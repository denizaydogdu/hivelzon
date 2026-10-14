# G-B1-04-past-continuous PROMPTS

Ders: Past continuous ve when / while · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ing` → "ing".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:06:38Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 162 | 10.91 | 815bc9ecc4644756ac9e8d33a4f77c6c | 8b29df3d28d60502 |
| 2026-10-14T14:06:39Z | c01-tr | duyu-1 | - | - | - | 10.91 | - | 8b29df3d28d60502 |
| 2026-10-14T14:06:42Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 205 | 15.06 | 1614210617fa4c59baca9fc498cf7211 | 7c9c6acf88c29dd7 |
| 2026-10-14T14:06:44Z | c02-tr | duyu-1 | - | - | - | 15.06 | - | 7c9c6acf88c29dd7 |
| 2026-10-14T14:06:47Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 203 | 14.43 | a200b17927a741f2af51cd38f6d50f4a | 93f7c23496a73524 |
| 2026-10-14T14:06:48Z | c03-tr | duyu-1 | - | - | - | 14.43 | - | 93f7c23496a73524 |
| 2026-10-14T14:06:51Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 173 | 12.51 | 168e69598e6e4380a2b2061524e20920 | 59a75811d1655f27 |
| 2026-10-14T14:06:53Z | c05-tr | duyu-1 | - | - | - | 12.51 | - | 59a75811d1655f27 |
| 2026-10-14T14:06:55Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 78 | 4.96 | 686df5fac7194b72a173ff425e9e7092 | e5cfdac8feeb9a0a |
| 2026-10-14T14:06:57Z | c07-tr | duyu-1 | - | - | - | 4.96 | - | e5cfdac8feeb9a0a |
| 2026-10-14T14:06:59Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 9.28 | 3e904d73f5654fb9a71e8308ad3c3248 | acf747090bc81a96 |
| 2026-10-14T14:07:00Z | c08-tr | duyu-1 | - | - | - | 9.28 | - | acf747090bc81a96 |
