import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sezon jeneriğinin (tam sürüm) izlenip izlenmediği (H-050).
///
/// Tam jenerik sezonun ilk açılışında bir kez kendiliğinden oynar; sonra
/// yalnızca "Jeneriği izle" ile açılır. Bilgi cihazda tutulur.
abstract interface class SeasonIntroRepository {
  Future<bool> seen(int season);

  Future<void> markSeen(int season);

  /// Yalnızca doğrulama modu için: bilgiyi siler.
  Future<void> forget(int season);
}

class SharedPrefsSeasonIntroRepository implements SeasonIntroRepository {
  SharedPrefsSeasonIntroRepository({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;

  static String _key(int season) => 'story.seasonIntroSeen.$season';

  @override
  Future<bool> seen(int season) async =>
      await _prefs.getBool(_key(season)) ?? false;

  @override
  Future<void> markSeen(int season) => _prefs.setBool(_key(season), true);

  @override
  Future<void> forget(int season) => _prefs.remove(_key(season));
}

/// Testler için bellek içi uygulama.
class InMemorySeasonIntroRepository implements SeasonIntroRepository {
  final Set<int> seenSeasons = {};

  @override
  Future<bool> seen(int season) async => seenSeasons.contains(season);

  @override
  Future<void> markSeen(int season) async => seenSeasons.add(season);

  @override
  Future<void> forget(int season) async => seenSeasons.remove(season);
}

final seasonIntroRepositoryProvider = Provider<SeasonIntroRepository>(
  (ref) => SharedPrefsSeasonIntroRepository(),
);
