# B2-K03 Please Don't Translate That: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B2-K03 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B2 konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B2-K03 *Please Don't Translate That* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 5 bölüm (Health to Your Hand, Börek Disaster, No Earpiece, Night Practice, Blessing), 22 sayfa, ~4.800 kelime (B2 hedefi 5.000 ± %20). Sıcak, esprili mizah; iki kültürle de alay etmeden. Kulaklık markasız ve adsız; Eskişehir genel hatlarıyla. Bruno'nun Portekizce deyimleri gerçek Brezilya deyimleri, kulaklıkta kelimesi kelimesine. B2: edilgen (present perfect edilgen dahil), dolaylı anlatım (cümle, soru, rica), kibarlık kalıpları (*Would you mind…? I was wondering if…*), 2. ve 3. tip koşul, *wish / if only*, *must have / can't have / might have*, present perfect continuous, virgüllü ilgi cümleleri, ettirgen *have*, future continuous / perfect, *although / despite / however / whereas*; standart İngiliz İngilizcesi anlatı dilbilgisi. Türk öğrenci notu: *Eline sağlık* → *This is delicious, thank you*; *Kolay gelsin*'in tek karşılığı yok. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, kişi ve işletme yok. Kapsama CEFR-J ≤ B2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Kanca:** Katalogdaki kanca (*The translation earpiece worked perfectly, until Selin's family started using idioms.*) kitabın ilk cümlesidir; `book.json → hookEn` ile birebir aynıdır.

**Teknik kurgu (sürprizin işlemesi için):** Kulaklık kutusunda iki parça var; dinlemeyi ve çevirmeyi Bruno'nun telefonundaki uygulama yapıp sözcükleri iki kulaklığa da gönderiyor (p02). Bu yüzden Bruno'nun kulaklığının şarjı bitince (c3) ve gece kulaklık şarjdayken (c4) Orhan Bey, telefon yanında olduğu sürece Bruno'nun Portekizcesini duymaya devam eder.

