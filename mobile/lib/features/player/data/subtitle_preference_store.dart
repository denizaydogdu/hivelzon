import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/storage/app_database.dart';
import '../../../shared/storage/storage_providers.dart';
import '../application/player_session.dart';

/// Altyazı tercihi (K-03): açılışta (H-039) A1 için Türkçe satır önerilir;
/// oynatıcıdaki altyazı menüsü de aynı tercihi değiştirir. Yalnızca bu
/// cihazda (`app_meta`). Kayıt yoksa oynatıcı varsayılanı (yalnız İngilizce).
class SubtitlePreferenceStore {
  SubtitlePreferenceStore(this._db, {Future<void>? ready})
    : _ready = ready ?? Future<void>.value();

  final AppDatabase _db;
  final Future<void> _ready;

  static const key = 'settings.subtitleMode';

  static String encode(SubtitleMode m) => switch (m) {
    SubtitleMode.en => 'en',
    SubtitleMode.enTr => 'en_tr',
    SubtitleMode.off => 'off',
  };

  static SubtitleMode? decode(String? v) => switch (v) {
    'en' => SubtitleMode.en,
    'en_tr' => SubtitleMode.enTr,
    'off' => SubtitleMode.off,
    _ => null,
  };

  Future<SubtitleMode?> mode() async {
    await _ready;
    final row = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return decode(row?.value);
  }

  Future<void> setMode(SubtitleMode mode) async {
    await _ready;
    await _db
        .into(_db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: key, value: encode(mode)),
        );
  }
}

final subtitlePreferenceStoreProvider = Provider<SubtitlePreferenceStore>(
  (ref) => SubtitlePreferenceStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// Okunamazsa `null` (oynatıcı varsayılanıyla açılır).
Future<SubtitleMode?> readSubtitlePreference(SubtitlePreferenceStore s) async {
  try {
    return await s.mode();
  } on Object catch (e) {
    debugPrint('[H039] altyazı tercihi okunamadı: $e');
    return null;
  }
}
