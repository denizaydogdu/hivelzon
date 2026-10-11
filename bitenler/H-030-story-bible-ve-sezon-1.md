# H-030: Story Bible, karakter kitabı ve Sezon 1 bölüm planı

- **Durum:** Bitti (2026-10-11)
- **Tür:** Yazım (kodsuz, kredisiz)
- **Öncelik:** Yüksek
- **Bağımlılık:** H-029 (en azından K-21, K-22, K-23, K-25)

## Amaç
Hikâye kanonunu ve Sezon 1'in bölüm zincirini, üretime hazır taslak olarak yazmak.

## Kapsam
Aşağıdaki dosyalar `icerik/_evren/` altına yazılır:
- `STORY_BIBLE.md`
- `CHARACTER_PROFILES.md`: Alex, Hi, Maya, Sam, Jordan ve mekân karakterleri. Her biri için kişilik, konuşma tarzı, seviye başına dil sınırı, ses kimliği önerisi ve görsel tarif.
- `CANON_AND_TIMELINE.md`
- `OPEN_QUESTIONS.md`
- `LANGUAGE_PROGRESSION.md`
- `SEASON_01_OUTLINE.md`: 12 bölüm + prolog. Her bölüm için:
  - can-do hedefi, hedef ifadeler, dilbilgisi;
  - bağ alanları: `previously`, `payoff`, `openQuestion`, `answers`, `callbackPhrases`;
  - görev ve karar anları.
- Seri yayı: 5 sezonun taslağı.
- İlk 3 bölümün diyalog taslağı.

## Kabul kriterleri
- Bağ kuralları sağlanmış (`OYUN-TASARIMI.md` §4.3):
  - her soru en geç 3 bölümde kapanır;
  - aynı anda en fazla 3 açık soru vardır;
  - sahte kanca yoktur.
- Sezon 1 dil hedefleri A1 ünite listesini kapsıyor.
- İlk 3 bölümün diyalogları CEFR-J A1 listesine göre elle kontrol edilmiş.
- Gerçek kişi, marka ya da telifli karakter benzerliği yok; 13+ kurallarına uygun.
- Kullanıcı (ya da H-028'deki onaylayan) taslağı onaylamış.

## Kaynak
`docs/OYUN-TASARIMI.md` §4–§7, §12

## Notlar
2026-10-11: Kullanıcı ana deneyimin oyunlaştırılmış, bölümleri birbirine bağlı bir hikâye olmasına karar verdi. Kaynak: `docs/OYUN-TASARIMI.md`, `docs/HIKAYE-EVRENI.md`.

## İlerleme (2026-10-11)

**Yazılanlar** (`icerik/_evren/`):
- `STORY_BIBLE.md`
- `CHARACTER_PROFILES.md`
- `CANON_AND_TIMELINE.md` (F-001…F-020)
- `OPEN_QUESTIONS.md`
- `LANGUAGE_PROGRESSION.md`
- `SEASON_01_OUTLINE.md` (prolog + 12 bölüm; bağ alanları dolu)

**Diyalog taslakları:**
- `icerik/A1-000-arrival/`
- `A1-001-a-strange-message/`
- `A1-002-the-new-neighbour/`
- `A1-003-find-the-station/`

Her birinde `story.en.md` ve `content.json` var; durum DRAFT.

**Kabul kriterleri:**
- ✅ Bağ kuralları sağlanıyor (`OPEN_QUESTIONS.md` denetim tablosu):
  - her soru en geç 3 bölümde kapanıyor;
  - aynı anda en fazla 3 soru açık;
  - sahte kanca yok.
- ✅ Sezon 1, A1'in 12 ünitesinin tamamını kapsıyor.
- ✅ İlk 3 bölüm ve prolog CEFR-J v1.6 A1 ile denetlendi. Bu, geçici bir araçla yapıldı: `scratchpad/tools/cefr_check.py`. Araç oturuma özgü, repoda değil; `content-lint`'in tohumu.
  - A1 kapsamı: P 98,0 · B1 98,3 · B2 97,9 · B3 96,2. Sözlükle birlikte hepsi %100.
  - Hiçbir cümle 8 kelimeyi aşmıyor.
  - Denetim sonucunda yapılan düzeltmeler:
    - *next to* ve *opposite* (A2) yerine *near / between / behind*;
    - *market* yerine *shop*;
    - *voice* yerine *message*;
    - *pound* yerine birimsiz fiyat;
    - *press* yerine *turn on*.
- ✅ Gerçek kişi, marka ya da telifli karakter yok; 13+ kurallarına uygun.
  - **Açık:** "Port Lumen" adının gerçek bir yer ya da marka ile karışmadığı kontrol edilecek (H-016).
- ✅ **Kullanıcı onayı (2026-10-11):** Aleyna "Alex" (kadın), taslak onaylandı, fiyatlar birimsiz.

**Kullanıcıya sorulanlar:**
1. Alex'in adı ve cinsiyeti: Aleyna "Alex" mi, Alper "Alex" mi?
2. Taslağın genel onayı.
3. S1'de para biriminin söylenmemesi.
