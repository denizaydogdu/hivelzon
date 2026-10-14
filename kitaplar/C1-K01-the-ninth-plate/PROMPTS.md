# C1-K01 The Ninth Plate: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C1-K01 (özet, kanca, bölüm planı, son sürpriz, dil odağı) ve C1 "Seviye dil odağı"; `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 konuları (G-C1-01…G-C1-08) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "C1-K01 *The Ninth Plate* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 7 bölüm (Snow, Parcels, Suspicion, That Night, Candles, The Anagram, The Ninth Guest), 28 sayfa, ~8.000 kelime (C1 hedefi 6.400–9.600). Kahraman Ruth Okafor (58), emekli bulmaca yazarı; üçüncü tekil şahıs, Ruth'a yakın bakış, zeki, kuru mizahlı, ölçülü tempo. Karla kapanmış bir göl otelinde sekiz yabancı, dokuz tabak, paketler, imzası anagram olan davetiye; otel müdürü yanıltıcı ipucu; ev sahibi genç aşçı Maren, on dört yıl önce istasyonda kaybolan kız. C1 yapıları doğal biçimde ve her biri en az iki kez: devrik yapı, cleft, karma koşul, ortaç yan cümleleri, needn't have / might well have / was supposed to / would rather, kişisiz edilgen, It's high time / as if / would rather you didn't, eksiltme ve yerine koyma; deyimler (a red herring, put two and two together); konuşmalarda resmî ve gündelik üslup farkı. Standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, kişi ve yer adı yok. Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; ileri kelimeler ve C1 yapı notları sözlükte."

