# G-A1-04-the PROMPTS

Ders: the: ikimizin bildiği şey · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:04:51Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 9.93 | acce5f19ba3a4fe28a28108a89d0e7c6 | 861e44d72abcd045 |
| 2026-10-14T13:04:52Z | c01-tr | duyu-1 | - | - | - | 9.93 | - | 861e44d72abcd045 |
| 2026-10-14T13:04:54Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 177 | 10.88 | 0de035e32d304686901a8f742f4d1d57 | a14ae1e6acedfbb8 |
| 2026-10-14T13:04:55Z | c02-tr | duyu-1 | - | - | - | 10.88 | - | a14ae1e6acedfbb8 |
| 2026-10-14T13:04:58Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 160 | 9.47 | 002ea9cf01764726a21018aedaedf22d | 5bc5b00f6764e9fb |
| 2026-10-14T13:04:59Z | c03-tr | duyu-1 | - | - | - | 9.47 | - | 5bc5b00f6764e9fb |
| 2026-10-14T13:05:02Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 9.12 | b2e88369023c457b81cd0cf1fde026d9 | bd9288834e4b8d36 |
| 2026-10-14T13:05:03Z | c04-tr | duyu-1 | - | - | - | 9.12 | - | bd9288834e4b8d36 |
| 2026-10-14T13:05:06Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 169 | 12.12 | 02e1d84ae6a448fcabc12c93491c4671 | ad18817109f79fff |
| 2026-10-14T13:05:07Z | c06-tr | duyu-1 | - | - | - | 12.12 | - | ad18817109f79fff |
| 2026-10-14T13:05:09Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 75 | 4.8 | 8c8ae18de586473dbfd4993e4358d81b | c4b61d081b412ff1 |
| 2026-10-14T13:05:10Z | c08-tr | duyu-1 | - | - | - | 4.8 | - | c4b61d081b412ff1 |
| 2026-10-14T13:05:12Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 8.51 | b888111b25af47a3af77a860a9f50080 | 846a0f4a07647124 |
| 2026-10-14T13:05:13Z | c09-tr | duyu-1 | - | - | - | 8.51 | - | 846a0f4a07647124 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:53:51Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | 9242eb956cf0696b | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:53:52Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | dcec1b9b3638698a | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:53:53Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 8b2af896f0625e1d | audio/en/c03-ex2.mp3 |
| 2026-10-14T14:53:54Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 6b93369e272ee424 | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:53:55Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 31 | 7df38bb1010b964b | audio/en/c04-ex2.mp3 |
| 2026-10-14T14:53:56Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | 197fbdee66010f84 | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:53:57Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | f5c38121d555aab2 | audio/en/c05-ex2.mp3 |
| 2026-10-14T14:53:59Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 31 | d4b64e26992ccf42 | audio/en/c05-ex3.mp3 |
| 2026-10-14T14:54:00Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | a6729f05cd0ad9a3 | audio/en/c05-ex4.mp3 |
| 2026-10-14T14:54:01Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | eb946ec174d554d4 | audio/en/c05-ex5.mp3 |
| 2026-10-14T14:54:02Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 30 | 7a8e21ca6fafd001 | audio/en/c06-ex2.mp3 |
| 2026-10-14T14:54:03Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | a18577f8de1202dd | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:17:44Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 58 | 3.04 | cab1122427f14c8ab13846b2a5593e92 | 7dcfc1a59900cff1 |
| 2026-11-27T18:17:45Z | c07-q1-fb | duyu-1 | - | - | - | 3.04 | - | 7dcfc1a59900cff1 |
| 2026-11-27T18:17:47Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 3.36 | ec8678988be141f5b5bae54b97771231 | 16af6114700e04e3 |
| 2026-11-27T18:17:48Z | c07-q2-fb | duyu-1 | - | - | - | 3.36 | - | 16af6114700e04e3 |
| 2026-11-27T18:17:50Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.08 | e9c7a9e9e38544208744f7326fa209ce | 25ac632f14e6e60f |
| 2026-11-27T18:17:51Z | c07-q3-fb | duyu-1 | - | - | - | 2.08 | - | 25ac632f14e6e60f |
| 2026-11-27T18:17:54Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 55 | 3.84 | 4a4415a84bd244f9a8ef8e7e2853b2b0 | ba0dcd55032d9d07 |
| 2026-11-27T18:17:55Z | c07-q4-fb | duyu-1 | - | - | - | 3.84 | - | ba0dcd55032d9d07 |
| 2026-11-27T18:58:08Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.24 | e114564f87e9495b8566249d0b5aac7f | 8dbedf2a05d0f4a1 |
| 2026-11-27T18:58:09Z | c01-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 8dbedf2a05d0f4a1 |
| 2026-11-27T18:58:12Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | e940ca1305504b468fd1a19275d939d2 | eeccb6fa581735eb |
| 2026-11-27T18:58:12Z | c03-ex1-tl | duyu-1 | - | - | - | 1.28 | - | eeccb6fa581735eb |
| 2026-11-27T18:58:14Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.28 | 8220706eebd944fc8f698eeb2f842c4f | 9473a9675984fb82 |
| 2026-11-27T18:58:15Z | c03-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 9473a9675984fb82 |
| 2026-11-27T18:58:17Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.28 | 1f2ac962bff64e46bde97094c7e6e77c | d9bb79bdca6f58c2 |
| 2026-11-27T18:58:18Z | c04-ex1-tl | duyu-1 | - | - | - | 1.28 | - | d9bb79bdca6f58c2 |
| 2026-11-27T18:58:20Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | 89762bffb2284f5abc461165da341103 | 502b9f7c31c926f8 |
| 2026-11-27T18:58:21Z | c04-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 502b9f7c31c926f8 |
| 2026-11-27T18:58:23Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | 0fbf04fd67d4462582b3008b81778042 | 1e17fba3c373fbe6 |
| 2026-11-27T18:58:24Z | c05-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 1e17fba3c373fbe6 |
| 2026-11-27T18:58:26Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.08 | 27c99da9fedb4ce28f49bd75fa53d016 | cf7579d6122d7ecb |
| 2026-11-27T18:58:27Z | c05-ex2-tl | duyu-1 | - | - | - | 2.08 | - | cf7579d6122d7ecb |
| 2026-11-27T18:58:29Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.4 | 950ddff301a842e8bc8f43c6382e906e | 184489fd4668e0d4 |
| 2026-11-27T18:58:30Z | c05-ex3-tl | duyu-1 | - | - | - | 2.4 | - | 184489fd4668e0d4 |
| 2026-11-27T18:58:32Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.12 | 48c0f786679c4b8f870242b36fe56958 | 67749da8bab961d6 |
| 2026-11-27T18:58:33Z | c05-ex4-tl | duyu-1 | - | - | - | 1.12 | - | 67749da8bab961d6 |
| 2026-11-27T18:58:35Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 3.04 | 127cfd91b0af4f82b39e6fa50192fcf2 | c9f779692da7bff5 |
| 2026-11-27T18:58:36Z | c05-ex5-tl | duyu-1 | - | - | - | 3.04 | - | c9f779692da7bff5 |
| 2026-11-27T18:58:39Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.56 | ee15c36cd9484d5f997a9aa8016d5f80 | 4933db4beb6417fb |
| 2026-11-27T18:58:40Z | c06-ex2-tl | duyu-1 | - | - | - | 2.56 | - | 4933db4beb6417fb |
| 2026-11-27T18:58:42Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.92 | dfb1b1356bd5496080568fe1c3802dba | 617489c172884805 |
| 2026-11-27T18:58:43Z | c09-ex1-tl | duyu-1 | - | - | - | 1.92 | - | 617489c172884805 |
