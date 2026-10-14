# G-A1-15-there-is-are PROMPTS

Ders: there is / there are: "var" demek · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Örnek alınan pilot dersler: G-A1-01-to-be, G-A1-03-a-an, G-A1-13-third-person-s (H-079, onaylı). Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş sözlüğü:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın defteri ayrı tutuldu: `kitaplar/_maliyet/patientdesk-h080a.json` (birleştirme çakışmasını önlemek için; ana deftere ana oturum işler). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:09:12Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 133 | 8.48 | 4754f381736644ec97349e1a8137eff5 | 9cb4c9b353c5036f |
| 2026-10-14T13:09:13Z | c01-tr | duyu-1 | - | - | - | 8.48 | - | 9cb4c9b353c5036f |
| 2026-10-14T13:09:16Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 11.55 | 58eb13e2da014897836d81838545e423 | 8d79aec87e19e762 |
| 2026-10-14T13:09:17Z | c02-tr | duyu-1 | - | - | - | 11.55 | - | 8d79aec87e19e762 |
| 2026-10-14T13:09:20Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 127 | 8.16 | fc93022961444207ade524f85354aa5d | b7ff2f45eac9e427 |
| 2026-10-14T13:09:21Z | c03-tr | duyu-1 | - | - | - | 8.16 | - | b7ff2f45eac9e427 |
| 2026-10-14T13:09:23Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 104 | 6.72 | f32b703ed0f6401aa9a2c62c1b6a8967 | 5153a3b7c37cd68b |
| 2026-10-14T13:09:24Z | c04-tr | duyu-1 | - | - | - | 6.72 | - | 5153a3b7c37cd68b |
| 2026-10-14T13:09:26Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 172 | 11.48 | 0f1ce87549f24a808d1aafcabba4f4d9 | 6746d68f626a7db8 |
| 2026-10-14T13:09:28Z | c06-tr | duyu-1 | - | - | - | 11.48 | - | 6746d68f626a7db8 |
| 2026-10-14T13:09:30Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.96 | ef36afa4c7744ec093684a359de467db | f02650721f375889 |
| 2026-10-14T13:09:32Z | c08-tr | duyu-1 | - | - | - | 4.96 | - | f02650721f375889 |
| 2026-10-14T13:09:34Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 10.59 | 4bd23a6ff71c40a595990ea3201dfba9 | 75a6e8c3b9d29aa3 |
| 2026-10-14T13:09:35Z | c09-tr | duyu-1 | - | - | - | 10.59 | - | 75a6e8c3b9d29aa3 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T16:33:08Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 33 | c468441a9d3be68c | audio/en/c01-ex1.mp3 |
| 2026-10-14T16:33:09Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | 3b93056243a7e685 | audio/en/c02-ex1.mp3 |
| 2026-10-14T16:33:10Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | dbb8824226a38282 | audio/en/c03-ex1.mp3 |
| 2026-10-14T16:33:11Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 8698894a966a0b3a | audio/en/c03-ex2.mp3 |
| 2026-10-14T16:33:12Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | 76e8f0771e1f3e02 | audio/en/c04-ex1.mp3 |
| 2026-10-14T16:33:14Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | bba10f565ada1328 | audio/en/c04-ex2.mp3 |
| 2026-10-14T16:33:15Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 30 | 4aa040cb64fb52d7 | audio/en/c05-ex1.mp3 |
| 2026-10-14T16:33:16Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 35 | 8153e70c8f257022 | audio/en/c05-ex2.mp3 |
| 2026-10-14T16:33:17Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 3bf9133fcaa434b8 | audio/en/c05-ex3.mp3 |
| 2026-10-14T16:33:18Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | 7ac7af030f9eac97 | audio/en/c05-ex4.mp3 |
| 2026-10-14T16:33:20Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 33 | 267aca4fb25e22bd | audio/en/c05-ex5.mp3 |
| 2026-10-14T16:33:21Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | 1047977f6a4f3e26 | audio/en/c06-ex1.mp3 |
| 2026-10-14T16:33:22Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | c935862594004976 | audio/en/c06-ex2.mp3 |
| 2026-10-14T16:33:23Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | dcec1b9b3638698a | audio/en/c06-ex3.mp3 |
| 2026-10-14T16:33:24Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 30 | 82376d18dc1d0c58 | audio/en/c07-q5.mp3 |
