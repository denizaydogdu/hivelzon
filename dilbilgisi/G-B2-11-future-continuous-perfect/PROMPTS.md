# G-B2-11-future-continuous-perfect PROMPTS

Ders: Gelecekte süren ve bitmiş eylem: will be doing, will have done · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** -ing → ing.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:12:15Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 145 | 13.15 | 82a21e3535b7437a8335b5eeef684f30 | f3c21623261d2594 |
| 2026-10-14T14:12:16Z | c01-tr | duyu-1 | - | - | - | 13.15 | - | f3c21623261d2594 |
| 2026-10-14T14:12:19Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 10.43 | d23b6a316f3f4302b4ed5e31c19f7039 | c7e1abbfb8fb1ba8 |
| 2026-10-14T14:12:20Z | c02-tr | duyu-1 | - | - | - | 10.43 | - | c7e1abbfb8fb1ba8 |
| 2026-10-14T14:12:23Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 208 | 13.1 | 555082254fb748cfbccdd4e7cce00326 | e43e2266b39a28d0 |
| 2026-10-14T14:12:25Z | c03-tr | duyu-1 | - | - | - | 13.1 | - | e43e2266b39a28d0 |
| 2026-10-14T14:12:28Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 181 | 12.03 | 0b7247c6f5504243a51720e07a991a22 | cd8a6db840126c16 |
| 2026-10-14T14:12:30Z | c04-tr | duyu-1 | - | - | - | 12.03 | - | cd8a6db840126c16 |
| 2026-10-14T14:12:33Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 208 | 13.31 | d893788200964678aa33b2e316664370 | d22108ef867135a6 |
| 2026-10-14T14:12:35Z | c06-tr | duyu-1 | - | - | - | 13.31 | - | d22108ef867135a6 |
| 2026-10-14T14:12:37Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 9.15 | 4ebd9394a6df46498b5843dbfafb575d | 93c8f033d3049f26 |
| 2026-10-14T14:12:39Z | c08-tr | duyu-1 | - | - | - | 9.15 | - | 93c8f033d3049f26 |
| 2026-10-14T14:13:16Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 14.09 | d63fa2bcc136415f99db9fbb3401c052 | 9a03cd6ab3134e01 |
| 2026-10-14T14:13:18Z | c04-tr | duyu-1 | - | - | - | 14.09 | - | 9a03cd6ab3134e01 |
| 2026-11-20T16:01:02Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 10.4 | 922df3ec74af48f99fcdbab9c12b2f66 | 52f402572b6299e0 |
| 2026-11-20T16:01:06Z | c01-tr | duyu-1 | - | - | - | 10.4 | - | 52f402572b6299e0 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:05:54Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 55 | 5b1afb046e181764 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:05:56Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 47cac6a3fd2a85c7 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:05:58Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | f792a4afda5dfded | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:06:00Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 7513ac0e26f74803 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:06:01Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 72665b5667c764ec | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:06:03Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 1c3246876ff8a2cf | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:06:05Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 34 | 103cbd161089b5d6 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:06:06Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | e23d5ac3d180a064 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:06:08Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 9a40373980b2056d | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:06:11Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | 0413d0789aed95a0 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:06:13Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 42 | 8ca09d69b2a95c93 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:06:16Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 45 | b4a22a5cc079c3b0 | audio/en/c07-q5.mp3 |
