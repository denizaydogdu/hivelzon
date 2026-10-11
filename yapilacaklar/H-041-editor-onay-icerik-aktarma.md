# H-041: Editör onay ekranı ve içerik içe aktarma

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.9 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-038

## Kapsam
- `content-lint` → içe aktarma → Onayla / Zamanla / Kaldır.
- İçerik sürümleri, `publish_at` (K-05, K-12).
- Medya: Bunny Stream, `VideoHostingPort` arkasında (hesap bu işten önce gerekir).

## Kabul kriterleri
- Onaysız içerik katalogda görünmüyor (backend testi).
- Zamanlanmış içerik zamanı gelince görünüyor (test).

## Test
```bash
cd backend && mvn verify
```

## Geri alma
Kendi dalında (`h-041-editor-onay-icerik-aktarma`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
