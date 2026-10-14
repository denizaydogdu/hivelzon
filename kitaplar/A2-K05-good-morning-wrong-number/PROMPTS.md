# A2-K05 Good Morning, Wrong Number: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1 (A1 + A2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A2-K05 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; pilot kitaplar örnek alındı |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "A2-K05 *Good Morning, Wrong Number* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 4 bölüm, 15 sayfa, ~1.500 kelime (± %20). A2: her cümle ≤ 12 kelime; past simple, *because / so*, sıklık zarfları, kısa mesaj dili ile tam cümle farkı; Türk öğrenci notu *I'm bored / I'm boring*. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. Çevrim içi güvenlik: Mateo mesajları baştan annesine gösterir, ilk cevabı birlikte yazarlar, adres ve fotoğraf paylaşılmaz, son buluşma annesiyle, kalabalık plajda ve tanıdık biriyle. 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J ≤ A2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Bölüm kancaları:** c1 cuma sabahı fotoğraf gelmez (p04) · c2 "mavi balkonlu sarı ev" Mateo'nun evidir (p08) · c3 boş kırmızı sandalye ve "Tomorrow is my last day here." (p12) · c4 son: Ines ve gönüllü cankurtaranlık daveti.

**Adil son için yerleştirilen ipuçları:**
- p04: Mateo'nun ilk yüzme dersi; kırmızı şapkalı, düdüklü, uzun boylu kadın ve "Head up, Mateo! Kick your legs!".
- p07: Gönderen yüzücüleri biliyor; "Because I work at the beach. My job is to watch the sea."
- p10–p11: Fotoğraflar hep aynı yerden, yüksekten ve plajın ortasından; kırmızı şamandıra ve köşede tahta basamak.
- p11: Mesajda aynı sözler: "Head up! Kick your legs!"
- p12: Kumun üstünde, yüksekte boş kırmızı sandalye ve eski kırmızı şapka.
- p13: Annenin tuhaf gülümsemesi (p14'te açıklanır: o sözleri dokuz yıl önce bütün yaz duymuştu).

**Ad yazımı:** Katalogdaki *Inês* metinde *Ines* (`rights-and-review.md`).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: dalga 1 metinleri ve 34 görsel (~17 kr) onaylandı ("İlk dalganın 8 kitap metni … onay", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, medium, 1k = 0,5 kr. Bölüm başları kapak işi referans verilerek üretildi. Eski plan notu: Kullanıcı kararı (2026-10-14, pilot sonrası): kalan 28 kitapta **kapak + bölüm başı** görseli. Bu kitapta 5 görsel: kapak + 4 bölüm başı (p01, p05, p09, p13); diğer sayfalar resimsiz, kitap paletiyle renkli (`book.json → image: null`). Standart yol: GPT Image 2.5, 3:4, ~0,5 kr/görsel (≈ 2,5 kr). **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve onay alınır.** Dosyalar `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png` (git dışı). Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Watercolour storybook illustration, non-photorealistic, soft wet edges and visible paper texture, nostalgic and full of light. Palette: Atlantic turquoise, sunny yellow house, bright blue balcony, small red fishing boat, warm sand, morning pink sky. Gentle, warm, slightly melancholic but hopeful mood. Absolutely no text, letters, numbers, signs or writing anywhere in the image; phone screens show only a small picture of the sea, never any words, icons with letters or message bubbles. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekân (her istemde adı geçen karakterin tanımı aynen eklenir):**
- **Mateo:** 15-year-old boy, slim, warm light-brown skin, short dark curly hair, brown eyes, faded turquoise T-shirt, grey shorts; left leg in a white plaster cast from foot to knee (chapters 1–3); uses two wooden crutches.
- **Mum:** Mateo's mother, early 40s, dark hair in a low ponytail, sun-tanned, simple white shirt with rolled sleeves, calm attentive face.
- **The house:** small sunny-yellow house on a green hill above the sea, with a bright blue balcony and white window frames; from the balcony you see a wide sandy beach, black rocks on the right, a small café, the Atlantic.
- **The island:** small unnamed Atlantic island, white and pastel houses on the hill, red fishing boat, turquoise water, pink morning light.
- **Ines** (only for later use, not in this plan's images): not shown in any planned image (see Sürpriz kontrolü).

| Dosya | Sahne |
|---|---|
| cover.png | Mateo sits on the blue balcony of the yellow house at sunrise, his cast leg on a small stool, holding his phone; the phone screen shows only a tiny picture of a turquoise sea; beyond the balcony, the wide quiet sea under a pink sky. No other people. |
| p01.png | Early morning in Mateo's small bedroom; he lies in bed with his white cast leg on a pillow, looking surprised at his glowing phone (screen: only a small sea picture); a window with pink sky and sea behind. |
| p05.png | Mateo and Mum sit side by side at a sunny kitchen table, both looking at the phone in his hands; Mum points gently at the screen; crutches lean against the table; a bowl of fruit, morning light. |
| p09.png | Mum and Mateo on the blue balcony looking down at the beach from far away: sand, black rocks on the right, a small café, tiny people and umbrellas; Mum calm, her hand on Mateo's shoulder. |
| p13.png | Mateo, cast off, his left leg thin and pale, walks slowly down the hill path with one crutch next to Mum, who smiles a secret smile; below them the busy beach and, small in the distance, a tall white wooden tower with an empty red chair on top. |

**Sürpriz kontrolü:** Gönderenin kim olduğu ve fotoğrafların cankurtaran kulesinden çekildiği sona kadar saklıdır. Kapakta yalnız Mateo, balkon ve deniz var; telefon ekranında yalnız deniz resmi (yazı yok), başka kişi, kule, kırmızı şapka ya da düdük yok. p01, p05 ve p09'da da kule, kırmızı sandalye, şapka ve Ines yok (p09'da plaj uzaktan, kule vurgulanmadan; istemde "no tower" eklenir). Kule yalnız p13'te, uzakta ve boş görünür: bölümün adı zaten *The Tower* ve sayfa metni kuleyi aynı sayfada anlatıyor; Ines'in kendisi hiçbir planlı görselde yok, bu yüzden sürpriz (yüzme öğretmeni) p14'te okurla birlikte açılır.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 85793bb7-88e4-4220-ae96-1e53ebe42bba | — | 2026-10-14T11:12:09+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | 32b1977d-07f8-4f07-8106-51273d2e1273 | 85793bb7-88e4-4220-ae96-1e53ebe42bba | 2026-10-14T11:15:37+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | 828d0d6c-6f61-4c87-bf32-90fdd401773d | 85793bb7-88e4-4220-ae96-1e53ebe42bba | 2026-10-14T11:15:37+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 2a7375dc-b58f-44a5-8f40-1ccc3ea2289f | 85793bb7-88e4-4220-ae96-1e53ebe42bba | 2026-10-14T11:15:39+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | 0f8ea692-c6dd-4177-a197-bc02726c6acf | 85793bb7-88e4-4220-ae96-1e53ebe42bba | 2026-10-14T11:15:41+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 2.5 kr. Tam istem metinleri yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.95 (A2 başlangıç; anlatım temposu dışa aktarmada `auto`, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip maliyet onayı alındıktan sonra üretilecek. Tek anlatıcı. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
