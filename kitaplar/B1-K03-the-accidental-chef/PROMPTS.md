# B1-K03 The Accidental Chef: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B1), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B1-K03 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B1 konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B1-K03 *The Accidental Chef* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 5 bölüm, 20 sayfa, ~3.000 kelime (B1 hedefi 3.000 ± %20). Hızlı, esprili, kuru mizah. B1: bağlaçlı cümleler; present perfect ile past simple (*I've never cooked fish / I cooked dal yesterday*), *should / have to*, 1. tip koşul, mutfak fiilleri (*chop, boil, fry, stir*); ayrıca past continuous, *used to*, past perfect, ilgi cümleleri, *might*, *-ed / -ing* sıfatları doğal biçimde. Türk öğrenci notu: *cook / cooker*. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, otel ve kişi yok. Kapsama CEFR-J ≤ B1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Katalogdan küçük yorumlar:**
- Katalogdaki "beş farklı adla aynı yemek" makarna oldu (Priya'nın öğrenciliğinden bildiği güvenli yemek); dal, 4. bölümdeki dürüst seçim için saklandı.
- Kimliği gizli yemek yazarına bir takma ad verildi: *the Silent Fork* (Sessiz Çatal). Gus otelde toplam üç hafta çalışıyor (Priya gelmeden iki hafta önce başlamış); eleştiri yazısının başlığı "Three Weeks at the Sink".
- Kamala, Priya'nın annesi Sunita'nın gençlikteki komşusu; dal'ı ona o öğretmiş.

**Adil son için yerleştirilen ipuçları (Gus = Sessiz Çatal):**
- Gus otelde yalnızca iki hafta önce başlamış; tertemiz elleri ve gömlek cebinde taşıdığı küçük gümüş kaşığı var (p07).
- Her şeyin, soğuk sebzelerin bile tadına bakıyor ve küçük siyah deftere not alıyor; "Alışveriş listem" diyor (p07, p10).
- Aşçılık bilgisi şaşırtıcı derecede kesin: "Ten minutes, not two", "Less butter", "Hotter pan" (p07, p10, p11).
- Sessiz Çatal'ın erkek mi kadın mı olduğu bilinmiyor; şüpheliler listesi (gri şapkalı adam, genç çift, büyük çantalı kadın) dikkati başka yere çekiyor (p08, p10).
- Priya dal'ı yapmaya karar verince Gus gülümseyip defterine yazıyor (p13); Bruno, Gus'un ona salı günü her şeyi anlattığını söylüyor ve Gus'un kaşığı kaybolmuş (p18).
- Yaşlı hanım kırmızı ringa: Ellie onu Sessiz Çatal sanıyor (p13), ama o Priya'nın annesinin eski komşusu çıkıyor (p17).

## Görsel planı ve üretim kaydı (2026-10-14)

> Kullanıcı kararı (2026-10-14, H-071): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 6 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (dalga 1'de 1k medium ile doğrulandı); tahmini toplam ≈ 3 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Lively comic-book panel illustration, non-photorealistic, bold clean ink outlines, flat colours with halftone texture, expressive faces and slapstick energy. Palette: shiny copper pots, tomato red, saffron yellow, cream-white kitchen tiles, a touch of sea blue. Mood: chaotic, warm, funny, never mean. A small seaside hotel kitchen. Absolutely no text, letters, numbers, signs, labels, logos or writing anywhere in the image; menus, CVs, newspapers, notebooks, screens and order slips are blank or drawn with abstract lines only. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Priya Nair:** 24-year-old woman of South Indian background, medium-brown skin, long black hair in a messy bun with a pencil stuck in it, big expressive eyes, slightly too big white chef's jacket with rolled-up sleeves, red apron; looks brave and panicked at the same time.
- **Chef Bruno:** big cheerful man about 60, round belly, bushy grey moustache, tall white chef's hat, white jacket; after the accident his right wrist is wrapped in a white cloth.
- **Gus:** quiet man aged 63, slim, neat grey hair, round glasses, very clean hands, rolled-up shirt sleeves under a long grey dishwasher's apron, a small silver spoon in his shirt pocket, a little black notebook; calm, observant, slight smile.
- **Mrs Ferris:** tall hotel manager in her 50s, sharp blue suit, short blonde hair, always moving fast, wide excited eyes.
- **Tom and Ellie:** two young cooks around 19; Tom tall and skinny with curly red hair, Ellie short with dark skin and braids under a cap; both in white jackets.
- **Kamala:** small old woman about 75 of South Indian background, grey hair in a low bun, bright sharp eyes, soft green cardigan over a simple dress.
- **The Seagull Hotel:** a small white seaside hotel; a busy kitchen with copper pans on the walls, steaming pots, a round window in the swing door to the dining room; the dining room has blue-and-white tablecloths and big windows over the sea.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Priya in her too-big chef's jacket stands in the middle of the busy hotel kitchen holding a wooden spoon up like a sword; pots steam and a pan flames slightly behind her; her face is half brave, half terrified; copper pans shine on the wall. |
| p01.png | p01 (Bölüm 1, The Interview) | A small, tidy city flat at night: Priya at her laptop (blank screen) with a pile of bills (blank paper) beside her, sending her CV; her cousin's colourful design open on the screen as abstract shapes; a cup of tea gone cold. |
| p05.png | p05 (Bölüm 2, One Dish, Five Names) | Priya, Tom and Ellie in the kitchen: five identical plates of tomato pasta in a row, each decorated differently (a lemon slice, a piece of chicken, green leaves, a lot of black pepper, a big question-mark-shaped swirl of sauce); Priya proudly presents them; Tom and Ellie look at each other doubtfully. |
| p09.png | p09 (Bölüm 3, Burnt but Proud) | Comic chaos: black smoke rises from a frying pan with a very black fish; Priya waves a towel at the smoke; Tom in the background drinks a big glass of water after tasting a chocolate cake; Gus at the sink watches calmly. |
| p13.png | p13 (Bölüm 4, Dal) | Quiet moment in the evening kitchen: Priya stands at the stove stirring a pot of golden dal, eyes half closed, remembering; warm light; a bag of lentils, onions and spices on the counter; Tom and Ellie watch from the side, surprised. |
| p17.png | p17 (Bölüm 5, The Review) | In the hotel dining room by the big window, Kamala sits at a table with an empty bowl and holds Priya's hands across the table; Priya, still in her apron, is laughing and nearly crying; the sea is blue outside. |

**Sürpriz kontrolü:** Sonun sürprizi, kimliği gizli yemek yazarının bulaşıkçı Gus olmasıdır. Hiçbir görselde Gus'un defterine yazdığı şey, gazete, eleştiri yazısı ya da Gus'un yazar olarak gösterilmesi yok. Kapakta Gus yok. Gus yalnızca p09'da arka planda, evyenin başında sakin bir bulaşıkçı olarak görünür; defter ya da kaşık vurgulanmaz. p17 Kamala ile Priya'nın sıcak anını gösterir; Kamala'nın annenin komşusu olduğu ayrıntısı metinde kalır. Gri şapkalı adam görsellerde gösterilmez.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | c216140b-1852-49af-8b12-76d9b722ff2e | — | 2026-10-14T15:53:58+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | 43f73ff2-6b0e-468a-9945-6d3bddf26a2f | c216140b-1852-49af-8b12-76d9b722ff2e | 2026-10-14T15:56:23+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | cbb06a33-8fe7-4113-8999-71eba7a6d5c0 | c216140b-1852-49af-8b12-76d9b722ff2e | 2026-10-14T15:56:23+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | 04e67ab0-b17d-45e4-8d1c-b127882ffa34 | c216140b-1852-49af-8b12-76d9b722ff2e | 2026-10-14T15:56:25+00:00 | 3:4, medium, 1k | 0.5 |
| p17.png | c4be0f2f-2527-45a5-98de-3d39c3e7faaf | c216140b-1852-49af-8b12-76d9b722ff2e | 2026-10-14T15:56:46+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 3fcee268-d973-452b-b80f-936a10018105 | c216140b-1852-49af-8b12-76d9b722ff2e | 2026-10-14T15:56:50+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 3 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B1 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, hedef ~135 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
