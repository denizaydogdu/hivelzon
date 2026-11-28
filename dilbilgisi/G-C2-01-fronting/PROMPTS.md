# G-C2-01-fronting PROMPTS

Ders: Öne alma ve bilgi yapısı (fronting): Little did she know…, Such was… · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:40:46Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 173 | 11.39 | 1c8968f4e6e4467b8400a2147863cb24 | 6ee78bef475f5be0 |
| 2026-10-14T14:40:47Z | c01-tr | duyu-1 | - | - | - | 11.39 | - | 6ee78bef475f5be0 |
| 2026-10-14T14:40:50Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 220 | 13.61 | 5fb52ecc400d47128ddad5b52ea7e2ec | 9240f65a583e24fc |
| 2026-10-14T14:40:51Z | c02-tr | duyu-1 | - | - | - | 13.61 | - | 9240f65a583e24fc |
| 2026-10-14T14:40:54Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 197 | 13.3 | 64643ae75b6447ad81d399ce70399db6 | f4e89c67d9067a5b |
| 2026-10-14T14:40:56Z | c03-tr | duyu-1 | - | - | - | 13.3 | - | f4e89c67d9067a5b |
| 2026-10-14T14:40:59Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 228 | 16.74 | 310dc0219067451e82ba86c86c6378b7 | 8768363dd895e472 |
| 2026-10-14T14:41:00Z | c04-tr | duyu-1 | - | - | - | 16.74 | - | 8768363dd895e472 |
| 2026-10-14T14:41:04Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 235 | 16.48 | 0a36f6cbbfdc412d8d33ee2ffc7a3d67 | 1c4d527f785f2652 |
| 2026-10-14T14:41:05Z | c06-tr | duyu-1 | - | - | - | 16.48 | - | 1c4d527f785f2652 |
| 2026-10-14T14:41:08Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 194 | 12.98 | 9896616ef69c4f23880b4603eae5fa59 | 320c8e9e147f0a0a |
| 2026-10-14T14:41:09Z | c08-tr | duyu-1 | - | - | - | 12.98 | - | 320c8e9e147f0a0a |
| 2026-11-20T16:02:35Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 187 | 12.26 | b6c982ebcf374596ab173fed0e5b578c | 19ad19177d62dca5 |
| 2026-11-20T16:02:39Z | c01-tr | duyu-1 | - | - | - | 12.26 | - | 19ad19177d62dca5 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:10:18Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 60 | fb76974f0a4b802a | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:10:20Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 43 | 517c26b1ead57d32 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:10:22Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 46 | 0c039f556a4ec956 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:10:24Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 54 | 6af88ed5d3d1987c | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:10:25Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 36 | 72cbfc45ce4644a4 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:10:27Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 23 | c96dbb8e77fbb17e | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:10:29Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 48 | e952d88c97d97a96 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:10:30Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 46 | 2dd49bcde313b4ee | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:10:32Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 53 | c058d6445eb3e78a | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:10:34Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 37 | b51d91fa69e95a01 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:10:35Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 38 | 2e995b9ef4e38ba5 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:10:37Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 38 | fa455884b900439b | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:10:38Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 37 | a1922e60898be367 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:10:41Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 60 | a8e664b15a535a5a | audio/en/c07-q5.mp3 |
| 2026-11-27T18:32:07Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 66 | 5.12 | 7f003daba464428e82e6aed78493f67a | 883865c88ae9d3b0 |
| 2026-11-27T18:32:08Z | c07-q1-fb | duyu-1 | - | - | - | 5.12 | - | 883865c88ae9d3b0 |
| 2026-11-27T18:32:11Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 3.04 | f0d4207aa3dd414493e5bec4d8052a45 | af83eadc3068c16c |
| 2026-11-27T18:32:12Z | c07-q2-fb | duyu-1 | - | - | - | 3.04 | - | af83eadc3068c16c |
| 2026-11-27T18:32:14Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 51 | 3.68 | 7eef76a1a49f4f72b140ad031cac9208 | 30b8245771c43f0d |
| 2026-11-27T18:32:15Z | c07-q3-fb | duyu-1 | - | - | - | 3.68 | - | 30b8245771c43f0d |
| 2026-11-27T18:32:18Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 3.36 | 0a63497285da4704afcf68290deb2f67 | 86f1dda287645ff9 |
| 2026-11-27T18:32:19Z | c07-q4-fb | duyu-1 | - | - | - | 3.36 | - | 86f1dda287645ff9 |
| 2026-11-27T19:41:45Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 85 | 5.44 | d799b46ee0f848dc98c719fe331e8bfe | 1282fb95d4a10c2b |
| 2026-11-27T19:41:46Z | c01-ex1-tl | duyu-1 | - | - | - | 5.44 | - | 1282fb95d4a10c2b |
| 2026-11-27T19:41:49Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.72 | 63e28e1e2cf64d25bbbcd86df3eda43e | f3ebb55a63033ae0 |
| 2026-11-27T19:41:50Z | c02-ex1-tl | duyu-1 | - | - | - | 2.72 | - | f3ebb55a63033ae0 |
| 2026-11-27T19:41:52Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.72 | 7c37f57f4edc438bb3a7b38910067793 | f2670bc2ae774dd1 |
| 2026-11-27T19:41:52Z | c03-ex1-tl | duyu-1 | - | - | - | 2.72 | - | f2670bc2ae774dd1 |
| 2026-11-27T19:41:54Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.4 | 9688de43480a483db23b18facf25632f | e246aacebf8bb4d0 |
| 2026-11-27T19:41:55Z | c03-ex2-tl | duyu-1 | - | - | - | 2.4 | - | e246aacebf8bb4d0 |
| 2026-11-27T19:41:58Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 2.56 | 77e82bb192dc42a5b321aea42a33c6bf | 8ed4957b31a4ecc6 |
| 2026-11-27T19:41:59Z | c04-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 8ed4957b31a4ecc6 |
| 2026-11-27T19:42:01Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 3.04 | 76889b7bf0624e0e8ba6d0f604230751 | f4a9bf718864f233 |
| 2026-11-27T19:42:02Z | c04-ex2-tl | duyu-1 | - | - | - | 3.04 | - | f4a9bf718864f233 |
| 2026-11-27T19:42:04Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 2.88 | f800e98b0ac44f1d9b90bb07b6bed98d | 5f4a2c8e1c13cb17 |
| 2026-11-27T19:42:05Z | c05-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 5f4a2c8e1c13cb17 |
| 2026-11-27T19:42:07Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.08 | a99ab205c7e44804b2b934b8897f0cca | 4a9731e1e5f4e389 |
| 2026-11-27T19:42:08Z | c05-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 4a9731e1e5f4e389 |
| 2026-11-27T19:42:11Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 3.36 | dd4a6f02cbd2408ead17e10096495f6b | cb9813ab921b3b81 |
| 2026-11-27T19:42:12Z | c05-ex3-tl | duyu-1 | - | - | - | 3.36 | - | cb9813ab921b3b81 |
| 2026-11-27T19:42:14Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.24 | 88f8b3ee00c84638ae4658a2c0fb19ca | 36e2423b96dcf68f |
| 2026-11-27T19:42:15Z | c05-ex4-tl | duyu-1 | - | - | - | 2.24 | - | 36e2423b96dcf68f |
| 2026-11-27T19:42:17Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.72 | 7fa691207d604e86b24278490a024b48 | 74fa0723b806c994 |
| 2026-11-27T19:42:18Z | c05-ex5-tl | duyu-1 | - | - | - | 2.72 | - | 74fa0723b806c994 |
| 2026-11-27T19:42:21Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 2.88 | cbf776e95d554e7495619cd16c0b159c | 9dced4cdb600f5e3 |
| 2026-11-27T19:42:22Z | c06-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 9dced4cdb600f5e3 |
| 2026-11-27T19:42:24Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 2.88 | 5d7a892f54244ece9b2873e68a514013 | 57dd601df224afe5 |
| 2026-11-27T19:42:25Z | c06-ex2-tl | duyu-1 | - | - | - | 2.88 | - | 57dd601df224afe5 |
| 2026-11-27T19:42:27Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 53 | 3.04 | 27f02582b7914bbc9b63953fe93a06f9 | 768fdcb9ba6dbede |
| 2026-11-27T19:42:28Z | c07-q5-tl | duyu-1 | - | - | - | 3.04 | - | 768fdcb9ba6dbede |
