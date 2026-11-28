# G-A1-16-have-has PROMPTS

Ders: have / has: sahiplik ve tarif · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:09:38Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 163 | 11.23 | 589febc9c64344349c19310477e89230 | 3295b637e664cf11 |
| 2026-10-14T13:09:40Z | c01-tr | duyu-1 | - | - | - | 11.23 | - | 3295b637e664cf11 |
| 2026-10-14T13:09:42Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 162 | 12.03 | 043efa5cff034572994b4273b19353cf | 2da652ef09307740 |
| 2026-10-14T13:09:43Z | c02-tr | duyu-1 | - | - | - | 12.03 | - | 2da652ef09307740 |
| 2026-10-14T13:09:47Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 116 | 10.56 | 78129f0d27f54ab3b3631e482f195fbf | 70f782d61c16fd40 |
| 2026-10-14T13:09:48Z | c03-tr | duyu-1 | - | - | - | 10.56 | - | 70f782d61c16fd40 |
| 2026-10-14T13:09:51Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 150 | 11.55 | 63f95116717140e6bad3ba9935c0de11 | 50655fb1088ffa17 |
| 2026-10-14T13:09:52Z | c04-tr | duyu-1 | - | - | - | 11.55 | - | 50655fb1088ffa17 |
| 2026-10-14T13:09:54Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 165 | 11.55 | 414d92824fa44bd282fbd6ea3653a282 | 8b7ef00d9c012576 |
| 2026-10-14T13:09:56Z | c06-tr | duyu-1 | - | - | - | 11.55 | - | 8b7ef00d9c012576 |
| 2026-10-14T13:09:58Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 70 | 5.12 | d626de3a246b44538f0121e14eee0dd3 | e70cd0b58e9bd4e8 |
| 2026-10-14T13:09:59Z | c08-tr | duyu-1 | - | - | - | 5.12 | - | e70cd0b58e9bd4e8 |
| 2026-10-14T13:10:01Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 107 | 7.04 | 8bb780172872448596b086666bfb0109 | b6d5bc65eccecee0 |
| 2026-10-14T13:10:02Z | c09-tr | duyu-1 | - | - | - | 7.04 | - | b6d5bc65eccecee0 |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-10-14T16:33:25Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | e7ecf517c7ca5db5 | audio/en/c01-ex1.mp3 |
| 2026-10-14T16:33:26Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | dcec1b9b3638698a | audio/en/c02-ex1.mp3 |
| 2026-10-14T16:33:27Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 2cb823ba7c18bb6f | audio/en/c03-ex1.mp3 |
| 2026-10-14T16:33:29Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 14 | f9ef57857cc636c0 | audio/en/c03-ex2.mp3 |
| 2026-10-14T16:33:30Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | cf8e4ff30ca5946d | audio/en/c04-ex1.mp3 |
| 2026-10-14T16:33:31Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | 3b7225230c0ec6a6 | audio/en/c04-ex2.mp3 |
| 2026-10-14T16:33:32Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | e31375d7603809d2 | audio/en/c05-ex1.mp3 |
| 2026-10-14T16:33:33Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 34 | a3b6d582575deea7 | audio/en/c05-ex2.mp3 |
| 2026-10-14T16:33:34Z | c05-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 3fa3098436f2410f | audio/en/c05-ex3.mp3 |
| 2026-10-14T16:33:36Z | c05-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | 9331b82ac44aaa19 | audio/en/c05-ex4.mp3 |
| 2026-10-14T16:33:37Z | c05-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | 232e271e75998175 | audio/en/c05-ex5.mp3 |
| 2026-10-14T16:33:38Z | c06-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 14 | d360896124b044e2 | audio/en/c06-ex1.mp3 |
| 2026-10-14T16:33:39Z | c06-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | c1c76518882a158c | audio/en/c06-ex2.mp3 |
| 2026-10-14T16:33:40Z | c06-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | 50a6e46e74820bd7 | audio/en/c06-ex3.mp3 |
| 2026-11-27T18:20:21Z | c07-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 47 | 3.2 | f4a182d3c5f0431b96a65de122e88836 | 21404c943c22e611 |
| 2026-11-27T18:20:22Z | c07-q1-fb | duyu-1 | - | - | - | 3.2 | - | 21404c943c22e611 |
| 2026-11-27T18:20:24Z | c07-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | 8e56ab76c18647c7a67295ec59240a42 | 400b6752098a34b6 |
| 2026-11-27T18:20:25Z | c07-q2-fb | duyu-1 | - | - | - | 1.44 | - | 400b6752098a34b6 |
| 2026-11-27T18:20:27Z | c07-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.4 | cfd99ab5e80c4848aeb3eb911d0e0fa2 | d561ad7960260687 |
| 2026-11-27T18:20:28Z | c07-q3-fb | duyu-1 | - | - | - | 2.4 | - | d561ad7960260687 |
| 2026-11-27T18:20:30Z | c07-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 3.68 | 466368b9c9f44fb7ae958534d20d9fa3 | 8ed904f56d138cea |
| 2026-11-27T18:20:31Z | c07-q4-fb | duyu-1 | - | - | - | 3.68 | - | 8ed904f56d138cea |
| 2026-11-27T19:06:27Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.76 | 8feb06894ab143eb8e377b12bfa7485f | fbfa5e199734395e |
| 2026-11-27T19:06:28Z | c01-ex1-tl | duyu-1 | - | - | - | 1.76 | - | fbfa5e199734395e |
| 2026-11-27T19:06:29Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | 21961666b92842feb497a050b174642e | eeccb6fa581735eb |
| 2026-11-27T19:06:30Z | c02-ex1-tl | duyu-1 | - | - | - | 1.28 | - | eeccb6fa581735eb |
| 2026-11-27T19:06:32Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | bd0d6bf4b7f747188defbaf0acaf770e | c386fbd6c34157d8 |
| 2026-11-27T19:06:33Z | c03-ex1-tl | duyu-1 | - | - | - | 1.44 | - | c386fbd6c34157d8 |
| 2026-11-27T19:06:35Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 3.04 | c3d62ee0e68447e7b8d1d84738e14b3a | a89602b455df4ea5 |
| 2026-11-27T19:06:37Z | c03-ex2-tl | duyu-1 | - | - | - | 3.04 | - | a89602b455df4ea5 |
| 2026-11-27T19:06:39Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.72 | a074c953cdfb4d9a8c49babc4d38c9af | 8c1cf97dee212a3a |
| 2026-11-27T19:06:40Z | c04-ex1-tl | duyu-1 | - | - | - | 2.72 | - | 8c1cf97dee212a3a |
| 2026-11-27T19:06:42Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.08 | 82731bde332a45bdb2f0d045ff1f288a | b082537c8ce6260a |
| 2026-11-27T19:06:43Z | c04-ex2-tl | duyu-1 | - | - | - | 2.08 | - | b082537c8ce6260a |
| 2026-11-27T19:06:45Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 2605b41ddd854bb09296d4690b9767e8 | 5766f9de7115cacc |
| 2026-11-27T19:06:46Z | c05-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 5766f9de7115cacc |
| 2026-11-27T19:06:48Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.24 | 761139177786492bb035e95b974b8366 | b8e1e7b8e5506bbb |
| 2026-11-27T19:06:49Z | c05-ex2-tl | duyu-1 | - | - | - | 2.24 | - | b8e1e7b8e5506bbb |
| 2026-11-27T19:06:51Z | c05-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.6 | a526e98cd8884655a7c94811c7c61715 | 743d6d8d09bd176f |
| 2026-11-27T19:06:52Z | c05-ex3-tl | duyu-1 | - | - | - | 1.6 | - | 743d6d8d09bd176f |
| 2026-11-27T19:06:54Z | c05-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 2.4 | 1589096a593b4bcbb7bdcc2eff79f326 | c416ebc4e6cee02e |
| 2026-11-27T19:06:55Z | c05-ex4-tl | duyu-1 | - | - | - | 2.4 | - | c416ebc4e6cee02e |
| 2026-11-27T19:06:57Z | c05-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.44 | 446ca56111db4f6ba295070c075d0614 | c2e613efe0bf8482 |
| 2026-11-27T19:06:58Z | c05-ex5-tl | duyu-1 | - | - | - | 1.44 | - | c2e613efe0bf8482 |
| 2026-11-27T19:07:00Z | c06-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.76 | e21219ceba7e49a6933bb1b1363d5aaa | 886ad21806337222 |
| 2026-11-27T19:07:01Z | c06-ex1-tl | duyu-1 | - | - | - | 1.76 | - | 886ad21806337222 |
| 2026-11-27T19:07:03Z | c06-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 3.68 | 5ba6bec50a6e4977b52294f38a1673a9 | 2ca0598eebb26ab6 |
| 2026-11-27T19:07:05Z | c06-ex2-tl | duyu-1 | - | - | - | 3.68 | - | 2ca0598eebb26ab6 |
| 2026-11-27T19:07:07Z | c06-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 2.88 | ba33130fadec40b4b1f3c0807708c354 | d108720c140a43d6 |
| 2026-11-27T19:07:08Z | c06-ex3-tl | duyu-1 | - | - | - | 2.88 | - | d108720c140a43d6 |
