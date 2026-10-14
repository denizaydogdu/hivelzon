# C1-K02 Eleven Bridges: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C1-K02 (özet, kanca, bölüm planı, son sürpriz, dil odağı, görsel, anlatıcı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 konuları (G-C1-01…G-C1-08) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md`, `PROMPTS.md` |

**İstem (özet):** "C1-K02 *Eleven Bridges* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 7 bölüm (The Diary, Stone, Wood, Iron, The Knee, The Festival, The Delta, Nothing There, The Eleventh Bridge), 28 sayfa, ~8.000 kelime (C1 hedefi 7.600–8.600). Birinci tekil şahıs anlatıcı Lena Vogt (31, inşaat mühendisi); sakin, gözlemci, kuru esprili. Büyük teyzesi Hedda'nın 1962 bisiklet defterindeki on bir köprü; doğum gününe üç hafta; diz sakatlığı; 11. köprü hiçbir haritada yok. Uydurma bir nehir ve kasabalar. C1 yapıları doğal biçimde, her biri en az iki kez: devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri (needn't have, might well have, be supposed to, would rather), kişisiz edilgen, gerçek dışı geçmiş (it's high time, as if, would rather you didn't), eksiltme ve yerine koyma; geçmiş modallar (could have, should have), past perfect continuous; betimleyici eşdizimler; teknik ve gündelik dil karşıtlığı; standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, kişi ve yer adı yok. Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; ileri kelimeler ve C1 yapı notları sözlükte."

