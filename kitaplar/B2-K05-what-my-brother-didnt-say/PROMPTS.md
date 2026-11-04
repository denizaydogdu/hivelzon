# B2-K05 What My Brother Didn't Say: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B2-K05 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B2 konuları (G-B2-01…G-B2-12) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B2-K05 *What My Brother Didn't Say* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 5 bölüm (Two Bags, The Boatyard, Apprentice, Keeping It, Launch), 22 sayfa, ~4.800 kelime (B2 hedefi 5.000 ± %20). Birinci tekil şahıs anlatıcı Sophie (17), düşünceli, içten, sakin, yer yer esprili. İrlanda kıyısında uydurma bir kasaba. B2 yapıları doğal biçimde: edilgen (present perfect edilgen dahil), dolaylı anlatım (cümle, soru, rica), 2. ve 3. tip koşul, should have / could have, wish / if only, must have / can't have / might have, present perfect continuous, past perfect, virgüllü ilgi cümleleri, ettirgen have, future continuous / perfect, although / despite / however / whereas; standart İngiliz İngilizcesi anlatı dilbilgisi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. Aile gerginliği nazik; baba kızgın ama asla korkutucu değil; suya indirmede can yelekleri. 13+ güvenli; gerçek marka, kişi ve yer adı yok. Kapsama CEFR-J ≤ B2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler ve B2 yapı notları sözlükte."

