import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/episode_engine.dart';

/// Bölüm ilerlemesinin saklandığı yer.
///
/// Şimdilik `shared_preferences`; H-035'te Drift (SQLite) uygulaması bu
/// arayüzün yerine geçer.
abstract interface class ProgressRepository {
  Future<EngineSnapshot?> loadCheckpoint(String contentId);

  Future<void> saveCheckpoint(String contentId, EngineSnapshot snapshot);

  Future<void> clearCheckpoint(String contentId);

  /// Bitmiş bir bölümün kalıcı bayrakları (sonraki bölümler `externalFlags` ile okur).
  Future<Map<String, String>> loadEpisodeFlags(String episodeId);

  Future<void> saveEpisodeFlags(String episodeId, Map<String, String> flags);
}

class SharedPrefsProgressRepository implements ProgressRepository {
  SharedPrefsProgressRepository({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;

  static String _cpKey(String id) => 'player.checkpoint.$id';
  static String _flagsKey(String id) => 'player.flags.$id';

  @override
  Future<EngineSnapshot?> loadCheckpoint(String contentId) async {
    final raw = await _prefs.getString(_cpKey(contentId));
    if (raw == null) return null;
    try {
      return EngineSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      // Bozuk kayıt: baştan başlanır, kayıt silinir.
      await _prefs.remove(_cpKey(contentId));
      return null;
    }
  }

  @override
  Future<void> saveCheckpoint(String contentId, EngineSnapshot snapshot) =>
      _prefs.setString(_cpKey(contentId), jsonEncode(snapshot.toJson()));

  @override
  Future<void> clearCheckpoint(String contentId) =>
      _prefs.remove(_cpKey(contentId));

  @override
  Future<Map<String, String>> loadEpisodeFlags(String episodeId) async {
    final raw = await _prefs.getString(_flagsKey(episodeId));
    if (raw == null) return const {};
    try {
      return Map<String, String>.from(jsonDecode(raw) as Map);
    } on Object {
      return const {};
    }
  }

  @override
  Future<void> saveEpisodeFlags(String episodeId, Map<String, String> flags) =>
      _prefs.setString(_flagsKey(episodeId), jsonEncode(flags));
}

/// Testler için bellek içi uygulama.
class InMemoryProgressRepository implements ProgressRepository {
  final Map<String, EngineSnapshot> checkpoints = {};
  final Map<String, Map<String, String>> episodeFlags = {};

  @override
  Future<EngineSnapshot?> loadCheckpoint(String contentId) async =>
      checkpoints[contentId];

  @override
  Future<void> saveCheckpoint(
    String contentId,
    EngineSnapshot snapshot,
  ) async => checkpoints[contentId] = snapshot;

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
  (ref) => SharedPrefsProgressRepository(),
);
