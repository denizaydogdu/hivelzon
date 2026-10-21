# H-057: Tasarım sistemi v2 (belirteçler, bileşen kitaplığı, hareket, yazı tipleri)

- **Durum:** Bitti
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T0 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-053, H-054

## Kapsam
- **Belirteçler** (`mobile/lib/app/theme.dart` → `mobile/lib/app/design/`): yazı ölçeği (başlık yazı tipi + Inter; 400/500/700), boşluk 4/8/12/16/24/32/48, köşeler 8/12/20/tam, 3 gölge seviyesi, anlamsal renkler (başarı/uyarı/bilgi/tehlike), oynatıcı perde renkleri, hareket süreleri ve eğrileri, ikon boyutları.
- **Tema bileşenleri:** AppBar, input, sheet, chip, segmented button, list tile, düğme varyantları (birincil / ikincil / sessiz / tehlike / "Bilmiyorum").
- **Ortak bileşenler** (`mobile/lib/shared/ui/`): `AppSheet`, `InfoCard` (8 kopyanın yerine), `SettingsRow`/`SettingsGroup`, `StatTile`/`StatRow`, `CapsLabel`, `ShapedHeader` (dalga/çapraz kesim, illüstrasyonlu), `ProgressRing`, `EmptyState`, `TappableCard`, `PressScale`, `StaggeredList`. Mevcutlar yeniden kullanılır: `PageHeader`/`SectionHeading`, `Skeleton` ailesi, oynatıcı kiti (`player_ui.dart`), `CardFace`/`AudioButton`/`EpisodeTag`, `HiAvatar`.
- **Hareket:** `flutter_animate`, sayfa geçişleri (go_router `CustomTransitionPage`), azaltılmış hareket desteği.
- **Yazı tipleri** `pubspec.yaml` `fonts:` ile gömülür; Türkçe karakter (ç ğ ı İ ö ş ü â) doğrulanır. Uygulama açık temaya sabitlenir.
- **Bileşen vitrini:** yalnız debug'da `/tasarim` sayfası.
- **Golden test altyapısı** (gömülü yazı tipleriyle).

