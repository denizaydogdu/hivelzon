import 'package:drift/drift.dart';

import '../../../shared/storage/app_database.dart';
import '../domain/grammar_progress.dart';

/// Dilbilgisi dersi ilerlemesi (Drift `user_grammar_progress`, H-078).
///
/// Hesap açıksa her yazma eşitleme kuyruğuna girer (tetikleyiciler,
/// `sync_schema.dart`). Durum hiçbir yazmada geri gitmez: biten ders yeniden
/// açılırsa yalnız kalınan kart değişir ("bitti kazanır"). Aynı kart ikinci
/// kez yazılmaz (kuyruk boşuna dolmasın).
class GrammarProgressStore {
  GrammarProgressStore(
    this._db, {
    Future<void>? ready,
    DateTime Function()? clock,
  }) : _ready = ready ?? Future<void>.value(),
       _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  DateTime now() => _clock().toUtc();

  Future<Map<String, GrammarProgress>> all() async {
    await _ready;
    final rows = await _db.select(_db.userGrammarProgress).get();
    return {for (final r in rows) r.lessonId: _toModel(r)};
  }

  Future<GrammarProgress?> get(String lessonId) async {
    await _ready;
    final r = await (_db.select(
      _db.userGrammarProgress,
    )..where((t) => t.lessonId.equals(lessonId))).getSingleOrNull();
    return r == null ? null : _toModel(r);
  }

  /// Kart görüldü: başlamamış ders "görüldü" olur; biten ders biten kalır.
  /// Yazıldıysa true.
  Future<bool> markCard(String lessonId, String cardId) async {
    await _ready;
    final at = now();
    return _db.transaction(() async {
      final old = await get(lessonId);
      if (old != null &&
          old.status != GrammarStatus.notStarted &&
          old.lastCard == cardId) {
        return false;
      }
      await _db
          .into(_db.userGrammarProgress)
          .insertOnConflictUpdate(
            UserGrammarProgressCompanion.insert(
              lessonId: lessonId,
              status: Value(
                (old?.isCompleted ?? false)
                    ? GrammarStatus.completed.code
                    : GrammarStatus.inProgress.code,
              ),
              lastCard: Value(cardId),
              startedAt: Value(old?.startedAt ?? at),
              completedAt: Value(old?.completedAt),
              updatedAt: at,
            ),
          );
      return true;
    });
  }

  /// Ders bitti (idempotent: ilk bitiş zamanı kalır). Bittiyse ilk kez true.
  Future<bool> markCompleted(String lessonId, {String? lastCard}) async {
    await _ready;
    final at = now();
    return _db.transaction(() async {
      final old = await get(lessonId);
      if (old?.isCompleted ?? false) return false;
      await _db
          .into(_db.userGrammarProgress)
          .insertOnConflictUpdate(
            UserGrammarProgressCompanion.insert(
              lessonId: lessonId,
              status: Value(GrammarStatus.completed.code),
              lastCard: Value(lastCard ?? old?.lastCard),
              startedAt: Value(old?.startedAt ?? at),
              completedAt: Value(at),
              updatedAt: at,
            ),
          );
      return true;
    });
  }

  static GrammarProgress _toModel(UserGrammarProgressData r) => GrammarProgress(
    lessonId: r.lessonId,
    status: GrammarStatus.parse(r.status),
    lastCard: r.lastCard,
    startedAt: r.startedAt?.toUtc(),
    completedAt: r.completedAt?.toUtc(),
    updatedAt: r.updatedAt.toUtc(),
  );
}
