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

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071): kalan kitaplarda yalnız **kapak + her bölümün ilk sayfası**. Bu kitapta 3 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png` (git dışı; adlar `book.json` ile aynı). Öbür sayfalar resimsiz, palet renkli (`image: null`).
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

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.9; ninni tonu, son sayfa daha yavaş (anlatım temposu A1 `auto`, §6.5). Ses ElevenLabs **Creator** (ticari) hesabıyla, `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip maliyet onayı alındıktan sonra üretilir (H-071). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
