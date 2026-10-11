# HiVelzon Storyworld — Hikâye Tabanlı Oyunlaştırılmış İngilizce Öğrenme
**Ürün planı ve Codex şartnamesi | 1.0 | 11 Ekim 2026**

> **Depo notu (2026-10-11):** Bu belge kullanıcı tarafından sohbete yapıştırıldı ve olduğu gibi kaydedildi. Var olan kararlarla birleştirilmiş tasarım ve çelişkiler `docs/OYUN-TASARIMI.md`'dedir (H-029).

> **Karar önerisi:** HiVelzon'un ana öğrenme deneyimi, birbirinden bağımsız derslerden oluşan bir katalog değil; ana karakteri, devam eden gizemi, görevleri ve bölüm sonu merak unsurları olan bir hikâye evreni olmalıdır. Her bölüm İngilizce öğrenme hedefi taşır. Hikâye merak uyandırır; dili kullanmak ise hikâyeyi ilerletir.

**Bu belge planlama içindir.** Codex önce repository'yi ve mevcut proje planlarını incelemeli, uygulama planı hazırlamalı ve kullanıcı onayı beklemelidir. Onay öncesi kodlama, migration, ücretli AI çağrısı, video/görsel üretimi veya yayın yapılmamalıdır.

## 1. Araştırma: ne öğreniyoruz?

### Duolingo Adventures
Duolingo, Adventures özelliğini oyuncunun karakterlerin dünyasında gerçek hayattaki görevleri tamamladığı, mekânları keşfettiği ve karakterlerle konuştuğu oyun benzeri bir deneyim olarak anlatıyor. Bağlamdan kelime çıkarma ve yanlışta konuşmayı kesmeden yönlendirme önemli tasarım örnekleri.

Kaynak: https://blog.duolingo.com/adventures/

**HiVelzon'a uyarlanacak:** görev odaklı sahneler, karakterlerle diyalog, çevresel ipuçları, doğal geri bildirim, karakter ilişkilerinin zamanla gelişmesi.

**Kopyalanmayacak:** Duolingo karakterleri, hikâyeleri, görsel dili, diyalogları veya markalı evreni. HiVelzon özgün karakterler ve kendi hikâye dünyasını oluşturmalıdır.

### Araştırma bulguları
- 2025 meta-analizi mobil oyunların dil öğrenme çıktılarında genel olarak olumlu etkiler bildirdi; sonuçlar becerilere ve çalışma koşullarına göre değişebilir.
- 2025 tarihli bir çalışmada AI destekli etkileşimli hikâye grubu kelime testlerinde daha iyi sonuçlar bildirdi; bu, tek başına bütün ürünlerde aynı etkinin oluşacağını kanıtlamaz.
- 2026 tarihli bir çalışma, hikâye unsurunun katılımın bazı boyutlarına katkı sağlayabileceğini, ancak her durumda genel performans artışının garanti olmadığını bildiriyor.

Kaynaklar:
- https://www.tandfonline.com/doi/full/10.1080/09588221.2025.2528786
- https://www.sciencedirect.com/science/article/pii/S2666920X25001456
- https://research.hacettepe.edu.tr/en/publications/story-in-gamification-enhancing-engagement-for-socializer-and-kil/
- https://link.springer.com/article/10.1186/s12909-025-06822-7

**Ürün sonucu:** hikâye tek başına pedagojik yöntem değildir. Her bölümde CEFR düzeyine uygun hedef dil, aktif hatırlama, görev ve öğrenme kanıtı olmalı. Hikâyenin devam oranı ve dil öğrenme sonuçları ayrı ölçülmeli.

## 2. Ürün fikri: The Missing Signal

**Geçici ad:** *The Missing Signal*  
**Tür:** Gizem, şehir keşfi, arkadaşlık ve modern macera  
**Ana karakter:** Alex  
**Destek karakterleri:** Maya (yerel rehber ve arkadaş), Sam (teknik meraklı), Jordan (bilgileri her zaman tam olmayan tanık)  
**Ana gizem:** Alex, eski bir telsizde şehirdeki farklı insanlara ve mekânlara bağlanan bir mesaj bulur. Her bölüm bir ipucunu çözerken bir sonraki bölümün sorusunu ortaya çıkarır.

