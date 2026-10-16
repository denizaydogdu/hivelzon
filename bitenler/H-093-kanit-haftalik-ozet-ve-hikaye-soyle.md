# H-093: Haftalık özette kanıt cümlesi, Hi gizlilik ekranı ve hikâye içi "Söyle" kanıtı

- **Durum:** Bitti (2026-10-16)
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

## Notlar (2026-10-16, uygulama)
- **Haftalık özet ve Profil:** `WeeklySummary` bu hafta ilk kez ulaşılan basamakları sayar (`recalledLater`, `ownUse`, `helped`; `HiStore.evidenceSince`). Hi panelinde ve gizlilik "Son 7 gün"ünde tek kanıt cümlesi (en güçlü basamak); Profil durum satırı sırası: sonra hatırladın → kendin kullandın → tekrar ettin → yardımla yaptın → yeni ifade → bölüm. Yüzde yok; kanıt yoksa cümle yok.
- **`review_logs` denetimi:** `phrasesReviewed` = hatırlama sorusu cevaplanan ifadeler (anlamlı, korundu, belgelendi). `HiStore.lastReviewAt` artık hatırlama cevabı **ya da** tekrar oturumundaki son pratik (`app_meta` `review.lastPracticeAt`, yalnız cihazda, yalnız daha yeni an; sahne avı sayılmaz; "Bu telefondaki verileri de sil" siler). `reviewTimeSince` değişmedi (yalnız ölçüm öncesi geçiş; pratik süresi `StudyClock` ile ölçülüyor). Tablo: `docs/KELIME-TEKRARI.md` §3.2.
- **Gizlilik:** "Öğrenme kanıtların" bölümü (ifade, basamak, tarih; ilk 5 + "Hepsini göster"). **Karar:** "Hi'nin kayıtlarını sil" kanıtları da siler (ayrı seçenek yok); hesapta `hi_reset` ile sunucuda (`HiResetHook`, şema değişmedi) ve öteki cihazlarda (`applyHiReset`). Belge: `docs/HI-ASISTAN-VE-KOC.md` §5.
- **Hikâye içi "Söyle":** başarı (tam ya da yalnız bir kelime eksik, anlam değiştiren ek yok) → "yardımla yaptı" (`SpeakEnv.practiced` → `NotebookStore.recordSpokenPractice`). Anlam paneli: yalnız defterdeki ifade ya da kart örnek cümlesi; defterde yoksa hiçbir şey. Bölüm sonu ve karar anı (yalnız doğru seçenek): hedef ifadenin anahtarı (`targetPhraseKey`), kart henüz yoksa bölüm bitince ona bağlanır. FSRS ve `review_logs` değişmez.
- **Goldenler (bilerek):** `h059_hi_gizlilik`, `h059_profil`, `h059_profil_adsiz`.
- Şema değişmedi (Drift 10, backend V13).
