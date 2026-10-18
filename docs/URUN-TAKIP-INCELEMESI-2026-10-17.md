**hiVelzon — önceki inceleme sonrası takip değerlendirmesi, 17 Ekim 2026**

İncelenen sürüm: `3fc9c3a`. Başlangıçta çalışma ağacı temizdi. Önceki `URUN-INCELEMESI-2026-10-15.md` raporundaki bulgular; H-087, H-088, H-089, H-090, H-091 ve H-093 değişiklikleri, güncel kod, içerik paketleri ve golden ekranlarıyla karşılaştırıldı. Uygulama kodu değiştirilmedi.

**Genel karar**

Önceki rapora doğrudan karşılık veren, önemli ürün değişiklikleri yapılmış. Günlük öneri artık tek kaynaktan geliyor; B1+ kullanıcıya kitap önceliği var; taklit/hatırlama ayrılmış; Konuş sekmesi kullanılabilir görevler içeriyor; kitap sonlarına anlama soruları gelmiş. Önceki değerlendirmenin “bu özellik yok” bulgularının çoğu artık geçerli değil.

Kalan asıl sorun, yeni başarı/kanıt etiketlerinin hangi koşullarda yazıldığı. Sistem bazı ters anlamlı veya destekle üretilmiş cevaplardan bağımsız başarı sonucu çıkarabiliyor. Yeni özellik eklemeden önce bu ölçüm kurallarını düzeltmek daha değerli.

**Önceki bulguların durumu**

| Önceki bulgu | Güncel durum | Karar |
|---|---|---|
| “I can help” / “I can not help” tam eşleşmesi | `changedWords` ile engelleniyor; ayrı Dart denemesinde Again | Önceki örnek düzeldi; eksik olumsuzluk sorunu aşağıda |
| Ana Sayfa ve Hi farklı öneriyor | `dailyPlanProvider` ve `planToday` ortak | Çözüldü |
| B2 kullanıcıya A1 ana önerisi | İleri kullanıcıda kitap öncelikli, hikâye ikincil | Büyük ölçüde çözüldü; en son yarım kitabın seviyesine ayrıca dikkat |
| Yarım bölüm diğer ihtiyaçları bastırıyor | 7 gün, uzun ara, günlük ret ve tekrar öncelikleri eklenmiş | Ana mantık iyileşti; eşikler kullanıcı onaylı, pilotta ölçülmeli |
| Defter Profil'de saklı | Ana Sayfa'da Defter ve Kelime tekrarı girişleri | Çözüldü |
| Konuş sekmesi yer tutucu | 3 sahne + 3 kısa mesaj; dokunma alternatifi var | Çözüldü; altı görev paketinde DRAFT, editör kontrolü açık |
| Taklit FSRS başarısı sayılıyor | Pratik not yazmıyor; hatırlama ayrı soru | Büyük ölçüde çözüldü |
| Yalnız etkinlik sayısı var | Kanıt basamakları, Profil ve haftalık özet | Uygulandı; doğruluk sorunları aşağıda |
| Kitap sonu anlama yok | 30 kaynak ve 30 dışa aktarılmış kitapta ikişer soru | Çözüldü; yeniden anlatma kaydı aşağıda |
| Seviye testi sınırlı | Dört madde/basamak; dinleme yok; tek basamak geri düşme devam ediyor | Açık; başlangıç önerisi olarak sunulması doğru |
| Gerçek kullanıcıyla öğrenme kanıtı yok | H-092 hâlâ yapılacak | Açık |
| Çevrimdışı dayanıklılık/gerçek cihaz | Bu turda yeni canlı doğrulama yapılmadı | Kapanmış sayılmadı |

**Öncelikli bulgular**

**1. [P1] Olumsuzluk çıkarılınca ters anlamlı cevap hâlâ başarılı hatırlama sayılıyor.**

Yer: `mobile/lib/shared/speech/speech_match.dart` ve `mobile/lib/features/notebook/domain/review_policy.dart:254`.

Güncel kodla yeniden üretildi:

```text
I can help you. <- I can not help you.
close; changed=[not]; rating=Again          (düzeldi)

I agree. <- I do not agree.
close; changed=[not]; rating=Again          (düzeldi)

I can't hear you. <- I can hear you.
close; missing=[can't]; changed=[]; rating=Hard

I am not late. <- I am late.
close; missing=[not]; changed=[]; rating=Hard
```

`changedWords` fazla kelimelerden türetiliyor; eksik olumsuzluk anlam değişimi sayılmıyor. `rateSpeech` changedWords boş olan close sonucunu Hard yapıyor. Ekran da Again olmayan notu `correct: true` kabul ediyor. Uzun vade kartında `EvidenceRules.fromResult` bundan own_use ve şartlar uygunsa recalled_later çıkarabiliyor. Yani sonuç artık “tam” olmasa bile ters anlam olumlu öğrenme kanıtına dönüşebiliyor.

