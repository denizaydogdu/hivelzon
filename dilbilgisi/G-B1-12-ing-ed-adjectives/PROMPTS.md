# G-B1-12-ing-ed-adjectives PROMPTS

Ders: bored mı boring mi? -ed / -ing sıfatları · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ed` → "ed", `-ing` → "ing".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:10:03Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 9.6 | bcbdaf393f594b0fb62bf06f48f6e206 | eda39c8b2acaf53d |
| 2026-10-14T14:10:04Z | c01-tr | duyu-1 | - | - | - | 9.6 | - | eda39c8b2acaf53d |
| 2026-10-14T14:10:06Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 11.71 | 6b53826cd383406ea65790d2c52e7cef | 6f1c74e0eed5e0e0 |
| 2026-10-14T14:10:07Z | c02-tr | duyu-1 | - | - | - | 11.71 | - | 6f1c74e0eed5e0e0 |
| 2026-10-14T14:10:10Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 10.89 | 92fc6dd23c284db68b680f3aedc2beac | 1ce3fe66f7bd30ea |
| 2026-10-14T14:10:12Z | c03-tr | duyu-1 | - | - | - | 10.89 | - | 1ce3fe66f7bd30ea |
| 2026-10-14T14:10:14Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 200 | 13.28 | ac2886fb5fdc4112baa714e8a60a6731 | 79b668aa475c3eb9 |
| 2026-10-14T14:10:16Z | c05-tr | duyu-1 | - | - | - | 13.28 | - | 79b668aa475c3eb9 |
| 2026-10-14T14:10:18Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 63 | 4.32 | b04ff743fd00408daef309f97fa56b65 | 9466536444f7df5f |
| 2026-10-14T14:10:19Z | c07-tr | duyu-1 | - | - | - | 4.32 | - | 9466536444f7df5f |
| 2026-10-14T14:10:21Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 94 | 6.24 | 1682cd51ee36450fbbb3a9a637799f34 | 2831316009e7eeed |
| 2026-10-14T14:10:22Z | c08-tr | duyu-1 | - | - | - | 6.24 | - | 2831316009e7eeed |
