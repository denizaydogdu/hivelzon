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
