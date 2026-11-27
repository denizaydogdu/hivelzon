# G-C1-07-unreal-past PROMPTS

Ders: Gerçek dışı geçmiş (unreal past): It's time…, would rather…, as if… · Dalga 3 C1 (H-082) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:39:54Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 109 | 8.48 | a1e8a01340ab46d790ac733e8bd68cfc | ef33ba32ac958674 |
| 2026-10-14T14:39:55Z | c01-tr | duyu-1 | - | - | - | 8.48 | - | ef33ba32ac958674 |
| 2026-10-14T14:39:58Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 190 | 12.83 | 7d24b63dd1634a4ab4d32b34c145f636 | 6823ecb5b4a8b62e |
| 2026-10-14T14:39:59Z | c02-tr | duyu-1 | - | - | - | 12.83 | - | 6823ecb5b4a8b62e |
| 2026-10-14T14:40:02Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 165 | 11.23 | 24ea7540b9184593bb7a602634c9a22b | 0c4e3cbe6cffdb3b |
| 2026-10-14T14:40:03Z | c03-tr | duyu-1 | - | - | - | 11.23 | - | 0c4e3cbe6cffdb3b |
| 2026-10-14T14:40:06Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 215 | 14.27 | b48dd356734c43ae944fce6a3c5f0f48 | 47c92c5ec73865da |
| 2026-10-14T14:40:07Z | c04-tr | duyu-1 | - | - | - | 14.27 | - | 47c92c5ec73865da |
| 2026-10-14T14:40:10Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 209 | 13.73 | 084453d9396647c89184f5ed26c6949b | 003df5d021fe8e8b |
| 2026-10-14T14:40:12Z | c06-tr | duyu-1 | - | - | - | 13.73 | - | 003df5d021fe8e8b |
| 2026-10-14T14:40:15Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 195 | 12.32 | 877babdc61b94172b9a826e89ceb88f5 | 0c59e8f867ace073 |
| 2026-10-14T14:40:17Z | c08-tr | duyu-1 | - | - | - | 12.32 | - | 0c59e8f867ace073 |
| 2026-11-20T16:02:22Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 11.2 | 123db561e1ff4e3ba0fea7548e59e7d7 | d930617c04c30271 |
| 2026-11-20T16:02:29Z | c01-tr | duyu-1 | - | - | - | 11.2 | - | d930617c04c30271 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:09:30Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 29 | d2c76c9d503ad41d | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:09:32Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 36 | 1833a43121b33633 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:09:33Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 24 | e887b4c9b782c0b7 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:09:36Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 29 | 4c2eed48385a8918 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:09:37Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | 682f9e17a0fd49d1 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:09:39Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | e7c8ad07dad8da01 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:09:41Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 35 | 94935a7b1a3d8c45 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:09:42Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | 79c87cd9b08fa84b | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:09:45Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 31 | 3d8977bb36fce552 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:09:46Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 34 | 01a7a05dcc82c52f | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:09:48Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 38 | e9eb542030dafe39 | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:09:50Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.05 | 23 | 3eb97721e4349b9b | audio/en/c06-ex1.mp3 |
