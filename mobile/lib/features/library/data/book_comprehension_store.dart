import 'package:drift/drift.dart';

import '../../../shared/storage/app_database.dart';
import '../domain/book_comprehension.dart';

/// Kitap sonu anlama sonucu (Drift `user_book_comprehension`, H-091).
///
/// Kitap ilerlemesinden ayrıdır. Yalnızca sayılar ve öz değerlendirme
/// yazılır; kullanıcının yeniden anlatma metni hiçbir zaman buraya gelmez.
/// Atlanan anlama yazılmaz. Hesap açıksa yazma eşitleme kuyruğuna girer
/// (tetikleyiciler, `sync_schema.dart`); son yazan kazanır.
class BookComprehensionStore {
  BookComprehensionStore(
    this._db, {
    Future<void>? ready,
    DateTime Function()? clock,
  }) : _ready = ready ?? Future<void>.value(),
       _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  Future<ComprehensionResult?> get(String bookId) async {
    await _ready;
    final r = await (_db.select(
      _db.userBookComprehension,
    )..where((t) => t.bookId.equals(bookId))).getSingleOrNull();
    return r == null ? null : _toModel(r);
  }

  /// Bitirilen anlamayı yazar (aynı kitap yeniden yapılırsa son sonuç kalır).
  Future<void> save({
    required String bookId,
    required int contentVersion,
    required int answered,
    required int firstTryCorrect,
    required bool retellDone,
    RetellSelfCheck? selfCheck,
  }) async {
    await _ready;
    final at = _clock().toUtc();
    await _db
        .into(_db.userBookComprehension)
        .insertOnConflictUpdate(
          UserBookComprehensionCompanion.insert(
            bookId: bookId,
            contentVersion: Value(contentVersion),
            answered: Value(answered.clamp(0, 2)),
            firstTryCorrect: Value(firstTryCorrect.clamp(0, 2)),
            retellDone: Value(retellDone),
            selfCheck: Value(selfCheck?.code),
            completedAt: at,
            updatedAt: at,
          ),
        );
  }

  static ComprehensionResult _toModel(BookComprehensionRow r) =>
      ComprehensionResult(
        bookId: r.bookId,
        contentVersion: r.contentVersion,
        answered: r.answered,
        firstTryCorrect: r.firstTryCorrect,
        retellDone: r.retellDone,
        selfCheck: RetellSelfCheck.parse(r.selfCheck),
        completedAt: r.completedAt.toUtc(),
      );
}
