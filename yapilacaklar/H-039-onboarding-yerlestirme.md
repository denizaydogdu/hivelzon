# H-039: Onboarding ve yerleştirme

- **Durum:** Yapılacak (sırada; H-025 onaylandı 2026-10-11, sıra `docs/UYGULAMA-PLANI.md`'de)
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
2026-10-13: H-002 güncellendi: açılışta doğum yılı sorulur. 13 altı → hesap açma gösterilmez, uygulamanın tamamı hesapsız (cihazda) açılır; 13+ → misafir (prolog + B1) ya da hesap. AI sohbeti 18+. Ebeveyn kapısı (mağaza kuralı) H-043/H-044'te değerlendirilir.
