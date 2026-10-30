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

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:28:32Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 38 | 67ba80ea3b094968 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:28:34Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 41 | 0c5a9d8de8c2aa6d | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:28:35Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 47 | a902f6e00cfc4f86 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:28:37Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | 6f85ad9c380cfa5c | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:28:39Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 37 | 24a102486e730819 | audio/en/c04-ex3.mp3 |
| 2026-10-30T13:28:40Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 37 | db9ca0a69cbbf6cc | audio/en/c04-ex4.mp3 |
| 2026-10-30T13:28:42Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 33 | db8b46031a68c3b0 | audio/en/c04-ex5.mp3 |
| 2026-10-30T13:28:43Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 27 | 8e79632bde114d2a | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:28:45Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | 29e095f9aa1556d9 | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:28:47Z | c08-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 34 | c25238803ed6e823 | audio/en/c08-ex1.mp3 |
