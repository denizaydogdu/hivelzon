**hiVelzon ürün incelemesi ve uluslararası karşılaştırma — 15 Ekim 2026**

**Ana değerlendirme**

hiVelzon'un en güçlü vaadi, Türkçe konuşan birinin devamını merak ettiği bir macerayla İngilizce çalışması. Hikâye, bağlamdan kelime kaydetme, sesli kitap ve tekrarın aynı üründe birleşmesi değerli. Şu an temel sorun özellik azlığı değil: içerik tüketiminin, bağımsız dil üretimine ve ölçülebilir öğrenme kazanımına yeterince bağlanmaması.

Önerim: ilk ürün vaadini A1–A2 Türkçe konuşan genç/yetişkinler için hikâye üzerinden günlük İngilizce pratiğinde daralt. İleri seviye kitapları kaldırma; bunları yardımcı kitaplık olarak sun. Her yaşa ve A1–C2'nin tamamına aynı derinlikte hizmet veren kapsamlı kurs iddiasını, bu kapsam ölçülene kadar kullanma. Bu bir öneridir; mevcut ürün kararlarını değiştirmedim.

**İncelemenin kapsamı ve sınırı**

Önce yerel projeyi; sonra rakiplerin resmî ürün ve destek sayfalarını inceledim. Kaynaklar: ürün kararları, iş takibi, Flutter ekranları ve yönlendirme, yerleştirme motoru ve gerçek soru bankası, bölüm motoru, kelime tekrarı/FSRS kuralları, konuşma eşleştiricisi, Hi koçu, kitap ve dilbilgisi ilerlemesi, içerik paketleri, örnek metinler, backend katalog/onay/eşitleme yapısı ve depodaki ekran görüntüleri.

Bu, bütün metinlerin öğretmen tarafından satır satır düzeltilmesi veya bütün videoların izlenmesi anlamına gelmez. İçerik kalitesinde örneklem incelemesi yaptım. Açık iOS simülatörü bulunmadığından canlı uçtan uca kullanım, gerçek cihaz mikrofonu, ses kalitesi, video geçişleri, mağaza sürümü ve Android performansı bu incelemede doğrulanmadı. Ekran değerlendirmesi depodaki golden görüntülerine dayanıyor; bunlardaki örnek görsel yer tutucularını gerçek ürünün görselleri eksik diye yorumlamadım. Rakipleri ücretli hesaplarla uygulama içinde test etmedim. Resmî sayfalardaki özellik anlatımı, bağımsız öğrenme etkililiği kanıtı değildir; ülke, dil, platform ve aboneliğe göre erişim değişebilir.

Doğrulama: `flutter analyze` sorunsuz tamamlandı. `flutter test --reporter compact`: 956 test geçti. Ayrı küçük Dart denemesiyle konuşma eşleştiricisindeki olumsuzluk hatası yeniden üretildi. Backend testlerini bu incelemede yeniden çalıştırmadım. Uygulama koduna ve ürün kararlarına müdahale etmedim.

**1. Gerçekte ne var?**

