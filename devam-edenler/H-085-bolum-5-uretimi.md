# H-085: S1·B5 "Too Late?" üretimi (İngilizce ses hariç)

- **Durum:** Devam ediyor (2026-10-14). Görseller, kurgu, çeviri ve Türkçe sesler bitti; İngilizce replikler (ElevenLabs kotası) ve Jordan'ın sesi için kullanıcı kararı bekleniyor.
- **Tür:** İçerik üretimi (bölüm)
- **Faz:** F1 içerik (Sezon 1)
- **Bağımlılık:** H-032 (onaylı diyalog), H-083 (Türkçe sesler), ElevenLabs kotası
- **Dal:** `h-085-bolum-5`

## Kapsam
- `icerik/A1-005-too-late/`: `kurgu.json` (24 düğüm: başlık, özet, 10 segment, 2 karar, 1 tepki, 7 kart, 2 görev), `audio_manifest.json` (32 İngilizce replik), `ceviri.tr.json` (53 satır + 1 ifade, DRAFT), `story.tr.md` (taslak), `PROMPTS.md`.
- Görseller: 14 sahne görseli + 2 referans (R5 Jordan, R6 ses kaydedici) = 16 iş, **8 kr**. Kilit an (Seedance) yok: sezon planında B5'te ★ yok.
- Türkçe sesler (Alania, ücretsiz kampanya): 615 karakter; 5 ses tam, 5 karışık ses İngilizce parça bekliyor.
- Araçlar: `tts_episode_en.py` (yeni; bölüm İngilizce replikleri, kuru çalışma varsayılan), `tts_episode_tr.py --tr-only`, ses yokken kuru derlemede tahmini süre (`missing-audio` uyarısı). Rehber: `docs/BOLUM-URETIM-REHBERI.md`.

## Kalan
1. **Kullanıcı kararı:** Jordan'ın ElevenLabs sesi (öneri: Charlie; `sesler.json` → `episodeEnglish.voices.JORDAN`) ve kullanılacak ElevenLabs hesabı/defteri.
2. İngilizce replikler: 32 satır, **804 karakter** (Alex/Jessica 230, Jordan 574):
   `tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_episode_en.py icerik/A1-005-too-late --execute --cap <N> --ledger <defter> --key-file <anahtar>`
3. Hi satırlarındaki İngilizce ifadeler (Sarah): 160 karakter:
   `tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_episode_tr.py icerik/A1-005-too-late --tr-cap 2000000 --en-cap <N> --execute`
4. Ana kopyada (sezon başlık arka planı ve B4-08 görseli orada): `export_package.py icerik/A1-005-too-late`, sonra `content_lint.py icerik/A1-005-too-late`, `export_package.py --season 1`.
5. Editör onayı: görseller, `ceviri.tr.json`, `story.tr.md`, ipucu 1–2. düzeyleri (H-028).

## Kabul kriterleri
- `content_lint.py icerik/A1-005-too-late` 0 hata (şimdi: 0 hata; uyarılar ses ve çeviri onayı).
- Paket: senkron ≤ 0,2 sn, -16 LUFS; bütün düğümlerin videosu ya da sesi var.
- Görsellerde yazı yok; Ellen'in yüzü ve saçı görünmüyor.

## Test
`tools/content-pipeline/.venv/bin/python tools/content-pipeline/content_lint.py icerik/A1-005-too-late` · `… -m pytest tools/content-pipeline`

## Geri alma
Bölüm klasörü ve araç değişiklikleri tek commit'te; medya git dışı.
