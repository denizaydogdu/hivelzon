# G-A2-03-was-were PROMPTS

Ders: was / were: geçmişte "idi" · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:07:52Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 7.68 | fb4bd3c148c44042bf3651aac4cbd56e | 200596b5206acfdb |
| 2026-10-14T13:07:53Z | c01-tr | duyu-1 | - | - | - | 7.68 | - | 200596b5206acfdb |
| 2026-10-14T13:07:56Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 135 | 10.4 | 09570f5abce548b4b19036b3f36747a9 | 3a7078f97f242d76 |
| 2026-10-14T13:07:57Z | c02-tr | duyu-1 | - | - | - | 10.4 | - | 3a7078f97f242d76 |
| 2026-10-14T13:08:00Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 145 | 10.43 | fd143735f68548f99ddfb4358fe70c7f | 8e1ce71a1b98debb |
| 2026-10-14T13:08:01Z | c03-tr | duyu-1 | - | - | - | 10.43 | - | 8e1ce71a1b98debb |
| 2026-10-14T13:08:04Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 11.8 | cfd62ab3aa9d4fd897d6af552d59e005 | c6d8025bcb14a9fc |
| 2026-10-14T13:08:06Z | c05-tr | duyu-1 | - | - | - | 11.8 | - | c6d8025bcb14a9fc |
| 2026-10-14T13:08:08Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 76 | 4.64 | 6c498ddf26cd43fcb5ecc7067ae1fead | 6c4eb41663beb98e |
| 2026-10-14T13:08:09Z | c07-tr | duyu-1 | - | - | - | 4.64 | - | 6c4eb41663beb98e |
| 2026-10-14T13:08:11Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 115 | 7.52 | 4a80b046392c456a909aa12b64cf2415 | 2fd54b00e8ab4fc7 |
| 2026-10-14T13:08:12Z | c08-tr | duyu-1 | - | - | - | 7.52 | - | 2fd54b00e8ab4fc7 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T18:26:13Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 43 | f62aa5244fb400ab | audio/en/c01-ex1.mp3 |
| 2026-10-14T18:26:14Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 14 | 5ed3b02fd5b9d3c9 | audio/en/c02-ex1.mp3 |
| 2026-10-14T18:26:15Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 14 | 423bb55c323a4a61 | audio/en/c02-ex2.mp3 |
| 2026-10-14T18:26:16Z | c02-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 21 | 6be88a3d2e4cd3a7 | audio/en/c02-ex3.mp3 |
| 2026-10-14T18:26:17Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 15 | c7b9add5096f5773 | audio/en/c03-ex1.mp3 |
| 2026-10-14T18:26:18Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 15 | dcba0bcb1de8fdb2 | audio/en/c03-ex2.mp3 |
| 2026-10-14T18:26:20Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | cafa15f3d1398426 | audio/en/c04-ex1.mp3 |
| 2026-10-14T18:26:21Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 22b94e0557da73b0 | audio/en/c04-ex2.mp3 |
| 2026-10-14T18:26:22Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | 7875fc15b91adca4 | audio/en/c04-ex3.mp3 |
| 2026-10-14T18:26:24Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 6d4f687df607a5f8 | audio/en/c04-ex4.mp3 |
| 2026-10-14T18:26:25Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 16 | 39d0f87cd67cd0b2 | audio/en/c04-ex5.mp3 |
| 2026-10-14T18:26:26Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | bc104e83314edc34 | audio/en/c05-ex1.mp3 |
| 2026-10-14T18:26:27Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | 18530d3eb5b14c41 | audio/en/c05-ex2.mp3 |
| 2026-10-14T18:26:28Z | c08-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | 0913319c6a2c5531 | audio/en/c08-ex1.mp3 |
| 2026-11-27T18:21:02Z | c06-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.24 | 38e470fc04c0419f9785798267f2fedd | 7ed43a01ae6f9ace |
| 2026-11-27T18:21:03Z | c06-q1-fb | duyu-1 | - | - | - | 2.24 | - | 7ed43a01ae6f9ace |
| 2026-11-27T18:21:05Z | c06-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 2.72 | 283f81973ddc46038a64958c61e51864 | a98bdd91cbb257c4 |
| 2026-11-27T18:21:06Z | c06-q2-fb | duyu-1 | - | - | - | 2.72 | - | a98bdd91cbb257c4 |
| 2026-11-27T18:21:08Z | c06-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 3.52 | dd92821822614538be43c57c0c73781a | 66fcf121e220021f |
| 2026-11-27T18:21:09Z | c06-q3-fb | duyu-1 | - | - | - | 3.52 | - | 66fcf121e220021f |
| 2026-11-27T18:21:12Z | c06-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.56 | b1720b5d055d433ab7764d156f1e8fb0 | df8bc51752e81cac |
| 2026-11-27T18:21:13Z | c06-q4-fb | duyu-1 | - | - | - | 2.56 | - | df8bc51752e81cac |
| 2026-11-27T19:08:34Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.24 | d2f2142462d8447ca2b9a4aa2cc1e1f8 | 8965e8343564268b |
| 2026-11-27T19:08:35Z | c01-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 8965e8343564268b |
| 2026-11-27T19:08:37Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.12 | 920c7910d78248788acbd8e067ae9685 | 983c6a875535bc2d |
| 2026-11-27T19:08:38Z | c02-ex1-tl | duyu-1 | - | - | - | 1.12 | - | 983c6a875535bc2d |
| 2026-11-27T19:08:40Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.12 | eea277d8536f4580a107fec1ac1abc1b | 794d9e18ac8fde13 |
| 2026-11-27T19:08:41Z | c02-ex2-tl | duyu-1 | - | - | - | 1.12 | - | 794d9e18ac8fde13 |
| 2026-11-27T19:08:43Z | c02-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | 81236ec4ab034b45975d3714db0c2fe9 | 2011108561c96894 |
| 2026-11-27T19:08:44Z | c02-ex3-tl | duyu-1 | - | - | - | 1.28 | - | 2011108561c96894 |
| 2026-11-27T19:08:45Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | 1e5f81a0a9e048b78ce0077de4f2b3ba | ee138ea5971ceed5 |
| 2026-11-27T19:08:46Z | c03-ex1-tl | duyu-1 | - | - | - | 1.44 | - | ee138ea5971ceed5 |
| 2026-11-27T19:08:48Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | ad3dc5adfa4b452f937f2d3835dad446 | b1181c42a09cc9e7 |
| 2026-11-27T19:08:49Z | c03-ex2-tl | duyu-1 | - | - | - | 1.28 | - | b1181c42a09cc9e7 |
| 2026-11-27T19:08:51Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.44 | 58c133e08a34450ab6964e318444ab45 | 8c67ce4aa61392f4 |
| 2026-11-27T19:08:52Z | c04-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 8c67ce4aa61392f4 |
| 2026-11-27T19:08:54Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 3.68 | a122aaa0c8e64087862b96e6a4a7f248 | 846d076a1273f89e |
| 2026-11-27T19:08:56Z | c04-ex2-tl | duyu-1 | - | - | - | 3.68 | - | 846d076a1273f89e |
| 2026-11-27T19:08:58Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 3.36 | 243ebadc64f941e290048171ea63721c | 03de8f20b4e2edaf |
| 2026-11-27T19:08:59Z | c04-ex3-tl | duyu-1 | - | - | - | 3.36 | - | 03de8f20b4e2edaf |
| 2026-11-27T19:09:02Z | c04-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.24 | 3f4e2d68793544d198a81f635fbcb80b | b2a75a6aaa15bae9 |
| 2026-11-27T19:09:03Z | c04-ex4-tl | duyu-1 | - | - | - | 2.24 | - | b2a75a6aaa15bae9 |
| 2026-11-27T19:09:04Z | c04-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.12 | cff30de7a79c4daea42c8b04b80197df | 57315eb1f19b8e46 |
| 2026-11-27T19:09:05Z | c04-ex5-tl | duyu-1 | - | - | - | 1.12 | - | 57315eb1f19b8e46 |
| 2026-11-27T19:09:07Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | 2e2c7a61913d4825a459de9e4e339255 | cf9a6595cde3034e |
| 2026-11-27T19:09:08Z | c05-ex1-tl | duyu-1 | - | - | - | 1.28 | - | cf9a6595cde3034e |
| 2026-11-27T19:09:10Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | 5fd603cd097f4d5e899458c05b6de556 | 6560b3b58065a8fb |
| 2026-11-27T19:09:11Z | c05-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 6560b3b58065a8fb |
| 2026-11-27T19:09:13Z | c08-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.6 | 8bd3f39968d1460c9bedf382e091f8a4 | 86b832f05f44fe5c |
| 2026-11-27T19:09:14Z | c08-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 86b832f05f44fe5c |
