# A1-K04 Pip Cannot Sleep: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1, yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A1-K04 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json` |

**İstem (özet):** "A1-K04 *Pip Cannot Sleep* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 2 bölüm, 10 sayfa, ~650–700 kelime (A1 hedefi 700 ± %20). A1: her cümle ≤ 8 kelime, present simple, yan cümle yok; sayılar, *can / can't*, ev eşyaları, *Me too*, uyku sözcükleri (*bed, blanket, dream, tired*). İlk cümle "I tell you a story tonight." olmalı; sonda anlatıcının Pip olduğu ve Pip'in Zara'ya okuduğu kitabın bu kitap olduğu anlaşılır; kitap dinleyiciye "Good night" der. Ninni ritmi, sakin. 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J A1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Katalogdan küçük sapma:** Katalogda Pip "bin koyunu bir saniyede" sayıyor. *thousand* ve *hundred* A1 listesi dışında olduğu için metinde "fifty sheep in one second" kullanıldı; şaka aynı.

**Adil son için yerleştirilen ipuçları:** ilk cümle "I tell you a story tonight." ve "I know this robot very well." (p01); anlatıcının Pip'in iç dünyasını bilmesi (p03–p05); Zara'nın verdiği yeni mavi kitabın "about a robot" olması (p07); Pip'in okuduğu kitabın ilk satırının kitabın ilk cümlesiyle aynı olması ve kitabın Pip'in gecesini anlatması (p08).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: dalga 1 metinleri ve 34 görsel (~17 kr) onaylandı ("İlk dalganın 8 kitap metni … onay", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, medium, 1k = 0,5 kr. Bölüm başları kapak işi referans verilerek üretildi. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071): kalan kitaplarda yalnız **kapak + her bölümün ilk sayfası**. Bu kitapta 3 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png` (git dışı; adlar `book.json` ile aynı). Öbür sayfalar resimsiz, palet renkli (`image: null`).
> Öngörülen model: GPT Image 2.5, 3:4, quality medium, 1k ≈ 0,5 kr/görsel (pilotla aynı; ≈ 1,5 kr). Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır. Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Soft pastel pencil and digital paint children's book illustration, non-photorealistic, gentle grainy texture, calm bedtime mood, cosy and peaceful, never scary. Palette: night purple, moon yellow, soft lavender, warm cream, with turquoise-blue glowing robot lights as the accent. Absolutely no text, letters, numbers, signs or writing anywhere in the image; book covers, pages and clocks are drawn blank or with abstract lines only. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekân (her istemde adı geçen tanım aynen eklenir):**
- **Pip:** small, friendly home robot about the height of a kitchen table, rounded white-and-pale-mint body, two thin bendy arms, one wheel instead of legs, a smooth round head with two round glowing turquoise-blue eye lights, a few tiny turquoise lights on the chest; no mouth, expressive through its eye lights.
- **Zara:** 8-year-old girl, dark-brown skin, black hair in two puffy buns, purple pyjamas with small yellow moons, holds a worn brown toy bear.
- **Mum and Dad:** seen only briefly; Mum with long braided hair and a yellow cardigan, Dad tall with short hair and round glasses.
- **The house:** small yellow family house, cosy kitchen with a big window showing a large yellow moon, Zara's room with a bed, a soft green blanket and a low table with books.

**Görsel istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | At night Pip stands alone in the dark, quiet kitchen, looking up at a big yellow moon through the window; its turquoise eye lights glow softly; the house is asleep. |
| p01.png | c1 başı | Evening in the cosy yellow house: Pip washes cups at the kitchen sink while the family gets ready for bed in the background; warm lamp light. |
| p06.png | c2 başı | Late at night Zara in purple pyjamas, holding her toy bear, sits on the kitchen floor next to Pip under the window; they look at each other; moonlight. |

**Sürpriz kontrolü:** Sürpriz, anlatıcının Pip olması ve Pip'in Zara'ya okuduğu kitabın bu kitap olmasıdır. Hiçbir istemde Pip'in elinde kitap, kitap okuma sahnesi, rüyadaki koyunlar ya da Pip'in uyuduğu (ışıklarının söndüğü) an yok. Kapak yalnız kancayı gösterir (uyanık, yalnız bir robot ve ay). Bölüm 2 görseli yalnız Zara'nın gelişini gösterir; çözüm (hikâye okuma, rüya) görsele girmez.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 65c911ea-a2d3-44d0-a1f9-b66204322ff2 | — | 2026-10-14T11:10:33+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | 01a2bd45-ef6b-4a87-9618-b28bb2e4ceed | 65c911ea-a2d3-44d0-a1f9-b66204322ff2 | 2026-10-14T11:13:26+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 391137af-c8cb-4684-a768-9bf353ea33a0 | 65c911ea-a2d3-44d0-a1f9-b66204322ff2 | 2026-10-14T11:13:29+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 1.5 kr. Tam istem metinleri yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.9; ninni tonu, son sayfa daha yavaş (anlatım temposu A1 `auto`, §6.5). Ses ElevenLabs **Creator** (ticari) hesabıyla, `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip maliyet onayı alındıktan sonra üretilir (H-071). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T16:31:11Z | c1 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 2018 | 61a471b010bbac05 | audio/c1.mp3 |
| 2026-10-14T16:31:45Z | c2 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 2042 | 632cf018771f09da | audio/c2.mp3 |

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T17:10:48Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 379 | 29.75 | 4a181b24412c4f5b876beabfeab9ec56 | afacce3a175313d0 |
| 2026-11-03T17:10:51Z | p01 | duyu-1 | - | - | - | 29.75 | - | afacce3a175313d0 |
| 2026-11-03T17:10:55Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 354 | 24.84 | 2e793d64805b422aa7ea1246877bcd6b | 7633686223881bf4 |
| 2026-11-03T17:10:57Z | p02 | duyu-1 | - | - | - | 24.84 | - | 7633686223881bf4 |
| 2026-11-03T17:11:02Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 380 | 26.59 | 90775d1706e8496bb9cb48acee415db0 | a3f483ddf70f872a |
| 2026-11-03T17:11:04Z | p03 | duyu-1 | - | - | - | 26.59 | - | a3f483ddf70f872a |
| 2026-11-03T17:11:10Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 437 | 31.23 | 6ba5e27616f14a228fc4c389f55c3487 | d0b2dbdd7d1ec376 |
| 2026-11-03T17:11:13Z | p04 | duyu-1 | - | - | - | 31.23 | - | d0b2dbdd7d1ec376 |
| 2026-11-03T17:11:18Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 418 | 30.92 | 2c12e9f482fb4ac7b96eb04e01a06ca3 | 746eda5d2112f96d |
| 2026-11-03T17:11:21Z | p05 | duyu-1 | - | - | - | 30.92 | - | 746eda5d2112f96d |
| 2026-11-03T17:11:26Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 357 | 24.84 | 878c0612a8af4666bb742a39a5d5f524 | c51915fc4c154b2b |
| 2026-11-03T17:11:29Z | p06 | duyu-1 | - | - | - | 24.84 | - | c51915fc4c154b2b |
| 2026-11-03T17:11:41Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 394 | 27.31 | fc4d3d3f932643619c0bdfa1d0fd5762 | 06fd0ae0c4ef38a0 |
| 2026-11-03T17:11:44Z | p07 | duyu-1 | - | - | - | 27.31 | - | 06fd0ae0c4ef38a0 |
| 2026-11-03T17:11:50Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 335 | 23.5 | 89033e06de2148dd90014c9b8e3716f0 | 199ab39f3e62b068 |
| 2026-11-03T17:11:53Z | p08 | duyu-1 | - | - | - | 23.5 | - | 199ab39f3e62b068 |
| 2026-11-03T17:11:57Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 421 | 31.59 | bc26c9d450c049d6bd101caa37ed21dd | d2f5ab12f49306d6 |
| 2026-11-03T17:12:02Z | p09 | duyu-1 | - | - | - | 31.59 | - | d2f5ab12f49306d6 |
| 2026-11-03T17:12:07Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 596 | 44.09 | ab1684fc86434649b1c9ac91f0fe0349 | 91c4157dd60b98f8 |
| 2026-11-03T17:12:12Z | p10 | duyu-1 | - | - | - | 44.09 | - | 91c4157dd60b98f8 |
