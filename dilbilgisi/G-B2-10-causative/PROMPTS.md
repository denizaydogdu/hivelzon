# G-B2-10-causative PROMPTS

Ders: Ettirgen yapı (causative): have ya da get something done · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:11:51Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 135 | 10.08 | aa25469b56a144dd98e50b51ce91e8f6 | c449ab069a4a64d7 |
| 2026-10-14T14:11:52Z | c01-tr | duyu-1 | - | - | - | 10.08 | - | c449ab069a4a64d7 |
| 2026-10-14T14:11:55Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 12.83 | 2573173ec1a242e88ab31bca13f8c200 | c00a16df513a1390 |
| 2026-10-14T14:11:57Z | c02-tr | duyu-1 | - | - | - | 12.83 | - | c00a16df513a1390 |
| 2026-10-14T14:12:00Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 10.11 | e977143317304fc7a8e0046224ca4c21 | af978411d52adc06 |
| 2026-10-14T14:12:01Z | c03-tr | duyu-1 | - | - | - | 10.11 | - | af978411d52adc06 |
| 2026-10-14T14:12:04Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 92 | 7.04 | 25873e55ea5048dfb319b16d78fd7cc1 | 8f24d001e3efc360 |
| 2026-10-14T14:12:05Z | c04-tr | duyu-1 | - | - | - | 7.04 | - | 8f24d001e3efc360 |
| 2026-10-14T14:12:07Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 193 | 13.63 | 2684f2c827ea46739da9bd308e0adea9 | d45923af5bfa6a0a |
| 2026-10-14T14:12:08Z | c06-tr | duyu-1 | - | - | - | 13.63 | - | d45923af5bfa6a0a |
| 2026-10-14T14:12:11Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 107 | 8.8 | 00b581fed05843148c1b354da4c2e751 | 961593f2bd862409 |
| 2026-10-14T14:12:13Z | c08-tr | duyu-1 | - | - | - | 8.8 | - | 961593f2bd862409 |
| 2026-11-20T16:00:56Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 9.76 | 72303f1745694d48bdc8e91936639207 | 1fbb5d945df6f82e |
| 2026-11-20T16:00:58Z | c01-tr | duyu-1 | - | - | - | 9.76 | - | 1fbb5d945df6f82e |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:05:29Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 354b84b7e0bafbaa | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:05:31Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 14 | fc9fcbd08f22f31f | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:05:32Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 18 | ce0cb0bc730793d3 | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:05:34Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | dc33a6a60210fafd | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:05:36Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 309544786bfdc32c | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:05:37Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | e9abe3d9561b4347 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:05:39Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 348996df964c71b3 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:05:41Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 89f76b30ad47169c | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:05:42Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 5f7bf1a6219f323d | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:05:44Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | 1a434cb87f44fc18 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:05:46Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | b3620e2192f89bc2 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:05:48Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | e856bb674fc3d30a | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:05:49Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | 33367ed073a6ad73 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:05:51Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 6fe1c25c669e434a | audio/en/c07-q5.mp3 |
