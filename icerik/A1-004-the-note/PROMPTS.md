# PROMPTS: A1-004-the-note (üretim, 2026-10-11)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1 (her prompt'un sonuna eklenir).
- **Model:** gpt_image_2_5, 9:16, 2k, quality low.
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok; notlar, mesajlar ve haritadaki yazılar kurguda eklenir.
- **Kullanıcı onayı:** soru-cevap, "Evet, 11,5 kredi" (B2–B4 + Maya referansı).
- **Referanslar:** Alex `663ea0fe…`, Maya `6db4fa91…` (R4), telsiz `74fb45e8…`.

## Görseller

| Ad | Referanslar | Kredi | Job ID | Prompt (STYLE hariç) |
|---|---|---|---|---|
| B4-01-dukkan-sabah | Maya,Alex | 0,5 | 34badcb7-337a-4d61-b25f-b8573870ebf4 | Use the reference images for Maya and Alex. Scene: Monday morning in the cozy book-and-tea shop; Maya at the counter writing in her notebook, Alex arrives holding out her phone with excitement; steam rising from tea cups. Vertical composition. |
| B4-02-telefon-not | Alex | 0,5 | d1cbfa1b-314d-49cd-a14d-6d041c93df53 | Close-up over Alex's shoulder: her hand holds a phone showing a photo of a rain-stained paper note pinned to a wooden door; the note shows only faint blurred smudges, no readable letters. Cozy shop background softly blurred. Vertical composition. |
| B4-03-uc-kart | — | 0,5 | 4f81af42-a1c8-4365-af55-47f36bb9c54c | Top-down view of a wooden table with three small illustrated picture cards side by side: a calendar page with blank squares and no numbers, a small bird inside a cage, and a plate of fried fish. No text on the cards. Vertical composition. |
| B4-04-saat-cizimi | — | 0,5 | e6d08db8-bea4-43f4-906e-899b2cc32a2b | Extreme close-up of the torn corner of a rain-stained paper note: a small hand-drawn clock face without any numbers, the short hand pointing to seven and the long hand pointing to twelve, half washed out by rain. Vertical composition. |
| B4-05-maya-isik | Maya | 0,5 | d6b5e7d9-cce9-4646-a531-f2ac7ad4bea1 | Use the reference image for Maya. Scene: Maya holds a phone up toward the bright shop window, squinting carefully at the screen as if reading faint marks, focused and curious. The screen faces away from the viewer. Vertical composition. |
| B4-06-iskele-harita | — | 0,5 | 140ee4d2-800d-49e0-8cd8-9264bc581f1f | Top-down view of a paper map of a small harbour laid on a wooden table: several numbered piers drawn as simple lines but with no actual numbers or text visible, a pencil and a tea cup at the edge. Vertical composition. |
| B4-07-telsiz-not | Alex,telsiz | 0,5 | be3ed7af-fbf6-4bbd-bf7c-c89acd327227 | Use the reference images for Alex and the old radio. Scene: in the cozy shop, Alex quietly takes the old radio out of her backpack's side pocket; a small yellowed folded paper note slips from the radio into her hand; her face becomes thoughtful and surprised. Vertical composition. |
| B4-08-iki-not | telsiz | 0,5 | 4debe97d-8fb8-4611-985c-68d1858438b6 | Use the reference image for the old radio. Scene: evening, a wooden desk in a small room: two paper notes lie side by side - an old yellowed folded note and a newer rain-stained note - both with only faint illegible marks, no readable letters; the old radio stands behind them, light off; warm lamp light. Vertical composition. |

## Seslendirme

- **Sağlayıcı:** ElevenLabs `eleven_v3` with-timestamps, speed 0.9, `language_code` en/tr.
- **Hesap:** videoGenerator hesabı; ücretsiz plan. **Yalnızca iç kullanım, yayınlanmaz** (H-006).
- **Sesler:** Jessica (Alex), Lily (telsiz), River (Hi), Sarah (Maya).
- **Tüketim:** 33 satır, 1098 karakter.
- **Dosyalar:**
  - `audio/*.mp3` (git dışı) ve `audio/*.align.json`;
  - `audio_manifest.json`: replik → ses kimliği eşlemesi. B1 ile aynı telsiz replikleri B1'in kayıtlarını kullanır.

