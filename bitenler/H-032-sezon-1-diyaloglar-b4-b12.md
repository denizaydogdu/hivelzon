# H-032: Sezon 1 diyalog taslakları (B4–B12)

- **Durum:** Bitti (2026-10-11); kullanıcı onayladı
- **Tür:** Yazım (kodsuz, kredisiz)
- **Öncelik:** Yüksek (lansmanda Sezon 1'in büyük kısmı hazır olmalı, K-26)
- **Bağımlılık:** H-030 (bitti)

## Amaç
Onaylı `SEASON_01_OUTLINE.md`'ye göre B4–B12'nin diyalog taslaklarını yazmak.

## Kapsam
- Her bölüm için `story.en.md` ve `content.json`. Bağ alanları zorunlu.
- Format ve işaretler: `icerik/A1-000-arrival/story.en.md`.
- CEFR-J v1.6 A1 denetimi:
  - A1 kapsaması hedef ≥ %98, alt sınır %95;
  - hiçbir cümle 8 kelimeyi aşmaz;
  - seviye üstü kelimeler sözlükte verilir.
- Kanon (`CANON_AND_TIMELINE.md`) ve açık sorular (`OPEN_QUESTIONS.md`) ile tutarlılık.

## Kabul kriterleri
- 9 bölümün taslağı yazılmış; her biri A1 denetiminden geçmiş (sonuç `content.json`'da).
- Karar anı ve bayrak sınırlarına uyulmuş (K-27, K-28).
- Kanon çelişkisi yok.
- Kullanıcı onaylamış.

## Notlar
2026-10-11: H-030 onayından sonra açıldı.

## İlerleme (2026-10-11)

B4–B12 diyalog taslakları yazıldı. Üç ajan paralel çalıştı; Claude birleştirdi ve denetledi. Her bölümde `story.en.md` + `content.json` var.

**Sezon denetimi (prolog + B1–B12, 13 bölüm):**
- **A1 kapsaması:** %95,7–99,0. Sözlükle birlikte %98,9–100. Hepsi alt sınırın (%95) üstünde. %98'in altında kalanlar: B3, B4, B5, B8, B9. Nedeni hikâyenin anahtar kelimeleri (anten, sinyal, liman…); hepsi sözlükte.
- **8 kelimeyi aşan cümle:** 0.
- **Bölüm başına karar anı:** 2–3 (sınır 4). **Bayraklar:** `greet_tone`, `ask_style`, `drink_choice`; her birinin geri dönüşü var.
- **Önceki/sonraki zinciri** kesintisiz. Açılan ve kapanan sorular `OPEN_QUESTIONS.md` ile birebir aynı.
- **Denetim aracı düzeltildi:** artık `[TEPKİ]` satırlarını da ölçüyor.

**Claude'un düzeltmeleri:**
- **B9:**
  - "They meet here… long ago." → "The club was here. Long ago." (dilbilgisi; outline'daki hata).
  - Hikâye boşluğu kapatıldı: Neden hemen fenere gitmiyorlar? Lumen Point uzak, otobüs yok, telsiz zayıf.
  - *Next to* → *near*.
- **B12:** Bayrak değeri `hot chocolate` → `hot_chocolate` (B9 ile aynı).

**Ajanların kabul edilen sapmaları:**
- F-011 kayıt cümlesi 9 kelime olduğu için iki satıra bölündü; kelimeler aynı.
- *Slowly, Sam!* → "Sam! Slow down!" (*slowly* A2).
- B7'ye *he/she* karar anı eklendi.
- B9'da fiyat "twelve" (B10'un *thirteen* dersini öne çekmemek için).
- B12'deki "Sezon 2" kartı Türkçe (*season* B1).

**Kullanıcı onayı (2026-10-11):** "Onaylıyorum". Sezon 1 taslakları kilitlendi.

