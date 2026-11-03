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

**Üretildi (2026-10-14), anlatıcı Sarah.** Kullanıcı kararı: önce yalnız A1, ücretsiz kota (videoGenerator hesabı, iç kullanım; yayından önce ticari planla yeniden üretilir, H-006). Kota kontrolü: bu ay 0/10.000 kullanılmıştı; 3.880 karakter harcandı, tavan 4.000 verildi. Not: ölçülen hız 144–168 k/dk, A1 hedefi 100–110; yavaşlatma ayrıca yapılacak. Eski not: Pilot ses ElevenLabs ücretsiz kotasıyla, yalnız iç kullanım için üretilecek (H-069); önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilir. `narration.voiceId` henüz seçilmedi. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T10:08:28Z | c1 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1507 | a07284b8f5d8a618 | audio/c1.mp3 |
| 2026-10-14T10:08:48Z | c2 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1152 | cc0b4809cd518ed5 | audio/c2.mp3 |
| 2026-10-14T10:09:06Z | c3 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1221 | e9e4744a6f8da689 | audio/c3.mp3 |
| 2026-10-30T13:32:25Z | c3 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1224 | fb93c9054e2f8736 | audio/c3.mp3 |

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T17:06:37Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 348 | 25.94 | c139e8ab0e294af2b15aea5e51d988bd | 132acec1d956337d |
| 2026-11-03T17:06:40Z | p01 | duyu-1 | - | - | - | 25.94 | - | 132acec1d956337d |
| 2026-11-03T17:06:48Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 357 | 25.18 | 3ce3f706051f4606b223965ef114a940 | f565289a400de7af |
| 2026-11-03T17:06:51Z | p02 | duyu-1 | - | - | - | 25.18 | - | f565289a400de7af |
| 2026-11-03T17:06:55Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 401 | 26.87 | 3d62af2e089b4baf8a91663b15fe9da5 | c591b99d0cb7bf08 |
| 2026-11-03T17:06:59Z | p03 | duyu-1 | - | - | - | 26.87 | - | c591b99d0cb7bf08 |
| 2026-11-03T17:07:03Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 391 | 28.67 | 639d06591407411c8099b937da78ac73 | 36bdc946aa79617c |
| 2026-11-03T17:07:06Z | p04 | duyu-1 | - | - | - | 28.67 | - | 36bdc946aa79617c |
| 2026-11-03T17:07:10Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 262 | 18.88 | 8a9a90dc289242a8be994128c0ed1ff6 | b6efe3fce2ef955b |
| 2026-11-03T17:07:13Z | p05 | duyu-1 | - | - | - | 18.88 | - | b6efe3fce2ef955b |
| 2026-11-03T17:07:17Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 251 | 18.68 | b4d7e0dfa36f44438e3fbef83603573b | 3a4d982c6ba7fe1f |
| 2026-11-03T17:07:20Z | p06 | duyu-1 | - | - | - | 18.68 | - | 3a4d982c6ba7fe1f |
| 2026-11-03T17:07:23Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 329 | 25.31 | af117d907e61441ab186f398b32c9736 | b49a4162a1f9a1bc |
| 2026-11-03T17:07:26Z | p07 | duyu-1 | - | - | - | 25.31 | - | b49a4162a1f9a1bc |
| 2026-11-03T17:07:30Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 251 | 16.95 | 697a2a0b17ab477f90492d0a7266bf20 | 85301e886c22258f |
| 2026-11-03T17:07:32Z | p08 | duyu-1 | - | - | - | 16.95 | - | 85301e886c22258f |
| 2026-11-03T17:07:35Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 263 | 20.8 | c59e2f071fd647edbfdbc64328314871 | 73cc94570e4eb2c8 |
| 2026-11-03T17:07:38Z | p09 | duyu-1 | - | - | - | 20.8 | - | 73cc94570e4eb2c8 |
| 2026-11-03T17:07:42Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 372 | 27.63 | a67178ac6408472c8322d56eeeb447c9 | c8166d0dbe515ca2 |
| 2026-11-03T17:07:44Z | p10 | duyu-1 | - | - | - | 27.63 | - | c8166d0dbe515ca2 |
| 2026-11-03T17:07:50Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 619 | 41.08 | 172620ad2edc40978e9bb7f6d40de1c0 | dcb6fff8ac3ca9f5 |
| 2026-11-03T17:07:54Z | p11 | duyu-1 | - | - | - | 41.08 | - | dcb6fff8ac3ca9f5 |
| 2026-11-03T17:27:39Z | p11 | duyu-1 | - | - | - | 41.08 | - | dcb6fff8ac3ca9f5 |
