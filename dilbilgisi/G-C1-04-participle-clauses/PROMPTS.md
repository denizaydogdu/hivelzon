# G-C1-04-participle-clauses PROMPTS

Ders: Ortaç yan cümleleri (participle clauses): Having finished…, Walking home… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: önceki dalgaların dersleri (`G-B2-01-passive`, `G-B1-01-present-perfect-experience`, `G-A2-04-past-simple-regular`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, sade ve suçlamasız (C düzeyinde de). İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. C1/C2 kapsaması Octanove listesi depoda olmadığı için denetlenmedi (`grammar_lint.py` uyarısı).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ing` → "ing" (Alania söyleniş sözlüğü, `lesson.json`).

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h082.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:38:34Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 129 | 8.64 | fcbacb79e1af41c595e5beaeddd51087 | 8c2d410575541691 |
| 2026-10-14T14:38:35Z | c01-tr | duyu-1 | - | - | - | 8.64 | - | 8c2d410575541691 |
| 2026-10-14T14:38:38Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 204 | 13.43 | 9ff3da41190d458e9acc194c36b2b229 | 3b1b46268227f401 |
| 2026-10-14T14:38:40Z | c02-tr | duyu-1 | - | - | - | 13.43 | - | 3b1b46268227f401 |
| 2026-10-14T14:38:43Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 172 | 12.16 | 76f8fb8a04394f4bb08e760a110e30ca | 09f9489c5ed9e867 |
| 2026-10-14T14:38:44Z | c03-tr | duyu-1 | - | - | - | 12.16 | - | 09f9489c5ed9e867 |
| 2026-10-14T14:38:47Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 185 | 11.69 | 0abafe2109964ce384ea8c370249f4fd | 5cc260e6902abdd1 |
| 2026-10-14T14:38:49Z | c04-tr | duyu-1 | - | - | - | 11.69 | - | 5cc260e6902abdd1 |
| 2026-10-14T14:38:52Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 221 | 15.32 | b1af9b7d0be742a79044f0e01c9d189a | 5b2e5d7ece16b563 |
| 2026-10-14T14:38:54Z | c06-tr | duyu-1 | - | - | - | 15.32 | - | 5b2e5d7ece16b563 |
| 2026-10-14T14:38:57Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 185 | 13.31 | 8aac8ed0524d453b86a55403e6772a92 | a3a6ba442fb8a960 |
| 2026-10-14T14:38:58Z | c08-tr | duyu-1 | - | - | - | 13.31 | - | a3a6ba442fb8a960 |
| 2026-11-20T16:01:40Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 149 | 10.52 | 9cf4be0ed19e42e4bb0e880977bd5bbf | a209a828228c1056 |
| 2026-11-20T16:01:42Z | c01-tr | duyu-1 | - | - | - | 10.52 | - | a209a828228c1056 |
| 2026-11-20T16:10:37Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 149 | 10.04 | 71977175fcdf4cd49f7a5fd1e0809859 | ed627b1ae0eb5f06 |
| 2026-11-20T16:10:40Z | c01-tr | duyu-1 | - | - | - | 10.04 | - | ed627b1ae0eb5f06 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:08:13Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 41 | 30bae2242ce5963b | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:08:15Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 35 | 24cde46f49210537 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:08:17Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 802d1ba735b8c318 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:08:19Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 6a63c9e40d1bd421 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:08:21Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 35 | bf44e52344305e15 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:08:23Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 45 | a0484c38c1e1809c | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:08:25Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 52 | 10bff5ac4e856dc1 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:08:28Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 53 | c236c048edef4746 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:08:30Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 06d2e8b583c19440 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:08:32Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | d5ce2d647d275b94 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:08:34Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | 3743959e3e04968c | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:08:36Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | 335bacf23d5c6e5a | audio/en/c06-ex3.mp3 |
| 2026-11-27T18:30:58Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 59 | 4.0 | 49c527b5c9184b49a80040952a09b622 | 5652683acb27b850 |
| 2026-11-27T18:30:59Z | c07-q1-fb | duyu-1 | - | - | - | 4.0 | - | 5652683acb27b850 |
| 2026-11-27T18:31:02Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 3.52 | e9b2d1bb4cc34540beb6984dd8ec2b49 | 826a2e4bdf86f68b |
| 2026-11-27T18:31:03Z | c07-q2-fb | duyu-1 | - | - | - | 3.52 | - | 826a2e4bdf86f68b |
| 2026-11-27T18:31:05Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 64 | 4.8 | 89321d6cce3541288fc8c1525d086b95 | e0bfb24d56a46fc1 |
| 2026-11-27T18:31:07Z | c07-q3-fb | duyu-1 | - | - | - | 4.8 | - | e0bfb24d56a46fc1 |
| 2026-11-27T18:31:10Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.24 | 65830ba0eb4a49d3a1ac553d596400ec | d50679bf1b842246 |
| 2026-11-27T18:31:11Z | c07-q4-fb | duyu-1 | - | - | - | 2.24 | - | d50679bf1b842246 |
| 2026-11-27T19:38:06Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 2.88 | b1a5c42deb5f4e12b7f652af374b6970 | bab9b1719cb97205 |
| 2026-11-27T19:38:07Z | c01-ex1-tl | duyu-1 | - | - | - | 2.88 | - | bab9b1719cb97205 |
| 2026-11-27T19:38:10Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.24 | 2596723482da4e0aa7e7769fd9d1c34e | 9234462f099ab257 |
| 2026-11-27T19:38:11Z | c02-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 9234462f099ab257 |
| 2026-11-27T19:38:13Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.24 | 65f5c12e574248f9839d6c74e9528178 | b8f47c42698dd196 |
| 2026-11-27T19:38:14Z | c03-ex1-tl | duyu-1 | - | - | - | 2.24 | - | b8f47c42698dd196 |
| 2026-11-27T19:38:16Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 3.36 | 7ff065e31b5e405b8cb2d48cd35edb84 | 58ace2de91d246b4 |
| 2026-11-27T19:38:17Z | c04-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 58ace2de91d246b4 |
| 2026-11-27T19:38:20Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 2.72 | 217655e47ac24425898b006aa4d6f50e | 1fe70ff9c7f86f15 |
| 2026-11-27T19:38:21Z | c05-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 1fe70ff9c7f86f15 |
| 2026-11-27T19:38:23Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 62 | 5.12 | 281ea1bbfb734391b634627e601dad2c | 5e9552f20481de4a |
| 2026-11-27T19:38:24Z | c05-ex2-tl | duyu-1 | - | - | - | 5.12 | - | 5e9552f20481de4a |
| 2026-11-27T19:38:27Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 58 | 4.0 | a232f3140f8d4fad9c4486307cffb1c7 | 15bf2d28cafbf54d |
| 2026-11-27T19:38:28Z | c05-ex3-tl | duyu-1 | - | - | - | 4.0 | - | 15bf2d28cafbf54d |
| 2026-11-27T19:38:31Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 3.2 | 78abbf5579cc45cd90541d5acc620058 | fe83ecd914a1dab9 |
| 2026-11-27T19:38:32Z | c05-ex4-tl | duyu-1 | - | - | - | 3.2 | - | fe83ecd914a1dab9 |
| 2026-11-27T19:38:34Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.88 | 50eb9ab98ccd40f88b5678666ef941f0 | c7b84341b4227dda |
| 2026-11-27T19:38:35Z | c05-ex5-tl | duyu-1 | - | - | - | 2.88 | - | c7b84341b4227dda |
| 2026-11-27T19:38:37Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.88 | 19c1c228aa7148078a05c862a9cb030a | 167509c58a68b1a2 |
| 2026-11-27T19:38:38Z | c06-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 167509c58a68b1a2 |
| 2026-11-27T19:38:41Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | 19b9ee0158c14b349e041a63ad6f3dbe | 95b4047c249dd87c |
| 2026-11-27T19:38:42Z | c06-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 95b4047c249dd87c |
| 2026-11-27T19:38:44Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 4.32 | 316918770c28476eab0cd29db4934fdd | 50397c09b7b63bba |
| 2026-11-27T19:38:45Z | c06-ex3-tl | duyu-1 | - | - | - | 4.32 | - | 50397c09b7b63bba |
