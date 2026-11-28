# G-C1-02-cleft-sentences PROMPTS

Ders: Vurgulu yapılar (cleft sentences): It was… that…, What I need is… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:37:43Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 155 | 11.22 | 96552ea7cd1a4c66919f80de79525ea1 | 916ce8f964652533 |
| 2026-10-14T14:37:44Z | c01-tr | duyu-1 | - | - | - | 11.22 | - | 916ce8f964652533 |
| 2026-10-14T14:37:47Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 194 | 12.49 | a1dc758dba6c433f88b3593cdd4a00a1 | d5951c7c8285a2b7 |
| 2026-10-14T14:37:48Z | c02-tr | duyu-1 | - | - | - | 12.49 | - | d5951c7c8285a2b7 |
| 2026-10-14T14:37:51Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 245 | 16.38 | 984b1ea43bb840819326d4438c46ad0d | 13e0e0b06f784448 |
| 2026-10-14T14:37:53Z | c03-tr | duyu-1 | - | - | - | 16.38 | - | 13e0e0b06f784448 |
| 2026-10-14T14:37:56Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 181 | 11.55 | 1d01ac7fbe624f8ab6f77fcca5631bb2 | 63ff7439256b0ad8 |
| 2026-10-14T14:37:57Z | c04-tr | duyu-1 | - | - | - | 11.55 | - | 63ff7439256b0ad8 |
| 2026-10-14T14:38:00Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 228 | 14.75 | 683434b98007434c90c7237574fe3a4c | 4f195d8194090aa5 |
| 2026-10-14T14:38:02Z | c06-tr | duyu-1 | - | - | - | 14.75 | - | 4f195d8194090aa5 |
| 2026-10-14T14:38:05Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 132 | 8.16 | 03dda4db426048639b59af382e045372 | 0ab616b3890f3634 |
| 2026-10-14T14:38:06Z | c08-tr | duyu-1 | - | - | - | 8.16 | - | 0ab616b3890f3634 |
| 2026-11-20T16:01:20Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 146 | 10.75 | b613c850cf9740f990339e378e1d3363 | 822b1709a44e8a16 |
| 2026-11-20T16:01:23Z | c01-tr | duyu-1 | - | - | - | 10.75 | - | 822b1709a44e8a16 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:07:21Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 36 | 05ba219a31f0ed1e | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:07:23Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 20 | 2e7e5658c01f6ad8 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:07:25Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 97262a3197f4b239 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:07:27Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 36 | 8af7bdc4ddc567e5 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:07:29Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | c279e861e4415f82 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:07:30Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 37 | 0ce15c0d8f561cde | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:07:32Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 33 | 973432608a0d3a4b | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:07:34Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 30 | 9e10f3a7db04d94b | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:07:36Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | a89145b25a38e9f6 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:07:38Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 37 | c00f8931ff3f8961 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:07:40Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 30 | b7e254f0da05a438 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:07:41Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 35 | 17abbf697b0ede5d | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:07:43Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 25 | f680ca13676023cc | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:07:45Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 44 | 116fb7a54692eff5 | audio/en/c07-q5.mp3 |
| 2026-11-27T18:30:28Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.24 | 03ccc633c7e24c348882ac60b6d6ca33 | 4275af5f8b673e02 |
| 2026-11-27T18:30:29Z | c07-q1-fb | duyu-1 | - | - | - | 2.24 | - | 4275af5f8b673e02 |
| 2026-11-27T18:30:32Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 63 | 4.32 | 1381d6d3fb48431f950f38d3b0e9f953 | 869a15812ff854af |
| 2026-11-27T18:30:33Z | c07-q2-fb | duyu-1 | - | - | - | 4.32 | - | 869a15812ff854af |
| 2026-11-27T18:30:35Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 51 | 3.52 | de5c6cb5d8ec449b98bb4dd6def1d14c | b640835aed89922f |
| 2026-11-27T18:30:36Z | c07-q3-fb | duyu-1 | - | - | - | 3.52 | - | b640835aed89922f |
| 2026-11-27T18:30:39Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 65 | 4.0 | 0cf7b308f4e64572a48ce2d6bd4424c2 | de4e7391076ba320 |
| 2026-11-27T18:30:40Z | c07-q4-fb | duyu-1 | - | - | - | 4.0 | - | de4e7391076ba320 |
| 2026-11-27T19:36:45Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 3.52 | 8fb23118582046128047703f003d2347 | ccf21b4c7e320c8a |
| 2026-11-27T19:36:46Z | c01-ex1-tl | duyu-1 | - | - | - | 3.52 | - | ccf21b4c7e320c8a |
| 2026-11-27T19:36:48Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | 38226f8d065d43199686e12f9bb4a74d | 6478b2ba11873af8 |
| 2026-11-27T19:36:49Z | c02-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 6478b2ba11873af8 |
| 2026-11-27T19:36:51Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.6 | 19c9633b193c4820bf581db7294c7af1 | b43607a0db43991b |
| 2026-11-27T19:36:52Z | c02-ex2-tl | duyu-1 | - | - | - | 1.6 | - | b43607a0db43991b |
| 2026-11-27T19:36:54Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.08 | 6697f16addaf42d8bb87401aef573f70 | 8d415847ed7b3ba1 |
| 2026-11-27T19:36:55Z | c03-ex1-tl | duyu-1 | - | - | - | 2.08 | - | 8d415847ed7b3ba1 |
| 2026-11-27T19:36:58Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | 358459c97a814ca4a9e26ddbf489de0d | 27a0115619ad1b03 |
| 2026-11-27T19:36:59Z | c03-ex2-tl | duyu-1 | - | - | - | 1.92 | - | 27a0115619ad1b03 |
| 2026-11-27T19:37:01Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 2.88 | 5f24020a88184629b4812486a89323e3 | 50e8d549a4f5ae58 |
| 2026-11-27T19:37:02Z | c04-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 50e8d549a4f5ae58 |
| 2026-11-27T19:37:04Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.24 | ee4bab86034a44f588202c8f2cd1a07c | 4a8ad6537e57222d |
| 2026-11-27T19:37:05Z | c04-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 4a8ad6537e57222d |
| 2026-11-27T19:37:08Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.72 | 799f0e17e3cc4f0392b4b4b660d5622a | 9247f3b320537bf6 |
| 2026-11-27T19:37:09Z | c05-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 9247f3b320537bf6 |
| 2026-11-27T19:37:11Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.08 | 526103870f714e1993f1401c1eccbdc3 | 1b8e3c71c93e3202 |
| 2026-11-27T19:37:12Z | c05-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 1b8e3c71c93e3202 |
| 2026-11-27T19:37:14Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.56 | 86b6704ea30d4e0c98cb27a8977b52ca | da4c544070b60290 |
| 2026-11-27T19:37:14Z | c05-ex3-tl | duyu-1 | - | - | - | 2.56 | - | da4c544070b60290 |
| 2026-11-27T19:37:17Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.24 | 89f329ad466a4bd4bae7e25d177b5617 | a305ffb561710887 |
| 2026-11-27T19:37:18Z | c05-ex4-tl | duyu-1 | - | - | - | 2.24 | - | a305ffb561710887 |
| 2026-11-27T19:37:20Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.24 | 89b8fd5d675b403584330900c936f54e | 1201b57865609612 |
| 2026-11-27T19:37:21Z | c05-ex5-tl | duyu-1 | - | - | - | 2.24 | - | 1201b57865609612 |
| 2026-11-27T19:37:23Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | 80ea09fe0f7e4256bcf43072cca039d0 | 0df8ee4946f12220 |
| 2026-11-27T19:37:24Z | c06-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 0df8ee4946f12220 |
| 2026-11-27T19:37:26Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 3.84 | 3a84515e151e44efa44f52a41867bb87 | e5b125af3b9aae53 |
| 2026-11-27T19:37:27Z | c07-q5-tl | duyu-1 | - | - | - | 3.84 | - | e5b125af3b9aae53 |
