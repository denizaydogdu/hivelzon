# C1-K05 Held in Trust: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C1-K05 (özet, kanca, bölüm planı, son sürpriz, dil odağı, görsel, anlatıcı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 konuları (G-C1-01…G-C1-08) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md`, `PROMPTS.md` |

**İstem (özet):** "C1-K05 *Held in Trust* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 6 bölüm (The Job, The Village, 1968, Mothers, Beyond the Brief, Emanet), 27 sayfa, ~8.000 kelime (C1 hedefi 7.600–8.600). Anlatıcı Nur Demir (41), Londra'da yaşayan Türk-İngiliz sözlü çevirmen; birinci tekil şahıs, olgun, sıcak, hafif ironik iç ses. Margaret Ellis (81) 1967–68'de Kaş yakınlarındaki uydurma bir köyde öğretmenlik yapmış; resmî, keskin, kuru esprili. C1 yapıları doğal biçimde ve her biri en az 2–3 kez: devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri (needn't have, might well have, was supposed to, would rather), kişisiz edilgen, gerçek dışı geçmiş (It's high time, as if, would rather + geçmiş), eksiltme ve yerine koyma; temkinli dil (it would seem, arguably); deyimler (read between the lines, lost in translation). Kelimesi kelimesine anlam ile kastedilen anlam teması; resmî ve gündelik üslup farkı. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden adil ipuçları verilmiş sürpriz son. Standart İngiliz İngilizcesi. 13+ güvenli; gerçek marka, kişi ve kurum adı yok. Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; C1 yapıları ve Türk öğrenci notları sözlükte."

