# H-097: Uçtan uca simülatör gezinmesi ve görünen ad

- **Durum:** Bitti (2026-10-24); mobil 1454 test, `flutter analyze` temiz
- **Tür:** Doğrulama + küçük düzeltmeler
- **Faz:** F1 MVP
- **Bağımlılık:** H-094, H-096

## Kapsam
1. Bütün uygulama sayfalarını sırayla, gerçek yerel backend ve içerik sunucusuyla iOS simülatöründe gezmek; her adımı ekran görüntüsüyle kaydetmek.
2. Açılışı ayrı bir akış olarak baştan sona denemek: karşılama → doğum yılı/ad → bilgilendirme → tercihler → seviye → yerleştirme testi → sonuç → hazır → ana sayfa.
3. Keşfet'in bütün kategori akışlarını (Bugün, Hikâye klipleri, Sinema, Spor, Kitap) doğrulamak.
4. Bulunan görsel/akış hatalarını düzeltmek ya da neden hata olmadığını belgelemek.
5. Kullanıcı kararıyla uygulamanın görünen adını bütün ekranlarda **Hi** yapmak.

## Kabul kriterleri
- Gezinme testi ve açılış testi simülatörde geçer.
- Keşfet kategorileri backend açıkken hata kartı göstermez.
- `flutter analyze` temiz, `flutter test` yeşil.
- Ekran görüntüleri `.yerel/h097/` ve `.yerel/h097-onboarding/` altında; sır ya da kişisel veri içermez.

## Yapılanlar

### Gezinme
- `mobile/integration_test/h097_full_walkthrough_test.dart`: Ana Sayfa, Keşfet, Hikâye haritası, bölüm paneli, jenerik, oynatıcı, Kitaplık, okuyucu (dinle/sessiz, ayarlar, bölümler, sayfanın Türkçesi), Defter, Kelime tekrarı, Konuş, Profil ve alt sayfaları, Hakkında, hukuk metinleri, hesap, tasarım vitrini. 54+ adım.
- `mobile/integration_test/h097_onboarding_test.dart`: temiz bellek içi veritabanıyla bütün açılış; yerleştirme testi "Bilmiyorum" ile sonuca kadar sürüldü.
- `.yerel/h097/run-15.log` (geçen son tam tur), `.yerel/h097-onboarding/run.log` (geçen açılış), `.yerel/h097-discover/run-final-2.log` (`h097_discover_test.dart` son kategori doğrulaması).

### Keşfet
- Backend kapalıyken görülen "Klipler açılamadı" hatası uygulama hatası değildi: `127.0.0.1:8080` açılınca Bugün, Hikâye klipleri, Sinema, Spor ve Kitap akışlarının hepsi yüklendi (`error=0`, `pages=1`).
- Katalogda A1 ve A2'şer 9 yayınlanmış reel; 7 tanesi v2 (`A1-R-SPO-02`, `A1-R-CIN-02`, `A1-R-SPO-03`, `A1-R-BOK-03`, `A2-R-BOK-01`, `A2-R-CIN-02`, `A2-R-SPO-02`).

### Bulgular
- **Oynatıcı altyazısındaki "…" bir hata değil:** A1-004 recap sahnesindeki yırtık afişin metni tasarım gereği eksik basılmış (`"Fri… …pm Pier … — E."`); altyazı kırpılmıyor.
- **Tasarım vitrininde renk adı taşması:** uzun adlar (`eveningOrange`, `successSurface`, `dangerSurface`, `lighthouseYellow`) 402 pt genişlikte taşıyordu. Adlar tek satır + üç nokta ile sınırlandı; yazı boyutu belirteçten (`labelMedium`) alınıyor. Vitrin yalnız hata ayıklama ekranı.
- **Ekran görüntüsü sürücüsü:** `SHOT_DIR` yoksa yazma başarısız oluyordu; `test_driver/integration_test.dart` artık hedef klasörü kendisi oluşturuyor.
- **Keşfet denetleyici yaşam döngüsü:** kategori hızlı değişirken eski akışın `seekTo` işlemi sürüyor ve denetleyici aynı anda atılıyordu (`VideoPlayerController was used after being disposed`). `h097_discover_test.dart` önce bu hatayla düştü; `_activate` artık yalnız hâlâ sahip olduğu güncel denetleyicide devam ediyor ve atılmış/eski denetleyicinin kapanış yarışını güvenle bırakıyor. Aynı test düzeltmeden sonra beş kategoride geçti.
- **Görünen ad:** kullanıcı kararıyla bütün kullanıcı metinlerinde, Hakkında kartında, bildirim başlığında, hata kaydı konusunda ve iOS/Android uygulama etiketinde **Hi**; depo/paket/iç adlar `hiVelzon`, hukuki şirket Velzon Bilişim Teknolojileri Ltd. Şti. olarak kaldı.
- Hukuki metindeki veri sorumlusu yer tutucusu görünen addan ayrıldı; Velzon Bilişim Teknolojileri Ltd. Şti. adı korundu. Metin hâlâ taslak ve hukukçu kontrolü bekliyor.

## Test
```bash
cd mobile && flutter analyze && flutter test
# simülatör:
cd mobile && SHOT_DIR=../.yerel/h097 flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/h097_full_walkthrough_test.dart \
  -d EEE1613C-61A1-4B5F-8D5B-BED2170FC340 --dart-define=SHOT_PREFIX=h097
cd mobile && SHOT_DIR=../.yerel/h097-onboarding flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/h097_onboarding_test.dart \
  -d EEE1613C-61A1-4B5F-8D5B-BED2170FC340 --dart-define=SHOT_PREFIX=h097onb
cd mobile && SHOT_DIR=../.yerel/h097-discover flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/h097_discover_test.dart \
  -d EEE1613C-61A1-4B5F-8D5B-BED2170FC340
```

## Geri alma
Yeni test dosyaları ve metin/golden değişiklikleri kendi dalında geri alınabilir; veri ya da ücretli üretim yok.

## Notlar
- Ücretli üretim yapılmadı; bu işte Higgsfield/ElevenLabs harcaması **0**.
- Değişiklikler `2d59738` ile `origin/main`'de (2026-10-24).
- H-092 pilotu değişmedi: aşama A ve B, H-044'ten sonra.
