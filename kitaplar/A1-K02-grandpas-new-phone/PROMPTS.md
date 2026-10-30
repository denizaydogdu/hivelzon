# A1-K02 Grandpa's New Phone: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1 (A1 + A2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A1-K02 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json` |

**İstem (özet):** "A1-K02 *Grandpa's New Phone* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 3 bölüm, 11 sayfa, ~700 kelime (±%20). A1: her cümle ≤ 8 kelime, present simple, yan cümle yok; emir kipi (*Touch here. Smile.*), *can / can't*, haftanın günleri. Türk öğrenciye not: *answer the phone* (~~open the phone~~). Mizah: komik zamanlama, Dede'nin 'Oh no!' anları. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J A1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Uyarlama notları:**
- Katalogdaki "fırın" İngilizcede *bread shop* oldu (*bakery* A1 dışı); Türkçede yine "fırın".
- "Press here" yerine "Touch here" (*press* A1 dışı; dokunmatik ekranda da daha doğal). Telefonun uyarı sesi (*ding*) yerine "a happy noise".
- Mert'in perdesi pencereden görünür (balkon yerine; *balcony* A1 dışı).

**Adil son için yerleştirilen ipuçları:** fırındaki adamın "Your big cake is ready!" demesi (p02); Mert'in evindeki kalabalık ve kahkahalar, penceresindeki mavi perde (p03); her yanlış fotoğraftan sonra telefonun "mutlu sesi" ve "Where is the photo now?" sorusu (p03–p04); Mert'in parkta olmadığı hâlde müziği bilmesi ve kızarması (p05); görüntülü aramada herkesin arkasında aynı mavi perde ve ailenin şaşkınlığı (p07); Dede'nin akşam ipuçlarını sayıp yanlış sonuca varması (p08).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: dalga 1 metinleri ve 34 görsel (~17 kr) onaylandı ("İlk dalganın 8 kitap metni … onay", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, medium, 1k = 0,5 kr. Bölüm başları kapak işi referans verilerek üretildi. Eski plan notu: Kullanıcı kararı (2026-10-14): kalan 28 kitapta **kapak + bölüm başı**. Bu kitapta 4 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png` (git dışı); diğer sayfalar resimsizdir ve kitabın paletiyle renklidir (`book.json → image: null`). Model GPT Image 2.5, 3:4, ~0,5 kr/görsel (≈ 2 kr). Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve onay alınır. Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Flat-colour vector illustration with a light cartoon touch, non-photorealistic, simple rounded shapes, clean outlines, cheerful family comedy mood. Palette: warm orange, mint green, cream, with small touches of sky blue. A cosy apartment in Ankara, Turkey, with simple modern buildings outside. Absolutely no text, letters, numbers, signs or writing anywhere in the image; phone screens are plain glowing rectangles with simple round icons only, no words, no numbers, no clock. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçen tanım aynen eklenir):**
- **Grandpa Kemal:** 72-year-old Turkish man, retired bus driver, round and friendly, bald on top with white hair on the sides, big white moustache, bushy eyebrows, beige knitted vest over a light-blue shirt, brown trousers, reading glasses on a cord; very expressive, easily surprised face.
- **The new phone:** a thin black smartphone with no logo; its screen is a plain glowing rectangle.
- **Mert:** 14-year-old boy, neighbour on the same floor, slim, short black curly hair, friendly grin, orange hoodie, jeans, white sneakers.
- **Grandpa's flat:** small and cosy; mint-green sofa with crocheted cushions, a window with a view over Ankara rooftops, a small kitchen table with a tea glass on a saucer.

**Görsel istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sahne |
|---|---|
| cover.png | Grandpa Kemal sits on his mint-green sofa holding the new black phone at arm's length; the phone's glowing screen and Grandpa stare at each other; his eyebrows are raised in comic suspicion. |
| p01.png | Grandpa Kemal in his cosy flat laughs a big warm laugh, the new thin black phone in his hand; a window behind him shows sunny Ankara rooftops. |
| p05.png | Morning at the small kitchen table: Mert points at the phone screen and shows Grandpa where to touch; Grandpa leans in with his reading glasses on, very serious; two glasses of tea on the table. |
| p09.png | Saturday morning in the hall: Grandpa in his best white shirt holds a bunch of yellow flowers in one hand and the phone at arm's length in the other, smiling proudly for a selfie; the front door behind him is closed. |

**Sürpriz kontrolü:** Sürpriz, ailenin bütün hafta Mert'in evinde (mavi perde) gizlice parti hazırlaması, Mert'in de işin içinde olması ve Dede'nin "yanlış" fotoğraflarının parti duvarında olmasıdır. Hiçbir istemde aile, pasta, parti süsü, mavi perde ya da ayak fotoğrafı yok. Kapak yalnız Dede ile telefonun "bakışmasını" gösterir. p05'te Mert yalnızca yardımsever komşudur; perde ve Mert'in evi görünmez. p09'da kapı kapalıdır; kapının arkasındaki kalabalık gösterilmez.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | d483d26f-5c2b-4cb4-8548-943321fbfe65 | — | 2026-10-14T11:09:51+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | 28ea883a-97b4-446d-9a46-3c018a9d1f40 | d483d26f-5c2b-4cb4-8548-943321fbfe65 | 2026-10-14T11:12:32+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 3d986758-e680-4861-82d2-9bfce64127c3 | d483d26f-5c2b-4cb4-8548-943321fbfe65 | 2026-10-14T11:12:33+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | 9d965664-2d67-4d45-9a64-3231610ccf44 | d483d26f-5c2b-4cb4-8548-943321fbfe65 | 2026-10-14T11:12:36+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 2 kr. Tam istem metinleri yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.9; anlatım temposu dışa aktarmada A1 varsayılanı `auto` (§6.5). Ses, **ElevenLabs Creator** (ticari lisans) hesabıyla ve önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip onay alındıktan sonra üretilir. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
| 2026-10-30T13:33:41Z | c1 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1722 | e1b00882d093f79f | audio/c1.mp3 |
| 2026-10-30T13:34:26Z | c2 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1462 | 51b3ee62ec8d745f | audio/c2.mp3 |
| 2026-10-30T13:34:55Z | c3 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1194 | 4c0ec9c271b257c2 | audio/c3.mp3 |
