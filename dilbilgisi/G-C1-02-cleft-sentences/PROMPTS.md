# G-C1-02-cleft-sentences PROMPTS

Ders: Vurgulu yapılar (cleft sentences): It was… that…, What I need is… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:37:43Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 155 | 11.22 | 96552ea7cd1a4c66919f80de79525ea1 | 916ce8f964652533 |
| 2026-10-14T14:37:44Z | c01-tr | duyu-1 | - | - | - | 11.22 | - | 916ce8f964652533 |
| 2026-10-14T14:37:47Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 194 | 12.49 | a1dc758dba6c433f88b3593cdd4a00a1 | d5951c7c8285a2b7 |
| 2026-10-14T14:37:48Z | c02-tr | duyu-1 | - | - | - | 12.49 | - | d5951c7c8285a2b7 |
| 2026-10-14T14:37:51Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 245 | 16.38 | 984b1ea43bb840819326d4438c46ad0d | 13e0e0b06f784448 |
| 2026-10-14T14:37:53Z | c03-tr | duyu-1 | - | - | - | 16.38 | - | 13e0e0b06f784448 |
| 2026-10-14T14:37:56Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 181 | 11.55 | 1d01ac7fbe624f8ab6f77fcca5631bb2 | 63ff7439256b0ad8 |
| 2026-10-14T14:37:57Z | c04-tr | duyu-1 | - | - | - | 11.55 | - | 63ff7439256b0ad8 |
| 2026-10-14T14:38:00Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 228 | 14.75 | 683434b98007434c90c7237574fe3a4c | 4f195d8194090aa5 |
| 2026-10-14T14:38:02Z | c06-tr | duyu-1 | - | - | - | 14.75 | - | 4f195d8194090aa5 |
| 2026-10-14T14:38:05Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 132 | 8.16 | 03dda4db426048639b59af382e045372 | 0ab616b3890f3634 |
| 2026-10-14T14:38:06Z | c08-tr | duyu-1 | - | - | - | 8.16 | - | 0ab616b3890f3634 |
