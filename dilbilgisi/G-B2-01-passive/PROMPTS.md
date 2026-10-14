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
