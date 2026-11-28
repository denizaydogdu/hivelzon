# G-B2-09-non-defining-relatives PROMPTS

Ders: Tanımlamayan sıfat cümlecikleri: virgüllü who, which, whose · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:11:26Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 11.71 | a8d015d350144c7494400c2f1891d978 | 019bb3bdf720a257 |
| 2026-10-14T14:11:27Z | c01-tr | duyu-1 | - | - | - | 11.71 | - | 019bb3bdf720a257 |
| 2026-10-14T14:11:30Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 196 | 12.51 | a6ac3aa8e0964ba6802edaa53431ea99 | 5c182e3b1ef66235 |
| 2026-10-14T14:11:31Z | c02-tr | duyu-1 | - | - | - | 12.51 | - | 5c182e3b1ef66235 |
| 2026-10-14T14:11:34Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 175 | 11.55 | 7dc454359ad8441aa87f91f0ec4de2da | 7a3d34fc4276739d |
| 2026-10-14T14:11:36Z | c03-tr | duyu-1 | - | - | - | 11.55 | - | 7a3d34fc4276739d |
| 2026-10-14T14:11:38Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 175 | 11.23 | 88a4e8162cde45d99cebc29b7ae4fa6e | 22e4221887450d4f |
| 2026-10-14T14:11:40Z | c04-tr | duyu-1 | - | - | - | 11.23 | - | 22e4221887450d4f |
| 2026-10-14T14:11:42Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 220 | 16.37 | 47b1db5f9f394284844a542b42bec75f | cf9dd4f59ee911b5 |
| 2026-10-14T14:11:44Z | c06-tr | duyu-1 | - | - | - | 16.37 | - | cf9dd4f59ee911b5 |
| 2026-10-14T14:11:47Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 145 | 10.65 | 4cd2ae85d0aa4c98b70f67cfe4d9624c | c5c471a4a0b671c5 |
| 2026-10-14T14:11:48Z | c08-tr | duyu-1 | - | - | - | 10.65 | - | c5c471a4a0b671c5 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:05:02Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 64 | fe885d6eaf0b6624 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:05:04Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 50fd168434947439 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:05:07Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 56 | 48007749061c0226 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:05:09Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 44ab144fc00c5996 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:05:12Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 46 | 5c3b976ec52c87d1 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:05:15Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 4897816e80d97954 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:05:17Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 34 | e8f636c546f569ef | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:05:20Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 73 | 7b6e013f0c661356 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:05:22Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 53 | 8038a189b26e5f3e | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:05:24Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 54 | 10fb92f76d18070f | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:05:26Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 0e20e6ca8e8bb00e | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:05:28Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | c59d8ce51033615e | audio/en/c06-ex1.mp3 |
| 2026-11-26T21:00:28Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 64 | fe885d6eaf0b6624 | audio/en/c01-ex1.mp3 |
| 2026-11-27T18:29:15Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 3.84 | f99a37363e2848839115812766511aeb | 1f9432b8becec1ad |
| 2026-11-27T18:29:16Z | c07-q1-fb | duyu-1 | - | - | - | 3.84 | - | 1f9432b8becec1ad |
| 2026-11-27T18:29:18Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 4.0 | 26704022d84c4c01b0e978898aa5d4b6 | 354498fc60caea0d |
| 2026-11-27T18:29:19Z | c07-q2-fb | duyu-1 | - | - | - | 4.0 | - | 354498fc60caea0d |
| 2026-11-27T18:29:21Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.08 | f6a599bebaf04b8b94441bcfebe4d7f8 | aded11f36b60f297 |
| 2026-11-27T18:29:23Z | c07-q3-fb | duyu-1 | - | - | - | 2.08 | - | aded11f36b60f297 |
| 2026-11-27T18:29:25Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 56 | 3.36 | 13e9fbaef35d407f8788e220ff43654c | 46335cc146eb8b2a |
| 2026-11-27T18:29:26Z | c07-q4-fb | duyu-1 | - | - | - | 3.36 | - | 46335cc146eb8b2a |
| 2026-11-27T19:33:05Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 69 | 5.76 | df6248f301494bdf81bb67033db074a9 | 40b71a63c7f67580 |
| 2026-11-27T19:33:06Z | c01-ex1-tl | duyu-1 | - | - | - | 5.76 | - | 40b71a63c7f67580 |
| 2026-11-27T19:33:09Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.24 | ebd85dc1fecf4848a83aca772dc1da5f | a82ee170a1659d58 |
| 2026-11-27T19:33:10Z | c02-ex1-tl | duyu-1 | - | - | - | 2.24 | - | a82ee170a1659d58 |
| 2026-11-27T19:33:12Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 2.72 | c269fc2c1ff1455994a836813ef0eb9a | 425d57187a8b214e |
| 2026-11-27T19:33:13Z | c02-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 425d57187a8b214e |
| 2026-11-27T19:33:15Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 64 | 3.84 | 7b5835528e744723adafb0c373c56d92 | d9cfa97e71f2805a |
| 2026-11-27T19:33:16Z | c03-ex1-tl | duyu-1 | - | - | - | 3.84 | - | d9cfa97e71f2805a |
| 2026-11-27T19:33:19Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 56 | 3.84 | 831a4041ad2049c6bc9397abd936944e | c5ca989af40ea45a |
| 2026-11-27T19:33:20Z | c03-ex2-tl | duyu-1 | - | - | - | 3.84 | - | c5ca989af40ea45a |
| 2026-11-27T19:33:22Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 2.56 | 68c90a99ad504aad9572af30d413c35d | 36c0aba26e5d8e3d |
| 2026-11-27T19:33:23Z | c04-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 36c0aba26e5d8e3d |
| 2026-11-27T19:33:25Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 3.36 | 3a46b1263fe54ffbbc91fdb43dd0231a | c9a8615e00d795b0 |
| 2026-11-27T19:33:26Z | c04-ex2-tl | duyu-1 | - | - | - | 3.36 | - | c9a8615e00d795b0 |
| 2026-11-27T19:33:28Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 3.36 | 9577053368d341568f7d68e550c6d162 | 297fb431e6e88907 |
| 2026-11-27T19:33:29Z | c05-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 297fb431e6e88907 |
| 2026-11-27T19:33:32Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 3.2 | cefdc0bc376b42c8af28a5101dd55f05 | 698268f03330901d |
| 2026-11-27T19:33:33Z | c05-ex2-tl | duyu-1 | - | - | - | 3.2 | - | 698268f03330901d |
| 2026-11-27T19:33:35Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 3.2 | 8ba90ab5cf7d41b6b40872855e6a6533 | f0bddc7c2c9f0b6d |
| 2026-11-27T19:33:36Z | c05-ex3-tl | duyu-1 | - | - | - | 3.2 | - | f0bddc7c2c9f0b6d |
| 2026-11-27T19:33:38Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 2.88 | ac417416936a430087ae553dc47dea40 | ff8eb45d7e950e5f |
| 2026-11-27T19:33:39Z | c05-ex4-tl | duyu-1 | - | - | - | 2.88 | - | ff8eb45d7e950e5f |
| 2026-11-27T19:33:41Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.4 | 10a93599aefc477ebf563c40852ff30a | a1cec3e1e3a64180 |
| 2026-11-27T19:33:43Z | c06-ex1-tl | duyu-1 | - | - | - | 2.4 | - | a1cec3e1e3a64180 |