Bu yaratıcı konsept bir öneridir; isimler, karakterler ve olay örgüsü seri üretiminden önce onaylanmalıdır. Başka bir eserin karakterleri, olay örgüsü veya görsel kimliği taklit edilmemelidir.

### Hikâye kuralları
1. Ana gizem sezon boyunca ilerler; her bölümde küçük bir cevap ve yeni bir soru vardır.
2. Karakterlerin kişilikleri, bilgileri ve ilişkileri tutarlı kalır.
3. Her bölüm gerçek hayatta kullanılabilir bir İngilizce iletişim hedefi taşır.
4. Kullanıcı hata yaptığında hikâye kalıcı olarak kilitlenmez; ipucu ve tekrar sunulur.
5. Ana olay örgüsü CEFR seviyeleri arasında tutarlı kalır; dil karmaşıklığı seviyeye göre uyarlanır.
6. Her bölüm bağımsız bir mini görevi tamamlar, ancak sezonun genel gizemine bağlıdır.
7. Güvenli, kapsayıcı ve yaşa uygun içerik üretilir.

## 3. İlk sezonun bölüm zinciri

| Bölüm | Olay | Dil hedefi | Kullanıcı görevi | Sonraki bölüme bağlantı |
|---|---|---|---|---|
| 1. A Strange Message | Alex telsizde mesaj bulur | Selamlaşma, basit sorular, talimatlar | Mesajdaki kişiyi ve yeri belirle | Mesajdaki yer adı haritada belirir |
| 2. The New Neighbour | Alex komşudan bilgi ister | Tanışma, kibar soru sorma | Konuşmayla eksik bilgiyi tamamla | Eski istasyonun kapalı olduğu öğrenilir |
| 3. Find the Station | Alex istasyonu arar | Yönler, yer edatları, konumlar | Haritada rotayı seç | Kapıda yarım kalmış not bulunur |
| 4. The Note | Notun bir kısmı okunamaz | Tarih, saat, bağlamdan anlam | Olası anlamları eşleştir | Bir buluşma saati ortaya çıkar |
| 5. Too Late? | Alex buluşma yerine gider | Planlar, saatler, basit geçmiş | Karakterin anlattığını anla | Tanık ayrılmış ama kayıt bırakmıştır |
| 6. The Recording | Ses kaydı incelenir | Dinleme, ana fikir ve detay | Üç ipucunu bul | İsim ve yer bilgisi uyuşmaz |
| 7. Who Knows What? | İki karakter farklı açıklamalar verir | Görüş sorma, karşılaştırma, açıklama | Çelişkili bilgileri ayır | Bir karakter eksik bilgi verdiğini kabul eder |
| 8. The First Reveal | İlk büyük bağlantı kurulur | Önceki hedefleri bütünleştirme | Konuşma + okuma + karar görevi | Sinyalin başka bölgeden geldiği anlaşılır |

Bu tablo sezon taslağıdır, tam senaryo değildir. Bölüm başına kesin uzunluk ve kelime sayısı CEFR ve kullanıcı testleriyle belirlenmelidir.

### Her bölümün üç bağlantı sorusu
- Önceki bölümden hangi olay, nesne, karar veya ilişki devam ediyor?
- Bu bölümde hangi yeni bilgi veya sonuç kazanılıyor?
- Sonraki bölüm için hangi somut soru, hedef veya ipucu ortaya çıkıyor?

“Devamı yarın” tek başına cliffhanger sayılmaz. Yeni bir ses, kayıp not, harita noktası, çelişkili cevap veya çözülmemiş görev gibi hikâyenin içinden gelen bir bağlantı olmalıdır.

## 4. Bölümün iç yapısı

Önerilen deneyim yaklaşık 5–8 dakika; başlangıç hipotezidir ve test edilmelidir.

