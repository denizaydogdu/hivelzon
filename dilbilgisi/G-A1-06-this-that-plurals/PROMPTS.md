# G-A1-06-this-that-plurals PROMPTS

Ders: this / that / these / those ve çoğul -s · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:05:45Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 111 | 7.2 | 63306afc065b4c00b66262967fc78c09 | 8b52231a390cf593 |
| 2026-10-14T13:05:46Z | c01-tr | duyu-1 | - | - | - | 7.2 | - | 8b52231a390cf593 |
| 2026-10-14T13:05:49Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 11.94 | 2a9c07dc0e2f48c7b3e6b44927df6539 | 824806945a6ce145 |
| 2026-10-14T13:05:50Z | c02-tr | duyu-1 | - | - | - | 11.94 | - | 824806945a6ce145 |
| 2026-10-14T13:05:53Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 159 | 10.1 | 8cf7995cf8a14ea0ac881bd176918f16 | 4a793e00cf267b9c |
| 2026-10-14T13:05:54Z | c03-tr | duyu-1 | - | - | - | 10.1 | - | 4a793e00cf267b9c |
| 2026-10-14T13:05:56Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 9.76 | 975f245d56be412681b13c358bb29583 | 0f78d1395fa516b0 |
| 2026-10-14T13:05:57Z | c04-tr | duyu-1 | - | - | - | 9.76 | - | 0f78d1395fa516b0 |
| 2026-10-14T13:06:00Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 12.82 | 7be80003ed9e4d9aa8924a0009223a03 | 1cb70a8a4aa350d6 |
| 2026-10-14T13:06:01Z | c06-tr | duyu-1 | - | - | - | 12.82 | - | 1cb70a8a4aa350d6 |
| 2026-10-14T13:06:03Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.48 | 06466bf859ce4854b29d628dc5e49c98 | ab65d6764c5129b3 |
| 2026-10-14T13:06:04Z | c08-tr | duyu-1 | - | - | - | 4.48 | - | ab65d6764c5129b3 |
| 2026-10-14T13:06:07Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.26 | 199c64862f9740b982ca2d15ef0e2f53 | fd99c54e14afc86a |
| 2026-10-14T13:06:08Z | c09-tr | duyu-1 | - | - | - | 10.26 | - | fd99c54e14afc86a |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:54:22Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | de9fc86ae1fcb4ec | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:54:23Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | df63101fed847354 | audio/en/c02-ex1.mp3 |
| 2026-10-14T14:54:24Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 94ffe3ed8b7b8336 | audio/en/c02-ex2.mp3 |
| 2026-10-14T14:54:25Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 17a5eb84adfd207b | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:54:26Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | b83b583f136a97d8 | audio/en/c03-ex2.mp3 |
| 2026-10-14T14:54:27Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 8da8035d789bdb33 | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:54:28Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 4a639601588b2b7f | audio/en/c04-ex2.mp3 |
| 2026-10-14T14:54:29Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | bea20617d54dcd5e | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:54:30Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | e757e9291c3ceda4 | audio/en/c05-ex2.mp3 |
| 2026-10-14T14:54:31Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 1a141f21eb07c6fc | audio/en/c05-ex3.mp3 |
| 2026-10-14T14:54:32Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | b660171e4755f91a | audio/en/c05-ex4.mp3 |
| 2026-10-14T14:54:33Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 18e9a4ef5a0ee330 | audio/en/c05-ex5.mp3 |
| 2026-10-14T14:54:34Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 9 | a7a2b9611ef63cd9 | audio/en/c06-ex1.mp3 |
| 2026-10-14T14:54:35Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | f940f5e58060c0ca | audio/en/c06-ex2.mp3 |
| 2026-10-14T14:54:36Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 4fc3919968e556c4 | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:18:10Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 3.04 | 7a62e59d02a847fea041f8e7f29aab29 | 43abaf85e8d1aa4a |
| 2026-11-27T18:18:11Z | c07-q1-fb | duyu-1 | - | - | - | 3.04 | - | 43abaf85e8d1aa4a |
| 2026-11-27T18:18:13Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 5eb99c440b25483c98a6008c5309460a | dbee6f14d20c0479 |
| 2026-11-27T18:18:14Z | c07-q2-fb | duyu-1 | - | - | - | 1.76 | - | dbee6f14d20c0479 |
| 2026-11-27T18:18:16Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.4 | 27c3326eccf04c5692af5f46c252e8f9 | 99c91b61322c111f |
| 2026-11-27T18:18:17Z | c07-q3-fb | duyu-1 | - | - | - | 2.4 | - | 99c91b61322c111f |
| 2026-11-27T18:18:19Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 3.52 | 3144e0048d6641db932520a3e3872e7c | 27356606e11b99bb |
| 2026-11-27T18:18:21Z | c07-q4-fb | duyu-1 | - | - | - | 3.52 | - | 27356606e11b99bb |
| 2026-11-27T18:59:30Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | a2e9bf9f7cfb4a799b3006b2d044fced | fbed55fe873c86a4 |
| 2026-11-27T18:59:31Z | c01-ex1-tl | duyu-1 | - | - | - | 1.76 | - | fbed55fe873c86a4 |
| 2026-11-27T18:59:32Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | 84f90105e266424bbe5fb95aad5fb312 | 0dc0eb19a1ab41d8 |
| 2026-11-27T18:59:33Z | c02-ex1-tl | duyu-1 | - | - | - | 1.28 | - | 0dc0eb19a1ab41d8 |
| 2026-11-27T18:59:35Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.12 | 3a7503f269bc4d54a0d69412798bad07 | 9456370996ba2187 |
| 2026-11-27T18:59:36Z | c02-ex2-tl | duyu-1 | - | - | - | 1.12 | - | 9456370996ba2187 |
| 2026-11-27T18:59:38Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | d5b006b301b54e019cfea22ff779ee2e | 28d1397df167d9f6 |
| 2026-11-27T18:59:39Z | c03-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 28d1397df167d9f6 |
| 2026-11-27T18:59:41Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | 60c29b3a20ad43909e8efba21d10fe5f | 24c872cc94c9c1a3 |
| 2026-11-27T18:59:42Z | c03-ex2-tl | duyu-1 | - | - | - | 1.76 | - | 24c872cc94c9c1a3 |
| 2026-11-27T18:59:44Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 4.0 | fea2cab913024008b52cd54a33774a0d | bf9ee55082d3dad9 |
| 2026-11-27T18:59:46Z | c04-ex1-tl | duyu-1 | - | - | - | 4.0 | - | bf9ee55082d3dad9 |
| 2026-11-27T18:59:48Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | 0e3016a2da0f4e288c2a5fd07c56f0e2 | fb3e0a08f77be91e |
| 2026-11-27T18:59:48Z | c04-ex2-tl | duyu-1 | - | - | - | 1.44 | - | fb3e0a08f77be91e |
| 2026-11-27T18:59:51Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.4 | 7585ca8a396f46eb82602163c7a9ae64 | 302cde59b90d30a4 |
| 2026-11-27T18:59:52Z | c05-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 302cde59b90d30a4 |
| 2026-11-27T18:59:54Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | f9189a68d25a491fa37ddf8871210c93 | b09efa7c10157178 |
| 2026-11-27T18:59:55Z | c05-ex2-tl | duyu-1 | - | - | - | 1.44 | - | b09efa7c10157178 |
| 2026-11-27T18:59:57Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | 830122a42d0d42f2bf2150df013fc0a7 | e4dfafb7d3a2c764 |
| 2026-11-27T18:59:58Z | c05-ex3-tl | duyu-1 | - | - | - | 1.6 | - | e4dfafb7d3a2c764 |
| 2026-11-27T18:59:59Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.44 | 9b861fb5a85a48b688996816d423f30d | a97f898587d456ba |
| 2026-11-27T19:00:00Z | c05-ex4-tl | duyu-1 | - | - | - | 1.44 | - | a97f898587d456ba |
| 2026-11-27T19:00:03Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.72 | 22d830e998f74a3c8c709897bd58284a | 51da253f1aeba6b1 |
| 2026-11-27T19:00:04Z | c05-ex5-tl | duyu-1 | - | - | - | 2.72 | - | 51da253f1aeba6b1 |
| 2026-11-27T19:00:06Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.92 | 4450a6ff63fb458682f19a4424f6219f | e31b4f7d32ddd09f |
| 2026-11-27T19:00:07Z | c06-ex1-tl | duyu-1 | - | - | - | 1.92 | - | e31b4f7d32ddd09f |
| 2026-11-27T19:00:09Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 3.52 | 5bd5f0be20f64956923d24afe279c67f | 52eb623d74beaced |
| 2026-11-27T19:00:11Z | c06-ex2-tl | duyu-1 | - | - | - | 3.52 | - | 52eb623d74beaced |
| 2026-11-27T19:00:13Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.72 | 3e6e607cd7e74771adc113f39805772f | f4fe0cbb38d320db |
| 2026-11-27T19:00:14Z | c09-ex1-tl | duyu-1 | - | - | - | 2.72 | - | f4fe0cbb38d320db |
