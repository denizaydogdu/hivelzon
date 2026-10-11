# H-037: Backend çekirdek

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.5 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-033 (H-031 ile paralel olabilir)

## Kapsam
- Kimlik doğrulama ve kullanıcı (yöntem bu işten önce sorulur).
- Rıza kayıtları (yalnızca ekleme), `audit_log` (IP/port/saat).
- Hesap silme: 30 gün geri alınabilir.
- İçerik kataloğu, ilerleme ve olay (`learning_events`) API'leri.
- Flyway, ProblemDetail hata modeli, giriş hız sınırı.

## Kabul kriterleri
- Testcontainers entegrasyon testleri yeşil.
- Silme ve geri alma testli.
- Hız sınırı testli.

## Test
```bash
cd backend && mvn verify
```

## Geri alma
Kendi dalında (`h-037-backend-cekirdek`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
