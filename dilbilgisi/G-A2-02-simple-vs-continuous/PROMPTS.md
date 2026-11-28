# G-A2-02-simple-vs-continuous PROMPTS

Ders: Geniş zaman mı, şimdiki zaman mı? · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ing` → "ing".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:07:30Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 8.32 | 72cfb4d139f0457abf131666d4ceed04 | 721fddd6ee261592 |
| 2026-10-14T13:07:31Z | c01-tr | duyu-1 | - | - | - | 8.32 | - | 721fddd6ee261592 |
| 2026-10-14T13:07:34Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 194 | 12.34 | e24c8bf76aaf4a269e81c4baa7e3fa39 | e1f474273c99f45d |
| 2026-10-14T13:07:35Z | c02-tr | duyu-1 | - | - | - | 12.34 | - | e1f474273c99f45d |
| 2026-10-14T13:07:38Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 198 | 14.42 | e2c023cfb43440989e33aad16f01bbf0 | cb2f0f2e08c5c9dc |
| 2026-10-14T13:07:39Z | c03-tr | duyu-1 | - | - | - | 14.42 | - | cb2f0f2e08c5c9dc |
| 2026-10-14T13:07:42Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 195 | 13.95 | b013482751974ae69cd4718175a282a1 | b0bb43967dcd36ef |
| 2026-10-14T13:07:43Z | c05-tr | duyu-1 | - | - | - | 13.95 | - | b0bb43967dcd36ef |
| 2026-10-14T13:07:45Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 71 | 4.96 | d60053ef82ab4afba4257b99c328a3c5 | 0f174e20340b77f4 |
| 2026-10-14T13:07:46Z | c07-tr | duyu-1 | - | - | - | 4.96 | - | 0f174e20340b77f4 |
| 2026-10-14T13:07:48Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 11.39 | fa6e36daffc34b278809de6e9ee6eb9c | 5cd58fa936d1b54a |
| 2026-10-14T13:07:50Z | c08-tr | duyu-1 | - | - | - | 11.39 | - | 5cd58fa936d1b54a |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T18:25:55Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 13890dff6b7d87c6 | audio/en/c01-ex1.mp3 |
| 2026-10-14T18:25:56Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 27 | 573b5abffed4836f | audio/en/c02-ex1.mp3 |
| 2026-10-14T18:25:57Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 25 | 26d810c2bfe52574 | audio/en/c02-ex2.mp3 |
| 2026-10-14T18:25:59Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 18 | 9bae03a5d7e34a8d | audio/en/c03-ex1.mp3 |
| 2026-10-14T18:26:00Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 16 | bcb4769577393de4 | audio/en/c03-ex2.mp3 |
| 2026-10-14T18:26:02Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 17 | 84f98eecf61d667d | audio/en/c03-ex3.mp3 |
| 2026-10-14T18:26:03Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 55 | 3400d768df1b8650 | audio/en/c04-ex1.mp3 |
| 2026-10-14T18:26:05Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 43 | 053f0af4ec9f6606 | audio/en/c04-ex2.mp3 |
| 2026-10-14T18:26:06Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | ec5d4c3c6bf04282 | audio/en/c04-ex3.mp3 |
| 2026-10-14T18:26:08Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | bb183619336b4e0b | audio/en/c04-ex4.mp3 |
| 2026-10-14T18:26:09Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 16 | ce213a0ec33cdc1d | audio/en/c04-ex5.mp3 |
| 2026-10-14T18:26:10Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 26 | 34beee44f15ad9bb | audio/en/c05-ex2.mp3 |
| 2026-10-14T18:26:11Z | c08-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 45 | c2b14cc6d13836ff | audio/en/c08-ex1.mp3 |
| 2026-11-27T18:20:48Z | c06-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.88 | 57c12a8bbf7e4876aee064e66a0827be | 111b1baf8f79a439 |
| 2026-11-27T18:20:49Z | c06-q1-fb | duyu-1 | - | - | - | 2.88 | - | 111b1baf8f79a439 |
| 2026-11-27T18:20:52Z | c06-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 2.72 | c4f4b003639344b6b9002ecd4f22d726 | bc918ea470fdfc23 |
| 2026-11-27T18:20:53Z | c06-q2-fb | duyu-1 | - | - | - | 2.72 | - | bc918ea470fdfc23 |
| 2026-11-27T18:20:55Z | c06-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.56 | 65cfabf1d82b4ad387b190569d536884 | 7123a2f56bb51de0 |
| 2026-11-27T18:20:56Z | c06-q3-fb | duyu-1 | - | - | - | 2.56 | - | 7123a2f56bb51de0 |
| 2026-11-27T18:20:58Z | c06-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.88 | e62bbd6c78da44929157538c92058682 | 033a107c626e89d5 |
| 2026-11-27T18:20:59Z | c06-q4-fb | duyu-1 | - | - | - | 2.88 | - | 033a107c626e89d5 |
| 2026-11-27T19:07:54Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 34a518264d7b4bf0af14abba287813eb | a81e126d31abb2ff |
| 2026-11-27T19:07:55Z | c01-ex1-tl | duyu-1 | - | - | - | 1.28 | - | a81e126d31abb2ff |
| 2026-11-27T19:07:57Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.4 | e523a9b4892443c39b0bc51db7f1c998 | 06b9319c7911e04f |
| 2026-11-27T19:07:58Z | c02-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 06b9319c7911e04f |
| 2026-11-27T19:08:00Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.88 | 2d083ffe59bf4d4e8fec369a3194c8ac | 79797f7feb9617cd |
| 2026-11-27T19:08:01Z | c02-ex2-tl | duyu-1 | - | - | - | 2.88 | - | 79797f7feb9617cd |
| 2026-11-27T19:08:03Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.44 | 851b8c5105eb416e8b1d639061d48636 | ea2a1f1ddfb45b83 |
| 2026-11-27T19:08:04Z | c03-ex1-tl | duyu-1 | - | - | - | 1.44 | - | ea2a1f1ddfb45b83 |
| 2026-11-27T19:08:06Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.44 | ac19f5da8e024833943d91e763ae22ef | 2cbc198ee2cbfc3a |
| 2026-11-27T19:08:07Z | c03-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 2cbc198ee2cbfc3a |
| 2026-11-27T19:08:09Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | dc4a5e50bacc43dbab22d987ffdc08e7 | 49a8f75f74e9441a |
| 2026-11-27T19:08:10Z | c03-ex3-tl | duyu-1 | - | - | - | 1.28 | - | 49a8f75f74e9441a |
| 2026-11-27T19:08:12Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 3.04 | f9e4e68b1e464673acee844131e2a5fa | 3ddc01c9fe8cc7ab |
| 2026-11-27T19:08:13Z | c04-ex1-tl | duyu-1 | - | - | - | 3.04 | - | 3ddc01c9fe8cc7ab |
| 2026-11-27T19:08:15Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 3.36 | a9b68f9951cb40df927eaac111d03e5e | 4bcf07f248a96861 |
| 2026-11-27T19:08:16Z | c04-ex2-tl | duyu-1 | - | - | - | 3.36 | - | 4bcf07f248a96861 |
| 2026-11-27T19:08:18Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.56 | f72d935c65194b66871e198e8eef2ce6 | e4f5c272ef6d1a77 |
| 2026-11-27T19:08:19Z | c04-ex3-tl | duyu-1 | - | - | - | 2.56 | - | e4f5c272ef6d1a77 |
| 2026-11-27T19:08:21Z | c04-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.08 | d3fe34bc83374b29b13c72daf16577bc | 54f51438ef09b1e0 |
| 2026-11-27T19:08:22Z | c04-ex4-tl | duyu-1 | - | - | - | 2.08 | - | 54f51438ef09b1e0 |
| 2026-11-27T19:08:24Z | c04-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.44 | 4b00a54b36f146ea841e600f2fb0c89e | d20368b20959fa62 |
| 2026-11-27T19:08:25Z | c04-ex5-tl | duyu-1 | - | - | - | 1.44 | - | d20368b20959fa62 |
| 2026-11-27T19:08:27Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.72 | 3b0d21ba1bbd4504be36585544321df8 | 8cb6fdaced95ba77 |
| 2026-11-27T19:08:28Z | c05-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 8cb6fdaced95ba77 |
| 2026-11-27T19:08:31Z | c08-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 2.88 | 1fae0e273f4f42d89fa53b6ebe65223d | ca4bac8e88ed7fe4 |
| 2026-11-27T19:08:32Z | c08-ex1-tl | duyu-1 | - | - | - | 2.88 | - | ca4bac8e88ed7fe4 |
