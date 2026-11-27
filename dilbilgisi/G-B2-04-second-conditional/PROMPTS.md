# G-B2-04-second-conditional PROMPTS

Ders: 2. tip koşul (second conditional): gerçek dışı şimdi · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:09:02Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 130 | 8.64 | 68846403788a431e9562cece6c12bc6e | 2afa74b46d39cd74 |
| 2026-10-14T14:09:03Z | c01-tr | duyu-1 | - | - | - | 8.64 | - | 2afa74b46d39cd74 |
| 2026-10-14T14:09:06Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 15.07 | f62ae88b906640fab8208f5dfe6713e5 | a999e0f68d6c20cb |
| 2026-10-14T14:09:08Z | c02-tr | duyu-1 | - | - | - | 15.07 | - | a999e0f68d6c20cb |
| 2026-10-14T14:09:11Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 183 | 11.07 | 41a0f6d4949a4ebc8465a33c17884e89 | 7a054eea9c97ef55 |
| 2026-10-14T14:09:12Z | c03-tr | duyu-1 | - | - | - | 11.07 | - | 7a054eea9c97ef55 |
| 2026-10-14T14:09:15Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 206 | 13.49 | d617ed93acb348c1a30ef033c25783c8 | 93f5e8132a59ddf9 |
| 2026-10-14T14:09:16Z | c04-tr | duyu-1 | - | - | - | 13.49 | - | 93f5e8132a59ddf9 |
| 2026-10-14T14:09:19Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 215 | 15.55 | 8398264854754127b4314c28d5d63e68 | 6c042594a1b19ca4 |
| 2026-10-14T14:09:21Z | c06-tr | duyu-1 | - | - | - | 15.55 | - | 6c042594a1b19ca4 |
| 2026-10-14T14:09:24Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 135 | 8.16 | aecbfbe7031c4fa289d18fa08b6b8b9b | b9179aa14b166f55 |
| 2026-10-14T14:09:25Z | c08-tr | duyu-1 | - | - | - | 8.16 | - | b9179aa14b166f55 |
| 2026-11-20T16:00:36Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 11.38 | f296e2caeaa54952952c09d77c555a1f | 67f3aaf362c51676 |
| 2026-11-20T16:00:38Z | c01-tr | duyu-1 | - | - | - | 11.38 | - | 67f3aaf362c51676 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:02:58Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 49 | 506feecbfa2aace3 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:03:01Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 45 | 68a82fc4831a80c1 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:03:02Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 295c084e178c0fd2 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:03:05Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 41 | c55028584e6ced0c | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:03:07Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | 333064e53f3e1919 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:03:09Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 46 | d65468add7024d68 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:03:11Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 42 | 780dbaeff5c7360a | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:03:13Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 40 | de3bb0f688397989 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:03:15Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 45 | d673bd65b45271bf | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:03:17Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | f465bc53df37dcde | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:03:19Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | e2dbf543ee76df0e | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:03:21Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 7056b213ef5f9015 | audio/en/c06-ex2.mp3 |
