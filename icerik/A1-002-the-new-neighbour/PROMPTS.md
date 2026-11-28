# PROMPTS: A1-002-the-new-neighbour (üretim, 2026-10-11)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1 (her prompt'un sonuna eklenir).
- **Model:** gpt_image_2_5, 9:16, 2k, quality low.
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok; notlar, mesajlar ve haritadaki yazılar kurguda eklenir.
- **Kullanıcı onayı:** soru-cevap, "Evet, 11,5 kredi" (B2–B4 + Maya referansı).
- **Referanslar:** Alex `663ea0fe…`, Maya `6db4fa91…` (R4), telsiz `74fb45e8…`.

## Görseller

| Ad | Referanslar | Kredi | Job ID | Prompt (STYLE hariç) |
|---|---|---|---|---|
| B2-01-dukkan-dis | — | 0,5 | b8d39d0b-e619-43d8-87bd-d76955dce9f8 | Morning in a quiet harbour street of a coastal town: the front of a small cozy shop with a large window full of stacked books and tea cups, a wooden door with a small bell, potted plants, soft morning light, nobody outside. No sign text. Vertical composition. |
| B2-02-maya-tezgah | Maya | 0,5 | 51fc6157-b427-457f-ac8d-8e6c2b44dd12 | Use the reference image for Maya; keep the same face, curly hair and clothes but she wears a simple apron over her sweater. Scene: inside a cozy book-and-tea shop in the morning, Maya stands behind the wooden counter and looks up with a warm, welcoming smile, as if a customer just came in; shelves of books, tea jars, warm light. Vertical composition. |
| B2-03-maya-pov | Maya,Alex | 0,5 | 56383b2c-703b-4f7b-95ac-0909192dbc48 | Use the reference images for Maya and Alex. First-person view from Alex, standing at the shop counter: Maya smiles and offers a friendly hand to shake; Alex's hand with olive jacket sleeve enters the frame. Cozy book-and-tea shop, morning light, background softly blurred. Vertical composition. |
| B2-04-anne-foto | Maya | 0,5 | 26d1a6c2-2b43-439a-a345-e071d55b75e8 | Use the reference image for Maya. Scene: in the cozy shop, Maya points at a framed photo on the wall: the photo shows Maya and a teenage boy with glasses and headphones around his neck, both smiling. Next to Maya stands her mother, a kind woman in her late forties with curly greying hair and an apron, smiling. No text. Vertical composition. |
| B2-05-maya-sasirma | Maya | 0,5 | bf622335-59ca-4cde-a4f4-f4b8f6c06138 | Use the reference image for Maya. Scene: Maya behind the shop counter tilts her head with a gentle, puzzled smile, trying to understand a customer, one eyebrow raised, friendly and patient, not mocking. Cozy shop, morning light. Vertical composition. |
| B2-06-maya-harita | Maya,Alex | 0,5 | 5639593d-bab4-4f17-88ee-e38d3e49013a | Use the reference images for Maya and Alex. Scene: at the shop counter Maya unfolds a large paper map of the coastal town and draws a circle around the harbour area with a pencil; Alex leans in, curious and hopeful. The map shows streets, piers and the sea, with no labels and no text. Vertical composition. |
| B2-07-oda-harita | Alex,telsiz | 0,5 | 034ff5f4-4fa9-4183-a73b-bcf992b7053f | Use the reference images for Alex and the old radio. Scene: evening in Alex's small rented room; Alex sits at the desk looking thoughtfully at a paper map with a pencil circle around the harbour; the old radio on the desk beside her, light off; window shows the harbour at dusk. Map has no text. Vertical composition. |

## Seslendirme

