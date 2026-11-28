# G-B1-12-ing-ed-adjectives PROMPTS

Ders: bored mı boring mi? -ed / -ing sıfatları · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ed` → "ed", `-ing` → "ing".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:10:03Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 9.6 | bcbdaf393f594b0fb62bf06f48f6e206 | eda39c8b2acaf53d |
| 2026-10-14T14:10:04Z | c01-tr | duyu-1 | - | - | - | 9.6 | - | eda39c8b2acaf53d |
| 2026-10-14T14:10:06Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 11.71 | 6b53826cd383406ea65790d2c52e7cef | 6f1c74e0eed5e0e0 |
| 2026-10-14T14:10:07Z | c02-tr | duyu-1 | - | - | - | 11.71 | - | 6f1c74e0eed5e0e0 |
| 2026-10-14T14:10:10Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 10.89 | 92fc6dd23c284db68b680f3aedc2beac | 1ce3fe66f7bd30ea |
| 2026-10-14T14:10:12Z | c03-tr | duyu-1 | - | - | - | 10.89 | - | 1ce3fe66f7bd30ea |
| 2026-10-14T14:10:14Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 200 | 13.28 | ac2886fb5fdc4112baa714e8a60a6731 | 79b668aa475c3eb9 |
| 2026-10-14T14:10:16Z | c05-tr | duyu-1 | - | - | - | 13.28 | - | 79b668aa475c3eb9 |
| 2026-10-14T14:10:18Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 63 | 4.32 | b04ff743fd00408daef309f97fa56b65 | 9466536444f7df5f |
| 2026-10-14T14:10:19Z | c07-tr | duyu-1 | - | - | - | 4.32 | - | 9466536444f7df5f |
| 2026-10-14T14:10:21Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 94 | 6.24 | 1682cd51ee36450fbbb3a9a637799f34 | 2831316009e7eeed |
| 2026-10-14T14:10:22Z | c08-tr | duyu-1 | - | - | - | 6.24 | - | 2831316009e7eeed |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:36:56Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 2a506085a50b32cd | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:36:57Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 10 | 3ef57ee78f94b3b3 | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:36:59Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 19 | dd3ce63c18b52810 | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:37:00Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 18 | ad2c5967484cddf2 | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:37:01Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 55d9a4e25f5b990d | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:37:02Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | c1bc67e07c309e65 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:37:04Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 6e6aa55afdd0f219 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:37:05Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | eeb6a4fd7c371bab | audio/en/c04-ex3.mp3 |
| 2026-10-30T13:37:06Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | 4c1877a64dcb9675 | audio/en/c04-ex4.mp3 |
| 2026-10-30T13:37:08Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | c122b9e2f7f880a3 | audio/en/c04-ex5.mp3 |
| 2026-10-30T13:37:09Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | b06b2db64f301257 | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:37:10Z | c08-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 31b4ded8f028ed4b | audio/en/c08-ex1.mp3 |
| 2026-11-27T18:26:37Z | c06-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.56 | 31a05a7ab82a41e6b352ca6725b72db9 | 0ce6d13e27b3fd93 |
| 2026-11-27T18:26:38Z | c06-q1-fb | duyu-1 | - | - | - | 2.56 | - | 0ce6d13e27b3fd93 |
| 2026-11-27T18:26:40Z | c06-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.88 | 19cade95c4fc41d088b716771036b0fa | cb81bb367549ec33 |
| 2026-11-27T18:26:41Z | c06-q2-fb | duyu-1 | - | - | - | 2.88 | - | cb81bb367549ec33 |
| 2026-11-27T18:26:44Z | c06-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 3.68 | 93111b7b98cc44bca0b19dc6a50c3089 | 7e2068bcc162e87d |
| 2026-11-27T18:26:45Z | c06-q3-fb | duyu-1 | - | - | - | 3.68 | - | 7e2068bcc162e87d |
| 2026-11-27T18:26:47Z | c06-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.4 | 4f6e0da700784630a71eb005b0144511 | e04542c8eee991eb |
| 2026-11-27T18:26:48Z | c06-q4-fb | duyu-1 | - | - | - | 2.4 | - | e04542c8eee991eb |
| 2026-11-27T19:25:26Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 4.32 | 20b949ff791c44a382fb9e836c49a70a | ea7caa6c5720ae55 |
| 2026-11-27T19:25:27Z | c01-ex1-tl | duyu-1 | - | - | - | 4.32 | - | ea7caa6c5720ae55 |
| 2026-11-27T19:25:29Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.76 | 8f0284c941b14fe48648e80976a0e8c1 | 86ec414261159a20 |
| 2026-11-27T19:25:30Z | c02-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 86ec414261159a20 |
| 2026-11-27T19:25:32Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | 2c91fc58f4a647b8ba4ec4060775f4f0 | 120fcb2b46a7d553 |
| 2026-11-27T19:25:33Z | c02-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 120fcb2b46a7d553 |
| 2026-11-27T19:25:35Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | e3a35302a3954f31b337ea774708cc12 | 46a1375fb8a8b0f0 |
| 2026-11-27T19:25:36Z | c03-ex1-tl | duyu-1 | - | - | - | 1.28 | - | 46a1375fb8a8b0f0 |
| 2026-11-27T19:25:38Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.6 | a7907be3db7c477e8ed3f878860a6c3d | 927ced711bdd87b0 |
| 2026-11-27T19:25:39Z | c03-ex2-tl | duyu-1 | - | - | - | 1.6 | - | 927ced711bdd87b0 |
| 2026-11-27T19:25:41Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.56 | f0c7ba0130b1493fbb2ee278ffcc3d47 | 4c98cc17e55f3b15 |
| 2026-11-27T19:25:42Z | c04-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 4c98cc17e55f3b15 |
| 2026-11-27T19:25:44Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.44 | 3c3e79b4c82046229f42a0f336ce8404 | 91120776eaf18962 |
| 2026-11-27T19:25:45Z | c04-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 91120776eaf18962 |
| 2026-11-27T19:25:47Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | dd6b7c0fb41f48ff874dc218d362f96e | f95d48168b9e97ea |
| 2026-11-27T19:25:48Z | c04-ex3-tl | duyu-1 | - | - | - | 1.6 | - | f95d48168b9e97ea |
| 2026-11-27T19:25:50Z | c04-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.24 | 81003b657b214f8da851f626e6a1b49f | 2a4516f293a1b843 |
| 2026-11-27T19:25:51Z | c04-ex4-tl | duyu-1 | - | - | - | 2.24 | - | 2a4516f293a1b843 |
| 2026-11-27T19:25:53Z | c04-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | 417529176bc1430eadf6420f4119d665 | eccc0ff99501dc2e |
| 2026-11-27T19:25:54Z | c04-ex5-tl | duyu-1 | - | - | - | 1.92 | - | eccc0ff99501dc2e |
| 2026-11-27T19:25:56Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.6 | 2cbf828909f44a4ca7d4ae97ccea17f3 | 50096eb1bce60521 |
| 2026-11-27T19:25:57Z | c05-ex2-tl | duyu-1 | - | - | - | 1.6 | - | 50096eb1bce60521 |
| 2026-11-27T19:25:59Z | c08-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.72 | d2d339490eed413f9c12712f392d133b | b51a11d6b7780fda |
| 2026-11-27T19:26:00Z | c08-ex1-tl | duyu-1 | - | - | - | 2.72 | - | b51a11d6b7780fda |
