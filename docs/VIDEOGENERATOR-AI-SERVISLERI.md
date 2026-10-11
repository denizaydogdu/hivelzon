# videoGenerator: Yapay Zekâ ve Medya Servisleri İncelemesi

- **Tarih:** 2026-10-11
- **İncelenen repo:** `~/Dev/videoGenerator`, `main`, HEAD `98902a8` (98 commit, `origin/main` ile eşit). Repo **yalnızca okundu**.
  - Build, test, script ya da API çağrısı yapılmadı.
  - Sır değerleri okunmadı ve bu belgeye yazılmadı. Yalnızca anahtar adları, dosya yolları ve commit kimlikleri var.
- **Önceki rapor:** `docs/VIDEOGENERATOR-RAPORU.md` (H-022). Bu belge onu tekrar etmez; AI ve medya servislerini derinleştirir.
- **Kısaltma:** `vg:` = `~/Dev/videoGenerator/src/main/java/com/videogenerator/`. Satır numaraları HEAD `98902a8`'e göredir.
- **Etiket:** **[doğrulanmadı]** = kodda ya da repo belgelerinde kanıtı yok; dış kaynakla (güncel fiyat, lisans ya da API belgesi) teyit edilmeli.

---

## 1. Özet (10 madde)

1. **Kullanılan AI sağlayıcıları yalnızca iki tane: OpenAI ve ElevenLabs.**
   - OpenAI: metin için `gpt-5.6-luna` (Chat Completions), görsel için `gpt-image-2`.
   - ElevenLabs: TTS için `eleven_v3` (zaman damgalı) ve `eleven_multilingual_v2`; müzik için `music_v2`.
   - Kodda Higgsfield, Anthropic, Whisper, Gemini ya da OpenRouter **yok**.
   - Eski Sora ve Suno istemcileri Ağustos 2026'da silindi. Bugün yalnızca `ApiProvider` enum'u, `Constants` ve README/QUICKSTART'ta artık olarak duruyorlar.
2. **Model adları koda varsayılan olarak gömülü** (`vg:config/Configuration.java:142-146`). `config/application.properties` dosyası bunları ezmiyor.
   - Üretimde kullanılan değerler: `gpt-5.6-luna`, `gpt-image-2` (`medium`, `1024x1536`).
   - TTS ve müzik modeli ise config'ten geliyor: `tts.model=eleven_v3`, `music.enabled=false`.
3. **Yapılandırılmış çıktı (JSON Schema / `response_format`) kullanılmıyor.**
   - Bütün LLM çağrıları "Respond with ONLY valid JSON" talimatı, prompt içinde örnek bir JSON şekli ve `LlmJson.strip` ile markdown çitlerinin temizlenmesi yöntemiyle çalışıyor.
   - Doğrulama elle yapılıyor: sahne sayısı ve zorunlu alanlar kontrol ediliyor.
   - Yeniden deneme yalnızca `StoryWriter`'da var: 3 deneme, her denemede hata mesajı prompt'a geri besleniyor.
4. **LLM çağrılarında HTTP düzeyinde yeniden deneme yok.**
   - `OpenAiGptClient.chatCompletion` `RetryPolicy` kullanmıyor.
   - `temperature` gönderilmiyor; koddaki nota göre GPT-5.x yalnızca varsayılan değeri kabul ediyor.
   - `max_completion_tokens` 6000 (config). Yanıt `finish_reason=length` ile kesilirse hata fırlatılıyor.
5. **Maliyet birimleri koda gömülü sabitler** (`vg:util/Constants.java:74-77`): görsel 0,08 USD, TTS 1.000 karakter başına 0,10 USD, müzik 0,50 USD, LLM çağrısı 0,01 USD.
   - Gerçek token ya da karakter sayımı yapılmıyor.
   - `ElevenLabsClient.estimateCost` ise 1.000 karakter için 0,30 USD varsayıyor. İki tahmin birbiriyle tutarsız.
6. **Gerçek harcama defteri çok küçük ve eksik.**
   - `output/costs/2026-08.json` → **5,54 USD**. Ağustos dışında hiçbir ay için dosya yok.
   - 6 hikâye işinin `job.json` toplamı **6,83 USD**: görsel 4,80, TTS 1,74, LLM 0,29, müzik 0.
   - Velzon (X, Instagram, Facebook, YouTube, AI Brifing) ve Pinterest üreteçlerinin OpenAI ve ElevenLabs çağrıları **hiç sayılmıyor** ve `BudgetGuard`'dan geçmiyor. Bu yüzden gerçek OpenAI faturası defterden yüksek olmalı **[doğrulanmadı: OpenAI kullanım panelinden bakılmalı]**.
7. **Hesap ve plan durumu:**
   - ElevenLabs hesabı **ücretsiz plan**. 2026-08-02'de "Starter yerine yeni ücretsiz hesap açıldı" kararı var (TODO.md:346-350).
   - Ücretsiz planda kütüphane sesleri API'den kullanılamıyor: 402 hatası alındı (TODO.md:148-163). Music API'ye de erişim yok (`vg:job/JobPipeline.java:101-102`).
   - OpenAI'nin plan ya da tier bilgisi repoda yok.
