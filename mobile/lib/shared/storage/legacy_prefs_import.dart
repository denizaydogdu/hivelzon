import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../progress/story_progress.dart';
import 'app_database.dart';

/// Eski anahtar–değer deposu (H-031/H-050 `shared_preferences`); testlerde sahte.
abstract interface class LegacyKeyValueSource {
  Future<Set<String>> keys();

  Future<String?> getString(String key);

  Future<bool?> getBool(String key);
}

class SharedPrefsLegacySource implements LegacyKeyValueSource {
  SharedPrefsLegacySource({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;

  @override
  Future<Set<String>> keys() => _prefs.getKeys();

  @override
  Future<String?> getString(String key) => _prefs.getString(key);

  @override
  Future<bool?> getBool(String key) => _prefs.getBool(key);
}

/// `shared_preferences` → Drift, bir kez (H-035).
///
/// Taşınanlar: kontrol noktası (`player.checkpoint.<id>`), biten bölümün
/// bayrakları (`player.flags.<id>`), sezon jeneriği (`story.seasonIntroSeen.<n>`).
///
/// İdempotent: `app_meta` işareti varsa hiçbir şey yapılmaz; işaret ve kayıtlar
/// aynı işlemde yazılır; veritabanında zaten olan satırların üzerine yazılmaz.
/// Eski anahtarlar silinmez (dal geri alınırsa eski sürüm veriyi yine bulur).
///
/// Eski sürüm kapı ölçütlerini kaydetmiyordu. Bayrağı kaydedilmiş (yani bitmiş)
/// bir bölüm `COMPLETED` sayılır ve kapısı `legacy` düğümüyle tamam kabul
/// edilir: kilit kalıcı olmamalı (K-29), oyuncu bölümü zaten bitirmişti.
class LegacyPrefsImport {
  LegacyPrefsImport(this._db, this._source, {DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc());

  static const markerKey = 'migration.sharedPrefs.v1';
  static const legacyNode = 'legacy';

  final AppDatabase _db;
  final LegacyKeyValueSource _source;
  final DateTime Function() _clock;

  /// Taşındıysa `true`; işaret zaten varsa `false`.
  Future<bool> run() async {
    final done = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(markerKey))).getSingleOrNull();
    if (done != null) return false;
    final keys = await _source.keys();
    final now = _clock().toUtc();
    final checkpoints = <String, String>{};
    final flags = <String, Map<String, String>>{};
    final seasons = <int>{};
    for (final k in keys) {
      if (k.startsWith('player.checkpoint.')) {
        final raw = await _source.getString(k);
        if (raw != null && _validCheckpoint(raw)) {
          checkpoints[k.substring('player.checkpoint.'.length)] = raw;
        }
      } else if (k.startsWith('player.flags.')) {
        final raw = await _source.getString(k);
        try {
          flags[k.substring('player.flags.'.length)] = Map<String, String>.from(
            jsonDecode(raw ?? '{}') as Map,
          );
        } on Object {
          // Bozuk bayrak kaydı atlanır.
        }
      } else if (k.startsWith('story.seasonIntroSeen.')) {
        final n = int.tryParse(k.substring('story.seasonIntroSeen.'.length));
        if (n != null && (await _source.getBool(k) ?? false)) seasons.add(n);
      }
    }
    await _db.transaction(() async {
      for (final e in flags.entries) {
        await _db
            .into(_db.userStoryProgress)
            .insert(
              UserStoryProgressCompanion.insert(
                contentId: e.key,
                status: Value(StoryStatus.completed.code),
                lastCheckpointNodeId: Value(
                  _checkpointNode(checkpoints[e.key]),
                ),
                checkpointSnapshot: Value(checkpoints[e.key]),
                startedAt: Value(now),
                completedAt: Value(now),
                updatedAt: now,
              ),
              mode: InsertMode.insertOrIgnore,
            );
        for (final f in e.value.entries) {
          await _db
              .into(_db.userStoryFlags)
              .insert(
                UserStoryFlagsCompanion.insert(
                  contentId: e.key,
                  flag: f.key,
                  value: f.value,
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
        for (final g in GateItem.values) {
          await _db
              .into(_db.gateProgress)
              .insert(
                GateProgressCompanion.insert(
                  contentId: e.key,
                  itemKind: g.code,
                  nodeId: legacyNode,
                  recordedAt: now,
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
      }
      for (final e in checkpoints.entries) {
        if (flags.containsKey(e.key)) continue;
        await _db
            .into(_db.userStoryProgress)
            .insert(
              UserStoryProgressCompanion.insert(
                contentId: e.key,
                status: Value(StoryStatus.inProgress.code),
                lastCheckpointNodeId: Value(_checkpointNode(e.value)),
                checkpointSnapshot: Value(e.value),
                startedAt: Value(now),
                updatedAt: now,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
      for (final n in seasons) {
        await _db
            .into(_db.seasonState)
            .insert(
              SeasonStateCompanion.insert(
                seasonId: Value(n),
                introSeen: const Value(true),
                introSeenAt: Value(now),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
      await _db
          .into(_db.appMeta)
          .insert(
            AppMetaCompanion.insert(
              key: markerKey,
              value:
                  'checkpoints=${checkpoints.length} flags=${flags.length} '
                  'seasons=${seasons.length} at=${now.toIso8601String()}',
            ),
            mode: InsertMode.insertOrIgnore,
          );
    });
    debugPrint(
      '[H035] shared_preferences → Drift: ${checkpoints.length} kontrol '
      'noktası, ${flags.length} biten bölüm, ${seasons.length} sezon',
    );
    return true;
  }

  static bool _validCheckpoint(String raw) => _checkpointNode(raw) != null;

  static String? _checkpointNode(String? raw) {
    if (raw == null) return null;
    try {
      final j = jsonDecode(raw);
      return j is Map ? j['checkpoint'] as String? : null;
    } on Object {
      return null;
    }
  }
}
