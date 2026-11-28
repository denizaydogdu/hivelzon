# G-C2-05-cohesion-discourse PROMPTS

Ders: Bağdaşıklık ve söylem belirleyicileri (cohesion and discourse markers) · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: önceki dalgaların dersleri (`G-B2-01-passive`, `G-B1-01-present-perfect-experience`, `G-A2-04-past-simple-regular`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, sade ve suçlamasız (C düzeyinde de). İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. C1/C2 kapsaması Octanove listesi depoda olmadığı için denetlenmedi (`grammar_lint.py` uyarısı).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h082.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:42:32Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 8.64 | 67af14ad82084b7cb7a78a7a7d6da2cf | da1a44abdc4e886c |
| 2026-10-14T14:42:33Z | c01-tr | duyu-1 | - | - | - | 8.64 | - | da1a44abdc4e886c |
| 2026-10-14T14:42:36Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 211 | 13.63 | f64ce443aa854f85a4e397bd09af31f0 | 5bcb418bd6428ac1 |
| 2026-10-14T14:42:38Z | c02-tr | duyu-1 | - | - | - | 13.63 | - | 5bcb418bd6428ac1 |
| 2026-10-14T14:42:40Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 212 | 13.47 | a8d2292cd68c4578b2f3815fab586f40 | d33d6d95d758fe9c |
| 2026-10-14T14:42:42Z | c03-tr | duyu-1 | - | - | - | 13.47 | - | d33d6d95d758fe9c |
| 2026-10-14T14:42:45Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 12.99 | 261f637859874cd0a64510f3b1f6bfaf | b78d774a73779b8c |
| 2026-10-14T14:42:46Z | c04-tr | duyu-1 | - | - | - | 12.99 | - | b78d774a73779b8c |
| 2026-10-14T14:42:49Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 225 | 14.94 | eedcf2810a634ec4ab4df3132a4e7564 | 1c7572ec1e731e95 |
| 2026-10-14T14:42:50Z | c06-tr | duyu-1 | - | - | - | 14.94 | - | 1c7572ec1e731e95 |
| 2026-10-14T14:42:53Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 12.13 | b253ded06e0f43099bd2494e35992850 | f0316fe183ce77b5 |
| 2026-10-14T14:42:56Z | c08-tr | duyu-1 | - | - | - | 12.13 | - | f0316fe183ce77b5 |
| 2026-11-20T16:03:21Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 9.63 | 0f6a49084ca3422da6717c209b52639d | 655229b63e58d247 |
| 2026-11-20T16:03:24Z | c01-tr | duyu-1 | - | - | - | 9.63 | - | 655229b63e58d247 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:12:02Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 68 | f3d3dba93c9d3818 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:12:04Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 44 | 2fdfd3a598b66261 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:12:06Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 63 | 8bc7406bb69b23f6 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:12:08Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 57 | d0cb43ebd2e8dc23 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:12:10Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 48 | 7cede9fdad35ff67 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:12:12Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 74 | b001d61866c7cbc8 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:12:14Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 51 | 2a6803d8be77b0d2 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:12:17Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 57 | ffb16961391950ad | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:12:21Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 64 | 7c6154420505a8ed | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:12:23Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 0e05420e3c93b7f4 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:12:25Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 57 | 8db2fc0ca74ca278 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:12:27Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 47 | 3666d0e025121118 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:12:30Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 68 | 1db11e59079066f2 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:12:32Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 69 | fe72978f1cafeaae | audio/en/c07-q5.mp3 |
| 2026-11-26T14:12:34Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 52 | 0656c5878795c8f6 | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:33:03Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.88 | 1aeb8958b8eb4cbb8f497ac77c4d5cc2 | d0ae2c64d99362a9 |
| 2026-11-27T18:33:04Z | c07-q1-fb | duyu-1 | - | - | - | 2.88 | - | d0ae2c64d99362a9 |
| 2026-11-27T18:33:06Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 2.88 | f4651c1ce1ac4081ade5ba89b9c34c8d | ff9c6c58d59e4d7c |
| 2026-11-27T18:33:07Z | c07-q2-fb | duyu-1 | - | - | - | 2.88 | - | ff9c6c58d59e4d7c |
| 2026-11-27T18:33:09Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 3.04 | 90b6efa3dde54f66b8213c9090f9aead | c56ff8cfaa03c13f |
| 2026-11-27T18:33:10Z | c07-q3-fb | duyu-1 | - | - | - | 3.04 | - | c56ff8cfaa03c13f |
| 2026-11-27T18:33:13Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 3.52 | 6d11c92e2a914372aae255e93d8ee959 | 5a24a5d7e8ef4939 |
| 2026-11-27T18:33:14Z | c07-q4-fb | duyu-1 | - | - | - | 3.52 | - | 5a24a5d7e8ef4939 |
| 2026-11-27T19:45:02Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 51 | 3.04 | b7d172a3e235406d9c9540ca5b4d1f75 | 6769b63902c25688 |
| 2026-11-27T19:45:03Z | c01-ex1-tl | duyu-1 | - | - | - | 3.04 | - | 6769b63902c25688 |
| 2026-11-27T19:45:05Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.88 | 22c134ce8c1d49cb8ad82519fb9fd343 | 2cafda836c685745 |
| 2026-11-27T19:45:06Z | c02-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 2cafda836c685745 |
| 2026-11-27T19:45:09Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 3.68 | 414c534110c04dc6bd79d1cef76575a9 | 73b65358ec79713f |
| 2026-11-27T19:45:10Z | c02-ex2-tl | duyu-1 | - | - | - | 3.68 | - | 73b65358ec79713f |
| 2026-11-27T19:45:12Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 3.04 | 000b7fb85bda409ba1142b5207305b87 | 8105a9595afa8e06 |
| 2026-11-27T19:45:13Z | c03-ex1-tl | duyu-1 | - | - | - | 3.04 | - | 8105a9595afa8e06 |
| 2026-11-27T19:45:16Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 55 | 4.32 | 596b211f86764897af7c3348642648f0 | 2a2a629136a737c0 |
| 2026-11-27T19:45:17Z | c03-ex2-tl | duyu-1 | - | - | - | 4.32 | - | 2a2a629136a737c0 |
| 2026-11-27T19:45:20Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.48 | f7a578f82b5147db93e857bb9c8a932c | d0106c95c84eb548 |
| 2026-11-27T19:45:21Z | c04-ex1-tl | duyu-1 | - | - | - | 4.48 | - | d0106c95c84eb548 |
| 2026-11-27T19:45:24Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 3.68 | 145e053f31b34ce9b98ab7efc9742265 | ad217f29f601019b |
| 2026-11-27T19:45:25Z | c05-ex1-tl | duyu-1 | - | - | - | 3.68 | - | ad217f29f601019b |
| 2026-11-27T19:45:27Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 53 | 3.84 | c095215389444ce5ac11c9acabecbccd | 8ed4acd8b96322e0 |
| 2026-11-27T19:45:29Z | c05-ex2-tl | duyu-1 | - | - | - | 3.84 | - | 8ed4acd8b96322e0 |
| 2026-11-27T19:45:31Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 68 | 4.64 | f637bad56953413fbeac7184a7993a4b | 8fd813daf19dee39 |
| 2026-11-27T19:45:33Z | c05-ex3-tl | duyu-1 | - | - | - | 4.64 | - | 8fd813daf19dee39 |
| 2026-11-27T19:45:35Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.72 | c6c7889e09b54b0dbe39d0e7cef2a836 | a381414a2119d394 |
| 2026-11-27T19:45:36Z | c05-ex4-tl | duyu-1 | - | - | - | 2.72 | - | a381414a2119d394 |
| 2026-11-27T19:45:39Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 59 | 4.0 | cb19b475281e4186b77dab0354085cff | 81f9fee0d818ac99 |
| 2026-11-27T19:45:40Z | c05-ex5-tl | duyu-1 | - | - | - | 4.0 | - | 81f9fee0d818ac99 |
| 2026-11-27T19:45:42Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 3.52 | eddfef1468954c3fa6ba35ca41b8a090 | abc51420617fd7a8 |
| 2026-11-27T19:45:43Z | c06-ex1-tl | duyu-1 | - | - | - | 3.52 | - | abc51420617fd7a8 |
| 2026-11-27T19:45:46Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 58 | 4.64 | 19a8a72c18c44ea782eb9d2ea821222c | 45f77e10eb548089 |
| 2026-11-27T19:45:47Z | c06-ex2-tl | duyu-1 | - | - | - | 4.64 | - | 45f77e10eb548089 |
| 2026-11-27T19:45:50Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 62 | 4.64 | 39b04a7015ce4f4a88bab6a53a670275 | 9aabc0c1094c82c0 |
| 2026-11-27T19:45:52Z | c07-q5-tl | duyu-1 | - | - | - | 4.64 | - | 9aabc0c1094c82c0 |
| 2026-11-27T19:45:54Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 3.68 | c96dc0329c2741a3b745d2056ecf82b0 | ed582cd74be099d6 |
| 2026-11-27T19:45:55Z | c09-ex1-tl | duyu-1 | - | - | - | 3.68 | - | ed582cd74be099d6 |
