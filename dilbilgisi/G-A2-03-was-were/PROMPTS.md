# G-A2-03-was-were PROMPTS

Ders: was / were: geçmişte "idi" · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:07:52Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 7.68 | fb4bd3c148c44042bf3651aac4cbd56e | 200596b5206acfdb |
| 2026-10-14T13:07:53Z | c01-tr | duyu-1 | - | - | - | 7.68 | - | 200596b5206acfdb |
| 2026-10-14T13:07:56Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 135 | 10.4 | 09570f5abce548b4b19036b3f36747a9 | 3a7078f97f242d76 |
| 2026-10-14T13:07:57Z | c02-tr | duyu-1 | - | - | - | 10.4 | - | 3a7078f97f242d76 |
| 2026-10-14T13:08:00Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 145 | 10.43 | fd143735f68548f99ddfb4358fe70c7f | 8e1ce71a1b98debb |
| 2026-10-14T13:08:01Z | c03-tr | duyu-1 | - | - | - | 10.43 | - | 8e1ce71a1b98debb |
| 2026-10-14T13:08:04Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 11.8 | cfd62ab3aa9d4fd897d6af552d59e005 | c6d8025bcb14a9fc |
| 2026-10-14T13:08:06Z | c05-tr | duyu-1 | - | - | - | 11.8 | - | c6d8025bcb14a9fc |
| 2026-10-14T13:08:08Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 76 | 4.64 | 6c498ddf26cd43fcb5ecc7067ae1fead | 6c4eb41663beb98e |
| 2026-10-14T13:08:09Z | c07-tr | duyu-1 | - | - | - | 4.64 | - | 6c4eb41663beb98e |
| 2026-10-14T13:08:11Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 115 | 7.52 | 4a80b046392c456a909aa12b64cf2415 | 2fd54b00e8ab4fc7 |
| 2026-10-14T13:08:12Z | c08-tr | duyu-1 | - | - | - | 7.52 | - | 2fd54b00e8ab4fc7 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T18:26:13Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 43 | f62aa5244fb400ab | audio/en/c01-ex1.mp3 |
| 2026-10-14T18:26:14Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 14 | 5ed3b02fd5b9d3c9 | audio/en/c02-ex1.mp3 |
| 2026-10-14T18:26:15Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 14 | 423bb55c323a4a61 | audio/en/c02-ex2.mp3 |
| 2026-10-14T18:26:16Z | c02-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 21 | 6be88a3d2e4cd3a7 | audio/en/c02-ex3.mp3 |
| 2026-10-14T18:26:17Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 15 | c7b9add5096f5773 | audio/en/c03-ex1.mp3 |
| 2026-10-14T18:26:18Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 15 | dcba0bcb1de8fdb2 | audio/en/c03-ex2.mp3 |
| 2026-10-14T18:26:20Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | cafa15f3d1398426 | audio/en/c04-ex1.mp3 |
| 2026-10-14T18:26:21Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 22b94e0557da73b0 | audio/en/c04-ex2.mp3 |
| 2026-10-14T18:26:22Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | 7875fc15b91adca4 | audio/en/c04-ex3.mp3 |
| 2026-10-14T18:26:24Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 6d4f687df607a5f8 | audio/en/c04-ex4.mp3 |
| 2026-10-14T18:26:25Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 16 | 39d0f87cd67cd0b2 | audio/en/c04-ex5.mp3 |
| 2026-10-14T18:26:26Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | bc104e83314edc34 | audio/en/c05-ex1.mp3 |
| 2026-10-14T18:26:27Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | 18530d3eb5b14c41 | audio/en/c05-ex2.mp3 |
| 2026-10-14T18:26:28Z | c08-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | 0913319c6a2c5531 | audio/en/c08-ex1.mp3 |
