# G-A2-04-past-simple-regular PROMPTS

Ders: Geçmiş zaman: düzenli fiiller (-ed) · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ed` → "ed".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:08:14Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 110 | 8.0 | c6b84150fabb4568b6fd0e798faf8595 | e2ba6e76263d8d3d |
| 2026-10-14T13:08:15Z | c01-tr | duyu-1 | - | - | - | 8.0 | - | e2ba6e76263d8d3d |
| 2026-10-14T13:08:18Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 9.95 | 2cedef98646647efae78cf68de1a3333 | caa91ec6a241770e |
| 2026-10-14T13:08:19Z | c02-tr | duyu-1 | - | - | - | 9.95 | - | caa91ec6a241770e |
| 2026-10-14T13:08:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 13.95 | 32894bc6a5154990a5773dd91422c894 | 5968a8e8053b7149 |
| 2026-10-14T13:08:22Z | c03-tr | duyu-1 | - | - | - | 13.95 | - | 5968a8e8053b7149 |
| 2026-10-14T13:08:25Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 10.43 | 62f51a7c45eb4f36a4de514b89629672 | f62f4d4e1fd22353 |
| 2026-10-14T13:08:26Z | c04-tr | duyu-1 | - | - | - | 10.43 | - | f62f4d4e1fd22353 |
| 2026-10-14T13:08:29Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 13.31 | da09434a8dbb45ad83c26d45007ce312 | 53514539b9f768e3 |
| 2026-10-14T13:08:30Z | c06-tr | duyu-1 | - | - | - | 13.31 | - | 53514539b9f768e3 |
| 2026-10-14T13:08:33Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 63 | 4.0 | 5b900bcfd31b4afdbf42f41004f5173c | d58758c9cd52c276 |
| 2026-10-14T13:08:33Z | c08-tr | duyu-1 | - | - | - | 4.0 | - | d58758c9cd52c276 |
| 2026-10-14T13:08:35Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 80 | 5.92 | 359a866974b74ae3a437f653017b995b | 353af048ad4d20f3 |
| 2026-10-14T13:08:37Z | c09-tr | duyu-1 | - | - | - | 5.92 | - | 353af048ad4d20f3 |
