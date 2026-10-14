# B2-K02 The Singing Hill: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B2-K02 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B2 konuları (G-B2-01…G-B2-12) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B2-K02 *The Singing Hill* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 5 bölüm (First Night, The Survey, Permission, Holes in a Row, The Second Song), 23 sayfa, ~5.000 kelime (B2 hedefi 5.000 ± %20). Maceracı, ölçülü gerilim; Kapadokya'da adsız bir köy, tepe ve yeraltı şehri (uydurma). Tünele izinle, mühendis kontrolüyle, baret ve telsizle inilir; kimse yaralanmaz; gizlice girme fikri reddedilir ve doğru yol (yazılı öneri) ödüllendirilir. B2 yapıları doğal olarak: edilgen (present perfect edilgen dahil), dolaylı anlatım (cümle, soru, emir), 2. ve 3. tip koşul, *wish / if only*, *must have / can't have / might have*, present perfect continuous, virgüllü ilgi cümleleri, ettirgen *have something done*, future continuous ve future perfect, *although / despite / however / whereas*. Standart İngiliz İngilizcesi yazım ve anlatı dilbilgisi (Mr, Dr noktasız). İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka, kişi ve gerçek bir kazının tarihi yok. Kapsama CEFR-J ≤ B2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Kanca:** Katalogdaki kanca (*Every night when the wind turned north, the hill began to sing.*) kitabın ilk cümlesidir; `book.json → hookEn` ile birebir aynıdır. Son cümle aynı imgeye döner (*the wind had already turned north*).

**Bölüm sonu kancaları (katalogla aynı):** c1 rüzgâr durduğu an ses de kesilir · c2 "Some doors are closed for a reason." · c3 geçit taş yığınıyla kapalı, ses her yanda (ve gözden kaçmış alçak kapı) · c4 rüzgâr durur, sonra hiç duyulmamış yeni bir nota · c5 ikinci boru açılır, tepe iki sesle söyler.

