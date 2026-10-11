# HiVelzon — Oyun ve Hikâye Tasarımı

**Sürüm:** 0.2 (web araştırması işlendi) · **Tarih:** 2026-10-11 · **Durum:** §17'deki K-21…K-35 kullanıcı tarafından onaylandı (H-029, 2026-10-11)

## 0. Durum ve girdiler

**Kullanıcı kararı (2026-10-11, bağlayıcı):**
- HiVelzon'un ana deneyimi **oyunlaştırılmış, sürekli bir hikâye** olacak.
- Bir **ana kahraman** olacak. İngilizce, hikâye içinde adım adım, "sanki bir oyunun içindeymiş gibi" öğrenilecek.
- **Her bölüm bir öncekine bağlanacak.** Kullanıcı merak ettiği için devam edecek; yani tek bir oyun hikâyesi anlatılacak.

**Girdiler:**
- `docs/HIKAYE-EVRENI.md`: kullanıcının Storyworld belgesi. "The Missing Signal", Alex, 8 bölümlük zincir.
- `docs/ICERIK-MIMARISI.md`: onaylı içerik kararları K-01…K-20.
- `docs/VIDEOGENERATOR-RAPORU.md`: H-022 bulguları.
- Oyunlaştırılmış hikâye öğrenimi üzerine web araştırması (bkz. §19).

