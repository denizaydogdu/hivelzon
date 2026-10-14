# G-C2-01-fronting PROMPTS

Ders: Öne alma ve bilgi yapısı (fronting): Little did she know…, Such was… · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:40:46Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 173 | 11.39 | 1c8968f4e6e4467b8400a2147863cb24 | 6ee78bef475f5be0 |
| 2026-10-14T14:40:47Z | c01-tr | duyu-1 | - | - | - | 11.39 | - | 6ee78bef475f5be0 |
| 2026-10-14T14:40:50Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 220 | 13.61 | 5fb52ecc400d47128ddad5b52ea7e2ec | 9240f65a583e24fc |
| 2026-10-14T14:40:51Z | c02-tr | duyu-1 | - | - | - | 13.61 | - | 9240f65a583e24fc |
| 2026-10-14T14:40:54Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 197 | 13.3 | 64643ae75b6447ad81d399ce70399db6 | f4e89c67d9067a5b |
| 2026-10-14T14:40:56Z | c03-tr | duyu-1 | - | - | - | 13.3 | - | f4e89c67d9067a5b |
| 2026-10-14T14:40:59Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 228 | 16.74 | 310dc0219067451e82ba86c86c6378b7 | 8768363dd895e472 |
| 2026-10-14T14:41:00Z | c04-tr | duyu-1 | - | - | - | 16.74 | - | 8768363dd895e472 |
| 2026-10-14T14:41:04Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 235 | 16.48 | 0a36f6cbbfdc412d8d33ee2ffc7a3d67 | 1c4d527f785f2652 |
| 2026-10-14T14:41:05Z | c06-tr | duyu-1 | - | - | - | 16.48 | - | 1c4d527f785f2652 |
| 2026-10-14T14:41:08Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 194 | 12.98 | 9896616ef69c4f23880b4603eae5fa59 | 320c8e9e147f0a0a |
| 2026-10-14T14:41:09Z | c08-tr | duyu-1 | - | - | - | 12.98 | - | 320c8e9e147f0a0a |