1. **Cold open (10–20 sn):** Önceki bölümden bir görüntü/ses ve yeni sorunun işareti.
2. **Hikâye videosu (60–120 sn):** Özgün sahne, doğal İngilizce diyalog, İngilizce altyazı.
3. **Anlama kontrolü (30–60 sn):** Ana fikir veya kritik ayrıntı.
4. **Language Lab (60–120 sn):** 3–5 hedef kelime/ifade, kısa açıklama ve bağlam.
5. **Interactive Mission (60–120 sn):** Seçim, konuşma, dinleme, harita veya nesneyle etkileşim.
6. **Evidence Check (30–60 sn):** Hedef dili gerçekten anlayıp anlamadığını ölçen görev.
7. **Clue reveal (10–20 sn):** Yeni ipucu ve sonraki bölüm sorusu.
8. **Review plan:** Kelimeler tekrar listesine eklenir; gerekiyorsa gecikmeli tekrar önerilir.

Süreler sabit zorunluluk değildir. A1'de kısa, net, görsel destekli; B2/C1'de daha doğal, ayrıntılı ve çıkarım gerektiren görevler kullanılmalıdır.

## 5. A1–C1 hikâye uyarlaması

| Seviye | Dil | Görev |
|---|---|---|
| A1 | Kısa cümle, yüksek sıklıklı kelime, açık bağlam | İki seçenek, görsel ipucu, kısa cevap |
| A2 | Günlük diyalog, basit geçmiş/gelecek, neden-sonuç | Bilgi sorma, rota seçme, basit rol yapma |
| B1 | Uzun diyalog, olay özeti, gerekçe | İpucu karşılaştırma, kısa açıklama, konuşma |
| B2 | Doğal konuşma, farklı görüşler, örtük anlam | Kanıt değerlendirme, argüman kurma |
| C1 | Nüans, ima, register, karmaşık çıkarım | Güvenilirlik değerlendirme, uzun yanıt |

Aynı olay örgüsü ve ana gizem tutarlı kalmalı; kelime, cümle karmaşıklığı, konuşma hızı, ipucu miktarı ve görev zorluğu seviyeye göre değişmelidir. AI'ın her kullanıcıya farklı ana hikâye üretmesi kanon tutarlılığını bozabileceğinden MVP'de önerilmez.

## 6. Oyun sistemleri

- **Story Map:** Sezon ve bölüm haritası.
- **Mission Card:** Hikâye hedefi ve İngilizce hedefi.
- **Clue Board:** Kullanıcının bulduğu ipuçları; kısa İngilizce metin veya ses.
- **Inventory:** Hikâyede kullanılan nesneler, belgeler ve öğrenilen ifadeler.
- **Character Trust:** Karakter ilişkileri; anlamlı görev sonuçlarına bağlı, rastgele puan değil.
- **Season Recap:** Olayların ve hedef kelimelerin İngilizce tekrarı.
- **Optional Challenges:** Ana hikâyeyi ilerletmek için zorunlu olmayan ek görevler.
- **Story Mode / Challenge Mode:** Daha fazla yardım veya daha az yardım; ikisi de öğrenme kanıtı toplar.

### Oyunlaştırma sınırları
- Hata yapmak hikâyeyi kalıcı kilitlemez.
- Gün kaçırmak ilerlemeyi silmez.
- Ana hikâye ilerlemesi için ödeme zorunlu olmaz.
- Puanlar gerçek öğrenme görevleriyle bağlantılı olur.
- Streak ve bildirimler cezalandırıcı veya manipülatif olmaz.
- İzlenme süresi tek başına öğrenme başarısı sayılmaz.

## 7. Uygulamada ekranlar

### Ana Sayfa
1. **Continue the Story** — kaldığı bölüm ve devam et.
2. **Your Current Mission** — bugünkü tek net görev.
3. **Previously on HiVelzon** — 10–20 saniyelik özet veya kısa metin.
4. **Clue Board** — bulunan ipuçları ve çözülmemiş sorular.
5. **Quick Practice** — son bölümden 3 kelime/ifade.
6. **Story Clips** — hikâyeden kısa sahneler.
7. **Optional Exploration** — bağımsız katalog.
8. **Progress** — bölüm ilerlemesi ve beceri gelişimi.

