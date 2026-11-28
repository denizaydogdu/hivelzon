# G-A2-01-present-continuous PROMPTS

Ders: Şimdiki zaman: am / is / are + -ing · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ing` → "ing".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:07:05Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 7.68 | 5e1d5ac6a1b24383b517caea297caa79 | 56f85cefb5b25052 |
| 2026-10-14T13:07:06Z | c01-tr | duyu-1 | - | - | - | 7.68 | - | 56f85cefb5b25052 |
| 2026-10-14T13:07:08Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 168 | 11.87 | 85c69007e7c446558604a0ba101afdce | c2ba4358af98e0e9 |
| 2026-10-14T13:07:10Z | c02-tr | duyu-1 | - | - | - | 11.87 | - | c2ba4358af98e0e9 |
| 2026-10-14T13:07:12Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 11.68 | e1056d167ba449b087451e5e72a60dfa | a20a68721aad9ed1 |
| 2026-10-14T13:07:14Z | c03-tr | duyu-1 | - | - | - | 11.68 | - | a20a68721aad9ed1 |
| 2026-10-14T13:07:16Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 10.59 | 77d08fc4ef9b4b12881d876db586e35a | 7ede3185a33dfeb5 |
| 2026-10-14T13:07:18Z | c04-tr | duyu-1 | - | - | - | 10.59 | - | 7ede3185a33dfeb5 |
| 2026-10-14T13:07:21Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 10.58 | 5fcc1a0732ee4cee9254001665444918 | 7a1562109449897d |
| 2026-10-14T13:07:22Z | c06-tr | duyu-1 | - | - | - | 10.58 | - | 7a1562109449897d |
| 2026-10-14T13:07:24Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 65 | 4.8 | d33f826143904aa2bc42ecf86f6db312 | a4be7a15a8e9428c |
| 2026-10-14T13:07:25Z | c08-tr | duyu-1 | - | - | - | 4.8 | - | a4be7a15a8e9428c |
| 2026-10-14T13:07:27Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 103 | 6.4 | 8cd2fc637ceb442295300bb14ffea207 | f178aecc6f0d944e |
| 2026-10-14T13:07:28Z | c09-tr | duyu-1 | - | - | - | 6.4 | - | f178aecc6f0d944e |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T18:25:37Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | da4980c40a41882d | audio/en/c01-ex1.mp3 |
| 2026-10-14T18:25:38Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 13 | c2c0d90ebcfe3bf6 | audio/en/c03-ex1.mp3 |
| 2026-10-14T18:25:39Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 15 | ff5baad1fc2ac4ff | audio/en/c03-ex2.mp3 |
| 2026-10-14T18:25:41Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 17 | f15b9812beb5968a | audio/en/c03-ex3.mp3 |
| 2026-10-14T18:25:42Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 21 | 68ad7a343e9e940a | audio/en/c04-ex1.mp3 |
| 2026-10-14T18:25:43Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 17 | 988f482a0339984a | audio/en/c04-ex2.mp3 |
| 2026-10-14T18:25:45Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | 9d9fec8afdb0fbaa | audio/en/c05-ex1.mp3 |
| 2026-10-14T18:25:46Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 43 | 63b8e9375521323a | audio/en/c05-ex2.mp3 |
| 2026-10-14T18:25:47Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 27 | fa93a99fd153014e | audio/en/c05-ex3.mp3 |
| 2026-10-14T18:25:49Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | df201d39e9fb7f95 | audio/en/c05-ex4.mp3 |
| 2026-10-14T18:25:50Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 19 | 8bc402216a7f71e4 | audio/en/c05-ex5.mp3 |
| 2026-10-14T18:25:51Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 7b3f28ef94752f40 | audio/en/c06-ex1.mp3 |
| 2026-10-14T18:25:52Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 19 | 9f68fc2f6b9381d9 | audio/en/c06-ex2.mp3 |
| 2026-10-14T18:25:54Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 26 | 60aaaa727c54ab62 | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:20:34Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 59 | 5.28 | 9cc7c8f1728746c390e97ac0efb7bac7 | ec34fd96f68a0082 |
| 2026-11-27T18:20:35Z | c07-q1-fb | duyu-1 | - | - | - | 5.28 | - | ec34fd96f68a0082 |
| 2026-11-27T18:20:37Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.68 | e6bad3e6972e407ea8cc040180657865 | deebe9268c1a3d1f |
| 2026-11-27T18:20:38Z | c07-q2-fb | duyu-1 | - | - | - | 3.68 | - | deebe9268c1a3d1f |
| 2026-11-27T18:20:41Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 3.36 | 8aad3b3d833a401abbb52c98cd3b4b9c | 967c84ce8d186935 |
| 2026-11-27T18:20:42Z | c07-q3-fb | duyu-1 | - | - | - | 3.36 | - | 967c84ce8d186935 |
| 2026-11-27T18:20:44Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 56 | 4.64 | 42e6cc39ea6d44f099c310a1701eadf6 | 16d25f66b792a8c8 |
| 2026-11-27T18:20:45Z | c07-q4-fb | duyu-1 | - | - | - | 4.64 | - | 16d25f66b792a8c8 |
| 2026-11-27T19:07:10Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | 1031a91bd64f459091492b048eb59f35 | 94bd9a6f0bf9bc2c |
| 2026-11-27T19:07:11Z | c01-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 94bd9a6f0bf9bc2c |
| 2026-11-27T19:07:13Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.6 | 7ecc0de30bbc47f096778d2f100c3edd | e493be5bd4cf5c18 |
| 2026-11-27T19:07:14Z | c03-ex1-tl | duyu-1 | - | - | - | 1.6 | - | e493be5bd4cf5c18 |
| 2026-11-27T19:07:16Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.96 | 238d8c7d481c40de8a296e8111614470 | 83f6032f88907c6c |
| 2026-11-27T19:07:17Z | c03-ex2-tl | duyu-1 | - | - | - | 0.96 | - | 83f6032f88907c6c |
| 2026-11-27T19:07:20Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.12 | cd684c6810c44a0ca0feee4979dd30f0 | 9ee56e89f72aee99 |
| 2026-11-27T19:07:21Z | c03-ex3-tl | duyu-1 | - | - | - | 1.12 | - | 9ee56e89f72aee99 |
| 2026-11-27T19:07:23Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 2.72 | abbf8cc20cd24603b2c76bdd368f3fdb | b2122f1cf282d48a |
| 2026-11-27T19:07:24Z | c04-ex1-tl | duyu-1 | - | - | - | 2.72 | - | b2122f1cf282d48a |
| 2026-11-27T19:07:26Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | 92fd573b4fff4df8acacecd173ceee3d | afa91b07d3843154 |
| 2026-11-27T19:07:27Z | c04-ex2-tl | duyu-1 | - | - | - | 1.28 | - | afa91b07d3843154 |
| 2026-11-27T19:07:29Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.72 | 08c3f20f6ac44edf9c1e0e716d7a1193 | 9d823491e618df43 |
| 2026-11-27T19:07:30Z | c05-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 9d823491e618df43 |
| 2026-11-27T19:07:32Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.56 | 9b4e073e39de4951828a8eb6868e5d64 | 057c59bc6896c6bc |
| 2026-11-27T19:07:33Z | c05-ex2-tl | duyu-1 | - | - | - | 2.56 | - | 057c59bc6896c6bc |
| 2026-11-27T19:07:35Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | 67fa5afab56e4b20903bd95eea888ec9 | 0d664aa953614595 |
| 2026-11-27T19:07:36Z | c05-ex3-tl | duyu-1 | - | - | - | 1.6 | - | 0d664aa953614595 |
| 2026-11-27T19:07:38Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | 7959f92954a2451c8ef6720387f6d077 | c11a925b1abf7fc3 |
| 2026-11-27T19:07:39Z | c05-ex4-tl | duyu-1 | - | - | - | 2.24 | - | c11a925b1abf7fc3 |
| 2026-11-27T19:07:41Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 2.08 | 0674d3d3b57140f38a7845d8221d9c23 | a0e758c5c27ce0c5 |
| 2026-11-27T19:07:42Z | c05-ex5-tl | duyu-1 | - | - | - | 2.08 | - | a0e758c5c27ce0c5 |
| 2026-11-27T19:07:45Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.24 | 432c0bfa06854f8782fe652e5e5329be | 7dcf1c04586137a1 |
| 2026-11-27T19:07:46Z | c06-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 7dcf1c04586137a1 |
| 2026-11-27T19:07:48Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.6 | 5f7beec4f5b14777a54dd9cfad0d0a39 | 1b4f4da42e7b6e29 |
| 2026-11-27T19:07:48Z | c06-ex2-tl | duyu-1 | - | - | - | 1.6 | - | 1b4f4da42e7b6e29 |
| 2026-11-27T19:07:51Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 3.52 | 04baf4a7f54d4bf9b895f101799e668a | e2c3888a8107294c |
| 2026-11-27T19:07:52Z | c09-ex1-tl | duyu-1 | - | - | - | 3.52 | - | e2c3888a8107294c |
