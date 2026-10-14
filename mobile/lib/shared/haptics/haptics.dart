import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_database.dart';
import '../storage/storage_providers.dart';

/// "Titreşim" ayarı (H-064): Profil > Öğrenme'deki aç/kapa anahtarı.
/// Varsayılan açık; yalnızca bu cihazda (`app_meta`), sunucuya gitmez.
class HapticsStore {
  HapticsStore(this._db, {Future<void>? ready})
    : _ready = ready ?? Future<void>.value();

  final AppDatabase _db;
  final Future<void> _ready;

  static const enabledKey = 'haptics.enabled';

  Future<bool> enabled() async {
    await _ready;
    final row = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(enabledKey))).getSingleOrNull();
    return row?.value != '0';
  }

  Future<void> setEnabled(bool on) async {
    await _ready;
    await _db
        .into(_db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: enabledKey, value: on ? '1' : '0'),
        );
  }
}

final hapticsStoreProvider = Provider<HapticsStore>(
  (ref) => HapticsStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// Ayarın güncel değeri (Profil'deki anahtar bunu izler).
final hapticsEnabledProvider = FutureProvider<bool>(
  (ref) => ref.watch(hapticsStoreProvider).enabled(),
);

/// Uygulamadaki **bütün** dokunsal geri bildirimin tek kapısı (H-064).
/// `HapticFeedback` doğrudan çağrılmaz (bkz. `haptics_test.dart`); her çağrı
/// "Titreşim" ayarına bakar. K-32: yalnızca sakin onay; yanlış cevapta,
/// uyarıda ya da sürekli titreşim yok.
class Haptics {
  Haptics(this._store);

  final HapticsStore _store;

  /// Doğru cevap ya da bulunan nesne için tek, hafif onay.
  Future<void> success() async {
    try {
      if (!await _store.enabled()) return;
      await HapticFeedback.lightImpact();
    } on Object {
      // Titreşim yalnızca süs; ayar okunamazsa ya da cihaz desteklemezse sessiz geçilir.
    }
  }
}

final hapticsProvider = Provider<Haptics>(
  (ref) => Haptics(ref.watch(hapticsStoreProvider)),
);
