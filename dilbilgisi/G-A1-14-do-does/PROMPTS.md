# G-A1-14-do-does PROMPTS

Ders: do / does ile soru ve olumsuz · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:08:47Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 161 | 10.59 | 5d0e301452234b9b8461b057242c62ef | 6bc7c968e351329e |
| 2026-10-14T13:08:48Z | c01-tr | duyu-1 | - | - | - | 10.59 | - | 6bc7c968e351329e |
| 2026-10-14T13:08:51Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 162 | 10.9 | 5081672fc60f4fc8ba2a681640d64da6 | eaf07a57e686325e |
| 2026-10-14T13:08:52Z | c02-tr | duyu-1 | - | - | - | 10.9 | - | eaf07a57e686325e |
| 2026-10-14T13:08:55Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 100 | 8.96 | f726fbe3f17747b0bd8631035784cfe4 | f662041c7f00fbc5 |
| 2026-10-14T13:08:56Z | c03-tr | duyu-1 | - | - | - | 8.96 | - | f662041c7f00fbc5 |
| 2026-10-14T13:08:59Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 10.41 | 26fe5dd628ce45b29d4b0545cff53246 | 78624ad84df85060 |
| 2026-10-14T13:09:00Z | c04-tr | duyu-1 | - | - | - | 10.41 | - | 78624ad84df85060 |
| 2026-10-14T13:09:02Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 187 | 12.19 | 26cb944c9e7a4b8dbbad96c34c2f4b12 | cd506dcabbe1a2a2 |
| 2026-10-14T13:09:04Z | c06-tr | duyu-1 | - | - | - | 12.19 | - | cd506dcabbe1a2a2 |
| 2026-10-14T13:09:06Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 82 | 5.28 | d94dc009e1f34183928b3242800eaf45 | a46a0d9fb09d4f8e |
| 2026-10-14T13:09:07Z | c08-tr | duyu-1 | - | - | - | 5.28 | - | a46a0d9fb09d4f8e |
| 2026-10-14T13:09:09Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 109 | 7.2 | 27b4631bbc95415197f06037014e575d | 21212b94295aa299 |
| 2026-10-14T13:09:10Z | c09-tr | duyu-1 | - | - | - | 7.2 | - | 21212b94295aa299 |
