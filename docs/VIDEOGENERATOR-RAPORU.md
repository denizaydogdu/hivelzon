# videoGenerator İnceleme Raporu (H-022)

- **Tarih:** 2026-10-11
- **İncelenen repo:** `~/Dev/videoGenerator` (yalnızca okundu), `main` dalı, HEAD `98902a8` (98 commit)
- **Yöntem:** Kaynak kod, `docs/superpowers/specs|plans`, `TODO.md`, `thoughts/`, `channels/*.json` (sırlar maskelenerek) ve son kayıtlı `target/surefire-reports` okundu.
  - Hiçbir build, test ya da ücretli çağrı **çalıştırılmadı**. Test sonuçları, 2026-08-24'teki son koşunun rapor dosyalarından alındı.
- **İlgili belgeler:** CLAUDE.md "videoGenerator projesinden yararlanma", `SARTNAME.md` §8, `ICERIK-MIMARISI.md` §4.5, §4.6, §9

---

## 1. Özet (10 madde)

1. **Asıl kaynak kod ve tasarım belgesidir.** videoGenerator'ın `README.md` ve `CLAUDE.md` dosyaları eski Sora/Suno dönemini anlatıyor ve güncel değil. Güncel mimari şu kaynaklarda:
   - `docs/superpowers/specs/2026-08-01-shorts-fabrikasi-design.md`;
   - `TODO.md`;
   - koddaki javadoc'lar.

   `thoughts/` altında yalnızca büyüme stratejisi ve konu fikirleri var; mimari bilgi yok.
2. **Hat sağlam ve iyi test edilmiş.**
   - Hat: tek LLM çağrısında hikâye ve sahne prompt'u → sahne görselleri → dil başına çeviri → zaman damgalı TTS → sahne kesimleri → karaoke `.ass` → Ken Burns render → onay kuyruğu → idempotent yayın.
   - Son koşu: **365 test, 0 hata**. ffmpeg testleri varsayılan koşuda hariç tutuluyor.
3. **CLAUDE.md tablosundaki bir varsayım yanlış.** `SceneImageService` Higgsfield kullanmıyor; OpenAI `gpt-image-2` kullanıyor ve görsel başına sabit **0,08 USD** tahmini yazıyor. Kodda Higgsfield'a dair hiçbir şey yok. Higgsfield için yeni bir adaptör yazılmalı.
4. **En çok değer taşıyan ve en kolay taşınan parçalar şunlar:**
   - `SceneTimer` ve `SubtitleRenderer`: saf fonksiyonlar, aynen ya da küçük uyarlamayla taşınır.
   - `KenBurnsRenderer.buildFilterGraph`: kare bazında kaymayı önleyen zamanlama modeli.
   - `JobStore`: atomik yazma.
   - `PublishService`: idempotent yayın deseni.
5. **Ses normalizasyonu hiVelzon hedefini karşılamıyor.**
   - `loudnorm` parametresiz, tek geçişte çalışıyor. Bu, ffmpeg varsayılanı olan **I=-24 LUFS, TP=-2 dBTP, LRA=7** demektir.
   - Normalizasyon yalnızca müzik miksajı yapılınca uygulanıyor. **Yalnız sesli modda hiç normalizasyon yok.**
   - hiVelzon hedefleri (-16 LUFS / -1 dBTP ve -14 LUFS) için iki geçişli yeni bir adım ve `ebur128` ölçüm kapısı gerekir.
6. **Çıktı formatı sabit kodlanmış.**
   - Çıktı: 1080×1920, 30 fps, H.264 (`libx264`, varsayılan CRF), `yuv420p`, AAC 192k ve `+faststart`.
   - **16:9 ve HLS desteği yok.**
   - `ChannelProfile.validate()` süreyi **60–90 sn**, sahne sayısını **3–10** ile sınırlıyor. A1 (30–60 sn) ve C1 (4–8 dk) bu aralığa girmiyor.
7. **Bütçe koruması hiVelzon kuralına uymuyor.**
   - `budget.monthly.usd` tanımlı değilse varsayılan değer **100 USD**. Yani tavan yokken ücretli üretim **açık** kalıyor.
   - Maliyet aylık deftere **yalnızca iş başarıyla bitince** yazılıyor. Yarıda kalan işlerin harcaması hiç sayılmıyor.
   - Tahminler sabit sayılar; gerçek maliyet değil.
   - Kullanıcıdan üretim başına onay alınmıyor.
   - Higgsfield kredisi izlenmiyor.
8. **Kaldığı yerden devam kısmen çalışıyor.**
   - Hikâye, var olan görseller ve müzik atlanıyor.
   - Ama bir dil varyantı tamamlanmadan çökerse çeviri ve **TTS yeniden ücretle** üretiliyor.
   - Görseller ve TTS sesi doğrudan hedef dosyaya yazılıyor (atomik değil). Bu yüzden yarım yazılmış bir PNG "var" sayılıp atlanabilir.
9. **AI etiketleri eksik.**
   - YouTube'da `containsSyntheticMedia=true` her zaman gönderiliyor.
   - `selfDeclaredMadeForKids=false` sabit kodlanmış; hiVelzon'da bu karar içerik başına verilmeli.
   - TikTok'ta AIGC bayrağı (`is_aigc`) ve Instagram'da `is_ai_generated` **gönderilmiyor**.
10. **Sır ve lisans riskleri var.**
    - Git'e işlenmiş `TODO.md`'de bir API anahtarının parçası açık metin olarak duruyor (~277. satır; bu rapora kopyalanmadı).
    - `config/` altındaki dosyalar ve `channels/*.json` sır içeriyor ya da içerebilir. Bunlar gitignore'da.
    - ElevenLabs hesabı **ücretsiz plan** (TODO §2). hiVelzon bu hesabı kullanmamalı; ticari kullanım lisansı H-027 kapsamında doğrulanmalı.

---

## 2. Mimari ve akış

### 2.1 Paketler

| Paket | İçerik |
|---|---|
| `api/` | `LlmClient`, `ImageGenerator`, `MusicGenerator` arayüzleri; OpenAI, ElevenLabs ve YouTube istemcileri |
| `service/` | `StoryWriter`, `TranslationService`, `SceneImageService`, ayrıca eski `IdeaGenerator`, `NicheFinder` vb. |
| `processor/` | `SceneTimer`, `SubtitleRenderer`, `KenBurnsRenderer`, `AudioProcessor`, `FFmpegWrapper` |
| `job/` | `Job`, `JobStatus`, `JobStore`, `JobPipeline`, `DefaultRenderEngine`, `BudgetGuard`, `CostTracker`, `CostBreakdown`, `LocalMusicLibrary` |
| `channel/` | `ChannelProfile`, `ChannelStore`, `NicheSpec` |
| `publish/` | `Publisher` arayüzü; `YouTubePublisher`, `MetaReelsPublisher`, `TikTokPublisher`, `PublishService`, `UploadCounter`, HTTP istemcileri |
| `web/` | `BackofficeServer` (JDK `HttpServer`), `JobService`, `RangeSupport`, `StatsCollector`; statik UI `src/main/resources/web/` altında |
| `velzon/`, `pinterest/` | Velzon'un borsa paylaşımları ve Pinterest. **hiVelzon ile ilgisi yok.** |
| `main/Main` | CLI ve bağımlılıkların elle bağlanması (1.174 satır). Spring yok. |

