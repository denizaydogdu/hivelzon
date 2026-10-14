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

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 8 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p18.png`, `images/p22.png`, `images/p26.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

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

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C2 başlangıç değeri; C2'de anlatım temposu varsayılanı `off`, hedef doğal hız, katalogda ~165 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