Öneri: olumsuzluk, modal ve miktar gibi anlam açısından kritik kayıpları/yer değiştirmelerini de denetle. Tanıma belirsizliğinde cezalandırmadan yeniden deneme veya not vermeden geçme sun; belirsiz veya ters anlamlı cevaptan olumlu kanıt üretme. Yeni Konuş sahnelerinin yalnız `full` kabul etmesi bu örnekleri orada engelliyor; bulgu özellikle kelime hatırlama ve pratik başarı kaydıyla ilgili.

**2. [P1] Mesaj kontrolü anlamı doğrulamadan görev ve kendi kullanım kanıtı yazabiliyor.**

Yer: `mobile/lib/features/talk/domain/talk_match.dart:128,158`, `mobile/lib/features/talk/presentation/talk_message_view.dart:67` ve ilgili görev JSON'ları.

Gerçek görev içerikleriyle yeniden üretildi:

| Görev | Girilen cevap | Sonuç |
|---|---|---|
| Maya'ya geç kaldığını yaz | `Sorry late` | Geçti; hedef ifade bulunmadı |
| Maya'ya geç kaldığını yaz | `Sorry, I am early. Maya is late.` | Geçti; `Sorry, I'm late.` kullanılmış sayıldı |
| Telefonuna yer/gün/saat notu | `Friday seven` | Geçti; yer ve gerekli yapılar yok |
| Telefonuna yer/gün/saat notu | `On Friday at seven. Pier 99.` | Geçti; yanlış yer denetlenmiyor |
| Maya'ya geç kaldığını yaz | `Sorry, I'm late. I will never do it again.` | Reddedildi; tüm mesajdaki `never` yasak |

İkinci örnekte kişi aslında erken geldiğini söylüyor; `usesPhrase` sözcükleri farklı cümlelerden alt dizi olarak birleştirdiği için “Sorry + I + am + late” buluyor. Ekran bunu `recordUse(... own: true)` ile kaydediyor; hedef ifade Defter'deyse yanlış own_use kanıtı oluşuyor.

Öneri: anahtar kelime bulunmasıyla görevin anlamının tamamlanmasını ayır. Küçük kapsamda kabul edilen cümle/yanıt şablonlarını cümle sınırları, özne, olumsuzluk kapsamı ve görevdeki yer/saat ile birlikte kontrol et. Güvenilir değerlendirme yapılamayan özgür cevapta mevcut örnek cevap + öz değerlendirme yolunu kullan; otomatik own_use yazma. Bunun için serbest AI sohbeti eklemek gerekmiyor.

**3. [P1] Mesajda örnek görüldükten veya kelime ipucu alındıktan sonra cevap hâlâ yardımsız sayılabiliyor.**

Yer: `mobile/lib/features/talk/presentation/talk_message_view.dart:51,178,239`.

Kod akışı: yanlış cevap → örnek mesajı aç → “Yeniden dene” → örneği yazarak gönder. `_send` her geçen cevapta koşulsuz `own: true` yazıyor; örnek veya ipucu görülmesini izleyen kalıcı bir destek bayrağı yok. Sahne ekranında ise `_sawHelp` ile bu ayrım doğru kurulmuş.

Öneri: mesajda da görev denemesi boyunca yardım geçmişini koru. Örnek/cevabı açığa çıkaran ipucu görüldüyse sonraki doğru cevap helped sayılsın. Yeni ve desteksiz bir görevde own_use kazanılabilsin. Sayfayı kapatıp örneği ezberleyerek dönmeyi kusursuz biçimde önlemek gerekmiyor; aynı ekrandaki açık yardım akışını doğru sınıflamak yeterli başlangıç.

**4. [P2] Kitabı yalnız açmak, günlük okuma adımını tamamlanmış saydırabiliyor.**

Yer: `mobile/lib/features/library/presentation/reader_screen.dart:167`, `mobile/lib/features/hi/application/hi_providers.dart:170`.

İlk kitap açılışı hemen `savePosition` yapıyor. `_coachBooks` bu güncellenme anını `lastRead` olarak alıyor. `mainDoneToday` yalnız bunun bugün olmasına bakıyor. Kullanıcı kitabı açıp hiçbir şey okumadan geri dönerse ana adım yapılmış kabul edilebilir ve küçük görev öne geçer.

Öneri: “kitap açıldı” ile “anlamlı okuma/dinleme yapıldı” olaylarını ayır. Aktif okuma süresi, sayfa/cümle ilerlemesi veya kısa bölüm tamamlama gibi bir işaret kullan. Kesin süre eşiğini pilotla belirle; şimdiden keyfî bir süreyi öğrenme ölçüsü yapma.

