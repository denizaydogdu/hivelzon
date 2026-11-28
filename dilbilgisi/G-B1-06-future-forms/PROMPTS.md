# G-B1-06-future-forms PROMPTS

Ders: Gelecek: will, going to, şimdiki zamanla randevu · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:07:23Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 190 | 13.95 | a6d897a9958e4abb8653d0113970ea39 | 976f35ca8d4833bf |
| 2026-10-14T14:07:25Z | c01-tr | duyu-1 | - | - | - | 13.95 | - | 976f35ca8d4833bf |
| 2026-10-14T14:07:28Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 10.88 | 1c92e8da1dbb451890c98ddb62dacc38 | c294552ac3e4e801 |
| 2026-10-14T14:07:29Z | c02-tr | duyu-1 | - | - | - | 10.88 | - | c294552ac3e4e801 |
| 2026-10-14T14:07:33Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 207 | 14.2 | b11e4e3e65e3433f9768e3a1a82833b5 | f5b07b2f2332cbb8 |
| 2026-10-14T14:07:34Z | c03-tr | duyu-1 | - | - | - | 14.2 | - | f5b07b2f2332cbb8 |
| 2026-10-14T14:07:37Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 248 | 16.7 | f0380fce25524cfaba5e1c19ccd3fc9f | e535cb9aae75a7f9 |
| 2026-10-14T14:07:38Z | c05-tr | duyu-1 | - | - | - | 16.7 | - | e535cb9aae75a7f9 |
| 2026-10-14T14:07:41Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 76 | 4.64 | 1bcec31fdc6f452c9382c000aa73861b | d65f55aea2f241a6 |
| 2026-10-14T14:07:42Z | c07-tr | duyu-1 | - | - | - | 4.64 | - | d65f55aea2f241a6 |
| 2026-10-14T14:07:44Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 11.39 | 15b0567f364b4bc1a18909833b16a48e | 80605e4e5d8212c2 |
| 2026-10-14T14:07:45Z | c08-tr | duyu-1 | - | - | - | 11.39 | - | 80605e4e5d8212c2 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T13:59:30Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 11 | d290923960920881 | audio/en/c01-ex1.mp3 |
| 2026-11-26T13:59:31Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | ceabd7c8f48ad2ff | audio/en/c02-ex1.mp3 |
| 2026-11-26T13:59:33Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 9667c76f94bcdb57 | audio/en/c02-ex2.mp3 |
| 2026-11-26T13:59:34Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | c294f52e76a66627 | audio/en/c03-ex1.mp3 |
| 2026-11-26T13:59:36Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 376bf3024c7ea9e5 | audio/en/c03-ex2.mp3 |
| 2026-11-26T13:59:38Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 34 | eeff5809adb83ad3 | audio/en/c03-ex3.mp3 |
| 2026-11-26T13:59:40Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 1ef02448c5d57696 | audio/en/c04-ex1.mp3 |
| 2026-11-26T13:59:41Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | 763982bce37ac0ae | audio/en/c04-ex2.mp3 |
| 2026-11-26T13:59:43Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | cd12106b19f31861 | audio/en/c04-ex3.mp3 |
| 2026-11-26T13:59:45Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | c26fa058718321ee | audio/en/c04-ex4.mp3 |
| 2026-11-26T13:59:47Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | 4942048822b0536f | audio/en/c04-ex5.mp3 |
| 2026-11-26T13:59:48Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | 7cab89c1c27d0815 | audio/en/c05-ex1.mp3 |
| 2026-11-26T13:59:50Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 3ad4553d62db3e91 | audio/en/c05-ex2.mp3 |
| 2026-11-26T13:59:51Z | c08-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | b31c541fa9aa1cf1 | audio/en/c08-ex1.mp3 |
| 2026-11-27T18:25:17Z | c06-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 3.04 | eed8360c728046b0b18c0ce989463bf1 | 47b4c93010f9a688 |
| 2026-11-27T18:25:18Z | c06-q1-fb | duyu-1 | - | - | - | 3.04 | - | 47b4c93010f9a688 |
| 2026-11-27T18:25:20Z | c06-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.08 | d8f3283f0a264f9c8af6d8f1c12e5cf6 | 68b1ce4235bc3a81 |
| 2026-11-27T18:25:21Z | c06-q2-fb | duyu-1 | - | - | - | 2.08 | - | 68b1ce4235bc3a81 |
| 2026-11-27T18:25:24Z | c06-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 50 | 3.84 | a3866b33e5f24dab80adca7981d5352a | 78e97ac32ccfb358 |
| 2026-11-27T18:25:25Z | c06-q3-fb | duyu-1 | - | - | - | 3.84 | - | 78e97ac32ccfb358 |
| 2026-11-27T18:25:27Z | c06-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 3.04 | 147f395e9ef540689ff00dcb53af15d8 | 45328d03f131041b |
| 2026-11-27T18:25:28Z | c06-q4-fb | duyu-1 | - | - | - | 3.04 | - | 45328d03f131041b |
| 2026-11-27T19:21:10Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 0.96 | f59717da8caf4bef97e12edf86b9bb92 | 6d5efde0fbec5b3d |
| 2026-11-27T19:21:10Z | c01-ex1-tl | duyu-1 | - | - | - | 0.96 | - | 6d5efde0fbec5b3d |
| 2026-11-27T19:21:13Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 3.84 | eb28abfc0d104abd92ee2d9d17540c28 | b246d7ef3a235677 |
| 2026-11-27T19:21:14Z | c02-ex1-tl | duyu-1 | - | - | - | 3.84 | - | b246d7ef3a235677 |
| 2026-11-27T19:21:17Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.76 | 05406fdbc2cf49b58cadc188eccd8298 | f945ea1f37f56e9d |
| 2026-11-27T19:21:18Z | c02-ex2-tl | duyu-1 | - | - | - | 1.76 | - | f945ea1f37f56e9d |
| 2026-11-27T19:21:20Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 488a9164e6f843268fed97f22b8490d5 | c0a67c5068cd1901 |
| 2026-11-27T19:21:21Z | c03-ex1-tl | duyu-1 | - | - | - | 1.28 | - | c0a67c5068cd1901 |
| 2026-11-27T19:21:23Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.72 | cdcf68cc8b5e4bbeb6d8cdb82b8031d7 | 71a63ac1241fa964 |
| 2026-11-27T19:21:24Z | c03-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 71a63ac1241fa964 |
| 2026-11-27T19:21:27Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 3.04 | b498a76e65454729b7b094563860d18a | 073d1dd8d5c53df2 |
| 2026-11-27T19:21:28Z | c03-ex3-tl | duyu-1 | - | - | - | 3.04 | - | 073d1dd8d5c53df2 |
| 2026-11-27T19:21:30Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.24 | 4a73d9c2a7e94e11be8dbec1f38d839a | 0711c979cc01e7e2 |
| 2026-11-27T19:21:31Z | c04-ex1-tl | duyu-1 | - | - | - | 2.24 | - | 0711c979cc01e7e2 |
| 2026-11-27T19:21:33Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.56 | b2c89029251447b89c0eed60fb9b9759 | 253c9d50d22f3d23 |
| 2026-11-27T19:21:34Z | c04-ex2-tl | duyu-1 | - | - | - | 2.56 | - | 253c9d50d22f3d23 |
| 2026-11-27T19:21:36Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.56 | f852117034f54a5b8de947211e42df29 | cbe01de193f23a1f |
| 2026-11-27T19:21:37Z | c04-ex3-tl | duyu-1 | - | - | - | 2.56 | - | cbe01de193f23a1f |
| 2026-11-27T19:21:39Z | c04-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 3.04 | 6edb5777ad2a475ca8f284d4d1348bdb | ca0b9d9e2618767d |
| 2026-11-27T19:21:40Z | c04-ex4-tl | duyu-1 | - | - | - | 3.04 | - | ca0b9d9e2618767d |
| 2026-11-27T19:21:43Z | c04-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.56 | 616264a2e1ae405d8f813c0fdb3fb545 | b4462e62a04dc279 |
| 2026-11-27T19:21:43Z | c04-ex5-tl | duyu-1 | - | - | - | 2.56 | - | b4462e62a04dc279 |
| 2026-11-27T19:21:46Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.6 | 104eaa709e9e43a4ba680c20d017e4c2 | 6bb81e7dc3f1ecbc |
| 2026-11-27T19:21:46Z | c05-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 6bb81e7dc3f1ecbc |
| 2026-11-27T19:21:49Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.88 | 0eec99cb660c4f6082e7d02a98cd41e0 | c93f01bcfc7a822d |
| 2026-11-27T19:21:50Z | c05-ex2-tl | duyu-1 | - | - | - | 2.88 | - | c93f01bcfc7a822d |
| 2026-11-27T19:21:53Z | c08-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.4 | bb1630f872c8453a91afdeb52a1c006d | a37ccb713c797ae3 |
| 2026-11-27T19:21:54Z | c08-ex1-tl | duyu-1 | - | - | - | 2.4 | - | a37ccb713c797ae3 |
