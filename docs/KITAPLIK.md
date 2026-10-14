# Kitaplık: seviyeli, resimli, sesli kitaplar (H-065…H-073)

> Durum: **plan** (kullanıcı isteği ve onayı 2026-10-14). Kararlar §2'de; işler §9'da.

## 1. Neden
Uygulamada hep okuma ve dilbilgisi var. Kullanıcı bazen yalnızca **dinlemek** ister (ör. yatakta): "A2 seviyesinde bir hikâye aç."
- Sistem okumadığı bir kitabı seçer ve sesli okur.
- Metin ekranda renkli, resimli bir kitap sayfası olarak görünür.
- Okunan cümle vurgulanır; kullanıcı nerede olduğunu görür.
- İstediği an durdurabilir.
- Kelimeye ya da cümleye dokununca Türkçesini görür.
- Sesi kapatıp kendi de okuyabilir.
- Okuduğu ve yarıda kalan kitapları takip eder.
- **Hedef:** A1, A2, B1, B2, C1 ve C2 seviyelerinin her birinde 5 kitap, toplam **30 kitap**. Sıkmayan, merak ettiren kitaplar.

Ana hikâyeden (*The Missing Signal*) ayrı ama onu tamamlayan bir **dinleme + kapsamlı okuma** ayağıdır. Pasif dinleme aktif öğrenmeye bağlanır: dokun → anlam → deftere ekle → FSRS tekrarı (ürün ilkesi).

## 2. Kullanıcı kararları (2026-10-14)
| Konu | Karar |
|---|---|
| Resimler | **Önce pilot:** 2 pilot kitap (A1 + A2) her sayfası resimli, yaklaşık 30 görsel ≈ 15 kr. Uygulamada görüldükten sonra kalan 28 kitabın resim yoğunluğu seçilir. Seçenekler: her sayfa / A1–A2 her sayfa + B1 ve üstünde bölüm başı / kapak + her 3 sayfada 1. Yazı resmin içinde değil, uygulamada çizilir. Resimsiz sayfalar da kitabın renk paletiyle renkli olur. |
| Ses | **ElevenLabs, önce pilot.** Bölümlerdeki gibi zaman damgalı TTS. Pilot ücretsiz kotayla ve yalnız iç kullanım için. 30 kitap ≈ 870 bin karakter, ticari plan gerekir (H-006). Plan ve maliyet ayrıca onaylanır. |
| Uzunluk | **Kısa kitap**, yatak öncesi bir oturuşta biter. Bölümlere ayrılır ve kaldığın yerden devam edilir. §4'teki tablo. |
| Konu | **Bağımsız kitaplar, karışık türler.** Her seviyede 5 ayrı tür: gizem, macera, mizah, bilimkurgu/fantastik, günlük hayat/duygu. Hepsi özgün. Port Lumen kanonuna bağlı değil. |
| Katalog ve pilot | 30 kitaplık katalog onaylı (`kitaplar/KATALOG.md`). Pilot kitaplar: A1-K01 *The Blue Door* (gizem) ve A2-K03 *The Parrot Who Told Everything* (mizah). Yerleşim: Hikâye sekmesinde "Macera · Kitaplık" (2026-10-14). |
| Pilot sonrası (2026-10-14) | Pilot onaylandı. Kalan 28 kitapta resim: **kapak + bölüm başı** (~180 görsel ≈ 90 kr). Ses: **ElevenLabs Creator** (~22 USD/ay, ~100 bin karakter, ticari lisans; kullanıcı hesabı açar). Uzun basma: sesli modda kelime → Defter, sessiz modda cümle → seslendir. |
| Ses lisansı (2026-10-14) | Kullanıcı kararı (hukukçu görüşü): ücretsiz ElevenLabs hesaplarıyla üretilen sesler yayında kullanılabilir; ticari planla yeniden üretim gerekmez. |
| C2 | Kullanıcı C2'yi de istedi. Belgelerdeki seviye tablosu C1'de bitiyordu; Kitaplık için C2 eklenir (§4, §6). |

## 3. Dünyadaki örnekler (2026-10-14 taraması)
- **Beelinguapp:** Sesli kitapta karaoke tarzı cümle vurgusu ve yan yana çeviri. Bizde çeviri yan yana durmaz; dokununca anlam paneli açılır (K-03 ile aynı dil).
- **LingQ:** Dinle + oku, kelimeye dokununca anlam ve sesi, kelimeyi tekrar listesine ekleme, tek cümle modu. Bizde tekrar listesi defter + FSRS ile yapılır.
- **Readle:** Kelimeye dokununca sözlük, cümle cümle dinleme.
- **Apple Books / EPUB 3 Media Overlays:**
  - Sesli okumada kelime, cümle ya da vurgusuz okuma seçilebilir.
  - Metin parçası ile ses aralığı SMIL'de eşlenir.
  - Apple'da yalnız sabit yerleşimli kitaplarda çalışır.
  - Bizim biçimimiz aynı fikri JSON'la uygular: cümle ve kelime → başlangıç/bitiş sn.
- **Graded reader yayınevleri (Oxford Bookworms, Penguin Readers):**
  - Seviyeyi başlık kelime, yapı ve kitap uzunluğuyla belirler.
  - Bizim uzunluklar bilinçli olarak daha kısa: uygulama içi, bir oturuşluk.

