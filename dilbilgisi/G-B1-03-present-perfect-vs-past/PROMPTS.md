# G-B1-03-present-perfect-vs-past PROMPTS

Ders: Present perfect mi, past simple mı? just / already / yet · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok. **Sözlük (kapsama):** cast.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:06:16Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 179 | 13.94 | 1b46ba85c13942269fd7bfcb35787541 | 08a51777f2934e77 |
| 2026-10-14T14:06:17Z | c01-tr | duyu-1 | - | - | - | 13.94 | - | 08a51777f2934e77 |
| 2026-10-14T14:06:21Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 189 | 12.51 | e4468f56b03a41d69c7c1629d69c1a21 | d2c3621ffd71123a |
| 2026-10-14T14:06:23Z | c02-tr | duyu-1 | - | - | - | 12.51 | - | d2c3621ffd71123a |
| 2026-10-14T14:06:26Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 209 | 14.91 | 869ac17cca6a4ea78438b37fb2ada33d | 27606fc15982bf8e |
| 2026-10-14T14:06:27Z | c03-tr | duyu-1 | - | - | - | 14.91 | - | 27606fc15982bf8e |
| 2026-10-14T14:06:30Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 14.3 | 871e8d7965644e0b830dcb918d48a47c | a38eec53102fc8d1 |
| 2026-10-14T14:06:32Z | c05-tr | duyu-1 | - | - | - | 14.3 | - | a38eec53102fc8d1 |
| 2026-10-14T14:06:34Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.91 | fa7fc93204694d5685f435859940d2db | 8145a4f08e37448b |
| 2026-10-14T14:06:35Z | c07-tr | duyu-1 | - | - | - | 10.91 | - | 8145a4f08e37448b |
