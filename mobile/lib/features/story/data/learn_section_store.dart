import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/storage/app_database.dart';
import '../../../shared/storage/storage_providers.dart';
import '../domain/learn_section.dart';

/// Öğren sekmesinde son açılan bölüm (H-103). Cihazda tutulur (`app_meta`,
/// anahtar `learn.section`, değer [LearnSection.code]); eşitlenmez, sunucuya
/// gitmez.
abstract interface class LearnSectionStore {
  /// Kayıt yoksa ya da tanınmıyorsa `null`.
  Future<LearnSection?> load();

  /// Aynı değeri yeniden yazmak zararsızdır (idempotent).
  Future<void> save(LearnSection section);
}

class DriftLearnSectionStore implements LearnSectionStore {
  DriftLearnSectionStore(this._db, {Future<void>? ready})
    : _ready = ready ?? Future<void>.value();

  final AppDatabase _db;
  final Future<void> _ready;

  static const key = 'learn.section';

  @override
  Future<LearnSection?> load() async {
    await _ready;
    final row = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return LearnSection.parse(row?.value);
  }

  @override
  Future<void> save(LearnSection section) async {
    await _ready;
    await _db
        .into(_db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: key, value: section.code),
        );
  }
}

/// Testler için bellek içi uygulama.
class InMemoryLearnSectionStore implements LearnSectionStore {
  InMemoryLearnSectionStore([this.saved]);

  LearnSection? saved;

  @override
  Future<LearnSection?> load() async => saved;

  @override
  Future<void> save(LearnSection section) async => saved = section;
}

final learnSectionStoreProvider = Provider<LearnSectionStore>(
  (ref) => DriftLearnSectionStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);
