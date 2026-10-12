# Hi: her yerde yanında olan asistan ve öğrenme koçu (tasarım taslağı)

**Sürüm:** 0.2 · **Tarih:** 2026-10-11 · **Durum:** Kararlar verildi (H-047, kullanıcı onayı) · **Ek (2026-10-12):** Hi'nin konu tanıtımı H-048'e taşındı (H-050)
**Kaynak:** Kullanıcı önerisi (2026-10-11):
- Hi uygulamanın her yerinde, sağ altta bir balon olarak görünür; basınca yapay zekâ sohbeti açılır.
- Kullanıcının gelişimini sürekli takip eden bir ajan olur.
- Dış AI servislerine bağlı olmayan, kendi sunucumuzda RAG kullanan bir yapı kurulur.
- Bunlar fazlara bölünür.
- Türkiye'deki "hep aynı" İngilizce uygulamalarından farklı olunur ve kullanıcı yönlendirilir.

---

## 1. Fikir tek cümlede

Hi, Alex'in telefonundaki asistandır (K-23). Hikâyeden çıkınca **kullanıcının telefonunda da** yaşar: aynı karakter, aynı ses ve aynı hafızayla. Kullanıcı hikâyede Alex'in yol arkadaşıdır, hikâye dışında da Hi'nin öğrencisidir. Bu süreklilik, sıradan bir "sohbet botu" sekmesinin veremeyeceği bir bağ kurar.

## 2. Türkiye için farklılık: "hep aynı uygulama" sorunu

Türkiye'deki tipik öğrencinin durumu:
- Okulda yıllarca dilbilgisi görmüş.
- "Anlıyorum ama konuşamıyorum" diyor.
- Hata yapmaktan utanıyor.
- Uygulamaları birkaç hafta sonra bırakıyor.

Popüler uygulamalar her dilden öğrenciye aynı akışı sunuyor. hiVelzon'un farkı şu beş ilkeden gelir:

| # | İlke | Somut karşılığı |
|---|---|---|
| F1 | **Türkçeye göre koçluk** | Hi hatayı Türkçenin yapısıyla açıklar. Örnekler: "Türkçede 'olmak' çoğu zaman düşer (*Ben öğrenciyim*). İngilizcede düşmez: *I **am** a student*." *I am agree*, *-s* takısı, *the*, *in/on/at*, söz dizimi (*Where station?*). Hata kataloğu hikâyelere zaten bilerek yerleştiriliyor (CLAUDE.md); Hi bunu kişiye göre izler. |
| F2 | **Utanmadan prova** | Konuşma önce yalnızca Hi'ye yapılır: puan yok, kimse görmez. "Maya'ya söylemeden önce bana bir dene." Hikâyedeki konuşma sahnesi ancak bundan sonra gelir. |
| F3 | **Her gün tek adım, gerekçesiyle** | Kullanıcı ne yapacağını düşünmez. Hi her gün **bir** öneri verir ve nedenini gösterir: "Dün *at/on*'da iki kez takıldın; B4'teki saat sahnesi 4 dk." (Ürün ilkesi: tek öğrenme eylemi, görünür gerekçe.) |
| F4 | **Hikâye ve gerçek hayat köprüsü** | Hikâyede öğrenilen ifade hafta içinde küçük bir gerçek hayat görevine dönüşür: "Bu hafta bir kafede menüdeki İngilizce kelimeleri oku, bana üçünü söyle." Zorunlu değildir, yan görevdir (K-31). |
| F5 | **Yönlendirme, baskı değil** | Seri ve bildirim kuralları geçerli (K-16, H-013, K-32). Hi suçlamaz, geri sayım yapmaz. Kullanıcı kaybolduğunda geri getiren şey merak ve tek küçük adımdır. |

## 3. Hi'nin üç rolü (tek yüz, üç iş)