**Adil son için yerleştirilen ipuçları:**
- Kemal Bey'in büyükannesi: tepe şarkı söyleyince hayvanları içeri al; tepe kardan önce söyler (p04). Aynı yerde: "büyükannesinin zamanında tepe bir değil, iki sesle söylerdi" (p04) → ikinci boru.
- Kemal Bey Haziran'da "kalın giysi getirdin mi?" diye sorar (p02); kuzey rüzgârı geceleri soğuk getirir (p03).
- Zirveye yakın koyu kaya kuşağı, "kemer" (p02) → hava bacasının ağzı (p08, p17).
- Rüzgâr durunca ses sönmeden kesilir (p05, p06) → boru/flüt gibi çalışan bir yapı; Jonah'ın altı delikli tahta düdüğü (p06) → sıra sıra delikler (p16–p17).
- Rüzgâr doğuya kayınca nota yükselip "kırılıyor ve kayboluyor, sanki tepe artık sahip olmadığı bir notayı söylemeye çalışıyor" (p07) → kapalı ikinci boru.
- 1964 raporu: "Kuzey duvarında olağandışı delikler. İncelenmedi." (p08).
- Taş yığınında iki tür taş: keskin kenarlı soluk yeni taşlar ve çok daha eski, tozlu koyu taşlar (p15) → altta bilerek örülmüş eski duvar (p20).

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 6 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p11.png`, `images/p16.png`, `images/p20.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (dalga 1'de 1k medium ile doğrulandı); tahmini toplam ≈ 3 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Stylised graphic novel illustration, non-photorealistic, bold clean ink lines with flat colour shapes and soft grain, wide epic compositions. Palette: soft volcanic rock tones of apricot, pink-beige and cream by day; deep night indigo and warm lantern yellow at night; strong warm-cold contrast inside tunnels. Mood: adventurous, calm tension, wonder. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; maps, notebooks, graphs, reports and signs are blank or drawn only as abstract lines; hot-air balloons are plain colours or simple stripes with no logos. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Jonah Price:** 20-year-old Welsh geology student, tall and lanky, pale skin with freckles, messy light-brown hair, green eyes, a faded blue T-shirt and dusty cargo trousers, a canvas bag; often holds a small notebook or a simple wooden whistle with six holes.
- **Defne:** 21-year-old Turkish archaeology student, medium height, warm olive skin, long dark wavy hair tied back, a wide dusty sun hat, a khaki work shirt with rolled sleeves, a notebook under her arm, a calm amused expression.
- **Dr Aydın:** team leader in her fifties, small and upright, short grey hair, sharp dark eyes, simple practical work clothes, a light scarf; calm and serious.
- **Mr Kemal:** very thin villager over eighty, white moustache, flat cap, a dark waistcoat over a white shirt, a small glass of tea in his hand.
- **Mr Hakan:** engineer, about 50, broad shoulders, a white safety helmet, covered in pale dust.
- **The valley:** soft volcanic rock landscape with tall pointed rock towers and cliffs full of small dark carved windows; a small village of old stone houses with flat roofs; a pale smooth hill with a band of darker rock near its top.
- **The underground city:** carved rock passages and small rooms, a huge round rolling stone beside a doorway, steep worn stairs, a metal gate on the fourth level; on the lowest level a small room whose wall is covered in rows of carved round holes, big at the bottom and coin-sized at the top.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Night: the pale hill with its dark band of rock under a deep indigo sky full of stars; small silhouettes of Jonah and Defne on a flat stone roof in the foreground, wrapped in a blanket, looking towards the hill; faint curved lines of wind flow over the hilltop like soft sound waves. No holes or tunnels are shown. |
| p01.png | p01 (Bölüm 1, First Night) | Late afternoon arrival: Jonah with a backpack standing by an old stone fountain at the edge of the village, a sleeping dog nearby; behind him a wide valley of apricot and pink rock towers and cliffs with small carved windows; Defne in her sun hat walking towards him, smiling. |
| p06.png | p06 (Bölüm 2, The Survey) | Morning under a tree at the edge of a dig site: Jonah sits on a rock playing a small wooden whistle, his open notebook with abstract graph lines on his knee; Defne beside him with a brush and pieces of old pottery, listening with interest; the hill in the background. |
| p11.png | p11 (Bölüm 3, Permission) | Evening on the flat roof under early stars: Defne sits against a low wall writing in Jonah's notebook by lantern light while Jonah, still frowning, leans on the wall looking at the distant hill; warm lantern yellow against night indigo. |
| p16.png | p16 (Bölüm 4, Holes in a Row) | Deep underground: Jonah, Defne and Dr Aydın in helmets with lamps crouch inside a low carved doorway, their lamp beams crossing in the dark towards an unseen wall; dust floating in the light; their faces full of surprise. The holes themselves are not shown. |
| p20.png | p20 (Bölüm 5, The Second Song) | Careful work in a carved passage lit by work lamps: Mr Hakan and two other engineers in white helmets study a large pile of stones while Jonah carries a basket of stones towards the stairs; Dr Aydın stands with a camera on a tripod recording; numbered small tags on some stones are plain shapes without numbers. |

**Sürpriz kontrolü:** Sonun sürprizi, tepenin altındaki sıra sıra oyukların kuzey rüzgârında öten, insan yapımı bir uyarı "çalgısı" olması ve yüzyıllardır duvarla kapalı kalmış ikinci bir borunun açılmasıyla tepenin iki sesle söylemesidir. Hiçbir görselde delikli duvar ya da ikinci oda gösterilmez (p16'da yalnızca şaşkın yüzler ve ışık hüzmeleri; duvar görünmez). p20'deki taş yığını açılmamış hâliyle çizilir; arkasındaki oda ve ikinci baca görünmez. Kapakta tepenin içi gösterilmez. Kemal Bey'in "iki ses" sözü ve kar ipucu yalnız metindedir.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B2 başlangıç değeri). B2'de anlatım temposu varsayılanı `off` (§6.5); hedef hız ~145–155 k/dk, gerçek hız ses üretildikten sonra book-lint'te ölçülür, gerekirse `narration.pacing` ayarlanır. Türkçe adlar (Defne, Aydın, Kemal, Hakan, Murat) ve metindeki "Hava bacası" doğal Türkçe telaffuzla okunmalıdır; ilk bölümde dinlenip kontrol edilir. Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
