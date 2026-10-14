# G-C1-08-ellipsis-substitution PROMPTS

Ders: Eksiltme ve yerine koyma (ellipsis and substitution): So do I, I hope not · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:40:19Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 202 | 13.78 | 232f395e2914473c9faeecf835d5e6b1 | 8001c9d66594637e |
| 2026-10-14T14:40:21Z | c01-tr | duyu-1 | - | - | - | 13.78 | - | 8001c9d66594637e |
| 2026-10-14T14:40:24Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 217 | 14.75 | 91d4ec77ca9c4e4b9e04cb40a626dd58 | 89dca818eb43487b |
| 2026-10-14T14:40:25Z | c02-tr | duyu-1 | - | - | - | 14.75 | - | 89dca818eb43487b |
| 2026-10-14T14:40:29Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 170 | 11.55 | 82808cb44dca42aebc0716798c72c1e5 | 2ab53b1680bd80d6 |
| 2026-10-14T14:40:30Z | c03-tr | duyu-1 | - | - | - | 11.55 | - | 2ab53b1680bd80d6 |
| 2026-10-14T14:40:33Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 240 | 15.39 | 97109b911a2c42c1a9d73a667cf07a82 | 5c589557c37bb5ca |
| 2026-10-14T14:40:34Z | c04-tr | duyu-1 | - | - | - | 15.39 | - | 5c589557c37bb5ca |
| 2026-10-14T14:40:38Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 200 | 14.43 | 3042fd52b5c6415b87e7d5b5a9fcd842 | 4115961c88a64f25 |
| 2026-10-14T14:40:39Z | c06-tr | duyu-1 | - | - | - | 14.43 | - | 4115961c88a64f25 |
| 2026-10-14T14:40:42Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 12.35 | e1008cf9d049434383bb4fdc04173a99 | 4ebc4d5b841b8b3a |
| 2026-10-14T14:40:43Z | c08-tr | duyu-1 | - | - | - | 12.35 | - | 4ebc4d5b841b8b3a |
