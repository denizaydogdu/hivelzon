# B1-K05 Second Violin: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B1), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B1-K05 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B1 konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B1-K05 *Second Violin* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 4 bölüm (The Same Chair, The Audition, Pigeons and Little Kids, Duet), 18 sayfa, ~3.000 kelime (B1 hedefi 3.000 ± %20). İçten, ölçülü, müzikal ritim. B1: bağlaçlı cümleler; present perfect (*for / since, ever / never, just*), karşılaştırma ve üstünlük, duygu sıfatları ve *-ed / -ing*, past continuous, *used to*, 1. tip koşul, ilgi cümleleri, *might / may*, past perfect; standart İngiliz İngilizcesi anlatı dilbilgisi (*had never heard*). Türk öğrenci notu: *for / since*. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. Sahne korkusu utandırmadan işlenir. 13+ güvenli; gerçek marka, kişi ve bilinen eser yok (parça uydurma: *Evening Song*). Kapsama CEFR-J ≤ B1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Kanca kararı:** Katalogdaki kanca present perfect ve şimdiki zamanda (*Noah has played second violin for three years, and he wants more.*). Metinde bu cümle, Noah'nın yeni defterinin ilk sayfasına kendisi hakkında, bir kitaptan satır gibi yazdığı cümle olarak kullanıldı; anlatı hemen ardından geçmiş zamana geçer. Son sayfada aynı cümle yeniden okunur ve altına yeni satır eklenir (çerçeve). `book.json → hookEn` katalogdakiyle birebir aynıdır.

**Adil son için yerleştirilen ipuçları:**
- Hana yalnızken harika çalıyor, kapı açılınca susuyor (p05); seçmede herkesten çok korkmuş, içeri girmeden çıkıyor (p06, p07).
- Bayan Adeyemi Noah'ya "You've always listened better than anyone in this orchestra" diyor (p07): Noah'nın gücü dinlemek.
- Hana'nın notalarında iki renk kurşun kalem notu: mavi düzgün yuvarlak yazı, yeşil küçük ve aceleyle (p08); Hana'nın elinde yeşil kalem (p09, p10).
- "She has a plan" (p10): Bayan Adeyemi'nin planı.
- Parkta Hana'nın yeşil kalemle yazdığı "yalnızca çalışmak için" ikinci ses; Noah'ya tuhaf biçimde tanıdık geliyor, sanki bazı yerlerini daha önce çalmış gibi (p13); birlikte çalınca Hana'nın titremesi duruyor (p13).
- Bayan Adeyemi yeşil notaları biliyor: "Have you practised the green music?" (p14); "that may depend on you", "bring your violin… and your best listening" (p15).
- Hana'nın "I can't do it" cümlesi (p14) "tek başıma yapamam" anlamındadır; açıklama p17'de.

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 5 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p15.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (dalga 1'de 1k medium ile doğrulandı); tahmini toplam ≈ 2,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Soft pastel chalk illustration on warm toned paper, non-photorealistic, gentle smudged edges, visible chalk grain, quiet and intimate. Palette: burgundy velvet, warm violin brown, evening lilac, soft cream highlights, a little muted green. Mood: inward, warm, hopeful, a little nervous. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; sheet music is drawn only as soft abstract lines without readable notes, phone screens and notebooks are blank or abstract. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Noah:** 15-year-old boy, slim, a little shy, light brown skin, short curly dark-brown hair, thoughtful brown eyes, a dark burgundy jumper over a white collar, holds his violin carefully; often carries a small dark notebook.
- **Hana:** 15-year-old girl, short straight black hair with a fringe, serious face, East Asian features, pale when nervous; an oversized green coat over plain clothes; on concert night a long dark blue dress.
- **Ms Adeyemi:** conductor, tall Black woman about 60, short grey hair, bright orange round glasses, calm kind face, simple dark clothes with a lilac scarf.
- **Ella:** Noah's sister, 7, round cheeks, two small curly bunches, yellow raincoat or (concert night) a red party dress, holds a child's drawing (no letters).
- **Ruby:** 16, leader of the first violins, tall, red hair in a ponytail, friendly grin.
- **The hall:** an old wooden concert hall with high arched windows, rows of chairs and music stands, warm lamplight, a small stage; a small practice room behind it with one window.
- **The park:** a city park with a round stone fountain, big trees, wooden benches, many grey pigeons, a small ice-cream cart without any sign.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Noah sits on a wooden chair in the second violin row of the empty old hall, violin resting on his knee, looking towards the empty front of the stage in a pool of warm lamplight; long lilac evening shadows; the other chairs are empty. |
| p01.png | p01 (Bölüm 1, The Same Chair) | A Saturday morning practice in the old hall seen from behind the second violins: Noah in the third chair on the left, many young musicians around him, Ms Adeyemi standing at the front with her orange glasses, waiting calmly for silence. |
| p06.png | p06 (Bölüm 2, The Audition) | A rainy day: a narrow wooden corridor with a row of nervous students sitting on chairs outside a closed door; Hana at the end of the row holds her violin case tightly against her chest; Noah, two seats away, looks at her with surprise; rain on the window. |
| p10.png | p10 (Bölüm 3, Pigeons and Little Kids) | A sunny Sunday in the park by the round fountain: Hana plays her violin with her eyes half closed while grey pigeons walk around her feet; Noah sits on a bench nearby, listening carefully; Ella and two small friends sit on the grass eating crisps. |
| p15.png | p15 (Bölüm 4, Duet) | Concert evening: backstage near the stage door, Hana in a long dark blue dress stands very still, pale and holding her violin; through the half-open door the warm lights of the hall and the audience are visible as soft shapes. Noah is not in the picture. |

**Sürpriz kontrolü:** Sonun sürprizi, solonun haftalar önce Bayan Adeyemi'nin onayıyla Noah'nın ikinci keman çizgisinden doğan bir düete çevrilmiş olması ve konserde Noah'nın öne çağrılmasıdır. Hiçbir görselde Noah ile Hana sahnede birlikte çalarken gösterilmez; kapakta Noah tek başınadır; p10'da Noah çalmaz, yalnızca dinler; p15'te Noah görünmez. İki renkli kalem notları ve yeşil nota kâğıdı hiçbir görselde yer almaz (yalnız metinde, resimsiz sayfalar p08, p13, p17).

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B1 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, hedef ~135 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
