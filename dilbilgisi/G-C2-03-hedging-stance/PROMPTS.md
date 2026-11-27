# G-C2-03-hedging-stance PROMPTS

Ders: Yumuşatma ve tutum (hedging and stance): It would appear that…, arguably · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: önceki dalgaların dersleri (`G-B2-01-passive`, `G-B1-01-present-perfect-experience`, `G-A2-04-past-simple-regular`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, sade ve suçlamasız (C düzeyinde de). İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. C1/C2 kapsaması Octanove listesi depoda olmadığı için denetlenmedi (`grammar_lint.py` uyarısı).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h082.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:41:40Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 10.36 | 1a3e33ba034b4db5b25e91619d717e66 | 80b7310a7bfaa420 |
| 2026-10-14T14:41:41Z | c01-tr | duyu-1 | - | - | - | 10.36 | - | 80b7310a7bfaa420 |
| 2026-10-14T14:41:44Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 200 | 13.79 | 7874d59e6963436cadf923f5d7fde232 | df377476fd8ab26b |
| 2026-10-14T14:41:45Z | c02-tr | duyu-1 | - | - | - | 13.79 | - | df377476fd8ab26b |
| 2026-10-14T14:41:48Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 16.0 | 17f7214e05594846b1713e2ae9c7b73f | ec6e6db608c0e7c1 |
| 2026-10-14T14:41:50Z | c03-tr | duyu-1 | - | - | - | 16.0 | - | ec6e6db608c0e7c1 |
| 2026-10-14T14:41:53Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 162 | 10.75 | 99d88029ebd740debb280c32ff9e3d67 | e7af05f43cb056ed |
| 2026-10-14T14:41:54Z | c04-tr | duyu-1 | - | - | - | 10.75 | - | e7af05f43cb056ed |
| 2026-10-14T14:41:57Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 235 | 15.71 | 0d77ff6336174aef94d4bca3cabcd276 | 5c2fbbd1057b9e3e |
| 2026-10-14T14:41:58Z | c06-tr | duyu-1 | - | - | - | 15.71 | - | 5c2fbbd1057b9e3e |
| 2026-10-14T14:42:02Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 173 | 11.39 | 529770f631e3411aa89acf7645ac94a8 | a98448d6ae80792a |
| 2026-10-14T14:42:03Z | c08-tr | duyu-1 | - | - | - | 11.39 | - | a98448d6ae80792a |
| 2026-11-20T16:03:02Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 159 | 10.11 | 33bdfa0d938c449586b712ec3790d873 | fff3f82fcbb8f411 |
| 2026-11-20T16:03:06Z | c01-tr | duyu-1 | - | - | - | 10.11 | - | fff3f82fcbb8f411 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:11:10Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 186c2616ef0a6776 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:11:12Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 35 | 56bd863fca230e95 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:11:14Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 33 | 90abd8557b71cf01 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:11:15Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 32 | 096d494642d9be6b | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:11:17Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 1366ff119e39f4c8 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:11:18Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 32 | fc8912e1efe387c8 | audio/en/c03-ex3.mp3 |
| 2026-11-26T14:11:20Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 45 | fbe8654e6d454743 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:11:22Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 36 | 1b7bd6d9a72adb44 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:11:24Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 38 | 0fd2e044498dec84 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:11:25Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 50 | 435b550d3b669e0e | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:11:27Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 51 | 55c7d7fa8395955e | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:11:29Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 41 | 1cce1e9571a82b34 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:11:30Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 20 | 7bdcbc3ca0373a04 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:11:32Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 33 | 78dd8c81dfa1a598 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:11:33Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 41 | 152e0e9db3d8a632 | audio/en/c07-q5.mp3 |
