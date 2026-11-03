# A2-K04 The Girl Who Never Saw Rain: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1 (A1 + A2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A2-K04 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "A2-K04 *The Girl Who Never Saw Rain* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 4 bölüm, 16 sayfa, ~1.500 kelime (A2 hedefi 1.500 ± %20). A2: her cümle ≤ 12 kelime; past simple anlatı, karşılaştırma (*heavier, bigger than, the same as*), *going to*, hava ve duyu sözcükleri (*smell, feel, wet, dry*). İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J ≤ A2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Adil son için yerleştirilen ipuçları:**
- Yağmurun kokusu var: Leo'nun mektubu, "the earth smells sweet after rain" (p02), Nia'nın antrenmanda bunu hatırlaması (p03).
- Sulama boruları ve başlıkları; biri tam Nia'nın penceresinin altından geçiyor; geceleri çalışıyor; suyu ılık, "like bath water"; Nia "It's like rain!" diyor (p07).
- Leo, Nia'nın üzüldüğünü görüp tek söz etmeden çıkıyor; arka kapının sesi (p11).
- Gece "yağmuru": beklenenden ılık, Leo ıslak ve ayakkabıları çamurlu, Nia'ya bakmıyor (p13); koku yok, Lunaria'daki su gibi; gökyüzünde yıldızlar ve tek küçük bulut; su yandan, pencerenin yakınından geliyor (p14).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: dalga 1 metinleri ve 34 görsel (~17 kr) onaylandı ("İlk dalganın 8 kitap metni … onay", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, medium, 1k = 0,5 kr. Bölüm başları kapak işi referans verilerek üretildi. Eski plan notu: Kullanıcı kararı (2026-10-14): kalan 28 kitapta resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 5 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png` (git dışı; adlar `book.json` ile aynı). Diğer sayfalar resimsiz, palet renkli (`image: null`).
> Model ve maliyet: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (pilotta 1k medium), toplam ≈ 2,5 kr. Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır. Sayfa görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Retro science-fiction book illustration in a 1960s–70s paperback style, non-photorealistic, gouache and airbrush textures, soft grain, simple rounded shapes. Palette: moon grey and deep black for the Moon, mustard yellow and dry ochre earth for the farm, one clear rain blue accent, warm cream highlights. Mood: wonder and longing, calm, never scary. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; screens, maps, cards and notebooks are drawn blank or with abstract shapes only. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Nia:** 13-year-old girl born on the Moon, slim and a little pale, dark brown skin, short black hair in two small puffs, big curious eyes, silver-grey jumpsuit with a mustard-yellow stripe; on Earth a plain light-blue T-shirt and grey trousers.
- **Leo:** 13-year-old boy, tanned, messy sandy-brown hair, freckles, wide friendly grin, faded green T-shirt, rolled-up jeans, old brown boots.
- **Grandma Edda:** woman about 70, strong and small, white hair in a long braid, deeply tanned kind face, ochre work shirt with rolled sleeves, straw hat.
- **Mum and Dad:** scientists in their 40s; Mum tall with short grey-streaked hair and round glasses; Dad bearded, gentle, quiet smile; both in simple grey travel clothes.
- **Lunaria:** a small Moon town under a huge round glass roof; grey dust, round white buildings, black starry sky; the blue-and-white Earth hangs far away in the sky.
- **The farm:** a small wooden farmhouse with a tin roof in a wide, hot, dry valley; yellow and brown fields with long cracks in the ground; low hills.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Nia in her silver-grey jumpsuit stands at a round window inside the glass-roofed Moon town, one hand on the glass, looking up at the small blue-and-white Earth in the black sky; her face full of longing. |
| p01.png | p01 (Bölüm 1, Moon Girl) | Lunaria from the inside: grey dust, round white buildings under the big glass roof; Nia sits by her bedroom window with a letter (blank paper) in her lap, looking at the distant Earth. |
| p05.png | p05 (Bölüm 2, Too Much Sky) | Nia at the open door of a small, rounded spaceship on a hot, dry landing field; the endless bright blue sky above her; she holds Dad's hand tightly and looks down at her feet, legs heavy; Mum carries a bag behind them. |
| p09.png | p09 (Bölüm 3, Friday) | Nia and Leo stand in a dry, cracked field with their faces turned up; huge dark grey clouds roll in over the hills; Grandma Edda sets out empty metal buckets in the garden; wind moves the trees. |
| p13.png | p13 (Bölüm 4, The Smell of Rain) | Night in the farmhouse garden: Nia in her pyjamas laughs and spins with her arms open, her hair and face wet and shining in the light from the back door; the scene is lit warmly from the house; no source of water is shown. |

**Sürpriz kontrolü:** Sonun sürprizi, ilk "yağmurun" Leo'nun açtığı sulama boruları olmasıdır. Hiçbir görselde çalışan sulama başlığı, Leo'nun çarkı çevirmesi, boru ya da yıldızlı açık gökyüzü altında yağan su gösterilmez. Kapak yalnız Nia'nın özlemini (Ay ve uzaktaki Dünya) gösterir; sonu, yağmuru ya da Leo'yu göstermez. p13 yalnızca Nia'nın sevincini gösterir; suyun nereden geldiği görünmez, Leo görünmez, gökyüzü kadraj dışındadır. Borular yalnızca metinde (p07, resimsiz sayfa) geçer.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | c9814759-b88d-4323-99c9-a39ec2731a3e | — | 2026-10-14T11:11:51+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 36e54c6f-71e7-4402-a633-a7040f445a60 | c9814759-b88d-4323-99c9-a39ec2731a3e | 2026-10-14T11:15:12+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | 497fcf1a-0061-4d63-afae-bbf57151ff32 | c9814759-b88d-4323-99c9-a39ec2731a3e | 2026-10-14T11:15:12+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | 76732da9-1660-405f-a40d-d126ca09f606 | c9814759-b88d-4323-99c9-a39ec2731a3e | 2026-10-14T11:15:12+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | e613facd-103c-4ba0-a362-c36b3d4e4fa1 | c9814759-b88d-4323-99c9-a39ec2731a3e | 2026-10-14T11:15:14+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 2.5 kr. Tam istem metinleri yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.95 (A2 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T17:20:28Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 606 | 42.48 | d05fdc42863b49fa839dbea00b9291dc | 456a3ec850fb46d9 |
| 2026-11-03T17:20:32Z | p01 | duyu-1 | - | - | - | 42.48 | - | 456a3ec850fb46d9 |
| 2026-11-03T17:20:39Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 579 | 39.54 | 4487108b7f46481aaf190daa6e33ab5c | 1466d406bdd376cc |
| 2026-11-03T17:20:43Z | p02 | duyu-1 | - | - | - | 39.54 | - | 1466d406bdd376cc |
| 2026-11-03T17:20:48Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 420 | 28.39 | 1f6de60a4b214043b06809c4da6c9cad | d2c8cda3aa9a28b9 |
| 2026-11-03T17:20:51Z | p03 | duyu-1 | - | - | - | 28.39 | - | d2c8cda3aa9a28b9 |
| 2026-11-03T17:20:56Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 476 | 34.91 | b64ee13da8084910927e5b025bc050b1 | 0938ee74617a0bed |
| 2026-11-03T17:21:00Z | p04 | duyu-1 | - | - | - | 34.91 | - | 0938ee74617a0bed |
| 2026-11-03T17:21:06Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 509 | 36.74 | 1369bb5c7fa042c0b98628c62bb42c5b | acac62403844c19d |
| 2026-11-03T17:21:10Z | p05 | duyu-1 | - | - | - | 36.74 | - | acac62403844c19d |
| 2026-11-03T17:21:14Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 407 | 29.88 | 710a1d453e334bc3aab5ba5031aa3ebc | 0eff2da8dfa6615d |
| 2026-11-03T17:21:17Z | p06 | duyu-1 | - | - | - | 29.88 | - | 0eff2da8dfa6615d |
| 2026-11-03T17:21:24Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 735 | 51.15 | 6b60efc765a446968c6c5d03189e761d | 473fa4fd772130b9 |
| 2026-11-03T17:21:28Z | p07 | duyu-1 | - | - | - | 51.15 | - | 473fa4fd772130b9 |
| 2026-11-03T17:21:34Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 397 | 27.87 | 307451db3d2642fd8d4d856e11b22ab7 | 11b60fba502debeb |
| 2026-11-03T17:21:38Z | p08 | duyu-1 | - | - | - | 27.87 | - | 11b60fba502debeb |
| 2026-11-03T17:21:48Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 533 | 40.03 | f5256c28680f4a7f9b46d6619dedfc03 | 01b9962d3a3cc5d9 |
| 2026-11-03T17:21:52Z | p09 | duyu-1 | - | - | - | 40.03 | - | 01b9962d3a3cc5d9 |
| 2026-11-03T17:22:04Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 438 | 30.59 | 614cef85ed254a00b88722d1445ae634 | 2a27b24d8cd6fe20 |
| 2026-11-03T17:22:08Z | p10 | duyu-1 | - | - | - | 30.59 | - | 2a27b24d8cd6fe20 |
| 2026-11-03T17:22:19Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 383 | 28.62 | a8459934ace643ab9d32dd554ceef036 | 44876f8d53de992f |
| 2026-11-03T17:22:22Z | p11 | duyu-1 | - | - | - | 28.62 | - | 44876f8d53de992f |
| 2026-11-03T17:22:31Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 347 | 28.21 | ee411b88bb9d48f297baa2672320f2d7 | f8baa5f41876f95d |
| 2026-11-03T17:22:34Z | p12 | duyu-1 | - | - | - | 28.21 | - | f8baa5f41876f95d |
| 2026-11-03T17:22:45Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 350 | 25.94 | ee46d60d4c7049c89535fef0c88aed97 | c0604b9061ffc2dd |
| 2026-11-03T17:22:47Z | p13 | duyu-1 | - | - | - | 25.94 | - | c0604b9061ffc2dd |
| 2026-11-03T17:22:59Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 489 | 35.91 | fcf8e383105746f999f7c21da39c53ae | 3f8e79c666996318 |
| 2026-11-03T17:23:03Z | p14 | duyu-1 | - | - | - | 35.91 | - | 3f8e79c666996318 |
| 2026-11-03T17:23:18Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 578 | 40.37 | 67ed59b76b524bdf84a0192df993cbfa | c8518a3d9f9bff73 |
| 2026-11-03T17:23:22Z | p15 | duyu-1 | - | - | - | 40.37 | - | c8518a3d9f9bff73 |
| 2026-11-03T17:23:43Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 619 | 41.28 | b227b8ddb07d40c68f5d17e7e82f40fc | ae510e1e9c2346a1 |
| 2026-11-03T17:23:47Z | p16 | duyu-1 | - | - | - | 41.28 | - | ae510e1e9c2346a1 |