8. **Anahtarlar kanal başına değil, global.**
   - OpenAI anahtarı `OPENAI_API_KEY` ortam değişkeninden geliyor. Config'teki değer yer tutucu; değişken kullanıcının kabuk profilinde global olarak export ediliyor.
   - ElevenLabs anahtarı `config/application.properties` içindeki `tts.api.key` alanında **açık metin** duruyor. Dosya gitignore'da, ama izinleri 644.
9. **Git'te AI anahtarı sızıntısı bulunmadı.**
   - `TODO.md:277`'deki parça bir AI servisine değil, **Velzon piyasa verisi API'sine** ait (`velzon.market.api.key`, `gate.velzon.tr`, `X-API-KEY` başlığı).
   - Parça commit `30a051a` (2026-08-12) ile girdi ve `origin/main`'e push edildi.
   - Tüm geçmişte (98 commit) OpenAI, ElevenLabs, Google, Meta, AWS ya da özel anahtar kalıbı bulunmadı.
10. **hiVelzon için öneri:**
    - ElevenLabs zaman damgalı TTS **deseni aynen** alınsın, ama **ayrı ticari hesapla** (H-006) ve `speed` ile `language_code` eklenerek.
    - `gpt-image-2` **kullanılmasın**; görseller Higgsfield ile üretilir.
    - OpenAI metin modeli doğrudan taşınmasın. İçerik üretimi zaten oturum içinde Claude ile ve insan onaylı yapılıyor (H-028). Programatik bir LLM gerekirse `LlmPort` arkasında, **şemalı yapılandırılmış çıktıyla** kullanılsın.
    - Bütçe sabitleri ve global anahtar düzeni **kopyalanmasın**.

---

## 2. Servis tablosu

| # | Servis | Model / uç nokta | Görev | Sınıf / dosya:satır | Parametreler | Maliyet birimi (kodda) |
|---|---|---|---|---|---|---|
| 1 | OpenAI Chat Completions | `POST https://api.openai.com/v1/chat/completions`. Model: `llm.model`, varsayılan `gpt-5.6-luna` | Hikâye ve sahne prompt'u, çeviri ve metadata, fikir üretimi, Velzon ve Pinterest metinleri | `vg:api/OpenAiGptClient.java:324-386`; uç nokta `vg:util/Constants.java:13-14`; model `vg:config/Configuration.java:142` | `max_completion_tokens` = `llm.max.tokens` (config'te 6000, kod varsayılanı 2000). `temperature`, `top_p`, `response_format` ve `seed` gönderilmiyor (`:319-323`). Mesajlar: tek system + tek user | Çağrı başına sabit **0,01 USD** (`Constants.java:77`). Spec'teki fiyat: 1M token için 0,20 / 1,20 USD (girdi/çıktı) **[doğrulanmadı]** |
| 2 | OpenAI Images | `POST /v1/images/generations`. Model: `image.model`, varsayılan `gpt-image-2` | Sahne görselleri; Velzon Instagram, Facebook ve YouTube görselleri; Pinterest pinleri | `vg:api/ImageApiClient.java:41-99`; model `Configuration.java:143-145` | `size=1024x1536`, `quality=medium`, `n=1`. Yanıt `b64_json` olarak PNG'ye yazılıyor. `RetryPolicy`: 3 deneme, 429 ve 5xx'te | Görsel başına sabit **0,08 USD** (`Constants.java:74`). Spec'e göre gerçek fiyat ~0,05–0,08 USD **[doğrulanmadı]** |
| 3 | ElevenLabs TTS (zaman damgalı) | `POST https://api.elevenlabs.io/v1/text-to-speech/{voiceId}/with-timestamps`. Model: `tts.model=eleven_v3` | Hikâye anlatımı (en/es/tr) + karakter düzeyinde hizalama → sahne kesimi ve karaoke altyazı | `vg:api/ElevenLabsClient.java:115-175`; bağlantı `vg:main/Main.java:1119-1125`; model `Configuration.java:302-304` | `voice_settings`: `stability=0.5`, `similarity_boost=0.75`. `style`, `speed`, `language_code`, `seed`, `output_format`, `previous_text`/`next_text` **gönderilmiyor**. Ses kimliği kanal profilinden geliyor | 1.000 karakter başına **0,10 USD** (`Constants.java:75`); `estimateCost` ise 0,30 diyor (`ElevenLabsClient.java:358-362`) |
| 4 | ElevenLabs TTS (düz) | `POST /v1/text-to-speech/{voiceId}`. Model: `VoiceConfig` varsayılanı `eleven_multilingual_v2` | Velzon YouTube Shorts anlatımı (Türkçe) | `ElevenLabsClient.java:180-235`; çağrı `vg:velzon/VelzonYoutubeVideoBuilder.java:81`; ses `Main.java:966-967` (`VOICE_GEORGE`) | `stability`, `similarity_boost`, `style=0`, `use_speaker_boost=true` (`vg:model/VoiceConfig.java:26-32`) | **Sayılmıyor** |
| 5 | ElevenLabs Music | `POST https://api.elevenlabs.io/v1/music`. Model: `music.model`, varsayılan `music_v2` | Hikâye başına arka plan müziği | `vg:api/MusicApiClient.java:26-91`; prompt `vg:job/JobPipeline.java:194-198` | `prompt`, `music_length_ms` = hedef süre × 1000, `model_id`. Prompt sabit: "tense ambient background, instrumental, cinematic, for: <başlık>" | Parça başına **0,50 USD** (`Constants.java:76`). **Kapalı:** `music.enabled=false`; yerel telifsiz klasöre düşüyor |
| 6 | ElevenLabs hesap uçları | `GET /v1/voices`, `GET /v1/user/subscription` | Ses listesi, kalan karakter ve anahtar doğrulama | `ElevenLabsClient.java:256-321`, `342-350` | — | — |
| 7 | Velzon AI Brifing (dış sistem) | velzon-django `velzon.briefing.base.url` | Velzon'un **kendi** AI hisse analizini alıp sosyal gönderiye uyarlar. Metni üreten model bu repoda değil | `vg:velzon/VelzonBriefingClient.java`; uyarlama `VelzonAiBriefingPostGenerator.java:31-96, 185` | — | — |
| — | (AI değil) Google Trends, YouTube Data, Meta Graph, TikTok, X, Pinterest | — | Trend ve yayın | `KeywordApiClient`, `publish/*`, `velzon/*` | — | YouTube günlük 6 yükleme sınırı (`Constants.java:47`) |