| Alan | Depoda gördüğüm durum | Değerlendirme |
|---|---|---|
| Hikâye | 13 kaynak bölüm tanımı: prolog + 12 A1 bölüm; 12 dışa aktarılmış bölüm paketi | Kaynak, üretilmiş paket ve yayına onay aynı şey değil |
| Kitaplık | A1–C2, her seviyede 5: toplam 30 kaynak kitap ve 30 dışa aktarılmış kitap paketi | Kapsam var; bütün seslerin/görsellerin eksiksizliği ve pedagojik uygunluğu ayrıca denetlenmeli |
| Dilbilgisi | 71 kaynak ders ve 71 dışa aktarılmış paket; A1:16, A2:15, B1:14, B2:12, C1:8, C2:6 | İçerik miktarı güçlü; ders bitirmek ustalık ölçümü değil |
| Defter/tekrar | Bağlamdan kaydetme, kaynak bilgisi, FSRS, seçme/dinleme/dizme/yazma/söyleme | Ürünün korunması gereken çekirdeği |
| Konuşma | Çeşitli yerlerde cihazda beklenen ifadeyi söyleme | Açık uçlu karşılıklı konuşma yok; ana Konuş sekmesi yer tutucu |
| Koç | Hi-A: gerekçeli ve öncelik sıralı kural motoru | Yararlı; henüz kapsamlı uyarlanabilir beceri modeli değil |
| Yerleştirme | Onaylı 22 madde: 2 ısınma + seviye başına 4; A1–C1 | Okuma/kelime/dilbilgisi; dinleme, konuşma ve yazılı üretim ölçülmüyor |
| Hesap | İsteğe bağlı e-posta kodu, eşitleme, hesap silme altyapısı | Düşük giriş engeli önemli avantaj |
| Kalite | Tasarım sistemi, erişilebilirlik kontrolleri, geniş otomatik testler | Yazılım doğruluğuna kanıt; öğrenme etkililiğini ayrıca ölçmek gerekir |

Kaynak içerik JSON'larında DRAFT etiketleri bulunuyor. Bu, içeriklerin hiç gözden geçirilmediğini tek başına kanıtlamaz: backend içe aktarma kodu yayın durumunu dosyadan almıyor, veritabanında yönetiyor. Canlı veritabanının yayın/onay durumlarını doğrulamadım. README ve iş sırasının üst özetleri de bazı konularda kodun gerisinde: değerlendirmeyi yalnız bunlara dayandırmadım.

**2. İyi yaptıkların — bunları koru**

- **Tek bir devam eden hikâye:** Karakter ve merak, birbirinden kopuk örnek cümlelere göre güçlü bir ürün kimliği kuruyor. Bölümlerin payoff/openQuestion/callbackPhrases bağlantıları düşünülmüş.
- **Türkçeye özgü yardım:** Türkçe karşılaştırmalı dilbilgisi, bağlam içi anlam ve tipik hata notları somut değer taşıyor.
- **İçerik → Defter → tekrar zinciri:** Kitaptan veya sahneden öğrenilen ifadenin kaynağı ve sesiyle tekrar edilmesi iyi bir temel.
- **Baskısız deneyim:** Can, enerji, lig, süreli soru ve utandırıcı dil eklememe kararları tutarlı. Bunların yokluğu eksik değil.
- **Hesapsız kullanım:** Kullanıcı öğrenmeye başlamadan kayıt ve ödeme duvarıyla karşılaşmıyor.
- **Teknik disiplin:** Saf alan mantığı, testler, yerel ilerleme, eşitleme, onay akışı ve erişilebilirlik altyapısına erken yatırım yapılmış.
- **Sesli/sessiz okuma ve kademeli destek:** Okuyucu tek bir kullanım biçimine zorlamıyor. Türkçe desteği kaldırmak yerine ihtiyaç anında sunmak doğru yön.

**3. Rakiplerden hangi ilkeyi almalısın?**

