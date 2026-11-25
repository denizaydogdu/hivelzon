# H-111: drift / sqlite3 3.x yükseltmesi (`sqlite3_flutter_libs` ömrünü tamamladı)

- **Durum:** ✅ Bitti (2026-11-25): drift 2.35.4 / sqlite3 3.9.2, `sqlite3_flutter_libs` kaldırıldı; commit `1d26fca` (H-115 ile), CI `45685003221` yeşil; uyumluluk testi `21953d6` değişmeden geçti; simülatörde mevcut kurulumun üzerine yükseltmede 14 tablonun verisi korundu (H-115 kaydı).
- **Tür:** Bağımlılık bakımı (mobil)
- **Öncelik:** Orta (bugün çalışıyor; H-044 mağaza yüklemesinden önce çözülmeli)
- **Bağımlılık:** Flutter SDK yükseltmesi (yeni iş) · H-106 dersi (native assets)

## Sorun
`flutter pub outdated`: `sqlite3_flutter_libs` sonraki sürümü `0.6.0+eol`; pub.dev açıklaması "Not used anymore,
update to version 3.x of package:sqlite3 instead". drift 2.32+ `sqlite3 ^3.x` ister; sqlite3 3.x SQLite'ı Dart
hooks (native assets) ile, GitHub sürümlerinden sha256 doğrulamalı indirerek pakete koyar. Mevcut: drift 2.31.0,
sqlite3 2.9.4, `sqlite3_flutter_libs` 0.5.42 (iOS'ta CocoaPods SQLite 3.52.0).

## Engel (2026-11-25, yerelde doğrulandı)
`flutter pub add drift:^2.35.4 dev:drift_dev:^2.35.0 --dry-run` → çözülemedi: Flutter SDK `meta 1.17.0`'a
(ve `flutter_test` `test_api 0.7.7`'ye) sabit; drift_dev ≥ 2.32 analyzer ≥ 10 ister, o da `meta ^1.18.0`.
Son çözülebilen drift_dev 2.31 → drift < 2.32 → sqlite3 2.x. Yani drift yükseltmesi Flutter yükseltmesi ister
(alt ajan çıkarımı: 3.44 → drift 2.34, 3.47+ → 2.35; güncel kararlı 3.50.1; denenmedi).

## Seçenekler (karar kullanıcıda)
1. **Flutter'ı yerelde ve CI'da yükselt** (önerilen, ayrı iş): bütün eklentiler, golden'lar, iOS/Android derlemeleri yeniden doğrulanır.
2. drift kod üretimini Flutter'sız ayrı bir Dart paketine taşı (yapısal değişiklik).
3. Bekle: 0.5.42 bugün çalışıyor; H-044'ten önce 1 ya da 2 yapılır.
4. `dependency_overrides` ile zorlamak — önerilmez (test koşucusunun güvencesi bozulur).

## Yapılan (bağımlılık değişmeden)
- Uyumluluk testi: `mobile/test/shared/storage/legacy_file_compat_test.dart` + `mobile/test/fixtures/legacy_v11.sqlite.gz`
  (bugünkü kütüphaneyle üretilmiş şema 11 dosyası; `sync_state`/`sync_outbox`, `app_meta`, `user_story_progress`,
  `notebook_items`, `review_cards`, `review_logs`, `user_book_progress`). Denetim: `user_version` 11, `integrity_check`
  ok, `foreign_key_check` boş, satırlar drift API'siyle aynı okunuyor, eşitleme tetikleyicisi çalışıyor. Üretici test
  `HV_WRITE_LEGACY_DB=1` ile açılır. `flutter test test/shared/storage/` 27 geçti, 1 atlandı (üretici).
- Lisanslar sayfası paketleri kendiliğinden listeliyor; elle değişiklik gerekmez.

## Yükseltme günü kontrol listesi
`flutter clean && flutter pub get` (yarım temizlik yok, H-106) → `dart run build_runner build --force-jit` → tam test →
`flutter build ios --simulator --debug` ve `flutter build apk --debug`, pakette sqlite3 kitaplığı ve `objective_c.framework`
var mı → `ios/Podfile.lock` ve `GeneratedPluginRegistrant.m` değişir → simülatör denemesi (izinle).

## Geri alma
Test dosyalarını sil. Yükseltme sonrası: `git checkout mobile/pubspec.yaml mobile/pubspec.lock mobile/lib/shared/storage/app_database.g.dart mobile/ios/Podfile.lock mobile/ios/Runner/GeneratedPluginRegistrant.m && cd mobile && flutter clean && flutter pub get`.
