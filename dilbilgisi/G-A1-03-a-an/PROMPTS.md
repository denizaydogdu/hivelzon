# G-A1-03-a-an PROMPTS

Ders: a / an: "bir"i söylemek · Pilot (H-079) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `Alex` → "Aleks". İki biçim (a / an) Türkçe anlatımda geçmez; ayrı İngilizce örnek parçalarında duyulur.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). İngilizce örnekler (Sarah, ElevenLabs) sonradan üretildi. Yeni üretimler için çalışan ElevenLabs erişimi/ayrı onaylı plan gerekir; 2026-10-27'de 401 veren anahtar kullanılmaz.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T11:45:23Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 108 | 7.2 | 294ec6e3f3e44ba49679d4d1c0b57b31 | be820bd15a82bcf5 |
| 2026-10-14T11:45:24Z | c01-tr | duyu-1 | - | - | - | 7.2 | - | be820bd15a82bcf5 |
| 2026-10-14T11:45:27Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 10.11 | e3ba734935e2441887a8ee86d50744a5 | 2dca8d886a50fafa |
| 2026-10-14T11:45:28Z | c02-tr | duyu-1 | - | - | - | 10.11 | - | 2dca8d886a50fafa |
| 2026-10-14T11:45:30Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 155 | 9.95 | 8847f89fde234ef2aa7bc3c2ec4b174b | 5caafbac5ff4865e |
| 2026-10-14T11:45:31Z | c03-tr | duyu-1 | - | - | - | 9.95 | - | 5caafbac5ff4865e |
| 2026-10-14T11:45:34Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 8.32 | 10bf250c628c4857a09cd6bf1a39021c | 325eb70c16a9399c |
| 2026-10-14T11:45:35Z | c04-tr | duyu-1 | - | - | - | 8.32 | - | 325eb70c16a9399c |
| 2026-10-14T11:45:37Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 10.11 | a58e2c1a0177444eafe5499ef5721fd1 | 433218816681abf9 |
| 2026-10-14T11:45:38Z | c06-tr | duyu-1 | - | - | - | 10.11 | - | 433218816681abf9 |
| 2026-10-14T11:45:41Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.64 | 4808ed1b90f149eda6aa39e1b6896406 | 61703e54eea8e3f2 |
| 2026-10-14T11:45:41Z | c08-tr | duyu-1 | - | - | - | 4.64 | - | 61703e54eea8e3f2 |
| 2026-10-14T11:45:44Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 133 | 8.16 | a89efbc96cfc45ae9ecc7b7e806b1896 | 841a18fdcd94545c |
| 2026-10-14T11:45:45Z | c09-tr | duyu-1 | - | - | - | 8.16 | - | 841a18fdcd94545c |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T12:15:16Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 5bf49a4a8b257c25 | audio/en/c01-ex1.mp3 |
| 2026-10-14T12:15:17Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 14 | 6b657556a0442c4e | audio/en/c03-ex1.mp3 |
| 2026-10-14T12:15:18Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | f76fa81fd29ef5ea | audio/en/c03-ex2.mp3 |
| 2026-10-14T12:15:19Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 2056aef5bdcd6322 | audio/en/c04-ex1.mp3 |
| 2026-10-14T12:15:20Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 16c5fc4f35e0a5c2 | audio/en/c04-ex2.mp3 |
| 2026-10-14T12:15:21Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | afa550a35691cd14 | audio/en/c05-ex1.mp3 |
| 2026-10-14T12:15:22Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | a7c71d41446e6a21 | audio/en/c05-ex2.mp3 |
| 2026-10-14T12:15:23Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 6e94b1c1157490b9 | audio/en/c05-ex3.mp3 |
| 2026-10-14T12:15:25Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 28 | a45304ab17cac499 | audio/en/c05-ex4.mp3 |
| 2026-10-14T12:15:26Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | 3a213809c4903f0d | audio/en/c05-ex5.mp3 |
| 2026-10-14T12:15:27Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | d09712b2f0cb1e08 | audio/en/c06-ex2.mp3 |
| 2026-10-14T12:15:29Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 697e2a388acad78b | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:17:30Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.68 | e8fa4f332c2c4d51a0e3d73ed5c97980 | a7501b4cc27b3bf1 |
| 2026-11-27T18:17:31Z | c07-q1-fb | duyu-1 | - | - | - | 3.68 | - | a7501b4cc27b3bf1 |
| 2026-11-27T18:17:33Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 3.36 | c5498bf92ffc4f37bc541ead17e5702d | 08cc7118bac720c2 |
| 2026-11-27T18:17:34Z | c07-q2-fb | duyu-1 | - | - | - | 3.36 | - | 08cc7118bac720c2 |
| 2026-11-27T18:17:37Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.88 | d9ab8a7fa11e4cb1a39ea67125d508d6 | 31b64b16568bed76 |
| 2026-11-27T18:17:38Z | c07-q3-fb | duyu-1 | - | - | - | 2.88 | - | 31b64b16568bed76 |
| 2026-11-27T18:17:40Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.68 | 72f4b53546e74d18948ea652d8797187 | cef68cff705be929 |
| 2026-11-27T18:17:41Z | c07-q4-fb | duyu-1 | - | - | - | 3.68 | - | cef68cff705be929 |
| 2026-11-27T18:57:36Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.44 | 0a6499a2625c4a1e8e3b4e0ef52cde61 | dfa3aa7281c8c4d8 |
| 2026-11-27T18:57:37Z | c01-ex1-tl | duyu-1 | - | - | - | 1.44 | - | dfa3aa7281c8c4d8 |
| 2026-11-27T18:57:39Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.12 | 0891a0e2cdee435cbf27683a4f23db6c | b94bd0d3ae914bee |
| 2026-11-27T18:57:40Z | c03-ex1-tl | duyu-1 | - | - | - | 1.12 | - | b94bd0d3ae914bee |
| 2026-11-27T18:57:42Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.12 | 95dfeb6bec4449768b71ff0886e0158f | ee35c24251b3ac43 |
| 2026-11-27T18:57:43Z | c03-ex2-tl | duyu-1 | - | - | - | 1.12 | - | ee35c24251b3ac43 |
| 2026-11-27T18:57:45Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 2.08 | 62790938ffa94df7abdccab137bd976c | e494bcae1f45055b |
| 2026-11-27T18:57:47Z | c04-ex1-tl | duyu-1 | - | - | - | 2.08 | - | e494bcae1f45055b |
| 2026-11-27T18:57:49Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | b9c506819c20404186e3d50500839240 | 8179cf853a1e50b6 |
| 2026-11-27T18:57:49Z | c04-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 8179cf853a1e50b6 |
| 2026-11-27T18:57:51Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.12 | 5eb6f75fb76e44c2be0d0cf65cfe6d8e | 9bfb7a8391eeaaa2 |
| 2026-11-27T18:57:52Z | c05-ex1-tl | duyu-1 | - | - | - | 1.12 | - | 9bfb7a8391eeaaa2 |
| 2026-11-27T18:57:54Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.44 | efbd17e328154da4b03b5666ef9c1273 | b6ed64da2746f47f |
| 2026-11-27T18:57:55Z | c05-ex2-tl | duyu-1 | - | - | - | 1.44 | - | b6ed64da2746f47f |
| 2026-11-27T18:57:57Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | fa89fa89fd594969b533bc02c2618245 | 5e45c4b1f4c23e7b |
| 2026-11-27T18:57:58Z | c05-ex3-tl | duyu-1 | - | - | - | 1.28 | - | 5e45c4b1f4c23e7b |
| 2026-11-27T18:58:00Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 2.08 | d821b459d4bc4690af8d5cb5b4694ad7 | 82d671484e4c3c0f |
| 2026-11-27T18:58:01Z | c05-ex4-tl | duyu-1 | - | - | - | 2.08 | - | 82d671484e4c3c0f |
| 2026-11-27T18:58:03Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 8b5018c312af4311ba0887f7a66664a3 | b8caa9109c19467d |
| 2026-11-27T18:58:04Z | c05-ex5-tl | duyu-1 | - | - | - | 1.28 | - | b8caa9109c19467d |
| 2026-11-27T18:58:05Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.28 | 595b66249b6d4b21a09253e4fa60d951 | 5fccf98bf8c0a30d |
| 2026-11-27T18:58:06Z | c09-ex1-tl | duyu-1 | - | - | - | 1.28 | - | 5fccf98bf8c0a30d |
