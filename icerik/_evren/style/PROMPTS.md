# PROMPTS: Karakter ve stil referansları (H-024 pilot, 1. adım)

**İçerik ID:** `_evren/style` · **Prompt sürümü:** v1 · **Tarih:** 2026-10-11
**Amaç:**
- Alex, Hi ve telsiz için referans sayfaları üretmek.
- Görsel modeli seçmek (K-24): Nano Banana 2 mi, GPT Image 2.5 mi?

**Telif ve AI kontrolü:** Özgün karakterler. Gerçek kişi, ünlü ya da telifli karakter benzerliği istenmedi. Görsellerde yazı yok.

## Ortak stil öneki (STYLE v1)

> Warm animated-series illustration, graphic-novel style, clean ink lines, soft cel shading, coastal palette of sea blue, sand, lighthouse yellow and evening orange, mature tone suitable for teens and adults, not childish, no text, no letters, no logos.

## Prompt'lar

| # | Konu | Prompt (STYLE eklenir) |
|---|---|---|
| R1 | Alex | Character reference sheet of an original character: Aleyna, called Alex, a 19-year-old young woman from Izmir, Turkey. Dark brown shoulder-length hair, warm brown eyes, casual simple clothes: olive jacket, cream sweater, jeans, white sneakers. Canvas backpack with an old portable radio in the side pocket, phone on a strap. Front view, side view, back view, and three facial expressions: curious, shy smile, surprised. Plain light background. |
| R2 | Hi | Mascot design sheet of an original AI assistant character named Hi: a small round glowing speech bubble with two friendly eyes, soft cyan and warm yellow light, floating, simple and readable at small size, not human, not a robot. Five expressions: happy, thinking, surprised, encouraging, calm. Plain background. |
| R3 | Telsiz | Prop design sheet: an old 1970s portable two-way radio, scuffed cream and dark green body, small green indicator light, round channel dial, telescopic antenna, a faded blank sticker with no readable text. Front view, side view, light on and light off. Plain background. |

**Parametreler:** `--aspect_ratio 3:2 --resolution 2k`

## Maliyet ve sonuç (2026-10-11)

| İş | Model | Tahmin | Gerçek | Job ID | Yerel dosya (git dışı) | Değerlendirme |
|---|---|---|---|---|---|---|
| R1 Alex | nano_banana_flash | 2 | 2 | 074160d2-c5fb-4214-a815-dfb761362a36 | refs/R1-alex-nano.png (2528×1696) | Temiz mürekkep çizgisi, görünüşler tutarlı. Biraz daha genç ve "sevimli". Stile uygun. |
| R1 Alex | gpt_image_2_5 | 0,5 | 0,5 | 8d1fcc99-e4e6-4359-9111-e0bd4de8988b | refs/R1-alex-gpt.png (2048×1360) | Daha olgun, dokulu, çizgi roman hissi güçlü. İstenmeden palet ve fener vinyeti eklemiş; yazı yok. |
| R2 Hi | nano_banana_flash | 2 | 2 | a3a6f138-c82d-461e-9524-aed432c98ee1 | refs/R2-hi-nano.png | Yalnızca göz, ağız yok. Simge ve logo olarak çok iyi, duygu ifadesi sınırlı. |
| R2 Hi | gpt_image_2_5 | 0,5 | 0,5 | 0d2ea221-37f1-413e-a51d-a0f2047d3c3a | refs/R2-hi-gpt.png | Parlak balon, ağızlı ve çok ifadeli; geri bildirim anlarına uygun. Emoji'ye yakın; çocuksu görünme riski hafif. |
| R3 Telsiz | nano_banana_flash | 2 | 2 | b3398f5a-41de-49dd-b93e-8fd6afb0871b | refs/R3-radio-nano.png | ❌ **"Yazı yok" kuralını çiğnedi:** "Front View (Off)", "PTT", (a)(b)(c) ve etikette karalama. Bu hâliyle kullanılamaz. |
| R3 Telsiz | gpt_image_2_5 | 0,5 | 0,5 | 0e1bff0c-ba8c-4aad-9f9f-3e7c38976c54 | refs/R3-radio-gpt.png | ✅ Yazı yok, boş etiket, kadran, yeşil ışık açık ve kapalı. 1970'ler hissi iyi. |
| **Toplam** | | **7,5** | **7,5** | | | |

- **Kredi:** 126,25 → 118,75.
- **Kullanıcı onayı:** 2026-10-11, soru-cevap ("İki modelde de, 7,5 kredi").
- **İlk değerlendirme (Claude):**
  - GPT Image 2.5 dört kat daha ucuz ve "yazı yok" kuralına daha iyi uydu. Görsel modelde varsayılan adayı bu.
  - Sahneler arası karakter tutarlılığı, referans görseliyle (`image_references`) yapılacak sahne testiyle ölçülecek.
- **Nihai seçim:** kullanıcıda.

## R4 Maya (2026-10-11)

- **Prompt:** /tmp kaydı → "Character reference sheet of an original character: Maya Brooks, a 19-year-old young woman, local of a coastal town; curly dark-brown shoulder-length hair, warm light-brown skin with a few freckles, friendly bright eyes; yellow raincoat over a striped sweater, dark jeans, ankle boots; a folded paper map and a small notebook peeking from her shoulder bag. Front view, side view, back view, and three facial expressions: warm smile, thinking, surprised. Plain light background." + STYLE.
- **Üretim:** gpt_image_2_5, 3:2, 2k. Tahmin 0,5 / gerçek 0,5. Job `R4-maya-gpt.json`; upload `6db4fa91-a3ff-4587-9b02-43a480ecb45a`.
- **Değerlendirme:** ✅ Tarife uygun, yazı yok. Kullanıcı onayı: soru-cevap (B2–B4 paketi).

