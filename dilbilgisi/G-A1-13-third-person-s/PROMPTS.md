# G-A1-13-third-person-s PROMPTS

Ders: He / she / it ile fiile -s · Pilot (H-079) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-s` → "se" (söyleniş sözlüğü denemesi; H-079'daki karşılaştırma için bu ders sözlük yolunu kullanır).

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). İngilizce örnekler (Sarah, ElevenLabs) sonradan üretildi. Yeni üretimler için çalışan ElevenLabs erişimi/ayrı onaylı plan gerekir; 2026-10-27'de 401 veren anahtar kullanılmaz.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T11:45:47Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 104 | 7.36 | 8d7d26f9077f4b1abe23eb9b938f15ae | aa16338c20e08c60 |
| 2026-10-14T11:45:48Z | c01-tr | duyu-1 | - | - | - | 7.36 | - | aa16338c20e08c60 |
| 2026-10-14T11:45:51Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 132 | 9.44 | 9888f663ce9344f5a6029510ea56dca4 | 16546e6701c720fc |
| 2026-10-14T11:45:52Z | c02-tr | duyu-1 | - | - | - | 9.44 | - | 16546e6701c720fc |
| 2026-10-14T11:45:55Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 128 | 8.64 | ff1916a8bb414e148252a29359845a3a | 0179f3742a425846 |
| 2026-10-14T11:45:56Z | c03-tr | duyu-1 | - | - | - | 8.64 | - | 0179f3742a425846 |
| 2026-10-14T11:45:58Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 178 | 12.83 | 335e2467003b4609b0072f3eb2f6eea6 | 35607c32db1a7498 |
| 2026-10-14T11:45:59Z | c05-tr | duyu-1 | - | - | - | 12.83 | - | 35607c32db1a7498 |
| 2026-10-14T11:46:02Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 68 | 4.8 | ab3f3af6e71f4fa2aee457df6cab5dd5 | 42f013720d013aea |
| 2026-10-14T11:46:03Z | c07-tr | duyu-1 | - | - | - | 4.8 | - | 42f013720d013aea |
| 2026-10-14T11:46:04Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 98 | 6.56 | bf41879b1b974a3abfc00d656ec51c3a | fcd019b770e29bc5 |
| 2026-10-14T11:46:05Z | c08-tr | duyu-1 | - | - | - | 6.56 | - | fcd019b770e29bc5 |
| 2026-10-14T11:49:43Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 137 | 7.68 | e0fe197cbf924690b3ca69de89b269cd | d4f1688c91478f67 |
| 2026-10-14T11:49:45Z | c02-tr | duyu-1 | - | - | - | 7.68 | - | d4f1688c91478f67 |
| 2026-10-14T11:49:47Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 103 | 8.16 | f4c21ba5ab044c239bca767a05c86334 | 2cead964060c6b37 |
| 2026-10-14T11:49:48Z | c08-tr | duyu-1 | - | - | - | 8.16 | - | 2cead964060c6b37 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T12:15:30Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 4d2f4d0dc86b0f4d | audio/en/c01-ex1.mp3 |
| 2026-10-14T12:15:31Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 14 | 0743ddf971aabd2a | audio/en/c03-ex1.mp3 |
| 2026-10-14T12:15:32Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | 8cee90d8dec00060 | audio/en/c03-ex2.mp3 |
| 2026-10-14T12:15:33Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | 63d9a29af03e2b4e | audio/en/c04-ex1.mp3 |
| 2026-10-14T12:15:34Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | 4af8977fb1b18e67 | audio/en/c04-ex2.mp3 |
| 2026-10-14T12:15:35Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | bf55b29a62e2438c | audio/en/c04-ex3.mp3 |
| 2026-10-14T12:15:37Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | 28e8659b6311023b | audio/en/c04-ex4.mp3 |
| 2026-10-14T12:15:38Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | d45d9d05be5e29f3 | audio/en/c04-ex5.mp3 |
| 2026-10-14T12:15:39Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | fd897b50dc1b721f | audio/en/c05-ex1.mp3 |
| 2026-10-14T12:15:40Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | 54c93338773343d8 | audio/en/c05-ex2.mp3 |
| 2026-10-21T12:31:45Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 198 | 16.37 | 8e1245fcf8434f94b012215a4f7db56b | c7304f6f7e274fa5 |
| 2026-10-21T12:31:47Z | c05-tr | duyu-1 | - | - | - | 16.37 | - | c7304f6f7e274fa5 |
| 2026-11-27T18:19:41Z | c06-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 4.16 | 4e526b492dd94a46a6fa7a6d1c4b44a9 | 5af478ffa088cd79 |
| 2026-11-27T18:19:42Z | c06-q1-fb | duyu-1 | - | - | - | 4.16 | - | 5af478ffa088cd79 |
| 2026-11-27T18:19:44Z | c06-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.08 | e9209a180d8c42f49b7ff1bc27b4670d | 5c4d73465592eff6 |
| 2026-11-27T18:19:45Z | c06-q2-fb | duyu-1 | - | - | - | 2.08 | - | 5c4d73465592eff6 |
| 2026-11-27T18:19:47Z | c06-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.24 | 5832d4a995cc4684976761c46fcfe21d | 76ec0f384d0e378e |
| 2026-11-27T18:19:48Z | c06-q3-fb | duyu-1 | - | - | - | 2.24 | - | 76ec0f384d0e378e |
| 2026-11-27T18:19:50Z | c06-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.24 | cd3ec193c1144c88a699fd393627f5a6 | a23ed225a2c7c2ef |
| 2026-11-27T18:19:51Z | c06-q4-fb | duyu-1 | - | - | - | 2.24 | - | a23ed225a2c7c2ef |
| 2026-11-27T19:04:24Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.76 | 8dfae6e949804909a4c01d077a67fb33 | dba937e5813ed15e |
| 2026-11-27T19:04:25Z | c01-ex1-tl | duyu-1 | - | - | - | 1.76 | - | dba937e5813ed15e |
| 2026-11-27T19:04:26Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | e95e00e8859e4e5791231105615f5c54 | 749fc11754c10e8e |
| 2026-11-27T19:04:28Z | c03-ex1-tl | duyu-1 | - | - | - | 1.28 | - | 749fc11754c10e8e |
| 2026-11-27T19:04:30Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.6 | b4f34a42c0fa44838bfca1dc630e4227 | a89602b455df4ea5 |
| 2026-11-27T19:04:31Z | c03-ex2-tl | duyu-1 | - | - | - | 1.6 | - | a89602b455df4ea5 |
| 2026-11-27T19:04:33Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 3.2 | 462f4cd5eea54d3d9f991deaee7f0bfa | e4f5c272ef6d1a77 |
| 2026-11-27T19:04:34Z | c04-ex1-tl | duyu-1 | - | - | - | 3.2 | - | e4f5c272ef6d1a77 |
| 2026-11-27T19:04:36Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | cefa9452b34e4b47a1d25e1e2bc8a7a0 | 93ad55c2c7a7ba92 |
| 2026-11-27T19:04:38Z | c04-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 93ad55c2c7a7ba92 |
| 2026-11-27T19:04:39Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.44 | 836ef82a4d5a4b7983a177b2b0401a65 | 69346948d7744a02 |
| 2026-11-27T19:04:40Z | c04-ex3-tl | duyu-1 | - | - | - | 1.44 | - | 69346948d7744a02 |
| 2026-11-27T19:04:44Z | c04-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.92 | 1a650921a4c5426ca1c02afd4f7a5088 | e5bad4bb9d2dc757 |
| 2026-11-27T19:04:45Z | c04-ex4-tl | duyu-1 | - | - | - | 1.92 | - | e5bad4bb9d2dc757 |
| 2026-11-27T19:04:47Z | c04-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | 7b49851edd474bac93d07d17a3d48075 | e6b8dac12a66530a |
| 2026-11-27T19:04:48Z | c04-ex5-tl | duyu-1 | - | - | - | 1.76 | - | e6b8dac12a66530a |
| 2026-11-27T19:04:50Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.6 | 40a64c1caa9743dfa2d5efd529970484 | 3b110317417eae54 |
| 2026-11-27T19:04:50Z | c05-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 3b110317417eae54 |
| 2026-11-27T19:04:53Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.72 | 4eacc586a9704454837f5374a17c6b03 | 255a5c1bf2cd7e04 |
| 2026-11-27T19:04:54Z | c05-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 255a5c1bf2cd7e04 |