**Bu belgede:**
- Yön bağlayıcıdır.
- Konsept, karakterler, bölüm zinciri, ekranlar ve teknik ayrıntılar **önerilerdir** (§17'deki K-21…K-35).

**Kapsam:** Kod onayı değildir. Üretim ve yayın yoktur.

---

## 1. Tek cümlelik vaat

> **"Alex'in sıradaki ipucunu çözmek için bu ifadeyi öğren ve kullan."**
> Hikâye merak yaratır. Görevler İngilizceyi kullandırır. Öğrenme sistemi gerçekten ne öğrenildiğini ölçer.

Öğrenme döngüsü (ICERIK-MIMARISI §1) oyun diliyle şöyle olur:

`Önceki bölümde → İzle → Karar anı → Dil laboratuvarı → Görev → Kanıt → İpucu → Yeni soru → (tekrar) → Sonraki bölüm`

---

## 2. Pedagoji ↔ oyun eşlemesi

| Öğrenme yapısı (onaylı kararlar) | Oyundaki karşılığı |
|---|---|
| Seviye A1…C1 | **Sezon 1…5** (her sezon şehrin yeni bir bölgesi, hikâyenin yeni bir perdesi) |
| Ünite (can-do hedefi) | **Bölüm.** Görev kartı = can-do hedefi ("Kafede sipariş vererek ipucunu al") |
| Ders | **Sahne** (bölüm başına 3–5) |
| Hikâye videosu | **Ara sahne** (cutscene) ve **karar anı** |
| Quiz ve alıştırma | Anlama kontrolü, **görev** ve **kanıt kontrolü** |
| Biçime odak ve Türklerin hatası | **Dil laboratuvarı** (anlatan: yol arkadaşı Hi, §5.3) |
| AI konuşma pratiği | Bölüm görevinde ya da finalde bir karakterle **canlı sahne** (H-007'ye bağlı) |
| Kelime kaydetme | **Envanter / Defter:** toplanan ifadeler ve nesneler |
| SRS tekrarı (FSRS, K-04) | **Hafıza turu.** Eski ifadeler sonraki bölümlerde **hikâyenin gereği** olarak geri döner |
| Kapı testi (§7.3) | **Sezon finali** görevi |
| Yerleştirme testi (K-06) | **Prolog** (isteğe bağlı, atlanabilir; §10.3) |
| Kısa klipler (Keşfet) | **Fragmanlar** ve sahne kesitleri, tam bölüme bağlı |
| Yan seriler (Günün ifadesi vb., §4.3) | **Yan görevler** (isteğe bağlı keşif) |
| Rozetler | **Anı albümü:** bölümlerden kareler |

**Hikâye ilerlemesi ile dil ustalığı ayrı tutulur ama birbirine bağlıdır:**
- Bölüm bitirmek `COMPLETED` sayılır.
- `MASTERED` olmak için ayrıca farklı günlerden ve farklı görev türlerinden kanıt gerekir (ICERIK-MIMARISI §7.3).

---

## 3. Seviye ile hikâyenin ilişkisi [Karar gerekli: K-25]

Bu belgenin **en önemli mimari kararı** bu.

Storyworld belgesi iki şey söylüyor:
- "Aynı olay örgüsü bütün seviyelerde tutarlı kalsın, dil seviyeye göre uyarlansın."
- `episode_level_variants` tablosu.

Yani her bölümün A1…C1 için ayrı **varyantları** olabilir. Üç model var:

| Model | Nasıl çalışır | Artı | Eksi |
|---|---|---|---|
| **A: Sezon = seviye** | Hikâye tek hattır. Sezon 1 A1, Sezon 2 A2… Kullanıcının seviyesi hikâyenin neresinde olduğunu belirler. | Üretim 1 kat. Kahramanın İngilizcesi kullanıcıyla birlikte büyür. Kanon basit. | B1'den başlayan kullanıcı Sezon 1–2'yi, yani gizemin başlangıcını kaçırır. |
| **B: Bölüm × seviye varyantı** (Storyworld) | Herkes Bölüm 1'den başlar. Her bölümün her seviyede bir metni var. | Herkes hikâyenin başını görür. | Metin, TTS, altyazı ve **insan incelemesi 5 kata** kadar çıkar. Görseller ortak kullanılır. Tek kişilik ekip için en büyük darboğaz editör emeği. |
| **C: A + hızlı başlangıç (öneri)** | Omurga A. Yüksek seviyeden başlayan kullanıcı için Sezon 1'in **kısaltılmış üst seviye varyantı** sunulur: 2–3 bölüm, B1+ dilinde. Ayrıca her sezon için "Önceki sezonlarda" özet videosu. | Herkes gizemin başını görür. Ek maliyet yaklaşık 1,2–1,3 kat. | Kısaltılmış varyantı ayrıca yazmak ve onaylamak gerekir. |

**[Öneri]** MVP'de **A** (lansman A1–A2 olduğu için). Pilot verisinden sonra **C**'ye geçilir. B ancak editör kapasitesi büyürse düşünülür.

**Not:** Storyworld belgesindeki 8 bölümlük zincirin dil hedefleri A1 ile A2'yi karıştırıyor (basit geçmiş zaman, karşılaştırma). Model A'da bu hedefler A1'e çekilir (§6.2).

---

## 4. Bölümler arası bağ: merakla devam ettiren yapı (kullanıcı isteği)

### 4.1 Dört katmanlı anlatı yayı

Diziler ve oyunlar merakı katmanlarla taşır. Her katmanın kapanma süresi farklıdır:

| Katman | Süre | Kapanır mı? | Örnek |
|---|---|---|---|
| **Bölüm görevi** | 1 bölüm | **Her bölümde kapanır.** Kullanıcı tatmin olur, öğrenme hedefi tamamlanır. | "Komşudan istasyonun yerini öğren" |
| **Bölüm sorusu** | 1–3 bölüm | Sonraki 1–3 bölümde cevaplanır. | "Kapıdaki not kime ait?" |
| **Sezon gizemi** | 10–12 bölüm | Sezon ortasında kısmen, finalde tam açılır. | "Sinyali kim gönderiyor?" |
| **Seri gizemi** | 5 sezon | Ancak C1 finalinde çözülür. Her sezon bir parça verir. | "Sinyalin arkasındaki asıl hikâye" |

Bunlara paralel **karakter yayları** işler:
- Alex'in İngilizcesi kullanıcıyla birlikte gelişir.
- Arkadaşlıklar derinleşir.
- Hi'nin Türkçe desteği sezonlar ilerledikçe azalır; bu, öğrenme iskelesinin kademeli kaldırılmasıdır (§5.3).

### 4.2 Her bölümün bağ şablonu (zorunlu)

Storyworld'deki üç bağlantı sorusu her bölümün `content.json`'ında **zorunlu alan** olur. `content-lint` bu alanları denetler (§12.4).

| Alan | Soru | Örnek (Bölüm 3) |
|---|---|---|
| `previously` | Önceki bölümden hangi olay, nesne, karar ya da ilişki devam ediyor? | "İstasyonun kapalı olduğunu öğrendik" |
| `payoff` | Bu bölümde hangi yeni bilgi ya da sonuç kazanılıyor? | "İstasyonun yeri bulundu" |
| `openQuestion` | Sonraki bölüm için hangi somut soru ya da hedef açılıyor? | "Kapıdaki yarım notta ne yazıyor?" |
| `answers` | Bu bölüm daha önce açılmış hangi soruyu kapatıyor? | B2'nin sorusu: "İstasyon nerede?" |
| `cluesUnlocked` | İpucu panosuna ne ekleniyor? | "Yarım not" (İngilizce okuma metni) |
| `callbackPhrases` | Önceki bölümlerden hangi ifadeler hikâyenin gereği olarak tekrar kullanılıyor? | "Excuse me, where is…?" (B2'den) |

### 4.3 Bağ kuralları

1. **Her bölüm kendi görevini kapatır ve tam olarak bir yeni somut soru açar.** Tatmin ile merak dengelenir.
2. **Aynı anda en fazla 3 açık soru olur:** 1 sezon gizemi + en fazla 2 bölüm sorusu. Fazlası A1–A2'de bilişsel yükü artırır ve kafa karıştırır.
   - Seri gizemi arka plandadır ve bu sayıma girmez.
   - Seri gizemine yalnızca prolog, sezon ortası ve finalde değinilir.
3. **Açılan her soru en geç 3 bölüm içinde cevaplanır.** Sezon ve seri gizemi bu kuralın dışındadır. Cevaplanmayan soru = kırık söz = güven kaybı. `content-lint` bunu denetler.
4. **Kanca hikâyenin içinden gelir.** Kullanılabilecek kancalar: yeni bir ses ya da mesaj parçası, kayıp not, haritada beliren nokta, çelişkili cevap, beklenmedik (zararsız) bir kişi, yeni bir mekân, makul bir son tarih ("festival cumartesi"). "Devamı yarın" tek başına kanca sayılmaz.
5. **Güvenli kanca (13+):** Karakterlere yönelik tehlike, korku, kaçırma, şiddet ve romantik drama yoktur. Gerilim **merakla** kurulur, korkuyla kurulmaz.
6. **Sahte kanca yasak:** Kullanıcıyı sonraki bölüme çekmek için açılıp hiç karşılığı verilmeyen sorular kullanılmaz.
7. **Dil ve hikâye birlikte geri döner:**
   - Önceki bölümün son repliği ve hedef ifadesi bir sonraki bölümün açılışında tekrar duyulur.
   - Hikâyedeki nesneler (not, ses kaydı, harita) İngilizce **okuma ve dinleme metnidir.** İpucunu çözmek, metni anlamak demektir.
   - Önceki ifadeler sonraki bölümlerde **gerekli** hâle gelir. Örnek: B3'te öğrenilen "Excuse me, where is…?" B9'da tekrar kullanılmadan ilerlenemez. Bu, hikâyeye gömülü aralıklı geri çağırmadır (K-10: kelime başına 8 ve üzeri karşılaşma).

### 4.4 "Önceki bölümde" ve geri dönüş

- **Soğuk açılış (10–20 sn):** Her bölüm, önceki bölümün son karesi ve repliğiyle başlar; ardından yeni sorunun işareti gelir. Atlanabilir.
- **Uzun aradan dönüş:** Kullanıcı 7 günden uzun ara verdiyse:
  - 30–60 sn'lik uzun bir özet;
  - **3 ifadelik ısınma** (FSRS'te süresi gelen kartlar);
  - ipucu panosunda "Şu an bildiklerimiz".

  Özet suçlayıcı değildir: "Hoş geldin! Alex hâlâ o notun peşinde."
- **Sezon başı:** "Önceki sezonda" özeti İngilizce anlatılır ve hedef kelimelerin tekrarını içerir.

### 4.5 Merak ile etik arasındaki çizgi

- **Zaman kilidi yok:** Bölüm kapısı geçilince sonraki bölüm hemen açılır. "24 saat bekle" gibi yapay bekletme kullanılmaz.
- **Oturum sonu nötrdür:** "Bugünkü hedefini tamamladın. Bölüm 4 hazır; istersen devam et, istersen yarın kelimelerini tazeleyerek başla."
- **Bildirimlerde kanca kullanılmaz:**
  - En fazla 1 hatırlatma, saati kullanıcı seçer (K-16).
  - Karakter ağzından suçlayıcı mesaj gönderilmez ("Maya seni özledi" gibi).
  - Bildirimde spoiler ya da cliffhanger yoktur.
- **Kısa video tasarımı:** Keşfet klipleri cliffhanger ile bitebilir, ama klibin öğrenme hedefi kendi içinde tamamlanır (§13).

### 4.6 İçerik kuraklığı

Kullanıcılar bölümleri üretimden hızlı tüketir.

**Üretim önde, yayın haftalık (araştırmayla güncellendi):**
- Sezon 1'in büyük kısmı lansmandan **önce üretilir** (tampon).
- Lansmanda ilk 4 bölüm açık olur. Sonra **haftada 1 bölüm** yayınlanır.
  - Gerekçe: 84 bin izleyicili randomize bir saha deneyinde haftalık yayın, toplu yayına göre devamı yaklaşık %48 artırdı (de Matos ve ark., Marketing Science).
  - Tampon, üretim aksarsa yayının kesilmesini de önler.
- **Yayınlanmış bölümler her zaman açıktır.** Sonradan katılan kullanıcı biriken bölümleri bekletilmeden oynar. Yalnızca henüz yayınlanmamış bölüm beklenir; bekleme asla satılmaz ve atlatılmaz.

**Bekleyen kullanıcıya sunulanlar:**
- yan görevler;
- hafıza turları;
- bölümleri meydan okuma modunda yeniden oynama;
- aynı sahnenin **"diğer ton" dalını** oynama (var olan içerikten türer);
- Hi ile pratik.

**Haber:** Yeni bölümün yayın günü gösterilir ("Bölüm 15 · Pazartesi"). Geri sayım ya da FOMO dili kullanılmaz.

---

## 5. Evren ve karakterler [Karar gerekli: K-21, K-22, K-23]

### 5.1 Konsept: *The Missing Signal* (kullanıcı önerisi, temel alınır)

- **Tür:** Gizem, şehir keşfi, arkadaşlık, modern macera. Şiddet yok, korku yok.
- **Dünya:** Kurgusal, İngilizce konuşulan bir kıyı şehri.
  - Adı ileride seçilir; gerçek bir yer ya da marka adıyla karışmamalı (telif ve marka kontrolü).
  - Her sezon şehrin yeni bir bölgesi açılır.
- **Merkezdeki nesne:** **Eski bir telsiz.** Şehirdeki insanlara ve mekânlara bağlanan mesajlar yakalar.

**[Öneri] Birleştirme.** Onaylı K-10 ("Yeni gelen" evreni) ile Storyworld şöyle birleştirilir:
- **Alex şehre yeni gelmiştir.**
  - Bu, kahramanın İngilizcesinin A1'den başlamasını hikâye içinde gerekçelendirir.
  - Yerel karakterlerin Alex'le yavaş ve basit konuşmasının da doğal bir nedeni olur.
- **Telsiz, Alex'in Türkiye'deki büyükannesinden kalmadır.** Büyükanne gençliğinde bu şehirde bir süre yaşamış.
  - Gizeme duygusal bir bağ ekler.
  - Türk öğrencinin özdeşleşmesini kolaylaştırır.
  - Seri gizeminin cevabını sıcak bir yere bağlar: kopmuş bir arkadaşlığın ya da bağın yeniden kurulması.
- **Alternatif:** Telsiz eski evde bulunur; Türkiye bağı yoktur. Bu sürüm daha evrensel olur ama özdeşleşme daha zayıf kalır.

### 5.2 Ana kahraman: Alex [K-22]

| Konu | Öneri | Alternatif |
|---|---|---|
| Görünürlük | **Hibrit (araştırmayla güncellendi).**<br>• Alex ara sahnelerde görünür.<br>• **Karar anında kamera birinci şahıs (POV) ya da omuz üstü açıya geçer;** kullanıcı Alex'in ağzından seçer ya da söyler, Alex seçilen repliği seslendirir.<br>• Birinci şahıs bakış sürüklenmeyi ve görev hafızasını artırıyor (Lindgren 2012, Denisova 2015). Görünür kahraman da karakter tutarlılığı ve "kahraman" hissi için ucuz. | Tamamen görünmeyen POV oyuncu, ya da tamamen üçüncü şahıs. |
| Yaş ve konum | ~18–19 yaşında. Şehre okumak için gelmiş (dil okulu, üniversite hazırlık ya da değişim). 13 yaş ve üstü genç kullanıcılar da yetişkinler de özdeşleşebilir. | Lise öğrencisi; yetişkinlere hitap etmeyebilir. |
| Ad | **Alex** (Storyworld). Cinsiyetten bağımsız, İngilizce telaffuzu kolay. | Türkçe, cinsiyetten bağımsız bir ad (Derin, Kayra, Umut). |
| Cinsiyet ve görünüş | Tek tasarım. Karakter kitabında (H-030) belirlenir. **Avatar özelleştirme yok:** kaygıyı azalttığına dair kanıt zayıf ve tutarsız. | İki seçilebilir kahraman. Görsel maliyet yaklaşık 2 kat; **önerilmez**. |
| Dil yayı | Sezon 1'de Alex kısa ve basit konuşur, zorlanır. Sezon 5'te akıcıdır. **Alex'in İngilizcesi kullanıcıyla birlikte büyür.** | — |

### 5.3 Yol arkadaşı: Hi (yapay zekâ öğretmen) [K-23, H-005, H-016]

**[Öneri]** Sabit yapay zekâ öğretmen **hikâyenin içinde** Alex'in telefonundaki asistan olur. Çalışma adı: **"Hi"** (HiVelzon markasıyla bağ).

**Görevleri:**
- Türkçe ipucu verir.
- Dil laboratuvarını anlatır.
- "Böyle de söyleyebilirsin" notlarını sunar.
- Hata durumunda yönlendirir.

**Yapay zekâ açıklaması hikâyenin içindedir:**
- Hi ilk bölümde "Ben bir yapay zekâ asistanıyım" der.
- Bu, AB Yapay Zekâ Yasası Madde 50 ve Türkiye'deki reklam yönetmeliği md. 18(8) açısından da temiz bir çözümdür (ICERIK-MIMARISI §10.3).

**Görsel:** Fotogerçekçi değil, maskot ya da simge tarzı. "Deepfake" riski yok. Soul ID gerekmez.

**Öğrenme iskelesinin kademeli kaldırılması:**

| Sezon | Hi'nin Türkçe desteği |
|---|---|
| S1 | Türkçe ağırlıklı |
| S2 | Karışık |
| S3 ve sonrası | İngilizce ağırlıklı |
| S5 | Yalnızca istenince |

**Konuşma pratiği** (H-007): Hikâyedeki "Hi ile pratik" ya da "Maya ile canlı sahne" olarak çerçevelenir.

### 5.4 Destek kadrosu (Storyworld, ayrıntı H-030'da)

| Karakter | Rol | İşlevi |
|---|---|---|
| **Maya** | Yerel rehber, arkadaş | Alex'le yavaş ve net konuşur. A1'in "anlaşılır girdi" kaynağıdır. |
| **Sam** | Teknik meraklı | Telsizi geliştirir. Teknoloji kelimeleri, talimat dili. |
| **Jordan** | Bilgileri hep eksik olan tanık | Çelişkiler kurar. Dinlemede ayrıntı ve çıkarım görevleri. |
| Kafe sahibi, komşu, kütüphaneci vb. | Mekân karakterleri | Her ünitenin iletişim işlevi (sipariş, yol sorma, alışveriş) |

**Kurallar:**
- Karakterlerin kişilikleri, bilgileri, konuşma tarzları ve ses kimlikleri sabittir (`CHARACTER_PROFILES.md`).
- Gerçek kişilere, markalara ve başka eserlerin karakterlerine benzemezler.

### 5.5 Görsel tarz [K-24]

**[Öneri]**
- **Tarz:** Fotogerçekçi olmayan, **"animasyon dizi / çizgi roman"** tonu. Yetişkini de rahatsız etmeyecek kadar olgun, çocuksu değil.
- **Karakter tutarlılığı:**
  - Her karakter için referans görsel seti ve sabit bir stil öneki kullanılır.
  - Model olarak Nano Banana 2 (CLAUDE.md'ye göre çizgi karakter için varsayılan) ile GPT Image 2.5 pilotta karşılaştırılır (H-024).
- **Yazı:** Görsellerde yazı yoktur. Notlar, tabelalar ve ipuçları kurguda yerel olarak eklenir (Higgsfield kural 7).

---

## 6. Sezon planı

### 6.1 Seri yayı (taslak; H-030'da yazılır)

| Sezon | Seviye | Bölge | Sezon gizemi (taslak) | Finalde açılan |
|---|---|---|---|---|
| S1 | A1 | Alex'in mahallesi ve liman | Sinyali kim gönderiyor? | Sinyal, şehrin eski telsiz kulübüne bağlıdır. Ama ikinci bir ses vardır. |
| S2 | A2 | Şehir merkezi ve kısa bir yolculuk | İkinci ses kimin? | Ses, yıllar önce şehirden ayrılan birine aittir. Yolculuk ipucu verir. |
| S3 | B1 | Festival ve kulüp, yarı zamanlı iş | Kulübün eski kayıtları neden eksik? | Arşivde büyükanneyle ilgili bir iz bulunur. |
| S4 | B2 | Büyük şehir; arşiv ve kurumlar | Kayıtları kim, neden sakladı? (Suç yok; yanlış anlaşılma ve kırgınlık) | Kopmuş bağın nedeni anlaşılır. |
| S5 | C1 | Uluslararası sahne | Alex bağı yeniden kurabilecek mi? | Seri finali: buluşma ya da yeniden bağlantı. Alex'in konuşması (C1 görevi). |

### 6.2 Sezon 1: 12 bölümlük zincir (A1)

İlk 8 bölüm Storyworld zincirinden alındı; dil hedefleri A1'e çekildi. 9–12. bölümler yeni.

Her satırda:
- ünite karşılığı `ICERIK-STRATEJISI.md` §6'daki A1 ünite listesine göre;
- **bağ** = bu bölümün sonunda açılan soru.

| # | Bölüm | Olay | A1 dil hedefi (can-do) | Görev | Bağ (açılan soru) |
|---|---|---|---|---|---|
| 0 | *Prolog: Arrival* (isteğe bağlı) | Alex şehre gelir. Pasaport kontrolü. Hi'yle tanışma. | Selam, ad, ülke | (Yerleştirme testi, atlanabilir) | Bavulda büyükannenin telsizi var… |
| 1 | A Strange Message | Telsizden bir mesaj gelir | Selamlaşma, basit sorular, talimat | Mesajdaki **kişiyi ve yeri** belirle (dinleme) | Mesajdaki yer adı haritada belirir |
| 2 | The New Neighbour | Alex komşudan bilgi ister. Maya'yla tanışır. | Kendini ve aileni tanıtma; *to be*, ülkeler, aile | Konuşarak eksik bilgiyi tamamla | Eski istasyon kapalıdır, peki neden? |
| 3 | Find the Station | İstasyon aranır | Yol sorma, yer edatları | Haritada rotayı seç | Kapıda yarım kalmış bir not |
| 4 | The Note | Notun bir kısmı okunamaz | Saat, günler, tarih | Olası anlamları eşleştir (okuma) | Bir buluşma saati ortaya çıkar |
| 5 | Too Late? | Buluşma yerine gidilir. Jordan'la tanışılır. | Günlük rutin, planlar; *was/were* yalnızca tanıma düzeyinde | Jordan'ın anlattığını anla | Jordan ayrılmış ama bir kayıt bırakmış |
| 6 | The Recording | Ses kaydı incelenir | Dinleme: ana fikir ve ayrıntı; *there is/are* | Üç ipucunu bul | Kayıttaki isim ile yer uyuşmuyor |
| 7 | Who Knows What? | İki karakter farklı şeyler anlatır | Tarif etme, *have/has*, *can/can't*, sevdiklerin | Çelişkili bilgileri ayır | Bir karakter eksik bilgi verdiğini kabul eder |
| 8 | The First Reveal | **Sezon ortası açılımı** | Önceki hedeflerin bütünleştirilmesi | Konuşma + okuma + karar | Sinyal tepedeki bölgeden geliyor |
| 9 | The Café on the Hill | Tepedeki kafe | Yiyecek-içecek, sipariş | Sipariş verip kafe sahibinden bilgi al | Kafe sahibi sesi tanır: "Eski telsiz kulübü!" |
| 10 | Spare Parts | Telsiz için parça alınır | Alışveriş, fiyat, sayılar | Doğru parçayı doğru fiyata al | Yeni anten ikinci bir mesaj yakalar, yarım bir tarih |
| 11 | Storm Warning | Hava bozar, sinyal zayıflar | Hava durumu, kıyafet | Hazırlan, doğru zamanı seç | Mesaj: "deniz feneri… bu gece" |
| 12 | The Lighthouse *(final)* | Deniz fenerine gidilir | Yardım isteme + sezon tekrarı | **Sezon finali** (kapı testi; §10.2) | Sinyal kulübe bağlanır, ama **ikinci bir ses** var → Sezon 2 |

**Kapsanan A1 üniteleri:** Ev ve odalar ünitesi Bölüm 2 ve 5'e yedirilir. Böylece 12 A1 ünitesinin tamamı kapsanır.

**Kontrol:** Her bölümün dil hedefi, `content-lint` ile CEFR-J A1 kapsamına göre denetlenir (K-07).

---

## 7. Bölüm anatomisi [K-27]

**Süre:** Yaklaşık **5–8 dk**. Bu bir başlangıç varsayımıdır, pilotta ölçülür.

Storyworld'deki 8 adım ile "karar anları" birleştirildi:

| # | Adım | Süre | İçerik |
|---|---|---|---|
| 1 | **Önceki bölümde** (soğuk açılış) | 10–20 sn | Son kare ve replik, yeni sorunun işareti |
| 2 | **Görev kartı** | 5 sn | Hikâye hedefi + İngilizce hedefi + 3–5 hedef ifade |
| 3 | **Ara sahne ve karar anları** | 60–120 sn | Video segmentlere bölünür. A1–A2'de **sahne başına 1–2, bölüm başına en fazla 4 karar anı** vardır. Karar anında:<br>• video durur;<br>• **müzik ve hareket kısılır, arka plan sadeleşir, hedef ifade öne çıkar.**<br>Gerekçe: dikkat dağıtıcı süs öğeleri acemilerde öğrenmeyi düşürüyor (Sundararajan & Adesope 2020). |
| 4 | **Anlama kontrolü** | 30–60 sn | Ana fikir ya da kritik ayrıntı |
| 5 | **Dil laboratuvarı** (Hi) | 60–120 sn | Hedef ifadeler, kısa açıklama, "Böyle de söyleyebilirsin" |
| 6 | **Görev** | 60–120 sn | Harita, not, kayıt, nesne ya da konuşma etkileşimi (§8.1) |
| 7 | **Kanıt kontrolü** | 30–60 sn | Hedef dili yeni bir cümlede tanıma ya da kullanma |
| 8 | **İpucu açılır ve yeni soru** | 10–20 sn | İpucu panosuna eklenir. Sonraki bölümün sorusu açılır. |
| 9 | **Tekrar planı** | — | İfadeler deftere ve FSRS'e girer. Bir sonraki hafıza turunun zamanı gösterilir. |

**Seviyeye göre ayar:**

| Seviye | Ayar |
|---|---|
| A1 | Kısa segmentler; sahne başına 1–2 karar anı; iki-üç seçenek; görsel ipucu. Tempoyu kullanıcı kontrol eder. |
| B2–C1 | Uzun sahneler; daha az ama daha zengin karar anı (ton, ima, güvenilirlik); uzun yanıt |

### 7.1 Örnek: Bölüm 1, "A Strange Message" (A1)

1. **Soğuk açılış:** Prolog'un son karesi. Bavulda telsiz.
2. **Görev kartı:**
   - Hedef: "Mesajdaki kişiyi ve yeri bul."
   - İfadeler: *Hello / What's your name? / Where is…? / Listen. / Again, please.*
3. **Ara sahne ve karar anları:**
   - Alex telsizi açar; cızırtı, sonra bir ses: *"Hello? … My name is … Meet me at …"*
   - **Karar anı 1** (video durur). Ses soruyor: *"Hello? Can you hear me?"* Seçenekler:
     - **(a)** *"Yes, I can hear you."* → Ses devam eder.
     - **(b)** *"My name is Alex, goodbye."* → Ses şaşırır (5 sn'lik nazik tepki). Hi Türkçe ipucu verir. Kullanıcı tekrar dener.
4. **Anlama kontrolü:** "Ses ne istiyor?" (görselli 2 seçenek)
5. **Dil laboratuvarı:**
   - Hi: "*Again, please* demek kibarca tekrar istemektir…"
   - Türkçe karşılaştırma: "Bir daha söyle" doğrudan çevrilmez.
6. **Görev:** Kaydı dinlenir, kişinin adı ve yer seçilir (dinleme).
7. **Kanıt kontrolü:** *"Where is the station?"* cümlesi kelimeler sıralanarak kurulur.
8. **İpucu:** Haritada "Old Station" noktası belirir. Açılan soru: "Orada kim var?"
9. **Tekrar:** 5 ifade deftere girer.

---

## 8. Etkileşimler, dallanma ve destek

### 8.1 Etkileşim türleri

Her etkileşim beceri ve CEFR etiketi taşır. **İlk denemedeki doğruluk** `learning_events`'e kanıt olarak yazılır.

| Tür | Seviye | Beceri |
|---|---|---|
| Diyalog seçimi (Alex ne desin?) | A1+ (B2+'da ton ve nezaket seçimi) | Etkileşim, pragmatik |
| Dinle ve seç | A1+ | Dinleme |
| Haritada rota ve nesne seçimi | A1–A2 | Okuma, talimat |
| İpucu metnini okuma (not, mektup, ilan) | A1+ (uzunluk seviyeyle artar) | Okuma |
| Kelime sıralama ve boşluk doldurma | A1–B1 | Dilbilgisi |
| Çelişki ayırma, kanıt değerlendirme | B1+ | Çıkarım |
| Söyle (Alex'in repliğini sesli söyle) | A1+ | Konuşma. **Hiçbir zaman zorunlu değildir;** yazılı ya da seçmeli alternatifi vardır. Puanlama H-015'e bağlı. |
| Canlı sahne (AI ile serbest konuşma) | Final ya da isteğe bağlı | Etkileşim (H-007, kota) |
| Kısa mesaj yazma (karaktere) | P1 (K-11) | Yazma |

**Tahmin etme riskine karşı:**
- Çeldiriciler makul olur.
- Aynı hedef farklı türlerle tekrar sorulur.
- Peş peşe yanlışta daha kolay bir varyant gelir.
- Puanlamaya yalnızca ilk deneme girer.

### 8.2 Dallanma politikası [K-28]

- **Dal ve dar boğaz** (Ashwell). "Zaman mağarası" deseni, yani hiç birleşmeyen dallar, **yasaktır.**
- **Yanlış seçenek:** Kısa bir tepki parçasına gider (3–8 sn; tek durağan kare + TTS + altyazı, video kredisi yok). Sonra **aynı karar anına döner.**
- **Doğru seçenekler arasında ton farkı** olabilir (resmî / samimi). Seçilen ton bayrak olarak saklanır ve sonraki bölümde tek satırlık bir geri dönüşle anılır.
  - Seçimin hemen ve görünür biçimde karşılanması, doğrusal hikâyede de ajans hissi yaratıyor (Fendt 2012, Cardona-Rivera 2014).
  - Sonuçsuz seçenekler "sahte seçim" algısı yaratır. Bu yüzden geri dönüşler görünür olmalı.
- **Bayrak tavanı: bölüm başına en fazla 3 kalıcı bayrak.** Bayraklar arttıkça test ve kalite kontrol maliyeti katlanır.
  - Yanlış seçim **nazik ve komik bir yanlış anlaşılma** üretir, asla alay etmez.
  - Yanlış seçim aynı zamanda "bu ifade bu bağlamda ne anlama gelir" dersidir.
- **Kalıcı küçük seçimler:**
  - Örnekler: Alex'in kafede seçtiği içecek, Maya'ya mı Sam'e mi önce haber verdiği.
  - Bunlar bayrak olarak saklanır ve sonraki bölümlerde tek satırlık geri dönüşlerle (alternatif TTS) hatırlanır.
  - Ucuz yoldan "seçimlerim önemli" hissi verir.
- **Çoklu son yok:** Ana olay örgüsü tektir (kanon tutarlılığı ve müfredat kontrolü için). Kişiye özel AI hikâyesi MVP'de yoktur (Storyworld §5).

### 8.3 Başarısızlıkta destek (Storyworld §8)

1. Hi'den **kademeli** ipucu, yalnızca kullanıcı isterse:
   - önce anahtar kelime;
   - sonra kalıp;
   - en son Türkçe açıklama.
2. Altyazı ya da Türkçe anlam önerisi.
3. Sahneyi tekrar izleme.
4. Hedef ifadeyle örnek.
5. Daha kolay bir alıştırma.
6. Aynı hedef yeni bir cümleyle.

**Hikâye asla kalıcı kilitlenmez. Can, enerji ya da "game over" yoktur.**

---

## 9. Oyun sistemleri [K-31, K-32]

| Sistem | MVP? | Açıklama |
|---|---|---|
| **Hikâye haritası** | Evet | Şehir haritası. Bölümler mekân olarak görünür, sezonlar bölge olarak açılır. Kilitli bölümde kilidin nedeni yazar ("Bölüm 3'ün görevini tamamla"). Bir sonraki bölüm için spoiler vermeyen bir ipucu gösterilir. |
| **Görev kartı** | Evet | Hikâye hedefi + İngilizce hedefi |
| **İpucu panosu** | Evet | Bulunan ipuçları (İngilizce metin ya da ses) ve **açık sorular**. Kullanıcı "şu an neyi merak ediyorum"u görür. |
| **Defter / envanter** | Evet | Toplanan ifadeler ve nesneler. Kelime tekrarı (SRS) için bir kapıdır. |
| **Anı albümü** | Evet (basit) | Biten bölümlerden kareler |
| **Sezon özeti** | Evet | İngilizce özet + hedef kelime tekrarı |
| **Yan görevler** | Evet | Kısa seriler (Günün ifadesi, Kulak testi…) ve bağımsız hikâyeler; zorunlu değil |
| **Hikâye modu / meydan okuma modu** | P1 | Daha çok ya da daha az yardım. İkisi de kanıt toplar; ipucu kullanımı kaydedilir. |
| **Karakter güveni** | P1 | Yalnızca anlamlı görev sonuçlarına bağlı. Rastgele puan değil, "puan kasma" aracı değil. |
| **Kahramanın odası / kozmetik** | P2 | Satın alma yok |

**Yasaklar (K-32; bazıları önceki kararları kesinleştirir):**
- can, enerji ve kalp sistemleri;
- loot box ve şansa dayalı ödül;
- zaman kilidi ve geri sayım baskısı;
- suçlayıcı bildirim;
- lig ve sıralama;
- ilerlemeyi satın alma;
- kopan seriyi vurgulamak (K-16);
- süreli soru ve sayaç baskısı (erişilebilirlik ve kaygı nedeniyle).

---

## 10. İlerleme, kilit ve seviye

### 10.1 Bölüm kapısı [K-29]

Sonraki bölümün açılması için üçü birden gerekir:
- anlama kontrolü geçilmiş;
- hedef ifade bağlamda tanınmış;
- en az bir aktif görevde dil kullanılmış.

**Kurallar:**
- İpucu ve tekrar sınırsızdır.
- Kilit kalıcı değildir.
- Tek bir yanlış ne kilit ne seviye düşüşü getirir.

### 10.2 Sezon finali = seviye kapısı

- Sezon 12. bölümün görevi, ICERIK-MIMARISI §7.3'teki **kapı testini** hikâyeye gömer.
- Testi geçmek → "Sezon 2'ye hazırsın".
- Testi geçememek → sezon tekrar görevleri (hafıza turu ve yan görevler) ve nazik bir tekrar daveti. Hikâyenin sonu yine de izlenebilir; kanca kaybolmaz.
- Diğer seviye atlama koşulları (%80 tamamlama vb.) aynı kalır.

### 10.3 Yerleştirme ve yüksek seviyeden başlayanlar

- **Prolog** (isteğe bağlı): Pasaport kontrolü sahnesinde kademeli soru zinciri (K-06).
  - Hikâyeleştirilmiş bir testtir. Sonucu yine "önerilen başlangıç seviyesi" olarak gösterilir.
  - Testi atlayan kullanıcı Bölüm 1'den başlar.
- **Yüksek seviyeden başlayan kullanıcı** (Model A/C):
  - "Önceki sezonlarda" özeti izlenir.
  - Defterine o sezonların çekirdek ifadeleri "biliniyor olabilir" etiketiyle eklenir; ilk hafıza turunda doğrulanır.
  - İstediği zaman eski sezonları oynayabilir.
- **Lansmanda B1 ve üstü:** İçerik yalnızca A1–A2. Kullanıcıya dürüstçe söylenir: "Senin seviyendeki sezon yakında. Bu arada Sezon 1–2'yi meydan okuma modunda oynayabilir, yan görevleri yapabilirsin."

---

## 11. Ekranlar (ICERIK-MIMARISI §6'daki değişiklikler)

### 11.1 Sekmeler [K-30: K-02 revizyonu]

| Önceki onay (K-02) | Öneri |
|---|---|
| Ana Sayfa · Keşfet · **Öğren** · Konuş · Profil | Ana Sayfa · Keşfet · **Hikâye** · Konuş · Profil |

**Hikâye sekmesi:**
- **Harita** (varsayılan)
- İpucu panosu
- Defter
- Anı albümü
- **Yan görevler** (eski "Kütüphane")

### 11.2 Ana Sayfa (altı kart; sonsuz kaydırma yok)

1. **Hikâyeye devam et:** "S1 · B3 · Find the Station · Sahne 2/4". İçinde 10–20 sn'lik "Önceki bölümde" özeti var.
2. **Görevin:** Bugünkü tek net görev.
3. **İpucu panosu:** "Açık soru: Kapıdaki notta ne yazıyor?"
4. **Hızlı pratik:** Son bölümden ve süresi gelen kartlardan 3 ifade.
5. **Hikâye klipleri:** 3 kısa sahne. Mini oturum açar, sonsuz akış değildir.
6. **Konuşma ya da yan görev önerisi:** Gerekçesiyle.

İlerleme ve beceri gösterimi → Profil.

```
┌─────────────────────────────┐
│ Merhaba          🔥5    A1  │
│ ┌─────────────────────────┐ │
│ │ HİKÂYEYE DEVAM          │ │
│ │ S1·B3 Find the Station  │ │
│ │ "Önceki bölümde: ..."   │ │
│ │       [ ▶ Devam ]       │ │
│ └─────────────────────────┘ │
│ 🎯 Görev: İstasyonu bul      │
│ 🧩 Açık soru: Not kimin?     │
│ ▢ Hızlı pratik · 3 ifade    │
│ ▢ 3 hikâye klibi            │
│ ▢ Maya ile konuş (1 hak)    │
└AnaSayfa─Keşfet─Hikâye─Konuş─Profil┘
```

### 11.3 Hikâye haritası

```
┌─────────────────────────────┐
│ SEZON 1 · Liman Mahallesi   │
│   (1)●──(2)●──(3)◐          │
│                  │          │
│   (6)🔒─(5)🔒─(4)🔒         │
│ ◐ Find the Station          │
│   Görev: Haritada rotayı seç │
│ 🔒 4: "Bir not seni bekliyor"│
│ [İpucu panosu] [Defter]     │
└─────────────────────────────┘
```

### 11.4 Oynatıcı ve karar anı

- **Oynatıcı özellikleri:** ICERIK-MIMARISI §6.4'teki her şey: dokun-çevir, cümle tekrarı, 0,75 hız, EN / EN+TR altyazı (K-03).
- **Karar anı:** Video durur; seçenekler **yerel arayüz kartları** olarak gelir (videoya gömülmez).
- **Üst şerit:** Görev çubuğu, Hi düğmesi (💡 ipucu).
- **Ara sahne:** İlk izlemeden sonra atlanabilir.

```
┌─────────────────────────────┐
│ ← S1·B1  🎯Kişiyi ve yeri bul│
│ ┌─────────────────────────┐ │
│ │   [telsiz ara sahnesi]  │ │
│ └─────────────────────────┘ │
│ "Hello? Can you hear me?"   │
│  Alex ne desin?             │
│ ┌─────────────────────────┐ │
│ │ Yes, I can hear you.    │ │
│ ├─────────────────────────┤ │
│ │ My name is Alex, goodbye│ │
│ └─────────────────────────┘ │
│ 💡 Hi   🎤 Söyle (isteğe bağlı)│
└─────────────────────────────┘
```

### 11.5 Diğer ekranlar

- **Bölüm sonu:** Tamamlanan görev, quiz ve açıklamalar, deftere giren ifadeler, açılan ipucu, **yeni soru**, sonraki bölüm ve nötr oturum sonu (§4.5).
- **Keşfet:** Klipler bölümlerden gelir; sezon, bölüm, sahne ve sürüm kimliği taşır.
  - "Bölümü aç" eylemi:
    - Kullanıcı o bölüme ulaştıysa doğrudan bölümü açar.
    - Ulaşmadıysa "Bölüm 7'den. Oraya ulaşınca oynayabilirsin" der. Klip yine izlenebilir; spoiler riski kısa kliple sınırlıdır.
  - K-15 (quiz ve mola kartları) aynen geçerli.
- **Profil:** Hikâye ilerlemesi (sezon ve bölüm) **ayrı**, beceri tahminleri ve güven düzeyi **ayrı**, ayrıca defter, haftalık anlamlı döngü ve ayarlar.

---

## 12. İçerik yapısı ve üretim

### 12.1 Klasör [K-33: K-01 ile uyumlu]

Storyworld belgesi `story/episode-001/` öneriyor. Onaylı K-01 `icerik/<SEVİYE>-<3 hane>-<kısa-başlık>/` diyor. **[Öneri]** K-01 korunur, evren dosyaları ayrı bir klasöre girer:

```text
icerik/
  _evren/                       # hikâye kanonu (seviyeden bağımsız)
    STORY_BIBLE.md              # dünya, kurallar, ton, yasaklar
    CHARACTER_PROFILES.md       # kişilik, konuşma tarzı, ses kimliği, görsel referans
    CANON_AND_TIMELINE.md       # doğrulanmış gerçekler ve zaman çizelgesi
    OPEN_QUESTIONS.md           # açık sorular: açıldığı ve kapanacağı bölüm
    LANGUAGE_PROGRESSION.md     # sezon/bölüm → can-do, dilbilgisi ve kelime hedefleri
    SEASON_01_OUTLINE.md
    style/                      # stil öneki, karakter referans görselleri
  A1-001-a-strange-message/     # S1·B1 (Model A: seviye = sezon)
    content.json                # + season, episode, prev, next, bağ alanları (§4.2)
    scenes.json                 # segment ve karar düğümü grafiği
    mission.json                # görev, başarı ölçütü, ipucu politikası
    story.en.md, story.tr.md, glossary.md, quiz.md
    PROMPTS.md, rights-and-review.md
    audio/ images/ clips/ subs/ final/
```

- Model B seçilirse bölüm kimliği seviyeden bağımsız olur (`S01E001-…/variants/A1/…`). Bu, K-01'in değişmesini gerektirir.

### 12.2 Üretim akışı (ICERIK-MIMARISI §9.2'ye eklenenler)

1. **Kanon önce:** Önce Story Bible ve sezon özeti onaylanır, sonra bölüm yazılır.
2. **Bölüm iskeleti:**
   - görev;
   - sahneler;
   - karar anlarının yeri;
   - hedef dil;
   - bağ alanları (`previously`, `payoff`, `openQuestion`, `answers`, `callbackPhrases`).
3. **Diyalog yazımı:** LLM, CEFR kısıtlarıyla yazar. Prompt taslağı `VIDEOGENERATOR-RAPORU.md` §4a'da.
4. **`content-lint`:** Seviye, kapsama ve **zincir denetimi** (§12.4).
5. **İnsan incelemesi:** Dil, pedagoji ve **kanon tutarlılığı**.
   - Storyworld'deki `CANON_REVIEW` ayrı bir durum değil, onay kontrol listesinin bir maddesidir (K-05 korunur; K-34).
6. **Medya:**
   - Karakter referanslarıyla görseller üretilir. Önce maliyet gösterilir, onay alınır.
   - Seslendirme: karakter başına sabit ses kimliği.
   - **Segment başına** MP4/HLS + WebVTT + kelime zamanlama JSON'u.
   - Tepki parçaları: durağan kare + TTS.

### 12.3 videoGenerator raporundan düzeltmeler (H-022)

- `SceneImageService` **Higgsfield değil, OpenAI gpt-image-2** kullanıyor (görsel başına sabit 0,08 USD). HiVelzon için Higgsfield adaptörü yeniden yazılacak. CLAUDE.md tablosu düzeltildi.
- **Ses normalizasyonu:** `loudnorm` parametresiz çalışıyor, yani ffmpeg varsayılanı -24 LUFS. Hedefler -16 (uygulama) ve -14 (sosyal medya) LUFS. İki geçişli yeni bir adım ve ölçüm kapısı gerekir.
- **BudgetGuard:** Tavan yoksa 100 USD varsayıyor; HiVelzon kuralına aykırı. Yarıda kalan işlerin harcaması kaydedilmiyor. Bunlar düzeltilerek taşınacak.
- **Çıktı:** Sabit 1080×1920 ve 60–90 sn. Segmentli bölüm yapısı, 16:9 ve HLS yeni yazılacak.
- **TTS hizalaması:** Karakter düzeyinde geliyor. WebVTT ve kelime JSON'u üretimi raporun §4c bölümünde.
- **Yayıncılar:** `madeForKids` sabit `false`. TikTok AIGC ve Instagram AI bayrağı yok.

### 12.4 `content-lint` zincir denetimleri (yeni)

- Her bölümde `previously`, `payoff`, `openQuestion` dolu. Final bölümünde `openQuestion` bir sonraki sezona bağlanıyor.
- Açılan her soru en geç 3 bölüm içinde bir `answers` ile kapanıyor. Sezon ve seri gizemi işaretli olarak bu kuralın dışında.
- Aynı anda en fazla 3 açık soru var.
- `cluesUnlocked` ve `callbackPhrases` önceki bölümlerde gerçekten var.
- `CANON_AND_TIMELINE.md` ile çelişen olgu yok. Örnek: karakterin bilmemesi gereken bir şeyi bilmesi.
  - Bu denetim tam otomatik değil: LLM uyarı üretir, karar editörde.
- Grafik denetimi: Her dal ana hatta dönüyor, çıkmaz yol yok, her yanlış seçeneğin geri bildirimi var, her etkileşimde beceri ve CEFR etiketi var.
- Karar anı yoğunluğu seviyeye uygun.

---

## 13. Kısa video ve sosyal medya (Storyworld §9 + K-14/K-15)

- **Klipler:** Bölümlerden çıkar. **Tek bir öğrenme hedefi** taşır ve kendi içinde anlaşılır olur.
  - Eylemler: "İfadeyi öğren", "Görevi dene", "Bölümü aç".
  - Sezon, bölüm, sahne ve sürüm kimliği taşır.
- **Sosyal medya:** Dizi formatı için çok uygun ("S1 B3"). Klip bir soruyla bitebilir, ama öğrenme hedefi klipte tamamlanır.
  - CTA: "Bölümü uygulamada oyna".
  - Yapay zekâ etiketi her zaman konur. Yükleme önce elle yapılır (K-14).
- **Haftalık takvim (K-09):** Salı ve cuma klipleri o haftanın bölümünden gelir. Bölüm yayın günü pazartesidir.

---

## 14. Veri modeli taslağı (birleşik; kod onayından sonra kesinleşir)

Storyworld §11 + ICERIK-MIMARISI §7.7 + teknik not:

| Tablo | Not |
|---|---|
| `story_worlds`, `story_seasons` | Evren ve sezon; kanon sürümü |
| `story_characters` | Profil, ses kimliği, görsel referans, onaylı sürüm |
| `story_episodes` | Sezon, sıra, `prev`/`next`, `payoff`, `open_question`, `answers_question_id` |
| `story_questions` | Açık sorular: açıldığı bölüm, kapanması gereken bölüm, tür (bölüm / sezon / seri) |
| `episode_variants` | **Model B ya da C seçilirse.** Model A'da `content_version` yeterli. |
| `episode_nodes`, `episode_edges` | Segment, karar, tepki, not, görev, ipucu düğümleri ve koşullu geçişler. Düğüm kimlikleri sürümler arasında sabittir. |
| `story_missions`, `story_clues` | Görev ve başarı ölçütü; ipucu ve açılma koşulu |
| `user_story_progress` | `(user, episode_id, version_id)`, `current_node`, `status`, `checkpoint_node` |
| `user_story_flags` | Kalıcı küçük seçimler |
| `user_story_inventory` | Açılan ipuçları ve nesneler. İfadeler `srs_cards` (K-04) üzerinden tutulur, ayrı tablo açılmaz. |
| `learning_events` | **Kanıt deposu.** `user_episode_evidence` ayrı tablo olmaz; olay türleri ve bağlam (bölüm, düğüm, ipucu sayısı) burada tutulur. |

**Teknik not (H-021 raporundan):**
- PostgreSQL, partition'lı tabloda partition anahtarını içermeyen UNIQUE kısıta izin vermez.
- Bu yüzden `learning_events.client_event_id` için şunlardan biri gerekir:
  - `(client_event_id, occurred_at)` bileşik UNIQUE;
  - ya da ayrı bir idempotentlik tablosu.
- ICERIK-MIMARISI §7.7'ye not düşüldü.

**Sürüm geçişi:** Bir bölümün yeni sürümünde düğüm silinirse, kullanıcı **en yakın sahne başı kontrol noktasına** taşınır. Kazanılmış ilerleme ve ipuçları kaybolmaz.

---

## 15. Ölçümler (Storyworld §14)

**Hikâye devamlılığı ile öğrenme sonuçları ayrı raporlanır.**

**Devamlılık:**
- Bölüm 1→2, 2→3 ve sezon sonuna geçiş oranları.
- **Kanca sonrası 24 saat ve 7 gün içinde dönüş.**
- Bölüm ortasında bırakma (düğüm bazında).
- "Hikâyeye devam" ile dönüşler.

**Öğrenme:**
- İlk denemede doğru oranı, ipucu kullanımı.
- 1, 3 ve 7 gün sonra hatırlama.
- **Geri çağrılan ifadelerin (`callbackPhrases`) sonraki bölümlerde ilk denemede doğru oranı.**

**Kalite:**
- Kanon tutarsızlığı bildirimleri.
- Düğüm başına zorluk; yeniden ayar için.

**Kuzey yıldızı (değişmedi):** Haftalık anlamlı öğrenme döngüsü. Bir bölümün kapısını geçmek bir döngü sayılır.

---

## 16. Değişen önceki kararlar

| Önceki | Yeni durum |
|---|---|
| K-10 "Yeni gelen" evreni + kısa seriler | Ana yapıya yükseldi: **The Missing Signal**, Alex yeni gelen. Kısa seriler **yan görev** oldu. |
| K-02 sekme "Öğren" | Öneri: "Hikâye" (K-30) |
| ICERIK-MIMARISI §6.2 Ana Sayfa kartları | §11.2 ile güncellendi |
| §6.3 ünite yolu | **Hikâye haritası** |
| §3.5 ünite ve ders kalıbı | **Bölüm anatomisi** (§7). Aynı pedagojik adımlar, oyun çerçevesinde. |
| §4.3 seriler | Ana dizi = hikâye; diğerleri yan görev |
| §7.2 yerleştirme testi | **Prolog** olarak hikâyeleşti; kurallar aynı |
| K-05 durum makinesi | Korunur. "Kanon kontrolü" onay kontrol listesine eklenir (K-34). |
| H-005 öğretmen karakteri | **Hi** (maskot asistan) + Alex'in tasarımı (H-030) |
| H-024 pilot | **S1·B1 "A Strange Message"** etkileşimli bölüm + 3 klip |
| CLAUDE.md CEFR tablosu, A1 video süresi | 80–150 kelime A1 hızında ~45–90 sn ediyor. Öneri: A1 hikâye videosu **45–90 sn** (K-35). |

---

## 17. Karar listesi (H-029)

| # | Karar | Öneri |
|---|---|---|
| K-21 | Konsept | *The Missing Signal* temel alınsın. Telsiz, Alex'in büyükannesinden kalsın (Türkiye bağı). |
| K-22 | Kahraman | **Alex**; ~18–19 yaşında, şehre yeni gelmiş. **Hibrit:** ara sahnede görünür, karar anında POV ya da omuz üstü. Kullanıcı Alex'in repliklerini seçer. Özelleştirme yok. Ad ve cinsiyet karakter kitabında (H-030). |
| K-23 | Yol arkadaşı | AI öğretmen = **Hi**, Alex'in telefonundaki maskot asistan. Türkçe desteği sezonlar ilerledikçe azalır. |
| K-24 | Görsel tarz | Fotogerçekçi olmayan animasyon dizi / çizgi roman tonu. Model pilotta seçilir. |
| K-25 | Seviye ve hikâye | MVP'de **Model A** (sezon = seviye). Pilottan sonra **C** (A + hızlı başlangıç). |
| K-26 | Sezon 1 ve yayın | 12 bölüm + isteğe bağlı prolog, A1. **Üretim önde:** lansmandan önce büyük kısmı hazır. Lansmanda 4 bölüm açık, sonra haftada 1. Yayınlanmış bölümler hep açık. |
| K-27 | Bölüm anatomisi | 9 adım, 5–8 dk. A1–A2'de sahne başına 1–2, bölüm başına en fazla 4 karar anı. Karar anında müzik ve hareket kısılır. |
| K-28 | Dallanma | Dal ve dar boğaz. Yanlış seçim aynı karar anına döner. Ton bayrağı bölüm başına en fazla 3. Zaman mağarası ve çoklu son yok. |
| K-29 | Kilit | Bölüm kapısı (anlama + hedef ifade + 1 aktif görev). Zaman kilidi yok. |
| K-30 | Sekme | "Öğren" → "Hikâye" (K-02 revizyonu) |
| K-31 | MVP oyun sistemleri | Harita, görev kartı, ipucu panosu, defter, anı albümü, sezon özeti, yan görevler. P1: meydan okuma modu, karakter güveni. |
| K-32 | Yasaklar | §9'daki liste |
| K-33 | Klasör | `icerik/_evren/` + K-01 bölüm klasörleri. `story/` yapısı kullanılmaz. |
| K-34 | Onay akışı | K-05 korunur; kanon kontrolü onay kontrol listesine madde olarak eklenir |
| K-35 | A1 video süresi | 30–60 sn yerine 45–90 sn |

**Bağımlı kararlar:**
- H-007: konuşma pratiğinin MVP'deki yeri. Etkisi: canlı sahne olacak mı?
- H-015: telaffuz puanı.
- H-028: kanon ve dil incelemesini kim yapacak?

---

## 18. Riskler

| Risk | Azaltma |
|---|---|
| **Üretim hacmi:** Lansmanda 12 bölümün hazır olması ilk sürümü geciktirir | Pilotla bölüm başına emek ölçülür (H-024). Gerekirse S1 lansmanda 8 bölüm olur (sezon ortası açılımına kadar), kalanı haftalık yayınlanır. |
| **Karakter tutarlılığı:** Yaklaşık 60 bölüm boyunca aynı yüzler | Referans set, stil öneki, insan kontrolü. Maskot ve çizgi tarz riski azaltır. |
| **Kanon kayması:** Karakterin önceki bölümle çelişmesi | `CANON_AND_TIMELINE.md`, `OPEN_QUESTIONS.md`, `content-lint` uyarısı, kanon kontrol maddesi |
| **Hikâyenin öğrenmeyi gölgelemesi** (dikkat dağıtan süs öğeleri) | Her mekanik dil kullanımına bağlı. Dil dışı mini oyun yok. Öğrenme ve devamlılık ayrı ölçülür. |
| **Tahminle ilerleme** | Çeldiriciler, farklı etkileşim türleri, ilk deneme kanıtı |
| **Yetişkinin çocuksu bulması** | Ton ve görsel tarz; Alex ~18–19 yaşında |
| **Doğrusal hikâyenin hızlı öğrenciyi bekletmesi** | Atlanabilir ara sahne, meydan okuma modu, prolog ile yerleştirme |
| **B1+ kullanıcılar için lansmanda içerik yok** | Dürüst mesaj; Model C sonrası |
| **Kancanın manipülasyona kayması** | §4.5 kuralları; zaman kilidi ve suçlayıcı bildirim yok |

---

## 19. Araştırma doğrulaması

- **Storyworld belgesindeki kaynaklar** (2025 mobil oyun meta-analizi, 2025 AI hikâye çalışması, 2026 "story in gamification", 2025 scoping review) **olduğu gibi aktarıldı**, birincil kaynaktan okunmadı. Ortak mesajları:
  - hikâye bağlılığı artırabilir;
  - performans artışı garanti değildir.

  Bu yüzden ölçüm ayrımı (§15) zorunludur.
### 19.1 Web araştırması bulguları (2026-10-11)

**Etki ve oyun öğeleri**

| Bulgu | Kaynak | Tasarıma etkisi |
|---|---|---|
| Oyun tabanlı dil öğrenmede etki orta düzeyde: gruplar arası d≈0,50 (EFL'de d≈0,70–0,78). Yüksek değerler zayıf kontrol gruplarından geliyor. | Dixon ve ark. 2022; Kao 2014 | Etki vaadi verilmez; ölçülür (§15). |
| Ciddi oyunlarda öğrenme d=0,29, kalıcılık d=0,36; **motivasyon üstünlüğü anlamlı değil**. | Wouters ve ark. 2013 | Oyunlaştırma "tutma garantisi" olarak pazarlanmaz. |
| Oyunlaştırma: bilişsel etki g≈0,49–0,50; oyun öğesi türüne göre anlamlı fark yok. | Sailer & Homner 2020; Bai ve ark. 2020 | Anlatı ve can-do hedefi yeterli. XP ve puan tablosu gerekmez. |
| **Dikkat dağıtan süs öğeleri** öğrenmeyi düşürüyor (g≈−0,33 [ikincil]); acemilerde ve tempoyu kontrol edemeyenlerde zarar daha büyük. | Sundararajan & Adesope 2020 | Karar anında video durur, müzik kısılır; karar anı sayısı sınırlı (§7). |

**Örnekler, kahraman ve dallanma**

| Bulgu | Kaynak | Tasarıma etkisi |
|---|---|---|
| Duolingo Adventures: yanlışta "Oh, did you mean…?" diye sürükleyici tepki veriyor. Duolingo'nun 2025 **enerji sistemi** ise ciddi tepki aldı. | Duolingo blog; Android Authority | Kibar tepki deseni benimsendi. Can ve enerji yok (§9). |
| Episode ve Choices: en iyi seçimler ve bekleme süresi satılıyor; temel şikâyet bu. | Common Sense; PocketGamer | Bekleme ve seçim asla satılmaz. |
| Wagotabi ve Influent: en çok övülen yan, kelime defteri ve aralıklı tekrar; temel şikâyet içeriğin az olması. | Steam incelemeleri; basın | Defter + FSRS doğru seçim. İçerik kuraklığı planı şart (§4.6). |
| Birinci şahıs bakış sürüklenmeyi ve görev hafızasını artırıyor. Avatar özelleştirmenin etkisi zayıf. | Lindgren 2012; Denisova 2015; UPV 2024 | Hibrit kahraman (§5.2). Özelleştirme yok. |
| "Kahraman öğrenciyle birlikte dil öğrenir" modeline en yakın örnek Extr@'daki Hector. | Extr@ | Alex'in dil yayı benimsendi. |
| Dal ve dar boğaz ölçeklenebilir; zaman mağarası maliyeti katlar. Görünür geri dönüşler ajans hissi veriyor. | Ashwell; Fendt 2012; Cardona-Rivera 2014 | §8.2 |

**Seri, etik ve teknik**

| Bulgu | Kaynak | Tasarıma etkisi |
|---|---|---|
| Haftalık yayın devamı yaklaşık %48 artırıyor; aşırı toplu izleyenlerde tutma düşüyor. Cliffhanger devam isteğini artırıyor, keyfi düşürmüyor. | de Matos ve ark.; Buffalo deneyi | §4.6: üretim önde, yayın haftalık. Kanca kullanılır. |
| ICO Children's Code Standart 13: mola önerisi, bölüm ortasında kaydetme, gizlilik yönünde dürtme yasağı. AB CPC 2025 sanal para ilkeleri; AB Digital Fairness Act gündemi [nihai metin doğrulanmadı]. | ICO; AB CPC | Mola kartı (K-15), sahne başı kontrol noktası, sanal para yok. |
| Türkiye: 15 yaş altına sosyal medya sınırı, yaş doğrulama ve oyun dağıtıcılarına temsilci zorunluluğu getiren düzenleme [kanun no ve hükümler doğrulanmadı]. | Basın | H-002'ye not. Uygulama sosyal ağ sayılmamalı (beğeni ve yorum yok). |
| Apple'ın yeni yaş derecesi anketi AI sohbet özelliğini soruyor. | Apple, 07.2025 | H-002 / H-007 |
| Flutter'da dallanan video için hazır paket **yok**. `video_player` 2.14.1'de önyükleme API'si yok; iki-üç denetleyiciyle ön ısıtma deseni (VGV) kullanılabilir. | pub.dev; VGV | Sahne grafı, karar katmanı ve durum yönetimi kendimiz yazılır. Düşük uçlu Android'de **erken prototip** (H-031). |

**Doğrulanamayanlar:**
- Wouters 2013 ve Sailer & Homner 2020'deki anlatı moderatörü sonuçları;
- Duolingo Adventures'ın ücretli olup olmadığı;
- Türkiye'deki kanunun numarası ve oyun hükümleri;
- AB Digital Fairness Act'in nihai metni.
