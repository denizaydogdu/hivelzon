**hiVelzon — güncel geliştirmelerin incelemesi, 21 Ekim 2026**

İncelenen HEAD: `b7f9526`. Başlangıçta çalışma ağacı temizdi. Bu incelemede uygulama kodu değiştirilmedi; commit ve ücretli üretim yapılmadı. 15 ve 17 Ekim raporları ile Keşfet brief/planı temel alındı. Odak: son değişiklikler, önceki hataların durumu, bağımsız reeller, yayın kapısı, öğrenme kayıtları ve kullanıcı akışı.

**Değerlendirme**

Keşfet artık yalnız plan değil: bağımsız reel modeli, günlük seçki, konu/seviye tercihleri, Defter bağı ve backend yayın kataloğu uygulanmış. Önceki beş soruna da kodda karşılık gelen düzeltmeler var. Yeni büyük özellik geliştirmekten önce açık kalan katalog/kanıt doğruluğunu kapatıp küçük gözlemli teste geçmek daha yararlı.

Bu inceleme gerçek telefonla bütün ekranların kullanılması veya 18 videonun sesli olarak baştan sona izlenmesi değildir. Kod, otomatik test, geçici sınama örnekleri, medya envanteri, güncel golden görüntüleri ve örnek gerçek reel görseli incelendi. Gerçek cihaz performansı, mikrofon kalitesi ve bütün içeriklerin öğretim doğruluğu için ayrıca insan testi gerekiyor.

**Doğrulama sonuçları**

- `flutter analyze`: sorun yok.
- Mevcut mobil testlerin tamamı: **1.351 test geçti**. Belgelerdeki 1.284 sayısı bu koşunun sonucu değil; bu rapor doğrudan yeni çıktıyı esas alır.
- İçerik boru hattı testlerinde ilk tur yalnız üç yerel HTTP sunucu testi sandbox port bağlama izni nedeniyle başarısız oldu. Kitap, dilbilgisi ve reel sunucu testleri izinli yeniden çalıştırmada geçti; diğer testler ilk turda geçti.
- Backend `ReelCatalogTest`: **7 test geçti**. İlk denemede varsayılan Docker soketi bulunamadı; projede belgelenen Colima soketiyle yeniden çalıştırıldı. Bütün backend test paketi bu turda çalıştırılmadı.
- `/private/tmp/hv_followup_20261021_test.dart` geçici sınama dosyasında iki yeni beklenen davranış başarısız, önceki eksik olumsuzluk denetimi başarılı oldu. Bu dosya proje test paketine eklenmedi; aşağıdaki iki açık bununla yeniden üretildi.
- 18 gerçek reel paketi bulundu: **A1: 9, A2: 9**. Paket JSON'larının işaret ettiği video/poster/ifade sesi/görsel dosyalarında eksik yol saptanmadı. Bu varlık denetimi bütün seslerin anlaşılır veya senkron olduğunun kanıtı değildir.
- Paket süreleri **11,0–13,4 saniye**, toplam **220,2 saniye**. Plandaki yaklaşık 20–30 saniyeye göre daha kısa; bunun iyi veya kötü olduğuna yalnız süreden karar verilmez. Pilotta durumun anlaşılıp anlaşılmadığı ve soru kesintisinin ağırlığı gözlenmeli.

**Önceki bulguların güncel durumu**

| Önceki sorun | Kodda görülen düzeltme | Sonuç |
|---|---|---|
| Olumsuzluk düşünce başarı yazılıyordu | `_missingMeaningChangers` eklendi; `can't → can` ve `not` kaybında changedWords doluyor | Eski örnekler düzeldi |
| Mesaj yalnız sorry/late ile geçiyordu | Kabul grupları anlamlı kalıplarla daraltıldı; notta yer zorunlu oldu | Eski örnekler için düzeldi; cümle sınırı açığı aşağıda |
| Örneğe/ipucuna bakarak yazmak own_use sayılıyordu | `_sawHelp` tutuluyor, `own: !_sawHelp` yazılıyor | Aynı ekran içindeki yardım ayrımı düzelmiş |
| Kitabı açmak okuma sayılıyordu | İlk açılışta `_savePlace` kaldırılmış | Eski tetikleme düzelmiş; gerçek okuma tanımı hâlâ konum ilerlemesine dayanıyor |
| Örnek özeti açmak yeniden anlatma sayılıyordu | `retellDone` artık yazı veya öz değerlendirmeye bağlı | Eski tetikleme düzelmiş; öz değerlendirme bağımsız başarı diye yorumlanmamalı |
| Konu tercihi yalnız altyapıda vardı | Güncel Keşfet seviye panelinde konu aç/kapa arayüzü var | Uygulanmış; devir belgesindeki “arayüz yok” notu kodun gerisinde |

