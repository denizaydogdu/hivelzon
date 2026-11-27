# G-C2-06-aspect-nuance PROMPTS

Ders: Görünüş incelikleri (aspect): She's being rude, I was wondering… · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:42:58Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 8.64 | 418bd8d860ed4fcd97e41770cc612774 | 4c51a54254d923a2 |
| 2026-10-14T14:42:59Z | c01-tr | duyu-1 | - | - | - | 8.64 | - | 4c51a54254d923a2 |
| 2026-10-14T14:43:02Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 225 | 13.82 | fd1a7b1b06b84d868388d26e4e1494fe | cba626fcd914cf9b |
| 2026-10-14T14:43:03Z | c02-tr | duyu-1 | - | - | - | 13.82 | - | cba626fcd914cf9b |
| 2026-10-14T14:43:07Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 197 | 12.83 | e88722c912f74eb8adb2e7fb8e9a35bc | 5b0b3cdb9102aa30 |
| 2026-10-14T14:43:08Z | c03-tr | duyu-1 | - | - | - | 12.83 | - | 5b0b3cdb9102aa30 |
| 2026-10-14T14:43:11Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 178 | 11.68 | 5b5c18c3c3ae4734a2cd6c2e4d26db6f | b0c6d65d704bd646 |
| 2026-10-14T14:43:12Z | c04-tr | duyu-1 | - | - | - | 11.68 | - | b0c6d65d704bd646 |
| 2026-10-14T14:43:15Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 163 | 10.43 | a00d85a377f644b594b2612c9c6d14b6 | 02162aa39d2900ea |
| 2026-10-14T14:43:17Z | c06-tr | duyu-1 | - | - | - | 10.43 | - | 02162aa39d2900ea |
| 2026-10-14T14:43:20Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 146 | 9.63 | 0cb79110bb9a485ba88ed1295c9cce31 | 0c4abb5e409895c8 |
| 2026-10-14T14:43:21Z | c08-tr | duyu-1 | - | - | - | 9.63 | - | 0c4abb5e409895c8 |
| 2026-11-20T16:03:30Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 10.43 | 84b8917a68c7497c969df49833a0d937 | 621ba9faf36d7f4d |
| 2026-11-20T16:03:34Z | c01-tr | duyu-1 | - | - | - | 10.43 | - | 621ba9faf36d7f4d |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:12:36Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 30 | 1f412f1e8212ee3a | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:12:37Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 11 | cef01b5e4fab5f92 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:12:39Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 17 | e74684e925107122 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:12:40Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 21 | 00d12b86aa3e3a8d | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:12:41Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 310ac73baf9c7038 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:12:43Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 066f5a4f7eee33a3 | audio/en/c03-ex3.mp3 |
| 2026-11-26T14:12:44Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 37 | 97f5f0be61e09a26 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:12:45Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 27 | 942158c5b6fcede2 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:12:47Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 29 | c021e8753689ef28 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:12:48Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 33 | 01b5030049250e69 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:12:50Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 41 | c7e3175050d7e53e | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:12:51Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | c58edf9873806f60 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:12:53Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 40 | 082cca18838135e3 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:12:54Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 46 | ad5d1c70fed5a750 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:12:55Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 23 | 0686e35bb5f5328e | audio/en/c06-ex2.mp3 |
