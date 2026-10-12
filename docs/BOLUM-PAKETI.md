# Bölüm paketi (H-034)

**Sürüm:** `schemaVersion: 1` · **Tarih:** 2026-10-11 · **Araçlar:** `tools/content-pipeline/`

Bölüm paketi, etkileşimli oynatıcının (H-031) bir bölümü oynatmak için ihtiyaç duyduğu her şeydir: düğüm grafiği (`scenes.json`), segment videoları, altyazı JSON'ları, Hi sesleri ve karar arka planları. Paket her bölüm için `icerik/<id>/_build/package/` altında üretilir. Bu klasör git dışındadır. Kaynak dosyalar (`content.json`, `story.en.md`, `kurgu.json`, `audio/*.align.json`) depodadır.

## 1. Paket düzeni

```
icerik/A1-001-a-strange-message/_build/package/
├── scenes.json            # düğüm grafiği (şema: tools/content-pipeline/schema/scenes.schema.json)
├── manifest.json          # dosya listesi, boyut, sha256, ses düzeyi, yalnızca metin kalan düğümler
├── segments/<düğüm>.mp4   # 1080×1920 (9:16), H.264 High, yuv420p, 30 fps, AAC 44,1 kHz stereo, faststart
├── subs/<düğüm>.en.json   # İngilizce altyazı: ipucu (cue) ve kelime zamanları (şema: subs.schema.json)
├── audio/<kimlik>.m4a     # Hi balonu, seçenek ve görev sesleri (AAC)
└── stills/<görsel>.jpg    # karar, kart ve görev arka planları (1080×1920)
```

- **Altyazı videoya gömülmez (K-03).** Oynatıcı `subs/*.en.json` dosyasından çizer. Videoda yalnızca **dünya içi yazılar** (saat, takvim, kapıdaki yarım not) ve küçük "Yapay zekâ ile üretilmiştir" etiketi gömülüdür.
- **Karar kartları videoya gömülmez.** Karar anı yerel arayüzdür (OYUN-TASARIMI §11.4).
- Ses düzeyi: bölümdeki bütün segmentler birlikte ölçülür, tek kazanç uygulanır, hedef **-16 LUFS** ve sınırlayıcı ≈ -1,5 dBFS.
- Segment geçişlerinde video içi geçiş (xfade) yoktur. Segment içindeki çekimler 0,3 sn geçişle birleşir. Segmentler arası geçişi oynatıcı yapar.

## 2. `scenes.json`

### 2.1 Üst alanlar

| Alan | Açıklama |
|---|---|
| `schemaVersion` | Her zaman `1`. Uyumsuz değişiklikte artar. |
| `episode` | `id`, `slug`, `level`, `season`, `number`, `title`, `contentVersion`, `status`, `aiGenerated`, `aiLabel`, `mission.tr` (görev kartı), `targetPhrases`, `prev`, `next`, `links`. |
| `episode.links` | `content.json`'daki bağ alanları: `previously`, `payoff`, `openQuestion`, `answers`, `cluesUnlocked`, `callbackPhrases` (OYUN-TASARIMI §4.3). |
| `flags` | Bu bölümde yazılan kalıcı bayraklar (`id`, `values`). **En fazla 3 (K-28).** |
| `externalFlags` | Önceki bölümde yazılıp bu bölümde okunan bayraklar (`episode`, `id`, `values`, `default`). |
| `gate` | Bölüm kapısı (K-29). Üç ölçütün hepsi gerekir. |
| `start` | İlk düğümün kimliği. |
| `nodes` | Düğüm listesi. Sıra yalnızca okunabilirlik içindir; akışı `next` belirler. |

### 2.2 Düğüm türleri

Her düğümde `id` ve `type` vardır. `scene` (sahne adı) ve `checkpoint` (sahne başı kontrol noktası) isteğe bağlıdır. `next: null` bölüm sonudur.

| `type` | Ne zaman | Önemli alanlar |
|---|---|---|
| `segment` | Kesintisiz video. Karar anlarında bölünür. | `video`, `duration` (sn), `subtitles` (yol ya da `null`), `next` |
| `decision` | Karar anı. Video durur; müzik ve hareket kısılır (K-27). | `prompt.tr`, `cue` (soruyu soran replik), `pov`, `background`, `targetPhrase`, `skill`, `cefr`, `options[]`, `hints[]` |
| `reaction` | Yanlış seçimin kısa, nazik tepkisi; sonra aynı karara dönülür (K-28). | `video` + `duration` + `subtitles` ve/veya `bubble` (Hi balonu: `text`, `lang`, isteğe bağlı `audio`), `next` = karar |
| `card` | Yerel arayüz kartı. | `kind`: `title`, `mission`, `hi`, `line`, `note`, `message`, `clue`, `openQuestion`; `lines[]` (`text`, `lang`, `speaker`, `style`; İngilizce satırda `tr`, `words`, `chunks`, §3.1); `audio`; `background`; `advance` (`tap`/`auto`) + `duration`; `variants[]` (bayrağa göre satırlar); `clueIds`, `questionId`, `answers` |
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

- `checkpoint: true` sahne başlarını işaretler.
- Uygulama kapatılıp açılınca ya da bölümün yeni sürümünde düğüm silinince kullanıcı en yakın kontrol noktasına döner (OYUN-TASARIMI §14).
- Düğüm kimlikleri sürümler arasında sabit tutulur.

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
 "notes": ["…"]}