**Kanca kararı:** Katalogdaki kanca (*Margaret had kept a small blue box for fifty-eight years, and she had come back to return it.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. Son sayfada aynı cümle yeniden kullanılır (*Margaret Ellis had kept a small blue box…*) ve ters çevrilir: "In the end, she took it home again. Some things are not lent. They are held in trust…" Bölüm kancaları katalogdakilerdir: "I didn't come for the view. I came to return something." (p05); "She has been waiting for a long time." (p09); Nur kelimenin anlamını bilir ama susar (p14); "Babaannem kimseyi görmek istemiyor." (p18); kapı açılır, Hatice'nin üzerinde eski yeşil bir hırka (p23).

**Zaman çizelgesi:** Pazartesi uçuş ve varış (c1); salı köy ve Osman, salı akşamı 1968 hikâyesi (c2–c3); çarşamba sabahı annenin telefonu, öğleden sonra Hatice'nin kapısı, akşam not (c4–c5); perşembe sabahı Nur rolünün dışına çıkar, kapı açılır (c5–c6); cuma sabahı dönüş, akşam 18.30'da Mina'nın gösterisi (p27). Margaret 1967'de 22, 1968'de 23 yaşında; Hatice 1967'de 18, 1968'de 19, şimdi 77.

**Adil son için yerleştirilen ipuçları:**
- Margaret, Nur'un yeşil kazağına bakıp "I used to wear green myself." diyor; neden bıraktığı sorulunca "I lost the habit." (p03).
- Osman: "Hatice? She has been waiting for a long time." Hasta değil, yalnızca kimseyi görmüyor (p09).
- Margaret, telgraf gecesi sobanın sıcağından hırkasını çıkardığını, aceleyle eşyalarının yarısını, örneğin annesinin ördüğü yeşil, en üstte uyumsuz pirinç düğmeli hırkasını geride bıraktığını anlatıyor; Nur: "So that… was what had happened to the green." (p12).
- Nur, emanetin "yeniden karşılaşana dek benim için sakla" demek olduğunu ve "you will have to come back" anlamı taşıdığını açıklıyor (p14).
- Margaret: annesi sevgisini söylemez, her kış bir hırka örermiş; "every one of them had been a sentence" (p16).
- Emre: "She is not angry person… Maybe she is shy." (p19).
- Yukarıdaki kepenk bir el genişliği kadar aralık: Hatice dinliyor (p22).
- Kapı açılınca: eski, yamalı, boğazına kadar iliklenmiş yeşil hırka; en üstteki düğme pirinç (p23).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: 500 kredi yüklendi, "tüm yarım kalan işlerimizi yap … onay verdim". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 7 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p15.png`, `images/p19.png`, `images/p24.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 3,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Gouache and watercolour illustration, non-photorealistic, soft opaque gouache shapes over transparent watercolour washes on textured paper, elegant and nostalgic. Mediterranean autumn light. Palette: olive-leaf silver, warm terracotta, chalky whitewash, sea blue, pine green, with one small accent of clear summer-sea blue for the little box. Mood: quiet, warm, wistful, a little dry humour. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; shop signs, brochures, books, dictionary pages, phone screens and notes are blank or drawn as soft abstract lines. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Nur:** 41-year-old Turkish-British woman, shoulder-length wavy dark-brown hair, dark expressive eyes, warm olive skin, an observant, slightly ironic face; a navy jumper, dark trousers, a canvas shoulder bag with a notebook.
- **Margaret:** 81-year-old Englishwoman, small and very upright, short white hair, pale clear blue eyes, a sharp but not unkind face; a grey wool coat and a silk scarf (or a dark blue dress in the evening); a small brown leather bag; a long black umbrella she uses as a walking stick.
- **Osman:** about 70, thin, white moustache, flat cap, waistcoat, lively eyes.
- **Emre:** about 25, dark curly hair, kind slightly anxious face, a plain white shirt.
- **Mina:** 9-year-old girl, dark hair in two plaits, pyjamas, arms spread wide as if on a stage.
- **Hatice:** 77, small and very thin, white hair pulled back under a plain cotton scarf, a face full of gentle lines (only in p24, small and in soft shadow).
- **The blue box:** a small wooden box, the size of a paperback but deeper, painted bright summer-sea blue with tiny white flowers round the edges, paint worn at the corners.
- **The red dictionary:** a small old red pocket book with a cracked cover and tea-coloured pages (pages blank or abstract lines).
- **The village (Sarnıçlı):** a hillside village above a bay with a small island, stone and whitewashed houses, many blue wooden gates, olive trees and pine hills; new boutique hotels below, an old village above a round stone cistern.
- **The hotel:** a long old stone school building with tall windows and a small bell, now a hotel with a terrace over the bay.
- **Hatice's house:** a small whitewashed house with a wooden balcony and closed shutters, a vine over the door, a faded grey-blue gate, an enormous fig tree, pots of basil along the wall.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Late afternoon on a narrow stone lane above the village: Margaret, seen from behind and slightly from the side, small and upright with her umbrella, holds the little blue box in both hands; Nur walks one step behind her with her canvas bag; below them silver olive trees, blue gates and the bay with a small island; in the distance up the lane, a faded gate and a large fig tree. Warm autumn light. |
| p01.png | p01 (Bölüm 1, The Job) | A rainy evening in a small London kitchen: Nur sits at the table with her phone and a notebook, looking a little tired; behind her on the stairs, Mina in pyjamas practises a line with her arms spread wide; rain runs down the window. |
| p06.png | p06 (Bölüm 2, The Village) | Morning in the new part of the village: Margaret stands very still in front of a pretty whitewashed shop with a newly painted blue gate (displays of soap drawn as soft shapes, no signs), leaning on her umbrella; tourists in sun hats step politely round her; Nur beside her, watching her face. |
| p10.png | p10 (Bölüm 3, 1968) | Evening on the hotel terrace above the dark bay: one candle on a small table; on the table, the little blue box and the old red pocket dictionary; Margaret in a dark blue dress with both hands near the box, Nur opposite her listening; the last light over the island. |
| p15.png | p15 (Bölüm 4, Mothers) | Early morning in a hotel room with thick stone walls and a tall old school window: Nur sits up in bed with her phone to her ear and her other hand over her eyes, half-amused, half-tense; soft light on the ceiling. |
| p19.png | p19 (Bölüm 5, Beyond the Brief) | A narrow lane in the old village: Margaret walks quickly downhill with her umbrella, Nur hurrying after her, an elderly dog trotting behind them; they pass the round stone cistern; far behind, up the lane, Emre stands at a faded blue gate under the fig tree, watching them go. |
| p24.png | p24 (Bölüm 6, Emanet) | The small shady yard under the enormous fig tree, seen from a distance as if from the gate: two old women stand face to face, Margaret holding the little blue box against her chest; the second woman is small, in soft shadow, her clothes drawn only as muted indistinct shapes; Emre and Nur stand quietly at the edge of the yard. |

**Sürpriz kontrolü:** Sonun sürprizi, Hatice'nin elli sekiz yıl boyunca Margaret'in 1968'de bıraktığı yeşil hırkayı emanet olarak saklamış olmasıdır (ve kimseyi görmemesinin nedeninin kırgınlık değil utangaçlık olması). Hiçbir görselde yeşil hırka, örgü bir giysi ya da pirinç düğme yer almaz; Margaret hep gri palto ya da lacivert elbiseyle çizilir, Nur lacivert kazakla (p03'teki yeşil kazak çizilmez). 1968 sahnesi (telgraf gecesi, sobanın yanındaki sandalye) hiç çizilmez. Hatice yalnız p24'te, olay metinde açıldıktan sonra, uzaktan ve gölgede, kıyafeti belirsiz biçimde görünür. Kapakta ve p19'da Hatice yoktur; p19'daki kepenkler kapalıdır.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 07957614-b022-4cd0-94a5-8d3c65493008 | — | 2026-10-14T16:41:36+00:00 | 3:4, medium, 1k | 0.5 |
| p15.png | acc6cd41-99ca-4b9a-884a-05575185a0d6 | 07957614-b022-4cd0-94a5-8d3c65493008 | 2026-10-14T16:47:23+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 5bce21c0-ee5b-40bf-aee2-08efadcd2d31 | 07957614-b022-4cd0-94a5-8d3c65493008 | 2026-10-14T16:47:25+00:00 | 3:4, medium, 1k | 0.5 |
| p10.png | c7d9c15c-c466-4cb5-ba2f-4e87cfe837f8 | 07957614-b022-4cd0-94a5-8d3c65493008 | 2026-10-14T16:47:27+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | d93fc51e-b7a0-45e0-ae49-e39374f19f25 | 07957614-b022-4cd0-94a5-8d3c65493008 | 2026-10-14T16:47:30+00:00 | 3:4, medium, 1k | 0.5 |
| p24.png | 3a5be368-8beb-43a3-a4f7-6beb0f1e1130 | 07957614-b022-4cd0-94a5-8d3c65493008 | 2026-10-14T16:47:51+00:00 | 3:4, medium, 1k | 0.5 |
| p19.png | 19630d0f-47c7-4166-be5c-a3701d060794 | 07957614-b022-4cd0-94a5-8d3c65493008 | 2026-10-14T16:47:52+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 3.5 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C1 başlangıç değeri; C1'de anlatım temposu varsayılanı `off`, hedef ~160 k/dk, katalogda ~155 k/dk, §6.5). Türkçe sözler (emanet, Üşütme, Ben geldim, Babaannem kimseyi görmek istemiyor) doğal Türkçe telaffuzla okunmalıdır; seslendirmeden önce kısa bir deneme önerilir. Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-04T04:46:00Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1823 | 115.39 | a90422d0ddab47a0b6482eed5323a55b | 63bfb194fc9fbb56 |
| 2026-11-04T04:46:13Z | p01 | duyu-1 | - | - | - | 115.39 | - | 63bfb194fc9fbb56 |
| 2026-11-04T04:46:29Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 1699 | 110.41 | 78c80d8ec77142a4b7405c523b089402 | 101ae1f34e355915 |
| 2026-11-04T04:46:37Z | p02 | duyu-1 | - | - | - | 110.41 | - | 101ae1f34e355915 |
| 2026-11-04T04:46:53Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 1579 | 96.46 | ad13b8d0aaf84010b50a934375c37523 | d2a9166831f804d7 |
| 2026-11-04T04:47:00Z | p03 | duyu-1 | - | - | - | 96.46 | - | d2a9166831f804d7 |
| 2026-11-04T04:47:14Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1447 | 89.08 | 469e8cba9d83433abe3f37cd6e2505c0 | ad1dbd3527667b8d |
| 2026-11-04T04:47:22Z | p04 | duyu-1 | - | - | - | 89.08 | - | ad1dbd3527667b8d |
| 2026-11-04T04:47:34Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1433 | 90.28 | 42f1f013ade34c8692fc097d25fd18e7 | 9baa3ca267039c96 |
| 2026-11-04T04:47:43Z | p05 | duyu-1 | - | - | - | 107.72 | - | 9baa3ca267039c96 |
| 2026-11-04T04:47:57Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1627 | 103.38 | 7b4ecc2303c94c25bf1396294e52bf4b | b9dbfd450775288a |
| 2026-11-04T04:48:06Z | p06 | duyu-1 | - | - | - | 103.38 | - | b9dbfd450775288a |
| 2026-11-04T04:48:19Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 1515 | 97.19 | e81e4f5d7d7b4850ad901a759c654e1f | 0e499f767dc81fa1 |
| 2026-11-04T04:48:27Z | p07 | duyu-1 | - | - | - | 97.19 | - | 0e499f767dc81fa1 |
| 2026-11-04T04:48:39Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 1520 | 102.28 | 9d6a07554c1e43ca90107aed587be5c7 | 4fdff08477b0a6bc |
| 2026-11-04T04:48:47Z | p08 | duyu-1 | - | - | - | 102.28 | - | 4fdff08477b0a6bc |
| 2026-11-04T04:49:01Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1519 | 102.58 | 4046d9a3349e4efaa744e89a4143780f | e0e467276ec35dcd |
| 2026-11-04T04:49:09Z | p09 | duyu-1 | - | - | - | 102.58 | - | e0e467276ec35dcd |
| 2026-11-04T04:49:22Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1465 | 98.9 | fe70f4ff0b9a423ebc06f4f89bd94fd6 | 21e520664888561e |
| 2026-11-04T04:49:30Z | p10 | duyu-1 | - | - | - | 98.9 | - | 21e520664888561e |
| 2026-11-04T04:49:45Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 1688 | 110.68 | fa39b7e19f9f4932bea8394f37dd21b5 | 20925a5de086a641 |
| 2026-11-04T04:49:53Z | p11 | duyu-1 | - | - | - | 110.68 | - | 20925a5de086a641 |
| 2026-11-04T04:50:09Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1494 | 93.33 | 47aa3ad282494a12bb12895d83688b72 | 35376512363d0f6a |
| 2026-11-04T04:50:16Z | p12 | duyu-1 | - | - | - | 93.33 | - | 35376512363d0f6a |
| 2026-11-04T04:50:29Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 1554 | 95.76 | 4139f4672dd747acb44b8387bdd172c5 | 1e3c30de83ad65c6 |
| 2026-11-04T04:50:36Z | p13 | duyu-1 | - | - | - | 95.76 | - | 1e3c30de83ad65c6 |
| 2026-11-04T04:50:51Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1662 | 101.79 | fa2be8e11fd043b486b530472265a20b | 78255c8fdb7a0194 |
| 2026-11-04T04:50:58Z | p14 | duyu-1 | - | - | - | 101.79 | - | 78255c8fdb7a0194 |
| 2026-11-04T04:51:12Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1512 | 108.34 | 000da8dac1794ea09554b1e61e4b2af1 | 00c91c3321c04c6b |
| 2026-11-04T04:51:20Z | p15 | duyu-1 | - | - | - | 108.34 | - | 00c91c3321c04c6b |
| 2026-11-04T04:51:36Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1528 | 97.27 | 353a091f49b243bf9b1eec32055c5ae9 | 2fa819d3631fa765 |
| 2026-11-04T04:51:43Z | p16 | duyu-1 | - | - | - | 97.27 | - | 2fa819d3631fa765 |
| 2026-11-04T04:51:56Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1571 | 97.67 | 224a468f0c12404e8ebb241c2586e9c0 | 878648293957d502 |
| 2026-11-04T04:52:03Z | p17 | duyu-1 | - | - | - | 97.67 | - | 878648293957d502 |
| 2026-11-04T04:52:17Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1541 | 99.49 | ce547cb8ddd349b1bd9963a186739799 | a81a98ccfadb044f |
| 2026-11-04T04:52:25Z | p18 | duyu-1 | - | - | - | 99.49 | - | a81a98ccfadb044f |
| 2026-11-04T04:53:25Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1595 | 102.83 | 6482accb1feb48a4977a26c5b006d14a | 04b9e923f38a62eb |
| 2026-11-04T04:53:33Z | p19 | duyu-1 | - | - | - | 102.83 | - | 04b9e923f38a62eb |
| 2026-11-04T04:53:48Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1686 | 109.08 | 48068d5b1b6f4d71a0f1c64229e878d1 | 4236a7b67b1b8a45 |
| 2026-11-04T04:53:56Z | p20 | duyu-1 | - | - | - | 109.08 | - | 4236a7b67b1b8a45 |
| 2026-11-04T04:54:12Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1648 | 104.82 | 8b69685968da43958e2f700c398ee6e4 | cbaa896995515c65 |
| 2026-11-04T04:54:20Z | p21 | duyu-1 | - | - | - | 104.82 | - | cbaa896995515c65 |
| 2026-11-04T04:54:34Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1529 | 95.46 | a6950bdaaf9b455583e03af71cbc8603 | 8bb61231504b6762 |
| 2026-11-04T04:54:41Z | p22 | duyu-1 | - | - | - | 95.46 | - | 8bb61231504b6762 |
| 2026-11-04T04:54:55Z | p23 | alania-v2 | alania2-f1 | alania-v2.1 | 1549 | 96.16 | 30378a987433455a9ac2a9c9f029d909 | 7e1dc81a25d4e05b |
| 2026-11-04T04:55:02Z | p23 | duyu-1 | - | - | - | 96.16 | - | 7e1dc81a25d4e05b |
| 2026-11-04T04:55:15Z | p24 | alania-v2 | alania2-f1 | alania-v2.1 | 1363 | 85.76 | 3677b4e974f04a66816afedffbec5908 | 6a286c86a13ed188 |
| 2026-11-04T04:55:22Z | p24 | duyu-1 | - | - | - | 85.76 | - | 6a286c86a13ed188 |
| 2026-11-04T04:55:35Z | p25 | alania-v2 | alania2-f1 | alania-v2.1 | 1541 | 97.81 | f5d67685908a43349f65888e1a6f41fb | 24917b2bdb87f643 |
| 2026-11-04T04:55:44Z | p25 | duyu-1 | - | - | - | 97.81 | - | 24917b2bdb87f643 |
| 2026-11-04T04:55:59Z | p26 | alania-v2 | alania2-f1 | alania-v2.1 | 1610 | 106.77 | 062e667084124e3594c42d26656b2a1b | b1b50d912d610383 |
| 2026-11-04T04:56:07Z | p26 | duyu-1 | - | - | - | 106.77 | - | b1b50d912d610383 |
| 2026-11-04T04:56:23Z | p27 | alania-v2 | alania2-f1 | alania-v2.1 | 1496 | 101.04 | c106ea61042543299e1b835eea266e48 | 00f9f51ce71b565d |
| 2026-11-04T04:56:32Z | p27 | duyu-1 | - | - | - | 101.04 | - | 00f9f51ce71b565d |
| 2026-11-04T07:11:09Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1648 | 107.58 | 106ee343c5d34676a7d13eb926c5cdcb | cbaa896995515c65 |
| 2026-11-04T07:11:30Z | p21 | duyu-1 | - | - | - | 107.58 | - | cbaa896995515c65 |
