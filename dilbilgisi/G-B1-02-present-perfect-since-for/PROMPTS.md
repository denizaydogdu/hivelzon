# G-B1-02-present-perfect-since-for PROMPTS

Ders: Present perfect (2): since / for · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:05:52Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 180 | 12.83 | 9f8a56d4594c4a6cbebb21218fa9fe32 | 5e047ba9bf8971fe |
| 2026-10-14T14:05:53Z | c01-tr | duyu-1 | - | - | - | 12.83 | - | 5e047ba9bf8971fe |
| 2026-10-14T14:05:56Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 181 | 12.35 | 1a4513e7f676496b992e54e1a7e47aae | 39157fb0acdc297c |
| 2026-10-14T14:05:57Z | c02-tr | duyu-1 | - | - | - | 12.35 | - | 39157fb0acdc297c |
| 2026-10-14T14:06:00Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 248 | 17.73 | 3b5f1b7d3a6741078984d1d7c0a9f9b5 | 4a14036ab3b4350a |
| 2026-10-14T14:06:02Z | c03-tr | duyu-1 | - | - | - | 17.73 | - | 4a14036ab3b4350a |
| 2026-10-14T14:06:05Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 197 | 14.57 | 5f7c5a81a7e148e8903b485ab4f6e19b | 3b1737fa56aaeba8 |
| 2026-10-14T14:06:07Z | c05-tr | duyu-1 | - | - | - | 14.57 | - | 3b1737fa56aaeba8 |
| 2026-10-14T14:06:11Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 9.95 | c060d13dae40479d9742f6884f54d6a1 | 91cf34a468978b38 |
| 2026-10-14T14:06:12Z | c07-tr | duyu-1 | - | - | - | 9.95 | - | 91cf34a468978b38 |
