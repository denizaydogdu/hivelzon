# G-B1-14-articles-general-specific PROMPTS

Ders: Artikeller (2): genel mi, belirli mi? · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:10:48Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 11.23 | 07bf247942054df282ba0814d219339d | 0a115743cc792347 |
| 2026-10-14T14:10:49Z | c01-tr | duyu-1 | - | - | - | 11.23 | - | 0a115743cc792347 |
| 2026-10-14T14:10:56Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.11 | 394e043eac034d18966f186cdc3940c2 | 90da43a7ed3b1a09 |
| 2026-10-14T14:10:57Z | c02-tr | duyu-1 | - | - | - | 10.11 | - | 90da43a7ed3b1a09 |
| 2026-10-14T14:11:00Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 116 | 6.88 | 48ffe8763e8a44eaa90650c9977c59a1 | f4ab706bfa092c03 |
| 2026-10-14T14:11:01Z | c03-tr | duyu-1 | - | - | - | 6.88 | - | f4ab706bfa092c03 |
| 2026-10-14T14:11:04Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 12.51 | 1af3b55665294331a20f975ce960e19b | 7a5b395983cf082d |
| 2026-10-14T14:11:05Z | c04-tr | duyu-1 | - | - | - | 12.51 | - | 7a5b395983cf082d |
| 2026-10-14T14:11:08Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 223 | 15.72 | dc4d31fbaba542e0a4cfdaf8b95b9f5a | 0a79f62e52443f58 |
| 2026-10-14T14:11:10Z | c06-tr | duyu-1 | - | - | - | 15.72 | - | 0a79f62e52443f58 |
| 2026-10-14T14:11:12Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 74 | 4.96 | 2cf5056490e2423482e16028e0450967 | f6340043f61fcbe7 |
| 2026-10-14T14:11:13Z | c08-tr | duyu-1 | - | - | - | 4.96 | - | f6340043f61fcbe7 |
| 2026-10-14T14:11:16Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 116 | 7.68 | 63b6f40fb3a544d48bfbb69a3f56d372 | e40d000e88768d23 |
| 2026-10-14T14:11:17Z | c09-tr | duyu-1 | - | - | - | 7.68 | - | e40d000e88768d23 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:36:36Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | 34ffdf2d1606e52f | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:36:37Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | 31a5883fb7585ad6 | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:36:39Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 13 | c5765323933eaa30 | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:36:40Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | 31f8eb19f687415f | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:36:42Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | 927a8432ec7196b8 | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:36:43Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | c3e8b6110b811583 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:36:45Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 19 | d01d196962746555 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:36:46Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 17 | d7e6799ff32a7cf8 | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:36:48Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 18 | 2c6424d8c837e1ea | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:36:49Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | fb11e2135b3b224d | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:36:50Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 8ab7b295edfc3e7f | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:36:52Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 4b37e371deff0bda | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:36:54Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | b7574744f305987e | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:27:05Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.08 | 33c5b5b9fdd34c8e8d02e75b2a1fbd48 | 43ad053b86d84f38 |
| 2026-11-27T18:27:06Z | c07-q1-fb | duyu-1 | - | - | - | 2.08 | - | 43ad053b86d84f38 |
| 2026-11-27T18:27:08Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.72 | 9842f7560c494101afe93755485cd703 | 3b4e9d89d4c89329 |
| 2026-11-27T18:27:09Z | c07-q2-fb | duyu-1 | - | - | - | 2.72 | - | 3b4e9d89d4c89329 |
| 2026-11-27T18:27:13Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.92 | 8d776627f497462ca52ae762bf85691f | 88907d41028c3f53 |
| 2026-11-27T18:27:14Z | c07-q3-fb | duyu-1 | - | - | - | 1.92 | - | 88907d41028c3f53 |
| 2026-11-27T18:27:16Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.92 | 399ac2f1824649ef9135ec44a12e966f | 0a95feef8d7ee713 |
| 2026-11-27T18:27:17Z | c07-q4-fb | duyu-1 | - | - | - | 1.92 | - | 0a95feef8d7ee713 |
| 2026-11-27T19:26:44Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | 0fcb9a59a5c64f3382f81bef59e7fc6f | 33f1bacf5f712250 |
| 2026-11-27T19:26:45Z | c01-ex1-tl | duyu-1 | - | - | - | 1.92 | - | 33f1bacf5f712250 |
| 2026-11-27T19:26:47Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | cff4f89dbefb4c638bb22fd044b7f4cf | cccf235e7c2ea8e0 |
| 2026-11-27T19:26:48Z | c02-ex1-tl | duyu-1 | - | - | - | 1.76 | - | cccf235e7c2ea8e0 |
| 2026-11-27T19:26:50Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 23241f827d4845d798e3a13b1af913dd | 11e66a0d86292517 |
| 2026-11-27T19:26:51Z | c02-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 11e66a0d86292517 |
| 2026-11-27T19:26:53Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.4 | c361a74ab3c947cebaeb8982b49d1d3d | f30d63a2cede6c17 |
| 2026-11-27T19:26:54Z | c03-ex1-tl | duyu-1 | - | - | - | 2.4 | - | f30d63a2cede6c17 |
| 2026-11-27T19:26:56Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.72 | 0617834a3565458b9049f0e4dedfaf84 | b8041bbf7f73660d |
| 2026-11-27T19:26:58Z | c03-ex2-tl | duyu-1 | - | - | - | 2.72 | - | b8041bbf7f73660d |
| 2026-11-27T19:27:00Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.88 | d3ae10dfc401445786f55c5a455ae3ce | 9fa81a85b034e452 |
| 2026-11-27T19:27:01Z | c04-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 9fa81a85b034e452 |
| 2026-11-27T19:27:03Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 67031ce1220c4b219ee8426e7c3998a7 | 259857dcebdd1338 |
| 2026-11-27T19:27:04Z | c04-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 259857dcebdd1338 |
| 2026-11-27T19:27:06Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.28 | 76caa6ef361c4fe1b526aee7c02b69eb | c9d46a0ff104603c |
| 2026-11-27T19:27:07Z | c05-ex1-tl | duyu-1 | - | - | - | 1.28 | - | c9d46a0ff104603c |
| 2026-11-27T19:27:09Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | 419f24f7da154c11a3da4452189e8050 | e68a4e613ac840dd |
| 2026-11-27T19:27:10Z | c05-ex2-tl | duyu-1 | - | - | - | 1.28 | - | e68a4e613ac840dd |
| 2026-11-27T19:27:12Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.92 | 5bbcc02490d3444297e4af62d6522550 | 69d0fd3c602c0bb9 |
| 2026-11-27T19:27:13Z | c05-ex3-tl | duyu-1 | - | - | - | 1.92 | - | 69d0fd3c602c0bb9 |
| 2026-11-27T19:27:15Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.44 | 6556362cf3584c19b4c041934ed5ccc0 | 1bbd2135ecc2217a |
| 2026-11-27T19:27:16Z | c05-ex4-tl | duyu-1 | - | - | - | 1.44 | - | 1bbd2135ecc2217a |
| 2026-11-27T19:27:18Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.4 | 0e036869dc8f473a9a0f4ff3c69c9eca | 3856096bc8843ef4 |
| 2026-11-27T19:27:19Z | c05-ex5-tl | duyu-1 | - | - | - | 2.4 | - | 3856096bc8843ef4 |
| 2026-11-27T19:27:21Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 3.68 | c77505bbc16842faa1f1df1fbc4c1b8f | 16d42455ca61c5fe |
| 2026-11-27T19:27:22Z | c09-ex1-tl | duyu-1 | - | - | - | 3.68 | - | 16d42455ca61c5fe |
