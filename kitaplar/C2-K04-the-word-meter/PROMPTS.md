# C2-K04 The Word Meter: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1–C2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C2 "Seviye dil odağı" ve C2-K04 girdisi (kahraman, istek/engel, kanca, tanıtım, dil odağı, görsel, anlatıcı, bölüm planı, son sürpriz); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 (G-C1-01…08) ve C2 (G-C2-01…06) konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md`, `PROMPTS.md` |

**İstem (özet):** "C2-K04 *The Word Meter* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 7 bölüm (Nine Hundred, The Balance, Joaquim, The Archive, Habit, The Speech, Zero), 30 sayfa, ~10.000 kelime (C2 hedefi 9.500–10.800). Üçüncü tekil şahıs, Petra'ya yakın anlatıcı: ölçülü, ekonomik, kelimeleri sayar gibi; sona doğru serbestleşen akış. C2 dil odağı: ironi ve ima, teknokratik/ekonomik üslup ile duygusal dilin çatışması, alışkanlık yergisi (siyaset değil), türetilmiş sözcükler (word-broker, talk-debt), serbest dolaylı anlatım, kendini fazla ciddiye alan anlatıcı, kısa keskin cümlelerle uzun dengeli cümlelerin karşıtlığı. C1 ve C2 dilbilgisi yapılarının her biri doğal biçimde en az 2–3 kez (devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme; öne alma, adlaştırma, temkinli dil, resmî dilek kipi ve if'siz şart, bağdaşıklık belirleyicileri, görünüş incelikleri). Standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, kişi ve yer adı yok. Türkçe çeviri cümle cümle, öbekler ve bağlama uygun kelime anlamlarıyla; C1/C2 yapıları ve Türk öğrenci notları sözlükte."

