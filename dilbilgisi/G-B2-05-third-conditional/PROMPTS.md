# G-B2-05-third-conditional PROMPTS

Ders: 3. tip koşul (third conditional): olmayan geçmiş · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** Alex → Aleks.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:09:28Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 127 | 8.0 | 0b08cc041c9e4491b944742b97cefbc0 | ade3062c980af1b6 |
| 2026-10-14T14:09:29Z | c01-tr | duyu-1 | - | - | - | 8.0 | - | ade3062c980af1b6 |
| 2026-10-14T14:09:31Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 175 | 11.82 | 4681bb61de684bb7a1f2d8d8a6503421 | d53779fd5ccd2d43 |
| 2026-10-14T14:09:32Z | c02-tr | duyu-1 | - | - | - | 11.82 | - | d53779fd5ccd2d43 |
| 2026-10-14T14:09:35Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 137 | 9.28 | 21bab4e26faa430faa677320b068a802 | 7660e38d251a562f |
| 2026-10-14T14:09:36Z | c03-tr | duyu-1 | - | - | - | 9.28 | - | 7660e38d251a562f |
| 2026-10-14T14:09:39Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 13.31 | dcd18dd9bb264eb6a43ab1f0d82c78ef | 807e4dd772063961 |
| 2026-10-14T14:09:41Z | c05-tr | duyu-1 | - | - | - | 13.31 | - | 807e4dd772063961 |
| 2026-10-14T14:09:43Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 153 | 9.62 | 421d39d96f6047a99860cc1e09d615c8 | 479144cb58a71131 |
| 2026-10-14T14:09:44Z | c07-tr | duyu-1 | - | - | - | 9.62 | - | 479144cb58a71131 |
