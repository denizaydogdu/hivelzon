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

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: 500 kredi yüklendi, "tüm yarım kalan işlerimizi yap … onay verdim". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 8 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png`, `images/p21.png`, `images/p25.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 4 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter ve mekân tutarlılığı).

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


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 0239c954-066b-47b8-992e-c499689e982d | — | 2026-10-14T16:40:12+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | 6507554a-8b42-4097-a2e1-0747d0a42595 | 0239c954-066b-47b8-992e-c499689e982d | 2026-10-14T16:43:44+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | da6ce41a-780c-4840-a72c-48f1c1857c9c | 0239c954-066b-47b8-992e-c499689e982d | 2026-10-14T16:43:47+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | e888e9bf-bca7-484d-ac2d-ee77e2c570d4 | 0239c954-066b-47b8-992e-c499689e982d | 2026-10-14T16:43:47+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | 412b4c1d-e7d7-4b87-aaf9-b62cb9eb8075 | 0239c954-066b-47b8-992e-c499689e982d | 2026-10-14T16:43:49+00:00 | 3:4, medium, 1k | 0.5 |
| p17.png | 61194ae6-6141-4092-9f9c-e83bad14358d | 0239c954-066b-47b8-992e-c499689e982d | 2026-10-14T16:44:12+00:00 | 3:4, medium, 1k | 0.5 |
| p21.png | c8a3df2a-71c8-4726-b79e-013b5617d765 | 0239c954-066b-47b8-992e-c499689e982d | 2026-10-14T16:44:12+00:00 | 3:4, medium, 1k | 0.5 |
| p25.png | 4ea3a6dc-947c-41ed-8124-91247ce397fb | 0239c954-066b-47b8-992e-c499689e982d | 2026-10-14T16:44:16+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 4 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C1 başlangıç değeri; C1'de anlatım temposu varsayılanı `off`, hedef ~160 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T18:59:58Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1618 | 97.21 | c0db68e484534f9fab46a37920fc9253 | acae13bfdb4b9d41 |
| 2026-11-03T19:00:07Z | p01 | duyu-1 | - | - | - | 97.21 | - | acae13bfdb4b9d41 |
| 2026-11-03T19:00:21Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 1710 | 105.27 | 24a4dbf8c02245f7a9a4ac81b7830265 | eff602b83cd9aa6a |
| 2026-11-03T19:00:30Z | p02 | duyu-1 | - | - | - | 105.27 | - | eff602b83cd9aa6a |
| 2026-11-03T19:00:44Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 1493 | 93.03 | eee1249f60f94e6293685aa4296a39e6 | d0ba8a2c51ea532d |
| 2026-11-03T19:00:51Z | p03 | duyu-1 | - | - | - | 93.03 | - | d0ba8a2c51ea532d |
| 2026-11-03T19:01:04Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1499 | 95.97 | c8ff742652734f54887ac2999526a69d | d1a7ae5ae17056b6 |
| 2026-11-03T19:01:11Z | p04 | duyu-1 | - | - | - | 95.97 | - | d1a7ae5ae17056b6 |
| 2026-11-03T19:01:25Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1658 | 106.35 | 376d6e8d556d4b63aea9fe4b9e6ce978 | 9e8f50e1bea76838 |
| 2026-11-03T19:01:32Z | p05 | duyu-1 | - | - | - | 106.35 | - | 9e8f50e1bea76838 |
| 2026-11-03T19:01:46Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1557 | 104.21 | bb1fce1278304f02b335ee2d9380f69c | 7c6ec5e1940a5c19 |
| 2026-11-03T19:01:54Z | p06 | duyu-1 | - | - | - | 104.21 | - | 7c6ec5e1940a5c19 |
| 2026-11-03T19:02:09Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 1579 | 102.72 | 4f2f073aea1945ecbe6962edab364c97 | 2fd4b7f5e535193e |
| 2026-11-03T19:02:16Z | p07 | duyu-1 | - | - | - | 102.72 | - | 2fd4b7f5e535193e |
| 2026-11-03T19:02:31Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 1501 | 97.5 | 462c782bc83c4cffa2a3f31a582786d1 | bc758bde1c952253 |
| 2026-11-03T19:02:38Z | p08 | duyu-1 | - | - | - | 97.5 | - | bc758bde1c952253 |
| 2026-11-03T19:02:51Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1718 | 104.13 | 647987aaa91d4767bbbcd714bf516037 | 0f9da53254260a8c |
| 2026-11-03T19:02:58Z | p09 | duyu-1 | - | - | - | 104.13 | - | 0f9da53254260a8c |
| 2026-11-03T19:03:13Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1562 | 100.3 | 8338a9ee448241c6b3f138dc64c351ea | 1d0f3ba80ded8179 |
| 2026-11-03T19:03:22Z | p10 | duyu-1 | - | - | - | 100.3 | - | 1d0f3ba80ded8179 |
| 2026-11-03T19:03:36Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 1605 | 100.91 | e82b9214521745d6be60ba8eea7bb445 | 4be2bec9ab629278 |
| 2026-11-03T19:03:44Z | p11 | duyu-1 | - | - | - | 100.91 | - | 4be2bec9ab629278 |
| 2026-11-03T19:03:57Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1556 | 97.4 | 1686a458cd2d40aa97f48c97735f040c | 3f9b4b065936a815 |
| 2026-11-03T19:04:05Z | p12 | duyu-1 | - | - | - | 97.4 | - | 3f9b4b065936a815 |
| 2026-11-03T19:04:19Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 1703 | 107.46 | 45adf953355a41838272d335ac925577 | 33fc6821b212a3fc |
| 2026-11-03T19:04:27Z | p13 | duyu-1 | - | - | - | 107.46 | - | 33fc6821b212a3fc |
| 2026-11-03T19:04:41Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1604 | 100.72 | 6301a00f5eec421da6933164242bbce5 | 2759a6e92e229110 |
| 2026-11-03T19:04:48Z | p14 | duyu-1 | - | - | - | 100.72 | - | 2759a6e92e229110 |
| 2026-11-03T19:05:02Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1464 | 95.81 | 7aa78f1e5c574b68a18d0cae7539a972 | e2223a76f468edb6 |
| 2026-11-03T19:05:09Z | p15 | duyu-1 | - | - | - | 95.81 | - | e2223a76f468edb6 |
| 2026-11-03T19:05:23Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1599 | 101.65 | 9efaa1d553ad45699e680e90fa4b1752 | 199ca995c54d6d73 |
| 2026-11-03T19:05:32Z | p16 | duyu-1 | - | - | - | 101.65 | - | 199ca995c54d6d73 |
| 2026-11-03T19:05:45Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1553 | 101.63 | 0e4dc192c1104401863acd7a110a9a75 | 8b92b12821c65f7a |
| 2026-11-03T19:05:52Z | p17 | duyu-1 | - | - | - | 101.63 | - | 8b92b12821c65f7a |
| 2026-11-03T19:06:07Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1559 | 102.97 | b61e059a4e20488786635b7019a9700f | 42e027a7208d193b |
| 2026-11-03T19:06:16Z | p18 | duyu-1 | - | - | - | 102.97 | - | 42e027a7208d193b |
| 2026-11-03T19:06:30Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1710 | 109.52 | 95103a8f1c1b46ec80ffd1f079d33764 | 626adacbb4896f50 |
| 2026-11-03T19:06:37Z | p19 | duyu-1 | - | - | - | 109.52 | - | 626adacbb4896f50 |
| 2026-11-03T19:06:51Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1376 | 87.35 | b1397176ff454c7096ad510d99ae2056 | 3c131a23790cb98d |
| 2026-11-03T19:06:57Z | p20 | duyu-1 | - | - | - | 87.35 | - | 3c131a23790cb98d |
| 2026-11-03T19:07:10Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1693 | 110.4 | 45a0a8e649bb45ab96f2d388b75ade49 | d82ab3fe15e93141 |
| 2026-11-03T19:07:20Z | p21 | duyu-1 | - | - | - | 133.1 | - | d82ab3fe15e93141 |
| 2026-11-03T19:07:34Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1481 | 95.79 | c54c12ee49014d278e05cb6004a72f64 | 773dc491eaadc966 |
| 2026-11-03T19:07:42Z | p22 | duyu-1 | - | - | - | 95.79 | - | 773dc491eaadc966 |
| 2026-11-03T19:07:54Z | p23 | alania-v2 | alania2-f1 | alania-v2.1 | 1555 | 93.84 | 2b8fddcea1ea4f2fa515c040fb7ed243 | b1792194c1ff184a |
| 2026-11-03T19:08:01Z | p23 | duyu-1 | - | - | - | 93.84 | - | b1792194c1ff184a |
| 2026-11-03T19:08:15Z | p24 | alania-v2 | alania2-f1 | alania-v2.1 | 1270 | 82.92 | 72283c78757042da97130d0ed79595a9 | 13b026ee7d993399 |
| 2026-11-03T19:08:25Z | p24 | duyu-1 | - | - | - | 103.4 | - | 13b026ee7d993399 |
| 2026-11-03T19:08:38Z | p25 | alania-v2 | alania2-f1 | alania-v2.1 | 1590 | 94.97 | cac0a9432b4b4e1cb4a6e898e719153a | b95872637447a26c |
| 2026-11-03T19:08:44Z | p25 | duyu-1 | - | - | - | 94.97 | - | b95872637447a26c |
| 2026-11-03T19:08:58Z | p26 | alania-v2 | alania2-f1 | alania-v2.1 | 1607 | 100.89 | a623db6a88d14136ab70a6c6c3470af0 | 4f36933d990141b0 |
| 2026-11-03T19:09:06Z | p26 | duyu-1 | - | - | - | 100.89 | - | 4f36933d990141b0 |
| 2026-11-03T19:09:20Z | p27 | alania-v2 | alania2-f1 | alania-v2.1 | 1489 | 96.95 | f321b89682e64a1395425cca656762b4 | 130d24d310274e8a |
| 2026-11-03T19:09:28Z | p27 | duyu-1 | - | - | - | 96.95 | - | 130d24d310274e8a |
| 2026-11-03T19:09:41Z | p28 | alania-v2 | alania2-f1 | alania-v2.1 | 1357 | 87.25 | c91d6468ad8e46b18c8464ccb956fb9f | 5b7d32da4f36edca |
| 2026-11-03T19:09:48Z | p28 | duyu-1 | - | - | - | 87.25 | - | 5b7d32da4f36edca |