### Hikâye haritası
- Bölüm numarası, adı ve kısa görev açıklaması
- Tamamlandı / devam ediyor / kilitli durumu
- Kilitliyse sebebi ve tamamlanması gereken görev
- Sonraki bölümden spoiler vermeyen ipucu
- Sezon ilerlemesi; ancak yalnızca video izleme oranına dayalı değil

### Video oynatıcı
- İngilizce altyazı varsayılan açık
- Türkçe anlam açılıp kapatılabilir
- Hız kontrolü, kelimeye dokunarak anlam, sahneyi tekrar oynatma
- Sahne sonunda aktif görev
- Bölüm bitince otomatik sonsuz oynatma yerine göreve ve sonraki ipucuna yönlendirme

### Görev ekranı
- Görev hedefi
- Hedef İngilizce ifadeler
- Seçim/konuşma/dinleme etkileşimi
- İpucu kullanma
- Sonuç ve açıklama
- Başarısızlıkta kolaylaştırılmış tekrar
- Hikâyeye dönüş

### Profil
- Hikâye bölümü ilerlemesi
- Beceri bazlı seviye tahminleri ve güven düzeyi
- Öğrenilen kelimeler ve tekrar listesi
- Tamamlanan iletişim görevleri
- Haftalık anlamlı öğrenme döngüsü
- Gizlilik, bildirim ve ses tercihleri

## 8. Seviye ve ilerleme: hikâyeye bağlı kanıt

Bir bölümü izlemek tamamlanma sayılabilir; ancak **dil becerisinde ustalık** sayılmamalıdır.

### Bölüm ilerleme koşulları
Bölümün ana kapısı için örnek şartlar:
- Ana fikri veya kritik ayrıntıyı anlama
- Hedef ifadeyi bağlamda tanıma
- En az bir aktif görevde dili kullanma

Kesin puan eşikleri pedagojik testlerle belirlenmelidir. Bir tek yanlış cevapla seviye düşürülmemeli veya hikâye kilitlenmemelidir.

### Başarısızlıkta destek
1. Basit açıklama göster.
2. Altyazı/Türkçe anlam seçeneği sun.
3. Önceki sahneye dön.
4. Hedef ifadeyi örnekle.
5. Daha kolay alıştırma ver.
6. Aynı hedefi yeni cümleyle yeniden dene.

### Kanıt türleri
Quiz doğruluğu, dinleme/okuma anlama, kelimeyi gecikmeli hatırlama, farklı bağlamda kullanım, konuşma görevi tamamlama ve yazma rubriği. Her kanıtta seviye, beceri, deneme, kullanılan ipucu, içerik sürümü, puanlama sürümü ve zaman kaydedilir.

### Öğrenme durumları
`NOT_STARTED`, `IN_PROGRESS`, `PRACTICED`, `COMPLETED`, `NEEDS_REVIEW`, `MASTERED`.

`COMPLETED` bir bölümü bitirmektir. `MASTERED` farklı günlerde ve görev türlerinde kalıcı başarı kanıtı gerektirir.

## 9. Kısa video stratejisi

30 saniyelik klipler hikâyenin içinden seçilir ve tam bölüme bağlanır. Her klip:
- Tek öğrenme hedefi taşır.
- Tek başına anlaşılabilir bağlam sunar.
- İngilizce altyazılıdır; Türkçe anlam isteğe bağlıdır.
- “İfadeyi öğren”, “görevi dene”, “bölümü aç” eylemleri içerir.
- Sezon/bölüm/sahne/sürüm kimliği taşır.
- Telif ve editör onayı tamamlanmış olur.

Ölçümler: klip tamamlama, kelime kaydetme, mini quiz, tam bölüme geçiş, görev başarısı ve kullanıcı bildirimi. Yalnızca izlenme sayısına göre klip seçilmemelidir.

