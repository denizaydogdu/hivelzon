# C2-K03 A Strongly Worded Letter: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1/C2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C2-K03 (özet, kanca, bölüm planı, son sürpriz, dil odağı, görsel, anlatıcı) ve C2 "Seviye dil odağı"; `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 (G-C1-01…08) ve C2 (G-C2-01…06) konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "C2-K03 *A Strongly Worded Letter* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 7 bölüm (Reluctance, With Respect, The Street Takes Sides, Beatrice, Silence, The Survey, Tea?), 28 sayfa, ~10.000 kelime (C2 hedefi 9.500–10.800). Üçüncü şahıs, kuru ve alaycı anlatıcı; Constance'a yakın serbest dolaylı anlatım, bilinçli olarak güvenilmez yorumlar. İki karakterin mektupları iki ayrı sesle: Constance keskin ve okul müdiresi tonunda, Desmond vergi müfettişi gibi adlaştırmalı ve kurumsal. Resmî mektup kalıpları ve pasif-agresif kibarlık (With respect, I trust you will, I am sure you did not intend), söylenen ile kastedilen arasındaki ironi, İngiliz eksiltili mizahı, uzun dengeli cümlelerle kısa keskin cümlelerin karşıtlığı. C1/C2 yapıları doğal biçimde, her biri en az 2–3 kez: devrik yapı, cleft, karma koşul, ortaç yan cümlesi, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme, öne alma, adlaştırma, temkin dili, resmî dilek kipi ve if'siz şart, söylem belirleyicileri, görünüş incelikleri. Standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. Kaza ölçülü, merdiven güvenliği olumlu örnekle. 13+ güvenli; gerçek marka, kişi, kurum ve yer adı yok. Türkçe çeviri cümle cümle, öbekler ve bağlama göre kelime anlamlarıyla; ileri öğeler ve yapı notları sözlükte."

