# H-085: Sezon 1 Bölüm 5–12 üretimi

- **Durum:** Devam ediyor (2026-10-28). Üretim bitti; B5–B12 otomatik simülatör turu 8/8 geçti. Kalan kullanıcının öznel denemesi ile çeviri/görsel/ipucu için öğretmen-editör incelemesi. Simülatör her çalıştırmadan önce açık kullanıcı izni ister.
- **Tür:** İçerik üretimi
- **Faz:** F1 içerik (Sezon 1)
- **Bağımlılık:** H-032 (diyaloglar onaylı), H-083 (Türkçe sesler Alania)

## Kapsam
- A1-005…A1-012, H-024 standart yoluyla:
  - GPT Image 2.5 görseller, karakter referanslı;
  - yerel Ken Burns;
  - kilit anda Seedance 2.0 Mini;
  - İngilizce sesler ElevenLabs, Türkçe sesler Alania;
  - paket.
- Önce B5, örnek olarak; süreç `docs/BOLUM-URETIM-REHBERI.md`'ye yazılır. Ardından B6–B12.

## Kabul kriterleri
- Her bölüm content-lint 0 hata, paket ve senkron ölçümü (≤ 0,2 sn), -16 LUFS.
- Kullanıcı simülatörde dener.

## Teknik doğrulama (2026-10-27)

Simülatör doğrulaması otomatik turla yapıldı: uygulama `AUTOPLAY_TEST=h085`
ile B5–B12'yi sırayla açtı, her kararda yanlış ve doğru yolu denedi, bölüm
sonlarını Hikâye ekranına yazdı.

| Bölüm | completed | kapı | otomatik geçiş (medyan) | karar (medyan) | arayüz (medyan) | altyazı sapması | hata |
|---|---|---|---|---|---|---|---|
| A1-005 | ✅ | ✅ | 40,5 ms | 116,7 ms | 138,8 ms | 131 ms | 0 |
| A1-006 | ✅ | ✅ | 40,5 ms | 137,0 ms | 147,2 ms | 30 ms | 0 |
| A1-007 | ✅ | ✅ | 45,7 ms | 131,8 ms | 155,0 ms | 8 ms | 0 |
| A1-008 | ✅ | ✅ | 42,5 ms | 136,1 ms | 153,9 ms | 3 ms | 0 |
| A1-009 | ✅ | ✅ | 48,1 ms | 137,1 ms | 113,1 ms | 6 ms | 0 |
| A1-010 | ✅ | ✅ | 35,4 ms | 116,4 ms | 122,9 ms | 33 ms | 0 |
| A1-011 | ✅ | ✅ | 42,1 ms | 117,8 ms | 127,8 ms | 5 ms | 0 |
| A1-012 | ✅ | ✅ | 41,5 ms | 113,2 ms | 126,7 ms | 107 ms | 0 |

- Sekiz bölümde de `errors=0`, kapı açıldı, ön yükleme kaçağı yok
  (`notPreloaded=0`).
- En büyük ölçülen altyazı saat sapması **131 ms** (B5). Bu ölçüm,
  insanın ses/altyazı uyumunu dinleyerek kontrol etmesinin yerine geçmez.
- Bölüm başındaki video başlatma 215–1116 ms arasında; otomatik geçiş
  medyanları önden başlatmayla 35–48 ms.
- Content-lint B5–B12 için 0 hata; yalnız bilinen uyarılar (çeviri DRAFT,
  bir liste dışı sözcük).
- Bulunan tek içerik notu B11 `tr_c-clues` Türkçe zaman eşleşmesi (%80);
  editör kulakla kontrolü H-028'e bağlı.

**Kapanmayan kısım:** Otomatik tur kullanıcının kendi gözlemini veya insan
editör onayını yerine getirmez. Kullanıcının simülatör denemesi burada,
görsellerin/çevirilerin/ipuçlarının editör kontrolü **H-028**'de bekliyor.

## Engel
- ~~İngilizce seslendirme kotası~~ çözüldü: arkadaş hesapları (hesap3, hesap4).

## Notlar
2026-10-14: Kullanıcı 500 Higgsfield kredisi yükledi, yarım kalan işler için onay verdi. B5 bütçesi 20 kr.
# H-085: S1·B5 "Too Late?" üretimi (İngilizce ses hariç)

- **Durum:** Bitti (2026-10-14). B5 tamamlandı: İngilizce replikler hesap3 + hesap1 ile seslendirildi, Jordan = Chris; senkron 0,01 sn, lint 0 hata. (Kalan simülatör denemesi ve editör onayı yukarıdaki ana durumda.)
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
2026-10-14: B5 tamamlandı. Jordan'ın sesi Chris (ElevenLabs hazır ses; samimi, Amerikan aksanı; Charlie Avustralya aksanlı olduğu için seçilmedi) — kullanıcı değiştirebilir. İngilizce: diyalog 804 karakter (hesap3), Hi ifadeleri 160 karakter (hesap1/videoGenerator). Editör onayı (H-028) bekliyor: görseller, ceviri.tr.json, story.tr.md, ipucu metinleri.
2026-10-14: B6–B8 tamamlandı (hesap4; Sam = Liam). Senkron 0,02 / 0,1 / 0,053 sn; -15,97 / -16,1 / -16,08 LUFS.
2026-10-14: B9–B12 tamamlandı. Yeni İngilizce sesler (`sesler.json`): Rosa = Matilda, Mr Grant = Bill, Tom = Will, Sunucu = Daniel, Satıcı = Laura (kullanıcı değiştirebilir). İngilizce 4.175 karakter replik + Sarah ifadeleri, hepsi hesap4 (defter 7.524/10.000). Senkron: segment başına en büyük fark 0,0007 sn; bölüm bütünü -16,0 LUFS (B9–B12). Uyarı: B11 `tr_c-clues` Türkçe zaman eşleşmesi %80 ("Onuncu → 10.") — editör kulakla kontrol etsin. Higgsfield kalan kredi 385,06.
