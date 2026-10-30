# G-B1-03-present-perfect-vs-past PROMPTS

Ders: Present perfect mi, past simple mı? just / already / yet · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok. **Sözlük (kapsama):** cast.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:06:16Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 179 | 13.94 | 1b46ba85c13942269fd7bfcb35787541 | 08a51777f2934e77 |
| 2026-10-14T14:06:17Z | c01-tr | duyu-1 | - | - | - | 13.94 | - | 08a51777f2934e77 |
| 2026-10-14T14:06:21Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 189 | 12.51 | e4468f56b03a41d69c7c1629d69c1a21 | d2c3621ffd71123a |
| 2026-10-14T14:06:23Z | c02-tr | duyu-1 | - | - | - | 12.51 | - | d2c3621ffd71123a |
| 2026-10-14T14:06:26Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 209 | 14.91 | 869ac17cca6a4ea78438b37fb2ada33d | 27606fc15982bf8e |
| 2026-10-14T14:06:27Z | c03-tr | duyu-1 | - | - | - | 14.91 | - | 27606fc15982bf8e |
| 2026-10-14T14:06:30Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 14.3 | 871e8d7965644e0b830dcb918d48a47c | a38eec53102fc8d1 |
| 2026-10-14T14:06:32Z | c05-tr | duyu-1 | - | - | - | 14.3 | - | a38eec53102fc8d1 |
| 2026-10-14T14:06:34Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.91 | fa7fc93204694d5685f435859940d2db | 8145a4f08e37448b |
| 2026-10-14T14:06:35Z | c07-tr | duyu-1 | - | - | - | 10.91 | - | 8145a4f08e37448b |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:37:12Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 4c54dac7a139d009 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:37:13Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 25 | ea5e259fb3bef558 | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:37:15Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 18 | fcca49dc1e0433c0 | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:37:16Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 18 | 87d78efec3f2085d | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:37:17Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | 13443c34b8dd2427 | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:37:18Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | 663df90a9317b114 | audio/en/c03-ex3.mp3 |
| 2026-10-30T13:37:20Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | fb8b55d81f178191 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:37:21Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 1c05ab9dc1e3f288 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:37:22Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 503c424136b5c669 | audio/en/c04-ex3.mp3 |
| 2026-10-30T13:37:23Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 9294916ad15a1dd9 | audio/en/c04-ex4.mp3 |
| 2026-10-30T13:37:25Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | dae24a699eb59f35 | audio/en/c04-ex5.mp3 |
| 2026-10-30T13:37:26Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 9011e0d6b81fb9f7 | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:37:27Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 20 | 071aa22b7a36666f | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:37:29Z | c07-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | eca70b9d394aa8ee | audio/en/c07-ex1.mp3 |
