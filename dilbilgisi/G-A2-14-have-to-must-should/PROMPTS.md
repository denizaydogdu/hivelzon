# G-A2-14-have-to-must-should PROMPTS

Ders: have to / must / should: zorunluluk ve öneri · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:12:13Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 128 | 7.68 | 824d5384c6b84368ba1acf6118e62f69 | 1ebe3b28d61cd68d |
| 2026-10-14T13:12:14Z | c01-tr | duyu-1 | - | - | - | 7.68 | - | 1ebe3b28d61cd68d |
| 2026-10-14T13:12:16Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 12.5 | dde8bdab54c24a62972abce69803de00 | 11b260c7a5985139 |
| 2026-10-14T13:12:18Z | c02-tr | duyu-1 | - | - | - | 12.5 | - | 11b260c7a5985139 |
| 2026-10-14T13:12:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 10.84 | 897ecaeb0dad4d72ae8b6eff90224bf7 | 115f1075bb98ebb8 |
| 2026-10-14T13:12:23Z | c03-tr | duyu-1 | - | - | - | 10.84 | - | 115f1075bb98ebb8 |
| 2026-10-14T13:12:25Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 157 | 10.25 | 0e2af6adac294be7b066569b836882be | 149b34c8ba57cfd0 |
| 2026-10-14T13:12:27Z | c04-tr | duyu-1 | - | - | - | 10.25 | - | 149b34c8ba57cfd0 |
| 2026-10-14T13:12:30Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 230 | 16.21 | cff5d59479ad4ceab06e02209a22023f | 9ce48045b30597cd |
| 2026-10-14T13:12:31Z | c06-tr | duyu-1 | - | - | - | 16.21 | - | 9ce48045b30597cd |
| 2026-10-14T13:12:34Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 91 | 5.6 | a420e4ba9227439983d20c24a99b75b9 | c15d9e35efd6127c |
| 2026-10-14T13:12:35Z | c08-tr | duyu-1 | - | - | - | 5.6 | - | c15d9e35efd6127c |
| 2026-10-14T13:12:37Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 137 | 9.76 | 687819453bf14a1f9a921dd0d096baab | c34bfb7d06d62934 |
| 2026-10-14T13:12:39Z | c09-tr | duyu-1 | - | - | - | 9.76 | - | c34bfb7d06d62934 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:29:57Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | ca18215cb0829d95 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:29:59Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 39 | 8c952b153ff026ef | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:30:00Z | c02-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | ee260afe65f00012 | audio/en/c02-ex3.mp3 |
| 2026-10-30T13:30:01Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 108cb99748727406 | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:30:03Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 643f39626c4b5692 | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:30:04Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | 610a2bdc81852bf6 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:30:06Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | 6b7c14b641313e58 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:30:07Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | 6f915df4086b4700 | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:30:09Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | f3390d41fb37a747 | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:30:10Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | a37eb6fbbee4ad34 | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:30:13Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 42 | 9376b333c822ae62 | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:30:14Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | a71e1468273048f2 | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:30:15Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 12 | cce07d83e5369b6b | audio/en/c06-ex1.mp3 |
| 2026-10-30T13:30:17Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | 476b0c6b5e6d7747 | audio/en/c06-ex2.mp3 |
| 2026-10-30T13:30:18Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 16 | 03d1afd3d81acb95 | audio/en/c06-ex3.mp3 |
| 2026-11-27T18:23:37Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 3.52 | ec1bd7b5e259488e93d2e615dbfa577a | d5f5ae130f83fc25 |
| 2026-11-27T18:23:38Z | c07-q1-fb | duyu-1 | - | - | - | 3.52 | - | d5f5ae130f83fc25 |
| 2026-11-27T18:23:40Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.92 | b2145b138614494493da86d12b50a0b8 | 0a6059f34b2e2f25 |
| 2026-11-27T18:23:41Z | c07-q2-fb | duyu-1 | - | - | - | 1.92 | - | 0a6059f34b2e2f25 |
| 2026-11-27T18:23:43Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 1.76 | c29aed1e76f044ecb7b1f83d889af5be | 429e96430f2a9846 |
| 2026-11-27T18:23:44Z | c07-q3-fb | duyu-1 | - | - | - | 1.76 | - | 429e96430f2a9846 |
| 2026-11-27T18:23:47Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.72 | ee00313bb9044d06bc28e76a43928a12 | d61e28713d192293 |
| 2026-11-27T18:23:48Z | c07-q4-fb | duyu-1 | - | - | - | 2.72 | - | d61e28713d192293 |
| 2026-11-27T19:16:10Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 3.04 | 3a1867a426c248a78138a0717fe89072 | d65879696ad3f257 |
| 2026-11-27T19:16:11Z | c01-ex1-tl | duyu-1 | - | - | - | 3.04 | - | d65879696ad3f257 |
| 2026-11-27T19:16:13Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.56 | ae7bb924496847c0aa8271e55e951014 | 37250a5f5c5ecb18 |
| 2026-11-27T19:16:14Z | c02-ex2-tl | duyu-1 | - | - | - | 2.56 | - | 37250a5f5c5ecb18 |
| 2026-11-27T19:16:16Z | c02-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.56 | b0354cb1dda84161912a9b8dfc6694bd | e986d6b573305933 |
| 2026-11-27T19:16:17Z | c02-ex3-tl | duyu-1 | - | - | - | 2.56 | - | e986d6b573305933 |
| 2026-11-27T19:16:19Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 2.56 | acdf0694c8074865862d52f49ecbc9ba | 3a7ab116c338504a |
| 2026-11-27T19:16:20Z | c03-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 3a7ab116c338504a |
| 2026-11-27T19:16:22Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.88 | a873c8026cae43d58da3bd1e49657095 | 3c2627201ebdabcb |
| 2026-11-27T19:16:23Z | c03-ex2-tl | duyu-1 | - | - | - | 2.88 | - | 3c2627201ebdabcb |
| 2026-11-27T19:16:26Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 3.52 | 2455f1db6cfc4a1f8b90e9ea65f597d5 | 2a73e3968ac50748 |
| 2026-11-27T19:16:27Z | c04-ex1-tl | duyu-1 | - | - | - | 3.52 | - | 2a73e3968ac50748 |
| 2026-11-27T19:16:29Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 4.16 | 0ef9b669796142d59fd1b38931e985a6 | 391e468a5ae6989c |
| 2026-11-27T19:16:31Z | c04-ex2-tl | duyu-1 | - | - | - | 4.16 | - | 391e468a5ae6989c |
| 2026-11-27T19:16:33Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.24 | f8f58cfd1d58497ab14889679f635a7c | 5d22ac6f28ee96c7 |
| 2026-11-27T19:16:34Z | c05-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 5d22ac6f28ee96c7 |
| 2026-11-27T19:16:36Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.4 | 571cdb9cd061471bae6d3a651398d013 | ffc0d1dd7bb029f0 |
| 2026-11-27T19:16:37Z | c05-ex2-tl | duyu-1 | - | - | - | 2.4 | - | ffc0d1dd7bb029f0 |
| 2026-11-27T19:16:40Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 3.52 | f81bf388d4e64c07b70caee741bdc7c2 | b4d9991427305068 |
| 2026-11-27T19:16:41Z | c05-ex3-tl | duyu-1 | - | - | - | 3.52 | - | b4d9991427305068 |
| 2026-11-27T19:16:43Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 2.56 | d675c05a26a14127883b420bd322ae16 | 2feaec8462d8d0a0 |
| 2026-11-27T19:16:44Z | c05-ex4-tl | duyu-1 | - | - | - | 2.56 | - | 2feaec8462d8d0a0 |
| 2026-11-27T19:16:46Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.88 | b4027fd0bfb34defbe4477c9fd0e143d | 3adbb5e108f8b145 |
| 2026-11-27T19:16:47Z | c05-ex5-tl | duyu-1 | - | - | - | 2.88 | - | 3adbb5e108f8b145 |
| 2026-11-27T19:16:49Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 2.4 | 932f035b76fe46aab29eed05e9361c7e | ea9715443aad50f9 |
| 2026-11-27T19:16:50Z | c06-ex1-tl | duyu-1 | - | - | - | 2.4 | - | ea9715443aad50f9 |
| 2026-11-27T19:16:53Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 3.04 | d472a07314534adb946080ca238e8bcc | 78726f72b6e442a5 |
| 2026-11-27T19:16:54Z | c06-ex2-tl | duyu-1 | - | - | - | 3.04 | - | 78726f72b6e442a5 |
| 2026-11-27T19:16:57Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.76 | e812770fb8294d8f8a84c08249dec86d | 50accf2cf5c44828 |
| 2026-11-27T19:16:58Z | c06-ex3-tl | duyu-1 | - | - | - | 1.76 | - | 50accf2cf5c44828 |
