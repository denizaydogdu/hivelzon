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

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 9 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png`, `images/p21.png`, `images/p24.png`, `images/p28.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

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

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C2 başlangıç değeri; C1/C2'de anlatım temposu varsayılanı `off`, hedef doğal hız ~165 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
