# C2-K01 The Missing Entries: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1/C2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C2-K01 (özet, kanca, kahraman, istek/engel, bölüm planı, son sürpriz, dil odağı, görsel, anlatıcı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 (G-C1-01…G-C1-08) ve C2 (G-C2-01…G-C2-06) konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "C2-K01 *The Missing Entries* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 8 bölüm (An Absence, Suspects, A Pattern, The Stakeout, Correspondence, Callum, The Basket, Definitions), 30 sayfa, ~10.000 kelime (C2 hedefi; 9.500–10.800). Üçüncü tekil şahıs, Edmund'a yakın, serbest dolaylı anlatım; kendini fazla ciddiye alan kahramanın sesini ironiyle taşıyan anlatıcı. Latin kökenli resmî sözcükler ile gündelik karşılıkları arasındaki oyun (commence / start), sözlük tanımları, sözcük oyunları, deyimler, register kayması (Bay Dunmore'un adlaştırmalı kurum dili, Callum'un gündelik dili, Zofia'nın öğrenen İngilizcesi). C1 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme ve yerine koyma) ve C2 yapıları (öne alma, adlaştırma, temkinli dil, resmî dilek kipi ve if'siz şart, bağdaşıklık belirleyicileri, görünüş incelikleri) doğal biçimde, her biri en az 2–3 kez. Standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; uydurma köy (Quillham), uydurma sözlük (Thornwick); gerçek kişi, marka ve kurum yok. Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; ileri kelimeler, deyimler, C1/C2 yapı notları ve Türk öğrenci hataları sözlükte."

