# H-043: Kalite ve iç beta hazırlığı

- **Durum:** Devam ediyor (2026-10-21): yerel kısım bitti ve main'de (`docs/BETA-KONTROL-LISTESI.md` 1. bölüm); kalan gerçek telefon kontrolleri (2. bölüm). 3. bölüm H-044'te.
- **Tür:** Uygulama (kod)
- **Faz:** 1.11 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-039 … H-042 · **Sonraki:** H-044

## Kapsam
- Erişilebilirlik, hata ve boş durumlar.
- Çökme raporlama (veri minimizasyonuyla).
- Simülatör ve yerel cihazda uçtan uca deneme. Mağaza ve TestFlight H-044'te.

- **H-031'den taşındı (kullanıcı kararı 2026-10-11):** düşük uçlu Android'de oynatıcı bellek/ısı ölçümü ve gerçek telefonda ses–yazı farkı ≤ 0,2 sn kontrolü.

## Kabul kriterleri
- Beta kontrol listesi tamam (mağaza maddeleri hariç).

## Test
```bash
cd mobile && flutter test && flutter build ipa --no-codesign
```

## Geri alma
Kendi dalında (`h-043-kalite-beta`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12: Gerçek cihaz denetimleri bu işte toplanır (kullanıcı kararı): düşük uçlu Android'de bellek/ısı ölçümü, gerçek telefonda ses–yazı farkı ≤ 0,2 sn, Android'de oynatıcı ve Drift veritabanının çalışması. Şimdiye kadarki doğrulamalar yalnızca iOS simülatöründe yapıldı.
2026-10-12 (H-054'ten): Ucuz Android telefonda 4G ağ koşuluyla test; hedefler: soğuk açılış, bölüm açılışı, harita kaydırma kare hızı (H-054 ölçümleri temel alınır).
2026-10-13 (H-055'ten): Gerçek iPhone ve Android'de "Söyle" alıştırmaları: cihazda tanıma, izin akışı (mikrofon izni sorulmadan dinleme başlarsa), Android İngilizce dil paketi yoksa davranış; iOS izin penceresinde Apple'ın sabit "ses Apple'a gönderilir" cümlesi (biz cihazda tanımayı zorunlu tutuyoruz) → metin ve hukuk incelemesi, gerekirse Türkçe InfoPlist.strings.
2026-10-21: **Kullanıcı onayı (plan + kararlar):** Yerel işler: Android ana manifestine INTERNET; yerel çökme kaydı (kişisel veri yok) + sakin Türkçe hata ekranı; sonsuz spinner ve eksik "tekrar dene" düzeltmeleri, oynatıcı hata metinleri tr_strings'e; hata/boş durum erişilebilirlik testleri (+ h063/h086/h091); Keşfet ve oynatıcıda "Hareketi azalt"; `docs/BETA-KONTROL-LISTESI.md`; cihaz derlemesi için yerel ağ adresi betiği. **Kararlar:** (1) Profil'de "Hata kaydını paylaş" (kullanıcı isterse sistem paylaşımıyla; son 200 satır); (2) yaş bilgisi okunamazsa Keşfet 20 dk sınırı uygulanır (güvenli taraf); (3) iOS geliştirme bölgesi tr + Türkçe InfoPlist.strings; (4) sürüm 0.1.0 (iç beta), her derlemede artan yapı numarası; (5) geçici sade uygulama simgesi ve açılış ekranı, asıl logo H-016; (6) Android imza anahtarı H-044'e.
2026-10-21: **Yerel işler uygulandı (commit yok, kullanıcı onayı bekliyor).** Kontrol listesi: `docs/BETA-KONTROL-LISTESI.md`.
- **Android:** `INTERNET` izni ana manifestte. Önceden yalnız debug/profile manifestlerindeydi; release ağa çıkamıyordu. Debug ve profile derlemelerde düz HTTP (`base-config`) açık; Mac'in yerel ağ adresine ulaşmak için `src/profile/res/xml` eklendi. Release etkilenmez.
- **Çökme kaydı:** `lib/shared/diagnostics/`.
  - Yakalananlar: `FlutterError.onError`, `PlatformDispatcher.onError` ve `runZonedGuarded` (`main.dart`).
  - Kayıt, Application Support'ta son 200 satırlık JSON dosyasıdır; Drift kullanılmadı, gerekçesi kontrol listesinde.
  - Satırda yalnızca etiket, `runtimeType`, temizlenmiş 8 yığın satırı, sürüm ve UTC saat var. Mesaj saklanmaz. Art arda aynı hata tek satırda sayılır.
  - Release'te sakin hata kutusu (`CalmErrorBox`) gösterilir.
  - Profil → Hakkında → **Hata kaydını paylaş**: `share_plus` (BSD-3) ile yalnızca kullanıcı dokununca.
  - "Bu telefondaki verileri sil" kaydı da siler.
  - `debugPrint` taraması yapıldı: 154 çağrı var; belirteç, e-posta, transcript ya da ad yazan çağrı yok. Not kontrol listesinde.
- **Sonsuz yükleme ve "Tekrar dene":**
  - Keşfet sınırı ve kalınan video okunamazsa sağlayıcı hataya düşmez; ekranda da güvenli yedek var.
  - Kelime tekrarında cevap kaydı 10 sn zaman aşımına bağlandı. Hata ekranına **Tekrar dene** eklendi.
  - **Tekrar dene** eklenen öteki yerler: Hi gizlilik, Defter, İpucu panosu, sezon jeneriği.
  - Oynatıcı hata metinleri `PlayerTexts`'e taşındı ("Bölüme şu an ulaşılamadı."). "İçerik sunucusu" ibaresi kaldırıldı; geliştirici notu yalnız debug derlemede.
  - Defter hata metni: "… Biraz sonra tekrar dene."
- **Keşfet yaş sınırı (karar 2):** Yaş okunamazsa `DiscoverLimit.failSafe` (20 dk) uygulanır. Test önce yazıldı.
- **Erişilebilirlik:** `test/goldens/h043_states_test.dart` eklendi. Hata ve boş durumlar için yönergeler ile 320 × 568 · 1,3× taşma testleri yapıldı; **Tekrar dene**'nin gerçekten yeniden okuduğu da test edildi. Aynı dosyada h063, h086 ve h091 testleri de var.
- **Hareketi azalt:**
  - Oynatıcı rotası geçişsiz açılır (`fullscreenPage`).
  - Başlık afişi ve karar kararması anında değişir.
  - Görev ve anlam panelleri ile Keşfet seviye paneli animasyonsuz açılır (`AppMotion.sheet`).
- **iOS:**
  - Geliştirme bölgesi `tr`; `knownRegions` listesine `tr` eklendi; `CFBundleLocalizations` = `tr`.
  - `ios/Runner/tr.lproj/InfoPlist.strings` eklendi: mikrofon, konuşma tanıma ve yalnız debug/profile'da yerel ağ metni.
  - iOS'ta bildirim izni için açıklama anahtarı yoktur.
- **Sürüm:** `0.1.0+1`; `AppInfo` ve testi aynı. Yapı numarası derleme anında `--build-number` ve `HV_APP_VERSION` ile verilir (`tools/device-build.sh`).
- **Geçici simge ve açılış ekranı (H-016'ya kadar):** Kum zemin üstünde lacivert yuvarlak "hi" işareti. `mobile/tool/placeholder_icons.sh` ile ImageMagick'te üretildi; ücretli üretim yok.
  - iOS: AppIcon'un bütün boyutları ve LaunchImage.
  - Android: mipmap'ler, uyarlanabilir simge, açılış zemini, Android 12+ `windowSplashScreenBackground`.
- **Cihaz derlemesi:** `tools/device-build.sh` eklendi. Çalışan backend ve içerik sunucusuna dokunmaz.
  - İçerik sunucusuna isteğe bağlı `--host` eklendi (varsayılan yine 127.0.0.1).
  - Reel medyası için backend'in bir sonraki başlatılışında `HIVELZON_MEDIA_LOCAL_BASE_URL` verilmesi gerekir; not kontrol listesinde.
- **Doğrulama:**
  - `flutter analyze`: sorun yok.
  - `flutter test`: **1416 geçti** (önce 1351).
  - Golden'lar bilinçli olarak güncellendi: `h042_hakkinda` (sürüm), `h059_profil` ve `h059_profil_adsiz` (yeni satır), `h062_gorev_paneli` ("Hareketi azalt" ile panel tam açık).
  - `flutter build ios --simulator --debug --no-codesign` ve `flutter build apk --debug` geçti.
- **Kalan:** Kontrol listesinin 2. bölümü gerçek telefon ister. 3. bölüm H-044'tedir: imza, TestFlight/Play, gerçek HTTPS adresleri. 127.0.0.1 varsayılanları risk olarak yazıldı.
