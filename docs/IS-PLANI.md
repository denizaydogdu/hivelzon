# hiVelzon — İş ve Ürün Planı

> **Sürüm:** 0.1 (taslak, kullanıcı onayı bekliyor) · **Tarih:** 2026-10-11
> **Sahibi / veri sorumlusu:** Velzon Bilişim Teknolojileri Ltd. Şti. (Eskişehir · info@velzon.tr)
> **Durum:** Bu belge onaylanana kadar **kod yazılmaz** (bkz. `CLAUDE.md`).

## Özet (1 dakikada)

- **Ne:** Yapay zekâ ile üretilmiş videolarla İngilizce öğreten, iOS + Android mobil uygulama. Tüm seviyeler (A1–C1), **tamamen ücretsiz**.
- **Dört ayak:**
  1. Velzon'un Higgsfield ile ürettiği hazır ders videoları
  2. Yapay zekâ ile konuşma pratiği
  3. Kişiselleştirilmiş etkinlikler / videolar
  4. ~30 saniyelik kısa video akışı
- **En büyük risk:** "Ücretsiz" ile "kullanıcı başına yapay zekâ" birbirine ters düşer.
  - Hazır videolar ve kısa video akışı kullanıcı sayısıyla neredeyse hiç pahalılaşmaz.
  - Konuşma pratiği ve kullanıcıya özel video ise **kullanıcı arttıkça doğrusal büyür**.
  - Örnek: kotasız konuşma pratiği 100 bin aylık aktif kullanıcıda (MAU) ayda **~13–39 bin USD** tutar. Kullanıcıya özel video aynı ölçekte ayda **84 bin USD'nin üzerinde** tutar (§8).
- **Öneri:** "Ücretsiz" kararı korunur. Ama:
  - konuşma pratiği **günlük ücretsiz kota** ve **Velzon'un belirlediği aylık bütçe tavanı** arkasında açılır;
  - kullanıcıya özel video üretilmez; kişiselleştirme ucuz yollarla yapılır (etkinlik, tekrar, şablon video).
- **İlk yapılacak:** hazır dersler + kısa video akışı + quizler (MVP). Yapay zekâ konuşması v1'de, kotalı gelir.
- **Teknoloji:** Flutter + Spring Boot 4 + PostgreSQL. KVKK, denetim kaydı, rıza ve hesap silme baştan tasarlanır.

---

## 1. Vizyon ve değer önerisi

**Vizyon:** Türkiye'de herkesin, parası olsun olmasın, her gün birkaç dakika İngilizce dinleyip konuşabildiği, sıcak ve güvenli bir uygulama.

**Değer önerisi (kullanıcı gözünden):**

| Kullanıcının derdi | hiVelzon'un cevabı |
|---|---|
| "Uygulamalar pahalı, abonelik istiyor." | Tamamen ücretsiz; reklam yok (öneri). |
| "Kelime ezberliyorum ama konuşamıyorum." | Her gün kısa konuşma pratiği (kotalı ama ücretsiz). |
| "Ders sıkıcı, motivasyonum düşüyor." | Akıcı, 30 saniyelik kısa videolar; seri (streak) ve küçük hedefler. |
| "Türkçe açıklama istiyorum." | Türkçe arayüz, TR/EN altyazı, Türk öğrencinin tipik hatalarına özel içerik (ör. *th* sesi, *-s* takısı, *a/the*). |
| "Seviyeme uygun değil." | Başta seviye testi, sonra seviyeye göre akış ve tekrar. |

**Farklılaşma:**
1. **Türk öğrenciye özel:** içerik Türkçe konuşanların hatalarına göre yazılır. Rakiplerin çoğu tek bir genel müfredatı çevirir.
2. **Ücretsiz konuşma pratiği:** Duolingo Max, Speak ve Praktika'da bu özellik ücretlidir (§3).
3. **Kısa video akışı:** TikTok alışkanlığını öğrenmeye çevirir.
4. **Tutarlı yapay zekâ öğretmen karakteri:** her videoda aynı yüz ve ses. Marka bağı kurar.

**Ölçülebilir hedef (12 ay, öneri):** 10 bin MAU, 30. gün tutma oranı ≥ %15, haftada en az 3 gün aktif kullanıcı oranı ≥ %25 (§12).

---

## 2. Hedef kitle ve personalar

Kitle: **herkes, A1–C1**. Ancak ürün ve hukuk kararları yaşa göre çok değişir. Bu yüzden ilk sürüm için **13 yaş ve üstü** öneriliyor (§9).

| Persona | Yaş / seviye | Amaç | Ne kullanır | Not |
|---|---|---|---|---|
| **Elif, lise öğrencisi** | 16, A2–B1 | Okul dersi, YDS/YKS dil | Kısa video, quiz, kelime tekrarı | **13–17 grubu:** veli onayı ve yapay zekâ sohbetinde ek güvenlik gerekir. Açık karar (§13). |
| **Mert, üniversiteli** | 21, B1 | Erasmus, staj mülakatı | Konuşma pratiği, B1–B2 dersler | En yoğun konuşma pratiği kullanıcısı; kota en çok ona dokunur. |
| **Ayşe, çalışan** | 32, A2 | İş yazışması, toplantı | Günde 5 dakika ders, iş İngilizcesi senaryoları | Akşam ve hafta sonu kullanır; bildirim saatini kendi seçmeli. |
| **Hasan, emekli** | 61, A1 | Torunla, yurt dışı gezisi | Yavaş videolar, TR altyazı, büyük yazı | Erişilebilirlik: büyük yazı tipi, yavaş oynatma. |
| **Deniz, ileri seviye** | 27, C1 | Akıcılık, aksan, kelime inceliği | Konuşma pratiği, telaffuz puanı | Hazır içerik az gelir; kişiselleştirme ve yapay zekâya ihtiyaç duyar. |
| **Can, ilkokul** | 9, ön-A1 | Oyunla öğrenme | — | **13 yaş altı.** MVP kapsamı dışında önerilir. Ayrı bir "çocuk modu" gerekir (§9, §13). |

**13 yaş altı ve 13–17 sorusu (özet):**
- **13 yaş altı:**
  - Apple "Kids" kategorisi ve Google Play "Families" politikası devreye girer: üçüncü taraf analitik/reklam yasağı, veli kapısı, uygun içerik.
  - Yapay zekâ sohbeti ve ses kaydı çocuklar için ayrıca risklidir.
  - **Öneri:** MVP'de 13 yaş altı alınmasın. İleride ses kaydı ve serbest sohbet içermeyen ayrı bir çocuk modu değerlendirilsin.
- **13–17:**
  - KVKK'da açık rıza ehliyeti ve veli izni tartışmalıdır. GDPR m.8'de yaş sınırı ülkeye göre 13–16 arasında değişir.
  - **Öneri:** Hazır videolar, kısa video akışı ve quizler serbest olsun. Yapay zekâ konuşması ve ses verisi için veli onayı istensin ya da 18 yaş sınırı konsun. **Hukukçu görüşü alınmalı.**

---

## 3. Rakip analizi

> Kaynaklar 2026-10-11'de web aramasıyla toplandı. **[Doğrulanmadı]** etiketi taşıyan bilgiler resmi bir kaynaktan teyit edilemedi. Fiyatlar çoğunlukla ABD fiyatıdır. Türkiye mağaza fiyatları bölgesel olarak farklıdır; kontrol edilmeli.

