# G-A2-08-comparatives PROMPTS

Ders: Karşılaştırma: -er / more … than · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-er` → "er".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:09:47Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 112 | 6.88 | 5f99f2e9cc934e17bd4baef0c6407361 | c0cf70aafff1542c |
| 2026-10-14T13:09:48Z | c01-tr | duyu-1 | - | - | - | 6.88 | - | c0cf70aafff1542c |
| 2026-10-14T13:09:50Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 168 | 11.69 | bc494ac48c8b4e44941a9f10edd3cb18 | bae72c704c9a3ee0 |
| 2026-10-14T13:09:52Z | c02-tr | duyu-1 | - | - | - | 11.69 | - | bae72c704c9a3ee0 |
| 2026-10-14T13:09:55Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 8.32 | cd3790c733914f25b94847f81a4aa2e5 | a36c6d7632d48782 |
| 2026-10-14T13:09:56Z | c03-tr | duyu-1 | - | - | - | 8.32 | - | a36c6d7632d48782 |
| 2026-10-14T13:09:58Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 182 | 12.03 | dfb7ec1b2e3e4febb740e29473f96c03 | e95c6aa25bbb81ab |
| 2026-10-14T13:09:59Z | c05-tr | duyu-1 | - | - | - | 12.03 | - | e95c6aa25bbb81ab |
| 2026-10-14T13:10:02Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.64 | f1c4b59fee994479a421208207869de8 | b5b7fbfec7386e57 |
| 2026-10-14T13:10:02Z | c07-tr | duyu-1 | - | - | - | 4.64 | - | b5b7fbfec7386e57 |
| 2026-10-14T13:10:04Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 133 | 8.16 | a75393aecb6f42758d1fe66ebb07698b | e24ad987587a9344 |
| 2026-10-14T13:10:05Z | c08-tr | duyu-1 | - | - | - | 8.16 | - | e24ad987587a9344 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T18:27:35Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 40 | e38539f662268f1e | audio/en/c01-ex1.mp3 |
| 2026-10-14T18:27:36Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 44 | 53dc2afaddd4d78d | audio/en/c03-ex1.mp3 |
| 2026-10-14T18:27:38Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 33 | 68952508ac5865de | audio/en/c03-ex2.mp3 |
| 2026-10-14T18:27:39Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 27 | 7a7052eb20349273 | audio/en/c03-ex3.mp3 |
| 2026-10-14T18:27:40Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | 82efef4177a5e1b6 | audio/en/c04-ex1.mp3 |
| 2026-10-14T18:27:41Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | d989b15d7dd94ec4 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:28:00Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 34 | ba29804c14c6406e | audio/en/c04-ex3.mp3 |
| 2026-10-30T13:28:02Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 41 | e36e21687b8f7cb5 | audio/en/c04-ex4.mp3 |
| 2026-10-30T13:28:03Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 4e65cb1f14a91000 | audio/en/c04-ex5.mp3 |
| 2026-10-30T13:28:04Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | 2031acdaef878aba | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:28:06Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 9e747a4f4fa5cc45 | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:28:07Z | c08-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 34 | 2e94e00ab33e915e | audio/en/c08-ex1.mp3 |
