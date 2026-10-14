# H-086: Kitap okuyucuda "Sayfanın Türkçesi"

- **Durum:** Devam ediyor (kod main'de: flutter 940; kullanıcı denemesi bekleniyor)
- **Tür:** Uygulama (mobil)
- **Faz:** Kitaplık (H-067 devamı)
- **Bağımlılık:** H-067

## Kapsam
Kullanıcı isteği (2026-10-14): "Kitap okurken sayfanın tamamının Türkçesini görmek isteyebilir."

- **"Sayfanın Türkçesi" düğmesi.** Okuyucunun üst çubuğunda ya da sayfa altında durur. Dokununca alttan panel açılır:
  - sayfanın onaylı Türkçesi cümle cümle görünür;
  - ses duraklar, panel kapanınca kaldığı yerden devam eder;
  - paneldeki bir cümleye dokununca İngilizce sayfada karşılığı vurgulanır ve oraya kaydırılır.
- **"Satır altı Türkçe" ayarı.** Okuma ayarlarındadır, varsayılan kapalı. Her İngilizce cümlenin altında küçük, soluk Türkçesi görünür.
- Veri `pages.json`'daki cümle `tr` alanıdır; yeni içerik gerekmez.
- Ekran okuyucu etiketleri. 1,3× yazıda taşma yok. "Hareketi azalt" desteklenir.

## Kabul kriterleri
- Panel doğru sayfanın Türkçesini sırasıyla gösterir.
- Ses duraklar ve devam eder.
- Cümle eşleşmesi vurgulanır.
- Satır altı ayarı kalıcıdır.
- Testler ve golden yeşil.

## Test
`cd mobile && flutter analyze && flutter test`

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı. Pedagojik not: çeviri yalnız okunup geçilmesin diye cümle eşleşmesi İngilizceye geri götürür; satır altı varsayılan kapalıdır (K-03 ile tutarlı).

2026-10-14 (uygulama, dal `h-086-sayfa-turkcesi`):
- **Düğme:** iki giriş. Üst çubukta çeviri simgesi (ipucu/etiket "Sayfanın Türkçesi"; her zaman erişilir) ve sayfa metninin sonunda yazılı "Sayfanın Türkçesi" düğmesi (keşfedilir, 48 px). Sayfanın hiç Türkçesi yoksa ikisi de gizli.
- **Panel** (`presentation/widgets/page_turkish_sheet.dart`, `AppSheet`): sayfanın Türkçesi sırasıyla (`Book.turkishOf`; bölümün ilk sayfasında başlık önce; boş/eksik `tr` atlanır). Okunan cümle panelde açık sarı zeminle işaretli. Açılınca ses durur (`pauseForSheet`); "Kapat" ile kaldığı yerden sürer, duraklıysa duraklı kalır.
- **Cümleye dokunma:** panel hep kapanır (bölüm listesiyle tutarlı). Sesli modda okunan yer o cümleye geçer (`ReaderController.resumeAfterSheetAt`): vurgu oraya taşınır, panelden önce çalıyorduysa okuma o cümlenin başından sürer. Sessiz modda ses çalmaz; cümle sayfa çevrilene kadar vurgulu kalır. İki modda da cümle görünür kılınır (`BookPageView.reveal/revealRequest`; konforlu bant dışındaysa üst ~%25'e kaydırılır, "Hareketi azalt" açıksa atlanarak).
- **Satır altı Türkçe:** okuma ayarlarında, varsayılan kapalı, `app_meta` `reader.interlinear`. Açıkken her cümle ayrı blok, altında Türkçesi `AppTypography.readingGloss` (0,8×) ve `BookColors.muted` (yazı zemine doğru açılır, ≥ 4,5:1 korunur). İzleme Türkçe satırını da cümlenin parçası sayar. Ekran okuyucu "Türkçesi: …".
- **Metinler:** `ReaderTexts` + `ARAYUZ-METINLERI.md` §4.7; `KITAPLIK.md` §7.
- **Testler:** `test/features/library/reader_turkish_test.dart` (14: panel sırası ve sayfa değişimi, alt düğme, ses durur/sürer, duraklı kalır, sesli ve sessiz dokunma → vurgu + kaydırma, hareketi azalt, satır altı kalıcı ve çizimi, eksik `tr`, Türkçesiz sayfa, 320×568 1,3× iki modda, erişilebilirlik, ekran okuyucu). Golden: `test/goldens/images/h086_panel.png`, `h086_satir_alti.png` (`skipGoldensOffMac`); `h067_okuyucu.png` yeni düğmelerle güncellendi. Hepsi gözle kontrol edildi.
- `flutter analyze` temiz; `flutter test` 940 test geçti.
