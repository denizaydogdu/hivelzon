# C2-K05 The Other Half of the Sentence: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1/C2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C2-K05 (özet, kanca, bölüm planı, son sürpriz, dil odağı) ve C2 "Seviye dil odağı"; `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 (G-C1-01…08) ve C2 (G-C2-01…06) konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "C2-K05 *The Other Half of the Sentence* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 8 bölüm (The Manuscript, Untranslatable, Istanbul, Childhood Turkish, Tuesdays, Chapter Nine, The Envelope, The Other Half), 30 sayfa, ~10.000 kelime (C2 hedefi 8.000–12.000). Birinci tekil şahıs anlatıcı Aylin Marsh (38), Manchester'da yaşayan İngiliz-Türk çevirmen; kuru mizahlı, kendini fazla ciddiye alan, babası hakkında yanılan (güvenilmez) bir anlatıcı. C2 dil odağı: ironi ve ima, üslup kayması (yayıncılık dilinin adlaştırmaları, hukuk dili, çocuk sesi, babanın kırık İngilizcesi), çevrilemeyen kavramlar (hüzün, gönül, kıyamamak), iki dilli sözcük oyunları (vapur / vapour, Dilek / dil, katılıyorum / I am joining), serbest dolaylı anlatım; uzun dengeli cümlelerle kısa keskin cümlelerin karşıtlığı. Babanın İngilizcesi bilinçli olarak kusurlu (I am agree, the eksikliği, -s hataları, am + fiil); düzeltilmez, sözlükte not edilir. C1 ve C2 yapıları doğal biçimde, her biri en az iki kez. Yas sakin ve ölçülü. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, kişi ve kurum adı yok; semt adları uydurma. Standart İngiliz İngilizcesi. Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla."

