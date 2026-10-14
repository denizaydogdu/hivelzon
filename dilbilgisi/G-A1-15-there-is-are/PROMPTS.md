# G-A1-15-there-is-are PROMPTS

Ders: there is / there are: "var" demek · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Örnek alınan pilot dersler: G-A1-01-to-be, G-A1-03-a-an, G-A1-13-third-person-s (H-079, onaylı). Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş sözlüğü:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın defteri ayrı tutuldu: `kitaplar/_maliyet/patientdesk-h080a.json` (birleştirme çakışmasını önlemek için; ana deftere ana oturum işler). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:09:12Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 133 | 8.48 | 4754f381736644ec97349e1a8137eff5 | 9cb4c9b353c5036f |
| 2026-10-14T13:09:13Z | c01-tr | duyu-1 | - | - | - | 8.48 | - | 9cb4c9b353c5036f |
| 2026-10-14T13:09:16Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 11.55 | 58eb13e2da014897836d81838545e423 | 8d79aec87e19e762 |
| 2026-10-14T13:09:17Z | c02-tr | duyu-1 | - | - | - | 11.55 | - | 8d79aec87e19e762 |
| 2026-10-14T13:09:20Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 127 | 8.16 | fc93022961444207ade524f85354aa5d | b7ff2f45eac9e427 |
| 2026-10-14T13:09:21Z | c03-tr | duyu-1 | - | - | - | 8.16 | - | b7ff2f45eac9e427 |
| 2026-10-14T13:09:23Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 104 | 6.72 | f32b703ed0f6401aa9a2c62c1b6a8967 | 5153a3b7c37cd68b |
| 2026-10-14T13:09:24Z | c04-tr | duyu-1 | - | - | - | 6.72 | - | 5153a3b7c37cd68b |
| 2026-10-14T13:09:26Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 172 | 11.48 | 0f1ce87549f24a808d1aafcabba4f4d9 | 6746d68f626a7db8 |
| 2026-10-14T13:09:28Z | c06-tr | duyu-1 | - | - | - | 11.48 | - | 6746d68f626a7db8 |
| 2026-10-14T13:09:30Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.96 | ef36afa4c7744ec093684a359de467db | f02650721f375889 |
| 2026-10-14T13:09:32Z | c08-tr | duyu-1 | - | - | - | 4.96 | - | f02650721f375889 |
| 2026-10-14T13:09:34Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 10.59 | 4bd23a6ff71c40a595990ea3201dfba9 | 75a6e8c3b9d29aa3 |
| 2026-10-14T13:09:35Z | c09-tr | duyu-1 | - | - | - | 10.59 | - | 75a6e8c3b9d29aa3 |
