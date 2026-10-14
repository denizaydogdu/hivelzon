# G-A2-06-past-questions-negatives PROMPTS

Ders: did / didn't ile geçmişte soru ve olumsuz · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:09:00Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 8.96 | e08e9e8dbc904dad9d0e37adbd1f14f5 | cd53c0a3a02b087d |
| 2026-10-14T13:09:01Z | c01-tr | duyu-1 | - | - | - | 8.96 | - | cd53c0a3a02b087d |
| 2026-10-14T13:09:03Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 10.43 | ceddb8cd434c4fe6b73aca526b630159 | 9ad521db728c72d5 |
| 2026-10-14T13:09:05Z | c02-tr | duyu-1 | - | - | - | 10.43 | - | 9ad521db728c72d5 |
| 2026-10-14T13:09:07Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 141 | 10.22 | 806453894c364e9b936ca3ac0d1133cb | d984919ef3b94de0 |
| 2026-10-14T13:09:08Z | c03-tr | duyu-1 | - | - | - | 10.22 | - | d984919ef3b94de0 |
| 2026-10-14T13:09:10Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 189 | 12.67 | 2699e67ec32d4807ba3f12d084350827 | 0b8358f5bb3f01dc |
| 2026-10-14T13:09:12Z | c05-tr | duyu-1 | - | - | - | 12.67 | - | 0b8358f5bb3f01dc |
| 2026-10-14T13:09:14Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.64 | 8bc574d5d6c846c49edc99c9575a6fb6 | 0d75670b2a4beeb9 |
| 2026-10-14T13:09:16Z | c07-tr | duyu-1 | - | - | - | 4.64 | - | 0d75670b2a4beeb9 |
| 2026-10-14T13:09:18Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 91 | 5.6 | 2cb4d9ab77b94462b6c94f33dd6d587f | 045280cab932391a |
| 2026-10-14T13:09:19Z | c08-tr | duyu-1 | - | - | - | 5.6 | - | 045280cab932391a |
