# G-A2-01-present-continuous: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K02 p01 · "Mrs Berg is talking." (kanca)
  - A1-012 · "I'm looking for the old radio." (kurgu yok; story.en.md ✓ seçenek satırı)
  - A1-011 · "And it's raining in the evening." (kurgu yok; story.en.md satırı)
  - A2-K02 p03 · "Some clouds are coming." · A2-K03 p06 · "We're making pancakes," said Finn.

## Tipik hata kaynağı
*I am look for the old radio.* (A1-012 Sahne 1, ✗ seçenek) · *She cooking now.* (müfredat, G-A2-01: *I looking.*)

## Öğretmene notlar
- Yazım kuralı sade anlatıldı: "tek heceli, bir ünlü + bir ünsüzle biten fiilde son harf ikilenir" (run → running, sit → sitting). w, x, y ile bitenler (play → playing) ve vurgusu sonda olan iki heceli fiiller (begin → beginning) anlatılmadı.
- *-ie → -ying* (lie → lying) A2 için anlatılmadı.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan", "zamanla oturur" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h080b.json`): 7 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
