# H-040: Keşfet akışı (kısa klipler)

- **Durum:** Yapılacak (sırada; H-025 onaylandı 2026-10-11, sıra `docs/UYGULAMA-PLANI.md`'de)
- **Tür:** Uygulama (kod)
- **Faz:** 1.8 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-038

## Kapsam
- B1–B4'ten kısa klipler.
- Kaydet / Anlam / Tam hikâye.
- Her 4–5 klipte quiz kartı, ~10 klipte mola kartı; 13–17 yaş için 20 dk sınırı (K-15).

## Kabul kriterleri
- Akış bellek sınırı içinde (ölçüm raporu).
- Mola ve süre sınırı testli.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-040-kesfet-akisi`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12: "Anlam" düğmesi H-046'daki anlam panelini (`lib/shared/meaning/`) yeniden kullanır. Klipler yalnızca editörün onayladığı içerikten türetilir; uygulama içinde AI etiketi gömülmez, kısa not gösterilir (CLAUDE.md Higgsfield kuralı 6).
