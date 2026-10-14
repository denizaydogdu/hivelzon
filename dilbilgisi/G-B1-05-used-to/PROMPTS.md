# G-B1-05-used-to PROMPTS

Ders: used to: geçmişteki alışkanlık · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:07:03Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 177 | 12.67 | 3c460e8a00d64b688ca7bac7446dfa72 | 4ce2e7d4b3c4dd7d |
| 2026-10-14T14:07:04Z | c01-tr | duyu-1 | - | - | - | 12.67 | - | 4ce2e7d4b3c4dd7d |
| 2026-10-14T14:07:07Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 172 | 13.6 | 867686d1d9604a6c9f07f01a38372354 | ec1e22457dc33605 |
| 2026-10-14T14:07:09Z | c02-tr | duyu-1 | - | - | - | 13.6 | - | ec1e22457dc33605 |
| 2026-10-14T14:07:12Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 179 | 12.03 | 85ae2f2be56c45fa84af827bdf473feb | 6d8b1749e00a8a75 |
| 2026-10-14T14:07:13Z | c03-tr | duyu-1 | - | - | - | 12.03 | - | 6d8b1749e00a8a75 |
| 2026-10-14T14:07:16Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 192 | 11.87 | 443b7ab48b67469c80bef285d9b137ac | dce4a956c80ac0c2 |
| 2026-10-14T14:07:17Z | c05-tr | duyu-1 | - | - | - | 11.87 | - | dce4a956c80ac0c2 |
| 2026-10-14T14:07:19Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 160 | 11.52 | 42b372b0d67649f2a9e6dbf3abe44079 | 693882880a76f1fa |
| 2026-10-14T14:07:21Z | c07-tr | duyu-1 | - | - | - | 11.52 | - | 693882880a76f1fa |
| 2026-10-14T14:11:47Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 195 | 13.47 | 070ccab0b3b040b6a2f5fed498f600c5 | 5ff6d531a93165f2 |
| 2026-10-14T14:11:48Z | c01-tr | duyu-1 | - | - | - | 13.47 | - | 5ff6d531a93165f2 |
