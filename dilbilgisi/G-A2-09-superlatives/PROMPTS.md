# G-A2-09-superlatives PROMPTS

Ders: En üstünlük: the -est / the most · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-est` → "est".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:10:07Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 141 | 8.8 | c269cf2188ad4e07b865da706e6a64ea | f8d84665a12a7973 |
| 2026-10-14T13:10:08Z | c01-tr | duyu-1 | - | - | - | 8.8 | - | f8d84665a12a7973 |
| 2026-10-14T13:10:11Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 10.38 | d6e167690abc49849c8b351dce8d4103 | 4a774aae601c10cf |
| 2026-10-14T13:10:12Z | c02-tr | duyu-1 | - | - | - | 10.38 | - | 4a774aae601c10cf |
| 2026-10-14T13:10:15Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 9.6 | aba2cfe8ccc84c38995e7256af8fe550 | 36f6869478cea8ce |
| 2026-10-14T13:10:17Z | c03-tr | duyu-1 | - | - | - | 9.6 | - | 36f6869478cea8ce |
| 2026-10-14T13:10:20Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 212 | 15.27 | f81f0bd387334ce39da3af301249839b | 91bd2f47022c353b |
| 2026-10-14T13:10:21Z | c04-tr | duyu-1 | - | - | - | 15.27 | - | 91bd2f47022c353b |
| 2026-10-14T13:10:25Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 178 | 11.7 | b84c704d7051401f8cd10585995e63c8 | 4fc9cae5f8a67e24 |
| 2026-10-14T13:10:26Z | c06-tr | duyu-1 | - | - | - | 11.7 | - | 4fc9cae5f8a67e24 |
| 2026-10-14T13:10:28Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 89 | 5.12 | 1560eb82e91f4853bd368e4d4cee3a33 | 3628c563b296e582 |
| 2026-10-14T13:10:29Z | c08-tr | duyu-1 | - | - | - | 5.12 | - | 3628c563b296e582 |
| 2026-10-14T13:10:31Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 112 | 8.16 | 277c0f5cd96e4e24b6638b2299f1b9fe | 97693dca1073a6ea |
| 2026-10-14T13:10:33Z | c09-tr | duyu-1 | - | - | - | 8.16 | - | 97693dca1073a6ea |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:28:09Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 51 | 7fc602a3cc5cabd8 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:28:10Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 18 | 9102f9e7171333d7 | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:28:12Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | f90e6414459a031a | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:28:13Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 7a1f4fa31f21c4cf | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:28:14Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 21 | a0f18494f24fe877 | audio/en/c03-ex3.mp3 |
| 2026-10-30T13:28:16Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | 96aab8570cfaa51e | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:28:18Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | 8c14711e994a5e97 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:28:20Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 38 | ed0897fd8fadbad6 | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:28:21Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 34 | 24ccfce33dd822ce | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:28:22Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | a66627af76d52f50 | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:28:24Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 49 | fcf6db75bb766bdb | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:28:26Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | 9dfeef9c3b86d622 | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:28:27Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | 99022832389e32c7 | audio/en/c06-ex1.mp3 |
| 2026-10-30T13:28:29Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | f28a34383be14bfa | audio/en/c06-ex2.mp3 |
| 2026-10-30T13:28:31Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | d518f84e1ff29572 | audio/en/c07-q5.mp3 |
| 2026-11-27T18:22:25Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 61 | 4.96 | 8b7485941d8049bcb4d66973870928ee | a2780aa2266fcfc7 |
| 2026-11-27T18:22:26Z | c07-q1-fb | duyu-1 | - | - | - | 4.96 | - | a2780aa2266fcfc7 |
| 2026-11-27T18:22:29Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.56 | d9fd779abf12444fba560d35631b50e6 | 0d853cd9399f94e5 |
| 2026-11-27T18:22:30Z | c07-q2-fb | duyu-1 | - | - | - | 2.56 | - | 0d853cd9399f94e5 |
| 2026-11-27T18:22:32Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 3.84 | ac95c8143f5642e5904f7f7e0946ce1b | 771a8a37c0c0bb80 |
| 2026-11-27T18:22:33Z | c07-q3-fb | duyu-1 | - | - | - | 3.84 | - | 771a8a37c0c0bb80 |
| 2026-11-27T18:22:35Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.08 | 4f035184059b473dad8507f93e00e44d | 075af5f22d0672a5 |
| 2026-11-27T18:22:36Z | c07-q4-fb | duyu-1 | - | - | - | 2.08 | - | 075af5f22d0672a5 |
| 2026-11-27T19:12:34Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.4 | 3117cedb12d84bb096420a3444f44ce4 | 670232a5a7dfd3a9 |
| 2026-11-27T19:12:35Z | c01-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 670232a5a7dfd3a9 |
| 2026-11-27T19:12:37Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 0.96 | bf05b6538e7f45179753a6acd30b2e87 | b7a7ca3c172ecaa0 |
| 2026-11-27T19:12:38Z | c02-ex1-tl | duyu-1 | - | - | - | 0.96 | - | b7a7ca3c172ecaa0 |
| 2026-11-27T19:12:40Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 3.18 | 95ba30b1e45b427a9c4a436a905b6bd2 | d2d3587ae9954a87 |
| 2026-11-27T19:12:41Z | c03-ex1-tl | duyu-1 | - | - | - | 3.18 | - | d2d3587ae9954a87 |
| 2026-11-27T19:12:43Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 2.88 | c0c7ab0f92d54c888888aa3fa8b72daa | 8f2be7c7ef078a3b |
| 2026-11-27T19:12:45Z | c03-ex2-tl | duyu-1 | - | - | - | 2.88 | - | 8f2be7c7ef078a3b |
| 2026-11-27T19:12:46Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | ea82eddc8d6748a2a6140c3fa62e46c2 | 12e816574d07d425 |
| 2026-11-27T19:12:47Z | c03-ex3-tl | duyu-1 | - | - | - | 1.28 | - | 12e816574d07d425 |
| 2026-11-27T19:12:49Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.76 | 23169e8195a9497d89612fceeb5f777f | 688fa9edf9e8a198 |
| 2026-11-27T19:12:50Z | c04-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 688fa9edf9e8a198 |
| 2026-11-27T19:12:52Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.92 | b3a4c660bd264017873ed83bee080bd7 | d11f4385091e4db8 |
| 2026-11-27T19:12:53Z | c04-ex2-tl | duyu-1 | - | - | - | 1.92 | - | d11f4385091e4db8 |
| 2026-11-27T19:12:55Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.08 | 641102cac31c4e59ab5fad6511dfb6c9 | 96bc39dd9ca0fcbc |
| 2026-11-27T19:12:56Z | c05-ex1-tl | duyu-1 | - | - | - | 2.08 | - | 96bc39dd9ca0fcbc |
| 2026-11-27T19:12:59Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.72 | 8e7f99153a474611a107c95aa7da534d | 682aca6e263ef496 |
| 2026-11-27T19:13:00Z | c05-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 682aca6e263ef496 |
| 2026-11-27T19:13:02Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | d9fc9326058c42c2b5c4ded52415d431 | 962865323567fe15 |
| 2026-11-27T19:13:03Z | c05-ex3-tl | duyu-1 | - | - | - | 1.76 | - | 962865323567fe15 |
| 2026-11-27T19:13:05Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 3.2 | fcee50e30c224ab2a6619b8e60756551 | b26e8044a0b3d713 |
| 2026-11-27T19:13:06Z | c05-ex4-tl | duyu-1 | - | - | - | 3.2 | - | b26e8044a0b3d713 |
| 2026-11-27T19:13:08Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.76 | c68cb945d788492aa63d3185204fb2b0 | 5ab5e9fea9f3e6a4 |
| 2026-11-27T19:13:09Z | c05-ex5-tl | duyu-1 | - | - | - | 1.76 | - | 5ab5e9fea9f3e6a4 |
| 2026-11-27T19:13:11Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.6 | 430ccacf650444f7a1aa76f74e7a4592 | 733a0b42515a389a |
| 2026-11-27T19:13:12Z | c06-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 733a0b42515a389a |
| 2026-11-27T19:13:13Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 620326e4a9df47a1bfed2e7a352ded8a | 9b1ed810cce6cc68 |
| 2026-11-27T19:13:14Z | c06-ex2-tl | duyu-1 | - | - | - | 1.76 | - | 9b1ed810cce6cc68 |
| 2026-11-27T19:13:16Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.6 | 4342b228474e43f99c217d8bb3ea94ad | fe2fd10b8ed99bde |
| 2026-11-27T19:13:17Z | c07-q5-tl | duyu-1 | - | - | - | 1.6 | - | fe2fd10b8ed99bde |
