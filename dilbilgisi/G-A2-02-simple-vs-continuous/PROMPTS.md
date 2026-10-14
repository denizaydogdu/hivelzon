# G-A2-02-simple-vs-continuous PROMPTS

Ders: Geniş zaman mı, şimdiki zaman mı? · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:07:30Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 8.32 | 72cfb4d139f0457abf131666d4ceed04 | 721fddd6ee261592 |
| 2026-10-14T13:07:31Z | c01-tr | duyu-1 | - | - | - | 8.32 | - | 721fddd6ee261592 |
| 2026-10-14T13:07:34Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 194 | 12.34 | e24c8bf76aaf4a269e81c4baa7e3fa39 | e1f474273c99f45d |
| 2026-10-14T13:07:35Z | c02-tr | duyu-1 | - | - | - | 12.34 | - | e1f474273c99f45d |
| 2026-10-14T13:07:38Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 198 | 14.42 | e2c023cfb43440989e33aad16f01bbf0 | cb2f0f2e08c5c9dc |
| 2026-10-14T13:07:39Z | c03-tr | duyu-1 | - | - | - | 14.42 | - | cb2f0f2e08c5c9dc |
| 2026-10-14T13:07:42Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 195 | 13.95 | b013482751974ae69cd4718175a282a1 | b0bb43967dcd36ef |
| 2026-10-14T13:07:43Z | c05-tr | duyu-1 | - | - | - | 13.95 | - | b0bb43967dcd36ef |
| 2026-10-14T13:07:45Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 71 | 4.96 | d60053ef82ab4afba4257b99c328a3c5 | 0f174e20340b77f4 |
| 2026-10-14T13:07:46Z | c07-tr | duyu-1 | - | - | - | 4.96 | - | 0f174e20340b77f4 |
| 2026-10-14T13:07:48Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 11.39 | fa6e36daffc34b278809de6e9ee6eb9c | 5cd58fa936d1b54a |
| 2026-10-14T13:07:50Z | c08-tr | duyu-1 | - | - | - | 11.39 | - | 5cd58fa936d1b54a |
