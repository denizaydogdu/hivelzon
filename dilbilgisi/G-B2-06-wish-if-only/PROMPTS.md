# G-B2-06-wish-if-only PROMPTS

Ders: wish ve if only: dilek ve pişmanlık · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:09:47Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 134 | 9.44 | bec47c42313240a9a0c79db2de962b9a | 56758244e61c1301 |
| 2026-10-14T14:09:49Z | c01-tr | duyu-1 | - | - | - | 9.44 | - | 56758244e61c1301 |
| 2026-10-14T14:09:52Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 219 | 13.86 | 3a459e6b1b7e4f429a6fe05cb54a383c | ff26b2497d9b9b91 |
| 2026-10-14T14:09:54Z | c02-tr | duyu-1 | - | - | - | 13.86 | - | ff26b2497d9b9b91 |
| 2026-10-14T14:09:56Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 170 | 10.63 | a6971ab9d3c145a9ba5cbd84934a6976 | 3468b3253f035b35 |
| 2026-10-14T14:09:58Z | c03-tr | duyu-1 | - | - | - | 10.63 | - | 3468b3253f035b35 |
| 2026-10-14T14:10:01Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 199 | 13.15 | 822cfbba2ddc46a89da2372a485070d0 | 6881b36601af1bd2 |
| 2026-10-14T14:10:02Z | c04-tr | duyu-1 | - | - | - | 13.15 | - | 6881b36601af1bd2 |
| 2026-10-14T14:10:05Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 207 | 13.15 | d636648a47874186982448e84d2b57ca | eae416cebed4c8cd |
| 2026-10-14T14:10:06Z | c06-tr | duyu-1 | - | - | - | 13.15 | - | eae416cebed4c8cd |
| 2026-10-14T14:10:09Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 143 | 9.47 | 60122863fc754b8ebe3857856c691bed | da0824049e83247a |
| 2026-10-14T14:10:10Z | c08-tr | duyu-1 | - | - | - | 9.47 | - | da0824049e83247a |
