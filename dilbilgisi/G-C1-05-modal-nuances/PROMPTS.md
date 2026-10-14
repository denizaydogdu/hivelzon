# G-C1-05-modal-nuances PROMPTS

Ders: Modal incelikleri: needn't have, be supposed to, would rather · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:39:01Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 117 | 8.16 | 4b51855fc9a242c3ba6ae10fa8e8f3ad | bcd0d3093877244a |
| 2026-10-14T14:39:03Z | c01-tr | duyu-1 | - | - | - | 8.16 | - | bcd0d3093877244a |
| 2026-10-14T14:39:05Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 203 | 15.74 | 729d0654d1d24e6e9bbf211a21e53209 | fd3aac56b5d47ce5 |
| 2026-10-14T14:39:07Z | c02-tr | duyu-1 | - | - | - | 15.74 | - | fd3aac56b5d47ce5 |
| 2026-10-14T14:39:10Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 10.75 | 1d7432f02aa746a5b68fd32d490eebe3 | 1ecde98aef7b8704 |
| 2026-10-14T14:39:12Z | c03-tr | duyu-1 | - | - | - | 10.75 | - | 1ecde98aef7b8704 |
| 2026-10-14T14:39:15Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 188 | 13.12 | aa6c599e5bca4fa2b655c1ca0ece31e4 | bcd0a40edced7bd2 |
| 2026-10-14T14:39:16Z | c04-tr | duyu-1 | - | - | - | 13.12 | - | bcd0a40edced7bd2 |
| 2026-10-14T14:39:19Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 195 | 12.02 | 2cd21c8f6b644c288bee9dc5db7405ec | c31238819cac4b6d |
| 2026-10-14T14:39:20Z | c06-tr | duyu-1 | - | - | - | 12.02 | - | c31238819cac4b6d |
| 2026-10-14T14:39:23Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 201 | 13.28 | b37c408c8f1b4a72bdc491c36621c916 | 8a9ce12fa86b0230 |
| 2026-10-14T14:39:24Z | c08-tr | duyu-1 | - | - | - | 13.28 | - | 8a9ce12fa86b0230 |
