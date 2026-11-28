# G-C1-03-mixed-conditionals PROMPTS

Ders: Karışık koşul cümleleri (mixed conditionals) · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:38:09Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 9.6 | b0b084baaa324e929f404360eff4613a | f4d1961b62ea3945 |
| 2026-10-14T14:38:11Z | c01-tr | duyu-1 | - | - | - | 9.6 | - | f4d1961b62ea3945 |
| 2026-10-14T14:38:13Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 177 | 11.55 | a498982bb4e849caafae84ceb3c675df | aac0e11e05f269de |
| 2026-10-14T14:38:14Z | c02-tr | duyu-1 | - | - | - | 11.55 | - | aac0e11e05f269de |
| 2026-10-14T14:38:17Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 204 | 15.84 | 4a258530ed8640fe99b794d6c0812951 | 436c8d08e4fd3f62 |
| 2026-10-14T14:38:19Z | c03-tr | duyu-1 | - | - | - | 15.84 | - | 436c8d08e4fd3f62 |
| 2026-10-14T14:38:22Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 160 | 13.03 | a34705ad0e954ce3af153b4771ce7598 | 2c2b869881f57084 |
| 2026-10-14T14:38:23Z | c04-tr | duyu-1 | - | - | - | 13.03 | - | 2c2b869881f57084 |
| 2026-10-14T14:38:26Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 226 | 14.27 | cbee391c460b4ee3be17a525fe8c191a | d46e73277dc15137 |
| 2026-10-14T14:38:27Z | c06-tr | duyu-1 | - | - | - | 14.27 | - | d46e73277dc15137 |
| 2026-10-14T14:38:30Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 149 | 10.27 | d2fba8e4d1aa46e6b0a9cd1f35d92228 | 7138f767339bb901 |
| 2026-10-14T14:38:32Z | c08-tr | duyu-1 | - | - | - | 10.27 | - | 7138f767339bb901 |
| 2026-11-20T16:01:30Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 11.2 | 14598f4c68a644b68f018441bcdc2513 | 45cd783f67b2a44f |
| 2026-11-20T16:01:33Z | c01-tr | duyu-1 | - | - | - | 11.2 | - | 45cd783f67b2a44f |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:07:48Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 63 | 7ae62db41c87b426 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:07:50Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 51 | 8e9253d6aff803bf | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:07:53Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 60 | c00c26e52d4e565c | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:07:56Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 51 | 791b99def348be36 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:07:58Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 52 | 29492c6f1a8f526b | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:08:00Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 56 | b83af95f2961fd6b | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:08:03Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 60 | 76f098ecb31a5874 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:08:05Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 53 | bd0444003f6f86c4 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:08:08Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 50 | a3260a54b50a17f2 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:08:10Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 49 | 510d3fe3c4f9a13f | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:08:11Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 38 | 251a5be46d43e8ee | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:30:42Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.72 | 8798932f69124c4c968f8b2289377c64 | 54dbfdf33899c509 |
| 2026-11-27T18:30:43Z | c07-q1-fb | duyu-1 | - | - | - | 2.72 | - | 54dbfdf33899c509 |
| 2026-11-27T18:30:46Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 72 | 4.8 | 14726de5be024c8080d73a93a9c57555 | 329b04065811c115 |
| 2026-11-27T18:30:48Z | c07-q2-fb | duyu-1 | - | - | - | 4.8 | - | 329b04065811c115 |
| 2026-11-27T18:30:50Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 3.04 | 63e8e5b39cc14f87b5807a4f35150bcc | 55fafa12419ab0f4 |
| 2026-11-27T18:30:51Z | c07-q3-fb | duyu-1 | - | - | - | 3.04 | - | 55fafa12419ab0f4 |
| 2026-11-27T18:30:54Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 3.52 | d7c86d16130b48e8be5036761a8f3805 | 02117d0c70c18e24 |
| 2026-11-27T18:30:55Z | c07-q4-fb | duyu-1 | - | - | - | 3.52 | - | 02117d0c70c18e24 |
| 2026-11-27T19:37:30Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 4.16 | 3f389a205d7c4820b83a2f1d60626b1b | 6f529e74671bbf56 |
| 2026-11-27T19:37:31Z | c01-ex1-tl | duyu-1 | - | - | - | 4.16 | - | 6f529e74671bbf56 |
| 2026-11-27T19:37:33Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.72 | 3b8537bd7d9f4208a66d93448c6fa98e | 1b39b8b28a6e989f |
| 2026-11-27T19:37:34Z | c02-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 1b39b8b28a6e989f |
| 2026-11-27T19:37:37Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 55 | 4.16 | e60184b280264e048df65d09cc84235a | c222e633a51292ea |
| 2026-11-27T19:37:38Z | c03-ex1-tl | duyu-1 | - | - | - | 4.16 | - | c222e633a51292ea |
| 2026-11-27T19:37:40Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 3.2 | 51f3b1c5139c4c93a0b9638e3133607e | 2f47132f0f80dc88 |
| 2026-11-27T19:37:41Z | c04-ex1-tl | duyu-1 | - | - | - | 3.2 | - | 2f47132f0f80dc88 |
| 2026-11-27T19:37:43Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.88 | e7577da239264805ad7d514d127d6b32 | 7360ebd88fa27dca |
| 2026-11-27T19:37:44Z | c05-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 7360ebd88fa27dca |
| 2026-11-27T19:37:47Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 3.84 | 56af93a983a14494aada67f6c2e7e443 | 479cbe9150600ee0 |
| 2026-11-27T19:37:48Z | c05-ex2-tl | duyu-1 | - | - | - | 3.84 | - | 479cbe9150600ee0 |
| 2026-11-27T19:37:50Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 55 | 3.84 | fe3ccbddef404afcbaf6cf3de5cb45e5 | 4b8ec9f631b43f64 |
| 2026-11-27T19:37:51Z | c05-ex3-tl | duyu-1 | - | - | - | 3.84 | - | 4b8ec9f631b43f64 |
| 2026-11-27T19:37:53Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.88 | 2e72239824894586aa1f3d4c53821aad | 04dab603d11c1e56 |
| 2026-11-27T19:37:54Z | c05-ex4-tl | duyu-1 | - | - | - | 2.88 | - | 04dab603d11c1e56 |
| 2026-11-27T19:37:57Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 47 | 4.8 | 7a865a57bf5e4f3a92abdf1ddee87482 | 6f710a819efb114d |
| 2026-11-27T19:37:58Z | c05-ex5-tl | duyu-1 | - | - | - | 4.8 | - | 6f710a819efb114d |
| 2026-11-27T19:38:00Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 3.36 | 785f2974fb7e45a28cbcf93b1d492c6b | 8a2a16ff937d23c5 |
| 2026-11-27T19:38:01Z | c06-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 8a2a16ff937d23c5 |
| 2026-11-27T19:38:03Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.24 | b9161fa91ddf41749079bff337e72ea8 | 9cac31f9604c72c7 |
| 2026-11-27T19:38:04Z | c06-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 9cac31f9604c72c7 |
