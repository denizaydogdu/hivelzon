# G-B1-13-indirect-questions PROMPTS

Ders: Dolaylı sorular: Can you tell me where…? · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `Alex` → "Aleks".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:10:24Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 176 | 13.47 | a9588de3d9c6451d822ba3f5b0a2c221 | 6f2f524331f5c71e |
| 2026-10-14T14:10:26Z | c01-tr | duyu-1 | - | - | - | 13.47 | - | 6f2f524331f5c71e |
| 2026-10-14T14:10:28Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 10.11 | 6dca3fc141b54d3eb500022af5309226 | 9238fb9fec2f02a0 |
| 2026-10-14T14:10:30Z | c02-tr | duyu-1 | - | - | - | 10.11 | - | 9238fb9fec2f02a0 |
| 2026-10-14T14:10:33Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 111 | 6.72 | 97710a11d383453db4d12c36af25ab8d | ab27296b7a7ed021 |
| 2026-10-14T14:10:34Z | c03-tr | duyu-1 | - | - | - | 6.72 | - | ab27296b7a7ed021 |
| 2026-10-14T14:10:36Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 119 | 8.96 | ea1f16426fd74075a60befa5dc2c2b63 | abc7383601d21ecc |
| 2026-10-14T14:10:37Z | c04-tr | duyu-1 | - | - | - | 8.96 | - | abc7383601d21ecc |
| 2026-10-14T14:10:40Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 215 | 13.5 | 229ec8968ac14977ba7e989683f0caf4 | 72f7611c77af3b86 |
| 2026-10-14T14:10:41Z | c06-tr | duyu-1 | - | - | - | 13.5 | - | 72f7611c77af3b86 |
| 2026-10-14T14:10:44Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 159 | 9.61 | 8388146da269444eb6b356c0b956b19a | dc992b79e0892d02 |
| 2026-10-14T14:10:45Z | c08-tr | duyu-1 | - | - | - | 9.61 | - | dc992b79e0892d02 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:01:21Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 7c64674c8e6e6704 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:01:22Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 21 | 143c343f0c548b3f | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:01:24Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | e0df8d899e7d3aaa | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:01:25Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | a1aa3e7afdab62fc | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:01:27Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | 949b9af754eee620 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:01:28Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 15 | 86fbf23ffe39c84e | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:01:29Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | f7e980a056be816d | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:01:31Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | fd37a4703824075e | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:01:32Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 385b2c5895738800 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:01:34Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 221da374b73d61ff | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:01:35Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 9fe13472964c63b6 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:01:37Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | 2c1d7c390f7a00a8 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:01:39Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 48 | 8b0f21f3d543b12a | audio/en/c07-q5.mp3 |
| 2026-11-27T18:26:50Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.56 | 4b94d904fe974f369e8b910ad3ebdc6c | c21354f208999ecb |
| 2026-11-27T18:26:51Z | c07-q1-fb | duyu-1 | - | - | - | 2.56 | - | c21354f208999ecb |
| 2026-11-27T18:26:54Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.36 | 4d7e86a9da284edcbf530cbf996ff11b | 9c580e9db0bef296 |
| 2026-11-27T18:26:55Z | c07-q2-fb | duyu-1 | - | - | - | 3.36 | - | 9c580e9db0bef296 |
| 2026-11-27T18:26:57Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.04 | a5307e58e81e4c2c951f9c374554bbd6 | 0a051f61bbdcba3d |
| 2026-11-27T18:26:58Z | c07-q3-fb | duyu-1 | - | - | - | 3.04 | - | 0a051f61bbdcba3d |
| 2026-11-27T18:27:01Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 3.68 | d7f7e1386d0c45368477d9f825c6a9fb | f5d6c0d8b07cd0eb |
| 2026-11-27T18:27:03Z | c07-q4-fb | duyu-1 | - | - | - | 3.68 | - | f5d6c0d8b07cd0eb |
| 2026-11-27T19:26:02Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 53 | 3.36 | 573655813bdb41d4bc35b0d7b310b617 | 0280beaea811a5b9 |
| 2026-11-27T19:26:03Z | c01-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 0280beaea811a5b9 |
| 2026-11-27T19:26:06Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | 66c317a3759f433ca816f1e13edea684 | c4715add2c836e26 |
| 2026-11-27T19:26:07Z | c02-ex1-tl | duyu-1 | - | - | - | 1.44 | - | c4715add2c836e26 |
| 2026-11-27T19:26:08Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.24 | f84c16ea7f204a8083da75d37c22a09f | cc4e51cc736ab24e |
| 2026-11-27T19:26:10Z | c02-ex2-tl | duyu-1 | - | - | - | 2.24 | - | cc4e51cc736ab24e |
| 2026-11-27T19:26:11Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.44 | 0c5a700cc47c447ebef515e1402d7203 | 392a747ebab2eb80 |
| 2026-11-27T19:26:12Z | c03-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 392a747ebab2eb80 |
| 2026-11-27T19:26:14Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.4 | 81596219633144f2864d194a3269df5e | c04e0058f523c01d |
| 2026-11-27T19:26:16Z | c03-ex2-tl | duyu-1 | - | - | - | 2.4 | - | c04e0058f523c01d |
| 2026-11-27T19:26:18Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 8 | 0.96 | 5a72d13cf30b4dc895fd8a3397991e68 | 1d92e11fcaccb304 |
| 2026-11-27T19:26:19Z | c04-ex1-tl | duyu-1 | - | - | - | 0.96 | - | 1d92e11fcaccb304 |
| 2026-11-27T19:26:21Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.88 | f216821188424d319ea1c1d3dd6d7147 | f8abdc3f4b74c5d3 |
| 2026-11-27T19:26:22Z | c04-ex2-tl | duyu-1 | - | - | - | 2.88 | - | f8abdc3f4b74c5d3 |
| 2026-11-27T19:26:24Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 4.32 | 81b93f3006de4ece840ef6496ff54d14 | 4b9c1c6c4f3d235e |
| 2026-11-27T19:26:26Z | c05-ex1-tl | duyu-1 | - | - | - | 4.32 | - | 4b9c1c6c4f3d235e |
| 2026-11-27T19:26:28Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 2.56 | 7871a70c2c97431680a9a0f1b9b6125c | cc5d64ddf669b3e7 |
| 2026-11-27T19:26:29Z | c05-ex2-tl | duyu-1 | - | - | - | 2.56 | - | cc5d64ddf669b3e7 |
| 2026-11-27T19:26:31Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.4 | f347e0b1c1624ceeae7ccac145c663a1 | eadd4638ab6cb8c1 |
| 2026-11-27T19:26:32Z | c05-ex3-tl | duyu-1 | - | - | - | 2.4 | - | eadd4638ab6cb8c1 |
| 2026-11-27T19:26:34Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 2.4 | 0372089587f942a9aa233cfc0e40585e | b2b1832d6c1c817a |
| 2026-11-27T19:26:35Z | c05-ex4-tl | duyu-1 | - | - | - | 2.4 | - | b2b1832d6c1c817a |
| 2026-11-27T19:26:38Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 3.2 | 055de712d1a74f57a8e80cf2365345d0 | 3792c8608ebdfdb0 |
| 2026-11-27T19:26:39Z | c05-ex5-tl | duyu-1 | - | - | - | 3.2 | - | 3792c8608ebdfdb0 |
| 2026-11-27T19:26:41Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 61 | 3.52 | e70b258f74794d60ba47c7c4765ca5b1 | 6fff0caa0af99fad |
| 2026-11-27T19:26:42Z | c07-q5-tl | duyu-1 | - | - | - | 3.52 | - | 6fff0caa0af99fad |
