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

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: B1 metinleri ve görselleri ("sana onaylar verdim", 2026-10-14). GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 5 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p15.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (dalga 1'de 1k medium ile doğrulandı); tahmini toplam ≈ 2,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

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


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | aeadca17-5b27-45f4-a0cb-d1f5e31e6a03 | — | 2026-10-14T15:54:38+00:00 | 3:4, medium, 1k | 0.5 |
| p15.png | 20ee6fb6-a3dc-4773-8d94-62db2574f678 | aeadca17-5b27-45f4-a0cb-d1f5e31e6a03 | 2026-10-14T15:58:10+00:00 | 3:4, medium, 1k | 0.5 |
| p10.png | 88d5da0b-c49e-46bd-b1f5-c35886788c36 | aeadca17-5b27-45f4-a0cb-d1f5e31e6a03 | 2026-10-14T15:58:10+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | 917d98e6-f726-47ec-bd36-bf391ebe2ec9 | aeadca17-5b27-45f4-a0cb-d1f5e31e6a03 | 2026-10-14T15:58:11+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 92292597-58ac-4534-aed4-e4ad67c8e22e | aeadca17-5b27-45f4-a0cb-d1f5e31e6a03 | 2026-10-14T15:58:11+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 2.5 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B1 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, hedef ~135 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T17:46:32Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 863 | 54.48 | 6c381697804c4a15808722cf0b11c114 | bf0816d5c2985899 |
| 2026-11-03T17:46:40Z | p01 | duyu-1 | - | - | - | 54.48 | - | bf0816d5c2985899 |
| 2026-11-03T17:46:49Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 812 | 54.13 | dc5c269158e84ccfbfd29a916cff3d69 | 2f58c21bfa2973d9 |
| 2026-11-03T17:46:54Z | p02 | duyu-1 | - | - | - | 54.13 | - | 2f58c21bfa2973d9 |
| 2026-11-03T17:47:01Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 766 | 50.12 | da2f9791a33c471eafadf6360cd160b8 | 7d21bd71e2b8547f |
| 2026-11-03T17:47:05Z | p03 | duyu-1 | - | - | - | 50.12 | - | 7d21bd71e2b8547f |
| 2026-11-03T17:47:12Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 740 | 48.21 | 97b391a789244b6dbd859958fc275217 | 4a3651d3a0bb811b |
| 2026-11-03T17:47:15Z | p04 | duyu-1 | - | - | - | 48.21 | - | 4a3651d3a0bb811b |
| 2026-11-03T17:47:24Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 845 | 57.96 | c2eba270f4674bbca5cadcead8e272af | 80a7a72f83ac08b3 |
| 2026-11-03T17:47:29Z | p05 | duyu-1 | - | - | - | 57.96 | - | 80a7a72f83ac08b3 |
| 2026-11-03T17:47:37Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 812 | 50.37 | a55a82b456794dfa879b17871fb485b0 | ed8091e8ae3a6408 |
| 2026-11-03T17:47:41Z | p06 | duyu-1 | - | - | - | 50.37 | - | ed8091e8ae3a6408 |
| 2026-11-03T17:47:49Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 792 | 51.51 | 4130cd331984442eaf65d867542f4348 | 01c5c7d886fc227a |
| 2026-11-03T17:47:53Z | p07 | duyu-1 | - | - | - | 51.51 | - | 01c5c7d886fc227a |
| 2026-11-03T17:48:02Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 926 | 60.22 | 674f668230504966b732555a5148db3e | d12e8fbbaa54180b |
| 2026-11-03T17:48:07Z | p08 | duyu-1 | - | - | - | 60.22 | - | d12e8fbbaa54180b |
| 2026-11-03T17:48:15Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 792 | 52.98 | c7af5f85007c4833af8072b20bca3058 | 4ebeea8512e07544 |
| 2026-11-03T17:48:20Z | p09 | duyu-1 | - | - | - | 52.98 | - | 4ebeea8512e07544 |
| 2026-11-03T17:48:28Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 859 | 57.06 | 0cbbff977e46425b8bbf07f4b9c988d7 | a5446e94bc332ea4 |
| 2026-11-03T17:48:34Z | p10 | duyu-1 | - | - | - | 57.06 | - | a5446e94bc332ea4 |
| 2026-11-03T17:48:42Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 824 | 53.2 | b405c733db55463e85a2cc84c9cc40d8 | f569e96acab14ce8 |
| 2026-11-03T17:48:49Z | p11 | duyu-1 | - | - | - | 53.2 | - | f569e96acab14ce8 |
| 2026-11-03T17:48:59Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 854 | 54.54 | 2f258f9e9ef841bbb4a3d093afcbbe1e | c799a96d312fdca8 |
| 2026-11-03T17:49:03Z | p12 | duyu-1 | - | - | - | 54.54 | - | c799a96d312fdca8 |
| 2026-11-03T17:49:11Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 837 | 57.16 | 7d11c486c9ef4c9ebc7a004a92d0a086 | 15ff049fcce8137e |
| 2026-11-03T17:49:19Z | p13 | duyu-1 | - | - | - | 57.16 | - | 15ff049fcce8137e |
| 2026-11-03T17:49:28Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 877 | 55.94 | 51a6431072744bfa89458d1a6a15c88e | 7d27cd7f11a52058 |
| 2026-11-03T17:49:36Z | p14 | duyu-1 | - | - | - | 55.94 | - | 7d27cd7f11a52058 |
| 2026-11-03T17:49:46Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 917 | 59.1 | 39bdec4fdf7847e596ebb61a8c610926 | ee7aa5260273dbab |
| 2026-11-03T17:49:52Z | p15 | duyu-1 | - | - | - | 59.1 | - | ee7aa5260273dbab |
| 2026-11-03T17:50:00Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 815 | 53.21 | 00a193872a3943d99685508c86005cbf | 5826667dc010c12b |
| 2026-11-03T17:50:08Z | p16 | duyu-1 | - | - | - | 53.21 | - | 5826667dc010c12b |
| 2026-11-03T17:50:17Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 787 | 51.67 | eed9ee5e66f24da080d9e0e7e164130b | 2699a56ff58f3b22 |
| 2026-11-03T17:50:21Z | p17 | duyu-1 | - | - | - | 51.67 | - | 2699a56ff58f3b22 |
| 2026-11-03T17:50:31Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 836 | 56.43 | 2bcd6c2ff0974b849a8f5a5d86bdfd8a | 94162fc15b962466 |
| 2026-11-03T17:50:41Z | p18 | duyu-1 | - | - | - | 79.46 | - | 94162fc15b962466 |
| 2026-11-03T17:52:22Z | p02 | duyu-1 | - | - | - | 70.15 | - | 2f58c21bfa2973d9 |
| 2026-11-03T17:52:39Z | p05 | duyu-1 | - | - | - | 83.79 | - | 80a7a72f83ac08b3 |
| 2026-11-03T17:52:54Z | p13 | duyu-1 | - | - | - | 78.76 | - | 15ff049fcce8137e |
