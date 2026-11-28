# G-B2-06-wish-if-only PROMPTS

Ders: wish ve if only: dilek ve pişmanlık · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:09:47Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 134 | 9.44 | bec47c42313240a9a0c79db2de962b9a | 56758244e61c1301 |
| 2026-10-14T14:09:49Z | c01-tr | duyu-1 | - | - | - | 9.44 | - | 56758244e61c1301 |
| 2026-10-14T14:09:52Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 13.86 | 3a459e6b1b7e4f429a6fe05cb54a383c | ff26b2497d9b9b91 |
| 2026-10-14T14:09:54Z | c02-tr | duyu-1 | - | - | - | 13.86 | - | ff26b2497d9b9b91 |
| 2026-10-14T14:09:56Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 170 | 10.63 | a6971ab9d3c145a9ba5cbd84934a6976 | 3468b3253f035b35 |
| 2026-10-14T14:09:58Z | c03-tr | duyu-1 | - | - | - | 10.63 | - | 3468b3253f035b35 |
| 2026-10-14T14:10:01Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 13.15 | 822cfbba2ddc46a89da2372a485070d0 | 6881b36601af1bd2 |
| 2026-10-14T14:10:02Z | c04-tr | duyu-1 | - | - | - | 13.15 | - | 6881b36601af1bd2 |
| 2026-10-14T14:10:05Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 207 | 13.15 | d636648a47874186982448e84d2b57ca | eae416cebed4c8cd |
| 2026-10-14T14:10:06Z | c06-tr | duyu-1 | - | - | - | 13.15 | - | eae416cebed4c8cd |
| 2026-10-14T14:10:09Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 9.47 | 60122863fc754b8ebe3857856c691bed | da0824049e83247a |
| 2026-10-14T14:10:10Z | c08-tr | duyu-1 | - | - | - | 9.47 | - | da0824049e83247a |
| 2026-11-20T16:00:42Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 8.96 | 951ced63da594d7c89babd502613bfda | c403418bdefee72a |
| 2026-11-20T16:00:45Z | c01-tr | duyu-1 | - | - | - | 8.96 | - | c403418bdefee72a |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:03:47Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 43 | 386cac03153fde75 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:03:49Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 20 | c320148ef027db7c | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:03:51Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 21 | badcb244c13fb02b | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:03:53Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | bedd416378485406 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:03:56Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | 70726734e62a5f56 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:03:58Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 18e8b24970eb6dee | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:03:59Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | 51c6188c8e84827d | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:04:01Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 27 | c170c2c3f7caeeac | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:04:03Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 1aeb69944a0461b6 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:04:05Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 9c07dea6f564145d | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:04:07Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | b7c564134db62fd3 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:04:09Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 21 | ef21bd786680eadc | audio/en/c06-ex1.mp3 |
| 2026-11-27T18:28:32Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.88 | 5f272a07b4d7456daba138bd0d296350 | 330f6eeef8c16f77 |
| 2026-11-27T18:28:33Z | c07-q1-fb | duyu-1 | - | - | - | 2.88 | - | 330f6eeef8c16f77 |
| 2026-11-27T18:28:36Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 64 | 4.96 | c7a72c0b05314225ab2ebbc18cbcaf7f | 8eb8f11c735e65dc |
| 2026-11-27T18:28:37Z | c07-q2-fb | duyu-1 | - | - | - | 4.96 | - | 8eb8f11c735e65dc |
| 2026-11-27T18:28:39Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.92 | e456c021ea97461382a5df6aad05421e | 406d400330a193c0 |
| 2026-11-27T18:28:40Z | c07-q3-fb | duyu-1 | - | - | - | 1.92 | - | 406d400330a193c0 |
| 2026-11-27T18:28:42Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 4.0 | 836132975e9c4bc7bf016910807052e7 | 91613babb31ab176 |
| 2026-11-27T18:28:44Z | c07-q4-fb | duyu-1 | - | - | - | 4.0 | - | 91613babb31ab176 |
| 2026-11-27T19:31:02Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 3.36 | acca75f3488d4f7bb6997f329345a4e2 | 47b05e506fe913d0 |
| 2026-11-27T19:31:04Z | c01-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 47b05e506fe913d0 |
| 2026-11-27T19:31:06Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.6 | ffb9fa485f054e73be85ecded08ad1c9 | e21387ec3f5707a0 |
| 2026-11-27T19:31:07Z | c02-ex1-tl | duyu-1 | - | - | - | 1.6 | - | e21387ec3f5707a0 |
| 2026-11-27T19:31:09Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 3.52 | f3e21a983b0642dfa0c76164e4036a4e | 790630f0b31803fc |
| 2026-11-27T19:31:10Z | c02-ex2-tl | duyu-1 | - | - | - | 3.52 | - | 790630f0b31803fc |
| 2026-11-27T19:31:12Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.92 | 7ef7305cb2724f06a89efbd2927b0ac9 | 3a0ff5dc74259051 |
| 2026-11-27T19:31:13Z | c03-ex1-tl | duyu-1 | - | - | - | 1.92 | - | 3a0ff5dc74259051 |
| 2026-11-27T19:31:16Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 3.68 | 642e574bc4984960922b0722eb161783 | 52bb88d8f641101f |
| 2026-11-27T19:31:17Z | c04-ex1-tl | duyu-1 | - | - | - | 3.68 | - | 52bb88d8f641101f |
| 2026-11-27T19:31:19Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 4.16 | 7b8fb8b696d3417e91a6125911085620 | ec9412797433626c |
| 2026-11-27T19:31:21Z | c04-ex2-tl | duyu-1 | - | - | - | 4.16 | - | ec9412797433626c |
| 2026-11-27T19:31:23Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.72 | e51b3643146d446988474bd806231380 | a6600eed59df34bf |
| 2026-11-27T19:31:24Z | c05-ex1-tl | duyu-1 | - | - | - | 2.72 | - | a6600eed59df34bf |
| 2026-11-27T19:31:26Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.08 | a0f04961bff84f28807d82de617de4fd | 4fae627b1772d5ac |
| 2026-11-27T19:31:27Z | c05-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 4fae627b1772d5ac |
| 2026-11-27T19:31:29Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 3.52 | a4157f6812af44c7af23016cca9636d6 | 14a6e575f6059b5d |
| 2026-11-27T19:31:30Z | c05-ex3-tl | duyu-1 | - | - | - | 3.52 | - | 14a6e575f6059b5d |
| 2026-11-27T19:31:33Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | 9a309eb2b42c40a1a1362ec60aaf87ad | b0a0cc4d2a09b04b |
| 2026-11-27T19:31:34Z | c05-ex4-tl | duyu-1 | - | - | - | 1.6 | - | b0a0cc4d2a09b04b |
| 2026-11-27T19:31:36Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.4 | 7680fd1fba6c4cbc8778ebc4394fc824 | 5f268e5b7bf75056 |
| 2026-11-27T19:31:37Z | c05-ex5-tl | duyu-1 | - | - | - | 2.4 | - | 5f268e5b7bf75056 |
| 2026-11-27T19:31:40Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.72 | cf099648efcb42b79b626651d65e4665 | 7d20dcc2268ac7a9 |
| 2026-11-27T19:31:40Z | c06-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 7d20dcc2268ac7a9 |
