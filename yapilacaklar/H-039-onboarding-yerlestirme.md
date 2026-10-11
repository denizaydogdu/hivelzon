# H-039: Onboarding ve yerleştirme

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.7 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-038

## Kapsam
- Dil, yaş beyanı (13+), rızalar.
- Prolog.
- Atlanabilir kademeli yerleştirme testi (K-06).
- Bildirim izni sonradan istenir.

## Kabul kriterleri
- 13 yaş altı kayıt engelleniyor.
- Test atlanabiliyor.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-039-onboarding-yerlestirme`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
