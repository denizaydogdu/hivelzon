# G-C2-05-cohesion-discourse PROMPTS

Ders: Bağdaşıklık ve söylem belirleyicileri (cohesion and discourse markers) · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: önceki dalgaların dersleri (`G-B2-01-passive`, `G-B1-01-present-perfect-experience`, `G-A2-04-past-simple-regular`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, sade ve suçlamasız (C düzeyinde de). İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. C1/C2 kapsaması Octanove listesi depoda olmadığı için denetlenmedi (`grammar_lint.py` uyarısı).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h082.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:42:32Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 8.64 | 67af14ad82084b7cb7a78a7a7d6da2cf | da1a44abdc4e886c |
| 2026-10-14T14:42:33Z | c01-tr | duyu-1 | - | - | - | 8.64 | - | da1a44abdc4e886c |
| 2026-10-14T14:42:36Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 211 | 13.63 | f64ce443aa854f85a4e397bd09af31f0 | 5bcb418bd6428ac1 |
| 2026-10-14T14:42:38Z | c02-tr | duyu-1 | - | - | - | 13.63 | - | 5bcb418bd6428ac1 |
| 2026-10-14T14:42:40Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 212 | 13.47 | a8d2292cd68c4578b2f3815fab586f40 | d33d6d95d758fe9c |
| 2026-10-14T14:42:42Z | c03-tr | duyu-1 | - | - | - | 13.47 | - | d33d6d95d758fe9c |
| 2026-10-14T14:42:45Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 12.99 | 261f637859874cd0a64510f3b1f6bfaf | b78d774a73779b8c |
| 2026-10-14T14:42:46Z | c04-tr | duyu-1 | - | - | - | 12.99 | - | b78d774a73779b8c |
| 2026-10-14T14:42:49Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 225 | 14.94 | eedcf2810a634ec4ab4df3132a4e7564 | 1c7572ec1e731e95 |
| 2026-10-14T14:42:50Z | c06-tr | duyu-1 | - | - | - | 14.94 | - | 1c7572ec1e731e95 |
| 2026-10-14T14:42:53Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 12.13 | b253ded06e0f43099bd2494e35992850 | f0316fe183ce77b5 |
| 2026-10-14T14:42:56Z | c08-tr | duyu-1 | - | - | - | 12.13 | - | f0316fe183ce77b5 |
| 2026-11-20T16:03:21Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 9.63 | 0f6a49084ca3422da6717c209b52639d | 655229b63e58d247 |
| 2026-11-20T16:03:24Z | c01-tr | duyu-1 | - | - | - | 9.63 | - | 655229b63e58d247 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:12:02Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 68 | f3d3dba93c9d3818 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:12:04Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 44 | 2fdfd3a598b66261 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:12:06Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 63 | 8bc7406bb69b23f6 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:12:08Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 57 | d0cb43ebd2e8dc23 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:12:10Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 48 | 7cede9fdad35ff67 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:12:12Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 74 | b001d61866c7cbc8 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:12:14Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 51 | 2a6803d8be77b0d2 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:12:17Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 57 | ffb16961391950ad | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:12:21Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 64 | 7c6154420505a8ed | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:12:23Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 0e05420e3c93b7f4 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:12:25Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 57 | 8db2fc0ca74ca278 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:12:27Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 47 | 3666d0e025121118 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:12:30Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 68 | 1db11e59079066f2 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:12:32Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 69 | fe72978f1cafeaae | audio/en/c07-q5.mp3 |
| 2026-11-26T14:12:34Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 52 | 0656c5878795c8f6 | audio/en/c09-ex1.mp3 |