## 10. İçerik üretimi: Story Bible ve yayın

Önerilen klasör:

```text
story/
  STORY_BIBLE.md
  SEASON_01_OUTLINE.md
  CHARACTER_PROFILES.md
  CANON_AND_TIMELINE.md
  LANGUAGE_PROGRESSION.md
  episode-001/
    content.json
    story.en.md
    story.tr.md
    glossary.md
    quiz.md
    mission.json
    scenes.json
    PROMPTS.md
    rights-and-review.md
    audio/
    images/
    clips/
    subtitles/
    final/
```

### Story Bible içeriği
- Dünya ve temel kurallar
- Karakterlerin amacı, kişiliği, konuşma tarzı ve ilişkileri
- Ana gizem, sezon finali ve ipucu sırası
- Kronolojik olay çizelgesi
- Doğrulanmış kanonik gerçekler
- Henüz cevaplanmayan sorular
- Bölüm başına öğrenme hedefleri
- A1–C1 varyantları arasındaki farklar
- Yasaklı içerikler, telif ve güvenlik sınırları

### Yayın hattı
`IDEA → STORY_OUTLINE_APPROVED → SCRIPT_DRAFT → LANGUAGE_REVIEW → PEDAGOGICAL_REVIEW → MEDIA_PRODUCTION → QA → CANON_REVIEW → APPROVED → SCHEDULED → PUBLISHED`

Yalnızca AI tarafından oluşturulmuş metin yayınlanamaz. İngilizce editörü, pedagojik editör ve seri tutarlılığı incelemesi gereklidir. Yayınlanan bölümün üzerine yazılmaz; yeni sürüm açılır. Kritik hata veya telif sorunu varsa geri çekme yapılır.

### Her bölüm için zorunlu metadata
- Bölüm ID, sezon, sıra, önceki/sonraki bölüm
- CEFR ve beceri hedefleri
- İletişim hedefi, kelime/gramer listesi
- Hikâye özeti, önceki olay bağlantısı, sonraki ipucu
- Sahne, video, ses, altyazı varlıkları
- Quiz ve görev başarı ölçütleri
- İçerik sürümü, editör/onaylayan, tarih
- Kaynak/lisans, AI üretim beyanı, güvenlik kontrolü

## 11. Veri modeli taslağı

Önce mevcut repository incelenmeli; mevcut modelle çakışma varsa yeni tablo açılmamalıdır.

- `story_worlds`: evren, slug, durum, kanonik sürüm
- `story_seasons`: evren, sezon numarası, özet, durum
- `story_characters`: karakter profili, konuşma ve görsel profili, onaylı sürüm
- `story_episodes`: bölüm sırası, önceki/sonraki bağlantısı, kanonik özet, cliffhanger
- `episode_level_variants`: bölüm, CEFR, senaryo sürümü, hedef kelime/gramer, inceleme durumu
- `episode_scenes`: sahne sırası, hedef, diyalog ve medya varlıkları
- `story_missions`: görev tipi, öğrenme hedefi, başarı ölçütü, ipucu politikası
- `story_clues`: ipucu, bölüm, açılma koşulu, kanonik sıra
- `user_story_progress`: kullanıcının mevcut bölüm/sahne/durum bilgisi
- `user_episode_evidence`: görev denemesi, sonuç, ipucu sayısı, beceri kanıtı
- `user_story_inventory`: açılan ipuçları ve nesneler
- `story_content_links`: klip, kelime, quiz, konuşma senaryosu ve sahne ilişkileri

## 12. AI ve video üretim bütçesi

- Önce editör onaylı senaryo ve sabit hikâye kanonu kullan.
- Her kullanıcı için sınırsız yeni bölüm veya video üretme.
- Ücretli üretimden önce tahmini maliyet göster ve açık onay al.
- Aylık bütçe tavanı ve durdurma eşiği uygula.
- Prompt, model, parametre, tarih, job ID ve maliyeti `PROMPTS.md`/iş kaydında tut.
- Aynı içeriği gereksiz yere yeniden üretme; varlıkları önbellekle.
- Ucuz varsayılan: sabit görseller + yerel Ken Burns hareketi + TTS + altyazı; hareketli video seçilmiş sahnelerde.
- AI çıktısı dil doğruluğu, telif veya pedagojik uygunluk kanıtı değildir.