## B4-01 yeniden üretim (2026-10-11)

- **Sorun:** İlk üretimde (job 34badcb7…, `images/B4-01-dukkan-sabah_v1-hatali.*`) Maya, Alex'in zeytin yeşili ceketiyle çıktı; iki karakter ikiz gibi görünüyordu.
- **Düzeltme:** Prompt'a iki karakterin farklı kıyafetleri açıkça yazıldı. Maya: çizgili kazak + önlük, "NO olive jacket". Alex: zeytin yeşili ceket + sırt çantası.
- **Yeni job:** 684f0cd3-2d34-4306-aa7c-e92e53bb67b9. Tahmin 0,5 / gerçek 0,5.
- **Kullanıcı onayı:** soru-cevap. ✅ Sonuç doğru. **Kredi: 98,25.**
- **Ders:** Birden çok referanslı sahnede karakterlerin ayırt edici kıyafeti prompt'ta açıkça yazılmalı.

## b4_30_maya yeniden seslendirme (H-046, 2026-10-11)

- **Neden:** t-kanit görevindeki Maya repliği "I have Art on Friday. What time is it?" bağlamda belirsizdi ("Şu an saat kaç?" gibi okunuyordu). Kullanıcı kararıyla "I have Art on Friday. What time?" olarak düzeltildi; anlamı "Saat kaçta?". `story.en.md`, `kurgu.json` (prompt.en, item stem), `audio_manifest.json`, `ceviri.tr.json` birlikte güncellendi.
- **Sağlayıcı:** ElevenLabs `eleven_v3` with-timestamps, speed 0.9, `language_code` en; ses Sarah (Maya, `EXAVITQu4vr4xnSDxMaL`), önceki kayıtla aynı ayarlar.
- **Hesap:** videoGenerator hesabı (yerel, iç kullanım; H-006 ek).
- **Çağrı:** 1 TTS çağrısı, **32 karakter**. Metin: `I have Art on Friday. What time?`
- **Çıktı:** `audio/b4_30_maya.mp3` (2,32 sn) + `audio/b4_30_maya.align.json`. Eski dosyalar oturum geçici klasörüne yedeklendi.
- **Kullanıcı onayı:** H-046 soru-cevap.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:03:46Z | b4_21_hi.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.76 | fc4a9100dfee4bea83e5e9be62bec1bc | e26f97cd14cb7587 |
| 2026-10-14T13:03:47Z | b4_21_hi.p1 | duyu-1 | - | - | - | 1.76 | - | e26f97cd14cb7587 |
| 2026-10-14T13:03:48Z | b4_21_hi.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.76 | de596b3dbb8442ddaa35273efec9235e | 0f2d3ae689968c61 |
| 2026-10-14T13:03:48Z | b4_21_hi.p3 | duyu-1 | - | - | - | 1.76 | - | 0f2d3ae689968c61 |
| 2026-10-14T13:03:49Z | b4_21_hi.p5 | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.72 | 10a41173da3a4f48b6de2d7ba331b846 | a835e109f90dd16d |
| 2026-10-14T13:03:50Z | b4_21_hi.p5 | duyu-1 | - | - | - | 2.72 | - | a835e109f90dd16d |
| 2026-10-14T13:03:51Z | b4_21_hi.p7 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 0.96 | 315b7e5d90a24b7e90db10e80dbd7b69 | 229d1697f2ad1899 |
| 2026-10-14T13:03:51Z | b4_21_hi.p7 | duyu-1 | - | - | - | 0.96 | - | 229d1697f2ad1899 |
| 2026-10-14T13:03:56Z | b4_21_hi | alania-v2 | alania2-f1 | alania-v2.1 | 110 | 7.84 | 47f28dde34264f7e91ff656034eea968 | b5ff98effc6e65cf |
| 2026-10-14T13:03:57Z | b4_21_hi | duyu-1 | - | - | - | 7.84 | - | b5ff98effc6e65cf |

