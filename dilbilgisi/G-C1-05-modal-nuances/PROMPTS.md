# G-C1-05-modal-nuances PROMPTS

Ders: Modal incelikleri: needn't have, be supposed to, would rather · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:39:01Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 117 | 8.16 | 4b51855fc9a242c3ba6ae10fa8e8f3ad | bcd0d3093877244a |
| 2026-10-14T14:39:03Z | c01-tr | duyu-1 | - | - | - | 8.16 | - | bcd0d3093877244a |
| 2026-10-14T14:39:05Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 203 | 15.74 | 729d0654d1d24e6e9bbf211a21e53209 | fd3aac56b5d47ce5 |
| 2026-10-14T14:39:07Z | c02-tr | duyu-1 | - | - | - | 15.74 | - | fd3aac56b5d47ce5 |
| 2026-10-14T14:39:10Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 10.75 | 1d7432f02aa746a5b68fd32d490eebe3 | 1ecde98aef7b8704 |
| 2026-10-14T14:39:12Z | c03-tr | duyu-1 | - | - | - | 10.75 | - | 1ecde98aef7b8704 |
| 2026-10-14T14:39:15Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 188 | 13.12 | aa6c599e5bca4fa2b655c1ca0ece31e4 | bcd0a40edced7bd2 |
| 2026-10-14T14:39:16Z | c04-tr | duyu-1 | - | - | - | 13.12 | - | bcd0a40edced7bd2 |
| 2026-10-14T14:39:19Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 195 | 12.02 | 2cd21c8f6b644c288bee9dc5db7405ec | c31238819cac4b6d |
| 2026-10-14T14:39:20Z | c06-tr | duyu-1 | - | - | - | 12.02 | - | c31238819cac4b6d |
| 2026-10-14T14:39:23Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 201 | 13.28 | b37c408c8f1b4a72bdc491c36621c916 | 8a9ce12fa86b0230 |
| 2026-10-14T14:39:24Z | c08-tr | duyu-1 | - | - | - | 13.28 | - | 8a9ce12fa86b0230 |
| 2026-11-20T16:01:50Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 125 | 8.16 | 6b72e8e4d3d34c7b87d370d01f93029a | fba4dd5cb50dc0cb |
| 2026-11-20T16:01:56Z | c01-tr | duyu-1 | - | - | - | 8.16 | - | fba4dd5cb50dc0cb |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:08:38Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | b898805714f22485 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:08:40Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 46 | a1da9bd56d1ee56f | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:08:42Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 39 | 456f6c39884c819c | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:08:44Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 32 | fd558332476981b3 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:08:45Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 37 | 494129a62590f11e | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:08:47Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 32 | d01f68bf876491a4 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:08:49Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 3819163b0a1fe409 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:08:50Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 44 | bbb89a1ba2c7fb96 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:08:52Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 42 | 7278d6a75250d229 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:08:54Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 36 | 8e231d51678b150b | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:08:55Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 29 | 57dbc01660ce9334 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:08:58Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 24 | 0dcf8974915236ba | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:08:59Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 41 | 7206d0c0007c46ba | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:09:01Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 21 | 6dfc4cdea743cc80 | audio/en/c06-ex3.mp3 |
| 2026-11-26T14:09:03Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 32 | 698ebe712c3f0f91 | audio/en/c07-q5.mp3 |
