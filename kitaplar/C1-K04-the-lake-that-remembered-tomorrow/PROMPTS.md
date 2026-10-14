# C1-K04 The Lake That Remembered Tomorrow: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C1-K04 (özet, kanca, bölüm planı, son sürpriz, dil odağı, görsel, anlatıcı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 konuları (G-C1-01…G-C1-08) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "C1-K04 *The Lake That Remembered Tomorrow* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 7 bölüm (Arrival, Instruments, The Ledger, What You Want, The Report, Storm, Blank Water), 28 sayfa, ~8.000 kelime (C1 hedefi; 7.600–8.600). Üçüncü tekil şahıs, geçmiş zaman, şüpheci hidrolog Tomás Arrieta'ya (34) yakın anlatıcı; düşünceli, yavaş başlayıp derinleşen, hafif melankolik; kuru mizah. Büyülü gerçekçilik; uydurma dağ köyü Ardal. Temkinli bilimsel üslup (saha notları, rapor) ile iç ses arasında geçişler. C1 yapıları doğal biçimde ve her biri en az iki kez: devrik yapı, cleft, karma koşul, devrik koşul (Had I…, Should anyone…), ortaç yan cümleleri, modal incelikleri (needn't have, might well, be supposed to, would rather), kişisiz edilgen, gerçek dışı geçmiş (It's high time…, as if…, I'd rather you didn't), eksiltme ve yerine koyma; resmî dilek kipi ve adlaştırma raporda. Standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden adil ipuçları verilmiş sürpriz son. 13+ güvenli; fırtınada kimse suya girmez; gerçek marka, kişi, kurum ve yer adı yok. Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; ileri kelimeler ve C1 yapı notları sözlükte."

