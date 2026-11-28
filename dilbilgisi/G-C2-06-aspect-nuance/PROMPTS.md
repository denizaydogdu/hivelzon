# G-C2-06-aspect-nuance PROMPTS

Ders: Görünüş incelikleri (aspect): She's being rude, I was wondering… · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:42:58Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 8.64 | 418bd8d860ed4fcd97e41770cc612774 | 4c51a54254d923a2 |
| 2026-10-14T14:42:59Z | c01-tr | duyu-1 | - | - | - | 8.64 | - | 4c51a54254d923a2 |
| 2026-10-14T14:43:02Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 225 | 13.82 | fd1a7b1b06b84d868388d26e4e1494fe | cba626fcd914cf9b |
| 2026-10-14T14:43:03Z | c02-tr | duyu-1 | - | - | - | 13.82 | - | cba626fcd914cf9b |
| 2026-10-14T14:43:07Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 197 | 12.83 | e88722c912f74eb8adb2e7fb8e9a35bc | 5b0b3cdb9102aa30 |
| 2026-10-14T14:43:08Z | c03-tr | duyu-1 | - | - | - | 12.83 | - | 5b0b3cdb9102aa30 |
| 2026-10-14T14:43:11Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 178 | 11.68 | 5b5c18c3c3ae4734a2cd6c2e4d26db6f | b0c6d65d704bd646 |
| 2026-10-14T14:43:12Z | c04-tr | duyu-1 | - | - | - | 11.68 | - | b0c6d65d704bd646 |
| 2026-10-14T14:43:15Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 163 | 10.43 | a00d85a377f644b594b2612c9c6d14b6 | 02162aa39d2900ea |
| 2026-10-14T14:43:17Z | c06-tr | duyu-1 | - | - | - | 10.43 | - | 02162aa39d2900ea |
| 2026-10-14T14:43:20Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 146 | 9.63 | 0cb79110bb9a485ba88ed1295c9cce31 | 0c4abb5e409895c8 |
| 2026-10-14T14:43:21Z | c08-tr | duyu-1 | - | - | - | 9.63 | - | 0c4abb5e409895c8 |
| 2026-11-20T16:03:30Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 10.43 | 84b8917a68c7497c969df49833a0d937 | 621ba9faf36d7f4d |
| 2026-11-20T16:03:34Z | c01-tr | duyu-1 | - | - | - | 10.43 | - | 621ba9faf36d7f4d |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:12:36Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 30 | 1f412f1e8212ee3a | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:12:37Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 11 | cef01b5e4fab5f92 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:12:39Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 17 | e74684e925107122 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:12:40Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 21 | 00d12b86aa3e3a8d | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:12:41Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 310ac73baf9c7038 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:12:43Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 066f5a4f7eee33a3 | audio/en/c03-ex3.mp3 |
| 2026-11-26T14:12:44Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 37 | 97f5f0be61e09a26 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:12:45Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 27 | 942158c5b6fcede2 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:12:47Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 29 | c021e8753689ef28 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:12:48Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 33 | 01b5030049250e69 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:12:50Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 41 | c7e3175050d7e53e | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:12:51Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | c58edf9873806f60 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:12:53Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 40 | 082cca18838135e3 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:12:54Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 46 | ad5d1c70fed5a750 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:12:55Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 23 | 0686e35bb5f5328e | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:33:16Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.08 | fd23b3a369c5498b88060982dba876d5 | 560c1bc0375a608e |
| 2026-11-27T18:33:17Z | c07-q1-fb | duyu-1 | - | - | - | 2.08 | - | 560c1bc0375a608e |
| 2026-11-27T18:33:19Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 3.2 | d1ccc20edcd842bca5152c515c35d3c3 | 13c2b7ff2a5980e1 |
| 2026-11-27T18:33:20Z | c07-q2-fb | duyu-1 | - | - | - | 3.2 | - | 13c2b7ff2a5980e1 |
| 2026-11-27T18:33:23Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 5.12 | 1e5ea756d3214c92835991eb447cfca9 | d87e0312ec2d56e3 |
| 2026-11-27T18:33:25Z | c07-q3-fb | duyu-1 | - | - | - | 5.12 | - | d87e0312ec2d56e3 |
| 2026-11-27T18:33:27Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.24 | d8805bcc85ff443a9e627f93ef9efce9 | 27c8404d6c037148 |
| 2026-11-27T18:33:28Z | c07-q4-fb | duyu-1 | - | - | - | 2.24 | - | 27c8404d6c037148 |
| 2026-11-27T19:45:58Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.4 | a9d2554137e441a0bc2ece758240c419 | 16853144b9a33460 |
| 2026-11-27T19:45:59Z | c01-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 16853144b9a33460 |
| 2026-11-27T19:46:01Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | f939cc78bfb54d778c27bbf8eacc442f | be0f3580719a6f1f |
| 2026-11-27T19:46:03Z | c02-ex1-tl | duyu-1 | - | - | - | 1.28 | - | be0f3580719a6f1f |
| 2026-11-27T19:46:05Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.92 | 98c53945929a41d5aa75e1485775dd80 | 6344b00c54b29812 |
| 2026-11-27T19:46:06Z | c02-ex2-tl | duyu-1 | - | - | - | 1.92 | - | 6344b00c54b29812 |
| 2026-11-27T19:46:08Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 3.04 | ff6824b094124396aff0df186bc7e330 | 7a4386c2c163fc86 |
| 2026-11-27T19:46:10Z | c03-ex1-tl | duyu-1 | - | - | - | 3.04 | - | 7a4386c2c163fc86 |
| 2026-11-27T19:46:12Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.24 | 525b0dcbd22845159904f82bd6f5e25e | 55e4cfb1623d3402 |
| 2026-11-27T19:46:13Z | c03-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 55e4cfb1623d3402 |
| 2026-11-27T19:46:16Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.6 | bb0d4931429942988cb0e5240df8f9ce | b26bd07bc36fc87c |
| 2026-11-27T19:46:16Z | c03-ex3-tl | duyu-1 | - | - | - | 1.6 | - | b26bd07bc36fc87c |
| 2026-11-27T19:46:19Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.4 | 16327a2aeb1644b788ceb7ba46897973 | 09ee0faf8a925488 |
| 2026-11-27T19:46:20Z | c04-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 09ee0faf8a925488 |
| 2026-11-27T19:46:22Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 4.48 | a953b4b590394b9ba1d9998043bfffc6 | d357444cfce0a195 |
| 2026-11-27T19:46:24Z | c04-ex2-tl | duyu-1 | - | - | - | 4.48 | - | d357444cfce0a195 |
| 2026-11-27T19:46:26Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 2.72 | b9289494543741d0ae7d49dedc86dd67 | 7f1117f64ad6125d |
| 2026-11-27T19:46:27Z | c05-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 7f1117f64ad6125d |
| 2026-11-27T19:46:30Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | bc0e584cdb6c4cf2a922a0ffa41e7469 | e91fed9d2d1de638 |
| 2026-11-27T19:46:31Z | c05-ex2-tl | duyu-1 | - | - | - | 1.92 | - | e91fed9d2d1de638 |
| 2026-11-27T19:46:33Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.56 | 35c1eec1b0d94a7f8a9f5bbcb83a1e17 | 0f682a4a98387fcf |
| 2026-11-27T19:46:34Z | c05-ex3-tl | duyu-1 | - | - | - | 2.56 | - | 0f682a4a98387fcf |
| 2026-11-27T19:46:36Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.08 | c9adb6d9a2074a8ea228a72b8e4dc988 | 989768e950a999b8 |
| 2026-11-27T19:46:37Z | c05-ex4-tl | duyu-1 | - | - | - | 2.08 | - | 989768e950a999b8 |
| 2026-11-27T19:46:39Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.72 | 2b8554d699774d32a0522bbf37e2aaf6 | db1d4e334ff32017 |
| 2026-11-27T19:46:40Z | c05-ex5-tl | duyu-1 | - | - | - | 2.72 | - | db1d4e334ff32017 |
| 2026-11-27T19:46:43Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 3.68 | 62d6509d581d4b7299b4dd8f9c53638c | 2913542ac7d8150e |
| 2026-11-27T19:46:44Z | c06-ex1-tl | duyu-1 | - | - | - | 3.68 | - | 2913542ac7d8150e |
| 2026-11-27T19:46:46Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.44 | 69d5660c0e0a4bb49a652d3a61defdef | 1e6bea6a9e76d7eb |
| 2026-11-27T19:46:47Z | c06-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 1e6bea6a9e76d7eb |