| Rakip | Ne sunuyor | Ölçek (son bilinen) | Fiyat | hiVelzon için ders |
|---|---|---|---|---|
| **Duolingo** | Oyunlaştırılmış dersler, seri. Max planında yapay zekâ "Video Call" (Lily) ve Roleplay. | Q2 2026: **58,7 milyon DAU** (yıllık +%23), **12,7 milyon ücretli abone**, çeyreklik gelir 298,5 milyon USD [1] | Max ≈ 29,99 USD/ay veya 168 USD/yıl (ABD) [2] [Türkiye fiyatı doğrulanmadı] | Seri ve oyunlaştırma çok güçlü. Duolingo'nun yapay zekâ konuşması ücretli bölümde; hiVelzon burada ücretsiz kalarak farklılaşabilir. |
| **Babbel** | Uzman müfredatı. "Babbel Speak": Eylül 2025'te Conversation Coach'un yerini aldı, senaryolu yapay zekâ konuşması. | 2025 itibarıyla toplam 25 milyonun üzerinde satılmış abonelik [3] [ikincil kaynak] | Abonelik [güncel fiyat doğrulanmadı] | Senaryo temelli konuşma ("kafede sipariş") A1–B1 için iyi bir kalıp. |
| **Cambly** | Gerçek anadili İngilizce olan eğitmenlerle görüntülü ders; Cambly Kids. | 10 milyonun üzerinde kullanıcı [4] [ikincil kaynak] | Plana göre değişir. Bir kaynak günde 15 dakika için ~129 USD/ay; Kids ~9,99 USD/ay'dan başlıyor [5] [doğrulanmadı] | İnsan eğitmen pahalı. hiVelzon'un yapay zekâ pratiği "Cambly'ye hazırlık" gibi konumlanabilir. |
| **Praktika** | Yapay zekâ avatar öğretmenler (farklı aksanlar, duygu ve ton). | Mayıs 2024'te 35,5 milyon USD Seri A; 1,2 milyon aylık aktif kullanıcı ve ~20 milyon USD yıllık gelir (o tarihte) [6] | Abonelik [güncel fiyat doğrulanmadı] | **En yakın rakip konsept:** avatar öğretmen + konuşma. Fark: Praktika ücretli; hiVelzon ücretsiz ve Türkçeye özel. |
| **Speak** | Sesli konuşma odaklı yapay zekâ öğretmen. OpenAI teknolojisi kullanıyor. | Aralık 2024'te 78 milyon USD Seri C, 1 milyar USD değerleme, 10 milyonun üzerinde kullanıcı [7] | Abonelik [doğrulanmadı] | "Önce konuş" yaklaşımı ve Kore'deki başarı, konuşma pratiğine talep olduğunu gösteriyor. |
| **ELSA Speak** | Telaffuz puanlama (ses, akıcılık, tonlama, vurgu). | [Güncel kullanıcı sayısı doğrulanmadı] | Premium ~13,33 USD/ay'dan başlıyor; takım planı 18,20 USD/kullanıcı/ay [8] | Telaffuz puanı tek başına bir ürün olabilir. Biz bunu hazır bulut servisiyle (Azure) ucuza ekleyebiliriz (§6). |
| **Türk rakipler** | **Konuşarak Öğren:** canlı eğitmenle konuşma pratiği, 6–65 yaş [9]. **Learnai, Talkinn, SmartTalk** gibi bağımsız Türk geliştiricilerin yapay zekâ konuşma uygulamaları App Store'da [10][11]. MEB 2025–2026'dan itibaren ortaokulda İngilizce ders saatini artırıyor [12]. | [Kullanıcı sayıları doğrulanmadı] | Çoğu abonelik veya ders paketi [doğrulanmadı] | Türk pazarında "yapay zekâ ile konuş" uygulamaları çoğalıyor ama dağınık ve küçük. Ücretsiz, kaliteli videolu ve güvenilir (KVKK uyumlu) bir yerli ürün için boşluk var. |

**Sonuç:**
1. Pazar büyük ve büyüyor; Duolingo hâlâ yılda %20'nin üzerinde büyüyor.
2. Yapay zekâ konuşması artık rakiplerin **ücretli** özelliği; ücretsiz sunmak güçlü bir kanca olur ama maliyet riski taşır (§8).
3. Video tabanlı, tutarlı öğretmen karakterli **ve** Türkçeye özel bir ürün görülmedi.

---

## 4. Ürün kapsamı: dört ayak

### 4.0 Genel kullanıcı akışı

```
İlk açılış → Dil (TR/EN arayüz) → Yaş beyanı → Hedef ("neden öğreniyorsun?")
→ Seviye testi (5–8 dk, atlanabilir → A1 varsayılır)
→ Hesap (Apple/Google/e-posta) + aydınlatma metni + rızalar
→ Ana ekran: "Bugünün planı" (1 ders + 3 kısa video + 1 tekrar + [konuşma])
```

Alt menü (öneri): **Bugün** · **Akış** (kısa videolar) · **Dersler** · **Konuş** · **Profil**.

### 4.1 Ayak 1 — Hazır ders videoları

**Bir ders nasıl işler (8–12 dakika):**
1. **Isınma (30 sn):** Önceki dersten 2 hızlı tekrar sorusu.
2. **Video (2–4 dk):** Yapay zekâ öğretmen konuyu anlatır. Sahneler gerçek hayattan seçilir (havalimanı, kafe, ofis). Altyazı TR, EN veya kapalı olabilir. Hız 0,75x / 1x seçilir. Video içinde 1–2 duraklama noktası ("Sence ne diyecek?").
3. **Anlama quizi (2 dk):** 4–6 soru: çoktan seçmeli, boşluk doldurma, dinle-seç, sırala.
4. **Kelime kartları (1 dk):** Dersin 5–8 kelimesi tekrar destesine eklenir.
5. **Söyle (1–2 dk, isteğe bağlı):** 3 cümleyi sesli tekrar. Telaffuz puanı v1'de gelir.
6. **Özet:** Kazanılan puan, seri, sonraki ders.

**Müfredat:** CEFR'e göre A1 → C1. Her seviyede ~8–10 ünite, her ünitede 4–6 ders. Toplam hedef 250–300 ders, **ama kademeli** (§11). MVP: A1–A2'de 20 ders.

### 4.2 Ayak 2 — Yapay zekâ konuşma pratiği

**Modlar:**
- **Senaryo (A1–B1):** "Kafede sipariş ver". Hedef cümleler bellidir, yapay zekâ yönlendirir, ipucu düğmesi vardır.
- **Serbest sohbet (B1–C1):** Kullanıcının ilgi alanından konu seçilir; yapay zekâ seviyeye göre konuşur.
- **Mülakat / sınav provası (B2–C1):** İş mülakatı, IELTS konuşma bölümü tarzı sorular.

**Akış:**
- Mikrofona bas-konuş (ilk sürümde sürekli dinleme yok; maliyeti ve gizliliği kolaylaştırır).
- Yapay zekâ sesli cevap verir, metin de görünür.
- Oturum **5 dakika** ya da yaklaşık **10 tur** sürer.
- Sonda **geri bildirim kartı:** 3 düzeltme, 3 yeni ifade, akıcılık notu. Bu ifadeler tekrar destesine eklenir.
- **Metin modu:** Sesi olmayan ya da ses rızası vermeyen kullanıcı yazarak konuşur. Daha ucuzdur ve biyometrik veri tartışması doğmaz.

**Kota (öneri, §8):** Günde 1 ücretsiz sesli oturum (~5 dk) ve 3 metin oturumu. Seri ödülüyle ek oturum kazanılabilir. Kota dolunca hazır içeriğe yönlendirilir.

**Güvenlik:**
- Yapay zekâ sadece İngilizce öğretim rolünde kalır, konu dışı ve zararlı isteği reddeder.
- Her yanıtın yanında **"bildir"** düğmesi bulunur (Google Play yapay zekâ içerik politikası bunu istiyor [13]).
- 18 yaş altı için daha sıkı sistem talimatı kullanılır.

### 4.3 Ayak 3 — Kişiselleştirme

Ayrıntı §7'de. Kısaca:
- **Kişisel günlük plan** ve **aralıklı tekrar (SRS)** yapılır.
- İlgi alanına göre **etkinlikler** üretilir (yapay zekâ ile, önbelleğe alınarak).
- "Kişisel video" kullanıcıya özel üretilmez. Önceden üretilmiş **şablon varyantlar** arasından seçilir.

### 4.4 Ayak 4 — Kısa video akışı (~30 sn)

- **Format:** Dikey 9:16, 15–40 saniye. Tek bir fikir: "Bir deyim", "Türklerin en sık yaptığı hata", "*th* nasıl söylenir", "60 saniyede *present perfect*".
- **Etkileşim:**
  - kaydır;
  - beğen;
  - kaydet (destene ekle);
  - videonun sonunda **tek soruluk mini quiz** (isteğe bağlı).
- **Sıralama:**
  - basit kurallarla başlanır: seviye eşleşmesi, izlenmemiş içerik, kaydetme ve tamamlama oranı;
  - makine öğrenmesi yoktur;
  - yorum yoktur (moderasyon yükü olmaz).
- **İçerik:** Velzon üretir; kullanıcı yüklemesi **yoktur**. Bu bilinçli bir karar: moderasyon, telif ve çocuk güvenliği riskini sıfırlar.

### 4.5 Seviye testi