**Ses kimlikleri** (kimlikler sır değildir, ama burada yalnızca adlarıyla geçiyor):
- `truecrime-en` ve örnek profil: ElevenLabs hazır sesi **George**. Commit `79255b4`: "library voices blocked on free API".
- `forensic-lab-en`: başka bir hazır ses kimliği. Adı **[doğrulanmadı]**.
- Varsayılan `VOICE_RACHEL` bir kütüphane sesi; ücretsiz planda API'den 402 hatası verdi (TODO.md:148-163).
- Bütün kanallar `en`, `es` ve `tr` dillerini tek sesle üretiyor; `language_code` gönderilmiyor.

**Kim neyi çağırıyor** (LLM çağrı noktaları):
- `service/StoryWriter.java:119`
- `service/TranslationService.java:79`
- `service/IdeaGenerator.java:44`: `generateViralIdeas` üzerinden.
- `velzon/VelzonTweetGenerator.java:101`
- `velzon/VelzonInstagramPostGenerator.java:113`
- `velzon/VelzonFacebookPostGenerator.java:112`
- `velzon/VelzonYoutubeScriptGenerator.java:120`
- `velzon/VelzonAiBriefingPostGenerator.java:185`
- `pinterest/PinterestBatchGenerator.java:65`

**Görsel çağrı noktaları:**
- `service/SceneImageService.java:48`
- `VelzonInstagramPostGenerator.java:141`
- `VelzonFacebookPostGenerator.java:140`
- `VelzonYoutubeVideoBuilder.java:77`
- `PinterestBatchGenerator.java:95`
- AI Brifing gönderilerinde AI görseli **kaldırıldı**; yerine Velzon'un ücretsiz OG kartı kullanılıyor (TODO.md:695-708).

---

## 3. Prompt mimarisi

### 3.1 Ortak desen
- Arayüz tek metot: `LlmClient.complete(system, user)` (`vg:api/LlmClient.java:9-11`). Sağlayıcı değişse bile çağıran kod değişmez, testte sahte istemci kullanılır. **Bu desen hiVelzon'a iyi taşınır.**
- System prompt kısa bir rol tanımıdır ve her zaman "Respond with ONLY valid JSON, no markdown fences" ile biter.
- User prompt şu parçalardan oluşur: girdi, kurallar, sert limitler ve **örnek JSON şekli**. Şekil metin olarak verilir; şema olarak verilmez.
- Ayrıştırma: `LlmJson.strip` (`vg:api/LlmJson.java:13-19`) çitleri temizler, sonra Gson ile model sınıfına çevrilir. Bilinmeyen alanlar sessizce yok sayılır, eksik alanlar `null` olur.
- Eski `OpenAiGptClient` metotları (`generateMetadata`, `generateViralIdeas`; `:45-296`) aynı işi kendi çit temizleme koduyla yapıyor. Bu kod tekrarıdır.

