# G-B1-07-zero-first-conditional PROMPTS

Ders: Koşul cümleleri: 0 ve 1. tip · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:07:48Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 153 | 9.95 | 52d3dc6cc30a462498ab56f7631f5be0 | c60c036d55157213 |
| 2026-10-14T14:07:49Z | c01-tr | duyu-1 | - | - | - | 9.95 | - | c60c036d55157213 |
| 2026-10-14T14:07:52Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 181 | 11.55 | 047104b3261d452ba88611439d8aa968 | f72cb064abf5e34d |
| 2026-10-14T14:07:53Z | c02-tr | duyu-1 | - | - | - | 11.55 | - | f72cb064abf5e34d |
| 2026-10-14T14:07:56Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 192 | 12.99 | 856c88a211474ce19632040967c3cd04 | 8e292f5f498d8193 |
| 2026-10-14T14:07:57Z | c03-tr | duyu-1 | - | - | - | 12.99 | - | 8e292f5f498d8193 |
| 2026-10-14T14:08:00Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 12.03 | 560ad69ad3b142e6a9e60768a67da47d | 500a1b51aa441cd7 |
| 2026-10-14T14:08:02Z | c04-tr | duyu-1 | - | - | - | 12.03 | - | 500a1b51aa441cd7 |
| 2026-10-14T14:08:04Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 228 | 16.28 | 7e292f0cf69548c19320a4bc99e9789b | 59dc589e59f37c81 |
| 2026-10-14T14:08:06Z | c06-tr | duyu-1 | - | - | - | 16.28 | - | 59dc589e59f37c81 |
| 2026-10-14T14:08:09Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 86 | 5.12 | b88778ee9eed4be9b533fccb669fa9fb | 100b79a26ded3d83 |
| 2026-10-14T14:08:10Z | c08-tr | duyu-1 | - | - | - | 5.12 | - | 100b79a26ded3d83 |
| 2026-10-14T14:08:12Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 164 | 10.41 | 5761ada4f4a544458bbd07889100b1cd | 0472b39de17af7a9 |
| 2026-10-14T14:08:13Z | c09-tr | duyu-1 | - | - | - | 10.41 | - | 0472b39de17af7a9 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T13:59:53Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 1a254e83719c6fea | audio/en/c01-ex1.mp3 |
| 2026-11-26T13:59:55Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 173fe2b3c1a66f2e | audio/en/c02-ex1.mp3 |
| 2026-11-26T13:59:57Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | 7144be90d42b7842 | audio/en/c03-ex1.mp3 |
| 2026-11-26T13:59:59Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 38 | 5e5840d539e47197 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:00:00Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | 400ae17955ed36fa | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:00:02Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | 7f73010687e7eeb8 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:00:04Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | 7a2362317cd66d64 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:00:06Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | f9c6c860147a3d27 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:00:07Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | ca01413e376f2ec7 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:00:09Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 27faa0f3cc6e090b | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:00:11Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 295c084e178c0fd2 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:00:12Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 7008a77df1022aeb | audio/en/c06-ex2.mp3 |
