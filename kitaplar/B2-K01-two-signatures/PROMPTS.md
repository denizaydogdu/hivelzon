# B2-K01 Two Signatures: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B2-K01 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B2 konuları (G-B2-01…G-B2-12) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B2-K01 *Two Signatures* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 6 bölüm (Varnish, The Archive, Ultraviolet, Letters, Evidence, The Same Hand), 24 sayfa, ~5.000 kelime (B2 hedefi 5.000 ± %20). Sakin, zeki, hafif ironik anlatım. B2 dilbilgisi doğal geçişlerle: edilgen (present perfect edilgen dahil), dolaylı anlatım (cümle, soru, emir), 2. ve 3. tip koşul, *wish / if only*, *must have / can't have / might have*, present perfect continuous, virgüllü ilgi cümlesi, *have something done*, future continuous / perfect, *although / despite / however*. Standart İngiliz İngilizcesi (Mr / Ms noktasız, colour, realise). İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; şehir (Marell) ve kişiler uydurma; gerçek marka, kişi ve eser yok. Kapsama CEFR-J ≤ B2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Kanca kararı:** Katalogdaki kanca (*Under the varnish of an ordinary harbour painting, Lucía found a second name.*) kitabın ilk cümlesidir; `book.json → hookEn` ile birebir aynıdır. Bölüm sonu kancaları katalogdaki gibi: "Ai…" (c1), "Someone else asked about Serra last week." (c2), Bayan Vidal'ın "Only Andreu Serra" şartı (c3), "They will only buy a man's painting." (c4), koleksiyoncunun bir gün erken gelmesi (c5).

