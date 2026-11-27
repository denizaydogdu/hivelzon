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

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:06:18Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 46 | 4e597a01559f73ed | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:06:20Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | bff965b17cb887c6 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:06:22Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 48 | bebb9ba8b68616e8 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:06:24Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 261e1271775d870c | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:06:27Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 83f97715b48ac1e0 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:06:29Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 53 | f95e91746ac061ee | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:06:31Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 45 | 90f137c0c131f822 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:06:33Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 6b6abaca03da7ab1 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:06:35Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 46 | 252df215948362a6 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:06:37Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | d97a957258feb3a6 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:06:39Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 47 | 468dcc0a9ac0f2fe | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:06:41Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 55 | 3b192c0bfe60188d | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:06:43Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 48f582847170388c | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:06:45Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 45d902197fc60dba | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:06:47Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | b23af4fb23375c48 | audio/en/c06-ex3.mp3 |
