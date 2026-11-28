# G-B2-04-second-conditional PROMPTS

Ders: 2. tip koşul (second conditional): gerçek dışı şimdi · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:09:02Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 130 | 8.64 | 68846403788a431e9562cece6c12bc6e | 2afa74b46d39cd74 |
| 2026-10-14T14:09:03Z | c01-tr | duyu-1 | - | - | - | 8.64 | - | 2afa74b46d39cd74 |
| 2026-10-14T14:09:06Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 15.07 | f62ae88b906640fab8208f5dfe6713e5 | a999e0f68d6c20cb |
| 2026-10-14T14:09:08Z | c02-tr | duyu-1 | - | - | - | 15.07 | - | a999e0f68d6c20cb |
| 2026-10-14T14:09:11Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 183 | 11.07 | 41a0f6d4949a4ebc8465a33c17884e89 | 7a054eea9c97ef55 |
| 2026-10-14T14:09:12Z | c03-tr | duyu-1 | - | - | - | 11.07 | - | 7a054eea9c97ef55 |
| 2026-10-14T14:09:15Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 206 | 13.49 | d617ed93acb348c1a30ef033c25783c8 | 93f5e8132a59ddf9 |
| 2026-10-14T14:09:16Z | c04-tr | duyu-1 | - | - | - | 13.49 | - | 93f5e8132a59ddf9 |
| 2026-10-14T14:09:19Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 215 | 15.55 | 8398264854754127b4314c28d5d63e68 | 6c042594a1b19ca4 |
| 2026-10-14T14:09:21Z | c06-tr | duyu-1 | - | - | - | 15.55 | - | 6c042594a1b19ca4 |
| 2026-10-14T14:09:24Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 135 | 8.16 | aecbfbe7031c4fa289d18fa08b6b8b9b | b9179aa14b166f55 |
| 2026-10-14T14:09:25Z | c08-tr | duyu-1 | - | - | - | 8.16 | - | b9179aa14b166f55 |
| 2026-11-20T16:00:36Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 11.38 | f296e2caeaa54952952c09d77c555a1f | 67f3aaf362c51676 |
| 2026-11-20T16:00:38Z | c01-tr | duyu-1 | - | - | - | 11.38 | - | 67f3aaf362c51676 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:02:58Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | 506feecbfa2aace3 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:03:01Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 45 | 68a82fc4831a80c1 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:03:02Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 295c084e178c0fd2 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:03:05Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | c55028584e6ced0c | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:03:07Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | 333064e53f3e1919 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:03:09Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 46 | d65468add7024d68 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:03:11Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 42 | 780dbaeff5c7360a | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:03:13Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | de3bb0f688397989 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:03:15Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 45 | d673bd65b45271bf | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:03:17Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | f465bc53df37dcde | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:03:19Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | e2dbf543ee76df0e | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:03:21Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 7056b213ef5f9015 | audio/en/c06-ex2.mp3 |
| 2026-11-27T18:28:04Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 3.68 | 87a87fbfe9ab40bf8131342e44cca60f | 6e2c7fe6e93bc0c0 |
| 2026-11-27T18:28:05Z | c07-q1-fb | duyu-1 | - | - | - | 3.68 | - | 6e2c7fe6e93bc0c0 |
| 2026-11-27T18:28:08Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.36 | 97c30c1fe319477eb9f334208066c342 | d931011aa6d264d4 |
| 2026-11-27T18:28:09Z | c07-q2-fb | duyu-1 | - | - | - | 3.36 | - | d931011aa6d264d4 |
| 2026-11-27T18:28:11Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 64 | 4.0 | b4ff084521b84fa1aa7ab1af6b28e4d6 | 4c02eaa2faf51e43 |
| 2026-11-27T18:28:12Z | c07-q3-fb | duyu-1 | - | - | - | 4.0 | - | 4c02eaa2faf51e43 |
| 2026-11-27T18:28:15Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 56 | 4.16 | 6c2c13cd0e4443a2beaa2a621131d7c7 | d9f9df30af93ea0c |
| 2026-11-27T18:28:16Z | c07-q4-fb | duyu-1 | - | - | - | 4.16 | - | d9f9df30af93ea0c |
| 2026-11-27T19:29:48Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 51 | 3.68 | 753a1445521a48fabe25043f25b45a90 | aaa47ed9aa626576 |
| 2026-11-27T19:29:49Z | c01-ex1-tl | duyu-1 | - | - | - | 3.68 | - | aaa47ed9aa626576 |
| 2026-11-27T19:29:51Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 3.84 | d0e95c0bde114f61aab1f35893de7d6f | f1b550624c4159d5 |
| 2026-11-27T19:29:53Z | c02-ex1-tl | duyu-1 | - | - | - | 3.84 | - | f1b550624c4159d5 |
| 2026-11-27T19:29:55Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 28 | 2.08 | 6db44700617b4383ab027368beee8250 | d0916ef1de3135d3 |
| 2026-11-27T19:29:56Z | c03-ex1-tl | duyu-1 | - | - | - | 2.08 | - | d0916ef1de3135d3 |
| 2026-11-27T19:29:58Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.24 | 6a00c44c57bc4842ad5fe028ee895ce6 | 3571a380b256b36c |
| 2026-11-27T19:29:59Z | c03-ex2-tl | duyu-1 | - | - | - | 2.24 | - | 3571a380b256b36c |
| 2026-11-27T19:30:01Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.4 | 5c9666304f964790b0488f9fb1f910a3 | b08b7cca1a888c5b |
| 2026-11-27T19:30:02Z | c04-ex1-tl | duyu-1 | - | - | - | 2.4 | - | b08b7cca1a888c5b |
| 2026-11-27T19:30:04Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 2.72 | f39674d99b0f4bb7a6068b071ea79758 | 7329bd8f93e21d87 |
| 2026-11-27T19:30:05Z | c05-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 7329bd8f93e21d87 |
| 2026-11-27T19:30:07Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.08 | bd08a3c99b1044b6a55cbd35ea2f0f22 | 601bf860494142e3 |
| 2026-11-27T19:30:08Z | c05-ex2-tl | duyu-1 | - | - | - | 2.08 | - | 601bf860494142e3 |
| 2026-11-27T19:30:10Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.88 | 96f397258f64426ea7735ffaf7c4e649 | a857a873d925755e |
| 2026-11-27T19:30:11Z | c05-ex3-tl | duyu-1 | - | - | - | 2.88 | - | a857a873d925755e |
| 2026-11-27T19:30:14Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 4.8 | b32b17ceefb54ab0a92e0949f2dc797b | ba59a6314ee3f38b |
| 2026-11-27T19:30:15Z | c05-ex4-tl | duyu-1 | - | - | - | 4.8 | - | ba59a6314ee3f38b |
| 2026-11-27T19:30:18Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.24 | a5254a665f6646128ea90f0a5a646f60 | f70dbcbf14e5fead |
| 2026-11-27T19:30:19Z | c05-ex5-tl | duyu-1 | - | - | - | 2.24 | - | f70dbcbf14e5fead |
| 2026-11-27T19:30:21Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 3.2 | bca80eb9e6cf46088cf59d32416692c9 | 9aafff61ab0847c6 |
| 2026-11-27T19:30:22Z | c06-ex1-tl | duyu-1 | - | - | - | 3.2 | - | 9aafff61ab0847c6 |
| 2026-11-27T19:30:24Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.72 | 4a2ba85cc28a490bb6bc606ff772e0df | 7d207fc8d05dbd02 |
| 2026-11-27T19:30:25Z | c06-ex2-tl | duyu-1 | - | - | - | 2.72 | - | 7d207fc8d05dbd02 |
