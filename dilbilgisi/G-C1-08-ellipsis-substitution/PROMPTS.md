# G-C1-08-ellipsis-substitution PROMPTS

Ders: Eksiltme ve yerine koyma (ellipsis and substitution): So do I, I hope not · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:40:19Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 202 | 13.78 | 232f395e2914473c9faeecf835d5e6b1 | 8001c9d66594637e |
| 2026-10-14T14:40:21Z | c01-tr | duyu-1 | - | - | - | 13.78 | - | 8001c9d66594637e |
| 2026-10-14T14:40:24Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 217 | 14.75 | 91d4ec77ca9c4e4b9e04cb40a626dd58 | 89dca818eb43487b |
| 2026-10-14T14:40:25Z | c02-tr | duyu-1 | - | - | - | 14.75 | - | 89dca818eb43487b |
| 2026-10-14T14:40:29Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 170 | 11.55 | 82808cb44dca42aebc0716798c72c1e5 | 2ab53b1680bd80d6 |
| 2026-10-14T14:40:30Z | c03-tr | duyu-1 | - | - | - | 11.55 | - | 2ab53b1680bd80d6 |
| 2026-10-14T14:40:33Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 240 | 15.39 | 97109b911a2c42c1a9d73a667cf07a82 | 5c589557c37bb5ca |
| 2026-10-14T14:40:34Z | c04-tr | duyu-1 | - | - | - | 15.39 | - | 5c589557c37bb5ca |
| 2026-10-14T14:40:38Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 200 | 14.43 | 3042fd52b5c6415b87e7d5b5a9fcd842 | 4115961c88a64f25 |
| 2026-10-14T14:40:39Z | c06-tr | duyu-1 | - | - | - | 14.43 | - | 4115961c88a64f25 |
| 2026-10-14T14:40:42Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 12.35 | e1008cf9d049434383bb4fdc04173a99 | 4ebc4d5b841b8b3a |
| 2026-10-14T14:40:43Z | c08-tr | duyu-1 | - | - | - | 12.35 | - | 4ebc4d5b841b8b3a |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:09:51Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 29 | 40fa15e92f03ef9f | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:09:53Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 26 | eec706c0c881e2a8 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:09:55Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 30 | f61af145ccad480a | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:09:56Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 19 | e155a9cd1df98177 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:09:58Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 36 | a10c054ce0116cfc | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:09:59Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | c44e142d54adb3d1 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:10:01Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 26 | f27c30734cdaa366 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:10:03Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 47 | 500e757705636ccc | audio/en/c04-ex3.mp3 |
| 2026-11-26T14:10:05Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 41 | 0fea748574640f05 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:10:06Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 40 | d5434ddac6a5b033 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:10:08Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 33 | 1ad25f99007df0f5 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:10:10Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | f569efc55bc4e8cf | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:10:11Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 83bfd00bb801dc38 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:10:13Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | 624dd30253f8b2fe | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:10:14Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 11 | 69c0bd5adac736f3 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:10:16Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 10 | 5bc10e8175dc9422 | audio/en/c06-ex3.mp3 |
| 2026-11-27T18:31:53Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.72 | 3ac96f9c2cae44fc9dec53bbafb0143e | f9272993fd9fa22a |
| 2026-11-27T18:31:54Z | c07-q1-fb | duyu-1 | - | - | - | 2.72 | - | f9272993fd9fa22a |
| 2026-11-27T18:31:57Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 2.88 | f3777391d8224c6dae1aa91f33283716 | 8b8e3f39cd09ab32 |
| 2026-11-27T18:31:58Z | c07-q2-fb | duyu-1 | - | - | - | 2.88 | - | 8b8e3f39cd09ab32 |
| 2026-11-27T18:32:00Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 2.56 | 836d747723e2456086dc74dea015e2c3 | 390f51bec6ee0fa6 |
| 2026-11-27T18:32:02Z | c07-q3-fb | duyu-1 | - | - | - | 2.56 | - | 390f51bec6ee0fa6 |
| 2026-11-27T18:32:04Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | d7ba8b2cc874444f9d63574d44c9d6ee | 9c94abb5c4606930 |
| 2026-11-27T18:32:05Z | c07-q4-fb | duyu-1 | - | - | - | 2.24 | - | 9c94abb5c4606930 |
| 2026-11-27T19:40:55Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | 4199f72eb43e427389db716387ef9b39 | 7dc3ffd8eaa4bb7f |
| 2026-11-27T19:40:56Z | c01-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 7dc3ffd8eaa4bb7f |
| 2026-11-27T19:40:58Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.24 | 2050f601309f478693c77bd5c8271f88 | 5739a5bcf6d2e566 |
| 2026-11-27T19:40:59Z | c02-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 5739a5bcf6d2e566 |
| 2026-11-27T19:41:01Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.92 | d82ab1468cef4210af51a9396a06d9f6 | 91c71aaa5410b62a |
| 2026-11-27T19:41:02Z | c02-ex2-tl | duyu-1 | - | - | - | 1.92 | - | 91c71aaa5410b62a |
| 2026-11-27T19:41:04Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.76 | 985f5ae03a6e43c68ddd9aa485a6689d | 975732af11c5e412 |
| 2026-11-27T19:41:05Z | c03-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 975732af11c5e412 |
| 2026-11-27T19:41:07Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.56 | 74bed61f18084d65b80ba280f9d87e48 | 26c4a48558e21c40 |
| 2026-11-27T19:41:08Z | c03-ex2-tl | duyu-1 | - | - | - | 2.56 | - | 26c4a48558e21c40 |
| 2026-11-27T19:41:10Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 3.52 | 8c62a7362db84e9e82bbe734554e4f3c | 5330ab9d2dccb22a |
| 2026-11-27T19:41:11Z | c04-ex1-tl | duyu-1 | - | - | - | 3.52 | - | 5330ab9d2dccb22a |
| 2026-11-27T19:41:13Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.72 | 3d6a2a74a36f4e828a241da242cb3366 | 764a5b3e60af210e |
| 2026-11-27T19:41:15Z | c04-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 764a5b3e60af210e |
| 2026-11-27T19:41:17Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 3.68 | a0b891f3c6e346b4a5ad43c8150f6af0 | d88e6ee5220acdc9 |
| 2026-11-27T19:41:18Z | c04-ex3-tl | duyu-1 | - | - | - | 3.68 | - | d88e6ee5220acdc9 |
| 2026-11-27T19:41:20Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | c61f1cb539ad478aae223781446dd168 | 916f8a9716066a97 |
| 2026-11-27T19:41:21Z | c05-ex1-tl | duyu-1 | - | - | - | 2.08 | - | 916f8a9716066a97 |
| 2026-11-27T19:41:23Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.56 | 2a624dd1e9854f4999524592bc6d0b33 | a9d764fe646236d7 |
| 2026-11-27T19:41:24Z | c05-ex2-tl | duyu-1 | - | - | - | 2.56 | - | a9d764fe646236d7 |
| 2026-11-27T19:41:26Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.4 | 2ce4ed5cf5364cb9b8ff1ad92b53600c | f580fba43342078e |
| 2026-11-27T19:41:27Z | c05-ex3-tl | duyu-1 | - | - | - | 2.4 | - | f580fba43342078e |
| 2026-11-27T19:41:29Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 3.2 | 703b6ecf31f24992bf46a505e37527cc | 23907d46b2a5bb76 |
| 2026-11-27T19:41:31Z | c05-ex4-tl | duyu-1 | - | - | - | 3.2 | - | 23907d46b2a5bb76 |
| 2026-11-27T19:41:33Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.56 | 4c348416be5047efaabb82ad17f3d138 | 1d7b2bc42512fbe9 |
| 2026-11-27T19:41:34Z | c05-ex5-tl | duyu-1 | - | - | - | 2.56 | - | 1d7b2bc42512fbe9 |
| 2026-11-27T19:41:36Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | 090163b5537d4b239eb6a34332a753dc | 4d242d9345dc0eac |
| 2026-11-27T19:41:37Z | c06-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 4d242d9345dc0eac |
| 2026-11-27T19:41:39Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.28 | 7f31ee4183694e5f895fc5ea41504dc5 | 9166f990c9637af1 |
| 2026-11-27T19:41:40Z | c06-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 9166f990c9637af1 |
| 2026-11-27T19:41:42Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 7 | 0.8 | a6c947822704443799bd9a038469adf9 | 748eb88190019380 |
| 2026-11-27T19:41:43Z | c06-ex3-tl | duyu-1 | - | - | - | 0.8 | - | 748eb88190019380 |
