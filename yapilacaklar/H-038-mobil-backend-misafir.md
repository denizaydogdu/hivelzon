# H-038: Mobil ↔ backend bağlantısı ve misafir modu

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.6 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-035, H-037

## Kapsam
- Kayıt ve giriş ekranları.
- Misafir (prolog + B1) verisinin hesaba taşınması.
- İlerleme ve olay eşitleme; idempotent `client_event_id`.

## Kabul kriterleri
- Misafir → kayıt akışı veri kaybetmeden çalışıyor.
- Aynı olay iki kez gönderilince tek kayıt oluşuyor (test).

## Test
```bash
cd mobile && flutter test
cd backend && mvn verify
```

## Geri alma
Kendi dalında (`h-038-mobil-backend-misafir`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
