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
