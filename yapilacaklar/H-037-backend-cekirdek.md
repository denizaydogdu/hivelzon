# H-037: Backend çekirdek

- **Durum:** Yapılacak (sırada; H-025 onaylandı 2026-10-11, sıra `docs/UYGULAMA-PLANI.md`'de)
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
2026-10-12: Backend iskeleti var (H-033: Spring Boot 4.0.8, `/actuator/health`, Testcontainers). Bu işten önce kullanıcıya sorulacak: **giriş yöntemi** (e-posta + parola mı, Apple / Google mı). `docs/SARTNAME.md` §10 taslağındaki eksikler burada kesinleştirilir: `refresh_tokens` tablosu, roller (kullanıcı / editör / yönetici) ve hesap silme durum adı (şartname §10'da `DELETION_PENDING`, iş planı §9.4'te `PENDING_DELETION`; tek ad burada seçilir). Her şey yerel Docker PostgreSQL'de (5434); sunucu H-044'te.
