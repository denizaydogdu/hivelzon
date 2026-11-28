# G-B1-08-defining-relative-clauses PROMPTS

Ders: Tanımlayan sıfat cümlecikleri: who / which / that · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:08:20Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 9.76 | a7ee85d61c50478eb43c1b3c9abd4aff | 910766fff1f6e9cf |
| 2026-10-14T14:08:21Z | c01-tr | duyu-1 | - | - | - | 9.76 | - | 910766fff1f6e9cf |
| 2026-10-14T14:08:23Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 9.79 | 73a7d8089b1444abafd94eebb8ae28fb | 61c2c7ad5a30de20 |
| 2026-10-14T14:08:24Z | c02-tr | duyu-1 | - | - | - | 9.79 | - | 61c2c7ad5a30de20 |
| 2026-10-14T14:08:26Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 144 | 8.64 | 832e0d4d61d447eebe41e7be2a349ec4 | 9a39fc5458c30d77 |
| 2026-10-14T14:08:28Z | c03-tr | duyu-1 | - | - | - | 8.64 | - | 9a39fc5458c30d77 |
| 2026-10-14T14:08:30Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 128 | 8.48 | df5ef6b85be44302a2d5a363e44dc3d2 | a14ca8293135b691 |
| 2026-10-14T14:08:31Z | c04-tr | duyu-1 | - | - | - | 8.48 | - | a14ca8293135b691 |
| 2026-10-14T14:08:34Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 221 | 15.09 | 833764b04a7d42b0ad3f2a749eac67be | 99f17af2b38ee7eb |
| 2026-10-14T14:08:36Z | c06-tr | duyu-1 | - | - | - | 15.09 | - | 99f17af2b38ee7eb |
| 2026-10-14T14:08:39Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 122 | 8.16 | 75299ca97ae140709fa28a61cfc14992 | f206bb3156907352 |
| 2026-10-14T14:08:40Z | c08-tr | duyu-1 | - | - | - | 8.16 | - | f206bb3156907352 |
| 2026-10-14T14:08:42Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 140 | 9.12 | 8ada35dfae7644b8b32d7ceefa5f711c | a46f94b3ac46342b |
| 2026-10-14T14:08:43Z | c09-tr | duyu-1 | - | - | - | 9.12 | - | a46f94b3ac46342b |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:00:14Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 48 | c8043fc70854d11d | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:00:16Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 6f75e06bfe59ed98 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:00:18Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | fb0299ed6474d129 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:00:19Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 3ca42f5b96319065 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:00:21Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | d44e726e87a0cf51 | audio/en/c03-ex3.mp3 |
| 2026-11-26T14:00:23Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 1ccf35bfa51a571d | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:00:24Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 42 | fdd468d73578831f | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:00:26Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 5b0cbd30a1e24da8 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:00:28Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | 6578c4360cf9d7a5 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:00:30Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 443ced44f0d67f8b | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:00:31Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 5afc1213deeb0eec | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:00:33Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | c17d01838f6aea9a | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:00:34Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | b27b543038ba1a1a | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:25:43Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.24 | 9a2f583cce88414a9349e1e484d8dac9 | bb9ad88f635132b3 |
| 2026-11-27T18:25:44Z | c07-q1-fb | duyu-1 | - | - | - | 2.24 | - | bb9ad88f635132b3 |
| 2026-11-27T18:25:46Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 3.52 | 84a06a32d59f4d5c80dbf7d453b4d520 | bd107fef1b511e40 |
| 2026-11-27T18:25:47Z | c07-q2-fb | duyu-1 | - | - | - | 3.52 | - | bd107fef1b511e40 |
| 2026-11-27T18:25:50Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.08 | ab435f4510fd491691e83e981e66bc84 | f7b7147ef1b6e331 |
| 2026-11-27T18:25:51Z | c07-q3-fb | duyu-1 | - | - | - | 2.08 | - | f7b7147ef1b6e331 |
| 2026-11-27T18:25:53Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.88 | fc0a3073203f4cd5b9c5a2acb1b4d9f1 | 7c7050dcde621438 |
| 2026-11-27T18:25:53Z | c07-q4-fb | duyu-1 | - | - | - | 2.88 | - | 7c7050dcde621438 |
| 2026-11-27T19:22:36Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.72 | bddd55e8bd104571bdb725cb0e279bb7 | 76b23b5f66e735ab |
| 2026-11-27T19:22:37Z | c01-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 76b23b5f66e735ab |
| 2026-11-27T19:22:39Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.76 | 202b515105eb44ce85beb9dbb7f3b70e | 966ff02637b03b1d |
| 2026-11-27T19:22:40Z | c02-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 966ff02637b03b1d |
| 2026-11-27T19:22:42Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 848e2123298d44f784a8c85fb204f8b7 | 57ec661d95580efe |
| 2026-11-27T19:22:43Z | c03-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 57ec661d95580efe |
| 2026-11-27T19:22:45Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.72 | 4ad1c6c5928f429094a9fad87caaa8db | 1145d323f3d3db36 |
| 2026-11-27T19:22:46Z | c03-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 1145d323f3d3db36 |
| 2026-11-27T19:22:48Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.08 | 3a59fd9f4d0c43b7bf456ebe6f362409 | 3072c460a014fb94 |
| 2026-11-27T19:22:49Z | c03-ex3-tl | duyu-1 | - | - | - | 2.08 | - | 3072c460a014fb94 |
| 2026-11-27T19:22:51Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.4 | 3c97bbc716bb4a97a497091dc1e254e1 | 9695197cdd3f8dfe |
| 2026-11-27T19:22:52Z | c04-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 9695197cdd3f8dfe |
| 2026-11-27T19:22:54Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 3.04 | 6e787ea625b345469cca20f3a504b820 | b6c6ee69e6399f37 |
| 2026-11-27T19:22:55Z | c05-ex1-tl | duyu-1 | - | - | - | 3.04 | - | b6c6ee69e6399f37 |
| 2026-11-27T19:22:58Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 1.92 | 9cd4ba0922cd43f0b6b2b363ea6df9b9 | 147ca2e1666bc34c |
| 2026-11-27T19:22:59Z | c05-ex2-tl | duyu-1 | - | - | - | 1.92 | - | 147ca2e1666bc34c |
| 2026-11-27T19:23:01Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 4.16 | 1dfda6277a1e42a8b2d2393c5635bbcc | 5b0ffd7ebfb280c8 |
| 2026-11-27T19:23:03Z | c05-ex3-tl | duyu-1 | - | - | - | 4.16 | - | 5b0ffd7ebfb280c8 |
| 2026-11-27T19:23:05Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 3.2 | 687a6b1cfbab4823923504e130b3528d | e9faa2f18c9b047a |
| 2026-11-27T19:23:06Z | c05-ex4-tl | duyu-1 | - | - | - | 3.2 | - | e9faa2f18c9b047a |
| 2026-11-27T19:23:08Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.56 | 9cd110e18c114844b14096978d6f54b1 | 851ea7529bb07572 |
| 2026-11-27T19:23:09Z | c05-ex5-tl | duyu-1 | - | - | - | 2.56 | - | 851ea7529bb07572 |
| 2026-11-27T19:23:12Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | f37c2643d46c4fd5a75bff5e6ba98fd2 | 5733faf9e50346d1 |
| 2026-11-27T19:23:13Z | c06-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 5733faf9e50346d1 |
| 2026-11-27T19:23:15Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 3.2 | 98dc5f830f97478e93ab9f5d81c96982 | 19108b957b0ff0ff |
| 2026-11-27T19:23:17Z | c06-ex2-tl | duyu-1 | - | - | - | 3.2 | - | 19108b957b0ff0ff |