**Kanca kararı:** Katalogdaki kanca (*Somebody was stealing words from the village dictionary, one entry a night, and Edmund Pryce took it personally.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. "took it personally" ironisi sonda gerçekleşir: kesilen maddelerin hepsi Edmund'un kendi yazdığı maddelerdir ve mesaj doğrudan ona yazılmıştır. Son cümle de bir sözlük maddesi gibi kurulur: "the shortest entry he had ever written".

**Bölüm kancaları (katalogla uyum):** c1 ertesi gün too da gitmiş; c2 kayıp maddeler alfabetik sırada değil; c3 maddelerin hepsi Edmund'un 1987'deki küçük kelimeler işinden, hepsi onun elinden (fişler, önsöz); c4 kapının önünde karta yapıştırılmış lonely; c5 yeni kart you ve "Are you lonely too"; c6 Callum: "I saw a small person with a bicycle basket."; c7 son mesajda bir kelime eksik (Will you, blank, me); c8 karşılaşma.

**Adil son için yerleştirilen ipuçları:**
- Çocuk köşesindeki küçük kız Wednesday'i yanlış okur, Edmund kibarca düzeltir; Janet kıza "That's Mr Pryce… He helped to write the big dictionary." der (p02).
- Dr Fenn genç Edmund'a küçük kelimeleri verir: "Write them for a ten-year-old in a hurry." (p03).
- Mill Lane'deki parmaklıklara dayalı sarı sepetli çocuk bisikleti; Edmund bakmadan geçer (p04, p24'te yeniden hatırlanır).
- Edmund'un listesi: "Children did not steal words. They had no use for them." (p05, p14, p25'te ters döner).
- Janet: on altı yaş altına ebeveyn imzası gerekiyor; kart soran hevesli küçük bir kız, annesi geceleri çalışıyor (p07).
- Kesiklerin köşeleri yuvarlak ve örselenmiş: "Round-ended scissors… Like little kids." (p08).
- me maddesi çok sade ve açık; Edmund kimin olduğunu bilmeden beğenir (p09).
- Önsöz: en yaygın iki bin kelime tek elden, Edmund Pryce'ın elinden çıkmıştır (p10); fişlerde altı maddenin hepsi onun (p11).
- Gözetlemede Edmund'un okuduğu maddeler arasında teach vardır (p14); uyurken atkısı dörde katlanmış (p15).
- Kart, kütüphanenin "Free, Please Take" kutusundaki eski katalog kartı; kırağıda ince bir bisiklet tekerleği izi (p16); çocuk yapıştırıcısı, çilek kokusu (p17).
- Callum'un gazete turu ve "small person with a bicycle basket" (p23); Alf: Zofia yürürken defterine gömülü okur (p24).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: 500 kredi yüklendi, "tüm yarım kalan işlerimizi yap … onay verdim". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 9 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png`, `images/p21.png`, `images/p24.png`, `images/p28.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Fine pen-and-ink line drawing with soft sepia washes on warm cream paper, non-photorealistic, delicate cross-hatching, witty and warm, like the illustrations of a classic English village novel. Palette: sepia, umber, cream, faded grey; the only accent colour in the whole series is the bright yellow of a child's bicycle basket, used only where the basket appears. Paper cut-outs and collages are drawn as blank pale strips and rectangles, never as readable words. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; book pages, dictionary columns, cards, notebooks and noticeboards show only abstract thin grey lines. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Edmund Pryce:** 67-year-old Englishman, tall and thin, slightly stooped, neat white hair combed back, long sharp nose, half-moon reading glasses, a tweed jacket with elbow patches, a knitted tie and a long wool scarf; dignified, fussy, secretly kind face; often holding a small black notebook or a magnifying glass.
- **Janet Moss:** 50-year-old librarian, short round figure, short brown hair, cheerful busy face, reading glasses on a chain, a cardigan with pockets full of pens.
- **Callum Reid:** 16-year-old boy, tall and thin, untidy fair hair, a black hoodie usually with the hood up, a thin white earphone wire, a pair of long office scissors.
- **Alf Tidy:** 74-year-old retired postman, small and wiry, flat cap, round glasses, a pencil behind his ear, a folded newspaper crossword.
- **Gordon Speake:** large friendly man of about 60, bald with a grey beard, a tomato-red jumper, a pad of yellowish paper.
- **Mr Keith Dunmore:** thin pale man of about 45, neat grey suit, grey tie, a laptop under one arm, expressionless face.
- **Zofia:** 10-year-old girl, small, dark straight hair with a fringe, large serious dark eyes, a red coat, a small bicycle with a bright yellow basket. (Only in p28.)
- **Mrs Lenart:** about 35, tired kind face, hair tied back, blue care-worker tunic under an open coat. (Only in p28.)
- **Quillham Library:** a small old stone village schoolhouse turned library; inside, wooden floors, two old radiators, tall bookcases, a children's corner with a rug and small chairs, a reference corner with a high-backed armchair and an enormous dictionary open on a wooden stand; a cork noticeboard by the stand.
- **Lark Cottage:** a small stone cottage at the top of the village where the lane becomes a field; a neat, quiet kitchen with a table, a radio and a wall clock.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | The reference corner of a cosy village library: an enormous dictionary lies open on a wooden stand, one page with a neat rectangular hole cut through it; Edmund bends over it with a magnifying glass, offended and fascinated; through the window behind, far away and slightly out of focus, a small bicycle with a bright yellow basket leans against railings. No other people. |
| p01.png | p01 (Bölüm 1, An Absence) | Morning in the library: Edmund stands very straight at the dictionary stand, staring through the neat rectangular window in a page; Janet in a cardigan kneels by a radiator in the children's corner behind him, pulling out a picture book; small empty chairs. |
| p05.png | p05 (Bölüm 2, Suspects) | Edmund, notebook in hand, formally questions Alf in the reference corner; Alf looks up over his glasses with an amused face, a crossword on his knee; in the background Gordon in a tomato-red jumper looks through a doorway, and Callum in a black hoodie leans on a returns trolley. |
| p09.png | p09 (Bölüm 3, A Pattern) | The kitchen of Lark Cottage on a grey afternoon: a green leather dictionary open on the table, five blank pale paper strips laid in a circle; Edmund walks slowly round the table, hands behind his back, frowning; a radio and a wall clock without numbers. |
| p13.png | p13 (Bölüm 4, The Stakeout) | Edmund hides in a high-backed armchair behind a tall bookcase, leaning slightly to the left to peer through a gap between shelves, a flask and a cushion beside him; at the desk Janet watches with patient amusement; Callum grins from behind the returns trolley. |
| p17.png | p17 (Bölüm 5, Correspondence) | Early frosty morning at the door of Lark Cottage: Edmund in a dressing gown sits on the cold step holding a small white card with a pale blank strip glued to it; the frosty garden path shows a single thin curving line; the lane is empty. |
| p21.png | p21 (Bölüm 6, Callum) | Tension in the reference corner: Mr Dunmore with an open laptop on a stand, Callum with his hood down and a red face, Janet twisting a duster, and Edmund stepping forward from the side holding up a magnifying glass like a lawyer. |
| p24.png | p24 (Bölüm 7, The Basket) | Edmund and Alf talk in the reference corner, Alf pointing towards the window and explaining; outside the window a quiet village lane with small houses; on the noticeboard six small blank white cards in a row. |
| p28.png | p28 (Bölüm 8, Definitions) | Saturday morning at the library door: Zofia in a red coat pushes a small bicycle with a bright yellow basket inside, her mother in a blue tunic behind her; Edmund by the noticeboard turns towards them, surprised and very formal; Janet smiles. No cards or messages are visible. |

