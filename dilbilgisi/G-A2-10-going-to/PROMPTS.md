# G-A2-10-going-to PROMPTS

Ders: going to: plan ve kanıta dayalı tahmin · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot dersler (`G-A1-01-to-be`, `G-A1-03-a-an`, `G-A1-13-third-person-s`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A2 kapsamasında ve en çok 12 kelime (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h080b.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:10:35Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 8.32 | ed05849d565544b28860092dda36c63f | 5d53855e1f711edf |
| 2026-10-14T13:10:37Z | c01-tr | duyu-1 | - | - | - | 8.32 | - | 5d53855e1f711edf |
| 2026-10-14T13:10:39Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 190 | 13.79 | 103f906f6ea24eee9ce2b7afff1cbba0 | 6b41d8ba4e76de9c |
| 2026-10-14T13:10:41Z | c02-tr | duyu-1 | - | - | - | 13.79 | - | 6b41d8ba4e76de9c |
| 2026-10-14T13:10:44Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 10.2 | f4afae0e176c4cee9837ce4617a5505e | ccae0d87dcf79840 |
| 2026-10-14T13:10:45Z | c03-tr | duyu-1 | - | - | - | 10.2 | - | ccae0d87dcf79840 |
| 2026-10-14T13:10:48Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 188 | 12.99 | 77ea8e599062457ca275bf28dbcae0df | f1a77aaa4efd8762 |
| 2026-10-14T13:10:49Z | c05-tr | duyu-1 | - | - | - | 12.99 | - | f1a77aaa4efd8762 |
| 2026-10-14T13:10:52Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 88 | 5.28 | 1b770501705f43728c9b337816444100 | a42858af37c6f967 |
| 2026-10-14T13:10:53Z | c07-tr | duyu-1 | - | - | - | 5.28 | - | a42858af37c6f967 |
| 2026-10-14T13:10:55Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 133 | 9.44 | 220c520cb9cb4acb887aab6cdfd6c658 | 8f7b9482c1f1696d |
| 2026-10-14T13:10:56Z | c08-tr | duyu-1 | - | - | - | 9.44 | - | 8f7b9482c1f1696d |