| Örnek | Resmî kaynakta öne çıkan yaklaşım | hiVelzon için çıkarım |
|---|---|---|
| [Duolingo Adventures](https://blog.duolingo.com/adventures/) ve [Video Call](https://blog.duolingo.com/video-call/) | Oyun benzeri gündelik görevler ve karakterle konuşma pratiği | Hikâye/oyun tek başına benzersiz değil. Senin farkın sürekli Türkçe bağlantılı evren ve bağlamdan tekrara geçiş olmalı |
| [Busuu Study Plan](https://help.busuu.com/hc/en-gb/articles/16097312171153-What-s-a-Study-Plan-How-do-I-make-one) ve [Community](https://www.busuu.com/en/how-to/help-others) | Hedefe göre çalışma planı, yazılı üretime insan geri bildirimi | Bir sonraki içeriği sunmanın ötesinde kullanıcının hedefi ve üretimi görünür olmalı; bunun için hemen sosyal ağ kurman gerekmez |
| [Babbel konuşma pratiği](https://support.babbel.com/hc/en-us/articles/360037872051-Practising-speaking) | Konuşmayı ders ve tekrarın içine dağıtma | Sende Söyle'nin farklı yerlere dağılması doğru. Eksik adım, duyduğunu taklit etmekten kendi cevabını kurmaya geçiş |
| [Speak Tutor](https://help.speak.com/en/articles/11396739-what-is-speak-tutor) ve [Made For You](https://help.speak.com/en/articles/11565779-what-are-made-for-you-custom-lessons) | Gerçek yaşam konuşmaları, kullanıcıya ve hatalarına göre etkinlikler | Hi yalnızca mevcut etkinlik seçmesin; aynı hataya yönelik farklı bağlamda kısa pratik sunabilsin |
| [Praktika](https://praktika.ai/blog/learning-english-with-an-ai-tutor-how-it-works) | Avatarla konuşma, kişiselleştirilmiş plan ve geri bildirim | Karaktere bağlanmanın değeri var; pahalı avatar sayısını artırmak yerine Alex/Maya ile kısa görevleri tamamla |
| [ELSA](https://elsaspeak.com/en/faqs/how-does-elsas-pronunciation-feedback-work) | Sesler, vurgu ve tonlama hakkında ayrıntılı telaffuz geri bildirimi | Mevcut kelime eşleştirmesini telaffuz değerlendirmesi gibi sunma; teknik olarak farklı problemler |
| [LingQ](https://www.lingq.com/en/learn-english-online/) | Ses ve metin, bağlam içinde kelime, SRS ve içerik içe aktarma | Kitaplık + Defter güçlü bir yön. Şimdilik sınırsız içe aktarma yerine mevcut içeriklerde iyi bağlam ve tekrar öncelikli |
| [Beelinguapp](https://beelinguapp.com/) | Paralel metin, sesli okuma, sözlük ve hikâye sonu quiz | Okuyucunun temel yaklaşımı yerinde; kısa anlama ve hatırlama kontrolüyle döngüyü tamamla |
| [Memrise](https://www.memrise.com/) | Gerçek konuşmacı videoları, aksan ve doğal ritim, tekrar/taklit | Sentetik hikâye seslerine ek olarak ileride az sayıda izinli gerçek konuşma örneğiyle aktarımı sınamak değerli |

Bu örneklerin bütün özelliklerini eklemek gerekmiyor. Senin için ortak ders: anlaşılır bir öğrenme yolu, düzenli üretim, işe yarayan geri bildirim ve yeni bağlamda başarı kontrolü.

**4. Öncelikli eksikler ve yanlışlar**

**P0 — Konuşma eşleştirmesi anlamı tersine çeviren cevabı doğru sayabiliyor.**

`mobile/lib/shared/speech/speech_match.dart` içindeki `compare`, eksik kelime yoksa fazladan kelimelere rağmen `full` verebiliyor. Gerçek Dart çıktısı:

```text
Beklenen: I can help you.
Duyulan:  I can not help you.
Sonuç:    full; extra=[not]; missing=[]

Beklenen: I agree.
Duyulan:  I do not agree.
Sonuç:    full; extra=[do, not]; missing=[]
```

Bu sonuç FSRS tarafında Good/Easy değerlendirmesine de gidebilir. Öneri: ad/yer eklemek gibi izinli uzatmaları, olumsuzluk ve anlam değiştiren eklerden ayır. Tanıma belirsizliğinde kullanıcıyı hatalı ilan etme; “Bir kez daha deneyelim” veya dokunarak seçme sun. Mevcut kapsamlı testler bu pedagojik hatayı yakalamamış; olumsuzluk, modal, sayı ve kelime sırası için anlam odaklı sınama örnekleri eklenmeli.

**P1 — Seviye sonucu ana deneyimi yeterince değiştirmiyor.**

`seasonMapProvider` sezonları sıralayıp ilkini seçiyor; yerleştirme seviyesini kullanmıyor. Kitaplık ve dilbilgisi ise önerilen seviyeyi kullanıyor. Ürün sonuç ekranında A1 hikâyesinin kolay gelebileceğini dürüstçe söylüyor; yine de B2 çıkan kişiyi ana sayfada A1'e yöneltmek değeri azaltıyor. Bu bilinçli MVP sınırı; genel bir seviye uyarlamasıymış gibi sunulmamalı.

Öneri: başlangıç seviyesindeki kullanıcıda hikâyeyi, ileri kullanıcıda seviyesine uygun kitap + kısa üretim görevini birincil yap. Hikâyeyi merak eden ileri kullanıcı için isteğe bağlı kısa özet/kolay sahneleri hızlı geçme daha sonra düşünülebilir. Her bölümü altı seviyede yeniden üretmek gerekmiyor.

**P1 — Tamamlamak, hatırlamak ve kullanabilmek ayrı kaydedilmeli.**

Profil ve haftalık özet ağırlıkla eklenen/tekrar edilen ifade ve bitirilen bölüm sayıyor. Dilbilgisi ilerlemesi kartlara göre, kitap ilerlemesi sayfaya göre hesaplanıyor. Bunlar içerik ilerlemesi için uygun; dil ustalığını kanıtlamaz. Dilbilgisinde alıştırmaları geçmek mümkün ve ders sonundan tamamlandı yazılabiliyor. Geçişi açık tut; fakat bunu “öğrendi” olarak yorumlama.

Öneri: “Gördün”, “yardımla yaptın”, “yeni örnekte bağımsız kullandın”, “birkaç gün sonra hatırladın” ayrımı ekle. Kullanıcıya sahte hassasiyette yüzde vermek yerine “Yol sorabiliyorsun; saat ifadelerini yeniden çalışalım” gibi kanıta dayalı küçük kazanımlar göster.

**P1 — Bağımsız konuşma ve yazma üretimi sınırlı.**

Tek kelime yazma, kelime dizme ve beklenen cümleyi söyleme mevcut. Bunlar serbestçe cümle kurma ve karşılıklı etkileşimle aynı beceri değil. Ana Konuş ekranı hâlâ “yakında”.

Öneri: önce sınırlı, öğretmen onaylı 3–5 turluk sahneler: kafede sipariş, yön sorma, yeni komşuyla tanışma. Aynı anlam için birkaç doğal yanıt kabul et. Ardından 1–2 cümlelik mesaj yazma: “Maya'ya geç kalacağını yaz.” Açık uçlu cevabı güvenilir değerlendiremiyorsan model cevap ve öz değerlendirme sun; doğruymuş gibi kesin puan verme. Serbest AI sohbeti mevcut yaş ve bütçe kararlarına göre sonraki fazda kalabilir.

**P1 — Hafıza ölçümü ile dinleyip taklit etme aynı kart durumuna karışıyor.**

Tekrar görevi türü kart geçmişine göre seçiliyor. Aynı FSRS kartı resimden seçme, dinleyip İngilizce yazıyı seçme, dizme ve dinle-söyle sonuçlarıyla güncelleniyor. Oysa seçenekten tanıma, sesi ayırt etme ve Türkçe niyetten İngilizce üretme farklı görevler. Özellikle hedefi dinledikten sonra söylemek hatırlamadan çok taklit başarısı gösterebilir. FSRS kullanmak tek başına bu farkı çözmez.

Öneri: önce pratik başarısı ile hatırlama kontrolünü ayır; destekleri kaydet. Yeni bağlamdaki yardımsız üretim başarısını özellikle izle. Hızdan otomatik Hard/Easy verme kuralları da okuma hızı ve erişilebilirlik etkileri için pilotta sınanmalı. Hemen bütün kartları ayrı beceri başına çoğaltmak şart değil.

**P1 — Yerleştirme testi kaba yönlendirme; beceri profili değil.**

Gerçek bankanın durumu APPROVED; kod yorumlarında kalan TASLAK ifadeleri güncel değil. Ancak seviye başına aynı dört madde ve dinleme olmaması nedeniyle kalibrasyon sınırlı. Örneğin B1 kelime maddesi “I can't ___ my keys” çok kolay çeldiricilerle sunuluyor. C1'de bazı yapıları tanımak C1 düzeyinde etkileşim göstermek anlamına gelmez. Kendisini C1 seçip o basamakta çok zorlanan kullanıcı yalnızca bir alt seviyeye düşürülüyor; alttaki basamaklarla yeterince doğrulanmıyor.

Öneri: testi atlanabilir tut, ilk kullanımın önüne koyma. İlk üç oturumdan gelen sonuçlarla öneriyi güncelle. Başlangıçta gerçekçi bir alt/üst sınır doğrulaması, paralel madde havuzu ve birkaç kısa dinleme maddesi ekle. CEFR'yi yalnızca nadir kelime ve karmaşık gramer listesiyle eşitleme.

**P1 — Hi'nin öncelik sırası ve ana sayfa birbirinden kopabiliyor.**

Koç yarım bölümü her şeyden önce öneriyor; sonrasında tekrar ve hata notu geliyor. Uzun süre yarım kalan bölüm diğer ihtiyaçların önüne geçebilir. Sıradaki bölüm ve okunmamış kitap seçenekleri dilbilgisi önerisinden önce; böylece ilgili gramer önerisi uzun süre görünmeyebilir. Ana sayfanın birincil kartı ise koçun seçimine göre değil, hikâye haritasına göre kuruluyor.

Öneri: tek bir “bugünün planı” kararını hem ana sayfa hem Hi kullansın. Son önerinin reddi, uzun süre ilerlememe, tekrar borcu ve gerçek hata ihtiyacını dikkate al. Gerekçeli kural motorunu koru; bunun için LLM zorunlu değil.

**P2 — Bilgi mimarisi öğrenme araçlarını saklıyor.**

Hikâye başlığının içinde Macera, Kitaplık ve Dilbilgisi var. Defter ve konu setleri Profil altında. Çalışmayan Konuş ise ana navigasyonda. Öğrenme aracı arayan kişi Profil'e bakmayı düşünmeyebilir.

Öneri: bugünkü özelliklerle “Ana Sayfa · Öğren · Pratik · Profil” gibi dört giriş prototipini kullanıcıyla dene. Öğren'de Macera/Kitaplık/Dilbilgisi; Pratik'te Tekrar/Söyle/Konu setleri. Keşfet'i Öğren içindeki ikincil giriş olarak dene. Bu öneri navigasyon kararını otomatik değiştirmek değil; mevcut yapıyla görev bulma testinde karşılaştırmak içindir.

**P2 — Destek, yeni bağlam testiyle dengelenmeli.**

Türkçe altyazı, sayfa çevirisi, ipucu ve örnek ses başlangıç için iyi. Kullanıcı hep bu desteklerle ilerlerse bağımsız anlamayı ölçemezsin. Çeviriyi kaldırma; önce kısa deneme, ihtiyaçta yardım, sonra başka bir cümleyle yeniden deneme sun. Kitap sonunda 2 anlama sorusu + bir kısa yeniden anlatma önerisi yeterli olabilir; her sayfayı quiz ile kesme.

**P2 — İçerikte doğal dil ve açıklama doğruluğu denetimi gerekiyor.**

Örnek A1 kitap metninde “Her heart is fast” ve “live on floor four” anlaşılır ama hedef kullanım ve doğallık açısından editörün yeniden değerlendirmesine değer. Bunlar otomatik olarak dilbilgisi hatası sayılmamalı; “Her heart beats fast” ve bağlama göre “on the fourth floor” gibi seçeneklerin düzey maliyeti tartılmalı. Üçüncü tekil -s dersindeki “Türkçede fiil her kişide ek alır ... o için çoğu zaman eksizdir” açıklaması kişi eki ile zaman ekini karıştırabilecek kadar sıkıştırılmış. İçerik lint'i bu tür açıklama sorunlarını yakalamaz.

Öneri: en az ilk A1 ünitesinde öğretmen/editör; doğal İngilizce, Türkçe açıklama doğruluğu, çeldirici kalitesi, çeviri ve görsel-anlam ilişkisini birlikte denetlesin. Kaynakta `skills: spoken_interaction` yazması gerçek etkileşim çalışıldığına tek başına kanıt sayılmasın.

**5. Fazla olan ne? Şimdilik ne eklememeli?**

- **Kapsam genişliği:** Hikâye oyunu, kitap uygulaması, gramer kursu, kısa video akışı ve AI öğretmeni aynı anda büyütmek fazla. Mevcut içerikleri silme; geliştirme ve kalite odağını ilk 7 günlük A1 deneyimine ver.
- **Boş ana sekme:** Konuş çalışana kadar ana navigasyonda maliyeti yüksek. Mevcut Söyle alıştırmalarını gerçekten kullanılabilir bir Pratik girişinde topla veya yakında ekranını ikincil yap.
- **Birbiriyle yarışan koleksiyonlar:** Defter, ipucu panosu, albüm ve konu setleri aynı ağırlıkta sunulmamalı. Hikâye koleksiyonu isteğe bağlı; tekrar ve pratik kolay bulunur olsun.
- **Süsleme için yeni üretim:** Daha fazla jenerik, avatar, mikro animasyon veya kitap kapağı, öğrenme döngüsündeki açığı kapatmayacak. Mevcut görsel kimlik yeterli bir temel.
- **Şimdilik ekleme:** lig/XP rekabeti, enerji/can, sosyal akış ve açık mesajlaşma, sınırsız AI sohbeti, güvenilirliği sınanmamış telaffuz yüzdesi, sertifika vaadi, her bölümün altı seviyelik kopyası ve kullanıcı içeriği yükleme sistemi.
- **İleri seviye üretimi:** 30 kitap ve 71 ders zaten var. İlk hedef kullanıcıda öğrenme ve geri dönüş görülmeden yeni C1/C2 dalgaları başlatma.

Keşfet'i doğrudan gereksiz saymıyorum: öğrenilen ifadeleri yeniden görme veya hikâyeye giriş işlevi olabilir. Ancak ana menüde bağımsız sekme olmasını, klipten bölüme geçiş ve öğrenme katkısıyla gerekçelendir. Sonsuz olmayan, baskısız tasarımını koru.

**6. En değerli eklemeler — önerilen sıra**

| Öncelik | Yapılacak iş | Başarı kanıtı |
|---|---|---|
| İlk | Olumsuzluk ve anlam değişimi eşleştirme hatasını düzelt | Yukarıdaki ters anlamlı cevaplar full olmuyor; izinli doğal ekler yanlış cezalandırılmıyor |
| İlk | Tek günlük plan: kısa tekrar → sahne/okuma → bağımsız görev | Kullanıcı ilk ekranda ne yapacağını açıklayabiliyor ve başladığı işi tamamlıyor |
| İlk | İlk yedi günlük dar deneyim ve somut kazanımlar | Yeni örneklerde ertesi gün/hafta yardımsız başarı ölçülebiliyor |
| Sonra | Seviyeye göre ana öneri ve hedef seçimi | İleri kullanıcı gereksiz A1 yoluna zorlanmıyor; hedefe uygun etkinlik buluyor |
| Sonra | Üç kısa karakter konuşması + kısa mesaj yazma | Sadece modeli tekrar etmeden görevi farklı cevapla tamamlayabiliyor |
| Sonra | Kitap sonu kısa anlama/hatırlama kontrolü | Okunan sayfa sayısından ayrı anlama verisi oluşuyor |
| Sonra | Düşük bağlantı dayanıklılığı, en az tekrar ve son açılan metin | Ağ kesildiğinde kullanıcı öğrendiklerine erişebiliyor; tam video indirme sonraki fazda kalabilir |
| Daha sonra | Gerçek konuşmacı çeşitliliği ve doğrulanmış telaffuz desteği | Sentetik ders dışındaki sesleri anlama artışı ve Türk aksanında güvenilir geri bildirim |

Tam çevrimdışı çalışma mevcut kararda sonraki fazda. Önerim bunu tüm videoları indirme projesine çevirmeden, düşük maliyetli metin/tekrar dayanıklılığıyla yeniden değerlendirmek.

**7. İlk pilotta neyi ölçmelisin?**

Önce 5 kişiyle gözlemli kullanılabilirlik testi: ilk sahneyi açma, bir ifadeyi kaydetme, tekrarı bulma, kitabı açma ve yardıma ulaşma. Ardından örneğin 15–20 A1/A2 kullanıcıyla 7–14 günlük yön gösterici pilot. Bu sayı bilimsel etkililik kanıtı veya istatistiksel güç garantisi değildir.

Ölçümler:

- İlk açılıştan ilk anlamlı cevaba kadar süre ve ilk oturumdan ayrılma noktası.
- İlk bölüm ve ilk bağımsız üretim görevi tamamlama; kullanılan yardım sayısı.
- Aynı hedef ifadeyi başka bir sahnede hemen, ertesi gün ve bir hafta sonra kullanabilme.
- D1/D7 dönüş ve dönen kullanıcının gerçekten yaptığı etkinlik; salt ekran süresi değil.
- Dinlediğini anlayıp kendi cümlesini kurma arasındaki fark.
- Konuşma tanımasının doğru cevabı reddetmesi ve yanlış cevabı kabul etmesi; özellikle Türk aksanı ve gerçek Android cihazlar.
- Gerçek cihazda açılış/bölüm bekleme, ses-yazı uyumu, çökme ve ağ kesilmesi davranışı.

İçerik metni, ham ses ve konuşma yazısı toplamadan olay türü, süre, yardım kullanımı ve başarı sonucu gibi asgari verilerle başla; mevcut veri minimizasyonu kararlarını koru. Başlangıç verisini gördükten sonra hedef eşikleri koy. Rakiplerin pazarlama oranlarını kendi başarı eşiğin gibi kullanma.

**8. Ürün ve sürdürülebilirlik kararı**

Ücretsiz, reklamsız deneyim kullanıcı açısından güçlü. Yine de mevcut 300 USD/ay AI tavanı toplam işletme bütçesi değil: medya aktarımı, barındırma, içerik editörlüğü, destek ve üretim zamanı ayrıca hesaba katılmalı. Şimdi abonelik eklemen gerektiği sonucu çıkmıyor; bu maliyetlerin kim tarafından ve hangi kullanım ölçeğine kadar karşılanacağını görünür kılman gerekiyor. Serbest AI konuşmasını ölçeklemeden önce tamamlanan pratik oturumu başına gerçek maliyeti ölç.

**Son kararım:** mevcut tasarımı veya hikâyeyi baştan yapmak gerekmiyor. Önce yanlış olumlu konuşma geri bildirimini düzelt; ardından hikâye, kitap, gramer ve tekrarın üstüne tek bir günlük plan ve küçük bağımsız başarı kontrolleri koy. Yeni içerik hacminden daha yüksek getiriyi bu bağlantılar ve gerçek kullanıcı pilotu sağlayabilir. Bu getiri değerlendirmesi, ürün incelemesine dayalı çıkarımdır; kullanıcı verisiyle henüz doğrulanmış değildir.
