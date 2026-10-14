# H-057: Tasarım sistemi v2 (belirteçler, bileşen kitaplığı, hareket, yazı tipleri)

- **Durum:** Yapılacak
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
