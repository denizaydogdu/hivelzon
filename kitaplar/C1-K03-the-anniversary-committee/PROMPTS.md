# C1-K03 The Anniversary Committee: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-073 kitap dalgası 3 (C1/C2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → C1-K03 (özet, kanca, bölüm planı, son sürpriz, dil odağı, görsel, anlatıcı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` C1 konuları (G-C1-01…G-C1-08) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "C1-K03 *The Anniversary Committee* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 6 bölüm (The Meeting, Subcommittees, The Basement, Escalation, Three Days, The Speech), 27 sayfa, ~8.000 kelime (C1 hedefi 8.000 ± %20). Üçüncü tekil şahıs, geçmiş zaman, Gwen'in bakışından; deadpan, kuru mizah, ince zamanlama. Kurgusal bir şemsiye üreticisi ve uydurma bir İngiliz kasabası. C1 yapıları doğal biçimde, her biri en az 2–3 kez: devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri (needn't have, might well have, be supposed to, would rather), kişisiz edilgen, gerçek dışı geçmiş (it's high time, as if), eksiltme ve yerine koyma; kurumsal klişelerin ironisi (going forward, circle back, take this offline), kaçamak edilgen (Mistakes were made), temkinli dil (it would seem, arguably), resmî/gündelik üslup kayması. Standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, kişi ve yer adı yok. Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; C1 yapıları ve deyimler sözlükte."

