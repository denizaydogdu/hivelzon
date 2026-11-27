# G-B2-09-non-defining-relatives PROMPTS

Ders: Tanımlamayan sıfat cümlecikleri: virgüllü who, which, whose · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:11:26Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 11.71 | a8d015d350144c7494400c2f1891d978 | 019bb3bdf720a257 |
| 2026-10-14T14:11:27Z | c01-tr | duyu-1 | - | - | - | 11.71 | - | 019bb3bdf720a257 |
| 2026-10-14T14:11:30Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 196 | 12.51 | a6ac3aa8e0964ba6802edaa53431ea99 | 5c182e3b1ef66235 |
| 2026-10-14T14:11:31Z | c02-tr | duyu-1 | - | - | - | 12.51 | - | 5c182e3b1ef66235 |
| 2026-10-14T14:11:34Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 175 | 11.55 | 7dc454359ad8441aa87f91f0ec4de2da | 7a3d34fc4276739d |
| 2026-10-14T14:11:36Z | c03-tr | duyu-1 | - | - | - | 11.55 | - | 7a3d34fc4276739d |
| 2026-10-14T14:11:38Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 175 | 11.23 | 88a4e8162cde45d99cebc29b7ae4fa6e | 22e4221887450d4f |
| 2026-10-14T14:11:40Z | c04-tr | duyu-1 | - | - | - | 11.23 | - | 22e4221887450d4f |
| 2026-10-14T14:11:42Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 220 | 16.37 | 47b1db5f9f394284844a542b42bec75f | cf9dd4f59ee911b5 |
| 2026-10-14T14:11:44Z | c06-tr | duyu-1 | - | - | - | 16.37 | - | cf9dd4f59ee911b5 |
| 2026-10-14T14:11:47Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 145 | 10.65 | 4cd2ae85d0aa4c98b70f67cfe4d9624c | c5c471a4a0b671c5 |
| 2026-10-14T14:11:48Z | c08-tr | duyu-1 | - | - | - | 10.65 | - | c5c471a4a0b671c5 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:05:02Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 64 | fe885d6eaf0b6624 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:05:04Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 50fd168434947439 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:05:07Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 56 | 48007749061c0226 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:05:09Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 44ab144fc00c5996 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:05:12Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 46 | 5c3b976ec52c87d1 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:05:15Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 4897816e80d97954 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:05:17Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 34 | e8f636c546f569ef | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:05:20Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 73 | 7b6e013f0c661356 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:05:22Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 53 | 8038a189b26e5f3e | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:05:24Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 54 | 10fb92f76d18070f | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:05:26Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 0e20e6ca8e8bb00e | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:05:28Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | c59d8ce51033615e | audio/en/c06-ex1.mp3 |
| 2026-11-26T21:00:28Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 64 | fe885d6eaf0b6624 | audio/en/c01-ex1.mp3 |
