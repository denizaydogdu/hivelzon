# G-B1-04-past-continuous PROMPTS

Ders: Past continuous ve when / while · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ing` → "ing".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:06:38Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 162 | 10.91 | 815bc9ecc4644756ac9e8d33a4f77c6c | 8b29df3d28d60502 |
| 2026-10-14T14:06:39Z | c01-tr | duyu-1 | - | - | - | 10.91 | - | 8b29df3d28d60502 |
| 2026-10-14T14:06:42Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 205 | 15.06 | 1614210617fa4c59baca9fc498cf7211 | 7c9c6acf88c29dd7 |
| 2026-10-14T14:06:44Z | c02-tr | duyu-1 | - | - | - | 15.06 | - | 7c9c6acf88c29dd7 |
| 2026-10-14T14:06:47Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 203 | 14.43 | a200b17927a741f2af51cd38f6d50f4a | 93f7c23496a73524 |
| 2026-10-14T14:06:48Z | c03-tr | duyu-1 | - | - | - | 14.43 | - | 93f7c23496a73524 |
| 2026-10-14T14:06:51Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 173 | 12.51 | 168e69598e6e4380a2b2061524e20920 | 59a75811d1655f27 |
| 2026-10-14T14:06:53Z | c05-tr | duyu-1 | - | - | - | 12.51 | - | 59a75811d1655f27 |
| 2026-10-14T14:06:55Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 78 | 4.96 | 686df5fac7194b72a173ff425e9e7092 | e5cfdac8feeb9a0a |
| 2026-10-14T14:06:57Z | c07-tr | duyu-1 | - | - | - | 4.96 | - | e5cfdac8feeb9a0a |
| 2026-10-14T14:06:59Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 9.28 | 3e904d73f5654fb9a71e8308ad3c3248 | acf747090bc81a96 |
| 2026-10-14T14:07:00Z | c08-tr | duyu-1 | - | - | - | 9.28 | - | acf747090bc81a96 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T13:58:45Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 20 | 5d7fb94a1aac04fe | audio/en/c01-ex1.mp3 |
| 2026-11-26T13:58:47Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | 3131cf4168dcfba4 | audio/en/c02-ex1.mp3 |
| 2026-11-26T13:58:48Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 27 | 84c8ec90ef19b404 | audio/en/c02-ex2.mp3 |
| 2026-11-26T13:58:50Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | bf2b5cf02ae765ce | audio/en/c03-ex1.mp3 |
| 2026-11-26T13:58:52Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 47 | 9ad98edf44dab543 | audio/en/c03-ex2.mp3 |
| 2026-11-26T13:58:55Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 76bd700f0d246b0d | audio/en/c04-ex1.mp3 |
| 2026-11-26T13:58:57Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 43 | 111f2311ffbabdb0 | audio/en/c04-ex2.mp3 |
| 2026-11-26T13:58:59Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | d5bd707289f73565 | audio/en/c04-ex3.mp3 |
| 2026-11-26T13:59:01Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | e717a4ae48e6e331 | audio/en/c04-ex4.mp3 |
| 2026-11-26T13:59:03Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | eb2b79979e858cc8 | audio/en/c04-ex5.mp3 |
| 2026-11-26T13:59:04Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 7990f8ea371562e3 | audio/en/c05-ex1.mp3 |
| 2026-11-26T13:59:06Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | bb254678c9859347 | audio/en/c05-ex2.mp3 |
| 2026-11-26T13:59:07Z | c08-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 34 | 1a87f2c1525d70d1 | audio/en/c08-ex1.mp3 |
| 2026-11-27T18:24:45Z | c06-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 4.32 | 31a795dfc57947e686072af48576f3b6 | b529d9a1c529403e |
| 2026-11-27T18:24:46Z | c06-q1-fb | duyu-1 | - | - | - | 4.32 | - | b529d9a1c529403e |
| 2026-11-27T18:24:51Z | c06-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 3.68 | e2257c641fa947438857a9e95af04404 | c98112f30a3dcdcb |
| 2026-11-27T18:24:52Z | c06-q2-fb | duyu-1 | - | - | - | 3.68 | - | c98112f30a3dcdcb |
| 2026-11-27T18:24:55Z | c06-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.88 | c9c474abe6834b858db20b8dd0a8ee84 | 4fba4c620bfc5111 |
| 2026-11-27T18:24:56Z | c06-q3-fb | duyu-1 | - | - | - | 2.88 | - | 4fba4c620bfc5111 |
| 2026-11-27T18:24:58Z | c06-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 3.04 | 6592c868e0b14f22801d520791db97ea | 5b66385c0013f33d |
| 2026-11-27T18:25:00Z | c06-q4-fb | duyu-1 | - | - | - | 3.04 | - | 5b66385c0013f33d |
| 2026-11-27T19:19:43Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | dd8fc951708b4882ada92f04911fc2dd | 90033e7fda1b1402 |
| 2026-11-27T19:19:44Z | c01-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 90033e7fda1b1402 |
| 2026-11-27T19:19:46Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | d951fbee370f478b8803fc0060900a23 | 8611465d3c0cf62b |
| 2026-11-27T19:19:47Z | c02-ex1-tl | duyu-1 | - | - | - | 1.28 | - | 8611465d3c0cf62b |
| 2026-11-27T19:19:49Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 2.72 | 8264b01dd708443cae423ece030f3abf | 940c268048af7025 |
| 2026-11-27T19:19:50Z | c02-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 940c268048af7025 |
| 2026-11-27T19:19:52Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 4.48 | 682aecca8ad84cf5988e360f277b70bd | 1f5aa8327db46fd6 |
| 2026-11-27T19:19:53Z | c03-ex1-tl | duyu-1 | - | - | - | 4.48 | - | 1f5aa8327db46fd6 |
| 2026-11-27T19:19:56Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.4 | 2f9bcce555c74f359cf006b886b70249 | 7d9c13c97784d04a |
| 2026-11-27T19:19:57Z | c03-ex2-tl | duyu-1 | - | - | - | 2.4 | - | 7d9c13c97784d04a |
| 2026-11-27T19:19:59Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.24 | 0ee0f1bf4f5145468866c4631c4bba97 | fb1073b20ba2b0c7 |
| 2026-11-27T19:20:00Z | c04-ex1-tl | duyu-1 | - | - | - | 2.24 | - | fb1073b20ba2b0c7 |
| 2026-11-27T19:20:03Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 3.52 | 0f95fcb12abb46bc8ac31b5b45e5229b | 8e57bab01c523e8c |
| 2026-11-27T19:20:04Z | c04-ex2-tl | duyu-1 | - | - | - | 3.52 | - | 8e57bab01c523e8c |
| 2026-11-27T19:20:06Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 3.84 | 38d7bba43030486aae2a19dc3ad8847c | 9ebbbe0f81e29e19 |
| 2026-11-27T19:20:07Z | c04-ex3-tl | duyu-1 | - | - | - | 3.84 | - | 9ebbbe0f81e29e19 |
| 2026-11-27T19:20:10Z | c04-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 3.36 | 878c12f74bce41cdb786a56e97b97100 | 4ab67804599b7d93 |
| 2026-11-27T19:20:11Z | c04-ex4-tl | duyu-1 | - | - | - | 3.36 | - | 4ab67804599b7d93 |
| 2026-11-27T19:20:13Z | c04-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.6 | fc6c4c21c77d4d0d96b9b7da4e76013e | 2dc65baef1c0cce7 |
| 2026-11-27T19:20:14Z | c04-ex5-tl | duyu-1 | - | - | - | 1.6 | - | 2dc65baef1c0cce7 |
| 2026-11-27T19:20:16Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.28 | 1c204f3c06a541839dccbae038b05157 | 89a83c29496c3cfb |
| 2026-11-27T19:20:17Z | c05-ex1-tl | duyu-1 | - | - | - | 1.28 | - | 89a83c29496c3cfb |
| 2026-11-27T19:20:19Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.6 | 0ef385277a334d3d8fb38f76f0f3a679 | fb6bceb16320274a |
| 2026-11-27T19:20:20Z | c05-ex2-tl | duyu-1 | - | - | - | 1.6 | - | fb6bceb16320274a |
| 2026-11-27T19:20:22Z | c08-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 3.04 | 9fd3158bc5be4bb1a83641e24884504f | 96088e9c64cad426 |
| 2026-11-27T19:20:24Z | c08-ex1-tl | duyu-1 | - | - | - | 3.04 | - | 96088e9c64cad426 |
