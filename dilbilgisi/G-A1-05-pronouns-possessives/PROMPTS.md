# G-A1-05-pronouns-possessives PROMPTS

Ders: he / she / it, me / him / her, my / your / his / her ve 's · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:05:16Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 12.28 | 583660ce47c14a9082a1de3f0c721fe4 | 7caa9a4659a6e537 |
| 2026-10-14T13:05:17Z | c01-tr | duyu-1 | - | - | - | 12.28 | - | 7caa9a4659a6e537 |
| 2026-10-14T13:05:20Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 11.86 | dfcd4056ac5e4b5c9aea097f72d68a8f | 7b07625eadb26e67 |
| 2026-10-14T13:05:21Z | c02-tr | duyu-1 | - | - | - | 11.86 | - | 7b07625eadb26e67 |
| 2026-10-14T13:05:24Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 164 | 13.31 | 6210b29b2eb24a8c8b48576f245aed7c | b6cc3bfca48cef17 |
| 2026-10-14T13:05:26Z | c03-tr | duyu-1 | - | - | - | 13.31 | - | b6cc3bfca48cef17 |
| 2026-10-14T13:05:28Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 9.31 | 95a5390e711e414ba915ff4dc339d86d | 5fd28c47b3855f3f |
| 2026-10-14T13:05:29Z | c04-tr | duyu-1 | - | - | - | 9.31 | - | 5fd28c47b3855f3f |
| 2026-10-14T13:05:32Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 9.12 | b324b23108cc4ba18b1d98147deab976 | d5f9a8fb56ff19cd |
| 2026-10-14T13:05:33Z | c05-tr | duyu-1 | - | - | - | 9.12 | - | d5f9a8fb56ff19cd |
| 2026-10-14T13:05:35Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 9.47 | cbbf074f70fa4324b2a9e3da992bb35b | 26ae31d4624888c7 |
| 2026-10-14T13:05:36Z | c07-tr | duyu-1 | - | - | - | 9.47 | - | 26ae31d4624888c7 |
| 2026-10-14T13:05:38Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 75 | 4.64 | 449d663211ba4e85b8b0042d61b1d8b1 | b4986ab5ad92b184 |
| 2026-10-14T13:05:39Z | c09-tr | duyu-1 | - | - | - | 4.64 | - | b4986ab5ad92b184 |
| 2026-10-14T13:05:41Z | c10-tr | alania-v2 | alania2-f1 | alania-v2.1 | 149 | 10.11 | 73dd6c3348ab4ba2a5beb5b4aa684a3f | 77924a5f8435f452 |
| 2026-10-14T13:05:42Z | c10-tr | duyu-1 | - | - | - | 10.11 | - | 77924a5f8435f452 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:54:04Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 3edb60c0eee69a95 | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:54:06Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 0334c9539df95631 | audio/en/c02-ex1.mp3 |
| 2026-10-14T14:54:07Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | fcbe1b9a60aeee61 | audio/en/c02-ex2.mp3 |
| 2026-10-14T14:54:08Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 0e29114aa86c115d | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:54:09Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | b1235f4bb50ad8fd | audio/en/c03-ex2.mp3 |
| 2026-10-14T14:54:10Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 37e79c35d4fee75c | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:54:11Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 11 | 13d913c719a839de | audio/en/c04-ex2.mp3 |
| 2026-10-14T14:54:12Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 5a409be8454147e5 | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:54:13Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 38 | 3f7e132afd28844b | audio/en/c06-ex1.mp3 |
| 2026-10-14T14:54:15Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 5b6d780b36cb8acb | audio/en/c06-ex2.mp3 |
| 2026-10-14T14:54:16Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 4b7bc1c77d00c1bf | audio/en/c06-ex3.mp3 |
| 2026-10-14T14:54:17Z | c06-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 6d31d54ee54debca | audio/en/c06-ex4.mp3 |
| 2026-10-14T14:54:18Z | c06-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 016306c84cc7ec9a | audio/en/c06-ex5.mp3 |
| 2026-10-14T14:54:19Z | c07-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 778621772ae2924f | audio/en/c07-ex1.mp3 |
| 2026-10-14T14:54:20Z | c07-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 36 | fd8dcf86dbfb246c | audio/en/c07-ex2.mp3 |
| 2026-11-27T18:17:57Z | c08-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 2.24 | b694808f366e443385fa39e5eced867b | ec8b31266c050568 |
| 2026-11-27T18:17:58Z | c08-q1-fb | duyu-1 | - | - | - | 2.24 | - | ec8b31266c050568 |
| 2026-11-27T18:18:00Z | c08-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.88 | 197ceb80a0ef40568538e1ab01af9e93 | 47acd6e2475a8105 |
| 2026-11-27T18:18:01Z | c08-q2-fb | duyu-1 | - | - | - | 2.88 | - | 47acd6e2475a8105 |
| 2026-11-27T18:18:03Z | c08-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.4 | d951c5fa0ff34363ab79f5c19169bc81 | 2e5fc7931e56c48b |
| 2026-11-27T18:18:04Z | c08-q3-fb | duyu-1 | - | - | - | 2.4 | - | 2e5fc7931e56c48b |
| 2026-11-27T18:18:07Z | c08-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.72 | 83d2d9c6b34947b3b3598b12f01a8b77 | d747b483a0acc2e7 |
| 2026-11-27T18:18:08Z | c08-q4-fb | duyu-1 | - | - | - | 2.72 | - | d747b483a0acc2e7 |
| 2026-11-27T18:58:44Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.12 | 7eaa4e27245c4a899f213de37b12bfdc | 84871a8cf65fe9b5 |
| 2026-11-27T18:58:45Z | c01-ex1-tl | duyu-1 | - | - | - | 1.12 | - | 84871a8cf65fe9b5 |
| 2026-11-27T18:58:47Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.72 | b0c2aa6dfedb40bdb29364753bbdcdbd | 3fe40d3b79eaacc7 |
| 2026-11-27T18:58:48Z | c02-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 3fe40d3b79eaacc7 |
| 2026-11-27T18:58:50Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 3.04 | 6820d84a734b45378097f7f9d5960b22 | 131950a57ae2e6ce |
| 2026-11-27T18:58:52Z | c02-ex2-tl | duyu-1 | - | - | - | 3.04 | - | 131950a57ae2e6ce |
| 2026-11-27T18:58:54Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.12 | 747472d16c0d4f5f87bfdb4ab08d3928 | abf899f07bdb4176 |
| 2026-11-27T18:58:55Z | c03-ex1-tl | duyu-1 | - | - | - | 1.12 | - | abf899f07bdb4176 |
| 2026-11-27T18:58:57Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | 5c8d8b1ed254402f931484ea8a55b96b | b7cd42716f1c0665 |
| 2026-11-27T18:58:58Z | c03-ex2-tl | duyu-1 | - | - | - | 1.28 | - | b7cd42716f1c0665 |
| 2026-11-27T18:59:00Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.44 | 347962473804483f9b4b0be505ec2e28 | a87521cf883b0062 |
| 2026-11-27T18:59:01Z | c04-ex1-tl | duyu-1 | - | - | - | 1.44 | - | a87521cf883b0062 |
| 2026-11-27T18:59:03Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 2.72 | 46288dc6059244baaf1eedb06fafa939 | e9f4a1c7a5e7729c |
| 2026-11-27T18:59:04Z | c04-ex2-tl | duyu-1 | - | - | - | 2.72 | - | e9f4a1c7a5e7729c |
| 2026-11-27T18:59:06Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.76 | 8746d7ed744d44f0b2a328206cf17b3b | 11d68732b3228216 |
| 2026-11-27T18:59:07Z | c05-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 11d68732b3228216 |
| 2026-11-27T18:59:09Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 3.36 | 8471f33a7f9e46fdae5c4cce2abf2a31 | 05164cbdfb85c282 |
| 2026-11-27T18:59:10Z | c06-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 05164cbdfb85c282 |
| 2026-11-27T18:59:12Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | c429da7a7bac4cc89095263ef4581444 | 6529f33d5d424a14 |
| 2026-11-27T18:59:13Z | c06-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 6529f33d5d424a14 |
| 2026-11-27T18:59:15Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | 8b6f9b6c0c1c4379b78479117594f68d | 397fff93db5d1b25 |
| 2026-11-27T18:59:16Z | c06-ex3-tl | duyu-1 | - | - | - | 1.44 | - | 397fff93db5d1b25 |
| 2026-11-27T18:59:18Z | c06-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.6 | 13c8ef931c0b491eb9860185dd9fa1f1 | b3d3fef58d963e75 |
| 2026-11-27T18:59:19Z | c06-ex4-tl | duyu-1 | - | - | - | 1.6 | - | b3d3fef58d963e75 |
| 2026-11-27T18:59:21Z | c06-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | a33e48669b244005bc1fcd72fbff5843 | 3a54b41fc67ac75f |
| 2026-11-27T18:59:22Z | c06-ex5-tl | duyu-1 | - | - | - | 1.44 | - | 3a54b41fc67ac75f |
| 2026-11-27T18:59:24Z | c07-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | f4e768af7fcf458990609d328b580e92 | db481f31b4b5da51 |
| 2026-11-27T18:59:25Z | c07-ex1-tl | duyu-1 | - | - | - | 1.28 | - | db481f31b4b5da51 |
| 2026-11-27T18:59:27Z | c07-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.4 | 4d83083cd78e4902a2da2344bb8a209b | ed6f2e15429a8ba9 |
| 2026-11-27T18:59:28Z | c07-ex2-tl | duyu-1 | - | - | - | 2.4 | - | ed6f2e15429a8ba9 |
