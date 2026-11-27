# G-B2-08-present-perfect-continuous PROMPTS

Ders: Present perfect continuous: have been + -ing · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** -ing → ing.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:11:00Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 9.6 | c8e5291ce7ac467fb12b82ce2668d22c | 14b07f13a533437e |
| 2026-10-14T14:11:01Z | c01-tr | duyu-1 | - | - | - | 9.6 | - | 14b07f13a533437e |
| 2026-10-14T14:11:04Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 192 | 13.45 | d87ce58fb71e4ac699562719673ee876 | 47239595f051c04e |
| 2026-10-14T14:11:05Z | c02-tr | duyu-1 | - | - | - | 13.45 | - | 47239595f051c04e |
| 2026-10-14T14:11:08Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.27 | 8218d3a4533c48b08a83267033c5ca87 | babe63d7918df5fa |
| 2026-10-14T14:11:10Z | c03-tr | duyu-1 | - | - | - | 10.27 | - | babe63d7918df5fa |
| 2026-10-14T14:11:13Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 217 | 14.59 | dd051b93569c48ba9e87b6c020b2abda | 9d219861b0ffe15a |
| 2026-10-14T14:11:14Z | c04-tr | duyu-1 | - | - | - | 14.59 | - | 9d219861b0ffe15a |
| 2026-10-14T14:11:17Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 14.11 | e510e3af60ec4b86a82b85d90cb397aa | bf4f065317634a9b |
| 2026-10-14T14:11:19Z | c06-tr | duyu-1 | - | - | - | 14.11 | - | bf4f065317634a9b |
| 2026-10-14T14:11:21Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 10.56 | ed328e3973c84cbbb4393f688205b344 | 155aa161899c2dd8 |
| 2026-10-14T14:11:23Z | c08-tr | duyu-1 | - | - | - | 10.56 | - | 155aa161899c2dd8 |
| 2026-11-20T16:00:49Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 10.27 | 38524111776e4d259b44c64212d1e837 | 453e4c27847e88a2 |
| 2026-11-20T16:00:51Z | c01-tr | duyu-1 | - | - | - | 10.27 | - | 453e4c27847e88a2 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:04:40Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 47 | e58c23815f4f82c5 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:04:42Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | c8f6f0889bb48887 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:04:43Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | ee962c24d11ae331 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:04:45Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | 567bffee959d9a99 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:04:47Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | fa32e924ff568869 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:04:49Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 43 | eee3c6ed2d793eed | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:04:51Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | 67e367fec8304090 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:04:53Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | 4fdc0ade561d6596 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:04:55Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | 669ba1ae00f4e3cc | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:04:56Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | ed120a86895ab1b2 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:04:58Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 926a524947cbb9d4 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:05:00Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 25 | 500e53c241dbbcc5 | audio/en/c06-ex2.mp3 |
