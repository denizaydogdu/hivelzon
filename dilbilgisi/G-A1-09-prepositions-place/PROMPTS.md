# G-A1-09-prepositions-place PROMPTS

Ders: Yer edatları: in / on / under / near / between / behind · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:07:04Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 119 | 7.36 | 67df2522238f4b80bc6fa43489eda00a | 1988e77a7014b1c3 |
| 2026-10-14T13:07:05Z | c01-tr | duyu-1 | - | - | - | 7.36 | - | 1988e77a7014b1c3 |
| 2026-10-14T13:07:08Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 10.75 | 0af0e41fbb8b48a1a63dc3a0342f3b76 | 744fa0abab8a68f5 |
| 2026-10-14T13:07:09Z | c02-tr | duyu-1 | - | - | - | 10.75 | - | 744fa0abab8a68f5 |
| 2026-10-14T13:07:12Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 12.73 | 8bdfb569642840e3bdcdc574e558d022 | 33d8ed09c3e419b5 |
| 2026-10-14T13:07:14Z | c03-tr | duyu-1 | - | - | - | 12.73 | - | 33d8ed09c3e419b5 |
| 2026-10-14T13:07:17Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 183 | 12.19 | 328c5c7c42a947d6bc298fa59f619bcc | a7ba327205f3394e |
| 2026-10-14T13:07:18Z | c04-tr | duyu-1 | - | - | - | 12.19 | - | a7ba327205f3394e |
| 2026-10-14T13:07:21Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 155 | 9.63 | 07b649c14ca3458d8d5baaa34f977923 | 8653c3a099d1e10f |
| 2026-10-14T13:07:22Z | c06-tr | duyu-1 | - | - | - | 9.63 | - | 8653c3a099d1e10f |
| 2026-10-14T13:07:24Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 77 | 4.96 | 6561974fbcfc422daf1ba9eb17542c98 | 8a23b0458a2fb518 |
| 2026-10-14T13:07:25Z | c08-tr | duyu-1 | - | - | - | 4.96 | - | 8a23b0458a2fb518 |
| 2026-10-14T13:07:27Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 103 | 7.84 | b5e9ff54c5d74e52a5ee2832b31e9837 | e62409ee41e8c60a |
| 2026-10-14T13:07:28Z | c09-tr | duyu-1 | - | - | - | 7.84 | - | e62409ee41e8c60a |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:55:08Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 31 | 72c105d51d933f1a | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:55:09Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | 8b6d6ef61a892426 | audio/en/c02-ex1.mp3 |
| 2026-10-14T14:55:10Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | 40fbeafa27adbdd4 | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:55:11Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 35 | a64a82ab58776654 | audio/en/c03-ex2.mp3 |
| 2026-10-14T14:55:12Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | 47dc5110b0b5c826 | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:55:14Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | 495156bf6ccd679d | audio/en/c04-ex2.mp3 |
| 2026-10-14T14:55:15Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | 76ce6f78a1f4b212 | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:55:16Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | f5bbe6b0bd61e926 | audio/en/c05-ex2.mp3 |
| 2026-10-14T14:55:17Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | c3ff8fb22166c1a7 | audio/en/c05-ex3.mp3 |
| 2026-10-14T14:55:18Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | f147fb04bee48eeb | audio/en/c05-ex4.mp3 |
| 2026-10-14T14:55:19Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | 2a7653a34b3c963d | audio/en/c05-ex5.mp3 |
| 2026-10-14T14:55:20Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | e857b90d36b6f0c9 | audio/en/c06-ex1.mp3 |
| 2026-10-14T14:55:21Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | 0a47440c4f6c9747 | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:18:49Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.92 | 36a5d08a7f7e456a97e3c35bcd5240e6 | a3ac505e43f78dd2 |
| 2026-11-27T18:18:50Z | c07-q1-fb | duyu-1 | - | - | - | 1.92 | - | a3ac505e43f78dd2 |
| 2026-11-27T18:18:53Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 1.92 | b51431bb14364ddda9a4946360cf79bf | 45bf2ad7f83f13a1 |
| 2026-11-27T18:18:54Z | c07-q2-fb | duyu-1 | - | - | - | 1.92 | - | 45bf2ad7f83f13a1 |
| 2026-11-27T18:18:57Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 57 | 4.32 | 4bfac86b7b9c420383666579cc884bd2 | 29f3d84e8558fd4a |
| 2026-11-27T18:18:58Z | c07-q3-fb | duyu-1 | - | - | - | 4.32 | - | 29f3d84e8558fd4a |
| 2026-11-27T18:19:00Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.08 | f4aa4e4e87e346c7a7297791ef4f43a8 | 675ff7acd55c05b6 |
| 2026-11-27T18:19:01Z | c07-q4-fb | duyu-1 | - | - | - | 2.08 | - | 675ff7acd55c05b6 |
| 2026-11-27T19:01:43Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.72 | 7b9bec3ce8fa42cb829b68458eb81702 | e7e17bcd1eb0f8d7 |
| 2026-11-27T19:01:44Z | c01-ex1-tl | duyu-1 | - | - | - | 2.72 | - | e7e17bcd1eb0f8d7 |
| 2026-11-27T19:01:46Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.6 | 6f9437dd6190491caf74b2ffd2e61a7d | 954ff26b33f83b58 |
| 2026-11-27T19:01:47Z | c02-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 954ff26b33f83b58 |
| 2026-11-27T19:01:49Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.92 | d7a2381620a647c383521d5a544c6a4f | b954bf685affafc5 |
| 2026-11-27T19:01:50Z | c03-ex1-tl | duyu-1 | - | - | - | 1.92 | - | b954bf685affafc5 |
| 2026-11-27T19:01:52Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | 6233162700c2421aaac88988f228f7a2 | 4857dbcc3cd07744 |
| 2026-11-27T19:01:53Z | c03-ex2-tl | duyu-1 | - | - | - | 1.92 | - | 4857dbcc3cd07744 |
| 2026-11-27T19:01:55Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | abdd9b2a731347769a1ef84a94c22ffe | 5eec74f152718052 |
| 2026-11-27T19:01:56Z | c04-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 5eec74f152718052 |
| 2026-11-27T19:01:58Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.44 | eb0e3ed94e8d400cbd64a86e75bdfec5 | c835f92779e6fa54 |
| 2026-11-27T19:01:58Z | c04-ex2-tl | duyu-1 | - | - | - | 1.44 | - | c835f92779e6fa54 |
| 2026-11-27T19:02:00Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 6b8136c7e86c467e914d0c64596cb1dd | 75aef97a3ea0e92a |
| 2026-11-27T19:02:01Z | c05-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 75aef97a3ea0e92a |
| 2026-11-27T19:02:03Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.4 | b632035bbf8d4f23880c4a45d1615585 | b237432ba130645a |
| 2026-11-27T19:02:05Z | c05-ex2-tl | duyu-1 | - | - | - | 2.4 | - | b237432ba130645a |
| 2026-11-27T19:02:07Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.76 | c536d276cef64bcc947192cc9843281c | 5191aed27487cd9c |
| 2026-11-27T19:02:08Z | c05-ex3-tl | duyu-1 | - | - | - | 1.76 | - | 5191aed27487cd9c |
| 2026-11-27T19:02:10Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | 2764ab26db1b4114b1bba15e6a76b78c | 8604c92ca2ec0def |
| 2026-11-27T19:02:11Z | c05-ex4-tl | duyu-1 | - | - | - | 1.76 | - | 8604c92ca2ec0def |
| 2026-11-27T19:02:13Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 3.04 | 3f41265e6d03419490ad15826439cccb | f0b267b83ffb3ee4 |
| 2026-11-27T19:02:14Z | c05-ex5-tl | duyu-1 | - | - | - | 3.04 | - | f0b267b83ffb3ee4 |
| 2026-11-27T19:02:16Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 2.88 | e95482456cd04754a84876aa826dd6a5 | 656c3231f9f19ef3 |
| 2026-11-27T19:02:17Z | c06-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 656c3231f9f19ef3 |
| 2026-11-27T19:02:19Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.6 | 847c2a3c3dbf4719b46e6b2e0658749a | 10ddc40168b35d2d |
| 2026-11-27T19:02:20Z | c06-ex2-tl | duyu-1 | - | - | - | 1.6 | - | 10ddc40168b35d2d |
