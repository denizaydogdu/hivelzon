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

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:04:54Z | b3_05_hi.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.4 | 5b2c54fe5a9f4f39a041e0c9d518a670 | fc194f98b7471534 |
| 2026-10-14T13:04:55Z | b3_05_hi.p1 | duyu-1 | - | - | - | 2.4 | - | fc194f98b7471534 |
| 2026-10-14T13:04:56Z | tr_r-k2-b.p2 | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 0.48 | dc9a8ca46d8140d49f3ff9d216eb4831 | 5a343e0ac04749c3 |
| 2026-10-14T13:04:56Z | tr_r-k2-b.p2 | duyu-1 | - | - | - | 0.48 | - | 5a343e0ac04749c3 |
| 2026-10-14T13:04:57Z | tr_r-k2-b.p4 | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 2.4 | 0cc0fea8d7b04ee1aac0ce2f52a571fb | 275da6b4098dac4c |
| 2026-10-14T13:04:58Z | tr_r-k2-b.p4 | duyu-1 | - | - | - | 2.4 | - | 275da6b4098dac4c |
| 2026-10-14T13:04:59Z | b3_10_hi.p2 | alania-v2 | alania2-f1 | alania-v2.1 | 51 | 3.68 | ac14f3833d2a442aa98de84e40c11d1b | a7be4994aad1755a |
| 2026-10-14T13:04:59Z | b3_10_hi.p2 | duyu-1 | - | - | - | 3.68 | - | a7be4994aad1755a |
| 2026-10-14T13:05:01Z | b3_13_hi | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 3.68 | 0c435ef184374e1eaa85e4cfcf5b5efa | 478742dc589fecb9 |
| 2026-10-14T13:05:01Z | b3_13_hi | duyu-1 | - | - | - | 3.68 | - | 478742dc589fecb9 |
| 2026-10-14T13:05:03Z | tr_c-clues | alania-v2 | alania2-m1 | alania-v2.1 | 83 | 6.4 | b3f3f065539548ff8adcf496a5f1c32e | 63379d7df124b53b |
| 2026-10-14T13:05:05Z | tr_c-clues | duyu-1 | - | - | - | 6.4 | - | 63379d7df124b53b |
| 2026-10-14T13:05:06Z | tr_c-oq | alania-v2 | alania2-m1 | alania-v2.1 | 43 | 3.52 | ff466b32ba334b168500b1e4d4c51bdf | 95c74534fc80fb76 |
| 2026-10-14T13:05:07Z | tr_c-oq | duyu-1 | - | - | - | 3.52 | - | 95c74534fc80fb76 |

## İngilizce ifade seslendirme kayıtları (tts_episode_tr.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 |
|---|---|---|---|---|---|---|
| 2026-10-14T13:07:04Z | b3_05_hi.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 970ff260266b9d4b |
| 2026-10-14T13:07:05Z | tr_r-k2-b.p1 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 4 | 58eb9032e3bb83f0 |
| 2026-10-14T13:07:06Z | tr_r-k2-b.p3 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 5 | 883361d5d682a157 |
| 2026-10-14T13:07:07Z | b3_10_hi.p1 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 7 | c1ea3f5e7aa47303 |