**Adil son için yerleştirilen ipuçları:**
- İki imzanın büyük A harfi aynı, tepesinde kurdele gibi bir halka (p04); son sahnede yeniden (p19, p20 "unmistakably the same").
- İkinci ismin çatlakları çok daha az ve ince: daha sonra yazılmış (p04); Tomás'ın analizi: titanyum beyazı, 1920'den önce olamaz ama onlarca yıllık (p18).
- Arşivde Andreu Serra'nın doğum, evlilik, ölüm kaydı yok; Halat Sokağı 14'te yalnızca resim öğretmeni Aina Serra yaşıyor (p06).
- UV ışığında liman duvarında fırçalı bir kadın (p10); mektupta "I painted myself into it… as a joke" (p14).
- Mektuplarda Andreu "hiç sergiye gelmeyen utangaç genç adam", "hayatında bir sergide hiç görülmedi" (p15).
- Bayan Vidal'a karşı kırmızı ringa: arşivdeki adsız kadın (p09), kırmızı tekneyi önceden bilmesi (p12), yalnız "Andreu Serra" etiketi istemesi (p12). Lehine adil ipucu: tablonun değerinin üç katını ödemesi (p19); gri-yeşil gözleri ve tekneyi "biliyor" olması fotoğrafla açıklanır (p22).
- Tepedeki ev: tablo oradan gelir (p01); 1931 fotoğrafı da oradadır, ev büyükanne ölünce eşyalarıyla satılmıştır (p22); tarih 1931 köşede (p20) ve fotoğrafta (p22).
- Vernik: oğlu ölümünden sonra tabloları temizletip vernikletti (p23) — ikinci ismin neden vernik altında kaldığı.

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: "15,06 krediye kadar kullan". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. p13 (4. bölüm başı) kredi yüklenince H-084 ile üretildi (2026-10-14). Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 7 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png`, `images/p21.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 3,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Stylised illustration with a rich oil-paint texture, a picture within a picture, non-photorealistic, visible brushstrokes, thoughtful and quiet mood. Palette: saffron, mustard yellow, Mediterranean blue, warm workshop shadows, a small accent of boat red. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; signatures are drawn only as small abstract brush marks, documents, labels, catalogues and letters are blank or abstract lines, screens are blank. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Lucía Ferrer:** 26-year-old woman, intern restorer, olive skin, dark wavy hair tied up with a pencil through it, focused dark eyes, a dark blue work apron over a mustard jumper, cotton gloves; often holds a thin stick with cotton on the end.
- **Mr Castell:** owner of the workshop, short round man about 60, bald with grey sides, round glasses, always a small red bow tie, waistcoat and rolled-up sleeves.
- **Ms Vidal:** collector, tall elegant woman about 50, short grey hair, pale grey-green eyes, a long grey coat, calm and watchful.
- **Ms Roig:** archivist, thin older woman with silver hair in a bun, cardigan, reading glasses on a chain.
- **Mr Pons:** second-hand bookseller, large cheerful man with a white beard.
- **The workshop:** a narrow room above a harbour street, tall window, wooden easel, a big lamp with a round magnifying glass, bottles and brushes, warm shadows.
- **The painting:** an 1890s view of a small Mediterranean harbour at early morning: fishing boats, one small red boat on the left, a stone harbour wall, a row of yellow, pink and white houses, a soft blue sky.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | The old harbour painting on a wooden easel, half cleaned: the left half dark yellow-brown, the right half bright blue sky and sea; Lucía's gloved hand holds a cotton stick near the bottom corner, where two tiny abstract brush marks sit one above the other. |
| p01.png | p01 (Bölüm 1, Varnish) | Lucía in the workshop at dusk bending over the painting under the big magnifying lamp, cleaning a small square of sky; Mr Castell in his bow tie in the doorway, putting on his coat to leave. |
| p05.png | p05 (Bölüm 2, The Archive) | A cold, quiet archive in an old customs building: tall shelves of boxes, a long table, Ms Roig placing a heavy old book in front of Lucía, who reads with a notebook open; pale morning light from a high window. |
| p09.png | p09 (Bölüm 3, Ultraviolet) | Night in the dark workshop, blinds closed: Lucía holds a purple ultraviolet lamp up to the painting; the painting glows violet and green, and on the harbour wall a faint ghostly shape of a figure can be seen. |
| p13.png | p13 (Bölüm 4, Letters) | A narrow second-hand bookshop packed with books up to the ceiling; Mr Pons, laughing, waves towards stacked cardboard boxes at the back; Lucía squeezes between the shelves. |
| p17.png | p17 (Bölüm 5, Evidence) | Mr Castell's desk covered with blank photographs, copies and a bundle of old letters tied with a faded blue ribbon; Mr Castell, glasses in hand, looks up at Lucía standing by the window. |
| p21.png | p21 (Bölüm 6, The Same Hand) | Evening in the workshop: the cleaned painting on the easel under the lamp; Ms Vidal in her grey coat has just come through the door and stops, one hand raised to her mouth; Lucía and Mr Castell turn towards her. |

**Sürpriz kontrolü:** Sonun sürprizi, Andreu ile Aina Serra'nın aynı kişi olması, ikinci ismi Aina'nın 1931'de kendisinin yazması ve Bayan Vidal'ın onun torununun torunu olarak kaydı düzeltmek istemesidir. Hiçbir görselde yaşlı Aina ya da 1931 fotoğrafı gösterilmez; imzalar yalnız soyut fırça izi olarak çizilir (okunur ad ve tarih yok); p09'daki figür yalnızca belirsiz bir karaltıdır, yüzü görünmez; Bayan Vidal yalnız p21'de, şaşkın ve duygulu ama ne düşündüğü belli olmadan görünür; mektupların içeriği hiçbir görselde okunmaz.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | — | 2026-10-14T16:15:38+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | c51807f6-7f38-4b59-8dc4-f7821c08763c | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:20+00:00 | 3:4, medium, 1k | 0.5 |
| p17.png | 9450aa4c-4ad0-4a4b-a6ca-f2d1bd2c9bcf | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:23+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | a5db8076-25e3-4d90-93e4-f450860d6a5d | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:23+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | b956ac37-f2e6-4adb-a5bc-edd5d2e6ce7f | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:25+00:00 | 3:4, medium, 1k | 0.5 |
| p21.png | c4c8d5ba-dd8c-4766-b5bd-bed422d29a44 | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:49+00:00 | 3:4, medium, 1k | 0.5 |

