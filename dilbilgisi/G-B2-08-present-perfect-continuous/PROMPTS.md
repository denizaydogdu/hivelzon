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
