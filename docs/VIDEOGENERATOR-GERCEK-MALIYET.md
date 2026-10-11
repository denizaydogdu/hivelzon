# videoGenerator: Gerçek Maliyet ve Süre Dökümü

> Kaynak: `/Users/felece/Dev/videoGenerator` içindeki gerçek çıktı kayıtları. Repo yalnızca okundu.
> İncelenenler: `output/jobs/*/job.json`, `output/costs/*.json`, `logs/*.log`, dosya zaman damgaları,
> `TODO.md`, `thoughts/` ve fiyat sabitlerini görmek için kaynak kod.
> Hazırlanma tarihi: 2026-10-11. Hangi AI servislerinin kullanıldığı ayrı dokümanda anlatılıyor:
> `VIDEOGENERATOR-AI-SERVISLERI.md`. Burada o konu tekrar edilmedi.

## 0. En önemli uyarı: buradaki "maliyet" fatura değil, tahmin

- `job.json` içindeki `cost` alanı ve `output/costs/2026-08.json` dosyası gerçek fatura tutarı **değil**.
  Bu değerler, kodun `util/Constants.java` içindeki **sabit birim fiyatlarla** hesapladığı tahminler:
  - Görsel: **$0.08 / adet** (`COST_IMAGE_MEDIUM`; gpt-image-2, `medium` kalite, 1024x1536)
  - TTS: **$0.10 / 1.000 karakter** (`COST_TTS_PER_1K_CHARS`)
  - LLM: **$0.01 / çağrı**, sabit (`COST_LLM_CALL`; token sayılmıyor)
  - Müzik: **$0.50 / parça** (`COST_MUSIC_TRACK`; hiç kullanılmadı)
- Gerçekte nakit çıkan kalemler muhtemelen yalnızca **OpenAI görsel ve LLM** çağrıları.
  **ElevenLabs ücretsiz planda** kullanıldı (10.000 kredi/ay). TODO.md'ye göre 2026-08-02'de
  "Starter yerine yeni ücretsiz hesap açıldı". Yani TTS'nin fiili nakit maliyeti **$0**,
  ama kredi kotası gerçek bir darboğaz (bkz. §4).
- Kayıt dışı kalan maliyetler:
  - Fikir üretme (IdeaGenerator) LLM çağrısı hiç sayılmıyor.
  - Başarısız denemelerdeki LLM ve TTS harcaması sayılmıyor. Maliyet aylık dosyaya yalnızca iş
    **başarıyla** bitince ekleniyor.
- Gerçek OpenAI faturası repoda yok. Gerçek tutar için OpenAI kullanım panelinin Ağustos 2026 dökümüne bakılmalı.

## 1. Video başına maliyet: gerçek işler

Repoda **5 benzersiz üretim işi** var. Hepsi `truecrime-en` kanalında üretildi ve her iş
**3 dil** çıkarıyor (en, es, tr). Altıncı klasör (`2026-08-03-191500-d3m0test`), Zodiac işinin
TikTok testi için yapılmış birebir kopyası. Maliyeti aynı ve aylık toplama eklenmemiş, bu yüzden tabloya alınmadı.

| İş (tarih) | Format | Sahne / görsel | Süre en / es / tr (sn) | Görsel | TTS (tahmin) | LLM | Müzik | **Toplam (3 dil)** | **Dil başı** |
|---|---|---|---|---|---|---|---|---|---|
| 08-01 16:42, kurgu soğuk vaka | v1 | 6 / 6 | 93.1 / 116.0 / 94.3 | $0.48 | $0.391 | $0.05 | $0 | **$0.92** | $0.31 |
| 08-01 22:39, D.B. Cooper | v1 | 6 / 6 | 99.9 / 114.6 / 92.3 | $0.48 | $0.383 | $0.04 | $0 | **$0.90** | $0.30 |
| 08-02 09:13, Zodiac | 2.0 | 6 / 12 | 55.6 / 62.9 / 57.5 | $0.96 | $0.284 | $0.05 | $0 (yerel) | **$1.29** | $0.43 |
| 08-02 10:34, İstanbul 2000 vakası | 2.0 | 6 / 12 | 55.4 / 52.1 / 49.9 | $0.96 | $0.200 | $0.04 | $0 (yerel) | **$1.20** | $0.40 |
| 08-02 11:43, Los Galindos | 2.0 | 6 / 12 | 48.2 / 58.0 / 51.1 | $0.96 | $0.202 | $0.06 | $0 (yerel) | **$1.22** | $0.41 |
| **Toplam** | | | | **$3.84** | **$1.46** | **$0.24** | $0 | **$5.54** | |

