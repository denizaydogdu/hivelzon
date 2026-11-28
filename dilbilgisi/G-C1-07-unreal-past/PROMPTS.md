# G-C1-07-unreal-past PROMPTS

Ders: Gerçek dışı geçmiş (unreal past): It's time…, would rather…, as if… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:39:54Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 109 | 8.48 | a1e8a01340ab46d790ac733e8bd68cfc | ef33ba32ac958674 |
| 2026-10-14T14:39:55Z | c01-tr | duyu-1 | - | - | - | 8.48 | - | ef33ba32ac958674 |
| 2026-10-14T14:39:58Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 190 | 12.83 | 7d24b63dd1634a4ab4d32b34c145f636 | 6823ecb5b4a8b62e |
| 2026-10-14T14:39:59Z | c02-tr | duyu-1 | - | - | - | 12.83 | - | 6823ecb5b4a8b62e |
| 2026-10-14T14:40:02Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 165 | 11.23 | 24ea7540b9184593bb7a602634c9a22b | 0c4e3cbe6cffdb3b |
| 2026-10-14T14:40:03Z | c03-tr | duyu-1 | - | - | - | 11.23 | - | 0c4e3cbe6cffdb3b |
| 2026-10-14T14:40:06Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 215 | 14.27 | b48dd356734c43ae944fce6a3c5f0f48 | 47c92c5ec73865da |
| 2026-10-14T14:40:07Z | c04-tr | duyu-1 | - | - | - | 14.27 | - | 47c92c5ec73865da |
| 2026-10-14T14:40:10Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 209 | 13.73 | 084453d9396647c89184f5ed26c6949b | 003df5d021fe8e8b |
| 2026-10-14T14:40:12Z | c06-tr | duyu-1 | - | - | - | 13.73 | - | 003df5d021fe8e8b |
| 2026-10-14T14:40:15Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 195 | 12.32 | 877babdc61b94172b9a826e89ceb88f5 | 0c59e8f867ace073 |
| 2026-10-14T14:40:17Z | c08-tr | duyu-1 | - | - | - | 12.32 | - | 0c59e8f867ace073 |
| 2026-11-20T16:02:22Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 11.2 | 123db561e1ff4e3ba0fea7548e59e7d7 | d930617c04c30271 |
| 2026-11-20T16:02:29Z | c01-tr | duyu-1 | - | - | - | 11.2 | - | d930617c04c30271 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:09:30Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 29 | d2c76c9d503ad41d | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:09:32Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 36 | 1833a43121b33633 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:09:33Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 24 | e887b4c9b782c0b7 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:09:36Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 29 | 4c2eed48385a8918 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:09:37Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | 682f9e17a0fd49d1 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:09:39Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | e7c8ad07dad8da01 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:09:41Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 35 | 94935a7b1a3d8c45 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:09:42Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | 79c87cd9b08fa84b | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:09:45Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 3d8977bb36fce552 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:09:46Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | 01a7a05dcc82c52f | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:09:48Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 38 | e9eb542030dafe39 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:09:50Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 23 | 3eb97721e4349b9b | audio/en/c06-ex1.mp3 |
| 2026-11-27T18:31:40Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 57 | 3.36 | 50ade988a05f4b7fb18f0689251f743e | b6e8a3d08e3a3877 |
| 2026-11-27T18:31:41Z | c07-q1-fb | duyu-1 | - | - | - | 3.36 | - | b6e8a3d08e3a3877 |
| 2026-11-27T18:31:44Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 3.68 | 71348fc355e6417796208f041d6f844f | f124ef38b11ff34f |
| 2026-11-27T18:31:45Z | c07-q2-fb | duyu-1 | - | - | - | 3.68 | - | f124ef38b11ff34f |
| 2026-11-27T18:31:47Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.88 | a5654bf2ba4c4c54b31d0a317d5ba2fb | d2e92fcdacc28d7c |
| 2026-11-27T18:31:48Z | c07-q3-fb | duyu-1 | - | - | - | 2.88 | - | d2e92fcdacc28d7c |
| 2026-11-27T18:31:50Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 3.52 | f3a6656904254a5d8c2d704c01b80957 | 89ecb75883d2c3ad |
| 2026-11-27T18:31:51Z | c07-q4-fb | duyu-1 | - | - | - | 3.52 | - | 89ecb75883d2c3ad |
| 2026-11-27T19:40:15Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.4 | 309d870cb1b248ef999103718c57ef90 | 3e25271474086473 |
| 2026-11-27T19:40:16Z | c01-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 3e25271474086473 |
| 2026-11-27T19:40:18Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.4 | bd64979971d8417c90b5ed9447449935 | 17f7884ffec54412 |
| 2026-11-27T19:40:19Z | c02-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 17f7884ffec54412 |
| 2026-11-27T19:40:21Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.08 | 932d17071eac4060bfcda3baa44693f5 | fd942e1f767beeca |
| 2026-11-27T19:40:22Z | c03-ex1-tl | duyu-1 | - | - | - | 2.08 | - | fd942e1f767beeca |
| 2026-11-27T19:40:24Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.08 | 04dbcb99427547c9b5d8603af1fb5287 | c3fca594ab435dc5 |
| 2026-11-27T19:40:25Z | c03-ex2-tl | duyu-1 | - | - | - | 2.08 | - | c3fca594ab435dc5 |
| 2026-11-27T19:40:27Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.24 | a00d4f21fc5844838e25dd9c35071e07 | 1bebcc25eb38992f |
| 2026-11-27T19:40:28Z | c04-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 1bebcc25eb38992f |
| 2026-11-27T19:40:30Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 3.52 | 9b337c121ec8401380ea30a57fc5e3b1 | 9e45206980d4e07c |
| 2026-11-27T19:40:31Z | c04-ex2-tl | duyu-1 | - | - | - | 3.52 | - | 9e45206980d4e07c |
| 2026-11-27T19:40:33Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | c382f5d364004450afa6e5155f8695f6 | bbf6358beb1680bb |
| 2026-11-27T19:40:34Z | c05-ex1-tl | duyu-1 | - | - | - | 2.24 | - | bbf6358beb1680bb |
| 2026-11-27T19:40:37Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 4.0 | 29bea1f1a210484e9b24a0f754ba266f | c21f7ff2d31c0c4c |
| 2026-11-27T19:40:38Z | c05-ex2-tl | duyu-1 | - | - | - | 4.0 | - | c21f7ff2d31c0c4c |
| 2026-11-27T19:40:40Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.76 | 904643e1e7fc4fd99f6020b3a870f2b8 | 89f4b559d6ead6a1 |
| 2026-11-27T19:40:41Z | c05-ex3-tl | duyu-1 | - | - | - | 1.76 | - | 89f4b559d6ead6a1 |
| 2026-11-27T19:40:43Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 2.56 | 2b9120dfc1214c5b81b1cca004ae65d9 | f3042d95a3370c35 |
| 2026-11-27T19:40:44Z | c05-ex4-tl | duyu-1 | - | - | - | 2.56 | - | f3042d95a3370c35 |
| 2026-11-27T19:40:46Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.6 | e521338e06954959bd31d5f23676e50e | 6695c345ef140026 |
| 2026-11-27T19:40:47Z | c05-ex5-tl | duyu-1 | - | - | - | 1.6 | - | 6695c345ef140026 |
| 2026-11-27T19:40:49Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | ab230878d25b4eb398ff58b51fab55a3 | 33d23af9633f0fb1 |
| 2026-11-27T19:40:49Z | c06-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 33d23af9633f0fb1 |
| 2026-11-27T19:40:51Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.56 | 0928c75d7d8945f5ab511c7c87704d2c | a9ffcc890cfa30c9 |
| 2026-11-27T19:40:53Z | c07-q5-tl | duyu-1 | - | - | - | 2.56 | - | a9ffcc890cfa30c9 |