Kaynaklar:
- [Beelinguapp (App Store)](https://apps.apple.com/app/beelinguapp-learn-languages/id1225056371)
- [Beelinguapp incelemesi](https://www.alllanguageresources.com/beelinguapp/)
- [Apple Books Asset Guide: read aloud](https://help.apple.com/itc/booksassetguide/en.lproj/itc6db639756.html)
- [EPUB Media Overlays 3.2](https://www.w3.org/publishing/epub32/epub-mediaoverlays.html)
- [LingQ](https://apps.apple.com/app/id379385811)
- [OUP graded readers](https://www.oupjapan.co.jp/en/gradedreaders/bookworms.shtml)

## 4. Seviye ve uzunluk (kısa kitap)
| Seviye | Kelime (yaklaşık) | Sayfa | Bölüm | Dinleme | Anlatım hızı | Cümle | Kelime listesi |
|---|---|---|---|---|---|---|---|
| A1 | ~700 | 10–12 | 2–3 | ~6–7 dk | ~100–110 k/dk | ≤ 8 kelime | CEFR-J A1 |
| A2 | ~1.500 | 14–16 | 3–4 | ~12–13 dk | ~115–125 | ≤ 12 kelime | CEFR-J ≤A2 |
| B1 | ~3.000 | 18–20 | 4–5 | ~22 dk | ~130–140 | bağlaçlı | CEFR-J ≤B1 |
| B2 | ~5.000 | 22–24 | 5–6 | ~33 dk | ~145–155 | serbest | CEFR-J ≤B2 |
| C1 | ~8.000 | 26–28 | 6–7 | ~50 dk | ~160 | doğal | CEFR-J + Octanove C1 |
| C2 | ~10.000 | 28–30 | 7–8 | ~60 dk | doğal | doğal, üslup | CEFR-J + Octanove C1/C2 |

- **Kapsama kuralı (K-07):** Hedef ≥ %98, alt sınır %95. %95'e yalnızca sözlükle ve görselle desteklenirse izin verilir. Özel isimler sayılmaz.
- **C1/C2 kelime listesi:** Octanove C1/C2 (CC BY-SA 4.0) **ayrı veri seti** olarak eklenir; özgün metinlerimiz share-alike'a girmez (`docs/LISANS-RAPORU.md`).
- **Yasak kaynaklar:** Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC kullanılmaz ve LLM istemine konmaz.
- **Toplam:** ~145 bin kelime ≈ 870 bin karakter ses. Görsel sayısı pilottan sonra seçilen yoğunluğa göre: ~210 / ~320 / ~635 görsel, yani ≈ 105 / 160 / 320 kr.

## 5. Kitap içeriği ve kalite
- **Özgün metin; uyarlama ve gerçek marka yok.** 13+ güvenli (§5.5): şiddet, cinsellik, siyaset, din yok; gerçek kişi ya da ünlü yok.
- **Merak motoru (sıkmama):**
  - İlk sayfada bir soru açılır.
  - Her bölüm sonu küçük bir kanca taşır.
  - Son, sürprizli ama adil olur.
  - Karakterin bir isteği ve bir engeli vardır.
  - Seviye düştükçe olay basitleşir, gerilim düşmez.
- **Türk öğrenciye özel:** Tipik hatalar (*I am agree*, -s takısı, *the*) uygun yerlerde ve sözlükte not edilir.
- **Türkçe:**
  - Her cümlenin onaylı Türkçesi ve öbek çevirileri bulunur.
  - Seviye üstü kelimelerin Türkçe karşılığı ve örnek cümlesi sözlüktedir.
  - Bölümlerdeki `ceviri.tr.json` biçiminin kitap karşılığı kullanılır.
- **Akış:** Claude yazar → deterministik `book-lint` (kapsama, cümle uzunluğu, sözlük, çeviri durumu) → **kullanıcı onayı** (H-028) → editör toplu kontrolü.
- **Seslendirme:**
  - Tek anlatıcı.
  - Diyaloglarda en fazla 2 ek karakter sesi olabilir; pilotta tek anlatıcıyla başlanır.
  - Seviye hızına uygun ses, -16 LUFS.
- **Görseller:**
  - GPT Image 2.5, 9:16 ya da 3:4, düşük kalite (H-024).
  - Kitap başına sabit stil öneki ve karakter tanımı.
  - Görselde yazı yok.
  - Her istem ve maliyet `kitaplar/<id>/PROMPTS.md`'ye yazılır.
  - Her üretimden önce maliyet gösterilir ve onay alınır.

## 6. Kitap paketi (H-066'da kesinleşti, 2026-10-14)
**Kimlik:** `<SEVİYE>-K<2 hane>`, klasör `kitaplar/<SEVİYE>-K<2 hane>-<kisa-baslik>/` (ör. `kitaplar/A1-K01-the-blue-door/`). Bölüm kimlikleriyle (`A1-001`) çakışmaz. `_` ile başlayan klasörler (`kitaplar/_maliyet/`) kitap değildir.

### 6.1 Kaynak klasör
| Dosya | İçerik | Git |
|---|---|---|
| `book.json` | Meta veri; şema `tools/content-pipeline/schema/book.schema.json` (aşağıda) | depoda |
| `text.en.md` | Sayfa sayfa İngilizce metin (işaretler §6.2) | depoda |
| `ceviri.tr.json` | Bölümlerdeki biçimin aynısı: `status` (`DRAFT`/`APPROVED`), `lines[]` (`en` = cümlenin birebir metni, `tr`, `chunks[]`, `words{}`, `source` = cümle kimliği), `phrases[]`. Bölüm başlıklarının da satırı olur. | depoda |
| `glossary.md` | Tablo: `\| Kelime \| Türkçe \| Örnek \| Not \|`. Türkçe zorunlu, örnek önerilir. Buradaki kelimeler kapsama hesabında "sözlükle açıklanmış" sayılır. | depoda |
| `rights-and-review.md`, `PROMPTS.md` | Haklar, onay geçmişi; her görsel istemi ve **her TTS çağrısı** (`tts_book.py` satır ekler) | depoda |
| `audio/<bölüm>.align.json` | ElevenLabs hizalaması + `text`, `textSha256`, `voice_id`, `model_id`, `speed` | depoda |
| `audio/<bölüm>.mp3` | Bölüm sesi | **git dışı** |
| `audio/_parts/` | Uzun bölümlerin ödenmiş parça önbelleği (yeniden ödeme olmasın diye) | **git dışı** |
| `images/` | Sayfa ve kapak görselleri (PNG/JPG) | **git dışı** |

**`book.json` alanları:** `schemaVersion` (1), `id`, `slug` (= klasör adı), `level` (A1–C2), `genre` (`mystery` Gizem · `adventure` Macera · `humor` Mizah · `scifi-fantasy` Bilimkurgu/fantastik · `everyday` Günlük hayat/duygu), `title`, `titleTr`, `blurbTr` (Türkçe tanıtım), `hookEn`, `contentVersion`, `status` (K-05 durumları), `aiGenerated`, `palette` (`background`, `text`, `accent`, isteğe bağlı `surface`, `highlight`; `#RRGGBB`), `cover` (images/ altındaki dosya adı ya da `null`), `properNouns` (kapsamaya ve kelime anlamı zorunluluğuna girmez), `narration` (`voiceId`, `modelId`, `speed`, isteğe bağlı `pacing` = anlatım temposu §6.5; anahtar asla burada değil), `chapters[]` → `id` (`c1`…), `title`, `titleTr`, `pages[]` → `id` (`p01`…, kitap boyunca tekil ve sıralı), `image` (dosya adı ya da `null` = resimsiz, palet renkli sayfa).

### 6.2 `text.en.md` işaretleri
```
# The Blue Door                 ← isteğe bağlı; book.json title ile aynı
> Yorum satırı                  ← sese ve denetime girmez
## [c1] A New Home              ← bölüm başı; başlık seslendirilir (sesin ilk cümlesi)
### [p01]                       ← sayfa başı
Lina has a new home. It is old.
                                ← boş satır = paragraf sonu
She likes it.
```
- Gövde düz metindir; `* _ \` [ ]` kullanılmaz (lint hatası).
- Cümleler `. ! ? …` (ve ardından gelen tırnak) ile biter. *Mr., Mrs., Dr., St., e.g., i.e., a.m.* gibi kısaltmalar, rakamdan önceki *No. 3 / p. 12* ve ondalık sayılar bölünmez. Baş harf (*A. Serra*) yalnız sonraki sözcük `properNouns`'ta (ya da `data/proper_nouns.txt`'te) ise, önünde bir unvan varsa (*Ms A. Vale*) ya da başka bir baş harfle birlikteyse (*J. R. Hale*) bölünmez; "This is E. Meet me…" iki cümledir (H-073, `hvpipeline/sentsplit.py`). Özel adlar Unicode harfle okunur: *Lucía, Tomás, Zoë, Şebnem, Çağrı, Ömer* tek ad sayılır. Alıntıdan sonra **küçük harfle** devam eden konuşma eki aynı cümledir (`"Stop!" says Lina.`); büyük harfle devam ederse iki cümle olur (`"Stop!"` · `Lina says.`).
- Bölümün ses metni: `Başlık.` + boş satır + paragraflar (boş satırla). `tts_book.py` bunu gönderir; `textSha256` bu metnin özetidir.

### 6.3 Paket: `_build/package/`
| Dosya | İçerik |
|---|---|
| `book.json` | Kaynak meta verinin yayın alanları (aynı şema) + `cover` (`images/cover.webp`), `wordCount`, `pageCount`, `estimatedMinutes`; bölümlerde `audio` (`audio/<bölüm>.m4a` ya da `null`) ve `duration` (sn); sayfalarda `image` = `images/<sayfa>.webp` ya da `null`. `narration` ve `properNouns` pakete girmez. |
| `pages.json` | Şema `schema/pages.schema.json`. `chapters[]`: `id`, `title`, `audio`, `duration`, `heading` (seslendirilen başlık cümlesi), `pages[]` (kimlikler). `pages[]`: `id`, `number`, `chapter`, `image`, `sentences[]` → `id` (`p01-s01`; başlıkta `c1-h`), `paragraph`, `text`, `start`, `end`, `tr`, `words[]` (`w`, `start`, `end`, `gloss`), `chunks[]` (`en`, `tr`, `startWord`, `endWord`). Zamanlar sn, bölüm sesinin başına göre. Hizalama yoksa `start`/`end` `null` (sessiz okuma). |
| `audio/<bölüm>.m4a` | Anlatım temposu uygulanmış ses (§6.5). AAC 96k; kitabın bütün bölümleri (tempo **sonrası**) birlikte ölçülür, tek kazanç, hedef **-16 LUFS**, sınırlayıcı ≈ -1,5 dBFS (`media.audio_clip`). Ses düzeyi her zaman son adımdır. |
| `images/<sayfa>.webp`, `images/cover.webp` | 1080 px genişlik, oran korunur, WebP q80, yazısız. |
| `manifest.json` | `contentType: "BOOK"`, `contentVersion`, `tool`, `textSha256` (bölüm başına), `loudness`, `pacing` (bölüm başına `mode`, `sentencePauseSec`, `tempo`, `insertedSec`, `applied`, `wpmRaw`, `wpm`), `missing[]` (bu ortamda bulunmayan ses, hizalama, görsel), `files[]` (`path`, `bytes`, `sha256`), `totalBytes`. |

- **Zamanlama** `hvpipeline/align.py` → `sentence_timings`: **cümle düzeyinde** (bölüm altyazısındaki gibi kısa parçaları birleştirmez). Hizalama ile metin boşluk ve tırnak biçimi dışında birebir eşleşmelidir; metin TTS'ten sonra değişirse lint ve dışa aktarma hata verir (sesi yeniden üret).
- **Eksik medya:** ses ve görseller git dışında olduğundan CI'da yoktur. Paket yine üretilir, eksikler `manifest.missing`'e yazılır ve UYARI olarak gösterilir; `--require-media` ile hata olur.
- **Geliştirme sunucusu:** `/books/index.json` ve `/books/<kitapId>/<yol>` (Range destekli), `tools/dev-content-server/serve.py --books-root kitaplar`.

### 6.4 Araçlar
```bash
P=tools/content-pipeline/.venv/bin/python
$P tools/content-pipeline/book_lint.py kitaplar/A1-K01-*          # denetim (ücretsiz)
$P tools/content-pipeline/tts_book.py kitaplar/A1-K01-*           # KURU çalışma: karakter + tahmini kredi
$P tools/content-pipeline/tts_book.py kitaplar/A1-K01-* --execute # ÜCRETLİ: maliyet onayından sonra
$P tools/content-pipeline/export_book.py kitaplar/A1-K01-*        # paket (yerel ffmpeg + ImageMagick; anlatım temposu §6.5)
```

**book-lint kuralları**

| Kod | Kural | Düzey |
|---|---|---|
| `book-schema`, `book-id`, `book-files` | `book.json` şeması; klasör adı = `slug`, kimlik seviyeyle başlar; `text.en.md`, `glossary.md`, `rights-and-review.md`, `PROMPTS.md` var | Hata |
| `book-text`, `book-structure`, `book-page-empty` | İşaretler doğru; bölüm/sayfa kimlikleri, sırası ve bölüm başlıkları `book.json` ile birebir; her sayfada metin var | Hata |
| `book-length` | Sayfa ve bölüm sayısı §4 aralığında | Uyarı |
| `book-words` | Kelime sayısı seviye hedefi ± %20 (A1 560–840, A2 1.200–1.800, B1 2.400–3.600, B2 4.000–6.000, C1 6.400–9.600, C2 8.000–12.000) | Hata |
| `coverage`, `off-list` | K-07: ≥ %98; %95–98 yalnızca `glossary.md` ile %98'e tamamlanırsa (uyarı). A1–B2 kümülatif CEFR-J; C1/C2 CEFR-J + Octanove C1/C2 (ayrı CC BY-SA dosyası). Octanove dosyası yoksa C1/C2 için **"liste yok; kapsama denetlenmedi"** uyarısı. Özel adlar (`properNouns`, `data/proper_nouns.txt`) ve ünlemler sayılmaz. | Hata / uyarı |
| `sentence-length` | A1 ≤ 8, A2 ≤ 12 kelime | Hata |
| `glossary-meaning`, `glossary-example`, `glossary-unused` | Türkçe zorunlu; örnek cümle ve metinde geçme önerilir | Hata / uyarı / uyarı |
| `translation` | Her cümlenin (başlıklar dahil) çeviri satırı ve özel ad dışındaki her kelimenin anlamı; durum `APPROVED` değilse uyarı; bulunamayan kalıp uyarı | Hata / uyarı |
| `book-align` | Hizalama metinle uyuşuyor (uyuşmazsa hata); `textSha256` farklıysa uyarı | Hata / uyarı |
| `book-audio`, `book-media` | Hizalama henüz yok; ses ya da görsel bu ortamda yok (git dışı medya) | Uyarı |
| `book-speed` | Anlatım hızı, **anlatım temposundan sonra** (§6.5) seviye aralığının ± %10'u dışında. Ham hız da raporlanır (`hız c1 105 k/dk (ham 168)`); `narration.speed` ya da `narration.pacing` ayarlanır | Uyarı |
| `book-pacing` | `narration.pacing` geçersiz (bilinmeyen mod; manual tempo 0,85–1,25 dışında) | Hata |

**TTS betiği (`tts_book.py`)**
- ElevenLabs `POST /v1/text-to-speech/{voice}/with-timestamps`, `mp3_44100_128`, `language_code: en`, model `eleven_v3`, `stability` 0.5, `similarity_boost` 0.75 (bölümlerle aynı). **Hız başlangıç değerleri:** A1 0.90 (bölümlerde ~107 k/dk ölçüldü; kitapta 144–168 çıktı, dışa aktarmada anlatım temposuyla düzeltilir, §6.5), A2 0.95, B1 1.00, B2 1.00, C1 1.05, C2 1.05; `book.json → narration.speed` ile değişir, gerçek hız book-lint'te ölçülür.
- **Anahtar** yalnızca `ELEVENLABS_API_KEY` ortam değişkeninden, yalnızca `--execute` ile okunur; hiçbir dosyaya ve loga yazılmaz.
- **Varsayılan kuru çalışma:** API çağrılmaz; bölüm başına karakter, parça sayısı ve tahmini kredi yazılır (eleven_v3 ≈ 1 kredi/karakter, tahmin).
- **Aylık karakter tavanı:** `HIVELZON_TTS_MONTHLY_CHAR_CAP` ya da `--monthly-char-cap`. **Tanımlı değilse `--execute` reddedilir.** Her parçadan önce `kitaplar/_maliyet/elevenlabs-karakter.json` defteriyle (ay → karakter, çağrı) denetlenir; aşılacaksa çağrı yapılmadan durur.
- **İdempotent:** `.mp3` + `.align.json` var ve `textSha256` güncel metinle aynıysa bölüm atlanır. Uzun bölüm paragraf sınırında parçalara bölünür (eleven_v3 için istek başına 3.000 karakter varsayıldı); parçalar `audio/_parts/` önbelleğinden yeniden kullanılır, 0,4 sn arayla birleştirilir, hizalamalar kaydırılarak birleşir.
- Her gerçek çağrı `PROMPTS.md` → "Seslendirme kayıtları" tablosuna (tarih, bölüm, parça, ses, model, hız, karakter, metin sha256, dosya) eklenir.

**Backend:**
- İçerik türü olarak `BOOK` eklenir.
- Seviyeye C2 eklenir.
- İçe aktarma ve `/admin` onayı genişletilir (K-05 durum makinesi aynen).

### 6.5 Anlatım temposu (H-069, 2026-10-14)
**Sorun:** ElevenLabs `speed` yeterince inmiyor. A1-K01 0.9 ile seslendirildi, ama 144–168 k/dk ölçüldü; hedef 100–110. Yeniden üretim ücretli. **Çözüm ücretsiz ve dışa aktarmada:** `tools/content-pipeline/hvpipeline/pacing.py` + `media.pace_audio`.

- **Ayar:** `book.json → narration.pacing` = `{"mode": "auto" | "manual" | "off", "sentencePauseSec": sayı, "tempo": sayı}` (şema: 0–3 sn, tempo 0.85–1.25).
  - Alan yoksa **seviye varsayılanı** kullanılır: A1–B1 `auto`, B2–C2 `off` (`book.BOOK_LEVELS[...]["pacing"]`).
  - `auto`: Her bölüm için seviye aralığının **ortası** hedeflenir: A1 105, A2 120, B1 135 k/dk. Önce cümle arası duraklama denenir (en çok 1,2 sn). Yetmezse tempo düşürülür (en az 0,85). Hiçbir zaman hızlandırmaz: kayıt zaten yavaşsa ses olduğu gibi kalır. Bu modda verilen sayılar yok sayılır.
  - `manual`: `sentencePauseSec` (varsayılan 0,6) ve `tempo` (varsayılan 1,0) olduğu gibi uygulanır.
  - `off`: ses olduğu gibi kalır (eski davranış).
- **Duraklama:** `sentencePauseSec`, iki cümle arasındaki **toplam** sessizliğin alt sınırıdır. Kayıttaki doğal boşluk (tempo sonrası) kısaysa fark kadar sessizlik eklenir; uzunsa ekleme yapılmaz. Paragraf sınırında ×1,25, sayfa sınırında ve bölüm başlığından sonra ×1,5.
- **Kesim:** Kesim noktası cümle sonu (son karakterin bitişi) ile sonraki cümlenin başı arasındadır. Ses zarfındaki en sessiz 10 ms seçilir. ElevenLabs hizalaması gerçek sessizlikten ~0,1 sn kayabiliyor (A1-K01'de ölçüldü: "dear." sönümü hizalama boşluğuna taşıyor). Bu yüzden boşluk -40 dB'den sessiz değilse arama ±0,25 sn genişler; iki cümlenin ortasını geçmez. Eklenen sessizliğin iki yanında ≤ 8 ms yumuşak geçiş vardır.
- **Tempo:** ffmpeg `atempo` perdeyi korur. Parça parça uygulanır; eklenen sessizlik yavaşlatılmaz.
- **Zamanlar:** Her parça tempo sonrası tam `round(N / tempo)` örneğe doldurulur ya da kırpılır, ardından tam sessizlik eklenir. `pages.json` zamanları örnek düzeyinde kesindir: yeni zaman = t / tempo + önceki eklenen sessizlikler. Her cümlenin zamanı kendi parçasına sıkıştırılır, bu yüzden vurgu eklenen duraklamaya düşmez. Bölüm `duration` işlenmiş sesin süresidir. Ses bu ortamda yoksa plan hizalamadan kurulur; zaman eşlemesi kesim yerinden bağımsız olduğu için aynı zamanlar çıkar.
- **Sıra:** hizalama → tempo planı → kesim + sessizlik + atempo (geçici WAV, float) → birleşik ses düzeyi ölçümü → tek kazanç + sınırlayıcı → AAC. **-16 LUFS son adımdır.** Süreç deterministiktir: aynı girdiyle ikinci dışa aktarma bayt bayt aynı `pages.json` ve `.m4a` üretir.
- **book-lint** aynı planı hizalamadan kurar. `book-speed` tempo sonrası hızı denetler ve ham hızı da yazar.

**A1-K01 sonucu** (2026-10-14, `auto`, yalnız duraklama; tempo gerekmedi):

| Bölüm | Ham | Sonra | Duraklama | Tempo | Eklenen sessizlik | Süre |
|---|---|---|---|---|---|---|
| c1 | 168 k/dk | 105,0 | 1,17 sn | 1,0 | 65,1 sn | 109,1 → 174,2 sn |
| c2 | 144 | 105,1 | 0,93 | 1,0 | 34,3 | 92,4 → 126,7 |
| c3 | 154 | 104,9 | 1,01 | 1,0 | 43,5 | 93,3 → 136,7 |

- **Ses düzeyi:** -16,04 LUFS (bölüm başına -15,93 / -16,29 / -15,94; kazanç -2,34 dB), gerçek tepe en çok -5,38 dBTP, örnek tepe -5,40 dBFS; kırpılma yok, sınırlayıcı devreye girmedi.
- **Doğrulama:**
  - İşlenmiş sesin her parçası, kaynakla planlanan yerde ±1 örnekte (8 kHz) eşleşiyor. Korelasyon ≥ 0,96; fark yalnızca kayıplı kodlamadan.
  - Eklenen sessizlik gerçekten sessiz.
  - Bütün kesimler kaynakta en büyük seviyenin en az 41 dB altında; ortanca -62…-68 dB.
- **Not:** Seslendiricinin kendi konuşma hızı yüksek (cümle içinde ~165–190 k/dk). Ortalama hız duraklamalarla hedefe iniyor; cümle içi hız değişmiyor. Kullanıcı dinleyip cümle içini hızlı bulursa `manual` ile tempo 0,9 denenebilir: duraklama azalır, cümle içi yavaşlar.

## 7. Uygulama deneyimi (H-067'de uygulandı, 2026-10-14)
Kod: `mobile/lib/features/library/` (alan modeli `domain/`, okuyucu durumu `application/reader_controller.dart`, ekranlar `presentation/`). Metinler: `ARAYUZ-METINLERI.md` §4.6–4.7.
**Yer:**
- **Hikâye** sekmesinde iki bölüm: "Macera" (harita) ve "Kitaplık". Sekme sayısı değişmez (K-30).
- Ana Sayfa'daki tek eylem ilkesi korunur. Kitap, Hi'nin önerisi olarak görünür (H-067). Ana Sayfa'daki ikincil "yarım kitap" kartı henüz yok (sonraki iş).
- Kısa ekranda (yükseklik < 600) Hikâye sayfasının başlığı ve seçici haritayla birlikte kayar; harita yine ekran boyu yer alır.
- Yerleşim kullanıcı onaylı (2026-10-14, H-065).

**Kitaplık ekranı:**
- **Raflar:** "Okumaya devam et" (yarıda kalanlar, yüzdesiyle; son okunan önce), "Senin seviyen" (yerleştirme sonucu, yoksa A1), diğer seviyeler ("A2 kitapları"), "Okuduklarım". Seviye raflarında o seviyenin bütün kitapları durur (yarım/biten kart halkası ya da onayla). Yüzde sayfaya göredir; başlanmış kitapta en az %1.
- **Kitap kartı:** kapak, tür, süre, seviye, ilerleme halkası.
- **Rastgele kitap:** "Bana bir kitap oku" düğmesi → seviye seç (varsayılan önerilen seviye; yalnız kitabı olan seviyeler) → **hiç açılmamış** kitaplardan biri seçilir ve sesli açılır. Yarım ya da biten kitap seçilmez; kalmadıysa sakin not ("Bu seviyede açmadığın kitap kalmadı") ve başka seviye seçilebilir.
- Kitaplar `ContentSource.listBooks()` / `loadBook()` ile okunur (geliştirme sunucusu `/books/index.json`, `/books/<kitap>/book.json` + `pages.json`). Yükleniyor (iskelet), boş ve bağlantı hatası (Tekrar dene) durumları var.

**Okuyucu:**
- **Sayfa:** Renkli kitap sayfası (zemin, yazı ve vurgu `palette`'ten; yazı/zemin ve yazı/vurgu en az 4,5:1, tutmayan renk belirteçle değişir); üstte resim (ekranın ~%38'i), altta metin; bölümün ilk sayfasında "Bölüm N" ve seslendirilen bölüm başlığı. Resimsiz sayfada küçük vurgu çizgisi. Sayfa kaydırarak ya da düğmeyle çevrilir (400 ms kayma); "Hareketi azalt" açıksa kaymadan.
- **Sesli mod:**
  - Okunan **cümle** vurgulanır (cümle zemini). Kelime vurgusu ayarla açılıp kapanır (okunan kelimenin altı çizilir; yerleşim kaymaz). Varsayılan: kapalı.
  - **Eşleme:** her 50 ms'de ses konumu tahmin edilir (son örnek + geçen süre × hız), her 200 ms'de çalardan taze örnek alınır; vurgu sesin en fazla ~0,1 sn gerisinde kalır (kabul ≤ 0,2 sn, testle ölçülür). İki cümle arasındaki sessizlikte önceki cümle vurgulu kalır.
  - Bölüm bitince sıradaki bölümün sesi açılır ve sürer; son bölüm bitince kitap biter.
  - Sayfa sonunda sayfa kendiliğinden çevrilir.
  - **Okunan yeri izleme:** okunan cümle metin alanının konforlu bandından (üst ~%80) çıkacakken sayfa yumuşakça kaydırılır; cümle üst üçte bire yakın durur ("Hareketi azalt" açıksa atlayarak). Her cümlede kaydırılmaz. Kullanıcı kaydırınca izleme durur, "Okunan yere dön" çipi çıkar; ~4 sn kaydırma olmazsa, çipe, Dinle'ye, sayfa düğmesine ya da bir cümleye dokununca izleme sürer. Yeni sayfa en üstten açılır.
  - **Bölüm bölüm ses:** kitabın sesi bölüm bölüm hazırlanabilir (ör. ücretsiz TTS kotası biterse). En az bir bölümün sesi varsa kitap sesli okunabilir; sesli okuma sesi olmayan bölüme gelince durur, sessiz moda geçer, o bölümün ilk sayfasında kalır ve bir kez sakin not çıkar ("Bu bölümün sesi henüz hazır değil; kendin okuyabilirsin."). Sesi olmayan bölümde "Sesli" seçmek aynı notu gösterir. "Bana bir kitap oku", "Sıradaki kitabı aç" ve Hi'nin kitap önerisi ilk bölümünün sesi olan kitabı önce seçer (`index.json → firstChapterAudio`). Kitap kartında ayrı rozet yok.
  - Oynat/duraklat, 10 sn geri, hız 0,75 / 1 / 1,25.
  - **Uyku zamanlayıcısı:** bölüm sonunda ya da 10/20/30 dk. Geri sayım gösterilmez (K-32); dolunca ses durur ve bir kez sakin not çıkar. "Bölüm sonunda" seçiliyse kalınan yer sıradaki bölümün başı olur.
- **Sessiz mod:** Kullanıcı kendi okur ve sayfayı kendi çevirir; son sayfada "Kitabı bitir". Bir cümleye uzun basınca yalnız o cümle seslendirilir (çalarken vurgulu). Sesi olmayan ya da sesi açılamayan kitap sessiz açılır.
- **Uzun basma (karar, H-067):** sesli modda kelimeye uzun basmak kelimeyi tek dokunuşla Defter'e ekler (ses durmaz); sessiz modda uzun basmak o cümleyi seslendirir. İki istek aynı hareketi istiyordu; sesli modda cümle zaten okunduğu için uzun basma eklemeye, sessiz modda dinlemeye ayrıldı. Sessiz modda ekleme anlam panelindeki "Deftere ekle" ile yapılır.
- **Sayfanın Türkçesi (H-086):** üst çubukta ve sayfa sonunda "Sayfanın Türkçesi" düğmesi (sayfanın hiç Türkçesi yoksa gizli). Alttan panel sayfanın onaylı Türkçesini (`pages.json` cümle `tr`) cümle cümle, sırasıyla gösterir; bölümün ilk sayfasında başlık önce gelir, Türkçesi olmayan cümle atlanır. Panel açıkken ses durur, kapatılınca kaldığı yerden sürer. Paneldeki cümleye dokununca panel kapanır, İngilizce cümle vurgulanır ve görünür kılınır ("Hareketi azalt" açıksa atlayarak); sesli modda okuma o cümleden sürer (panelden önce çalıyorduysa), sessiz modda vurgu sayfa çevrilene kadar kalır. Çeviri yalnız okunup geçilmesin diye eşleşme İngilizceye geri götürür.
- **Satır altı Türkçe (H-086):** okuma ayarı, varsayılan kapalı (K-03), cihazda saklanır. Açıkken her İngilizce cümlenin altında Türkçesi küçük (okuma boyutunun 0,8 katı) ve soluk (`BookColors.muted`, zemine karşı ≥ 4,5:1) görünür; vurgu, okunan yeri izleme ve dokununca anlam paneli aynen çalışır.
- **Dokun:** Kelimeye ya da cümleye dokununca ses durur ve mevcut **anlam paneli** açılır (`shared/meaning/`): Türkçe, kelime sesi, "Sen de söyle" (H-055), "Deftere ekle". Panel kapanınca ses kaldığı yerden devam eder.
- **Bilmediğin kelimeyi Defter'e ekle (kullanıcı isteği 2026-10-14):**
  - Her kelime ve cümle Defter'e eklenebilir.
    - Kelimeye dokununca açılan panelde "Deftere ekle".
    - Kelimeye uzun basınca (sesli mod) tek dokunuşla ekleme ve küçük bir onay ("Deftere eklendi").
    - Panelde kelime, öbek ya da bütün cümle seçilebilir.
  - Kayıtta neler var:
    - Kelime;
    - Türkçesi;
    - kitaptaki örnek cümle;
    - kitap sesinden kesilmiş telaffuz;
    - kaynak: "Kitap: <başlık>, s. N".
  - Defter'de kitaba göre süzme yapılır.
  - Kartlar mevcut **Kelime tekrarı**na (FSRS) girer.
  - Kitap bitince "Bu kitapta kaydettiklerin" listesi gösterilir.
  - Aynı kelime ikinci kez eklenmez (idempotent).
  - Görsel yoksa kart kitap sayfasının resmini ya da kitap kapağını kullanır.
  - Uygulamada (H-067): kayıt `notebook_items` satırıdır, `source = book`, `source_title` = kitabın başlığı (Drift şema 6, eşitlenir), `content_id` = kitap kimliği, `cue_id` = cümle kimliği (sayfa numarası buradan), ses ve görsel yolu `_books/<kitap>/…` (kitap paketinden çalınır). Aynı ifade (tür + metin) ikinci kez eklenmez; kart yeni FSRS kartı olarak Kelime tekrarına girer.
  - Defter'de bütün satırların kaynağı yazılır: "Kitap: <başlık>, s. N", "Bölüm N'den ekledin" (kullanıcının bölümde eklediği), "Konu setinden". Kitaptan eklenen ifade varsa "Hepsi · Hikâyeden · <kitap>" çipleriyle süzülür.
- **İlerleme:** Kitap, bölüm, sayfa ve son cümle cihazda saklanır, hesap varsa eşitlenir. "Bitti" kazanır (H-056 kuralı).
  - Tablo `user_book_progress` (mobil Drift şema 6, backend Flyway V8): `book_id`, `status` (NOT_STARTED / IN_PROGRESS / COMPLETED), `chapter_id`, `page_number`, `sentence_index` (−1: bölüm başlığı), `position_sec`, `started_at`, `completed_at`, `updated_at`. Okunan cümle her değiştiğinde yazılır (aynı yer ikinci kez yazılmaz).
  - Eşitleme: durum hiçbir zaman geri gitmez (mobil `SyncStore`, backend `ProgressMerger.forBooks()`); aynı durumda son yazan kazanır; biten kopyanın kalınan yeri korunur.
  - Yarım kitap kaldığı cümleden açılır (sesli modda o cümlenin başından okunur). Biten kitap baştan açılır, durumu "bitti" kalır.
- **Hi:** yarım kitap (`continueBook`) yarım bölüm, tekrar (≥ 5) ve Hi'nin notundan sonra; kitaba başlamak (`startBook`, önerilen seviyede açılmamış ilk kitap) bütün öneriler bittikten sonra, dinlenmeden önce. Gerekçe görünür ("…%40 kadarını okudun; kaldığın cümleden devam edersin.").
- **Arka plan:** Ekran kilitliyken dinleme ve kilit ekranı denetimleri (H-068).
- **Bitiş:** Sakin kutlama, "Bu kitapta kaydettiklerin" listesi ve "sıradaki kitap" önerisi (aynı seviyede açılmamış kitap varsa "Sıradaki kitabı aç"); "Kitaplığa dön", "Baştan oku". Puan, lig ve geri sayım yok (K-32). "Bu kitaptan 5 ifade" kartı kitap içeriği gelince (H-069) ayrıca eklenebilir.
- **Erişilebilirlik:** Yazı boyutu ayarı (okuma için ayrı, 3 kademe: 18 / 21 / 25 px, sistem büyütmesi üstüne), dokunma hedefi en az 48, ekran okuyucu paragrafı metin olarak okur; ekran okuyucu açıkken her cümle ayrı düğmedir (dokununca anlam paneli). 320 × 568 ekranda 1,3× yazıda taşma yok.

## 8. Mevcut koddan yeniden kullanılacaklar
- **Zamanlama:** `tools/content-pipeline/hvpipeline/align.py` (ElevenLabs hizalama → cümle/kelime zamanı), `media.py` (-16 LUFS), `translation.py`, `cefr.py`, `lint.py` (kapsama kuralları).
- **Mobil:**
  - Anlam paneli: `mobile/lib/shared/meaning/` (`MeaningController`, `MeaningSheet`, `MeaningAudio` arayüzü).
  - Defter ve tekrar: `NotebookRepository`, FSRS.
  - Altyazı modeli: `features/player/domain/subtitles.dart` (`SubtitleWord` deseni).
  - Hi önerisi: `features/hi/domain/coach_rules.dart` (yeni öneri türleri `continueBook` / `startBook`).
  - Eşitleme: `shared/sync/` (yeni tablo `user_book_progress`, UUIDv5, LWW + "bitti kazanır").
  - Tasarım: `shared/ui/` bileşenleri.
- **Backend:** `CatalogImportService`, `/admin` onay ekranı (H-041), genel `/api/v1/sync`.
- **Eksik olanlar (yeni):**
  - Sesli kitap oynatıcısı. Bugün yalnız `video_player` var; arka plan ve kilit ekranı yok.
  - Kitap paketi biçimi.
  - C1/C2 kelime listesi.
  - C2 seviyesi: veritabanı kısıtı ve lint.
  - TTS betiği. Bugüne kadar seslendirme elle yapıldı.

## 9. Fazlar ve işler
| Faz | İş | Kapsam | Kabul | Maliyet |
|---|---|---|---|---|
| K0 | **H-065** Kitaplık kararları ve 30 kitaplık katalog | Bu belgenin kesinleşmesi; 30 kitabın başlık, tür, tek cümlelik kanca ve karakter listesi; yerleşim ve okuyucu taslağı (kodla çizilmiş tel çerçeve) | Kullanıcı kataloğu ve yerleşimi onaylar | 0 |
| K1 | **H-066** Kitap paketi ve içerik boru hattı | `book.json` / `pages.json` şeması; `book-lint` (kapsama A1–C2, cümle uzunluğu, sözlük, çeviri); Octanove C1/C2 ayrı veri seti; ElevenLabs TTS betiği (zaman damgalı, idempotent, bütçe kontrolü, maliyet kaydı, anahtar repo dışında); WebP ve m4a dışa aktarma; dev içerik sunucusuna `/books/` | pytest yeşil; örnek kitapla paket üretilir | 0 |
| K2 | **H-067** Kitaplık ve okuyucu (mobil) | Kitaplık ekranı, okuyucu (sesli/sessiz, cümle ve kelime vurgusu, otomatik sayfa çevirme, dokun → anlam paneli, hız, uyku zamanlayıcısı), **bilmediğin kelimeyi Defter'e ekleme → Kelime tekrarı**, "Bana bir kitap oku", ilerleme tablosu + eşitleme, Hi önerisi | Kitaptan eklenen kelime Defter'de kaynağıyla görünür ve tekrara girer; testler yeşil; vurgu kayması ≤ 0,2 sn; golden; erişilebilirlik | 0 |
| K3 | **H-068** Arka planda dinleme | `just_audio` + `audio_service` (lisans kontrolü), iOS `UIBackgroundModes: audio`, Android medya bildirimi, kilit ekranı denetimleri | Ekran kilitliyken ses sürer; testler yeşil | 0 |
| K4 | **H-069** Pilot kitaplar (A1 + A2) | 2 kitap: metin → lint → çeviri → kullanıcı onayı → görseller (~30, ≈ 15 kr, maliyet onayı) → ses (ücretsiz kota, iç kullanım) → paket → simülatörde deneme | Kullanıcı pilotu dener; resim yoğunluğu ve ses planı kararı verilir | ≈ 15 kr |
| K5 | **H-070** Kitaplık arka ucu | İçerik türü `BOOK`, seviye C2, kimlik biçimi, içe aktarma, `/admin` onayı, katalog uç noktası | `mvn verify` yeşil | 0 |
| K6 | **H-071** Kitap dalgası 1: A1 + A2 (kalan 8) | Yazım, lint, çeviri, onay, görsel, ses, paket | 10 kitap onaylı | Seçilen yoğunluğa göre |
| K7 | **H-072** Kitap dalgası 2: B1 + B2 (10) | Aynı akış | 10 kitap onaylı | Aynı |
| K8 | **H-073** Kitap dalgası 3: C1 + C2 (10) | Aynı akış | 10 kitap onaylı | Aynı |

**Sıra ve paralellik:**
- H-065 hemen başlar; yalnız belge ve katalog işi.
- Tasarım yenilemesiyle (H-060…H-064) paralel yürüyebilecekler:
  - H-066 ve H-069'un metin kısmı;
  - H-067 (ayrı dalda).
- H-069 pilotu H-066 ve H-067'den sonra uygulamada denenir.
- Dalgalar (H-071…H-073) pilot kararından sonra gelir.
- Ses için ticari ElevenLabs planı yayından önce şarttır (H-006, H-044 ile birlikte).

**Kural:** Her ücretli üretimden önce maliyet gösterilir ve onay alınır. Aylık AI tavanı 300 USD'dir (H-003). Higgsfield kredisi şu an 60,06 kr; 25 kr'nin altına inince bir kez hatırlatılır.