### 3.2 `StoryWriter` (`vg:service/StoryWriter.java`)
- **Tek çağrıda hikâye ve görsel prompt üretilir.** Her sahne 1–2 cümlelik `narration` ve **iki** `imagePrompts` içerir: aynı anın iki farklı açısı. Böylece görsel her zaman anlatımla eşleşir.
- Kural blokları (`:49-86`):
  - **FACTUAL RULES:** yalnızca gerçek vakalar kullanılır; "alleged" dili zorunludur; birincil kaynaktan en az bir ayrıntı verilir.
  - **HOOK RULES:** sonuç ilk cümlede söylenir; tarihle açılış yasaktır. Ayrıca 4–7 kelimelik bir `hookText` üretilir.
  - **LOOP RULE:** son cümle videonun başına bağlanır.
  - **Tempo:** 5 tempo varyantından biri rastgele seçilir (`:32-38`, `:47-48`). Amaç YouTube'un "inauthentic content" kümelemesinden kaçmaktır.
  - **Kelime bütçesi:** hedef süre × 2,2 kelime/sn (`:45`). Bu oran, çevirinin yaklaşık %15 uzamasına pay bırakır.
  - Görselde tanınabilir insan yüzü ve gerçek kişi benzerliği yasaktır.
- **Doğrulama** (`:126-140`): sahne sayısı tam tutmalı, `hookText` boş olmamalı, her sahnede en az bir görsel prompt bulunmalı.
- **Yeniden deneme** (`:94-114`):
  - En fazla 3 deneme yapılır.
  - 2. denemeden itibaren prompt'a "STRICT FORMAT REMINDER (a previous attempt was rejected: <hata>)" eklenir.
  - Gerekçe kod yorumunda yazıyor: GPT ara sıra sahne dizisini tek bir nesneye birleştiriyor.
  - Bu, "doğrulayıcının hata mesajını modele geri besleme" desenidir. **hiVelzon'daki `content-lint` için faydalı bir desen.**
- **Stil kilidi:** `stylePrefix` kanal profilinden gelir ve görsel prompt'unun başına eklenir (`SceneImageService.java:48`).

### 3.3 `TranslationService` (`vg:service/TranslationService.java`)
- Her hedef dil için bir çağrı yapılır; İngilizce de dahil, onun için yalnızca metadata üretilir. Numaralı anlatım satırları gönderilir.
- Kurallar:
  - Satır sayısı ve sırası korunur.
  - **Her satır aynı uzunlukta ya da daha kısa olur.** Gerekçe ses bütçesi.
  - `hookText` çevrilir.
  - Dil başına başlık kalıbı uygulanır (`:29-41`).
- Doğrulama: anlatım sayısı sahne sayısına eşit olmalı ve metadata geçerli olmalı. **Yeniden deneme yok**; hata `IllegalStateException` olarak işi düşürür.
- Kod ayrıca açıklamanın sonuna sabit bir yasal dipnot ekler (`:44-47`, `:101-103`). Bu bir **deterministik son işlem** örneğidir.

### 3.4 Velzon ve Pinterest üreteçleri
- Uzun system prompt'lar kullanılıyor; en uzunu `VelzonAiBriefingPostGenerator.java:31-96`, ~65 satır. İçerikleri:
  - alana özgü yasaklar: "AL/SAT" yazılmaz, sayı uydurulmaz, eksik veri duyurulmaz;
  - karakter sınırları: X için 280, Instagram için 2.200;
  - zorunlu sembol ve CTA.
- Sınırlar ayrıca kodla da uygulanıyor (`:228-250`: Instagram açıklaması 2.200 karakterde güvenli biçimde kesiliyor). **Ders: modele verilen sınır her zaman kodla da zorlanmalı.** hiVelzon'da CEFR kelime ve cümle sınırları için de aynısı geçerli.
- Parti üretimde ucuz adımlar (metin) önce yapılır; pahalı adımlar (görsel, TTS, render) yalnızca insan "Yayınla" dediğinde yapılır (`VelzonYoutubeScriptGenerator.java:30-40`). **hiVelzon için iyi bir desen:** metin onayından önce Higgsfield ya da TTS kredisi harcanmaz.

### 3.5 Görsel ve müzik prompt'ları
- Görsel: `stylePrefix + ", " + sahne prompt'u`. Negatif prompt, seed ya da referans görsel yok. Karakter tutarlılığı için hiçbir mekanizma yok; TODO.md:10-29 bunu "yüksek risk" diye not ediyor.
- Müzik: tek bir sabit şablon (`JobPipeline.java:195-196`).

---

## 4. Maliyet ve bütçe

### 4.1 Birim fiyatlar: nereden geliyor?

| Kalem | Değer | Kaynak | Config ile değişir mi? |
|---|---|---|---|
| Görsel (medium) | 0,08 USD/adet | `Constants.COST_IMAGE_MEDIUM` (`:74`) | Hayır, kodda sabit |
| TTS | 0,10 USD / 1.000 karakter | `Constants.COST_TTS_PER_1K_CHARS` (`:75`) | Hayır |
| Müzik | 0,50 USD/parça | `Constants.COST_MUSIC_TRACK` (`:76`) | Hayır |
| LLM | 0,01 USD/çağrı | `Constants.COST_LLM_CALL` (`:77`) | Hayır |
| TTS (ikinci tahmin) | 0,30 USD / 1.000 karakter | `ElevenLabsClient.estimateCost` (`:358-362`) | Hayır. Kullanılmıyor ama çelişiyor |
| Aylık tavan | `budget.monthly.usd`, yoksa **100 USD** | `Configuration.java:147` | Evet. Config'te **tanımlı değil**, yani 100 USD geçerli |