## İngilizce ifade seslendirme kayıtları (tts_episode_tr.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 |
|---|---|---|---|---|---|---|
| 2026-10-14T13:04:01Z | b4_21_hi.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | ba57b745b2a21730 |
| 2026-10-14T13:04:02Z | b4_21_hi.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 2 | 582967534d0f909d |
| 2026-10-14T13:04:03Z | b4_21_hi.p6 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 2 | b1d6b91b67c2afa5 |
| 2026-10-14T13:04:04Z | b4_21_hi.p8 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 9 | 5cbe1e0fcc1110ff |
| 2026-10-14T13:05:08Z | b4_01_hi | alania-v2 | alania2-f1 | alania-v2.1 | 62 | 3.68 | 8b53c510342d4889899fbc7e1ce318f3 | bcd2a161d41f9a29 |
| 2026-10-14T13:05:09Z | b4_01_hi | duyu-1 | - | - | - | 3.68 | - | bcd2a161d41f9a29 |
| 2026-10-14T13:05:10Z | b4_11_hi.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 61 | 4.16 | 4bef3011eb1d41ee873190fccf707ffc | 1c58528287355264 |
| 2026-10-14T13:05:11Z | b4_11_hi.p3 | duyu-1 | - | - | - | 4.16 | - | 1c58528287355264 |
| 2026-10-14T13:05:12Z | b4_14_hi.p2 | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.6 | 0c5f604c91544520ae47a1ad546c29fd | 47ad698d387a13bd |
| 2026-10-14T13:05:13Z | b4_14_hi.p2 | duyu-1 | - | - | - | 1.6 | - | 47ad698d387a13bd |
| 2026-10-14T13:05:14Z | b4_14_hi.p4 | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | fc95137effc04824a622e60c71c26745 | 380537d14d7f5b4b |
| 2026-10-14T13:05:14Z | b4_14_hi.p4 | duyu-1 | - | - | - | 1.44 | - | 380537d14d7f5b4b |
| 2026-10-14T13:05:15Z | b4_29_hi.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.96 | 6d87c9ff880b4a2b810eba65b6a6d7e2 | c12d8894a77d25a9 |
| 2026-10-14T13:05:15Z | b4_29_hi.p1 | duyu-1 | - | - | - | 0.96 | - | c12d8894a77d25a9 |
| 2026-10-14T13:05:16Z | b4_29_hi.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 0.96 | 5a1e2cb34e2d44ccaf5f61595c161fa2 | cd8b039ded6eb9a3 |
| 2026-10-14T13:05:17Z | b4_29_hi.p3 | duyu-1 | - | - | - | 0.96 | - | cd8b039ded6eb9a3 |
| 2026-10-14T13:05:17Z | b4_29_hi.p5 | alania-v2 | alania2-f1 | alania-v2.1 | 1 | 0.16 | bd53cb96ffdc471abd0f0e4c8acadc24 | e7ac0786668e0ff0 |
| 2026-10-14T13:05:17Z | b4_29_hi.p5 | duyu-1 | - | - | - | 0.16 | - | e7ac0786668e0ff0 |
| 2026-10-14T13:05:18Z | b4_29_hi.p7 | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.88 | d5cf699d03f44f979d7c8c4d431f5465 | 089c13531ff3508b |
| 2026-10-14T13:05:19Z | b4_29_hi.p7 | duyu-1 | - | - | - | 2.88 | - | 089c13531ff3508b |
| 2026-10-14T13:05:20Z | b4_29_hi.p9 | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 1.12 | f537d438792247bda19685061895c481 | 48542bd05e95cf41 |
| 2026-10-14T13:05:21Z | b4_29_hi.p9 | duyu-1 | - | - | - | 1.12 | - | 48542bd05e95cf41 |
| 2026-10-14T13:05:21Z | b4_33_hi.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | 7a566d90a9314786b54969d67d62c809 | 24c04ac897e9c6d3 |
| 2026-10-14T13:05:22Z | b4_33_hi.p1 | duyu-1 | - | - | - | 1.28 | - | 24c04ac897e9c6d3 |
| 2026-10-14T13:05:24Z | tr_c-nermin | alania-v2 | alania2-selin | alania-v2.1 | 39 | 4.6 | 652f9fd7fa9b4af68d34d028b30611ab | 63bf23caafb5f5dd |
| 2026-10-14T13:05:24Z | tr_c-nermin | duyu-1 | - | - | - | 4.6 | - | 63bf23caafb5f5dd |
| 2026-10-14T13:05:26Z | tr_c-alex | alania-v2 | alania2-nisa | alania-v2.1 | 50 | 4.0 | 8fd690da4b4c40f6ab58a68d0c6b110b | b298ec57e6d9b3c8 |
| 2026-10-14T13:05:27Z | tr_c-alex | duyu-1 | - | - | - | 4.0 | - | b298ec57e6d9b3c8 |
| 2026-10-14T13:05:28Z | tr_c-clues.p1 | alania-v2 | alania2-m1 | alania-v2.1 | 30 | 3.04 | 3185233febdb42df98be93d59e3d4d66 | d061349f0d95dcf8 |
| 2026-10-14T13:05:29Z | tr_c-clues.p1 | duyu-1 | - | - | - | 3.04 | - | d061349f0d95dcf8 |
| 2026-10-14T13:05:30Z | tr_c-clues.p3 | alania-v2 | alania2-m1 | alania-v2.1 | 51 | 4.0 | 39c6e15955cb44df8b25278e9fe5e38c | cc62b3da9697e217 |
| 2026-10-14T13:05:31Z | tr_c-clues.p3 | duyu-1 | - | - | - | 4.0 | - | cc62b3da9697e217 |
| 2026-10-14T13:05:32Z | tr_c-oq | alania-v2 | alania2-m1 | alania-v2.1 | 49 | 3.68 | 5d874405776045d9a8363f99c3e8a368 | 1950544aaffefd2e |
| 2026-10-14T13:05:33Z | tr_c-oq | duyu-1 | - | - | - | 3.68 | - | 1950544aaffefd2e |
| 2026-10-14T13:07:08Z | b4_11_hi.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 7 | edd7595534b124d7 |
| 2026-10-14T13:07:09Z | b4_14_hi.p1 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 4 | 0aca6630d95b1a64 |
| 2026-10-14T13:07:10Z | b4_14_hi.p5 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | cfd82b38bf4a0426 |
| 2026-10-14T13:07:11Z | b4_29_hi.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 2 | b8d31e852725afb1 |
| 2026-10-14T13:07:13Z | b4_29_hi.p6 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 33fff6e793f21916 |
| 2026-10-14T13:07:14Z | b4_29_hi.p8 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 8 | ffcede063ab06de8 |
| 2026-10-14T13:07:15Z | b4_33_hi.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | 6e25153f233d13e6 |
| 2026-10-14T13:07:16Z | tr_c-clues.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | 440330356b9b62b2 |
| 2026-11-27T19:50:09Z | l-ce9c654187 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 0.96 | 0a41a26da8394eafaab929d331557719 | a7acbd804d7d4838 |
| 2026-11-27T19:50:10Z | l-ce9c654187 | duyu-1 | - | - | - | 0.96 | - | a7acbd804d7d4838 |
| 2026-11-27T19:50:12Z | l-c42e1e4ac7 | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | fab538c01b0d4d17b2a51867066bb0f5 | 8416791e4b81306a |
| 2026-11-27T19:50:13Z | l-c42e1e4ac7 | duyu-1 | - | - | - | 1.6 | - | 8416791e4b81306a |
| 2026-11-27T19:50:14Z | l-ed73d15de9 | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 1.28 | ff6c1c93adee49dd9618afbe6ebbec99 | a91d8539e8c1270b |
| 2026-11-27T19:50:15Z | l-ed73d15de9 | duyu-1 | - | - | - | 1.28 | - | a91d8539e8c1270b |
| 2026-11-27T19:50:17Z | l-2673398073 | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.72 | e2bd92d0d2514ce5aae017786029e4e0 | 5668a91e6db97257 |
| 2026-11-27T19:50:18Z | l-2673398073 | duyu-1 | - | - | - | 2.72 | - | 5668a91e6db97257 |
| 2026-11-27T19:50:19Z | l-cec66bcc5e | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 1.28 | 985f3e7467014b778211356879a25a23 | 3b2415bb5d80ba2e |
| 2026-11-27T19:50:20Z | l-cec66bcc5e | duyu-1 | - | - | - | 1.28 | - | 3b2415bb5d80ba2e |
| 2026-11-27T19:50:22Z | l-cc929e32b3 | alania-v2 | alania2-f1 | alania-v2.1 | 8 | 0.96 | df0d9d18c3264f2787fdbc191d59cb3d | 6986181c091ca495 |
| 2026-11-27T19:50:23Z | l-cc929e32b3 | duyu-1 | - | - | - | 0.96 | - | 6986181c091ca495 |
| 2026-11-27T19:50:24Z | l-4603d12355 | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.76 | 3a16eec2f4814cb59322de595b725b82 | e77217f459fed063 |
| 2026-11-27T19:50:25Z | l-4603d12355 | duyu-1 | - | - | - | 1.76 | - | e77217f459fed063 |
| 2026-11-27T19:50:27Z | l-5c67643290 | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | 095adf39d63141afa0d86c3cd3238ab3 | 3332758b80356f83 |
| 2026-11-27T19:50:28Z | l-5c67643290 | duyu-1 | - | - | - | 1.44 | - | 3332758b80356f83 |
| 2026-11-27T19:50:29Z | l-499e0c1bfc | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.28 | 92d961d310044d58b922a1fa7d40b312 | b6fa931a34f6a5f3 |
| 2026-11-27T19:50:30Z | l-499e0c1bfc | duyu-1 | - | - | - | 1.28 | - | b6fa931a34f6a5f3 |
| 2026-11-27T19:50:32Z | l-61dcba5347 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.44 | 80c7d3f01347407ab27f34ea7a9078a0 | e6996b2490d46af6 |
| 2026-11-27T19:50:33Z | l-61dcba5347 | duyu-1 | - | - | - | 1.44 | - | e6996b2490d46af6 |
| 2026-11-27T19:50:35Z | l-bd3e6a6ae6 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 2.08 | 4010f11c205b4467a4d7f91b445bbf35 | 1639ed267a778478 |
| 2026-11-27T19:50:36Z | l-bd3e6a6ae6 | duyu-1 | - | - | - | 2.08 | - | 1639ed267a778478 |
| 2026-11-27T19:50:37Z | l-edd7595534 | alania-v2 | alania2-f1 | alania-v2.1 | 5 | 1.12 | 76175a1f2edf451283071a167ee0c770 | a2bdef514d9459cd |
| 2026-11-27T19:50:38Z | l-edd7595534 | duyu-1 | - | - | - | 1.12 | - | a2bdef514d9459cd |
| 2026-11-27T19:50:40Z | l-5a9e526640 | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 3.36 | cd9f1c1bdd9d44eaae316750c9b7548d | 669a86e074bba4c6 |
| 2026-11-27T19:50:41Z | l-5a9e526640 | duyu-1 | - | - | - | 3.36 | - | 669a86e074bba4c6 |
| 2026-11-27T19:50:43Z | l-47f707a2f6 | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 2.08 | 32d484589e83430084fc40284ba87374 | 9e72789dc64cfae6 |
| 2026-11-27T19:50:44Z | l-47f707a2f6 | duyu-1 | - | - | - | 2.08 | - | 9e72789dc64cfae6 |
| 2026-11-27T19:50:46Z | l-d67c54503e | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | c7e2b0670422401694627e8730bc5879 | 8126e9a4ad980e2c |
| 2026-11-27T19:50:46Z | l-d67c54503e | duyu-1 | - | - | - | 1.44 | - | 8126e9a4ad980e2c |
| 2026-11-27T19:50:48Z | l-cfdd303b1a | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.56 | 49fd9739d73c4f3c870d0c3a3bef4d14 | c27efafe74daa235 |
| 2026-11-27T19:50:49Z | l-cfdd303b1a | duyu-1 | - | - | - | 2.56 | - | c27efafe74daa235 |
| 2026-11-27T19:50:51Z | l-c9f669e433 | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.44 | e22dfb4926f846619e63a11b3abd072e | e47d015a35aa1ca5 |
| 2026-11-27T19:50:52Z | l-c9f669e433 | duyu-1 | - | - | - | 1.44 | - | e47d015a35aa1ca5 |
| 2026-11-27T19:50:54Z | l-7b56dd85eb | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.6 | 4adb52ca168045a0a1e859ca4823443a | a77b8af01bed9366 |
| 2026-11-27T19:50:54Z | l-7b56dd85eb | duyu-1 | - | - | - | 1.6 | - | a77b8af01bed9366 |
| 2026-11-27T19:50:56Z | l-729ace06f8 | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.44 | 9fb60d4a24d54f068e48647c9f1646d3 | 6be744361648c3b2 |
| 2026-11-27T19:50:57Z | l-729ace06f8 | duyu-1 | - | - | - | 1.44 | - | 6be744361648c3b2 |
| 2026-11-27T19:50:59Z | l-09a8f386b0 | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 2.08 | d6d34cda9e784decab0e35e3ef672ad2 | b708eaecbf9eda25 |
| 2026-11-27T19:51:00Z | l-09a8f386b0 | duyu-1 | - | - | - | 2.08 | - | b708eaecbf9eda25 |
| 2026-11-27T19:51:01Z | l-a5c90e6a96 | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.6 | 2f57a69c3751493a8133cb7e4e443a8d | 051f09d351d4d769 |
| 2026-11-27T19:51:02Z | l-a5c90e6a96 | duyu-1 | - | - | - | 1.6 | - | 051f09d351d4d769 |
| 2026-11-27T19:51:04Z | l-cd61bf0cc6 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.28 | 32e74d94212e41b0a33a914b867d35ac | 0452ceadda5b16d2 |
| 2026-11-27T19:51:05Z | l-cd61bf0cc6 | duyu-1 | - | - | - | 1.28 | - | 0452ceadda5b16d2 |
| 2026-11-27T19:51:07Z | l-0fb95a7949 | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.08 | d1033821c9234acbb1d4494345cef29c | 837174232151cd90 |
| 2026-11-27T19:51:08Z | l-0fb95a7949 | duyu-1 | - | - | - | 2.08 | - | 837174232151cd90 |
| 2026-11-27T19:51:09Z | l-ba57b745b2 | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 1.28 | 5985ad1018754bbe8277ea310aaf9552 | 97723f868655f3a3 |
| 2026-11-27T19:51:10Z | l-ba57b745b2 | duyu-1 | - | - | - | 1.28 | - | 97723f868655f3a3 |
| 2026-11-27T19:51:12Z | l-5edce0c9c1 | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 4.32 | 142ce6354fcc4e68aa0db9d8f7db1d96 | 9f477c784390fb45 |
| 2026-11-27T19:51:13Z | l-5edce0c9c1 | duyu-1 | - | - | - | 4.32 | - | 9f477c784390fb45 |
| 2026-11-27T19:51:15Z | l-0304e07f91 | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 2.08 | 27601c0323234768a0a6190ce51f11e3 | 75deae3d180ae897 |
| 2026-11-27T19:51:16Z | l-0304e07f91 | duyu-1 | - | - | - | 2.08 | - | 75deae3d180ae897 |
| 2026-11-27T19:51:18Z | l-bcf9b67eee | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.92 | c8468bf2b578489180469b386f25880a | cc0fac2a094aa8be |
| 2026-11-27T19:51:19Z | l-bcf9b67eee | duyu-1 | - | - | - | 1.92 | - | cc0fac2a094aa8be |
| 2026-11-27T19:51:20Z | l-e3b7b1e517 | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 2.08 | 2ccfb72d94e34322a822efdb1221dad4 | d8790657afcb87ba |
| 2026-11-27T19:51:21Z | l-e3b7b1e517 | duyu-1 | - | - | - | 2.08 | - | d8790657afcb87ba |
| 2026-11-27T19:51:23Z | l-5d64d3dc6e | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.6 | d293065151e54737b1b1681c69abd747 | af4c5c88fcd2c56b |
| 2026-11-27T19:51:24Z | l-5d64d3dc6e | duyu-1 | - | - | - | 1.6 | - | af4c5c88fcd2c56b |
| 2026-11-27T19:51:26Z | l-668e44e22c | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.92 | 870531ecea1747bf85145eff360ced21 | ae2a1bf1c9b70bfa |
| 2026-11-27T19:51:26Z | l-668e44e22c | duyu-1 | - | - | - | 1.92 | - | ae2a1bf1c9b70bfa |
| 2026-11-27T19:51:28Z | l-c4e435885d | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.72 | 24bea4112416434099b3ae8b642a8d02 | 78191d6a9862e4d5 |
| 2026-11-27T19:51:29Z | l-c4e435885d | duyu-1 | - | - | - | 2.72 | - | 78191d6a9862e4d5 |
| 2026-11-27T19:51:31Z | l-72c105d51d | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.72 | c0aef46c100f4223b3f97b500aae032d | b19058a92dd1c17c |
| 2026-11-27T19:51:32Z | l-72c105d51d | duyu-1 | - | - | - | 2.72 | - | b19058a92dd1c17c |
| 2026-11-27T19:51:33Z | l-b683b26fc7 | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 2.08 | 87f634c2878e4caeb0e3969eb220ef89 | 4c3c49802664aafe |
| 2026-11-27T19:51:34Z | l-b683b26fc7 | duyu-1 | - | - | - | 2.08 | - | 4c3c49802664aafe |
| 2026-11-27T19:51:36Z | l-956fe1a359 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 2.4 | 264ec15f95554de4b82865cb7dc056fb | 6d397670d8a14661 |
| 2026-11-27T19:51:37Z | l-956fe1a359 | duyu-1 | - | - | - | 2.4 | - | 6d397670d8a14661 |
| 2026-11-27T19:51:39Z | l-8569efc4ed | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | 7bd2709dc41c4141be7fae40ab6f2ea4 | 023a1e9c9eb3efac |
| 2026-11-27T19:51:40Z | l-8569efc4ed | duyu-1 | - | - | - | 1.28 | - | 023a1e9c9eb3efac |
| 2026-11-27T19:51:41Z | l-143dca3f66 | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.24 | bb88e024417346358fe66d494d6fa633 | 39e27fb192644dae |
| 2026-11-27T19:51:42Z | l-143dca3f66 | duyu-1 | - | - | - | 2.24 | - | 39e27fb192644dae |
| 2026-11-27T19:51:44Z | l-31de8faa90 | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 2.24 | ec78d15dff8b47acbf021fa8520bf0fb | 18357ca65986d0f9 |
| 2026-11-27T19:51:45Z | l-31de8faa90 | duyu-1 | - | - | - | 2.24 | - | 18357ca65986d0f9 |
| 2026-11-27T19:51:46Z | l-744e2676ad | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.44 | 1b3893befcaa428ca50b5346ed568efb | 10a8df30c8ea22d1 |
| 2026-11-27T19:51:47Z | l-744e2676ad | duyu-1 | - | - | - | 1.44 | - | 10a8df30c8ea22d1 |