**Kanca kararı:** Katalogdaki kanca (*My father wrote nine chapters in Turkish and left the tenth, it seemed, to me.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. "it seemed" bilinçli bir güvenilmez anlatıcı işaretidir: herkes içindekiler sayfasındaki adı "bitir" talimatı sanar. Son sayfada cümle yeniden kurulur ve ters çevrilir: *My father wrote nine chapters in Turkish and one in English, and left the other half of the sentence, it turns out, to me.*

**Adil son için yerleştirilen ipuçları:**
- İçindekiler sayfasında onuncu satırda başlık ve numara yok; yalnızca elle, yeşil mürekkeple "Aylin" yazıyor (p02, p04). Yanlış okuma: herkes bunu "bitir" diye anlar (p02, p07).
- Annenin kesin yargısı: "he never learned a word of English" (p03); Aylin'in "my Turkish had not [grown]" itirafı (p03). (Yanıltıcı, ama sonradan çürütülür.)
- Kenar notları babanın el yazısıyla ve İngilizce: "Here she is angry but she is not angry. Is tired.", "Do not make beautiful. Make true.", "Ask A." (p08). Büyük A'yı çadır gibi yazması ve kalemi sert bastırması (p08; p24 ve p26'da yeniden).
- Masadaki kalın mavi İngilizce sözlük, sırtı nehir haritası gibi kırık; Selçuk Bey'in "For the crossword" demesi, oysa baba hiç bulmaca çözmezdi (p10–p11).
- Selçuk Bey: "of the language my daughter dreams in", "he wanted to be good at it first", "He took English lessons. Every Tuesday, for three years." (p12).
- "Baba için İngilizce" defteri; kelime listesi (apple, ferry, seagull, moon, I love you) ve her kelimenin yanında öğretmen işareti gibi küçük, düzgün kurşun kalem işaretleri; Aylin onları kendisinin koyduğunu sanıyor (p15). Arka kapakta Dilek Hanım'ın adresi (p15).
- Dilek Hanım: hataları "bilerek, mücevher gibi" yapması (p17); "my daughter lives in English … knock on the right one" (p18); son yıl "one long piece of homework … this one I will not be corrected" (p18).
- Zarf: "Dokuzuncu bölüm çevrilmeden açılmayacak"; beklenenden ağır (p19), "far too heavy to be a letter" (p22).
- Romanın dokuzuncu bölümü: Nevzat kızının dilinin sözlüğünü alır, ikinci yarıyı ilk kez anlar, "to arrive at the right door" (p20–p21); adı konmayan nesnenin bir okul defteri olduğu; son satır "The rest he would tell her in her own language." (p22).
- Kart: "For translator. Please, no correct." (p24); "For translator. Not for Aylin." (p25).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: 500 kredi yüklendi, "tüm yarım kalan işlerimizi yap … onay verdim". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 9 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p16.png`, `images/p20.png`, `images/p23.png`, `images/p27.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Watercolour and ink illustration, non-photorealistic, loose ink lines and soft watercolour washes on textured paper, elegant, melancholic but warm. Palette: seagull white, tea red, brick red, fog grey, deep grey-blue sea, small touches of green ink. Mood: quiet grief softened by warmth and gentle humour. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; handwriting and typed pages are drawn only as abstract wavy lines, book covers, spines and envelopes are blank, the ferries have no names or numbers. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Aylin:** 38-year-old woman, shoulder-length dark wavy hair loosely tied back, olive skin, strong dark eyebrows, tired thoughtful eyes; a grey wool jumper, a long dark green raincoat outdoors; reading glasses pushed up on her head.
- **Judith (her mother):** 71-year-old Englishwoman, small and brisk, short white hair, reading glasses on a cord round her neck, a bright mustard cardigan; lively, dryly amused face.
- **Baba (in memory only):** tall man in his forties, thick dark hair, dark moustache, a heavy grey wool coat; seen from the side or behind, face soft and partly turned away.
- **Little Aylin (in memory only):** 5-year-old girl in a yellow raincoat.
- **Selçuk Bey:** 76-year-old man, small and round, white moustache, kind eyes, a brown cardigan with leather patches on the elbows.
- **Dilek Hanım:** about 65, very short silver hair, a cardigan buttoned to the neck, round glasses, upright posture, a precise teacher's face.
- **Manchester:** a small kitchen with a rain-streaked window, red-brick terraced houses outside, a kettle, a pot of tea, a wooden table with a cardboard box of typed pages.
- **Kemerburnu (Istanbul):** a hillside neighbourhood on the Asian shore, a narrow tea-coloured apartment building, a small wooden ticket window on a pier, white ferries with dark funnels crossing grey water, seagulls, soft grey winter light.
- **Sakızlı Street:** a short steep lane of old wooden houses, washing lines strung between windows like a ship's rigging, a green door, a lemon tree in a pot far too small for it.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | A split composition that blends softly in the middle: on the left, Manchester rain over red-brick roofs; on the right, a grey Istanbul sea with a white ferry and seagulls. Aylin, small, seen from behind in her green raincoat, stands where the two halves meet, holding a few loose sheets of paper; one sheet drifts in the air between the two cities. The sheets show only abstract lines. |
| p01.png | p01 (Bölüm 1, The Manuscript) | Aylin at her kitchen table in Manchester on a rainy day, an open cardboard box of typed pages held with two black clips, a cup of tea, a kettle behind her; she is looking at the top page with a guarded expression. |
| p05.png | p05 (Bölüm 2, Untranslatable) | Night: Aylin at a desk surrounded by open dictionaries and sharpened pencils, her chin in her hand; in the steam rising from her glass of tea, a faint watercolour vision of a grey Istanbul pier with empty benches in winter. |
| p09.png | p09 (Bölüm 3, Istanbul) | Aylin with a suitcase on the pavement at the foot of a narrow tea-coloured building in Kemerburnu; below the hill, white ferries cross grey water and a small wooden ticket window stands on the pier; above her, Selçuk Bey opens a door, smiling. |
| p13.png | p13 (Bölüm 4, Childhood Turkish) | A soft, faded memory at dusk: a tall man in a grey wool coat carries a sleeping five-year-old girl in a yellow raincoat off a ferry; seagulls circle; in the background a man carries a tray of round bread rings on his head. The edges of the picture fade into white paper. |
| p16.png | p16 (Bölüm 5, Tuesdays) | A steep lane of old wooden houses with washing lines between the windows; Dilek Hanım opens a green door beside a lemon tree in a too-small pot, looking at Aylin on the step for a long moment. Late afternoon light. |
| p20.png | p20 (Bölüm 6, Chapter Nine) | Aylin translating at her desk in Manchester at night, a box of tissues beside a thick book; on the shelf above her, a large brown envelope wrapped in far too much tape, sitting like a patient cat; rain on the window. |
| p23.png | p23 (Bölüm 7, The Envelope) | Early morning in the kitchen: Judith in a raincoat buttoned over pyjamas, a paper bag of croissants on the table; she and Aylin sit facing each other with the sealed, heavily taped brown envelope between them, neither touching it. |
| p27.png | p27 (Bölüm 8, The Other Half) | The same kitchen, a little later: Judith rests her head on Aylin's shoulder; Aylin holds lined pages torn from school exercise books, covered in small green abstract wavy lines; croissants going cold; through the window, the rain is easing and a pale light comes in. |

