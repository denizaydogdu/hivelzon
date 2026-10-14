# A2-K04 The Girl Who Never Saw Rain: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1 (A1 + A2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A2-K04 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "A2-K04 *The Girl Who Never Saw Rain* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 4 bölüm, 16 sayfa, ~1.500 kelime (A2 hedefi 1.500 ± %20). A2: her cümle ≤ 12 kelime; past simple anlatı, karşılaştırma (*heavier, bigger than, the same as*), *going to*, hava ve duyu sözcükleri (*smell, feel, wet, dry*). İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J ≤ A2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Adil son için yerleştirilen ipuçları:**
- Yağmurun kokusu var: Leo'nun mektubu, "the earth smells sweet after rain" (p02), Nia'nın antrenmanda bunu hatırlaması (p03).
- Sulama boruları ve başlıkları; biri tam Nia'nın penceresinin altından geçiyor; geceleri çalışıyor; suyu ılık, "like bath water"; Nia "It's like rain!" diyor (p07).
- Leo, Nia'nın üzüldüğünü görüp tek söz etmeden çıkıyor; arka kapının sesi (p11).
- Gece "yağmuru": beklenenden ılık, Leo ıslak ve ayakkabıları çamurlu, Nia'ya bakmıyor (p13); koku yok, Lunaria'daki su gibi; gökyüzünde yıldızlar ve tek küçük bulut; su yandan, pencerenin yakınından geliyor (p14).

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14): kalan 28 kitapta resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 5 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png` (git dışı; adlar `book.json` ile aynı). Diğer sayfalar resimsiz, palet renkli (`image: null`).
> Model ve maliyet: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (pilotta 1k medium), toplam ≈ 2,5 kr. Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır. Sayfa görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Retro science-fiction book illustration in a 1960s–70s paperback style, non-photorealistic, gouache and airbrush textures, soft grain, simple rounded shapes. Palette: moon grey and deep black for the Moon, mustard yellow and dry ochre earth for the farm, one clear rain blue accent, warm cream highlights. Mood: wonder and longing, calm, never scary. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; screens, maps, cards and notebooks are drawn blank or with abstract shapes only. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Nia:** 13-year-old girl born on the Moon, slim and a little pale, dark brown skin, short black hair in two small puffs, big curious eyes, silver-grey jumpsuit with a mustard-yellow stripe; on Earth a plain light-blue T-shirt and grey trousers.
- **Leo:** 13-year-old boy, tanned, messy sandy-brown hair, freckles, wide friendly grin, faded green T-shirt, rolled-up jeans, old brown boots.
- **Grandma Edda:** woman about 70, strong and small, white hair in a long braid, deeply tanned kind face, ochre work shirt with rolled sleeves, straw hat.
- **Mum and Dad:** scientists in their 40s; Mum tall with short grey-streaked hair and round glasses; Dad bearded, gentle, quiet smile; both in simple grey travel clothes.
- **Lunaria:** a small Moon town under a huge round glass roof; grey dust, round white buildings, black starry sky; the blue-and-white Earth hangs far away in the sky.
- **The farm:** a small wooden farmhouse with a tin roof in a wide, hot, dry valley; yellow and brown fields with long cracks in the ground; low hills.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Nia in her silver-grey jumpsuit stands at a round window inside the glass-roofed Moon town, one hand on the glass, looking up at the small blue-and-white Earth in the black sky; her face full of longing. |
| p01.png | p01 (Bölüm 1, Moon Girl) | Lunaria from the inside: grey dust, round white buildings under the big glass roof; Nia sits by her bedroom window with a letter (blank paper) in her lap, looking at the distant Earth. |
| p05.png | p05 (Bölüm 2, Too Much Sky) | Nia at the open door of a small, rounded spaceship on a hot, dry landing field; the endless bright blue sky above her; she holds Dad's hand tightly and looks down at her feet, legs heavy; Mum carries a bag behind them. |
| p09.png | p09 (Bölüm 3, Friday) | Nia and Leo stand in a dry, cracked field with their faces turned up; huge dark grey clouds roll in over the hills; Grandma Edda sets out empty metal buckets in the garden; wind moves the trees. |
| p13.png | p13 (Bölüm 4, The Smell of Rain) | Night in the farmhouse garden: Nia in her pyjamas laughs and spins with her arms open, her hair and face wet and shining in the light from the back door; the scene is lit warmly from the house; no source of water is shown. |

**Sürpriz kontrolü:** Sonun sürprizi, ilk "yağmurun" Leo'nun açtığı sulama boruları olmasıdır. Hiçbir görselde çalışan sulama başlığı, Leo'nun çarkı çevirmesi, boru ya da yıldızlı açık gökyüzü altında yağan su gösterilmez. Kapak yalnız Nia'nın özlemini (Ay ve uzaktaki Dünya) gösterir; sonu, yağmuru ya da Leo'yu göstermez. p13 yalnızca Nia'nın sevincini gösterir; suyun nereden geldiği görünmez, Leo görünmez, gökyüzü kadraj dışındadır. Borular yalnızca metinde (p07, resimsiz sayfa) geçer.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.95 (A2 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
