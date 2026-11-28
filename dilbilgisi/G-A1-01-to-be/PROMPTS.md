# G-A1-01-to-be PROMPTS

Ders: am / is / are: "olmak" fiili · Pilot (H-079) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `Alex` → "Aleks" (ad; İngilizce kelime değil). Biçimlerin kendisi (am / is / are) Türkçe anlatımda geçmez; ayrı İngilizce örnek parçalarında duyulur.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). İngilizce örnekler (Sarah, ElevenLabs) sonradan üretildi. Yeni üretimler için çalışan ElevenLabs erişimi/ayrı onaylı plan gerekir; 2026-10-27'de 401 veren anahtar kullanılmaz.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T11:44:56Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 8.83 | 0b8eac0c4d854c8aadf86e6dc03ae0a2 | f9967aed37fde7f9 |
| 2026-10-14T11:44:58Z | c01-tr | duyu-1 | - | - | - | 8.83 | - | f9967aed37fde7f9 |
| 2026-10-14T11:45:01Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 129 | 9.92 | be4b3322d2ec4a1286ab72c2f6a99239 | 370ee5ce8c7cb191 |
| 2026-10-14T11:45:02Z | c02-tr | duyu-1 | - | - | - | 9.92 | - | 370ee5ce8c7cb191 |
| 2026-10-14T11:45:05Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 144 | 10.75 | d6be09c97ba744d9aa0afba0470257d7 | 695f60c5354f4f0f |
| 2026-10-14T11:45:06Z | c03-tr | duyu-1 | - | - | - | 10.75 | - | 695f60c5354f4f0f |
| 2026-10-14T11:45:09Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 119 | 8.64 | 834467e628cf4bad9103aa7275ba5b63 | 7b14320b75d52e7b |
| 2026-10-14T11:45:10Z | c04-tr | duyu-1 | - | - | - | 8.64 | - | 7b14320b75d52e7b |
| 2026-10-14T11:45:13Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 153 | 10.68 | ba64d24d0652443fb3d808ede04f5a2f | 3102b5a2b78d2976 |
| 2026-10-14T11:45:14Z | c06-tr | duyu-1 | - | - | - | 10.68 | - | 3102b5a2b78d2976 |
| 2026-10-14T11:45:17Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 59 | 4.0 | 06bdaa1de2ce4d189a9b7d27ad3e332e | e89a5c6a53f5df2f |
| 2026-10-14T11:45:17Z | c08-tr | duyu-1 | - | - | - | 4.0 | - | e89a5c6a53f5df2f |
| 2026-10-14T11:45:19Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 9.6 | be6a2d69caf442088d339020c5abc2c0 | 18ae55abd2843daa |
| 2026-10-14T11:45:21Z | c09-tr | duyu-1 | - | - | - | 9.6 | - | 18ae55abd2843daa |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T12:15:02Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | d7b06372bc132bbb | audio/en/c01-ex1.mp3 |
| 2026-10-14T12:15:03Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | 0c00f6707d412bc9 | audio/en/c03-ex1.mp3 |
| 2026-10-14T12:15:05Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 4b6499246f424672 | audio/en/c03-ex2.mp3 |
| 2026-10-14T12:15:06Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 817f1f1b1d0bf57f | audio/en/c03-ex3.mp3 |
| 2026-10-14T12:15:07Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | 57ee8b15fb9ffb9d | audio/en/c04-ex1.mp3 |
| 2026-10-14T12:15:08Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | c5df970de4d42e93 | audio/en/c05-ex1.mp3 |
| 2026-10-14T12:15:09Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 5ab2682520e4f3fb | audio/en/c05-ex2.mp3 |
| 2026-10-14T12:15:10Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | acf7e8a43cd6c9c1 | audio/en/c05-ex3.mp3 |
| 2026-10-14T12:15:11Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 01d66c9cc0c0d79f | audio/en/c05-ex4.mp3 |
| 2026-10-14T12:15:12Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | 6357c54bdc617ded | audio/en/c05-ex5.mp3 |
| 2026-10-14T12:15:14Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | b399ac806ffd4ed0 | audio/en/c06-ex2.mp3 |
| 2026-10-14T12:15:15Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 69da1a01cb3aaef7 | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:16:50Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.24 | dc53c4d2561c4413afee7486d312996f | b34daa0fb665a41a |
| 2026-11-27T18:16:51Z | c07-q1-fb | duyu-1 | - | - | - | 2.24 | - | b34daa0fb665a41a |
| 2026-11-27T18:16:53Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 3.52 | f269086d59ab4902849750f4297ed2de | d97bea6d5ad94067 |
| 2026-11-27T18:16:54Z | c07-q2-fb | duyu-1 | - | - | - | 3.52 | - | d97bea6d5ad94067 |
| 2026-11-27T18:16:59Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.6 | 8c2c75f2f3f4465c96f319edb8866831 | 01543b4a4619a5f0 |
| 2026-11-27T18:17:00Z | c07-q3-fb | duyu-1 | - | - | - | 1.6 | - | 01543b4a4619a5f0 |
| 2026-11-27T18:17:02Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 3.84 | 7ec98144c00f4f2fa7b850f1be10ff76 | 97a451e0b8ad9089 |
| 2026-11-27T18:17:03Z | c07-q4-fb | duyu-1 | - | - | - | 3.84 | - | 97a451e0b8ad9089 |
| 2026-11-27T18:56:23Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 2.72 | d10f9b45659242c69e1016d317849de2 | e01ddf713ad47af8 |
| 2026-11-27T18:56:24Z | c01-ex1-tl | duyu-1 | - | - | - | 2.72 | - | e01ddf713ad47af8 |
| 2026-11-27T18:56:26Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | e87bd4fc586f46eaa1e2e39d492e1956 | b2a41acebccf74a1 |
| 2026-11-27T18:56:27Z | c03-ex1-tl | duyu-1 | - | - | - | 1.28 | - | b2a41acebccf74a1 |
| 2026-11-27T18:56:29Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 1.28 | 35bd5033873f4d4d97f22986519460d3 | c91063b41a8ef5a0 |
| 2026-11-27T18:56:30Z | c03-ex2-tl | duyu-1 | - | - | - | 1.28 | - | c91063b41a8ef5a0 |
| 2026-11-27T18:56:31Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 7058c76e258a4affb7cf8de01aa69499 | 87a8a9293f5d9654 |
| 2026-11-27T18:56:32Z | c03-ex3-tl | duyu-1 | - | - | - | 1.28 | - | 87a8a9293f5d9654 |
| 2026-11-27T18:56:34Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.12 | a38ee907d6944d6e9f3c635ce8979c24 | de9c5dc78817d983 |
| 2026-11-27T18:56:35Z | c04-ex1-tl | duyu-1 | - | - | - | 1.12 | - | de9c5dc78817d983 |
| 2026-11-27T18:56:37Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 6100a3a33be24d138397fb16e8542145 | 474687c9ed760fa3 |
| 2026-11-27T18:56:38Z | c05-ex1-tl | duyu-1 | - | - | - | 1.28 | - | 474687c9ed760fa3 |
| 2026-11-27T18:56:40Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.44 | d49b85f30c9349bd87497ea58bcdcc14 | 32e651dea20c0cda |
| 2026-11-27T18:56:41Z | c05-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 32e651dea20c0cda |
| 2026-11-27T18:56:42Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | 7b2316ef46dc4ff4969a942c8a7a3f04 | 04b2d5544485b045 |
| 2026-11-27T18:56:43Z | c05-ex3-tl | duyu-1 | - | - | - | 1.28 | - | 04b2d5544485b045 |
| 2026-11-27T18:56:45Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 3.36 | de86162def8342a5a6a1bb274bd4bc07 | 02347e154966f233 |
| 2026-11-27T18:56:47Z | c05-ex4-tl | duyu-1 | - | - | - | 3.36 | - | 02347e154966f233 |
| 2026-11-27T18:56:49Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.12 | 45e1b989af2e48758b5cab9acdf07c12 | 7e5e5e9f1fd0b2bb |
| 2026-11-27T18:56:50Z | c05-ex5-tl | duyu-1 | - | - | - | 1.12 | - | 7e5e5e9f1fd0b2bb |
| 2026-11-27T18:56:52Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | b78438dd451c4e3ab97ef703d2833934 | b6de4f9ddc446b4e |
| 2026-11-27T18:56:53Z | c06-ex2-tl | duyu-1 | - | - | - | 1.28 | - | b6de4f9ddc446b4e |
| 2026-11-27T18:56:55Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 2.72 | d50141fa9d2b4cc7b6b6e2e278a5b268 | 4e4e38d1516843b9 |
| 2026-11-27T18:56:56Z | c09-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 4e4e38d1516843b9 |