Gözlemler:

- Toplam, `output/costs/2026-08.json` dosyasındaki `{"spent": 5.5397}` değeriyle kuruşu kuruşuna aynı.
  Bu, kayıtların kendi içinde tutarlı olduğunu gösteriyor.
- **Maliyetin %69'u görsel.** Format 2.0'da sahne başına 2 görsele geçildi (01a/01b, "görsel tempo").
  Bu değişiklik görsel maliyetini ikiye katladı, video süresi ise 95 sn'den 55 sn'ye indi.
- TTS karakter hacmi:
  - İngilizce anlatım 740–1.376 karakter.
  - Konuşma hızı yaklaşık **13–15 karakter/sn** (ör. 841 karakter → 55.6 sn).
  - İspanyolca metin, İngilizceye göre %10–20 daha uzun süre üretiyor.
- Müzik API hiç kullanılmadı. ElevenLabs Music ücretli plan istiyor. Onun yerine `assets/music/`
  içindeki 2 telifsiz parça (yerel kütüphane, $0) kullanıldı.
- LLM payı küçük: 1 hikâye + her dil için 1 çeviri/metadata çağrısı. 0.05–0.06'lık değerler
  yeniden denemelerde fazladan yapılan çeviri çağrılarını gösteriyor.

## 2. Adım süreleri (log ve dosya zaman damgalarından)

En temiz koşu `2026-08-02-103411` (12 görsel, 3 dil, topic hint ile):

| Adım | Ölçülen süre | Not |
|---|---|---|
| Fikir üretimi (LLM, 5 fikir) | 6–9 sn | topic hint verilirse atlanıyor |
| Hikâye (StoryWriter, LLM) | **10–22 sn** | 6 sahne + hookText |
| Görseller (gpt-image-2, sıralı) | **~40–50 sn / görsel** → 6 görsel ≈ 4–5 dk, 12 görsel ≈ 8–9 dk | **toplam sürenin ~%65'i**; paralel değil |
| Çeviri + metadata (dil başı, LLM) | 5–8 sn | |
| TTS (ElevenLabs eleven_v3, zaman damgalı) | **~20 sn / dil** | hizalama JSON'u aynı çağrıda geliyor |
| Altyazı (.ass karaoke) | <1 sn | TTS hizalamasından üretiliyor, ayrı STT yok |
| Ses miksi (ses + müzik, ducking) | 1–2 sn | FFmpeg |
| Kurgu (Ken Burns + xfade, 1080x1920) | **~40–50 sn / dil** | 6 ya da 12 görselde benzer |
| İnceleme (insan onayı, backoffice) | değişken | iş `PENDING_REVIEW` durumunda bekliyor |
| Yayın (YouTube upload) | **~10–14 sn / video** (16–17 MB) | 3 dil 37 sn |

- **Uçtan uca, insan onayı hariç:** 12 görselli ve 3 dilli bir iş **~12–13 dk**
  (10:34:11 → 10:46:59). 6 görselli v1 işler ~8–16 dk.
- Dil başına ek süre: çeviri + TTS + miks + render ≈ **75–80 sn**.

## 3. Aylık harcama özeti

- Yalnızca **Ağustos 2026** kaydı var: `2026-08.json` → **$5.54** (tahmini, 5 iş, 15 video).
- Yükleme sayaçları:
  - `uploads-2026-08-02.json` → 6 yükleme
  - `uploads-2026-08-03.json` → 3 yükleme
- Eylül ve Ekim için maliyet dosyası yok. 3 Ağustos'tan sonra true-crime üretimi durmuş görünüyor.
  Sonraki loglar Velzon işleri; bunlar ya AI görsel kullanmıyor ya da AI görseli sonradan kaldırıldı.
