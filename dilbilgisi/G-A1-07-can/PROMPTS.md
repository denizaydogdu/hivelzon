# G-A1-07-can PROMPTS

Ders: can / can't: yetenek, rica ve kısa cevap · Dalga 1 (H-080) · `docs/DILBILGISI.md` §4, §9

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
| 2026-10-14T13:06:10Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 10.39 | 997be1de7a0a475ea51a69c0cf921331 | 145d180bc0646f34 |
| 2026-10-14T13:06:11Z | c01-tr | duyu-1 | - | - | - | 10.39 | - | 145d180bc0646f34 |
| 2026-10-14T13:06:14Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 158 | 12.67 | 060a5c1bc671494aa2569bfbfd524e9e | ffda19b8e5574e03 |
| 2026-10-14T13:06:15Z | c02-tr | duyu-1 | - | - | - | 12.67 | - | ffda19b8e5574e03 |
| 2026-10-14T13:06:18Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 125 | 8.0 | 45a07792f16b4edfa78b40a8a04edc93 | beca484e0db49123 |
| 2026-10-14T13:06:20Z | c03-tr | duyu-1 | - | - | - | 8.0 | - | beca484e0db49123 |
| 2026-10-14T13:06:22Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 159 | 11.87 | f5820b1a818b4c8288e67e5c9b98cd87 | 6348cb098d21ef1e |
| 2026-10-14T13:06:26Z | c04-tr | duyu-1 | - | - | - | 11.87 | - | 6348cb098d21ef1e |
| 2026-10-14T13:06:29Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 182 | 12.83 | 82fcc1c59fdc493e8ccdc15363e881c5 | 9783ab8c1493ea77 |
| 2026-10-14T13:06:30Z | c06-tr | duyu-1 | - | - | - | 12.83 | - | 9783ab8c1493ea77 |
| 2026-10-14T13:06:32Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 59 | 4.16 | fc86c11c95014a72996aba07eed1ac64 | e89a5c6a53f5df2f |
| 2026-10-14T13:06:34Z | c08-tr | duyu-1 | - | - | - | 4.16 | - | e89a5c6a53f5df2f |
| 2026-10-14T13:06:36Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 144 | 10.43 | 8c7ee278930e49d78a79bec1a3ac8ac8 | f0742249f2a30a9b |
| 2026-10-14T13:06:37Z | c09-tr | duyu-1 | - | - | - | 10.43 | - | f0742249f2a30a9b |
