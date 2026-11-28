# G-C2-02-nominalisation PROMPTS

Ders: Adlaştırma (nominalisation): resmî ve akademik yazı · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:41:12Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 128 | 9.44 | 8a23d8a420ba4e399ae04b4befdb1101 | e4c7cf7a8f107b3f |
| 2026-10-14T14:41:14Z | c01-tr | duyu-1 | - | - | - | 9.44 | - | e4c7cf7a8f107b3f |
| 2026-10-14T14:41:17Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 14.43 | 5cf43ea569484d3dad9d5d79f5a860e5 | c155f798162060c5 |
| 2026-10-14T14:41:18Z | c02-tr | duyu-1 | - | - | - | 14.43 | - | c155f798162060c5 |
| 2026-10-14T14:41:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 205 | 14.41 | 6de415421c7c4865823a06909fa79a5e | 518385519d12d332 |
| 2026-10-14T14:41:22Z | c03-tr | duyu-1 | - | - | - | 14.41 | - | 518385519d12d332 |
| 2026-10-14T14:41:25Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 188 | 12.19 | 6b3ca71ca540498abbf00d6855265e0c | 7efc5d587bf89576 |
| 2026-10-14T14:41:27Z | c04-tr | duyu-1 | - | - | - | 12.19 | - | 7efc5d587bf89576 |
| 2026-10-14T14:41:30Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 237 | 15.4 | 253ea916859a457cac463718619e09be | a7c195c0f6691dab |
| 2026-10-14T14:41:32Z | c06-tr | duyu-1 | - | - | - | 15.4 | - | a7c195c0f6691dab |
| 2026-10-14T14:41:35Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 11.39 | aac11d582ffd44f3b737e64585696254 | d4adf0cd4e976b91 |
| 2026-10-14T14:41:37Z | c08-tr | duyu-1 | - | - | - | 11.39 | - | d4adf0cd4e976b91 |
| 2026-11-20T16:02:50Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 118 | 7.36 | af8e0eae3c9e4db795ddef657d823571 | 26bf14e702aff5b5 |
| 2026-11-20T16:02:52Z | c01-tr | duyu-1 | - | - | - | 7.36 | - | 26bf14e702aff5b5 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:10:42Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 47 | 263da988d28a99ac | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:10:44Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 27 | fc09d309848f2a27 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:10:45Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 47 | 19c10e0c64d56936 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:10:47Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 937d80e9f011fadc | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:10:49Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 53 | 5c670d7b5296fd56 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:10:51Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 44 | eaccbd1c04465da3 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:10:54Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 48 | 123410185ab8e128 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:10:56Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 54 | 75ffe08469bbe138 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:10:58Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 40 | b19f1b3a8386ec91 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:11:00Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 53 | 0ae3baa8bd10ef96 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:11:01Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | f11e13fe7b103fe0 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:11:03Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 48 | 302f3e0e4ac4f1e5 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:11:05Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 43 | b0eb7d8a56e8d2e5 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:11:07Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 40 | 25a00f301bf6d8ef | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:11:09Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 49 | 3d388bfb399e0b6e | audio/en/c07-q5.mp3 |
| 2026-11-27T18:32:21Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.04 | 8f70e126bc224bf683d6531fe8731c8e | cbf5d5c2b4519a30 |
| 2026-11-27T18:32:22Z | c07-q1-fb | duyu-1 | - | - | - | 3.04 | - | cbf5d5c2b4519a30 |
| 2026-11-27T18:32:24Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 3.36 | eb1337cb3cc74058a9f4bfd1a6563dbf | c61085506752307a |
| 2026-11-27T18:32:25Z | c07-q2-fb | duyu-1 | - | - | - | 3.36 | - | c61085506752307a |
| 2026-11-27T18:32:28Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 3.2 | 2c8f58b988ea405ab916aa3b4cd25c10 | f00ce952713ecde8 |
| 2026-11-27T18:32:29Z | c07-q3-fb | duyu-1 | - | - | - | 3.2 | - | f00ce952713ecde8 |
| 2026-11-27T18:32:31Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.36 | 5d85c7c997a64cc295f39fa4b463e008 | 94bf389b87657924 |
| 2026-11-27T18:32:32Z | c07-q4-fb | duyu-1 | - | - | - | 3.36 | - | 94bf389b87657924 |
| 2026-11-27T19:42:30Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 2.88 | aa345e328303480b9a9230f7c4b6d10f | 0c469c97ec1e1b44 |
| 2026-11-27T19:42:31Z | c01-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 0c469c97ec1e1b44 |
| 2026-11-27T19:42:33Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 4c90411314764ad3b2d31f6b71ce6e23 | 60912358e360bb54 |
| 2026-11-27T19:42:34Z | c02-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 60912358e360bb54 |
| 2026-11-27T19:42:36Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.56 | 963ed5c9c2994f68b07335a5c0c15f2c | 258cbbf5e07981b8 |
| 2026-11-27T19:42:38Z | c02-ex2-tl | duyu-1 | - | - | - | 2.56 | - | 258cbbf5e07981b8 |
| 2026-11-27T19:42:39Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.24 | 49be133b997f4667bfc67dca090ada6a | 0d731817bf526c27 |
| 2026-11-27T19:42:40Z | c03-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 0d731817bf526c27 |
| 2026-11-27T19:42:43Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.88 | c3810cb6f71d4f818e27bc13ce9853c7 | 4fcec42d1ed00b1e |
| 2026-11-27T19:42:44Z | c03-ex2-tl | duyu-1 | - | - | - | 2.88 | - | 4fcec42d1ed00b1e |
| 2026-11-27T19:42:46Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 2.88 | 685ee7e674ec4649a86da0a1d1ba5483 | 2493d1e94b93527e |
| 2026-11-27T19:42:47Z | c04-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 2493d1e94b93527e |
| 2026-11-27T19:42:49Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 4.8 | 8998ebd35d224be88d2d0cab41591fe9 | 1cf61f74959e98fb |
| 2026-11-27T19:42:50Z | c04-ex2-tl | duyu-1 | - | - | - | 4.8 | - | 1cf61f74959e98fb |
| 2026-11-27T19:42:53Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.56 | 9f89fb13768f4b42a5d7f219abfa3ad3 | 57b52534abeb1b84 |
| 2026-11-27T19:42:54Z | c05-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 57b52534abeb1b84 |
| 2026-11-27T19:42:56Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 2.88 | 26c6c536f0f645319a8c457bad8f842a | 2cff053372407f30 |
| 2026-11-27T19:42:57Z | c05-ex2-tl | duyu-1 | - | - | - | 2.88 | - | 2cff053372407f30 |
| 2026-11-27T19:43:00Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 57 | 3.52 | c4fe08118e12450da340e6793fa1bef7 | 55b404a496f34236 |
| 2026-11-27T19:43:01Z | c05-ex3-tl | duyu-1 | - | - | - | 3.52 | - | 55b404a496f34236 |
| 2026-11-27T19:43:03Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.4 | a588657936a14b9ea89faf535fc9fa9b | e8d0bf0a09c12396 |
| 2026-11-27T19:43:04Z | c05-ex4-tl | duyu-1 | - | - | - | 2.4 | - | e8d0bf0a09c12396 |
| 2026-11-27T19:43:07Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 3.52 | 13af049cf87c4d4e96b973681dd617e2 | c3009c740be82e35 |
| 2026-11-27T19:43:08Z | c05-ex5-tl | duyu-1 | - | - | - | 3.52 | - | c3009c740be82e35 |
| 2026-11-27T19:43:10Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.56 | ce9350b8b2e447a397cba6d6288fd44c | 44811d25fafcd861 |
| 2026-11-27T19:43:11Z | c06-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 44811d25fafcd861 |
| 2026-11-27T19:43:13Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 2.88 | a428ef489ebd47f4bf278ff9a41d11c9 | 852d19351aab0376 |
| 2026-11-27T19:43:14Z | c06-ex2-tl | duyu-1 | - | - | - | 2.88 | - | 852d19351aab0376 |
| 2026-11-27T19:43:17Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 3.52 | 0ff24f71e93a4d3f9efb3cd39d621907 | 3c0bc51c32979fdf |
| 2026-11-27T19:43:18Z | c07-q5-tl | duyu-1 | - | - | - | 3.52 | - | 3c0bc51c32979fdf |
