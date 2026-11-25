# H-117: `package:flutter/material.dart` → `package:material_ui` göçü (+ go_router 18)

- **Durum:** ✅ Bitti (2026-11-25): commit `1d26fca`, CI `45685003221` yeşil.
- **Tür:** Mobil bağımlılık/kod göçü
- **Öncelik:** Orta (H-115'in `main`'e alınmasını engelliyor: CI `flutter analyze` info'da kırmızı)
- **Bağımlılık:** H-115 (Flutter 3.50.1)

## Sorun
Flutter 3.47+ `package:flutter/material.dart`'ı kullanımdan kaldırıyor: `fvm flutter analyze` 175 info
(174 import + `GlobalMaterialLocalizations`). `dart fix --apply` mekanik olarak çevirebilir, ama `material_ui` ayrı sınıflar
getirir; go_router 17.5 sayfaları hâlâ `flutter/material` ile kurar → karışırsa rotalarda/geçişlerde Theme sessizce
kaybolabilir. go_router 18 (majör) muhtemelen gerekir.

## Yapılacak
go_router 18'e geç (değişiklik günlüğü; rota/redirect testleri) → `dart fix --apply` → tema ve geçişlerin aynı kaldığını
golden'larla doğrula (fark yalnız kenar yumuşatma olmalı) → `flutter analyze` temiz → H-115 ile birlikte `main`'e.

## Geçici seçenekler (önerilmez)
`deprecated_member_use: ignore` (bütün kullanım dışı uyarıları gizler) ya da CI'da `--no-fatal-infos`.

## Yapılan
- go_router 17.5.0 → **18.1.4** (18.0.0: "Migrates to material_ui and cupertino_ui"; 17.5, material_ui uygulamasında
  `builder:` rotalarını geçişsiz WidgetsApp sayfası olarak kuruyor ve yanlış HeroController takıyordu).
- material_ui **1.11.1** doğrudan bağımlılık; 174 Dart dosyasında yalnız import (`dart fix --code=migrate_design_widgets`);
  yerelleştirme delegeleri material_ui'den (`flutter_localizations` doğrudan bağımlılığı kalktı).
- Yeni test `test/app/material_ui_router_test.dart` (Material geçişli rota, tema rengi, Türkçe "Geri"); 17.5'te kırmızı.
- `docs/ARAYUZ-METINLERI.md` madde 9 güncellendi.
- Doğrulama: `fvm flutter analyze` "No issues found!" (175 info → 0); `fvm flutter test` 1530 + 1 atlandı; golden'lar
  piksel piksel aynı; iOS/Android debug derlemeleri geçti; qa-code-reviewer engelleyici yok.
- Not: ileride `VideoProgressIndicator`, `ClosedCaption` ya da `ShaderEffect` eklenirse `MaterialUiCompatibilityBridge` gerekir.
