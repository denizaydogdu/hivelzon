# G-B1-10-might-may-could PROMPTS

Ders: Olasılık: might / may / could · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:09:14Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 163 | 10.11 | e733178ffc7645649f8936fcd12a14a1 | 5866722ca4a9ada9 |
| 2026-10-14T14:09:15Z | c01-tr | duyu-1 | - | - | - | 10.11 | - | 5866722ca4a9ada9 |
| 2026-10-14T14:09:17Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 163 | 10.4 | 578529f272ea40c4a914a47c978819c0 | 73e1213aaa49aaaa |
| 2026-10-14T14:09:18Z | c02-tr | duyu-1 | - | - | - | 10.4 | - | 73e1213aaa49aaaa |
| 2026-10-14T14:09:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 8.8 | ab7824f881e84826b85d3e1222996ce4 | 322df938c282e146 |
| 2026-10-14T14:09:22Z | c03-tr | duyu-1 | - | - | - | 8.8 | - | 322df938c282e146 |
| 2026-10-14T14:09:24Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 107 | 7.36 | 103aa00eecf2457e83e612d43366df99 | 2c62e17886c2d2fc |
| 2026-10-14T14:09:25Z | c04-tr | duyu-1 | - | - | - | 7.36 | - | 2c62e17886c2d2fc |
| 2026-10-14T14:09:28Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 229 | 14.43 | a03dbbf1f0494eb1b99ce78fe20fd192 | 125a321fdbaed6ff |
| 2026-10-14T14:09:29Z | c06-tr | duyu-1 | - | - | - | 14.43 | - | 125a321fdbaed6ff |
| 2026-10-14T14:09:32Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 101 | 6.4 | e82d2f3f7e1843c69c42e750c4217a92 | f685564a9211ad43 |
| 2026-10-14T14:09:33Z | c08-tr | duyu-1 | - | - | - | 6.4 | - | f685564a9211ad43 |
| 2026-10-14T14:09:35Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 122 | 7.36 | e153a9bb50fc4b7da4924ec7e8a05e21 | e6e677d35ed01fae |
| 2026-10-14T14:09:37Z | c09-tr | duyu-1 | - | - | - | 7.36 | - | e6e677d35ed01fae |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:37:30Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 6146ffd6756da81a | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:37:32Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | ecb7e17a9fb6e954 | audio/en/c02-ex1.mp3 |
| 2026-10-30T13:37:33Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 60c01e463d8d6c01 | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:37:35Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | a1667c5c7d55a1b9 | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:37:37Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | eeb48c81773b8a48 | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:37:39Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | 7fd425129d4d7510 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:37:40Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 00e33a2ee6a9033a | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:37:41Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 22 | 744ce4220a2bb1a9 | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:37:43Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 87201ce6567450b6 | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:37:44Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | 21af3ffcfa29e48f | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:37:46Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 19 | 59be2c68b94a1eea | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:37:47Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 23 | fadf7f55f41dcfbe | audio/en/c06-ex1.mp3 |
| 2026-10-30T13:37:48Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 15 | c966251e3e299c16 | audio/en/c06-ex2.mp3 |
| 2026-10-30T13:37:49Z | c07-q5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 20 | e47c760ea9d2b005 | audio/en/c07-q5.mp3 |