### 4.2 Nasıl uygulanıyor?
- **İş başında tek bir tahmin yapılır** (`JobPipeline.java:150-154`): sahne sayısı × görsel + dil sayısı × 0,10 + müzik + (1 + dil sayısı) × LLM.
  - Sahne başına **iki** görsel üretildiği halde tahmin bir görsel sayıyor. Yani tahmin, görsel maliyetini yarı yarıya düşük gösteriyor.
  - TTS tahmini, gerçek metin uzunluğundan bağımsız olarak dil başına 1.000 karakter varsayıyor.
- **Gerçekleşen maliyet** adım adım `job.cost`'a yazılıyor (`:179`, `:187`, `:198`, `:229`, `:238-239`). Aylık deftere ise yalnızca iş başarıyla bitince bir kez ekleniyor (`:289-292`, `costRecorded` bayrağıyla idempotent).
- `CostTracker`, `FileLock` ve atomik yeniden adlandırma ile yazıyor. Bozuk dosyada "fail closed" davranıyor (`vg:job/CostTracker.java:35-72`). **Bu kısım iyi; taşınabilir.**
- **Kapsam dışında kalanlar:**
  - `IdeaGenerator`'ın LLM çağrısı (`JobPipeline.java:171-173`) maliyete eklenmiyor.
  - `velzon/*` ve `pinterest/*` içindeki hiçbir çağrı `CostTracker` ya da `BudgetGuard` kullanmıyor (`grep` ile doğrulandı).

### 4.3 Gerçek harcama (yerel dosyalardan; kişisel veri ya da sır yok)

| Kaynak | Değer |
|---|---|
| `output/costs/2026-08.json` | **5,54 USD** (Ağustos 2026). Başka ay dosyası yok. |
| 6 iş (`output/jobs/*/job.json`, 2026-08-01…03, `truecrime-en`, her biri 3 dil) | Görsel 4,80 + TTS 1,744 + LLM 0,29 + müzik 0 = **6,83 USD** |
| Fark | ~1,29 USD. Bu, `2026-08-03-191500-d3m0test` işinin toplamına eşit. Büyük olasılıkla deftere yazılmayan bir test işi **[doğrulanmadı]** |
| İş başına ortalama | ~1,14 USD, 3 dil için. Spec hedefi 0,32–0,53 USD idi. Aradaki fark büyük ölçüde sahne başına 2 görselden geliyor (12 × 0,08 = 0,96 USD) |
| Sayılmayan harcama | Velzon AI Brifing (BIST günlerinde günde 5 tur LLM), Velzon X/IG/FB/YouTube metinleri, Velzon YouTube TTS ve görselleri, Pinterest görselleri (`output/pinterest` altında 12 PNG). Tutarı bilinmiyor **[doğrulanmadı]** |

**Çıkarım:** Ses ve görsel maliyetinin baskın kalemi görsellerdir: hikâye işlerinde maliyetin %70'i. hiVelzon'da görseller Higgsfield kredisiyle ödeneceği için bu kalem USD defterine değil, **kredi defterine** yazılmalı.

---

## 5. Hesap, plan ve anahtar yönetimi (yalnızca adlar)

### 5.1 Anahtarların yüklenmesi
- `Configuration.get(key)` (`vg:config/Configuration.java:56-66`) önce ortam değişkenine bakar: anahtar adındaki `.` yerine `_` konur ve büyük harfe çevrilir. Bulamazsa `config/application.properties` dosyasına, sonra classpath'teki `application.properties` dosyasına bakar.

| Servis | Config anahtarı | Ortam değişkeni | Fiilen nereden geliyor |
|---|---|---|---|
| OpenAI (LLM + görsel) | `openai.api.key` | `OPENAI_API_KEY` | Config'te yer tutucu (`YOUR_…`). Classpath dosyasında `${OPENAI_API_KEY}`. Değişken kullanıcının kabuk profilinde global export ediliyor. Yani **aynı OpenAI anahtarını o makinedeki her süreç miras alıyor.** |
| ElevenLabs (TTS + müzik) | `tts.api.key` | `TTS_API_KEY`; property yoksa `ELEVENLABS_API_KEY` (`:294-296`) | `config/application.properties` içinde **açık metin** (değer okunmadı; yalnızca dolu olduğu görüldü). Dosya gitignore'da, hiç commit edilmemiş, izinleri `-rw-r--r--` |
| Velzon piyasa verisi | `velzon.market.api.key` | `VELZON_MARKET_API_KEY` | config (AI değil) |
| Velzon brifing | `velzon.briefing.api.key` | — | config (AI değil) |
| Yayın platformları | `meta.*`, `tiktok.*`, `pinterest.*`, `velzon.x.*`, `velzon.ig.*`, `velzon.fb.*`, `velzon.tiktok.*`, `youtube.client.*` | — | config. OAuth token'ları `config/tokens/` altında (izin 600) |