**Kanca kararı:** Katalogdaki kanca (*Gwen joined the anniversary committee by accident: she was the only person who didn't leave the room fast enough.*) metnin ilk cümlesidir ve `book.json → hookEn` ile birebir aynıdır. Son sahnede aynı durum tekrarlanır (herkes kaçar, Gwen genel müdürle yalnız kalır) ve cümle yankılanır: *She had not, once again, left the room fast enough.* İlk sayfanın merak sorusu: fabrika çatısındaki tabela "since 1976" diyor; *Nobody, at that point, had thought to check.*

**Adil son için yerleştirilen ipuçları:**
- Tabela "since 1976"; "Nobody, at that point, had thought to check." (p01); "the date that nobody had ever checked" (p05).
- Howard: "The firm and I are practically twins. Born in the same week!" (p03).
- Nell'in doğum günü tablosu: Bay Brindle partiden önceki hafta **kırk dokuz** yaşına girecek (p07). p03 ile birleşince şirket de kırk dokuz yaşında olmalı.
- Howard çay kupasını logonun üstüne koyup kahverengi halka bırakıyor (p09): lekenin nasıl oluştuğunun habercisi.
- Albert hiçbir belgeye yıl yazmazdı; plaket 1994'te, ilk broşürle birlikte pazarlama tarafından yapıldı; "Nobody ever asks the archive." (p12).
- Şapka kutusu: Albert öldüğünden beri hiç açılmamış (p11); günlük orada çıkar (p23–p24).
- Bay Penrose: Dorothy en ilk hafta, Howard doğduktan hemen sonra başladı; "Whether she gets it right is another matter." (p13).
- Kuruluş belgesi: gün ve ay açık (haziranın onu), yılın son iki rakamı çay halkasının altında (p14).
- Dorothy'nin kartı: "But fifty already? I thought it was next year." (p18); telefonda: on dokuz yaşında başladı, şimdi altmış sekiz (p19).
- İlk yıllık hesaplar: "Year ended thirty-first of May, 1978." (p21).
- 1994 broşürünün provasını Albert gözlüksüz imzaladı (p22).
- Günlük: Salı Howard doğdu, cuma kâğıtlar imzalandı; 10 Haziran 1976 perşembe, 1977 cuma (p24).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: 500 kredi yüklendi, "tüm yarım kalan işlerimizi yap … onay verdim". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 7 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p15.png`, `images/p19.png`, `images/p24.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 3,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Flat-colour editorial illustration, non-photorealistic, clean shapes, subtle paper grain, dry and slightly absurd office comedy, deadpan expressions. Palette: plum purple, mustard yellow, office grey and warm cream, with a single bright red umbrella as the only strong accent. Mood: dry, witty, gently absurd, never cruel. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; banners, slides, documents, plaques, calendars, clock faces and screens are drawn blank or with abstract lines only. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Gwen Holloway:** 38-year-old woman, neat dark-brown hair in a low bun, small rectangular glasses, calm watchful face, a mustard cardigan over a grey blouse, always holding a notebook and a pen.
- **Howard Brindle:** about 49, large and cheerful, silver hair, round pink face, a plum-coloured suit with a loosened tie, big expressive hands, often holding a mug of tea.
- **Clive Marsh:** head of marketing, thin and anxious, very expensive thick-framed glasses, slim grey suit, often holding printed sheets (blank) or a tablet with a blank screen.
- **Jasper Brindle:** 24, tall and relaxed, messy fair hair, hoodie under a blazer, white trainers, a wide easy grin.
- **Nell Okafor:** 19, intern, short natural black hair with a headband, bright eager face, a green jumper, an open notebook in her hand.
- **Mr Ambrose Penrose:** 81, very small and upright, tweed jacket, woollen hat, fingerless gloves, round glasses on the end of his nose.
- **Dorothy Fairweather:** 68, small and lively, short white curls, a purple coat, carrying large scissors in a velvet case.
- **Derek Pole:** about 64, mild and grey, a brown cardigan, expressionless face.
- **Brindle Umbrellas:** an old brick umbrella factory with a long roof and a large blank sign on top; a grey boardroom with a long table; Meeting Room Three with no windows; a damp basement archive full of cardboard boxes, a single desk lamp, a pipe dripping into a bucket; a big warehouse decorated with warm string lights.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | A long boardroom table seen from above: every chair pushed back and empty, abandoned coffee cups and papers (blank), and Gwen alone at one end, small, holding her notebook, looking up with a deadpan expression; Howard leaning towards her, beaming; a single red umbrella hanging on a coat stand by the open door. |
| p01.png | p01 (Bölüm 1, The Meeting) | The moment the room empties: colleagues hurrying out through the door in a blur, one coffee cup still swinging; Gwen at the table underlining something in her notebook; Howard at the front with open arms; Jasper half hidden behind a large office plant in the corner, eating a biscuit. |
| p06.png | p06 (Bölüm 2, Subcommittees) | Windowless Meeting Room Three: Clive presenting a slide showing only a simple umbrella shape tilted at an angle (no text); Jasper leaning back in his chair; Nell taking notes; Gwen staring at the wall clock (no numbers on the face); a stack of identical umbrella drawings on the table. |
| p10.png | p10 (Bölüm 3, The Basement) | The damp basement archive: Mr Penrose at a wooden desk under one lamp, in tweed, woollen hat and fingerless gloves, looking up over his glasses; a pipe dripping into a bucket; Gwen with a torch and Nell with a packet of tissues on the narrow stairs; rows of cardboard boxes stretching into the dark and turning a corner. |
| p15.png | p15 (Bölüm 4, Escalation) | The committee table again: Jasper standing and spreading his arms wide to show something enormous; Howard bursting in through the door, delighted; Clive with his hand raised; Gwen doing a calculation on the back of a blank sheet; through a window, an outline of the car park. No giant umbrella is shown yet. |
| p19.png | p19 (Bölüm 5, Three Days) | Gwen at her desk on the phone, a small card with a drawing of a seagull propped against her computer (the card has no writing); on the back of her hand, three tiny abstract marks; a desk calendar with blank squares; outside the window, grey rain. |
| p24.png | p24 (Bölüm 6, The Speech) | Early morning in the basement: Mr Penrose wraps a small black book in a white handkerchief and hands it to Gwen with both hands, like a precious object; the lamp makes a circle of warm light; the old cardboard boxes around them. The book is closed and has no visible writing. |

**Sürpriz kontrolü:** Sonun sürprizi şirketin 50 değil 49 yaşında olması, kanıtın Albert'in şapka kutusundaki günlükte çıkması ve gecenin "Fiftieth Anniversary Rehearsal" olarak yeniden adlandırılmasıdır. Hiçbir görselde rakam, yıl, tarih ya da yazı yoktur (tabela, plaket, takvim, saat kadranı ve belgeler boş çizilir). Çay lekeli belge ve 1994 broşürü hiçbir görselde gösterilmez. p24'teki günlük kapalı ve yazısızdır; görselin ne anlattığı (yıl) gösterilmez. Dev şemsiye ve kutlama gecesi hiçbir görselde yoktur; p15'te yalnız Jasper'ın kollarını açtığı fikir anı vardır. Kapakta Gwen'in başkanlığa "yakalandığı" an gösterilir; bu kanca cümlesidir, son değildir.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 7dccc59f-6b81-4122-955e-ad3d985081c7 | — | 2026-10-14T16:40:57+00:00 | 3:4, medium, 1k | 0.5 |
| p15.png | caa248af-ad39-436d-a8d0-5db512c2745f | 7dccc59f-6b81-4122-955e-ad3d985081c7 | 2026-10-14T16:45:36+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | 9faa5629-0dd1-4d15-b9cf-6fc15f3a302b | 7dccc59f-6b81-4122-955e-ad3d985081c7 | 2026-10-14T16:45:39+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | c31fd069-588a-48ff-992a-f0e52f0411b7 | 7dccc59f-6b81-4122-955e-ad3d985081c7 | 2026-10-14T16:45:39+00:00 | 3:4, medium, 1k | 0.5 |
| p10.png | 9d7cc2df-434d-4033-8e3b-76ba16a16606 | 7dccc59f-6b81-4122-955e-ad3d985081c7 | 2026-10-14T16:45:40+00:00 | 3:4, medium, 1k | 0.5 |
| p19.png | b6377072-d78c-4932-bd71-84048a1a43d2 | 7dccc59f-6b81-4122-955e-ad3d985081c7 | 2026-10-14T16:45:59+00:00 | 3:4, medium, 1k | 0.5 |
| p24.png | 5c92ae89-5df1-4758-af5e-d9bc6dd4d002 | 7dccc59f-6b81-4122-955e-ad3d985081c7 | 2026-10-14T16:46:04+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 3.5 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.05 (C1 başlangıç değeri; C1'de anlatım temposu varsayılanı `off`, hedef ~160 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
