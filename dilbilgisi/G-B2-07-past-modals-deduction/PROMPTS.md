# G-B2-07-past-modals-deduction PROMPTS

Ders: Geçmişe dair çıkarım: must have, can't have, might have · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** Alex → Aleks.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:10:13Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 10.43 | 54cff248f11a451a8e380bdd497989ed | db8f7e8b650323af |
| 2026-10-14T14:10:14Z | c01-tr | duyu-1 | - | - | - | 10.43 | - | db8f7e8b650323af |
| 2026-10-14T14:10:16Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 201 | 13.47 | 97cd91e369784ca1ac2dc4831e7b9685 | 148a74128fb39bd2 |
| 2026-10-14T14:10:18Z | c02-tr | duyu-1 | - | - | - | 13.47 | - | 148a74128fb39bd2 |
| 2026-10-14T14:10:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 195 | 12.35 | a52f9158c34f411e9b612cbd567985c9 | c38aa00afc4b1eb9 |
| 2026-10-14T14:10:22Z | c03-tr | duyu-1 | - | - | - | 12.35 | - | c38aa00afc4b1eb9 |
| 2026-10-14T14:10:24Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 10.11 | 7545c4b4f4db4423b5854928272da265 | c732fb844ca4dddd |
| 2026-10-14T14:10:26Z | c04-tr | duyu-1 | - | - | - | 10.11 | - | c732fb844ca4dddd |
| 2026-10-14T14:10:29Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 215 | 15.39 | f2f982a4787a4eb5b6999c979fd2d027 | 55573d456d150094 |
| 2026-10-14T14:10:30Z | c06-tr | duyu-1 | - | - | - | 15.39 | - | 55573d456d150094 |
| 2026-10-14T14:10:33Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 183 | 12.49 | 15f153cd7f01443287d8a98308b86bfd | 900505a6c8d5c958 |
| 2026-10-14T14:10:35Z | c08-tr | duyu-1 | - | - | - | 12.49 | - | 900505a6c8d5c958 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:04:11Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | e5a8966c1e12fe42 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:04:13Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 14cc1aee4eecc402 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:04:15Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | a88492b6ec65c173 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:04:18Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | c56b7e1d713aa107 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:04:20Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 0dcf8974915236ba | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:04:23Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 50 | d69840928175d783 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:04:25Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 64 | 9e3230e007f45c0d | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:04:28Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 55 | f3ce0171cf965990 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:04:30Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 52 | c431e942f2e10b82 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:04:32Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 968f5c45bd3b8913 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:04:34Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 46e9bf74cabb8629 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:04:36Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | d702b55a854b3388 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:04:38Z | c09-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | e87adabd9137e07b | audio/en/c09-ex2.mp3 |
| 2026-11-27T18:28:46Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 3.2 | fc07d1ce968145429607bd3d3d9b94ab | 4dc3f2090b1dabdf |
| 2026-11-27T18:28:47Z | c07-q1-fb | duyu-1 | - | - | - | 3.2 | - | 4dc3f2090b1dabdf |
| 2026-11-27T18:28:50Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 61 | 4.96 | 268cd354fc3c4ce5a9fde5c0cc9a517f | 0f9a3767b4422503 |
| 2026-11-27T18:28:51Z | c07-q2-fb | duyu-1 | - | - | - | 4.96 | - | 0f9a3767b4422503 |
| 2026-11-27T18:28:53Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 3.04 | fa239f5e82114e759b68b292eee91f63 | d013e690a9835963 |
| 2026-11-27T18:28:55Z | c07-q3-fb | duyu-1 | - | - | - | 3.04 | - | d013e690a9835963 |
| 2026-11-27T18:28:57Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 46 | 3.68 | 1b9f6adbee1e438c9a27d10101feb2fd | f5a9b16f03ce1eee |
| 2026-11-27T18:28:58Z | c07-q4-fb | duyu-1 | - | - | - | 3.68 | - | f5a9b16f03ce1eee |
| 2026-11-27T19:31:43Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | 322c189d6e634946ba224d96ad2d0470 | d0fa23838210a028 |
| 2026-11-27T19:31:43Z | c01-ex1-tl | duyu-1 | - | - | - | 1.44 | - | d0fa23838210a028 |
| 2026-11-27T19:31:46Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 3.84 | 385709cd9f394fcf9414055dae0260ae | aadd30a89f324fd2 |
| 2026-11-27T19:31:47Z | c02-ex1-tl | duyu-1 | - | - | - | 3.84 | - | aadd30a89f324fd2 |
| 2026-11-27T19:31:49Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.88 | 2aef994319874695accbf82c99b7d566 | aed08bdb12f8528b |
| 2026-11-27T19:31:50Z | c03-ex1-tl | duyu-1 | - | - | - | 2.88 | - | aed08bdb12f8528b |
| 2026-11-27T19:31:53Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 3.84 | ba1336e55497434bac1f50204ded8951 | 67f115f018647fdd |
| 2026-11-27T19:31:54Z | c03-ex2-tl | duyu-1 | - | - | - | 3.84 | - | 67f115f018647fdd |
| 2026-11-27T19:31:56Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 2.08 | d7fe3e7ed09f41e2b2b5e15227421b5d | 398a897fedf64513 |
| 2026-11-27T19:31:57Z | c04-ex1-tl | duyu-1 | - | - | - | 2.08 | - | 398a897fedf64513 |
| 2026-11-27T19:31:59Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 3.2 | cc53b76b9a3f48afa106038a2324609c | 0ca8e62c24813dca |
| 2026-11-27T19:32:00Z | c05-ex1-tl | duyu-1 | - | - | - | 3.2 | - | 0ca8e62c24813dca |
| 2026-11-27T19:32:03Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 3.2 | ea752e735549454aad193cc36b9c0c94 | 291639f22ab6e00e |
| 2026-11-27T19:32:04Z | c05-ex2-tl | duyu-1 | - | - | - | 3.2 | - | 291639f22ab6e00e |
| 2026-11-27T19:32:06Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 3.36 | c0528f74557345529c8579496f054e5f | c0e33dfc5ab8401a |
| 2026-11-27T19:32:07Z | c05-ex3-tl | duyu-1 | - | - | - | 3.36 | - | c0e33dfc5ab8401a |
| 2026-11-27T19:32:09Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.72 | 2324b373f6054c1d89106f9a3eae48a1 | 17bbde101551e096 |
| 2026-11-27T19:32:10Z | c05-ex4-tl | duyu-1 | - | - | - | 2.72 | - | 17bbde101551e096 |
| 2026-11-27T19:32:13Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.4 | 8d485adac71d4858aa8a5e8f4d654673 | 8a9c6bbf34d1988b |
| 2026-11-27T19:32:14Z | c05-ex5-tl | duyu-1 | - | - | - | 2.4 | - | 8a9c6bbf34d1988b |
| 2026-11-27T19:32:16Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.44 | 17e4b8a71bdb4507b622fc8163a831d9 | 33ae4e1565eb31d7 |
| 2026-11-27T19:32:17Z | c06-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 33ae4e1565eb31d7 |
| 2026-11-27T19:32:19Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | 4d5600c693d247e5b44a2fcb02071f6f | ae3681da62971151 |
| 2026-11-27T19:32:20Z | c06-ex2-tl | duyu-1 | - | - | - | 1.44 | - | ae3681da62971151 |
| 2026-11-27T19:32:22Z | c09-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 3.04 | dcac833e0804483690e9627527c13672 | 5207bb8cdd50b6d7 |
| 2026-11-27T19:32:23Z | c09-ex2-tl | duyu-1 | - | - | - | 3.04 | - | 5207bb8cdd50b6d7 |