```

- Satır, İngilizce metnin **birebir aynısıyla** eşlenir; yalnızca boşluklar normalleştirilir. Konuşmacı eşlemeye girmez (aynı cümle iki karakterde tek kayıtla çevrilir).
- `words` anahtarı küçük harfli kelimedir; baştaki ve sondaki noktalama atılır, içteki `'` ve `:` kalır (`it's`, `o'clock`, `2:00`).
- `source` yalnızca bilgi içindir. `status`: `DRAFT` → editör onayı → `APPROVED` (H-028).
- Çeviriyi Claude taslak olarak yazar, kullanıcı onaylar. `story.tr.md` aynı çevirinin okunur sürümüdür.
- **Karar seçenekleri çevrilmez** (kullanıcı kararı); destek Hi ipuçlarıyla verilir. Görev seçenekleri de cevabı ele vermemek için çevrilmez.
- Dışa aktarıcı aynı çeviriyi zamansız metinlere de ekler: kart satırları (`lines[]`, `lang: en`) ve karar repliği (`cue`) `tr`, `words` (`w`, `gloss`) ve `chunks` alır; görev kökü (`items[].stem`) `stemTr`, `stemWords`, `stemChunks` alır. "Bölüm 2: The New Neighbour" gibi önekli satırda iki noktadan sonraki kısım eşlenir.
- Hi'nin Türkçe repliği segmente girmez. Hi her zaman `card` (kind `hi`) ya da `bubble` olarak gelir.

## 4. `manifest.json`

`contentId`, `contentVersion`, `tool`, `loudness` (`gainDb`, önce/sonra ölçüm), `textOnly[]` (videosu ya da sesi olmayan düğümler ve nedeni), `files[]` (`path`, `bytes`, `sha256`), `totalBytes`. Oynatıcı ve içe aktarma (H-041) bütünlüğü sha256 ile denetler.

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
- Çıktıda her segment için senkron ölçümü yapılır: ilk ipucu ile gerçek ses başlangıcı arasındaki fark ≤ 0,2 sn olmalı.

### content-lint kuralları

| Kod | Kural | Düzey |
|---|---|---|
| `links` | `content.json`'da `previously`, `payoff`, `openQuestion`, `answers`, `cluesUnlocked`, `callbackPhrases` var. `previously` yalnızca ilk bölümde boş olabilir. | Hata |
| `coverage` | CEFR-J kümülatif kapsama ≥ %98. %95–98 arası yalnızca seviye üstü sözcükler sözlükte (`content.json` → `glossary`) açıklanıyorsa kabul edilir (sözlükle ≥ %98). Bu durumda uyarı verilir; görsel desteği editör doğrular. | Hata / uyarı |
| `off-list` | Sözlükte olmayan liste dışı sözcükler | Uyarı |
| `sentence-length` | A1'de cümle en çok 8, A2'de en çok 12 sözcük | Hata |
| `schema` | `scenes.json` şemaya uygun | Hata |
| `unreachable`, `dangling`, `dead-end`, `no-end` | Ulaşılamayan düğüm, var olmayan hedef, bölüm sonuna çıkmayan yol | Hata |
| `no-correct`, `wrong-no-reaction`, `wrong-no-return` | Kararda doğru seçenek var; yanlış seçenek tepkiye, tepki aynı karara gider | Hata |
| `flags`, `flag-undeclared`, `flag-value` | En fazla 3 bayrak; yazılan ve okunan bayrak tanımlı | Hata |
| `decisions` | A1–A2'de bölüm başına en fazla 4 karar anı | Hata |
| `task` | Tek seçimlide tam 1 doğru; sıralama cevabı parçalarla aynı | Hata |
| `gate` | Kapı ölçütlerindeki düğümler var ve ulaşılabilir | Hata |
| `chain` | Açılan bölüm sorusu en geç 3 bölümde kapanır; aynı anda en fazla 2 bölüm sorusu açık (sezon ve seri soruları hariç) | Hata |
| `missing-file` | Pakette `scenes.json`'ın andığı dosya var | Hata |
| `translation` | `ceviri.tr.json` varsa: her altyazı ipucunun çeviri satırı ve her kelimenin (özel ad hariç) anlamı var. Kart, karar repliği ve görev kökünde eksik çeviri ya da cümlede bulunamayan kalıp uyarıdır. Dosya yoksa "çeviri yok", durum `APPROVED` değilse durum uyarısı. | Hata / uyarı |

**Kapsama hesabı:**
- Özel adlar sayılmaz (`data/proper_nouns.txt`).
- Ünlemler de sayılmaz (*oh, ah, ha, hmm, wow*).
- Kısaltmalar açılır (*I'm → I am*). Yarım sözcükler (*Fri…*) atılır.
- Çekim ekleri liste sözcüğüne indirgenir (*-s, -ed, -ing*, düzensiz fiiller).
- Denetime giren satırlar: İngilizce replikler, ✓/✗ seçenekleri, `[TEPKİ]` replikleri ve `[YAZI]` metinleri. `(TR)` replikleri ve `>` ile başlayan notlar girmez.

## 7. Atıf

> The CEFR-J Wordlist Version 1.6. Compiled by Yukio Tono, Tokyo University of Foreign Studies. Retrieved from https://www.cefr-j.org/download.html on 11/10/26.

Ayrıntı: `tools/content-pipeline/data/README.md`, `docs/LISANS-RAPORU.md` §2.1.
