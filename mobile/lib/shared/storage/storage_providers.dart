import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  try {
    await LegacyPrefsImport(
      ref.watch(appDatabaseProvider),
      SharedPrefsLegacySource(),
    ).run();
  } on Object catch (e) {
    debugPrint('[H035] eski kayıtlar taşınamadı: $e');
  }
});
