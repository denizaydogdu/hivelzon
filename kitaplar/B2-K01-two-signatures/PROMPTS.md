# B2-K01 Two Signatures: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B2-K01 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B2 konuları (G-B2-01…G-B2-12) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B2-K01 *Two Signatures* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 6 bölüm (Varnish, The Archive, Ultraviolet, Letters, Evidence, The Same Hand), 24 sayfa, ~5.000 kelime (B2 hedefi 5.000 ± %20). Sakin, zeki, hafif ironik anlatım. B2 dilbilgisi doğal geçişlerle: edilgen (present perfect edilgen dahil), dolaylı anlatım (cümle, soru, emir), 2. ve 3. tip koşul, *wish / if only*, *must have / can't have / might have*, present perfect continuous, virgüllü ilgi cümlesi, *have something done*, future continuous / perfect, *although / despite / however*. Standart İngiliz İngilizcesi (Mr / Ms noktasız, colour, realise). İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; şehir (Marell) ve kişiler uydurma; gerçek marka, kişi ve eser yok. Kapsama CEFR-J ≤ B2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Kanca kararı:** Katalogdaki kanca (*Under the varnish of an ordinary harbour painting, Lucía found a second name.*) kitabın ilk cümlesidir; `book.json → hookEn` ile birebir aynıdır. Bölüm sonu kancaları katalogdaki gibi: "Ai…" (c1), "Someone else asked about Serra last week." (c2), Bayan Vidal'ın "Only Andreu Serra" şartı (c3), "They will only buy a man's painting." (c4), koleksiyoncunun bir gün erken gelmesi (c5).

**Adil son için yerleştirilen ipuçları:**
- İki imzanın büyük A harfi aynı, tepesinde kurdele gibi bir halka (p04); son sahnede yeniden (p19, p20 "unmistakably the same").
- İkinci ismin çatlakları çok daha az ve ince: daha sonra yazılmış (p04); Tomás'ın analizi: titanyum beyazı, 1920'den önce olamaz ama onlarca yıllık (p18).
- Arşivde Andreu Serra'nın doğum, evlilik, ölüm kaydı yok; Halat Sokağı 14'te yalnızca resim öğretmeni Aina Serra yaşıyor (p06).
- UV ışığında liman duvarında fırçalı bir kadın (p10); mektupta "I painted myself into it… as a joke" (p14).
- Mektuplarda Andreu "hiç sergiye gelmeyen utangaç genç adam", "hayatında bir sergide hiç görülmedi" (p15).
- Bayan Vidal'a karşı kırmızı ringa: arşivdeki adsız kadın (p09), kırmızı tekneyi önceden bilmesi (p12), yalnız "Andreu Serra" etiketi istemesi (p12). Lehine adil ipucu: tablonun değerinin üç katını ödemesi (p19); gri-yeşil gözleri ve tekneyi "biliyor" olması fotoğrafla açıklanır (p22).
- Tepedeki ev: tablo oradan gelir (p01); 1931 fotoğrafı da oradadır, ev büyükanne ölünce eşyalarıyla satılmıştır (p22); tarih 1931 köşede (p20) ve fotoğrafta (p22).
- Vernik: oğlu ölümünden sonra tabloları temizletip vernikletti (p23) — ikinci ismin neden vernik altında kaldığı.

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: "15,06 krediye kadar kullan". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. p13 (4. bölüm başı) kredi yüklenince H-084 ile üretildi (2026-10-14). Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 7 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png`, `images/p21.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel; tahmini toplam ≈ 3,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Stylised illustration with a rich oil-paint texture, a picture within a picture, non-photorealistic, visible brushstrokes, thoughtful and quiet mood. Palette: saffron, mustard yellow, Mediterranean blue, warm workshop shadows, a small accent of boat red. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; signatures are drawn only as small abstract brush marks, documents, labels, catalogues and letters are blank or abstract lines, screens are blank. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Lucía Ferrer:** 26-year-old woman, intern restorer, olive skin, dark wavy hair tied up with a pencil through it, focused dark eyes, a dark blue work apron over a mustard jumper, cotton gloves; often holds a thin stick with cotton on the end.
- **Mr Castell:** owner of the workshop, short round man about 60, bald with grey sides, round glasses, always a small red bow tie, waistcoat and rolled-up sleeves.
- **Ms Vidal:** collector, tall elegant woman about 50, short grey hair, pale grey-green eyes, a long grey coat, calm and watchful.
- **Ms Roig:** archivist, thin older woman with silver hair in a bun, cardigan, reading glasses on a chain.
- **Mr Pons:** second-hand bookseller, large cheerful man with a white beard.
- **The workshop:** a narrow room above a harbour street, tall window, wooden easel, a big lamp with a round magnifying glass, bottles and brushes, warm shadows.
- **The painting:** an 1890s view of a small Mediterranean harbour at early morning: fishing boats, one small red boat on the left, a stone harbour wall, a row of yellow, pink and white houses, a soft blue sky.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | The old harbour painting on a wooden easel, half cleaned: the left half dark yellow-brown, the right half bright blue sky and sea; Lucía's gloved hand holds a cotton stick near the bottom corner, where two tiny abstract brush marks sit one above the other. |
| p01.png | p01 (Bölüm 1, Varnish) | Lucía in the workshop at dusk bending over the painting under the big magnifying lamp, cleaning a small square of sky; Mr Castell in his bow tie in the doorway, putting on his coat to leave. |
| p05.png | p05 (Bölüm 2, The Archive) | A cold, quiet archive in an old customs building: tall shelves of boxes, a long table, Ms Roig placing a heavy old book in front of Lucía, who reads with a notebook open; pale morning light from a high window. |
| p09.png | p09 (Bölüm 3, Ultraviolet) | Night in the dark workshop, blinds closed: Lucía holds a purple ultraviolet lamp up to the painting; the painting glows violet and green, and on the harbour wall a faint ghostly shape of a figure can be seen. |
| p13.png | p13 (Bölüm 4, Letters) | A narrow second-hand bookshop packed with books up to the ceiling; Mr Pons, laughing, waves towards stacked cardboard boxes at the back; Lucía squeezes between the shelves. |
| p17.png | p17 (Bölüm 5, Evidence) | Mr Castell's desk covered with blank photographs, copies and a bundle of old letters tied with a faded blue ribbon; Mr Castell, glasses in hand, looks up at Lucía standing by the window. |
| p21.png | p21 (Bölüm 6, The Same Hand) | Evening in the workshop: the cleaned painting on the easel under the lamp; Ms Vidal in her grey coat has just come through the door and stops, one hand raised to her mouth; Lucía and Mr Castell turn towards her. |