**Sürpriz kontrolü:** Sonun sürprizi, onuncu bölümün kayıp olmadığı, babanın onu üç yıllık derslerin kırık İngilizcesiyle Aylin'in dilinde yazıp çevirmene bıraktığıdır. Hiçbir görselde okunur yazı yoktur; sayfalar, kenar notları ve kart yalnızca soyut çizgilerdir, bu yüzden hiçbir görsel yazının hangi dilde olduğunu göstermez. Sözlük ve kitaplar yazısız ve renksiz sırtlarla çizilir (İngilizce sözlük olduğu anlaşılmaz). Babanın ders aldığı, Dilek Hanım'la çalıştığı ya da yazı yazdığı hiçbir sahne görselleştirilmez; baba yalnızca p13'teki çocukluk anısında, yüzü yarı dönük görünür. Zarf p20 ve p23'te kapalıdır; p27'deki sayfalar yalnızca okul defteri yaprağı olarak görünür. Kapakta iki şehir arasında süzülen yaprak bir sembol olarak kalır.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 14e39983-f730-46ef-ad0d-c085fc583f62 | — | 2026-10-14T16:43:20+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | c7035bb6-1d18-43cc-ace1-c0ffeb2b9f88 | 14e39983-f730-46ef-ad0d-c085fc583f62 | 2026-10-14T16:51:53+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | a73eda01-391f-4895-b67c-6ab1277cb25f | 14e39983-f730-46ef-ad0d-c085fc583f62 | 2026-10-14T16:51:53+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | 3d6285d8-2911-4586-8486-94e049dab31c | 14e39983-f730-46ef-ad0d-c085fc583f62 | 2026-10-14T16:52:04+00:00 | 3:4, medium, 1k | 0.5 |
| p20.png | 51706246-6aa6-46e5-af74-68a8ddd6fa00 | 14e39983-f730-46ef-ad0d-c085fc583f62 | 2026-10-14T16:52:16+00:00 | 3:4, medium, 1k | 0.5 |
| p16.png | add557eb-487c-44a4-bd63-8450f28dbe8a | 14e39983-f730-46ef-ad0d-c085fc583f62 | 2026-10-14T16:52:18+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | be5c6fde-9310-47e8-8789-cdf02f3fc223 | 14e39983-f730-46ef-ad0d-c085fc583f62 | 2026-10-14T16:52:20+00:00 | 3:4, medium, 1k | 0.5 |
| p23.png | 2fc1859b-ba2e-400e-a214-b31dfbcf871d | 14e39983-f730-46ef-ad0d-c085fc583f62 | 2026-10-14T16:52:24+00:00 | 3:4, medium, 1k | 0.5 |
| p27.png | 98ec3a57-2b7f-4ed2-a67f-907247c8c148 | 14e39983-f730-46ef-ad0d-c085fc583f62 | 2026-10-14T16:52:36+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 4.5 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C2 başlangıç değeri; C2'de anlatım temposu varsayılanı `off`, hedef doğal hız ~155–160 k/dk, §6.5). Katalog notu: Türkçe kelimeler doğal telaffuz edilmeli; babanın İngilizcesi (kenar notları, kart, onuncu bölüm alıntıları) daha yavaş ve dikkatli okunur. Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-04T06:52:29Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1742 | 102.37 | fed839874218434ea88ea4916d3544b6 | 64aa61cfc2600933 |
| 2026-11-04T06:52:38Z | p01 | duyu-1 | - | - | - | 102.37 | - | 64aa61cfc2600933 |
| 2026-11-04T06:52:58Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 2021 | 128.86 | 0258b223521347a49033673f29162c08 | bb107c91d6151c11 |
| 2026-11-04T06:53:17Z | p02 | duyu-1 | - | - | - | 128.86 | - | bb107c91d6151c11 |
| 2026-11-04T06:53:40Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 1770 | 111.26 | fc4746944b2c4151a9b7d24678c86814 | 1ce2dff93f685f5c |
| 2026-11-04T06:54:04Z | p03 | duyu-1 | - | - | - | 150.6 | - | 1ce2dff93f685f5c |
| 2026-11-04T06:54:21Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1538 | 93.97 | 93d8ad0094ba4e94a7fd25e864e9096f | 8fb0b115dba5b991 |
| 2026-11-04T06:54:34Z | p04 | duyu-1 | - | - | - | 93.97 | - | 8fb0b115dba5b991 |
| 2026-11-04T06:54:50Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1474 | 91.48 | 32c9fe0d978f48e28d3e46485db1f260 | 10e717fd77d4ff83 |
| 2026-11-04T06:54:58Z | p05 | duyu-1 | - | - | - | 91.48 | - | 10e717fd77d4ff83 |
| 2026-11-04T06:55:17Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1658 | 107.01 | 140cf99c24954882931e3d2d81a3b8e8 | 85a907eb8b12d184 |
| 2026-11-04T06:55:26Z | p06 | duyu-1 | - | - | - | 107.01 | - | 85a907eb8b12d184 |
| 2026-11-04T06:55:44Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 1590 | 98.94 | deceb7eeb47042f0bc9ae067cf283328 | e3c5de797f896795 |
| 2026-11-04T06:55:53Z | p07 | duyu-1 | - | - | - | 98.94 | - | e3c5de797f896795 |
| 2026-11-04T06:56:11Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 1486 | 88.57 | ae4f4ef1e3df4f97a6796061948018f6 | 53a591229062e83a |
| 2026-11-04T06:56:23Z | p08 | duyu-1 | - | - | - | 88.57 | - | 53a591229062e83a |
| 2026-11-04T06:56:40Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1478 | 89.46 | 7651c778d5eb4454ab8be1cd8504f0ba | b666c0bc8ea6dc96 |
| 2026-11-04T06:56:59Z | p09 | duyu-1 | - | - | - | 89.46 | - | b666c0bc8ea6dc96 |
| 2026-11-04T06:57:19Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1590 | 101.56 | 14516f5058704aa0a3b1322fd13cef8a | 761c7449336721f4 |
| 2026-11-04T06:57:32Z | p10 | duyu-1 | - | - | - | 101.56 | - | 761c7449336721f4 |
| 2026-11-04T06:57:50Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 1619 | 100.72 | f0a6f684847e4284bb5293cf2eb5e70f | 1e2e818442e594aa |
| 2026-11-04T06:58:05Z | p11 | duyu-1 | - | - | - | 100.72 | - | 1e2e818442e594aa |
| 2026-11-04T06:58:23Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1571 | 95.51 | 7ba7b5b1759541b9bb1bc3a4116f41c8 | ab5e89ea10713e05 |
| 2026-11-04T06:58:35Z | p12 | duyu-1 | - | - | - | 95.51 | - | ab5e89ea10713e05 |
| 2026-11-04T06:58:52Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 1504 | 89.13 | e3a1f02867d9402188f0cc404aff7111 | 0ee7398e539daf25 |
| 2026-11-04T06:59:04Z | p13 | duyu-1 | - | - | - | 89.13 | - | 0ee7398e539daf25 |
| 2026-11-04T06:59:21Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1645 | 100.58 | d9cca9718faf47948eda92fc4c21fbc9 | fdd14a4bbf95b5e4 |
| 2026-11-04T06:59:34Z | p14 | duyu-1 | - | - | - | 120.31 | - | fdd14a4bbf95b5e4 |
| 2026-11-04T06:59:58Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1734 | 110.5 | 6d3b983ea0314c9c9e9fa3cc7f3f2fce | c127b41f96923b7e |
| 2026-11-04T07:00:17Z | p15 | duyu-1 | - | - | - | 110.5 | - | c127b41f96923b7e |
| 2026-11-04T07:00:38Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1784 | 114.21 | 186455e9d61a42559d1e45eda3d29104 | 9b7edd22242fdbe9 |
| 2026-11-04T07:00:51Z | p16 | duyu-1 | - | - | - | 114.21 | - | 9b7edd22242fdbe9 |
| 2026-11-04T07:01:11Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1748 | 116.08 | 63c6692032f94fc7b1e2d971cfee95f3 | 7985fa1074e2daa1 |
| 2026-11-04T07:01:25Z | p17 | duyu-1 | - | - | - | 116.08 | - | 7985fa1074e2daa1 |
| 2026-11-04T07:01:42Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1426 | 89.47 | 7d0c00248a9b4fffa051fec4722305cc | 264d15d197006618 |
| 2026-11-04T07:01:55Z | p18 | duyu-1 | - | - | - | 89.47 | - | 264d15d197006618 |
| 2026-11-04T07:02:12Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1635 | 102.96 | 06d8b75d80d2404885055985deec1714 | 9b311df58a9c23d7 |
| 2026-11-04T07:02:27Z | p19 | duyu-1 | - | - | - | 102.96 | - | 9b311df58a9c23d7 |
| 2026-11-04T07:02:46Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1679 | 101.36 | c34c03dd35b64aed9220b3d30de9d504 | 6cb0692f7fcfce6a |
| 2026-11-04T07:03:00Z | p20 | duyu-1 | - | - | - | 101.36 | - | 6cb0692f7fcfce6a |
| 2026-11-04T07:03:20Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1535 | 93.72 | 051b8f00a5bf429ca8311711af0d15fc | 3b74a05679c21057 |
| 2026-11-04T07:03:35Z | p21 | duyu-1 | - | - | - | 93.72 | - | 3b74a05679c21057 |
| 2026-11-04T07:03:54Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1457 | 90.25 | c458f984e7f3431c92f85cc4f639fb94 | f755640bb276259f |
| 2026-11-04T07:04:10Z | p22 | duyu-1 | - | - | - | 90.25 | - | f755640bb276259f |
| 2026-11-04T07:04:29Z | p23 | alania-v2 | alania2-f1 | alania-v2.1 | 1587 | 101.89 | 7c72f727892f4bea80c10dbb9b01b4c3 | 31cb10289d616260 |
| 2026-11-04T07:04:45Z | p23 | duyu-1 | - | - | - | 101.89 | - | 31cb10289d616260 |
| 2026-11-04T07:05:03Z | p24 | alania-v2 | alania2-f1 | alania-v2.1 | 1592 | 99.76 | 09dc1e2dd8f6483ebb91aa38009132c3 | 6d6606a2af5d88fb |
| 2026-11-04T07:05:24Z | p24 | duyu-1 | - | - | - | 99.76 | - | 6d6606a2af5d88fb |
| 2026-11-04T07:05:41Z | p25 | alania-v2 | alania2-f1 | alania-v2.1 | 1652 | 102.62 | be8f0a118b8a4ae382e795306ab61c04 | a61525f4eafd6df2 |
| 2026-11-04T07:05:58Z | p25 | duyu-1 | - | - | - | 102.62 | - | a61525f4eafd6df2 |
| 2026-11-04T07:06:16Z | p26 | alania-v2 | alania2-f1 | alania-v2.1 | 1524 | 90.76 | e6199d89d23345c695376649116ea33d | eaa8acd196f28082 |
| 2026-11-04T07:06:33Z | p26 | duyu-1 | - | - | - | 90.76 | - | eaa8acd196f28082 |
| 2026-11-04T07:06:50Z | p27 | alania-v2 | alania2-f1 | alania-v2.1 | 1501 | 100.34 | eb8fd2e427a14b98b9cf4b11b1129947 | 9ef8beba3684a64a |
| 2026-11-04T07:07:08Z | p27 | duyu-1 | - | - | - | 100.34 | - | 9ef8beba3684a64a |
| 2026-11-04T07:07:25Z | p28 | alania-v2 | alania2-f1 | alania-v2.1 | 1647 | 102.41 | 08a357dd07c0495782b6e9731e2705e3 | 5510f266325d3725 |
| 2026-11-04T07:07:45Z | p28 | duyu-1 | - | - | - | 102.41 | - | 5510f266325d3725 |
| 2026-11-04T07:08:02Z | p29 | alania-v2 | alania2-f1 | alania-v2.1 | 1607 | 96.8 | 030f20a919d4438d8cda0901757df4a0 | 1536a95ed18324c8 |
| 2026-11-04T07:08:21Z | p29 | duyu-1 | - | - | - | 96.8 | - | 1536a95ed18324c8 |
| 2026-11-04T07:08:40Z | p30 | alania-v2 | alania2-f1 | alania-v2.1 | 1576 | 99.91 | b8c57ec72c6c4b04949a0cb903c3c526 | 6bb94e314bdc5273 |
| 2026-11-04T07:09:01Z | p30 | duyu-1 | - | - | - | 99.91 | - | 6bb94e314bdc5273 |
