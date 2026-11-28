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
| 2026-11-27T19:49:10Z | l-323a013269 | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.88 | a1ec64bdef2d456e9954bab6dad9f7c3 | 0cd00e74a48d91b3 |
| 2026-11-27T19:49:11Z | l-323a013269 | duyu-1 | - | - | - | 2.88 | - | 0cd00e74a48d91b3 |
| 2026-11-27T19:49:13Z | l-9cc109b4e2 | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.24 | 5fa688fbc8bb4fccb68971f069a2b018 | f1727fcc6bed9327 |
| 2026-11-27T19:49:14Z | l-9cc109b4e2 | duyu-1 | - | - | - | 2.24 | - | f1727fcc6bed9327 |
| 2026-11-27T19:49:15Z | l-69e438c2c6 | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 3.04 | eceef7883e1b40278d62a08d245f2966 | 59bd7f93ede6a67a |
| 2026-11-27T19:49:17Z | l-69e438c2c6 | duyu-1 | - | - | - | 3.04 | - | 59bd7f93ede6a67a |
| 2026-11-27T19:49:18Z | l-b78aa7c8f5 | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.12 | 1e9e92ce28e746f880528ddf298802ae | 1a0e5528470e7d30 |
| 2026-11-27T19:49:19Z | l-b78aa7c8f5 | duyu-1 | - | - | - | 1.12 | - | 1a0e5528470e7d30 |
| 2026-11-27T19:49:21Z | l-15cbb0efb5 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.44 | 28e7d8ffe6504246b0d23e6618efafaa | 8ad88ab2e088d0ae |
| 2026-11-27T19:49:21Z | l-15cbb0efb5 | duyu-1 | - | - | - | 1.44 | - | 8ad88ab2e088d0ae |
| 2026-11-27T19:49:23Z | l-5b763410d2 | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 1.92 | c2c68f1e61fd4b0286e805e94dbb4c8f | 3ed9e10827114c68 |
| 2026-11-27T19:49:24Z | l-5b763410d2 | duyu-1 | - | - | - | 1.92 | - | 3ed9e10827114c68 |
| 2026-11-27T19:49:26Z | l-3fa43c7ed3 | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.56 | 48157501b9744022b0ce0eb055761721 | fea8e3c023f2c334 |
| 2026-11-27T19:49:27Z | l-3fa43c7ed3 | duyu-1 | - | - | - | 2.56 | - | fea8e3c023f2c334 |
| 2026-11-27T19:49:28Z | l-d208fcbee8 | alania-v2 | alania2-f1 | alania-v2.1 | 8 | 0.96 | 73ff64e7a3704c079a46342fc7f9740e | 264303d2be58593d |
| 2026-11-27T19:49:29Z | l-d208fcbee8 | duyu-1 | - | - | - | 0.96 | - | 264303d2be58593d |
| 2026-11-27T19:49:31Z | l-195b4d1393 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.8 | 298f19d7e71f4e5ca6584e07e5d18511 | 89e67b989b621fa4 |
| 2026-11-27T19:49:31Z | l-195b4d1393 | duyu-1 | - | - | - | 0.8 | - | 89e67b989b621fa4 |
| 2026-11-27T19:49:33Z | l-4536d4ddef | alania-v2 | alania2-f1 | alania-v2.1 | 8 | 0.96 | d874a11903d74f1d8845328c90182d0e | d0a14d658fd873ec |
| 2026-11-27T19:49:34Z | l-4536d4ddef | duyu-1 | - | - | - | 0.96 | - | d0a14d658fd873ec |
| 2026-11-27T19:49:35Z | l-a50a64ed10 | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 73f3c8e4772d492aa7ef5a0046f20f69 | 125e2ad894bbb5f0 |
| 2026-11-27T19:49:36Z | l-a50a64ed10 | duyu-1 | - | - | - | 1.28 | - | 125e2ad894bbb5f0 |
| 2026-11-27T19:49:38Z | l-308c8f3227 | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.92 | 552f4ff1cbf44bb3bf9e384233ff103e | db672b7bb819657b |
| 2026-11-27T19:49:39Z | l-308c8f3227 | duyu-1 | - | - | - | 1.92 | - | db672b7bb819657b |
| 2026-11-27T19:49:40Z | l-185886c430 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.96 | 7c7a1324fb5941f3ab984ec713272494 | a0d6722ba2301562 |
| 2026-11-27T19:49:41Z | l-185886c430 | duyu-1 | - | - | - | 0.96 | - | a0d6722ba2301562 |
| 2026-11-27T19:49:43Z | l-b6d0e82812 | alania-v2 | alania2-f1 | alania-v2.1 | 8 | 0.8 | 521d3ca976b14e54aef5693ebd5bc705 | 78295b2a65ed3822 |
| 2026-11-27T19:49:44Z | l-b6d0e82812 | duyu-1 | - | - | - | 0.8 | - | 78295b2a65ed3822 |
| 2026-11-27T19:49:45Z | l-063c1a64fa | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 3.04 | 171578cdeaf14eaba70bb3439b4fe34a | 6169b3f2c385cb6f |
| 2026-11-27T19:49:46Z | l-063c1a64fa | duyu-1 | - | - | - | 3.04 | - | 6169b3f2c385cb6f |
| 2026-11-27T19:49:48Z | l-3afdda2c09 | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | f89718cd34b348d9b561e59d2427a8a9 | 50c33073174386bb |
| 2026-11-27T19:49:49Z | l-3afdda2c09 | duyu-1 | - | - | - | 1.28 | - | 50c33073174386bb |
| 2026-11-27T19:49:50Z | l-b5abb6e0ab | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.24 | b95db1fa503a4963a2141ad870724c37 | 92817465ec4837fb |
| 2026-11-27T19:49:51Z | l-b5abb6e0ab | duyu-1 | - | - | - | 2.24 | - | 92817465ec4837fb |
| 2026-11-27T19:49:53Z | l-a2e8979447 | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.08 | bd1d3c25b8ed42b4aa75066e54cfa5e2 | 130fcaac9f8e2fb0 |
| 2026-11-27T19:49:54Z | l-a2e8979447 | duyu-1 | - | - | - | 2.08 | - | 130fcaac9f8e2fb0 |
| 2026-11-27T19:49:56Z | l-de9fc86ae1 | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.92 | 5e32db67a3b3457985157a30307f5c8b | fbed55fe873c86a4 |
| 2026-11-27T19:49:57Z | l-de9fc86ae1 | duyu-1 | - | - | - | 1.92 | - | fbed55fe873c86a4 |
| 2026-11-27T19:49:58Z | l-e74ebc3243 | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.08 | 20edb911f0e048b6964ca987deb520d4 | 642c084a8b94760a |
| 2026-11-27T19:49:59Z | l-e74ebc3243 | duyu-1 | - | - | - | 2.08 | - | 642c084a8b94760a |
| 2026-11-27T19:50:01Z | l-0029ebaf05 | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.92 | 513b103e0eab47778f0b050189eedd57 | 1ae4a8e8097e932f |
| 2026-11-27T19:50:02Z | l-0029ebaf05 | duyu-1 | - | - | - | 1.92 | - | 1ae4a8e8097e932f |
| 2026-11-27T19:50:04Z | l-8203555812 | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.88 | 90ed08ea1a064a8eaf5e558f87d38e9f | 980bfad1802eed6f |
| 2026-11-27T19:50:05Z | l-8203555812 | duyu-1 | - | - | - | 2.88 | - | 980bfad1802eed6f |
| 2026-11-27T19:50:07Z | l-9313cdc81d | alania-v2 | alania2-f1 | alania-v2.1 | 3 | 1.12 | fe2200ed45d14eefa60f1e1b2a493120 | a3cb7fba638e2366 |
| 2026-11-27T19:50:08Z | l-9313cdc81d | duyu-1 | - | - | - | 1.12 | - | a3cb7fba638e2366 |
