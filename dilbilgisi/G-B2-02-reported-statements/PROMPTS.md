# G-B2-02-reported-statements PROMPTS

Ders: Dolaylı anlatım (1): say, tell ve zaman kaydırma · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:08:10Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 148 | 10.91 | 4e28905f5e7b41c7afde433ab2e25373 | 0e4c720c5d89eb3c |
| 2026-10-14T14:08:11Z | c01-tr | duyu-1 | - | - | - | 10.91 | - | 0e4c720c5d89eb3c |
| 2026-10-14T14:08:14Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 12.35 | d77fca2dd52746748b8a34dc9a73704c | ca3352d2e16e7418 |
| 2026-10-14T14:08:15Z | c02-tr | duyu-1 | - | - | - | 12.35 | - | ca3352d2e16e7418 |
| 2026-10-14T14:08:18Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 197 | 12.66 | cdad26dda2904e8fb9d2cecbdc45f8f2 | 2d798db377d0d3dd |
| 2026-10-14T14:08:19Z | c03-tr | duyu-1 | - | - | - | 12.66 | - | 2d798db377d0d3dd |
| 2026-10-14T14:08:22Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 160 | 11.87 | 6e992b0a457d44758881b91eb2b53aff | 2cca151d7eb98082 |
| 2026-10-14T14:08:23Z | c04-tr | duyu-1 | - | - | - | 11.87 | - | 2cca151d7eb98082 |
| 2026-10-14T14:08:26Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 262 | 16.83 | a5983741e7454eca82cba2c82d43844f | b8cb1e2990b96f11 |
| 2026-10-14T14:08:28Z | c06-tr | duyu-1 | - | - | - | 16.83 | - | b8cb1e2990b96f11 |
| 2026-10-14T14:08:30Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 68 | 4.0 | ef6169f3e3d54356919f0f6046586421 | f1f494453a262d99 |
| 2026-10-14T14:08:31Z | c08-tr | duyu-1 | - | - | - | 4.0 | - | f1f494453a262d99 |
| 2026-10-14T14:08:34Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 124 | 6.88 | e4e1e2b4010f46d88a266f9543a8069c | 711b6d28ba4dc5ae |
| 2026-10-14T14:08:35Z | c09-tr | duyu-1 | - | - | - | 6.88 | - | 711b6d28ba4dc5ae |