- **Uyarlamalı, 15–25 soru:**
  - kelime;
  - dilbilgisi;
  - dinleme (kısa klipler);
  - okuma.
- Doğru cevapta soru zorlaşır, yanlışta kolaylaşır.
- Konuşma testi MVP'de yoktur. Konuşma pratiği gelince isteğe bağlı 1 dakikalık "konuş" adımı eklenebilir.
- **Sonuç:** CEFR seviyesi ve alt beceri profili (dinleme / kelime / dilbilgisi).
- Kullanıcı seviyesini elle değiştirebilir. Her 4 haftada bir kısa yeniden değerlendirme yapılır.

### 4.6 İlerleme

- **Seviye çubuğu:** Mevcut CEFR seviyesindeki ünitelerin yüzde kaçı bitti.
- **Beceri radarı:** Dinleme, kelime, dilbilgisi, konuşma.
- **Kelime sayacı:** Öğrenilen ve "olgun" (SRS'te 21 günden uzun aralıklı) kelime sayısı.
- **Haftalık özet:** Pazar günü bildirim ve uygulama içi kart.

### 4.7 Oyunlaştırma ve seri

- **Seri (streak):**
  - günde en az 1 "anlamlı etkinlik" seriyi sürdürür (1 ders, 3 kısa video + quiz ya da 1 konuşma oturumu);
  - **seri dondurma:** haftada 1 ücretsiz;
  - seri kaybında 24 saat içinde "kurtarma" görevi verilir (Duolingo bunun DAU'ya etkisini raporladı [1]).
- **XP ve günlük hedef:** 10 / 20 / 30 dakika seçilir.
- **Rozetler:** "İlk konuşma", "7 gün seri", "100 kelime" gibi.
- **Lig / sıralama:** MVP'de yoktur, v2'de değerlendirilir. Sıralama sosyal baskı ve çocuk güvenliği riski getirir; isteğe bağlı olmalıdır.
- **Bildirimler:** Kullanıcının seçtiği saatte, günde en fazla 1 hatırlatma. Bildirim izni sonradan istenir.

---

## 5. İçerik üretim hattı (Higgsfield)

### 5.1 Öğretmen karakteri

- **Kurgusal** bir öğretmen karakteri (ör. çalışma adı "Miss Hi" / "Mr. Velzon"). Higgsfield **Soul ID** ile eğitilir. Soul ID, aynı yüzün tüm görsel ve videolarda tutarlı kalmasını sağlar.
  - Karakterin "kaynak yüzü" de yapay zekâ ile üretilir (Soul 2.0 görsel ≈ 0,12 kredi).
  - **Gerçek bir kişinin yüzü kullanılmaz.** Kullanılacaksa yazılı muvafakat ve KVKK aydınlatması şarttır; Higgsfield koşulları da gerçek kişi yüzü ve sesi için gerekli izinleri şart koşar [14].
- İlk sürümde **1 ana öğretmen** olur. v1'de 2. karakter (farklı aksan: İngiliz / Amerikan) ve 2–3 yan karakter (diyalog için) eklenir.
- **Ses:**
  - her karakterin tek ve sabit bir TTS sesi olur (Higgsfield içindeki ElevenLabs v4 / Seed Audio ya da harici TTS);
  - ses klonlama **yapılmaz**;
  - sesler `docs/` altında bir "karakter kartı"na yazılır (yüz, ses, kişilik, konuşma tarzı).

### 5.2 Ders videosu üretim adımları

```
1. Müfredat maddesi (CEFR, hedef kelime/yapı, Türk öğrenci hatası)
2. Senaryo (yapay zekâ taslağı + insan editör): sahne listesi, replikler, ekrandaki yazılar
3. Ses: replikler → TTS (karakter sesi) — ses önce üretilir, video ona göre
4. Görüntü:
   a. Öğretmen konuşan kafa çekimleri (Soul ID + dudak senkronu / sesli video modeli)
   b. Sahne / B-roll çekimleri (ucuz video modeli, 5–10 sn'lik parçalar)
   c. Durağan slaytlar (kelime kartı, dilbilgisi tablosu) — kredi harcamaz
5. Kurgu: parçaları birleştir, müzik, geçişler (yerel araç, ör. ffmpeg/CapCut/DaVinci)
6. Altyazı: EN (senaryodan birebir) + TR (çeviri + insan kontrolü), SRT/VTT ayrı dosya
7. Quiz: senaryodan yapay zekâ taslağı → editör onayı
8. Kalite kontrolü (aşağıda) → yayın (CDN) → uygulamada görünür
```

Her video için `icerik/<id>/` altında şunlar saklanır: senaryo, prompt'lar, kullanılan model, kredi harcaması ve altyazı dosyaları.

### 5.3 Kredi maliyetleri (ölçülen)

`higgsfield generate cost` ile 2026-10-11'de ölçüldü. Bu ölçüm kredi harcamaz.

| Model | Ayar | Kredi | Kredi/sn |
|---|---|---|---|
| Seedance 2.0 Mini | 10 sn, 720p | 10 | **1,0** |
| Seedance 2.0 Mini | 5 sn | 5 | 1,0 |
| Google Veo 3.1 Lite | 8 sn | 12 | 1,5 |
| Kling 3.0 | 10 sn | 17,5 | 1,75 |
| Wan 3.0 | 10 sn | 17,5 | 1,75 |
| Gemini Omni Flash | 10 sn | 30 | 3,0 |
| Seedance 2.5 | 10 sn, 480p | 30 | 3,0 |
| Google Veo 3.1 | 8 sn | 32 | 4,0 |
| Seedance 2.5 | 10 sn, 720p (sesli) | 70 | **7,0** |
| Soul 2.0 görsel | 1 görsel | 0,12 | — |
| Seed Audio (kısa ses) | 1 cümle | 0,3 | — |

**Kredinin dolar karşılığı:**
- Plana göre değişir. Bir 2026 kaynağına göre Starter planında ~0,075 USD/kredi, üst planda ~0,028 USD/kredi [15].
- Başka bir kaynak farklı plan adları ve fiyatlar veriyor [16].
- Hesabımız **"lite" planda, 244,25 kredi** kaldı. Lite planın aylık ücreti ve kredi miktarı **doğrulanmadı**.

**Tahmini üretim maliyeti:**
- Varsayım: 1,5 kat yeniden çekim payı. Ders videolarında üçte biri slayt (kredisiz).

| İçerik | Ucuz karışım (Seedance Mini / Kling) | Kaliteli karışım (Seedance 2.5 sesli öğretmen + Mini B-roll) |
|---|---|---|
| 3 dk ders videosu (~120 sn yapay zekâ videosu) | ~180–320 kredi (≈ 5–24 USD) | ~600–900 kredi (≈ 17–68 USD) |
| 30 sn kısa video | ~45–80 kredi (≈ 1,3–6 USD) | ~150–315 kredi (≈ 4–24 USD) |

**Mevcut 244 kredi ancak bir pilot için yeter:** 1 kısa ders + 2–3 kısa video ya da sadece maliyet ve kalite denemesi. Üretime geçmek için plan yükseltmesi gerekir (§13, H-004).

### 5.4 Haftalık üretim hızı (öneri)

| Dönem | Haftalık hedef | Aylık kredi (ucuz karışım) | Gereken plan |
|---|---|---|---|
| Pilot (Faz 0) | 1 ders + 3 kısa | ~500 | Lite + ek kredi ya da bir üst plan |
| MVP öncesi stok | 3 ders + 10 kısa | ~3.000–5.000 | Üst plan (~3.000 kredi) + ek paket |
| Yayın sonrası sürdürme | 2 ders + 7 kısa | ~2.000–3.500 | Üst plan |

**İnsan emeği darboğazdır:** Bir ders için senaryo, kurgu, altyazı ve kontrol ~3–5 saat; bir kısa video ~1 saat (tahmin). Haftada 2 ders + 7 kısa video ≈ **13–17 saat** içerik emeği eder. Bunu kimin yapacağı açık bir sorudur (§13).

**Yayın stoğu hedefi:**
- MVP'de **20 ders + 60 kısa video** (A1–A2) ile açılış önerilir.
- Bu stok ~9.000–12.000 kredi ister; üst planla ~3–4 ay sürer.
- Bu yüzden içerik üretimi **kodlamayla paralel ve hemen** başlamalıdır.

### 5.5 Kalite kontrolü (her video için kontrol listesi)

- [ ] Dil doğruluğu: anadili İngilizce olan biri ya da C2 seviyesinde bir editör dinledi; dilbilgisi ve telaffuz hatası yok.
- [ ] Altyazı senaryoyla birebir; TR çeviri doğal; zamanlama ±0,3 sn.
- [ ] Yapay zekâ kusuru yok: fazla parmak, bozuk yazı, dudak kayması, yüz değişimi.
- [ ] Öğretmen karakteri tutarlı (Soul ID).
- [ ] Sahnede marka, logo, telifli karakter veya gerçek kişi benzerliği yok.
- [ ] İçerik 13+ için uygun: şiddet, cinsellik, siyaset ve din yok; kültürel hassasiyet gözetildi.
- [ ] Ses seviyesi normalize; müzik telifsiz ya da lisanslı.
- [ ] Quiz cevapları doğru, çeldiriciler makul.
- [ ] Erişilebilirlik: altyazı var, kontrast yeterli.

### 5.6 Telif ve benzerlik kuralları

- **Sahiplik:** Higgsfield, üretilen içeriğin kullanıcıya ait olduğunu ve ticari kullanılabileceğini belirtiyor [14]. Ücretsiz uygulamada kullanım bu kapsamdadır. **Koşullar yayından önce yeniden okunmalı ve sürümü kaydedilmeli.**
- **Gerçek kişi:** Ünlü, öğretmen veya çalışan yüzü ya da sesi kullanılmaz. "X'e benzeyen" prompt'u yazılmaz.
- **Marka ve eser:** Gerçek marka logoları, film, dizi ve oyun karakterleri, şarkı sözleri kullanılmaz. Örnek cümlelerde kurgusal markalar kullanılır.
- **Yapay zekâ etiketi:** Videolarda ve mağaza açıklamasında "yapay zekâ ile üretilmiştir" ibaresi bulunur. Öğretmen karakterinin yapay zekâ olduğu açıkça söylenir; kullanıcı gerçek bir öğretmen sanmamalı.
- **Kayıt:** Her videonun prompt'u, modeli, tarihi ve onaylayan editörü saklanır. Telif itirazında kanıt olur.

---

## 6. Yapay zekâ konuşma pratiği mimarisi (kavramsal)

### 6.1 Boru hattı

```
Kullanıcı konuşur
  → [STT] Konuşmayı yazıya çevir (cihazda veya bulutta)
  → [Telaffuz puanı] (isteğe bağlı, sadece "Söyle" alıştırmalarında)
  → [LLM] Öğretmen yanıtı + düzeltme önerisi (sunucu üzerinden, kota kontrolüyle)
  → [TTS] Yanıtı seslendir (cihazda veya bulutta)
Kullanıcı duyar + metni görür
```

İstemci yapay zekâ sağlayıcısına **doğrudan bağlanmaz.** Her istek hiVelzon sunucusundan geçer. Sebepleri:
1. API anahtarı istemcide bulunmaz.
2. Kota ve bütçe tavanı sunucuda uygulanır.
3. Denetim kaydı tutulur.

### 6.2 Seçenekler

| Katman | Cihazda (ücretsiz) | Bulut (ücretli) | Not |
|---|---|---|---|
| **STT** | iOS Speech / Android SpeechRecognizer; Whisper tabanlı yerel model | Deepgram Nova-3 akış: ~0,0048 USD/dk [17]; Azure STT | Cihazdaki tanıma Türk aksanlı İngilizcede zayıf olabilir; pilotta ölçülmeli. Ses cihazdan çıkmazsa KVKK yükü çok azalır. |
| **Telaffuz puanı** | Yok (pratikte) | Azure Pronunciation Assessment: ~1,32 USD/saat (≈ 0,022 USD/dk) [18] | Sadece kısa "Söyle" alıştırmalarında kullanılır; serbest sohbette kullanılmaz. |
| **LLM** | Küçük yerel modeller (kalite ve pil sorunu) | **Claude Haiku 4.5:** 1 / 5 USD (milyon girdi / çıktı token). **Claude Sonnet 5.5:** 2 / 10 USD. Önbellekten okuma ~0,1 kat (Haiku). Kaynak: Anthropic fiyat sayfası [19] | Öneri: **Haiku 4.5** varsayılan. Geri bildirim özeti gibi zor işler için Sonnet 5.5. Sistem talimatı önbelleğe alınır. |
| **TTS** | iOS AVSpeechSynthesizer / Android TTS | Azure nöral: ~15 USD / 1 milyon karakter [18]; Deepgram Aura-2: 0,030 USD / 1.000 karakter, Aura-1: 0,015 USD [17] | Cihaz sesi robotik olabilir. Öğretmen karakter sesi için bulut TTS tercih edilir; sık cümleler önbelleğe alınır. |
| **Uçtan uca ses modeli** | — | OpenAI gpt-realtime: gerçekçi bütçe ~0,06–0,11 USD/dk, mini model ~0,02–0,05 USD/dk [20] | En doğal ve en düşük gecikmeli seçenek ama en pahalısı. Sağlayıcıya bağımlılık getirir. v2'de yeniden bakılır. |

### 6.3 Gecikme

Hedef: kullanıcı sustuktan sonra **ilk sesin 1,5 saniyenin altında** gelmesi.

| Adım | Tipik süre |
|---|---|
| Konuşmanın bittiğini anlama (bas-konuş ile sıfır) | 0–300 ms |
| STT son metin | 200–500 ms (akışta) |
| LLM ilk token | 400–900 ms (Haiku, kısa bağlam) |
| TTS ilk ses parçası | 200–400 ms (akışla) |
| **Toplam** | **~0,9–2,0 sn** |

**Teknikler:**
- Her şey akış (streaming) ile çalışır.
- LLM cümle cümle TTS'e verilir.
- Kısa sistem talimatı önbelleğe alınır.
- Sunucu Türkiye'ye yakın bir bölgede (AB) konumlanır.

### 6.4 Öneri

- **MVP:** Konuşma pratiği yoktur.
- **v1 başlangıç konfigürasyonu:**
  - STT cihazda (izin varsa), değilse Deepgram;
  - LLM Claude Haiku 4.5;
  - TTS bulut (Azure, öğretmen sesi);
  - telaffuz puanı yalnızca "Söyle" alıştırmalarında.
- **Metin modu** her zaman açıktır; en ucuz ve rızasız çalışabilen yol budur.
- Sağlayıcılar bir **ara katman arkasında** tutulur. Böylece fiyat değişince sağlayıcı değiştirilebilir.

---

## 7. Kişiselleştirme

| Ne | Nasıl | Maliyet | Öneri |
|---|---|---|---|
| **Günlük plan** | Kurallar: seviye, hedef süre, eksik beceri, SRS'te bekleyen kartlar | ~0 (sunucuda basit hesap) | **MVP** |
| **Aralıklı tekrar (SRS)** | FSRS veya SM-2 algoritması; kelime ve ifade kartları | ~0 | **MVP** |
| **Seviyeye ve ilgiye göre akış sıralaması** | Etiketler (seviye, konu, ilgi) + izleme ve tamamlama oranı | ~0 | **MVP** (basit kurallar) |
| **Hata defteri** | Quizde ve konuşmada yapılan hatalar tekrar destesine eklenir | ~0 | **MVP** (quiz), v1 (konuşma) |
| **İlgiye göre okuma ve alıştırma metni** | LLM ile üretilir; **(seviye × konu × ilgi) anahtarıyla önbelleğe alınır**, aynı anahtarı isteyen herkes aynı metni alır | Bir kez üretim: ~0,005–0,02 USD/metin. 5 seviye × 30 konu × 10 ilgi = 1.500 metin ≈ **10–30 USD bir defalık** | **v1** |
| **Konuşma senaryosu kişiselleştirme** | Sistem talimatına kullanıcının seviyesi, ilgi alanı ve son hataları eklenir | Konuşma maliyetine dahil (§8) | v1 |
| **Şablon kişisel video** | Önceden üretilmiş varyantlar (ör. aynı ders "futbol" / "müzik" / "iş" temalı 3 sürüm). Kullanıcıya ilgisine en yakın sürüm gösterilir. İsim gibi kişisel öğe sadece **uygulama arayüzünde** gösterilir, videoya gömülmez. | Varyant sayısı × üretim maliyeti. Kullanıcı sayısından **bağımsız**. | **v2** |
| **Kullanıcıya özel üretilen video** | Her kullanıcı için ayrı Higgsfield üretimi | Ucuz modelde 30 sn ≈ 30 kredi ≈ **0,8–2,3 USD/video**; kaliteli modelde ≈ 6–16 USD. Ayrıca dakikalar süren üretim, denetimsiz içerik riski ve Higgsfield abonelik planlarının bu ölçeğe uygun olmaması (API ve kurumsal fiyat doğrulanmadı). | **Önerilmez** (§8) |

**Öneri:** "Kişiselleştirilmiş video" vaadi, **önceden üretilmiş varyantlardan seçim** olarak karşılanmalıdır. Gerçek anlamda kişiselleştirme **etkinlik ve tekrar** düzeyinde yapılır. Bu yolla kişiselleştirmenin kullanıcı başı maliyeti sıfıra yakın kalır.

---

## 8. Maliyet modeli ve ücretsiz modelin sürdürülebilirliği

> **Bu bölüm planın en kritik kısmıdır.** Rakamlar yaklaşık değerlerdir. Fiyatlar 2026-10 itibarıyla kamuya açık listelerden alındı (§3 ve §6 kaynakları). Tutarlar USD'dir; KDV, kur farkı ve sağlayıcı minimumları hariçtir.

### 8.1 Sabit ve yarı sabit maliyetler (kullanıcı sayısıyla az değişir)

| Kalem | Aylık tahmin | Not |
|---|---|---|
| Higgsfield içerik üretimi | ~50–130 USD (üst plan) + ek kredi | §5.4. Asıl maliyet insan emeği. |
| Sunucu (API + PostgreSQL) | ~20–80 USD | Sunucu kiralama kararına bağlı. [Doğrulanmadı] |
| Video depolama ve CDN | 1k MAU: ~5 USD · 10k: ~30 USD · 100k: ~200–400 USD | Varsayım: MAU başına ayda 20 izlenme × ~20 MB ≈ 100k MAU'da 40 TB. Çıkış trafiği ücretsiz veya ucuz bir depolama/CDN (ör. Cloudflare R2, Bunny) seçilmeli. **[Fiyatlar doğrulanmadı]** |
| Apple Developer + Google Play | ~99 USD/yıl + 25 USD tek sefer | Velzon'un mevcut geliştirici hesapları kullanılabilir. [Doğrulanmalı] |
| Alan adı ve e-posta | Mevcut (velzon.tr) | — |

**Sonuç:** Hazır video, kısa video akışı ve quiz ayakları **100 bin MAU'da bile ayda birkaç yüz dolar** düzeyinde kalır. Bu ayaklar ücretsiz modelle **sürdürülebilir**.

### 8.2 Konuşma pratiği: oturum başı maliyet

**Varsayımlar (bir sesli oturum):**
- 5 dakika ve 10 tur;
- kullanıcı ~2 dk, yapay zekâ ~2,5 dk konuşur (~375 kelime ≈ 2.100 karakter TTS);
- LLM her turda ~3.000 token girdi alır (~2.000'i önbellekten) ve ~150 token çıktı verir;
- oturum sonunda geri bildirim özeti: 4.000 token girdi, 500 token çıktı.

| Kalem | A) Tasarruflu (cihazda STT + TTS, Haiku) | B) Standart (bulut STT + TTS, Haiku, hafif telaffuz) | C) Premium (uçtan uca gerçek zamanlı ses modeli) |
|---|---|---|---|
| STT | 0 | 0,012 (2,5 dk × 0,0048) | dahil |
| LLM | 0,027 | 0,027 | dahil |
| TTS | 0 | 0,032 (Azure, 2.100 karakter) | dahil |
| Telaffuz puanı | 0 | 0,011 (30 sn Azure) | — |
| **Oturum başı** | **~0,03 USD** | **~0,08 USD** | **~0,30–0,55 USD** |
| Dakika başı | ~0,006 | ~0,016 | ~0,06–0,11 |

