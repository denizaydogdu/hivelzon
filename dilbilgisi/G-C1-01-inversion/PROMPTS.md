# G-C1-01-inversion PROMPTS

Ders: Devrik yapı (inversion): Never have I…, Not only… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:37:14Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.75 | 6c65486c1d7a498c8c7e62222e82b463 | 97cca81464d7effb |
| 2026-10-14T14:37:15Z | c01-tr | duyu-1 | - | - | - | 10.75 | - | 97cca81464d7effb |
| 2026-10-14T14:37:18Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 179 | 13.46 | 5fcbc448d62f4605b2f9fd2a71dfe969 | 742e1db8773fdc25 |
| 2026-10-14T14:37:19Z | c02-tr | duyu-1 | - | - | - | 13.46 | - | 742e1db8773fdc25 |
| 2026-10-14T14:37:23Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 206 | 13.63 | 015d82528e034bfebea0a6144cd77084 | 468c3c08febf4b6b |
| 2026-10-14T14:37:24Z | c03-tr | duyu-1 | - | - | - | 13.63 | - | 468c3c08febf4b6b |
| 2026-10-14T14:37:28Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 235 | 16.19 | 020a2015022d44b9b7566b2e77df6d29 | f084c54351ed9be1 |
| 2026-10-14T14:37:29Z | c04-tr | duyu-1 | - | - | - | 16.19 | - | f084c54351ed9be1 |
| 2026-10-14T14:37:33Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 232 | 16.28 | 3b408914283b479085a63e680f3ef961 | 6220fcd7ac604e1f |
| 2026-10-14T14:37:35Z | c06-tr | duyu-1 | - | - | - | 16.28 | - | 6220fcd7ac604e1f |
| 2026-10-14T14:37:39Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 160 | 12.28 | 824fdd30f2464e20805e425b93d34c68 | 4d57c0eda4aaceb3 |
| 2026-10-14T14:37:40Z | c08-tr | duyu-1 | - | - | - | 12.28 | - | 4d57c0eda4aaceb3 |
| 2026-11-20T16:01:12Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 175 | 12.03 | 56af06cdf00748908f66386100e2b036 | 7263aa8241ef1c19 |
| 2026-11-20T16:01:15Z | c01-tr | duyu-1 | - | - | - | 12.03 | - | 7263aa8241ef1c19 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:06:48Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 29 | 9a62de08ce6e4421 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:06:50Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 30 | e1f894938328fff4 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:06:53Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 30 | b56ea58ad5dc4114 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:06:57Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 61 | 2bb5cc80290ef1b1 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:06:59Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 43 | fd0d538b4ea7e01c | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:07:01Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | cf9b671c38918386 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:07:03Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | 87bf958707059b4b | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:07:05Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 27 | b7b0f6ec04e1dd4c | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:07:08Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | 0e57e919003507fc | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:07:09Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 46 | 1a8833259a2c4aa1 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:07:11Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 46 | e02913a4d510db19 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:07:13Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 49 | a34f9fe52230fbc1 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:07:15Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 32 | ed62b6b4c7697215 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:07:17Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 27 | 0df2061a2de74f8a | audio/en/c06-ex3.mp3 |
| 2026-11-26T14:07:19Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 3e5de10fb07f1c37 | audio/en/c07-q5.mp3 |
| 2026-11-27T18:30:13Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 65 | 4.64 | e5ad7f18218c4e1ca528f96eb4a23519 | dc10964ddf07a750 |
| 2026-11-27T18:30:14Z | c07-q1-fb | duyu-1 | - | - | - | 4.64 | - | dc10964ddf07a750 |
| 2026-11-27T18:30:17Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 3.84 | 6fde8a90034a4526aa536009b95f0198 | ab5fd746c376caa6 |
| 2026-11-27T18:30:18Z | c07-q2-fb | duyu-1 | - | - | - | 3.84 | - | ab5fd746c376caa6 |
| 2026-11-27T18:30:21Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 77 | 5.92 | a9d470e59c4940c89cf9a8c0a4f7a93b | 8527592e266debab |
| 2026-11-27T18:30:22Z | c07-q3-fb | duyu-1 | - | - | - | 5.92 | - | 8527592e266debab |
| 2026-11-27T18:30:25Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 60 | 4.32 | f6797fb6c48c41608b3e964fec900e9e | 135518010ec8218e |
| 2026-11-27T18:30:26Z | c07-q4-fb | duyu-1 | - | - | - | 4.32 | - | 135518010ec8218e |
| 2026-11-27T19:35:57Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.88 | bfc3f20c264c4d3c837d19ff6f3e60f0 | 025c1d86a52c921b |
| 2026-11-27T19:35:58Z | c01-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 025c1d86a52c921b |
| 2026-11-27T19:36:00Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.88 | 9b24eb6f5c244573b99f2ade07c16749 | 091114e20ef80121 |
| 2026-11-27T19:36:01Z | c02-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 091114e20ef80121 |
| 2026-11-27T19:36:03Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.08 | 8e3d1aba9701419ba49604540082e00f | dfd20b655933c35a |
| 2026-11-27T19:36:04Z | c02-ex2-tl | duyu-1 | - | - | - | 2.08 | - | dfd20b655933c35a |
| 2026-11-27T19:36:06Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 3.04 | dc186bf80d894dcb9b6392e16d5bb59c | 58b41c1698690743 |
| 2026-11-27T19:36:07Z | c03-ex1-tl | duyu-1 | - | - | - | 3.04 | - | 58b41c1698690743 |
| 2026-11-27T19:36:10Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.08 | e505922c0d4a43a8a5933ea64660017d | b593d2185036a339 |
| 2026-11-27T19:36:11Z | c03-ex2-tl | duyu-1 | - | - | - | 2.08 | - | b593d2185036a339 |
| 2026-11-27T19:36:13Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | a96797e482504e44b9821daad40ad47f | 0c65d728272a2321 |
| 2026-11-27T19:36:14Z | c04-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 0c65d728272a2321 |
| 2026-11-27T19:36:16Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | 02acf03d53b746e3be5305c93e7d4dab | 62c726a3ec1934d2 |
| 2026-11-27T19:36:17Z | c04-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 62c726a3ec1934d2 |
| 2026-11-27T19:36:19Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.24 | 1046bb1e333b4eeabdf4634453af4043 | a78f261f5eca72b3 |
| 2026-11-27T19:36:20Z | c05-ex1-tl | duyu-1 | - | - | - | 2.24 | - | a78f261f5eca72b3 |
| 2026-11-27T19:36:22Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | 5055c35d4f3448468449ea1f9d2fc1bd | 49b3c82d88e79c74 |
| 2026-11-27T19:36:23Z | c05-ex2-tl | duyu-1 | - | - | - | 1.92 | - | 49b3c82d88e79c74 |
| 2026-11-27T19:36:25Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.88 | ef4e7b1573474a5594118022a23f842a | f23c15e99bc48b5c |
| 2026-11-27T19:36:26Z | c05-ex3-tl | duyu-1 | - | - | - | 2.88 | - | f23c15e99bc48b5c |
| 2026-11-27T19:36:28Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.24 | c52715d476ae436b836f59a2c0cc91fd | 7ab1d87df93cf83b |
| 2026-11-27T19:36:29Z | c05-ex4-tl | duyu-1 | - | - | - | 2.24 | - | 7ab1d87df93cf83b |
| 2026-11-27T19:36:31Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 3.36 | ffa4a0e7f4894a51868af9daa624efca | 59be5069caa50973 |
| 2026-11-27T19:36:32Z | c05-ex5-tl | duyu-1 | - | - | - | 3.36 | - | 59be5069caa50973 |
| 2026-11-27T19:36:35Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 4.16 | c0d6858f9f984a13946981b80c91b5a8 | b4a08a9cf7c2a89f |
| 2026-11-27T19:36:36Z | c06-ex1-tl | duyu-1 | - | - | - | 4.16 | - | b4a08a9cf7c2a89f |
| 2026-11-27T19:36:38Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.72 | fa191a9fcc6648759a7d306e9676282e | 707cfe1d0bab3ef0 |
| 2026-11-27T19:36:39Z | c06-ex3-tl | duyu-1 | - | - | - | 2.72 | - | 707cfe1d0bab3ef0 |
| 2026-11-27T19:36:42Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 53 | 3.04 | cb1f50da81484bf294d8e01bf1f6c7ce | 55d5d17770af4190 |
| 2026-11-27T19:36:42Z | c07-q5-tl | duyu-1 | - | - | - | 3.04 | - | 55d5d17770af4190 |
