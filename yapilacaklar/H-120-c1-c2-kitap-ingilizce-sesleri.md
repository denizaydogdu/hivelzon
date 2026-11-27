# H-120: C1 + C2 kitaplarının İngilizce anlatım sesleri (10 kitap)

- **Durum:** ⏳ Sırada (2026-11-27 açıldı) — ücretli üretim; kullanıcı ElevenLabs kredisi yenilendikten sonra **"devam"** deyince başlar. Önce C1 (Aralık dönemi), sonra C2 (Ocak dönemi).
- **Tür:** İçerik üretimi (ücretli TTS)
- **Öncelik:** Düşük–Orta (H-087 odağı A1–A2; C1/C2 yardımcı kitaplıktır, sıra ve zaman kararı kullanıcıda)
- **Bağımlılık:** H-073 (10 C1/C2 kitabı onaylı ve tam resimli; editör kontrolü için `devam-edenler/`de kalır), H-119 (kesik yanıt kaydı, 1500 karakterlik parçalar), H-114 (defter kilidi)

## Kapsam
- 10 C1/C2 kitabının İngilizce anlatımı: ElevenLabs **Creator**, model `eleven_v3`, ses Sarah (`EXAVITQu4vr4xnSDxMaL`), hız 1.05, araç `tools/content-pipeline/tts_book.py`.
- A1–B2 kitaplarıyla aynı akış (2026-11-26/27): kuru çalışma → maliyet onayı → `--execute` → `export_book.py` → lint → kayıtlar.

### Karakter sayıları (2026-11-27 kuru çalışma, API çağrılmadı)
| Kitap | Bölüm | Parça | İstenecek karakter |
|---|---|---|---|
| C1-K01 *The Ninth Plate* | 7 | 37 | 44.921 |
| C1-K02 *Eleven Bridges* | 7 | 36 | 45.359 |
| C1-K03 *The Anniversary Committee* | 6 | 36 | 48.131 |
| C1-K04 *The Lake That Remembered Tomorrow* | 7 | 37 | 45.466 |
| C1-K05 *Held in Trust* | 6 | 36 | 45.612 |
| **C1 toplam** | 33 | 182 | **229.489** |
| C2-K01 *The Missing Entries* | 8 | 45 | 58.856 |
| C2-K02 *The Town That Wasn't There* | 7 | 46 | 58.985 |
| C2-K03 *A Strongly Worded Letter* | 7 | 48 | 58.165 |
| C2-K04 *The Word Meter* | 7 | 43 | 54.816 |
| C2-K05 *The Other Half of the Sentence* | 8 | 42 | 51.876 |
| **C2 toplam** | 37 | 224 | **282.698** |
| **Genel toplam** | 70 | 406 | **512.187** |

Not: Önceki belgelerdeki 229.655 + 282.922 = 512.577 karakter önceki bir sayımdır (fark %0,08); güncel değer kuru
çalışmanın "Toplam istenecek" satırıdır. Her koşudan önce yeniden ölçülür.

### Maliyet ve takvim
- Ölçülen oran **≈ 0,44 kredi/karakter** (2026-11 defteri: 289.009 karakter, 667 çağrı; 2026-11-26 ilk ölçüm ≈ 0,45).
- **C1 ≈ 101.000 kredi**, **C2 ≈ 124.400 kredi** (toplam ≈ 225.400; 0,45 ile ≈ 230.500).
- Creator: 131.000 kredi/ay. Bu dönem kalan **2.859 kredi**; yenilenme **2026-12-26**.
- İkisi tek döneme sığmaz. Plan:
  1. **Aralık dönemi (2026-12-26 sonrası): C1** (5 kitap, ≈ 101.000 kredi; ≈ 30.000 kredi pay kalır).
  2. **Ocak dönemi (2027-01-26 sonrası): C2** (5 kitap, ≈ 124.400 kredi; pay dar, ≈ 6.600 kredi). Gerekirse C2 iki parti
     (K01–K03, sonra K04–K05) ya da kalan kitaplar bir sonraki döneme bırakılır.
