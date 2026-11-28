# G-B1-07-zero-first-conditional PROMPTS

Ders: Koşul cümleleri: 0 ve 1. tip · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:07:48Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 153 | 9.95 | 52d3dc6cc30a462498ab56f7631f5be0 | c60c036d55157213 |
| 2026-10-14T14:07:49Z | c01-tr | duyu-1 | - | - | - | 9.95 | - | c60c036d55157213 |
| 2026-10-14T14:07:52Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 181 | 11.55 | 047104b3261d452ba88611439d8aa968 | f72cb064abf5e34d |
| 2026-10-14T14:07:53Z | c02-tr | duyu-1 | - | - | - | 11.55 | - | f72cb064abf5e34d |
| 2026-10-14T14:07:56Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 192 | 12.99 | 856c88a211474ce19632040967c3cd04 | 8e292f5f498d8193 |
| 2026-10-14T14:07:57Z | c03-tr | duyu-1 | - | - | - | 12.99 | - | 8e292f5f498d8193 |
| 2026-10-14T14:08:00Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 12.03 | 560ad69ad3b142e6a9e60768a67da47d | 500a1b51aa441cd7 |
| 2026-10-14T14:08:02Z | c04-tr | duyu-1 | - | - | - | 12.03 | - | 500a1b51aa441cd7 |
| 2026-10-14T14:08:04Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 228 | 16.28 | 7e292f0cf69548c19320a4bc99e9789b | 59dc589e59f37c81 |
| 2026-10-14T14:08:06Z | c06-tr | duyu-1 | - | - | - | 16.28 | - | 59dc589e59f37c81 |
| 2026-10-14T14:08:09Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 86 | 5.12 | b88778ee9eed4be9b533fccb669fa9fb | 100b79a26ded3d83 |
| 2026-10-14T14:08:10Z | c08-tr | duyu-1 | - | - | - | 5.12 | - | 100b79a26ded3d83 |
| 2026-10-14T14:08:12Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 164 | 10.41 | 5761ada4f4a544458bbd07889100b1cd | 0472b39de17af7a9 |
| 2026-10-14T14:08:13Z | c09-tr | duyu-1 | - | - | - | 10.41 | - | 0472b39de17af7a9 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T13:59:53Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 1a254e83719c6fea | audio/en/c01-ex1.mp3 |
| 2026-11-26T13:59:55Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 173fe2b3c1a66f2e | audio/en/c02-ex1.mp3 |
| 2026-11-26T13:59:57Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 7144be90d42b7842 | audio/en/c03-ex1.mp3 |
| 2026-11-26T13:59:59Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 5e5840d539e47197 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:00:00Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | 400ae17955ed36fa | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:00:02Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | 7f73010687e7eeb8 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:00:04Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | 7a2362317cd66d64 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:00:06Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | f9c6c860147a3d27 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:00:07Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | ca01413e376f2ec7 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:00:09Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 27faa0f3cc6e090b | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:00:11Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 295c084e178c0fd2 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:00:12Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 7008a77df1022aeb | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:25:30Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.56 | 1f04aa3c968942f2b6f9c9a1e23c9858 | 5fba1ba284e671a2 |
| 2026-11-27T18:25:31Z | c07-q1-fb | duyu-1 | - | - | - | 2.56 | - | 5fba1ba284e671a2 |
| 2026-11-27T18:25:34Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 47 | 4.0 | ca7ba09bbd8b4e78bd17ad482bf9b642 | 00ce691162234648 |
| 2026-11-27T18:25:35Z | c07-q2-fb | duyu-1 | - | - | - | 4.0 | - | 00ce691162234648 |
| 2026-11-27T18:25:37Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 1.92 | 39de9eb9e641467bae8f1aa3267d8475 | b21af8134ccbba8c |
| 2026-11-27T18:25:38Z | c07-q3-fb | duyu-1 | - | - | - | 1.92 | - | b21af8134ccbba8c |
| 2026-11-27T18:25:40Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.88 | c84615b9e88845af9dc3627547ce26ee | d72853a116a72ec0 |
| 2026-11-27T18:25:41Z | c07-q4-fb | duyu-1 | - | - | - | 2.88 | - | d72853a116a72ec0 |
| 2026-11-27T19:21:56Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.72 | 142bf5c7712d4a84ade932458c377a82 | d77549e87d8e9564 |
| 2026-11-27T19:21:58Z | c01-ex1-tl | duyu-1 | - | - | - | 2.72 | - | d77549e87d8e9564 |
| 2026-11-27T19:22:00Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.76 | d523a8e18f454f56bab8eb7b82884778 | ceeecfd2bd1e4a72 |
| 2026-11-27T19:22:01Z | c02-ex1-tl | duyu-1 | - | - | - | 1.76 | - | ceeecfd2bd1e4a72 |
| 2026-11-27T19:22:03Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 3.2 | cb80366e036843ee871fad20c9637af5 | 7eca4529961c160d |
| 2026-11-27T19:22:04Z | c03-ex1-tl | duyu-1 | - | - | - | 3.2 | - | 7eca4529961c160d |
| 2026-11-27T19:22:07Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.56 | 16f30f8ba43f4fb4b8320a3b468cc0c9 | 4f2a98b6038a8a2d |
| 2026-11-27T19:22:08Z | c04-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 4f2a98b6038a8a2d |
| 2026-11-27T19:22:10Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 3.18 | 45853b61668c443ea60fafb128eaf72e | ae6672c536b385ba |
| 2026-11-27T19:22:11Z | c04-ex2-tl | duyu-1 | - | - | - | 3.18 | - | ae6672c536b385ba |
| 2026-11-27T19:22:13Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 3.52 | d653092fe8304f2fb66d08b7a08d7887 | 71ce49849f57b9d6 |
| 2026-11-27T19:22:14Z | c05-ex1-tl | duyu-1 | - | - | - | 3.52 | - | 71ce49849f57b9d6 |
| 2026-11-27T19:22:17Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.24 | e58f6bd869fe42bc8c2526a481f2448c | 6e637435209c4ece |
| 2026-11-27T19:22:17Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 6e637435209c4ece |
| 2026-11-27T19:22:20Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | 3b99c2bb34a9426c85ce90e5a96b68c0 | 80ee713a44cc1c42 |
| 2026-11-27T19:22:21Z | c05-ex3-tl | duyu-1 | - | - | - | 2.08 | - | 80ee713a44cc1c42 |
| 2026-11-27T19:22:23Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.24 | 74609a8f97924718baa7a7c2c3a6db0a | ec1323c5e7b4717f |
| 2026-11-27T19:22:24Z | c05-ex4-tl | duyu-1 | - | - | - | 2.24 | - | ec1323c5e7b4717f |
| 2026-11-27T19:22:26Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.24 | 6c6052f3f8424b84bb8f52551e5fb691 | 8ae6a06169b23858 |
| 2026-11-27T19:22:27Z | c05-ex5-tl | duyu-1 | - | - | - | 2.24 | - | 8ae6a06169b23858 |
| 2026-11-27T19:22:29Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.4 | 11f47e2bca3448b1bd9a68fccb8e12d9 | d0916ef1de3135d3 |
| 2026-11-27T19:22:30Z | c06-ex1-tl | duyu-1 | - | - | - | 2.4 | - | d0916ef1de3135d3 |
| 2026-11-27T19:22:33Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 3.04 | d3988c39998e4318bfa5e332c9a0c501 | 3fdb169e44945d61 |
| 2026-11-27T19:22:34Z | c06-ex2-tl | duyu-1 | - | - | - | 3.04 | - | 3fdb169e44945d61 |
