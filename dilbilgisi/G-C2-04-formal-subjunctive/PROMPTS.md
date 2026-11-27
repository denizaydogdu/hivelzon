# G-C2-04-formal-subjunctive PROMPTS

Ders: Resmî dilek kipi ve if'siz şart (subjunctive, inverted conditionals): Should you…, Had I known… · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:42:06Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 129 | 10.4 | 73402ec2cb014f7f8f1658ab595ea64f | b022ed8377645b3a |
| 2026-10-14T14:42:07Z | c01-tr | duyu-1 | - | - | - | 10.4 | - | b022ed8377645b3a |
| 2026-10-14T14:42:10Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 217 | 15.38 | 16f92fe6ed104bf799d730a04a1e0e7b | 77de07fb273fbe54 |
| 2026-10-14T14:42:11Z | c02-tr | duyu-1 | - | - | - | 15.38 | - | 77de07fb273fbe54 |
| 2026-10-14T14:42:14Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 12.98 | 3f823f30854e440db4c0e8da6efd9557 | 98ee8d89ec80b459 |
| 2026-10-14T14:42:16Z | c03-tr | duyu-1 | - | - | - | 12.98 | - | 98ee8d89ec80b459 |
| 2026-10-14T14:42:19Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 225 | 16.17 | 802e33d530fb4292a687ae761084ff6c | 7e4a0dbc688e18d0 |
| 2026-10-14T14:42:20Z | c04-tr | duyu-1 | - | - | - | 16.17 | - | 7e4a0dbc688e18d0 |
| 2026-10-14T14:42:24Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 229 | 15.1 | a13ff52aafcf4c558f3b9058abdddfab | 6c705be25766463e |
| 2026-10-14T14:42:25Z | c06-tr | duyu-1 | - | - | - | 15.1 | - | 6c705be25766463e |
| 2026-10-14T14:42:28Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 9.63 | 3ca493aad03946758ff29dd939e5102f | 9bf2261b8b3e1384 |
| 2026-10-14T14:42:29Z | c08-tr | duyu-1 | - | - | - | 9.63 | - | 9bf2261b8b3e1384 |
| 2026-11-20T16:03:11Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 10.68 | cff100ad07144eebbc7726d470a1c91f | f2363036c1dca330 |
| 2026-11-20T16:03:15Z | c01-tr | duyu-1 | - | - | - | 10.68 | - | f2363036c1dca330 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:11:35Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 74 | 4d26d3a4ed72202a | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:11:37Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 60 | aebbd0f5ed05e3b6 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:11:39Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 57 | c5c2a7292a0d85be | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:11:41Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 50 | e1df26137f3962c6 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:11:42Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 52 | 2f4ac421154287c7 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:11:44Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 35 | c1f90d49f6ddef06 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:11:46Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 48 | 9249e81948320dd5 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:11:48Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 46 | eb57f8c304263fe1 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:11:50Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 52 | bc71a053bb3d1a47 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:11:52Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | e4ea35e954264e0e | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:11:53Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 46 | d6b3e41922729282 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:11:55Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 47 | aaf7f5794551a9d4 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:11:57Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 30 | 350f3d520096ccf2 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:11:58Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 663c43d86f37992c | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:12:00Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 44 | b094e17adaeaa66e | audio/en/c07-q5.mp3 |
