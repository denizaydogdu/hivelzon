# B1-K04 The Library of Lost Things: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B1), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B1-K04 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B1 konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B1-K04 *The Library of Lost Things* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 5 bölüm, 20 sayfa, ~3.000 kelime (B1 hedefi 3.000 ± %20). B1: bağlaçlı birleşik cümleler; anlatı past simple + standart İngiliz İngilizcesiyle past perfect (*had lost, had never seen*); present perfect (*Have you seen…? I've had it for a week.*), *used to*, past continuous (*while she was going down*), 1. tip koşul, ilgi cümleleri (*who / which / that*), *might*, *-ed / -ing* sıfatları. Masalsı, sakin, biraz komik (kayıp sabır, kayıp öğleden sonralar). İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, kişi ve şehir yok. Kapsama CEFR-J ≤ B1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Katalogdan küçük yorumlar:**
- Kütüphanecinin ilk sözü katalogdaki gibi bölüm 1'in son cümlesi: "We've been waiting for you to ask about it."
- Kütüphanenin içinde zaman farklı akar: Ines kapıdan döndüğünde istasyonda yalnızca bir dakika geçmiştir (p20). Saatteki zil sesleri yalnız kütüphanenin içindedir.
- Yolunu kaybeden yaşlı adam (Bay Pell) hafif ve komik çizildi: gözlüğünü ararken kaybolmuştur, gözlüğü başının üstündedir.

