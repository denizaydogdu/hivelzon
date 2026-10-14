# G-C1-01-inversion PROMPTS

Ders: Devrik yapı (inversion): Never have I…, Not only… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: önceki dalgaların dersleri (`G-B2-01-passive`, `G-B1-01-present-perfect-experience`, `G-A2-04-past-simple-regular`), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, sade ve suçlamasız (C düzeyinde de). İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. C1/C2 kapsaması Octanove listesi depoda olmadığı için denetlenmedi (`grammar_lint.py` uyarısı).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h082.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:37:14Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 10.75 | 6c65486c1d7a498c8c7e62222e82b463 | 97cca81464d7effb |
| 2026-10-14T14:37:15Z | c01-tr | duyu-1 | - | - | - | 10.75 | - | 97cca81464d7effb |
| 2026-10-14T14:37:18Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 179 | 13.46 | 5fcbc448d62f4605b2f9fd2a71dfe969 | 742e1db8773fdc25 |
| 2026-10-14T14:37:19Z | c02-tr | duyu-1 | - | - | - | 13.46 | - | 742e1db8773fdc25 |
| 2026-10-14T14:37:23Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 206 | 13.63 | 015d82528e034bfebea0a6144cd77084 | 468c3c08febf4b6b |
| 2026-10-14T14:37:24Z | c03-tr | duyu-1 | - | - | - | 13.63 | - | 468c3c08febf4b6b |
| 2026-10-14T14:37:28Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 235 | 16.19 | 020a2015022d44b9b7566b2e77df6d29 | f084c54351ed9be1 |
| 2026-10-14T14:37:29Z | c04-tr | duyu-1 | - | - | - | 16.19 | - | f084c54351ed9be1 |
| 2026-10-14T14:37:33Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 232 | 16.28 | 3b408914283b479085a63e680f3ef961 | 6220fcd7ac604e1f |
| 2026-10-14T14:37:35Z | c06-tr | duyu-1 | - | - | - | 16.28 | - | 6220fcd7ac604e1f |
| 2026-10-14T14:37:39Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 160 | 12.28 | 824fdd30f2464e20805e425b93d34c68 | 4d57c0eda4aaceb3 |
| 2026-10-14T14:37:40Z | c08-tr | duyu-1 | - | - | - | 12.28 | - | 4d57c0eda4aaceb3 |
