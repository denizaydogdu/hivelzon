# Bölüm paketi (H-034)

**Sürüm:** `schemaVersion: 2` · **Tarih:** 2026-10-12 (H-050, H-054) · **Araçlar:** `tools/content-pipeline/`

> **H-054 (2026-10-12, schemaVersion 2 içinde, geriye uyumlu):** Her video düğümünde `renditions` (`720p`, `1080p`) alanı var; `video` alanı 1080p kalır, eski uygulamalar onu oynatır. Uygulama varsayılan olarak 720p oynatır. Durağan görseller, başlık afişi ve harita WebP'dir (kalite 80).

> **schemaVersion 2 (H-050, kullanıcı kararı 2026-10-12):** Her bölüm doğrudan **başlık ekranıyla** açılır (`title` düğümü, zorunlu başlangıç). Başlıktan önce video, yazı ya da kart yoktur. B2 ve sonrasında başlıktan sonra atlanabilir **"Önceki bölümde"** özeti (`recap`) gelir, sonra hikâye. Açılıştaki başlık kartı ve görev kartı kalktı: görev cümlesi ve hedef ifadeler oynatıcının üst çubuğundaki 🎯 panelinde ve bölüm sonunda gösterilir. Uygulama sürüm 1 paketlerini de okur.

Bölüm paketi, etkileşimli oynatıcının (H-031) bir bölümü oynatmak için ihtiyaç duyduğu her şeydir: düğüm grafiği (`scenes.json`), segment videoları, altyazı JSON'ları, Hi sesleri ve karar arka planları. Paket her bölüm için `icerik/<id>/_build/package/` altında üretilir. Bu klasör git dışındadır. Kaynak dosyalar (`content.json`, `story.en.md`, `kurgu.json`, `audio/*.align.json`) depodadır.

## 1. Paket düzeni

```
icerik/A1-001-a-strange-message/_build/package/
├── scenes.json            # düğüm grafiği (şema: tools/content-pipeline/schema/scenes.schema.json)
├── manifest.json          # dosya listesi, boyut, sha256, ses düzeyi, yalnızca metin kalan düğümler
├── segments/<düğüm>.mp4   # 1080×1920 (9:16), H.264 High, yuv420p, 30 fps, AAC 44,1 kHz stereo, faststart (~4–5,6 Mbps)
├── segments/<düğüm>.720p.mp4  # 720×1280, H.264 High yuv420p, CRF 21 + maxrate 2M/bufsize 4M, -tune animation;
│                          #   ses 1080p'den kopya (AAC 128k), faststart; ~1,7–1,9 Mbps (H-054, uygulamanın varsayılanı)
├── subs/<düğüm>.en.json   # İngilizce altyazı: ipucu (cue) ve kelime zamanları (şema: subs.schema.json)
├── audio/<kimlik>.m4a     # Hi balonu, seçenek ve görev sesleri (AAC)
└── stills/<görsel>.webp   # karar, kart ve görev arka planları (1080×1920, WebP q80; H-054 öncesi .jpg)
```

- **Altyazı videoya gömülmez (K-03).** Oynatıcı `subs/*.en.json` dosyasından çizer. Videoda yalnızca **dünya içi yazılar** (saat, takvim, kapıdaki yarım not) ve küçük "Yapay zekâ ile üretilmiştir" etiketi gömülüdür.
- **Karar kartları videoya gömülmez.** Karar anı yerel arayüzdür (OYUN-TASARIMI §11.4).
- Ses düzeyi: bölümdeki bütün segmentler birlikte ölçülür, tek kazanç uygulanır, hedef **-16 LUFS** ve sınırlayıcı ≈ -1,5 dBFS.
- **720p sürüm (H-054):** 1080p son çıktıdan yeniden kodlanır (Ken Burns yeniden çizilmez). Ses kopyalanır; süre 1080p ile aynıdır (ölçülen fark 0,000 sn) ve senkron 720p dosyada da ayrıca ölçülür (≤ 0,2 sn). Önbellek: `_build/cache/r720/`.
- Segment geçişlerinde video içi geçiş (xfade) yoktur. Segment içindeki çekimler 0,3 sn geçişle birleşir. Segmentler arası geçişi oynatıcı yapar.

## 2. `scenes.json`

### 2.1 Üst alanlar