| p13.png | dbf698c3-99e1-4bd3-9b08-f137b3ad1b0a | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:37:59+00:00 | 3:4, medium, 1k | 0.5 |
**Toplam:** 3.5 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B2 başlangıç değeri). Anlatım temposu B2 varsayılanı `off` (§6.5); hedef 145–155 k/dk, gerçek hız book-lint'te ölçülür, gerekirse `narration.pacing` ayarlanır. Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T18:26:32Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1143 | 70.67 | b2c547983be246e59f8c9514872cdcb8 | d0390c9394c2cc09 |
| 2026-11-03T18:26:38Z | p01 | duyu-1 | - | - | - | 70.67 | - | d0390c9394c2cc09 |
| 2026-11-03T18:26:48Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 1169 | 75.06 | 2bcc4876cb5c4a15b6bfa718f0a1b129 | ed9920554b70562d |
| 2026-11-03T18:26:54Z | p02 | duyu-1 | - | - | - | 75.06 | - | ed9920554b70562d |
| 2026-11-03T18:28:36Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 984 | 61.67 | 8d529e962500474a965eb79e1be7658a | 84496eba86eb2846 |
| 2026-11-03T18:28:41Z | p03 | duyu-1 | - | - | - | 61.67 | - | 84496eba86eb2846 |
| 2026-11-03T18:28:50Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1051 | 68.61 | 74946385d70f4f72b7704d150d3f1787 | ea62a7d871a61e6e |
| 2026-11-03T18:28:55Z | p04 | duyu-1 | - | - | - | 68.61 | - | ea62a7d871a61e6e |
| 2026-11-03T18:29:05Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1097 | 82.47 | 8dc1199551af485a872aadb293ea7e9c | 56dbbd607b7943cd |
| 2026-11-03T18:29:13Z | p05 | duyu-1 | - | - | - | 82.47 | - | 56dbbd607b7943cd |
| 2026-11-03T18:29:24Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1114 | 77.12 | 1471e651c9cf41aead903d3eb044fbdd | a8d6d5c74b39248a |
| 2026-11-03T18:29:30Z | p06 | duyu-1 | - | - | - | 77.12 | - | a8d6d5c74b39248a |
| 2026-11-03T18:29:40Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 1111 | 73.5 | 6bb15cabdc4f4e1bab7f70f400c522a4 | 484b1d177f625643 |
| 2026-11-03T18:29:46Z | p07 | duyu-1 | - | - | - | 73.5 | - | 484b1d177f625643 |
| 2026-11-03T18:29:57Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 1007 | 63.19 | a10510289d514c95807e7d748371ba7c | 316c8f7ea4ab9b75 |
| 2026-11-03T18:30:02Z | p08 | duyu-1 | - | - | - | 63.19 | - | 316c8f7ea4ab9b75 |
| 2026-11-03T18:30:12Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1142 | 74.98 | c855222301bd4bd4b80b233463612ee8 | cd05e965bc1cf53f |
| 2026-11-03T18:30:19Z | p09 | duyu-1 | - | - | - | 74.98 | - | cd05e965bc1cf53f |
| 2026-11-03T18:30:29Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1159 | 75.04 | 6507d3a0392e4510abc2e44f9e43beec | a97f827044e07ec4 |
| 2026-11-03T18:30:37Z | p10 | duyu-1 | - | - | - | 75.04 | - | a97f827044e07ec4 |
| 2026-11-03T18:30:47Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 954 | 63.23 | a9e73ce1724b4d1b858db61ebd418733 | 96f6ef91a9d845ed |
| 2026-11-03T18:30:54Z | p11 | duyu-1 | - | - | - | 63.23 | - | 96f6ef91a9d845ed |
| 2026-11-03T18:31:05Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1139 | 76.13 | cb6061a9042743f09a891caa3b15cd73 | c649e636eee94291 |
| 2026-11-03T18:31:11Z | p12 | duyu-1 | - | - | - | 76.13 | - | c649e636eee94291 |
| 2026-11-03T18:31:21Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 964 | 63.63 | 41066f53aba24bc5998b05a311bbd609 | 03d030c8cc420e73 |
| 2026-11-03T18:31:27Z | p13 | duyu-1 | - | - | - | 63.63 | - | 03d030c8cc420e73 |
| 2026-11-03T18:31:35Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 924 | 56.87 | b8e5362e98384d42ba018b0afb172bb7 | c1ff108b0fcc892d |
| 2026-11-03T18:31:40Z | p14 | duyu-1 | - | - | - | 56.87 | - | c1ff108b0fcc892d |
| 2026-11-03T18:31:49Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1144 | 72.26 | 662bd57fb6334c4aa7728a640b118098 | 015a3e5ba36c22b5 |
| 2026-11-03T18:31:57Z | p15 | duyu-1 | - | - | - | 91.13 | - | 015a3e5ba36c22b5 |
| 2026-11-03T18:32:08Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1188 | 76.54 | 00d73a5e1e7341f9973b478ebc153a60 | 5f6879f336f922c7 |
| 2026-11-03T18:32:13Z | p16 | duyu-1 | - | - | - | 76.54 | - | 5f6879f336f922c7 |
| 2026-11-03T18:32:23Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1116 | 77.16 | 73ed49ea67254ec6ac73fd76807aa922 | c631940b6a360a0d |
| 2026-11-03T18:32:29Z | p17 | duyu-1 | - | - | - | 77.16 | - | c631940b6a360a0d |
| 2026-11-03T18:32:39Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1148 | 74.01 | 5b4bcb620c214323b1e1b2348e0f8467 | 1ccd3f04189a129c |
| 2026-11-03T18:32:45Z | p18 | duyu-1 | - | - | - | 74.01 | - | 1ccd3f04189a129c |
| 2026-11-03T18:32:56Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1168 | 72.64 | 372eb86404a74f5298220a575a4bcf8f | 56ea7f8f24007b46 |
| 2026-11-03T18:33:02Z | p19 | duyu-1 | - | - | - | 72.64 | - | 56ea7f8f24007b46 |
| 2026-11-03T18:33:13Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 979 | 65.22 | 0e3e8ad86eea49cf9c9037b4d064ca67 | 6bc6c69ef007b102 |
| 2026-11-03T18:33:18Z | p20 | duyu-1 | - | - | - | 65.22 | - | 6bc6c69ef007b102 |
| 2026-11-03T18:33:27Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1064 | 67.14 | 002fb0900315449297f91883e917c6d6 | e72998d95ebc46a5 |
| 2026-11-03T18:33:33Z | p21 | duyu-1 | - | - | - | 67.14 | - | e72998d95ebc46a5 |
| 2026-11-03T18:33:44Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1153 | 76.18 | c1f6f8562be74c56b7a30950d5c4efc4 | 2e6fe5cfcc02ef4c |
| 2026-11-03T18:33:51Z | p22 | duyu-1 | - | - | - | 76.18 | - | 2e6fe5cfcc02ef4c |
| 2026-11-03T18:34:01Z | p23 | alania-v2 | alania2-f1 | alania-v2.1 | 1290 | 84.64 | 551d6cd98b0c45e4a4594c089e28eeef | c173e88b33a0dce8 |
| 2026-11-03T18:34:09Z | p23 | duyu-1 | - | - | - | 84.64 | - | c173e88b33a0dce8 |
| 2026-11-03T18:34:21Z | p24 | alania-v2 | alania2-f1 | alania-v2.1 | 1092 | 71.32 | f18474e281c74b75a8ba7a74be22aa07 | 74df40cb26595064 |
| 2026-11-03T18:34:27Z | p24 | duyu-1 | - | - | - | 71.32 | - | 74df40cb26595064 |
