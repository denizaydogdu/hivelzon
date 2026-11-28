# G-B2-05-third-conditional PROMPTS

Ders: 3. tip koşul (third conditional): olmayan geçmiş · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** Alex → Aleks.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:09:28Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 127 | 8.0 | 0b08cc041c9e4491b944742b97cefbc0 | ade3062c980af1b6 |
| 2026-10-14T14:09:29Z | c01-tr | duyu-1 | - | - | - | 8.0 | - | ade3062c980af1b6 |
| 2026-10-14T14:09:31Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 175 | 11.82 | 4681bb61de684bb7a1f2d8d8a6503421 | d53779fd5ccd2d43 |
| 2026-10-14T14:09:32Z | c02-tr | duyu-1 | - | - | - | 11.82 | - | d53779fd5ccd2d43 |
| 2026-10-14T14:09:35Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 137 | 9.28 | 21bab4e26faa430faa677320b068a802 | 7660e38d251a562f |
| 2026-10-14T14:09:36Z | c03-tr | duyu-1 | - | - | - | 9.28 | - | 7660e38d251a562f |
| 2026-10-14T14:09:39Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 13.31 | dcd18dd9bb264eb6a43ab1f0d82c78ef | 807e4dd772063961 |
| 2026-10-14T14:09:41Z | c05-tr | duyu-1 | - | - | - | 13.31 | - | 807e4dd772063961 |
| 2026-10-14T14:09:43Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 153 | 9.62 | 421d39d96f6047a99860cc1e09d615c8 | 479144cb58a71131 |
| 2026-10-14T14:09:44Z | c07-tr | duyu-1 | - | - | - | 9.62 | - | 479144cb58a71131 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:03:23Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 58 | 9683f33e85030eed | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:03:25Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 54 | 5ead0c85efa6f8ee | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:03:28Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | 8711deef91b4bba7 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:03:29Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | d9ae68cea12bb483 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:03:32Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 54 | 395d02f56849223d | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:03:35Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 50 | ac52c3573adc0867 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:03:37Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 50 | 973413d3259759e5 | audio/en/c04-ex3.mp3 |
| 2026-11-26T14:03:39Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 53 | 9126ee027117dc37 | audio/en/c04-ex4.mp3 |
| 2026-11-26T14:03:42Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 55 | fc0d7fd602417507 | audio/en/c04-ex5.mp3 |
| 2026-11-26T14:03:43Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 34 | 37ce7b6eb15f1451 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:03:45Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 8e12cc0e286c5695 | audio/en/c05-ex2.mp3 |
| 2026-11-27T18:28:19Z | c06-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 3.36 | f6a7ee2d8e7f42228daaaf43d5354979 | 5c3d5569d8d36673 |
| 2026-11-27T18:28:20Z | c06-q1-fb | duyu-1 | - | - | - | 3.36 | - | 5c3d5569d8d36673 |
| 2026-11-27T18:28:22Z | c06-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 47 | 3.84 | ccc6cdaa50c84a0999c0687d3576505f | ce2b6877083820f5 |
| 2026-11-27T18:28:23Z | c06-q2-fb | duyu-1 | - | - | - | 3.84 | - | ce2b6877083820f5 |
| 2026-11-27T18:28:25Z | c06-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 2.4 | 11c410a441824fa594a0994f5a480281 | 782647ce89c79719 |
| 2026-11-27T18:28:26Z | c06-q3-fb | duyu-1 | - | - | - | 2.4 | - | 782647ce89c79719 |
| 2026-11-27T18:28:29Z | c06-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 4.16 | 4d040c5ebac0443982ea06e9badf458f | 035d082cd5197779 |
| 2026-11-27T18:28:30Z | c06-q4-fb | duyu-1 | - | - | - | 4.16 | - | 035d082cd5197779 |
| 2026-11-27T19:30:28Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 3.04 | 7fc18fe7e7b346758794501218e8fd88 | d511ac1c608755fa |
| 2026-11-27T19:30:29Z | c01-ex1-tl | duyu-1 | - | - | - | 3.04 | - | d511ac1c608755fa |
| 2026-11-27T19:30:31Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 3.2 | 04dc00b380494227a03f4a0dbea5d6e6 | 636abc6bfd5c5e0d |
| 2026-11-27T19:30:32Z | c02-ex1-tl | duyu-1 | - | - | - | 3.2 | - | 636abc6bfd5c5e0d |
| 2026-11-27T19:30:34Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.08 | 6b5a75ebe70643e5971887b9ab556043 | 86f33dd9ccccbd16 |
| 2026-11-27T19:30:35Z | c03-ex1-tl | duyu-1 | - | - | - | 2.08 | - | 86f33dd9ccccbd16 |
| 2026-11-27T19:30:37Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 2.4 | 5083826ac9a54fe7a1bfa6994ebede03 | 3cf7fcee4c6d2cbf |
| 2026-11-27T19:30:38Z | c03-ex2-tl | duyu-1 | - | - | - | 2.4 | - | 3cf7fcee4c6d2cbf |
| 2026-11-27T19:30:40Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.56 | c4ab2e126de5485f975b687fb5edd975 | c4fa46af72ac4a41 |
| 2026-11-27T19:30:41Z | c04-ex1-tl | duyu-1 | - | - | - | 2.56 | - | c4fa46af72ac4a41 |
| 2026-11-27T19:30:43Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | c1b75ff84f544b5696fb474b1cdd7d89 | 97b212033390c518 |
| 2026-11-27T19:30:45Z | c04-ex2-tl | duyu-1 | - | - | - | 1.92 | - | 97b212033390c518 |
| 2026-11-27T19:30:47Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 1.92 | f154531632c9497fbbfaad88a9fd5f6d | e3591debf9c17f07 |
| 2026-11-27T19:30:47Z | c04-ex3-tl | duyu-1 | - | - | - | 1.92 | - | e3591debf9c17f07 |
| 2026-11-27T19:30:49Z | c04-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.4 | c03bc0ab79c042c785672d53586770a6 | 372f8339a845fbfd |
| 2026-11-27T19:30:50Z | c04-ex4-tl | duyu-1 | - | - | - | 2.4 | - | 372f8339a845fbfd |
| 2026-11-27T19:30:53Z | c04-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.4 | ea7fe7ac11e84cf7afe8f384b0643fe1 | 604f00feb56c21f2 |
| 2026-11-27T19:30:54Z | c04-ex5-tl | duyu-1 | - | - | - | 2.4 | - | 604f00feb56c21f2 |
| 2026-11-27T19:30:56Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | 65df1d1f5fae4484ae3dedd1d22b4f0c | 1fc6ca85a5d7a7df |
| 2026-11-27T19:30:57Z | c05-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 1fc6ca85a5d7a7df |
| 2026-11-27T19:30:59Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | df5ac2fbe762486c9e8ca9e7e2eb3413 | c772234b6aea2256 |
| 2026-11-27T19:31:00Z | c05-ex2-tl | duyu-1 | - | - | - | 1.44 | - | c772234b6aea2256 |
