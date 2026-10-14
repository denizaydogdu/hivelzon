# G-C1-04-participle-clauses PROMPTS

Ders: Ortaç yan cümleleri (participle clauses): Having finished…, Walking home… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: önceki dalgaların dersleri (`G-B2-01-passive`, `G-B1-01-present-perfect-experience`, `G-A2-04-past-simple-regular`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, sade ve suçlamasız (C düzeyinde de). İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. C1/C2 kapsaması Octanove listesi depoda olmadığı için denetlenmedi (`grammar_lint.py` uyarısı).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ing` → "ing" (Alania söyleniş sözlüğü, `lesson.json`).

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h082.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:38:34Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 129 | 8.64 | fcbacb79e1af41c595e5beaeddd51087 | 8c2d410575541691 |
| 2026-10-14T14:38:35Z | c01-tr | duyu-1 | - | - | - | 8.64 | - | 8c2d410575541691 |
| 2026-10-14T14:38:38Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 204 | 13.43 | 9ff3da41190d458e9acc194c36b2b229 | 3b1b46268227f401 |
| 2026-10-14T14:38:40Z | c02-tr | duyu-1 | - | - | - | 13.43 | - | 3b1b46268227f401 |
| 2026-10-14T14:38:43Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 172 | 12.16 | 76f8fb8a04394f4bb08e760a110e30ca | 09f9489c5ed9e867 |
| 2026-10-14T14:38:44Z | c03-tr | duyu-1 | - | - | - | 12.16 | - | 09f9489c5ed9e867 |
| 2026-10-14T14:38:47Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 185 | 11.69 | 0abafe2109964ce384ea8c370249f4fd | 5cc260e6902abdd1 |
| 2026-10-14T14:38:49Z | c04-tr | duyu-1 | - | - | - | 11.69 | - | 5cc260e6902abdd1 |
| 2026-10-14T14:38:52Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 221 | 15.32 | b1af9b7d0be742a79044f0e01c9d189a | 5b2e5d7ece16b563 |
| 2026-10-14T14:38:54Z | c06-tr | duyu-1 | - | - | - | 15.32 | - | 5b2e5d7ece16b563 |
| 2026-10-14T14:38:57Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 185 | 13.31 | 8aac8ed0524d453b86a55403e6772a92 | a3a6ba442fb8a960 |
| 2026-10-14T14:38:58Z | c08-tr | duyu-1 | - | - | - | 13.31 | - | a3a6ba442fb8a960 |