**1. [P1] Yenilenen katalogdan silinen reelin eski paket adresi bellekte kalıyor**

Yer: `mobile/lib/shared/content/http_content_source.dart:213–252,255–283`.

`listReels()` her okumada güncel katalog nesnesini oluşturuyor; fakat `_reelPackageBases` haritasını güncel listenin tamamıyla değiştirmiyor. Katalogdan düşen kimliğin eski adresi haritada kalıyor. `loadReel()` önce bu adrese baktığı için kimliğin hâlâ yayında olduğunu denetlemeden paketi okuyabiliyor.

Geçici testte sıra: bir reel yayında → katalog/paket yükleniyor → sahte backend artık boş katalog dönüyor → `listReels()` boş liste veriyor → aynı kaynak nesnesiyle `loadReel(eskiId)` yine Reel döndürüyor. Beklenen `ContentUnavailableException` gelmedi.

Günlük seçkide katalogdan düşeni değiştiren mantık var; bu bulgu o düzeltmenin yokluğu değil. Paket yükleyicinin kendi yayın kapısı eksik. Ayrıca normal uygulama/sekme dönüşünde `reelCatalogProvider` yenilenmiyor; oynatıcı görünür olunca sadece süre tekrar okunuyor ve video yeniden başlıyor. Dolayısıyla backend'den geri çekmenin açık oturuma ne zaman yansıyacağı da tanımlı değil.

Öneri: katalog sayfaları başarıyla tamamlanınca yeni yetkili kimlik/adres haritasını atomik olarak değiştir; yayında olmayan kimliği eski önbellek adresinden açma. Foreground/Keşfet'e dönüşte kontrollü katalog yenilemesi ve aktif video geri çekilmişse durdurma davranışını tanımla. Ağ hatasında “önceden biliniyordu, açalım” şeklinde sessiz fallback yapma. Katalogdan kaldırmanın doğrudan medya URL'sini iptal etmediğini de yayın tasarımında ayrı ele al.

**2. [P1] Mesajda cümleler yeniden birleştiriliyor; yanlış cevap hâlâ own_use üretebiliyor**

Yer: `mobile/lib/features/talk/domain/talk_match.dart:204–220`, `talk_message_view.dart:75–85`.

`sentences()` ve cümle içinde kontrol eklenmiş; fakat `checkMessage()` gerekli kalıpları ararken bütün cümleleri `all` listesinde yeniden birleştiriyor. `coveredTargets()` da bütün mesajın kelime kümesine bakıyor.

Güncel gerçek `late-maya` göreviyle yeniden üretildi:

```text
Girdi: Sorry, I am. Late.
checkMessage.passed = true
coveredTargets = [Sorry, I'm late.]
```

Kullanıcı ilk denemesinde bunu yazarsa yardım bayrağı false kalır; ifade Defter'de varsa ekran own_use yazabilir. Eski “Sorry, I am early. Maya is late.” örneğini kapatmak, genel cümle sınırı kuralını henüz tamamlamamış.

Öneri: gerekli kalıbın tamamını tek bir cümlede doğrula; özür ile gecikme ayrı cümlelerde olabilir ama `I am late` farklı cümlelerin parçalarından oluşmamalı. Kanıt üretiminde yalnız geçerli eşleşmenin kimliğini/kalıbını taşı; bütün mesajdaki kelimelerin varlığını denetlenmiş üretim sayma. Hata/öz değerlendirme yoluna düşmek, yanlış olumlu kanıt yazmaktan daha uygun.

**3. [P1 — yayın öncesi] İçerik sürümü ile fiziksel paket adresi birbirinden ayrılmamış**

Yer: `backend/src/main/java/tr/velzon/hivelzon/catalog/ContentType.java:37–41`, `tools/content-pipeline/build_reel.py:124–128,176–178,206`.

