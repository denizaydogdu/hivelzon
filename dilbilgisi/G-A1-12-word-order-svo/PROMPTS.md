# G-A1-12-word-order-svo PROMPTS

Ders: Kelime sırası: özne + fiil + nesne · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Örnek alınan pilot dersler: G-A1-01-to-be, G-A1-03-a-an, G-A1-13-third-person-s (H-079, onaylı). Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş sözlüğü:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın defteri ayrı tutuldu: `kitaplar/_maliyet/patientdesk-h080a.json` (birleştirme çakışmasını önlemek için; ana deftere ana oturum işler). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T13:08:22Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 123 | 7.84 | e9e6d34c0b0743e58303d382333b8faa | 137609ef5b289f69 |
| 2026-10-14T13:08:23Z | c01-tr | duyu-1 | - | - | - | 7.84 | - | 137609ef5b289f69 |
| 2026-10-14T13:08:25Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 159 | 10.58 | 5f7d1c0ee73045e4b513021d1b7611ec | 96fd37242d9f2be2 |
| 2026-10-14T13:08:27Z | c02-tr | duyu-1 | - | - | - | 10.58 | - | 96fd37242d9f2be2 |
| 2026-10-14T13:08:29Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 10.59 | dd473a26c5604301af1330d98e2771e5 | 3a7164629855b910 |
| 2026-10-14T13:08:30Z | c03-tr | duyu-1 | - | - | - | 10.59 | - | 3a7164629855b910 |
| 2026-10-14T13:08:33Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 9.12 | cc174c4b95d34ff1b4411eb5a246312c | 0e8db7aad9b0e346 |
| 2026-10-14T13:08:34Z | c04-tr | duyu-1 | - | - | - | 9.12 | - | 0e8db7aad9b0e346 |
| 2026-10-14T13:08:37Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 147 | 10.59 | c1e5518510ee41f5ae77077d84415daa | d8b7d66ae905bfdf |
| 2026-10-14T13:08:38Z | c06-tr | duyu-1 | - | - | - | 10.59 | - | d8b7d66ae905bfdf |
| 2026-10-14T13:08:40Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 71 | 4.32 | caffbeb793a343b0aaa73bbd3c9f8af1 | 2d81949401123ad3 |
| 2026-10-14T13:08:42Z | c08-tr | duyu-1 | - | - | - | 4.32 | - | 2d81949401123ad3 |
| 2026-10-14T13:08:44Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 91 | 6.24 | 9224d9fe95514522b4306db730e1b1a2 | f7d5de45f2334ccf |
| 2026-10-14T13:08:44Z | c09-tr | duyu-1 | - | - | - | 6.24 | - | f7d5de45f2334ccf |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T14:56:02Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 32 | d8e8e79a856e0e86 | audio/en/c01-ex1.mp3 |
| 2026-10-14T14:56:03Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 12 | 5c669a424c49d9ab | audio/en/c02-ex1.mp3 |
| 2026-10-14T14:56:04Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | d1b3a3eb30086c2e | audio/en/c03-ex1.mp3 |
| 2026-10-14T14:56:05Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | dd043b306bf45968 | audio/en/c03-ex2.mp3 |
| 2026-10-14T14:56:07Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 30 | a285ab82e5153264 | audio/en/c04-ex1.mp3 |
| 2026-10-14T14:56:08Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | e6669daa7f52308f | audio/en/c05-ex1.mp3 |
| 2026-10-14T14:56:09Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 28 | e3711a3aff188137 | audio/en/c05-ex2.mp3 |
| 2026-10-14T14:56:11Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | 2ef6ab7f3df86897 | audio/en/c05-ex3.mp3 |
