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
