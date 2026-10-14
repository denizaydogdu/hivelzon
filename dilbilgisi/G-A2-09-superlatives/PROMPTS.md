# G-A2-09-superlatives PROMPTS

Ders: En üstünlük: the -est / the most · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-est` → "est".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:10:07Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 141 | 8.8 | c269cf2188ad4e07b865da706e6a64ea | f8d84665a12a7973 |
| 2026-10-14T13:10:08Z | c01-tr | duyu-1 | - | - | - | 8.8 | - | f8d84665a12a7973 |
| 2026-10-14T13:10:11Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 10.38 | d6e167690abc49849c8b351dce8d4103 | 4a774aae601c10cf |
| 2026-10-14T13:10:12Z | c02-tr | duyu-1 | - | - | - | 10.38 | - | 4a774aae601c10cf |
| 2026-10-14T13:10:15Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 9.6 | aba2cfe8ccc84c38995e7256af8fe550 | 36f6869478cea8ce |
| 2026-10-14T13:10:17Z | c03-tr | duyu-1 | - | - | - | 9.6 | - | 36f6869478cea8ce |
| 2026-10-14T13:10:20Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 212 | 15.27 | f81f0bd387334ce39da3af301249839b | 91bd2f47022c353b |
| 2026-10-14T13:10:21Z | c04-tr | duyu-1 | - | - | - | 15.27 | - | 91bd2f47022c353b |
| 2026-10-14T13:10:25Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 178 | 11.7 | b84c704d7051401f8cd10585995e63c8 | 4fc9cae5f8a67e24 |
| 2026-10-14T13:10:26Z | c06-tr | duyu-1 | - | - | - | 11.7 | - | 4fc9cae5f8a67e24 |
| 2026-10-14T13:10:28Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 89 | 5.12 | 1560eb82e91f4853bd368e4d4cee3a33 | 3628c563b296e582 |
| 2026-10-14T13:10:29Z | c08-tr | duyu-1 | - | - | - | 5.12 | - | 3628c563b296e582 |
| 2026-10-14T13:10:31Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 112 | 8.16 | 277c0f5cd96e4e24b6638b2299f1b9fe | 97693dca1073a6ea |
| 2026-10-14T13:10:33Z | c09-tr | duyu-1 | - | - | - | 8.16 | - | 97693dca1073a6ea |