**Adil son için yerleştirilen ipuçları:**
- Selin ikinci kulaklığı "Let me give it to him" diyerek kutudan alıyor (p02); "Everything they say… That's exactly what worries me" (p01).
- Orhan Bey'in kır saçları kulaklarının üstünü örtüyor (p03); ilk Türkçe yanlış anlamada "as if something had bitten it" kulağına dokunup içeri giriyor (p03).
- Her Portekizce deyimden sonra aynı desen: kulağa dokunma, yüzün kıpırtısız kalması, ağzın tuhaf kıpırdaması, odadan çıkış; mutfak (bucket, p05), bahçe ve inip kalkan omuzlar (duck, p07), banyo (sausage, p10); dönüşte kızarmış gözler (p05).
- Emre babasına "very strangely" bakıyor ve "I don't think so" diyor (p07).
- Portekizce bilmeyen Selin ördeği biliyor; "Emre told me… He looked it up" diye geçiştiriyor (p10).
- Uygulamada "two earpieces connected"; Selin "In my bag, probably" diyor (p10).
- Akrabalar gecesi Orhan Bey hiç odadan çıkmıyor (Bruno'nun kulaklığı kapalı, ama Bruno deyimi yalnız kendi kendine söylüyor), ama kablo sahnesinde dudak kenarları kıpırdamak üzere (p12–p13).
- Mutfaktan Nermin Hanım'ın ve kalın sesin bastırılmış kahkahası, Bruno'nun adıyla (p14).
- Karanlık köşede oturan Orhan Bey, "Orhan Bey couldn't have understood those. At least, that is what Bruno thought." (p18).
- Kediye gönderme: Orhan Bey bir kez, "something about a cat" yüzünden gülmüş (p02) → "Your mistakes are the best thing in this house since the cat." (p21).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: "15,06 krediye kadar kullan". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 6 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p11.png`, `images/p15.png`, `images/p19.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 3 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Lively comic-book comedy illustration, clean ink lines with flat bright colours and soft halftone shading, non-photorealistic, warm and affectionate family chaos, expressive faces. Palette: turquoise, candy pink, mustard yellow, peach, warm cream, a little deep plum for shadows. Setting details: old colourful wooden houses by a slow green river in a Turkish city. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; phone screens are blank or show only abstract shapes; speech is never shown as speech bubbles with words, the earpiece's translation is shown only as small wordless wave symbols near the ear. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Bruno:** 31-year-old Brazilian man, warm brown skin, short dark curly hair, a neat short beard, big expressive eyebrows, friendly nervous smile; a light blue shirt with rolled sleeves; a small white earpiece in his right ear.
- **Selin:** 29-year-old Turkish woman, shoulder-length wavy dark-brown hair, clever amused eyes, a mustard cardigan over a simple top.
- **Orhan Bey:** 64-year-old Turkish man, tall with a straight back, serious face with deep lines, thick grey hair a little long at the sides covering the tops of his ears (the ears are never visible and no earpiece is ever shown on him), a grey moustache, a dark green knitted vest over a white shirt.
- **Nermin Hanım:** Selin's mother, about 60, small and quick, round cheerful face, short reddish-brown hair, a flowered apron.
- **Emre:** Selin's brother, 19, thin, messy black hair, hoodie, socks without shoes at home.
- **The house:** a narrow peach-coloured old house with a wooden door; a busy kitchen with two stacked Turkish tea pots on the stove and thin tulip-shaped tea glasses; a dining table covered with home-made dishes; a small garden.
- **The train room:** an attic room with a model railway on three tables: paper hills, a river of blue glass, tiny stations, a stone-arched bridge, a small red train; a framed photograph of a young engineer on a bridge (no writing); an old armchair in a dark corner; a small green lamp.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Bruno stands at the doorway of the peach-coloured house holding a suitcase, smiling too widely, a small white earpiece in his ear with little wordless wave symbols around it; behind him Selin covers her eyes with one hand; in the doorway Orhan Bey looks down at him, serious, arms folded, grey hair covering his ears. |
| p01.png | p01 (Bölüm 1, Health to Your Hand) | The first family dinner: a table covered with stuffed peppers, beans, salad and bread; Bruno stands and lifts his glass of water high like a toast, beaming; everyone else has stopped eating; Emre's fork is frozen in the air; Nermin Hanım looks at her husband's hands; Orhan Bey sits very still. |
| p06.png | p06 (Bölüm 2, Börek Disaster) | Early morning kitchen: Bruno, in great concentration, watches two stacked Turkish tea pots on the stove; at the table Orhan Bey sits with an unopened newspaper, watching the tea instead; soft morning light. (The burned börek is not shown.) |
| p11.png | p11 (Bölüm 3, No Earpiece) | A crowded living room full of cheerful relatives of all ages; Bruno in the middle, smiling until his face hurts, showing a napkin with a simple drawing of a plane and a heart to a big uncle; Orhan Bey sits in an armchair in the corner, watching with no expression. |
| p15.png | p15 (Bölüm 4, Night Practice) | Night in the attic train room lit only by a small green lamp: Bruno sits on a low stool among the model railway tables, phone in hand, practising words to a little red train; in the darkest corner an old armchair is only a deep shadow (no visible person). |
| p19.png | p19 (Bölüm 5, Blessing) | The train room in warm yellow lamplight: Bruno and Orhan Bey sit facing each other across the model railway, both leaning forward and talking; a small red train between them on the stone bridge; Orhan Bey's face is softer, almost smiling. Neither man's ears are visible. |

**Sürpriz kontrolü:** Sonun sürprizi, Selin'in ikinci kulaklığı ilk akşam babasına vermiş olması ve Orhan Bey'in bütün hafta Bruno'nun Portekizce deyimlerinin kelimesi kelimesine çevirisini dinleyip gülmemek için sofradan kalkmasıdır. **Hiçbir görselde Orhan Bey kulaklık takarken ya da elinde kulaklıkla gösterilmez;** kulakları her görselde saçla örtülüdür. p15'te köşedeki koltuk boş bir gölgedir, Orhan Bey görünmez. p19'da kulaklık masada ya da elde gösterilmez; yalnız iki adamın konuştuğu görülür. Telefon ekranındaki "two earpieces connected" satırı ve gülerken mutfakta saklanan Orhan Bey hiçbir görselde yer almaz (yalnız metinde, resimsiz sayfalar p10, p14, p20).


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | fe970fcf-0f06-45dd-818b-fa4836554fc6 | — | 2026-10-14T16:16:17+00:00 | 3:4, medium, 1k | 0.5 |
| p11.png | 60bafda8-04ca-4fcc-92ee-90d13ecf94aa | fe970fcf-0f06-45dd-818b-fa4836554fc6 | 2026-10-14T16:19:05+00:00 | 3:4, medium, 1k | 0.5 |
| p15.png | c5d7e8c6-d402-405c-96e2-005dc8911b03 | fe970fcf-0f06-45dd-818b-fa4836554fc6 | 2026-10-14T16:19:07+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | 2e01cd3b-5f8b-48d8-983b-8e353fce80b8 | fe970fcf-0f06-45dd-818b-fa4836554fc6 | 2026-10-14T16:19:07+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 31d97522-f7bd-467e-8b3a-3b7cc30a81c6 | fe970fcf-0f06-45dd-818b-fa4836554fc6 | 2026-10-14T16:19:08+00:00 | 3:4, medium, 1k | 0.5 |
| p19.png | aee36b5a-3a8d-480e-8f98-38528d103edc | fe970fcf-0f06-45dd-818b-fa4836554fc6 | 2026-10-14T16:19:31+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 3 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B2 başlangıç değeri; anlatım temposu B2 varsayılanı `off`, hedef 145–155 k/dk, §6.5; ölçümden sonra gerekirse `narration.pacing` ayarlanır). Kulaklığın çevirileri aynı anlatıcıyla, hafif mekanik bir tonla okunabilir (katalog notu; ayrı ses yok). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
