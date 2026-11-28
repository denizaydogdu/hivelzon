# G-A1-07-can PROMPTS

Ders: can / can't: yetenek, rica ve kısa cevap · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:06:10Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 10.39 | 997be1de7a0a475ea51a69c0cf921331 | 145d180bc0646f34 |
| 2026-10-14T13:06:11Z | c01-tr | duyu-1 | - | - | - | 10.39 | - | 145d180bc0646f34 |
| 2026-10-14T13:06:14Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 12.67 | 060a5c1bc671494aa2569bfbfd524e9e | ffda19b8e5574e03 |
| 2026-10-14T13:06:15Z | c02-tr | duyu-1 | - | - | - | 12.67 | - | ffda19b8e5574e03 |
| 2026-10-14T13:06:18Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 125 | 8.0 | 45a07792f16b4edfa78b40a8a04edc93 | beca484e0db49123 |
| 2026-10-14T13:06:20Z | c03-tr | duyu-1 | - | - | - | 8.0 | - | beca484e0db49123 |
| 2026-10-14T13:06:22Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 159 | 11.87 | f5820b1a818b4c8288e67e5c9b98cd87 | 6348cb098d21ef1e |
| 2026-10-14T13:06:26Z | c04-tr | duyu-1 | - | - | - | 11.87 | - | 6348cb098d21ef1e |
| 2026-10-14T13:06:29Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 182 | 12.83 | 82fcc1c59fdc493e8ccdc15363e881c5 | 9783ab8c1493ea77 |
| 2026-10-14T13:06:30Z | c06-tr | duyu-1 | - | - | - | 12.83 | - | 9783ab8c1493ea77 |
| 2026-10-14T13:06:32Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 59 | 4.16 | fc86c11c95014a72996aba07eed1ac64 | e89a5c6a53f5df2f |
| 2026-10-14T13:06:34Z | c08-tr | duyu-1 | - | - | - | 4.16 | - | e89a5c6a53f5df2f |
| 2026-10-14T13:06:36Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 144 | 10.43 | 8c7ee278930e49d78a79bec1a3ac8ac8 | f0742249f2a30a9b |
| 2026-10-14T13:06:37Z | c09-tr | duyu-1 | - | - | - | 10.43 | - | f0742249f2a30a9b |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:54:38Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 37e79c35d4fee75c | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:54:39Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 11 | 4dfec7b6fe858196 | audio/en/c02-ex1.mp3 |
| 2026-10-14T14:54:40Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | bd2d7cace91ee2eb | audio/en/c02-ex2.mp3 |
| 2026-10-14T14:54:41Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | 7ada9beab290cf53 | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:54:42Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 9e90eb72593da912 | audio/en/c03-ex2.mp3 |
| 2026-10-14T14:54:43Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | 3cd420f5ca93599a | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:54:44Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 28 | 946856fcf2768ade | audio/en/c04-ex2.mp3 |
| 2026-10-14T14:54:45Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | e03d51d2675bc601 | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:54:46Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | 8266f9d07e530dee | audio/en/c05-ex2.mp3 |
| 2026-10-14T14:54:47Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | 0a568186027ca060 | audio/en/c05-ex3.mp3 |
| 2026-10-14T14:54:48Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | 7a2478852c8366df | audio/en/c05-ex4.mp3 |
| 2026-10-14T14:54:49Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | fc92fbc81f95af00 | audio/en/c05-ex5.mp3 |
| 2026-10-14T14:54:50Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 11 | 044feecf91a29253 | audio/en/c06-ex1.mp3 |
| 2026-10-14T14:54:52Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | aa8a38408553451e | audio/en/c07-q5.mp3 |
| 2026-11-27T18:18:23Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 3.2 | cd0c75015bef4df8b4d98992ca394a9a | fd3daacb17de338a |
| 2026-11-27T18:18:24Z | c07-q1-fb | duyu-1 | - | - | - | 3.2 | - | fd3daacb17de338a |
| 2026-11-27T18:18:26Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 60 | 3.84 | 1a532f5ccfa64cb89f826506ac517abb | 7399372c83a16e7d |
| 2026-11-27T18:18:27Z | c07-q2-fb | duyu-1 | - | - | - | 3.84 | - | 7399372c83a16e7d |
| 2026-11-27T18:18:30Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 3.2 | d3adc901063f449c90a374bbaf503686 | 3bf1ed4a0dca162f |
| 2026-11-27T18:18:31Z | c07-q3-fb | duyu-1 | - | - | - | 3.2 | - | 3bf1ed4a0dca162f |
| 2026-11-27T18:18:33Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.4 | 27ff9faae18e46399546a221fe10a255 | afde40d738ffc7b6 |
| 2026-11-27T18:18:34Z | c07-q4-fb | duyu-1 | - | - | - | 2.4 | - | afde40d738ffc7b6 |
| 2026-11-27T19:00:17Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 3.2 | cf99201c318747b9b9f4ce08c5d19e61 | a87521cf883b0062 |
| 2026-11-27T19:00:18Z | c01-ex1-tl | duyu-1 | - | - | - | 3.2 | - | a87521cf883b0062 |
| 2026-11-27T19:00:21Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.76 | 8e023213eb5c42c88699d59444a11855 | c3e9592bad4c2c3d |
| 2026-11-27T19:00:22Z | c02-ex1-tl | duyu-1 | - | - | - | 1.76 | - | c3e9592bad4c2c3d |
| 2026-11-27T19:00:24Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 2.08 | c532ecb8de3d4088b7615ed557057c9d | 72ac283977ad7a18 |
| 2026-11-27T19:00:25Z | c02-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 72ac283977ad7a18 |
| 2026-11-27T19:00:26Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 8 | 0.96 | 95d9963d14914c83b70d2448655322bc | c2d6957f68fd7cd2 |
| 2026-11-27T19:00:27Z | c03-ex1-tl | duyu-1 | - | - | - | 0.96 | - | c2d6957f68fd7cd2 |
| 2026-11-27T19:00:29Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.44 | 6c28f34322e34ca28d86ae4be8e9f963 | 4a6d1b8fd17c684a |
| 2026-11-27T19:00:30Z | c03-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 4a6d1b8fd17c684a |
| 2026-11-27T19:00:33Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 3.36 | afcac3eb1861447d89df6036697d981a | 1567982579a87c18 |
| 2026-11-27T19:00:34Z | c04-ex1-tl | duyu-1 | - | - | - | 3.36 | - | 1567982579a87c18 |
| 2026-11-27T19:00:37Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 3.68 | 93fd0ccb53d24babb56fd607bdfd23c2 | 201810344eea3edf |
| 2026-11-27T19:00:38Z | c04-ex2-tl | duyu-1 | - | - | - | 3.68 | - | 201810344eea3edf |
| 2026-11-27T19:00:40Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.88 | e1f4d10784f34ddaaa3c9034755bd8ef | 1df74acc00f53310 |
| 2026-11-27T19:00:41Z | c05-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 1df74acc00f53310 |
| 2026-11-27T19:00:44Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 4.16 | 58f432edf60b4cdd9b0bafdfdd43147a | 2446505eaa69917c |
| 2026-11-27T19:00:45Z | c05-ex2-tl | duyu-1 | - | - | - | 4.16 | - | 2446505eaa69917c |
| 2026-11-27T19:00:47Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.88 | 075a441f49624793a7839e26fe816810 | c682604817d4c830 |
| 2026-11-27T19:00:48Z | c05-ex3-tl | duyu-1 | - | - | - | 2.88 | - | c682604817d4c830 |
| 2026-11-27T19:00:50Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.92 | d0a740c7bf354c618af42e1d86f5484a | 99943c4275023a2a |
| 2026-11-27T19:00:51Z | c05-ex4-tl | duyu-1 | - | - | - | 1.92 | - | 99943c4275023a2a |
| 2026-11-27T19:00:53Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.44 | 14d7d24d46a140aba5287e187faa67d2 | 7e5f453058009ae9 |
| 2026-11-27T19:00:54Z | c05-ex5-tl | duyu-1 | - | - | - | 1.44 | - | 7e5f453058009ae9 |
| 2026-11-27T19:00:56Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.6 | ef7f4daa6e4f4463b1729d726185bc4a | 35bb6103a97eb89d |
| 2026-11-27T19:00:57Z | c06-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 35bb6103a97eb89d |
| 2026-11-27T19:00:59Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.88 | ed28c5ca5fd44d889f3646c600d5e72e | 54d51b0a193a1731 |
| 2026-11-27T19:01:01Z | c07-q5-tl | duyu-1 | - | - | - | 2.88 | - | 54d51b0a193a1731 |
