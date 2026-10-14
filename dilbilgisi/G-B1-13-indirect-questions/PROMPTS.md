# G-B1-13-indirect-questions PROMPTS

Ders: Dolaylı sorular: Can you tell me where…? · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `Alex` → "Aleks".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:10:24Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 176 | 13.47 | a9588de3d9c6451d822ba3f5b0a2c221 | 6f2f524331f5c71e |
| 2026-10-14T14:10:26Z | c01-tr | duyu-1 | - | - | - | 13.47 | - | 6f2f524331f5c71e |
| 2026-10-14T14:10:28Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 10.11 | 6dca3fc141b54d3eb500022af5309226 | 9238fb9fec2f02a0 |
| 2026-10-14T14:10:30Z | c02-tr | duyu-1 | - | - | - | 10.11 | - | 9238fb9fec2f02a0 |
| 2026-10-14T14:10:33Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 111 | 6.72 | 97710a11d383453db4d12c36af25ab8d | ab27296b7a7ed021 |
| 2026-10-14T14:10:34Z | c03-tr | duyu-1 | - | - | - | 6.72 | - | ab27296b7a7ed021 |
| 2026-10-14T14:10:36Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 119 | 8.96 | ea1f16426fd74075a60befa5dc2c2b63 | abc7383601d21ecc |
| 2026-10-14T14:10:37Z | c04-tr | duyu-1 | - | - | - | 8.96 | - | abc7383601d21ecc |
| 2026-10-14T14:10:40Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 215 | 13.5 | 229ec8968ac14977ba7e989683f0caf4 | 72f7611c77af3b86 |
| 2026-10-14T14:10:41Z | c06-tr | duyu-1 | - | - | - | 13.5 | - | 72f7611c77af3b86 |
| 2026-10-14T14:10:44Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 159 | 9.61 | 8388146da269444eb6b356c0b956b19a | dc992b79e0892d02 |
| 2026-10-14T14:10:45Z | c08-tr | duyu-1 | - | - | - | 9.61 | - | dc992b79e0892d02 |
