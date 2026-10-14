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

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 6 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p15.png`, `images/p19.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 3 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

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

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B2 başlangıç değeri; B2'de anlatım temposu varsayılanı `off`, hedef 145–155 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
