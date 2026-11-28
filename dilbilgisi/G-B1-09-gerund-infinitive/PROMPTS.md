# G-B1-09-gerund-infinitive PROMPTS

Ders: -ing mi, to mu? Fiil kalıpları (2) · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:08:46Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 8.99 | e108393839a849e5823e2a7bb2dbc291 | 4bd26d44fd5e1326 |
| 2026-10-14T14:08:47Z | c01-tr | duyu-1 | - | - | - | 8.99 | - | 4bd26d44fd5e1326 |
| 2026-10-14T14:08:49Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 185 | 12.16 | 2befb8a648814de18e34fc528ef0eeac | 36b610680fd2cdfa |
| 2026-10-14T14:08:51Z | c02-tr | duyu-1 | - | - | - | 12.16 | - | 36b610680fd2cdfa |
| 2026-10-14T14:08:54Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 216 | 15.58 | 20f85058c08645a8ba7ae5e6d94e4fb0 | 2baee57ab1db5421 |
| 2026-10-14T14:08:55Z | c03-tr | duyu-1 | - | - | - | 15.58 | - | 2baee57ab1db5421 |
| 2026-10-14T14:08:58Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 8.32 | 5fd96a3dc5484d89ad000d73e00b1102 | 4ed58465382ec5e5 |
| 2026-10-14T14:09:00Z | c04-tr | duyu-1 | - | - | - | 8.32 | - | 4ed58465382ec5e5 |
| 2026-10-14T14:09:02Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 221 | 14.91 | ce2328e792424f6d82ad78d6cbb66412 | 807fc8877b192038 |
| 2026-10-14T14:09:04Z | c06-tr | duyu-1 | - | - | - | 14.91 | - | 807fc8877b192038 |
| 2026-10-14T14:09:06Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 77 | 4.64 | 8bc700f5695b492bb64b2f48a7a9d06b | 3aaab09c7e21e706 |
| 2026-10-14T14:09:08Z | c08-tr | duyu-1 | - | - | - | 4.64 | - | 3aaab09c7e21e706 |
| 2026-10-14T14:09:10Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 11.02 | 9e062632a2924fdfa5d30d059679e402 | fa0b8e04c8571b6b |
| 2026-10-14T14:09:11Z | c09-tr | duyu-1 | - | - | - | 11.02 | - | fa0b8e04c8571b6b |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:00:36Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | b467a35e7456fb78 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:00:37Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 16 | 73b7a9a5c482c4d0 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:00:39Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | d6f208bd4bae66a6 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:00:40Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 21 | c3f873a939f6237f | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:00:42Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 60496166d97eb3d5 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:00:43Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | a4c23ae0ba474ea6 | audio/en/c03-ex3.mp3 |
| 2026-11-26T14:00:45Z | c03-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | cfc278286a90da74 | audio/en/c03-ex4.mp3 |
| 2026-11-26T14:00:46Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | 7d995d596e2b5670 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:00:48Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 27 | 193a5d77443e7948 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:00:49Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 047e283320419485 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:00:51Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 899e7612cdc88adf | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:00:53Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 25 | e5ff0cca97fa78f7 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:00:54Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 34 | c9a75dab07283040 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:00:56Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 17 | e6b72b66a2c3d4a3 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:00:58Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | f33b15009e56b1c2 | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:25:57Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.08 | b3802c30dcfb4850810812abc9c7ef1f | d14f948fae960336 |
| 2026-11-27T18:25:58Z | c07-q1-fb | duyu-1 | - | - | - | 2.08 | - | d14f948fae960336 |
| 2026-11-27T18:26:00Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.24 | d6c1271323434822bb2a617a134a2482 | d17797fefe24adfe |
| 2026-11-27T18:26:02Z | c07-q2-fb | duyu-1 | - | - | - | 2.24 | - | d17797fefe24adfe |
| 2026-11-27T18:26:04Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 4.48 | ff75c6b177ec49478ecbc07d19b5d3ca | d813af18d3961d90 |
| 2026-11-27T18:26:05Z | c07-q3-fb | duyu-1 | - | - | - | 4.48 | - | d813af18d3961d90 |
| 2026-11-27T18:26:07Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 3.04 | 296c775588e34151a15f1b471db1dd37 | 0026653c7d400615 |
| 2026-11-27T18:26:08Z | c07-q4-fb | duyu-1 | - | - | - | 3.04 | - | 0026653c7d400615 |
| 2026-11-27T19:23:19Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.4 | b06252b897a7429d8992009f8979b577 | 065f1316e0bafad1 |
| 2026-11-27T19:23:20Z | c01-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 065f1316e0bafad1 |
| 2026-11-27T19:23:22Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 3.52 | 4dc48f41d6da49d089ab36b52e11811c | 0d9c9372c08445ac |
| 2026-11-27T19:23:23Z | c02-ex1-tl | duyu-1 | - | - | - | 3.52 | - | 0d9c9372c08445ac |
| 2026-11-27T19:23:26Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.24 | a541252375a84efd8740af8b818fb6ba | 06c0c2b29c67125b |
| 2026-11-27T19:23:27Z | c02-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 06c0c2b29c67125b |
| 2026-11-27T19:23:28Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | 7f24b1b808db43cdae9a162fa03f3fb4 | 139fca57f81e6ea4 |
| 2026-11-27T19:23:30Z | c03-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 139fca57f81e6ea4 |
| 2026-11-27T19:23:32Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | a6b82fe719c046439a2f20354b8c645a | a394d1c12b524eda |
| 2026-11-27T19:23:33Z | c03-ex2-tl | duyu-1 | - | - | - | 1.76 | - | a394d1c12b524eda |
| 2026-11-27T19:23:35Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | f5ddde17c08b4e80aa8c186120e55e4f | 7f1034514d55c55a |
| 2026-11-27T19:23:36Z | c03-ex3-tl | duyu-1 | - | - | - | 1.92 | - | 7f1034514d55c55a |
| 2026-11-27T19:23:38Z | c03-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.24 | e3a384f7ed0e4815a4c5113854602b08 | 5de04cf81d94b29f |
| 2026-11-27T19:23:39Z | c03-ex4-tl | duyu-1 | - | - | - | 2.24 | - | 5de04cf81d94b29f |
| 2026-11-27T19:23:41Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.56 | 9e46c5670316405698648ddf87473a27 | a4994d91525e1f07 |
| 2026-11-27T19:23:42Z | c04-ex1-tl | duyu-1 | - | - | - | 2.56 | - | a4994d91525e1f07 |
| 2026-11-27T19:23:44Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 3.36 | 52739bbeade244ef8fbf3e4b8289a3a6 | 5f67762db391580d |
| 2026-11-27T19:23:45Z | c05-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 5f67762db391580d |
| 2026-11-27T19:23:48Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.24 | d969135d22334408aa5c5697cddb3ec4 | 3da58b5bb74a652f |
| 2026-11-27T19:23:49Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 3da58b5bb74a652f |
| 2026-11-27T19:23:51Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 1.92 | d346d9c9adfd4a7880a9c4b04d232263 | 2c26a2c3bbf8691a |
| 2026-11-27T19:23:52Z | c05-ex3-tl | duyu-1 | - | - | - | 1.92 | - | 2c26a2c3bbf8691a |
| 2026-11-27T19:23:54Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | 2ff5771e9607476e937f89e6aef98f33 | 0845d499d0b44cef |
| 2026-11-27T19:23:55Z | c05-ex4-tl | duyu-1 | - | - | - | 1.44 | - | 0845d499d0b44cef |
| 2026-11-27T19:23:57Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.56 | 8eaf18f551bc4c28918045ff7080717d | 7af5adf151bc83cd |
| 2026-11-27T19:23:58Z | c05-ex5-tl | duyu-1 | - | - | - | 2.56 | - | 7af5adf151bc83cd |
| 2026-11-27T19:24:00Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | aa13e351379d4eccb387e6bfbf532c5b | e41433970176f21c |
| 2026-11-27T19:24:00Z | c06-ex1-tl | duyu-1 | - | - | - | 1.28 | - | e41433970176f21c |
| 2026-11-27T19:24:03Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 4.48 | 73e96af6b2104a3297568568761ad259 | faba15a2495c2060 |
| 2026-11-27T19:24:04Z | c09-ex1-tl | duyu-1 | - | - | - | 4.48 | - | faba15a2495c2060 |
