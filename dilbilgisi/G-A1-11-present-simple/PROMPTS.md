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
| 2026-11-27T18:19:15Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 3.04 | 0632a5ae95fb4df3b053416198be43af | ba10e1c2224bff22 |
| 2026-11-27T18:19:16Z | c07-q1-fb | duyu-1 | - | - | - | 3.04 | - | ba10e1c2224bff22 |
| 2026-11-27T18:19:18Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 879f71544f394705b32e89a6e2f29912 | 5e34e2c0c8ca2b01 |
| 2026-11-27T18:19:19Z | c07-q2-fb | duyu-1 | - | - | - | 1.76 | - | 5e34e2c0c8ca2b01 |
| 2026-11-27T18:19:21Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.24 | eec4b4d51d2e450dbf71a13010785fe3 | c4c7f46dc0eeb4f7 |
| 2026-11-27T18:19:22Z | c07-q3-fb | duyu-1 | - | - | - | 2.24 | - | c4c7f46dc0eeb4f7 |
| 2026-11-27T18:19:24Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.04 | a7f58f9811684cd290bbbe6e11249d3f | 1caea42cc88d3783 |
| 2026-11-27T18:19:26Z | c07-q4-fb | duyu-1 | - | - | - | 3.04 | - | 1caea42cc88d3783 |
| 2026-11-27T19:03:05Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.72 | ee5262bc3b6f4571956185399ac7bb17 | a9f1ad9e4b5061ba |
| 2026-11-27T19:03:06Z | c01-ex1-tl | duyu-1 | - | - | - | 2.72 | - | a9f1ad9e4b5061ba |
| 2026-11-27T19:03:08Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.6 | e274e4bb95c84cf3b1a910ed4472c249 | 8cb6fdaced95ba77 |
| 2026-11-27T19:03:09Z | c02-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 8cb6fdaced95ba77 |
| 2026-11-27T19:03:11Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | 89af9c6b59124abc818455e17b32a17b | bad84b83334b7604 |
| 2026-11-27T19:03:11Z | c02-ex2-tl | duyu-1 | - | - | - | 1.6 | - | bad84b83334b7604 |
| 2026-11-27T19:03:14Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | 8978bf4552d94f09a1ecc6bd31eb21e7 | 0dc038cb401cc7d1 |
| 2026-11-27T19:03:15Z | c03-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 0dc038cb401cc7d1 |
| 2026-11-27T19:03:17Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | eca08500f1f9440b94b6551e0343ba84 | 5b55b650dd9e4916 |
| 2026-11-27T19:03:18Z | c03-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 5b55b650dd9e4916 |
| 2026-11-27T19:03:20Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.12 | cde5e74d01594cc090e8ef77b125a07a | 2e3d05d248cb0be2 |
| 2026-11-27T19:03:21Z | c04-ex1-tl | duyu-1 | - | - | - | 1.12 | - | 2e3d05d248cb0be2 |
| 2026-11-27T19:03:23Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.92 | 69fdc181c74e4a37868452f6fc55ddd1 | e67b1a3edcff9ca4 |
| 2026-11-27T19:03:24Z | c04-ex2-tl | duyu-1 | - | - | - | 1.92 | - | e67b1a3edcff9ca4 |
| 2026-11-27T19:03:26Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.56 | 1c912a77eed54b7d83259387e4c96203 | 2abc189e94e45ae9 |
| 2026-11-27T19:03:27Z | c05-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 2abc189e94e45ae9 |
| 2026-11-27T19:03:29Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.24 | c59eed51a4df448cae5bdee5694aac0d | 37322f551a16167a |
| 2026-11-27T19:03:30Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 37322f551a16167a |
| 2026-11-27T19:03:32Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 1.92 | ffa01aa51bdc43d895a93bc7ad5c4be8 | 88408b139fe655ed |
| 2026-11-27T19:03:33Z | c05-ex3-tl | duyu-1 | - | - | - | 1.92 | - | 88408b139fe655ed |
| 2026-11-27T19:03:36Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.72 | 8812aa093c024e219f2290661e16561b | e924d456230190d7 |
| 2026-11-27T19:03:37Z | c05-ex4-tl | duyu-1 | - | - | - | 2.72 | - | e924d456230190d7 |
| 2026-11-27T19:03:38Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.6 | fb90efd96098464e9b805013d3f16701 | cbe1a7075b9f0692 |
| 2026-11-27T19:03:39Z | c05-ex5-tl | duyu-1 | - | - | - | 1.6 | - | cbe1a7075b9f0692 |
| 2026-11-27T19:03:41Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.28 | 78e83eb0b1e64c3fac9e3b45d814c905 | 41ccb1962f2a46fa |
| 2026-11-27T19:03:42Z | c06-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 41ccb1962f2a46fa |
| 2026-11-27T19:03:44Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | dde54bbb6a9f425d9c244bda3815f094 | a084e5f47c406ce2 |
| 2026-11-27T19:03:45Z | c06-ex3-tl | duyu-1 | - | - | - | 1.44 | - | a084e5f47c406ce2 |