**Sürpriz kontrolü:** Sonun sürprizi, sözlükten maddeleri kesenin İngilizce öğrenmeye çalışan on yaşındaki Zofia olması, yalnızca Edmund'un maddelerini en açık tanımlar oldukları için seçmesi, mesajın "Are you lonely too? Will you teach me?" olması ve teach'i kesmeye kıyamamasıdır. Zofia ve annesi yalnız 8. bölüm başında (p28), metinde kapıdan girdikleri anda görünür; daha önceki hiçbir görselde çocuk yüzü ya da çocuk figürü yoktur. Sarı sepetli bisiklet yalnız kapakta uzakta ve bulanık görünür (metinde p04'te zaten anlatılan ipucu). Hiçbir görselde okunur kelime, kartlardaki mesajın sırası, boşluklu ikinci satır ya da teach maddesi yer almaz; kartlar ve şeritler boş çizilir. p13'te uyuyan Edmund ve katlanmış atkı gösterilmez.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | f5165a73-844e-48da-b09b-911578e99ee8 | — | 2026-10-14T16:41:56+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | 9979202e-f4b2-4f3e-85aa-fd605c1d83c5 | f5165a73-844e-48da-b09b-911578e99ee8 | 2026-10-14T16:48:15+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | ce961d17-d426-437e-b41e-bf151ebe2988 | f5165a73-844e-48da-b09b-911578e99ee8 | 2026-10-14T16:48:16+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | a3952cff-87c6-4edd-b9c1-c2c8dcfa3400 | f5165a73-844e-48da-b09b-911578e99ee8 | 2026-10-14T16:48:19+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | 4bae6f0e-c4cd-4460-a0bf-e1ae40a2aa2c | f5165a73-844e-48da-b09b-911578e99ee8 | 2026-10-14T16:48:22+00:00 | 3:4, medium, 1k | 0.5 |
| p17.png | ee193855-5d2f-4830-a465-96cb9644fbc0 | f5165a73-844e-48da-b09b-911578e99ee8 | 2026-10-14T16:48:41+00:00 | 3:4, medium, 1k | 0.5 |
| p24.png | 92339538-daae-494e-b675-f5212ee7f4e9 | f5165a73-844e-48da-b09b-911578e99ee8 | 2026-10-14T16:48:43+00:00 | 3:4, medium, 1k | 0.5 |
| p21.png | 62bb9084-940f-4291-a3f9-6a5fb7a25131 | f5165a73-844e-48da-b09b-911578e99ee8 | 2026-10-14T16:48:45+00:00 | 3:4, medium, 1k | 0.5 |
| p28.png | 59dd52de-d6d2-44af-8ec2-0704357c5074 | f5165a73-844e-48da-b09b-911578e99ee8 | 2026-10-14T16:48:45+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 4.5 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C2 başlangıç değeri; C1/C2'de anlatım temposu varsayılanı `off`, hedef doğal hız ~165 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-04T04:56:47Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1561 | 97.77 | 01c3636e16174831a36a2a847505220e | 1d44830cf4d927a0 |
| 2026-11-04T04:56:55Z | p01 | duyu-1 | - | - | - | 97.77 | - | 1d44830cf4d927a0 |
| 2026-11-04T04:57:14Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 2047 | 129.33 | 8eb4ead0012c4be1ad8b5a09bba1f490 | 86415b3c61ddb97c |
| 2026-11-04T04:57:22Z | p02 | duyu-1 | - | - | - | 129.33 | - | 86415b3c61ddb97c |
| 2026-11-04T04:57:42Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 2009 | 134.31 | bca09916ccf34e3fbd7482e65365f80c | 799a8d7c22998c13 |
| 2026-11-04T04:57:57Z | p03 | duyu-1 | - | - | - | 157.9 | - | 799a8d7c22998c13 |
| 2026-11-04T04:58:14Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1613 | 105.59 | 04e38c1a09fb4c3084c6da902e501496 | b221ada76161cf32 |
| 2026-11-04T04:58:21Z | p04 | duyu-1 | - | - | - | 105.59 | - | b221ada76161cf32 |
| 2026-11-04T04:58:36Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1998 | 123.09 | 8b667a2363c04c2c8c78b8dcc0008b72 | 476aab388a49c046 |
| 2026-11-04T04:58:46Z | p05 | duyu-1 | - | - | - | 123.09 | - | 476aab388a49c046 |
| 2026-11-04T04:59:02Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1717 | 105.84 | 5279d2db3416435ea09c439f110e1d2a | d384f464789de276 |
| 2026-11-04T04:59:10Z | p06 | duyu-1 | - | - | - | 105.84 | - | d384f464789de276 |
| 2026-11-04T04:59:26Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 2257 | 135.33 | 86635826fd654ec0bc043b2667a2f129 | f4455bbd84e7b09d |
| 2026-11-04T04:59:37Z | p07 | duyu-1 | - | - | - | 135.33 | - | f4455bbd84e7b09d |
| 2026-11-04T04:59:56Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 2092 | 138.08 | 4b82e73dc87c4b3696bca229aec40a4c | 525dcb40cd20de89 |
| 2026-11-04T05:00:09Z | p08 | duyu-1 | - | - | - | 157.0 | - | 525dcb40cd20de89 |
| 2026-11-04T05:00:26Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1849 | 114.17 | 3f99d40a580546058dd2d9727fd59e67 | 37d25cfda707c40d |
| 2026-11-04T05:00:37Z | p09 | duyu-1 | - | - | - | 114.17 | - | 37d25cfda707c40d |
| 2026-11-04T05:00:53Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1774 | 120.66 | 5d42edddd7cb4395a35db9a0e3377615 | c42457a3bd6681f0 |
| 2026-11-04T05:01:02Z | p10 | duyu-1 | - | - | - | 120.66 | - | c42457a3bd6681f0 |
| 2026-11-04T05:01:19Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 1991 | 130.21 | cb034aa3958b4faca12399ffd0eb7f79 | 1872d28f6546152e |
| 2026-11-04T05:01:33Z | p11 | duyu-1 | - | - | - | 155.56 | - | 1872d28f6546152e |
| 2026-11-04T05:01:51Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1874 | 119.62 | c92fd2f1b47d4d9992041fa185325b08 | 39715f6050fcde6d |
| 2026-11-04T05:02:06Z | p12 | duyu-1 | - | - | - | 169.98 | - | 39715f6050fcde6d |
| 2026-11-04T05:02:22Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 1845 | 117.4 | bd9746c7c1494fc3a47351bdd7a9ab7a | 4bbac63529325f2f |
| 2026-11-04T05:02:31Z | p13 | duyu-1 | - | - | - | 117.4 | - | 4bbac63529325f2f |
| 2026-11-04T05:02:49Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1948 | 120.23 | f78dbb9a87fe4cf0a7f74c2cfa7b2fb4 | 8245ab3a76e774e4 |
| 2026-11-04T05:02:58Z | p14 | duyu-1 | - | - | - | 120.23 | - | 8245ab3a76e774e4 |
| 2026-11-04T05:03:17Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1780 | 119.49 | 9632b4b8444943f28de146346b76bd3c | e2f6c3cf73c6e820 |
| 2026-11-04T05:03:27Z | p15 | duyu-1 | - | - | - | 119.49 | - | e2f6c3cf73c6e820 |
| 2026-11-04T05:03:44Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1729 | 110.51 | 137f741aaf3841dc8390426e090104a5 | 5960b885219bb2f4 |
| 2026-11-04T05:03:53Z | p16 | duyu-1 | - | - | - | 110.51 | - | 5960b885219bb2f4 |
| 2026-11-04T05:04:09Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1625 | 108.53 | 55901d1a27f140b7831b24f8e33cd8fd | af44030101bd6abe |
| 2026-11-04T05:04:21Z | p17 | duyu-1 | - | - | - | 129.1 | - | af44030101bd6abe |
| 2026-11-04T05:04:38Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1775 | 119.68 | e496c4e42a7c4993a01084a55a0a9715 | 626116e8afa7de1d |
| 2026-11-04T05:04:52Z | p18 | duyu-1 | - | - | - | 144.4 | - | 626116e8afa7de1d |
| 2026-11-04T05:05:10Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1915 | 119.43 | 29286c1b9af347bebf2619c0f6bbffdb | 45952746374a77d9 |
| 2026-11-04T05:05:21Z | p19 | duyu-1 | - | - | - | 119.43 | - | 45952746374a77d9 |
| 2026-11-04T05:05:37Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1437 | 92.12 | 43a73412948b41a5bd35ab54f54f14d9 | 5c98e3fa2da4940f |
| 2026-11-04T05:05:48Z | p20 | duyu-1 | - | - | - | 111.4 | - | 5c98e3fa2da4940f |
| 2026-11-04T05:06:01Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1731 | 106.6 | 8c135df5f2ba4a2b94f13e5fc32677b3 | 68a11878bda33787 |
| 2026-11-04T05:06:10Z | p21 | duyu-1 | - | - | - | 106.6 | - | 68a11878bda33787 |
| 2026-11-04T05:06:26Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1950 | 121.94 | 0dd07f58707e4ce8956ed2db2fa77256 | 229ed34be98c2d61 |
| 2026-11-04T05:06:36Z | p22 | duyu-1 | - | - | - | 121.94 | - | 229ed34be98c2d61 |
| 2026-11-04T05:06:55Z | p23 | alania-v2 | alania2-f1 | alania-v2.1 | 1857 | 121.91 | 41b2d35d4c2640feafbea2c760cd1b37 | bab7ffde490f24ad |
| 2026-11-04T05:07:06Z | p23 | duyu-1 | - | - | - | 121.91 | - | bab7ffde490f24ad |
| 2026-11-04T05:45:27Z | p24 | alania-v2 | alania2-f1 | alania-v2.1 | 1883 | 118.88 | f02195a2f4c04c438277d904124e32c3 | 41cb699af3951b12 |
| 2026-11-04T05:45:39Z | p24 | duyu-1 | - | - | - | 140.02 | - | 41cb699af3951b12 |
| 2026-11-04T05:46:04Z | p25 | alania-v2 | alania2-f1 | alania-v2.1 | 1918 | 125.36 | f0c2c35e67ee4a65b2a928770e67371f | d1df30e0856d3192 |
| 2026-11-04T05:46:16Z | p25 | duyu-1 | - | - | - | 145.79 | - | d1df30e0856d3192 |
| 2026-11-04T05:46:38Z | p26 | alania-v2 | alania2-f1 | alania-v2.1 | 1621 | 106.71 | 4afcbc32147c48b58a2baf5fccb2982b | 7fb69aba1d6ba5af |
| 2026-11-04T05:46:50Z | p26 | duyu-1 | - | - | - | 106.71 | - | 7fb69aba1d6ba5af |
| 2026-11-04T05:47:09Z | p27 | alania-v2 | alania2-f1 | alania-v2.1 | 1731 | 110.87 | d3244f93d70447098abc8175222349bd | 1c0c4fb27ce7ce56 |
| 2026-11-04T05:47:25Z | p27 | duyu-1 | - | - | - | 110.87 | - | 1c0c4fb27ce7ce56 |
| 2026-11-04T05:47:45Z | p28 | alania-v2 | alania2-f1 | alania-v2.1 | 1930 | 123.09 | 63734bc587c0462d92f43f65e5dcf419 | ce172704cb486723 |
| 2026-11-04T05:48:03Z | p28 | duyu-1 | - | - | - | 123.09 | - | ce172704cb486723 |
| 2026-11-04T05:48:24Z | p29 | alania-v2 | alania2-f1 | alania-v2.1 | 1670 | 110.5 | 78f9f85b1dd74a46b06967ec2d369124 | 1012f384a49b92db |
| 2026-11-04T05:48:36Z | p29 | duyu-1 | - | - | - | 110.5 | - | 1012f384a49b92db |
| 2026-11-04T05:48:57Z | p30 | alania-v2 | alania2-f1 | alania-v2.1 | 2190 | 137.61 | 651bb31539ff462b9c17d07ed8a68feb | 20079941a3644430 |
| 2026-11-04T05:49:15Z | p30 | duyu-1 | - | - | - | 160.09 | - | 20079941a3644430 |
