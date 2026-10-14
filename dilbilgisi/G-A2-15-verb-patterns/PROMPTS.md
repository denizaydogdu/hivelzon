# G-A2-15-verb-patterns PROMPTS

Ders: Fiilden sonra fiil: want to, like + -ing · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ing` → "ing".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:12:41Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 113 | 8.0 | 84e64d3607164accb907acb177dff0a9 | ef85fcbb562bbd74 |
| 2026-10-14T13:12:43Z | c01-tr | duyu-1 | - | - | - | 8.0 | - | ef85fcbb562bbd74 |
| 2026-10-14T13:12:46Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 227 | 15.39 | 2f80e23394a24e67a3e28cc526eb9bef | 5e7420039368befa |
| 2026-10-14T13:12:47Z | c02-tr | duyu-1 | - | - | - | 15.39 | - | 5e7420039368befa |
| 2026-10-14T13:12:50Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 193 | 13.15 | 8a045a57d5344c5a8ad8508ffe4e8097 | bdb4fa3820eb0edb |
| 2026-10-14T13:12:52Z | c03-tr | duyu-1 | - | - | - | 13.15 | - | bdb4fa3820eb0edb |
| 2026-10-14T13:12:55Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 11.1 | d57d288125aa4e2480d9fbf997b9103a | 103f88a461aa9415 |
| 2026-10-14T13:12:56Z | c04-tr | duyu-1 | - | - | - | 11.1 | - | 103f88a461aa9415 |
| 2026-10-14T13:12:59Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 184 | 12.19 | 2285fd366df44dcfbc9381a3796b69e3 | ff5a69dc6b0f00bf |
| 2026-10-14T13:13:00Z | c06-tr | duyu-1 | - | - | - | 12.19 | - | ff5a69dc6b0f00bf |
| 2026-10-14T13:13:03Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 83 | 5.12 | fe40943a2f8c43e8be4070402b8f9c17 | d1958fa00e8d1ddf |
| 2026-10-14T13:13:04Z | c08-tr | duyu-1 | - | - | - | 5.12 | - | d1958fa00e8d1ddf |
| 2026-10-14T13:13:06Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 10.27 | 81e6a01d8f5f4a0697fbbad6d3ba1e8d | ae90465ede57a5db |
| 2026-10-14T13:13:08Z | c09-tr | duyu-1 | - | - | - | 10.27 | - | ae90465ede57a5db |