**Kanca kararı:** Katalogdaki kanca (*My great-aunt's diary described eleven bridges, but only ten of them were on any map.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. Hedda'nın cümlesi (*Some bridges you find. Some find you.*) p03'te kurulur, p15'te Tomasz'ın ağzından anlamı değişir (*It was not always a joke.*) ve son sayfada geri döner: *This one took sixty-four years, and it had to send a girl on a bicycle. Twice.*

**Adil son için yerleştirilen ipuçları:**
- Kutudaki açılmamış uzun zarf (p01); sonda reddedilen projenin mektubu olduğu ortaya çıkar (p26, p28).
- On birinci çizimde yer adı yok; kıyı, ağaç, inek yok; köprü "cetvelle çekilmiş bir çizginin üstünde" duruyor; kenarda tarih ya da mesafe sanılan küçük rakamlar; altında daha kararlı yazılmış "Number eleven. Here, one day." (p02).
- Hedda kurşun kalemi "yanılmayı bekleyenlere" bırakır (p03); defteri aramadan doğru sayfadan açar (p04); mühendislik okumuş ama hiç köprü yapmamıştır (p04).
- Spanyelli adam: "Whoever did that knew how things stand up." (p06); mühendis Priya: "These aren't sketches… nobody draws the expansion joint unless they know what it's for." ve "That seems a waste." (p07).
- Ilan'ın babası: o yaz bisikletli bir kız nehri ip ve taşla ölçmüş, derinlik, hız, genişlik (p11). Ilan: Wrenmouth'ta nehir kışın kapanır, karşı kıyı iki saat dolaşır; "someone ought to build them a bridge… Too soft underneath." (p12).
- Harl'daki fotoğraf: genç Hedda koltuğunun altında uzun bir karton tüple (çizim rulosu) (p12).
- Tomasz: sınıftaki tek kadın öğrenci, en iyisi; projeler yan yana "until the last"; "It was not always a joke."; rakamlar tarih değil, harita koordinatı (p14, p15).
- Hedda telefonda: "You needn't have come all this way for me." ve "Take a good look." (p18).
- Kanal kapağı bekçisi (Mardle): koordinat nehrin ortası, "nothing there but water" (p16); cezirde ortaya çıkan çakıl tümseği, "The Bank" (p21); Bayan Dunmore: "A bridge would need to stand on the Bank, and nobody has ever come up with a design that could." (p22).

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 8 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png`, `images/p21.png`, `images/p25.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Travel-journal sketch illustration, non-photorealistic: loose graphite pencil lines with soft watercolour washes on cream textured paper, like a page from an engineer's sketchbook, airy and thoughtful. Palette: river green, stone grey, summer yellow, cream paper, a little sky blue. Mood: calm, spacious, quietly curious, gentle dry humour. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; diary and sketchbook pages show only drawings and soft abstract pencil marks, maps are blank shapes and lines, phone screens are blank. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Lena Vogt:** 31-year-old woman, slim and practical, shoulder-length dark-blonde hair tied back, light freckles, grey eyes, thoughtful slightly amused expression; a faded green cycling jacket, cargo trousers, trainers; a small sketchbook and pencil always to hand; from chapter 3 a supportive strap on her left knee.
- **Hedda Vogt:** 89-year-old woman, small and very upright, white hair in a neat low bun, sharp blue eyes behind round glasses, a dark cardigan over a pressed blouse; holds a pen like an engineer.
- **Mortimer:** a large, grumpy grey cat with a torn ear.
- **Ilan:** man in his seventies, white beard, broad forearms, a navy wool jumper and a flat cap, calm weathered face.
- **Margit:** elderly village woman, round and cheerful, silver curls, a floral summer dress.
- **Tomasz:** 90-year-old man, tall but a little bent, thick white hair, a wide straw hat, kind deep-set eyes, rolled shirt sleeves.
- **Ms Dunmore:** woman in her fifties, short grey hair, a waterproof coat, a bicycle with a basket full of exercise books.
- **The River Ostrel:** a green-brown river running south from a small old town, through fields and villages to a wide flat delta of reeds, dykes and big skies, and finally a broad grey estuary with a small harbour town.
- **The bridges:** a steep two-arch grey stone packhorse bridge; a covered wooden footbridge on stone feet; an old iron lattice railway bridge with moss; a modern flat concrete road bridge; a stone bus shelter in a cabbage field; a slender suspension footbridge; a long brick viaduct; a white wooden footbridge with paper lanterns; a small iron bridge over a canal lock; a small green iron swing bridge over a tidal creek.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Lena cycles along a riverside towpath on a bright summer morning, seen from behind and slightly to the side, a small old green diary tucked in the front basket; ahead, the river winds away into the distance under a big sky, with several small bridges of different kinds (stone arch, wooden, iron) appearing one behind another along the river like a sequence; the far end of the river fades into pale watercolour haze. |
| p01.png | p01 (Bölüm 1, The Diary) | A dusty loft under a sloping roof on a rainy day: Lena sits on a wooden crate, an open shoebox at her feet with old stiff cycling gloves, a folded worn map and a long closed envelope; she holds a small swollen green diary open on her knees, its page showing a soft pencil sketch of a stone arch bridge; rain on a small roof window. |
| p05.png | p05 (Bölüm 2, Stone, Wood, Iron) | Lena sits on a low wall beside a steep two-arch grey stone packhorse bridge, the diary open on one knee and her sketchbook on the other; the brown river rushes under the arches and over a small weir; a small boy in a raincoat stands beside her, looking critically at her drawing; a borrowed bicycle leans on the wall. |
| p09.png | p09 (Bölüm 3, The Knee) | At the edge of a small town, a little old grey stone shelter with a tiled roof stands beside a field of cabbages and a country lane, now used as a bus stop; two schoolgirls sit on its stone bench looking at blank phones; Lena stands opposite, sketching it standing up; heavy rain clouds gather on the horizon. |
| p13.png | p13 (Bölüm 4, The Festival) | Midsummer evening on a village green: a white wooden footbridge strung with glowing paper lanterns, their reflections in the dark river; trestle tables, bunting without letters, a small brass band, villagers dancing; Lena sits in a deckchair with a cup of tea and a slice of lemon cake, her strapped knee stretched out, an elderly cheerful woman (Margit) telling her a story. |
| p17.png | p17 (Bölüm 5, The Delta) | A wide flat delta under an enormous sky: reeds, long straight dykes and a slow brown river; in the middle distance a small green iron swing bridge over a tidal creek pivots open as an old man in a cap turns a handle and a small sailing boat passes through; Lena, tired, stands with her bicycle on the dyke, wind blowing her hair. |
| p21.png | p21 (Bölüm 6, Nothing There) | Low tide at a small harbour town on a very wide grey estuary: shining mud banks, a narrow channel, and in the middle a long low hump of gravel like the back of a sleeping animal with rows of gulls standing on it facing the wind; a concrete slipway and a small wooden ferry hut in the foreground; Lena sits small on a low wall by the hut, the diary closed on her lap. No bridge anywhere. |
| p25.png | p25 (Bölüm 7, The Eleventh Bridge) | Night in a small room above a café: Lena sits on the bed under a warm lamp, leaning over the open diary with a ruler and a pencil, a laptop beside her with a blank glowing screen; the diary page shows only soft faint abstract pencil lines, seen at an angle and not readable; through the window, dark water and a few harbour lights. |

**Sürpriz kontrolü:** Sonun sürprizi, on birinci köprünün hiç yapılmamış olması, Hedda'nın onu 1962'de bitirme projesi olarak tasarlaması ve projenin reddedilmesidir; Lena çizimin tam bir mühendislik projesi olduğunu anlar ve meclis onu incelemeye karar verir. Hiçbir görselde on birinci köprünün çizimi okunur biçimde gösterilmez (p01'de defter sayfasında yalnız taş kemer; p25'te sayfa açılı ve soyut çizgiler). Wrenmouth'taki görsel (p21) bilinçli olarak köprüsüz ve boştur. Genç Hedda, Tomasz'la fotoğraf, karton çizim tüpü, red mektubu, meclis toplantısı ve doğum günü hiçbir görselde yer almaz. Kapaktaki köprüler yalnız yol boyunca var olan köprülerdir; nehrin sonu sise karışır.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C1 başlangıç değeri; C1'de anlatım temposu varsayılanı `off`, hedef ~160 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