**5. [P2] Örnek özeti açmak, yeniden anlatma yapıldı diye saklanıyor.**

Yer: `mobile/lib/features/library/presentation/widgets/comprehension_view.dart:99`.

`retellDone: _modelShown || _selfCheck != null` nedeniyle kullanıcı hiçbir şey yazmadan, anlatmadan ve kendini değerlendirmeden yalnız örnek özeti açarak retellDone=true oluşturabiliyor. Kullanıcının gerçekten sesli anlatıp anlatmadığını uygulama bilemez; fakat örnek gösterimini üretim olarak kaydetmek gerekmiyor.

Öneri: modelViewed, retellAttempted/retellSelfReported ve selfCheck alanlarını anlamlarıyla ayır. Sözlü anlatım için kullanıcının “Denediğim anlatımı karşılaştırdım” beyanı kullanılabilir; bunu nesnel dil başarısı gibi sunma. İki soru ve ilk deneme doğruluğunun ayrıca tutulması olumlu.

**Pedagojik olarak açık kalan nokta**

Defterde aynı görsel ve Türkçe anlamdan ifadeyi üretmek, yardımsız geri çağırmaya kanıt olabilir. Ancak otomatik olarak “yeni bir durumda kullandı” anlamına gelmez. Yeni Konuş sahneleri gerçek bağlam çeşitliliğine daha yakın. Ürün etiketlerinde “yardımsız hatırladı” ile “başka görevde kullandı” ayrımını korumak daha dürüst olur. `selfCheck` de açıkça kullanıcının beyanına dayalı; nesnel denetlenen cevapla aynı güçte kanıt sayılmamalı.

İlk hafta akışı şu an ana olarak öneri önceliği ve gün gerekçesi üzerinden kuruluyor; yedi güne yayılmış ayrı gecikmeli aktarım görevlerinin tamamı henüz kanıtlanmış değil. Bu, iyi bir başlangıç; H-092'de aynı ifadelerin ertesi gün ve bir hafta sonra farklı görevde kullanılmasını ayrıca ölçmek gerekiyor.

**Ekran değerlendirmesi**

Yeni golden görüntülerinde B2 kullanıcının ilk kartında seviyesine uygun kitap, hikâyede “isteğe bağlı” etiketi görülüyor; önceki geri bildirime net karşılık. Defter/tekrar Ana Sayfa'da bulunabiliyor. Konuş ekranında söyle/seç/diz/geç alternatifleri anlaşılır; kitap soruları okuma akışını bölmeden sona eklenmiş.

A1 Ana Sayfa'da selam, öneri cümlesi, plan başlığı, adım çipleri, büyük görsel, bölüm ilerlemesi ve gerekçe üst üste gelince çalışma araçları ilk ekranın altına düşüyor. Öncelik bu turda doğru; küçük düzenleme olarak gerekçeyi tek kısa satıra indirip ayrıntısını açılır yapmak ve görseli kısaltmak pilotta sınanabilir. Konuş girişindeki büyük teknik açıklama kartı da sadeleştirilebilir. Yeni menü düzenini pilot öncesi zorunlu değişiklik saymıyorum.

**Doğrulama**

- `flutter analyze`: sorun yok.
- Mobil testler: 1.130 test geçti; önceki incelemede 956 idi. Test sayısındaki artış öğrenme etkililiğinin kanıtı değildir.
- İçerik boru hattı testleri çalıştırıldı. İlk turda yalnız kitap/dilbilgisi yerel HTTP sunucu testleri sandbox port bağlama izni yüzünden başarısız oldu; aynı iki test izinli yeniden çalıştırmada geçti.
- Ayrı küçük Dart programıyla önceki iki konuşma örneği, eksik olumsuzluk ve yukarıdaki mesaj örnekleri gerçek güncel fonksiyonlarla yeniden üretildi.
- 30 kaynak ve 30 paket kitabın hepsinde iki anlama sorusu bulundu. Sezon paketindeki 6 Konuş görevi mevcut; hepsi DRAFT etiketi taşıyor.
- Gerçek telefon, canlı mikrofon, iOS/Android uçtan uca akış, backend entegrasyon testleri ve bütün içeriklerin öğretmen kontrolü bu turda yapılmadı.

**Önerilen sonraki adım**

Yeni özellik eklemeden önce 1–3 numaralı kanıt doğruluğu sorunlarını düzelt; ardından günlük tamamlanma ve yeniden anlatma kayıtlarını ayır. Sonra H-092 kullanılabilirlik/pilot çalışmasına geç. Mevcut değişikliklerle temel ürün yönü belirgin biçimde iyileşmiş; şimdi başarıyı doğru saymak ve gerçek kullanıcıda görmek gerekiyor.