LLM hesabı (Haiku 4.5):
- Tur başına: 1.000 önbelleksiz × 1 USD/M + 2.000 önbellekten × 0,10 USD/M + 150 çıktı × 5 USD/M ≈ 0,002 USD.
- 10 tur ≈ 0,02 USD. Özet ≈ 0,0065 USD. Toplam ≈ **0,027 USD**.
- Sonnet 5.5 kullanılırsa LLM kalemi ~2 katına çıkar (~0,054 USD).
- **Metin modu** (STT ve TTS yok) oturum başı ~0,02–0,03 USD tutar.

### 8.3 Konuşma pratiği: aylık toplam (1k / 10k / 100k MAU)

**Kullanım varsayımları:**
- **Kotasız:** MAU'nun %40'ı konuşma pratiği kullanır ve ayda ortalama 12 oturum yapar. Bu, MAU başına **4,8 oturum/ay** eder.
- **Kotalı:** Günde 1 sesli oturum sınırı vardır. Ağır kullanıcılar kırpılır; ortalama MAU başına **3,2 oturum/ay**.

| Senaryo | MAU başı/ay | 1.000 MAU | 10.000 MAU | 100.000 MAU |
|---|---|---|---|---|
| A) Tasarruflu, kotasız | 0,13 USD | **130 USD** | **1.300 USD** | **13.000 USD** |
| B) Standart, kotasız | 0,39 USD | **390 USD** | **3.900 USD** | **39.000 USD** |
| C) Premium, kotasız | ~1,9 USD | **1.900 USD** | **19.000 USD** | **190.000 USD** |
| B) Standart, **kotalı** (önerilen başlangıç) | 0,26 USD | **260 USD** | **2.600 USD** | **26.000 USD** |
| A/B karışık, **kotalı + bütçe tavanı** | ≤ tavan | ≤ 300 USD | ≤ 1.500 USD | ≤ tavan (ör. 5.000 USD) |

