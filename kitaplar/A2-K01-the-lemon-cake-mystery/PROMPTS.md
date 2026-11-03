# A2-K01 The Lemon Cake Mystery: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1 (A1 + A2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A2-K01 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "A2-K01 *The Lemon Cake Mystery* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 4 bölüm, 16 sayfa, ~1.500 kelime (A2 hedefi 1.500 ± %20). A2: her cümle ≤ 12 kelime; past simple (*took, found, saw, made*), karşılaştırma (*sweeter, more sour, drier*), mutfak fiilleri, *going to*; Türk öğrenci notu *make / do* (*make a cake*, *do the dishes*). Ayvalık'ta aile lokantası; pastane markasız. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J ≤ A2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Katalogdan küçük yorum:** Katalog "Füsun Teyze Theo'ya sabah altıda İngilizce dersi veriyor" diyor; Theo İngiliz olduğu için metinde bu bir **dil değişimi** oldu: Füsun Teyze Theo'ya Türkçe, Theo ona İngilizce öğretiyor. Böylece 3. bölüm sonundaki İngilizce "Are you ready?" de bu dersin ipucu olur. Kullanıcı onayında bakılmalı.

**Adil son için yerleştirilen ipuçları:** Füsun Teyze'nin hiçbir şeyi yazmaması, "elleriyle, kâğıtla değil" yemek yapması (p02); masadaki unlu el izleri (p03); Limon'un geceleri hep Füsun Teyze'nin yatağında uyuması ve yarım kartın Limon'un sepetinden çıkması (p04, p05); karttaki ölçülerle yapılan üç kötü kek (p09–p10); Füsun Teyze'nin hiç ölçmeden, karta bakmadan yemek yapması (p11); Theo ile sabah altıdaki gizli dersler ve Füsun Teyze'nin İngilizce konuşması (p07, p08, p12).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: dalga 1 metinleri ve 34 görsel (~17 kr) onaylandı ("İlk dalganın 8 kitap metni … onay", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, medium, 1k = 0,5 kr. Bölüm başları kapak işi referans verilerek üretildi. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071): kalan 28 kitapta resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 5 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ~0,5 kr/görsel (pilotta 1k medium ile doğrulandı; tahmini toplam ≈ 2,5 kr). **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Gouache storybook illustration, non-photorealistic, soft visible brush strokes, warm, playful detective mood. Palette: lemon yellow, olive green, whitewashed white, Aegean blue, warm terracotta. Small seaside Aegean town with narrow stone streets, white houses with blue shutters and olive trees. Absolutely no text, letters, numbers, signs, labels or writing anywhere in the image; recipe cards, notebooks, shop fronts and phone screens are blank or drawn with abstract lines only. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Elif:** 15-year-old Turkish girl, long dark-brown hair in a high ponytail, warm light-brown skin, thick eyebrows, determined curious eyes, lemon-yellow T-shirt, olive-green apron, a small dark-blue notebook and pencil.
- **Aunt Füsun:** Turkish woman about 70, short, round and lively, grey hair under a white headscarf tied at the back like a cook, flour on her hands and sleeves, blue flowered dress, sharp twinkling eyes.
- **Bora:** Elif's 17-year-old cousin, tall, curly black hair, white T-shirt, always holding up a phone with a blank glowing screen to take photos.
- **Theo:** young English waiter about 22, thin, pale skin, red-brown hair, white shirt and black waistcoat, carries a small blue notebook, shy polite smile.
- **Mr Selim:** cake-shop owner in his 60s, big and smiling, white moustache, white baker's jacket, round cheeks; his small shop across the street has a window full of colourful cakes and no sign.
- **Limon:** fat yellow-orange cat with round lemon-coloured eyes, lazy and proud; sleeps in a wicker basket.
- **The restaurant:** small family restaurant on a stone street near the sea; blue chairs and tables outside; a warm white kitchen with an old oven, a wooden table dusted with flour, copper pans, a bowl of lemons, and an old wooden box on a shelf.

**Görsel istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Elif, holding her notebook and pencil, peers closely into an empty old wooden box on the flour-dusted kitchen table; a golden lemon cake on a plate and a bowl of lemons beside her; Limon the cat watches from the edge of the table. |
| p01.png | c1 başı | The family restaurant on a sunny Aegean street near the sea: Elif carries plates to the blue tables outside while guests happily eat slices of lemon cake. |
| p05.png | c2 başı | Elif sits at an outside table with her open notebook (blank pages); behind her, three people go about their day: Bora photographing a plate with his phone, Theo writing in his blue notebook, and Mr Selim waving from his cake shop across the street. |
| p09.png | c3 başı | Saturday morning in the kitchen: Elif takes a cake out of the old oven; on the table, a lemon, butter, eggs and a glass of sugar; Bora leans in with his phone, grinning. |
| p13.png | c4 başı | Midnight kitchen lit by one warm lamp; Aunt Füsun, with flour on her hands, holds out her open hand towards Elif in pyjamas at the door; inviting, friendly, no paper visible. |