## R5 Jordan ve R6 ses kaydedici (H-085, 2026-10-14)

- **R5 Jordan prompt:** "Character reference sheet of an original character: Jordan Reed, a 31-year-old man, a bicycle courier in a small coastal town; short black curly hair, short neat beard, warm brown skin, friendly wide grin, energetic posture; bright orange courier jacket with grey reflective stripes, dark grey cycling helmet (shown on his head and also held in his hand), black cargo trousers, sturdy trainers, a dark green messenger bag across his body, holding a small cardboard parcel; a sturdy city bicycle with a front basket. Front view, side view, back view, and three facial expressions: big laugh, thinking with a hand on his chin, surprised. Plain light background." + STYLE v1.1.
- **R6 kaydedici prompt:** "Prop design sheet: a small old handheld voice recorder from the 1980s, palm-sized, scuffed faded red plastic body with a silver metal speaker grille, one round button and one small slide switch, a tiny round indicator light, a small window showing a mini cassette inside, a short black wrist strap; no labels, no brand, no writing. Front view, side view, back view, indicator light on and indicator light off. Plain background." + STYLE v1.1.
- **Üretim:** gpt_image_2_5, 3:2, 2k, low. Tahmin 0,5 / gerçek 0,5 her biri. Job: R5 `185195f6-f42d-4cbe-a013-7151a26d759a`, R6 `72e65920-4ec7-4946-ae36-502810c61948` (sonraki üretimlerde job kimliği referans olarak verilir). Dosyalar `refs/R5-jordan-gpt.png`, `refs/R6-kaydedici-gpt.png` (git dışı; yalnızca ana çalışma kopyasında).
- **Değerlendirme (Claude):** ✅ Yazı yok. Jordan turuncu kurye ceketiyle Alex (zeytin yeşili) ve Maya'dan (sarı yağmurluk) açıkça ayrılıyor. R6'da model kendiliğinden küçük bir fener vinyeti ve palet eklemiş (yalnızca referans sayfası; bölümde görünmez). B6'da (Sam kaydediciyi açar) aynı kaydedici için R6 kullanılmalı.
- **Kullanıcı onayı:** H-085 görevi (20 kr tavan). Editör onayı bekliyor.

## R9 Rosa, R10 Mr Grant, R11 Tom (H-085, B9–B12, 2026-10-14)

- **R9-rosa prompt:** "Character reference sheet of an original character: Rosa Marin, a 58-year-old woman who owns a small café on a hill in a coastal town; warm olive skin, dark hair with grey streaks in a loose low bun, reading glasses pushed up on top of her head, kind smile lines, calm warm eyes; a soft sage-green cardigan with rolled sleeves over a cream blouse, a long mustard-yellow apron, dark trousers, comfortable shoes; holding a small teapot. Front view, side view, back view, and three facial expressions: warm welcoming smile, listening thoughtfully, gentle surprise. Plain light background." + STYLE v1.1. Job `a30f6cb8-b8bd-42f2-9bcb-573477f1eb65`.
- **R10-grant prompt:** "Character reference sheet of an original character: Mr Grant, a 70-year-old man who runs a small, cluttered spare-parts shop for old radios; pale skin with rosy cheeks, bald on top with short white hair at the sides, a big bushy white moustache, round reading glasses low on his nose; a brown knitted waistcoat over a checked flannel shirt with rolled sleeves, a pencil behind one ear, brown corduroy trousers; humorous but patient. Front view, side view, back view, and three facial expressions: hearty laugh, explaining patiently with one finger raised, peering over his glasses. Plain light background." + STYLE v1.1. Job `effcd1d0-a1a7-4490-b464-571ed47edf5d`.
- **R11-tom prompt:** "Character reference sheet of an original character: Tom Walsh, a 24-year-old weekend volunteer at a lighthouse museum; tall and lanky, fair skin with freckles, messy ginger-red hair, friendly open face; a dark-teal rain jacket with a plain bright yellow volunteer lanyard and an empty blank badge, a grey knitted scarf, dark jeans, wellington boots; holding an old-fashioned hand lantern with a warm glow. Front view, side view, back view, and three facial expressions: big welcoming smile, worried concern, explaining with enthusiasm. Plain light background." + STYLE v1.1. Job `d253029e-727a-4f84-9042-4afc2e552a08`.
- **Üretim:** gpt_image_2_5, 3:2, 2k, low. Tahmin 0,5 / gerçek 0,5 her biri (1,5 kr). Dosyalar `refs/R9-rosa-gpt.png`, `refs/R10-grant-gpt.png`, `refs/R11-tom-gpt.png` (depo dışı; worktree'den ana kopyaya taşınmalı). Sonraki üretimlerde job kimliği referans olarak verilir.
- **Değerlendirme (Claude):** ✅ Yazı yok. Rosa: yeşil hırka + hardal önlük, gözlük başında; Mr Grant: kel, beyaz bıyık, kahverengi örgü yelek + kareli gömlek; Tom: zencefil saç, petrol rengi yağmurluk, sarı boyun askısı (kart boş), fener. Üçü de Alex, Maya, Sam ve Jordan'dan renk ve siluetle ayrılıyor.
- **Not:** R7 Sam (job `d83596f7-7f31-4914-ae9e-5e4134e086b6`) ve R8 Mrs Brooks B6–B8 oturumunda üretildi; B9–B12'de Sam için R7 kullanıldı.
- **Kullanıcı onayı:** H-085 görevi (B9–B12 tavanı 60 kr). Editör onayı bekliyor.