**Kanca kararı:** Katalogdaki kanca (*In the city of Halvern, every citizen was allowed nine hundred spoken words a day, and Petra had been saving hers for eleven years.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. İlk sayfanın sorusu: Petra kelimelerini ne için saklıyor? (p01 sonu: "What she was keeping them for, she had told nobody.") Son cümle kancayı ters çevirir: on bir yıllık birikimin amacı olan konuşma "did not cost either of them a single word".

**Bölüm sonu kancaları:** c1 duyuru, biriken hakların gece yarısı silinmesi ve Petra'nın kararı (GO); c2 bakiye fişi, biriktirdiğinden üç buçuk milyon fazla; c3 "Have you never wondered why mine doesn't count?"; c4 son kota raporu yirmi beş yıl önce yazılmış; c5 babası kapıyı açar ve tek kelime etmez; c6 sayaç cümlenin ortasında, gece yarısı sıfıra iner; c7 hiçbir şey olmaz.

**Zaman çizelgesi:** Duyuru ayın ilk pazartesisi (son gün: gelecek ayın son günü, bir salı, yedi hafta sonra). Bakiye fişi son günden önceki cumartesi; Joaquim pazartesi; Arşiv salı sabahı (yalnız salı açık); Eastmere salı akşamı 22.30; konuşma 22.40–24.00; gece yarısı biriken haklar silinir, yeni günün 900 kelimesi sabah altıda gelir. Petra 29 yaşında; baba Hizmet'ten Petra dört yaşındayken, yirmi beş yıl önce ayrıldı; küslük on bir yıl önce, on sekizinci doğum gününde. Bakiye: Petra'nın birikimi ≈ 2.411.000 (günde ≈ 300 kelime konuşur) + babanın bağışı 900 × 4.060 gün = 3.654.000 → fiş 6.065.302.

**Adil son için yerleştirilen ipuçları:**
- Kotanın ne zaman başladığını artık pek az kişi biliyor; "mantıklıydı, dokunulmamalı" (p01).
- Babası Kelime Hizmeti'nin Kalibrasyon bölümünde çalışmış, Petra dört yaşındayken birdenbire ayrılmış ve nedenini hiç açıklamamış (p03).
- Babanın altı kelimesi: "You'll be selling something that isn't there." Petra bunu hakaret sanıyor (p03); sonda aynen dönüyor (p27).
- Çan'ı kimse duymamış: Petra, annesi, Borsa'daki on bir yılda sıfırın altına düşen tek bir müşteri yok; yalnız büyükannenin şüpheli postane hikâyesi (p04; p20'de Petra bunu kanıt sayıyor).
- Petra bakiyesini on bir yıldır hiç resmî olarak sorgulamamış (p07).
- Her sabah altıyı altı geçe 900 kelime, on bir yıldır, "uykuda" (hiç konuşmayan) bir hesaptan; gönderen bildirim istememiş; Halvern'de hiç konuşmayan bir düzine kişiden yalnız birinin kızı var (p11–p12).
- Joaquim'in sayacı karanlık ve o on dakika konuşsa da değişmiyor; ustasının sözü "a meter is only as honest as the throat it sits on"; Lind adını görünce duraksıyor (p12); "Have you never wondered why mine doesn't count?" (p13); "eve git" işareti (p14).
- İlk rapor: önlem "üç yılı aşmayacak" geçici bir tedbir (p15); raporlar yıllar içinde inceliyor, kendini tekrar ediyor (p16); son rapor yirmi beş yıl önce, temkinli dille "önlemin etkisi artık denetime bağlı değil" diyor ve "something that is…" ile kesiliyor (p17).
- Petra yirmi beş yıl önce babasının da Hizmet'ten ayrıldığını fark edip "ilgisiz" diye bir kenara koyuyor (p18); sokaktaki sessizliğin bir kural değil görgü olduğunu düşünüyor (p19).
- Babanın penceresinde, tezgâhta düzgün sıralanmış küçük gri parçalar (p21); babanın sayacı Joaquim'inkiyle aynı eski model ve karanlık; gözlüğü de Joaquim gibi saçına itilmiş (p22).
- Mutfakta on bir yıldır iki sandalye (p23).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: 500 kredi yüklendi, "tüm yarım kalan işlerimizi yap … onay verdim". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 8 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p14.png`, `images/p18.png`, `images/p23.png`, `images/p27.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Retro-futurist illustration, non-photorealistic, flat shapes with soft grain, clean geometric lines, mid-century poster feeling, calm and quiet. Strictly limited palette: concrete grey, pale stone, warm meter amber, and one single red accent (Petra's scarf only). A silent city with wide empty spaces, long shadows, very few people, nobody shouting. Word meters are slim grey metal collars with a thin glowing amber light bar at the throat, no numbers, no dials. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; notices, slips, books, reports and screens are drawn blank or with soft abstract lines only. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Petra Lind:** 29-year-old woman, slim, straight dark-blonde hair in a low knot, pale serious face, alert grey eyes, slight frown of concentration; a long charcoal coat, grey trousers, a slim grey meter collar with an amber light bar; from chapter 2 on, a soft red wool scarf (the only red in the picture). Often holds a small black notebook.
- **Joaquim:** about 60, large and broad, short white beard, warm laughing face, leather apron over a grey shirt, magnifying glasses pushed up on his forehead; an old thick grey meter collar with a small dent, its light bar dark.
- **Matthias Lind (father):** about 63, thin and slightly stooped, short grey hair, quiet patient face, a worn oatmeal cardigan, reading glasses pushed up into his hair; an old thick grey meter collar, its light bar dark.
- **Osric Pell:** about 25, nervous young man, neat suit slightly too big, sitting on the edge of a chair.
- **Mr Fenwick:** elderly, very thin archive clerk, grey suit, small bell in one hand.
- **Halvern:** a quiet retro-futurist city of grey concrete and pale stone, wide empty squares, long tram lines with rounded old trams, people communicating with hand gestures, pigeons, a slow grey river with an iron bridge.
- **The Exchange:** a narrow tall stone building on Copper Street; Petra's office is a narrow room with one window, a desk, two chairs and a framed (blank) certificate.
- **Service kiosk:** a grey metal box the height of a person, a round grille at mouth level and a narrow slot below.
- **Glass Arcade:** a long high corridor of mostly closed shops under an iron and glass roof; at the end a small repair shop full of tools and grey collars.
- **The Archive:** a tall grey building with columns; inside, a dim reading room, long aisles of shelves with grey cloth-bound volumes.
- **Eastmere:** a steep hill district with tall thin houses pressed together, a leaning old water tower, a faded blue-grey front door, a warm lit window with a workbench.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Dusk on the iron bridge over the slow grey river of Halvern: Petra, small in the frame, stands at the rail in her charcoal coat and red scarf, looking across at a steep district of tall thin houses with one warm lit window; the amber bar at her throat glows full; a rounded tram crosses in the distance; wide empty space, long shadows. |
| p01.png | p01 (Bölüm 1, Nine Hundred) | Early morning in a silent Halvern square: rounded trams, people talking only with hand gestures, everyone wearing slim grey collars with glowing amber bars; Petra in her charcoal coat (no scarf yet) walking among them with a small notebook under her arm; pigeons on the pavement. |
| p06.png | p06 (Bölüm 2, The Balance) | A shop window full of grey scarves and one soft red scarf; Petra stands outside on the pavement, reflected faintly in the glass, looking at the red scarf; quiet grey street behind her. |
| p10.png | p10 (Bölüm 3, Joaquim) | Inside a small cluttered repair shop at the end of a glass-roofed arcade: Joaquim, laughing, behind a counter covered in tools and small grey collars, an opened collar lying in front of him like a patient; Petra in the doorway with her red scarf, holding a small blank slip of paper. Joaquim's collar bar is dark. |
| p14.png | p14 (Bölüm 4, The Archive) | A dim archive reading room with tall grey columns and long aisles of shelves full of identical grey cloth-bound volumes; Petra kneels on the floor between the shelves with an open blank volume on her knees; a thin elderly clerk watches from a desk at the far end. |
| p18.png | p18 (Bölüm 5, Habit) | Petra in her red scarf sits on the wide stone steps of a grey columned building, holding a small round bun, watching a quiet street: two old men playing chess on an upturned box, a mother with a finger to her lips beside a small boy, a tram passing. |
| p23.png | p23 (Bölüm 6, The Speech) | A small warm kitchen at night: a table with two chairs; Petra sits on one side with a closed notebook in front of her, her red scarf on; her father stands at the stove with his back to her, filling a kettle; a round wall clock with a plain white face and two black hands, no numerals; the window shows only a dark reflection. |
| p27.png | p27 (Bölüm 7, Zero) | Midnight in the same small kitchen, absolute stillness: Petra sits frozen at the table, lips slightly parted, one hand at her dark collar; across the table her father sits with folded hands, watching her, his collar dark too; the round wall clock (plain face, no numerals) with both hands pointing straight up; a single drop falling from the tap into the sink. |

**Sürpriz kontrolü:** Sonun sürprizi, sayaçların yirmi beş yıldır hiçbir şeyi denetlemediği, sistemi babanın kapattığı ve babanın susmasının nedenidir. Hiçbir görselde Çan, sayacın "öttüğü" bir an, bir yeraltı odası, tornavida ya da kablo bağlantısı yoktur; raporlar ve fiş boş çizilir. Kapakta ve p01'de Petra'nın sayaç ışığı doludur, karanlık sayaç yalnız Joaquim'de (p10) görünür, ki metin bunu bölüm sonunda zaten soru olarak açar. Baba yalnız p23'te sırtı dönük, p27'de sessizce otururken görünür; hiçbir görselde babanın konuştuğu ya da ikisinin sohbet ettiği gösterilmez. p27, c6 sonundaki kancayı (gece yarısı, sıfır) tekrarlar; neyin olmadığını ve nedenini göstermez. Babanın tezgâhındaki parçalar hiçbir görselde yoktur.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 83fc7a40-8729-4a80-bf00-b4e35694d079 | — | 2026-10-14T16:42:55+00:00 | 3:4, medium, 1k | 0.5 |
| p10.png | 79b12583-c957-4e9b-bfcd-b0947a73f441 | 83fc7a40-8729-4a80-bf00-b4e35694d079 | 2026-10-14T16:51:00+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | d866fe4d-88cb-4446-9d28-4798dcf40f63 | 83fc7a40-8729-4a80-bf00-b4e35694d079 | 2026-10-14T16:51:01+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 4c328141-0374-4d93-bb5a-e54c59419f20 | 83fc7a40-8729-4a80-bf00-b4e35694d079 | 2026-10-14T16:51:03+00:00 | 3:4, medium, 1k | 0.5 |
| p14.png | c805eb23-d714-479b-8041-c45152381402 | 83fc7a40-8729-4a80-bf00-b4e35694d079 | 2026-10-14T16:51:03+00:00 | 3:4, medium, 1k | 0.5 |
| p23.png | e0e7334f-9976-4a6b-80ee-5851c7a5028f | 83fc7a40-8729-4a80-bf00-b4e35694d079 | 2026-10-14T16:51:20+00:00 | 3:4, medium, 1k | 0.5 |
| p27.png | b5b71c23-3cbe-4a8b-8b11-3a8a15d91cfb | 83fc7a40-8729-4a80-bf00-b4e35694d079 | 2026-10-14T16:51:25+00:00 | 3:4, medium, 1k | 0.5 |
| p18.png | db1295df-ba55-4b09-a63c-0096fb7223c1 | 83fc7a40-8729-4a80-bf00-b4e35694d079 | 2026-10-14T16:51:27+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 4 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C2 başlangıç değeri; C1–C2'de anlatım temposu varsayılanı `off`, doğal hız, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-04T06:34:18Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1822 | 114.67 | ed68fd6555d949a896e30d02a39ede6a | bd81e8424567071b |
| 2026-11-04T06:34:33Z | p01 | duyu-1 | - | - | - | 114.67 | - | bd81e8424567071b |
| 2026-11-04T06:35:00Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 1743 | 112.45 | 8d894c5d84064abd9983d906e1c40bc9 | 554dd2d83e016a73 |
| 2026-11-04T06:35:09Z | p02 | duyu-1 | - | - | - | 112.45 | - | 554dd2d83e016a73 |
| 2026-11-04T06:35:29Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 1695 | 102.6 | 9ab7a1df78814fd5894a6e1ab4bda0bd | 296e4e8ef212c689 |
| 2026-11-04T06:35:39Z | p03 | duyu-1 | - | - | - | 102.6 | - | 296e4e8ef212c689 |
| 2026-11-04T06:35:58Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1664 | 99.25 | d221f42647ef4f26bc537e60c6f41b50 | 9afd56309493e796 |
| 2026-11-04T06:36:13Z | p04 | duyu-1 | - | - | - | 116.6 | - | 9afd56309493e796 |
| 2026-11-04T06:36:33Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1704 | 107.87 | f722ef90426f4adda600b26a1505ebea | 02b1a6e140066145 |
| 2026-11-04T06:36:48Z | p05 | duyu-1 | - | - | - | 107.87 | - | 02b1a6e140066145 |
| 2026-11-04T06:37:06Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1636 | 103.96 | b3c01609562b44bb84accc2d3148a08c | 8695859f0a4fc3cb |
| 2026-11-04T06:37:24Z | p06 | duyu-1 | - | - | - | 103.96 | - | 8695859f0a4fc3cb |
| 2026-11-04T06:37:41Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 1615 | 101.46 | 3f6bf7f2063c4dc2bea947d075b20121 | 3c52e5769faa9e3c |
| 2026-11-04T06:37:53Z | p07 | duyu-1 | - | - | - | 101.46 | - | 3c52e5769faa9e3c |
| 2026-11-04T06:38:12Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 1503 | 95.44 | ad45d8d6fb6e497faf74701ad1eff4d6 | 61d8cd45397f2ec4 |
| 2026-11-04T06:38:21Z | p08 | duyu-1 | - | - | - | 95.44 | - | 61d8cd45397f2ec4 |
| 2026-11-04T06:38:43Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1580 | 100.68 | 2d102cba5e684dc1b4979074913984ea | e818c29bf058283d |
| 2026-11-04T06:39:02Z | p09 | duyu-1 | - | - | - | 121.27 | - | e818c29bf058283d |
| 2026-11-04T06:39:21Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1709 | 112.07 | d53fe0221c4e48318f35ac5f9a17749e | 422917084c827274 |
| 2026-11-04T06:39:33Z | p10 | duyu-1 | - | - | - | 112.07 | - | 422917084c827274 |
| 2026-11-04T06:39:56Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 1745 | 118.17 | e177fd031c2a417997f10458bdd19106 | 5edcda4c549846c5 |
| 2026-11-04T06:40:13Z | p11 | duyu-1 | - | - | - | 139.11 | - | 5edcda4c549846c5 |
| 2026-11-04T06:40:36Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1734 | 116.61 | dcb30579a8ca4ec598e6117f50af4af7 | 27b9a8fce2a94d16 |
| 2026-11-04T06:40:50Z | p12 | duyu-1 | - | - | - | 116.61 | - | 27b9a8fce2a94d16 |
| 2026-11-04T06:41:12Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 1533 | 96.33 | 778c24a9351a43ecbc6096f525fffb9d | 576634a73d73f21c |
| 2026-11-04T06:41:27Z | p13 | duyu-1 | - | - | - | 96.33 | - | 576634a73d73f21c |
| 2026-11-04T06:41:46Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1617 | 106.17 | 09ac7f66e6034730bb4cfbc15927df5e | bf769308d20ef6b5 |
| 2026-11-04T06:42:02Z | p14 | duyu-1 | - | - | - | 129.36 | - | bf769308d20ef6b5 |
| 2026-11-04T06:42:23Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1674 | 103.06 | 91bd44fc736d416cbfbd24645ff0301f | 91ace46824cf14e5 |
| 2026-11-04T06:42:36Z | p15 | duyu-1 | - | - | - | 103.06 | - | 91ace46824cf14e5 |
| 2026-11-04T06:42:55Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1677 | 101.02 | ade2f2cfc2be47ca88122ba445569f90 | ddd2be16e95f13bc |
| 2026-11-04T06:43:10Z | p16 | duyu-1 | - | - | - | 101.02 | - | ddd2be16e95f13bc |
| 2026-11-04T06:43:30Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1611 | 100.82 | 1633478d420f41bd9da31ef02ee90f4f | 27b4e7eff02dfc50 |
| 2026-11-04T06:43:48Z | p17 | duyu-1 | - | - | - | 100.82 | - | 27b4e7eff02dfc50 |
| 2026-11-04T06:44:08Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1721 | 110.19 | f6047e5db0c54c93a02d91bffcb7aac1 | 058474c8768f2f07 |
| 2026-11-04T06:44:23Z | p18 | duyu-1 | - | - | - | 110.19 | - | 058474c8768f2f07 |
| 2026-11-04T06:44:42Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1949 | 118.98 | df4039ba6245472f84ce890762534e6a | 11609a0e2a42814c |
| 2026-11-04T06:45:03Z | p19 | duyu-1 | - | - | - | 143.3 | - | 11609a0e2a42814c |
| 2026-11-04T06:45:23Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1492 | 91.46 | c31828db3c37449e9d5fbc35b59beeca | d3ce6a1e0cb47eef |
| 2026-11-04T06:45:36Z | p20 | duyu-1 | - | - | - | 91.46 | - | d3ce6a1e0cb47eef |
| 2026-11-04T06:45:58Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1560 | 96.51 | 0f0eb4646da54678911a01abf6a9256f | 8d724156574eba46 |
| 2026-11-04T06:46:14Z | p21 | duyu-1 | - | - | - | 96.51 | - | 8d724156574eba46 |
| 2026-11-04T06:46:34Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1650 | 107.56 | 3f5cec6a1f624035951599313546e320 | 0179691b48757f09 |
| 2026-11-04T06:47:02Z | p22 | duyu-1 | - | - | - | 107.56 | - | 0179691b48757f09 |
| 2026-11-04T06:47:22Z | p23 | alania-v2 | alania2-f1 | alania-v2.1 | 1670 | 109.83 | f12732536a1d40388754a59df971012e | af64f25664c2302b |
| 2026-11-04T06:47:59Z | p23 | duyu-1 | - | - | - | 132.42 | - | af64f25664c2302b |
| 2026-11-04T06:48:18Z | p24 | alania-v2 | alania2-f1 | alania-v2.1 | 1530 | 99.84 | d45ac69a0a8f45d5bb34aa9f6e5608fe | be94c2b1e98084f6 |
| 2026-11-04T06:48:34Z | p24 | duyu-1 | - | - | - | 99.84 | - | be94c2b1e98084f6 |
| 2026-11-04T06:48:50Z | p25 | alania-v2 | alania2-f1 | alania-v2.1 | 1526 | 92.9 | c30266afeea84a578523130f471af5d0 | ffb113a8921b3d07 |
| 2026-11-04T06:49:04Z | p25 | duyu-1 | - | - | - | 92.9 | - | ffb113a8921b3d07 |
| 2026-11-04T06:49:23Z | p26 | alania-v2 | alania2-f1 | alania-v2.1 | 1646 | 104.06 | d1c439e91069461c9cf75010bfc78aae | 289d52a06052339a |
| 2026-11-04T06:49:45Z | p26 | duyu-1 | - | - | - | 104.06 | - | 289d52a06052339a |
| 2026-11-04T06:50:05Z | p27 | alania-v2 | alania2-f1 | alania-v2.1 | 1601 | 99.64 | 2db47e97950e4279a8f9dd33acc5f6b5 | 8aa49078bf8a0392 |
| 2026-11-04T06:50:22Z | p27 | duyu-1 | - | - | - | 99.64 | - | 8aa49078bf8a0392 |
| 2026-11-04T06:50:43Z | p28 | alania-v2 | alania2-f1 | alania-v2.1 | 1760 | 114.13 | 3983171512be44c7bb48620cf977e281 | ad43252e0d25e93a |
| 2026-11-04T06:50:58Z | p28 | duyu-1 | - | - | - | 114.13 | - | ad43252e0d25e93a |
| 2026-11-04T06:51:20Z | p29 | alania-v2 | alania2-f1 | alania-v2.1 | 1770 | 110.99 | 99be6c0f3d1a42f183c32f926e5f3f47 | 7ab29a780c8b537b |
| 2026-11-04T06:51:35Z | p29 | duyu-1 | - | - | - | 110.99 | - | 7ab29a780c8b537b |
| 2026-11-04T06:51:53Z | p30 | alania-v2 | alania2-f1 | alania-v2.1 | 2168 | 129.71 | c11d03dea4134c8683cc096bd5e2a22c | 42eb20ef57969a6d |
| 2026-11-04T06:52:07Z | p30 | duyu-1 | - | - | - | 149.37 | - | 42eb20ef57969a6d |