- **Sağlayıcı:** ElevenLabs `eleven_v3` with-timestamps, speed 0.9, `language_code` en/tr.
- **Hesap:** videoGenerator hesabı; ücretsiz plan. **Yalnızca iç kullanım, yayınlanmaz** (H-006).
- **Sesler:** Alice (Mrs Brooks), Jessica (Alex), Lily (telsiz), River (Hi), Sarah (Maya).
- **Tüketim:** 29 satır, 812 karakter.
- **Dosyalar:**
  - `audio/*.mp3` (git dışı) ve `audio/*.align.json`;
  - `audio_manifest.json`: replik → ses kimliği eşlemesi. B1 ile aynı telsiz replikleri B1'in kayıtlarını kullanır.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:03:42Z | b2_17_hi.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.44 | b9ecfc31daf644efa3f055776bc5fc53 | e26f97cd14cb7587 |
| 2026-10-14T13:03:43Z | b2_17_hi.p1 | duyu-1 | - | - | - | 1.44 | - | e26f97cd14cb7587 |
| 2026-10-14T13:03:44Z | b2_17_hi.p4 | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.92 | 8cb07329d2d04029aa86c38e8267ed8e | b2f309b3d7a9ea66 |
| 2026-10-14T13:03:45Z | b2_17_hi.p4 | duyu-1 | - | - | - | 1.92 | - | b2f309b3d7a9ea66 |
| 2026-10-14T13:03:53Z | b2_17_hi | alania-v2 | alania2-f1 | alania-v2.1 | 96 | 6.56 | 4796fb891d79460c8c04bd24929fc41c | d13e694c218b14a6 |
| 2026-10-14T13:03:54Z | b2_17_hi | duyu-1 | - | - | - | 6.56 | - | d13e694c218b14a6 |

