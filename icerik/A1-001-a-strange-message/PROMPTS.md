# PROMPTS: A1-001 *A Strange Message* (pilot, H-024)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1.
- **Model:** gpt_image_2_5.
- **Referanslar:** Alex (663ea0fe…), telsiz (74fb45e8…).
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok. Videoda "Yapay zekâ ile üretilmiştir" ibaresi olacak.

## Sahne testi (karakter tutarlılığı), 2026-10-11

| # | Sahne | Prompt (STYLE eklenir) | Parametre | Tahmin | Gerçek | Job ID | Dosya |
|---|---|---|---|---|---|---|---|
| T1 | Sahne 1: Cuma akşamı, oda ve telsiz | Use the reference images for the character Alex and for the old radio; keep the same face, hair, clothes and radio design. Scene: evening in a small, bright rented room in a coastal town. Through the window: a harbour and, far away, a lighthouse at dusk. Alex sits at a wooden desk and carefully places the old green-and-cream radio on the desk. A simple round wall clock with a blank face, no numbers. Calm, curious mood. Vertical composition. | 9:16, 2k (quality: low, varsayılan), refs: Alex + telsiz | 0,5 | 0,5 | 6d48f511-e6a9-4d23-b90a-1bb12b643b73 | images/T1-oda.png (1520×2688) |
| T2 | K1 karar anı (POV) | Use the reference image for the old radio and Alex's hands and jacket sleeve. Scene: first-person point of view looking down at the old radio on a wooden desk, its small green light glowing, Alex's hands near the radio, a phone lying next to it with a dark blank screen. Background softly blurred and simplified, warm dim evening light, focused and quiet decision moment. Vertical composition. | 9:16, 2k (quality: low), refs: Alex + telsiz | 0,5 | 0,5 | 79759833-7016-4e97-8f28-2af795a5cf49 | images/T2-pov.png (1520×2688) |

- **Toplam:** tahmin 1 / gerçek 1 kredi.
- **Kredi:** 118,75 → 117,75.
- **Kullanıcı onayı:** 2026-10-11, soru-cevap.

**Değerlendirme:**
- ✅ Alex'in yüzü, saçı ve kıyafeti referansla tutarlı; telsiz tasarımı aynı.
- ✅ Saat rakamsız; görselde yazı yok; 9:16.
- ⚠️ T1'de telsizin ışığı zaten açık (hikâyede 19:00'da yanıyor). Kurguda ışığın yandığı an T2 ve klipte gösterilir; T1 sahnenin başında kısa kullanılır ya da ileride ışık kapalı varyantı üretilir.
- **Not:** GPT Image 2.5'in varsayılan kalitesi `low`. 0,5 kredilik fiyat bu kaliteye ait ve düşük kalite pilot için yeterli görünüyor.
- **İndirme hatası ve düzeltmesi:** JSON'daki ilk `.png` adresi referans görseline aitti. Sonuç `result_url` alanından indirilmeli.

## Kilit klip maliyet karşılaştırması (★ telsiz ışığı, 5 sn, 9:16, start-image = T2)

| Model | 480p | 720p |
|---|---|---|
| seedance_2_5 | 15 | 35 |
| kling3_0_turbo | — | 7,5 |
| seedance_2_0_mini | — | 5 |
| grok_video_v15_lite | — | 5 |
| Yerel geçiş (T2'nin ışık kapalı ve açık hâlleri + parlama, ffmpeg) | 0 | 0 |