**Kanca kararı:** Katalogdaki kanca (*"Dear Mr Achterberg, I write, with the greatest possible reluctance, about your hedge."*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. İlk sayfa sorusu: bu mektup nereye varacak, çit kesilecek mi? (*Little did she know… the longest correspondence of her life.*) Kanca sonda ters çevrilir: Constance'ın son mektubu *"It is with the greatest possible embarrassment that I write to you about my hedge."* diye başlar.

**Bölüm sonu kancaları:** c1 1952 tarihli belirsiz plan ve T işareti; c2 Constance ölçüm uzmanı tutar; c3 Desmond'ın mektubundan preslenmiş gül çıkar; c4 üç gün mektup gelmez; c5 Constance ilk kez makası eline alır; c6 ölçüm raporu gelir; c7 "Tea?"

**Adil son için yerleştirilen ipuçları:**
- Bay Pike çiti kırk yıl boyunca **iki tarafından da** budar; Constance ona hiç dokunmaz, "başkasının malını budamak haddini aşmaktır" der (p02).
- 1952 planının kopyası "işinden hoşlanmayan bir makinede çekilmiş" gibi eğri ve bulanıktır; T işareti ve "bir söylenti kadar silik" kuzey oku (p04; sonradan kopyanın ters basıldığı ortaya çıkar).
- Constance'ın kendi mektubu: çit, uzunluğunun büyük kısmında **onun evine daha yakındır** (p05).
- Desmond: "insan sahip olduğu şeyden sorumludur… kendime ait olmayan bir çiti budamayı asla aklımdan geçirmem" (p06; sonun ironisi).
- Demir sınır kazıkları porsuk gövdelerinin **Hollybank tarafında** durur; Constance bunu yok sayar (p07).
- Bay Quayle: "Porsuk çitleri… hiçbir zaman tam olarak insanların sandığı yerde olmazlar." (p08); kazığı bulur, "Ben olsam makasınızı atmazdım." der (p11).
- Constance'ın otuz yıl önce **çitin dibine diktiği** sarmaşık gül, çitin içinden Desmond'ın tarafına geçer (p12).
- Beatrice: emlakçı 1983'te "Tabii, çit de evle birlikte geliyor." demişti (p14).
- Arşivdeki asıl plan kopyadan çok daha nettir; Josh "T'nin hangi tarafa konduğuyla ilgili bir kural" olduğunu hatırlar (p23).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: 500 kredi yüklendi, "tüm yarım kalan işlerimizi yap … onay verdim". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 8 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png`, `images/p21.png`, `images/p25.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Elegant caricature illustration in the tradition of classic English magazine cartoons, non-photorealistic, fine confident ink lines with soft watercolour washes on cream paper, gently comic and warm. Palette: deep hedge green, rose pink, ink navy, cream, soft brick red. Letters and envelopes are drawn only as blank pages with neat empty lines, never with readable writing. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; plans and maps are drawn only as abstract lines, chalkboards and labels are blank. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Constance Webb:** 74-year-old woman, tall, thin and very upright, silver hair in a neat bun, reading glasses on a chain, sharp intelligent face with a hint of humour; a navy cardigan, a pale blouse with a small brooch, a tweed skirt and sensible shoes.
- **Desmond Achterberg:** 66-year-old man, shorter than Constance, neat and precise, short grey hair, small tidy grey moustache, round wire glasses, a brown felt hat, a grey cardigan over a shirt and tie.
- **Beatrice:** about 70, round and cheerful, short curly white hair, a bright flowered dress, large earrings, laughing eyes.
- **Barry Tuttle:** about 50, the village postman, red-cheeked and cheerful, a plain dark blue jacket with no logo, a big canvas postbag on his shoulder.
- **Mr Hollis Quayle:** nearly 80, thin, slow, white hair, an old tweed coat and a walking stick. **Ms Quayle:** about 40, quick and energetic, short dark hair, a practical jacket, a long measuring tape.
- **Audit:** a large grey cat with a permanently suspicious expression.
- **Larkspur Lane:** a quiet English country lane with two old brick cottages side by side (Fernleigh and Hollybank), small front gardens with low gates, a red pillar-style post box with no markings at the end of the lane.
- **The hedge:** a very old, very tall dark-green yew hedge, nearly twice the height of a person, running between the two back gardens; at its foot on Constance's side, a pink climbing rose growing up into it; Constance's garden has a glass conservatory, rose beds and an old apple tree.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | The tall dark yew hedge seen from above between two back gardens; on one side Constance, very upright, holding a blank white envelope; on the other side Desmond in his hat, holding a blank cream envelope; neither can see the other over the hedge; a cheerful postman walking down the lane in the background with a full postbag; a blackbird on top of the hedge. |
| p01.png | p01 (Bölüm 1, Reluctance) | Evening, Constance at a writing desk surrounded by crumpled blank drafts, pen raised, glasses on her nose, a determined expression; through the window, the huge dark hedge blocking the low sun. |
| p05.png | p05 (Bölüm 2, With Respect) | Constance behind the curtain of an upstairs window, peering down at Desmond on a low step trimming his side of the hedge into a perfectly flat green wall with small shears; the top of the hedge, untouched, rises high above him with a blackbird nest. |
| p09.png | p09 (Bölüm 3, The Street Takes Sides) | The village shop doorway: a chalkboard with three blank columns and small blank tally marks, villagers gathered around it pointing and laughing, the postman in the middle tapping the side of his nose; a lady from the book group and a man from the bowls club looking at each other like rivals. |
| p13.png | p13 (Bölüm 4, Beatrice) | The kitchen: Beatrice at the table laughing helplessly over an open box file of blank letters with dividers; Constance at the kettle with her back half turned, pretending to be busy; a pressed pink rose lying on the table cloth. |
| p17.png | p17 (Bölüm 5, Silence) | Rainy grey morning, Constance standing alone at her front window, looking out at the empty lane; next door, a closed curtain and no bins outside; a single raindrop running down the glass. |
| p21.png | p21 (Bölüm 6, The Survey) | Constance, standing firmly on the ground in sensible shoes, carefully trimming the lower part of the hedge with new shears, a wheelbarrow full of cuttings beside her; the large grey cat watches suspiciously from the grass; no ladder in use. |
| p25.png | p25 (Bölüm 7, Tea?) | The kitchen table: a large unopened brown envelope, a teapot and a single cup of tea; Constance sitting very straight, hands folded, looking at the envelope; through the window, the grey cat sitting on top of a low stretch of hedge in afternoon sunlight. |

**Sürpriz kontrolü:** Sonun sürprizi, çitin tümüyle Constance'ın arazisinde olması ve Desmond'ın aylardır onun çitini budamasıdır. Hiçbir görselde demir kazıklar, porsuk gövdelerinin sınıra göre yeri, plan ya da T işareti gösterilmez (plan yalnız soyut çizgi olarak bile çizilmez). Kapakta çit iki bahçenin tam ortasında, sınırı belirsiz durur. p05'te Desmond "kendi" tarafını budar ama görüntü sahipliği ima etmez; p21'de Constance yalnız yerden budar, merdiven kullanılmaz. p25'te rapor zarfı açılmamıştır. Desmond'ın kazası ve "Tea?" kartı hiçbir görselde yoktur. Böylece hiçbir görsel sonu ele vermez.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 3694cf12-9b3f-4e62-86e1-64e3158b1b1b | — | 2026-10-14T16:42:35+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | ef1e88d5-530d-4fc1-a0a8-1f9cb1768090 | 3694cf12-9b3f-4e62-86e1-64e3158b1b1b | 2026-10-14T16:50:04+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | 6e158e58-3e97-4146-837b-de2f294d61b8 | 3694cf12-9b3f-4e62-86e1-64e3158b1b1b | 2026-10-14T16:50:05+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | f3d62128-cc51-490e-9bd6-e9db1a9c9183 | 3694cf12-9b3f-4e62-86e1-64e3158b1b1b | 2026-10-14T16:50:06+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 68e989d5-5988-4236-8a7c-8625b021328d | 3694cf12-9b3f-4e62-86e1-64e3158b1b1b | 2026-10-14T16:50:07+00:00 | 3:4, medium, 1k | 0.5 |
| p25.png | 720a10fb-61f5-454d-82eb-1a8f0f84a095 | 3694cf12-9b3f-4e62-86e1-64e3158b1b1b | 2026-10-14T16:50:32+00:00 | 3:4, medium, 1k | 0.5 |
| p17.png | 661fab82-3e30-4975-a747-9348af3f56a8 | 3694cf12-9b3f-4e62-86e1-64e3158b1b1b | 2026-10-14T16:50:33+00:00 | 3:4, medium, 1k | 0.5 |
| p21.png | c2a2ee6a-3a55-4177-96de-4c081763c33e | 3694cf12-9b3f-4e62-86e1-64e3158b1b1b | 2026-10-14T16:50:34+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 4 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C2 başlangıç değeri; C2'de anlatım temposu varsayılanı `off`, doğal hız, katalogda ~160 k/dk, §6.5). Mektuplar resmî ve keskin, anlatı kuru alaycı tonla okunur. Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-04T06:06:57Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1934 | 121.44 | 06eb344736134ce1a9fca3d4a40b9dd4 | 4db4b5ee4773287b |
| 2026-11-04T06:07:11Z | p01 | duyu-1 | - | - | - | 121.44 | - | 4db4b5ee4773287b |
| 2026-11-04T06:07:35Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 2059 | 121.14 | a3bcb11683d2454793c9bdac266ddcc7 | ae02c9eeb6846e2d |
| 2026-11-04T06:07:52Z | p02 | duyu-1 | - | - | - | 121.14 | - | ae02c9eeb6846e2d |
| 2026-11-04T06:08:12Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 1770 | 108.62 | 85d28621c1e64b94a92dab38568f03e3 | f54d09efa9b0afe3 |
| 2026-11-04T06:08:31Z | p03 | duyu-1 | - | - | - | 108.62 | - | f54d09efa9b0afe3 |
| 2026-11-04T06:08:57Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1905 | 115.95 | fd64f442529b4028b1de127fab6818a6 | af950d22059c6681 |
| 2026-11-04T06:09:18Z | p04 | duyu-1 | - | - | - | 138.32 | - | af950d22059c6681 |
| 2026-11-04T06:09:41Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1951 | 114.24 | fb2c391f8e8241768fe616f3964edc8d | 599e594532f3191b |
| 2026-11-04T06:09:49Z | p05 | duyu-1 | - | - | - | 114.24 | - | 599e594532f3191b |
| 2026-11-04T06:10:12Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1916 | 114.55 | 42f218d4371d4f0d9337045e08238923 | 504cb71015043616 |
| 2026-11-04T06:10:28Z | p06 | duyu-1 | - | - | - | 136.56 | - | 504cb71015043616 |
| 2026-11-04T06:10:50Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 2097 | 130.91 | df888727ee774ca7bdd8a8edd234eee0 | 9c4ea5e3a3a08ccf |
| 2026-11-04T06:11:04Z | p07 | duyu-1 | - | - | - | 130.91 | - | 9c4ea5e3a3a08ccf |
| 2026-11-04T06:11:27Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 1763 | 107.9 | 11cf363918b64ac1803694398416f32a | 0dcaad2a78a7f0d4 |
| 2026-11-04T06:11:40Z | p08 | duyu-1 | - | - | - | 129.08 | - | 0dcaad2a78a7f0d4 |
| 2026-11-04T06:12:04Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 2176 | 133.32 | 9046c14761d6490490890bb01607e79f | 637ccdd0a98df35a |
| 2026-11-04T06:12:22Z | p09 | duyu-1 | - | - | - | 155.5 | - | 637ccdd0a98df35a |
| 2026-11-04T06:12:46Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1995 | 116.3 | e134f466350449a480e9eb3f6dd4d6ee | 2f3a2fdcda58e07b |
| 2026-11-04T06:13:03Z | p10 | duyu-1 | - | - | - | 137.13 | - | 2f3a2fdcda58e07b |
| 2026-11-04T06:13:24Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 1751 | 110.64 | 576dd1faba4147e2af1f616c12830c12 | 7de9715975a2a0a4 |
| 2026-11-04T06:13:39Z | p11 | duyu-1 | - | - | - | 110.64 | - | 7de9715975a2a0a4 |
| 2026-11-04T06:13:59Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1932 | 116.79 | 793f06b359634d97ae492175dc27bec4 | a767f58a9bcc0c47 |
| 2026-11-04T06:14:13Z | p12 | duyu-1 | - | - | - | 116.79 | - | a767f58a9bcc0c47 |
| 2026-11-04T06:14:38Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 2093 | 129.64 | e2c16c4fdfd1425b8cc549516a56a69a | 692554b7662674c9 |
| 2026-11-04T06:15:00Z | p13 | duyu-1 | - | - | - | 172.76 | - | 692554b7662674c9 |
| 2026-11-04T06:15:26Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1830 | 114.7 | 88d5f36f5914457c8aa23643ff4edadc | b4280a2a0e421eda |
| 2026-11-04T06:15:45Z | p14 | duyu-1 | - | - | - | 114.7 | - | b4280a2a0e421eda |
| 2026-11-04T06:20:05Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1965 | 125.42 | f5c16e3b58d347939363ab43c28fa79d | 421ae8194512db32 |
| 2026-11-04T06:20:32Z | p15 | duyu-1 | - | - | - | 165.45 | - | 421ae8194512db32 |
| 2026-11-04T06:20:56Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1714 | 107.04 | 27071ceeb40e4787853b4d9436024159 | d3dd2fefc9589093 |
| 2026-11-04T06:21:09Z | p16 | duyu-1 | - | - | - | 107.04 | - | d3dd2fefc9589093 |
| 2026-11-04T06:21:30Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1858 | 113.59 | 2160fa08034148be957743c1f967aa5c | 1d228196647691b5 |
| 2026-11-04T06:21:46Z | p17 | duyu-1 | - | - | - | 113.59 | - | 1d228196647691b5 |
| 2026-11-04T06:27:18Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1928 | 125.43 | 430af889c78c40f8b30f5ba011e04d0f | 59f219a73de420c6 |
| 2026-11-04T06:27:32Z | p18 | duyu-1 | - | - | - | 125.43 | - | 59f219a73de420c6 |
| 2026-11-04T06:27:54Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1882 | 115.37 | 2fbcdd4c20884a9394ece39fc18d874b | 64f05c2fe94b4bae |
| 2026-11-04T06:28:03Z | p19 | duyu-1 | - | - | - | 115.37 | - | 64f05c2fe94b4bae |
| 2026-11-04T06:28:24Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1695 | 107.74 | 41b07afa0d0448b4b05d06fd5ada178f | eac58864025b643a |
| 2026-11-04T06:28:38Z | p20 | duyu-1 | - | - | - | 107.74 | - | eac58864025b643a |
| 2026-11-04T06:28:58Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 2153 | 138.03 | 3c2ecd7fb23041649b44490e20b91e68 | b3c5a27b2f912dbb |
| 2026-11-04T06:29:17Z | p21 | duyu-1 | - | - | - | 138.03 | - | b3c5a27b2f912dbb |
| 2026-11-04T06:29:48Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1830 | 115.53 | 94abe97105b24bc0bba7f68771a1afec | e9d87ca1de78a163 |
| 2026-11-04T06:29:58Z | p22 | duyu-1 | - | - | - | 115.53 | - | e9d87ca1de78a163 |
| 2026-11-04T06:30:22Z | p23 | alania-v2 | alania2-f1 | alania-v2.1 | 2085 | 133.76 | 3a062d03dee2450987aa49e9bd513267 | d4af7bba4af10247 |
| 2026-11-04T06:30:37Z | p23 | duyu-1 | - | - | - | 156.95 | - | d4af7bba4af10247 |
| 2026-11-04T06:31:02Z | p24 | alania-v2 | alania2-f1 | alania-v2.1 | 1870 | 112.83 | fb96854d6b5e4cd7a657aa41f81ec693 | 781e2d8eb9c031f6 |
| 2026-11-04T06:31:20Z | p24 | duyu-1 | - | - | - | 112.83 | - | 781e2d8eb9c031f6 |
| 2026-11-04T06:31:41Z | p25 | alania-v2 | alania2-f1 | alania-v2.1 | 1848 | 113.9 | 280adff215a541eebd58bf630a28d690 | 459deb6547ba437d |
| 2026-11-04T06:32:00Z | p25 | duyu-1 | - | - | - | 137.27 | - | 459deb6547ba437d |
| 2026-11-04T06:32:24Z | p26 | alania-v2 | alania2-f1 | alania-v2.1 | 2065 | 127.23 | 6b6eee8c3e0e40ef8e77abb2527b0647 | 936f1144d0140ff5 |
| 2026-11-04T06:32:40Z | p26 | duyu-1 | - | - | - | 127.23 | - | 936f1144d0140ff5 |
| 2026-11-04T06:33:06Z | p27 | alania-v2 | alania2-f1 | alania-v2.1 | 2145 | 132.78 | cd383dc837e843f3bbd087ef6db2594a | f1ce4e493704ba58 |
| 2026-11-04T06:33:20Z | p27 | duyu-1 | - | - | - | 132.78 | - | f1ce4e493704ba58 |
| 2026-11-04T06:33:42Z | p28 | alania-v2 | alania2-f1 | alania-v2.1 | 1775 | 113.07 | 8710444ec9d94b4898f758b67b960903 | c6be213eae1c4a20 |
| 2026-11-04T06:33:54Z | p28 | duyu-1 | - | - | - | 113.07 | - | c6be213eae1c4a20 |
