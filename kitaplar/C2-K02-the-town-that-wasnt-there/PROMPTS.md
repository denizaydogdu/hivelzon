# C2-K02 The Town That Wasn't There: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1–C2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C2-K02 (kahraman, istek/engel, kanca, tanıtım, dil odağı, görsel, anlatıcı, bölüm planı, son sürpriz) ve C2 "Seviye dil odağı"; `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 (G-C1-01…08) ve C2 (G-C2-01…06) konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "C2-K02 *The Town That Wasn't There* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 7 bölüm (Trap Streets, The Road, Crossing, Population: Unconfirmed, Invented, Two Drafts, Green Roofs), 29 sayfa, ~10.000 kelime. Kahraman Amira Haddad (36), Lübnan kökenli Kanadalı haritacı, kurgusal bir dijital harita şirketinde saha doğrulama uzmanı; masa başına geçmeden önceki son saha işi. Üçüncü tekil şahıs, Amira'ya yakın serbest dolaylı anlatım; zeki, kuru, merakla canlanan ses. C2 dil odağı: resmî rapor dili ile iç ses arasındaki üslup kaymaları, temkin ve mesafe dili (allegedly, purportedly, so to speak), ironi, deyimler (off the beaten track, put something on the map), uzun dönemli cümleler ile kısa, keskin cümlelerin karşıtlığı. C1 ve C2 dilbilgisi yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme, öne alma, adlaştırma, temkin, resmî dilek kipi ve if'siz şart, söylem belirleyicileri, görünüş incelikleri) doğal biçimde, her biri en az 2–3 kez. Standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, kurum ve kişi yok; uydurma yer adları. Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; ileri kelimeler, deyimler ve yapı notları sözlükte."

