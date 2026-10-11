# H-036: Defter, ipucu panosu, FSRS tekrarı

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.4 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-035

## Kapsam
- Defter: bölümlerde toplanan ifadeler.
- İpucu panosu ve açık sorular (en fazla 3).
- FSRS tekrarı (hedef hatırlama 0,90), Bildim / Bilmedim.
- Ana Sayfa'da "Hızlı pratik" (5/10/15 dk hedef).

## Kabul kriterleri
- FSRS birim testleri yeşil.
- İstemci–sunucu eşdeğerlik testi için örnek veri hazır.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-036-defter-ipucu-fsrs`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
