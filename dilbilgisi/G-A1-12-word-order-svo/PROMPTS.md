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
| 2026-10-14T16:32:46Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 36 | 3250314edba0c098 | audio/en/c05-ex4.mp3 |
| 2026-10-14T16:32:47Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | ac3c43554289bb8a | audio/en/c05-ex5.mp3 |
| 2026-10-14T16:32:48Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | 171f3ab474badb7e | audio/en/c06-ex2.mp3 |
| 2026-10-14T16:32:50Z | c09-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | 905328f7fe6fa06e | audio/en/c09-ex1.mp3 |
| 2026-11-27T18:19:28Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 36 | 2.72 | c998ba44b784406c8f068a8034e674a0 | 8de9cd99422a94a7 |
| 2026-11-27T18:19:29Z | c07-q1-fb | duyu-1 | - | - | - | 2.72 | - | 8de9cd99422a94a7 |
| 2026-11-27T18:19:31Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 3.36 | d0a904d873ee43038b03f3e530bb72c4 | 423e558ff11fcb35 |
| 2026-11-27T18:19:32Z | c07-q2-fb | duyu-1 | - | - | - | 3.36 | - | 423e558ff11fcb35 |
| 2026-11-27T18:19:34Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | 2e1ce8c726244c10bef0e3fc57a3bc89 | 7210453617f2cf6d |
| 2026-11-27T18:19:35Z | c07-q3-fb | duyu-1 | - | - | - | 1.92 | - | 7210453617f2cf6d |
| 2026-11-27T18:19:38Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 3.2 | 0d33b86492f149c09c658282d8a58f38 | a09f0d6fbde34fcd |
| 2026-11-27T18:19:39Z | c07-q4-fb | duyu-1 | - | - | - | 3.2 | - | a09f0d6fbde34fcd |
| 2026-11-27T19:03:47Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 3.84 | 1b4799acee0741bab328e7d82f09ad9f | 606a6e33341bb75f |
| 2026-11-27T19:03:48Z | c01-ex1-tl | duyu-1 | - | - | - | 3.84 | - | 606a6e33341bb75f |
| 2026-11-27T19:03:51Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.12 | b34de7fa74ed456da3f50fde364ada2c | 2a97423b084086ac |
| 2026-11-27T19:03:52Z | c02-ex1-tl | duyu-1 | - | - | - | 1.12 | - | 2a97423b084086ac |
| 2026-11-27T19:03:53Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.44 | 02c11a8b6d7641848153204d21a009e0 | e099a7fe33799a51 |
| 2026-11-27T19:03:54Z | c03-ex1-tl | duyu-1 | - | - | - | 1.44 | - | e099a7fe33799a51 |
| 2026-11-27T19:03:57Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | 7a4ad0c5f20a4f2aaaa2057642da813b | 03c67814c83e34fe |
| 2026-11-27T19:03:57Z | c03-ex2-tl | duyu-1 | - | - | - | 1.44 | - | 03c67814c83e34fe |
| 2026-11-27T19:03:59Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.92 | a2a8401b9db2490487eacb601a9ac2b9 | 2e2df09562054c8a |
| 2026-11-27T19:04:00Z | c04-ex1-tl | duyu-1 | - | - | - | 1.92 | - | 2e2df09562054c8a |
| 2026-11-27T19:04:02Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.6 | 6caffa138b6444658ff556dcd6c0f898 | 1906975f5506ff82 |
| 2026-11-27T19:04:03Z | c05-ex1-tl | duyu-1 | - | - | - | 1.6 | - | 1906975f5506ff82 |
| 2026-11-27T19:04:05Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.92 | 8df333aca10d4db2a09c697e6258706b | 4473798e028057ba |
| 2026-11-27T19:04:06Z | c05-ex2-tl | duyu-1 | - | - | - | 1.92 | - | 4473798e028057ba |
| 2026-11-27T19:04:08Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.4 | d07dd6cb80924cce97296866542e2324 | ec76ce4be0a3680b |
| 2026-11-27T19:04:09Z | c05-ex3-tl | duyu-1 | - | - | - | 2.4 | - | ec76ce4be0a3680b |
| 2026-11-27T19:04:11Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.56 | c14270ebfc994fd8a0d1413d70e257b1 | 6c091504673fa7d0 |
| 2026-11-27T19:04:12Z | c05-ex4-tl | duyu-1 | - | - | - | 2.56 | - | 6c091504673fa7d0 |
| 2026-11-27T19:04:15Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 3.36 | 6aa958cb7cef4cfc93d3212229a7f2f9 | e9c592c5bd33e4e0 |
| 2026-11-27T19:04:16Z | c05-ex5-tl | duyu-1 | - | - | - | 3.36 | - | e9c592c5bd33e4e0 |
| 2026-11-27T19:04:18Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.92 | 4d4ea57bcdcf49668e34df81210ff946 | c13f34f93ef11450 |
| 2026-11-27T19:04:19Z | c06-ex2-tl | duyu-1 | - | - | - | 1.92 | - | c13f34f93ef11450 |
| 2026-11-27T19:04:21Z | c09-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | a34ccee3f740447ea889126a1e77e626 | 43630f06fc69511f |
| 2026-11-27T19:04:21Z | c09-ex1-tl | duyu-1 | - | - | - | 1.44 | - | 43630f06fc69511f |
