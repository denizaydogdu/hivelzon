# G-C1-06-impersonal-passive PROMPTS

Ders: Kişisiz edilgen (impersonal passive): It is said that…, He is believed to… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: önceki dalgaların dersleri (`G-B2-01-passive`, `G-B1-01-present-perfect-experience`, `G-A2-04-past-simple-regular`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, sade ve suçlamasız (C düzeyinde de). İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. C1/C2 kapsaması Octanove listesi depoda olmadığı için denetlenmedi (`grammar_lint.py` uyarısı).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h082.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:39:27Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 10.74 | 62784036127b45978b6863450cf2612e | 8a1db58b465b7655 |
| 2026-10-14T14:39:28Z | c01-tr | duyu-1 | - | - | - | 10.74 | - | 8a1db58b465b7655 |
| 2026-10-14T14:39:31Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 198 | 13.95 | e877ecb283f142adb1e14254429216db | 5a20740bfacb9f43 |
| 2026-10-14T14:39:32Z | c02-tr | duyu-1 | - | - | - | 13.95 | - | 5a20740bfacb9f43 |
| 2026-10-14T14:39:35Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 11.07 | 46d737a05a7441e4946c1c0376ed8dde | 38c97319c354bc9d |
| 2026-10-14T14:39:37Z | c03-tr | duyu-1 | - | - | - | 11.07 | - | 38c97319c354bc9d |
| 2026-10-14T14:39:40Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 208 | 14.27 | be39761506a84b0fb1334cc183cee63c | d3c84b3aaed03fab |
| 2026-10-14T14:39:41Z | c04-tr | duyu-1 | - | - | - | 14.27 | - | d3c84b3aaed03fab |
| 2026-10-14T14:39:44Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 196 | 12.35 | 3ae570f644a74b85a429828d375e4590 | 53a9bd3689a5b236 |
| 2026-10-14T14:39:46Z | c06-tr | duyu-1 | - | - | - | 12.35 | - | 53a9bd3689a5b236 |
| 2026-10-14T14:39:49Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 204 | 15.87 | c15d1bfda0ac449196dc20d8bb612d05 | 2ef6bf7667509b54 |
| 2026-10-14T14:39:51Z | c08-tr | duyu-1 | - | - | - | 15.87 | - | 2ef6bf7667509b54 |
| 2026-11-20T16:02:04Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 12.8 | 66aac3131bd548be8e5e6d0725e545d3 | b96bf53b80c10fd4 |
| 2026-11-20T16:02:09Z | c01-tr | duyu-1 | - | - | - | 12.8 | - | b96bf53b80c10fd4 |
| 2026-11-20T16:10:48Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 12.67 | a373b71ab26d40bea9b9deff9071d965 | a708bbbbf348f6c1 |
| 2026-11-20T16:10:56Z | c01-tr | duyu-1 | - | - | - | 12.67 | - | a708bbbbf348f6c1 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:09:05Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 62 | 884e4c5dc61c2235 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:09:08Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 45 | 3948f7209db608d5 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:09:10Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 45 | 7a6bc4287155b5e4 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:09:11Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 43 | 661290f267141e0b | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:09:13Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 51 | cc7b47c0a4f26b6d | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:09:16Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 49 | 1c417acf8965be2a | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:09:19Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 37 | 6753f45d2a72765a | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:09:21Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 7331901779e89f6a | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:09:23Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | e4322547972c54c0 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:09:24Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 22 | abb15031d60dc4f2 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:09:26Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 27 | a05f5265eabc59dc | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:09:27Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | 1d156dc10a6b499d | audio/en/c06-ex3.mp3 |
| 2026-11-26T14:09:29Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 38 | 5d7e0ee1a005f2b9 | audio/en/c07-q5.mp3 |
| 2026-11-27T18:31:26Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.56 | ec00c1d46c5f4dff946434bd72354819 | 712488e5d1610fb5 |
| 2026-11-27T18:31:27Z | c07-q1-fb | duyu-1 | - | - | - | 2.56 | - | 712488e5d1610fb5 |
| 2026-11-27T18:31:30Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 57 | 4.0 | f763997dbb3c44ba9cbf91d90949b3d9 | 2252dc77bc76c550 |
| 2026-11-27T18:31:31Z | c07-q2-fb | duyu-1 | - | - | - | 4.0 | - | 2252dc77bc76c550 |
| 2026-11-27T18:31:33Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 3.36 | 7253aa1d2c724b49a6e6828a325513c2 | cd9633c44e8e10f3 |
| 2026-11-27T18:31:34Z | c07-q3-fb | duyu-1 | - | - | - | 3.36 | - | cd9633c44e8e10f3 |
| 2026-11-27T18:31:37Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 57 | 4.0 | c9b43259a6864c68a4925ed5808fdddc | a5866e25da4321ea |
| 2026-11-27T18:31:38Z | c07-q4-fb | duyu-1 | - | - | - | 4.0 | - | a5866e25da4321ea |
| 2026-11-27T19:39:36Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 3.2 | 993e7d82f82544558768e2e0e2a61d7d | 05f60e6215171b4e |
| 2026-11-27T19:39:37Z | c01-ex1-tl | duyu-1 | - | - | - | 3.2 | - | 05f60e6215171b4e |
| 2026-11-27T19:39:39Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.56 | 6dde1bae44584abf9df3013b84f9eb94 | 7d6f923ada2498c0 |
| 2026-11-27T19:39:40Z | c02-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 7d6f923ada2498c0 |
| 2026-11-27T19:39:42Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.72 | d4d2e80a47c44f6ca6650fb8616198af | 7f6289081375d09d |
| 2026-11-27T19:39:43Z | c03-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 7f6289081375d09d |
| 2026-11-27T19:39:46Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 2.4 | 703af6323ee94593b14c61de27fae53c | 5d87d6348a2c3f03 |
| 2026-11-27T19:39:47Z | c04-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 5d87d6348a2c3f03 |
| 2026-11-27T19:39:49Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 47 | 3.04 | b764ecbd4dbf453898eb35fc798dcbbe | ae9581d8fe3f7570 |
| 2026-11-27T19:39:50Z | c05-ex1-tl | duyu-1 | - | - | - | 3.04 | - | ae9581d8fe3f7570 |
| 2026-11-27T19:39:52Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.4 | 8052467c62f8483fb9cba3a769d181b9 | 667fc27c330033cf |
| 2026-11-27T19:39:53Z | c05-ex2-tl | duyu-1 | - | - | - | 2.4 | - | 667fc27c330033cf |
| 2026-11-27T19:39:55Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.88 | ccfebc2daaf64edba86bf6a077042011 | f645a126ca265e52 |
| 2026-11-27T19:39:56Z | c05-ex3-tl | duyu-1 | - | - | - | 2.88 | - | f645a126ca265e52 |
| 2026-11-27T19:39:58Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 3.2 | ed04fe68b5e24065ba4f77e21bec42f8 | 475c2fc5e5e61e9f |
| 2026-11-27T19:39:59Z | c05-ex4-tl | duyu-1 | - | - | - | 3.2 | - | 475c2fc5e5e61e9f |
| 2026-11-27T19:40:02Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 4.16 | 4edab41f691a4d9f9bdf8cef67537350 | bce88e8cbd23e8a4 |
| 2026-11-27T19:40:03Z | c05-ex5-tl | duyu-1 | - | - | - | 4.16 | - | bce88e8cbd23e8a4 |
| 2026-11-27T19:40:05Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.72 | aa5876e5e7c24ef2a58a3f67f3701771 | 157893a09e3c24c1 |
| 2026-11-27T19:40:06Z | c06-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 157893a09e3c24c1 |
| 2026-11-27T19:40:08Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.6 | cf69265359ff41e49f877b5fb5cacf5e | 0dd89d92c614e070 |
| 2026-11-27T19:40:09Z | c06-ex3-tl | duyu-1 | - | - | - | 1.6 | - | 0dd89d92c614e070 |
| 2026-11-27T19:40:11Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.4 | 5c1e5004ac664cb09bc2405ddd803007 | ec1a423e87332c8a |
| 2026-11-27T19:40:13Z | c07-q5-tl | duyu-1 | - | - | - | 2.4 | - | ec1a423e87332c8a |
