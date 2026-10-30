# G-A2-14-have-to-must-should PROMPTS

Ders: have to / must / should: zorunluluk ve öneri · Dalga 1 A2 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:12:13Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 128 | 7.68 | 824d5384c6b84368ba1acf6118e62f69 | 1ebe3b28d61cd68d |
| 2026-10-14T13:12:14Z | c01-tr | duyu-1 | - | - | - | 7.68 | - | 1ebe3b28d61cd68d |
| 2026-10-14T13:12:16Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 167 | 12.5 | dde8bdab54c24a62972abce69803de00 | 11b260c7a5985139 |
| 2026-10-14T13:12:18Z | c02-tr | duyu-1 | - | - | - | 12.5 | - | 11b260c7a5985139 |
| 2026-10-14T13:12:21Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 10.84 | 897ecaeb0dad4d72ae8b6eff90224bf7 | 115f1075bb98ebb8 |
| 2026-10-14T13:12:23Z | c03-tr | duyu-1 | - | - | - | 10.84 | - | 115f1075bb98ebb8 |
| 2026-10-14T13:12:25Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 157 | 10.25 | 0e2af6adac294be7b066569b836882be | 149b34c8ba57cfd0 |
| 2026-10-14T13:12:27Z | c04-tr | duyu-1 | - | - | - | 10.25 | - | 149b34c8ba57cfd0 |
| 2026-10-14T13:12:30Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 230 | 16.21 | cff5d59479ad4ceab06e02209a22023f | 9ce48045b30597cd |
| 2026-10-14T13:12:31Z | c06-tr | duyu-1 | - | - | - | 16.21 | - | 9ce48045b30597cd |
| 2026-10-14T13:12:34Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 91 | 5.6 | a420e4ba9227439983d20c24a99b75b9 | c15d9e35efd6127c |
| 2026-10-14T13:12:35Z | c08-tr | duyu-1 | - | - | - | 5.6 | - | c15d9e35efd6127c |
| 2026-10-14T13:12:37Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 137 | 9.76 | 687819453bf14a1f9a921dd0d096baab | c34bfb7d06d62934 |
| 2026-10-14T13:12:39Z | c09-tr | duyu-1 | - | - | - | 9.76 | - | c34bfb7d06d62934 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-30T13:29:57Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | ca18215cb0829d95 | audio/en/c01-ex1.mp3 |
| 2026-10-30T13:29:59Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 39 | 8c952b153ff026ef | audio/en/c02-ex2.mp3 |
| 2026-10-30T13:30:00Z | c02-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | ee260afe65f00012 | audio/en/c02-ex3.mp3 |
| 2026-10-30T13:30:01Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 108cb99748727406 | audio/en/c03-ex1.mp3 |
| 2026-10-30T13:30:03Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 22 | 643f39626c4b5692 | audio/en/c03-ex2.mp3 |
| 2026-10-30T13:30:04Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 28 | 610a2bdc81852bf6 | audio/en/c04-ex1.mp3 |
| 2026-10-30T13:30:06Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | 6b7c14b641313e58 | audio/en/c04-ex2.mp3 |
| 2026-10-30T13:30:07Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | 6f915df4086b4700 | audio/en/c05-ex1.mp3 |
| 2026-10-30T13:30:09Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 32 | f3390d41fb37a747 | audio/en/c05-ex2.mp3 |
| 2026-10-30T13:30:10Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 29 | a37eb6fbbee4ad34 | audio/en/c05-ex3.mp3 |
| 2026-10-30T13:30:13Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 42 | 9376b333c822ae62 | audio/en/c05-ex4.mp3 |
| 2026-10-30T13:30:14Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 24 | a71e1468273048f2 | audio/en/c05-ex5.mp3 |
| 2026-10-30T13:30:15Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 12 | cce07d83e5369b6b | audio/en/c06-ex1.mp3 |
| 2026-10-30T13:30:17Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 23 | 476b0c6b5e6d7747 | audio/en/c06-ex2.mp3 |
| 2026-10-30T13:30:18Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 16 | 03d1afd3d81acb95 | audio/en/c06-ex3.mp3 |
