# G-B2-10-causative PROMPTS

Ders: Ettirgen yapı (causative): have ya da get something done · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:11:51Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 135 | 10.08 | aa25469b56a144dd98e50b51ce91e8f6 | c449ab069a4a64d7 |
| 2026-10-14T14:11:52Z | c01-tr | duyu-1 | - | - | - | 10.08 | - | c449ab069a4a64d7 |
| 2026-10-14T14:11:55Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 12.83 | 2573173ec1a242e88ab31bca13f8c200 | c00a16df513a1390 |
| 2026-10-14T14:11:57Z | c02-tr | duyu-1 | - | - | - | 12.83 | - | c00a16df513a1390 |
| 2026-10-14T14:12:00Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 10.11 | e977143317304fc7a8e0046224ca4c21 | af978411d52adc06 |
| 2026-10-14T14:12:01Z | c03-tr | duyu-1 | - | - | - | 10.11 | - | af978411d52adc06 |
| 2026-10-14T14:12:04Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 92 | 7.04 | 25873e55ea5048dfb319b16d78fd7cc1 | 8f24d001e3efc360 |
| 2026-10-14T14:12:05Z | c04-tr | duyu-1 | - | - | - | 7.04 | - | 8f24d001e3efc360 |
| 2026-10-14T14:12:07Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 193 | 13.63 | 2684f2c827ea46739da9bd308e0adea9 | d45923af5bfa6a0a |
| 2026-10-14T14:12:08Z | c06-tr | duyu-1 | - | - | - | 13.63 | - | d45923af5bfa6a0a |
| 2026-10-14T14:12:11Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 107 | 8.8 | 00b581fed05843148c1b354da4c2e751 | 961593f2bd862409 |
| 2026-10-14T14:12:13Z | c08-tr | duyu-1 | - | - | - | 8.8 | - | 961593f2bd862409 |
| 2026-11-20T16:00:56Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 9.76 | 72303f1745694d48bdc8e91936639207 | 1fbb5d945df6f82e |
| 2026-11-20T16:00:58Z | c01-tr | duyu-1 | - | - | - | 9.76 | - | 1fbb5d945df6f82e |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:05:29Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 354b84b7e0bafbaa | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:05:31Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 14 | fc9fcbd08f22f31f | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:05:32Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 18 | ce0cb0bc730793d3 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:05:34Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | dc33a6a60210fafd | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:05:36Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 309544786bfdc32c | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:05:37Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | e9abe3d9561b4347 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:05:39Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 348996df964c71b3 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:05:41Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 89f76b30ad47169c | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:05:42Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 5f7bf1a6219f323d | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:05:44Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | 1a434cb87f44fc18 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:05:46Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | b3620e2192f89bc2 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:05:48Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | e856bb674fc3d30a | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:05:49Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | 33367ed073a6ad73 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:05:51Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 6fe1c25c669e434a | audio/en/c07-q5.mp3 |
| 2026-11-27T18:29:28Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 3.84 | 45df8ab672e74dd398396dd13e94be08 | d8ef064f12bc8074 |
| 2026-11-27T18:29:30Z | c07-q1-fb | duyu-1 | - | - | - | 3.84 | - | d8ef064f12bc8074 |
| 2026-11-27T18:29:32Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 3.84 | 399f215d98594e38bb3b2f38f415b7d6 | 5d7f034166f97d5d |
| 2026-11-27T18:29:33Z | c07-q2-fb | duyu-1 | - | - | - | 3.84 | - | 5d7f034166f97d5d |
| 2026-11-27T18:29:36Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.72 | b9d29aee939b460dad747e2233fc8eab | 26b71ab6195c3f6b |
| 2026-11-27T18:29:38Z | c07-q3-fb | duyu-1 | - | - | - | 2.72 | - | 26b71ab6195c3f6b |
| 2026-11-27T18:29:40Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 57 | 4.48 | d7c0f54b9f8b4405b9081a173708f132 | 9c996f860103f85c |
| 2026-11-27T18:29:42Z | c07-q4-fb | duyu-1 | - | - | - | 4.48 | - | 9c996f860103f85c |
| 2026-11-27T19:33:44Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.44 | 152d46ab6832481691b46cde37e0df1a | 664e0c728d202ef9 |
| 2026-11-27T19:33:45Z | c01-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 664e0c728d202ef9 |
| 2026-11-27T19:33:47Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.88 | 7d1aa30eff434b3f9c7fba995b52765f | ccc0b7a96bf5388e |
| 2026-11-27T19:33:48Z | c02-ex1-tl | duyu-1 | - | - | - | 2.88 | - | ccc0b7a96bf5388e |
| 2026-11-27T19:33:50Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.44 | 734b4e61bb804d8184a40a7510e4ea21 | 97fd13093f261117 |
| 2026-11-27T19:33:51Z | c02-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 97fd13093f261117 |
| 2026-11-27T19:33:53Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.4 | 278dd851218f49cc88fbff648f3730e9 | 6e8da9d4ce60f093 |
| 2026-11-27T19:33:54Z | c03-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 6e8da9d4ce60f093 |
| 2026-11-27T19:33:56Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.24 | 0a74febd6cef4a189115d5eea1fc58da | 40569f3e2ab3fb2d |
| 2026-11-27T19:33:57Z | c04-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 40569f3e2ab3fb2d |
| 2026-11-27T19:33:59Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.08 | 72a2c8dab93a43119b5f6b180c283f78 | d20e1a80d0d1e84b |
| 2026-11-27T19:34:00Z | c04-ex2-tl | duyu-1 | - | - | - | 2.08 | - | d20e1a80d0d1e84b |
| 2026-11-27T19:34:03Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 3.68 | 6f300a27707c43c88c396deb3af59e11 | f84e3b6578821afa |
| 2026-11-27T19:34:04Z | c05-ex1-tl | duyu-1 | - | - | - | 3.68 | - | f84e3b6578821afa |
| 2026-11-27T19:34:06Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 3.04 | b9747d84bad14872baa0b9d01e2144b5 | 2c3d095e487973a2 |
| 2026-11-27T19:34:07Z | c05-ex2-tl | duyu-1 | - | - | - | 3.04 | - | 2c3d095e487973a2 |
| 2026-11-27T19:34:10Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 3.2 | 6e97bceaa07b43cd9c27707f26709b75 | fe17b0c53b959fab |
| 2026-11-27T19:34:11Z | c05-ex3-tl | duyu-1 | - | - | - | 3.2 | - | fe17b0c53b959fab |
| 2026-11-27T19:34:13Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.08 | a403d7430bb046ea9c0be6dc0f1f8177 | 5bd6429e372b6b6a |
| 2026-11-27T19:34:14Z | c05-ex4-tl | duyu-1 | - | - | - | 2.08 | - | 5bd6429e372b6b6a |
| 2026-11-27T19:34:17Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 3.55 | 2304c2bc215e4c7a8da2b74d8742c370 | 85a4a4093d214a76 |
| 2026-11-27T19:34:18Z | c05-ex5-tl | duyu-1 | - | - | - | 3.55 | - | 85a4a4093d214a76 |
| 2026-11-27T19:34:20Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.24 | 9aed5f2e4deb405497774863b81b632c | 5535eed242d15151 |
| 2026-11-27T19:34:21Z | c06-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 5535eed242d15151 |
| 2026-11-27T19:34:23Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 3.2 | fc3820da5c8b49a9882fa66cf5867f8d | 476cfab582f0222b |
| 2026-11-27T19:34:24Z | c06-ex2-tl | duyu-1 | - | - | - | 3.2 | - | 476cfab582f0222b |
| 2026-11-27T19:34:27Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.56 | f2446770eb5044e9b23165c1f3166452 | b9c5371b485bd75b |
| 2026-11-27T19:34:28Z | c07-q5-tl | duyu-1 | - | - | - | 2.56 | - | b9c5371b485bd75b |
