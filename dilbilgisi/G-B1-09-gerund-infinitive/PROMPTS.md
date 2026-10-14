# G-B1-09-gerund-infinitive PROMPTS

Ders: -ing mi, to mu? Fiil kalıpları (2) · Dalga 2 B1 (H-081) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Biçim ve ton: pilot ve Dalga 1 dersleri (`G-A1-13-third-person-s`, `G-A2-04-past-simple-regular`, `G-A2-10-going-to`), `icerik/_evren/CHARACTER_PROFILES.md` (Hi), `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler B1 kapsamasında (CEFR-J v1.6, `grammar_lint.py`; B1'de cümle uzunluğu sınırı yok, örnekler yine kısa tutuldu).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `-ing` → "ing".

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). Bu dalganın Türkçe çağrıları ayrı defterde: `kitaplar/_maliyet/patientdesk-h081a.json`. İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi, yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T14:08:46Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 151 | 8.99 | e108393839a849e5823e2a7bb2dbc291 | 4bd26d44fd5e1326 |
| 2026-10-14T14:08:47Z | c01-tr | duyu-1 | - | - | - | 8.99 | - | 4bd26d44fd5e1326 |
| 2026-10-14T14:08:49Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 185 | 12.16 | 2befb8a648814de18e34fc528ef0eeac | 36b610680fd2cdfa |
| 2026-10-14T14:08:51Z | c02-tr | duyu-1 | - | - | - | 12.16 | - | 36b610680fd2cdfa |
| 2026-10-14T14:08:54Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 216 | 15.58 | 20f85058c08645a8ba7ae5e6d94e4fb0 | 2baee57ab1db5421 |
| 2026-10-14T14:08:55Z | c03-tr | duyu-1 | - | - | - | 15.58 | - | 2baee57ab1db5421 |
| 2026-10-14T14:08:58Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 121 | 8.32 | 5fd96a3dc5484d89ad000d73e00b1102 | 4ed58465382ec5e5 |
| 2026-10-14T14:09:00Z | c04-tr | duyu-1 | - | - | - | 8.32 | - | 4ed58465382ec5e5 |
| 2026-10-14T14:09:02Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 221 | 14.91 | ce2328e792424f6d82ad78d6cbb66412 | 807fc8877b192038 |
| 2026-10-14T14:09:04Z | c06-tr | duyu-1 | - | - | - | 14.91 | - | 807fc8877b192038 |
| 2026-10-14T14:09:06Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 77 | 4.64 | 8bc700f5695b492bb64b2f48a7a9d06b | 3aaab09c7e21e706 |
| 2026-10-14T14:09:08Z | c08-tr | duyu-1 | - | - | - | 4.64 | - | 3aaab09c7e21e706 |
| 2026-10-14T14:09:10Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 152 | 11.02 | 9e062632a2924fdfa5d30d059679e402 | fa0b8e04c8571b6b |
| 2026-10-14T14:09:11Z | c09-tr | duyu-1 | - | - | - | 11.02 | - | fa0b8e04c8571b6b |
