# G-A2-01-present-continuous PROMPTS

Ders: Şimdiki zaman: am / is / are + -ing · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ing` → "ing".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:07:05Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 7.68 | 5e1d5ac6a1b24383b517caea297caa79 | 56f85cefb5b25052 |
| 2026-10-14T13:07:06Z | c01-tr | duyu-1 | - | - | - | 7.68 | - | 56f85cefb5b25052 |
| 2026-10-14T13:07:08Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 168 | 11.87 | 85c69007e7c446558604a0ba101afdce | c2ba4358af98e0e9 |
| 2026-10-14T13:07:10Z | c02-tr | duyu-1 | - | - | - | 11.87 | - | c2ba4358af98e0e9 |
| 2026-10-14T13:07:12Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 11.68 | e1056d167ba449b087451e5e72a60dfa | a20a68721aad9ed1 |
| 2026-10-14T13:07:14Z | c03-tr | duyu-1 | - | - | - | 11.68 | - | a20a68721aad9ed1 |
| 2026-10-14T13:07:16Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 10.59 | 77d08fc4ef9b4b12881d876db586e35a | 7ede3185a33dfeb5 |
| 2026-10-14T13:07:18Z | c04-tr | duyu-1 | - | - | - | 10.59 | - | 7ede3185a33dfeb5 |
| 2026-10-14T13:07:21Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 10.58 | 5fcc1a0732ee4cee9254001665444918 | 7a1562109449897d |
| 2026-10-14T13:07:22Z | c06-tr | duyu-1 | - | - | - | 10.58 | - | 7a1562109449897d |
| 2026-10-14T13:07:24Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 65 | 4.8 | d33f826143904aa2bc42ecf86f6db312 | a4be7a15a8e9428c |
| 2026-10-14T13:07:25Z | c08-tr | duyu-1 | - | - | - | 4.8 | - | a4be7a15a8e9428c |
| 2026-10-14T13:07:27Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 103 | 6.4 | 8cd2fc637ceb442295300bb14ffea207 | f178aecc6f0d944e |
| 2026-10-14T13:07:28Z | c09-tr | duyu-1 | - | - | - | 6.4 | - | f178aecc6f0d944e |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T18:25:37Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 20 | da4980c40a41882d | audio/en/c01-ex1.mp3 |
| 2026-10-14T18:25:38Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 13 | c2c0d90ebcfe3bf6 | audio/en/c03-ex1.mp3 |
| 2026-10-14T18:25:39Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 15 | ff5baad1fc2ac4ff | audio/en/c03-ex2.mp3 |
| 2026-10-14T18:25:41Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 17 | f15b9812beb5968a | audio/en/c03-ex3.mp3 |
| 2026-10-14T18:25:42Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 21 | 68ad7a343e9e940a | audio/en/c04-ex1.mp3 |
| 2026-10-14T18:25:43Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 17 | 988f482a0339984a | audio/en/c04-ex2.mp3 |
| 2026-10-14T18:25:45Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | 9d9fec8afdb0fbaa | audio/en/c05-ex1.mp3 |
| 2026-10-14T18:25:46Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 43 | 63b8e9375521323a | audio/en/c05-ex2.mp3 |
| 2026-10-14T18:25:47Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 27 | fa93a99fd153014e | audio/en/c05-ex3.mp3 |
| 2026-10-14T18:25:49Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | df201d39e9fb7f95 | audio/en/c05-ex4.mp3 |
| 2026-10-14T18:25:50Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 19 | 8bc402216a7f71e4 | audio/en/c05-ex5.mp3 |
| 2026-10-14T18:25:51Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 7b3f28ef94752f40 | audio/en/c06-ex1.mp3 |
| 2026-10-14T18:25:52Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 19 | 9f68fc2f6b9381d9 | audio/en/c06-ex2.mp3 |
| 2026-10-14T18:25:54Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 26 | 60aaaa727c54ab62 | audio/en/c09-ex1.mp3 |