**Sürpriz kontrolü:** Hiçbir görsel kartı kimin aldığını göstermez. Kapak yalnızca boş kutuyu ve meraklı Elif'i gösterir; Füsun Teyze kapakta yok. Bölüm başı görselleri sonu ele vermez: c2'de üç şüpheli eşit ağırlıkta ve masum gündelik işlerinde; c3'te yalnız Elif'in kek denemesi; c4'te Füsun Teyze'nin elinde kart parçası **yok**, yalnızca davet eden açık bir el var (kartı sakladığı ve kartın yanlış olduğu metinde öğrenilir). Theo ile Füsun Teyze'nin sabah dersleri hiçbir görselde yer almaz.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | d8c23b5e-3ff3-4dc2-bbeb-3762f17f2bba | — | 2026-10-14T11:11:12+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | 050d6d14-a6a7-4290-bb84-7aa6bb25b729 | d8c23b5e-3ff3-4dc2-bbeb-3762f17f2bba | 2026-10-14T11:14:18+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | 123ac385-0619-499b-ae86-d710bce4d318 | d8c23b5e-3ff3-4dc2-bbeb-3762f17f2bba | 2026-10-14T11:14:21+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | c246c559-1e56-413e-9e21-42ea8ab2c856 | d8c23b5e-3ff3-4dc2-bbeb-3762f17f2bba | 2026-10-14T11:14:21+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | e3de7819-00fe-48e6-87d4-f76d81fb3358 | d8c23b5e-3ff3-4dc2-bbeb-3762f17f2bba | 2026-10-14T11:14:22+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 2.5 kr. Tam istem metinleri yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.95 (A2 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilir; anahtar repo dışında. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T17:13:31Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 561 | 40.11 | 630332bbd24e41079f6108e1e9d5af3d | 9a15312623a2ac59 |
| 2026-11-03T17:13:35Z | p01 | duyu-1 | - | - | - | 40.11 | - | 9a15312623a2ac59 |
| 2026-11-03T17:13:41Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 497 | 34.14 | 5cc4e67c56d144628e53c64a1c22086a | f5ea79efb32154b1 |
| 2026-11-03T17:13:44Z | p02 | duyu-1 | - | - | - | 34.14 | - | f5ea79efb32154b1 |
| 2026-11-03T17:13:50Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 492 | 35.34 | e9e578ddc3bf405eb4e4be1850269e81 | 7862571b1aed7d3f |
| 2026-11-03T17:13:53Z | p03 | duyu-1 | - | - | - | 35.34 | - | 7862571b1aed7d3f |
| 2026-11-03T17:13:59Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 523 | 36.79 | a2dfffe94e694f18acd346b835b19957 | a21facdf00b2b520 |
| 2026-11-03T17:14:03Z | p04 | duyu-1 | - | - | - | 36.79 | - | a21facdf00b2b520 |
| 2026-11-03T17:14:08Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 370 | 26.29 | 21a37fe2352f490c920f8dc08b25131b | ba2c2ad66553032c |
| 2026-11-03T17:14:12Z | p05 | duyu-1 | - | - | - | 26.29 | - | ba2c2ad66553032c |
| 2026-11-03T17:14:16Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 484 | 32.13 | f8b616ed491a49f3ad51a37e298df8b1 | ecfe007b632ad48c |
| 2026-11-03T17:14:20Z | p06 | duyu-1 | - | - | - | 32.13 | - | ecfe007b632ad48c |
| 2026-11-03T17:14:25Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 401 | 28.34 | 635770a5432e4498848998a5bf14089d | 615f0dab49f35bf5 |
| 2026-11-03T17:14:29Z | p07 | duyu-1 | - | - | - | 28.34 | - | 615f0dab49f35bf5 |
| 2026-11-03T17:14:34Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 548 | 39.17 | 14e792d90dc64ef28fa93e92530a3c05 | 5d1854738d45ca38 |
| 2026-11-03T17:14:38Z | p08 | duyu-1 | - | - | - | 39.17 | - | 5d1854738d45ca38 |
| 2026-11-03T17:14:43Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 453 | 32.78 | 7303c0e0d7534a8391ea507f8a345a85 | 2cf364deb690b833 |
| 2026-11-03T17:14:48Z | p09 | duyu-1 | - | - | - | 32.78 | - | 2cf364deb690b833 |
| 2026-11-03T17:14:52Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 319 | 24.06 | 3e239eadadd340f2a893fda2050f2360 | bd48708171fb39c9 |
| 2026-11-03T17:14:56Z | p10 | duyu-1 | - | - | - | 24.06 | - | bd48708171fb39c9 |
| 2026-11-03T17:15:01Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 387 | 27.64 | 73e6d3302e524b9a8a14f1bae251c2dd | f350348892de1512 |
| 2026-11-03T17:15:03Z | p11 | duyu-1 | - | - | - | 27.64 | - | f350348892de1512 |
| 2026-11-03T17:15:08Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 673 | 44.32 | 0b02ce12082543de8267f446041a5957 | 02626a9616f64523 |
| 2026-11-03T17:15:11Z | p12 | duyu-1 | - | - | - | 44.32 | - | 02626a9616f64523 |
| 2026-11-03T17:15:17Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 466 | 32.15 | f8402baf4e124c6387185dc7bd219b20 | da1d7b0383289aed |
| 2026-11-03T17:15:21Z | p13 | duyu-1 | - | - | - | 32.15 | - | da1d7b0383289aed |
| 2026-11-03T17:15:26Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 588 | 42.39 | 7f6b4f948ee246b7857344acc17d7801 | 6a0cc34a7ed2cd0b |
| 2026-11-03T17:15:30Z | p14 | duyu-1 | - | - | - | 42.39 | - | 6a0cc34a7ed2cd0b |
| 2026-11-03T17:15:36Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 487 | 34.0 | 98875a7ca086488ba737e511c17aa5cc | fd0ddeac7cc04c21 |
| 2026-11-03T17:15:39Z | p15 | duyu-1 | - | - | - | 34.0 | - | fd0ddeac7cc04c21 |
| 2026-11-03T17:15:44Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 600 | 39.74 | b6fb7d7fef9f4ae998ebf86be928cbf6 | e7feb1b3cbb1800a |
| 2026-11-03T17:15:47Z | p16 | duyu-1 | - | - | - | 39.74 | - | e7feb1b3cbb1800a |
