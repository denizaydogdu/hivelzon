# G-B1-01-present-perfect-experience PROMPTS

Ders: Present perfect (1): deneyim, ever / never · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:05:24Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 177 | 12.81 | 820294c099af4f98bf6d42b2e3f11e6f | 41cec98304db2ead |
| 2026-10-14T14:05:25Z | c01-tr | duyu-1 | - | - | - | 12.81 | - | 41cec98304db2ead |
| 2026-10-14T14:05:30Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 144 | 11.55 | ca95e1144ec543e6b15d8f858ef67aa3 | 117014f87f278374 |
| 2026-10-14T14:05:32Z | c02-tr | duyu-1 | - | - | - | 11.55 | - | 117014f87f278374 |
| 2026-10-14T14:05:35Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 144 | 10.27 | 6c773c050c7e41d7b8f7b13287d66a58 | f37f1c661da205c8 |
| 2026-10-14T14:05:36Z | c03-tr | duyu-1 | - | - | - | 10.27 | - | f37f1c661da205c8 |
| 2026-10-14T14:05:39Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 209 | 15.48 | c3cec7d09a2d4167b35ae944ba7abe01 | 109aac51f2a53703 |
| 2026-10-14T14:05:41Z | c04-tr | duyu-1 | - | - | - | 15.48 | - | 109aac51f2a53703 |
| 2026-10-14T14:05:44Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 242 | 16.44 | d3fd7d6f37344d34b636a8b0e28f5422 | 900f8cd3b205ad4c |
| 2026-10-14T14:05:45Z | c06-tr | duyu-1 | - | - | - | 16.44 | - | 900f8cd3b205ad4c |
| 2026-10-14T14:05:48Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.22 | 3c3bc7fb2cad47729f4df4e357ac5047 | 05494a0bf89ecb7d |
| 2026-10-14T14:05:49Z | c08-tr | duyu-1 | - | - | - | 10.22 | - | 05494a0bf89ecb7d |
