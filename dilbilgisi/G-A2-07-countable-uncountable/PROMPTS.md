# G-A2-07-countable-uncountable PROMPTS

Ders: Sayılabilen ve sayılamayan: some / any / much / many / a lot of · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:09:21Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 119 | 7.36 | ba156530ddf14e7780adddf65274c6e5 | 0de2d03750b9b288 |
| 2026-10-14T13:09:22Z | c01-tr | duyu-1 | - | - | - | 7.36 | - | 0de2d03750b9b288 |
| 2026-10-14T13:09:24Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 11.53 | be8a66be71ae4d738bbd03c952a05bc7 | 7d87d5287db7d0f3 |
| 2026-10-14T13:09:26Z | c02-tr | duyu-1 | - | - | - | 11.53 | - | 7d87d5287db7d0f3 |
| 2026-10-14T13:09:28Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 10.43 | 4783241a15f84b1eab078194fe9a0ef2 | 63902156e518b206 |
| 2026-10-14T13:09:29Z | c03-tr | duyu-1 | - | - | - | 10.43 | - | 63902156e518b206 |
| 2026-10-14T13:09:32Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 193 | 12.19 | 83428ee249c14fd4a2ad3d05971075b2 | 76e54c9640bd77d7 |
| 2026-10-14T13:09:33Z | c04-tr | duyu-1 | - | - | - | 12.19 | - | 76e54c9640bd77d7 |
| 2026-10-14T13:09:36Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 201 | 13.63 | 15c341527c2e401f8d13fd5286b7a0dd | b0c407bb0521b1f3 |
| 2026-10-14T13:09:38Z | c06-tr | duyu-1 | - | - | - | 13.63 | - | b0c407bb0521b1f3 |
| 2026-10-14T13:09:40Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 5.6 | bd99ad902632438ab670be876267429b | ab65d6764c5129b3 |
| 2026-10-14T13:09:41Z | c08-tr | duyu-1 | - | - | - | 5.6 | - | ab65d6764c5129b3 |
| 2026-10-14T13:09:43Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 118 | 8.0 | 9a8208e6e35244f0ae9c4ab46e194b5e | 664c51a917372649 |
| 2026-10-14T13:09:44Z | c09-tr | duyu-1 | - | - | - | 8.0 | - | 664c51a917372649 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T18:27:13Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | b3a265f19553852e | audio/en/c01-ex1.mp3 |
| 2026-10-14T18:27:14Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 18 | 726b1a3756495fc5 | audio/en/c02-ex1.mp3 |
| 2026-10-14T18:27:15Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 18 | 6150b66a2ce7474b | audio/en/c02-ex2.mp3 |
| 2026-10-14T18:27:16Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | c6c4b068cbdafd44 | audio/en/c03-ex1.mp3 |
| 2026-10-14T18:27:17Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 18 | 7258518922bbc7f6 | audio/en/c03-ex2.mp3 |
| 2026-10-14T18:27:19Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 7afaf0d5ef66af0f | audio/en/c03-ex3.mp3 |
| 2026-10-14T18:27:20Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 25 | dea4d4f7b6626611 | audio/en/c04-ex1.mp3 |
| 2026-10-14T18:27:21Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | da6f7b83364a89cf | audio/en/c04-ex2.mp3 |
| 2026-10-14T18:27:22Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 26 | 72ea66c993b00d28 | audio/en/c04-ex3.mp3 |
| 2026-10-14T18:27:24Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | e11a23aa1fc36c58 | audio/en/c05-ex1.mp3 |
| 2026-10-14T18:27:25Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 36 | a897e1c2ee26cac6 | audio/en/c05-ex2.mp3 |
| 2026-10-14T18:27:26Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | 74457233be04ac72 | audio/en/c05-ex3.mp3 |
| 2026-10-14T18:27:28Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 39 | 93df7e6c7e8bb3e0 | audio/en/c05-ex4.mp3 |
| 2026-10-14T18:27:29Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 0396f6de7ba0b1cf | audio/en/c05-ex5.mp3 |
| 2026-10-14T18:27:30Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | bf06be1649239f9d | audio/en/c06-ex1.mp3 |
| 2026-10-14T18:27:32Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | 0c031540183a2d1a | audio/en/c06-ex2.mp3 |
| 2026-10-14T18:27:33Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 46 | 492ece5bec98e6a8 | audio/en/c09-ex1.mp3 |