**Kuyruk riski:** Kotasız bir ağır kullanıcı (günde 2 saat, standart konfigürasyon) **tek başına ayda ~58 USD** tutar. Kötüye kullanım ya da bot, ortalamaları anlamsız kılar. Bu yüzden **kullanıcı başı günlük kota şarttır**; en tasarruflu konfigürasyonda bile.

### 8.4 Kullanıcıya özel video: aylık toplam

Varsayım: Her MAU ayda 1 adet 30 saniyelik kişisel video alır. Ucuz model ~30 kredi, kaliteli model ~210 kredi. Kredi ~0,028–0,075 USD.

| Model | Video başı | 1.000 MAU | 10.000 MAU | 100.000 MAU |
|---|---|---|---|---|
| Ucuz (Seedance 2.0 Mini) | ~0,8–2,3 USD | 840–2.250 USD | 8.400–22.500 USD | **84.000–225.000 USD** |
| Kaliteli (Seedance 2.5 720p) | ~5,9–15,8 USD | 5.900–15.800 USD | 59.000–158.000 USD | 590.000+ USD |

Ayrıca:
- 1.000 MAU bile **ayda 30.000 kredi** ister; bu, üst planın ~10 katıdır.
- Abonelik planları bu ölçek için tasarlanmamıştır. API ve kurumsal fiyat **doğrulanmadı**.
- Her video dakikalar sürer ve otomatik moderasyon gerektirir.

**Sonuç:** Kullanıcıya özel video, ücretsiz modelle **sürdürülemez.** Şablon varyant yaklaşımı (§7) maliyeti kullanıcı sayısından bağımsız kılar.

### 8.5 Kısaca: "Ücretsiz + kullanıcı başı yapay zekâ" denklemi

```
Hazır içerik maliyeti   ≈ sabit                      → ücretsiz model ✅
Konuşma pratiği maliyeti ≈ MAU × oturum × birim fiyat → sınır veya finansman gerekir ⚠️
Kişisel video maliyeti   ≈ MAU × video × birim fiyat  → ücretsiz modelle ❌
```

Gelir sıfır olduğu için büyüme, maliyeti **doğrudan** artırır. Başarı ne kadar büyükse fatura o kadar büyük olur. Bu risk yönetilmeden konuşma pratiği "sınırsız ücretsiz" olarak duyurulmamalıdır.

### 8.6 Seçenekler

