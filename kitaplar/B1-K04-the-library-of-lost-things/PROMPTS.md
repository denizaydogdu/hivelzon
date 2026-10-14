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
