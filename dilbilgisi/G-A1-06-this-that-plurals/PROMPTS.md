# G-A1-06-this-that-plurals PROMPTS

Ders: this / that / these / those ve çoğul -s · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Örnek alınan pilot dersler: G-A1-01-to-be, G-A1-03-a-an, G-A1-13-third-person-s (H-079, onaylı). Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş sözlüğü:** `Alex` → "Aleks".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın defteri ayrı tutuldu: `kitaplar/_maliyet/patientdesk-h080a.json` (birleştirme çakışmasını önlemek için; ana deftere ana oturum işler). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:05:45Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 111 | 7.2 | 63306afc065b4c00b66262967fc78c09 | 8b52231a390cf593 |
| 2026-10-14T13:05:46Z | c01-tr | duyu-1 | - | - | - | 7.2 | - | 8b52231a390cf593 |
| 2026-10-14T13:05:49Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 11.94 | 2a9c07dc0e2f48c7b3e6b44927df6539 | 824806945a6ce145 |
| 2026-10-14T13:05:50Z | c02-tr | duyu-1 | - | - | - | 11.94 | - | 824806945a6ce145 |
| 2026-10-14T13:05:53Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 159 | 10.1 | 8cf7995cf8a14ea0ac881bd176918f16 | 4a793e00cf267b9c |
| 2026-10-14T13:05:54Z | c03-tr | duyu-1 | - | - | - | 10.1 | - | 4a793e00cf267b9c |
| 2026-10-14T13:05:56Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 9.76 | 975f245d56be412681b13c358bb29583 | 0f78d1395fa516b0 |
| 2026-10-14T13:05:57Z | c04-tr | duyu-1 | - | - | - | 9.76 | - | 0f78d1395fa516b0 |
| 2026-10-14T13:06:00Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 171 | 12.82 | 7be80003ed9e4d9aa8924a0009223a03 | 1cb70a8a4aa350d6 |
| 2026-10-14T13:06:01Z | c06-tr | duyu-1 | - | - | - | 12.82 | - | 1cb70a8a4aa350d6 |
| 2026-10-14T13:06:03Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.48 | 06466bf859ce4854b29d628dc5e49c98 | ab65d6764c5129b3 |
| 2026-10-14T13:06:04Z | c08-tr | duyu-1 | - | - | - | 4.48 | - | ab65d6764c5129b3 |
| 2026-10-14T13:06:07Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.26 | 199c64862f9740b982ca2d15ef0e2f53 | fd99c54e14afc86a |
| 2026-10-14T13:06:08Z | c09-tr | duyu-1 | - | - | - | 10.26 | - | fd99c54e14afc86a |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:54:22Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | de9fc86ae1fcb4ec | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:54:23Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | df63101fed847354 | audio/en/c02-ex1.mp3 |
| 2026-10-14T14:54:24Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 94ffe3ed8b7b8336 | audio/en/c02-ex2.mp3 |
| 2026-10-14T14:54:25Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 17a5eb84adfd207b | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:54:26Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | b83b583f136a97d8 | audio/en/c03-ex2.mp3 |
| 2026-10-14T14:54:27Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 8da8035d789bdb33 | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:54:28Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 4a639601588b2b7f | audio/en/c04-ex2.mp3 |
| 2026-10-14T14:54:29Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | bea20617d54dcd5e | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:54:30Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | e757e9291c3ceda4 | audio/en/c05-ex2.mp3 |
| 2026-10-14T14:54:31Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 1a141f21eb07c6fc | audio/en/c05-ex3.mp3 |
| 2026-10-14T14:54:32Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | b660171e4755f91a | audio/en/c05-ex4.mp3 |
| 2026-10-14T14:54:33Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 18e9a4ef5a0ee330 | audio/en/c05-ex5.mp3 |
| 2026-10-14T14:54:34Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 9 | a7a2b9611ef63cd9 | audio/en/c06-ex1.mp3 |
| 2026-10-14T14:54:35Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | f940f5e58060c0ca | audio/en/c06-ex2.mp3 |
| 2026-10-14T14:54:36Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 4fc3919968e556c4 | audio/en/c09-ex1.mp3 |
