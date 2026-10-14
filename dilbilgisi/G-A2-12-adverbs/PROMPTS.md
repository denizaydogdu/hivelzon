# G-A2-12-adverbs PROMPTS

Ders: Zarflar: always / usually / never ve -ly · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ly` → "li".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:11:21Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 130 | 8.32 | 65ce9cd2b1cf46dca098a9e534b44fff | 7bcd17e900ea3332 |
| 2026-10-14T13:11:22Z | c01-tr | duyu-1 | - | - | - | 8.32 | - | 7bcd17e900ea3332 |
| 2026-10-14T13:11:24Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 10.43 | ce81fb46c26a47e3a80912c56f8bae9d | f5c095b99d532ef7 |
| 2026-10-14T13:11:26Z | c02-tr | duyu-1 | - | - | - | 10.43 | - | f5c095b99d532ef7 |
| 2026-10-14T13:11:28Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 187 | 12.35 | a8bea785a8cb4cee9628b59615d9ba80 | a58891a2f3fff7ec |
| 2026-10-14T13:11:30Z | c03-tr | duyu-1 | - | - | - | 12.35 | - | a58891a2f3fff7ec |
| 2026-10-14T13:11:32Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 169 | 11.71 | 5e1c3cbd24ef4a11b8b29f1a913375d6 | c0cebce6e714738c |
| 2026-10-14T13:11:34Z | c04-tr | duyu-1 | - | - | - | 11.71 | - | c0cebce6e714738c |
| 2026-10-14T13:11:36Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 223 | 16.34 | 8f4274e2b5204270b813dc060831b1a9 | f24c0e935edb75a9 |
| 2026-10-14T13:11:38Z | c06-tr | duyu-1 | - | - | - | 16.34 | - | f24c0e935edb75a9 |
| 2026-10-14T13:11:40Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.16 | aa6705a5a4084f3aac9d99db9144f0b2 | ab65d6764c5129b3 |
| 2026-10-14T13:11:41Z | c08-tr | duyu-1 | - | - | - | 4.16 | - | ab65d6764c5129b3 |
| 2026-10-14T13:11:43Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 123 | 7.68 | 63af2ed12a8f43758f23e61555db2210 | 0931b2ffbb264e51 |
| 2026-10-14T13:11:44Z | c09-tr | duyu-1 | - | - | - | 7.68 | - | 0931b2ffbb264e51 |
