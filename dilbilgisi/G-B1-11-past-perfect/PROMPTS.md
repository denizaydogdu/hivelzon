# G-B1-11-past-perfect PROMPTS

Ders: Past perfect: "olmuştu" · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** yok.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:09:39Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 173 | 13.94 | 323310a06e5d476eb8d1a850b506ce0c | 89fa6b4538a0ae9c |
| 2026-10-14T14:09:41Z | c01-tr | duyu-1 | - | - | - | 13.94 | - | 89fa6b4538a0ae9c |
| 2026-10-14T14:09:44Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 186 | 13.95 | ca053ffa2c934f8ca96e3d13fc6b87d2 | 5da509746620c7aa |
| 2026-10-14T14:09:46Z | c02-tr | duyu-1 | - | - | - | 13.95 | - | 5da509746620c7aa |
| 2026-10-14T14:09:49Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 186 | 12.19 | 61455c937468489bb2e5d056aaf17d97 | 16f601253c0e7daf |
| 2026-10-14T14:09:50Z | c03-tr | duyu-1 | - | - | - | 12.19 | - | 16f601253c0e7daf |
| 2026-10-14T14:09:54Z | c05-tr | alania-v2 | alania2-f1 | alania-v2.1 | 190 | 11.87 | e946ff0ee6b04ab096d785f6e3803935 | 63df1c673448c343 |
| 2026-10-14T14:09:56Z | c05-tr | duyu-1 | - | - | - | 11.87 | - | 63df1c673448c343 |
| 2026-10-14T14:09:59Z | c07-tr | alania-v2 | alania2-f1 | alania-v2.1 | 148 | 9.63 | 61447598515247ccb70e9aba816ed906 | 212ef6a09031cd6a |
| 2026-10-14T14:10:00Z | c07-tr | duyu-1 | - | - | - | 9.63 | - | 212ef6a09031cd6a |

