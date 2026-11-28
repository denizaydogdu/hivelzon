# G-A2-04-past-simple-regular PROMPTS

Ders: Geçmiş zaman: düzenli fiiller (-ed) · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ed` → "ed".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:08:14Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 110 | 8.0 | c6b84150fabb4568b6fd0e798faf8595 | e2ba6e76263d8d3d |
| 2026-10-14T13:08:15Z | c01-tr | duyu-1 | - | - | - | 8.0 | - | e2ba6e76263d8d3d |
| 2026-10-14T13:08:18Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 9.95 | 2cedef98646647efae78cf68de1a3333 | caa91ec6a241770e |
| 2026-10-14T13:08:19Z | c02-tr | duyu-1 | - | - | - | 9.95 | - | caa91ec6a241770e |
| 2026-10-14T13:08:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 13.95 | 32894bc6a5154990a5773dd91422c894 | 5968a8e8053b7149 |
| 2026-10-14T13:08:22Z | c03-tr | duyu-1 | - | - | - | 13.95 | - | 5968a8e8053b7149 |
| 2026-10-14T13:08:25Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 10.43 | 62f51a7c45eb4f36a4de514b89629672 | f62f4d4e1fd22353 |
| 2026-10-14T13:08:26Z | c04-tr | duyu-1 | - | - | - | 10.43 | - | f62f4d4e1fd22353 |
| 2026-10-14T13:08:29Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 13.31 | da09434a8dbb45ad83c26d45007ce312 | 53514539b9f768e3 |
| 2026-10-14T13:08:30Z | c06-tr | duyu-1 | - | - | - | 13.31 | - | 53514539b9f768e3 |
| 2026-10-14T13:08:33Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 63 | 4.0 | 5b900bcfd31b4afdbf42f41004f5173c | d58758c9cd52c276 |
| 2026-10-14T13:08:33Z | c08-tr | duyu-1 | - | - | - | 4.0 | - | d58758c9cd52c276 |
| 2026-10-14T13:08:35Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 80 | 5.92 | 359a866974b74ae3a437f653017b995b | 353af048ad4d20f3 |
| 2026-10-14T13:08:37Z | c09-tr | duyu-1 | - | - | - | 5.92 | - | 353af048ad4d20f3 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T18:26:29Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 21 | a9d11973b2e06d81 | audio/en/c01-ex1.mp3 |
| 2026-10-14T18:26:31Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 18 | 582295d46de5a4c3 | audio/en/c03-ex1.mp3 |
| 2026-10-14T18:26:32Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 16 | 1e58c40ec2585aaf | audio/en/c03-ex2.mp3 |
| 2026-10-14T18:26:33Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 15 | aeb833e0b2a9622d | audio/en/c04-ex1.mp3 |
| 2026-10-14T18:26:34Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 21 | b2cffc0b613cd31c | audio/en/c04-ex2.mp3 |
| 2026-10-14T18:26:35Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | f8a303f8622f88f1 | audio/en/c04-ex3.mp3 |
| 2026-10-14T18:26:36Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | 633479460f937431 | audio/en/c05-ex1.mp3 |
| 2026-10-14T18:26:37Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 33 | fb62824e734bed57 | audio/en/c05-ex2.mp3 |
| 2026-10-14T18:26:39Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | 7ddc24a54f9c9f66 | audio/en/c05-ex3.mp3 |
| 2026-10-14T18:26:40Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 73c2babf86774943 | audio/en/c05-ex4.mp3 |
| 2026-10-14T18:26:41Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 36 | 1e50e723470b7b16 | audio/en/c05-ex5.mp3 |
| 2026-10-14T18:26:43Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | c9bfd3b5cc254929 | audio/en/c06-ex1.mp3 |
| 2026-10-14T18:26:44Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | 6044cdd9d65ea7ac | audio/en/c06-ex2.mp3 |
| 2026-10-14T18:26:45Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | 6f4a63f9ace5e7df | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:21:15Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.4 | 3e02a008c50b4462b65b2c1565cf4cf8 | bdfb3cf712b6ca5e |
| 2026-11-27T18:21:16Z | c07-q1-fb | duyu-1 | - | - | - | 2.4 | - | bdfb3cf712b6ca5e |
| 2026-11-27T18:21:18Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 3.52 | 60e2e92ded5a468ca45e67b160e1a04c | 35c21574a3830118 |
| 2026-11-27T18:21:19Z | c07-q2-fb | duyu-1 | - | - | - | 3.52 | - | 35c21574a3830118 |
| 2026-11-27T18:21:22Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 3.52 | c4076ea875ad41e2b36b02fc3336a4b4 | 9f12f0f756f3ef59 |
| 2026-11-27T18:21:23Z | c07-q3-fb | duyu-1 | - | - | - | 3.52 | - | 9f12f0f756f3ef59 |
| 2026-11-27T18:21:25Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 3.2 | 329904d65c5e4b60b00144eecef18599 | ac3fef12a9bf1b47 |
| 2026-11-27T18:21:26Z | c07-q4-fb | duyu-1 | - | - | - | 3.2 | - | ac3fef12a9bf1b47 |
| 2026-11-27T19:09:16Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.44 | 84c19321a7d54d0c911a58bcf02d4c8d | dc9b7e031ab3cdd4 |
| 2026-11-27T19:09:17Z | c01-ex1-tl | duyu-1 | - | - | - | 1.44 | - | dc9b7e031ab3cdd4 |
| 2026-11-27T19:09:19Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | b4254640e134427784e4761bcab517b7 | c3c838b091665cfb |
| 2026-11-27T19:09:20Z | c03-ex1-tl | duyu-1 | - | - | - | 1.44 | - | c3c838b091665cfb |
| 2026-11-27T19:09:21Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.28 | 4fc74cb6e3e04fe6b13ad34bbd983a8d | e4ec03efee8e2e62 |
| 2026-11-27T19:09:22Z | c03-ex2-tl | duyu-1 | - | - | - | 1.28 | - | e4ec03efee8e2e62 |
| 2026-11-27T19:09:25Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 3.36 | dcd9c9455069407ba1c01b54950590b1 | 656a80c7d92b9509 |
| 2026-11-27T19:09:26Z | c04-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 656a80c7d92b9509 |
| 2026-11-27T19:09:28Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.44 | a293d7baca1f4ddbab5762e69eedc1a5 | cdaf968f00d12bb5 |
| 2026-11-27T19:09:29Z | c04-ex2-tl | duyu-1 | - | - | - | 1.44 | - | cdaf968f00d12bb5 |
| 2026-11-27T19:09:31Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | c074496528fa481db9f81c60f225eccb | 046c973a601bf9eb |
| 2026-11-27T19:09:32Z | c04-ex3-tl | duyu-1 | - | - | - | 1.28 | - | 046c973a601bf9eb |
| 2026-11-27T19:09:34Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 47e1a9a7538c45399b4e67f75681ffa4 | 9cf2c60517947d25 |
| 2026-11-27T19:09:35Z | c05-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 9cf2c60517947d25 |
| 2026-11-27T19:09:37Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.24 | bec26fa4e48746bcbb8452fec8514c26 | b6fb185e2df5e4cd |
| 2026-11-27T19:09:38Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | b6fb185e2df5e4cd |
| 2026-11-27T19:09:40Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | b0ecdd60a8224ab7a71941fb00f46e6d | 056de625940913c0 |
| 2026-11-27T19:09:41Z | c05-ex3-tl | duyu-1 | - | - | - | 1.92 | - | 056de625940913c0 |
| 2026-11-27T19:09:43Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.08 | f8ce257db20943aeb5a7a6e276bcdf94 | c7a3091bb4be26b0 |
| 2026-11-27T19:09:44Z | c05-ex4-tl | duyu-1 | - | - | - | 2.08 | - | c7a3091bb4be26b0 |
| 2026-11-27T19:09:47Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 3.84 | 113fc7c63b4b4fd8a79d436e33e7b66d | d062cde844cbce6d |
| 2026-11-27T19:09:48Z | c05-ex5-tl | duyu-1 | - | - | - | 3.84 | - | d062cde844cbce6d |
| 2026-11-27T19:09:50Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.76 | 3cfac97a8360412bbf93d20d13ff340b | 86006d743b73fc4b |
| 2026-11-27T19:09:51Z | c06-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 86006d743b73fc4b |
| 2026-11-27T19:09:53Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.44 | 53cf74b07ee5498c871f9f59bf602577 | bb9d34c457269eaf |
| 2026-11-27T19:09:54Z | c06-ex2-tl | duyu-1 | - | - | - | 1.44 | - | bb9d34c457269eaf |
| 2026-11-27T19:09:56Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | 817a1111d3084aa5b888e55979ae3255 | b24532d036383aa8 |
| 2026-11-27T19:09:57Z | c09-ex1-tl | duyu-1 | - | - | - | 1.28 | - | b24532d036383aa8 |
