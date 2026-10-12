import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/notebook/data/legacy_notebook_import.dart';
import 'app_database.dart';
import 'legacy_prefs_import.dart';

/// Uygulamanın tek yerel veritabanı. Testlerde `AppDatabase.memory()` ile değiştirilir.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

/// Eski `shared_preferences` kayıtlarının bir kerelik taşınması (H-035).
///
/// Depolar her işlemden önce bunu bekler. Hata uygulamayı durdurmaz: yeni
/// veritabanı boş başlar, eski anahtarlar yerinde kalır, sonraki açılışta
/// yeniden denenir (işaret yazılmadığı için).
final legacyImportProvider = Provider<Future<void>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  LegacyKeyValueSource? source;
  try {
    source = SharedPrefsLegacySource();
    await LegacyPrefsImport(db, source).run();
  } on Object catch (e) {
    debugPrint('[H035] eski kayıtlar taşınamadı: $e');
  }
  // Defter ve öğrenme olayları (H-036); ayrı işaretle, bağımsız denenir.
  try {
    await LegacyNotebookImport(db, source ?? SharedPrefsLegacySource()).run();
  } on Object catch (e) {
    debugPrint('[H036] eski defter taşınamadı: $e');
  }
});