## İngilizce örnek seslendirme kayıtları (tts_lesson.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|
| 2026-11-26T14:01:00Z | c01-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 37 | 3c4cff48a5182cd4 | audio/en/c01-ex1.mp3 |
| 2026-11-26T14:01:02Z | c02-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 47 | d961b226c85e93da | audio/en/c02-ex1.mp3 |
| 2026-11-26T14:01:04Z | c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 36 | d374318bb241cd46 | audio/en/c03-ex1.mp3 |
| 2026-11-26T14:01:06Z | c03-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 43 | 260b61dd49f1e783 | audio/en/c03-ex2.mp3 |
| 2026-11-26T14:01:08Z | c04-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 43 | fdd50cbc9f5b9294 | audio/en/c04-ex1.mp3 |
| 2026-11-26T14:01:10Z | c04-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 45 | 23fc02ee5111ee0e | audio/en/c04-ex2.mp3 |
| 2026-11-26T14:01:12Z | c04-ex3 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 44 | deea3f17e4ffcd06 | audio/en/c04-ex3.mp3 |
| 2026-11-26T14:01:14Z | c04-ex4 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 42 | de78294fc08c55fe | audio/en/c04-ex4.mp3 |
| 2026-11-26T14:01:16Z | c04-ex5 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 33 | d8662be4cce2b2fd | audio/en/c04-ex5.mp3 |
| 2026-11-26T14:01:18Z | c05-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 35 | baf7989b1034ef05 | audio/en/c05-ex1.mp3 |
| 2026-11-26T14:01:19Z | c05-ex2 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 1.0 | 16 | 87edb17ac6f41ec2 | audio/en/c05-ex2.mp3 |
| 2026-11-27T18:26:24Z | c06-q1-fb | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.08 | 979d96e512be41a98c18ffc773dd6ff8 | b7f7ea98c11b8b61 |
| 2026-11-27T18:26:25Z | c06-q1-fb | duyu-1 | - | - | - | 2.08 | - | b7f7ea98c11b8b61 |
| 2026-11-27T18:26:27Z | c06-q2-fb | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 2.88 | 7075cec757dd4e478a98e1b80bf3742f | 6ba94966b08dd54e |
| 2026-11-27T18:26:28Z | c06-q2-fb | duyu-1 | - | - | - | 2.88 | - | 6ba94966b08dd54e |
| 2026-11-27T18:26:30Z | c06-q3-fb | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 3.2 | bead7a84118c459fb527e32221fdd077 | 4ba45cf14bdc9d67 |
| 2026-11-27T18:26:31Z | c06-q3-fb | duyu-1 | - | - | - | 3.2 | - | 4ba45cf14bdc9d67 |
| 2026-11-27T18:26:34Z | c06-q4-fb | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 4.96 | b7107e7658924221b0ed55dfede93d7c | 5076892ba2a41c0a |
| 2026-11-27T18:26:35Z | c06-q4-fb | duyu-1 | - | - | - | 4.96 | - | 5076892ba2a41c0a |
| 2026-11-27T19:24:50Z | c01-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 2.56 | 4ba3984d964840a3a992f24a3bcac73b | 4d6e1118cee55dba |
| 2026-11-27T19:24:51Z | c01-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 4d6e1118cee55dba |
| 2026-11-27T19:24:54Z | c02-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 3.04 | 66a3126c1a4a4840a5d9e9c4ce1c3567 | 95bcc3f89df394a4 |
| 2026-11-27T19:24:55Z | c02-ex1-tl | duyu-1 | - | - | - | 3.04 | - | 95bcc3f89df394a4 |
| 2026-11-27T19:24:57Z | c03-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.4 | 73f56578bd2c43cbbf5b5d3b8e5960dc | ee09ec3e015ed858 |
| 2026-11-27T19:24:59Z | c03-ex1-tl | duyu-1 | - | - | - | 2.4 | - | ee09ec3e015ed858 |
| 2026-11-27T19:25:01Z | c03-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 45 | 2.88 | d7882319d69e47fa89888ce6c34b6851 | ec290ee92eca7362 |
| 2026-11-27T19:25:02Z | c03-ex2-tl | duyu-1 | - | - | - | 2.88 | - | ec290ee92eca7362 |
| 2026-11-27T19:25:04Z | c04-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.56 | eb5033025d5349cebd273a7961f73381 | 46cafa446af1e9d8 |
| 2026-11-27T19:25:05Z | c04-ex1-tl | duyu-1 | - | - | - | 2.56 | - | 46cafa446af1e9d8 |
| 2026-11-27T19:25:07Z | c04-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 38 | 2.56 | fc5c28d9dcd14882b1bf2df603fef5fd | d4ab8bbf223e9459 |
| 2026-11-27T19:25:08Z | c04-ex2-tl | duyu-1 | - | - | - | 2.56 | - | d4ab8bbf223e9459 |
| 2026-11-27T19:25:10Z | c04-ex3-tl | alania-v2 | alania2-f1 | alania-v2.1 | 41 | 3.36 | b02f3a8d4f0148dbaa4c3d3370528312 | c2d9d82d6dbca195 |
| 2026-11-27T19:25:11Z | c04-ex3-tl | duyu-1 | - | - | - | 3.36 | - | c2d9d82d6dbca195 |
| 2026-11-27T19:25:13Z | c04-ex4-tl | alania-v2 | alania2-f1 | alania-v2.1 | 35 | 2.56 | b5270fbb270748e089f277bfdaf8372f | 1cbe35bab19fb0e0 |
| 2026-11-27T19:25:14Z | c04-ex4-tl | duyu-1 | - | - | - | 2.56 | - | 1cbe35bab19fb0e0 |
| 2026-11-27T19:25:16Z | c04-ex5-tl | alania-v2 | alania2-f1 | alania-v2.1 | 37 | 2.56 | 9d7269dd61274ecebb7be7906ec78a13 | d42d57e849aff624 |
| 2026-11-27T19:25:17Z | c04-ex5-tl | duyu-1 | - | - | - | 2.56 | - | d42d57e849aff624 |
| 2026-11-27T19:25:20Z | c05-ex1-tl | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 4.0 | a8536ebf34cb446bac6602bf821d7930 | b81cff46b6eac9bc |
| 2026-11-27T19:25:21Z | c05-ex1-tl | duyu-1 | - | - | - | 4.0 | - | b81cff46b6eac9bc |
| 2026-11-27T19:25:23Z | c05-ex2-tl | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.28 | f4be907a695749b1928145086577c789 | 5cd2bbb8eaa016d3 |
| 2026-11-27T19:25:24Z | c05-ex2-tl | duyu-1 | - | - | - | 1.28 | - | 5cd2bbb8eaa016d3 |
