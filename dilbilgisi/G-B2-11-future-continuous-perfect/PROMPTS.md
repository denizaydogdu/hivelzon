# G-B2-11-future-continuous-perfect PROMPTS

Ders: Gelecekte süren ve bitmiş eylem: will be doing, will have done · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** -ing → ing.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:12:15Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 145 | 13.15 | 82a21e3535b7437a8335b5eeef684f30 | f3c21623261d2594 |
| 2026-10-14T14:12:16Z | c01-tr | duyu-1 | - | - | - | 13.15 | - | f3c21623261d2594 |
| 2026-10-14T14:12:19Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 10.43 | d23b6a316f3f4302b4ed5e31c19f7039 | c7e1abbfb8fb1ba8 |
| 2026-10-14T14:12:20Z | c02-tr | duyu-1 | - | - | - | 10.43 | - | c7e1abbfb8fb1ba8 |
| 2026-10-14T14:12:23Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 208 | 13.1 | 555082254fb748cfbccdd4e7cce00326 | e43e2266b39a28d0 |
| 2026-10-14T14:12:25Z | c03-tr | duyu-1 | - | - | - | 13.1 | - | e43e2266b39a28d0 |
| 2026-10-14T14:12:28Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 181 | 12.03 | 0b7247c6f5504243a51720e07a991a22 | cd8a6db840126c16 |
| 2026-10-14T14:12:30Z | c04-tr | duyu-1 | - | - | - | 12.03 | - | cd8a6db840126c16 |
| 2026-10-14T14:12:33Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 208 | 13.31 | d893788200964678aa33b2e316664370 | d22108ef867135a6 |
| 2026-10-14T14:12:35Z | c06-tr | duyu-1 | - | - | - | 13.31 | - | d22108ef867135a6 |
| 2026-10-14T14:12:37Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 9.15 | 4ebd9394a6df46498b5843dbfafb575d | 93c8f033d3049f26 |
| 2026-10-14T14:12:39Z | c08-tr | duyu-1 | - | - | - | 9.15 | - | 93c8f033d3049f26 |
| 2026-10-14T14:13:16Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 14.09 | d63fa2bcc136415f99db9fbb3401c052 | 9a03cd6ab3134e01 |
| 2026-10-14T14:13:18Z | c04-tr | duyu-1 | - | - | - | 14.09 | - | 9a03cd6ab3134e01 |
| 2026-11-20T16:01:02Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 10.4 | 922df3ec74af48f99fcdbab9c12b2f66 | 52f402572b6299e0 |
| 2026-11-20T16:01:06Z | c01-tr | duyu-1 | - | - | - | 10.4 | - | 52f402572b6299e0 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:05:54Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 55 | 5b1afb046e181764 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:05:56Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 47cac6a3fd2a85c7 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:05:58Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | f792a4afda5dfded | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:06:00Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 7513ac0e26f74803 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:06:01Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 72665b5667c764ec | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:06:03Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 1c3246876ff8a2cf | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:06:05Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 34 | 103cbd161089b5d6 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:06:06Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | e23d5ac3d180a064 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:06:08Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 9a40373980b2056d | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:06:11Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | 0413d0789aed95a0 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:06:13Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 42 | 8ca09d69b2a95c93 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:06:16Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 45 | b4a22a5cc079c3b0 | audio/en/c07-q5.mp3 |
| 2026-11-27T18:29:45Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 3.2 | 61a2d5c6093c4de2bdb30fb4b2d0355a | d363a23a0417b324 |
| 2026-11-27T18:29:46Z | c07-q1-fb | duyu-1 | - | - | - | 3.2 | - | d363a23a0417b324 |
| 2026-11-27T18:29:48Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.72 | 953da6e18b584c769199bad179d63824 | 2057b526022d9b37 |
| 2026-11-27T18:29:49Z | c07-q2-fb | duyu-1 | - | - | - | 2.72 | - | 2057b526022d9b37 |
| 2026-11-27T18:29:51Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 4.0 | 014adb79aa2e43cdb56047d20aae4cab | adaa3f9d314e338e |
| 2026-11-27T18:29:52Z | c07-q3-fb | duyu-1 | - | - | - | 4.0 | - | adaa3f9d314e338e |
| 2026-11-27T18:29:55Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 55 | 3.36 | 815bcdb6ebb44d02a2a12378b25fb89e | 778a09479555d84f |
| 2026-11-27T18:29:56Z | c07-q4-fb | duyu-1 | - | - | - | 3.36 | - | 778a09479555d84f |
| 2026-11-27T19:34:30Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 3.36 | ea1a5107211c4b66aaa4a2f79cd70da9 | a134d23e7a086c7f |
| 2026-11-27T19:34:31Z | c01-ex1-tl | duyu-1 | - | - | - | 3.36 | - | a134d23e7a086c7f |
| 2026-11-27T19:34:33Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.24 | c535738a141b445d81ec4e09fff843f6 | 92b1c3ada57331bf |
| 2026-11-27T19:34:34Z | c02-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 92b1c3ada57331bf |
| 2026-11-27T19:34:36Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.56 | 6000a35887d249f29bf89f6d6e5269cb | ec2c7c94ea8b5bd7 |
| 2026-11-27T19:34:37Z | c03-ex1-tl | duyu-1 | - | - | - | 2.56 | - | ec2c7c94ea8b5bd7 |
| 2026-11-27T19:34:39Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.88 | c3570a160d084f5cb1b52f13da73f48e | 51d574d69deda941 |
| 2026-11-27T19:34:40Z | c04-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 51d574d69deda941 |
| 2026-11-27T19:34:43Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 4.0 | 430b5afc803345b590ce8fb4025427d4 | 0af81d0e2034a2a7 |
| 2026-11-27T19:34:44Z | c04-ex2-tl | duyu-1 | - | - | - | 4.0 | - | 0af81d0e2034a2a7 |
| 2026-11-27T19:34:46Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.08 | 156f2878b652413799cace31d17a0ea1 | 41427a5997eec7a8 |
| 2026-11-27T19:34:47Z | c05-ex1-tl | duyu-1 | - | - | - | 2.08 | - | 41427a5997eec7a8 |
| 2026-11-27T19:34:49Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.24 | c063ee55c79445c99544a4da97e744a1 | c15a6bbff7bd96b1 |
| 2026-11-27T19:34:50Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | c15a6bbff7bd96b1 |
| 2026-11-27T19:34:53Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.72 | 962dbe53ba514e39984508e4fb89bf22 | 51968d68a00edeb4 |
| 2026-11-27T19:34:54Z | c05-ex3-tl | duyu-1 | - | - | - | 2.72 | - | 51968d68a00edeb4 |
| 2026-11-27T19:34:56Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 4.48 | 12f8d2a269764ecb9a1e183ab71f391d | f65adaa067138c1c |
| 2026-11-27T19:34:58Z | c05-ex4-tl | duyu-1 | - | - | - | 4.48 | - | f65adaa067138c1c |
| 2026-11-27T19:35:00Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 3.04 | ae687a8d6c7740c7a5fd6de55bfb326a | 5b012551305b3be4 |
| 2026-11-27T19:35:01Z | c05-ex5-tl | duyu-1 | - | - | - | 3.04 | - | 5b012551305b3be4 |
| 2026-11-27T19:35:04Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.72 | 862d89cc0f1d4fb697491568335505c6 | 395bad6e32f0ef51 |
| 2026-11-27T19:35:04Z | c06-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 395bad6e32f0ef51 |
| 2026-11-27T19:35:07Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.56 | 38bf67c7bfd546cc86f5dc5a00e3ef36 | b777a07a508647c2 |
| 2026-11-27T19:35:08Z | c07-q5-tl | duyu-1 | - | - | - | 2.56 | - | b777a07a508647c2 |
