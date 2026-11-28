# G-B2-08-present-perfect-continuous PROMPTS

Ders: Present perfect continuous: have been + -ing · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** -ing → ing.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:11:00Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 9.6 | c8e5291ce7ac467fb12b82ce2668d22c | 14b07f13a533437e |
| 2026-10-14T14:11:01Z | c01-tr | duyu-1 | - | - | - | 9.6 | - | 14b07f13a533437e |
| 2026-10-14T14:11:04Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 192 | 13.45 | d87ce58fb71e4ac699562719673ee876 | 47239595f051c04e |
| 2026-10-14T14:11:05Z | c02-tr | duyu-1 | - | - | - | 13.45 | - | 47239595f051c04e |
| 2026-10-14T14:11:08Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.27 | 8218d3a4533c48b08a83267033c5ca87 | babe63d7918df5fa |
| 2026-10-14T14:11:10Z | c03-tr | duyu-1 | - | - | - | 10.27 | - | babe63d7918df5fa |
| 2026-10-14T14:11:13Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 217 | 14.59 | dd051b93569c48ba9e87b6c020b2abda | 9d219861b0ffe15a |
| 2026-10-14T14:11:14Z | c04-tr | duyu-1 | - | - | - | 14.59 | - | 9d219861b0ffe15a |
| 2026-10-14T14:11:17Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 14.11 | e510e3af60ec4b86a82b85d90cb397aa | bf4f065317634a9b |
| 2026-10-14T14:11:19Z | c06-tr | duyu-1 | - | - | - | 14.11 | - | bf4f065317634a9b |
| 2026-10-14T14:11:21Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 10.56 | ed328e3973c84cbbb4393f688205b344 | 155aa161899c2dd8 |
| 2026-10-14T14:11:23Z | c08-tr | duyu-1 | - | - | - | 10.56 | - | 155aa161899c2dd8 |
| 2026-11-20T16:00:49Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 10.27 | 38524111776e4d259b44c64212d1e837 | 453e4c27847e88a2 |
| 2026-11-20T16:00:51Z | c01-tr | duyu-1 | - | - | - | 10.27 | - | 453e4c27847e88a2 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:04:40Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 47 | e58c23815f4f82c5 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:04:42Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | c8f6f0889bb48887 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:04:43Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | ee962c24d11ae331 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:04:45Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | 567bffee959d9a99 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:04:47Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | fa32e924ff568869 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:04:49Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 43 | eee3c6ed2d793eed | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:04:51Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | 67e367fec8304090 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:04:53Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | 4fdc0ade561d6596 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:04:55Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | 669ba1ae00f4e3cc | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:04:56Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | ed120a86895ab1b2 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:04:58Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 926a524947cbb9d4 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:05:00Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 25 | 500e53c241dbbcc5 | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:29:01Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 3.84 | c595d156f6354ae085cee6f55913ee6b | 6460bc0cf05cfd81 |
| 2026-11-27T18:29:02Z | c07-q1-fb | duyu-1 | - | - | - | 3.84 | - | 6460bc0cf05cfd81 |
| 2026-11-27T18:29:05Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 3.52 | ab23d33c7b5c4aeab42f156927dde4a8 | ff561caa50f253cc |
| 2026-11-27T18:29:06Z | c07-q2-fb | duyu-1 | - | - | - | 3.52 | - | ff561caa50f253cc |
| 2026-11-27T18:29:08Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.24 | a958e35ef3e04dfdaaa030218675d019 | 7b2a4b19b7d2a3d0 |
| 2026-11-27T18:29:09Z | c07-q3-fb | duyu-1 | - | - | - | 2.24 | - | 7b2a4b19b7d2a3d0 |
| 2026-11-27T18:29:11Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 49 | 3.52 | d68f88ccff97468f9c8ba9b17396bbab | c8cceebc16d8c091 |
| 2026-11-27T18:29:12Z | c07-q4-fb | duyu-1 | - | - | - | 3.52 | - | c8cceebc16d8c091 |
| 2026-11-27T19:32:25Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 2.4 | a795d0c7adbf4b0abf2abd31aded5d9f | 3e6a2b2b848fa6d2 |
| 2026-11-27T19:32:26Z | c01-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 3e6a2b2b848fa6d2 |
| 2026-11-27T19:32:28Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 3.52 | 73e35e0c458e4c2080d7f8657bf96222 | 98c95a3d2916e661 |
| 2026-11-27T19:32:29Z | c02-ex1-tl | duyu-1 | - | - | - | 3.52 | - | 98c95a3d2916e661 |
| 2026-11-27T19:32:31Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.4 | 0251e018fea84bcd9778d3ed7523ae81 | a0bcd84e5717b48c |
| 2026-11-27T19:32:32Z | c03-ex1-tl | duyu-1 | - | - | - | 2.4 | - | a0bcd84e5717b48c |
| 2026-11-27T19:32:35Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 3.04 | 62c9f402c6ff4cbdab413ab58702ea5c | 38a829aaaf5fffda |
| 2026-11-27T19:32:36Z | c03-ex2-tl | duyu-1 | - | - | - | 3.04 | - | 38a829aaaf5fffda |
| 2026-11-27T19:32:38Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.6 | afb089bf583343f8843cd62bbc01f386 | 19b282beb42bec86 |
| 2026-11-27T19:32:38Z | c04-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 19b282beb42bec86 |
| 2026-11-27T19:32:40Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.08 | 45eca6a530e244a0bab75e563971e21e | f0cc7e88c82b3807 |
| 2026-11-27T19:32:41Z | c05-ex1-tl | duyu-1 | - | - | - | 2.08 | - | f0cc7e88c82b3807 |
| 2026-11-27T19:32:43Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.24 | 0ecbdb66237b4b508d3b5f808549b456 | 2ff1914c42da4a51 |
| 2026-11-27T19:32:44Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 2ff1914c42da4a51 |
| 2026-11-27T19:32:46Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.08 | 06c0194231a94d0d9cd9fea896548f35 | ba1d19522eb264f0 |
| 2026-11-27T19:32:47Z | c05-ex3-tl | duyu-1 | - | - | - | 2.08 | - | ba1d19522eb264f0 |
| 2026-11-27T19:32:49Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.88 | 6ce41543e8ff40aa98353785c24fde13 | 6fe56521cf79e5c0 |
| 2026-11-27T19:32:50Z | c05-ex4-tl | duyu-1 | - | - | - | 2.88 | - | 6fe56521cf79e5c0 |
| 2026-11-27T19:32:52Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.24 | b81864ac18ec4e9b90d331064ee8e573 | ab69030b59967815 |
| 2026-11-27T19:32:53Z | c05-ex5-tl | duyu-1 | - | - | - | 2.24 | - | ab69030b59967815 |
| 2026-11-27T19:32:56Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.56 | 29a359b484c44b56a76c016ad88d4103 | 3a3c5497cddbf3f6 |
| 2026-11-27T19:32:57Z | c06-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 3a3c5497cddbf3f6 |
| 2026-11-27T19:33:00Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 4.07 | 8f4a3d9cd5eb4e2ab7913ca1f48a7eb1 | 2f6060edbf70b60b |
| 2026-11-27T19:33:02Z | c06-ex2-tl | duyu-1 | - | - | - | 4.07 | - | 2f6060edbf70b60b |
