# G-B1-08-defining-relative-clauses PROMPTS

Ders: Tanımlayan sıfat cümlecikleri: who / which / that · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:08:20Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 9.76 | a7ee85d61c50478eb43c1b3c9abd4aff | 910766fff1f6e9cf |
| 2026-10-14T14:08:21Z | c01-tr | duyu-1 | - | - | - | 9.76 | - | 910766fff1f6e9cf |
| 2026-10-14T14:08:23Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 9.79 | 73a7d8089b1444abafd94eebb8ae28fb | 61c2c7ad5a30de20 |
| 2026-10-14T14:08:24Z | c02-tr | duyu-1 | - | - | - | 9.79 | - | 61c2c7ad5a30de20 |
| 2026-10-14T14:08:26Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 144 | 8.64 | 832e0d4d61d447eebe41e7be2a349ec4 | 9a39fc5458c30d77 |
| 2026-10-14T14:08:28Z | c03-tr | duyu-1 | - | - | - | 8.64 | - | 9a39fc5458c30d77 |
| 2026-10-14T14:08:30Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 128 | 8.48 | df5ef6b85be44302a2d5a363e44dc3d2 | a14ca8293135b691 |
| 2026-10-14T14:08:31Z | c04-tr | duyu-1 | - | - | - | 8.48 | - | a14ca8293135b691 |
| 2026-10-14T14:08:34Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 221 | 15.09 | 833764b04a7d42b0ad3f2a749eac67be | 99f17af2b38ee7eb |
| 2026-10-14T14:08:36Z | c06-tr | duyu-1 | - | - | - | 15.09 | - | 99f17af2b38ee7eb |
| 2026-10-14T14:08:39Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 122 | 8.16 | 75299ca97ae140709fa28a61cfc14992 | f206bb3156907352 |
| 2026-10-14T14:08:40Z | c08-tr | duyu-1 | - | - | - | 8.16 | - | f206bb3156907352 |
| 2026-10-14T14:08:42Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 140 | 9.12 | 8ada35dfae7644b8b32d7ceefa5f711c | a46f94b3ac46342b |
| 2026-10-14T14:08:43Z | c09-tr | duyu-1 | - | - | - | 9.12 | - | a46f94b3ac46342b |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:00:14Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 48 | c8043fc70854d11d | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:00:16Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | 6f75e06bfe59ed98 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:00:18Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | fb0299ed6474d129 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:00:19Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | 3ca42f5b96319065 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:00:21Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | d44e726e87a0cf51 | audio/en/c03-ex3.mp3 |
| 2026-11-26T14:00:23Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 1ccf35bfa51a571d | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:00:24Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 42 | fdd468d73578831f | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:00:26Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 5b0cbd30a1e24da8 | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:00:28Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | 6578c4360cf9d7a5 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:00:30Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | 443ced44f0d67f8b | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:00:31Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 5afc1213deeb0eec | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:00:33Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | c17d01838f6aea9a | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:00:34Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 30 | b27b543038ba1a1a | audio/en/c06-ex2.mp3 |