| Alan | Açıklama |
|---|---|
| `schemaVersion` | `2` (H-050: `title` ve `recap` düğümleri; başlık ve görev kartı yok). Uyumsuz değişiklikte artar. Uygulama 1 ve 2'yi okur. |
| `episode` | `id`, `slug`, `level`, `season`, `number`, `title`, `contentVersion`, `status`, `aiGenerated`, `aiLabel`, `mission.tr` (🎯 panelindeki görev cümlesi), `targetPhrases`, `targetPhraseGloss`, `glossary`, `prev`, `next`, `links`. |
| `episode.targetPhraseGloss` | 🎯 paneli için hedef ifadenin Türkçe anlamı: `text`, `tr`, `words` (`w`, `gloss`), `chunks`. `ceviri.tr.json`'dan gelir: önce birebir satır, yoksa herhangi bir satırdaki aynı kalıp (`chunks[].en`). Sonra `ceviri.tr.json` → `phrases` (H-052; altyazıda geçmeyen ifadeler, ör. B1 *Listen.* → "Dinle."). content-lint, anlamı olmayan hedef ifadeyi hata sayar (`target-meaning`). |
| `episode.glossary` | Bölüm sözlüğü (H-052): `content.json` → `glossary` (seviye üstü kelimeler) ve Türkçesi: `[{"w": "channel", "tr": "kanal"}]`. Türkçe `phrases` → satır kalıbı (çok kelimeli giriş) → herhangi bir satırın `words` anlamından gelir; bulunamazsa `tr` yoktur. Uygulama, altyazıda bakılan kelimelerden **yalnızca bu listedekileri** defter kartına çevirir (hedef ifadeler ve "Deftere ekle" bundan etkilenmez). |
| `episode.links` | `content.json`'daki bağ alanları: `previously`, `payoff`, `openQuestion`, `answers`, `cluesUnlocked`, `callbackPhrases` (OYUN-TASARIMI §4.3). |
| `flags` | Bu bölümde yazılan kalıcı bayraklar (`id`, `values`). **En fazla 3 (K-28).** |
| `externalFlags` | Önceki bölümde yazılıp bu bölümde okunan bayraklar (`episode`, `id`, `values`, `default`). |
| `gate` | Bölüm kapısı (K-29). Üç ölçütün hepsi gerekir. |
| `start` | İlk düğümün kimliği. schemaVersion 2'de her zaman `title` düğümüdür. |
| `nodes` | Düğüm listesi. Sıra yalnızca okunabilirlik içindir; akışı `next` belirler. |

### 2.2 Düğüm türleri

Her düğümde `id` ve `type` vardır. `scene` (sahne adı) ve `checkpoint` (sahne başı kontrol noktası) isteğe bağlıdır. `next: null` bölüm sonudur.