- **Kanal başına ayrı AI anahtarı yok.** Kanal profili (`channels/*.json`) yalnızca şunları taşıyor: `voiceId`, `stylePrefix`, `languages`, `platforms`, `targetDurationSeconds`, `sceneCount`, `youtubeTokenFile`, `meta`, `publishLang`. Yalnızca yayın token'ları kanal ya da marka başına ayrı.
- `.env` dosyası yok. `docker-compose.yml` `OPENAI_API_KEY`'i ortamdan geçiriyor.

### 5.2 Plan, tier ve limit notları
- **ElevenLabs:**
  - Ücretsiz plan kullanılıyor (TODO.md:346-350, karar tarihi 2026-08-02). Kullanıcı riskleri kabul etmiş; konu "gelir öncesi tekrar gündeme getirilmeyecek" diye not edilmiş.
  - Kütüphane sesleri API'den kullanılamıyor (402 `payment_required`). Yalnızca hesaba eklenmiş hazır sesler (George) çalışıyor.
  - Music API ücretsiz planda kapalı (`JobPipeline.java:101-102`; config'te `music.enabled=false`).
- **OpenAI:**
  - Repoda plan, tier ya da kota notu yok.
  - Config'te `api.openai.rpm.limit=60` (`Constants.java:48`) tanımlı ama kodda bu limiti uygulayan bir yer bulunmadı.
  - Spec'e göre Sora API 24 Eylül 2026'da kapanıyor; bu yüzden Sora kaldırıldı (`docs/superpowers/specs/2026-08-01-shorts-fabrikasi-design.md:28`).
- **YouTube:** Kanal başına günde 6 yükleme sınırı (`api.youtube.daily.limit`).

---

## 6. Güvenlik bulguları (değerler yazılmadan)

| # | Bulgu | Yer | Servis | Önem |
|---|---|---|---|---|
| G-1 | Git'e işlenmiş anahtar parçası (önek ve tire ile kısaltılmış bir **prod** anahtarı) | `TODO.md:277`; commit `30a051a` (2026-08-12); `origin/main`'e push edilmiş | **Velzon piyasa verisi API'si** (`gate.velzon.tr`, `X-API-KEY`, `velzon.market.api.key`). AI servisi **değil**. Metne göre anahtar velzon-django belgelerinde zaten "rotate edilmeli" diye işaretli ve kullanıcı onayıyla kullanılıyor | Orta. Tam değer değil, ama önek sızıyor. GitHub reposunun herkese açık olup olmadığı **[doğrulanmadı]**. Öneri: anahtar döndürülsün, satır temizlensin (videoGenerator sahibinin işi) |
| G-2 | Tüm git geçmişinde OpenAI (`sk-`, `sk-proj-`), ElevenLabs (`sk_`), Google (`AIza`, `GOCSPX-`, `ya29.`), Meta (`EAA`, `IGAA`), AWS (`AKIA`) ve özel anahtar kalıpları tarandı. **Eşleşme yok.** | `git log --all -p` (98 commit) | — | Bilgi |
| G-3 | `config/`, `channels/*.json` ve `config/tokens/` hiç commit edilmemiş. Yalnızca `channels/example-truecrime-en.json.example` commit edilmiş ve sır içermiyor | `git log --all -- config/ channels/` | — | Bilgi |
| G-4 | ElevenLabs anahtarı config dosyasında açık metin; dosya herkes tarafından okunabilir (644). `config/google_credentials.json` da 644 | `config/application.properties:51`, `config/google_credentials.json` | ElevenLabs, Google OAuth | Düşük–orta (tek kullanıcılı makine) |
| G-5 | OpenAI anahtarı global ortam değişkeninde. hiVelzon araçları aynı kabuktan çalışırsa **aynı anahtarı ve faturayı** sessizce kullanır | kabuk profili (`OPENAI_API_KEY`) | OpenAI | Orta (fatura ve kota karışıklığı) |
| G-6 | `logs/` ve `output/` altında anahtar kalıbı bulunmadı. Ancak `OpenAiGptClient` istek gövdesini DEBUG düzeyinde loglar (`:354`), hata yanıt gövdelerini ERROR düzeyinde loglar. `ImageApiClient` her prompt'u INFO düzeyinde loglar (`:53`) | `vg:api/*` | — | Düşük. hiVelzon'da loga prompt yazılmamalı (CLAUDE.md mühendislik ilkeleri) |

**Önceki rapora düzeltme:** `VIDEOGENERATOR-RAPORU.md` §6.2/7'de "ElevenLabsClient 4xx yanıtlarını da yeniden deniyor" deniyordu. HEAD'de `RetryPolicy.shouldRetry` neden zincirini izliyor (`vg:util/RetryPolicy.java:72-89`) ve `ApiException.isRetryable` yalnızca 429, 500, 503 ve 504 için `true` dönüyor (`vg:util/ApiException.java:39-41`). Yani **4xx yanıtlar tekrar denenmiyor**. `Accept: audio/mpeg` başlığının JSON uç noktasıyla tutarsızlığı ise doğru (`ElevenLabsClient.java:334`).

---

## 7. hiVelzon önerileri

hiVelzon bağlamı:
- içerik offline üretilir ve insan onaylıdır (H-028, K-05);
- CEFR seviye denetimi deterministiktir (`content-lint`);
- TTS ElevenLabs'in ayrı ticari hesabıyla yapılır (H-006);
- görseller Higgsfield ile üretilir;
- AI sohbet v1'de gelir ve 18+ içindir (H-002, H-007);
- aylık tavan 300 USD'dir (H-003).

| Servis (videoGenerator) | Öneri | Gerekçe ve yapılacaklar |
|---|---|---|
| **ElevenLabs TTS `with-timestamps`** | **Aynen kullan (desen)**, ayrı hesapla | Karakter hizalaması → `SceneTimer` → altyazı ve WebVTT zinciri altyazı kaymasını önlüyor ve ek ASR maliyeti yok. Eklenecekler: CEFR hızı için `voice_settings.speed` (A1 ~100–110 kelime/dk); `language_code="en"`; tekrar üretilebilirlik için `seed`; açık `output_format`; uzun bölüm parçalı üretilecekse `previous_text`/`next_text`. `eleven_v3`'ün `speed` ve `seed` desteği **[doğrulanmadı]**. Desteklemiyorsa A1–A2 için `eleven_multilingual_v2` ya da daha yeni bir model denensin. Gerçek karakter tüketimi `/v1/user/subscription` farkından ölçülsün; sabit fiyat kullanılmasın |
| ElevenLabs sesleri | **Farklı ses**, hiVelzon hesabında | George ya da Rachel kopyalanmasın. Anlatıcı, Hi ve karakterler için hiVelzon hesabında ticari lisanslı sesler seçilsin ve ses kimlikleri `icerik/_evren/` kanonuna yazılsın. Ses klonlama kullanılırsa gerçek kişi sesi yasağı geçerli (§5.6) |
| **ElevenLabs Music `music_v2`** | **Şimdilik kullanma**; karar açık | Müzik kararı açık (önceki rapor, açık soru 6). Ücretsiz planda erişim yok. Ticari planda `music_v2` çıktısının ticari kullanımı ElevenLabs'e göre serbest (spec:31) **[doğrulanmadı]**. Alternatifler: Higgsfield Seed Audio ya da lisansı belgelenmiş yerel kütüphane (`LocalMusicLibrary` deseni) |
| **OpenAI `gpt-image-2`** | **Kullanma** | Görseller Higgsfield ile üretilecek (karar). Karakter tutarlılığı (Alex, Hi) için Soul ID ve referans gerekiyor; `gpt-image-2` istemcisinde referans ya da seed yok. Gerekirse yalnızca Higgsfield içindeki GPT Image modeli üzerinden, kredi defterine yazılarak |
| **OpenAI Chat `gpt-5.6-luna`** (hikâye, çeviri, metadata) | **Doğrudan taşıma; gerekirse farklı sağlayıcı ya da model** | MVP'de içerik Claude Code oturumunda üretiliyor ve kullanıcı onaylıyor (H-028). Hatta programatik bir LLM gerekmeyebilir. Gerekirse `LlmPort` arkasında; JSON Schema ile yapılandırılmış çıktı kullanılsın (Anthropic tool use / structured output ya da OpenAI `response_format: json_schema`), ayrıca token bazlı gerçek maliyet ölçülsün. CEFR uyumu **asla** modele bırakılmasın: kelime havuzu, cümle uzunluğu ve bilinmeyen kelime oranı `content-lint`'te deterministik ölçülsün. Lint hatası `StoryWriter`'daki gibi modele geri beslenebilir |
| `TranslationService` deseni (TR çeviri) | **Desen olarak kullan**, model ayrı karar | "Satır sayısı korunur, satır uzamaz" kuralı ve deterministik dipnot iyi. hiVelzon'da TR çeviri insan kontrolünden geçiyor (`story.tr.md`); sosyal medya metadata kısmı H-017'ye kadar gerekmiyor |
| `LlmClient`, `ImageGenerator`, `MusicGenerator` arayüzleri | **Aynen kullan (desen)** | Sağlayıcı bağımsızlığı ve ücretsiz testler. hiVelzon'da: `LlmPort`, `TtsPort`, `ImageGenPort` (Higgsfield CLI adaptörü), `VideoHostingPort` |
| `CostTracker` (atomik, kilitli, fail-closed) | **Aynen kullan**, kapsamı genişlet | Ayrı defterler: USD (ElevenLabs, LLM) ve **Higgsfield kredisi**. Kayıt **her ücretli çağrıdan hemen sonra** yapılsın, iş sonunda değil. Tavan tanımsızsa **üretim kapalı** olsun (videoGenerator'daki 100 USD varsayılanı kopyalanmasın) |
| `BudgetGuard` + `Constants` fiyatları | **Kullanma (bu haliyle)** | Sabit fiyatlar, eksik kapsam ve sahne başına 2 görseli sayamayan tahmin. Fiyatlar config'ten okunsun; Higgsfield için `generate cost` çıktısı ve kullanıcı onayı (CLAUDE.md Higgsfield kuralı 1) |
| Velzon ve Pinterest üreteçleri | **Kullanma** | Alan dışı. Yalnızca "ucuz adım önce, pahalı adım onaydan sonra" deseni alınsın |
| Whisper ya da ASR | videoGenerator'da yok | Altyazı için gerekmiyor (ElevenLabs hizalaması yeterli). v1'deki konuşma ve telaffuz özelliği için H-006'da ayrı karar verilmeli (Azure / Deepgram / cihazda STT adayları) |
| **AI sohbet (v1, 18+)** | videoGenerator'da karşılığı yok | Gerekenler: akış (streaming), moderasyon, kota sayacı, veri saklama ve yurt dışı aktarım (KVKK), sağlayıcının veri kullanımı ve ZDR koşulları. Aday sağlayıcı plana göre Claude **[karar bekliyor, H-006]**. Anahtar yalnızca backend'de durur |

### 7.1 Ticari kullanım ve lisans notları
- **OpenAI çıktıları:** OpenAI kullanım koşullarına göre çıktının hakları kullanıcıya devredilir ve ticari kullanım serbesttir **[doğrulanmadı: güncel Services Agreement / Terms of Use]**. Görsel çıktısı için telif koruması belirsizdir; bu, bütün AI görselleri için geçerlidir. hiVelzon görselleri Higgsfield ile üreteceği için bu not ikincil kalır.
- **ElevenLabs:** Ücretsiz plan ticari lisans içermez ve atıf ister; ticari kullanım ücretli planlardan başlar **[doğrulanmadı: güncel fiyat ve lisans sayfası]**. Bu yüzden videoGenerator'ın hesabı hiVelzon için **uygun değildir** (H-006 kararıyla tutarlı). Ses kütüphanesindeki seslerin ticari koşulları ses sahibine göre değişebilir **[doğrulanmadı]**.
- **ElevenLabs Music:** Spec (`…design.md:31`) "lisanslı ve ticari kullanıma açık" diyor **[doğrulanmadı]**.
- **Higgsfield:** videoGenerator'da kullanılmıyor. hiVelzon'un lite planında ticari kullanım hakkı **[doğrulanmadı]** (H-027 kapsamı).
- **Çocuk ve genç kullanıcılar:** OpenAI, Anthropic ve ElevenLabs API koşullarında 18 yaş altına hizmet veren uygulamalar için ek yükümlülükler olabilir **[doğrulanmadı]**. AI sohbetin 18+ kararı bu riski azaltır. Hazır içerik (video, TTS) ise 13+ kitleye gider; bu kullanımın sağlayıcı koşullarına uygunluğu ayrıca teyit edilmeli.

---

## 8. Açık sorular

1. **hiVelzon'da programatik LLM gerekiyor mu?** İçerik Claude oturumunda üretiliyorsa MVP'de LLM adaptörü yalnızca sohbet (v1) için gerekir. Gerekiyorsa sağlayıcı Claude mu (plan adayı), OpenAI mı?
2. ElevenLabs ticari planı hangisi olacak (Starter / Creator / Pro)? Aylık karakter ihtiyacı nedir? Kaba hesap: A1 bölümü 45–90 sn ≈ 100–170 kelime ≈ 600–1.000 karakter; S1 12 bölüm + klipler + yeniden üretimler. Bu hesap H-003'teki 300 USD tavanına bağlanmalı.
3. `eleven_v3` `with-timestamps` ile birlikte `speed` ve `seed` destekliyor mu? Desteklemiyorsa A1 yavaş anlatım hangi model ve ayarla yapılacak? Pilotta küçük bir deneme (maliyeti onaylı) yapılmalı.
4. Higgsfield üretimleri için USD karşılığı mı tutulacak, yalnızca kredi mi? 300 USD tavanına nasıl dahil edilecek?
5. Arka plan müziği olacak mı? Olacaksa kaynağı ElevenLabs Music mi, Higgsfield Seed Audio mu, yerel kütüphane mi?
6. G-1 ve G-5 videoGenerator sahibine iletilsin mi? Önerilenler: Velzon piyasa verisi anahtarının döndürülmesi, `TODO.md:277`'nin temizlenmesi ve global `OPENAI_API_KEY` yerine proje başına anahtar. Bu oturumda o repoda değişiklik yapılmadı; karar kullanıcının.
7. GitHub `denizaydogdu/videoGenerator` reposu herkese açık mı? Açıksa G-1'in önemi yükselir.
