import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/storage/app_database.dart';
import '../../../shared/storage/storage_providers.dart';

/// Haritada açılmış bölümlerin "görüldü" işareti (H-060).
///
/// Yeni açılan bölüm haritada ilk kez görününce bir kez "ışık yanar, yol
/// çizilir"; sonra hiç tekrarlanmaz. İşaret cihazda tutulur (`app_meta`,
/// anahtar `story.unlockSeen.<contentId>`, değer: ilk görülme anı, UTC);
/// eşitlenmez, sunucuya gitmez.
abstract interface class UnlockSeenRepository {
  /// [contentIds] içinden daha önce görülmemiş olanları döndürür ve hepsini
  /// görüldü olarak işaretler. İdempotent: aynı çağrı ikinci kez boş döner;
  /// var olan işaretin tarihi değişmez.
  Future<Set<String>> claimUnseen(Iterable<String> contentIds);
}

class DriftUnlockSeenRepository implements UnlockSeenRepository {
  DriftUnlockSeenRepository(
    this._db, {
    Future<void>? ready,
    DateTime Function()? clock,
  }) : _ready = ready ?? Future<void>.value(),
       _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  static const keyPrefix = 'story.unlockSeen.';

  static String keyFor(String contentId) => '$keyPrefix$contentId';

  @override
  Future<Set<String>> claimUnseen(Iterable<String> contentIds) async {
    await _ready;
    final ids = contentIds.toSet();
    if (ids.isEmpty) return const {};
    return _db.transaction(() async {
      final keys = [for (final id in ids) keyFor(id)];
      final rows = await (_db.select(
        _db.appMeta,
      )..where((t) => t.key.isIn(keys))).get();
      final seen = {for (final r in rows) r.key};
      final fresh = {
        for (final id in ids)
          if (!seen.contains(keyFor(id))) id,
      };
      if (fresh.isEmpty) return fresh;
      final now = _clock().toIso8601String();
      await _db.batch(
        (b) => b.insertAll(_db.appMeta, [
          for (final id in fresh)
            AppMetaCompanion.insert(key: keyFor(id), value: now),
        ], mode: InsertMode.insertOrIgnore),
      );
      return fresh;
    });
  }
}

/// Testler için bellek içi uygulama.
class InMemoryUnlockSeenRepository implements UnlockSeenRepository {
  final Set<String> seen = {};

  @override
  Future<Set<String>> claimUnseen(Iterable<String> contentIds) async {
    final fresh = {
      for (final id in contentIds)
        if (!seen.contains(id)) id,
    };
    seen.addAll(fresh);
    return fresh;
  }
}

final unlockSeenRepositoryProvider = Provider<UnlockSeenRepository>(
  (ref) => DriftUnlockSeenRepository(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);
