# A2-K02 Into the Fog: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1, yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A2-K02 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json` |

**İstem (özet):** "A2-K02 *Into the Fog* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 4 bölüm, 15 sayfa, ~1.500 kelime (± %20). A2: her cümle ≤ 12 kelime; past simple; *must / have to / should*; yön ve hareket (*go down, follow, left the path*); hava sözcükleri; *because / so*. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. Gerilimli ama korkutmayan; doğru güvenlik davranışı (birlikte kal, sıcak kal). 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J ≤ A2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Adil son için yerleştirilen ipuçları:**
- p02: Berg Hanım'ın dördüncü kuralı "If you are lost, listen. Follow the b…" Paloma deklanşöre basarken yarıda kesilir; okur "listen" ve "b…" parçasını yakalar. Paragraf sonunda: "Paloma did not hear rule four. But Jonas did."
- p04: Uzaktan çan sesi; "There is no church and no village." (çanın kaynağı sorusu).
- p06: Jonas'ın "Didn't you listen?" sorusu (Paloma'nın dinlemediği bir kez daha).
- p08: Paloma dördüncü kuralı hatırlayamaz; Jonas yalnız "Something about listening?" diyebilir (ağrıdan).
- p11: Paloma "If you are lost, listen." parçasını hatırlar ve çanları dinler; çanların dağdan aşağı indiğini duyar.
- Çözüm p14'te: "Follow the bells. These goats come home at six every evening."

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: dalga 1 metinleri ve 34 görsel (~17 kr) onaylandı ("İlk dalganın 8 kitap metni … onay", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, medium, 1k = 0,5 kr. Bölüm başları kapak işi referans verilerek üretildi. Eski plan notu: Kullanıcı kararı (2026-10-14): kalan 28 kitapta resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 5 görsel: kapak + 4 bölüm başı (p01, p05, p09, p12); diğer sayfalar resimsiz, palet renkli (`book.json → image: null`). Model: GPT Image 2.5, 3:4, düşük kalite, ~0,5 kr/görsel (≈ 2,5 kr; kesin tutar üretimden önce `higgsfield generate cost` ile doğrulanır). **Her üretimden önce maliyet gösterilir ve kullanıcı onayı alınır.** Dosya adları `book.json` ile aynı: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p12.png` (git dışı). Sayfa görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Ink wash (sumi-e style) storybook illustration, non-photorealistic, soft wet brush edges and layered grey-green washes, misty mountain atmosphere. Palette: fog grey, sage and grey-green, pale stone, dark pine ink; the only strong colour accent is Paloma's bright orange jacket. Tense but safe and warm mood, never scary, no danger to anyone. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; phone and camera screens are blank or show only soft light. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekân (her istemde adı geçen tanım aynen eklenir):**
- **Paloma Ruiz:** 14-year-old girl, long dark-brown hair in a low ponytail, warm light-brown skin, bright orange hiking jacket, dark green trousers, brown hiking boots, an old silver film-style camera on a strap around her neck.
- **Jonas:** 14-year-old boy, tall and thin, short straight blond hair, pale skin, calm serious face, grey-blue jacket, small dark backpack.
- **Mrs Berg:** small woman about 50, short grey hair, weathered friendly face, bright red knitted hat, green outdoor jacket, walking stick.
- **The mountain:** wide grassy slopes with grey rocks, dark pine trees lower down, a round blue lake at the top; later thick white-grey fog.
- **The wooden house:** old dark-wood mountain house above the trees, warm yellow window light, a wooden fence, a gate and a grassy field behind it.

**Görsel istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Paloma and Jonas stand close together on grey rocks; a wall of soft white fog rolls towards them across the slope and swallows the path behind them; Paloma holds her camera, Jonas points into the fog. A tiny white star-shaped flower grows between two rocks at their feet. |
| p01.png | c1 · The Flower | Clear blue morning above an old wooden mountain house among pine trees; the class with backpacks gathers outside; Paloma crouches and photographs a pair of muddy shoes while Jonas watches, amused. |
| p05.png | c2 · Shelter | Inside thick fog: Jonas sits on wet ground holding his lower leg, Paloma kneels beside him with a worried face; later they huddle together behind a big rock under a thin silver emergency blanket, the orange jacket glowing in the grey. |
| p09.png | c3 · The Bells | Paloma and Jonas behind the rock, wrapped in the silver blanket, staring wide-eyed into the fog; several large, soft, completely unclear dark shapes are only hinted at far away in the mist, no recognisable animal features, no legs, no horns. |
| p12.png | c4 · Home Before Dark | Evening light through thinning fog: a line of goats with bells walks down a stony slope; at the back an old big goat looks back; Paloma helps Jonas, who limps with his arm over her shoulder, following them. |

**Sürpriz kontrolü:**
- **Kapak** keçi, çan ya da evi göstermez; yalnız sisin gelişini ve kanca sorusunu (yol kayboluyor) verir. Çiçek bölüm 1'in kendisidir, sonu ele vermez.
- **p01** ve **p05** keçisizdir; evin arkasındaki boş otlak gösterilmez.
- **p09** bölüm 3'ün başında açılır ve metinde keçi bu sayfanın içinde ortaya çıkar; görsel bu yüzden yalnız belirsiz karaltıları gösterir (boynuz, bacak, sakal, çan yok). Keçiler ilk kez **p12**'de (bölüm 4, açıklamadan sonra) görünür.
- Hiçbir görsel son sürprizi (keçilerin her akşam saat altıda eve dönmesi, dördüncü kuralın "Follow the bells" olması, Paloma'nın en sevdiği fotoğraf) göstermez; p12'de ev görünmez.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 332235ba-8a6f-4a05-8df5-d3dd06aaee63 | — | 2026-10-14T11:11:32+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | 5173a6f7-9828-4fe1-9898-8ccf4b003576 | 332235ba-8a6f-4a05-8df5-d3dd06aaee63 | 2026-10-14T11:14:46+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | 85d000ae-eaea-4cda-8fe0-0174bdbe085f | 332235ba-8a6f-4a05-8df5-d3dd06aaee63 | 2026-10-14T11:14:47+00:00 | 3:4, medium, 1k | 0.5 |
| p12.png | c98c6b02-1013-44ad-8eb0-9294c84a8541 | 332235ba-8a6f-4a05-8df5-d3dd06aaee63 | 2026-10-14T11:14:49+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | f188a079-c26b-4fb6-ac3a-f56f31adbc06 | 332235ba-8a6f-4a05-8df5-d3dd06aaee63 | 2026-10-14T11:14:49+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 2.5 kr. Tam istem metinleri yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

**Henüz üretilmedi.** Anlatıcı: Sarah (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.95 (A2 başlangıç değeri); anlatım temposu seviye varsayılanı (`auto`, hedef ~120 k/dk). Ses ElevenLabs **Creator (ticari)** hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilir; anahtar repo dışında. Tek anlatıcı. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T17:15:53Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 568 | 38.79 | 922d0afde0d64804bd34e63c3b07bc91 | 9bfcf9c8d13e50d5 |
| 2026-11-03T17:15:56Z | p01 | duyu-1 | - | - | - | 38.79 | - | 9bfcf9c8d13e50d5 |
| 2026-11-03T17:16:03Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 678 | 50.25 | 71968d29841749d9a6bdbce553b1f4d3 | e8dc1ac275a4c778 |
| 2026-11-03T17:16:07Z | p02 | duyu-1 | - | - | - | 50.25 | - | e8dc1ac275a4c778 |
| 2026-11-03T17:16:15Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 547 | 39.86 | 0d00fbae62fd478fa0ca7d5f7ffe30bd | 1a60da4ee72e23cf |
| 2026-11-03T17:16:18Z | p03 | duyu-1 | - | - | - | 39.86 | - | 1a60da4ee72e23cf |
| 2026-11-03T17:16:25Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 667 | 46.48 | 36b5919066d4456e889fe911f3935ed9 | 5f6d13b2fda9fe52 |
| 2026-11-03T17:16:29Z | p04 | duyu-1 | - | - | - | 46.48 | - | 5f6d13b2fda9fe52 |
| 2026-11-03T17:16:35Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 496 | 36.29 | 46555450840d46e5a3a7140b6dc91947 | a22e8ca301eeadd6 |
| 2026-11-03T17:16:38Z | p05 | duyu-1 | - | - | - | 36.29 | - | a22e8ca301eeadd6 |
| 2026-11-03T17:16:44Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 570 | 38.74 | 3ef635c0327b45da88e4f8b819cf67d6 | f035e7b2578c708d |
| 2026-11-03T17:16:47Z | p06 | duyu-1 | - | - | - | 38.74 | - | f035e7b2578c708d |
| 2026-11-03T17:16:53Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 501 | 34.86 | 306dcbdf90404b1185912708c4ba8e4d | 1f68b8972d556389 |
| 2026-11-03T17:16:57Z | p07 | duyu-1 | - | - | - | 34.86 | - | 1f68b8972d556389 |
| 2026-11-03T17:17:03Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 585 | 40.96 | b0adeff112a841c4ad8348ca724e177a | 519a0edffd045820 |
| 2026-11-03T17:17:06Z | p08 | duyu-1 | - | - | - | 40.96 | - | 519a0edffd045820 |
| 2026-11-03T17:17:12Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 480 | 35.37 | 22d082c2a2b74b1d87881942b67d9d36 | a68cd9de29f9ece2 |
| 2026-11-03T17:17:15Z | p09 | duyu-1 | - | - | - | 35.37 | - | a68cd9de29f9ece2 |
| 2026-11-03T17:17:21Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 501 | 35.5 | e6bd7c853e7840af9c71d1d020fed7e3 | 3801c1a60b368dc8 |
| 2026-11-03T17:17:24Z | p10 | duyu-1 | - | - | - | 35.5 | - | 3801c1a60b368dc8 |
| 2026-11-03T17:17:29Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 474 | 34.92 | 388cc7c6cb2f41f6969a257049cb4117 | 2c15201122953782 |
| 2026-11-03T17:17:32Z | p11 | duyu-1 | - | - | - | 34.92 | - | 2c15201122953782 |
| 2026-11-03T17:17:38Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 428 | 31.89 | 6aebdbe9e1124a899c741fb4cad70577 | ea46de0a671fa720 |
| 2026-11-03T17:17:41Z | p12 | duyu-1 | - | - | - | 31.89 | - | ea46de0a671fa720 |
| 2026-11-03T17:17:46Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 432 | 30.66 | 000f6b0997a842e3a178e149b3182288 | e47f4763423802df |
| 2026-11-03T17:17:49Z | p13 | duyu-1 | - | - | - | 30.66 | - | e47f4763423802df |
| 2026-11-03T17:17:54Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 765 | 52.28 | 107cebb8a93b43cb841b5fc2540dbd72 | 5454ca617026bc1c |
| 2026-11-03T17:18:02Z | p14 | duyu-1 | - | - | - | 52.28 | - | 5454ca617026bc1c |
| 2026-11-03T17:18:09Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 546 | 36.01 | 5d6605b0b68341d7b3be64fb15d98688 | a3aaba8914078fd4 |
| 2026-11-03T17:18:12Z | p15 | duyu-1 | - | - | - | 36.01 | - | a3aaba8914078fd4 |
| 2026-11-03T17:27:47Z | p13 | duyu-1 | - | - | - | 30.66 | - | e47f4763423802df |
| 2026-11-03T18:23:37Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 667 | 50.61 | 407c241f8e83496290015f06a4da8326 | 5f6d13b2fda9fe52 |
| 2026-11-03T18:23:41Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 667 | 50.06 | 98e36f09458c46a7920c84750c161771 | 5f6d13b2fda9fe52 |
| 2026-11-03T18:23:41Z | p04 | duyu-1 | - | - | - | 50.61 | - | 5f6d13b2fda9fe52 |
| 2026-11-03T18:23:45Z | p04 | duyu-1 | - | - | - | 50.06 | - | 5f6d13b2fda9fe52 |
| 2026-11-03T18:23:47Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 546 | 37.01 | a43f4f86c36c4f7e8e1289df55843377 | a3aaba8914078fd4 |
| 2026-11-03T18:23:52Z | p15 | duyu-1 | - | - | - | 37.01 | - | a3aaba8914078fd4 |
| 2026-11-03T18:23:53Z | p15 | duyu-1 | - | - | - | 37.01 | - | a3aaba8914078fd4 |
| 2026-11-04T08:37:02Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 667 | 51.97 | 69f07b84b4cf425681e3177a6b5043b4 | 5f6d13b2fda9fe52 |
| 2026-11-04T08:37:06Z | p04 | duyu-1 | - | - | - | 51.97 | - | 5f6d13b2fda9fe52 |
| 2026-11-04T08:37:14Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 546 | 38.41 | 8273cb876fed4d7b8d8b289367e892a8 | a3aaba8914078fd4 |
| 2026-11-04T08:37:22Z | p15 | duyu-1 | - | - | - | 38.41 | - | a3aaba8914078fd4 |
