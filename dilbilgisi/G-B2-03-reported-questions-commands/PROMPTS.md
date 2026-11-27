# G-B2-03-reported-questions-commands PROMPTS

Ders: Dolaylı anlatım (2): soru ve rica aktarma · Dalga 2 B2 (H-081) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T14:08:37Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 165 | 11.39 | ce61e1984d9a4586a62d97ed787aa63e | a071286fe4643182 |
| 2026-10-14T14:08:39Z | c01-tr | duyu-1 | - | - | - | 11.39 | - | a071286fe4643182 |
| 2026-10-14T14:08:41Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 179 | 12.83 | cacd521ca6744b9aad5b4320dc9e396a | 9f58f767b713cd43 |
| 2026-10-14T14:08:42Z | c02-tr | duyu-1 | - | - | - | 12.83 | - | 9f58f767b713cd43 |
| 2026-10-14T14:08:45Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 11.36 | 656e16b3b6b04043a19630cad05e549a | 37d8d826bbbb0eae |
| 2026-10-14T14:08:47Z | c03-tr | duyu-1 | - | - | - | 11.36 | - | 37d8d826bbbb0eae |
| 2026-10-14T14:08:50Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 170 | 12.14 | ce2b289fc92544eb8045cf39cfbf39c2 | 8ac0cb39182abcc1 |
| 2026-10-14T14:08:51Z | c04-tr | duyu-1 | - | - | - | 12.14 | - | 8ac0cb39182abcc1 |
| 2026-10-14T14:08:54Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 200 | 13.63 | 220f0f0e5483492b91b75d33ddd83880 | f755b148b7a3c777 |
| 2026-10-14T14:08:55Z | c06-tr | duyu-1 | - | - | - | 13.63 | - | f755b148b7a3c777 |
| 2026-10-14T14:08:58Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 8.96 | 9731a38a9fba43a79375f36a5511d8fb | 0f53518fa219e349 |
| 2026-10-14T14:09:00Z | c08-tr | duyu-1 | - | - | - | 8.96 | - | 0f53518fa219e349 |
| 2026-10-14T14:10:56Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 172 | 12.19 | 11de71ec33894d94a2b37595aeb53f63 | 83547c912357a451 |
| 2026-10-14T14:10:57Z | c02-tr | duyu-1 | - | - | - | 12.19 | - | 83547c912357a451 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:02:32Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 42 | 8cc2f490a56b7ff4 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:02:34Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | eac3443654cf1dd4 | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:02:36Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 27 | 41c727079a7e126c | audio/en/c02-ex2.mp3 |
| 2026-11-26T14:02:37Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 26 | 879bf7f81c602caa | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:02:39Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 24 | 29500b517b828510 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:02:41Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 39 | 9c422660548db8e9 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:02:42Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 32 | 608615cf2186fbb3 | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:02:44Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 29 | d86e12640876786a | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:02:45Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | 9c725c0476f1a10b | audio/en/c05-ex2.mp3 |
| 2026-11-26T14:02:47Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 34 | a6268b91a2784ad3 | audio/en/c05-ex3.mp3 |
| 2026-11-26T14:02:49Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 7cea3f13afe49e82 | audio/en/c05-ex4.mp3 |
| 2026-11-26T14:02:51Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 28 | af5d394fc66d999c | audio/en/c05-ex5.mp3 |
| 2026-11-26T14:02:53Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 31 | f3c5c34e14828f19 | audio/en/c06-ex1.mp3 |
| 2026-11-26T14:02:55Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 19 | 216d659c04f3d432 | audio/en/c06-ex2.mp3 |
| 2026-11-26T14:02:56Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 27 | 542975651cca5aea | audio/en/c06-ex3.mp3 |
