# H-117: `package:flutter/material.dart` → `package:material_ui` göçü (+ go_router 18)

- **Durum:** ⏳ Sırada — H-115 kararına bağlı (2026-11-25)
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