1. **Asistan (balon):** Sağ altta, menünün üstünde durur. Oynatıcıda, görevde ve onboarding'de görünmez. Basınca Hi paneli açılır:
   - bugünkü öneri;
   - hızlı eylemler;
   - soru sorma.
2. **Koç (ajan):** Arka planda öğrenme olaylarını (`learning_events`: bakılan kelime, yanlış seçim, ipucu kullanımı, FSRS cevapları) okur ve bir öğrenci modeli tutar. Bu modeli kullanarak:
   - günlük öneriyi,
   - haftalık özeti ("Bu hafta 23 ifade topladın; en çok *in/on/at*'ta zorlandın"),
   - yan görevleri

   seçer.
3. **Sohbet ortağı (AI):** Serbest metin, sonra sesli konuşma. Hikâye bağlamını ve kullanıcının seviyesini bilir. İpucunu kademeli verir: önce basit İngilizce, sonra Türkçe. Gizemi Alex'in yerine çözmez (K-23).

**Kritik ayrım:** Rol 1 ve 2'nin büyük kısmı **yapay zekâ olmadan, kurallarla** yapılabilir. Ürün ilkesi de "ilk sürümde öneriler kural tabanlı ve gerekçeli" der. Böylece:
- MVP'de maliyet, yaş ve KVKK riski olmadan "yönlendiren Hi" verilebilir;
- dil modeli sonradan eklenir.

## 4. Mimari

```
Flutter (Hi balonu, panel, sohbet)
   │  (asla doğrudan modele gitmez)
   ▼
Spring Boot 4: hi modülü
   ├─ CoachService: öğrenci modeli + kurallar → öneri ve gerekçe   (Faz A, AI yok)
   ├─ AiTutorPort ──► OllamaAdapter (geliştirme, yerel)            (Faz B)
   │                └► üretim adaptörü (değerlendirmeyle seçilir)
   ├─ RetrievalService → PostgreSQL + pgvector
   │     (onaylı içerik: bölümler, çeviriler, sözlük, dilbilgisi notları, hata kataloğu)
   ├─ EmbeddingPort (yerel embedding modeli)
   ├─ SafetyFilter (girdi/çıktı denetimi, yaş kuralları) + QuotaGuard (H-003)
   └─ learning_events → LearnerModel (FSRS + beceri kanıtı + hata örüntüleri)
```

- Sağlayıcı anahtarı ve model mobilde olmaz (mühendislik ilkesi).
- Geliştirmede her şey yerelde çalışır (kullanıcı kararı): Ollama + yerel embedding + pgvector, aynı Docker PostgreSQL'de.
- Port/adaptör sayesinde üretimde yerel model mi, Türkiye'de bir GPU sunucusu mu, harici API mi kullanılacağı **en son**, ölçüme göre seçilir (H-044 ile birlikte).

### 4.1 "Kendi kendine öğrenen model" ne demek, ne demek değil

| Mekanizma | Ne yapar | hiVelzon'da |
|---|---|---|
| **RAG** | Cevap vermeden önce onaylı içerikten ilgili parçayı bulur | Faz B. Yalnızca editörün onayladığı içerik indekslenir (K-05). |
| **Öğrenci hafızası** | Kişinin hatalarını, bildiklerini ve ilerlemesini tutar | Faz A'da kurallarla başlar. "Kendini geliştirme" hissinin asıl kaynağı budur. |
| **İnce ayar (fine-tuning)** | Modelin ağırlıklarını değiştirir | En sonda. Yalnızca onaylı ve anonimleştirilmiş örneklerle yapılır. **Kullanıcı (özellikle 13–17) konuşmaları otomatik olarak eğitime girmez.** |

RAG modeli "eğitmez". Sistemi her gün daha iyi yapan, öğrenci hafızası ve onaylı içeriğin büyümesidir.

### 4.2 Kendi sunucumuzda model: artıları ve gerçekçi riskler

