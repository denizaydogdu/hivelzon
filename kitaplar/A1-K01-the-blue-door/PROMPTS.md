# A1-K01 The Blue Door: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-069 pilot kitaplar, yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A1-K01 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json` |

**İstem (özet):** "A1-K01 *The Blue Door* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 3 bölüm, 11 sayfa, ~700 kelime (±%20). A1: her cümle ≤ 8 kelime, present simple, yan cümle yok; *there is / there are*, üçüncü tekil -s, renk + isim, *on / under / behind / next to*, saat (*at nine*). İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J A1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Adil son için yerleştirilen ipuçları:** Ada Hanım'ın "No one lives there. That is true." demesi (p03), basamaklardaki toprak (p04–p05), domates kokusu ve yeşil eller (p06), Ada Hanım'ın dördüncü kattaki kırmızı saksıyı bilmesi (p06), "I sleep at eight" ve saat dokuzda gelen yavaş adımlar (p07–p08).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: pilot görselleri ≈ 15 kr (\"Görseller: Yaklaşık 15 kredi … ( onay )\", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, quality medium, 1k = 0,5 kr/görsel; sayfalar kapak işi referans verilerek üretildi (karakter tutarlılığı). Başarısız işler ücretlendirilmedi ve yeniden denendi.
> Dosya adları `book.json` ile aynı: `images/cover.png`, `images/p01.png` … `images/p11.png` (git dışı).

**Sabit stil öneki (her istemin başına):**
`Gouache storybook illustration, non-photorealistic, soft visible brush strokes, warm and curious mood, never scary. Palette: deep night navy, warm lamp yellow, tomato red, soft cream, leaf green. Cozy old riverside apartment building. Absolutely no text, letters, numbers, signs or writing anywhere in the image; doors, notebooks and clocks are drawn without any marks. Consistent characters as described. Vertical 3:4.`

**Karakterler (her istemde adı geçen karakterin tanımı aynen eklenir):**
- **Lina:** 11-year-old girl, short curly dark-brown hair with a small yellow hair clip, light olive skin, big curious eyes, tomato-red hoodie, blue jeans, green sneakers.
- **Mum:** Lina's mother, late 30s, tall, long black hair in a loose bun, mustard-yellow cardigan, kind tired smile.
- **Mrs Ada:** small, round woman about 75, silver hair in a bun, round glasses, dark green apron with brown earth marks, green-stained hands and fingers, gentle secret smile.
- **Mr Tom:** man in his 60s, bald with a short grey beard, blue sweater, holds a big fluffy grey cat.
- **The building:** old five-floor building beside a river, green and white walls, narrow wooden steps; on the top floor one plain blue door with no number.
- **The roof garden:** flat roof with tomato plants, green beans on sticks and flowers in pots, many small warm lights on strings, night sky with stars.

**Sayfa sayfa istem (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sahne |
|---|---|
| cover.png | Lina stands on the dark top-floor landing, looking at the plain blue door; a warm yellow line of light glows under it. |
| p01.png | Lina runs up the narrow wooden steps of the old green-and-white riverside building; above her, at the top, the plain blue door. |
| p02.png | Moving day in a small flat full of cardboard boxes; Lina holds a small red pot with a dry brown flower while Mum carries a box. |
| p03.png | Evening on the stairs: Mr Tom with his big grey cat laughs; Mrs Ada stands at her door and smiles; Lina looks up at them. |
| p04.png | Night, dark stairwell; Lina peeks out of her door and looks up; a warm yellow light glows under the blue door far above. |
| p05.png | Morning; Lina kneels on the steps with an open blank notebook, following small brown bits of earth down the stairs to a green door. |
| p06.png | Mrs Ada opens her green door; Lina stares at Mrs Ada's green-stained hands; ripe tomatoes in a bowl behind her. |
| p07.png | Lina sits alone on the steps, thinking hard, pencil on her lips, her notebook open with only doodles, no writing. |
| p08.png | Night; Lina sits on the floor behind her slightly open door, listening; a soft shadow of slow steps goes up the stairs. |
| p09.png | Lina climbs a second, narrow dark staircase behind the open blue door towards a warm yellow glow and cool night air. |
| p10.png | A magical roof garden under many small string lights at night: tomatoes, beans, flowers; Mrs Ada waters the tomatoes and smiles at Lina. |
| p11.png | Mrs Ada holds out an open hand with two old brass keys to Lina; later, Lina's red pot stands next to the tomatoes with one new green leaf. |


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi | Not |
|---|---|---|---|---|---|---|
| cover.v1-rejected | 531ea17c-3636-4242-9d2c-5785b4294ed0 | — | 2026-10-14T09:58:15Z | 3:4, medium, 1k | 0.5 | Reddedildi: istemde çatı bahçesi tanımı vardı, sonu ele veriyordu. |
| cover.png | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | — | 2026-10-14T09:59:39+00:00 | 3:4, medium, 1k | 0.5 |  |
| p04.png | fe93f09a-c974-4c6b-a402-399efbd6aa82 | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:00:25+00:00 | 3:4, medium, 1k | 0.5 |  |
| p02.png | 29294672-6256-4050-828c-f4de6b36c459 | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:00:26+00:00 | 3:4, medium, 1k | 0.5 |  |
| p03.png | d07f89dc-f6d3-48ed-bc54-5ad163583481 | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:00:30+00:00 | 3:4, medium, 1k | 0.5 |  |
| p01.png | 8ab181e2-da52-4fb9-a439-f0b8e0771dd0 | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:00:33+00:00 | 3:4, medium, 1k | 0.5 |  |
| p06.png | 76ebd8c9-7cb3-44aa-a4aa-ed9712e3978c | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:00:58+00:00 | 3:4, medium, 1k | 0.5 |  |
| p05.png | 27046871-2c52-413a-94b8-3863f124b58b | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:01:06+00:00 | 3:4, medium, 1k | 0.5 |  |
| p08.png | 8df76b6e-1d5c-4da2-90ef-114b6f8aa019 | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:01:08+00:00 | 3:4, medium, 1k | 0.5 |  |
| p09.png | 1e477d76-2d1d-4c10-a5c5-c7b4a930b3ef | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:01:31+00:00 | 3:4, medium, 1k | 0.5 |  |
| p10.png | 0bc492cf-e1a2-4710-875b-2cc93b53acad | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:01:42+00:00 | 3:4, medium, 1k | 0.5 |  |
| p07.png | aba82761-a1a9-4017-8d5d-cf4b0f774ec9 | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:03:57+00:00 | 3:4, medium, 1k | 0.5 |  |
| p11.png | 2b66cef8-bf38-4a01-a3ae-34dfee0363ff | a2e42f2c-4c2b-43f0-8235-a862c7d75ecc | 2026-10-14T10:03:58+00:00 | 3:4, medium, 1k | 0.5 |  |

**Toplam:** 6.5 kr. İstem = sabit stil öneki + sahnede geçen karakter/mekân tanımları + sahne (yukarıdaki tablo). Tam istem metinleri yerel `images/_jobs.json`'da (git dışı).

**Editör değerlendirmesi:** Karakter ve üslup tutarlı; görselde yazı yok. Küçük notlar: A1 p11 dört karelik kolaj olarak çizildi; A2 p10'da ikizler uyumuyor. Telif/AI: özgün istem, gerçek kişi/marka yok; uygulama içi AI notu bölüm başındaki gibi gösterilir.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Pilot ses ElevenLabs ücretsiz kotasıyla, yalnız iç kullanım için üretilecek (H-069); önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilir. `narration.voiceId` henüz seçilmedi. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
