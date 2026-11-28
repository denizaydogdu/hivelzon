# G-B2-01-passive PROMPTS

Ders: Edilgen yapı (passive): be + V3 · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:07:43Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 10.24 | 5f3ae0e6daab455f80b0f457a5057f73 | 0f677022dd19ab18 |
| 2026-10-14T14:07:44Z | c01-tr | duyu-1 | - | - | - | 10.24 | - | 0f677022dd19ab18 |
| 2026-10-14T14:07:47Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 11.96 | ce4e82c6e9b54fcba6189af703e6d0d0 | 4fa30d60264c024c |
| 2026-10-14T14:07:48Z | c02-tr | duyu-1 | - | - | - | 11.96 | - | 4fa30d60264c024c |
| 2026-10-14T14:07:51Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 139 | 8.96 | 21001fc3eec240bc83e54e25c45b6107 | da2987edcbf91cbb |
| 2026-10-14T14:07:52Z | c03-tr | duyu-1 | - | - | - | 8.96 | - | da2987edcbf91cbb |
| 2026-10-14T14:07:55Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 201 | 13.79 | 86e5103d0b0840ef9714960ca23ccd68 | 3c32853669f0efa3 |
| 2026-10-14T14:07:56Z | c04-tr | duyu-1 | - | - | - | 13.79 | - | 3c32853669f0efa3 |
| 2026-10-14T14:07:59Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 280 | 19.25 | db7e2bbe3e6749e5a113c6c780bbf5f2 | 3427860794bf16f9 |
| 2026-10-14T14:08:00Z | c06-tr | duyu-1 | - | - | - | 19.25 | - | 3427860794bf16f9 |
| 2026-10-14T14:08:03Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 68 | 3.84 | afb4331a6a8940e3a61c9d594863c8a7 | 75df77f465746223 |
| 2026-10-14T14:08:04Z | c08-tr | duyu-1 | - | - | - | 3.84 | - | 75df77f465746223 |
| 2026-10-14T14:08:06Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 139 | 8.8 | 0faeae90ab5a4abb80a1212a3957d4dc | 72bc07870ca63d04 |
| 2026-10-14T14:08:07Z | c09-tr | duyu-1 | - | - | - | 8.8 | - | 72bc07870ca63d04 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:01:41Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 25 | 8b33df7df6217c3e | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:01:42Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | a8bd37644b759e14 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:01:44Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | 614135ec7a4af6ab | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:01:46Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | f21405c93845a596 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:01:47Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | f870af4856cd5f9f | audio/en/c03-ex3.mp3 |
| 2026-11-26T14:01:49Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | a87be233400d2a24 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:01:51Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 9e505983d3fe07aa | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:01:52Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | b15ff9512c1a2c5f | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:01:54Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | 0393dd8c7e15b3a6 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:01:56Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | 934714943b22b497 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:01:58Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | 99480d75be3a4209 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:02:00Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 19 | 34677f240258ed73 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:02:02Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | fda06093122bff23 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:02:03Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 21 | aafe277bee60d478 | audio/en/c06-ex3.mp3 |
| 2026-11-26T14:02:04Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 20 | 392f42b6dfef3f66 | audio/en/c07-q5.mp3 |
| 2026-11-27T18:27:19Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 62 | 4.16 | 3e0002ada1464ed192127ce8b311a5f3 | 979a4c95ffd1e65b |
| 2026-11-27T18:27:21Z | c07-q1-fb | duyu-1 | - | - | - | 4.16 | - | 979a4c95ffd1e65b |
| 2026-11-27T18:27:23Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 71 | 4.96 | ba009a13fd3541729562e19e88b79f70 | 9d4a123bf90b5b29 |
| 2026-11-27T18:27:24Z | c07-q2-fb | duyu-1 | - | - | - | 4.96 | - | 9d4a123bf90b5b29 |
| 2026-11-27T18:27:27Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 65 | 4.64 | 19972efe79aa4e87bb9a62f3f2029c9c | 921921d6d2028ec0 |
| 2026-11-27T18:27:28Z | c07-q3-fb | duyu-1 | - | - | - | 4.64 | - | 921921d6d2028ec0 |
| 2026-11-27T18:27:32Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 73 | 5.92 | eb784300872a460eb442c25f75e4874f | ea88263cc6671f93 |
| 2026-11-27T18:27:33Z | c07-q4-fb | duyu-1 | - | - | - | 5.92 | - | ea88263cc6671f93 |
| 2026-11-27T19:27:24Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | 66ab6e2e77b14fa1b51e14d7a8b6e98a | a165ca8065b10fc6 |
| 2026-11-27T19:27:25Z | c01-ex1-tl | duyu-1 | - | - | - | 1.44 | - | a165ca8065b10fc6 |
| 2026-11-27T19:27:27Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.56 | 5b1bb8e128364f22b249d4413b535c6c | 7a18c677d604a971 |
| 2026-11-27T19:27:29Z | c02-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 7a18c677d604a971 |
| 2026-11-27T19:27:31Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.4 | e059de8b7a094b2283a487b4215cca10 | 4643a4477ad6be9b |
| 2026-11-27T19:27:32Z | c03-ex1-tl | duyu-1 | - | - | - | 2.4 | - | 4643a4477ad6be9b |
| 2026-11-27T19:27:34Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.24 | 900ca51a9d7440e58b6c4d6348116212 | 7c409d0d1b6db302 |
| 2026-11-27T19:27:35Z | c03-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 7c409d0d1b6db302 |
| 2026-11-27T19:27:37Z | c03-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.6 | ceb397bbaf1f45bc98930f60a87a926d | 99793d59c5af0fc0 |
| 2026-11-27T19:27:38Z | c03-ex3-tl | duyu-1 | - | - | - | 1.6 | - | 99793d59c5af0fc0 |
| 2026-11-27T19:27:40Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 2.88 | f9995aa5f6e34f7fa9d41497395306db | 6a386f3333f75b9e |
| 2026-11-27T19:27:41Z | c04-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 6a386f3333f75b9e |
| 2026-11-27T19:27:43Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.56 | eff2966763fc4304bb9c728273ea1e09 | 875deaccba9c3d81 |
| 2026-11-27T19:27:44Z | c05-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 875deaccba9c3d81 |
| 2026-11-27T19:27:46Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.76 | 0cea137922764ea0a4c20684bca70088 | 2b039705da9f1617 |
| 2026-11-27T19:27:47Z | c05-ex2-tl | duyu-1 | - | - | - | 1.76 | - | 2b039705da9f1617 |
| 2026-11-27T19:27:49Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.24 | dffd68c926cd4d31bd131b72508c01cd | dfd8ac02ba7a3e4c |
| 2026-11-27T19:27:50Z | c05-ex3-tl | duyu-1 | - | - | - | 2.24 | - | dfd8ac02ba7a3e4c |
| 2026-11-27T19:27:53Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.56 | 90f59507f4b24393b49ce276239ccfe5 | 0984a1f07e48ff55 |
| 2026-11-27T19:27:54Z | c05-ex4-tl | duyu-1 | - | - | - | 2.56 | - | 0984a1f07e48ff55 |
| 2026-11-27T19:27:56Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.76 | 9f0248cdc05f476fb24734059dad7968 | c7aa9876516946a7 |
| 2026-11-27T19:27:57Z | c05-ex5-tl | duyu-1 | - | - | - | 1.76 | - | c7aa9876516946a7 |
| 2026-11-27T19:27:59Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.44 | 77983a434e1040c094109b26cfd273e3 | 55a365cd54072fce |
| 2026-11-27T19:28:00Z | c06-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 55a365cd54072fce |
| 2026-11-27T19:28:01Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 2.4 | 4c6e25f95d9d4a7b999844d1cb85807c | 604855051ffef22a |
| 2026-11-27T19:28:02Z | c06-ex2-tl | duyu-1 | - | - | - | 2.4 | - | 604855051ffef22a |
| 2026-11-27T19:28:05Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 1.12 | 2ffcbf67b08f4a9d99257e852b71ddd2 | f69cbee19727ef57 |
| 2026-11-27T19:28:06Z | c06-ex3-tl | duyu-1 | - | - | - | 1.12 | - | f69cbee19727ef57 |
| 2026-11-27T19:28:07Z | c07-q5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | 014941f8c58a47d282612eb851ab7348 | 814fc936c367f9a7 |
| 2026-11-27T19:28:08Z | c07-q5-tl | duyu-1 | - | - | - | 1.28 | - | 814fc936c367f9a7 |
