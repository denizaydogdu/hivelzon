# G-A1-03-a-an PROMPTS

Ders: a / an: "bir"i söylemek · Pilot (H-079) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `Alex` → "Aleks". İki biçim (a / an) Türkçe anlatımda geçmez; ayrı İngilizce örnek parçalarında duyulur.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi (ücretsiz kota bitti; kullanıcı yeni anahtar verecek), yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T11:45:23Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 108 | 7.2 | 294ec6e3f3e44ba49679d4d1c0b57b31 | be820bd15a82bcf5 |
| 2026-10-14T11:45:24Z | c01-tr | duyu-1 | - | - | - | 7.2 | - | be820bd15a82bcf5 |
| 2026-10-14T11:45:27Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 10.11 | e3ba734935e2441887a8ee86d50744a5 | 2dca8d886a50fafa |
| 2026-10-14T11:45:28Z | c02-tr | duyu-1 | - | - | - | 10.11 | - | 2dca8d886a50fafa |
| 2026-10-14T11:45:30Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 155 | 9.95 | 8847f89fde234ef2aa7bc3c2ec4b174b | 5caafbac5ff4865e |
| 2026-10-14T11:45:31Z | c03-tr | duyu-1 | - | - | - | 9.95 | - | 5caafbac5ff4865e |
| 2026-10-14T11:45:34Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 136 | 8.32 | 10bf250c628c4857a09cd6bf1a39021c | 325eb70c16a9399c |
| 2026-10-14T11:45:35Z | c04-tr | duyu-1 | - | - | - | 8.32 | - | 325eb70c16a9399c |
| 2026-10-14T11:45:37Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 10.11 | a58e2c1a0177444eafe5499ef5721fd1 | 433218816681abf9 |
| 2026-10-14T11:45:38Z | c06-tr | duyu-1 | - | - | - | 10.11 | - | 433218816681abf9 |
| 2026-10-14T11:45:41Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 4.64 | 4808ed1b90f149eda6aa39e1b6896406 | 61703e54eea8e3f2 |
| 2026-10-14T11:45:41Z | c08-tr | duyu-1 | - | - | - | 4.64 | - | 61703e54eea8e3f2 |
| 2026-10-14T11:45:44Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 133 | 8.16 | a89efbc96cfc45ae9ecc7b7e806b1896 | 841a18fdcd94545c |
| 2026-10-14T11:45:45Z | c09-tr | duyu-1 | - | - | - | 8.16 | - | 841a18fdcd94545c |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T12:15:16Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 5bf49a4a8b257c25 | audio/en/c01-ex1.mp3 |
| 2026-10-14T12:15:17Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 14 | 6b657556a0442c4e | audio/en/c03-ex1.mp3 |
| 2026-10-14T12:15:18Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | f76fa81fd29ef5ea | audio/en/c03-ex2.mp3 |
| 2026-10-14T12:15:19Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 2056aef5bdcd6322 | audio/en/c04-ex1.mp3 |
| 2026-10-14T12:15:20Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 16c5fc4f35e0a5c2 | audio/en/c04-ex2.mp3 |
| 2026-10-14T12:15:21Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | afa550a35691cd14 | audio/en/c05-ex1.mp3 |
| 2026-10-14T12:15:22Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | a7c71d41446e6a21 | audio/en/c05-ex2.mp3 |
| 2026-10-14T12:15:23Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 6e94b1c1157490b9 | audio/en/c05-ex3.mp3 |
| 2026-10-14T12:15:25Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 28 | a45304ab17cac499 | audio/en/c05-ex4.mp3 |
| 2026-10-14T12:15:26Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | 3a213809c4903f0d | audio/en/c05-ex5.mp3 |
| 2026-10-14T12:15:27Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | d09712b2f0cb1e08 | audio/en/c06-ex2.mp3 |
| 2026-10-14T12:15:29Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 697e2a388acad78b | audio/en/c09-ex1.mp3 |