## Kabul kriterleri
- Belirteçler dışında yeni hex renk / `fontSize` yok (lint benzeri test).
- Vitrin ekran görüntüsü; golden testler; `flutter analyze` ve `flutter test` yeşil.
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-057/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-057-tasarim-sistemi-v2`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

## Kullanıcı kararları (2026-10-14, soru-cevap)
- Bütçe ~8 kr (Higgsfield, GPT Image 2.5 orta 1k: ~10 ekran taslağı + ~6 illüstrasyon); Hi ifadeleri kodla çizilir. Her üretimden önce maliyet gösterilir.
- Yazı tipi: başlıklar yuvarlak/sıcak (Nunito ya da Fredoka, OFL), metin Inter (OFL); uygulamaya gömülü.
- Yalnız açık tema (karanlık mod sonra ayrı iş; sistem hazır kurulur).
- Sıra: tasarım sistemi + Profil önce; H-039 ve H-040 yeni tasarımla.
- Hareket dili: yumuşak geçişler, dokunma tepkisi, sırayla belirme, dolan halka/çubuk, Hi ifadeleri, harita ışığı, sakin kutlama, hafif haptic; "Hareketi azalt" açıksa statik. K-32 yasakları korunur.
- Araçlar: Higgsfield; `frontend-design` skill'i ve AwesomeDesign standartları; 21st.dev Magic yalnız fikir panosu (web üretir, Flutter'a doğrudan girmez); `flutter_animate` (MIT).
- Plan: `/Users/felece/.claude/plans/ek-i-olarak-sayfalar-n-delightful-elephant.md` → özeti `docs/UYGULAMA-PLANI.md` "Tasarım yenilemesi".

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Sayfaların tasarımlarıyla ilgilenen bir iş aç; Profilim sayfasını hiç beğenmedim, her şey iç içe, düz yazı gibi. Daha animasyonlu, şekilli, kullanıcıyı çekecek tasarımlar."

2026-10-14 (uygulama ve doğrulama, dal `h-057-tasarim-sistemi`; sonradan commit edildi):
- **Yazı tipleri** (SIL OFL 1.1, gömülü, `mobile/assets/fonts/`): **Inter 4.1** (rsms/inter sürüm paketi, resmî statik 400/500/700) ve **Nunito** (googlefonts/nunito değişken TTF, commit `93a90a3`; fontTools 4.55.3 ile 400/500/700 statik örnek; OFL'de ayrılmış ad yok). Toplam 1,6 MB. Lisanslar Lisanslar sayfasında (`registerFontLicenses`). Türkçe karakterler (ç ğ ı İ ö ş ü â Â î û) altı dosyanın `cmap` tablosunda doğrulandı (`test/app/design/fonts_test.dart`); simülatörde başlıklar Nunito, metin Inter olarak çiziliyor.
- **Belirteçler** `mobile/lib/app/design/` (`tokens.dart`, `typography.dart`, `buttons.dart`, `transitions.dart`); `theme.dart` bunları kullanır, `AppColors` / `AppSpacing` / `AppTheme.radius` eski adlar olarak çalışır. Uygulama `ThemeMode.light`'a sabit. Renk kontrastları hesaplandı (ikincil metin `ink500` kumda 5,5:1, `orange700` 4,75:1, `success` 5,6:1).
- **Ortak bileşenler** `mobile/lib/shared/ui/`: `AppSheet`/`showAppSheet`, `InfoCard`, `SettingsGroup`/`SettingsRow`, `StatTile`/`StatRow`, `CapsLabel`, `ShapedHeader`, `ProgressRing`, `EmptyState`, `TappableCard`, `PressScale`, `StaggeredList`/`FadeSlideIn`. Hepsi "Hareketi azalt"ta durağan. Paket: `flutter_animate` 4.5.2 (BSD-3-Clause; bağımlılığı `flutter_shaders` BSD-3).
- **Geçişler:** itilen alt sayfalar (`/profil/defter`, `/profil/hi`, `/profil/hesap/**`, `/konu-seti/:id`) `appPage` ile; Android'de solarak geçiş, iOS'ta yerel kaydırma (kenardan geri dönme korunur). Oynatıcı / jenerik / tekrar / sahne avı değişmedi.
- **Vitrin:** debug'da `/tasarim` (`--dart-define=HV_START_ROUTE=/tasarim`).
- **Sabit stil temizliği (değer aynı, görünüm aynı):** oynatıcı ve harita perdeleri `AppScrim`'e, açık tonlar `AppPalette`'e taşındı; iki "Bilmiyorum" kopyası `AppButtonStyles.dontKnow()`; `PrimaryAction` `AppTypography.buttonLarge`. Taban çizgisi testi (`test/app/design/style_literals_guard_test.dart`): `Color(0x` **31 → 10**, `fontSize:` **40 → 37**, dosya başına; yalnız azalabilir.
- **Testler:** `flutter analyze` temiz; `flutter test` **404 → 439** (yeni: font 10, bileşen 9, guard 4, golden + erişilebilirlik 11, vitrin yolu 1). Golden'lar `mobile/test/goldens/images/` (güncelleme: `flutter test --update-goldens test/goldens`). Vitrinde `androidTapTarget`, `iOSTapTarget`, `labeledTapTarget`, `textContrast` yönergeleri geçti; 1,3× yazıda taşma yok.
- **Simülatör:** önce/sonra Ana Sayfa ve Profil, vitrin (9 görüntü + alt panel) ve `montaj.png` → `.yerel/h057/`. Kullanıcı verisi önce `.yerel/h057/yedek/app-data.tgz`'e yedeklendi; sonra karşılaştırıldı: yalnız sistem önbellekleri değişti, `hivelzon.sqlite` ve ayarlar değişmedi (geri yüklemeye gerek kalmadı, yedek duruyor).
- **Ertelenenler:** ekranlardaki 8 özel bilgi kartı, 8 sheet iskeleti, Profil/Hesap ayar satırları ve büyük harfli etiket kopyaları yeni bileşenlere ekran fazlarında geçer (H-059…H-062; yerleşim değişikliği olduğu için bu işte yapılmadı). Harita renkleri (H-060) ve Hi kenar rengi (H-063) belirteçlere sonra taşınır. Bulgu (H-059): kayıt ekranında hata metni "Hesabımı aç" düğmesinin altında, küçük ekranda görünür alanın dışında kalabiliyor. Bottom sheet temasında `showDragHandle` kapalı bırakıldı (mevcut sheet'lerin yerleşimi değişmesin); `AppSheet` kendi tutamacını çizer.
2026-10-14 (ana oturum): flutter test 439/439, analyze temiz yeniden doğrulandı. Commit edildi.