**Artılar:**
- **KVKK:** Veri yurt dışına aktarılmaz. Türkiye'deki sunucuda çalışınca yurt dışı aktarım sorunu büyük ölçüde ortadan kalkar. Bu, çocuk kullanıcı ihtimali olan bir uygulama için güçlü bir avantajdır.
- Dış servise bağımlılık ve fiyat değişimi riski yoktur.

**Riskler:**
- **Kalite:** Küçük modellerin (3B sınıfı) Türkçe açıklaması ve dilbilgisi düzeltmesi zayıf olabilir. Yanlış düzeltme, öğrenciye yanlış öğretmek demektir.
- **Güvenlik:** 13+ kitle için içerik denetimi de yerel çalışmalıdır.
- **Maliyet:** Üretimde GPU sunucusu sabit maliyettir. Az kullanıcıyla API'den pahalı olabilir.

**Çözüm: değerlendirme seti.** Model seçimi tahminle yapılmaz. Örnek değerlendirme seti:
- 100 Türk öğrenci hatası;
- 50 "bu ne demek" sorusu;
- 30 güvenlik denemesi.

Her aday model bu setle puanlanır: doğruluk, Türkçe açıklama kalitesi, gecikme, bellek, maliyet.

### 4.3 MacBook M1 Pro 16 GB'ta yerel geliştirme

- **Model sınıfı:** 3–4B sınıfı, 4-bit modeller rahat çalışır (~2–3 GB). 7–8B sınıfı (~5–6 GB) simülatör, Spring, PostgreSQL ve IDE ile birlikte sıkışık olur; yalnızca değerlendirme sırasında açılır.
- **Embedding:** Küçük, çok dilli bir embedding modeli kullanılır.
- **Tek model:** Aynı anda tek model yüklü tutulur. Ollama boşta kalınca modeli bellekten atar.
- **Bağlantı:** Uygulama Ollama'ya doğrudan bağlanmaz; her istek Spring üzerinden geçer.

## 5. Güvenlik, yaş ve gizlilik (bağlayıcı kurallarla çakışmalar)

- **H-002: AI sohbeti yalnızca 18+.** Kullanıcının "balona basınca AI sohbet" fikri 13–17 yaş için bu kararla çakışır. Önerilen çözüm:
  - 13–17 yaş için Hi paneli **rehberli mod** olur: öneri, hızlı eylemler ve **onaylı içerikten** cevaplanan "bu ne demek / bu neden böyle" soruları (RAG + sabit şablonlar). Serbest sohbet yoktur.
  - 18+ için serbest sohbet açılır.
  - Gençlere serbest sohbet ancak hukuk teyidinden sonra açılabilir (hukukçu sorusu olarak eklenecek).
- **Saklama:** Ham ses saklanmaz. Sohbet metninin saklama süresi ve erişimi sınırlıdır. Loglara transkript yazılmaz (mühendislik ilkeleri, H-008).
- **Profil çıkarma:** Öğrenci modeli bir profil çıkarmadır. Aydınlatma metninde açıkça yazılır ve kullanıcı Profil'de "Hi benim hakkımda ne biliyor?" ekranından görüp silebilir.
- **Persona:** Hi romantik, manipülatif ya da bağımlılık yaratan bir dil kullanmaz; yapay zekâ olduğunu söyler (ürün ilkeleri).

## 6. Fazlar

