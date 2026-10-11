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