- Velzon tarafı:
  - `output/velzon-ai-briefing/` içinde tek bir `image.png` var, maliyet kaydı yok.
  - TODO.md'ye göre (2026-08-24) Velzon brifinglerinde gpt-image-2 **tamamen kaldırıldı**.
    Yerine Django'nun ücretsiz `og-image.png` terminal kartı kullanılıyor, yani görsel maliyeti $0.
  - Velzon YouTube videolarının ElevenLabs TTS kullanımı CostTracker'a yazılmıyor.

## 4. Üretimde yaşanan kalite ve hata sorunları

Not: Error loglarındaki ~285 "Job failed" kaydının **büyük çoğunluğu birim testlerinden** geliyor.
Bunlar sahte hatalar ("boom", "LLM down", "render crash", junit geçici yolları). Aşağıda yalnızca
**gerçek üretim** hataları listelendi.

| Tarih | Adım | Hata | Etkisi |
|---|---|---|---|
| 08-01 16:12 ve 16:40 | Fikir | IdeaGenerator boş döndü → `idea is null` NPE | iş başlamadan öldü |
| 08-01 16:47 | Müzik | ElevenLabs **Music API ücretli plan istiyor** (402), 3 deneme | müzik kapatıldı (`music.enabled=false`), sonra yerel kütüphaneye geçildi |
| 08-01 16:50 | TTS | **Kütüphane sesi ücretsiz planda API'den kullanılamıyor** (402), 3 deneme | ses ID'si hesaba eklenmiş bir sesle değiştirildi. Aynı hata 08-13'te Velzon YouTube'da **tekrar yaşandı**: varsayılan ses yine kütüphane sesiydi |
| 08-02 09:13 | Hikâye | LLM yanıtı `max_tokens`ta **kesildi** | iş öldü; `llm.max.tokens` artırıldı |
| 08-02 09:24 | Miks | FFmpeg exit 234 (ses miksi) | İngilizce TTS üretilmişti ama iş öldü; 15 dk sonra resume'da **İngilizce TTS ve çeviri yeniden yapıldı** (kredi israfı) |
| 08-02 11:41 | Hikâye | "LLM returned 1 scenes, expected 6" | iş öldü, yeni iş açıldı (LLM çağrısı boşa gitti) |
| 08-02 11:55 ve 12:16 | TTS | **ElevenLabs kotası bitti**: "quota of 10000, 9 credits remaining" (her biri 3 deneme) | Türkçe varyant 22 dk bekledi; yeni ücretsiz hesapla resume edildi |
| 08-02 20:15 | Kurgu | es/tr render'ları 10 saat sonra **yeniden üretildi** | yeniden render (lokal, API maliyeti yok) |

Öne çıkan desenler:

1. **TTS kotası en sert darboğaz.**
   - Ücretsiz plan 10.000 kredi/ay ve eleven_v3 karakter başına yaklaşık 1 kredi harcıyor.
   - 3 dilli bir iş 2.000–3.900 karakter tutuyor, yani ayda **ancak 3–4 iş** üretilebiliyor.
     Kota 2. günün 5. işinde bitti.
2. **Resume mantığı görselleri koruyor ama TTS'i korumayabiliyor.**
   - Mevcut görseller atlanıyor ("Skip existing scene image").
   - Varyant, render bitmeden kaydedilmiyor. Render veya miks adımında çökme olursa TTS ve çeviri
     yeniden yapılıyor ve kredi ikinci kez yanıyor.
3. **LLM yapısal çıktı hataları:** kesik yanıt, eksik sahne, eksik `hookText`.
   Bunlar doğrulama ile yakalanıyor ve iş fail-fast ile duruyor. Maliyeti düşük ama işi baştan başlatmayı gerektiriyor.
4. **RetryPolicy 402/401 hatalarını da 3 kez deniyor.** Kota ve plan hatalarında tekrar denemenin
   anlamı yok, sadece süre kaybı.
5. **Görsel tutarlılığı:**
   - true-crime'da bilinçli olarak sorun edilmedi: stil öneki "documentary photography, **no human faces**".
   - TODO.md'deki "Emily tarzı sabit karakter" fikri **yüksek riskli** olarak işaretlendi.
     Gerekçe: gpt-image-2 ile LoRA ya da referans kilitleme yok, çok karakterli tutarlılık güçlü
     video modellerinde bile çözülmüş değil. Fizibilite testi önerildi ama **hiç yapılmadı**.

