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

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T18:41:09Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1178 | 77.52 | a77e9c688d024c1e9ce61a536389dfdb | 2343cf65aecc6b88 |
| 2026-11-03T18:41:16Z | p01 | duyu-1 | - | - | - | 77.52 | - | 2343cf65aecc6b88 |
| 2026-11-03T18:41:27Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 1203 | 77.58 | 3b5dfb3ea93d4009a1965a330f46c463 | cfa661bdcc3b937d |
| 2026-11-03T18:41:32Z | p02 | duyu-1 | - | - | - | 77.58 | - | cfa661bdcc3b937d |
| 2026-11-03T18:41:43Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 1120 | 71.91 | 0cf03221820e4a8f8ada9aa8f9cef299 | 89c00c286b121f97 |
| 2026-11-03T18:41:53Z | p03 | duyu-1 | - | - | - | 94.05 | - | 89c00c286b121f97 |
| 2026-11-03T18:42:03Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1090 | 67.43 | ef02923f03424b67b435670479d090c8 | 4e63db8dc8827d44 |
| 2026-11-03T18:42:08Z | p04 | duyu-1 | - | - | - | 67.43 | - | 4e63db8dc8827d44 |
| 2026-11-03T18:42:17Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1046 | 65.54 | 645518670d064a5b8e9f2ab35ac53842 | 37a02fd7a9d81ddb |
| 2026-11-03T18:42:23Z | p05 | duyu-1 | - | - | - | 65.54 | - | 37a02fd7a9d81ddb |
| 2026-11-03T18:42:32Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1181 | 73.44 | b5cdf4948acc4872ab6579b2a55007da | c2569e8600d2adfc |
| 2026-11-03T18:42:40Z | p06 | duyu-1 | - | - | - | 73.44 | - | c2569e8600d2adfc |
| 2026-11-03T18:42:51Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 1209 | 80.24 | d73f606c2c664debb031d6b80b6de988 | d24ba2e66d43888c |
| 2026-11-03T18:42:57Z | p07 | duyu-1 | - | - | - | 80.24 | - | d24ba2e66d43888c |
| 2026-11-03T18:43:08Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 1165 | 73.63 | 23c3eb60eeed4b3da672d746511027ea | a9c43fd5641accbb |
| 2026-11-03T18:43:16Z | p08 | duyu-1 | - | - | - | 73.63 | - | a9c43fd5641accbb |
| 2026-11-03T18:43:27Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1194 | 78.85 | ab20d1bc175e4fb48e17d19c74f13de5 | c831f3996c371159 |
| 2026-11-03T18:43:32Z | p09 | duyu-1 | - | - | - | 78.85 | - | c831f3996c371159 |
| 2026-11-03T18:43:44Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1214 | 78.91 | aff32fbabf124dc287d1766ae24a03b7 | c5b876066867ed2f |
| 2026-11-03T18:43:50Z | p10 | duyu-1 | - | - | - | 78.91 | - | c5b876066867ed2f |
| 2026-11-03T18:44:01Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 1216 | 80.22 | 4c12a2789110431c892785d6cc20028a | 8842158ad079877a |
| 2026-11-03T18:44:09Z | p11 | duyu-1 | - | - | - | 80.22 | - | 8842158ad079877a |
| 2026-11-03T18:44:21Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1169 | 71.14 | b6cc46093bb24404b69a56c9b3065869 | 8242a0ee990b5a14 |
| 2026-11-03T18:44:27Z | p12 | duyu-1 | - | - | - | 71.14 | - | 8242a0ee990b5a14 |
| 2026-11-03T18:44:37Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 1214 | 77.56 | 4f6b6d28233d4563977dcdb97c515cbc | 1fdf4e90009e1f2f |
| 2026-11-03T18:44:43Z | p13 | duyu-1 | - | - | - | 77.56 | - | 1fdf4e90009e1f2f |
| 2026-11-03T18:44:53Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1082 | 70.54 | 878c40eae93d49f8a2f2f148bbbe88dd | e815fba21d64e163 |
| 2026-11-03T18:44:59Z | p14 | duyu-1 | - | - | - | 70.54 | - | e815fba21d64e163 |
| 2026-11-03T18:45:09Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1157 | 72.96 | 530777d0c43148d5ac46be497c12951b | 72ffb187d6c54ede |
| 2026-11-03T18:45:16Z | p15 | duyu-1 | - | - | - | 72.96 | - | 72ffb187d6c54ede |
| 2026-11-03T18:45:27Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1081 | 70.49 | aecb7b07ff754e138db87335747bb509 | 2b083885dd7e91fa |
| 2026-11-03T18:45:32Z | p16 | duyu-1 | - | - | - | 70.49 | - | 2b083885dd7e91fa |
| 2026-11-03T18:45:44Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1325 | 85.42 | 0886a3e6b9464cc79f5b8e4b7d041b2e | 30968cbe05b9191f |
| 2026-11-03T18:45:55Z | p17 | duyu-1 | - | - | - | 105.52 | - | 30968cbe05b9191f |
| 2026-11-03T18:46:06Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1202 | 78.28 | 27d65addacb1463395511fd1e8bd2c35 | c044814cbebd7ee5 |
| 2026-11-03T18:46:12Z | p18 | duyu-1 | - | - | - | 78.28 | - | c044814cbebd7ee5 |
| 2026-11-03T18:46:23Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1158 | 77.54 | ffd202ec3aea469cbf8e72c54552a27c | 689964979725045f |
| 2026-11-03T18:46:29Z | p19 | duyu-1 | - | - | - | 77.54 | - | 689964979725045f |
| 2026-11-03T18:46:40Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1031 | 68.33 | ee155716c95944358f3969dc3d4bdbb3 | 9b238ac245e20c0b |
| 2026-11-03T18:46:46Z | p20 | duyu-1 | - | - | - | 68.33 | - | 9b238ac245e20c0b |
| 2026-11-03T18:46:55Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1160 | 70.36 | c4cf94e2c2204b92a8bf48c8f5a57b95 | 145cc4b028678898 |
| 2026-11-03T18:47:01Z | p21 | duyu-1 | - | - | - | 70.36 | - | 145cc4b028678898 |
| 2026-11-03T18:47:12Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1157 | 74.21 | c017b87c39594a42a3172c73c43008be | 38b479bab680af05 |
| 2026-11-03T18:47:18Z | p22 | duyu-1 | - | - | - | 74.21 | - | 38b479bab680af05 |