| Seçenek | Etkisi | Artısı | Eksisi |
|---|---|---|---|
| **1. Günlük ücretsiz kota** (1 sesli + 3 metin oturumu) | Kuyruk riskini keser, maliyeti ~%30 düşürür | Adil ve anlaşılır; Duolingo'nun "kalp" mantığına benzer | Ağır kullanıcı kısıtlanır |
| **2. Ucuz model ve cihazda işleme** (Haiku, cihazda STT ve TTS, metin modu) | Birim maliyet ~%60–70 düşer | Gizlilik de iyileşir | Ses kalitesi ve tanıma doğruluğu düşebilir |
| **3. Önbellek ve tekrar kullanım** (sistem talimatı önbelleği, sık TTS cümleleri, üretilen metinlerin anahtarla paylaşılması) | LLM ve TTS maliyeti düşer | Kullanıcı farkı hissetmez | Mühendislik emeği gerekir |
| **4. Velzon'un belirlediği aylık bütçe tavanı** (devre kesici) | Toplam fatura asla tavanı aşmaz | Kesin öngörülebilirlik | Tavan dolunca konuşma o ay için "yoğunluk" moduna geçer (kota küçülür ya da sadece metin modu kalır). Kullanıcıya açıkça söylenmeli. |
| **5. Sponsorluk / hibe** (TÜBİTAK, KOSGEB, belediye, üniversite, kurumsal sosyal sorumluluk; ör. "Bu ayın konuşma pratiği X'in katkısıyla") | Maliyetin bir kısmı karşılanır | Ücretsiz kalır | Belirsiz ve zaman alır; marka görünürlüğü politikası gerekir |
| **6. Sonradan isteğe bağlı premium / destekçi planı** (ör. ek konuşma kotası) | Ağır kullanıcı maliyetini kendisi karşılar | Ücretsiz çekirdek korunur | Kullanıcının "tamamen ücretsiz" kararıyla çelişir; **ancak kullanıcı onaylarsa** |
| 7. Reklam | Gelir getirir | — | Eğitim ve genç kitlede güven ve KVKK sorunu; Kids kategorisinde yasak. **Önerilmez.** |

### 8.7 Öneri (risk ve azaltma planı olarak)

"Tamamen ücretsiz" kararı **değiştirilmez.** Konuşma pratiği şu kurallarla açılır:

1. **Ücretsiz çekirdek sınırsızdır:** Hazır dersler, kısa video akışı, quizler, SRS ve metin tabanlı kişiselleştirme sınırsız ve ücretsizdir.
2. **Konuşma pratiği ücretsiz ama kotalıdır:**
   - günde 1 sesli (~5 dk) ve 3 metin oturumu;
   - seri ödülüyle haftada +2 oturum kazanılabilir.
3. **Konfigürasyon:** B (standart) başlar; pilot ölçümleri iyiyse A (tasarruflu) ağırlıklı karışıma geçilir.
4. **Aylık bütçe tavanı:**
   - başlangıçta **300 USD/ay** önerilir; Velzon kararıyla değişir;
   - %80'e gelince uyarı verilir;
   - %100'de yalnızca metin modu kalır;
   - tavan yönetim panelinden değiştirilebilir.
5. **Ölçüm:** Her oturumun gerçek maliyeti (token, dakika, karakter) sunucuda kaydedilir. Haftalık maliyet raporu çıkarılır (§12: MAU başı yapay zekâ maliyeti).
6. **Tetikleyici:** MAU başı yapay zekâ maliyeti 3 ay üst üste **0,30 USD**'yi aşarsa ya da bütçe tavanı 2 ay üst üste dolarsa, seçenek 5 veya 6 kullanıcıyla **yeniden konuşulur.**
7. **Kişisel video yalnızca şablon varyant** olarak yapılır; kullanıcıya özel üretim yoktur.

Bu kurallarla 10 bin MAU'da yapay zekâ maliyeti yaklaşık **1.500–2.600 USD/ay**, 1 bin MAU'da yaklaşık **150–300 USD/ay** düzeyinde kalır. Ya da daha düşük bir tavana sabitlenir.

---

## 9. KVKK, GDPR ve çocuk güvenliği

### 9.1 Ses verisi

- **Sınıflandırma:**
  - Ses kaydı kişisel veridir.
  - Kişiyi tanımak amacıyla işlenen ses (ses izi) **biyometrik veri**, yani özel nitelikli kişisel veri sayılır (KVKK m.6).
  - Telaffuz puanlaması tanıma amacı taşımaz. Ancak Kurul'un 2026/921 sayılı ilke kararı (RG 02.06.2026) "ses tınısı" gibi verileri de biyometrik kapsamda anıyor [21].
  - **İhtiyatlı yaklaşım:** Ses verisi özel nitelikli kabul edilir.
- **Gereken adımlar:**
  - Konuşma pratiği ilk açıldığında **ayrı bir açık rıza** alınır (ör. `VOICE_PROCESSING`). Rıza vermeyen kullanıcı **metin modunu** kullanır. Rıza Ayarlar'dan geri alınabilir.
  - **Varsayılan: ses saklanmaz.** Ses işlenir ve atılır. Sunucuya giden ses bellekte işlenir, diske yazılmaz.
  - Sağlayıcı sözleşmelerinde veri saklamama ve modeli eğitmeme seçenekleri açılır.
  - Konuşmanın **metin dökümü** kullanıcının geçmişinde 30 gün tutulur (öneri), sonra silinir.
  - Aydınlatma metni şunları açıkça yazar: hangi sağlayıcıya, hangi ülkeye, ne amaçla gönderildiği ve ne kadar saklandığı.
- **Yurt dışına aktarım (KVKK m.9):**
  - Anthropic, Deepgram ve Azure gibi sağlayıcılar yurt dışındadır.
  - 2024 değişikliğiyle standart sözleşme imzalanır ve imzadan sonra 5 iş günü içinde Kurum'a bildirilir. **[Hukukçu teyidi gerekli]**
  - Cihazda STT ve TTS kullanmak bu yükü azaltır.
- **VERBİS:** Velzon'un VERBİS kaydı varsa envantere hiVelzon işlemleri eklenir. **[Kontrol edilmeli]**

### 9.2 Çocuklar

| Konu | Öneri |
|---|---|
| 13 yaş altı | **MVP'de alınmaz.** Yaş beyanı ekranında 13 altı seçilirse kayıt tamamlanmaz; nazik bir mesaj gösterilir. Apple Kids ve Google Families kategorilerine girilmez. |
| 13–17 | Hazır içerik serbesttir. **Konuşma pratiği** için ya veli onayı akışı kurulur ya da 18+ sınırı konur (karar: H-002). Sohbetin sistem talimatı bu yaş grubunda daha sıkıdır; kişisel bilgi (adres, okul, telefon) istemez ve paylaşılırsa uyarır. |
| İçerik | Tüm hazır içerik 13+ uygun yazılır (§5.5). |
| Üçüncü taraf SDK | Reklam SDK'sı yoktur. Analitik, kendi sunucumuzda ve kimliksiz tutulur. Çökme raporlayıcı dikkatle seçilir. Apple, Kids kategorisinde cihaz kimliği gönderen SDK'ları da sorguluyor [22]. |
| Mağaza yaş derecesi | Yapay zekâ sohbeti nedeniyle derece 13+ ya da üstü olabilir. Apple'ın 2025'te değişen yaş derecesi sistemi (4+/9+/13+/16+/18+) **doğrulanmalı.** |
| Yapay zekâ içerik politikası | Google Play, yapay zekâ ile içerik üreten uygulamalardan zararlı içeriği önlemesini ve **uygulama içi bildirme** düğmesi sunmasını istiyor [13]. |

### 9.3 GDPR

- Hedef pazar Türkiye. Ancak AB'deki Türk kullanıcılar uygulamayı indirebilir. GDPR m.3/2 kapsamına girme ihtimali vardır.
- Yaş sınırı m.8'e göre ülkeden ülkeye 13–16 arasındadır.
- **Öneri:** Başlangıçta mağaza yayınını **Türkiye ile sınırla**. AB'ye açılmak ayrı bir karardır (§13).

### 9.4 Temel kalıplar (hiVelzon'un kendi tasarımı)

