# G-A2-05-past-simple-irregular PROMPTS

Ders: Geçmiş zaman: düzensiz fiiller · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:08:39Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 101 | 7.68 | 274ee0f9a921480ca6b983f4e48cc3d5 | 81696489b440b248 |
| 2026-10-14T13:08:40Z | c01-tr | duyu-1 | - | - | - | 7.68 | - | 81696489b440b248 |
| 2026-10-14T13:08:43Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 135 | 9.12 | 13879c58cc6a43e1aa3f5d0f908ee905 | 6cf1b81e3acfb53c |
| 2026-10-14T13:08:44Z | c02-tr | duyu-1 | - | - | - | 9.12 | - | 6cf1b81e3acfb53c |
| 2026-10-14T13:08:46Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 10.27 | 53a19b7a2ee641e0809381a7cde67752 | 693198eedd0f9a65 |
| 2026-10-14T13:08:47Z | c03-tr | duyu-1 | - | - | - | 10.27 | - | 693198eedd0f9a65 |
| 2026-10-14T13:08:50Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 173 | 12.51 | 04e213e1cb3d40e4a62301eca0e372dc | 3257a100605287d2 |
| 2026-10-14T13:08:52Z | c05-tr | duyu-1 | - | - | - | 12.51 | - | 3257a100605287d2 |
| 2026-10-14T13:08:54Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 69 | 4.96 | ed6b4754b0314586ac748bebdfb15eba | f6ce734051d7f594 |
| 2026-10-14T13:08:55Z | c07-tr | duyu-1 | - | - | - | 4.96 | - | f6ce734051d7f594 |
| 2026-10-14T13:08:57Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 91 | 6.72 | 44df4616447549bcba1fbf5696df5836 | bb65e7a6b6122738 |
| 2026-10-14T13:08:58Z | c08-tr | duyu-1 | - | - | - | 6.72 | - | bb65e7a6b6122738 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T18:26:46Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 12 | bc4b23c69a4ab44a | audio/en/c01-ex1.mp3 |
| 2026-10-14T18:26:47Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 12 | 614f817d7aaa70b6 | audio/en/c03-ex1.mp3 |
| 2026-10-14T18:26:49Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 15 | 2beee64045e06b7b | audio/en/c03-ex2.mp3 |
| 2026-10-14T18:26:50Z | c03-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 13 | 9683cb4e100aed93 | audio/en/c03-ex3.mp3 |
| 2026-10-14T18:26:51Z | c03-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 16 | 9229acfb3e8590ee | audio/en/c03-ex4.mp3 |
| 2026-10-14T18:26:52Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | 6a868ba88b9e16bd | audio/en/c04-ex1.mp3 |
| 2026-10-14T18:26:54Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 31 | 80c4236305d8f898 | audio/en/c04-ex2.mp3 |
| 2026-10-14T18:26:55Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 8d9825b6fc15485e | audio/en/c04-ex3.mp3 |
| 2026-10-14T18:26:56Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 33 | f4d04a00ba66df24 | audio/en/c04-ex4.mp3 |
| 2026-10-14T18:26:57Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 21 | 407afcb670712497 | audio/en/c04-ex5.mp3 |
| 2026-10-14T18:26:58Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 15 | 8122ac4fc36cf843 | audio/en/c05-ex1.mp3 |
| 2026-10-14T18:27:00Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 30 | 781126fff19f965f | audio/en/c05-ex2.mp3 |
| 2026-10-14T18:27:01Z | c08-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 19 | 890ea235a06e3148 | audio/en/c08-ex1.mp3 |
