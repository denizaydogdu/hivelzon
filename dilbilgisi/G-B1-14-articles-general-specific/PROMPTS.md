# G-B1-14-articles-general-specific PROMPTS

Ders: Artikeller (2): genel mi, belirli mi? · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:10:48Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 156 | 11.23 | 07bf247942054df282ba0814d219339d | 0a115743cc792347 |
| 2026-10-14T14:10:49Z | c01-tr | duyu-1 | - | - | - | 11.23 | - | 0a115743cc792347 |
| 2026-10-14T14:10:56Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.11 | 394e043eac034d18966f186cdc3940c2 | 90da43a7ed3b1a09 |
| 2026-10-14T14:10:57Z | c02-tr | duyu-1 | - | - | - | 10.11 | - | 90da43a7ed3b1a09 |
| 2026-10-14T14:11:00Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 116 | 6.88 | 48ffe8763e8a44eaa90650c9977c59a1 | f4ab706bfa092c03 |
| 2026-10-14T14:11:01Z | c03-tr | duyu-1 | - | - | - | 6.88 | - | f4ab706bfa092c03 |
| 2026-10-14T14:11:04Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 12.51 | 1af3b55665294331a20f975ce960e19b | 7a5b395983cf082d |
| 2026-10-14T14:11:05Z | c04-tr | duyu-1 | - | - | - | 12.51 | - | 7a5b395983cf082d |
| 2026-10-14T14:11:08Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 223 | 15.72 | dc4d31fbaba542e0a4cfdaf8b95b9f5a | 0a79f62e52443f58 |
| 2026-10-14T14:11:10Z | c06-tr | duyu-1 | - | - | - | 15.72 | - | 0a79f62e52443f58 |
| 2026-10-14T14:11:12Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 74 | 4.96 | 2cf5056490e2423482e16028e0450967 | f6340043f61fcbe7 |
| 2026-10-14T14:11:13Z | c08-tr | duyu-1 | - | - | - | 4.96 | - | f6340043f61fcbe7 |
| 2026-10-14T14:11:16Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 116 | 7.68 | 63b6f40fb3a544d48bfbb69a3f56d372 | e40d000e88768d23 |
| 2026-10-14T14:11:17Z | c09-tr | duyu-1 | - | - | - | 7.68 | - | e40d000e88768d23 |
