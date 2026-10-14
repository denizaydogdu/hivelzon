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
