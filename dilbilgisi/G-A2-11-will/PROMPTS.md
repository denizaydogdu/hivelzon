# G-A2-11-will PROMPTS

Ders: will: anlık karar, söz ve tahmin · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `Alex` → "Aleks".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:10:58Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 9.13 | af37914a81054da19dc53f42215521ae | 023a70ef67ea9e5a |
| 2026-10-14T13:11:00Z | c01-tr | duyu-1 | - | - | - | 9.13 | - | 023a70ef67ea9e5a |
| 2026-10-14T13:11:02Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 141 | 10.43 | acbef9ca8e2b41ccb901d930472ab57f | 4e9d2b9da58fc090 |
| 2026-10-14T13:11:03Z | c02-tr | duyu-1 | - | - | - | 10.43 | - | 4e9d2b9da58fc090 |
| 2026-10-14T13:11:06Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 9.79 | d82125946c934e229f6ae59528e85076 | 2d4924f831216933 |
| 2026-10-14T13:11:07Z | c03-tr | duyu-1 | - | - | - | 9.79 | - | 2d4924f831216933 |
| 2026-10-14T13:11:10Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 179 | 12.34 | 26d21ad2b26b401486496262162a5c6b | 6db05e4149fc77fb |
| 2026-10-14T13:11:11Z | c04-tr | duyu-1 | - | - | - | 12.34 | - | 6db05e4149fc77fb |
| 2026-10-14T13:11:14Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 185 | 11.87 | b6e2efc3a1664fd18477e4a2ef57bceb | 280ab95967032e62 |
| 2026-10-14T13:11:15Z | c06-tr | duyu-1 | - | - | - | 11.87 | - | 280ab95967032e62 |
| 2026-10-14T13:11:18Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 100 | 7.04 | a40197bd091c4e4cb550b03e0325e509 | d6bfc4401e9928c5 |
| 2026-10-14T13:11:19Z | c08-tr | duyu-1 | - | - | - | 7.04 | - | d6bfc4401e9928c5 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:28:48Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 17 | 9f8fa68320600394 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:28:50Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 14 | e79701d1f2cec056 | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:28:51Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 16 | 5983282ec909870c | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:28:53Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | e8a2f9029b97b5d1 | audio/en/c03-ex3.mp3 |
| 2026-10-30T13:28:54Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 38 | 02d39ad5b93abf3f | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:28:56Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 34 | a9ee6e385962a971 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:28:58Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 33 | da35d43e3fc0a08a | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:28:59Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | 0eb51ecbf0160bd4 | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:29:01Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 37 | 376bf3024c7ea9e5 | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:29:02Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | f699911dfa44599a | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:29:04Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 25 | cde2db62cd417101 | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:29:05Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 13 | 15051c9769aec101 | audio/en/c06-ex1.mp3 |
| 2026-10-30T13:29:06Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 14 | 082ade7e6ab15640 | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:22:54Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.56 | 143742d402834a7e88c1c360e4200ed0 | 7647fd15bbc22cb4 |
| 2026-11-27T18:22:55Z | c07-q1-fb | duyu-1 | - | - | - | 2.56 | - | 7647fd15bbc22cb4 |
| 2026-11-27T18:22:57Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.72 | bd90a882d8254820a3f7766f349665a0 | e35bf4609a708bc5 |
| 2026-11-27T18:22:58Z | c07-q2-fb | duyu-1 | - | - | - | 2.72 | - | e35bf4609a708bc5 |
| 2026-11-27T18:23:01Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 9d191d98985a40eb8ba7e9128602ae2f | 7a8e0e9a64aa264c |
| 2026-11-27T18:23:01Z | c07-q3-fb | duyu-1 | - | - | - | 1.76 | - | 7a8e0e9a64aa264c |
| 2026-11-27T18:23:04Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.72 | 935c0ff0f6fb46aa835eb525aa4e5c31 | 92cd2fa737209341 |
| 2026-11-27T18:23:05Z | c07-q4-fb | duyu-1 | - | - | - | 2.72 | - | 92cd2fa737209341 |
| 2026-11-27T19:13:51Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.6 | 07d16639a44c41eba246bf6b89d4ce00 | 00ae08b989e4e717 |
| 2026-11-27T19:13:52Z | c01-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 00ae08b989e4e717 |
| 2026-11-27T19:13:53Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.28 | b6f87a1ddaf24455bae49a7e0bb72bb6 | 263cf7e6cd29064c |
| 2026-11-27T19:13:54Z | c03-ex1-tl | duyu-1 | - | - | - | 1.28 | - | 263cf7e6cd29064c |
| 2026-11-27T19:13:56Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.28 | 16f2bc34f9be49489b079b36f74b4410 | 9e332539ec4fcd5d |
| 2026-11-27T19:13:57Z | c03-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 9e332539ec4fcd5d |
| 2026-11-27T19:13:59Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.4 | 485b1eb90f6d4460a7b46858076a8f2e | 073d1dd8d5c53df2 |
| 2026-11-27T19:14:00Z | c03-ex3-tl | duyu-1 | - | - | - | 2.4 | - | 073d1dd8d5c53df2 |
| 2026-11-27T19:14:03Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.24 | c5cc2949894c47fd9821c3cbe7ba3e95 | 5e272e7a46c785ca |
| 2026-11-27T19:14:04Z | c04-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 5e272e7a46c785ca |
| 2026-11-27T19:14:06Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.56 | b424050cd82a48e09180f84852e4da2e | cb75a4a237491ba4 |
| 2026-11-27T19:14:07Z | c04-ex2-tl | duyu-1 | - | - | - | 2.56 | - | cb75a4a237491ba4 |
| 2026-11-27T19:14:09Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.72 | 8e373b00efd2413590530418470687c9 | 61729c941197eca3 |
| 2026-11-27T19:14:10Z | c05-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 61729c941197eca3 |
| 2026-11-27T19:14:12Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | c77f198e7a6945f28af9a596572e3854 | 95b4f55855c2d2b7 |
| 2026-11-27T19:14:13Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 95b4f55855c2d2b7 |
| 2026-11-27T19:14:15Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | 914e1a8861874464be5810c704122e73 | 71a63ac1241fa964 |
| 2026-11-27T19:14:16Z | c05-ex3-tl | duyu-1 | - | - | - | 2.08 | - | 71a63ac1241fa964 |
| 2026-11-27T19:14:18Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.88 | f9448bf04cc24449aa61df02894993f2 | e7889dc08cae56f3 |
| 2026-11-27T19:14:19Z | c05-ex4-tl | duyu-1 | - | - | - | 2.88 | - | e7889dc08cae56f3 |
| 2026-11-27T19:14:22Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 3.84 | d77ee3a033264a99bf515bc2cb7a604d | 90e39783f97118fc |
| 2026-11-27T19:14:23Z | c05-ex5-tl | duyu-1 | - | - | - | 3.84 | - | 90e39783f97118fc |
| 2026-11-27T19:14:25Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.28 | f45f9f7654fc4e83a5622b3aefc1baed | f7ba92a9cb29d220 |
| 2026-11-27T19:14:26Z | c06-ex1-tl | duyu-1 | - | - | - | 1.28 | - | f7ba92a9cb29d220 |
| 2026-11-27T19:14:28Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | af1cb337b3e844cd96e1eeffc44e460c | 8db227ba8d0661c6 |
| 2026-11-27T19:14:29Z | c06-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 8db227ba8d0661c6 |
