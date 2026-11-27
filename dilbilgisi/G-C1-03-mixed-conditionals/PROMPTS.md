# G-C1-03-mixed-conditionals PROMPTS

Ders: Karışık koşul cümleleri (mixed conditionals) · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:38:09Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 9.6 | b0b084baaa324e929f404360eff4613a | f4d1961b62ea3945 |
| 2026-10-14T14:38:11Z | c01-tr | duyu-1 | - | - | - | 9.6 | - | f4d1961b62ea3945 |
| 2026-10-14T14:38:13Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 177 | 11.55 | a498982bb4e849caafae84ceb3c675df | aac0e11e05f269de |
| 2026-10-14T14:38:14Z | c02-tr | duyu-1 | - | - | - | 11.55 | - | aac0e11e05f269de |
| 2026-10-14T14:38:17Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 204 | 15.84 | 4a258530ed8640fe99b794d6c0812951 | 436c8d08e4fd3f62 |
| 2026-10-14T14:38:19Z | c03-tr | duyu-1 | - | - | - | 15.84 | - | 436c8d08e4fd3f62 |
| 2026-10-14T14:38:22Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 160 | 13.03 | a34705ad0e954ce3af153b4771ce7598 | 2c2b869881f57084 |
| 2026-10-14T14:38:23Z | c04-tr | duyu-1 | - | - | - | 13.03 | - | 2c2b869881f57084 |
| 2026-10-14T14:38:26Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 226 | 14.27 | cbee391c460b4ee3be17a525fe8c191a | d46e73277dc15137 |
| 2026-10-14T14:38:27Z | c06-tr | duyu-1 | - | - | - | 14.27 | - | d46e73277dc15137 |
| 2026-10-14T14:38:30Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 149 | 10.27 | d2fba8e4d1aa46e6b0a9cd1f35d92228 | 7138f767339bb901 |
| 2026-10-14T14:38:32Z | c08-tr | duyu-1 | - | - | - | 10.27 | - | 7138f767339bb901 |
| 2026-11-20T16:01:30Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 166 | 11.2 | 14598f4c68a644b68f018441bcdc2513 | 45cd783f67b2a44f |
| 2026-11-20T16:01:33Z | c01-tr | duyu-1 | - | - | - | 11.2 | - | 45cd783f67b2a44f |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:07:48Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 63 | 7ae62db41c87b426 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:07:50Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 51 | 8e9253d6aff803bf | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:07:53Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 60 | c00c26e52d4e565c | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:07:56Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 51 | 791b99def348be36 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:07:58Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 52 | 29492c6f1a8f526b | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:08:00Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 56 | b83af95f2961fd6b | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:08:03Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 60 | 76f098ecb31a5874 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:08:05Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 53 | bd0444003f6f86c4 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:08:08Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 50 | a3260a54b50a17f2 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:08:10Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 49 | 510d3fe3c4f9a13f | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:08:11Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 38 | 251a5be46d43e8ee | audio/en/c06-ex2.mp3 |