**Kanca kararı:** Katalogdaki kanca (*The town of Merrow Cross appeared on every paper map printed since 1931, and on no satellite image ever taken.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. Sonda ters çevrilir: "Merrow Cross had not been missing from every satellite image ever taken. It had been hiding." (p27). Babanın sözü ("A map is a promise that somebody went and looked.", p02) son sayfada geri döner (p29); son cümle katalogdaki gibi kurguların sakinlerini beklediğini söyler.

**Adil son için yerleştirilen ipuçları:**
- Uydu görüntüsündeki orman "rengi öylesine düzgün ki sanki biri onu taramış" (p01); sırttan bakınca aynı "taranmış halı" (p11); sonda aynı imge kanıt olur (p27).
- 1931 paftasında yalnız Merrow Cross çevresindeki eş yükselti çizgileri kusursuz; uyduran kişi vadiyi adım adım yürümüş (p03, p10).
- Kartpostaldaki çatılar "eski yosunun yumuşak, koyu yeşili"; Amira bunu sanatsal serbestlik sayar (p04). Kartpostaldaki el yazısı "çizim bürolarında öğretilen türden" küçük, dik harfler (p04).
- Benzinci Bryony: "They buy a lot of green paint, that lot." (p06; p23'te Amira hatırlar).
- Geçidin bakımlı taşları, yağlanmış menteşeler, yeni halat: kasaba yaşıyor ve dışarıyla bağlantılı (p09–p10).
- Kasabada bütün çatılar aynı yeşil, kenarlarından pul pul dökülüyor, altından gri kayrak görünüyor; evlerin arasında köknarlar bırakılmış, dallar "yeşil bir tavan" oluşturuyor (p13).
- Kit: "Moss… We have a great deal of moss." / "Very hardy moss." (p14). Fırındaki kara tahtada aynı küçük, dik, düzgün harfler "tuhaf biçimde tanıdık" (p14). Ekmeğin kabuğuna eş yükselti çizgisine benzeyen kıvrımlar kesiyor (p14).
- Mutfak rafındaki pirinç köşeli çizim aleti kutusu: "My grandfather's. He drew lines for a living." (p16).
- Bayan Gale'in duvarındaki asıl 1931 paftasının kenarındaki kurşun kalem notu yine küçük, dik, düzgün harflerle (p17); genç haritacı 1954'te gelip kasabada kalmış (p20).
- Bayan Gale: "We like to be found by the people who need to find us… and nobody else." (p20).
- Kilerde düzinelerce aynı yeşil boya tenekesi, uzun saplı fırçalar, çatıya yetecek iki merdiven (p23).
- Nell bu yaz ilk kez "çatıya çıkacak"; Kit sözünü keser (p24). Kit: "I don't suppose there has." (p24); uydu haberine sakin tepki: "Clear skies. How lovely." (p25).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: 500 kredi yüklendi, "tüm yarım kalan işlerimizi yap … onay verdim". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 8 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p18.png`, `images/p22.png`, `images/p26.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Illustration in the style of an old hand-drawn survey map brought to life, non-photorealistic: fine ink linework, delicate contour-line patterns flowing through skies, hills and water, soft sepia paper texture, muted watercolour washes. Palette: sepia and parchment cream, deep fir green, moss green, slate grey, a little rust. Mood: adventurous, nostalgic, quietly witty. Absolutely no text, letters, numbers, place names, labels, signs, logos or writing anywhere in the image; maps, screens, postcards and papers show only abstract contour lines and shapes, phone and laptop screens are blank or show abstract green texture. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Amira Haddad:** 36-year-old woman of Lebanese heritage, olive skin, dark brown thoughtful eyes, shoulder-length dark wavy hair tied back loosely, a few loose strands; practical rust-coloured waterproof jacket, dark walking trousers, sturdy walking boots, canvas rucksack; a small notebook in her pocket; alert, dry, curious expression.
- **Gavin Pell:** about 50, neat and slim, short grey hair, pale blue shirt and narrow tie, holding a coffee cup and a tablet; polite, impatient face.
- **Theo Marsh:** 24, tall and lanky, curly ginger hair, round glasses, a hoodie under a blazer, a packet of crisps.
- **Bryony:** about 60, short grey bob, a tomato-red cardigan, a pencil in her hand, amused eyes.
- **Kit Rowley:** man in his forties, tall, short dark-blond hair, calm grey eyes, sleeves rolled up with flour on his forearms, a pencil behind his ear, a long linen apron.
- **Nell:** 11-year-old girl, short brown hair in two bunches, freckles, green wellington boots, a jumper with holes in both elbows, curious journalist's expression.
- **Mrs Hester Gale:** 94, tiny and very upright, white hair pinned on top of her head, sharp bright eyes, a knitted shawl, holding a teacup.
- **The office:** a modern open-plan fourth floor, large windows, rows of desks with screens showing only abstract green and contour-line patterns.
- **The road and the ford:** narrow lanes between dry-stone walls, sheep, folded brown and green hills under low grey cloud; a broad brown river over grey stones, a line of flat pale stepping stones just under the clear water, a wooden post with a small green-lidded metal box on the far bank, a steep dark wall of fir trees.
- **The town:** a hidden valley of tall firs; small grey stone cottages standing among the trees, their roofs the soft deep green of old moss, fir branches meeting above narrow lanes like a green ceiling; a little village green with a bakery (bow window) on one side and a one-room school on the other, a water pump with a bench, washing lines strung between trees, stacks of firewood.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Amira, small in the frame, stands on a bare heather ridge with her back half turned to the viewer, looking down into a deep green valley that is completely filled with an even carpet of fir trees; faint contour lines ripple through the sky and over the hills like an old map; low cloud at the far end of the valley. No buildings are visible anywhere. |
| p01.png | p01 (Bölüm 1, Trap Streets) | The fourth-floor office at dusk: Amira sits at a desk between two screens, one showing a faded sepia map pattern with a tiny cluster of dark squares, the other an even green texture of treetops; Gavin leans in behind her shoulder with a coffee and a tablet; Theo in the background with a packet of crisps. Screens show no text. |
| p05.png | p05 (Bölüm 2, The Road) | A small grey hire car drives along a narrow lane between dry-stone walls, sheep on both sides, folded brown and green hills ahead with their tops lost in soft grey cloud; late afternoon light. |
| p09.png | p09 (Bölüm 3, Crossing) | Amira, trousers rolled to the knee and boots tied to her rucksack, crosses a broad brown river on a line of flat pale stones just under clear water, a walking pole planted downstream; on the far bank a wooden post with a green-lidded metal box, and above it a steep dark wall of firs. |
| p13.png | p13 (Bölüm 4, Population: Unconfirmed) | Ground-level view: Amira stands in the middle of a little village green, mouth slightly open, among small grey stone cottages with soft moss-green roofs half hidden among tall firs; fir branches meet overhead like a green ceiling; a bakery with a bow window; a woman hanging washing between two trees; two old men on a bench by a water pump; Nell watching from a doorway. |
| p18.png | p18 (Bölüm 5, Invented) | Mrs Gale's tiny sitting room crowded with old furniture: Mrs Gale upright in an armchair with a teacup, telling a story; Amira leaning forward on a chair, listening; on the wall behind, a framed old map seen only as a faded brown oblong with soft abstract curves, no details. |
| p22.png | p22 (Bölüm 6, Two Drafts) | Night in a small room above a bakery: Amira at a little table with an open laptop (blank glowing screen), two loose sheets of paper side by side and a candle-shaped lamp; a dark window with fir branches outside; she rests her chin on her hand, thinking. |
| p26.png | p26 (Bölüm 7, Green Roofs) | A bright, perfectly clear blue morning on the village green, seen from ground level under the edge of the fir branches: Nell waving both arms at the sky, Amira beside her shading her eyes and looking up, Kit in his apron with his hands in his pockets, calm; white sheets and a red jumper on a washing line. Only the sky and the branches are seen above them. |

**Sürpriz kontrolü:** Sonun sürprizi, kasabanın uydu görüntülerinde bilerek görünmemesidir: sakinler onlarca yıldır çatıları yosun yeşiline boyar ve evlerin arasındaki ağaçları korur; fırıncı Kit, kasabayı 1931'de uyduran haritacı Arthur Lisle'ın torunudur ve kartpostalı o yazmıştır. Hiçbir görselde boya tenekesi, fırça, merdiven, çatıda çalışan biri ya da boya izi gösterilmez. Kasaba hiçbir görselde yukarıdan (kuş bakışı ya da uydu açısından) gösterilmez; çatılar yalnız p13'te yerden ve ağaçların arasında, kitaptaki "yosun" açıklamasıyla uyumlu biçimde görünür. Kapakta vadi yalnız ağaçla doludur. Kit'in çizim aleti kutusu, kara tahta, kartpostal ve haritanın kenarındaki not hiçbir görselde yer almaz; p18'deki harita yalnız soluk bir dikdörtgen olarak çizilir. p26'da gökyüzüne bakan üç kişi gösterilir ama sonuç (boş uydu görüntüsü) gösterilmez.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | ca5a9bd6-a82f-4f6d-a826-e68df192dc68 | — | 2026-10-14T16:42:15+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | d68a7d40-ddf4-44d8-95ac-a2be886ef0ed | ca5a9bd6-a82f-4f6d-a826-e68df192dc68 | 2026-10-14T16:49:11+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 3babae9b-290f-4c2a-84eb-061e09c0d950 | ca5a9bd6-a82f-4f6d-a826-e68df192dc68 | 2026-10-14T16:49:11+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | 44d97826-1750-4987-964e-416e76df8f49 | ca5a9bd6-a82f-4f6d-a826-e68df192dc68 | 2026-10-14T16:49:14+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | b779915a-2809-4a99-9052-af3f7703abfe | ca5a9bd6-a82f-4f6d-a826-e68df192dc68 | 2026-10-14T16:49:27+00:00 | 3:4, medium, 1k | 0.5 |
| p18.png | dec1f81c-5eb6-4734-8f5f-7f949d55a480 | ca5a9bd6-a82f-4f6d-a826-e68df192dc68 | 2026-10-14T16:49:34+00:00 | 3:4, medium, 1k | 0.5 |
| p22.png | 422cdd28-d7d5-41fd-9d3f-ac5b9a8619f3 | ca5a9bd6-a82f-4f6d-a826-e68df192dc68 | 2026-10-14T16:49:34+00:00 | 3:4, medium, 1k | 0.5 |
| p26.png | 73e7a93c-7d9b-4999-a9da-75f7b9749a11 | ca5a9bd6-a82f-4f6d-a826-e68df192dc68 | 2026-10-14T16:49:38+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 4 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C2 başlangıç değeri; C2'de anlatım temposu varsayılanı `off`, hedef doğal hız, katalogda ~165 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-04T05:49:38Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1796 | 111.0 | 5c088102a6cd428f8bce04eb4d51a8d5 | d8828f3fd597c268 |
| 2026-11-04T05:49:48Z | p01 | duyu-1 | - | - | - | 111.0 | - | d8828f3fd597c268 |
| 2026-11-04T05:50:11Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 2137 | 139.92 | 89566c0540774688ad35eca5b3a7f698 | f12eea5cfcfa6a91 |
| 2026-11-04T05:50:23Z | p02 | duyu-1 | - | - | - | 139.92 | - | f12eea5cfcfa6a91 |
| 2026-11-04T05:50:49Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 2346 | 150.13 | e088fcb31f8f4150ae2735416eba1ac8 | ed4f8192d3714394 |
| 2026-11-04T05:51:03Z | p03 | duyu-1 | - | - | - | 150.13 | - | ed4f8192d3714394 |
| 2026-11-04T05:51:27Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1726 | 115.94 | 46880690d6a44225924cf6e26a3e38af | f65f0169c86c3b64 |
| 2026-11-04T05:51:40Z | p04 | duyu-1 | - | - | - | 115.94 | - | f65f0169c86c3b64 |
| 2026-11-04T05:52:04Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 2136 | 131.1 | 4bbd776956084b05b411833dd737903c | 0ca069976670c495 |
| 2026-11-04T05:52:23Z | p05 | duyu-1 | - | - | - | 157.25 | - | 0ca069976670c495 |
| 2026-11-04T05:52:43Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1539 | 98.19 | 7ce56971d4e24e859d73b37c38f1b500 | 338cab67a31ab5c8 |
| 2026-11-04T05:53:01Z | p06 | duyu-1 | - | - | - | 121.06 | - | 338cab67a31ab5c8 |
| 2026-11-04T05:53:19Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 1942 | 117.5 | fc8a2b0ee46e4cf6a5298704ca8e9d0d | 5c2c41db45daee30 |
| 2026-11-04T05:53:32Z | p07 | duyu-1 | - | - | - | 117.5 | - | 5c2c41db45daee30 |
| 2026-11-04T05:53:56Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 1786 | 112.66 | 638777dbc3ff409aa94c9729d557d40b | 8316c92f25474086 |
| 2026-11-04T05:54:05Z | p08 | duyu-1 | - | - | - | 112.66 | - | 8316c92f25474086 |
| 2026-11-04T05:54:26Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1892 | 115.36 | 92ab73166dca41b4a6561cd56420a781 | ae04b71ae1c612a0 |
| 2026-11-04T05:54:37Z | p09 | duyu-1 | - | - | - | 115.36 | - | ae04b71ae1c612a0 |
| 2026-11-04T05:54:57Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1870 | 114.26 | ef66d4d5d206428aabe8b8cfbe51fb78 | 1055e48e097856ea |
| 2026-11-04T05:55:10Z | p10 | duyu-1 | - | - | - | 114.26 | - | 1055e48e097856ea |
| 2026-11-04T05:55:31Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 1834 | 118.58 | 972ae7e462414087bcf72595929be95c | a93ebab57873cbd6 |
| 2026-11-04T05:55:45Z | p11 | duyu-1 | - | - | - | 140.38 | - | a93ebab57873cbd6 |
| 2026-11-04T05:56:06Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1812 | 115.21 | 1ff91194342247aeae1eafa7145ed15f | 5c0710cd1a4af4c5 |
| 2026-11-04T05:56:19Z | p12 | duyu-1 | - | - | - | 115.21 | - | 5c0710cd1a4af4c5 |
| 2026-11-04T05:56:40Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 1934 | 116.59 | 3acd38ec45aa4d46b1832d65ffb7690b | d7ce503a6094a0d6 |
| 2026-11-04T05:56:52Z | p13 | duyu-1 | - | - | - | 116.59 | - | d7ce503a6094a0d6 |
| 2026-11-04T05:57:14Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1915 | 128.9 | db53db42b75844f39c2064a24427b7bc | a0acda85efbe5b6d |
| 2026-11-04T05:57:27Z | p14 | duyu-1 | - | - | - | 128.9 | - | a0acda85efbe5b6d |
| 2026-11-04T05:57:48Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 2018 | 126.15 | 55955751a1ff443c844eb629cb969e15 | b4e88ad8ec4e9747 |
| 2026-11-04T05:58:00Z | p15 | duyu-1 | - | - | - | 126.15 | - | b4e88ad8ec4e9747 |
| 2026-11-04T05:58:22Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1959 | 120.77 | 19e0876fd76c46028a2eff0c37540cde | 9dc7b5ee6bccdf6f |
| 2026-11-04T05:58:34Z | p16 | duyu-1 | - | - | - | 120.77 | - | 9dc7b5ee6bccdf6f |
| 2026-11-04T05:58:56Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 2093 | 136.05 | 74c040f24e7a4034ad7ef50b5c557000 | 1c2bbc3cd4110063 |
| 2026-11-04T05:59:15Z | p17 | duyu-1 | - | - | - | 136.05 | - | 1c2bbc3cd4110063 |
| 2026-11-04T05:59:37Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1840 | 117.33 | 3661aee1fa944ea788a81472228685e0 | 13196f7fa07b48aa |
| 2026-11-04T05:59:46Z | p18 | duyu-1 | - | - | - | 117.33 | - | 13196f7fa07b48aa |
| 2026-11-04T06:00:09Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 2014 | 129.82 | fc2c14c88cc746c781d45fa78bf682bf | e0b0ce382eb711a2 |
| 2026-11-04T06:00:21Z | p19 | duyu-1 | - | - | - | 151.19 | - | e0b0ce382eb711a2 |
| 2026-11-04T06:00:42Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1974 | 124.28 | 10c007b22de04f0f93a87c9ba1cfb714 | 81d2ca04a83ac9f6 |
| 2026-11-04T06:00:54Z | p20 | duyu-1 | - | - | - | 124.28 | - | 81d2ca04a83ac9f6 |
| 2026-11-04T06:01:16Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1831 | 119.72 | 107be2e6cc23451c97f91dc548cc975a | a6535d85855e2a5e |
| 2026-11-04T06:01:24Z | p21 | duyu-1 | - | - | - | 119.72 | - | a6535d85855e2a5e |
| 2026-11-04T06:01:47Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 2229 | 140.34 | 33543d224c3a4953a936488e19601535 | 3c83e44345929e60 |
| 2026-11-04T06:01:59Z | p22 | duyu-1 | - | - | - | 140.34 | - | 3c83e44345929e60 |
| 2026-11-04T06:02:24Z | p23 | alania-v2 | alania2-f1 | alania-v2.1 | 2005 | 122.15 | 71faa6cb043e4a288fd1682501763778 | 18165796c98c622e |
| 2026-11-04T06:02:38Z | p23 | duyu-1 | - | - | - | 122.15 | - | 18165796c98c622e |
| 2026-11-04T06:03:01Z | p24 | alania-v2 | alania2-f1 | alania-v2.1 | 1929 | 130.2 | e247dd8626884ffcbdabf09aa78fed86 | 4e2531ce54915ead |
| 2026-11-04T06:03:18Z | p24 | duyu-1 | - | - | - | 152.13 | - | 4e2531ce54915ead |
| 2026-11-04T06:03:40Z | p25 | alania-v2 | alania2-f1 | alania-v2.1 | 1528 | 100.62 | 1cc2154dc6054f0f88c8ec2982579c8f | b5ef8351cadde237 |
| 2026-11-04T06:03:55Z | p25 | duyu-1 | - | - | - | 100.62 | - | b5ef8351cadde237 |
| 2026-11-04T06:04:14Z | p26 | alania-v2 | alania2-f1 | alania-v2.1 | 1919 | 122.36 | f67eb97ac1244f448bb61aa446a6f21e | 04b2d61aab3ab0f9 |
| 2026-11-04T06:04:23Z | p26 | duyu-1 | - | - | - | 122.36 | - | 04b2d61aab3ab0f9 |
| 2026-11-04T06:04:45Z | p27 | alania-v2 | alania2-f1 | alania-v2.1 | 1891 | 123.82 | 4e427a31107a467b9a6f66015b8f6570 | 0f28fc680e3245b3 |
| 2026-11-04T06:04:54Z | p27 | duyu-1 | - | - | - | 123.82 | - | 0f28fc680e3245b3 |
| 2026-11-04T06:05:32Z | p28 | alania-v2 | alania2-f1 | alania-v2.1 | 2278 | 149.32 | e04e35e1f4184deca78ac822d7acd3e9 | 908936064ac6a228 |
| 2026-11-04T06:05:52Z | p28 | duyu-1 | - | - | - | 149.32 | - | 908936064ac6a228 |
| 2026-11-04T06:06:19Z | p29 | alania-v2 | alania2-f1 | alania-v2.1 | 2153 | 139.8 | 137456fb4d2844deab68be61ddc3c4eb | cd4d00eb3e919fe8 |
| 2026-11-04T06:06:34Z | p29 | duyu-1 | - | - | - | 139.8 | - | cd4d00eb3e919fe8 |
