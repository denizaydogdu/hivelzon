# H-093: Haftalık özette kanıt cümlesi, Hi gizlilik ekranı ve hikâye içi "Söyle" kanıtı

- **Durum:** Devam ediyor (2026-10-16)
- **Tür:** Uygulama (kod)
- **Faz:** F1 MVP — ürün incelemesi sonrası (H-089'un devamı; H-089 kapsamı "Profil ve haftalık özet" onaylıydı)
- **Bağımlılık:** H-088, H-089

## Kapsam
- Hi haftalık özeti ve Profil durum satırı yalnız "tekrar ettin / ekledin" saymaz; kanıt cümlesi ekler ("Bu hafta 2 ifadeyi birkaç gün sonra kendin hatırladın"), `NotebookStore.evidence()` / `evidenceSummary()` ile. Sahte yüzde ve suçlayıcı dil yok.
- `review_logs` artık yalnız hatırlama tutuyor: `phrasesReviewed` ve `HiStore.reviewTimeSince` gibi kullanımlar gözden geçirilir; pratik süresi/sayısı gerekiyorsa kanıt verisinden alınır.
- Hi gizlilik ekranı kanıt verisini (ifade, basamak, tarih) listeler; "Hi'nin kayıtlarını sil" bunu da siler ya da ayrı seçenek sunar (veri minimizasyonu; karar belgeye yazılır).
- Hikâye içi "Söyle" (anlam paneli "Sen de söyle", bölüm sonu hedef ifadeler, "Söyleyerek seç") başarısı ilgili ifade için "Yardımla yaptı" basamağına yazılır (taklit = pratik; FSRS'e gitmez).

## Kabul kriterleri
- Haftalık özet ve Profil'de kanıt cümlesi (test); boş durum sakin.
- Gizlilik ekranında kanıt verisi görünür; silme davranışı test edilir.
- Hikâyede "Sen de söyle" başarısı "helped" kaydı üretir (test); FSRS değişmez.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında; `git revert`.
