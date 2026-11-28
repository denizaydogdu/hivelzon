# G-B1-10-might-may-could PROMPTS

Ders: Olasılık: might / may / could · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:09:14Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 163 | 10.11 | e733178ffc7645649f8936fcd12a14a1 | 5866722ca4a9ada9 |
| 2026-10-14T14:09:15Z | c01-tr | duyu-1 | - | - | - | 10.11 | - | 5866722ca4a9ada9 |
| 2026-10-14T14:09:17Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 163 | 10.4 | 578529f272ea40c4a914a47c978819c0 | 73e1213aaa49aaaa |
| 2026-10-14T14:09:18Z | c02-tr | duyu-1 | - | - | - | 10.4 | - | 73e1213aaa49aaaa |
| 2026-10-14T14:09:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 8.8 | ab7824f881e84826b85d3e1222996ce4 | 322df938c282e146 |
| 2026-10-14T14:09:22Z | c03-tr | duyu-1 | - | - | - | 8.8 | - | 322df938c282e146 |
| 2026-10-14T14:09:24Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 107 | 7.36 | 103aa00eecf2457e83e612d43366df99 | 2c62e17886c2d2fc |
| 2026-10-14T14:09:25Z | c04-tr | duyu-1 | - | - | - | 7.36 | - | 2c62e17886c2d2fc |
| 2026-10-14T14:09:28Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 229 | 14.43 | a03dbbf1f0494eb1b99ce78fe20fd192 | 125a321fdbaed6ff |
| 2026-10-14T14:09:29Z | c06-tr | duyu-1 | - | - | - | 14.43 | - | 125a321fdbaed6ff |
| 2026-10-14T14:09:32Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 101 | 6.4 | e82d2f3f7e1843c69c42e750c4217a92 | f685564a9211ad43 |
| 2026-10-14T14:09:33Z | c08-tr | duyu-1 | - | - | - | 6.4 | - | f685564a9211ad43 |
| 2026-10-14T14:09:35Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 122 | 7.36 | e153a9bb50fc4b7da4924ec7e8a05e21 | e6e677d35ed01fae |
| 2026-10-14T14:09:37Z | c09-tr | duyu-1 | - | - | - | 7.36 | - | e6e677d35ed01fae |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:37:30Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 6146ffd6756da81a | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:37:32Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | ecb7e17a9fb6e954 | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:37:33Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 60c01e463d8d6c01 | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:37:35Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | a1667c5c7d55a1b9 | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:37:37Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | eeb48c81773b8a48 | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:37:39Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | 7fd425129d4d7510 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:37:40Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 00e33a2ee6a9033a | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:37:41Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | 744ce4220a2bb1a9 | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:37:43Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 87201ce6567450b6 | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:37:44Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | 21af3ffcfa29e48f | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:37:46Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 19 | 59be2c68b94a1eea | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:37:47Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | fadf7f55f41dcfbe | audio/en/c06-ex1.mp3 |
| 2026-10-30T13:37:48Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 15 | c966251e3e299c16 | audio/en/c06-ex2.mp3 |
| 2026-10-30T13:37:49Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 20 | e47c760ea9d2b005 | audio/en/c07-q5.mp3 |
| 2026-11-27T18:26:10Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.92 | 0ce4105320a04909ac0c69ee4af80338 | 48c6c5d2248ed4e8 |
| 2026-11-27T18:26:11Z | c07-q1-fb | duyu-1 | - | - | - | 1.92 | - | 48c6c5d2248ed4e8 |
| 2026-11-27T18:26:13Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.24 | 03786bf2bdc74bc8b3500c5ac8cf8a4e | 3dc55bb8ea49f398 |
| 2026-11-27T18:26:14Z | c07-q2-fb | duyu-1 | - | - | - | 2.24 | - | 3dc55bb8ea49f398 |
| 2026-11-27T18:26:17Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.88 | d8cd76e171fd4dacadb1188fd4daf833 | b2fd59335e0aacfc |
| 2026-11-27T18:26:18Z | c07-q3-fb | duyu-1 | - | - | - | 2.88 | - | b2fd59335e0aacfc |
| 2026-11-27T18:26:21Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.24 | 4db2ede47b85420c923b8dcd937e03f7 | accefd42bd6bea44 |
| 2026-11-27T18:26:22Z | c07-q4-fb | duyu-1 | - | - | - | 2.24 | - | accefd42bd6bea44 |
| 2026-11-27T19:24:06Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.24 | 2930a4ae2abb424097c309e14dd6e533 | 6159e0f1a5701b42 |
| 2026-11-27T19:24:07Z | c01-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 6159e0f1a5701b42 |
| 2026-11-27T19:24:09Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | b60c6128c4294e16848da8f9d6c3fb9c | 45aa440e42836861 |
| 2026-11-27T19:24:10Z | c02-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 45aa440e42836861 |
| 2026-11-27T19:24:12Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | b4689b65f7db4cb6bd53e4ec8697134d | e3f9eec209f0ff4b |
| 2026-11-27T19:24:13Z | c02-ex2-tl | duyu-1 | - | - | - | 1.44 | - | e3f9eec209f0ff4b |
| 2026-11-27T19:24:15Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | c7a6e89ab05e41e0a82a8c7ea982bb5e | 24831064cdfe4fc4 |
| 2026-11-27T19:24:16Z | c03-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 24831064cdfe4fc4 |
| 2026-11-27T19:24:18Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.4 | 1b0ce20e7480459bbc1ab69d652580f7 | 2657e2a476d8c81a |
| 2026-11-27T19:24:19Z | c03-ex2-tl | duyu-1 | - | - | - | 2.4 | - | 2657e2a476d8c81a |
| 2026-11-27T19:24:21Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.08 | 9f311b1ad7fe4eac968901cef95f8a3f | b0e01b0df6bd1179 |
| 2026-11-27T19:24:22Z | c04-ex1-tl | duyu-1 | - | - | - | 2.08 | - | b0e01b0df6bd1179 |
| 2026-11-27T19:24:24Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 3.2 | 5c76102229d3436fac1a8de3a66db84f | 0bdcebe56f582f3d |
| 2026-11-27T19:24:25Z | c05-ex1-tl | duyu-1 | - | - | - | 3.2 | - | 0bdcebe56f582f3d |
| 2026-11-27T19:24:28Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 3.36 | 3f5306ef0213439e977748c0de57f3c1 | ed6d99e76d176a85 |
| 2026-11-27T19:24:29Z | c05-ex2-tl | duyu-1 | - | - | - | 3.36 | - | ed6d99e76d176a85 |
| 2026-11-27T19:24:31Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 3.36 | bb491065a0e84916867729b83e19cb64 | 06a028b861d980b7 |
| 2026-11-27T19:24:32Z | c05-ex3-tl | duyu-1 | - | - | - | 3.36 | - | 06a028b861d980b7 |
| 2026-11-27T19:24:35Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 3.36 | 39c03a635ff541848c9c9e79e3df8f6d | 8af340c6dd627de1 |
| 2026-11-27T19:24:36Z | c05-ex4-tl | duyu-1 | - | - | - | 3.36 | - | 8af340c6dd627de1 |
| 2026-11-27T19:24:38Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.44 | 677e9e6d504b4ab5877ac080e93271fe | 9dd5515f8a7fbee4 |
| 2026-11-27T19:24:39Z | c05-ex5-tl | duyu-1 | - | - | - | 1.44 | - | 9dd5515f8a7fbee4 |
| 2026-11-27T19:24:41Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.08 | cdcf5934ba9b42389a134467900dd2b7 | 88ab7d0919becf9a |
| 2026-11-27T19:24:42Z | c06-ex1-tl | duyu-1 | - | - | - | 2.08 | - | 88ab7d0919becf9a |
| 2026-11-27T19:24:44Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 1.12 | b93176b0752f4af3858659ae2cc03d26 | aaa8dfe9d937d072 |
| 2026-11-27T19:24:45Z | c06-ex2-tl | duyu-1 | - | - | - | 1.12 | - | aaa8dfe9d937d072 |
| 2026-11-27T19:24:47Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 9dfd1a24107949088a29f7cb6c95ad86 | a578b4d1469be71b |
| 2026-11-27T19:24:48Z | c07-q5-tl | duyu-1 | - | - | - | 1.76 | - | a578b4d1469be71b |
