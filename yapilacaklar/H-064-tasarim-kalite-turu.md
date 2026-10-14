# H-064: Tasarım kalite turu (erişilebilirlik, golden, temizlik)

- **Durum:** Yapılacak
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T7 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-059 … H-063, H-040

## Kapsam
- Bütün ekranlarda erişilebilirlik testleri (`meetsGuideline`: dokunma hedefi, kontrast, etiket).
- 1,3× metin büyütmede taşma testleri; golden kapsamının tamamlanması.
- Kalan sabit stil ve metinlerin temizliği; `docs/ARAYUZ-METINLERI.md` ve `tasarim/README.md` son hâli.

## Kabul kriterleri
- Sabit stil sayıları sıfıra yakın (rapor); bütün testler yeşil.
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-064/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-064-tasarim-kalite-turu`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

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
2026-10-14 (H-061 kararı): Doğru cevaptaki hafif titreşim için Profil > Öğrenme'de "Titreşim" aç/kapa anahtarı (varsayılan açık); bütün haptic çağrıları bu ayara bağlanır.

2026-10-14 (Hi balonu katmanı, dal `h-hi-balon-katman`): Kullanıcı geri bildirimi: "her sayfada Hi balonunun satırı tamamen kapanıyor; z-index'le üstte dursun, gezerken o satır kapanmasın." `ShellScaffold` artık alt güvenli alanı balon kadar büyütmüyor. Balon içeriğin üstünde yüzüyor, sayfalar menüye kadar uzanıyor ve içerik balonun altından kayıyor. Yeni `HiBubbleInset.of(context)`: balon görünürken `HiBubble.clearance` (88), görünmezken 0 döner. Kaydırılan listeler bu payı yalnızca son dolgu olarak ekliyor: Ana Sayfa, Profil, Konuş yer tutucusu, Hikâye · Kitaplık ve Dilbilgisi. Böylece liste sonunda son kart balonun üstünde bitiyor. Hikâye/Macera kaymıyor; odak kartı yer varsa balonun solunda bitiyor (yalnız sağ pay). Dar ekranda ya da büyük yazıda kart balonun üstünde kalıyor. Odak kartı yoksa harita balonun üstünde bitiyor. Kısa ekranda kayan Hikâye sayfasında harita alanı en az 600 pt; 320×568 boyutunda 1,3× yazıda harita sütunu artık taşmıyor. Keşfet tam ekran video olduğu için eski davranışı koruyor: alt denetimler balonun üstünde kalsın diye orada alt güvenli alan hâlâ balon kadar büyüyor. Balonun gölgesi zaten vardı; otomatik gizleme animasyonu eklenmedi. Testler `hi_ui_test.dart` dosyasında. Kontrol edilenler: içerik balonun satırından geçiyor; liste sonunda son öğe balonun üstünde; balon yokken fazladan dolgu yok; odak kartı ve oku 393×852 ve 320×568 boyutlarında, 1× ve 1,3× yazıda örtülmüyor; Keşfet'te Kaydet düğmesi balonun üstünde. Golden'lar değişmedi.

2026-10-14 (Dilbilgisi ilerleme yüzdesi ve örneklerin cihaz sesi, dal `h-dilbilgisi-ilerleme-ses`): Kullanıcı istekleri: "Dilbilgisi listesinde her konunun altında kullanıcı ne kadar ilerlemiş, yüzde olarak görünsün." ve "Her derste İngilizce örnekler var; kullanıcılar nasıl söylendiğini dinleyebilmeli." Liste: yarım derste ince çubuk + "%43 ilerledin" (kalınan kart / `cardCount`), bitmişte onay + "Tamamladın", başlanmamışta yazı yok; seviye raflarında "A1 · 3/16 tamamlandı"; ekran okuyucu etiketleri. Ses: önceden üretilmiş Sarah sesi yoksa örnek ve "Söyle" cümlesi telefonun cihazdaki İngilizce sesiyle okunur (`flutter_tts`, MIT; iOS AVSpeechSynthesizer, Android yalnız ağ istemeyen kurulu ses); dosya varsa dosya çalar; ses yoksa düğme gizli; aynı anda tek ses; kart değişince ve ekrandan çıkınca durur. Ayrıntı `docs/DILBILGISI.md` §7, metinler `docs/ARAYUZ-METINLERI.md` §4.8–4.9. Testler: `grammar_progress_percent_test.dart`, `grammar_progress_ui_test.dart`, `grammar_device_voice_test.dart`; yeni golden `h078_dilbilgisi_ilerleme.png` (öteki golden'lar değişmedi). Anlam panelinde kelime kelime cihaz sesi eklenmedi (ortak arayüz değişirdi); cümle cihaz sesiyle dinlenebilir.

2026-10-14 (kalite turu, dal `h-064-kalite`):
- **Profil durum çubuğu:** Kaydırınca avatar ve "Merhaba Deniz" saatin ve Dynamic Island'ın altına giriyordu. Yeni ortak `StatusBarScrim` (`shared/ui/surfaces.dart`) eklendi: sayfa en üstteyken görünmez, illüstrasyon durum çubuğunun altında kalır. Kaydırınca kum renkli, alt çizgili bir şerit belirir ve durum çubuğu simgeleri koyulaşır. "Hareketi azalt" açıksa geçiş anlıktır. Profil'de ve açılışın karşılama adımında (başlıklı adımlar) kullanılıyor. Ana Sayfa, Hikâye, Kitaplık okuyucusu, Dilbilgisi dersi ve sahne avı zaten üst güvenli alanı koruyor; Defter, Hesap, Hi gizlilik ve konu seti `AppBar`'lı. Bunlarda sorun yok.
- **Alt sekme etiketi:** 320 pt genişlikte, 1,3× yazıda "Ana Sayfa" iki satıra bölünüyordu (test: 42 px yükseklik). `AppTypography.navLabelFitScale`, en geniş etiketin tek satıra sığacağı ölçeği hesaplıyor. Etiket kesilmiyor, biraz küçülüyor (alt sınır 0,85×). Geniş ekranda kullanıcının ölçeği korunuyor. Test: `test/app/shell_nav_label_test.dart` (320 × 568 1,3× ve 1×; 393 × 852 1,3×).
- **Titreşim ayarı:** Profil > Öğrenme > **Titreşim** (varsayılan açık; `app_meta` `haptics.enabled`). Bütün dokunsal geri bildirim (kelime tekrarında doğru cevap, sahne avında bulma) `shared/haptics/haptics.dart` (`Haptics.success`) üzerinden geçiyor ve ayara uyuyor. Başka yerde `HapticFeedback` çağrılmıyor; bunu bir test koruyor. Testler: `test/shared/haptics/haptics_test.dart`, `h061_design_test.dart` (kapalıyken titreşim yok), `profile_test.dart` (anahtar ve perde).
- **Erişilebilirlik ve küçük ekran turu:** Dört yönerge (dokunma hedefi Android/iOS, etiket, kontrast) ve 320 × 568 · 1,3× taşma testi artık her ana ekranda ve panelde var. Yeni kapsananlar: Profil, Hesap, Hi gizlilik ve hukuk metni (320 × 568), giriş, günlük hedef ve ad panelleri (`h059`), kabuk içinde Ana Sayfa, Hikâye ve Profil (alt sekme çubuğu ve Hi balonuyla), Konuş, Hi paneli ve sezon jeneriği (yeni `test/goldens/h064_quality_test.dart`; başındaki harita hangi ekranın nerede denetlendiğini gösteriyor). Kontrast denetimi her yerde `if (!skipGoldensOffMac)` içinde (h059 ve açılış testinde eksikti). Yeni testlerde başarısız olan ekran çıkmadı.
- **Sabit stil:** belirteç dışında `Color(0x` 0, `fontSize:` 1 → **0** ("Söyle" düğmesi `AppTypography.button`'a geçti; dosyadaki eski `AppColors` / `AppSpacing` / `Colors.white` adları da belirteçlere çevrildi). Bekçi tabanı boş.
- **Golden:** yalnız `h059_profil` ve `h059_profil_adsiz` değişti (yeni Titreşim satırı; yükseklik 1240 → 1340). Görsel olarak kontrol edildi. Öteki golden'lar değişmedi.
- **Simülatör önce/sonra:** `.yerel/h-064/before|after/` (`profil-ust`, `profil-kaydirilmis`, `profil-buyuk-yazi`). Geçici "h064-temp-17pro" simülatöründe çekildi, sonra silindi. Paylaşılan simülatöre dokunulmadı. Önce: kaydırınca avatar saatin üstüne biniyor. Sonra: kum şerit var.
- Testler: 887 → 924, hepsi yeşil; `flutter analyze` temiz.
