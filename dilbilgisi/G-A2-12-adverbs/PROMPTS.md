# G-A2-12-adverbs PROMPTS

Ders: Zarflar: always / usually / never ve -ly · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ly` → "li".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:11:21Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 130 | 8.32 | 65ce9cd2b1cf46dca098a9e534b44fff | 7bcd17e900ea3332 |
| 2026-10-14T13:11:22Z | c01-tr | duyu-1 | - | - | - | 8.32 | - | 7bcd17e900ea3332 |
| 2026-10-14T13:11:24Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 10.43 | ce81fb46c26a47e3a80912c56f8bae9d | f5c095b99d532ef7 |
| 2026-10-14T13:11:26Z | c02-tr | duyu-1 | - | - | - | 10.43 | - | f5c095b99d532ef7 |
| 2026-10-14T13:11:28Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 187 | 12.35 | a8bea785a8cb4cee9628b59615d9ba80 | a58891a2f3fff7ec |
| 2026-10-14T13:11:30Z | c03-tr | duyu-1 | - | - | - | 12.35 | - | a58891a2f3fff7ec |
| 2026-10-14T13:11:32Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 169 | 11.71 | 5e1c3cbd24ef4a11b8b29f1a913375d6 | c0cebce6e714738c |
| 2026-10-14T13:11:34Z | c04-tr | duyu-1 | - | - | - | 11.71 | - | c0cebce6e714738c |
| 2026-10-14T13:11:36Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 223 | 16.34 | 8f4274e2b5204270b813dc060831b1a9 | f24c0e935edb75a9 |
| 2026-10-14T13:11:38Z | c06-tr | duyu-1 | - | - | - | 16.34 | - | f24c0e935edb75a9 |
| 2026-10-14T13:11:40Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.16 | aa6705a5a4084f3aac9d99db9144f0b2 | ab65d6764c5129b3 |
| 2026-10-14T13:11:41Z | c08-tr | duyu-1 | - | - | - | 4.16 | - | ab65d6764c5129b3 |
| 2026-10-14T13:11:43Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 123 | 7.68 | 63af2ed12a8f43758f23e61555db2210 | 0931b2ffbb264e51 |
| 2026-10-14T13:11:44Z | c09-tr | duyu-1 | - | - | - | 7.68 | - | 0931b2ffbb264e51 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:29:08Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | 89c5141f1bcd8c41 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:29:09Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | 461c135203732a8b | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:29:11Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 19 | d3cf82f7611a96ac | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:29:12Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 26 | 6c54deb762e1bf82 | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:29:14Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 0c9b6b18c30d37fb | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:29:15Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | b64fca404003be7a | audio/en/c03-ex3.mp3 |
| 2026-10-30T13:29:16Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | 4cf75e1f8451b847 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:29:18Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | 6f385db08bb7bae6 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:29:19Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | fc81e8365ea4a8f9 | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:29:21Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | 0650dd0beddd348b | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:29:23Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 34 | c9907ccee0622c6c | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:29:24Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | ca992131988c2885 | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:29:25Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | 5d8e8b92da3084b5 | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:29:27Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | b279fbb5b7bfbdca | audio/en/c06-ex1.mp3 |
| 2026-10-30T13:29:28Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 17 | 1ebd95039bc09efc | audio/en/c06-ex2.mp3 |
| 2026-10-30T13:29:30Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 25 | 75815a164fc98547 | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:23:07Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 3.04 | 8a40d178f16c406a8073627a22ccd355 | 5b9406a277166c77 |
| 2026-11-27T18:23:08Z | c07-q1-fb | duyu-1 | - | - | - | 3.04 | - | 5b9406a277166c77 |
| 2026-11-27T18:23:11Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 4.64 | f26a9f2045114a83b15d0d6042ee6c8e | 8c60f0cbc8125d25 |
| 2026-11-27T18:23:12Z | c07-q2-fb | duyu-1 | - | - | - | 4.64 | - | 8c60f0cbc8125d25 |
| 2026-11-27T18:23:15Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 47 | 3.2 | 0b78f06a3d764c3bbed01ea3b8410454 | c2de8e016fa63e63 |
| 2026-11-27T18:23:16Z | c07-q3-fb | duyu-1 | - | - | - | 3.2 | - | c2de8e016fa63e63 |
| 2026-11-27T18:23:18Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 3.36 | 5c093f8333774eac80b5965b3b707d84 | 374641564adcc3cc |
| 2026-11-27T18:23:19Z | c07-q4-fb | duyu-1 | - | - | - | 3.36 | - | 374641564adcc3cc |
| 2026-11-27T18:23:21Z | c07-q5-fb | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.4 | fa3efe30ee8949648b4089e828513091 | a4bc6a315fc87b72 |
| 2026-11-27T18:23:22Z | c07-q5-fb | duyu-1 | - | - | - | 2.4 | - | a4bc6a315fc87b72 |
| 2026-11-27T19:14:31Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.24 | 94056e6ca5a3408a8d7efb3e2b0d1817 | 1405b148c621d3bd |
| 2026-11-27T19:14:32Z | c01-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 1405b148c621d3bd |
| 2026-11-27T19:14:34Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 3.2 | 69dcd207ca974add9ff37a0453c93642 | f5ec7a05fba2253a |
| 2026-11-27T19:14:35Z | c02-ex1-tl | duyu-1 | - | - | - | 3.2 | - | f5ec7a05fba2253a |
| 2026-11-27T19:14:37Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | a7b1e52b5b9d4cfcb70a38482fb7386a | 2bc66b14b2ce25eb |
| 2026-11-27T19:14:38Z | c02-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 2bc66b14b2ce25eb |
| 2026-11-27T19:14:40Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.56 | 84a572425da04d6ab6863106eeac8a89 | 40358b9a7fad8100 |
| 2026-11-27T19:14:41Z | c03-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 40358b9a7fad8100 |
| 2026-11-27T19:14:43Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.44 | 4ec9614ea6c14800b8d8fc71a8a56c8e | 669d2e49e61fac7e |
| 2026-11-27T19:14:44Z | c03-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 669d2e49e61fac7e |
| 2026-11-27T19:14:46Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.76 | 06dc07eb95ec447ca1fb05e21c6e209a | 57a0ce30ffd54ff6 |
| 2026-11-27T19:14:47Z | c03-ex3-tl | duyu-1 | - | - | - | 1.76 | - | 57a0ce30ffd54ff6 |
| 2026-11-27T19:14:49Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.76 | 0424fc22396f4efc8c5ddd382d484656 | 189ff4d05eee8404 |
| 2026-11-27T19:14:50Z | c04-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 189ff4d05eee8404 |
| 2026-11-27T19:14:53Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.08 | 4fb5a59b3aab484cbde1367626425064 | e8cea5683785c48f |
| 2026-11-27T19:14:54Z | c04-ex2-tl | duyu-1 | - | - | - | 2.08 | - | e8cea5683785c48f |
| 2026-11-27T19:14:56Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.24 | e7f9c3f2ce014068983980d4cf734724 | 6a50953149416c78 |
| 2026-11-27T19:14:57Z | c05-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 6a50953149416c78 |
| 2026-11-27T19:14:59Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.28 | 94c0b3e6a1f44cfea3e18b0c1f59613c | 6475a60df98002fb |
| 2026-11-27T19:15:00Z | c05-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 6475a60df98002fb |
| 2026-11-27T19:15:02Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.4 | f8f3bd29008a44eeb35486c11e5677af | 41fc630d8e447fc9 |
| 2026-11-27T19:15:03Z | c05-ex3-tl | duyu-1 | - | - | - | 2.4 | - | 41fc630d8e447fc9 |
| 2026-11-27T19:15:06Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | f07aac2140f5444fb11c16c531a745dc | b11e114618729932 |
| 2026-11-27T19:15:06Z | c05-ex4-tl | duyu-1 | - | - | - | 2.08 | - | b11e114618729932 |
| 2026-11-27T19:15:09Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 3.36 | b9fc563a573248c89774a5ee74819eca | 5c88c9089433745c |
| 2026-11-27T19:15:10Z | c05-ex5-tl | duyu-1 | - | - | - | 3.36 | - | 5c88c9089433745c |
| 2026-11-27T19:15:12Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.72 | 46d50af418ee41daa3da3212c7db5c03 | 4e695e6b496a3092 |
| 2026-11-27T19:15:13Z | c06-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 4e695e6b496a3092 |
| 2026-11-27T19:15:15Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.12 | 3cc542d82ee04201833c7c2360a68944 | c6c2fd2bc4dfd461 |
| 2026-11-27T19:15:16Z | c06-ex2-tl | duyu-1 | - | - | - | 1.12 | - | c6c2fd2bc4dfd461 |
| 2026-11-27T19:15:18Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.92 | ff22e0ed65774c5a9e66b23697f4d8e4 | 207b10cb4d2e5169 |
| 2026-11-27T19:15:19Z | c09-ex1-tl | duyu-1 | - | - | - | 1.92 | - | 207b10cb4d2e5169 |