| Faz | Ne gelir | AI / maliyet | Ne zaman |
|---|---|---|---|
| **Hi-A: Yönlendiren Hi** | Balon (sağ alt, menünün üstü; hikâye ve görevde gizli); Hi paneli: bugünkü tek öneri + gerekçe, hızlı eylemler, "bu ne demek?" (çeviri ve sözlük verisinden, deterministik); haftalık özet; Türkçeye göre hata ipuçları (hata kataloğu); **konu tanıtımı** (yeni dilbilgisi konusu sahnede ilk geçtiğinde kısa, atlanabilir Hi kartı; H-050'den taşındı) | **Yok**, kural tabanlı; bütün yaşlar | F1 (MVP); H-036'dan (defter/FSRS) sonra |
| **Hi-B: Metin sohbeti** | `AiTutorPort` + Ollama (yerel), RAG (pgvector), güvenlik filtresi, kota; 18+ serbest sohbet, 13–17 rehberli mod; değerlendirme seti ve model karşılaştırması | Yerelde 0; üretim kararı ölçümle | F2 (v1) başı (H-007 ile uyumlu) |
| **Hi-C: Sesli Hi ve prova** | Yerel STT/TTS adayları, "önce Hi'ye fısılda" provası, sonra karakter sahnesi; telaffuz yalnızca güvenilirse (H-015) | Değerlendirmeyle | F2 (v1) |
| **Hi-D: Koç ajanı** | Haftalık plan, gerçek hayat köprü görevleri, kişiye göre yan görevler, karakterlerle senaryolu konuşma | — | F3 (v2) |
| **Hi-E: Model geliştirme** | Onaylı ve anonim örneklerle ince ayar, model sürümleme ve geri alma | GPU sunucusu | Yeterli veri olunca |

## 7. Kararlar (H-047, 2026-10-11, soru-cevap)

- **Fazlar:** Hi-A MVP'de (kural tabanlı, AI yok, bütün yaşlar; uygulama işi H-048). AI sohbeti v1'de (Hi-B).
- **AI altyapısı:** Yerelde başlanır (port/adaptör + Ollama + yerel embedding + pgvector). Üretimde kendi sunucu mu, API mi kullanılacağı değerlendirme seti ve maliyet ölçümüyle H-044'te seçilir.
- **13–17 yaş:** Rehberli Hi. Serbest sohbet yalnızca 18+ (H-002 korunur). Gençlere serbest sohbet ancak hukuk teyidinden sonra.
- **Farklılık önceliği:** F1 Türkçeye göre koçluk, F2 utanmadan prova, F3 her gün tek adım + gerekçe, F4 gerçek hayat köprü görevleri. Dördü de seçildi; F5 zaten bağlayıcı kurallardan gelir.

## 8. İlk açık sorular (kapandı)

1. Faz yapısı: Hi-A MVP'ye girsin mi?
2. AI altyapı yönü: port arkasında yerel Ollama ile başlayıp üretim kararını ölçüme mi bırakalım, yoksa "kesinlikle kendi sunucumuz" kararını şimdiden mi verelim?
3. 13–17 yaş: rehberli mod mu?
4. Farklılık ilkelerinden (F1–F5) hangileri önceliklidir?

## 9. Sonradan eklenen (2026-10-12)

- **Hi'nin konu tanıtımı H-048'e (Hi-A) taşındı.** H-050 kararıyla bölümler doğrudan başlıkla açılır; Hi'nin konu tanıtımı başlıktan önce değil, yeni bir dilbilgisi konusu (ör. saatler, fiyatlar) sahnede ilk geçtiği anda kısa ve atlanabilir bir kart olarak gösterilir. `content.json`'daki dilbilgisi hedefinden beslenir, konu başına bir kez gösterilir, defterden yeniden açılabilir. AI kullanmaz.
- "Bu ne demek?" için veri hazır: H-046'nın onaylı `ceviri.tr.json` dosyaları (B1–B4) ve anlam paneli bileşeni (`mobile/lib/shared/meaning/`).

## 10. Dış referans: EnglishPractice (2026-10-12)
Yerel Ollama + Whisper + Kokoro ile çalışan, Türk öğrenciye yönelik açık kaynak bir uygulama. Hata sınıflandırması (Hi-A), LLM düzeltme + deterministik denetim (Hi-B) ve yerel ses (Hi-C) için MIT kod desen olarak uyarlanır; içerik yalnızca referanstır. Bkz. `docs/ENGLISHPRACTICE-INCELEME.md`.
