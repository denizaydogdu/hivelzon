# G-A1-10-prepositions-time PROMPTS

Ders: Saat ve gün: at / on / in, What time is it? · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Örnek alınan pilot dersler: G-A1-01-to-be, G-A1-03-a-an, G-A1-13-third-person-s (H-079, onaylı). Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş sözlüğü:** `Alex` → "Aleks".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın defteri ayrı tutuldu: `kitaplar/_maliyet/patientdesk-h080a.json` (birleştirme çakışmasını önlemek için; ana deftere ana oturum işler). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:07:31Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 130 | 7.68 | 1603d05883e84a5d8d3d82308495d074 | 7801652380db1e85 |
| 2026-10-14T13:07:32Z | c01-tr | duyu-1 | - | - | - | 7.68 | - | 7801652380db1e85 |
| 2026-10-14T13:07:34Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 168 | 13.95 | cc95bcac32104fe08f8fe68f47f3de0c | 7ae6202a8d44fdec |
| 2026-10-14T13:07:35Z | c02-tr | duyu-1 | - | - | - | 13.95 | - | 7ae6202a8d44fdec |
| 2026-10-14T13:07:38Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 118 | 6.88 | 80b7f03d67714682be1f4809b1bdca3a | 1e2ca74684f334d7 |
| 2026-10-14T13:07:39Z | c03-tr | duyu-1 | - | - | - | 6.88 | - | 1e2ca74684f334d7 |
| 2026-10-14T13:07:42Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 10.75 | e0d6c34237434c248045ce7c2c112227 | 9fd4fdeb312b3586 |
| 2026-10-14T13:07:43Z | c04-tr | duyu-1 | - | - | - | 10.75 | - | 9fd4fdeb312b3586 |
| 2026-10-14T13:07:46Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 186 | 12.96 | 621c50e9da684860a9a74995c1b11c40 | 6fd5d1bf45384b5b |
| 2026-10-14T13:07:47Z | c06-tr | duyu-1 | - | - | - | 12.96 | - | 6fd5d1bf45384b5b |
| 2026-10-14T13:07:50Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 80 | 5.6 | 3eba9e50505147a2b895b912b0db4c1a | 79f4d711051ea117 |
| 2026-10-14T13:07:51Z | c08-tr | duyu-1 | - | - | - | 5.6 | - | 79f4d711051ea117 |
| 2026-10-14T13:07:53Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 9.6 | f77314d7a723480297a20d7512d93f31 | eb9a069e353b6f62 |
| 2026-10-14T13:07:54Z | c09-tr | duyu-1 | - | - | - | 9.6 | - | eb9a069e353b6f62 |
| 2026-10-14T13:11:21Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 84 | 5.76 | 17cbac0cd1ed43179c7bc7db6cbe8569 | 9dd39cf92fb24cce |
| 2026-10-14T13:11:22Z | c08-tr | duyu-1 | - | - | - | 5.76 | - | 9dd39cf92fb24cce |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:55:31Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | bcf9b67eeefa0e65 | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:55:32Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | 4573e80283165384 | audio/en/c02-ex1.mp3 |
| 2026-10-14T14:55:33Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | e455eaa92a776712 | audio/en/c02-ex2.mp3 |
| 2026-10-14T14:55:34Z | c02-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | e15b456bb9802c0c | audio/en/c02-ex3.mp3 |
| 2026-10-14T14:55:35Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 6db007abe1e06c9b | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:55:36Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 36 | ccecf83f153c28f0 | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:55:38Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | 26807498437bc409 | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:55:39Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 06c8971e7b975988 | audio/en/c05-ex2.mp3 |
| 2026-10-14T14:55:40Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | e6669daa7f52308f | audio/en/c05-ex3.mp3 |
| 2026-10-14T14:55:41Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 30 | 90aab95caf65a577 | audio/en/c05-ex4.mp3 |
| 2026-10-14T14:55:42Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | 48168b62123e5396 | audio/en/c05-ex5.mp3 |
| 2026-10-14T14:55:43Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | ba57b745b2a21730 | audio/en/c06-ex1.mp3 |
| 2026-10-14T14:55:45Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 9 | 7c1ea03ace9f7f90 | audio/en/c06-ex2.mp3 |
| 2026-10-14T14:55:46Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | d03a9f627cd86a9c | audio/en/c07-q5.mp3 |
