import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../shared/progress/story_progress.dart';
import '../../../shared/storage/app_database.dart';
import '../domain/episode_engine.dart';
import 'progress_repository.dart';

/// Drift (SQLite) ilerleme deposu (H-035).
///
/// - `user_story_progress`: durum, kontrol noktası, başlama/bitiş (UTC).
/// - `user_story_flags`: biten bölümün kalıcı bayrakları.
/// - `gate_progress`: karşılanan kapı ölçütleri (birleşerek büyür).
///
/// [ready] tamamlanmadan (eski kayıtların taşınması) hiçbir işlem yapılmaz.
class DriftProgressRepository implements ProgressRepository {
  DriftProgressRepository(
    this._db, {
    Future<void>? ready,
    DateTime Function()? clock,
  }) : _ready = ready ?? Future<void>.value(),
       _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  DateTime _now() => _clock().toUtc();

  Future<UserStoryProgressData?> _row(String id) => (_db.select(
    _db.userStoryProgress,
  )..where((t) => t.contentId.equals(id))).getSingleOrNull();

  @override
  Future<EngineSnapshot?> loadCheckpoint(String contentId) async {
    await _ready;
    final row = await _row(contentId);
    final raw = row?.checkpointSnapshot;
    if (raw == null) return null;
    try {
      return EngineSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      // Bozuk kayıt: baştan başlanır, kayıt silinir.
      await clearCheckpoint(contentId);
      return null;
    }
  }

  @override
  Future<void> saveCheckpoint(String contentId, EngineSnapshot snapshot) async {
    await _ready;
    final now = _now();
    await _db.transaction(() async {
      final row = await _row(contentId);
      final status = row?.status == StoryStatus.completed.code
          ? StoryStatus.completed
          : StoryStatus.inProgress;
      await _db
          .into(_db.userStoryProgress)
          .insertOnConflictUpdate(
            UserStoryProgressCompanion.insert(
              contentId: contentId,
              status: Value(status.code),
              lastCheckpointNodeId: Value(snapshot.checkpointNodeId),
              checkpointSnapshot: Value(jsonEncode(snapshot.toJson())),
              startedAt: Value(row?.startedAt ?? now),
              completedAt: Value(row?.completedAt),
              updatedAt: now,
            ),
          );
    });
  }

  @override
  Future<void> clearCheckpoint(String contentId) async {
    await _ready;
    await (_db.update(
      _db.userStoryProgress,
    )..where((t) => t.contentId.equals(contentId))).write(
      UserStoryProgressCompanion(
        lastCheckpointNodeId: const Value(null),
        checkpointSnapshot: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

  @override
  Future<Map<String, String>> loadEpisodeFlags(String episodeId) async {
    await _ready;
    final rows = await (_db.select(
      _db.userStoryFlags,
    )..where((t) => t.contentId.equals(episodeId))).get();
    return {for (final r in rows) r.flag: r.value};
  }

  @override
  Future<void> saveEpisodeFlags(
    String episodeId,
    Map<String, String> flags,
  ) async {
    await _ready;
    final now = _now();
    await _db.transaction(() async {
      // Yalnızca değişen bayraklar yazılır (eşitlemede gereksiz değişiklik
      // ve silme işareti oluşmasın, H-038).
      final old = {
        for (final r in await (_db.select(
          _db.userStoryFlags,
        )..where((t) => t.contentId.equals(episodeId))).get())
          r.flag: r.value,
      };
      final removed = old.keys.where((k) => !flags.containsKey(k)).toList();
      if (removed.isNotEmpty) {
        await (_db.delete(_db.userStoryFlags)..where(
              (t) => t.contentId.equals(episodeId) & t.flag.isIn(removed),
            ))
            .go();
      }
      await _db.batch(
        (b) => b.insertAllOnConflictUpdate(_db.userStoryFlags, [
          for (final e in flags.entries)
            if (old[e.key] != e.value)
              UserStoryFlagsCompanion.insert(
                contentId: episodeId,
                flag: e.key,
                value: e.value,
                updatedAt: Value(now),
              ),
        ]),
      );
    });
  }

  @override
  Future<void> markCompleted(
    String contentId, {
    required Map<GateItem, Set<String>> gate,
  }) async {
    await _ready;
    final now = _now();
    await _db.transaction(() async {
      final row = await _row(contentId);
      await _db
          .into(_db.userStoryProgress)
          .insertOnConflictUpdate(
            UserStoryProgressCompanion.insert(
              contentId: contentId,
              status: Value(StoryStatus.completed.code),
              lastCheckpointNodeId: Value(row?.lastCheckpointNodeId),
              checkpointSnapshot: Value(row?.checkpointSnapshot),
              startedAt: Value(row?.startedAt ?? now),
              completedAt: Value(now),
              updatedAt: now,
            ),
          );
      await _db.batch(
        (b) => b.insertAll(_db.gateProgress, [
          for (final e in gate.entries)
            for (final node in e.value)
              GateProgressCompanion.insert(
                contentId: contentId,
                itemKind: e.key.code,
                nodeId: node,
                recordedAt: now,
              ),
        ], mode: InsertMode.insertOrIgnore),
      );
    });
  }

  @override
  Future<void> addGateItem(
    String contentId,
    GateItem item,
    String nodeId,
  ) async {
    await _ready;
    await _db
        .into(_db.gateProgress)
        .insert(
          GateProgressCompanion.insert(
            contentId: contentId,
            itemKind: item.code,
            nodeId: nodeId,
            recordedAt: _now(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<Map<String, StoryProgress>> loadAll() async {
    await _ready;
    final rows = await _db.select(_db.userStoryProgress).get();
    final gates = await _db.select(_db.gateProgress).get();
    final items = <String, Set<GateItem>>{};
    for (final g in gates) {
      final kind = GateItem.fromCode(g.itemKind);
      if (kind != null) items.putIfAbsent(g.contentId, () => {}).add(kind);
    }
    return {
      for (final r in rows)
        r.contentId: StoryProgress(
          contentId: r.contentId,
          status: StoryStatus.fromCode(r.status),
          lastCheckpointNodeId: r.lastCheckpointNodeId,
          startedAt: r.startedAt?.toUtc(),
          completedAt: r.completedAt?.toUtc(),
          updatedAt: r.updatedAt.toUtc(),
          gateItems: items[r.contentId] ?? const {},
        ),
    };
  }
}
