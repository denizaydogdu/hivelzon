# G-A1-04-the PROMPTS

Ders: the: ikimizin bildiği şey · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:04:51Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 9.93 | acce5f19ba3a4fe28a28108a89d0e7c6 | 861e44d72abcd045 |
| 2026-10-14T13:04:52Z | c01-tr | duyu-1 | - | - | - | 9.93 | - | 861e44d72abcd045 |
| 2026-10-14T13:04:54Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 177 | 10.88 | 0de035e32d304686901a8f742f4d1d57 | a14ae1e6acedfbb8 |
| 2026-10-14T13:04:55Z | c02-tr | duyu-1 | - | - | - | 10.88 | - | a14ae1e6acedfbb8 |
| 2026-10-14T13:04:58Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 160 | 9.47 | 002ea9cf01764726a21018aedaedf22d | 5bc5b00f6764e9fb |
| 2026-10-14T13:04:59Z | c03-tr | duyu-1 | - | - | - | 9.47 | - | 5bc5b00f6764e9fb |
| 2026-10-14T13:05:02Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 9.12 | b2e88369023c457b81cd0cf1fde026d9 | bd9288834e4b8d36 |
| 2026-10-14T13:05:03Z | c04-tr | duyu-1 | - | - | - | 9.12 | - | bd9288834e4b8d36 |
| 2026-10-14T13:05:06Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 169 | 12.12 | 02e1d84ae6a448fcabc12c93491c4671 | ad18817109f79fff |
| 2026-10-14T13:05:07Z | c06-tr | duyu-1 | - | - | - | 12.12 | - | ad18817109f79fff |
| 2026-10-14T13:05:09Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 75 | 4.8 | 8c8ae18de586473dbfd4993e4358d81b | c4b61d081b412ff1 |
| 2026-10-14T13:05:10Z | c08-tr | duyu-1 | - | - | - | 4.8 | - | c4b61d081b412ff1 |
| 2026-10-14T13:05:12Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 8.51 | b888111b25af47a3af77a860a9f50080 | 846a0f4a07647124 |
| 2026-10-14T13:05:13Z | c09-tr | duyu-1 | - | - | - | 8.51 | - | 846a0f4a07647124 |