**Kanca kararı:** Katalogdaki kanca (*My brother came home from university with two bags and no explanation.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. Son sayfada aynı cümle yeniden kullanılır (*He came home with two bags and no explanation.*) ve ters çevrilir: "He did explain. He just didn't use words."

**Adil son için yerleştirilen ipuçları:**
- Şöminenin üstündeki fotoğraf: yirmi yaşındaki baba, büyük ahşap bir barakada yarım bir teknenin yanında gülüyor; annem "Nobody's, really. It was never finished." diyor ve konuyu kapatıyor (p04).
- Fotoğrafın altındaki rafta üç küçük tahta balık (p04); teknenin içinde, arkaya yakın, tahtaya oyulmuş minicik bir balık (p09); Sophie balığı düşünüp duruyor (p11); balığı elinde tartıyor, babasının onları satın aldığını sanıyor (p17).
- Daniel'ın ellerinde kesikler, kazağında talaş (p05); Daniel yemekte bir an fotoğrafa bakıp gözünü kaçırıyor (p05).
- Bay Doyle: "He said you'd come." (p09); "My first apprentice in over twenty years." (p10: babanın oradan ayrılışı 22 yıl önce).
- Teknenin alt kısmı üstünden koyu ve eski (p09, p13); "The boat was started by someone else… for longer than you've been alive." ve "Wood remembers who touched it." (p13).
- Baba: "I gave up a lot… There's nothing to find in this town. I should know." (p12, p15); Daniel: "I know more than you think." (p12).
- Annem: baba gençken Tommy Doyle'un yanında tekne yapmış, Daniel doğacakken sigorta işine geçmiş (p16); Sophie fotoğrafın Doyle'un atölyesinde çekildiğini fark ediyor (p17).
- Baba: "…while you make the same mistake I…" diyip susuyor (p18).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: "15,06 krediye kadar kullan". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 6 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p15.png`, `images/p19.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 3 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Pencil and watercolour illustration, non-photorealistic, visible pencil lines and soft watercolour washes on textured paper, quiet and tender. Palette: moss green, grey-blue sea, warm wood brown, evening copper light, pale sky. Mood: quiet, honest, a little tense, warm underneath. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; photographs in frames are drawn only as soft blurred shapes, phone screens are blank. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Sophie:** 17-year-old girl, long straight light-brown hair often in a loose ponytail, freckles, grey-green eyes, curious and determined face; a navy school jumper or a grey hoodie with running shoes.
- **Daniel:** 21-year-old young man, tall and thin, untidy dark-brown hair, short beard shadow, quiet serious face; an old green jacket, a dark jumper; small plasters and cuts on his hands.
- **Dad:** about 43, medium height, short greying brown hair, tired eyes, office shirt and trousers or an old knitted jumper; hands that look like they once did hard work.
- **Mum:** about 44, short curly auburn hair, bright cardigan, warm but nervous smile, often holding a cleaning cloth.
- **Mr Doyle (Tommy):** about 78, small and thin, white hair standing up, round glasses, a faded blue work coat, a deeply lined friendly face.
- **Mrs Kelly:** about 65, round, a purple raincoat, holding a flask.
- **The town:** a small Irish fishing town on a grey-blue bay, coloured houses, a little harbour with fishing boats, low green hills, stone walls.
- **The boatyard:** a long old wooden shed at the end of a narrow road by the bay, roof coming down almost to the ground on one side, some broken windows, a thin metal chimney with smoke, a stone ramp into the water; inside, warm yellow light, tools hanging in neat rows, sawdust and wood curls on the floor.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Early morning by the grey-blue bay: Sophie stands on the narrow road in the distance, small in the frame, looking towards the long old wooden boatyard shed, thin smoke rising from its chimney; Daniel's bicycle leans against the shed wall; seagulls over the water; soft copper dawn light. No boat is visible. |
| p01.png | p01 (Bölüm 1, Two Bags) | A rainy evening at the front door of a small family house: Daniel, wet hair, in an old green jacket, stands in the doorway with two full bags; Mum in the hallway behind him smiling a very big nervous smile; Sophie at the kitchen table with homework, looking up. |
| p06.png | p06 (Bölüm 2, The Boatyard) | Dawn, half-dark: Sophie in running clothes hides behind a pile of old wooden boxes outside the long boatyard shed; warm yellow light comes from a broken window; Daniel's bicycle against the wall; the stone ramp leads into calm grey water. The inside of the shed is not visible. |
| p10.png | p10 (Bölüm 3, Apprentice) | Inside the warm boatyard: Mr Doyle pours tea from an old pot by a small iron stove; Daniel and Sophie sit on wooden boxes holding cups; tools hang in neat rows on the wall; in the background, part of an unfinished wooden boat under soft light, only partly visible and out of focus. |
| p15.png | p15 (Bölüm 4, Keeping It) | Evening in the family kitchen: Dad sits at the table looking tired and disappointed; Daniel, asleep on the sofa in the next room with sawdust on his sleeve; Sophie at the table with her eyes on her plate, keeping a secret; Mum cleaning an already clean oven. |
| p19.png | p19 (Bölüm 5, Launch) | A bright cold Saturday morning at the top of the stone ramp: a crowd of townspeople (fishermen, neighbours, children, Mrs Kelly with a flask), Mr Doyle in a jacket and tie, Daniel in a bright orange life jacket looking up at the empty road; the finished wooden boat on a wheeled frame, seen from the side at a distance, honey-coloured on top and dark below. Dad is not in the picture. |

**Sürpriz kontrolü:** Sonun sürprizi, Daniel'ın bitirdiği teknenin babanın yirmi iki yıl önce başlayıp yarım bıraktığı teknenin kendisi olmasıdır. Fotoğraftaki yarım tekne hiçbir görselde gösterilmez (p01'de fotoğraf yoktur; çerçeveli fotoğraflar yalnız bulanık biçim olarak çizilir). Teknenin içine oyulmuş küçük balık ve raftaki tahta balıklar hiçbir görselde yer almaz. p10'da tekne yalnız kısmen ve bulanık görünür; p19'da tekne uzaktan ve yandan görünür, baba görselde yoktur. Kapakta tekne görünmez. Böylece hiçbir görsel fotoğraftaki tekneyle Daniel'ın teknesini yan yana ya da aynı biçimde göstermez.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 8a187236-b8ad-474a-a21f-b7f47b8d6530 | — | 2026-10-14T16:16:57+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | d5a4958e-5ea4-47c4-99a5-b84bddcd35c6 | 8a187236-b8ad-474a-a21f-b7f47b8d6530 | 2026-10-14T16:20:47+00:00 | 3:4, medium, 1k | 0.5 |
| p10.png | 99598bad-c5d6-42f9-a630-a494510406ef | 8a187236-b8ad-474a-a21f-b7f47b8d6530 | 2026-10-14T16:20:50+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 8455cfce-5dd4-4241-af2a-d0a5ab34a164 | 8a187236-b8ad-474a-a21f-b7f47b8d6530 | 2026-10-14T16:20:53+00:00 | 3:4, medium, 1k | 0.5 |
| p15.png | e66e9fac-753b-45cc-ae0a-bfe00ef883a8 | 8a187236-b8ad-474a-a21f-b7f47b8d6530 | 2026-10-14T16:20:59+00:00 | 3:4, medium, 1k | 0.5 |
| p19.png | 20bcdbf2-99b7-4cd4-8f4a-8f1f2babb842 | 8a187236-b8ad-474a-a21f-b7f47b8d6530 | 2026-10-14T16:21:09+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 3 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor. Not: kapak ile p06 sahnesi (kayıkhane) birbirine çok benziyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B2 başlangıç değeri; B2'de anlatım temposu varsayılanı `off`, hedef 145–155 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T18:54:07Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1099 | 71.56 | 71493188e07b4abbbfa4ed59704c7130 | e0f76f972ec5bbbc |
| 2026-11-03T18:54:13Z | p01 | duyu-1 | - | - | - | 71.56 | - | e0f76f972ec5bbbc |
| 2026-11-03T18:54:23Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 1072 | 70.12 | 2398382ba34b453b8334fdc233ff4331 | f22d64d381fa8f63 |
| 2026-11-03T18:54:30Z | p02 | duyu-1 | - | - | - | 70.12 | - | f22d64d381fa8f63 |
| 2026-11-03T18:54:40Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 1058 | 66.61 | 5d7f3e8aa41546398e099de76e1ccc08 | eef15f40f8950907 |
| 2026-11-03T18:54:45Z | p03 | duyu-1 | - | - | - | 66.61 | - | eef15f40f8950907 |
| 2026-11-03T18:54:55Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1226 | 78.9 | ee0ff44937b5471ab7bf8a54dfeadcfb | a136ae722eeed8b3 |
| 2026-11-03T18:55:01Z | p04 | duyu-1 | - | - | - | 78.9 | - | a136ae722eeed8b3 |
| 2026-11-03T18:55:11Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1085 | 71.76 | a030f4e7d96642ac8cae8c9a1ddee133 | e80e82f40b533669 |
| 2026-11-03T18:55:16Z | p05 | duyu-1 | - | - | - | 71.76 | - | e80e82f40b533669 |
| 2026-11-03T18:55:25Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1139 | 71.47 | d46c9ec2e7654a7cb2bb7da76020b768 | 9ef700963813e8b0 |
| 2026-11-03T18:55:31Z | p06 | duyu-1 | - | - | - | 71.47 | - | 9ef700963813e8b0 |
| 2026-11-03T18:55:42Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 1005 | 65.46 | 6e9682b801854415a1271e4f1c6af146 | 11a0d69447c0e299 |
| 2026-11-03T18:55:46Z | p07 | duyu-1 | - | - | - | 65.46 | - | 11a0d69447c0e299 |
| 2026-11-03T18:55:55Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 962 | 63.74 | 21e7feb3df3243f58a5fbfb98aac505e | 9f5fda83bf974681 |
| 2026-11-03T18:56:01Z | p08 | duyu-1 | - | - | - | 63.74 | - | 9f5fda83bf974681 |
| 2026-11-03T18:56:10Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1154 | 75.29 | 083a5dca36724cbc809710a883f14f32 | 0f931da31c7e8ce6 |
| 2026-11-03T18:56:16Z | p09 | duyu-1 | - | - | - | 75.29 | - | 0f931da31c7e8ce6 |
| 2026-11-03T18:56:27Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1167 | 72.12 | cd7071ddabae42d187d4258052f412e3 | 1cb6ab2ce15f42f6 |
| 2026-11-03T18:56:32Z | p10 | duyu-1 | - | - | - | 72.12 | - | 1cb6ab2ce15f42f6 |
| 2026-11-03T18:56:41Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 1134 | 71.06 | 4afd2794663d4f7da2309cd561f7694b | 99a4e5c9916c7577 |
| 2026-11-03T18:56:46Z | p11 | duyu-1 | - | - | - | 71.06 | - | 99a4e5c9916c7577 |
| 2026-11-03T18:56:56Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1216 | 74.24 | 9344aca80aff44268603207bc18e9033 | 3a5c2ae2b9ead57d |
| 2026-11-03T18:57:01Z | p12 | duyu-1 | - | - | - | 74.24 | - | 3a5c2ae2b9ead57d |
| 2026-11-03T18:57:12Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 1158 | 74.01 | dfe8b35a4953436b8610ccb798f87add | 59161761d2712462 |
| 2026-11-03T18:57:18Z | p13 | duyu-1 | - | - | - | 74.01 | - | 59161761d2712462 |
| 2026-11-03T18:57:28Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1101 | 70.18 | c0a083ea4e97484b85b4bcca5964a226 | b7508f8fd1c7772b |
| 2026-11-03T18:57:36Z | p14 | duyu-1 | - | - | - | 93.7 | - | b7508f8fd1c7772b |
| 2026-11-03T18:57:46Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1201 | 73.61 | ee48ee671c234ec28995c0d28877735d | d0c6301601a11432 |
| 2026-11-03T18:57:53Z | p15 | duyu-1 | - | - | - | 73.61 | - | d0c6301601a11432 |
| 2026-11-03T18:58:03Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1178 | 78.07 | d7b5fb429c4f4f7ba2c80156cdbaa214 | d9ae67cbac0b54fc |
| 2026-11-03T18:58:09Z | p16 | duyu-1 | - | - | - | 78.07 | - | d9ae67cbac0b54fc |
| 2026-11-03T18:58:20Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1101 | 70.53 | 86fef0e7476043de908530d5cc7684bc | 1fbdf9eb60106f43 |
| 2026-11-03T18:58:26Z | p17 | duyu-1 | - | - | - | 70.53 | - | 1fbdf9eb60106f43 |
| 2026-11-03T18:58:37Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1129 | 74.84 | ec42aa81e4704e2c87f8df821213bcff | 5df57e4224744989 |
| 2026-11-03T18:58:43Z | p18 | duyu-1 | - | - | - | 74.84 | - | 5df57e4224744989 |
| 2026-11-03T18:58:53Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1126 | 70.37 | fa0cf4d381774ac4a15f2e6a55261094 | c18be04ec4d09b53 |
| 2026-11-03T18:58:59Z | p19 | duyu-1 | - | - | - | 70.37 | - | c18be04ec4d09b53 |
| 2026-11-03T18:59:09Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1051 | 69.18 | 0c7e8d9a354e4797800ffd7e096eb0e2 | df2e338031e8051f |
| 2026-11-03T18:59:15Z | p20 | duyu-1 | - | - | - | 69.18 | - | df2e338031e8051f |
| 2026-11-03T18:59:24Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1161 | 75.84 | 2e8ef45b9db14b1eb48ef1415ff21040 | 032bfcf555813c4c |
| 2026-11-03T18:59:30Z | p21 | duyu-1 | - | - | - | 75.84 | - | 032bfcf555813c4c |
| 2026-11-03T18:59:40Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1219 | 75.75 | 10644453df7f4f3180caf43bbcee9852 | f4259dbe0461e59d |
| 2026-11-03T18:59:46Z | p22 | duyu-1 | - | - | - | 75.75 | - | f4259dbe0461e59d |
