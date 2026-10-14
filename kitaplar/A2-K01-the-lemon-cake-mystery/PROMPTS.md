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

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071): kalan 28 kitapta resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 5 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ~0,5 kr/görsel (pilotta 1k medium ile doğrulandı; tahmini toplam ≈ 2,5 kr). **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

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

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.95 (A2 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilir; anahtar repo dışında. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
