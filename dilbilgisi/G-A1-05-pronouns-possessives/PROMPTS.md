# G-A1-05-pronouns-possessives PROMPTS

Ders: he / she / it, me / him / her, my / your / his / her ve 's · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Örnek alınan pilot dersler: G-A1-01-to-be, G-A1-03-a-an, G-A1-13-third-person-s (H-079, onaylı). Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş sözlüğü:** `Alex` → "Aleks".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın defteri ayrı tutuldu: `kitaplar/_maliyet/patientdesk-h080a.json` (birleştirme çakışmasını önlemek için; ana deftere ana oturum işler). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:05:16Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 12.28 | 583660ce47c14a9082a1de3f0c721fe4 | 7caa9a4659a6e537 |
| 2026-10-14T13:05:17Z | c01-tr | duyu-1 | - | - | - | 12.28 | - | 7caa9a4659a6e537 |
| 2026-10-14T13:05:20Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 11.86 | dfcd4056ac5e4b5c9aea097f72d68a8f | 7b07625eadb26e67 |
| 2026-10-14T13:05:21Z | c02-tr | duyu-1 | - | - | - | 11.86 | - | 7b07625eadb26e67 |
| 2026-10-14T13:05:24Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 164 | 13.31 | 6210b29b2eb24a8c8b48576f245aed7c | b6cc3bfca48cef17 |
| 2026-10-14T13:05:26Z | c03-tr | duyu-1 | - | - | - | 13.31 | - | b6cc3bfca48cef17 |
| 2026-10-14T13:05:28Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 154 | 9.31 | 95a5390e711e414ba915ff4dc339d86d | 5fd28c47b3855f3f |
| 2026-10-14T13:05:29Z | c04-tr | duyu-1 | - | - | - | 9.31 | - | 5fd28c47b3855f3f |
| 2026-10-14T13:05:32Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 138 | 9.12 | b324b23108cc4ba18b1d98147deab976 | d5f9a8fb56ff19cd |
| 2026-10-14T13:05:33Z | c05-tr | duyu-1 | - | - | - | 9.12 | - | d5f9a8fb56ff19cd |
| 2026-10-14T13:05:35Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 9.47 | cbbf074f70fa4324b2a9e3da992bb35b | 26ae31d4624888c7 |
| 2026-10-14T13:05:36Z | c07-tr | duyu-1 | - | - | - | 9.47 | - | 26ae31d4624888c7 |
| 2026-10-14T13:05:38Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 75 | 4.64 | 449d663211ba4e85b8b0042d61b1d8b1 | b4986ab5ad92b184 |
| 2026-10-14T13:05:39Z | c09-tr | duyu-1 | - | - | - | 4.64 | - | b4986ab5ad92b184 |
| 2026-10-14T13:05:41Z | c10-tr | alania-v2 | alania2-f1 | alania-v2.1 | 149 | 10.11 | 73dd6c3348ab4ba2a5beb5b4aa684a3f | 77924a5f8435f452 |
| 2026-10-14T13:05:42Z | c10-tr | duyu-1 | - | - | - | 10.11 | - | 77924a5f8435f452 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:54:04Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 3edb60c0eee69a95 | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:54:06Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 0334c9539df95631 | audio/en/c02-ex1.mp3 |
| 2026-10-14T14:54:07Z | c02-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | fcbe1b9a60aeee61 | audio/en/c02-ex2.mp3 |
| 2026-10-14T14:54:08Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 0e29114aa86c115d | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:54:09Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | b1235f4bb50ad8fd | audio/en/c03-ex2.mp3 |
| 2026-10-14T14:54:10Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 37e79c35d4fee75c | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:54:11Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 11 | 13d913c719a839de | audio/en/c04-ex2.mp3 |
| 2026-10-14T14:54:12Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 5a409be8454147e5 | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:54:13Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 38 | 3f7e132afd28844b | audio/en/c06-ex1.mp3 |
| 2026-10-14T14:54:15Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 5b6d780b36cb8acb | audio/en/c06-ex2.mp3 |
| 2026-10-14T14:54:16Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 4b7bc1c77d00c1bf | audio/en/c06-ex3.mp3 |
| 2026-10-14T14:54:17Z | c06-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 6d31d54ee54debca | audio/en/c06-ex4.mp3 |
| 2026-10-14T14:54:18Z | c06-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 016306c84cc7ec9a | audio/en/c06-ex5.mp3 |
| 2026-10-14T14:54:19Z | c07-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 778621772ae2924f | audio/en/c07-ex1.mp3 |
| 2026-10-14T14:54:20Z | c07-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 36 | fd8dcf86dbfb246c | audio/en/c07-ex2.mp3 |
