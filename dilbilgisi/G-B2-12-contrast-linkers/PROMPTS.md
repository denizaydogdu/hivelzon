# G-B2-12-contrast-linkers PROMPTS

Ders: Zıtlık bağlaçları: although, despite, however, whereas · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** Max → Maks; -ing → ing.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:12:41Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 9.63 | 5adb518ce06447599703c5c6c27784e7 | 8deb00cea66cfa1d |
| 2026-10-14T14:12:43Z | c01-tr | duyu-1 | - | - | - | 9.63 | - | 8deb00cea66cfa1d |
| 2026-10-14T14:12:46Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 207 | 13.95 | b89743d7ee414d1e82913d110d864cdd | 4f0457db6b6614fd |
| 2026-10-14T14:12:47Z | c02-tr | duyu-1 | - | - | - | 13.95 | - | 4f0457db6b6614fd |
| 2026-10-14T14:12:50Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 9.79 | 28931813e9934b0583777147fa9a3a84 | 8d176a23dc2cce6d |
| 2026-10-14T14:12:51Z | c03-tr | duyu-1 | - | - | - | 9.79 | - | 8d176a23dc2cce6d |
| 2026-10-14T14:12:54Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 209 | 16.67 | 63eea3826a4e45f3a1805ddf1d1fff5a | 263bebbac4e485e9 |
| 2026-10-14T14:12:56Z | c04-tr | duyu-1 | - | - | - | 16.67 | - | 263bebbac4e485e9 |
| 2026-10-14T14:13:00Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 220 | 14.75 | 5e17ca50033c413181642a932359bcf8 | 59e222e6566753e6 |
| 2026-10-14T14:13:01Z | c06-tr | duyu-1 | - | - | - | 14.75 | - | 59e222e6566753e6 |
| 2026-10-14T14:13:04Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 7.84 | 5a8a133aa4d240f5918d397ee0804d4a | c295b3e2d9152fc2 |
| 2026-10-14T14:13:05Z | c08-tr | duyu-1 | - | - | - | 7.84 | - | c295b3e2d9152fc2 |