**Kanca kararı:** Katalogdaki kanca (*Eight strangers were invited to dinner, but the table had been laid for nine.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. Kitap aynı karşıtlıkla kapanır: dokuzuncu yer ev sahibinin değil, "o geceki kız"ındır; son satırda gece kuşu ile erkenci kuş aynı mutfakta buluşur.

**Takma ad ve anagram kararı:** Katalog, imzanın Ruth'un bulmaca takma adının "ters çevrilmiş bir oyunu" olmasını istiyor. Ruth'un takma adı **Night Owl** (gece kuşu); imza **Daryl Brie**, **Early Bird**'ün (erkenci kuş, gece kuşunun tersi) anagramıdır. Ruth'un trende bulduğu **Bridal Rye** da aynı dokuz harftir; okur için adil bir ipucudur. Erkenci kuş = sabah beşte işe başlayan aşçı.

**Adil son için yerleştirilen ipuçları:**
- Ruth'un takma adı Night Owl; yirmi yıl boyunca editörü dışında kimse bilmiyordu; altı yıldır tek bulmaca bitirmedi (p01). İmza Daryl Brie; Ruth harflerin bir şey sakladığından emin; Bridal Rye aynı harflerle (p02).
- Bay Crane aşçının saatler önce evine gittiğini söylüyor (p03); dokuzuncu yere gözü kayıyor (p03, p11).
- Domates çorbasının tadı Ruth'a tanıdık geliyor (p05).
- Ruth'un paketi: kendi bulmaca kitabı; arkadaki elle çizilmiş bulmaca Ruth'un el yazısıyla; son ipucu "The first thing you ever said to me. Six letters." (p07). Ruth bir an kırmızı bir yün bere görüyor (p08).
- Kilitli mutfakta hâlâ sıcak çorba: biri onu karıştırıyor (p12).
- Maren: kulağının arkasında kalem; "I start at five, and bread doesn't wait." (p13); Desmond'un çayına istemeden üç şeker koyuyor (p13) — Desmond'un anısı: kız ona çayına kaç şeker attığını sormuştu, "üç" (p16).
- Theo'nun on altı yaşında yazıp bir kez çaldığı şarkı (p15); Maren mutfakta sonunda soru gibi yükselen bir ezgi mırıldanıyor (p19, p28).
- Kız bankta karton bardaktan çorba içiyordu, yanında bulmaca çözen bir kadın vardı (p15); Ruth ona bir sandviç almak istemişti (p16).
- Felix'in eldiveninin ikizi Maren'in önlüğünün cebinde (p16); "Gloves are like socks…" kaçamağı (p19).
- Mutfak duvarında yüzlerce cumartesi bulmacası, hepsi bitirilmiş; Ruth "boş bir odayla konuşmak gibiydi" deyince Maren: "It wasn't empty." (p18).
- Yanıltıcı ipucu Bay Crane: tırmalanmış eller, kilitli ofisten gelen ince ses, yeleğindeki gri tüyler ve Felix'in hapşırması (p10) → ofiste saklanan anne kedi ve yavruları (p19).
- Ruth kıza gece yarısı "I'm a night owl… it's a secret." demişti (p23, Ruth'un hatırladığı an; çözüm p22–p23'te).

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 8 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png`, `images/p21.png`, `images/p25.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter ve mekân tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Elegant Art Deco inspired illustration, non-photorealistic, clean ink lines with flat and softly graded colour, geometric fan and sunburst motifs, warm candlelit night interiors. Palette: deep emerald green, candle gold, snow white, warm cream, touches of dark wood. Mood: elegant, warm, quietly mysterious, never frightening, with a hint of dry humour. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; invitations, place cards, labels, parcels, newspapers and crossword grids are drawn blank or with abstract lines only, clock faces have no numbers. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Ruth Okafor:** 58-year-old Black British woman, short natural grey-and-black hair, round tortoiseshell glasses, sharp amused eyes, a pencil tucked behind one ear; a dark green cardigan over a cream blouse, a long wool coat.
- **Agnes Thorne:** about 64, small and upright, silver hair cut in a perfectly straight bob, calm watchful face; a grey dress with a neat collar.
- **Desmond Pike:** about 65, large and cheerful, round red face, thinning white hair, a big checked jacket.
- **Ambrose Hale:** about 78, very tall and thin, white moustache, old-fashioned tweed suit and tie.
- **Felix Arden:** man in his forties, slim, worried eyebrows, a brown knitted jumper.
- **Bev Hartley:** woman about 55, sturdy, short dyed red-purple hair, big laugh, a bright knitted cardigan.
- **Priya Nair:** South Asian woman about 50, neat dark hair in a low bun, calm precise face, a navy jacket.
- **Theo Fallon:** thin man about 30, untidy red hair, freckles, a dark coat, carrying a guitar case.
- **Mr Crane:** narrow anxious man about 40, neat dark hair, a tea-brown waistcoat, thin scratches on one hand.
- **Maren:** young woman about 23, small and quick, dark hair tied back under a white cloth, a white cook's jacket with sleeves pushed up, flour on her arms, a pencil behind her ear.
- **The Glasswater Hotel:** an Art Deco lakeside hotel in deep snow, tall lit windows, a frozen lake and dark pines behind.
- **The dining room:** deep emerald walls, mirrors framed in gold fans, lamps shaped like tulips, a long table with a white cloth, nine white plates, crystal glasses, tall gold candlesticks, nine green velvet chairs with curved backs.
- **The kitchen:** copper pans hanging in rows, bunches of herbs drying from a beam, a long steel counter, a big black stove, two swinging doors with round porthole windows.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | The long candlelit dining table seen from one end in the emerald dining room: nine white plates, crystal glasses and gold candlesticks; at the far end one green velvet chair stands empty, and on its seat sits a small parcel in brown paper tied with green string; through the tall windows behind, heavy snow falls over a frozen lake. No people. |
| p01.png | p01 (Bölüm 1, Snow) | Ruth stands just inside the dining room doorway, glasses on, counting the places at the long table with one raised finger; behind her, the other guests (Agnes, Desmond, Ambrose, Felix, Bev, Priya, Theo with his guitar case) shake snow from their coats; Mr Crane holds an umbrella turned inside out. |
| p05.png | p05 (Bölüm 2, Parcels) | At the table, bowls of dark red tomato soup in front of each guest; Felix lifts his napkin to discover a small brown-paper parcel tied with green string; the other guests lean in, curious; Mr Crane hurries out of the door with a silver soup pot. Parcels and labels are blank. |
| p09.png | p09 (Bölüm 3, Suspicion) | The guests around the table in lively, comic suspicion: Desmond and Ambrose eye each other, Bev laughs, Priya sits calm with folded hands, Felix sneezes into a handkerchief; Mr Crane, anxious, stands in the doorway hiding one scratched hand behind his back; Ruth watches quietly. |
| p13.png | p13 (Bölüm 4, That Night) | In the dark corridor, Ruth holds a candle in front of the kitchen's swinging doors; one door has just opened and Maren looks out, surprised and shy, flour on her arms, warm light and copper pans behind her. |
| p17.png | p17 (Bölüm 5, Candles) | The dining room in a power cut: only the tall candles light the table, small trembling circles of gold; the mirrors are full of tiny flames, the emerald walls almost black; the guests' faces float above the white tablecloth like an old painting; Mr Crane in the doorway with a torch that does not work. |
| p21.png | p21 (Bölüm 6, The Anagram) | Close view of Ruth at the table, pencil in hand, bent over the back of a blank cream invitation card on which nine small abstract marks are arranged in a circle (no readable letters); behind her, out of focus, the other guests argue and point at an empty place at the table. |
| p25.png | p25 (Bölüm 7, The Ninth Guest) | Late at night, the guests sit quietly around the long table, listening, seen from behind Ruth's shoulder; at the far end, in the ninth chair, Maren in her white cook's jacket speaks softly, her hands folded; snow against the dark windows. |

**Sürpriz kontrolü:** Sonun sürprizi, ev sahibinin genç aşçı Maren olması, onun on dört yıl önceki kaybolmuş kız olması, imzanın "Early Bird" anagramı olması ve son ipucunun cevabının "Hungry" çıkmasıdır. Hiçbir görselde kırmızı yün bere, istasyon, otobüs bileti, eldiven, karton bardak çorba ya da peynirli sandviç yoktur; davetiye, kartlar ve bulmaca ızgaraları yazısız ve okunamaz soyut çizgilerle çizilir (p21'deki işaretler harf değildir). Maren yalnızca p13'te (metnin kendisini tanıttığı sahne) ve p25'te (metnin onu dokuzuncu sandalyeye oturttuğu p24'ten sonra) görünür; hiçbir görsel onun geçmişini ya da konuklarla bağını göstermez. Kapakta kimse yoktur ve dokuzuncu sandalyede yalnızca paket durur.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C1 başlangıç değeri; C1'de anlatım temposu varsayılanı `off`, hedef ~160 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
