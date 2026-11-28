# G-B2-02-reported-statements PROMPTS

Ders: Dolaylı anlatım (1): say, tell ve zaman kaydırma · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:08:10Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 148 | 10.91 | 4e28905f5e7b41c7afde433ab2e25373 | 0e4c720c5d89eb3c |
| 2026-10-14T14:08:11Z | c01-tr | duyu-1 | - | - | - | 10.91 | - | 0e4c720c5d89eb3c |
| 2026-10-14T14:08:14Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 12.35 | d77fca2dd52746748b8a34dc9a73704c | ca3352d2e16e7418 |
| 2026-10-14T14:08:15Z | c02-tr | duyu-1 | - | - | - | 12.35 | - | ca3352d2e16e7418 |
| 2026-10-14T14:08:18Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 197 | 12.66 | cdad26dda2904e8fb9d2cecbdc45f8f2 | 2d798db377d0d3dd |
| 2026-10-14T14:08:19Z | c03-tr | duyu-1 | - | - | - | 12.66 | - | 2d798db377d0d3dd |
| 2026-10-14T14:08:22Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 160 | 11.87 | 6e992b0a457d44758881b91eb2b53aff | 2cca151d7eb98082 |
| 2026-10-14T14:08:23Z | c04-tr | duyu-1 | - | - | - | 11.87 | - | 2cca151d7eb98082 |
| 2026-10-14T14:08:26Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 262 | 16.83 | a5983741e7454eca82cba2c82d43844f | b8cb1e2990b96f11 |
| 2026-10-14T14:08:28Z | c06-tr | duyu-1 | - | - | - | 16.83 | - | b8cb1e2990b96f11 |
| 2026-10-14T14:08:30Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 68 | 4.0 | ef6169f3e3d54356919f0f6046586421 | f1f494453a262d99 |
| 2026-10-14T14:08:31Z | c08-tr | duyu-1 | - | - | - | 4.0 | - | f1f494453a262d99 |
| 2026-10-14T14:08:34Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 124 | 6.88 | e4e1e2b4010f46d88a266f9543a8069c | 711b6d28ba4dc5ae |
| 2026-10-14T14:08:35Z | c09-tr | duyu-1 | - | - | - | 6.88 | - | 711b6d28ba4dc5ae |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:02:06Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 21 | 4f63e06007fc8c6d | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:02:07Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | 143087f5fef80965 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:02:09Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | 5e8f240fa8b737f1 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:02:10Z | c02-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | 9032c180a1e848f0 | audio/en/c02-ex3.mp3 |
| 2026-11-26T14:02:13Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | a3aef6f12a0455b9 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:02:14Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | c5bc3b3ee82f9736 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:02:16Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 222aef9498650eea | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:02:18Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 0e835ec95b2c34a7 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:02:20Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 21e2cc45d159be20 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:02:21Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | 91385eb99dcae0f7 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:02:23Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 03934c4f9a4026f1 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:02:25Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | b540ba56308f627b | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:02:26Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | fdf6d671caecfda0 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:02:28Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | a465290af6737ef2 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:02:30Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 25 | 47118fd62e3c6428 | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:27:37Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.4 | c8e6ce02021f4eb5b2c74a441889eafc | 672ec2d49fc2e96c |
| 2026-11-27T18:27:38Z | c07-q1-fb | duyu-1 | - | - | - | 2.4 | - | 672ec2d49fc2e96c |
| 2026-11-27T18:27:40Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 56 | 4.0 | e09c9b424c484d16a9c94fc14f3e951a | 463308d9f11f2519 |
| 2026-11-27T18:27:41Z | c07-q2-fb | duyu-1 | - | - | - | 4.0 | - | 463308d9f11f2519 |
| 2026-11-27T18:27:44Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.24 | a514bbac399b4e1ab347e381b854ce87 | 831e9e2e4028c29d |
| 2026-11-27T18:27:45Z | c07-q3-fb | duyu-1 | - | - | - | 2.24 | - | 831e9e2e4028c29d |
| 2026-11-27T18:27:47Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 51 | 3.04 | 18cc86e9e7714165862ce8c63777b675 | 01fdf9e1a1c004a8 |
| 2026-11-27T18:27:48Z | c07-q4-fb | duyu-1 | - | - | - | 3.04 | - | 01fdf9e1a1c004a8 |
| 2026-11-27T19:28:10Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | b60dfed5fb7d4bde99ccffaf1d0e59aa | e481130181cf82b8 |
| 2026-11-27T19:28:11Z | c01-ex1-tl | duyu-1 | - | - | - | 2.08 | - | e481130181cf82b8 |
| 2026-11-27T19:28:13Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.6 | dce0726b9eca47619b6d9e68bfa43eef | 5b1c2ccc9e61aa0f |
| 2026-11-27T19:28:14Z | c02-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 5b1c2ccc9e61aa0f |
| 2026-11-27T19:28:16Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.76 | b16bbbbc6bcc4d6dac3a770e44966bda | 4f07fdc8c4632031 |
| 2026-11-27T19:28:17Z | c02-ex2-tl | duyu-1 | - | - | - | 1.76 | - | 4f07fdc8c4632031 |
| 2026-11-27T19:28:19Z | c02-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.08 | cbd3a4d5d1ca42f8877bb4445fbb7ff8 | f9e9ce0b8860b170 |
| 2026-11-27T19:28:20Z | c02-ex3-tl | duyu-1 | - | - | - | 2.08 | - | f9e9ce0b8860b170 |
| 2026-11-27T19:28:22Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.76 | 86cdaa3edc4741b59b8c180f185100a6 | 092bf81631a3697e |
| 2026-11-27T19:28:23Z | c03-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 092bf81631a3697e |
| 2026-11-27T19:28:25Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.24 | 453d7b0fc6ec4a928c53896f72b5148e | 10c6e446def8079c |
| 2026-11-27T19:28:26Z | c03-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 10c6e446def8079c |
| 2026-11-27T19:28:28Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | 91a1e6f09a4a40b2bbac83bf646bbfa8 | 16a36efe2c0c29ae |
| 2026-11-27T19:28:29Z | c04-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 16a36efe2c0c29ae |
| 2026-11-27T19:28:31Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.6 | e492c7d9bbf94035926e9e3531c3b255 | bf97c6ddac54da13 |
| 2026-11-27T19:28:32Z | c04-ex2-tl | duyu-1 | - | - | - | 1.6 | - | bf97c6ddac54da13 |
| 2026-11-27T19:28:34Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 3.36 | 90305f329abd41faa32a1bd0fe2e2ac7 | d6292d9dd672d15c |
| 2026-11-27T19:28:35Z | c05-ex1-tl | duyu-1 | - | - | - | 3.36 | - | d6292d9dd672d15c |
| 2026-11-27T19:28:38Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.4 | 6785d34b2e4545189def94d7dd2c18ba | 60998b1d7d7c3f2f |
| 2026-11-27T19:28:39Z | c05-ex2-tl | duyu-1 | - | - | - | 2.4 | - | 60998b1d7d7c3f2f |
| 2026-11-27T19:28:41Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.24 | c01106f344314752a6114261699a842f | 29b2c45e42877d0a |
| 2026-11-27T19:28:42Z | c05-ex3-tl | duyu-1 | - | - | - | 2.24 | - | 29b2c45e42877d0a |
| 2026-11-27T19:28:44Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.88 | d6441730d0834653ac1e33ad26c09f29 | e68aaec5df1f3a2d |
| 2026-11-27T19:28:45Z | c05-ex4-tl | duyu-1 | - | - | - | 2.88 | - | e68aaec5df1f3a2d |
| 2026-11-27T19:28:48Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 4.8 | 1fa5663556fb4d008d546d50f04543e9 | 96f32966e84771b4 |
| 2026-11-27T19:28:49Z | c05-ex5-tl | duyu-1 | - | - | - | 4.8 | - | 96f32966e84771b4 |
| 2026-11-27T19:28:51Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 1.92 | 27192266cc5e45538106b26524a09a4a | e7286a70163b9888 |
| 2026-11-27T19:28:52Z | c06-ex1-tl | duyu-1 | - | - | - | 1.92 | - | e7286a70163b9888 |
| 2026-11-27T19:28:54Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.76 | c4885606cebb4260b7c92cb313f6b26b | 2b57d1c6071397e3 |
| 2026-11-27T19:28:55Z | c06-ex2-tl | duyu-1 | - | - | - | 1.76 | - | 2b57d1c6071397e3 |
