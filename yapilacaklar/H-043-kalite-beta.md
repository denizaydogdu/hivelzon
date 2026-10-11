# H-043: Kalite ve iç beta hazırlığı

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.11 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-039 … H-042 · **Sonraki:** H-044

## Kapsam
- Erişilebilirlik, hata ve boş durumlar.
- Çökme raporlama (veri minimizasyonuyla).
- Simülatör ve yerel cihazda uçtan uca deneme. Mağaza ve TestFlight H-044'te.

## Kabul kriterleri
- Beta kontrol listesi tamam (mağaza maddeleri hariç).

## Test
```bash
cd mobile && flutter test && flutter build ipa --no-codesign
```

## Geri alma
Kendi dalında (`h-043-kalite-beta`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
