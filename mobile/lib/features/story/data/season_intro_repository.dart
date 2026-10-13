import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/storage/app_database.dart';
import '../../../shared/storage/storage_providers.dart';

/// Sezon jeneriğinin (tam sürüm) izlenip izlenmediği (H-050).
///
/// Tam jenerik sezonun ilk açılışında bir kez kendiliğinden oynar; sonra
/// yalnızca "Jeneriği izle" ile açılır. Bilgi cihazda tutulur
/// (`season_state`, H-035; eski `shared_preferences` kaydı bir kez taşınır).
abstract interface class SeasonIntroRepository {
  Future<bool> seen(int season);

  Future<void> markSeen(int season);

  /// Yalnızca doğrulama modu için: bilgiyi siler.
  Future<void> forget(int season);
}

class DriftSeasonIntroRepository implements SeasonIntroRepository {
  DriftSeasonIntroRepository(this._db, {Future<void>? ready})
    : _ready = ready ?? Future<void>.value();

  final AppDatabase _db;
  final Future<void> _ready;

  @override
  Future<bool> seen(int season) async {
    await _ready;
    final row = await (_db.select(
      _db.seasonState,
    )..where((t) => t.seasonId.equals(season))).getSingleOrNull();
    return row?.introSeen ?? false;
  }

  @override
  Future<void> markSeen(int season) async {
    await _ready;
    final now = DateTime.now().toUtc();
    await _db
        .into(_db.seasonState)
        .insertOnConflictUpdate(
          SeasonStateCompanion.insert(
            seasonId: Value(season),
            introSeen: const Value(true),
            introSeenAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<void> forget(int season) async {
    await _ready;
    await (_db.delete(
      _db.seasonState,
    )..where((t) => t.seasonId.equals(season))).go();
  }
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
  (ref) => DriftSeasonIntroRepository(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);
