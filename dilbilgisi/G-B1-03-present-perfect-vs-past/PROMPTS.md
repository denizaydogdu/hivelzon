# G-B1-03-present-perfect-vs-past PROMPTS

Ders: Present perfect mi, past simple mı? just / already / yet · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok. **Sözlük (kapsama):** cast.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:06:16Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 179 | 13.94 | 1b46ba85c13942269fd7bfcb35787541 | 08a51777f2934e77 |
| 2026-10-14T14:06:17Z | c01-tr | duyu-1 | - | - | - | 13.94 | - | 08a51777f2934e77 |
| 2026-10-14T14:06:21Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 189 | 12.51 | e4468f56b03a41d69c7c1629d69c1a21 | d2c3621ffd71123a |
| 2026-10-14T14:06:23Z | c02-tr | duyu-1 | - | - | - | 12.51 | - | d2c3621ffd71123a |
| 2026-10-14T14:06:26Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 209 | 14.91 | 869ac17cca6a4ea78438b37fb2ada33d | 27606fc15982bf8e |
| 2026-10-14T14:06:27Z | c03-tr | duyu-1 | - | - | - | 14.91 | - | 27606fc15982bf8e |
| 2026-10-14T14:06:30Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 14.3 | 871e8d7965644e0b830dcb918d48a47c | a38eec53102fc8d1 |
| 2026-10-14T14:06:32Z | c05-tr | duyu-1 | - | - | - | 14.3 | - | a38eec53102fc8d1 |
| 2026-10-14T14:06:34Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.91 | fa7fc93204694d5685f435859940d2db | 8145a4f08e37448b |
| 2026-10-14T14:06:35Z | c07-tr | duyu-1 | - | - | - | 10.91 | - | 8145a4f08e37448b |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:37:12Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 4c54dac7a139d009 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:37:13Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 25 | ea5e259fb3bef558 | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:37:15Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 18 | fcca49dc1e0433c0 | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:37:16Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 18 | 87d78efec3f2085d | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:37:17Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | 13443c34b8dd2427 | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:37:18Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | 663df90a9317b114 | audio/en/c03-ex3.mp3 |
| 2026-10-30T13:37:20Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | fb8b55d81f178191 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:37:21Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 1c05ab9dc1e3f288 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:37:22Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 503c424136b5c669 | audio/en/c04-ex3.mp3 |
| 2026-10-30T13:37:23Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 9294916ad15a1dd9 | audio/en/c04-ex4.mp3 |
| 2026-10-30T13:37:25Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | dae24a699eb59f35 | audio/en/c04-ex5.mp3 |
| 2026-10-30T13:37:26Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 9011e0d6b81fb9f7 | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:37:27Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 20 | 071aa22b7a36666f | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:37:29Z | c07-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | eca70b9d394aa8ee | audio/en/c07-ex1.mp3 |
| 2026-11-27T18:24:31Z | c06-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 3.52 | 7085441579044e198cb9e5d1dd119864 | a807a303c2792641 |
| 2026-11-27T18:24:32Z | c06-q1-fb | duyu-1 | - | - | - | 3.52 | - | a807a303c2792641 |
| 2026-11-27T18:24:35Z | c06-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 56 | 5.28 | 9e956e9b73334be0a3199d92ca3b8558 | 666f39871d8962b7 |
| 2026-11-27T18:24:36Z | c06-q2-fb | duyu-1 | - | - | - | 5.28 | - | 666f39871d8962b7 |
| 2026-11-27T18:24:39Z | c06-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 51 | 4.0 | 47563e03e36d47d39c29546a96013ad5 | 844cb684e7d70a69 |
| 2026-11-27T18:24:40Z | c06-q3-fb | duyu-1 | - | - | - | 4.0 | - | 844cb684e7d70a69 |
| 2026-11-27T18:24:42Z | c06-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 3.52 | 3e561c559c8c4750b99ec972e5359596 | a83bd032b241097f |
| 2026-11-27T18:24:43Z | c06-q4-fb | duyu-1 | - | - | - | 3.52 | - | a83bd032b241097f |
| 2026-11-27T19:18:59Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.08 | 12eeb6ce9bc644128ce8d423f0778524 | c9d18d3a13a7ce41 |
| 2026-11-27T19:19:00Z | c01-ex1-tl | duyu-1 | - | - | - | 2.08 | - | c9d18d3a13a7ce41 |
| 2026-11-27T19:19:02Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 1.92 | 51f65e5d540948ba9516bf6543d8a53f | e83b9414c35be72a |
| 2026-11-27T19:19:03Z | c02-ex1-tl | duyu-1 | - | - | - | 1.92 | - | e83b9414c35be72a |
| 2026-11-27T19:19:06Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 3.2 | e1998e6bbf3e4f40b0a462c51478010b | 3dfc48a55cc0f507 |
| 2026-11-27T19:19:07Z | c02-ex2-tl | duyu-1 | - | - | - | 3.2 | - | 3dfc48a55cc0f507 |
| 2026-11-27T19:19:09Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | b26dc259c8714a3d8617a949f419f580 | 3adb2a16a0c58699 |
| 2026-11-27T19:19:09Z | c03-ex1-tl | duyu-1 | - | - | - | 1.28 | - | 3adb2a16a0c58699 |
| 2026-11-27T19:19:11Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.28 | 300b22b0597f44948fef83e0e72187f2 | f3d8d7ce46404523 |
| 2026-11-27T19:19:12Z | c03-ex2-tl | duyu-1 | - | - | - | 1.28 | - | f3d8d7ce46404523 |
| 2026-11-27T19:19:14Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.6 | 9a233046583c4e63aedd3a6ef3d154c3 | fa300f1cb96429ad |
| 2026-11-27T19:19:16Z | c03-ex3-tl | duyu-1 | - | - | - | 1.6 | - | fa300f1cb96429ad |
| 2026-11-27T19:19:18Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 3.36 | aa6ec7f276d24953a2c686d3f6e82965 | 0587b8a9d320f54f |
| 2026-11-27T19:19:19Z | c04-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 0587b8a9d320f54f |
| 2026-11-27T19:19:21Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.76 | 31d721f4c76c4b3aa06e4e9a52aa6e86 | 8e9c308d48eca5d6 |
| 2026-11-27T19:19:22Z | c04-ex2-tl | duyu-1 | - | - | - | 1.76 | - | 8e9c308d48eca5d6 |
| 2026-11-27T19:19:25Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.4 | 44f9948853bd43fc8fa72361a81c89c2 | 0adbe836d1e15554 |
| 2026-11-27T19:19:26Z | c04-ex3-tl | duyu-1 | - | - | - | 2.4 | - | 0adbe836d1e15554 |
| 2026-11-27T19:19:28Z | c04-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | 01f781ea09fe4dd1a22e96f4b34213db | 3d1a7b571180514a |
| 2026-11-27T19:19:29Z | c04-ex4-tl | duyu-1 | - | - | - | 1.44 | - | 3d1a7b571180514a |
| 2026-11-27T19:19:31Z | c04-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.88 | ea3c8a1e293f4e3699571ac8fe9ce323 | e833a35787be3240 |
| 2026-11-27T19:19:32Z | c04-ex5-tl | duyu-1 | - | - | - | 2.88 | - | e833a35787be3240 |
| 2026-11-27T19:19:34Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.12 | e18f3e713f964341adbbb11bd63051f3 | 091e06518ab18e01 |
| 2026-11-27T19:19:35Z | c05-ex1-tl | duyu-1 | - | - | - | 1.12 | - | 091e06518ab18e01 |
| 2026-11-27T19:19:37Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | 3f4556dc3ffe4454bf992efaa736c50f | 998c17634eb98327 |
| 2026-11-27T19:19:37Z | c05-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 998c17634eb98327 |
| 2026-11-27T19:19:40Z | c08-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 3.84 | 82738cc91bd440d4ae86ac59aeafa8b6 | 634932d931abb14d |
| 2026-11-27T19:19:41Z | c08-ex1-tl | duyu-1 | - | - | - | 3.84 | - | 634932d931abb14d |
