# A1-K03 The Red Kite: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1 (A1 + A2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A1-K03 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json` |

**İstem (özet):** "A1-K03 *The Red Kite* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 3 bölüm, 12 sayfa, ~700 kelime (±%20). A1: her cümle ≤ 8 kelime, present simple, yan cümle yok; hareket ve yer edatları (*over, up, down, into, after, near*), hava (*The wind is very strong.*), *can / can't*. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka ve kişi yok; fiyat birimsiz. Kapsama CEFR-J A1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Uyarlama notları:** Katalogdaki "The wind turns at noon" A1 düzeyinde ve öğle yemeği saatiyle bağ kursun diye "The wind turns at twelve" oldu (*noon* A1 dışı). Uçurtma "tramvayın çatısında" yerine "tramvayın tepesinde" (*on top of the tram*), "teknenin direğinde" yerine "beyaz teknenin üstünde"; *roof* ve *mast* gereksiz liste dışı kelime olmasın diye.

**Adil son için yerleştirilen ipuçları:** evin tepede olması ve çiçekli küçük balkon (p01); annenin "Lunch is at twelve" demesi (p01, p08); Bay Das'ın "The wind turns at twelve" demesi (p03); rüzgârın sabah uçurtmayı tepeden aşağı, nehre götürmesi (p02–p04); Ravi'nin saat on birde saatine bakması (p08); saat on ikide çalan kasaba saati ve dönen rüzgâr (p10).

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14): kalan 28 kitapta **kapak + bölüm başı**. Bu kitapta 4 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png` (git dışı); diğer sayfalar resimsizdir ve kitabın paletiyle renklidir (`book.json → image: null`). Model GPT Image 2.5, 3:4, ~0,5 kr/görsel (≈ 2 kr). Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve onay alınır. Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Watercolour and ink-line storybook illustration, non-photorealistic, light loose washes with fine dark ink outlines, airy and full of movement, bright and cheerful, never scary. Palette: sky blue, soft pastel houses (pink, peach, mint, pale yellow), river grey-blue; the red kite is the only strong warm accent. Hilly harbour town by the sea. Absolutely no text, letters, numbers, signs, shop names or writing anywhere in the image; clocks have plain faces without numbers or marks. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçen tanım aynen eklenir):**
- **Ravi:** 9-year-old boy of Indian heritage, warm brown skin, short thick black hair, big bright eyes, sky-blue T-shirt, khaki shorts, white sneakers, a small wristwatch with a plain face.
- **The red kite:** a diamond-shaped bright red kite with thin yellow stripes and a short yellow ribbon tail, clearly home-made.
- **Mum:** Ravi's mother, late 30s, long black hair in a braid, mustard-yellow kurta top, warm smile.
- **Mr Das:** fruit seller in his 60s, round and cheerful, grey moustache, big white cloth hat, green apron, crates of apples, oranges and bananas.
- **The town:** pastel houses on steep hills, narrow streets with long stone stairs, an old yellow tram, a wide grey-blue river with boats, a small green ferry, a long bridge downstream.
- **Ravi's home:** a pastel house high on a hill with a small balcony full of flowers in pots.

**Görsel istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sahne |
|---|---|
| cover.png | Ravi runs down a steep pastel street, arms reaching up; high above the rooftops the red kite flies away towards the river, tail fluttering. |
| p01.png | Sunday morning on the hilltop park: Ravi holds his new red kite high, ready to run; wind bends the trees; the pastel town and the river far below. |
| p05.png | Inside an old yellow tram going downhill; Ravi kneels on the seat with his face at the window, looking up; pastel houses pass by. |
| p09.png | Ravi stands on a small green ferry crossing the wide grey-blue river, hair blowing; ahead, a white boat with a tiny red kite on top. |

**Sürpriz kontrolü:** Sürpriz, rüzgârın öğlen dönüp uçurtmayı Ravi'nin kendi balkonuna getirmesidir. Hiçbir istemde balkon, Ravi'nin evi ya da uçurtmanın geri dönüşü yok. Kapakta uçurtma Ravi'den **uzaklaşıyor** (nehre doğru); p01'de evin balkonu değil, tepe parkı ve uzaktaki nehir var; p09 bölüm 3'ün başındaki ana (karşıya geçiş) kalır, sona geçmez. Annenin tanımı yalnız ileride gerekirse diye tutuldu; bu dört görselde kullanılmaz.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.9; anlatım temposu dışa aktarmada A1 varsayılanı `auto` (§6.5). Ses, **ElevenLabs Creator** (ticari lisans) hesabıyla ve önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip onay alındıktan sonra üretilir. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
