# G-C2-02-nominalisation PROMPTS

Ders: Adlaştırma (nominalisation): resmî ve akademik yazı · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:41:12Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 128 | 9.44 | 8a23d8a420ba4e399ae04b4befdb1101 | e4c7cf7a8f107b3f |
| 2026-10-14T14:41:14Z | c01-tr | duyu-1 | - | - | - | 9.44 | - | e4c7cf7a8f107b3f |
| 2026-10-14T14:41:17Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 14.43 | 5cf43ea569484d3dad9d5d79f5a860e5 | c155f798162060c5 |
| 2026-10-14T14:41:18Z | c02-tr | duyu-1 | - | - | - | 14.43 | - | c155f798162060c5 |
| 2026-10-14T14:41:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 205 | 14.41 | 6de415421c7c4865823a06909fa79a5e | 518385519d12d332 |
| 2026-10-14T14:41:22Z | c03-tr | duyu-1 | - | - | - | 14.41 | - | 518385519d12d332 |
| 2026-10-14T14:41:25Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 188 | 12.19 | 6b3ca71ca540498abbf00d6855265e0c | 7efc5d587bf89576 |
| 2026-10-14T14:41:27Z | c04-tr | duyu-1 | - | - | - | 12.19 | - | 7efc5d587bf89576 |
| 2026-10-14T14:41:30Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 237 | 15.4 | 253ea916859a457cac463718619e09be | a7c195c0f6691dab |
| 2026-10-14T14:41:32Z | c06-tr | duyu-1 | - | - | - | 15.4 | - | a7c195c0f6691dab |
| 2026-10-14T14:41:35Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 11.39 | aac11d582ffd44f3b737e64585696254 | d4adf0cd4e976b91 |
| 2026-10-14T14:41:37Z | c08-tr | duyu-1 | - | - | - | 11.39 | - | d4adf0cd4e976b91 |
