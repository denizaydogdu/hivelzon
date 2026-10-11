# PROMPTS: A1-003-find-the-station (üretim, 2026-10-11)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1 (her prompt'un sonuna eklenir).
- **Model:** gpt_image_2_5, 9:16, 2k, quality low.
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok; notlar, mesajlar ve haritadaki yazılar kurguda eklenir.
- **Kullanıcı onayı:** soru-cevap, "Evet, 11,5 kredi" (B2–B4 + Maya referansı).
- **Referanslar:** Alex `663ea0fe…`, Maya `6db4fa91…` (R4), telsiz `74fb45e8…`.

## Görseller

| Ad | Referanslar | Kredi | Job ID | Prompt (STYLE hariç) |
|---|---|---|---|---|
| B3-01-mesaj | Alex | 0,5 | 1987eae9-190c-4ef0-a2cc-e2ed7a911e37 | Use the reference image for Alex. Scene: Sunday morning, Alex sits on her bed in pajamas and a cardigan, reading a message on her phone with a small, slightly disappointed smile; the phone screen faces away from the viewer. Soft morning light, cozy room. Vertical composition. |
| B3-02-kopekli-adam-pov | Alex | 0,5 | a1ad653b-cc47-4044-a40f-4b36549d9a11 | First-person view from Alex on a sloping street of colourful houses in a coastal town: a friendly older man with a small dog on a leash points down the street, explaining the way; Alex's hand in an olive jacket sleeve at the edge of the frame. Morning light. Vertical composition. |
| B3-03-kavsak-pov | — | 0,5 | 8b976ac5-5429-4162-b5b3-0d95439f6b75 | First-person view at a crossroads in a coastal town: one road goes straight ahead and then curves left toward a glimpse of the harbour and boats, another road goes right uphill. Calm morning, no people, no signs with text. Vertical composition. |
| B3-04-cikmaz-kedi | — | 0,5 | 8a8de187-eb2e-43cb-a0fa-781deb68ca4d | A small dead-end alley in a coastal town with a brick wall at the end, flower pots and a sleepy orange cat sitting on a step, looking at the viewer with mild curiosity; gentle humorous mood. No text. Vertical composition. |
| B3-05-liman | Alex | 0,5 | acc2c480-f375-4f25-a23c-b82fb0948396 | Use the reference image for Alex. Scene: a small harbour in the morning: from left to right a fish shop with fish on ice, an old grey two-storey building with a rusty antenna on its roof, and a small café with outdoor tables; a bus stop shelter in front of the café; boats in the water. Alex stands in the foreground holding a paper map, looking at the old building. No text on any sign. Vertical composition. |
| B3-06-old-station | Alex | 0,5 | 9efbd1a9-21e5-4f5b-bfcc-e0630ab6e3ce | Use the reference image for Alex. Scene: Alex stands in front of an old grey harbour radio station building: peeling paint, a tall rusty antenna on the roof, a locked heavy wooden door with a padlock, seagulls on the roof, quiet and slightly mysterious but not scary, morning light. Vertical composition. |
| B3-07-yarim-not | — | 0,5 | cdbc8c8f-5c23-45d8-855a-ebc937c45410 | Close-up of a heavy wooden door: a sheet of paper is pinned to it, rain-stained and partly washed out, with only faint blurred smudges and no readable letters or numbers; a rusty pin; morning light. Vertical composition. |

## Seslendirme

- **Sağlayıcı:** ElevenLabs `eleven_v3` with-timestamps, speed 0.9, `language_code` en/tr.
- **Hesap:** videoGenerator hesabı; ücretsiz plan. **Yalnızca iç kullanım, yayınlanmaz** (H-006).
- **Sesler:** George (adam), Jessica (Alex), River (Hi).
- **Tüketim:** 13 satır, 404 karakter.
- **Dosyalar:**
  - `audio/*.mp3` (git dışı) ve `audio/*.align.json`;
  - `audio_manifest.json`: replik → ses kimliği eşlemesi. B1 ile aynı telsiz replikleri B1'in kayıtlarını kullanır.