| Kalıp | hiVelzon'da kullanımı |
|---|---|
| `audit_log` (IP, port, User-Agent, UTC; sadece ekleme) | Her yazma işlemi + her yapay zekâ oturumunun başlangıç/bitiş ve maliyet kaydı |
| `user_consents` (politika sürümüyle) | KVKK aydınlatma, `VOICE_PROCESSING` açık rızası, veli onayı, bildirim izni |
| Hesap silme 30 gün bekleme (`PENDING_DELETION`, geri alma) | Aynen. Silmede ilerleme, deste ve konuşma dökümleri kalıcı silinir. |
| Hassas veri rızası yoksa `403 ...CONSENT_REQUIRED` | Ses rızası yoksa sesli uç noktalar `403 VOICE_CONSENT_REQUIRED` döner. |
| Gerçek sırlar ortam değişkeninde | Aynen (yapay zekâ ve Higgsfield anahtarları dahil) |
| Uygulama içi moderatör/yönetici paneli (rol bazlı) | İçerik yönetimi, bütçe tavanı ve bildirilen yapay zekâ yanıtlarının incelenmesi |
| Hukuki metinlerin `docs/`tan uygulamaya kopyalanması | Aynen (aydınlatma, gizlilik, kullanım koşulları, açık rıza metinleri) |

---

## 10. Teknik mimari (üst düzey)

```
┌──────────────── Flutter uygulaması (iOS + Android) ────────────────┐
│ Bugün · Akış (dikey video) · Dersler · Konuş · Profil              │
│ Video oynatıcı (HLS) · Quiz motoru · SRS (yerel önbellek)          │
│ Cihazda STT/TTS (izinli) · Mikrofon · Bildirimler                  │
└──────────────┬─────────────────────────────────┬───────────────────┘
               │ REST (JSON)                     │ WebSocket (ses akışı)
┌──────────────▼─────────────────────────────────▼───────────────────┐
│ Spring Boot 4 API (Java 17)                                        │
│ • Kimlik & hesap                 • Rıza & denetim kaydı            │
│ • İçerik kataloğu (ders, kısa video, quiz, altyazı)                │
│ • Öğrenme motoru (seviye testi, ilerleme, seri, SRS, günlük plan)  │
│ • Konuşma geçidi (STT→LLM→TTS orkestrasyonu, akış)                 │
│ • Kota & bütçe servisi (kullanıcı başı kota, aylık tavan, maliyet) │
│ • Yönetim (içerik yayınlama, bildirilenler, bütçe)                 │
└──────┬─────────────────────┬────────────────────┬──────────────────┘
       │                     │                    │
 PostgreSQL 16        Nesne depolama + CDN   Dış sağlayıcılar (ara katman arkasında)
 (kullanıcı, ilerleme, (video HLS, altyazı,   • LLM: Claude Haiku 4.5 / Sonnet 5.5
  içerik meta, audit,   küçük resimler)       • STT: Deepgram / Azure
  rıza, maliyet)                              • TTS: Azure / Deepgram
                                              • Telaffuz: Azure
                                              • Push: APNs / FCM

İçerik hattı (sunucu dışında, Velzon iç süreci):
Senaryo → Higgsfield CLI (Soul ID, video, ses) → kurgu → altyazı → QC → yükleme → katalogda "yayında"
```

**Baştan kurulacak temel parçalar:**
- Flutter proje yapısı;
- TR/EN yerelleştirme (ARB);
- kimlik doğrulama akışı;
- ayarlar, hesap silme ve rıza ekranları;
- Spring Boot katmanları ve hata modeli (ProblemDetail);
- `audit_log` ve `user_consents` şemaları ve migration'lar;
- Testcontainers ile test;
- yerelde docker-compose ile PostgreSQL.

**Bilinçli olarak yok:**
- web sitesi ve web uygulaması (`hi.velzon.tr` şimdilik yapılmayacak);
- kullanıcı içerik yüklemesi;
- yorumlar ve sosyal akış;
- reklam SDK'sı;
- üçüncü taraf analitik.

---

## 11. Yol haritası

> Efor tahminleri, Claude destekli tek geliştirici varsayımıyla kabadır. İçerik üretimi ayrı bir iş koludur ve **paralel** yürür.

