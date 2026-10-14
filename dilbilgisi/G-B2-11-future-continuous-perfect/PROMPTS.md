# G-B2-11-future-continuous-perfect PROMPTS

Ders: Gelecekte süren ve bitmiş eylem: will be doing, will have done · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** -ing → ing.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:12:15Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 145 | 13.15 | 82a21e3535b7437a8335b5eeef684f30 | f3c21623261d2594 |
| 2026-10-14T14:12:16Z | c01-tr | duyu-1 | - | - | - | 13.15 | - | f3c21623261d2594 |
| 2026-10-14T14:12:19Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 10.43 | d23b6a316f3f4302b4ed5e31c19f7039 | c7e1abbfb8fb1ba8 |
| 2026-10-14T14:12:20Z | c02-tr | duyu-1 | - | - | - | 10.43 | - | c7e1abbfb8fb1ba8 |
| 2026-10-14T14:12:23Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 208 | 13.1 | 555082254fb748cfbccdd4e7cce00326 | e43e2266b39a28d0 |
| 2026-10-14T14:12:25Z | c03-tr | duyu-1 | - | - | - | 13.1 | - | e43e2266b39a28d0 |
| 2026-10-14T14:12:28Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 181 | 12.03 | 0b7247c6f5504243a51720e07a991a22 | cd8a6db840126c16 |
| 2026-10-14T14:12:30Z | c04-tr | duyu-1 | - | - | - | 12.03 | - | cd8a6db840126c16 |
| 2026-10-14T14:12:33Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 208 | 13.31 | d893788200964678aa33b2e316664370 | d22108ef867135a6 |
| 2026-10-14T14:12:35Z | c06-tr | duyu-1 | - | - | - | 13.31 | - | d22108ef867135a6 |
| 2026-10-14T14:12:37Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 9.15 | 4ebd9394a6df46498b5843dbfafb575d | 93c8f033d3049f26 |
| 2026-10-14T14:12:39Z | c08-tr | duyu-1 | - | - | - | 9.15 | - | 93c8f033d3049f26 |
| 2026-10-14T14:13:16Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 14.09 | d63fa2bcc136415f99db9fbb3401c052 | 9a03cd6ab3134e01 |
| 2026-10-14T14:13:18Z | c04-tr | duyu-1 | - | - | - | 14.09 | - | 9a03cd6ab3134e01 |