**Kanca kararı:** Katalogdaki kanca (*In the lake at Ardal, Tomás saw himself doing something he had not yet decided to do.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. Son cümle aynı kalıbı ters çevirir: *In the lake at Ardal, Tomás saw only the sky, and for the first time in his life he knew exactly what he would do tomorrow.*

**Bölüm sonu kancaları (katalogla eşleşme):** c1 ertesi gün yansımadaki şeyi yapar (p04–p05); c2 aynı su aynı anda iki farklı yarın gösterir (p09); c3 yansımaların yalnızca yüzde altmış biri gerçekleşmiştir (p13); c4 yansımada raporunu yırtar (p16–p17); c5 o andan sonra göl ona hiçbir şey göstermez (p21); c6 şafakta kendini köyden ayrılırken görür (p25); c7 karar ve boş su (p28).

**Adil son için yerleştirilen ipuçları:**
- Palto: Tomás karar vermeden, "as if his hands had been told what to do by someone else" (p04); "What disturbed him was … that he had not chosen to give it away." (p05).
- "Each time, Tomás had not decided anything… like a leaf carried by a stream." Tersini yapmaya kesin karar verdiği sabah göl yalnızca yüzünü ve gökyüzünü gösterir (Gözlem yedi) (p07).
- Aurel (oğlunun baskısıyla sürüklenen) satar; bütün gece oturup kararını veren Constantin ertesi sabah "nothing there. Only sky." görür (p10).
- Nico: "I've never seen anything… I always know what I'm going to do. I decide everything at breakfast." ve anlatıcı: "the most important observation he made in Ardal" (p12).
- Defterdeki iki yüz on iki "blank" sabah (Constantin da aralarında) ve gerçekleşmeyenlerin yorumları: "Changed her mind. Talked it over… and decided not to. Sat by the water all night and chose." Ardından "Had he looked at them more closely, he might have saved himself a great deal of trouble." (p13).
- Ardal sözü: "the lake remembers tomorrow for those who forget to choose it" (p14).
- Bank sahnesi: Tomás sahneye "drifted into it, one small easy step after another" ve bilinçli olarak durur; yansıma gerçekleşmez (p19–p20).
- Dürüst raporu bilinçli olarak gönderdiği sabah ve sonrasında su boş (p21); "He had not decided anything at all since the night of the report." (p26).
- Oriana otuz bir yıldır, defteri tutmaya karar verdiği geceden beri yalnızca gökyüzünü görür (p28).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: 500 kredi yüklendi, "tüm yarım kalan işlerimizi yap … onay verdim". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 8 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p14.png`, `images/p18.png`, `images/p22.png`, `images/p26.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Magical realism illustration, non-photorealistic, painterly with soft gouache textures, calm symmetrical compositions with a strong central axis. Palette: mirror-like steel-grey lake water, misty violet and purple mountains, pale morning gold light, cool mist white, small touches of warm wood and stone. Mood: silent, mysterious, contemplative, slightly melancholic, never frightening. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; book pages, papers, screens and notebooks show only abstract soft lines; no clock faces. Reflections in the water are soft and calm. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Tomás Arrieta:** 34-year-old man, thin serious face, dark hair a little too long at the back, light stubble, tired thoughtful eyes; a long grey wool coat over a dark jumper; often holding a small notebook.
- **Nico:** 8-year-old boy, pointed chin, a cloud of untidy fair hair, a thin red jumper; lively, curious expression.
- **Petra:** woman in her fifties, broad-shouldered, practical, hair tied back, a flour-dusted apron over a dark dress, rolled-up sleeves.
- **Oriana:** woman of about sixty, tall and very straight, short grey hair, very dark attentive eyes, a long dark wool cardigan; calm, quietly amused.
- **Aurel:** old man in his seventies, tall and stooped, a large white moustache, a patched work jacket.
- **Constantin:** old man in his seventies, short and round, a very old shapeless felt hat, a thick knitted jumper.
- **Ardal:** a small mountain village of thirty or forty grey stone houses at the northern end of a long, narrow lake between two steep mountains; smoke rising straight from chimneys; a guesthouse with blue shutters and a small garden running down to the water with a wooden bench; a low stone wall and an old dry stone fountain where the yellow bus stops; at the southern end an old arched stone bridge over the narrow outflow; flat rocks along the shore; small wooden rowing boats pulled up on the stones.
- **Oriana's kitchen:** warm, woodsmoke and apples on the table, a wall of floor-to-ceiling shelves of thick books bound in dark cloth.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Dawn at a perfectly still mountain lake, symmetrical composition: Tomás, small in the frame, crouches on a flat rock at the water's edge in his grey coat, looking down; the lake mirrors the violet mountains and a line of gold light running across the water towards him; his reflection is only a soft, glowing, indistinct shimmer of light, with no clear figure or action in it; thin layers of mist. |
| p01.png | p01 (Bölüm 1, Arrival) | Late evening: a small bus on a mountain road high above a long, narrow, steel-grey lake lying between two mountains like a blade; below, the stone village with smoke rising straight up and the guesthouse with blue shutters; Tomás seen from behind, standing by the road with two instrument cases and a small suitcase. |
| p06.png | p06 (Bölüm 2, Instruments) | Early misty morning on a flat rock at the southern end of the shore: Tomás kneels beside a small camera on a tripod facing the lake, a cable running down into the dark water, small glass sample bottles in a row and an open cool box; the water is calm and grey; the old stone bridge in the far background. |
| p10.png | p10 (Bölüm 3, The Ledger) | Oriana's warm kitchen: Tomás and Oriana sit at a wooden table with a large open ledger between them, its pages covered only in abstract faint brown lines and columns; floor-to-ceiling shelves of dark cloth-bound books behind them; apples in a bowl; a window showing the grey lake. |
| p14.png | p14 (Bölüm 4, What You Want) | A grey, low-sky morning on the shore: Tomás walks along the water's edge with a laptop under his arm, pausing to glance down; the still water shows only his own ordinary reflection and the grey sky; the last stone house of the village small in the distance. |
| p18.png | p18 (Bölüm 5, The Report) | Thin autumn sunshine on the bench in front of the guesthouse, where the garden runs down to the lake: Tomás sits with a pad of paper and a pen, a cup of coffee beside him, frowning; Nico sits on the stones at his feet drawing an enormous chalk volcano; Petra watching from the doorway. The papers are whole and blank-looking, with only faint abstract lines. |
| p22.png | p22 (Bölüm 6, Storm) | Night storm at the old arched stone bridge: a dozen villagers stand on the bridge in heavy rain with lamps and torches, pulling ropes tied to branches piled under the arch; Aurel and Constantin side by side holding a rope; Oriana at the end of the bridge with a lamp; Tomás pointing and giving directions; nobody is in the water; dramatic but safe, warm lamp light against dark blue rain. |
| p26.png | p26 (Bölüm 7, Blank Water) | Early morning after the storm, wet pine and shining stones: Tomás, seen from behind and at a distance, runs along the curving shore towards the last stone house of the village, where a single window is lit; the calm lake reflects the violet mountains and the pale gold sky. |

**Sürpriz kontrolü:** Sonun sürprizi, gölün geleceği ya da istekleri değil, insanın karar vermeyip sürüklenirse varacağı yeri göstermesi; bilinçli bir karar verildiğinde yansımanın kaybolup suda yalnızca gökyüzünün görünmesidir. Hiçbir görsel, birinin suya baktığında yüzü yerine boş gökyüzü gördüğü anı göstermez. Kapaktaki yansıma belirsiz bir ışık pırıltısıdır; ne bir eylem ne de boşluk gösterir. p14'teki yansıma sıradan, kendi yüzüdür (metindeki o anla aynı). Defter sayfaları yalnız soyut çizgilerdir; yüzde altmış bir sayısı ya da "blank" kelimesi görünmez. p26'da Tomás uzaktan ve arkadan görünür, suya bakmaz; göl yalnızca manzarayı yansıtır. Böylece hiçbir görsel kararla boş su arasındaki bağı ele vermez.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | c2ae771a-703c-41a4-9df1-b97d81129581 | — | 2026-10-14T16:41:16+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 5fce350d-2d2f-4ead-aca2-c0b1aeb2ea57 | c2ae771a-703c-41a4-9df1-b97d81129581 | 2026-10-14T16:46:27+00:00 | 3:4, medium, 1k | 0.5 |
| p14.png | 2db33b36-5b4d-46af-950a-7478ae3cb0ce | c2ae771a-703c-41a4-9df1-b97d81129581 | 2026-10-14T16:46:31+00:00 | 3:4, medium, 1k | 0.5 |
| p10.png | adc305f2-f8d5-45e8-ae86-e9e08c39e3c9 | c2ae771a-703c-41a4-9df1-b97d81129581 | 2026-10-14T16:46:31+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | b4d87a08-b3ee-4d49-9875-3eedbb6a6466 | c2ae771a-703c-41a4-9df1-b97d81129581 | 2026-10-14T16:46:32+00:00 | 3:4, medium, 1k | 0.5 |
| p18.png | 89aa2c06-cce0-4446-bee7-bd438eace610 | c2ae771a-703c-41a4-9df1-b97d81129581 | 2026-10-14T16:46:53+00:00 | 3:4, medium, 1k | 0.5 |
| p26.png | ee753f67-850e-46fd-a918-9e9ecc8daeb9 | c2ae771a-703c-41a4-9df1-b97d81129581 | 2026-10-14T16:46:55+00:00 | 3:4, medium, 1k | 0.5 |
| p22.png | f3b61d60-4b96-4550-a8b2-7c63be8aaf3f | c2ae771a-703c-41a4-9df1-b97d81129581 | 2026-10-14T16:46:57+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 4 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C1 başlangıç değeri; C1'de anlatım temposu varsayılanı `off`, hedef ~155 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
