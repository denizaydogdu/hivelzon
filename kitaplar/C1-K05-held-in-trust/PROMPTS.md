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

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 7 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p15.png`, `images/p19.png`, `images/p24.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 3,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

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

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C1 başlangıç değeri; C1'de anlatım temposu varsayılanı `off`, hedef ~160 k/dk, katalogda ~155 k/dk, §6.5). Türkçe sözler (emanet, Üşütme, Ben geldim, Babaannem kimseyi görmek istemiyor) doğal Türkçe telaffuzla okunmalıdır; seslendirmeden önce kısa bir deneme önerilir. Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
