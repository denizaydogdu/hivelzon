# G-A2-13-conjunctions PROMPTS

Ders: Bağlaçlar: and / but / because / so ve when · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:11:47Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 139 | 8.48 | c4633653ce4c43e4b1dc36dba603a12f | 4e6df9049bb445e1 |
| 2026-10-14T13:11:48Z | c01-tr | duyu-1 | - | - | - | 8.48 | - | 4e6df9049bb445e1 |
| 2026-10-14T13:11:50Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 11.71 | 74acf0ff7e9d4ad4b7c6753b8aa3b7e1 | c5e262c6d9195897 |
| 2026-10-14T13:11:51Z | c02-tr | duyu-1 | - | - | - | 11.71 | - | c5e262c6d9195897 |
| 2026-10-14T13:11:54Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 155 | 10.59 | a3b86fb82e9e41d983728a643d7beca4 | e13b8c43a1905210 |
| 2026-10-14T13:11:55Z | c03-tr | duyu-1 | - | - | - | 10.59 | - | e13b8c43a1905210 |
| 2026-10-14T13:11:58Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 184 | 12.29 | b556375f69ed4d248d98a6f65417f1a4 | 34b4c7cd0778ca35 |
| 2026-10-14T13:11:59Z | c04-tr | duyu-1 | - | - | - | 12.29 | - | 34b4c7cd0778ca35 |
| 2026-10-14T13:12:02Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 212 | 12.83 | 23f74c72ce2d478685000664ffe0e9bd | 2bf9971e2b863d63 |
| 2026-10-14T13:12:03Z | c06-tr | duyu-1 | - | - | - | 12.83 | - | 2bf9971e2b863d63 |
| 2026-10-14T13:12:06Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 85 | 5.92 | c056928e2dca43f094e17e04337ca925 | 7e408f00f29ca34d |
| 2026-10-14T13:12:07Z | c08-tr | duyu-1 | - | - | - | 5.92 | - | 7e408f00f29ca34d |
| 2026-10-14T13:12:10Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 126 | 8.0 | e25a6f907c8d44e397d975808ba0fba0 | fd9b322783446ea8 |
| 2026-10-14T13:12:10Z | c09-tr | duyu-1 | - | - | - | 8.0 | - | fd9b322783446ea8 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:29:32Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 45 | 28c0da81f5dc1259 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:29:33Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 39 | 9b810e3193914ce0 | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:29:35Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 38 | e76c0c6b9b7847ee | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:29:37Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | ba0a8f1e037b39cf | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:29:39Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | 9df1b9346abc5d1b | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:29:40Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | 8b7fa75e2bf084b7 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:29:42Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | 956f703d0044fc28 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:29:45Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 34 | 12ffc2b1f764373f | audio/en/c04-ex3.mp3 |
| 2026-10-30T13:29:46Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | c3dc00db219066c4 | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:29:48Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 40 | 713d7cf1fd3dbc6a | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:29:49Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 38 | 46cc22182df882c5 | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:29:51Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 34 | 1f8f721a9e4f1a25 | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:29:53Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | b6bc8507b5765a89 | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:29:54Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | 3b7231a527696cef | audio/en/c06-ex1.mp3 |
| 2026-10-30T13:29:56Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 40 | 8f6e23172afcdf49 | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:23:24Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.88 | b3b4e45553ca43e1a162f7deb0bf8f75 | 1b946eede85cf768 |
| 2026-11-27T18:23:25Z | c07-q1-fb | duyu-1 | - | - | - | 2.88 | - | 1b946eede85cf768 |
| 2026-11-27T18:23:27Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.4 | 52cc9a20ea67420abbe850d5dfb53607 | ab64d436c67171ae |
| 2026-11-27T18:23:28Z | c07-q2-fb | duyu-1 | - | - | - | 2.4 | - | ab64d436c67171ae |
| 2026-11-27T18:23:30Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 3.04 | dd2aac9e83734d30afc973b0888de271 | 65b69eab171aa2e7 |
| 2026-11-27T18:23:31Z | c07-q3-fb | duyu-1 | - | - | - | 3.04 | - | 65b69eab171aa2e7 |
| 2026-11-27T18:23:33Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.92 | f6f921fa7d734d42bcd50ad4d10db232 | 82cb97ae74ae61e1 |
| 2026-11-27T18:23:34Z | c07-q4-fb | duyu-1 | - | - | - | 1.92 | - | 82cb97ae74ae61e1 |
| 2026-11-27T19:15:21Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.08 | 62052b438cf84f1d98687e4cf9b7a4ee | f58955d0404a5c70 |
| 2026-11-27T19:15:22Z | c01-ex1-tl | duyu-1 | - | - | - | 2.08 | - | f58955d0404a5c70 |
| 2026-11-27T19:15:24Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 3.04 | f552b76bbe5a4bf79c2a72f5855f0b33 | 3d25e1e9fa075e4d |
| 2026-11-27T19:15:25Z | c02-ex1-tl | duyu-1 | - | - | - | 3.04 | - | 3d25e1e9fa075e4d |
| 2026-11-27T19:15:28Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.24 | 92333326989e4dda90a70082834618f1 | df721cc70d7fc09c |
| 2026-11-27T19:15:28Z | c02-ex2-tl | duyu-1 | - | - | - | 2.24 | - | df721cc70d7fc09c |
| 2026-11-27T19:15:31Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 3.2 | 6625bcec310d4e8bb5c98f4e2d3877ba | d73cfee43ddb6a5e |
| 2026-11-27T19:15:32Z | c03-ex1-tl | duyu-1 | - | - | - | 3.2 | - | d73cfee43ddb6a5e |
| 2026-11-27T19:15:34Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.56 | 5c5edf36814a48738c5048b448f804a8 | 693f798777cf1639 |
| 2026-11-27T19:15:35Z | c03-ex2-tl | duyu-1 | - | - | - | 2.56 | - | 693f798777cf1639 |
| 2026-11-27T19:15:38Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 3.04 | 95a5688458cd414f9d2eb8aed11856c2 | e683d16885074184 |
| 2026-11-27T19:15:39Z | c04-ex1-tl | duyu-1 | - | - | - | 3.04 | - | e683d16885074184 |
| 2026-11-27T19:15:41Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.08 | 0ed90df5d629406bb6b8ef56e0dd6c65 | ae2b93b6d49a61e6 |
| 2026-11-27T19:15:42Z | c04-ex2-tl | duyu-1 | - | - | - | 2.08 | - | ae2b93b6d49a61e6 |
| 2026-11-27T19:15:44Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.04 | 85b03a9de529460ba0639000a8d90675 | 39f418378b309603 |
| 2026-11-27T19:15:45Z | c04-ex3-tl | duyu-1 | - | - | - | 3.04 | - | 39f418378b309603 |
| 2026-11-27T19:15:48Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.88 | 004d9ecd249b4c68905d4fbf429a9f5c | da526995eebb16d0 |
| 2026-11-27T19:15:49Z | c05-ex1-tl | duyu-1 | - | - | - | 2.88 | - | da526995eebb16d0 |
| 2026-11-27T19:15:51Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.24 | cd90ab4e21c2412298e81eb1b222b586 | 68a26f2ec2ededc4 |
| 2026-11-27T19:15:52Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 68a26f2ec2ededc4 |
| 2026-11-27T19:15:54Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 3.04 | b0adf5a9b98945d1b7e7765120f009ab | 0bf27cbcc3d9a97e |
| 2026-11-27T19:15:55Z | c05-ex3-tl | duyu-1 | - | - | - | 3.04 | - | 0bf27cbcc3d9a97e |
| 2026-11-27T19:15:58Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.4 | 4aa74fa7cf274b05a6498dce59c192c2 | 0e59c5f915a94fa3 |
| 2026-11-27T19:15:59Z | c05-ex4-tl | duyu-1 | - | - | - | 2.4 | - | 0e59c5f915a94fa3 |
| 2026-11-27T19:16:01Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.08 | 5697f8c5f32b4dd099f9245e7352d5ed | 912d4c7d771a28d0 |
| 2026-11-27T19:16:02Z | c05-ex5-tl | duyu-1 | - | - | - | 2.08 | - | 912d4c7d771a28d0 |
| 2026-11-27T19:16:03Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | 61d8a6a05d9c427cab602b1d833dc5e4 | 645d1e6fee04f72f |
| 2026-11-27T19:16:04Z | c06-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 645d1e6fee04f72f |
| 2026-11-27T19:16:06Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.08 | 326707e4bdfd477c8fca74ed1865ea71 | 88df35d4ca61a312 |
| 2026-11-27T19:16:07Z | c06-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 88df35d4ca61a312 |
