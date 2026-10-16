import 'package:drift/drift.dart';

import '../../../shared/storage/app_database.dart';

/// Bitirilen Konuş görevleri (Drift `user_talk_progress`, H-090).
///
/// Yalnızca görev kimliği ve zamanlar yazılır. Kullanıcının yazdığı mesaj,
/// söylediğinin yazısı ve ses hiçbir zaman buraya (ya da başka bir yere)
/// gelmez. Hesap açıksa yazma eşitleme kuyruğuna girer (tetikleyiciler,
/// `sync_schema.dart`); son yazan kazanır.
class TalkProgressStore {
  TalkProgressStore(this._db, {Future<void>? ready, DateTime Function()? clock})
    : _ready = ready ?? Future<void>.value(),
      _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  DateTime now() => _clock().toUtc();

  /// Görev → ilk bitirildiği an (UTC).
  Future<Map<String, DateTime>> doneAt() async {
    await _ready;
    final rows = await _db.select(_db.userTalkProgress).get();
    return {for (final r in rows) r.taskId: r.completedAt.toUtc()};
  }

  /// [since]'ten sonra bir görev bitirildi mi (Ana Sayfa planı: "bugün").
  Future<bool> doneSince(DateTime since) async {
    await _ready;
    final row =
        await (_db.select(_db.userTalkProgress)
              ..where((t) => t.lastDoneAt.isBiggerOrEqualValue(since.toUtc()))
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  /// Görevi bitti olarak yazar. İlk bitiş anı korunur; yeniden yapılırsa
  /// yalnızca son an ilerler (idempotent: tekrar çağrı satır çoğaltmaz).
  Future<void> markDone(String taskId) async {
    await _ready;
    final at = now();
    await _db
        .into(_db.userTalkProgress)
        .insert(
          UserTalkProgressCompanion.insert(
            taskId: taskId,
            completedAt: at,
            lastDoneAt: at,
            updatedAt: at,
          ),
          onConflict: DoUpdate(
            (_) => UserTalkProgressCompanion(
              lastDoneAt: Value(at),
              updatedAt: Value(at),
            ),
          ),
        );
  }
}
