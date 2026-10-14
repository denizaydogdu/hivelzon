# G-C2-04-formal-subjunctive PROMPTS

Ders: Resmî dilek kipi ve if'siz şart (subjunctive, inverted conditionals): Should you…, Had I known… · Dalga 3 C2 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:42:06Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 129 | 10.4 | 73402ec2cb014f7f8f1658ab595ea64f | b022ed8377645b3a |
| 2026-10-14T14:42:07Z | c01-tr | duyu-1 | - | - | - | 10.4 | - | b022ed8377645b3a |
| 2026-10-14T14:42:10Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 217 | 15.38 | 16f92fe6ed104bf799d730a04a1e0e7b | 77de07fb273fbe54 |
| 2026-10-14T14:42:11Z | c02-tr | duyu-1 | - | - | - | 15.38 | - | 77de07fb273fbe54 |
| 2026-10-14T14:42:14Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 12.98 | 3f823f30854e440db4c0e8da6efd9557 | 98ee8d89ec80b459 |
| 2026-10-14T14:42:16Z | c03-tr | duyu-1 | - | - | - | 12.98 | - | 98ee8d89ec80b459 |
| 2026-10-14T14:42:19Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 225 | 16.17 | 802e33d530fb4292a687ae761084ff6c | 7e4a0dbc688e18d0 |
| 2026-10-14T14:42:20Z | c04-tr | duyu-1 | - | - | - | 16.17 | - | 7e4a0dbc688e18d0 |
| 2026-10-14T14:42:24Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 229 | 15.1 | a13ff52aafcf4c558f3b9058abdddfab | 6c705be25766463e |
| 2026-10-14T14:42:25Z | c06-tr | duyu-1 | - | - | - | 15.1 | - | 6c705be25766463e |
| 2026-10-14T14:42:28Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 9.63 | 3ca493aad03946758ff29dd939e5102f | 9bf2261b8b3e1384 |
| 2026-10-14T14:42:29Z | c08-tr | duyu-1 | - | - | - | 9.63 | - | 9bf2261b8b3e1384 |
