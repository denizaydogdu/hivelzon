# G-A1-09-prepositions-place PROMPTS

Ders: Yer edatları: in / on / under / near / between / behind · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Örnek alınan pilot dersler: G-A1-01-to-be, G-A1-03-a-an, G-A1-13-third-person-s (H-079, onaylı). Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş sözlüğü:** `Alex` → "Aleks".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın defteri ayrı tutuldu: `kitaplar/_maliyet/patientdesk-h080a.json` (birleştirme çakışmasını önlemek için; ana deftere ana oturum işler). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:07:04Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 119 | 7.36 | 67df2522238f4b80bc6fa43489eda00a | 1988e77a7014b1c3 |
| 2026-10-14T13:07:05Z | c01-tr | duyu-1 | - | - | - | 7.36 | - | 1988e77a7014b1c3 |
| 2026-10-14T13:07:08Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 10.75 | 0af0e41fbb8b48a1a63dc3a0342f3b76 | 744fa0abab8a68f5 |
| 2026-10-14T13:07:09Z | c02-tr | duyu-1 | - | - | - | 10.75 | - | 744fa0abab8a68f5 |
| 2026-10-14T13:07:12Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 12.73 | 8bdfb569642840e3bdcdc574e558d022 | 33d8ed09c3e419b5 |
| 2026-10-14T13:07:14Z | c03-tr | duyu-1 | - | - | - | 12.73 | - | 33d8ed09c3e419b5 |
| 2026-10-14T13:07:17Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 183 | 12.19 | 328c5c7c42a947d6bc298fa59f619bcc | a7ba327205f3394e |
| 2026-10-14T13:07:18Z | c04-tr | duyu-1 | - | - | - | 12.19 | - | a7ba327205f3394e |
| 2026-10-14T13:07:21Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 155 | 9.63 | 07b649c14ca3458d8d5baaa34f977923 | 8653c3a099d1e10f |
| 2026-10-14T13:07:22Z | c06-tr | duyu-1 | - | - | - | 9.63 | - | 8653c3a099d1e10f |
| 2026-10-14T13:07:24Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 77 | 4.96 | 6561974fbcfc422daf1ba9eb17542c98 | 8a23b0458a2fb518 |
| 2026-10-14T13:07:25Z | c08-tr | duyu-1 | - | - | - | 4.96 | - | 8a23b0458a2fb518 |
| 2026-10-14T13:07:27Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 103 | 7.84 | b5e9ff54c5d74e52a5ee2832b31e9837 | e62409ee41e8c60a |
| 2026-10-14T13:07:28Z | c09-tr | duyu-1 | - | - | - | 7.84 | - | e62409ee41e8c60a |
