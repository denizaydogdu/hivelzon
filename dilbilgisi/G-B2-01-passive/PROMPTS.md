# G-B2-01-passive PROMPTS

Ders: Edilgen yapı (passive): be + V3 · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:07:43Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 10.24 | 5f3ae0e6daab455f80b0f457a5057f73 | 0f677022dd19ab18 |
| 2026-10-14T14:07:44Z | c01-tr | duyu-1 | - | - | - | 10.24 | - | 0f677022dd19ab18 |
| 2026-10-14T14:07:47Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 11.96 | ce4e82c6e9b54fcba6189af703e6d0d0 | 4fa30d60264c024c |
| 2026-10-14T14:07:48Z | c02-tr | duyu-1 | - | - | - | 11.96 | - | 4fa30d60264c024c |
| 2026-10-14T14:07:51Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 139 | 8.96 | 21001fc3eec240bc83e54e25c45b6107 | da2987edcbf91cbb |
| 2026-10-14T14:07:52Z | c03-tr | duyu-1 | - | - | - | 8.96 | - | da2987edcbf91cbb |
| 2026-10-14T14:07:55Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 201 | 13.79 | 86e5103d0b0840ef9714960ca23ccd68 | 3c32853669f0efa3 |
| 2026-10-14T14:07:56Z | c04-tr | duyu-1 | - | - | - | 13.79 | - | 3c32853669f0efa3 |
| 2026-10-14T14:07:59Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 280 | 19.25 | db7e2bbe3e6749e5a113c6c780bbf5f2 | 3427860794bf16f9 |
| 2026-10-14T14:08:00Z | c06-tr | duyu-1 | - | - | - | 19.25 | - | 3427860794bf16f9 |
| 2026-10-14T14:08:03Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 68 | 3.84 | afb4331a6a8940e3a61c9d594863c8a7 | 75df77f465746223 |
| 2026-10-14T14:08:04Z | c08-tr | duyu-1 | - | - | - | 3.84 | - | 75df77f465746223 |
| 2026-10-14T14:08:06Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 139 | 8.8 | 0faeae90ab5a4abb80a1212a3957d4dc | 72bc07870ca63d04 |
| 2026-10-14T14:08:07Z | c09-tr | duyu-1 | - | - | - | 8.8 | - | 72bc07870ca63d04 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:01:41Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 25 | 8b33df7df6217c3e | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:01:42Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | a8bd37644b759e14 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:01:44Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | 614135ec7a4af6ab | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:01:46Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | f21405c93845a596 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:01:47Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | f870af4856cd5f9f | audio/en/c03-ex3.mp3 |
| 2026-11-26T14:01:49Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | a87be233400d2a24 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:01:51Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 9e505983d3fe07aa | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:01:52Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | b15ff9512c1a2c5f | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:01:54Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | 0393dd8c7e15b3a6 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:01:56Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | 934714943b22b497 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:01:58Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | 99480d75be3a4209 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:02:00Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 19 | 34677f240258ed73 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:02:02Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | fda06093122bff23 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:02:03Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 21 | aafe277bee60d478 | audio/en/c06-ex3.mp3 |
| 2026-11-26T14:02:04Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 20 | 392f42b6dfef3f66 | audio/en/c07-q5.mp3 |
