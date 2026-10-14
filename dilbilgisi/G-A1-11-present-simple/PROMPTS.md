# G-A1-11-present-simple PROMPTS

Ders: Geniş zaman (present simple): I / you / we / they · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:07:57Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 119 | 8.48 | 56cd410e44ef41b79b2c3aa0fdd23287 | 01e1ed229fc00247 |
| 2026-10-14T13:07:58Z | c01-tr | duyu-1 | - | - | - | 8.48 | - | 01e1ed229fc00247 |
| 2026-10-14T13:08:00Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 172 | 10.59 | 87f2d9fbde3c47e883e389aa0c71f93a | 2406a81a293f4a18 |
| 2026-10-14T13:08:01Z | c02-tr | duyu-1 | - | - | - | 10.59 | - | 2406a81a293f4a18 |
| 2026-10-14T13:08:04Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 169 | 13.63 | 6c87f4e3bfdc43b9b0d2e2d0b4b9fc20 | d87a7c91d42d7811 |
| 2026-10-14T13:08:05Z | c03-tr | duyu-1 | - | - | - | 13.63 | - | d87a7c91d42d7811 |
| 2026-10-14T13:08:08Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 110 | 8.32 | 516b58d9693b421d9cb84e9e2a262a66 | b9c2e6731d1d27cd |
| 2026-10-14T13:08:09Z | c04-tr | duyu-1 | - | - | - | 8.32 | - | b9c2e6731d1d27cd |
| 2026-10-14T13:08:12Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 198 | 12.94 | 90a7b1abc187480285807dd0b754dce1 | 5f8ceedd8b5825e8 |
| 2026-10-14T13:08:13Z | c06-tr | duyu-1 | - | - | - | 12.94 | - | 5f8ceedd8b5825e8 |
| 2026-10-14T13:08:15Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 71 | 4.64 | c6d7bc6d7dd24c2f99ea5f733f4f440d | 6f3a0c37b32aec8b |
| 2026-10-14T13:08:16Z | c08-tr | duyu-1 | - | - | - | 4.64 | - | 6f3a0c37b32aec8b |
| 2026-10-14T13:08:18Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 9.28 | 76bf7eef788843139071e625dc09fd86 | e932c510f77d4c13 |
| 2026-10-14T13:08:19Z | c09-tr | duyu-1 | - | - | - | 9.28 | - | e932c510f77d4c13 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:55:47Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | 96787c3291eed8ca | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:55:48Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | 34beee44f15ad9bb | audio/en/c02-ex1.mp3 |
| 2026-10-14T14:55:49Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | f07963f55c90515a | audio/en/c02-ex2.mp3 |
| 2026-10-14T14:55:50Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | f058c630d2206dcc | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:55:51Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | f30ebc9595d305d0 | audio/en/c03-ex2.mp3 |
| 2026-10-14T14:55:52Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 8 | 826ff0dab649a97f | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:55:53Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 12 | 7f3a819eb3a3bf03 | audio/en/c04-ex2.mp3 |
| 2026-10-14T14:55:54Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 7b513c289d454094 | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:55:56Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | cea7527fa554dd8c | audio/en/c05-ex2.mp3 |
| 2026-10-14T14:55:57Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | 5946354313d5a472 | audio/en/c05-ex3.mp3 |
| 2026-10-14T14:55:58Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 20023cc092fb34c5 | audio/en/c05-ex4.mp3 |
| 2026-10-14T14:55:59Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | 573b5abffed4836f | audio/en/c05-ex5.mp3 |
| 2026-10-14T14:56:00Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 7b1ded309ee8e643 | audio/en/c06-ex3.mp3 |