## İngilizce ifade seslendirme kayıtları (tts_episode_tr.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 |
|---|---|---|---|---|---|---|
| 2026-10-14T13:03:59Z | b2_17_hi.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 36 | 0ed10ff0338dbc20 |
| 2026-10-14T13:03:59Z | b2_17_hi.p3 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 9 | f868adba71dd145e |
| 2026-10-14T13:04:46Z | tr_c-alex | alania-v2 | alania2-nisa | alania-v2.1 | 40 | 2.56 | 2d6d9c447ee641cb8192a631790a1372 | 1ffbe11aef016470 |
| 2026-10-14T13:04:47Z | tr_c-alex | duyu-1 | - | - | - | 2.56 | - | 1ffbe11aef016470 |
| 2026-10-14T13:04:49Z | tr_c-clues | alania-v2 | alania2-m1 | alania-v2.1 | 95 | 8.32 | 347b429e7d4248bd9252ad999d3e5a61 | 332163a12f9bf9bf |
| 2026-10-14T13:04:50Z | tr_c-clues | duyu-1 | - | - | - | 8.32 | - | 332163a12f9bf9bf |
| 2026-10-14T13:04:52Z | tr_c-oq | alania-v2 | alania2-m1 | alania-v2.1 | 59 | 4.32 | e25db17518294df7b496235bc6b3f57d | 88dd7444b298e3fc |
| 2026-10-14T13:04:53Z | tr_c-oq | duyu-1 | - | - | - | 4.32 | - | 88dd7444b298e3fc |
| 2026-11-27T19:47:32Z | l-9242eb956c | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.08 | c9ecad841ec7401fa1dfb9937b4ce8b3 | 8dbedf2a05d0f4a1 |
| 2026-11-27T19:47:33Z | l-9242eb956c | duyu-1 | - | - | - | 2.08 | - | 8dbedf2a05d0f4a1 |
| 2026-11-27T19:47:34Z | l-c9ebfb6f4b | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.96 | bb17f197e3824127952a648166ddcad4 | c189b308c306aa3e |
| 2026-11-27T19:47:35Z | l-c9ebfb6f4b | duyu-1 | - | - | - | 0.96 | - | c189b308c306aa3e |
| 2026-11-27T19:47:36Z | l-1f24795de9 | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.44 | 51d9cf83b87e455d8c64946b7d5f20f6 | e7e4928c72b8e478 |
| 2026-11-27T19:47:37Z | l-1f24795de9 | duyu-1 | - | - | - | 1.44 | - | e7e4928c72b8e478 |
| 2026-11-27T19:47:39Z | l-3d4bf06b51 | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.4 | 62d2e6fc819446d5a906aa942d29b963 | 1ff16bbd5396bcf4 |
| 2026-11-27T19:47:40Z | l-3d4bf06b51 | duyu-1 | - | - | - | 2.4 | - | 1ff16bbd5396bcf4 |
| 2026-11-27T19:47:42Z | l-39954823f7 | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 1.76 | eaf1c430fad741a5b255dcd0ab5636f9 | 63ac259a8b4ba322 |
| 2026-11-27T19:47:43Z | l-39954823f7 | duyu-1 | - | - | - | 1.76 | - | 63ac259a8b4ba322 |
| 2026-11-27T19:47:44Z | l-85079ba188 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.28 | 0ac77ee932934499bc0aee98469579b7 | 68268f28e9b1bec6 |
| 2026-11-27T19:47:45Z | l-85079ba188 | duyu-1 | - | - | - | 1.28 | - | 68268f28e9b1bec6 |
| 2026-11-27T19:47:47Z | l-8e5ef5de10 | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.92 | ffbcf3626fe84a89b3a51a7f20171ab8 | c52681e4ce755318 |
| 2026-11-27T19:47:47Z | l-8e5ef5de10 | duyu-1 | - | - | - | 1.92 | - | c52681e4ce755318 |
| 2026-11-27T19:47:49Z | l-ce9c654187 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.28 | 47e63dfc308c4e459271a58e19c23f7a | a7acbd804d7d4838 |
| 2026-11-27T19:47:50Z | l-ce9c654187 | duyu-1 | - | - | - | 1.28 | - | a7acbd804d7d4838 |
| 2026-11-27T19:47:51Z | l-98e0da9a30 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.96 | 075fae9b6dfe4c16b7314cb16900abfc | fddf0fb40750917d |
| 2026-11-27T19:47:52Z | l-98e0da9a30 | duyu-1 | - | - | - | 0.96 | - | fddf0fb40750917d |
| 2026-11-27T19:47:54Z | l-40823c4d63 | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.24 | 612be8c624cc4835a04a4aad270f9b7f | 26f979a9e4d9443b |
| 2026-11-27T19:47:55Z | l-40823c4d63 | duyu-1 | - | - | - | 2.24 | - | 26f979a9e4d9443b |
| 2026-11-27T19:47:57Z | l-cd3edde18a | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.92 | b507c9772e414b038af3874f7a7d8642 | 731264d225f1dfc3 |
| 2026-11-27T19:47:58Z | l-cd3edde18a | duyu-1 | - | - | - | 1.92 | - | 731264d225f1dfc3 |
| 2026-11-27T19:47:59Z | l-9f6dcf6d31 | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.6 | 1a9321baa21b40969f092b6b0118e4a5 | 0bbda99fcd6fbf57 |
| 2026-11-27T19:48:00Z | l-9f6dcf6d31 | duyu-1 | - | - | - | 1.6 | - | 0bbda99fcd6fbf57 |
| 2026-11-27T19:48:02Z | l-63265a7977 | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 1.28 | 621da6d13f49465a86d33bd62b2dc813 | 5c7133643ad9afb4 |
| 2026-11-27T19:48:03Z | l-63265a7977 | duyu-1 | - | - | - | 1.28 | - | 5c7133643ad9afb4 |
| 2026-11-27T19:48:04Z | l-d7b06372bc | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.12 | c47816eb1a1d478ab0f6cd3354e23702 | e01ddf713ad47af8 |
| 2026-11-27T19:48:05Z | l-d7b06372bc | duyu-1 | - | - | - | 1.12 | - | e01ddf713ad47af8 |
| 2026-11-27T19:48:07Z | l-f9761bf0b7 | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 0.96 | df391070bfb14c99961a9251df298154 | a4e0f27762f28653 |
| 2026-11-27T19:48:07Z | l-f9761bf0b7 | duyu-1 | - | - | - | 0.96 | - | a4e0f27762f28653 |
| 2026-11-27T19:48:09Z | l-1d0fc6da40 | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | d5641d63991147e6b100581a3683c975 | 2e30904a1d4dc147 |
| 2026-11-27T19:48:10Z | l-1d0fc6da40 | duyu-1 | - | - | - | 2.24 | - | 2e30904a1d4dc147 |
| 2026-11-27T19:48:11Z | l-6a56a44616 | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.76 | 47a7cf82929f4536a3dcca8e612822f9 | 5249911821ef9ace |
| 2026-11-27T19:48:12Z | l-6a56a44616 | duyu-1 | - | - | - | 1.76 | - | 5249911821ef9ace |
| 2026-11-27T19:48:14Z | l-3edb60c0ee | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.12 | 2de58e0d48b04012b9eac6f227938448 | c81c12e4217493a6 |
| 2026-11-27T19:48:15Z | l-3edb60c0ee | duyu-1 | - | - | - | 1.12 | - | c81c12e4217493a6 |
| 2026-11-27T19:48:16Z | l-f30b255e33 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.12 | 1b0cf354b37945e680b1a8efc4b48a75 | c00f0b86ef8f5bbd |
| 2026-11-27T19:48:17Z | l-f30b255e33 | duyu-1 | - | - | - | 1.12 | - | c00f0b86ef8f5bbd |
| 2026-11-27T19:48:19Z | l-93a837aaf6 | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.44 | 42ecba4b5dc443a5852a6193d7cdbba8 | f6c79ee85ea16a08 |
| 2026-11-27T19:48:20Z | l-93a837aaf6 | duyu-1 | - | - | - | 1.44 | - | f6c79ee85ea16a08 |
| 2026-11-27T19:48:21Z | l-4d2f4d0dc8 | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | 68a1c4256f0b4b6bb3447e4eb08a7732 | dba937e5813ed15e |
| 2026-11-27T19:48:22Z | l-4d2f4d0dc8 | duyu-1 | - | - | - | 1.6 | - | dba937e5813ed15e |
| 2026-11-27T19:48:24Z | l-0ed10ff033 | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.56 | aa9d0987cb0b401fb53c8d378896bbe4 | 97104da328fa18cf |
| 2026-11-27T19:48:25Z | l-0ed10ff033 | duyu-1 | - | - | - | 2.56 | - | 97104da328fa18cf |
| 2026-11-27T19:48:27Z | l-6f21fcad7b | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.24 | ab0162fef2984cfebdfb1ce9f377e9f1 | d9e02d9f1e2d9e7a |
| 2026-11-27T19:48:28Z | l-6f21fcad7b | duyu-1 | - | - | - | 2.24 | - | d9e02d9f1e2d9e7a |
| 2026-11-27T19:48:29Z | l-4ca57df528 | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.88 | 4ae613114ba24368a75848d412bf5fd3 | acd6eb014cc2c766 |
| 2026-11-27T19:48:30Z | l-4ca57df528 | duyu-1 | - | - | - | 2.88 | - | acd6eb014cc2c766 |
| 2026-11-27T19:48:32Z | l-32e6c89e4c | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.6 | 4555dc3e3bb94e0587d90cb87a9a49a9 | cb185e2c9d5ab53e |
| 2026-11-27T19:48:33Z | l-32e6c89e4c | duyu-1 | - | - | - | 1.6 | - | cb185e2c9d5ab53e |
| 2026-11-27T19:48:34Z | l-e978ece38a | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.44 | b979846111304e7d83e1db9555249180 | 2ace6e784dca5fd2 |
| 2026-11-27T19:48:35Z | l-e978ece38a | duyu-1 | - | - | - | 1.44 | - | 2ace6e784dca5fd2 |
| 2026-11-27T19:48:37Z | l-4aefa82633 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.12 | 5cb2707cf9db456588b3f2bc5696a597 | b06123f84fe8e7fd |
| 2026-11-27T19:48:38Z | l-4aefa82633 | duyu-1 | - | - | - | 1.12 | - | b06123f84fe8e7fd |
| 2026-11-27T19:48:39Z | l-ae3d5216f7 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.96 | 6f1b7a0f92dc4679994f691cf250ecce | c3b5440e5c82bc93 |
| 2026-11-27T19:48:40Z | l-ae3d5216f7 | duyu-1 | - | - | - | 0.96 | - | c3b5440e5c82bc93 |
| 2026-11-27T19:48:42Z | l-11f6263af6 | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.4 | ca34214f29f342f0ab991200fb7bba94 | ad0d8333c1cea327 |
| 2026-11-27T19:48:43Z | l-11f6263af6 | duyu-1 | - | - | - | 2.4 | - | ad0d8333c1cea327 |
| 2026-11-27T19:48:45Z | l-c01b6222de | alania-v2 | alania2-f1 | alania-v2.1 | 7 | 0.96 | 2896c127cbce41bab8b2ac7499163a05 | cd20631c5a36c36c |
| 2026-11-27T19:48:46Z | l-c01b6222de | duyu-1 | - | - | - | 0.96 | - | cd20631c5a36c36c |
| 2026-11-27T19:48:47Z | l-4b5889356e | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 1.28 | 949ec54116554fe9ad44d8a99623e6da | be4512f2d52d4189 |
| 2026-11-27T19:48:48Z | l-4b5889356e | duyu-1 | - | - | - | 1.28 | - | be4512f2d52d4189 |
| 2026-11-27T19:48:49Z | l-96ff2ce28b | alania-v2 | alania2-f1 | alania-v2.1 | 8 | 0.8 | 84e9c2528dc24000820272cd97eeb1da | 78ac210e866afaec |
| 2026-11-27T19:48:50Z | l-96ff2ce28b | duyu-1 | - | - | - | 0.8 | - | 78ac210e866afaec |
| 2026-11-27T19:48:51Z | l-503cc25569 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.6 | 81c90f372c4445509e6be982231a63cc | 3f1287eed08b3c19 |
| 2026-11-27T19:48:52Z | l-503cc25569 | duyu-1 | - | - | - | 1.6 | - | 3f1287eed08b3c19 |
| 2026-11-27T19:48:54Z | l-5bf49a4a8b | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.44 | c8909705ef134bc7aa92dc5a7706afee | dfa3aa7281c8c4d8 |
| 2026-11-27T19:48:55Z | l-5bf49a4a8b | duyu-1 | - | - | - | 1.44 | - | dfa3aa7281c8c4d8 |
| 2026-11-27T19:48:57Z | l-8203555812 | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.08 | 5a7e02356b904587983be0d8a32362a8 | 980bfad1802eed6f |
| 2026-11-27T19:48:58Z | l-8203555812 | duyu-1 | - | - | - | 2.08 | - | 980bfad1802eed6f |
| 2026-11-27T19:48:59Z | l-446a7b646e | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.6 | ebcc63371f964aca939c221a7876d154 | 8f8fdda98985e1aa |
| 2026-11-27T19:49:01Z | l-446a7b646e | duyu-1 | - | - | - | 1.6 | - | 8f8fdda98985e1aa |
| 2026-11-27T19:49:02Z | l-8569efc4ed | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | 7fd7e14c028f458db2aabd8a147f4311 | 4083df5f0438bbdf |
| 2026-11-27T19:49:03Z | l-8569efc4ed | duyu-1 | - | - | - | 1.44 | - | 4083df5f0438bbdf |
| 2026-11-27T19:49:05Z | l-fe15a8f5c3 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.12 | c09efb6313d34edbbd72c4b036f39fb6 | b5e3632c5c5aab87 |
| 2026-11-27T19:49:06Z | l-fe15a8f5c3 | duyu-1 | - | - | - | 1.12 | - | b5e3632c5c5aab87 |
| 2026-11-27T19:49:07Z | p-970ff26026 | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.92 | 42614ee9111f4116a0a897d27658e264 | 7f45e608d5e683f8 |
| 2026-11-27T19:49:08Z | p-970ff26026 | duyu-1 | - | - | - | 1.92 | - | 7f45e608d5e683f8 |
