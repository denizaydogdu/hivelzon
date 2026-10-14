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
