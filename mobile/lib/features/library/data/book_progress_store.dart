import 'package:drift/drift.dart';

import '../../../shared/storage/app_database.dart';
import '../domain/book_progress.dart';

/// Kitap ilerlemesi (Drift `user_book_progress`, H-067) ve okuyucu ayarları
/// (`app_meta`; yalnız cihazda, eşitlenmez).
///
/// Hesap açıksa her yazma eşitleme kuyruğuna girer (tetikleyiciler,
/// `sync_schema.dart`). Durum hiçbir yazmada geri gitmez: biten kitap yeniden
/// okunursa yalnız kalınan yer değişir ("bitti kazanır").
class BookProgressStore {
  BookProgressStore(this._db, {Future<void>? ready, DateTime Function()? clock})
    : _ready = ready ?? Future<void>.value(),
      _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  static const textSizeKey = 'reader.textSize';
  static const wordHighlightKey = 'reader.wordHighlight';

  DateTime now() => _clock().toUtc();

  Future<Map<String, BookProgress>> all() async {
    await _ready;
    final rows = await _db.select(_db.userBookProgress).get();
    return {for (final r in rows) r.bookId: _toModel(r)};
  }

  Future<BookProgress?> get(String bookId) async {
    await _ready;
    final r = await (_db.select(
      _db.userBookProgress,
    )..where((t) => t.bookId.equals(bookId))).getSingleOrNull();
    return r == null ? null : _toModel(r);
  }

  /// Kalınan yeri yazar. Başlamamış kitap "okunuyor" olur; biten kitap
  /// biten kalır. Aynı yer ikinci kez yazılmaz (eşitleme kuyruğu boşuna
  /// dolmasın). Yazıldıysa true.
  Future<bool> savePosition(
    String bookId, {
    required String chapterId,
    required int pageNumber,
    required int sentenceIndex,
    double? positionSec,
  }) async {
    await _ready;
    final at = now();
    return _db.transaction(() async {
      final old = await get(bookId);
      if (old != null &&
          old.status != BookStatus.notStarted &&
          old.chapterId == chapterId &&
          old.pageNumber == pageNumber &&
          old.sentenceIndex == sentenceIndex) {
        return false;
      }
      final status = old?.isCompleted ?? false
          ? BookStatus.completed
          : BookStatus.inProgress;
      await _db
          .into(_db.userBookProgress)
          .insertOnConflictUpdate(
            UserBookProgressCompanion.insert(
              bookId: bookId,
              status: Value(status.code),
              chapterId: Value(chapterId),
              pageNumber: Value(pageNumber),
              sentenceIndex: Value(sentenceIndex),
              positionSec: Value(positionSec),
              startedAt: Value(old?.startedAt ?? at),
              completedAt: Value(old?.completedAt),
              updatedAt: at,
            ),
          );
      return true;
    });
  }

  /// Kitap bitti (idempotent: ilk bitiş zamanı kalır).
  Future<void> markCompleted(String bookId) async {
    await _ready;
    final at = now();
    await _db.transaction(() async {
      final old = await get(bookId);
      if (old?.isCompleted ?? false) return;
      await _db
          .into(_db.userBookProgress)
          .insertOnConflictUpdate(
            UserBookProgressCompanion.insert(
              bookId: bookId,
              status: Value(BookStatus.completed.code),
              chapterId: Value(old?.chapterId),
              pageNumber: Value(old?.pageNumber),
              sentenceIndex: Value(old?.sentenceIndex),
              positionSec: Value(old?.positionSec),
              startedAt: Value(old?.startedAt ?? at),
              completedAt: Value(at),
              updatedAt: at,
            ),
          );
    });
  }

  // ------------------------------------------------------------ ayarlar

  Future<String?> _meta(String key) async => (await (_db.select(
    _db.appMeta,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _setMeta(String key, String value) => _db
      .into(_db.appMeta)
      .insertOnConflictUpdate(AppMetaCompanion.insert(key: key, value: value));

  /// Okuma yazı boyutu: 0 küçük, 1 orta (varsayılan), 2 büyük.
  Future<int> textSize() async {
    await _ready;
    return (int.tryParse(await _meta(textSizeKey) ?? '') ?? 1).clamp(0, 2);
  }

  Future<void> setTextSize(int step) async {
    await _ready;
    await _setMeta(textSizeKey, '${step.clamp(0, 2)}');
  }

  /// Kelime vurgusu (varsayılan kapalı: yalnız cümle vurgulanır).
  Future<bool> wordHighlight() async {
    await _ready;
    return await _meta(wordHighlightKey) == '1';
  }

  Future<void> setWordHighlight(bool on) async {
    await _ready;
    await _setMeta(wordHighlightKey, on ? '1' : '0');
  }

  static BookProgress _toModel(UserBookProgressData r) => BookProgress(
    bookId: r.bookId,
    status: BookStatus.parse(r.status),
    chapterId: r.chapterId,
    pageNumber: r.pageNumber,
    sentenceIndex: r.sentenceIndex,
    positionSec: r.positionSec,
    startedAt: r.startedAt?.toUtc(),
    completedAt: r.completedAt?.toUtc(),
    updatedAt: r.updatedAt.toUtc(),
  );
}
