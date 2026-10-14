# G-A1-08-imperatives PROMPTS

Ders: Emir kipi: Go / Turn / Don't… · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:06:40Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 113 | 7.2 | f7ec1cea998f4e43a1724efb7800ca5a | 31f37608a9830d50 |
| 2026-10-14T13:06:41Z | c01-tr | duyu-1 | - | - | - | 7.2 | - | 31f37608a9830d50 |
| 2026-10-14T13:06:43Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 149 | 10.11 | fa792881fd3546e39bc539f7149a99d0 | 09fd9cd69d7c0d6b |
| 2026-10-14T13:06:44Z | c02-tr | duyu-1 | - | - | - | 10.11 | - | 09fd9cd69d7c0d6b |
| 2026-10-14T13:06:47Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 139 | 11.04 | 7789bbfdf60848ba9decef88a894cf76 | e06bcaeb6b94daba |
| 2026-10-14T13:06:49Z | c03-tr | duyu-1 | - | - | - | 11.04 | - | e06bcaeb6b94daba |
| 2026-10-14T13:06:51Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 153 | 10.43 | 5045aff2304c4631ba9a5a3d8880e63e | f30dcccba6a06bf1 |
| 2026-10-14T13:06:52Z | c04-tr | duyu-1 | - | - | - | 10.43 | - | f30dcccba6a06bf1 |
| 2026-10-14T13:06:55Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 174 | 12.19 | 723ad200fd594700aa35c982e42e4e58 | c7307c51e45d9ed4 |
| 2026-10-14T13:06:56Z | c06-tr | duyu-1 | - | - | - | 12.19 | - | c7307c51e45d9ed4 |
| 2026-10-14T13:06:58Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 59 | 4.48 | 770e90cdbf74443690ecdb4a4405bd3c | a407fb161b89f381 |
| 2026-10-14T13:06:59Z | c08-tr | duyu-1 | - | - | - | 4.48 | - | a407fb161b89f381 |
| 2026-10-14T13:07:01Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 97 | 6.56 | 95c24a0d82cf49029d0734a220d8c472 | 4d4a8b436b724b2d |
| 2026-10-14T13:07:02Z | c09-tr | duyu-1 | - | - | - | 6.56 | - | 4d4a8b436b724b2d |