## 13. Güvenlik ve telif
- İnternette bulunması yeniden yayınlama izni olduğu anlamına gelmez.
- Rakip uygulama, dizi/film, sosyal medya ve YouTube materyalleri izin/lisans olmadan kullanılmamalı.
- Açık lisansın ticari kullanım ve türev eser şartları doğrulanmalı.
- Kaynak URL, lisans, atıf, kontrol tarihi ve onaylayan kaydedilmeli.
- Karakter, marka ve görsel tasarımlar özgün olmalı.
- Mikrofon izni konuşma özelliği açılırken açıklanmalı.
- Ham ses varsayılan olarak kalıcı saklanmamalı.
- KVKK, yaş hedefi ve mağaza politikaları hukuk/uyumluluk incelemesinden geçmeli.

Google Play Families politikası: https://support.google.com/googleplay/android-developer/answer/9893335?hl=en

## 14. Ölçüm planı

### Hikâye devamlılığı
- Bölüm 1→2, 2→3 ve sezon sonuna geçiş
- Bölüm yarıda bırakma oranı
- “Continue the Story” ile geri dönüş
- Cliffhanger sonrası sonraki bölüme geçiş

### Öğrenme
- Bölüm sonrası anlama
- 1/3/7 gün sonra kelime hatırlama
- İfadeyi yeni bağlamda kullanma
- Konuşma görevini tamamlama
- İpucu kullanımıyla başarı arasındaki ilişki
- Beceri seviyesi için yeni kanıt

### Kalite ve maliyet
- Dil/çeviri hataları
- Kanon tutarsızlığı
- Klipten bölüme geçiş
- Bölüm başına medya maliyeti
- Kullanıcı başına AI konuşma maliyeti
- Editör düzeltme süresi

**Hikâye devam oranı ile öğrenme sonucu ayrı raporlanmalıdır.**

## 15. MVP yol haritası

### Faz 0 — Repository keşfi
`docs/IS-PLANI.md`, `yapilacaklar/IS-SIRASI.md`, mevcut görev klasörleri, auth, içerik, medya, quiz, ilerleme ve admin panelini incele. Başka projeleri yalnızca oku. Kod yazma; plan hazırla ve onay bekle.

### Faz 1 — Hikâye tasarımı
Story Bible, sezon ana gizemi, karakter profilleri, ilk üç bölüm outline'ı ve A1/A2 öğrenme hedefleri. İngilizce editör ve pedagojik inceleme.

### Faz 2 — İlk oynanabilir bölüm
Video, altyazı, 3–5 hedef ifade, quiz, aktif görev, ipucu, tekrar ve bölüm ilerlemesi.

### Faz 3 — Üç bölümlük zincir
Önceki bölüm özeti, ipucu panosu, sonraki bölüm bağlantısı, hikâye haritası ve devam etme.

### Faz 4 — Kanıt ve kişiselleştirme
Beceri bazlı kanıt, gecikmeli tekrar, görev zorluğu ve destek mekanizması.

### Faz 5 — Kısa klipler
Onaylı sahnelerden 30 saniyelik klip, tam bölüme yönlendirme ve analitik.

### Faz 6 — Pilot
Kullanıcılarla anlaşılabilirlik, devam etme, gecikmeli hatırlama, maliyet ve içerik kalitesi testleri. Sonuçlar olumluysa sezon genişletilir.

## 16. Codex talimatı

