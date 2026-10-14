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