- Ücret dönemi (26'sı) ile defterin takvim ayı (`kitaplar/_maliyet/elevenlabs-karakter.json`, ay anahtarı) aynı değildir:
  tavan defter ayına göre denetlenir, gerçek kalan kredi ise abonelik okumasından alınır.

## Her koşudan önce (zorunlu)
1. Kullanıcı yenilenmeden sonra açıkça **"devam"** der (genel "devam" simülatör izni sayılmaz; bu iş için ücret onayıdır).
2. **Abonelik okuması:** ElevenLabs `GET /v1/user/subscription` (ücretsiz okuma) — kullanılan/kalan kredi ve yenilenme
   tarihi. Anahtar dosyadan okunur, ekrana ve günlüğe yazılmaz.
3. **Kuru çalışma** (ücretsiz, API çağırmaz) ve sonucun kullanıcıya gösterilmesi: karakter + tahmini kredi.
4. Tavan: `--monthly-char-cap <defter ayı kullanılan + istenecek + küçük pay>` (ya da `HIVELZON_TTS_MONTHLY_CHAR_CAP`);
   tavan tanımlı değilse `--execute` reddedilir.

```bash
P=tools/content-pipeline/.venv/bin/python
# kuru çalışma (ücretsiz)
$P tools/content-pipeline/tts_book.py kitaplar/C1-K*
# üretim (onaydan sonra; anahtar yalnız ~/.config/hivelzon/elevenlabs.env içinden ortama alınır)
$P tools/content-pipeline/tts_book.py kitaplar/C1-K* --monthly-char-cap <N> --execute
```

## Koruma notları
- **H-119:** HTTP 200 ile gelip gövdesi kesilen yanıtlar ücretlidir ve deftere yazılır (`TtsPaidError`/`paid_call`);
  `eleven_v3` parçaları en fazla 1500 karakter. **Aynı parçada kesik tekrar ederse dur**, körlemesine yeniden deneme
  (her deneme ücretlenir); önce nedeni ele al.
- Önceden seslendirilmiş bölümler `textSha256` ile atlanır, yeniden ödeme yok; yarıda kalan koşu kaldığı yerden sürer.
- **Anahtar** yalnız `~/.config/hivelzon/elevenlabs.env` (izin 600); repoya, belgelere, günlüğe yazılmaz. Mevcut anahtar
  sohbete yapıştırıldığı için **kullanıcı anahtarı yenilemeli** ve yenisini yalnız bu dosyaya yazmalı (C1'den önce
  yapılırsa en iyisi).
- H-087 odağı A1–A2'dir; C1/C2 yardımcı kitaplıktır. Başlatıp başlatmama ve zamanlama kararı kullanıcıdadır.

## Kabul ölçütleri
- 10 kitabın bütün bölümleri İngilizce sesli; kuru çalışma her kitapta "istenecek 0".
- `export_book.py` 10 kitapta çıkış 0, 0 hata.
- `book_lint.py` 30 kitap 0 hata.
- Kitapların `rights-and-review.md` onay tablosu ve `PROMPTS.md` ses kayıtları "Üretildi" (tarih, model, ses, hesap/plan).
- Defter (`kitaplar/_maliyet/elevenlabs-karakter.json`) koşuları ve kesik çağrıları içeriyor; gerçek kredi abonelik
  okumasıyla karşılaştırılıp kayda yazıldı.
- `tools/content-pipeline` pytest tamamı geçiyor.

## Test / denetim
```bash
P=tools/content-pipeline/.venv/bin/python
$P tools/content-pipeline/tts_book.py kitaplar/C1-K* kitaplar/C2-K*        # kalan 0 olmalı
$P tools/content-pipeline/export_book.py kitaplar/C1-K* kitaplar/C2-K*
$P tools/content-pipeline/book_lint.py kitaplar/[A-C]*-K*
$P -m pytest -q tools/content-pipeline
```

## Sonrasında
- Paketleri dışa aktar, lint'i koş; `devam-edenler/H-073-kitap-dalgasi-c1-c2.md` durumunu güncelle (H-073 editör
  kontrolü için açık kalır); `IS-SIRASI.md`, `docs/TTS-MALIYET-2026-10-30.md`, `docs/EDITOR-INCELEME-PAKETI.md` §5.3/§7.
- Ses düzgün değilse bölüm bazında yeniden üretim yalnız ayrı maliyet onayıyla.

## Geri alma
Kitap başına ses dosyaları ve kayıtlar `git revert` ile geri alınır; defterdeki harcama satırları gerçek ücreti
yansıttığı için geri alınmaz.

## Notlar
- 2026-11-27: Kullanıcı isteğiyle açıldı ("C1 ve C2 kitap seslerini yapılacaklara yazalım"). A1–B2 kitapları sesli (20/30),
  dilbilgisi İngilizce örnekleri 71/71.