**Adil son için yerleştirilen ipuçları:**
- Bay Orrin defteri tanıyor ve heyecanlanıyor: "We know it very well." / "We've been waiting for you to ask about it." (p04).
- Kartta "ödünç verildi" simgesi (bir şey uzatan el) ve kartın arkasında kenara kadar uzanan minicik eller sırası: "it isn't exactly one person" (p08).
- Defter "çok rağbet görüyor", dün geri gelmiş ve bu sabah yine çıkmış (p09).
- Bay Pell defteri yolunu bulmak için kullanıyor ve "I added something to it… It seemed rude to take and give nothing back" diyor; defter "daha kalın" görünüyor (p11).
- Kütüphanenin kuralı: alan, yerine bir şey bırakır (p07, p12).
- Defter iki kat kalınlaşmış; sayfalar arasından renkli kâğıtlar, kurumuş çiçek, tüy, yapıştırılmış fazladan sayfalar çıkıyor (p16).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: B1 metinleri ve görselleri ("sana onaylar verdim", 2026-10-14). GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 6 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (dalga 1'de 1k medium ile doğrulandı); tahmini toplam ≈ 3 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Layered paper-cut illustration, non-photorealistic, several layers of cut paper with soft shadows between them, gentle depth, slightly dusty and magical. Palette: ink blue, old-paper yellow and cream, with bright touches of many-coloured umbrellas (red, yellow, teal) and a warm orange highlight. Mood: calm, magical, a little funny, never scary. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; shelf labels and drawer cards are small symbols only (a key, a cup, a moon, a hand); clock faces have no numbers, only lines; notebook pages are blank or show simple abstract shapes. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Ines:** 14-year-old girl, light-brown skin, dark wavy shoulder-length hair with a yellow hair band, thoughtful dark eyes, oversized mustard-yellow raincoat over a grey school jumper, a dark-blue school bag on her back.
- **Mr Orrin:** the librarian, tall and very thin man of about 65, silver hair, small round glasses, long dark-blue jacket with many pockets, a very long thin pen in his hand, kind and slightly mysterious smile.
- **Mr Pell:** small, round old man of about 80, long brown coat, soft brown hat, reading glasses pushed up on his head, cheerful lost expression, often holding a map upside down.
- **The green notebook:** a medium-sized sketchbook with a green cover and one chewed corner (only its closed cover is ever shown).
- **The station:** a fictional, unnamed old city train station in grey November light; a small lost-property window, a hot-drinks machine, and between them a small blue door with a round metal handle.
- **The Library of Lost Things:** a huge warm hall that cannot fit behind the station; endless tall shelves of keys, scarves, single shoes and toys; the Umbrella Hall with thousands of colourful umbrellas hanging from the ceiling; walls of small wooden drawers with symbol cards; a big clock with no numbers; Mr Orrin's wooden desk in the middle with old glass scales on it.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Ines, seen from behind and slightly to the side, stands in the open small blue door and looks into the enormous Library of Lost Things: tall shelves rising into the distance and a sky of colourful umbrellas hanging from the ceiling; warm light falls on her face. |
| p01.png | p01 (Bölüm 1, The Door) | A grey, quiet station in November: Ines stands at the small lost-property window with her school bag; between the window and a hot-drinks machine there is a small blue door with a round handle; people with suitcases walk past without looking at it. |
| p05.png | p05 (Bölüm 2, Umbrellas to the Ceiling) | Mr Orrin leads Ines through the Umbrella Hall; thousands of red, yellow, black and spotted umbrellas hang open and closed from a high ceiling like a coloured sky; Ines looks up with her mouth open. |
| p09.png | p09 (Bölüm 3, Borrowers) | In a room full of old maps at the bottom of a narrow staircase, Ines meets Mr Pell, who is turning a map round and round in his hands, his reading glasses on top of his head; a small silver bell hangs on the wall. |
| p13.png | p13 (Bölüm 4, What to Leave) | At Mr Orrin's wooden desk, Ines empties her school bag: a maths book, half a sandwich, a hair band and a ticket lie next to old glass scales; Mr Orrin watches politely; the big clock with no numbers on the wall behind them. |
| p17.png | p17 (Bölüm 5, The Most Borrowed Book) | Ines sits on the floor of the library holding the closed, very thick green notebook to her chest with both arms; small pieces of coloured paper and a feather stick out from between its pages; Mr Orrin smiles at her over his glasses. |

**Sürpriz kontrolü:** Sonun sürprizi, defterin kütüphanenin en çok ödünç alınan eşyası olması ve her ödünç alanın Ines'in resimlerine bir cevap çizmesidir. Hiçbir görselde defterin açık sayfaları, eklenmiş çizimler, başka insanların defteri elinde tutması ya da kuyruk hâlinde ödünç alanlar gösterilmez. Kapak yalnız kapıyı ve kütüphanenin büyüsünü gösterir. p09'da Bay Pell'in elinde defter değil harita vardır. p17'de defter kapalıdır; yalnızca kalınlığı ve aradan çıkan kâğıtlar (metinde p16'da zaten anlatılan) görünür.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 82e3e476-37a2-4a8b-8a5e-8e4a8f42e61b | — | 2026-10-14T15:54:21+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | c24bf9e5-f6e7-4faa-8caa-cf1e41413ebd | 82e3e476-37a2-4a8b-8a5e-8e4a8f42e61b | 2026-10-14T15:57:16+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | d0f646e6-316e-4eaa-8849-70b6f79d5c54 | 82e3e476-37a2-4a8b-8a5e-8e4a8f42e61b | 2026-10-14T15:57:17+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | c746b2ff-d062-4356-b47b-4f390b2d7a71 | 82e3e476-37a2-4a8b-8a5e-8e4a8f42e61b | 2026-10-14T15:57:18+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | ad10e8da-e6fc-4cd8-8c74-14ca95054bfd | 82e3e476-37a2-4a8b-8a5e-8e4a8f42e61b | 2026-10-14T15:57:34+00:00 | 3:4, medium, 1k | 0.5 |
| p17.png | ba8fd5b7-d56a-4833-aec2-e90f68a934f3 | 82e3e476-37a2-4a8b-8a5e-8e4a8f42e61b | 2026-10-14T15:57:44+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 3 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B1 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, hedef ~135 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T17:42:17Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 814 | 54.97 | 3604936962c94277ba61c30a917746a8 | facc7b625ffa6f72 |
| 2026-11-03T17:42:21Z | p01 | duyu-1 | - | - | - | 54.97 | - | facc7b625ffa6f72 |
| 2026-11-03T17:42:29Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 782 | 50.54 | 5687ad57c5414a3f90397f2e13f0835f | 78af9a41d1e85cc8 |
| 2026-11-03T17:42:33Z | p02 | duyu-1 | - | - | - | 50.54 | - | 78af9a41d1e85cc8 |
| 2026-11-03T17:42:41Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 837 | 54.78 | a4fdd0ce691f4922a10dc2d67486b87e | 8b20de442dc1898e |
| 2026-11-03T17:42:46Z | p03 | duyu-1 | - | - | - | 54.78 | - | 8b20de442dc1898e |
| 2026-11-03T17:42:54Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 778 | 51.48 | 9fa3378bd8e541818c08c5f545a71457 | f9c6419b4df7fb7e |
| 2026-11-03T17:42:58Z | p04 | duyu-1 | - | - | - | 51.48 | - | f9c6419b4df7fb7e |
| 2026-11-03T17:43:06Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 781 | 52.35 | 4fc073f26536445083ccf594c985c65e | 972ef546675a04aa |
| 2026-11-03T17:43:10Z | p05 | duyu-1 | - | - | - | 52.35 | - | 972ef546675a04aa |
| 2026-11-03T17:43:19Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 960 | 63.34 | a5698e9aa20448dc959f6c9a5dc18428 | 828645aad3ef7bb3 |
| 2026-11-03T17:43:24Z | p06 | duyu-1 | - | - | - | 63.34 | - | 828645aad3ef7bb3 |
| 2026-11-03T17:43:33Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 840 | 54.8 | 5d1bf85cda394293b79004a2890bf85c | 912e7f7313d2a677 |
| 2026-11-03T17:43:39Z | p07 | duyu-1 | - | - | - | 54.8 | - | 912e7f7313d2a677 |
| 2026-11-03T17:43:47Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 801 | 55.1 | 7be4f72a13b94f3d909c10b739d18e47 | c6884abb9436af9f |
| 2026-11-03T17:43:52Z | p08 | duyu-1 | - | - | - | 55.1 | - | c6884abb9436af9f |
| 2026-11-03T17:44:00Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 815 | 50.99 | 379d3283667c42dfb147c87931a3a072 | acc3d3eefa810686 |
| 2026-11-03T17:44:04Z | p09 | duyu-1 | - | - | - | 50.99 | - | acc3d3eefa810686 |
| 2026-11-03T17:44:13Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 812 | 56.44 | d39b0aab730d43ae8c384ee584e13060 | d5fde198cb690b0d |
| 2026-11-03T17:44:18Z | p10 | duyu-1 | - | - | - | 56.44 | - | d5fde198cb690b0d |
| 2026-11-03T17:44:26Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 925 | 57.58 | b675381593634dbeb845b185fffb403c | ee667566416864b2 |
| 2026-11-03T17:44:30Z | p11 | duyu-1 | - | - | - | 57.58 | - | ee667566416864b2 |
| 2026-11-03T17:44:38Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 866 | 54.46 | 5460ca89bebf43889f85e60723234340 | 47b1e1a3bd030db2 |
| 2026-11-03T17:44:44Z | p12 | duyu-1 | - | - | - | 54.46 | - | 47b1e1a3bd030db2 |
| 2026-11-03T17:44:51Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 820 | 55.29 | 07eae7fb18d64951be8818d79d1de777 | a7aeaf47de9184b6 |
| 2026-11-03T17:44:57Z | p13 | duyu-1 | - | - | - | 55.29 | - | a7aeaf47de9184b6 |
| 2026-11-03T17:45:04Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 842 | 54.65 | 7d83d2dadcb34463afb2cd7cd39d50ad | 36e3b54164ee7fc2 |
| 2026-11-03T17:45:09Z | p14 | duyu-1 | - | - | - | 54.65 | - | 36e3b54164ee7fc2 |
| 2026-11-03T17:45:18Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 823 | 52.41 | d497859abbbd41bc8b067ec435eca29a | 37fb4ae9c61dd7f7 |
| 2026-11-03T17:45:22Z | p15 | duyu-1 | - | - | - | 52.41 | - | 37fb4ae9c61dd7f7 |
| 2026-11-03T17:45:29Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 755 | 51.33 | ea922ec8e49b4b37a296bc8dbb84ba46 | 521c2b9d2f81dc2d |
| 2026-11-03T17:45:33Z | p16 | duyu-1 | - | - | - | 51.33 | - | 521c2b9d2f81dc2d |
| 2026-11-03T17:45:41Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 786 | 50.6 | d31e1a06142f43208cf4de0956ea695a | 8691cee5f3547b11 |
| 2026-11-03T17:45:45Z | p17 | duyu-1 | - | - | - | 50.6 | - | 8691cee5f3547b11 |
| 2026-11-03T17:45:53Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 797 | 54.82 | 40144495e6da4da4aebda99827385850 | 4acc58c4a3ca0cd6 |
| 2026-11-03T17:45:58Z | p18 | duyu-1 | - | - | - | 54.82 | - | 4acc58c4a3ca0cd6 |
| 2026-11-03T17:46:07Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 783 | 51.99 | 5c174856043a4542b1052a22d79e7d83 | beb2a8a7d2211e8f |
| 2026-11-03T17:46:11Z | p19 | duyu-1 | - | - | - | 51.99 | - | beb2a8a7d2211e8f |
| 2026-11-03T17:46:19Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 900 | 58.02 | b58ab98ebc764e7b837d5fcc6196c242 | 4d3995c1e57f72dd |
| 2026-11-03T17:46:24Z | p20 | duyu-1 | - | - | - | 58.02 | - | 4d3995c1e57f72dd |