| Faz | Kapsam | Kaba efor | Çıkış ölçütü |
|---|---|---|---|
| **Faz 0: Karar ve pilot** | Planın onayı (H-001). Açık kararlar (H-002…H-006). Marka ve öğretmen karakteri (Soul ID). **Pilot içerik:** 1 ders + 3 kısa video, gerçek kredi ve emek ölçümü. Cihazda STT ile Türk aksanı küçük testi (kodsuz, hazır demo uygulamalarla). | 1–2 hafta | Kullanıcı planı onayladı; pilot videolar beğenildi; birim maliyetler doğrulandı. |
| **Faz 1: MVP** | Proje iskeleti. Hesap, rıza, denetim kaydı, hesap silme. Seviye testi. Ders oynatıcı + quiz + altyazı. Kısa video akışı + mini quiz. İlerleme, seri, günlük hedef, SRS. İçerik yönetimi (uygulama içi yönetici rolü). CDN. Hukuki metinler. TR/EN. **İçerik:** A1–A2, 20 ders + 60 kısa video. | 8–10 hafta (kod) · içerik 3–4 ay (paralel, Faz 0'dan itibaren) | Kapalı beta (TestFlight / dahili test); 50–100 test kullanıcısı; çökme oranı < %1. |
| **Faz 2: v1** | **Yapay zekâ konuşma pratiği** (metin + ses, kotalı, bütçe tavanlı, maliyet ölçümü). Ses açık rızası. Telaffuz puanı ("Söyle" alıştırmaları). Push hatırlatmaları. Haftalık özet. Rozetler. B1–B2 içerik. İlgiye göre önbellekli metin üretimi. 13–17 politikası (H-002 kararına göre). | 6–8 hafta | Mağazada Türkiye yayını; MAU başı yapay zekâ maliyeti ölçülüyor ve tavan altında. |
| **Faz 3: v2** | Şablon varyant videolar. C1 içerik. İkinci öğretmen karakteri. Çevrimdışı indirme. İsteğe bağlı lig. Konuşma konfigürasyonunun optimizasyonu (cihazda işleme, gerçek zamanlı model değerlendirmesi). Sponsorluk / premium kararının yeniden değerlendirilmesi. Gerekirse çocuk modu ve `hi.velzon.tr`. | 8+ hafta | Tutma ve maliyet hedefleri (§12). |

**Neden bu sıra:**
- Çalıştırması en ucuz ayaklar önce gelir (hazır video, kısa akış, quiz). Bunlar kullanıcı sayısından bağımsız maliyetlidir ve "ücretsiz" sözünü risksiz tutar.
- Konuşma pratiği, ölçüm altyapısı ve kotalar hazır olduktan sonra açılır.
- İçerik üretimi en uzun süren iştir; **ilk gün başlamalıdır.**

---

## 12. Başarı metrikleri (KPI)

| Alan | Metrik | Hedef (yayından 6 ay sonra, öneri) |
|---|---|---|
| Büyüme | MAU · DAU · DAU/MAU | 10k MAU · DAU/MAU ≥ %20 |
| Tutma | 1. gün / 7. gün / 30. gün tutma | ≥ %40 / %20 / %12–15 |
| Alışkanlık | 7+ günlük seri sahibi kullanıcı oranı | ≥ %15 |
| Öğrenme | Ders tamamlama oranı · quiz doğruluğu · 4 haftada seviye testinde ilerleme | ≥ %60 · %65–80 · aktif kullanıcıların ≥ %30'u |
| Kısa akış | Ortalama izleme oranı · kaydetme oranı | ≥ %70 · ≥ %5 |
| Konuşma | Oturum tamamlama oranı · kota dolduran kullanıcı oranı | ≥ %70 · izlenir (çok yüksekse kota dar demektir) |
| **Maliyet** | **MAU başı yapay zekâ maliyeti · aylık toplam yapay zekâ maliyeti / tavan** | **≤ 0,30 USD · ≤ %100** |
| İçerik | Haftalık yayınlanan ders / kısa video · video başı kredi | 2 / 7 · ≤ §5.3 tahmini |
| Kalite | Mağaza puanı · çökmesiz oturum oranı · bildirilen yapay zekâ yanıtı oranı | ≥ 4,5 · ≥ %99,5 · < %0,5 |
| Güven | Ses rızası verme oranı · hesap silme talebi | İzlenir |

**Ölçüm ilkesi:**
- Analitik kendi sunucumuzda, olay bazlı tutulur.
- Kişiyle eşleştirme gerekmiyorsa toplu (aggregate) tutulur.
- Arama sorgusu ve ses kaydedilmez.

---

## 13. Riskler ve açık sorular

### 13.1 Riskler

| Risk | Olasılık | Etki | Azaltma |
|---|---|---|---|
| Yapay zekâ maliyetinin kontrolsüz büyümesi | Yüksek (başarı hâlinde) | Yüksek | Kota, bütçe tavanı, ucuz model, ölçüm, tetikleyici (§8.7) |
| İçerik üretiminin yavaş kalması (insan emeği) | Yüksek | Yüksek | Pilotla emek ölçümü, şablonlu senaryo, üretimi hemen başlatmak |
| Yapay zekâ videolarında kalite ve tutarlılık sorunu | Orta | Orta | Soul ID, QC listesi, slayt ağırlıklı ders yapısı |
| Yapay zekâ öğretmenin yanlış bilgi vermesi ya da uygunsuz yanıt | Orta | Yüksek | Rol kilitli sistem talimatı, yaş grubuna göre kural, bildir düğmesi, inceleme |
| KVKK ve ses verisi uyumsuzluğu | Orta | Yüksek | Ayrı açık rıza, ses saklamama, cihazda işleme, hukukçu incelemesi |
| Mağaza reddi (yaş derecesi, yapay zekâ politikası) | Orta | Orta | 13+, bildir düğmesi, açık yapay zekâ etiketleme |
| Higgsfield fiyat ya da koşul değişikliği | Orta | Orta | Prompt ve kaynak dosyalarını sakla, modelden bağımsız hat, alternatif araç listesi |
| Duolingo ve benzerlerinin konuşma özelliğini ücretsize çekmesi | Düşük–Orta | Orta | Türkçeye özel içerik ve öğretmen karakteriyle farklılaş |
| Tek kişilik ekip ve diğer Velzon işleriyle kaynak çakışması | Yüksek | Orta | Net faz sırası, küçük ve doğrulanabilir işler |

### 13.2 Kullanıcıya açık sorular (karar bekleyenler)

1. **Yaş politikası (H-002):** MVP 13+ mı? 13–17 yaş için konuşma pratiğinde veli onayı mı, yoksa 18+ sınırı mı? 13 yaş altı (çocuk modu) ileride hedef mi?
2. **Yapay zekâ bütçesi ve kota (H-003):** Velzon ayda en fazla ne harcamaya hazır (öneri 300 USD ile başlamak)? Tavan dolunca ne olsun (sadece metin modu mu, kapanma mı)? İleride isteğe bağlı premium veya sponsorluk konuşulabilir mi, yoksa kesinlikle hayır mı?
3. **Higgsfield planı ve içerik bütçesi (H-004):** Plan yükseltilecek mi (üst plan ~3.000 kredi/ay)? Aylık içerik bütçesi ne? Senaryo, kurgu, altyazı ve QC emeğini kim verecek (haftada ~13–17 saat)?
4. **Öğretmen karakteri (H-005):** Tamamen kurgusal yapay zekâ karakteri mi? Adı, cinsiyeti, aksanı (Amerikan / İngiliz) ne olacak? Kaç karakter?
5. **Sağlayıcılar ve yurt dışı aktarım (H-006):** LLM için Claude (Haiku 4.5 / Sonnet 5.5) uygun mu? STT, TTS ve telaffuz için Azure / Deepgram uygun mu? Yurt dışına aktarım için hukukçu desteği var mı?
6. **Yayın bölgesi:** Sadece Türkiye mi (öneri), yoksa AB'deki Türkler de mi?
8. **Marka:** "hiVelzon" adı ve logosu Higgsfield brandkit ile mi üretilecek? Mağaza adı "hiVelzon: İngilizce Öğren" gibi mi olacak?
9. **Reklam yok kararı:** Onaylanıyor mu (öneri: hiç reklam yok)?

---

## Kaynaklar

1. Duolingo Q2 2026 sonuçları (DAU 58,7 milyon, 12,7 milyon ücretli abone, gelir 298,5 milyon USD): https://www.globenewswire.com/fr/news-release/2026/08/05/3339653/0/en/duolingo-reports-second-quarter-2026-results.html · SEC 8-K: https://www.sec.gov/Archives/edgar/data/0001562088/000162828026053299/q2fy26duolingo6-30x26share.htm
2. Duolingo Max fiyatı (ikincil kaynak): https://dev.to/incubadora_6c1fc80706dda7/duolingo-max-gpt-4-worth-paying-for-in-2026-2o71 · https://frontdeskreview.com/software/language-learning/duolingo/
3. Babbel (abonelik sayısı, Babbel Speak): https://en.wikipedia.org/wiki/Babbel · https://skillademia.com/statistics/babbel-statistics/
4. Cambly kullanıcı sayısı (ikincil kaynak): https://www.teknoblog.com/online-ingilizce-konusma-pratigi-icin-en-iyi-platformlar-2026/
5. Cambly ve Cambly Kids fiyatları (ikincil kaynak, doğrulanmadı): https://subger.com/en/service/cambly-kids
6. Praktika Seri A ve kullanıcı sayısı (2024): https://techcrunch.com/2024/05/22/praktika-raises-35-5m-to-use-ai-avatars-to-make-learning-languages-feel-more-natural · https://tech.eu/2024/05/22/language-app-pratika-raises-a-355m-series-a-round/
7. Speak Seri C (2024): https://techcrunch.com/2024/12/10/openai-backed-speak-raises-78m-at-1b-valuation-to-help-users-learn-languages-by-talking-out-loud
8. ELSA Speak fiyatı (ikincil kaynak): https://softwarefinder.com/lms/elsa-speak/pricing · https://www.getapp.com/all-software/a/elsa-speak/
9. Konuşarak Öğren: https://apps.apple.com/app/id1099431274 · https://www.teknoblog.com/online-ingilizce-konusma-pratigi-icin-en-iyi-platformlar-2026/
10. Learnai: https://apps.apple.com/us/app/-/id6749094916
11. Talkinn: https://apps.apple.com/cl/app/edutalkinn/id6466325020 · SmartTalk: https://apps.apple.com/mx/app/smarttalk/id6749509466
12. MEB çoklu yabancı dil modeli (haber): https://www.hurriyet.com.tr/haberleri/yabanci-dil-egitimi
13. Google Play yapay zekâ içerik politikası: https://support.google.com/googleplay/android-developer/answer/14094294 · Families politikası: https://support.google.com/googleplay/android-developer/answer/9893335
14. Higgsfield içerik sahipliği ve ticari kullanım: https://higgsfield.ai/creator-hub/help-center/account-and-privacy/who-owns-my-generations-and-can-i-use-them-commercially
15. Higgsfield fiyatları (2026, üçüncü taraf): https://creatify.ai/blog/higgsfield-pricing-(2026)-plans-and-what-you-ll-actually-pay
16. Higgsfield fiyatları (alternatif kaynak): https://www.hooked.so/compare/higgsfield-pricing · Resmi sayfa (içerik alınamadı): https://higgsfield.ai/pricing
17. Deepgram fiyatları (Nova-3, Aura): https://diyai.io/ai-tools/speech-to-text/deepgram-pricing-2026/ · https://www.happyrobot.ai/hub/deepgram-pricing
18. Azure AI Speech fiyatları (telaffuz, nöral TTS): https://acom-sandbox.azure.net/en-us/pricing/details/cognitive-services/speech-services/ · https://learn.microsoft.com/en-us/answers/questions/5608069/pricing-and-usage-of-pronunciation-assessment-feat
19. Claude API fiyatları: https://platform.claude.com/docs/en/about-claude/pricing (Haiku 4.5: 1 / 5 USD; Sonnet 5.5: 2 / 10 USD per milyon token; 2026-09-25 önbellek tablosu)
20. OpenAI Realtime fiyatları (ikincil kaynak): https://aireiter.com/blog/openai-realtime-api-pricing · https://openai.com/api/pricing/
21. KVKK 2026/921 sayılı ilke kararı (biyometrik veri): https://www.alomaliye.com/2026/06/02/mesai-takibinde-biyometrik-veri-islenmesine-yeni-ilke-karari-kvkk/ · https://cottgroup.com/tr/mevzuat/item/mesai-takibi-biyometrik-veri-islenmesine-iliskin-kvkk-duyurusu-ilke-karari-kapsami-uygulama-sinirlari
22. Apple Kids kategorisi kuralları (ikincil kaynak): https://conductatlas.com/platform/apple/apple-app-store-review-guidelines/kids-category-third-party-data-and-advertising-restrictions/ · https://appsops.store/news/apple-kids-category-guidelines-update-ios26-age-verification
