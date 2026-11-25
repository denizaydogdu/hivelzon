# H-115: Flutter 3.50.1'e geçiş (yalnız hiVelzon, FVM)

- **Durum:** ✅ Bitti (2026-11-25): commit `1d26fca`, CI `45685003221` yeşil (Flutter 3.50.1 `.fvmrc`'den; analyze temiz; Linux 1439 test + 92 golden atlandı). Kullanıcı onayları: iOS en düşük 15.0, ilerleme çubuğu ekran okuyucu metni, simülatör denemesi, commit. H-117 ile birlikte.
  (ayrı dala commit izin sisteminde reddedildi). `main`'e alınmadan önce analyze kararı gerekir (aşağıda).
- **Tür:** Altyapı (mobil SDK + CI)
- **Bağımlılık:** H-111 (drift/sqlite3 3.x bunu bekliyordu) · H-117 (`main`e almadan önce)
- **Kullanıcı kararı (2026-11-25):** yalnız hiVelzon yükseltilir; Homebrew Flutter 3.38.5 (piru, quikt_monorepo, scyborsa_mobile…) değişmez.

## Yapılan
- FVM 4.3.2 (brew) + Flutter **3.50.1** (Dart 3.14.0); `mobile/.fvmrc`, `.fvm/` git dışı. Komutlar `fvm flutter …`.
- drift 2.31.0 → **2.35.4**, drift_dev → 2.35.3, sqlite3 2.9.4 → **3.9.2** (SQLite **3.54.1**, hooks ile paketlenir),
  `sqlite3_flutter_libs` kaldırıldı. riverpod 3.5.0, analyzer 13.3 vb. küçük sürümler; go_router/video_player majör yok.
- Kod: `TickerMode.getNotifier/of` → `getValuesNotifier(...).value.enabled` / `valuesOf(...).enabled` (3 dosya);
  `ref.exists(p)` → `ref.read(p.exists)`; Hikâye ilerleme çubuğu: metin `semanticsLabel`'a taşındı (Flutter 3.47+ değer
  sayı olmalı) → ekran okuyucu "Sezon ilerlemesi, 12 bölümden 0'ı tamamlandı, %0" der (**kullanıcı onayı**).
- Testler: font yükleme `tester.runAsync`; `tab_refresh_test` riverpod 3.5 düzeltmesine göre; `release_files_guard_test`
  Xcode'un tırnaklı `INFOPLIST_FILE = "Runner/Info-Release.plist";` yazımını kabul eder (ayar yerinde, gerileme yok).
- Android (3.50 zorunlu): Gradle 9.5.0, AGP 9.3.1, KGP 2.4.20, `kotlin { compilerOptions }`; geçici
  `android.builtInKotlin=false`, `android.newDsl=false` (AGP 10'da kalkar).
- iOS: Swift Package Manager'a geçti (flutter_tts hariç, o CocoaPods); `Podfile.lock`'ta CocoaPods sqlite3 yok;
  **en düşük iOS 13.0 → 15.0** (Flutter 3.50 zorunlu; **kullanıcı onayı**).
- 33 golden yalnız köşe/kenar yumuşatma farkıyla (%0,01–0,91) yenilendi.
- CI: `flutter-version-file: mobile/.fvmrc`. README ve CLAUDE.md komutları `fvm` ile. `tools/device-build.sh` `fvm flutter`
  kullanır, fvm yoksa açık hata verir.

## Doğrulama (2026-11-25)
- `fvm flutter test`: **1529 geçti, 1 atlandı** (eski veritabanı fikstür üreticisi); eski şema-11 dosyası uyumluluk testi değişmeden geçti.
- `fvm flutter build ios --simulator --debug`: Runner.app'te `sqlite3.framework` (arm64+x86_64) ve `objective_c.framework`.
  `fvm flutter build apk --debug`: `lib/{arm64-v8a,armeabi-v7a,x86_64}/libsqlite3.so`. Simülatör açılmadı.
- `fvm flutter analyze`: **175 info** — 174 "`package:flutter/material.dart` kullanımdan kalkıyor, `package:material_ui`
  kullan" + 1 `GlobalMaterialLocalizations`. Başka bulgu yok. CI'da analyze info'da da kırmızı olur.

## Kararlar (2026-11-25, hepsi verildi)
1. **material → material_ui (175 info) → H-117 ile çözüldü (seçenek a):** (a) ayrı iş: go_router 18 + `dart fix` + golden kontrolü (önerilen; o zamana
   kadar bu iş `main`'e alınamaz); (b) geçici `deprecated_member_use: ignore` (bütün kullanım dışı uyarıları gizler);
   (c) CI'da `flutter analyze --no-fatal-infos`.
2. iOS en düşük sürüm 15.0 ve ilerleme çubuğu ekran okuyucu metni — **onaylandı**.
3. Simülatör denemesi — **yapıldı** (aşağıda): mevcut kurulumda veritabanı yeni SQLite ile açılıyor mu, eşitleme, hatırlatma, ses/video eklentileri SPM derlemesinde çalışıyor mu.

## Not
Bu depoda komutlar `fvm flutter …` / `fvm dart …` ile çalışır; global Homebrew Flutter 3.38.5 öteki projeler içindir.

## Geri alma
`git checkout -- mobile .github/workflows/ci.yml README.md CLAUDE.md tools/device-build.sh` →
`rm -rf mobile/.fvmrc mobile/.fvm mobile/ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/swiftpm mobile/ios/Runner.xcworkspace/xcshareddata/swiftpm`
→ `cd mobile && flutter clean && flutter pub get && cd ios && pod install`.

## Simülatör denemesi (2026-11-25, kullanıcı izniyle)
PIRU iPhone 17'deki 2026-11-20 kurulumunun (eski derleme, `sqlite3_flutter_libs`) üzerine Flutter 3.50.1 + drift 2.35.4 +
material_ui derlemesi kuruldu. Önce veritabanı yedeklendi ve satır sayıları alındı. Sonuç: uygulama açıldı (Ana Sayfa
2,4 sn), `[H042]`/`DOBJC`/hata satırı yok; veritabanı `user_version` 11, `integrity_check` ok, **14 tablonun satır sayıları
birebir aynı** (ör. `review_cards` 19, `notebook_items` 19, `gate_progress` 19); ekranda "10 ifadenin tekrar zamanı geldi"
ve "12 bölümden 4'ü bitti". Cihazda hesap yok → eşitleme devreye girmez (tetikleyiciler uyumluluk testinde doğrulanır).
Simülatör, backend, içerik sunucusu ve konteynerler kapatıldı; `fvm flutter clean && fvm flutter pub get`, hiVelzon
DerivedData silindi.