## 5. hiVelzon için çıkarım (kaba tahmin)

### Varsayımlar

- Tek dil, 45–90 sn'lik **A1 seviyesinde** hikâye. A1 için daha yavaş anlatım varsayıldı:
  ~11–13 karakter/sn → **500–1.150 karakter** TTS.
- Bölüm başına **6 görsel**: gpt-image-2, `medium`, 1024x1536, videoGenerator'daki $0.08/adet tahmini.
  OpenAI'ın güncel fiyatı ayrıca doğrulanmalı.
- LLM: 1 hikâye çağrısı + 1 metadata/sözlük çağrısı. Token bazlı hesap yok; videoGenerator'ın
  çağrı başı $0.01'lik sabiti kullanıldı.
- TTS: ElevenLabs eleven_v3, videoGenerator'ın $0.10/1k karakter tahmini.
  Ücretsiz planda nakit maliyet $0, ama kota sınırlı.
- Müzik: yerel telifsiz kütüphane ($0).
- Yeniden deneme payı +%25. videoGenerator'da 5 işin en az 3'ünde bir adım tekrarlandı.

### Bölüm başı maliyet (tek dil)

| Kalem | 45 sn | 90 sn |
|---|---|---|
| 6 görsel | $0.48 | $0.48 |
| TTS (500 / 1.150 karakter) | $0.05 | $0.12 |
| LLM (2 çağrı) | $0.02 | $0.02 |
| Müzik | $0 | $0 |
| Ara toplam | $0.55 | $0.62 |
| **Yeniden deneme payıyla** | **~$0.70** | **~$0.80** |

- Görsel payı ~%80. Maliyeti düşürecek tek etkili kaldıraç görsel sayısı ve kalitesi:
  - `low` kalite kullanmak,
  - görselleri bölümler arasında tekrar kullanmak,
  - Velzon'daki gibi programatik kart üretmek.
- Ücretsiz ElevenLabs ile ayda yaklaşık **8–20 bölüm** (10.000 / 500–1.150 karakter), retry israfı hariç.
  Düzenli üretim için ücretli plan gerekir.
- Hedeflenen 30 bölüm/ay için ≈ **$21–24/ay** görsel+LLM+TTS tahmini. Buna ElevenLabs aboneliği ayrıca eklenir.

### Bölüm başı süre (tek dil, insan onayı hariç)

| Adım | Süre |
|---|---|
| Hikâye (LLM) | 10–25 sn |
| 6 görsel (sıralı) | **4–5 dk** (paralel üretilirse ≈ 1 dk) |
| TTS + hizalama | ~20–30 sn |
| Altyazı + miks | ~2 sn |
| Render (1080x1920, Ken Burns) | ~40–60 sn |
| Yayın (upload) | ~10–15 sn |
| **Toplam** | **~6–7 dk** (paralel görselle **~3 dk**) |

### hiVelzon'a taşınacak dersler

1. **Görselleri paralel üret.** Sürenin üçte ikisi sıralı görsel üretiminden geliyor.
2. **TTS çıktısını ayrı bir tamamlanma işareti olarak kalıcılaştır.** Render çökünce ses yeniden
   üretilmesin. videoGenerator'da varyant işareti render'dan sonra konduğu için kredi iki kez yandı.
3. **402/401 hatalarında retry yapma.** Kota bitmesini erken ve açık bir şekilde bildir.
4. **Ses ID'sini hesaba eklenmiş bir sesle sabitle.** Kütüphane sesi ücretsiz planda API'den çalışmıyor;
   bu hata iki kez yaşandı.
5. **Maliyeti gerçek kullanımdan hesapla.** Token ve karakter sayısını yanıttan alıp kaydet. Başarısız
   denemeleri de kaydet. videoGenerator'daki sabit tahmin ve "yalnızca başarıda kaydet" modeli harcamayı
   olduğundan düşük gösteriyor.
6. Karakter tutarlılığı gerekiyorsa (tekrarlayan A1 karakterleri), pipeline kurmadan önce
   **4–5 sahnelik bir fizibilite testi** yap. videoGenerator'da bu risk tespit edildi ama test hiç yapılmadı.