**Sürpriz kontrolü:** Sonun sürprizi, Andreu ile Aina Serra'nın aynı kişi olması, ikinci ismi Aina'nın 1931'de kendisinin yazması ve Bayan Vidal'ın onun torununun torunu olarak kaydı düzeltmek istemesidir. Hiçbir görselde yaşlı Aina ya da 1931 fotoğrafı gösterilmez; imzalar yalnız soyut fırça izi olarak çizilir (okunur ad ve tarih yok); p09'daki figür yalnızca belirsiz bir karaltıdır, yüzü görünmez; Bayan Vidal yalnız p21'de, şaşkın ve duygulu ama ne düşündüğü belli olmadan görünür; mektupların içeriği hiçbir görselde okunmaz.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | — | 2026-10-14T16:15:38+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | c51807f6-7f38-4b59-8dc4-f7821c08763c | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:20+00:00 | 3:4, medium, 1k | 0.5 |
| p17.png | 9450aa4c-4ad0-4a4b-a6ca-f2d1bd2c9bcf | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:23+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | a5db8076-25e3-4d90-93e4-f450860d6a5d | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:23+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | b956ac37-f2e6-4adb-a5bc-edd5d2e6ce7f | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:25+00:00 | 3:4, medium, 1k | 0.5 |
| p21.png | c4c8d5ba-dd8c-4766-b5bd-bed422d29a44 | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:17:49+00:00 | 3:4, medium, 1k | 0.5 |

| p13.png | dbf698c3-99e1-4bd3-9b08-f137b3ad1b0a | 1d011fd5-c1bd-4da8-bfa1-11164f1521e8 | 2026-10-14T16:37:59+00:00 | 3:4, medium, 1k | 0.5 |
**Toplam:** 3.5 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B2 başlangıç değeri). Anlatım temposu B2 varsayılanı `off` (§6.5); hedef 145–155 k/dk, gerçek hız book-lint'te ölçülür, gerekirse `narration.pacing` ayarlanır. Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