Katalog ve günlük set contentVersion taşıyor; fakat paket adresi yalnız `_reels/<id>` üzerinden kuruluyor. Üretim de aynı `_build/package/` dosyalarını yeniden yazıyor. Bu akışta yayındaki v1'in klasörüne henüz onaylanmamış v2 kurulursa katalog v1'i göstermeyi sürdürürken aynı adresteki JSON/video v2 olabilir. İçe aktarmanın onaylı kaydı SKIPPED bırakması, fiziksel dosyanın üzerine yazılmasını geri almıyor.

Bu turda yayındaki gerçek dosyalara yeni sürüm yazarak deneme yapılmadı; bulgu paket yolu ve build davranışından çıkarılan somut yayın riski. CDN/üretim depolaması henüz ayrı sürüm yolu kullanıyorsa plan ve kod sözleşmesinde gösterilmeli.

Öneri: değişmez sürüm veya içerik özeti içeren paket kökleri kullan (`<id>/v2/` gibi); üretim/staging ile yayındaki paketi ayır. Katalog onaylanan belirli pakete işaret etsin. Mobil paket kimliği/sürümü ile katalogdaki beklenen sürümün uyuşmasını denetlesin. Bekleyen v2 üretildiğinde v1 byte'larının aynı kaldığını ve v2'nin onay öncesi sunulmadığını test et.

**4. [P2] İzleme tamamlandı koşulu henüz benzersiz oynatma kapsamını ölçmüyor**

Yer: `mobile/lib/features/discover/presentation/discover_screen.dart:872–880`.

Tamamlanma için esas kontrol oynatıcı konumunun sürenin %90'ına gelmesi. Aktif saniye ayrıca artıyor ancak tamamlanma koşulunda toplam izleme veya benzersiz izlenen aralıklar kullanılmıyor. Normal baştan sona oynatmada sorun olmayabilir; konum atlaması, ileri sarma gibi yollar eklenirse kısa bir son parça tamamlandı kaydı üretebilir. Bu madde kod incelemesine dayanıyor; kullanıcı arayüzünde son noktaya atlama senaryosu bu turda yeniden üretilmedi.

Öneri: “aktif süre + %90 kapsam” diye belgelenen sözleşmeyi gerçekten iki koşula bağla veya ölçüm tanımını açıkça daralt. Bu kaydı öğrenme kanıtından ayrı tutman doğru; korunmalı.

**Ürün ve ekran geri bildirimi**

- Günlük üçlü, kategori çipleri, seviye ve ilgi tercihleri artık görünür. Kullanıcının “Reels gibi ama seviyeme uygun” isteği somutlaşmış.
- Her videonun ardından atlanabilir soru var; eski quizEvery=4 tuzağına bağlı değil. Soru sonucu Defter/FSRS kanıtından ayrılmış.
- “Kaydet” hâlâ tek başına video kaydetme gibi anlaşılabilir. Pilot için etiketin “İfadeyi kaydet” veya “Defter'e ekle” olması daha açık.
- Önceki handoff'taki “kategori arayüzü yok” bilgisi artık geçerli değil; yeni durumu kod ve golden görüntüler üzerinden doğruladım.
- İncelenen gerçek sinema görselinin çizim dili ve bağlamı ürünün genel görsel yönüyle uyumlu. Bu örnek, bütün sahnelerin karakter tutarlılığına veya ses-görsel eşleşmesine onay anlamına gelmez.
- Reel stokunun her seviyede dokuz video olması, üç günlük tekrarsız seçkiyi karşılıyor. Haftalık taze içerik vaadi için yeterli değil; plan zaten bunu doğru biçimde sınırlandırmış.

**Önerilen sıra**

Önce katalog önbelleği/yayın kapısı ve mesaj kanıtı hatasını düzelt. Gerçek dağıtımdan önce değişmez sürüm paketlerini netleştir. Ardından kullanıcının kararlaştırdığı küçük, isteğe bağlı gözlemli H-092 A testinde kategori seçme, ilk üçlü, ifadeyi kaydetme ve ertesi gün hatırlama görevlerini gözle. H-092 B'nin H-044 ile en sona bırakılması mevcut kullanıcı kararı; bu rapor onu değiştirmiyor. Yeni içerik dalgası veya daha karmaşık öneri sistemi şu anda öncelik değil.
