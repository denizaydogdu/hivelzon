import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/progress/story_progress.dart';
import '../../../shared/storage/storage_providers.dart';
import '../domain/episode_engine.dart';
import 'drift_progress_repository.dart';

/// Bölüm ilerlemesinin saklandığı yer.
///
/// Uygulamada Drift (SQLite, H-035): `DriftProgressRepository`. Eski
/// `shared_preferences` kayıtları ilk açılışta bir kez taşınır
/// (`LegacyPrefsImport`). Testler bellek içi uygulamayı kullanır.
abstract interface class ProgressRepository {
  Future<EngineSnapshot?> loadCheckpoint(String contentId);

  /// Kontrol noktası: bölüm `IN_PROGRESS` olur (bitmişse `COMPLETED` kalır),
  /// `startedAt` ilk kez yazılır.
  Future<void> saveCheckpoint(String contentId, EngineSnapshot snapshot);

  Future<void> clearCheckpoint(String contentId);

  /// Bitmiş bir bölümün kalıcı bayrakları (sonraki bölümler `externalFlags` ile okur).
  Future<Map<String, String>> loadEpisodeFlags(String episodeId);

  Future<void> saveEpisodeFlags(String episodeId, Map<String, String> flags);

  /// Bölüm sonu: `COMPLETED` + `completedAt`; kapı ölçütleri öncekilerle
  /// birleştirilir (tekrar oynamak hiçbir ölçütü geri almaz).
  Future<void> markCompleted(
    String contentId, {
    required Map<GateItem, Set<String>> gate,
  });

  /// Bütün bölümlerin ilerlemesi (kaydı olmayan bölüm listede yoktur).
  Future<Map<String, StoryProgress>> loadAll();

  /// Tek bir kapı ölçütünü ekler (H-055: bölüm sonunda hedef ifadeyi
  /// söylemek `targetPhrase`'i karşılar). Var olan kaydı değiştirmez; bölüm
  /// durumuna ve bitiş anına dokunmaz. Tekrar çağrı bir şey değiştirmez.
  Future<void> addGateItem(String contentId, GateItem item, String nodeId);
}

/// Bellek içi ilerleme kaydı (Drift'siz testler ve [InMemoryProgressRepository]).
class _ProgressRow {
  StoryStatus status = StoryStatus.notStarted;
  DateTime? startedAt;
  DateTime? completedAt;
  final Map<GateItem, Set<String>> gate = {};
}

/// Testler için bellek içi uygulama.
class InMemoryProgressRepository implements ProgressRepository {
  final Map<String, EngineSnapshot> checkpoints = {};
  final Map<String, Map<String, String>> episodeFlags = {};

  final Map<String, _ProgressRow> _rows = {};

  /// Sabit saat (testler); yoksa gerçek UTC saat.
  DateTime Function() clock = () => DateTime.now().toUtc();

  @override
  Future<EngineSnapshot?> loadCheckpoint(String contentId) async =>
      checkpoints[contentId];

  @override
  Future<void> saveCheckpoint(String contentId, EngineSnapshot snapshot) async {
    checkpoints[contentId] = snapshot;
    final r = _rows.putIfAbsent(contentId, _ProgressRow.new);
    r.startedAt ??= clock();
    if (r.status != StoryStatus.completed) r.status = StoryStatus.inProgress;
  }

  @override
  Future<void> markCompleted(
    String contentId, {
    required Map<GateItem, Set<String>> gate,
  }) async {
    final r = _rows.putIfAbsent(contentId, _ProgressRow.new);
    r.startedAt ??= clock();
    r.status = StoryStatus.completed;
    r.completedAt = clock();
    for (final e in gate.entries) {
      if (e.value.isEmpty) continue;
      r.gate.putIfAbsent(e.key, () => {}).addAll(e.value);
    }
  }

  @override
  Future<Map<String, StoryProgress>> loadAll() async => {
    for (final id in {..._rows.keys, ...checkpoints.keys})
      id: StoryProgress(
        contentId: id,
        status:
            _rows[id]?.status ??
            (checkpoints.containsKey(id)
                ? StoryStatus.inProgress
                : StoryStatus.notStarted),
        lastCheckpointNodeId: checkpoints[id]?.checkpointNodeId,
        startedAt: _rows[id]?.startedAt,
        completedAt: _rows[id]?.completedAt,
        gateItems: {...?_rows[id]?.gate.keys},
      ),
  };

  @override
  Future<void> addGateItem(
    String contentId,
    GateItem item,
    String nodeId,
  ) async {
    _rows
        .putIfAbsent(contentId, _ProgressRow.new)
        .gate
        .putIfAbsent(item, () => {})
        .add(nodeId);
  }

  @override
  Future<void> clearCheckpoint(String contentId) async =>
      checkpoints.remove(contentId);

  @override
  Future<Map<String, String>> loadEpisodeFlags(String episodeId) async =>
      episodeFlags[episodeId] ?? const {};

  @override
  Future<void> saveEpisodeFlags(
    String episodeId,
    Map<String, String> flags,
  ) async => episodeFlags[episodeId] = Map.of(flags);
}

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => DriftProgressRepository(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);
