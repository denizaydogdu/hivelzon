# G-A2-11-will PROMPTS

Ders: will: anlık karar, söz ve tahmin · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `Alex` → "Aleks".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:10:58Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 9.13 | af37914a81054da19dc53f42215521ae | 023a70ef67ea9e5a |
| 2026-10-14T13:11:00Z | c01-tr | duyu-1 | - | - | - | 9.13 | - | 023a70ef67ea9e5a |
| 2026-10-14T13:11:02Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 141 | 10.43 | acbef9ca8e2b41ccb901d930472ab57f | 4e9d2b9da58fc090 |
| 2026-10-14T13:11:03Z | c02-tr | duyu-1 | - | - | - | 10.43 | - | 4e9d2b9da58fc090 |
| 2026-10-14T13:11:06Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 9.79 | d82125946c934e229f6ae59528e85076 | 2d4924f831216933 |
| 2026-10-14T13:11:07Z | c03-tr | duyu-1 | - | - | - | 9.79 | - | 2d4924f831216933 |
| 2026-10-14T13:11:10Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 179 | 12.34 | 26d21ad2b26b401486496262162a5c6b | 6db05e4149fc77fb |
| 2026-10-14T13:11:11Z | c04-tr | duyu-1 | - | - | - | 12.34 | - | 6db05e4149fc77fb |
| 2026-10-14T13:11:14Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 185 | 11.87 | b6e2efc3a1664fd18477e4a2ef57bceb | 280ab95967032e62 |
| 2026-10-14T13:11:15Z | c06-tr | duyu-1 | - | - | - | 11.87 | - | 280ab95967032e62 |
| 2026-10-14T13:11:18Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 100 | 7.04 | a40197bd091c4e4cb550b03e0325e509 | d6bfc4401e9928c5 |
| 2026-10-14T13:11:19Z | c08-tr | duyu-1 | - | - | - | 7.04 | - | d6bfc4401e9928c5 |
