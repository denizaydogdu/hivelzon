# G-A1-14-do-does PROMPTS

Ders: do / does ile soru ve olumsuz · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Örnek alınan pilot dersler: G-A1-01-to-be, G-A1-03-a-an, G-A1-13-third-person-s (H-079, onaylı). Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş sözlüğü:** `Alex` → "Aleks".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın defteri ayrı tutuldu: `kitaplar/_maliyet/patientdesk-h080a.json` (birleştirme çakışmasını önlemek için; ana deftere ana oturum işler). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:08:47Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 161 | 10.59 | 5d0e301452234b9b8461b057242c62ef | 6bc7c968e351329e |
| 2026-10-14T13:08:48Z | c01-tr | duyu-1 | - | - | - | 10.59 | - | 6bc7c968e351329e |
| 2026-10-14T13:08:51Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 162 | 10.9 | 5081672fc60f4fc8ba2a681640d64da6 | eaf07a57e686325e |
| 2026-10-14T13:08:52Z | c02-tr | duyu-1 | - | - | - | 10.9 | - | eaf07a57e686325e |
| 2026-10-14T13:08:55Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 100 | 8.96 | f726fbe3f17747b0bd8631035784cfe4 | f662041c7f00fbc5 |
| 2026-10-14T13:08:56Z | c03-tr | duyu-1 | - | - | - | 8.96 | - | f662041c7f00fbc5 |
| 2026-10-14T13:08:59Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 10.41 | 26fe5dd628ce45b29d4b0545cff53246 | 78624ad84df85060 |
| 2026-10-14T13:09:00Z | c04-tr | duyu-1 | - | - | - | 10.41 | - | 78624ad84df85060 |
| 2026-10-14T13:09:02Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 187 | 12.19 | 26cb944c9e7a4b8dbbad96c34c2f4b12 | cd506dcabbe1a2a2 |
| 2026-10-14T13:09:04Z | c06-tr | duyu-1 | - | - | - | 12.19 | - | cd506dcabbe1a2a2 |
| 2026-10-14T13:09:06Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 82 | 5.28 | d94dc009e1f34183928b3242800eaf45 | a46a0d9fb09d4f8e |
| 2026-10-14T13:09:07Z | c08-tr | duyu-1 | - | - | - | 5.28 | - | a46a0d9fb09d4f8e |
| 2026-10-14T13:09:09Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 109 | 7.2 | 27b4631bbc95415197f06037014e575d | 21212b94295aa299 |
| 2026-10-14T13:09:10Z | c09-tr | duyu-1 | - | - | - | 7.2 | - | 21212b94295aa299 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T16:32:51Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | cf383d02068d0f79 | audio/en/c01-ex1.mp3 |
| 2026-10-14T16:32:52Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 14 | c5b9878178fc0b2d | audio/en/c02-ex1.mp3 |
| 2026-10-14T16:32:53Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | c0d37581035d5940 | audio/en/c02-ex2.mp3 |
| 2026-10-14T16:32:54Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | 0e07443ddc008faf | audio/en/c03-ex1.mp3 |
| 2026-10-14T16:32:55Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 472861eee9407b7b | audio/en/c03-ex2.mp3 |
| 2026-10-14T16:32:56Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | 810d7c3ca6aa6411 | audio/en/c04-ex1.mp3 |
| 2026-10-14T16:32:57Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | 17be8b5553d15076 | audio/en/c04-ex2.mp3 |
| 2026-10-14T16:32:58Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | 3efddb1aded372c9 | audio/en/c05-ex1.mp3 |
| 2026-10-14T16:33:00Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 28 | a6d69c463fb9b878 | audio/en/c05-ex2.mp3 |
| 2026-10-14T16:33:01Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 4348dbb46b8d3419 | audio/en/c05-ex3.mp3 |
| 2026-10-14T16:33:02Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 35 | c5f630df9637a1e2 | audio/en/c05-ex4.mp3 |
| 2026-10-14T16:33:04Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | d0bbbfc8e7bdb41b | audio/en/c05-ex5.mp3 |
| 2026-10-14T16:33:05Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | d28167116c987d45 | audio/en/c06-ex1.mp3 |
| 2026-10-14T16:33:07Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | bd3c8c9cf2b87fd7 | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:19:53Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 3.36 | 3db14be5aac74559a46c17bdbb595a20 | 43efd2120f70569a |
| 2026-11-27T18:19:55Z | c07-q1-fb | duyu-1 | - | - | - | 3.36 | - | 43efd2120f70569a |
| 2026-11-27T18:19:57Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 3.2 | 8c13d883cfff4a47953818252ae87454 | 371bcd7726faabbf |
| 2026-11-27T18:19:58Z | c07-q2-fb | duyu-1 | - | - | - | 3.2 | - | 371bcd7726faabbf |
| 2026-11-27T18:20:00Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 3.36 | 5f6c52bedba24329a17862494ad396ee | 137d392c995c4960 |
| 2026-11-27T18:20:01Z | c07-q3-fb | duyu-1 | - | - | - | 3.36 | - | 137d392c995c4960 |
| 2026-11-27T18:20:04Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 55 | 4.64 | 9610e255a4a54654ae8cc63f6876253e | bb866a60a93a4217 |
| 2026-11-27T18:20:05Z | c07-q4-fb | duyu-1 | - | - | - | 4.64 | - | bb866a60a93a4217 |
| 2026-11-27T19:04:57Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.24 | 341978e84e0c48efb58398cad405be20 | e554594c382a1ad6 |
| 2026-11-27T19:04:58Z | c01-ex1-tl | duyu-1 | - | - | - | 2.24 | - | e554594c382a1ad6 |
| 2026-11-27T19:05:00Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | 849f63addfd84ed787b89d7b250aaaf8 | 0b0ff1c09a492a30 |
| 2026-11-27T19:05:01Z | c02-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 0b0ff1c09a492a30 |
| 2026-11-27T19:05:03Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.44 | b60d2eb64c7945e3b3d2b6b9927fff93 | 4f017e29a859bdde |
| 2026-11-27T19:05:03Z | c02-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 4f017e29a859bdde |
| 2026-11-27T19:05:06Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 3.04 | bfe10bd292724a4f80d951e6dba81286 | 087c194eef140842 |
| 2026-11-27T19:05:07Z | c03-ex1-tl | duyu-1 | - | - | - | 3.04 | - | 087c194eef140842 |
| 2026-11-27T19:05:09Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | 5171686b8dc84678a00345f2e42d330f | 1ce743f34c4f1f2c |
| 2026-11-27T19:05:10Z | c03-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 1ce743f34c4f1f2c |
| 2026-11-27T19:05:12Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 0.96 | ee893807ad6f4c95a5b142ebd5df24c5 | ccf713d6a7979434 |
| 2026-11-27T19:05:13Z | c04-ex1-tl | duyu-1 | - | - | - | 0.96 | - | ccf713d6a7979434 |
| 2026-11-27T19:05:14Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.44 | d83b470c4e2443e1bc2b30fa702fcfe3 | af44aa58b231be65 |
| 2026-11-27T19:05:15Z | c04-ex2-tl | duyu-1 | - | - | - | 1.44 | - | af44aa58b231be65 |
| 2026-11-27T19:05:17Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.56 | 9fbd543c11844bd59448151b049ff942 | 963d4033d24f3760 |
| 2026-11-27T19:05:18Z | c05-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 963d4033d24f3760 |
| 2026-11-27T19:05:20Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.24 | 530d376eb0e143d6b53d5200a2f7e440 | c58239bfbee11952 |
| 2026-11-27T19:05:22Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | c58239bfbee11952 |
| 2026-11-27T19:05:24Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.28 | 16142b0bb07a4c2d813a4d4af65c2cc2 | 8e146dce1439191c |
| 2026-11-27T19:05:24Z | c05-ex3-tl | duyu-1 | - | - | - | 1.28 | - | 8e146dce1439191c |
| 2026-11-27T19:05:27Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.04 | 92c5332e6ea84822b5b58885ac4a5437 | 1471ccc424bb149a |
| 2026-11-27T19:05:28Z | c05-ex4-tl | duyu-1 | - | - | - | 3.04 | - | 1471ccc424bb149a |
| 2026-11-27T19:05:30Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 8810aad470e442a38a326a4802c58e16 | 605f9d7eb7b0e2b6 |
| 2026-11-27T19:05:31Z | c05-ex5-tl | duyu-1 | - | - | - | 1.28 | - | 605f9d7eb7b0e2b6 |
| 2026-11-27T19:05:33Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 2.72 | 90e409efc4414899ae4dece2c1ae9351 | 78e996ffe54c62c3 |
| 2026-11-27T19:05:34Z | c06-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 78e996ffe54c62c3 |
| 2026-11-27T19:05:36Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.28 | 52256f2fd7bd495aad0c75a351db6d4c | ff0fa7cdbad5a8cc |
| 2026-11-27T19:05:37Z | c06-ex2-tl | duyu-1 | - | - | - | 1.28 | - | ff0fa7cdbad5a8cc |
