# H-043: Kalite ve beta

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.11 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-039 … H-042

## Kapsam
- Erişilebilirlik, hata ve boş durumlar.
- Çökme raporlama (veri minimizasyonuyla).
- TestFlight ve Google Play dahili test (geliştirici hesapları gerekir).

## Kabul kriterleri
- Beta kontrol listesi tamam.
- Ticari ElevenLabs (H-006) çözülmeden mağazaya çıkılmıyor.

## Test
```bash
cd mobile && flutter test && flutter build ipa --no-codesign
```

## Geri alma
Kendi dalında (`h-043-kalite-beta`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
