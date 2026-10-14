# G-C1-06-impersonal-passive PROMPTS

Ders: Kişisiz edilgen (impersonal passive): It is said that…, He is believed to… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:39:27Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 10.74 | 62784036127b45978b6863450cf2612e | 8a1db58b465b7655 |
| 2026-10-14T14:39:28Z | c01-tr | duyu-1 | - | - | - | 10.74 | - | 8a1db58b465b7655 |
| 2026-10-14T14:39:31Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 198 | 13.95 | e877ecb283f142adb1e14254429216db | 5a20740bfacb9f43 |
| 2026-10-14T14:39:32Z | c02-tr | duyu-1 | - | - | - | 13.95 | - | 5a20740bfacb9f43 |
| 2026-10-14T14:39:35Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 11.07 | 46d737a05a7441e4946c1c0376ed8dde | 38c97319c354bc9d |
| 2026-10-14T14:39:37Z | c03-tr | duyu-1 | - | - | - | 11.07 | - | 38c97319c354bc9d |
| 2026-10-14T14:39:40Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 208 | 14.27 | be39761506a84b0fb1334cc183cee63c | d3c84b3aaed03fab |
| 2026-10-14T14:39:41Z | c04-tr | duyu-1 | - | - | - | 14.27 | - | d3c84b3aaed03fab |
| 2026-10-14T14:39:44Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 196 | 12.35 | 3ae570f644a74b85a429828d375e4590 | 53a9bd3689a5b236 |
| 2026-10-14T14:39:46Z | c06-tr | duyu-1 | - | - | - | 12.35 | - | 53a9bd3689a5b236 |
| 2026-10-14T14:39:49Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 204 | 15.87 | c15d1bfda0ac449196dc20d8bb612d05 | 2ef6bf7667509b54 |
| 2026-10-14T14:39:51Z | c08-tr | duyu-1 | - | - | - | 15.87 | - | 2ef6bf7667509b54 |
