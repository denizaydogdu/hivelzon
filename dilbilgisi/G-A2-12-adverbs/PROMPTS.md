# G-A2-12-adverbs PROMPTS

Ders: Zarflar: always / usually / never ve -ly · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ly` → "li".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:11:21Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 130 | 8.32 | 65ce9cd2b1cf46dca098a9e534b44fff | 7bcd17e900ea3332 |
| 2026-10-14T13:11:22Z | c01-tr | duyu-1 | - | - | - | 8.32 | - | 7bcd17e900ea3332 |
| 2026-10-14T13:11:24Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 10.43 | ce81fb46c26a47e3a80912c56f8bae9d | f5c095b99d532ef7 |
| 2026-10-14T13:11:26Z | c02-tr | duyu-1 | - | - | - | 10.43 | - | f5c095b99d532ef7 |
| 2026-10-14T13:11:28Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 187 | 12.35 | a8bea785a8cb4cee9628b59615d9ba80 | a58891a2f3fff7ec |
| 2026-10-14T13:11:30Z | c03-tr | duyu-1 | - | - | - | 12.35 | - | a58891a2f3fff7ec |
| 2026-10-14T13:11:32Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 169 | 11.71 | 5e1c3cbd24ef4a11b8b29f1a913375d6 | c0cebce6e714738c |
| 2026-10-14T13:11:34Z | c04-tr | duyu-1 | - | - | - | 11.71 | - | c0cebce6e714738c |
| 2026-10-14T13:11:36Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 223 | 16.34 | 8f4274e2b5204270b813dc060831b1a9 | f24c0e935edb75a9 |
| 2026-10-14T13:11:38Z | c06-tr | duyu-1 | - | - | - | 16.34 | - | f24c0e935edb75a9 |
| 2026-10-14T13:11:40Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.16 | aa6705a5a4084f3aac9d99db9144f0b2 | ab65d6764c5129b3 |
| 2026-10-14T13:11:41Z | c08-tr | duyu-1 | - | - | - | 4.16 | - | ab65d6764c5129b3 |
| 2026-10-14T13:11:43Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 123 | 7.68 | 63af2ed12a8f43758f23e61555db2210 | 0931b2ffbb264e51 |
| 2026-10-14T13:11:44Z | c09-tr | duyu-1 | - | - | - | 7.68 | - | 0931b2ffbb264e51 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:29:08Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | 89c5141f1bcd8c41 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:29:09Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | 461c135203732a8b | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:29:11Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 19 | d3cf82f7611a96ac | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:29:12Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 26 | 6c54deb762e1bf82 | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:29:14Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 0c9b6b18c30d37fb | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:29:15Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | b64fca404003be7a | audio/en/c03-ex3.mp3 |
| 2026-10-30T13:29:16Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | 4cf75e1f8451b847 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:29:18Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | 6f385db08bb7bae6 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:29:19Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | fc81e8365ea4a8f9 | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:29:21Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | 0650dd0beddd348b | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:29:23Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 34 | c9907ccee0622c6c | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:29:24Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 35 | ca992131988c2885 | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:29:25Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | 5d8e8b92da3084b5 | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:29:27Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | b279fbb5b7bfbdca | audio/en/c06-ex1.mp3 |
| 2026-10-30T13:29:28Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 17 | 1ebd95039bc09efc | audio/en/c06-ex2.mp3 |
| 2026-10-30T13:29:30Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 25 | 75815a164fc98547 | audio/en/c09-ex1.mp3 |
