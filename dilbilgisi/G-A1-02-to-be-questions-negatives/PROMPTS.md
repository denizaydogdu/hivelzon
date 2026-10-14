# G-A1-02-to-be-questions-negatives PROMPTS

Ders: to be ile soru ve olumsuz · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:04:25Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 97 | 6.56 | d6914eedafc94332a9107ebec4f312ae | c1b58def1a699677 |
| 2026-10-14T13:04:26Z | c01-tr | duyu-1 | - | - | - | 6.56 | - | c1b58def1a699677 |
| 2026-10-14T13:04:28Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 9.92 | 1c89dfcdda3a42018ffe329fd70457ac | 05b5e46714fdca55 |
| 2026-10-14T13:04:30Z | c02-tr | duyu-1 | - | - | - | 9.92 | - | 05b5e46714fdca55 |
| 2026-10-14T13:04:33Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 173 | 13.47 | e3ab8abeaebe401aa3711798f558cade | 7cb2e60e8ad9672b |
| 2026-10-14T13:04:34Z | c03-tr | duyu-1 | - | - | - | 13.47 | - | 7cb2e60e8ad9672b |
| 2026-10-14T13:04:37Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 148 | 9.95 | d10e519620344eb191d8c4282cc7084d | 0a52d302007406ea |
| 2026-10-14T13:04:38Z | c04-tr | duyu-1 | - | - | - | 9.95 | - | 0a52d302007406ea |
| 2026-10-14T13:04:40Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 169 | 11.51 | 830b785565624194afa4d574e3b0f1d8 | 8c9ea8523e4c1a90 |
| 2026-10-14T13:04:42Z | c06-tr | duyu-1 | - | - | - | 11.51 | - | 8c9ea8523e4c1a90 |
| 2026-10-14T13:04:44Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 59 | 4.0 | 66d91e6284a6478b91225f526e1523ff | c52bc4a6691bafb9 |
| 2026-10-14T13:04:45Z | c08-tr | duyu-1 | - | - | - | 4.0 | - | c52bc4a6691bafb9 |
| 2026-10-14T13:04:47Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 134 | 9.76 | 25614aa1d72644fdac38699815db7f6f | 5246a208a948f9c7 |
| 2026-10-14T13:04:48Z | c09-tr | duyu-1 | - | - | - | 9.76 | - | 5246a208a948f9c7 |
