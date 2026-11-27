# G-B2-07-past-modals-deduction PROMPTS

Ders: Geçmişe dair çıkarım: must have, can't have, might have · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve A2 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B2 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** Alex → Aleks.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:10:13Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 10.43 | 54cff248f11a451a8e380bdd497989ed | db8f7e8b650323af |
| 2026-10-14T14:10:14Z | c01-tr | duyu-1 | - | - | - | 10.43 | - | db8f7e8b650323af |
| 2026-10-14T14:10:16Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 201 | 13.47 | 97cd91e369784ca1ac2dc4831e7b9685 | 148a74128fb39bd2 |
| 2026-10-14T14:10:18Z | c02-tr | duyu-1 | - | - | - | 13.47 | - | 148a74128fb39bd2 |
| 2026-10-14T14:10:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 195 | 12.35 | a52f9158c34f411e9b612cbd567985c9 | c38aa00afc4b1eb9 |
| 2026-10-14T14:10:22Z | c03-tr | duyu-1 | - | - | - | 12.35 | - | c38aa00afc4b1eb9 |
| 2026-10-14T14:10:24Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 10.11 | 7545c4b4f4db4423b5854928272da265 | c732fb844ca4dddd |
| 2026-10-14T14:10:26Z | c04-tr | duyu-1 | - | - | - | 10.11 | - | c732fb844ca4dddd |
| 2026-10-14T14:10:29Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 215 | 15.39 | f2f982a4787a4eb5b6999c979fd2d027 | 55573d456d150094 |
| 2026-10-14T14:10:30Z | c06-tr | duyu-1 | - | - | - | 15.39 | - | 55573d456d150094 |
| 2026-10-14T14:10:33Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 183 | 12.49 | 15f153cd7f01443287d8a98308b86bfd | 900505a6c8d5c958 |
| 2026-10-14T14:10:35Z | c08-tr | duyu-1 | - | - | - | 12.49 | - | 900505a6c8d5c958 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:04:11Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | e5a8966c1e12fe42 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:04:13Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 14cc1aee4eecc402 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:04:15Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | a88492b6ec65c173 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:04:18Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | c56b7e1d713aa107 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:04:20Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 0dcf8974915236ba | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:04:23Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 50 | d69840928175d783 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:04:25Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 64 | 9e3230e007f45c0d | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:04:28Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 55 | f3ce0171cf965990 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:04:30Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 52 | c431e942f2e10b82 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:04:32Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 968f5c45bd3b8913 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:04:34Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 46e9bf74cabb8629 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:04:36Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | d702b55a854b3388 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:04:38Z | c09-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | e87adabd9137e07b | audio/en/c09-ex2.mp3 |