| `type` | Ne zaman | Önemli alanlar |
|---|---|---|
| `title` | **Bölümün ilk düğümü (zorunlu).** Sezonun yazısız kısa animasyonu üstünde uygulama "SEZON 1 · BÖLÜM N" (fener sarısı, küçük büyük harf) ve bölüm adını (büyük, beyaz) çizer. Dokunma gerekmez; video bitince `next`'e geçilir. Kontrol noktası değildir. | `season`, `episode`, `caption`, `title`, `seasonVideo` (sezon paketindeki dosya, 1080p), `seasonRenditions` (`720p`, `1080p`; H-054), `seasonPoster` (ilk kare, webp), `duration`, `next` |
| `recap` | "Önceki bölümde" (B2+): başlıktan hemen sonra, segment gibi oynayan kısa video. Altta "Önceki bölümde" etiketi ve "Atla" düğmesi (≥ 48 px). Kontrol noktası değildir. | `video`, `duration`, `subtitles`, `skippable`, `next` |
| `segment` | Kesintisiz video. Karar anlarında bölünür. | `video` (1080p), `renditions` (`720p`, `1080p`; H-054), `duration` (sn), `subtitles` (yol ya da `null`), `next` |
| `decision` | Karar anı. Video durur; müzik ve hareket kısılır (K-27). | `prompt.tr`, `cue` (soruyu soran replik), `pov`, `background`, `targetPhrase`, `skill`, `cefr`, `options[]`, `hints[]` |
| `reaction` | Yanlış seçimin kısa, nazik tepkisi; sonra aynı karara dönülür (K-28). | `video` + `duration` + `subtitles` ve/veya `bubble` (Hi balonu: `text`, `lang`, isteğe bağlı `audio`), `next` = karar |
| `card` | Yerel arayüz kartı. | `kind`: `hi`, `line`, `note`, `message`, `clue`, `openQuestion` (`title` ve `mission` sürüm 2'de yok); `lines[]` (`text`, `lang`, `speaker`, `style`; İngilizce satırda `tr`, `words`, `chunks`, §3.1); `audio`; `background`; `advance` (`tap`/`auto`) + `duration`; `variants[]` (bayrağa göre satırlar); `clueIds`, `questionId`, `answers` |
| `task` | Görev, anlama ya da kanıt etkileşimi. | `kind`: `choice`, `multiSelect`, `order`, `match`, `fillBlank`; `role`: `comprehension`, `mission`, `evidence`; `prompt.tr`; `items[]`; `audio` (dinleme); `feedback.wrong` (Hi balonu); `result[]` |

**Seçenek (`options[]`):** `id`, `text`, `lang` (varsayılan `en`), `icon` (ör. `arrows:up,left`), `correct`, `setFlag` (`flag`, `value`), `audio` (Alex'in o repliği), `next`.

- Doğru seçenek genellikle kısa bir yanıt segmentine gider (Alex repliği söyler), sonra hikâye sürer.
- Birden çok doğru seçenek olabilir (ton farkı: resmî / samimi). Seçilen ton `setFlag` ile saklanır.
- **Yanlış seçenek her zaman bir `reaction` düğümüne gider, o da aynı karara döner.**

**İpuçları (`hints[]`):** Hi'nin kademeli ipucu, yalnızca kullanıcı isterse (OYUN-TASARIMI §8.3): `level` 1 = anahtar sözcük, 2 = kalıp, 3 = Türkçe açıklama. 3. düzey metinler `story.en.md`'deki HI (TR) satırlarından gelir; 1. ve 2. düzey kurgu dosyasında yazıldı ve **editör onayı bekler** (H-028).

**Görev öğeleri (`items[]`):**

| `kind` | Öğe alanları | Doğru cevap |
|---|---|---|
| `choice` | `stem`, `options[]` | Tam 1 `correct` |
| `multiSelect` | `options[]` | Bütün `correct` seçenekler |
| `order` | `tokens[]` (karışık), `answer[]` | `answer` sırası |
| `match` | `pairs[]` (`left`, `right`) | Çiftler; oynatıcı sağ tarafı karıştırır |
| `fillBlank` | `stem` (`___`), `blanks[]` (`accept`: `"any"` ya da kabul listesi) | `accept` |

Yanlışta `feedback.wrong` gösterilir ve aynı öğe tekrar denenir. Süre sınırı yoktur (K-32). Puanlamaya yalnızca ilk deneme girer (OYUN-TASARIMI §8.1).

### 2.3 Bölüm kapısı (`gate`, K-29)

```json
"gate": {"rule": "all", "comprehension": ["t-gorev"], "targetPhrase": ["k2"], "activeTask": ["t-kanit"]}
```

- Her ölçüt bir düğüm listesidir. Listedeki herhangi bir düğüm doğru tamamlanınca ölçüt karşılanır.
- Deneme ve ipucu sınırsızdır. Kilit kalıcı değildir.
- `activeTask` yalnızca `task` düğümü olabilir (en az 1).

### 2.4 Bayraklar ve geri dönüş

- Bayrak bir karar seçeneğinde yazılır: `"setFlag": {"flag": "greet_tone", "value": "formal"}`.
- Sonraki bölüm onu `externalFlags` ile bildirir ve bir kartın `variants[]` alanında okur. Örnek: B3'teki Maya mesajı, B2'deki selamlaşma tonuna göre değişir.
- Hiçbir varyant uymazsa kartın kendi `lines` alanı gösterilir.

### 2.5 Kontrol noktası

- `checkpoint: true` sahne başlarını işaretler. Başlık ve özet kontrol noktası değildir.
- Kaldığı yerden devamda da önce başlık ekranı oynar, sonra doğrudan kaydedilen kontrol noktasına geçilir (özet atlanır). Başlık sırasında çıkılırsa kayıt korunur.
- Uygulama kapatılıp açılınca ya da bölümün yeni sürümünde düğüm silinince kullanıcı en yakın kontrol noktasına döner (OYUN-TASARIMI §14).
- Düğüm kimlikleri sürümler arasında sabit tutulur.

### 2.6 Açılış (H-050)

| Bölüm | Açılış | Eski soğuk açılış (`s01`) ne oldu |
|---|---|---|
| B1 | başlık → `s02` (Sahne 1) | Sessiz not görseli (2,5 sn) kaldırıldı; aynı görsel `s03`'te zaten var. B1'de özet yok. |
| B2 | başlık → `recap` (2,5 sn) → `s02` | 1. çekim (B1'in telsiz anı + "Meet me at the old station.") özet oldu. 2. çekim (dükkânın dış cephesi, 3 sn) `s02`'nin açılış çekimi oldu. |
| B3 | başlık → `recap` (2,8 sn) → `c-msg` → `s02` → `k1` | B2'nin sonu (Maya haritada: "I can show you. Tomorrow?") özet oldu. Maya'nın mesajı Sahne 1'in ilk düğümü (kontrol noktası). |
| B4 | başlık → `recap` (3,2 sn) → `h-01` → `s02` | B3'ün son karesi (kapıdaki yarım not) sessiz özet oldu. Hi kartı Sahne 1'in ilk düğümü (kontrol noktası). |

- Tam jenerik bölüm başında oynamaz. Hikâye sekmesinde sezon ilk kez açılınca bir kez kendiliğinden oynar (cihazda saklanır), sezon başlığındaki "Jeneriği izle" ile yeniden açılır. "Geç" ile her an atlanır.
- "Yapay zekâ ile üretilmiştir" notu başlık ekranında sol üstte 4 sn görünür; başlık yazısıyla çakışmaz.
- Hi'nin konu tanıtımı (yeni dilbilgisi konusu ilk geçtiğinde) bu sürümde yok; H-048'e taşındı.

### 2.7 Sezon paketi ve harita kataloğu (H-050, H-035)

Sezon paketi `icerik/_evren/_build/season/S<n>/` altında üretilir (git dışı), geliştirme sunucusu `/packages/_season/S<n>/` adresinde sunar.

| Dosya / alan | Kaynak | Açıklama |
|---|---|---|
| `jenerik-tam.mp4`, `jenerik-kisa.mp4`, `jenerik-baslik.mp4` + `.720p.mp4` sürümleri + `jenerik-baslik.webp` | `_evren/jenerik/` (H-049/H-050) | Sezon jeneriği ve bölüm başlık arka planı. `season.json`'daki her video girdisinde `renditions` (H-054). |
| `map.webp` | `_evren/harita/map.jpg` (kayıpsız `map.png` varsa ondan; git dışı; üretim kaydı `_evren/harita/PROMPTS.md`) | Hikâye haritasının arka planı (WebP q80, H-054). **Yoksa** uygulama haritayı kodla çizer. Numara ve düğümler görselde değil, uygulamada çizilir. |
| `season.json` → `map` | | `image`, `width`, `height` (piksel). Uygulama haritayı bu en-boy oranıyla çizer, gerekirse dikey kaydırır. |
| `season.json` → `episodes[]` | `_evren/harita/season-<nn>.json` (depoda) | Sezonun bütün bölüm yerleri (S1: 12). Alanlar aşağıda. |

`episodes[]` alanları:

| Alan | Kaynak | Açıklama |
|---|---|---|
| `number` | katalog | Bölüm numarası (1–12) |
| `contentId` | katalog | `A1-001` … |
| `title` | bölümün `content.json`'ı | Klasör yoksa `contentId` |
| `teaserTr` | katalog | Spoiler'sız tek cümle (kilitli ve yakında olan bölümde de gösterilir). Açık soruların cevabını ve bölüm sonunu **vermez**. |
| `teaserStatus` | katalog | `DRAFT` → editör onayından sonra `APPROVED` |
| `available` | paket | `<bölüm>/_build/package/scenes.json` varsa `true`. Uygulama ayrıca canlı `index.json` listesine bakar; ikisinden biri yoksa bölüm "Yakında" görünür. |
| `mapPos` | katalog | `[x, y]`, 0–1 arası, sol üst köşe `0,0`. `map.jpg` üzerinde ölçülür; düğümler yol üstündeki açık noktalara gelir (liman altta → fener üstte). |

Yalnızca sezon paketini yeniden üretmek (bölüm medyasına dokunmaz):

```bash
python3 tools/content-pipeline/export_package.py --season 1
```

**Kilit kuralı (uygulama, K-26/K-29):** Bölüm N oynanabilir ⇔ `available` **ve** (N = 1 **ya da** Bölüm N−1'in kapısı tamam **ya da** bölüm daha önce başlatılmış/bitirilmiş). Paket yoksa "Yakında" (tarih ve geri sayım yok). Tekrar oynama her zaman serbesttir; zaman kilidi yoktur.

## 3. Altyazı JSON (`subs/<düğüm>.en.json`)

```json
{"schemaVersion": 1, "segment": "s04", "lang": "en", "duration": 12.1,
 "cues": [{"id": "s04-05", "start": 9.033, "end": 11.663, "speaker": "MAYA",
           "text": "It's between Pier 2 and Pier 4.", "tr": "2 ve 4 numaralı iskelelerin arasında.",
           "words": [{"w": "It's", "start": 9.033, "end": 9.313, "gloss": "o … -dır (orası)"},
                     {"w": "between", "start": 9.338, "end": 9.513, "gloss": "arasında"}, "…"],
           "chunks": [{"en": "between … and …", "tr": "… ile …-in arasında", "startWord": 1, "endWord": 6}]}]}
```

- Zamanlar saniyedir ve segmentin başına görelidir. ElevenLabs karakter hizalamasından hesaplanır.
- Cümle parçası düzeyinde zamanlanır. İki sözcükten kısa parça sonrakiyle birleşir.
- İpucu, söz bittikten 0,15 sn sonra ya da sonraki ipucu başlayınca kalkar.
- Her çekimin ilk ipucu, ölçülen ses başlangıcından önce başlamaz (D-001).
- `tr`: Türkçe cümle. `ceviri.tr.json`'dan gelir; çeviri yoksa `null`. EN+TR altyazı modu ve anlam paneli bunu kullanır.
- `words[].gloss`: kelimenin **bu cümledeki** Türkçe anlamı. Özel adlarda (`data/proper_nouns.txt`) ve çeviri yoksa `null`.
- `chunks[]`: kalıp ifadeler (*How much is it?* = "Ne kadar?"). `startWord`..`endWord` bu ipucunun `words` dizisindeki aralıktır (0 tabanlı, ikisi de dahil). `…` ve `+ <yer tutucu>` içeren kalıplar (*between … and …*, *It's + gün*) aradaki kelimeleri de kapsar.
- Anlam panelinde kelimenin sesi, `words[].start`/`end` zamanlarıyla segmentten kesilir; ek ses üretilmez (H-046).

### 3.1 Çeviri kaynağı: `ceviri.tr.json` (H-046)

```json
{"contentId": "A1-004", "status": "DRAFT", "author": "Claude taslak", "date": "2026-10-11",
 "lines": [{"en": "It's between Pier 2 and Pier 4.", "speaker": "MAYA", "tr": "2 ve 4 numaralı iskelelerin arasında.",
            "chunks": [{"en": "between … and …", "tr": "… ile …-in arasında"}],
            "words": {"it's": "o … -dır (orası)", "between": "arasında", "pier": "iskele", "2": "iki"},
            "source": "subs/s04"}],
 "phrases": [{"en": "Listen.", "tr": "Dinle.", "words": {"listen": "dinlemek"},
              "source": "content:targetPhrases", "note": "altyazıda geçmiyor"}],
 "notes": ["…"]}
```

- `phrases` (H-052): altyazıda ya da kartta birebir geçmeyen hedef ifadelerin ve sözlük kelimelerinin anlamı. Altyazı eşlemesine girmez; yalnızca 🎯 paneli, defter kartı ve `episode.glossary` kullanır. Hedef ifadede önce satır, sonra kalıp, en son `phrases` aranır.
- Satır, İngilizce metnin **birebir aynısıyla** eşlenir; yalnızca boşluklar normalleştirilir. Konuşmacı eşlemeye girmez (aynı cümle iki karakterde tek kayıtla çevrilir).
- `words` anahtarı küçük harfli kelimedir; baştaki ve sondaki noktalama atılır, içteki `'` ve `:` kalır (`it's`, `o'clock`, `2:00`).
- `source` yalnızca bilgi içindir. `status`: `DRAFT` → editör onayı → `APPROVED` (H-028).
- Çeviriyi Claude taslak olarak yazar, kullanıcı onaylar. `story.tr.md` aynı çevirinin okunur sürümüdür.
- **Karar seçenekleri çevrilmez** (kullanıcı kararı); destek Hi ipuçlarıyla verilir. Görev seçenekleri de cevabı ele vermemek için çevrilmez.
- Dışa aktarıcı aynı çeviriyi zamansız metinlere de ekler: kart satırları (`lines[]`, `lang: en`) ve karar repliği (`cue`) `tr`, `words` (`w`, `gloss`) ve `chunks` alır; görev kökü (`items[].stem`) `stemTr`, `stemWords`, `stemChunks` alır. "Bölüm 2: The New Neighbour" gibi önekli satırda iki noktadan sonraki kısım eşlenir.
- Hi'nin Türkçe repliği segmente girmez. Hi her zaman `card` (kind `hi`) ya da `bubble` olarak gelir.

## 4. `manifest.json`

`contentId`, `contentVersion`, `renditions` (`["720p", "1080p"]`), `tool`, `loudness` (`gainDb`, önce/sonra ölçüm), `textOnly[]` (videosu ya da sesi olmayan düğümler ve nedeni), `files[]` (`path`, `bytes`, `sha256`), `totalBytes`, `renditionBytes` (H-054: uygulamanın bir sürüm için indirdiği toplam = ortak dosyalar + o sürümün videoları). Oynatıcı ve içe aktarma (H-041) bütünlüğü sha256 ile denetler.

### 4.1 Katalog içe aktarma (H-037)

Backend kataloğu (`content_items`, `catalog_seasons`) paket dosyalarından doldurulur; medya veritabanına girmez. Geliştirmede `POST /api/v1/admin/catalog/import` (EDITOR/ADMIN, prod'da yok) şunları okur: `manifest.json` (`contentId`, `contentVersion`, `totalBytes`, `renditionBytes`; dosyanın SHA-256'sı saklanır), `scenes.json → episode` (`id`, `slug`, `level`, `season`, `number`, `title`, `contentVersion`, `estimatedMinutes`), bölüm klasöründeki `content.json` (`status`, `publishAt`, `humanReviewed`) ve `ceviri.tr.json → status`; sezon için `season.json`.

- Klasör adının ilk 6 karakteri, `manifest.contentId`, `episode.id` ve iki `contentVersion` birbirini tutmalı; tutmazsa bölüm atlanır.
- **Durum:** `APPROVED` / `SCHEDULED` / `PUBLISHED` yalnızca `humanReviewed: true` ve (varsa) `ceviri.tr.json` `APPROVED` ise kabul edilir; yoksa `DRAFT`. `SCHEDULED` `publishAt` ister (ISO-8601, saat dilimli). Açık katalogda yalnızca `PUBLISHED` ya da zamanı gelmiş `APPROVED`/`SCHEDULED` bölüm görünür. Onay ekranı H-041'de.
- Aynı (`contentId`, `contentVersion`) ikinci kez içe aktarılınca değişmez; paket yeniden üretilip manifest değişirse satır güncellenir. Yeni içerik sürümü yeni satırdır; katalog görünür en yeni sürümü verir.
- `season.json → episodes[].teaserTr` yalnızca `teaserStatus: APPROVED` ise uygulamaya döner.

## 5. Kaynak: `kurgu.json`

Her bölüm klasöründe, paketin kaynağı olan kurgu tanımı vardır. `scenes.json` ile aynı düğümleri içerir; fark, video düğümlerinde dosya yolu yerine **çekim listesi** (`shots[]`) bulunmasıdır:

```json
{"image": "images/T2-pov.png", "audio": [{"id": "voice_01", "radio": true}], "atempo": 0.82, "aoff": 0.5,
 "move": [1.06, 1.12, 0.5, 0.5, 0.45, 0.45],
 "signs": [{"style": "note", "lines": [{"text": "Fri…  …pm"}], "start": 0.35, "end": 1.95}]}
```

| Alan | Açıklama |
|---|---|
| `image` / `clip` | Durağan görsel (Ken Burns) ya da gerçek klip. Başka bölümün görseli `../A1-00x-…/images/…` ile kullanılabilir. |
| `audio[]` | Ses kimlikleri. Birden çoksa aralarına 0,35 sn boşluk konarak tek seslik olur. `radio: true` telsiz filtresi uygular. `path` başka bölümün sesidir. Konuşmacı `audio_manifest.json`'dan ya da dosya adından bulunur. |
| `atempo` | Hız (ör. 0,82). Ayrı dosyaya önceden uygulanır (D-001). |
| `aoff` | Çekim başında sesten önceki boşluk (varsayılan 0,5 sn). |
| `len` | Sessiz çekimde süre. Sesli çekimde süre = `aoff` + ses + 0,55 sn. |
| `move` | Ken Burns: `[z0, z1, x0, x1, y0, y1]`. |
| `signs[]` | Dünya içi yazı (gömülür): `style` `caption` ya da `note`, `lines`, `start`, `end`. |

- Kartlarda `background` bir görsel yoludur ve pakette `stills/` altına dönüştürülür.
- Ses alanları (`audio`) ses kimliğidir ve `audio/*.m4a` olur.
- Kaynakta ses yoksa düğüm yalnızca metin kalır ve `manifest.textOnly`'ye yazılır. **Araç hiçbir ücretli üretim çağrısı yapmaz.**

## 6. Araçlar

```bash
cd tools/content-pipeline && uv venv .venv && uv pip install --python .venv/bin/python -r requirements-dev.txt
.venv/bin/python -m pytest                               # testler (ffmpeg gerekmez)
python3 tools/content-pipeline/content_lint.py icerik/A1-0*            # denetim
python3 tools/content-pipeline/export_package.py icerik/A1-00[1-4]-*   # paket (ffmpeg + ImageMagick gerekir)
```

- `export_package.py` ara dosyaları `_build/cache/` altında saklar. Aynı girdiyle tekrar çalıştırma yalnızca değişen çekimleri yeniden üretir.
- Önbellek dosyaları önce geçici adla yazılır.
- Çıktıda her segment ve özet için senkron ölçümü yapılır: ilk ipucu ile gerçek ses başlangıcı arasındaki fark ≤ 0,2 sn olmalı. H-054'ten beri 720p dosyalarda da ölçülür; ayrıca 720p süresi 1080p'den en çok 1 kare farklı, biçimi H.264 High 720×1280 yuv420p ve faststart olmalı.
- Sezon paketi de aynı komutla üretilir (bölümlerin sezonları için). Yalnızca sezon paketi: `--season 1` (§2.7).

### content-lint kuralları

| Kod | Kural | Düzey |
|---|---|---|
| `target-meaning` | Her hedef ifadenin Türkçe anlamı var (satır, kalıp ya da `phrases`). Yalnızca `ceviri.tr.json` olan bölümlerde. | Hata |
| `glossary-meaning` | Sözlükteki (`content.json` → `glossary`) her kelimenin Türkçesi bulunuyor | Uyarı |
| `links` | `content.json`'da `previously`, `payoff`, `openQuestion`, `answers`, `cluesUnlocked`, `callbackPhrases` var. `previously` yalnızca ilk bölümde boş olabilir. | Hata |
| `coverage` | CEFR-J kümülatif kapsama ≥ %98. %95–98 arası yalnızca seviye üstü sözcükler sözlükte (`content.json` → `glossary`) açıklanıyorsa kabul edilir (sözlükle ≥ %98). Bu durumda uyarı verilir; görsel desteği editör doğrular. | Hata / uyarı |
| `off-list` | Sözlükte olmayan liste dışı sözcükler | Uyarı |
| `sentence-length` | A1'de cümle en çok 8, A2'de en çok 12 sözcük | Hata |
| `schema` | `scenes.json` şemaya uygun | Hata |
| `title-start` | Başlangıç düğümü `title` değil ya da birden çok başlık var | Hata |
| `title-first` | Başlığa giden bir düğüm var (başlıktan önce hiçbir şey olamaz) | Hata |
| `recap-length` | "Önceki bölümde" 15 sn'den uzun | Uyarı |
| `recap-position` | Özet doğrudan başlıktan sonra gelmiyor | Uyarı |
| `season-missing` | Paket denetiminde sezon paketinde başlık arka planı yok | Uyarı |
| `unreachable`, `dangling`, `dead-end`, `no-end` | Ulaşılamayan düğüm, var olmayan hedef, bölüm sonuna çıkmayan yol | Hata |
| `no-correct`, `wrong-no-reaction`, `wrong-no-return` | Kararda doğru seçenek var; yanlış seçenek tepkiye, tepki aynı karara gider | Hata |
| `flags`, `flag-undeclared`, `flag-value` | En fazla 3 bayrak; yazılan ve okunan bayrak tanımlı | Hata |
| `decisions` | A1–A2'de bölüm başına en fazla 4 karar anı | Hata |
| `task` | Tek seçimlide tam 1 doğru; sıralama cevabı parçalarla aynı | Hata |
| `gate` | Kapı ölçütlerindeki düğümler var ve ulaşılabilir | Hata |
| `chain` | Açılan bölüm sorusu en geç 3 bölümde kapanır; aynı anda en fazla 2 bölüm sorusu açık (sezon ve seri soruları hariç) | Hata |
| `missing-file` | Pakette `scenes.json`'ın andığı dosya var | Hata |
| `translation` | `ceviri.tr.json` varsa: her altyazı ipucunun çeviri satırı ve her kelimenin (özel ad hariç) anlamı var. Kart, karar repliği ve görev kökünde eksik çeviri ya da cümlede bulunamayan kalıp uyarıdır. Dosya yoksa "çeviri yok", durum `APPROVED` değilse durum uyarısı. | Hata / uyarı |

**Konu seti kuralları (H-051, §7):** content-lint bölümlerle aynı içerik kökündeki `_evren/setler/*.json` dosyalarını da denetler (`--no-sets` ile atlanır). Hatalı set dışa aktarılmaz.

| Kod | Kural | Düzey |
|---|---|---|
| `set-schema` | `schema/topic-set.schema.json`'a uygun; dosya adı = set kimliği; öğe kimliği ve kelime tekil | Hata |
| `set-meaning` | Her öğenin Türkçesi (`tr`) ve sahne avı yardım satırı (`findTr`) dolu | Hata |
| `set-level` | Kelime set seviyesinde (CEFR-J); üstündeyse `aboveLevel: true` zorunlu (Türkçesi kartta sözlük işlevi görür) | Hata (gereksiz işaret: uyarı) |
| `set-coverage`, `set-off-list` | Örnek cümleler bölümlerle aynı kapsama kuralına uyar (≥ %98; %95–98 yalnızca sözlükle). Sözlük = `aboveLevel` kelimeler + setin `glossary` listesi | Hata / uyarı |
| `set-sentence-length` | A1'de örnek cümle en çok 8 sözcük | Hata |
| `set-crop`, `set-hotspot` | Kırpma ve dokunma bölgeleri görselin içinde; çokgenin alanı var; kırpma en az bir bölgeyle kesişiyor | Hata |
| `set-audio` | Ses kaynağı (`.mp3` + `.align.json`) var; kelime hizalamada bulunuyor; örnek cümle sesi örnek cümleyle aynı replik | Hata |
| `set-unlock`, `set-image` | `unlockAfter` bölümü ve sahne görseli var | Hata |
| `set-status` | Durum `APPROVED` değil (Türkçe ve örnekler editör onayı bekliyor) | Uyarı |

**Kapsama hesabı:**
- Özel adlar sayılmaz (`data/proper_nouns.txt`).
- Ünlemler de sayılmaz (*oh, ah, ha, hmm, wow*).
- Kısaltmalar açılır (*I'm → I am*). Yarım sözcükler (*Fri…*) atılır.
- Çekim ekleri liste sözcüğüne indirgenir (*-s, -ed, -ing*, düzensiz fiiller).
- Denetime giren satırlar: İngilizce replikler, ✓/✗ seçenekleri, `[TEPKİ]` replikleri ve `[YAZI]` metinleri. `(TR)` replikleri ve `>` ile başlayan notlar girmez.

## 7. Konu setleri ve sahne avı (H-051)

Hikâye mekânlarına bağlı kelime setleri. Kaynak `icerik/_evren/setler/<set-id>.json` (şema `tools/content-pipeline/schema/topic-set.schema.json`), paket sezon paketinin içindedir. Ücretli üretim yoktur: görseller bölümün mevcut çiziminden kırpılır, ses yalnızca karakter kelimeyi bölümde gerçekten söylüyorsa kayıttan kesilir.

**Kaynak alanları:** `id`, `season`, `level`, `order`, `titleTr` ("Alex'in odası"), `unlockAfter` (seti açan bölüm, `A1-001`), `sceneImage` (bölümün kendi görseli, `A1-001-…/images/T1-oda.png`), `glossary` (örneklerde geçen seviye üstü kelimeler), `status` (`DRAFT` → `APPROVED`), `items[]`:

| Alan | Açıklama |
|---|---|
| `w` | İngilizce kelime ya da kısa ifade (`radio`, `bus stop`); A1 CEFR-J. Üstündeyse `aboveLevel: true`. |
| `tr`, `findTr` | Türkçesi; sahne avının Türkçe yardım satırı ("Telsizi bul"). `findEn` verilmezse "Find the {w}!". |
| `exampleEn`, `exampleTr` | A1, en çok 8 sözcük; bölümde geçen bir replik varsa o kullanılır. |
| `crop` | Kart görseli için normalleştirilmiş `[x, y, w, h]`. Paket, kısa kenarı merkezden uzatıp görsel içinde kalan bir kareye çevirir (512×512 WebP). |
| `hotspots` | Dokunma bölgeleri: `{"rect": [x, y, w, h]}` ya da `{"polygon": [[x, y], …]}` (normalleştirilmiş). Nesne sahnede birden çok yerdeyse birden çok bölge. |
| `audioRef` | `{"source": "<bölüm>/audio/<ad>", "word": "radio"}`: kelime `.align.json` zamanlarıyla kesilir (önce 0,04 sn, sonra 0,10 sn pay); sesi olmayan öğe `null` (kartta ses düğmesi görünmez). |
| `exampleAudioRef` | Örnek cümle bir replikse o kaydın tamamı (`{"source": …}`). |

**Paket** (`/packages/_season/S<n>/`):

```
season.json            → topicSets[]: id, order, titleTr, unlockAfter, unlockEpisode, itemCount, cover, path, bytes
sets/<id>.json         → set verisi: scene {image, width, height}, items[] (kaynak alanları + kind, image,
                         audio/audioSource {source, start, end}, exampleAudio/exampleAudioSource)
sets/<id>/scene.webp   → sahne avı görseli (1080 px genişlik, oran korunur, yazısız)
sets/<id>/<öğe>.webp   → öğe kartı (512×512)
sets/<id>/<öğe>.m4a, <öğe>.example.m4a → kelime ve örnek cümle sesi (AAC, kayıt -16 LUFS'a getirilir)
```

**Uygulama:**
- Set, `unlockAfter` bölümü bitince açılır (zaman kilidi yok). Kilitli set sakin bir nedenle görünür: "Bölüm 3'ü bitirince açılır."
- Konu setinden eklenen ifade Defter'den çıkarılabilir; set etkilenmez.
- Defter → "Konu setleri" sekmesi ve bölüm sonu ("Yeni konu seti açıldı: …"). Izgarada nesne görseli, kelime ve Türkçesi; karta dokununca anlam, örnek cümle ve (varsa) ses. "Hepsini defterime ekle" ya da tek tek ekleme kelime tekrarına (FSRS) yeni ifade ekler.
- Defter kartının görsel ve ses yolu `_season/S1/sets/…` önekiyle sezon paketinden okunur. Aynı kelime bölümden de geldiyse kart, açık bir setteki kırpılmış görsele geçer (bölümdeki ses korunur).
- **Sahne avı:** önce yalnızca "Find the radio!" (+ kelimenin sesi, varsa); ilk yanlış dokunuşta "Bir daha bakalım." ve Türkçe yardım satırı ("Telsizi bul"), ikinci yanlıştan sonra bölge parlar. Görsel ekranı olabildiğince doldurur; iki parmakla ya da düğmeyle büyütülür ve kaydırılır (`InteractiveViewer`). Dokunuş görselin kendi koordinatlarında değerlendirilir, büyütme isabeti bozmaz (küçük nesnelere 14 pt pay). "Bilmiyorum" yeri gösterir. Süre ve puan yok. Defterdeki ifadeler için sonuç kelime tekrarına yazılır: kendi bulduysa Good; "Bilmiyorum" ya da 2+ kaçırma Again (`review_logs.task_type = scene_hunt`). Aynı gün zaten tekrar edilmiş kart atlanır.
- Ekran okuyucu: her bölge Türkçe adıyla düğmedir; ekran okuyucu açıkken resim yerine seçenek listesi sunulur ve Türkçe yardım satırı ipucuna kadar gizlenir.

## 8. Atıf

> The CEFR-J Wordlist Version 1.6. Compiled by Yukio Tono, Tokyo University of Foreign Studies. Retrieved from https://www.cefr-j.org/download.html on 11/10/26.

Ayrıntı: `tools/content-pipeline/data/README.md`, `docs/LISANS-RAPORU.md` §2.1.
