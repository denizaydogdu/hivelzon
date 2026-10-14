# G-A1-01-to-be PROMPTS

Ders: am / is / are: "olmak" fiili · Pilot (H-079) · `docs/DILBILGISI.md` §4, §9

## Metin
- **Yazan:** Claude (Opus 5.5), Claude Code oturumu, 2026-10-14. Ayrı bir LLM istemi ya da API çağrısı yok; metin doğrudan bu depoda yazıldı.
- **Girdi:** `dilbilgisi/MUFREDAT.md` (H-076, onaylı) konu kaydı: hedef, Türkçeyle karşılaştırma, tipik hata, hikâye bağı. Hi'nin sesi: `icerik/_evren/CHARACTER_PROFILES.md`; ton: `docs/ARAYUZ-METINLERI.md`.
- **Kurallar:** Türkçe anlatım kart başına en çok 3 kısa cümle, Hi'nin sesiyle, suçlamasız. İngilizce kelime Türkçe anlatıma yazılmaz; ayrı örnek parçasına (`+`) taşınır. Örnekler A1 kapsamasında (`grammar_lint.py`).
- **Görsel ve Higgsfield:** kullanılmadı (şemalar kodla çizilir; kredi harcanmadı).
- **Söyleniş:** `Alex` → "Aleks" (ad; İngilizce kelime değil). Biçimlerin kendisi (am / is / are) Türkçe anlatımda geçmez; ayrı İngilizce örnek parçalarında duyulur.

## Ses çağrıları
Türkçe anlatım: PatientDesk Alania (`alania-v2`, `alania2-f1`) + Duyu (`duyu-1`) kelime zamanı. Lansman kampanyası: 14 Kasım 2026'ya kadar ücretsiz ve sınırsız (kullanıcı bildirimi 2026-10-14). İngilizce örnekler (Sarah, ElevenLabs): henüz üretilmedi (ücretsiz kota bitti; kullanıcı yeni anahtar verecek), yalnız kuru çalışma.

Aşağıdaki satırları `tts_lesson.py` yazar.

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T11:44:56Z | c01-tr | alania-v2 | alania2-f1 | alania-v2.1 | 142 | 8.83 | 0b8eac0c4d854c8aadf86e6dc03ae0a2 | f9967aed37fde7f9 |
| 2026-10-14T11:44:58Z | c01-tr | duyu-1 | - | - | - | 8.83 | - | f9967aed37fde7f9 |
| 2026-10-14T11:45:01Z | c02-tr | alania-v2 | alania2-f1 | alania-v2.1 | 129 | 9.92 | be4b3322d2ec4a1286ab72c2f6a99239 | 370ee5ce8c7cb191 |
| 2026-10-14T11:45:02Z | c02-tr | duyu-1 | - | - | - | 9.92 | - | 370ee5ce8c7cb191 |
| 2026-10-14T11:45:05Z | c03-tr | alania-v2 | alania2-f1 | alania-v2.1 | 144 | 10.75 | d6be09c97ba744d9aa0afba0470257d7 | 695f60c5354f4f0f |
| 2026-10-14T11:45:06Z | c03-tr | duyu-1 | - | - | - | 10.75 | - | 695f60c5354f4f0f |
| 2026-10-14T11:45:09Z | c04-tr | alania-v2 | alania2-f1 | alania-v2.1 | 119 | 8.64 | 834467e628cf4bad9103aa7275ba5b63 | 7b14320b75d52e7b |
| 2026-10-14T11:45:10Z | c04-tr | duyu-1 | - | - | - | 8.64 | - | 7b14320b75d52e7b |
| 2026-10-14T11:45:13Z | c06-tr | alania-v2 | alania2-f1 | alania-v2.1 | 153 | 10.68 | ba64d24d0652443fb3d808ede04f5a2f | 3102b5a2b78d2976 |
| 2026-10-14T11:45:14Z | c06-tr | duyu-1 | - | - | - | 10.68 | - | 3102b5a2b78d2976 |
| 2026-10-14T11:45:17Z | c08-tr | alania-v2 | alania2-f1 | alania-v2.1 | 59 | 4.0 | 06bdaa1de2ce4d189a9b7d27ad3e332e | e89a5c6a53f5df2f |
| 2026-10-14T11:45:17Z | c08-tr | duyu-1 | - | - | - | 4.0 | - | e89a5c6a53f5df2f |
| 2026-10-14T11:45:19Z | c09-tr | alania-v2 | alania2-f1 | alania-v2.1 | 131 | 9.6 | be6a2d69caf442088d339020c5abc2c0 | 18ae55abd2843daa |
| 2026-10-14T11:45:21Z | c09-tr | duyu-1 | - | - | - | 9.6 | - | 18ae55abd2843daa |