1. Repository ağacını ve `git status` durumunu incele; mevcut değişiklikleri silme.
2. `docs/IS-PLANI.md`, `yapilacaklar/IS-SIRASI.md` ve mevcut iş takip klasörlerini oku.
3. Mevcut içerik, video, quiz, kullanıcı seviyesi, ilerleme ve admin onay modellerini bul.
4. Yeni tablo/API önermeden önce çakışma kontrolü yap.
5. Story Bible, ilk üç bölüm outline'ı, öğrenme hedefleri ve teknik uygulama planını hazırla.
6. Hikâye kanonunu ve CEFR varyantlarını ayrı kavramlar olarak ele al.
7. AI'ın her kullanıcıya sınırsız yeni hikâye üretmesini MVP kapsamına alma.
8. `videoGenerator`/Higgsfield iş akışlarını yalnızca incele; başka repository'yi değiştirme.
9. Planı, riskleri, açık kararları ve test stratejisini kullanıcıya sun.
10. **Kullanıcı açıkça onaylamadan kodlama, migration, dış servis çağrısı, ücretli AI üretimi, medya üretimi veya yayın yapma.**

## 17. MVP kabul kriterleri

- Kullanıcı hikâye haritasında mevcut, tamamlanmış ve kilitli bölümleri görür.
- Kilitli bölümün sebebi açıklanır.
- Önceki bölüm özeti ve sonraki ipucu kanonik olaylarla tutarlıdır.
- Her bölüm CEFR, hedef dil, quiz ve aktif görev taşır.
- Hata yapmak hikâyeyi kalıcı kilitlemez; destekli tekrar vardır.
- İpucu kullanımı öğrenme kanıtında kaydedilir.
- Hikâye ilerlemesi ile dil ustalığı ayrı ama bağlantılıdır.
- Klipten tam bölüme geçiş çalışır.
- Yayınlanmış içerik sürümü ve onay geçmişi korunur.
- Onaysız veya telif durumu belirsiz içerik yayınlanamaz.
- AI üretim maliyeti ve açık onay kayıt altındadır.
- Hikâye devamlılığı ve gecikmeli öğrenme sonuçları ayrı ölçülür.

## 18. Açık kararlar
1. Ana karakter Alex ve *The Missing Signal* konsepti onaylanıyor mu?
2. İlk kullanıcı kitlesi yetişkinler mi, 13+ mı?
3. MVP ilk olarak A1–A2 mi sunacak?
4. Bölüm başına hedef süre ne olmalı?
5. Görsel anlatım sabit görsel+pan/zoom mu, seçilmiş sahnelerde video üretimi mi?
6. İngilizce ve Türkçe ses seçenekleri hangileri?
7. Günlük AI konuşma kotası ve aylık maliyet sınırı nedir?
8. Hikâye görevlerinde konuşma zorunlu mu, yazılı alternatif olacak mı?
9. İlk sezon kaç bölüm olacak?
10. İçerik editörü ve pedagojik onay sorumlusu kim?

## 19. Kaynakça
1. Duolingo — Adventures: https://blog.duolingo.com/adventures/
2. Duolingo — Duocon announcement: https://investors.duolingo.com/news-releases/news-release-details/duolingo-introduces-ai-powered-innovations-duocon-2024
3. *Do mobile games improve language learning? A meta-analysis* (2025): https://www.tandfonline.com/doi/full/10.1080/09588221.2025.2528786
4. *Impact of AI-generated storytelling vs. gamified learning on vocabulary retention and engagement in CALL environments* (2025): https://www.sciencedirect.com/science/article/pii/S2666920X25001456
5. *Story in gamification: enhancing engagement ... with no effect on performance* (2026): https://research.hacettepe.edu.tr/en/publications/story-in-gamification-enhancing-engagement-for-socializer-and-kil/
6. *A scoping review of gamified applications in English language teaching* (2025): https://link.springer.com/article/10.1186/s12909-025-06822-7
7. Council of Europe — CEFR descriptors: https://www.coe.int/en/web/common-european-framework-reference-languages/cefr-descriptors

---

## Son karar önerisi

HiVelzon kullanıcıya “İngilizce çalış” demek yerine “Alex'in sonraki ipucunu çözmek için bu ifadeyi öğren ve kullan” demelidir. Hikâye merak yaratır; görevler İngilizceyi kullandırır; öğrenme sistemi de kullanıcının gerçekten ne öğrendiğini ölçer.