**Bağımlılıklar** (`pom.xml`):
- Java 17;
- Gson 2.10.1, SLF4J/Logback;
- Google API Client (YouTube v3, OAuth);
- Apache HttpClient5, jsoup, sqlite-jdbc;
- test için JUnit 5 ve Mockito;
- sistemde **ffmpeg/ffprobe** kurulu olmalı (kodda FFmpeg 8'e atıf var).

### 2.2 Üretim akışı (JobPipeline)

```
 channels/<id>.json (ChannelProfile)
          │
          ▼
 ┌─ BudgetGuard.assertAllows(sabit tahmin) ── aşarsa: iş başlamaz
 │
 │  FAZ 1 — dilden bağımsız                         output/jobs/<jobId>/
 │  IdeaGenerator / topicHint ──► StoryWriter ──────► job.json (story)        [LLM 1×]
 │                                     │
 │                                     ▼
 │                              SceneImageService ─► scenes/01a.png,01b.png… [görsel N×2]
 │                                     │   (stylePrefix + prompt; dosya varsa atla)
 │                                     ▼
 │                       MusicApiClient | LocalMusicLibrary ─► audio/music.mp3 (ops.)
 │  status = RENDERING
 │
 │  FAZ 2 — her dil için (variant kaydı = tamamlanma işareti)
 │  TranslationService.localize ─► narrations[], hookText, metadata          [LLM 1×]
 │        │
 │        ▼  SceneTimer.joinNarrations(" ")
 │  ElevenLabsClient.generateWithTimestamps ─► audio/<lang>.mp3
 │        │                                   audio/<lang>.alignment.json    [TTS]
 │        ▼
 │  SceneTimer.sceneEndTimes / sceneDurations  (karakter bitiş zamanlarından)
 │        │
 │        ├─► SubtitleRenderer.writeKaraoke ─► subs/<lang>.ass (hook + karaoke + son kart)
 │        ▼
 │  DefaultRenderEngine:
 │     AudioProcessor.mix (ducking + afade + loudnorm*) ─► temp/<job>-<lang>-mix.mp3
 │     KenBurnsRenderer.render (zoompan + xfade + subtitles) ─► renders/<lang>.mp4
 │        │                                          (* loudnorm yalnız müzik varsa)
 │        ▼
 │  job.variants += LangVariant ; jobStore.save
 │
 └─ CostTracker.add(job.cost.total)  ← YALNIZCA başarıda
    status = PENDING_REVIEW
```

### 2.3 Onay ve yayın akışı

```
 PENDING_REVIEW ──(BackofficeServer: PATCH metadata)──┐
       │                                              │
       ├── reject ──► REJECTED                        │
       ▼                                              │
 approve {platforms[]} ──► APPROVED ◄─────────────────┘
       │
       ▼  publishExecutor (tek iş parçacığı)
 PublishService.publishApproved
   for variant × platform:
     zaten PUBLISHED veya SKIPPED_NO_PUBLISHER ise ─► atla      (idempotentlik)
     YOUTUBE ise UploadCounter günlük limit kontrolü
     Publisher.publish ─► Publication{platform,status,url}
     job.json kaydı (her yüklemeden hemen sonra)
   hata varsa: PUBLISHING'de kalır, eksikler sonra tekrar denenir
   hepsi tamamsa ─► PUBLISHED
```

**Durum makinesi:**
- Ana yol: `DRAFTING → RENDERING → PENDING_REVIEW → APPROVED → PUBLISHING → PUBLISHED`
- Yan çıkışlar: `FAILED` ve `REJECTED`

hiVelzon K-05 ile karşılaştırma:
- `PENDING_REVIEW` ≈ `IN_REVIEW`;
- hiVelzon'da `SCHEDULED`, `ARCHIVED` ve `WITHDRAWN` ek durumları var;
- hiVelzon'da onay **sürüme** bağlanıyor.

---

## 3. Sınıf başına inceleme

Taşıma notu kısaltmaları:
- **A (aynen):** Mantık değişmeden kopyalanır; yalnızca paket adı ve stil değişir.
- **U (uyarlanır):** Desen ya da kod alınır, ama anlamlı değişiklik gerekir.
- **X (alınmaz):** Taşınmaz.

**Kaynak belirtme kuralı** (bütün taşınan dosyalar için):
- Taşınan dosyanın başına şu yorum konur:

  ```java
  // Kaynak: github.com/denizaydogdu/videoGenerator @ 98902a8
  //   src/main/java/com/videogenerator/processor/SceneTimer.java
  // Değişiklikler: <kısa liste> — gerekçe: <...> (hiVelzon H-0xx)
  ```

- Aynı bilgi commit mesajında da yer alır.
- Repo'lar arasında Maven bağımlılığı, git submodule ya da ortak jar **kurulmaz** (CLAUDE.md kuralı).

### 3.1 `service/StoryWriter`

**Dosya:** `src/main/java/com/videogenerator/service/StoryWriter.java` (≈150 satır)

**Ne yapar?** Tek LLM çağrısıyla şunları üretir:
- başlık;
- `hookText` (4–7 kelimelik ekran yazısı);
- tam `sceneCount` adet sahne. Her sahnede 1–2 cümlelik `narration` ve iki `imagePrompts` bulunur.

Görsel ve anlatım aynı çağrıda üretildiği için birbiriyle uyumlu kalır.

**API:** `Story write(ContentIdea idea, ChannelProfile profile) throws ApiException`

**Bağımlılıklar:**
- `LlmClient` arayüzü. Üretimde `OpenAiGptClient` kullanılıyor; model config'te `llm.model`.
- Gson ve `LlmJson.strip` (markdown kod çitlerini temizler).

**Konfigürasyon:** `ChannelProfile`'dan `targetDurationSeconds`, `sceneCount`, `niche.topic` ve `stylePrefix`. Kelime bütçesi `süre × 2,2 kelime/sn` olarak hesaplanıyor.

**Hata davranışı:**
- Çıktı sırayla şunlar için doğrulanıyor: JSON geçerli mi, sahne sayısı tam mı, `hookText` dolu mu, her sahnede prompt var mı.
- Hata olursa en fazla 3 deneme yapılıyor. Her yeni denemede bir önceki hatanın açıklaması prompt'a ekleniyor (geri bildirimli yeniden deneme).
- 3 deneme de başarısız olursa `IllegalStateException` fırlatılıyor.

**Idempotentlik:** Yok; her çağrı yeni metin üretir. Pipeline bunu, hikâyeyi `job.json`'a yazıp bir dahaki sefere atlayarak çözüyor.

**Test:** `StoryWriterTest` (5), `StoryWriter2Test` (5), `StoryLengthTest` (1). Hepsi sahte LLM ile çalışıyor.

**Taşıma notu: U.**
- Alınacaklar:
  - "tek çağrıda hikâye ve görsel prompt'u" yaklaşımı;
  - JSON şeması;
  - geri bildirimli yeniden deneme döngüsü;
  - `LlmClient` benzeri port.
- Atılacaklar:
  - true-crime kuralları;
  - `PACING_VARIANTS`;
  - loop/hook kuralları;
  - `Random` ile tempo seçimi (deterministik olmadığı için test edilmesi zor).
- Spring karşılığı:
  - `generation.story.StoryDraftService` ve bir `LlmPort` adaptörü (OpenAI ya da Anthropic, `RestClient` ile).
  - Prompt şablonu kodun içinde değil, sürümlü bir dosyada (`prompts/story-v1.md`) tutulur. Prompt sürümü `PROMPTS.md`'ye yazılır.
- CEFR ekleri için bkz. §4a.
- Sahne sayısı ve uzunluk değerleri `ChannelProfile`'dan değil, seviye profilinden gelir.

### 3.2 `service/SceneImageService`

**Dosya:** `service/SceneImageService.java` (≈60 satır)

**Ne yapar?**
- Her sahne prompt'unun başına `stylePrefix` ekler. Stil kilidi yalnızca bu sınıfta uygulanır.
- Çıktıları `scenes/NNx.png` olarak yazar; sahne başına `01a`, `01b` gibi.
- Dosya zaten varsa üretimi atlar. Yarıda kalan işte kredi israfını bu önler.

**API:** `double generateAll(Story, Path scenesDir)`. Dönüş değeri gerçekten üretilen görsellerin tahmini maliyetidir.

**Bağımlılıklar:** `ImageGenerator` arayüzü. Üretimde `ImageApiClient` kullanılıyor: OpenAI `/images/generations`, `gpt-image-2`, `quality=medium`, base64 PNG.

**Konfigürasyon:** `image.model`, `image.size`, `image.quality`. Maliyet `Constants.COST_IMAGE_MEDIUM = 0.08` sabitinden alınıyor.

**Hata davranışı:**
- `ImageApiClient`, 429 ve 5xx yanıtlarında `RetryPolicy` ile üstel bekleme yapıyor.
- 4xx yanıtında `ApiException` fırlatıyor.
- **Atomik yazma yok.** `Files.write` doğrudan hedef dosyaya yazıyor. Yazma sırasında çökme olursa bozuk bir PNG "var" sayılıp kalıcı olarak atlanır.

**Test:** `SceneImageServiceTest` (1), `SceneImageTempoTest` (4).

**Taşıma notu: U.**
- "Dosya varsa atla" ve "stil önekini tek yerde uygula" desenleri aynen alınır.
- Değişiklikler:
  1. Higgsfield için bir `ImageGenerationPort` adaptörü yazılır. CLI'yi `ProcessBuilder` ile çağırır: önce `generate cost`, sonra onay, sonra `generate create`, `wait` ve indirme. Dönen job id ve harcanan kredi kaydedilir.
  2. Yazma `.tmp` dosyasına yapılır, ardından `ATOMIC_MOVE` ile taşınır. Ayrıca PNG başlığı ya da boyutu doğrulanır.
  3. Maliyet sabitten değil, `generate cost` çıktısından alınır.
  4. Her üretim `PROMPTS.md`'ye satır olarak eklenir.
- Bu sınıf backend'e değil, içerik üretim aracına (`content-tools`) gider (bkz. §5).

### 3.3 `service/TranslationService`

**Dosya:** `service/TranslationService.java` (≈115 satır)

**Ne yapar?** Numaralı anlatım satırlarını hedef dile çevirir. Kurallar: satır sayısı aynı kalır, uzunluk aynı ya da daha kısa olur. Ayrıca `hookText` çevrilir ve sosyal medya meta verisi (başlık, açıklama, 3–5 hashtag) üretilir. Açıklamanın sonuna dile göre bir yasal dipnot eklenir.

**API:** `LocalizedStory localize(Story story, String lang)`

**Bağımlılıklar:** `LlmClient` ve Gson.

**Konfigürasyon:** Başlık kalıpları (`TITLE_FORMULAS`) ve dipnotlar (`DISCLAIMERS`) kodun içine gömülü, true-crime'a özgü ve yalnızca tr/en/es için var.

**Hata davranışı:**
- Satır sayısı uyuşmazsa ya da meta veri geçersizse `IllegalStateException` fırlatılıyor. Bu sınıfta yeniden deneme **yok**.
- `hookText` boş gelirse kaynaktaki değer kullanılıyor.

**Test:** `TranslationServiceTest` (5).

**Taşıma notu: U (kısmen).**
- hiVelzon'da çeviri **anlatıma girmez**: ses her zaman İngilizce. Çeviri yalnızca şunlar için kullanılır:
  - `story.tr.md` taslağı (insan kontrolünden geçecek);
  - sözlükteki Türkçe karşılıklar;
  - TR altyazı satırı (K-03, isteğe bağlı);
  - sosyal medya meta verisi.
- "Satır sayısı ve sırası korunur" kuralı ve satır sayısı doğrulaması aynen alınır. Satırlar sahnelerle birebir eşleşmeli.
- Başlık kalıpları ve dipnotlar alınmaz. hiVelzon'un dipnotu: "Yapay zekâ ile üretilmiştir".
- `StoryWriter`'daki geri bildirimli yeniden deneme buraya da eklenmeli.

### 3.4 `api/ElevenLabsClient`

**Dosya:** `api/ElevenLabsClient.java` (364 satır). Model sınıfı: `model/Alignment.java`.

**Ne yapar?**
- `generateWithTimestamps`, şu uç noktayı çağırır: `POST https://api.elevenlabs.io/v1/text-to-speech/{voiceId}/with-timestamps`
- Gönderilen alanlar: `text`, `model_id`, `voice_settings{stability, similarity_boost}`.
- Yanıttaki `audio_base64` MP3 olarak, `alignment` ise ham JSON olarak diske yazılır.
- Ayrıca şunlar var: zaman damgasız `generateVoiceover`, `getAvailableVoices`, `getSubscriptionInfo`, `estimateCost` (0,30 USD / 1.000 karakter varsayımıyla).

**API:**
- `TtsResult generateWithTimestamps(String text, VoiceConfig, Path audioOut, Path alignmentOut)`
- `static Alignment parseAlignment(String json)`

**Bağımlılıklar:**
- ElevenLabs REST API;
- Gson;
- `HttpUtil` (JDK `HttpClient`);
- `RetryPolicy`.

**Konfigürasyon:**
- `tts.api.key` ya da `ELEVENLABS_API_KEY`;
- `tts.model` (varsayılan `eleven_v3`; `VoiceConfig` kurucusundaki varsayılan `eleven_multilingual_v2`);
- `tts.stability`;
- `voiceId` kanal profilinden geliyor.

**Hata davranışı:**
- 2xx dışı her yanıt yeniden deneme döngüsüne giriyor. Bu, 4xx yanıtlarının da tekrar denenmesi demek.
- Alignment dizilerinin uzunlukları tutarsızsa ya da alignment boşsa `IllegalStateException` fırlatılıyor.
- Ses ve alignment dosyaları atomik yazılmıyor.

**Eksikler (hiVelzon için):**
- `voice_settings.speed` gönderilmiyor. CEFR'e göre anlatım hızı ayarlanamıyor.
- `output_format` belirtilmiyor.
- `previous_text` / `next_text` (parça birleşiminde prozodi sürekliliği) kullanılmıyor.
- `normalized_alignment` kullanılmıyor.
- İstek başlığında `Accept: audio/mpeg` var, ama bu uç nokta JSON döndürüyor. Üretimde çalışıyor, yine de temizlenmeli.

**Test:**
- `AlignmentParseTest` (2) ve fixture dosyası `src/test/resources/fixtures/alignment-sample.json`.
- HTTP katmanı için test yok.

**Taşıma notu: U.**
- `parseAlignment` ve `Alignment` modeli aynen alınır.
- İstemci Spring `RestClient` ile yeniden yazılır ve bir `TtsPort` arayüzünün arkasına konur. Adaptör `ElevenLabsTtsAdapter` olur. Adaptör `content-tools`'a gider; backend'de konuşma özelliği için ayrı bir adaptör gerekebilir.
- Eklenecekler:
  - seviyeye göre `speed` (§4a tablosu);
  - atomik yazma;
  - yalnızca 429 ve 5xx için yeniden deneme;
  - harcanan karakter sayısının kaydı;
  - mümkünse istek idempotentliği: aynı metin, ses ve ayar için hash. Bu hash'le adlandırılmış dosya varsa çağrı yapılmaz.

> **Doğrulanmadı:** `eleven_v3` modelinin `/with-timestamps` uç noktasını ve `speed` ayarını desteklediği bu incelemede doğrulanmadı. Bağlam: videoGenerator'ın üretimde bu modelle alignment aldığı TODO kayıtlarından anlaşılıyor.

### 3.5 `processor/SceneTimer`

**Dosya:** `processor/SceneTimer.java` (≈60 satır). Saf, durumsuz bir sınıf.

**Ne yapar?**
- `joinNarrations`, sahneleri tek boşlukla birleştirir. TTS'e giden metin **tam olarak** budur.
- `sceneEndTimes(narrations, alignment)`, her sahnenin son karakterinin `character_end_times_seconds` değerini alır. Son sahne her zaman sesin sonuna kadar uzatılır.
- `sceneDurations` ardışık farkları hesaplar.
- Görsel süresi ve altyazı aynı veriden türetildiği için aralarında kayma oluşamaz.

**Bağımlılık:** Yalnızca `Alignment`.

**Hata davranışı:** Normalizasyondan kaynaklanan karakter sayısı farkını `Math.min(cursor, len-1)` ile tolere ediyor. ElevenLabs metni değiştirirse sahne sınırları sessizce kayabilir; bu durumda uyarı verilmiyor.

**Test:** `SceneTimerTest` (4).

**Taşıma notu: A.**
- En temiz taşınacak sınıf bu. Testleriyle birlikte kopyalanır.
- Ek öneri: Alignment karakter sayısı birleşik metnin uzunluğuna eşit değilse **uyarı** ya da `content-lint` hatası verilsin.

### 3.6 `processor/SubtitleRenderer`

**Dosya:** `processor/SubtitleRenderer.java` (273 satır). Saf, durumsuz bir sınıf.

**Ne yapar?**
- Karakterleri boşluklara göre kelimelere ayırır. Noktalama işaretleri kelimeye yapışık kalır.
- Kelimeleri sabit sayıda gruplar halinde cue'lara böler.
- `.ass` üretir:
  - `PlayResX/Y` 1080×1920;
  - Arial, 72 pt;
  - alttan `MarginV=420`, Shorts arayüzü için güvenli alan.
- İsteğe bağlı ekler:
  - ilk 2,2 sn'de üstte sarı **hook** yazısı;
  - son 2,5 sn'de **son kart** yazısı.
- `toKaraokeAss`: her kelime için bir `Dialogue` satırı yazar; grup metni ekranda sabit kalır, yalnızca etkin kelime sarı olur.
- `assTime`, önce santisaniyeye yuvarlayıp sonra böler (59,995 sn sorununun düzeltmesi).
- `escapeAssText`, `\`, `{` ve `}` karakterlerini temizler.

**API:**
- `buildCues(Alignment, maxWords)`
- `toAss(cues, hook)`
- `toKaraokeAss(a, n, hook, end)`
- `writeKaraoke(...)`
- `write(...)`

**Test:** `SubtitleRendererTest` (9).

**Eksikler (hiVelzon §9.6 için):**
- Cue'lar cümle sınırına göre bölünmüyor.
- En kısa cue ≥ 1 sn kuralı yok.
- Okuma hızı kontrolü (A1'de ≤ 15 karakter/sn) yok.
- Satır kırma ve satır başına en fazla karakter sınırı yok.
- WebVTT çıktısı yok.
- Hedef kelimede küçük TR karşılık stili yok.
- Çözünürlük sabit kodlanmış.
- Arial fontu Linux'ta olmayabilir.

**Taşıma notu: U.**
- Kelime çıkarma (`extractWords`), `assTime`, `escapeAssText` ve karaoke mantığı aynen alınır.
- Yeni sınıflara bölünür:
  - `AlignmentWords`: karakterden kelimeye, ortak çekirdek;
  - `CueSegmenter`: cümle sınırı, en kısa cue, karakter/sn ve satır sınırı, seviyeye göre parametreli;
  - `AssWriter`: sosyal medya; parametreler çözünürlük, stil ve TR karşılık stili;
  - `WebVttWriter` ve `WordTimingJsonWriter`: uygulama için (§4c).
- Hook ve son kart metinleri true-crime'a özgü. Yerine §4.5'teki 30 sn şablonunun katmanları (seviye rozeti, "Kendini test et", CTA, kalıcı AI ibaresi) gelir.

### 3.7 `processor/KenBurnsRenderer`

**Dosya:** `processor/KenBurnsRenderer.java` (≈115 satır)

**Ne yapar?** Sahne görsellerinden tek bir ffmpeg `-filter_complex` çağrısıyla video üretir.

Filtre grafı:
- Her görsel için `scale … increase, crop=1080:1920`, ardından `zoompan`. Çift sıradaki sahneler 1,0'dan 1,10'a yakınlaşır, tek sıradakiler 1,10'dan 1,0'a uzaklaşır.
- Görseller arasında `xfade=fade` geçişi. Geçiş süresi 0,5 sn, ama en kısa görselin süresinin %40'ını geçemez.
- En sonda `subtitles` filtresiyle `.ass` gömülür.

Zamanlama modeli:
- 1. sahneden sonraki her sahne, geçiş payı kadar uzatılır.
- Ofsetler kare sayısına yuvarlanmış sürelerden hesaplanır. Böylece birikimli kayma olmaz ve toplam video süresi ses süresine eşit kalır.

**API:**
- `static String buildFilterGraph(double[] durations, String assPath, int fps)`
- `File render(List<File> images, double[] durations, File mixedAudio, File ass, Path out)`

**Çıktı ayarları:** `libx264` (CRF verilmiyor, varsayılan 23), `yuv420p`, AAC 192k, `-movflags +faststart`, `-shortest`, 30 fps.

**Bağımlılık:** `FFmpegWrapper.executeCommand` ve sistemdeki ffmpeg (libass derlenmiş olmalı).

**Hata davranışı:**
- Görsel ve süre sayıları uyuşmazsa `IllegalArgumentException` fırlatılıyor.
- ffmpeg hata verirse çıktının son 20 satırı `VideoProcessingException` mesajına ekleniyor.
- **`assPath` filtre grafına kaçışsız ekleniyor.** Yolda `:` ya da `'` varsa graf bozulur.
- Render atomik değil. Pipeline'da tamamlanma işareti mp4 dosyası değil, varyant kaydı. Bu doğru bir tercih.

**Test:** `KenBurnsFilterTest` (4) ve `KenBurnsRenderFfmpegTest` (1). İkincisi `@Tag("ffmpeg")` ile işaretli ve varsayılan koşuda hariç.

**Taşıma notu: U.**
- Zamanlama modeli ve filtre grafı mantığı alınır. Bu, deneme yanılmayla bulunmuş değerli bir bilgi.
- Değişiklikler:
  - `OutputProfile{width,height,fps,crf}` parametresi: 9:16 için 1080×1920, uygulama için 16:9'da 1920×1080 ya da 1280×720.
  - Görsel üretimde en-boy oranı, kırpma kaybını önlemek için çıktıya uygun seçilmeli.
  - Uygulama çıktısında **altyazı gömülmez** (K-03: ayrı WebVTT). `subtitles` filtresi isteğe bağlı olmalı.
  - `assPath` kaçışı eklenmeli.
  - Çıktı önce `.tmp` dosyasına yazılıp sonra taşınmalı.
  - Zaman aşımı süre ile orantılı olmalı (bkz. §3.8).
- HLS bu sınıfın işi değil; Bunny Stream kodlar (K-13).

### 3.8 `processor/AudioProcessor` ve `processor/FFmpegWrapper`

**Dosyalar:** `processor/AudioProcessor.java` (202 satır), `processor/FFmpegWrapper.java` (514 satır)

**Ne yaparlar?**

`AudioProcessor`, config'ten bir `AudioMixConfig` kurar ve `FFmpegWrapper`'a devreder. Metotları:
- `mixVoiceoverAndMusic`
- `normalizeAudio`
- `trimAudio`
- `adjustVolume`
- `getAudioDuration`

Çıktıyı ortak `temp/` klasörüne yazar.

`FFmpegWrapper.buildMixFilter` şu filtreyi kurar:
1. ses ve müzik için ayrı `volume`;
2. sesi bölen `asplit`;
3. `sidechaincompress` ile müziği ses altında kısma (ducking): `threshold=0.03:ratio=4:attack=5:release=200`;
4. `amix`;
5. başta ve sonda `afade`;
6. **parametresiz `loudnorm`**.

Çıktı `libmp3lame -q:a 2` ile kodlanıyor.

`executeCommand`:
- stdout ve stderr'i birleştirip okuyor;
- 5 dakikalık zaman aşımı uyguluyor;
- hata durumunda son 20 satırı döndürüyor.

Diğer metotlar: `getMediaDuration` (ffprobe), `mergeVideoAudio`, `resizeVideo`, `trimVideo`, `convertToMp4` ve doğrulama yardımcıları.

**Konfigürasyon:**
- `audio.voiceover.volume`, `audio.music.volume`;
- `audio.ducking.enabled` (varsayılan true), `audio.ducking.amount`;
- `audio.normalize` (varsayılan true);
- `ffmpeg.path`.

**Hata ve bilinen sorunlar:**
- `loudnorm` parametresiz çalışıyor. Bu ffmpeg varsayılanı demek: **-24 LUFS / -2 dBTP / LRA 7, tek geçiş** (bkz. §4d).
- `DefaultRenderEngine` müzik yoksa `AudioProcessor`'ı hiç çağırmıyor. **Yalnız sesli videolarda normalizasyon yok.**
- Ses önce MP3'e, render'da da AAC'ye kodlanıyor. Bu çift kayıplı kodlama demek ve ölçülen ses yüksekliği hafifçe kayabilir.
- Zaman aşımı `waitFor` çağrısı stdout'un sonuna kadar okunduktan **sonra** başlıyor. Çıktı üretmeden takılan bir ffmpeg süreci zaman aşımına uğramaz. Ayrıca 5 dakika, 4–8 dakikalık C1 render'ları için kısa kalabilir.
- `executeCommandWithOutput`'ta hiç zaman aşımı yok.

**Test:** `MixFilterTest` (3) yalnızca filtre metnini sınıyor. Komut çalıştırmanın testi yok. `RenderCleanupTest` var.

**Taşıma notu: U.**
- `buildMixFilter` aynen alınır; ducking grafı canlı bir hatadan sonra düzeltilmiş hâliyle alınmalı.
- Yeni yazılacaklar:
  - `FfmpegRunner`: stdout ve stderr ayrı iş parçacığında okunur, zaman aşımı gerçekten uygulanır, `destroyForcibly` kullanılır, gerekirse komut maskelenerek loglanır.
  - `LoudnessNormalizer`: iki geçişli `loudnorm` (önce `print_format=json` ile ölçüm, sonra `measured_*` değerleriyle uygulama). Hedefler: uygulama için `I=-16:TP=-1:LRA=11`, sosyal medya için `I=-14:TP=-1`.
  - `LoudnessGate`: `ebur128` ile ölçer; ±1 LU dışındaysa `content-lint` hata verir.
- Normalizasyon **her durumda** son adım olmalı, müzik olsun olmasın.
- Ara dosyalar WAV ya da PCM olmalı. Tek kayıplı kodlama son adımda yapılır.
- `AudioProcessor`'ın `Configuration.getInstance()` singleton'ı yerine Spring `@ConfigurationProperties` kullanılır.

### 3.9 `job/JobPipeline`, `job/Job`, `job/JobStore` (+ `DefaultRenderEngine`)

**Dosyalar:** `job/JobPipeline.java` (315 satır), `job/Job.java`, `job/JobStore.java`, `job/JobStatus.java`, `job/DefaultRenderEngine.java`

**Ne yaparlar?**

`JobPipeline`:
- Akışı §2.2'deki gibi yönetir.
- `run(channelId)` yeni iş açar; `resume(jobId)` yarım işi sürdürür. İş `PENDING_REVIEW`, `APPROVED` ya da `PUBLISHED` durumundaysa bir şey yapmaz.
- `TtsEngine` ve `RenderEngine` iç arayüzleriyle test edilebilir.
- `withLocalMusicDir` ve `withTopicHint` ile ek ayar alır.

`Job`, şu alanları tutar:
- `jobId` (`yyyy-MM-dd-HHmmss-<8 hex>`), `channelId`, `status`;
- `story`, `musicFile`;
- `variants[]` (lang, metadata, audio/alignment/render dosyaları, süre, publications[]);
- `cost` (images/tts/music/llm);
- `error`;
- `costRecorded` (maliyetin iki kez yazılmasına karşı koruma);
- `approvedPlatforms`.

`normalize()`, Gson'dan sonra null olan koleksiyonları onarır.

`JobStore`:
- Her iş için bir klasör tutar; `job.json` önce `.tmp` dosyasına yazılır, sonra `ATOMIC_MOVE` ile taşınır.
- `dirFor`, path traversal saldırısına karşı korumalı.
- `list()` bozuk işleri atlayıp devam eder.

**Hata davranışı:**
- Herhangi bir istisnada `FAILED` durumu ve `error` alanı kaydedilir. Kayıt da başarısız olursa asıl hata maskelenmez.
- Kalıcı (4xx) ve geçici hata ayrımı client katmanında yapılıyor; `ElevenLabsClient`'ta bu ayrım tam değil.

**Idempotentlik ve devam etme:** bkz. §4g.

**Test:** `JobPipelineTest` (6), `JobStoreTest` (4), `LocalMusicTest`, `RenderCleanupTest`. Sahte istemcilerle sıfır maliyetle uçtan uca koşuyor.

**Taşıma notu: U (desen olarak).**
- Alınacak desenler:
  - adım adım ilerleme ve her adımdan sonra atomik kayıt;
  - "tamamlanma işareti çıktı dosyası değil, kayıttır" ilkesi;
  - sahte motorlarla uçtan uca test.
- Değişiklikler:
  - Faz 2'nin dil döngüsü kalkar. hiVelzon'da tek ses dili (EN) var; onun yerine **çıktı profilleri** döngüsü gelir: `app-16x9`, `app-9x16`, `social-9x16`.
  - Her adımın kendi işareti olur, ara çıktılar da kalıcı yazılır: `story`, `images[i]`, `tts`, `subs`, `render[profile]`, `loudness[profile]`. Böylece TTS iki kez ödenmez.
- `content-tools` içinde `job.json`, içerik klasörünün yanında ya da `.work/<contentId>/` altında tutulabilir (medya git'e girmez, K-01).
- Backend'in `generation` modülünde ise bunun karşılığı PostgreSQL'de bir `generation_job` tablosudur: durum, adım, deneme sayısı, idempotency anahtarı.
- Faz sırası şu olmalı: içerik `content-lint`'ten geçer, **sonra** medya üretilir (§9.2: 3. adım lint, 5. adım medya). videoGenerator'da metin denetimi yok; doğrudan görsele geçiyor.

### 3.10 `job/BudgetGuard` ve `job/CostTracker` (+ `CostBreakdown`)

**Dosyalar:** `job/BudgetGuard.java`, `job/CostTracker.java`, `job/CostBreakdown.java`

**Ne yaparlar?**

`BudgetGuard.assertAllows(estimateUsd)`:
- Bu ay harcanan ile tahminin toplamı tavanı aşıyorsa `IllegalStateException` fırlatır.
- Javadoc'ta kabul edilmiş bir sınırlama yazıyor: kontrol ve harcama atomik değil; güvenlik tek bir harcayan sürece dayanıyor.

`CostTracker`:
- Aylık harcamayı `output/costs/<yyyy-MM>.json` dosyasında `{"spent": x}` olarak tutar.
- Yazarken bir OS `FileLock` alır, `.tmp` dosyasına yazar ve `ATOMIC_MOVE` ile taşır.
- Dosya bozuksa **kapalı yönde hata verir** ("fail closed"); harcamayı sıfır saymaz.

`CostBreakdown`: iş başına images, tts, music ve llm toplamlarını tutar.

**Konfigürasyon:** `budget.monthly.usd`, **varsayılan 100,0**. Tahmin `JobPipeline.assertBudget` içinde sabitlerle hesaplanıyor:

```
sahne × 0,08 + dil × 0,10 + 0,50 + (1 + dil) × 0,01
```

**Test:** `BudgetGuardTest` (3), `CostTracker`'ı da kapsıyor. `CostTracker` için ayrı bir test sınıfı yok.

**Taşıma notu: U (kural sıkılaştırılarak).** Ayrıntı §4f'de.
- Alınacaklar:
  - "çağrıdan önce kontrol";
  - "bozuk dosyada kapalı yönde hata";
  - atomik dosya yazma.
- hiVelzon'da iki katman olur:
  1. **Backend `generation` (ve `speaking`) modülü:** PostgreSQL'de `cost_ledger` tablosu, `SELECT … FOR UPDATE` ya da koşullu `UPDATE` ile atomik **rezervasyon**, sonra gerçek değerle mutabakat. Tavan `@ConfigurationProperties` ile okunur; **null ya da 0 ise ücretli çağrı reddedilir.**
  2. **`content-tools`:** Higgsfield **kredisi** ve ElevenLabs karakteri için ayrı bir defter tutar. Her üretimden önce `generate cost` çalışır, ardından **açık kullanıcı onayı** alınır.

### 3.11 `channel/ChannelProfile` ve `channels/*.json`

**Dosyalar:** `channel/ChannelProfile.java`, `channel/ChannelStore.java`, `channel/NicheSpec.java`, `channels/*.json`

**Biçim:** Hassas değerler aşağıda yer tutucuyla gösterildi.

```json
{
  "channelId": "truecrime-en",
  "displayName": "Unsolved Files",
  "niche": { "topic": "...", "keywords": ["..."] },
  "stylePrefix": "1970s film grain, desaturated colors, …, no human faces",
  "voiceId": "<ElevenLabs ses kimliği>",
  "languages": ["en","es","tr"],
  "platforms": ["YOUTUBE","INSTAGRAM","FACEBOOK","TIKTOK"],
  "targetDurationSeconds": 60,
  "sceneCount": 6,
  "youtubeTokenFile": "config/tokens/<kanal>.json",
  "enabled": true,
  "meta": { "publishLang": "en", "pageId": "…", "igUserId": "…", "accessToken": "<sır>" }
}
```

**Doğrulama** (`validate()`):
- `channelId`, `voiceId`, `niche.topic` ve `languages` zorunlu;
- **`targetDurationSeconds` 60–90 arasında** olmalı (TikTok ≥ 60 sn kuralı);
- **`sceneCount` 3–10 arasında** olmalı.

**Sır:** `meta.accessToken` kanal dosyasına yazılabiliyor. `channels/*.json` gitignore'da; yalnızca `.example` dosyası takipte.

**Test:** `ChannelStoreTest` (3), `ChannelUpdateTest`.

**Taşıma notu: U.** hiVelzon'da "kanal" yerine iki kavram var:
1. **Seviye profili:** `profiles/level-a1.json` … `level-c1.json`. İçeriği:
   - kelime, cümle ve süre sınırları;
   - TTS `speed`;
   - altyazı parametreleri (en fazla kelime/cue, karakter/sn);
   - `stylePrefix`;
   - `voiceId` (öğretmen ya da anlatıcı);
   - çıktı profilleri.
2. İçeriğe özgü değerler `content.json`'da tutulur (K-01).

Doğrulama aralıkları seviye tablosundan gelmeli. 60–90 sn ve 3–10 sahne sınırları **kaldırılmalı**.

Sırlar bu dosyalara **asla** konmaz; ortam değişkeninden ya da secret store'dan okunur.

### 3.12 `web/BackofficeServer` (+ `JobService`, `RangeSupport`)

**Dosyalar:** `web/BackofficeServer.java` (1.271 satır), `web/JobService.java`, `web/RangeSupport.java`, `src/main/resources/web/*`

**Ne yapar?**
- JDK `HttpServer` ile `127.0.0.1:8080` üzerinde çalışır.
- REST uç noktaları: kanal ve iş listesi, iş detayı, Range destekli mp4 akışı, sahne PNG'si, metadata PATCH, approve/reject, generate, stats.
- Ayrıca Velzon ve Pinterest panelleri var.
- `JobService`, onayı yalnızca `PENDING_REVIEW` durumundaki işler için kabul eder ve onaylanan platformları kaydeder.
- Uzun işler tek iş parçacıklı `Executor`'larla çalışır.

**Güvenlik:**
- HTTP Basic Auth **isteğe bağlı**. Ayarlanmazsa sunucu **korumasız** açılıyor; yalnızca uyarı logu basılıyor.
- Javadoc'a göre üretimde nginx, sunucuyu herkese açık bir alt alan adında yayınlıyor.
- CSRF koruması ve rol yönetimi yok.

**Test:** `BackofficeServerTest` (7), `BackofficeAuthTest` (8), `RangeSupportTest` (5) ve diğerleri.

**Taşıma notu: X (kod alınmaz).**
- hiVelzon'da bunun yerine `admin` modülü gelir: Spring MVC, Spring Security (rol ve oturum), denetim kaydı (WishSay deseni) ve ince bir onay ekranı (K-12).
- Alınacak fikirler:
  - durum kontrolü serviste yapılır (`PENDING_REVIEW` değilse onay reddedilir);
  - onay sırasında platform seçimi;
  - Range desteği. Spring'de `ResourceRegion` ile hazır gelir; video zaten Bunny'den akacak.
- UI tasarım kararları (koyu tema, kart ızgarası) ilham olarak kullanılabilir.

### 3.13 `publish/*`: `Publisher`, `PublishService`, `YouTubePublisher`, `MetaReelsPublisher`, `TikTokPublisher`

**Dosyalar:** `publish/` altında 11 dosya (1.145 satır), ayrıca `api/YouTubeApiClient.java` (510 satır).

**Ne yaparlar?**

`Publisher` arayüzü: `platform()` ve `publish(job, variant, profile, jobDir)`.

`PublishService.publishApproved`:
- Varyant × platform döngüsü kurar.
- `PUBLISHED` ya da `SKIPPED_NO_PUBLISHER` kaydı olan çifti atlar.
- Her yüklemeden hemen sonra `job.json`'u kaydeder.
- YouTube için `UploadCounter` ile günlük limit uygular.
- Kısmi hata olursa durum `PUBLISHING`'de kalır, eksikler sonra tekrar denenir.
- Kabul edilmiş açıklar:
  - yükleme ile kayıt arasındaki milisaniyelik pencerede çökme olursa video tekrar yüklenebilir;
  - süreçler arası kilit yok.

`YouTubePublisher`:
- Kanal başına `Uploader` önbelleği tutar; OAuth jetonu kanal başına ayrı.
- `YouTubeApiClient.buildVideoResource` şunları ayarlar:
  - `defaultLanguage` ve `defaultAudioLanguage`;
  - `selfDeclaredMadeForKids=false` (**sabit**);
  - `containsSyntheticMedia=true` (**her zaman**);
  - açıklamaya `#Shorts`.

`MetaReelsPublisher`:
- Instagram ve Facebook Reels için tek bir `MetaApiClient` kullanır.
- Caption 2.000 karakterde kesilir.
- `onlyLang` ile tek dil koruması var (çok dilli kopyalar duplicate sayılmasın diye).

`TikTokPublisher`:
- Direct Post kullanır: önce `creator_info` sorgusu, sonra `init`, tek parça `PUT` ve durum sorgulama döngüsü.
- `privacy_level` config'ten geliyor; denetlenmemiş uygulama için `SELF_ONLY`.

**AI etiketleri:** bkz. §4h.

**Test:** `PublishServiceTest` (6), `YouTubePublisherTest` (6), `MetaApiClientTest` (6), `MetaLangGuardTest`, `MetaBackfillTest`, `TikTokApiClientTest` (3), `UploadCounterTest`.

**Taşıma notu: şimdilik X, ileride U.**
- K-14 gereği önce elle yükleme yapılacak. Bu sınıflar şimdi taşınmaz.
- Platform denetiminden sonra `distribution` modülüne şunlar alınır:
  - `PublishService`'in idempotentlik deseni. hiVelzon'da veritabanında `(content_version_id, platform)` için tekil kısıt olmalı. Yüklemeden **önce** `PENDING` kaydı açılmalı ki çift yayın penceresi daralsın.
  - `Publisher` arayüzü.
- Eklenecekler:
  - AI etiketi parametreleri;
  - içerik başına `madeForKids`;
  - `APPROVED` kontrolünün backend'de yapılması (K-05).

---

## 4. hiVelzon özel soruları

### 4a. StoryWriter prompt'una CEFR kısıtları

**Yaklaşım:**
- Kısıtlar seviye profilinden okunur ve prompt'a **sayısal ve listeli** olarak verilir.
- LLM'in seviye hükmüne güvenilmez. Çıktı `content-lint`'ten geçmeden medya üretimi başlamaz.
- Lint hatası olursa `StoryWriter`'daki geri bildirimli yeniden deneme kullanılır, en fazla 3 deneme. Her denemede lint raporunun ilk 10 maddesi prompt'a eklenir.

**Değerler** (CLAUDE.md seviye tablosu; kelime havuzu ICERIK-MIMARISI §3.2 önerisiyle):

| Alan | A1 | A2 | B1 | B2 | C1 |
|---|---|---|---|---|---|
| Kelime (toplam) | 80–150 | 150–300 | 300–600 | 500–900 | 800–1.500 |
| Cümle | ≤ 8 kelime, yan cümle yok | ≤ 12, and/but/because | bağlaçlı birleşik | karmaşık serbest | doğal, üslup çeşitli |
| Dilbilgisi | present simple, to be, there is/are, can | past simple, going to, karşılaştırma | present perfect, 1. tip koşul, used to | edilgen, dolaylı anlatım, 2./3. tip koşul | inversion, cleft, modal nüansı, deyim |
| Kelime havuzu | CEFR-J A1 (~550) | ≤ A2 (~1.000) | ≤ B1 | ≤ B2 | geniş |
| Kapsama | ≥ %98 hedef, ≥ %95 alt sınır (K-07) | aynı | aynı | aynı | aynı |
| TTS hızı | ~100–110 kelime/dk | ~115–125 | ~130–140 | ~145–155 | ~160+ |
| Video | 30–60 sn | 60–90 sn | 1,5–3 dk | 3–5 dk | 4–8 dk |

**Kelime bütçesi:** videoGenerator `süre × 2,2 kelime/sn` kullanıyor (≈132 kelime/dk). hiVelzon'da bütçe seviyenin **kelime/dk** değerinden hesaplanır. Örnek: A1, 45 sn × 105/60 ≈ 79 kelime.

Ayrıca CLAUDE.md'deki **kelime aralığı** ile **video süresi** aralığı birbiriyle tutarlı olmalı:
- A1'de 150 kelime ≈ 86 sn, ama video üst sınırı 60 sn.
- Bu çelişki bir açık soru olarak not edildi (§7).

**Prompt taslağı** (A1 örneği; `{}` alanları seviye profilinden ve brief'ten doldurulur):

```text
SYSTEM:
You write graded English stories for Turkish learners of English, level {level}.
You are a careful materials writer, not a creative showcase. Respond with ONLY
valid JSON, no markdown fences. Never mention real brands, celebrities, real
living people, politics, religion, violence or romance. Audience: 13+.

USER:
Brief
- Level: {level}  (CEFR)
- Series / episode: {seriesId} / {episode}   Setting: {setting}
- Can-do goal: {canDo}            e.g. "I can say what I have and what I like."
- Target words (MUST each appear at least 2 times, in natural use): {targetWords}
- Target grammar (MUST appear at least 3 times): {grammarTargets}
- Recurring "words of the week" (use at least 1 time each): {weeklyWords}
- Planned typical Turkish-learner error to address (do NOT put the error in the
  narration; it goes to "teacherNotes" only): {plannedError}

Hard language limits for {level} (a deterministic checker will reject violations):
- Total narration: {minWords}-{maxWords} words  (budget for this video: ~{budgetWords} words).
- Every sentence: at most {maxSentenceWords} words. {clauseRule}
  (A1: no subordinate clauses; no relative clauses; no "which/that/who/when/if/because".)
- Allowed grammar ONLY: {allowedGrammar}
  Forbidden grammar: {forbiddenGrammar}
  (A1 forbidden: past tenses, future, perfect, passive, modals other than "can",
   conditionals, gerund subjects, phrasal verbs outside the word list.)
- Vocabulary: use ONLY words from the {level} list (CEFR-J cumulative) plus the target
  words. Proper names are allowed. If you need a word above {level}, use at most
  {maxAboveLevel} such words in the whole story and list each in "aboveLevelWords".
- Prefer high-frequency words; repeat key words instead of using synonyms.
- Write numbers as digits only if they are simple (1-20); no abbreviations, no slang,
  no idioms (A1-B1).

Structure
- Split into EXACTLY {sceneCount} scenes. Each scene: 1-{maxSentencesPerScene} sentences.
- Scene 1 opens with a clear, simple question or situation (the "hook").
- The story must be understandable on its own and end with a small resolution.
- For each scene give TWO image descriptions ("imagePrompts") that show exactly what is
  narrated: places, objects, animals or simple cartoon characters as defined in the
  character sheet below. Never put written text, letters, signs or logos in the image.
  Character sheet (keep identical in every prompt): {characterSheet}

Also return
- "title" (max 6 words, level-appropriate)
- "hookText" (max 5 words, on-screen)
- "aboveLevelWords": [{ "word": "...", "sentence": "..." }]
- "targetWordUses": { "<word>": <count> }   (your own count; will be re-checked)
- "comprehensionQuestions": 3-5 items {question, options[3], answerIndex}
- "teacherNotes": short notes in Turkish for the glossary about {plannedError}

JSON shape:
{"title":"...","hookText":"...",
 "scenes":[{"narration":"...","imagePrompts":["...","..."]}],
 "aboveLevelWords":[...],"targetWordUses":{...},
 "comprehensionQuestions":[...],"teacherNotes":"..."}
```

**Seviye başına değişen bloklar** (`{clauseRule}`, `{allowedGrammar}`, `{forbiddenGrammar}`):

| Seviye | Değişen kurallar |
|---|---|
| **A2** | "and/but/because allowed; no relative clauses except 'who/that' as subject"; izinli: past simple, going to, comparatives; yasak: perfect, passive, conditionals |
| **B1** | Ek izinli: present perfect, first conditional, used to. Yasak: passive in more than 2 sentences, third conditional |
| **B2** | Karmaşık cümle serbest. Yasak listesi yerine **hedef dilbilgisi en az 3 kez** kuralı ağırlık kazanır |
| **C1** | Kelime kısıtı yerine "idioms/collocations allowed; each idiom listed in aboveLevelWords" |

**Neden bu biçim?**
- LLM'den kendi sayımlarını (`targetWordUses`) istemek, lint ile karşılaştırınca tutarsızlığı görmeyi sağlar.
- "Ölçülecek" uyarısı uyumu artırır.
- Gerçek doğrulama yine deterministiktir.
- Görselde yazı yasağı Higgsfield kural 7'yi uygular.

### 4b. `content-lint` için videoGenerator'da temel var mı?

**Kısa cevap:** Seviye ya da kelime denetimi **yok**. Yalnızca **yapısal** doğrulama ve onun üstüne kurulmuş geri bildirimli yeniden deneme deseni var.

Var olan deterministik denetimler:

| Sınıf | Denetim |
|---|---|
| `StoryWriter.attemptStory` | JSON geçerli mi, sahne sayısı tam mı, `hookText` dolu mu, her sahnede prompt var mı. Hata olursa nedeni prompt'a eklenip tekrar denenir. |
| `TranslationService` | Anlatım satırı sayısı kaynakla aynı mı, meta veri geçerli mi (`VideoMetadata.isValid`) |
| `ElevenLabsClient.parseAlignment` | Dizi uzunlukları tutarlı mı |
| `ChannelProfile.validate` | Şema ve değer aralıkları |
| `velzon/*Generator` | Uzunluk sınırları ve zorunlu sembolün metinde geçmesi. Örnek: `VelzonAiBriefingPostGenerator` satır ~261. |
| `StoryLengthTest` | Yalnızca prompt'ta kelime bütçesinin **yazdığını** sınıyor. Çıktının uzunluğu ölçülmüyor. |

Uzunluk sorunu için TODO'daki kayıt şöyle: "ilk gerçek koşuda senaryolar hedefi %25–55 aştı". Bu, LLM'e verilen sayısal sınırların tutmadığının **kanıtı**. `content-lint`'in neden şart olduğunu destekliyor.

**`content-lint`'e taşınacak parçalar:**
- `SubtitleRenderer.extractWords`: kelime sınırlarını çıkarma;
- `SceneTimer`: sahne ve alignment eşleşmesi;
- geri bildirimli yeniden deneme döngüsü;
- `LlmJson.strip`.

**Sıfırdan yazılacaklar:**
- tokenizer ve lemmatizer;
- CEFR-J kümülatif kapsama;
- cümle uzunluğu;
- dilbilgisi desenleri (regex ya da POS);
- sözlük ↔ metin tutarlılığı;
- quiz ↔ metin tutarlılığı;
- yasaklı konu ve marka listesi;
- altyazı senkron kuralları (§9.6).

Lisans durumu ve aracın dili (Java ya da Python, cefrpy) H-027'ye bağlı.

### 4c. ElevenLabs hizalama biçimi, WebVTT ve kelime zamanlama JSON'u (K-03)

**Biçim:** Fixture dosyasıyla birebir, karakter düzeyinde.

```json
{"audio_base64":"<base64 mp3>",
 "alignment":{
   "characters":["H","i","."," ","B","y","e","."],
   "character_start_times_seconds":[0.0,0.08,0.16,0.24,0.30,0.42,0.55,0.68],
   "character_end_times_seconds":[0.08,0.16,0.24,0.30,0.42,0.55,0.68,0.80]}}
```

- Üç dizi aynı uzunluktadır.
- Boşluk ve noktalama da birer karakterdir.
- `alignment`, gönderilen metne karşılık gelir.
- API ayrıca `normalized_alignment` döndürebilir: sayıların okunuşa çevrildiği metin. videoGenerator bunu kullanmıyor; hiVelzon'da ham `alignment` kullanılmalı.
- videoGenerator ham alignment JSON'unu `audio/<lang>.alignment.json` olarak saklıyor. hiVelzon'da da bu dosya **kanonik kaynak** olarak saklanmalı; diğer çıktılar ondan türetilir.

**Türetme hattı** (`content-tools`, deterministik):

1. **Kelimeler.** `extractWords` mantığı uygulanır: boşluk olmayan karakter dizileri bir kelimedir.
   - Her kelime için şunlar tutulur: `text`, `start` (ilk karakterin başlangıcı), `end` (son karakterin bitişi), `charStart`, `charEnd`, `sceneIndex` (SceneTimer sınırlarından).
   - Noktalama, `textNorm` alanında ayrıştırılır: `"cat."` → `display:"cat."`, `norm:"cat"`.
   - `norm`, lemma eşlemesi ve sözlük bağlantısı için kullanılır. Kelime kayıtları lemma'ya bağlanır (§9.4).
2. **Kelime zamanlama JSON'u** (`subs/en.words.json`, uygulamadaki karaoke widget'ı için):

   ```json
   {
     "schemaVersion": 1,
     "contentId": "A1-001-lost-cat",
     "contentVersion": 3,
     "audioSha256": "…",
     "source": "elevenlabs-alignment",
     "verified": true,
     "durationMs": 41230,
     "words": [
       {"i":0,"t":"Tom","n":"tom","s":120,"e":410,"scene":1},
       {"i":1,"t":"has","n":"have","s":430,"e":610,"scene":1,
        "gloss":{"tr":"sahip olmak","target":true}}
     ],
     "cues": [ {"s":120,"e":2380,"w":[0,4]} ]
   }
   ```

   - Zamanlar milisaniye cinsinden tamsayıdır; kayan nokta farklılığı oluşmaz.
   - `verified=false` olan içerikte uygulama yalnızca satır vurgusu yapar (§4.6).
   - Doğrulama: isteğe bağlı Whisper hizalaması, tolerans ±200 ms.
3. **Cue bölme** (`CueSegmenter`, `buildCues` mantığının geliştirilmiş hâli):
   - Önce **cümle sınırı** (`.?!`) uygulanır, sonra uzunluk sınırı.
   - Satır başına ≤ 42 karakter, en fazla 2 satır.
   - En kısa cue 1,0 sn. Kısa kalanlar sonraki cue ile birleştirilir ya da `end` uzatılır; ama bir sonraki cue'nun `start` değerini geçemez.
   - Okuma hızı: A1 ≤ 15 karakter/sn. Aşılırsa cue bölünür.
   - Cue'lar çakışmaz ve son cue ses süresini geçmez.
4. **WebVTT** (`subs/en.vtt`):

   ```
   WEBVTT

   1
   00:00:00.120 --> 00:00:02.380
   Tom has a small cat.
   ```

   - Zaman biçimi `HH:MM:SS.mmm`.
   - `<c.target>has</c>` sınıfı kullanılabilir, ama ana vurgu widget'ta yapılır.
   - TR satırı ayrı dosyadadır (`subs/tr.vtt`), A2 ve üstünde varsayılan kapalıdır. `story.tr.md`'deki sahne çevirisinden sahne zamanına göre üretilir; kelime düzeyinde değil, cümle ya da sahne düzeyinde.
5. **Sosyal medya `.ass` dosyası:** `toKaraokeAss`'ın uyarlanmış hâli. Hedef kelimenin üstünde küçük TR karşılık için ikinci bir stil kullanılır (`\pos` ya da ayrı bir katman).
6. **Lint (§9.6):**
   - Cue metinleri birleştirildiğinde, boşluklar normalize edilerek `story.en.md` metniyle aynı olmalı.
   - Alignment karakter sayısı TTS'e gönderilen metnin uzunluğuna eşit olmalı.

### 4d. Ses yüksekliği normalizasyonu hangi LUFS değerine yapılıyor?

- **Hedef belirtilmemiş.** `FFmpegWrapper.buildMixFilter`, filtre zincirinin sonuna parametresiz `loudnorm` ekliyor. `normalizeAudio` da `-filter:a loudnorm` kullanıyor.
- Bu ffmpeg varsayılanı demek: **I = -24 LUFS, TP = -2 dBTP, LRA = 7**, tek geçiş (dinamik mod).
- Uygulanma koşulu: yalnızca `DefaultRenderEngine` müzik miksajı yaptığında ve `audio.normalize=true` (varsayılan) iken. **Yalnız sesli modda hiç normalizasyon yok.**
- Ses miksten sonra MP3'e, render'da AAC 192k'ya kodlanıyor; çift kayıplı kodlama.
- Sonuç: Bugünkü çıktılar hiVelzon hedeflerinin (**uygulama -16 LUFS / -1 dBTP, sosyal medya -14 LUFS**) yaklaşık 8–10 LU altında kalır ya da hiç normalize edilmemiştir. Bu tahmin koddan çıkarıldı; çıktı dosyaları ölçülmedi.

**Öneri:**

```
1. geçiş: ffmpeg -i mix.wav -af loudnorm=I=-16:TP=-1:LRA=11:print_format=json -f null -
2. geçiş: loudnorm=I=-16:TP=-1:LRA=11:measured_I=..:measured_TP=..:measured_LRA=..:
          measured_thresh=..:offset=..:linear=true  → -ar 48000 → AAC
Kapı:    ffmpeg -i out.mp4 -af ebur128=peak=true -f null -  →  |I-hedef| ≤ 1 LU ve TP ≤ -1
```

Sosyal medya için ayrı bir çıktı profili kullanılır: `I=-14`.

### 4e. Video çıktı formatı, 16:9 ve HLS

| Konu | Durum |
|---|---|
| Çözünürlük | **1080×1920 (9:16), sabit kodlanmış:** `KenBurnsRenderer` filtre grafında ve `SubtitleRenderer` `PlayResX/Y` değerinde. `video.width/height` config'i Ken Burns'te kullanılmıyor. |
| Kapsayıcı ve kodek | MP4; H.264 `libx264` (CRF verilmiyor, varsayılan 23; preset varsayılan), `yuv420p`, 30 fps; AAC 192 kbps; `+faststart` (Meta yükleme hatası sonrası eklendi) |
| 16:9 | **Yok.** Filtre grafının parametreli hâle getirilmesi gerekir. Görseller dikey üretildiği için 16:9'a kırpmada ciddi kayıp olur; görsel en-boy oranı çıktı profiline göre seçilmeli. |
| HLS | **Yok.** K-13 gereği Bunny Stream kaynak MP4'ü HLS'ye kendisi kodlar. Yerelde HLS üretmek yalnızca R2 yoluna geçilirse gerekir. |
| Süre | Pipeline 60–90 sn varsayımıyla çalışıyor (profil doğrulaması). 5 dk ffmpeg zaman aşımı C1 için risk. |

### 4f. BudgetGuard/CostTracker, Higgsfield kredisi ve hiVelzon kuralı

**Higgsfield'i izliyor mu?** **Hayır.** videoGenerator Higgsfield kullanmıyor. Maliyetler USD cinsinden ve sabit:
- görsel 0,08;
- TTS 0,10 / 1k karakter;
- müzik 0,50;
- LLM çağrısı 0,01.

Kredi, `generate cost` çıktısı ya da gerçek fatura okunmuyor.

**hiVelzon kuralına uyum:**

| Kural | videoGenerator | Uyum |
|---|---|---|
| Tavan konfigürasyondan okunur | `budget.monthly.usd` | ✔ |
| **Tavan yoksa ücretli üretim kapalı** | Varsayılan **100 USD**; tavan yoksa üretim **açık** | ✘ |
| Her ücretli çağrıdan **önce** kontrol | İş başında **bir kez**, toplam tahminle. Çağrı başına değil. | Kısmen |
| **Her üretimden önce maliyet onayı** | Yok; zamanlayıcı ve backoffice doğrudan üretiyor (onay yalnızca **yayın** için) | ✘ |
| Gerçek harcama kaydı | Tahmini değerler, **yalnızca başarılı işte** deftere yazılıyor | ✘ (yarıda kalan işlerin harcaması kayboluyor) |
| Atomik sayaç | `FileLock` ile güncelleme var, ama kontrol ile harcama ayrı adımlar (belgelenmiş sınırlama) | Kısmen |
| Bozuk veride güvenli taraf | Kapalı yönde hata | ✔ |
| Çift ücret yok | Görsel ✔, müzik ✔; TTS ve çeviri ✘ (bkz. 4g) | Kısmen |

**hiVelzon için yeni tasarım:**
1. `CostGuard` tavanı `Optional` olarak okur. Değer **boşsa ya da ≤ 0 ise `PAID_GENERATION_DISABLED`** hatası verir.
2. Her ücretli çağrı için şu sıra izlenir:
   1. `estimate` (Higgsfield'te `generate cost`, ElevenLabs'te karakter × fiyat);
   2. `reserve`: atomik; tavan aşılacaksa reddedilir;
   3. `content-tools`'ta **kullanıcı onay istemi**. Toplu işte toplam tek seferde gösterilir.
   4. çağrı;
   5. `settle`: gerçek kredi ya da karakter; hata olursa rezervasyon iade edilir. Ancak sağlayıcı ücret aldıysa harcama kaydedilir.
3. Defter iki birimle tutulur: `credits` (Higgsfield) ve `usd`. Kur çevirisi yapılmaz; tavan her birim için ayrı tanımlanır.
4. Kredi azaldığında kullanıcıya **bir kez** uyarı verilir (H-004 kararı). Bayrak defterde tutulur.
5. Her satır `PROMPTS.md`'ye de yazılır: job id, tahmin, gerçek değer, onay referansı.

### 4g. Bir sahnede iş yarıda kalırsa ne olur, nasıl devam eder?

Mekanizma:
- `job.json` her adımdan sonra atomik olarak kaydediliyor.
- `JobPipeline.resume(jobId)` işi yükleyip `execute` metodunu baştan çalıştırıyor.
- Tamamlanmış adımlar çıktılarına bakılarak atlanıyor.

| Adım | Devamda davranış | Ücret riski |
|---|---|---|
| Fikir ve hikâye | `job.story` doluysa atlanır | Yok |
| Sahne görselleri | **Dosya bazında**: `scenes/NNx.png` varsa atlanır. 6 görselin 5'i varsa yalnızca 6. üretilir. | Yok. Ama yarım yazılmış PNG de "var" sayılır (atomik yazma yok). |
| Müzik | `audio/music.mp3` varsa atlanır | Yok |
| Dil varyantı | Tamamlanma işareti **`variants[]` kaydı**; mp4 değil. Kayıt yoksa **çeviri + TTS + altyazı + render baştan** yapılır. | **Var:** TTS yeniden ücretlenir. Çeviri `job.json`'a yazılmıyor, ve LLM deterministik olmadığı için eski ses dosyası yeni metinle de eşleşmez. |
| Maliyet defteri | `costRecorded` bayrağı çift yazımı engelliyor | Yarıda kalan işin harcaması **hiç** yazılmıyor |
| Durum | Hata → `FAILED` + `error`; devam ederken `error` temizleniyor | — |

**hiVelzon önerisi:**
- Ara çıktılar da kalıcı olmalı: çeviri metni ve TTS sonucu kendi işaretini almalı.
- TTS dosyası **içerik hash'iyle** adlandırılmalı: `audio/en.<sha256(text+voice+settings)[:12]>.mp3`. Hash'li dosya varsa çağrı yapılmaz.
- Tüm yazmalar `.tmp` dosyasına yapılıp `ATOMIC_MOVE` ile taşınmalı.
- Render çıktı profili başına işaretlenmeli.
- Higgsfield işlerinde yerel dosya henüz yoksa ama job id kaydedilmişse, **yeni iş açılmaz**; `higgsfield generate wait <job_id>` ile var olan iş beklenip indirilir. Bu, çift kredi harcamasını önler.

### 4h. Yayıncılar AI etiketini destekliyor mu?

| Platform | Alan | videoGenerator | Not |
|---|---|---|---|
| YouTube | `status.containsSyntheticMedia` | **Var, her zaman `true`** (`YouTubeApiClient.buildVideoResource`, generic `status.set`) | hiVelzon'da da her zaman `true` (K-14) |
| YouTube | `status.selfDeclaredMadeForKids` | **Sabit `false`** | hiVelzon'da **içerik başına** karar gerekir (§10.1: çizgi hayvanlı A1 hikâyeleri "çocuklara yönelik" sayılabilir). `content.json`'a `madeForKids` alanı eklenmeli; hukuki karar bekliyor. |
| YouTube | `defaultLanguage`, `defaultAudioLanguage` | Var | `en` |
| TikTok | `post_info.is_aigc` (AIGC etiketi) | **Yok.** `post_info`'da yalnızca `title` ve `privacy_level` var. | Eklenmeli. Ayrıca `disable_comment` ve `brand_content_toggle` gibi alanlar değerlendirilmeli. Alan adları güncel dokümandan doğrulanmalı. |
| Instagram | `is_ai_generated` | **Yok** (`media_type=REELS`, `caption`, `video_url` / yükleme) | ICERIK-MIMARISI §10.1'de "tek kaynak" olarak işaretli; doğrulanmadan kullanılmamalı. Caption'a görünür "AI ile üretilmiştir" ibaresi her durumda konmalı. |
| Facebook | — | Yok | Görünür ibare |
| Hepsi | Görünür ibare ve C2PA | `TranslationService` açıklamaya **true-crime dipnotu** ekliyor (AI ibaresi değil). C2PA yok. | Videoya kalıcı ibare (§4.5) ve `c2patool` imzası (§9.6) yeni iş |

---

## 5. Taşıma planı

### 5.1 Hedef yerleşim

İçerik üretimi Claude Code ve git ile yapılıyor (K-12: içerik kod olarak yönetilir). Medya üretimi Higgsfield CLI ve ffmpeg gerektiriyor; bunlar Spring backend'in çalışma ortamına konmamalı. Bu yüzden iki ayrı hedef öneriliyor:

```
hivelzon/
├── backend/                     Spring Boot 4 modüler monolit (Java 21+)
│   └── …/generation, admin, content, speaking, (distribution — sonra)
├── tools/content-pipeline/      Spring Boot "web-application-type=none" CLI
│   │                            (picocli ya da CommandLineRunner); yerelde/CI'da çalışır
│   ├── story/  media/  subs/  render/  lint/  ledger/
│   └── profiles/level-a1.json … level-c1.json
└── icerik/<id>/                 metin + content.json + manifest (medya git'te değil)
```

Ortak DTO'lar (`content.json` şeması, kelime zamanlama şeması) ayrı küçük bir `content-model` modülünde tutulabilir. Bu, **aynı repo içinde** bir modül olur; videoGenerator'a bağımlılık değildir.

### 5.2 Sıralı plan

Her adım ayrı bir H-işi olarak açılmalı: kabul kriteri ve test komutuyla, kod onayından sonra.

| # | videoGenerator kaynağı | Not | hiVelzon hedefi | Yapılacak |
|---|---|---|---|---|
| 1 | `model/Alignment`, `ElevenLabsClient.parseAlignment`, `fixtures/alignment-sample.json` | A | `content-model` / `tools…/subs` | Testleriyle kopyala |
| 2 | `processor/SceneTimer` | A | `tools…/subs` | Testleriyle kopyala; karakter sayısı uyuşmazlığı uyarısı ekle |
| 3 | `SubtitleRenderer` (`extractWords`, `assTime`, `escapeAssText`, karaoke) | U | `tools…/subs`: `AlignmentWords`, `CueSegmenter`, `AssWriter`, **yeni** `WebVttWriter`, `WordTimingJsonWriter` | §4c kuralları, seviye parametreleri |
| 4 | `FFmpegWrapper.executeCommand`, `buildMixFilter` | U | `tools…/render/FfmpegRunner`, `AudioMixer` | Ayrı iş parçacığında akış okuma, gerçek zaman aşımı, WAV ara dosya |
| 5 | (yeni; `AudioProcessor` yerine) | — | `tools…/render/LoudnessNormalizer`, `LoudnessGate` | İki geçiş, -16/-1 ve -14, `ebur128` kapısı |
| 6 | `KenBurnsRenderer` | U | `tools…/render/KenBurnsRenderer` | `OutputProfile` (9:16 ve 16:9), CRF, isteğe bağlı altyazı gömme, yol kaçışı, `.tmp` |
| 7 | `job/BudgetGuard`, `CostTracker` | U | `tools…/ledger/CreditLedger` + backend `generation/CostGuard` (PostgreSQL) | Tavan yoksa kapalı; reserve/settle; onay istemi; kredi birimi |
| 8 | `api/ElevenLabsClient` | U | `tools…/media/tts/ElevenLabsTtsAdapter` (`TtsPort`) | `RestClient`, `speed`, hash'li idempotentlik, atomik yazma |
| 9 | `SceneImageService`, `ImageGenerator` | U | `tools…/media/image/SceneImageService` + `HiggsfieldCliAdapter` | cost → onay → create/wait; job id ile devam; `PROMPTS.md` |
| 10 | `StoryWriter`, `LlmClient`, `LlmJson` | U | `tools…/story/StoryDraftService` + `LlmPort` | §4a prompt'u, sürümlü şablon, lint geri bildirimli döngü |
| 11 | (yeni) | — | `tools…/lint` (`content-lint`) | §4b listesi; H-027 lisans sonucuna göre veri |
| 12 | `TranslationService` | U | `tools…/story/TranslationDraftService` | Yalnızca TR taslak, sözlük ve TR altyazı; dipnot ve başlık kalıpları yok |
| 13 | `JobPipeline`, `Job`, `JobStore` | U | `tools…/pipeline/ContentPipeline` + `.work/<id>/job.json` | Adım başına işaret, çıktı profili döngüsü; lint'ten **sonra** medya |
| 14 | `ChannelProfile`, `ChannelStore` | U | `tools…/profiles/LevelProfile` | Seviye aralıkları; sır yok |
| 15 | `JobService` onay kuralları (fikir olarak) | U | backend `admin` + `content` (K-05 durum makinesi) | Spring Security, denetim kaydı, sürüme bağlı onay |
| 16 | `BackofficeServer`, `RangeSupport`, web UI | X | — | Spring MVC ile yeniden yazılır |
| 17 | `publish/*` | Sonra U | backend `distribution` (platform denetiminden sonra, K-14) | AI bayrakları, içerik başına `madeForKids`, `PENDING` kaydı ve tekil kısıt |
| — | `velzon/*`, `pinterest/*`, `IdeaGenerator`, `NicheFinder`, `TrendAnalyzer`, `MusicApiClient`, `LocalMusicLibrary`, SQLite repo'ları | X | — | hiVelzon'la ilgisiz. Müzik gerekirse ayrıca karar verilir. |

---

## 6. Riskler

### 6.1 Kopyalanmaması gerekenler

- **Sırlar.** Şu dosyalar sır içeriyor ya da içerebilir. Hiçbiri kopyalanmamalı, okunup içeriği rapora da alınmadı.
  - Git'te takip edilen `TODO.md`, ~277. satır: bir API anahtarının parçası açık metin. **videoGenerator sahibinin bu anahtarı döndürmesi ve satırı temizlemesi önerilir.** Bu oturumda o repoda değişiklik yapılmadı.
  - Gitignore'da olanlar: `config/application.properties`, `config/google_credentials.json`, `config/tokens/**` (OAuth jetonları), `channels/*.json` (`meta.accessToken` alanı olabilir), `data/videogenerator.db`, `logs/*.log` (içeriği kontrol edilmedi).
- **ElevenLabs hesabı ve ses kimlikleri.** videoGenerator'ın kullandığı hesap ücretsiz plan (TODO §2). hiVelzon kendi ticari lisanslı hesabını kullanmalı (H-027).
- **True-crime'a özgü içerik:** prompt kuralları, başlık kalıpları, dipnotlar, son kart metinleri, `PACING_VARIANTS`.
- **`Configuration.getInstance()` singleton'ı ve elle bağlanmış `Main`.** Spring'de DI ve `@ConfigurationProperties` ile değiştirilir.
- **İsteğe bağlı kimlik doğrulamalı backoffice.** "Ayar yoksa korumasız aç" deseni hiVelzon'da yasak.
- **Sabit `madeForKids=false`** ve **varsayılan 100 USD tavan**.

### 6.2 Bilinen hata ve zayıflıklar (koddan çıkarıldı)

1. Yalnız sesli modda ses normalizasyonu yok. Normalizasyonun hedefi de ffmpeg varsayılanı (-24 LUFS).
2. Yarıda kalan işlerin harcaması aylık deftere yazılmıyor; bütçe eksik sayılıyor.
3. Dil varyantı yarıda kalırsa TTS ve çeviri yeniden ücretleniyor.
4. Görsel, TTS sesi, alignment, `.ass` ve render dosyaları atomik yazılmıyor. Bozuk görsel kalıcı olarak atlanabiliyor.
5. `FFmpegWrapper` zaman aşımı, çıktı akışı kapanmadan devreye girmiyor. `executeCommandWithOutput`'ta hiç zaman aşımı yok. 5 dk, uzun videolar için kısa.
6. `KenBurnsRenderer` `.ass` yolunu filtre grafına kaçışsız ekliyor.
7. `ElevenLabsClient` 4xx yanıtlarını da yeniden deniyor (gereksiz çağrı). `Accept: audio/mpeg` başlığı JSON uç noktasıyla tutarsız.
8. `ChannelProfile` 60–90 sn ve 3–10 sahne sınırları hiVelzon seviyeleriyle uyumsuz.
9. `PublishService.hasPublication`, `SKIPPED_LANG` durumunu atlama işareti saymıyor. Her devamda yeni bir atlama kaydı ekleniyor (zararsız ama kirli).
10. `SubtitleRenderer` cümle sınırı, en kısa süre ve okuma hızı kurallarını uygulamıyor.

### 6.3 Eksik testler

- `ElevenLabsClient`'ın HTTP katmanı.
- `FFmpegWrapper.executeCommand`: zaman aşımı ve hata yolu.
- `AudioProcessor`.
- Ses yüksekliği ölçümü.
- Gerçek ffmpeg render testi yalnızca 1 tane ve varsayılan koşuda kapalı.
- `CostTracker`'ın kilit davranışı (eşzamanlı yazma).
- `TikTokPublisher` ve `MetaReelsPublisher`'ın dil koruması dışındaki yolları.
- Not: Testler bu incelemede **çalıştırılmadı**. 365 test, 0 hata bilgisi 2026-08-24 tarihli `target/surefire-reports` dosyalarından alındı.

### 6.4 İki repo arasında bağımlılık riski

- **Çalışma zamanı bağımlılığı:** hiVelzon'un videoGenerator jar'ını, `channels/` klasörünü ya da `output/` klasörünü kullanması yasak. `mvn package` çalışan JVM'i bozar. Önlem: yalnızca kod kopyalama ve kaynak notu.
- **Hesap paylaşımı:**
  - Aynı ElevenLabs, OpenAI ya da Meta hesabının kullanılması kota, maliyet ve fatura karışıklığına yol açar.
  - Aynı Meta/TikTok uygulamasının kullanılması platform denetimi riskini paylaştırır.
  - Önlem: hiVelzon'a ayrı hesaplar, ayrı anahtarlar, ayrı bütçe defteri.
- **Kopyalanan kodun ayrışması:** videoGenerator'da sonradan düzeltilen bir hata hiVelzon'a otomatik geçmez. Önlem: kaynak notuna commit hash'i yazılır. Ara sıra `git log -- <dosya>` ile karşılaştırma yapılır, ya da bilinçli olarak tamamen ayrışmaya izin verilir.
- **Lisans:** videoGenerator'da LICENSE dosyası yok (README "MIT" diyor). İki repo da aynı sahibe ait olduğu için risk düşük. Yine de kaynak notu tutulmalı.
- **Kavram karışıklığı:** hiVelzon CLAUDE.md tablosu bazı sınıfları gerçekte olmadıkları gibi anlatıyor. Örneğin `SceneImageService` Higgsfield kullanmıyor, maliyeti USD; `AudioProcessor` "normalizasyon (§5.5)" diye geçiyor ama hedef LUFS yok. Bu rapor onaylanınca CLAUDE.md tablosu düzeltilmeli. Bu oturumda düzeltilmedi; yazma kapsamı yalnızca bu raporla sınırlıydı.

---

## 7. Açık sorular

1. **TTS sağlayıcısı:** Anlatım ElevenLabs ile mi, Higgsfield ses modelleriyle (Seed Audio vb.) mi yapılacak?
   - K-03, kelime zamanlaması için hizalama verisine bağlı. Higgsfield TTS'in karakter ya da kelime zaman damgası verip vermediği **doğrulanmadı**.
   - Vermiyorsa iki seçenek var: ElevenLabs'te kalmak ya da Whisper ile zorunlu hizalama (forced alignment) yapmak.
2. **ElevenLabs lisansı:** hiVelzon için ayrı ve ticari kullanıma uygun bir plan alınacak mı? `eleven_v3` modelinin `with-timestamps` ve `speed` desteği teyit edilmeli (H-027).
3. **Seviye tablosundaki çelişki:** A1'de 80–150 kelime, ~105 kelime/dk hızla 46–86 sn eder; ama video sınırı 30–60 sn. Kelime aralığı mı daraltılacak, süre mi uzatılacak? Benzer kontrol A2 için de yapılmalı.
4. **`content-tools` nerede çalışacak?** Yalnızca yerelde (Claude Code oturumu) mı, yoksa CI ya da sunucuda da mı?
   - Higgsfield CLI etkileşimli giriş istiyor ve Node 18'e bağlı; sunucuda çalıştırmak zor.
   - Öneri: yerelde çalışsın, backend yalnızca içe aktarsın.
5. **Uygulama videosu 16:9 mu, 9:16 mı?** CLAUDE.md "16:9 ya da 9:16" diyor. Karar, görsel en-boy oranını ve kredi harcamasını doğrudan etkiliyor; her iki oran da gerekirse sahne başına iki görsel gerekebilir.
6. **Arka plan müziği:** hiVelzon hikâyelerinde müzik olacak mı? Olacaksa kaynak ve lisans ne olacak? (videoGenerator ElevenLabs Music ya da yerel telifsiz klasör kullanıyor.)
7. **`madeForKids` kararı:** Hangi içerikler "çocuklara yönelik" işaretlenecek? Hukuki görüş gerekiyor (§10.1).
8. **TikTok `is_aigc` ve Instagram `is_ai_generated`:** Alan adları ve davranışları güncel resmî dokümandan doğrulanmalı (API otomasyonu K-14 gereği sonraya kaldı).
9. **Bütçe birimi:** Higgsfield için aylık tavan **kredi** olarak mı, USD olarak mı tanımlanacak? Öneri: sağlayıcı başına kendi biriminde ayrı tavan.
10. **Çeviri ve sözlük üretiminde hangi LLM?** Backend'deki konuşma özelliğiyle aynı sağlayıcı mı (maliyet ve anahtar ayrımı)?
