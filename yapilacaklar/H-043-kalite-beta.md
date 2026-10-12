# H-043: Kalite ve iç beta hazırlığı

- **Durum:** Yapılacak (sırada; H-025 onaylandı 2026-10-11, sıra `docs/UYGULAMA-PLANI.md`'de)
- **Tür:** Uygulama (kod)
- **Faz:** 1.11 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-039 … H-042 · **Sonraki:** H-044

## Kapsam
- Erişilebilirlik, hata ve boş durumlar.
- Çökme raporlama (veri minimizasyonuyla).
- Simülatör ve yerel cihazda uçtan uca deneme. Mağaza ve TestFlight H-044'te.

- **H-031'den taşındı (kullanıcı kararı 2026-10-11):** düşük uçlu Android'de oynatıcı bellek/ısı ölçümü ve gerçek telefonda ses–yazı farkı ≤ 0,2 sn kontrolü.

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
2026-10-12: Gerçek cihaz denetimleri bu işte toplanır (kullanıcı kararı): düşük uçlu Android'de bellek/ısı ölçümü, gerçek telefonda ses–yazı farkı ≤ 0,2 sn, Android'de oynatıcı ve Drift veritabanının çalışması. Şimdiye kadarki doğrulamalar yalnızca iOS simülatöründe yapıldı.
