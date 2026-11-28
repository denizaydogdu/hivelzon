# G-B2-12-contrast-linkers PROMPTS

Ders: Zıtlık bağlaçları: although, despite, however, whereas · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** Max → Maks; -ing → ing.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:12:41Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 9.63 | 5adb518ce06447599703c5c6c27784e7 | 8deb00cea66cfa1d |
| 2026-10-14T14:12:43Z | c01-tr | duyu-1 | - | - | - | 9.63 | - | 8deb00cea66cfa1d |
| 2026-10-14T14:12:46Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 207 | 13.95 | b89743d7ee414d1e82913d110d864cdd | 4f0457db6b6614fd |
| 2026-10-14T14:12:47Z | c02-tr | duyu-1 | - | - | - | 13.95 | - | 4f0457db6b6614fd |
| 2026-10-14T14:12:50Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 9.79 | 28931813e9934b0583777147fa9a3a84 | 8d176a23dc2cce6d |
| 2026-10-14T14:12:51Z | c03-tr | duyu-1 | - | - | - | 9.79 | - | 8d176a23dc2cce6d |
| 2026-10-14T14:12:54Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 209 | 16.67 | 63eea3826a4e45f3a1805ddf1d1fff5a | 263bebbac4e485e9 |
| 2026-10-14T14:12:56Z | c04-tr | duyu-1 | - | - | - | 16.67 | - | 263bebbac4e485e9 |
| 2026-10-14T14:13:00Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 220 | 14.75 | 5e17ca50033c413181642a932359bcf8 | 59e222e6566753e6 |
| 2026-10-14T14:13:01Z | c06-tr | duyu-1 | - | - | - | 14.75 | - | 59e222e6566753e6 |
| 2026-10-14T14:13:04Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 7.84 | 5a8a133aa4d240f5918d397ee0804d4a | c295b3e2d9152fc2 |
| 2026-10-14T14:13:05Z | c08-tr | duyu-1 | - | - | - | 7.84 | - | c295b3e2d9152fc2 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:06:18Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 46 | 4e597a01559f73ed | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:06:20Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | bff965b17cb887c6 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:06:22Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 48 | bebb9ba8b68616e8 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:06:24Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 261e1271775d870c | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:06:27Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 83f97715b48ac1e0 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:06:29Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 53 | f95e91746ac061ee | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:06:31Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 45 | 90f137c0c131f822 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:06:33Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 6b6abaca03da7ab1 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:06:35Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 46 | 252df215948362a6 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:06:37Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | d97a957258feb3a6 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:06:39Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 47 | 468dcc0a9ac0f2fe | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:06:41Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 55 | 3b192c0bfe60188d | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:06:43Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 48f582847170388c | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:06:45Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 45d902197fc60dba | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:06:47Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | b23af4fb23375c48 | audio/en/c06-ex3.mp3 |
| 2026-11-27T18:29:58Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.72 | 0bac704eef704b5a9ef3340d97ff0aa7 | a85c7ae779a84d46 |
| 2026-11-27T18:29:59Z | c07-q1-fb | duyu-1 | - | - | - | 2.72 | - | a85c7ae779a84d46 |
| 2026-11-27T18:30:01Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.4 | f06759369f464a7b89098c26b4456370 | b59c242e6742ec12 |
| 2026-11-27T18:30:03Z | c07-q2-fb | duyu-1 | - | - | - | 2.4 | - | b59c242e6742ec12 |
| 2026-11-27T18:30:05Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 55 | 3.84 | 169e183ddfd94ab4a920bd2b68663b6e | 80b7bf9b1bca5d5f |
| 2026-11-27T18:30:06Z | c07-q3-fb | duyu-1 | - | - | - | 3.84 | - | 80b7bf9b1bca5d5f |
| 2026-11-27T18:30:09Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 61 | 3.84 | 19ccbeeae452459ea434f7f7304f9c7c | 75db4754e9226e63 |
| 2026-11-27T18:30:10Z | c07-q4-fb | duyu-1 | - | - | - | 3.84 | - | 75db4754e9226e63 |
| 2026-11-27T19:35:10Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.72 | ae9139820a5c4fdbaba7f8bc49002e39 | c196d07fc3251539 |
| 2026-11-27T19:35:11Z | c01-ex1-tl | duyu-1 | - | - | - | 2.72 | - | c196d07fc3251539 |
| 2026-11-27T19:35:13Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.04 | ba9f026da76b4bf88f1dba7ced2b5ee4 | f91f63aeb6c01466 |
| 2026-11-27T19:35:14Z | c02-ex1-tl | duyu-1 | - | - | - | 3.04 | - | f91f63aeb6c01466 |
| 2026-11-27T19:35:16Z | c02-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.88 | 683cf694fbd945cba8c9691f9e3c953f | aec863db5be7a81f |
| 2026-11-27T19:35:17Z | c02-ex2-tl | duyu-1 | - | - | - | 2.88 | - | aec863db5be7a81f |
| 2026-11-27T19:35:19Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.24 | df486937cf144295a956bbc21686f68f | d934a2c088ce7c87 |
| 2026-11-27T19:35:20Z | c03-ex1-tl | duyu-1 | - | - | - | 2.24 | - | d934a2c088ce7c87 |
| 2026-11-27T19:35:22Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.4 | b76a5df7e38241b4860b34e885c20c97 | 79c8e12fb7c435e2 |
| 2026-11-27T19:35:23Z | c03-ex2-tl | duyu-1 | - | - | - | 2.4 | - | 79c8e12fb7c435e2 |
| 2026-11-27T19:35:26Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 43 | 3.2 | bc4f331124894ce9bd33a080f657284d | 5889d89370324369 |
| 2026-11-27T19:35:27Z | c04-ex1-tl | duyu-1 | - | - | - | 3.2 | - | 5889d89370324369 |
| 2026-11-27T19:35:29Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 55 | 4.16 | b1f5b1f390264cf5a9c7e05714f17cd9 | c56e449ffe9abf76 |
| 2026-11-27T19:35:30Z | c04-ex2-tl | duyu-1 | - | - | - | 4.16 | - | c56e449ffe9abf76 |
| 2026-11-27T19:35:32Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 2.88 | 8431dddb65bf43188d959edf26b5d315 | 1205dac3dcf485c2 |
| 2026-11-27T19:35:33Z | c05-ex1-tl | duyu-1 | - | - | - | 2.88 | - | 1205dac3dcf485c2 |
| 2026-11-27T19:35:36Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.24 | 35b80a8567fe49fe9579fc0e7131a782 | f9d7f14c780e8450 |
| 2026-11-27T19:35:36Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | f9d7f14c780e8450 |
| 2026-11-27T19:35:38Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.08 | 5c9c309023284e58b9dc3b1d39b36623 | d9907e311fd7e910 |
| 2026-11-27T19:35:39Z | c05-ex3-tl | duyu-1 | - | - | - | 2.08 | - | d9907e311fd7e910 |
| 2026-11-27T19:35:42Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.56 | 696e1d6a0b0b43e2bae72f6b4196cb86 | 37566a81ff47d01c |
| 2026-11-27T19:35:42Z | c05-ex4-tl | duyu-1 | - | - | - | 2.56 | - | 37566a81ff47d01c |
| 2026-11-27T19:35:45Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 58 | 3.84 | 60e634177ad741cf900447ef3ba12930 | f6d7120cc61638a6 |
| 2026-11-27T19:35:46Z | c05-ex5-tl | duyu-1 | - | - | - | 3.84 | - | f6d7120cc61638a6 |
| 2026-11-27T19:35:48Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.56 | 8f617a4b969440beaf13dcec3992b3ab | f4023fbad3ef0ae8 |
| 2026-11-27T19:35:49Z | c06-ex1-tl | duyu-1 | - | - | - | 2.56 | - | f4023fbad3ef0ae8 |
| 2026-11-27T19:35:51Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.6 | e171ffcf681e417daceadcd5902d1321 | 7f3eb04cba5405a3 |
| 2026-11-27T19:35:52Z | c06-ex2-tl | duyu-1 | - | - | - | 1.6 | - | 7f3eb04cba5405a3 |
| 2026-11-27T19:35:54Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 30ecd7d5ceeb47d38f14b1e6f1508d29 | 7b21a5605a559723 |
| 2026-11-27T19:35:54Z | c06-ex3-tl | duyu-1 | - | - | - | 1.76 | - | 7b21a5605a559723 |
