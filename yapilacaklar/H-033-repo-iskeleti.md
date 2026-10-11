# H-033: Repo iskeleti (mobil + backend)

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.0 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-025 onayı

## Kapsam
- `mobile/`: Flutter uygulaması (iOS + Android), paket kimliği `tr.velzon.hivelzon`, Riverpod, go_router, tema, 5 sekmelik iskelet (Konuş = "yakında").
- `backend/`: Spring Boot 4 (Java 17, Maven), Actuator health, Flyway, PostgreSQL (docker compose, Colima).
- README: geliştirici kurulumu (Flutter, Android SDK/`adb` PATH, iOS simülatörü, Docker).
- Temel CI (GitHub Actions): `flutter analyze`, `flutter test`, `mvn test`.

## Kabul kriterleri
- `flutter analyze` ve `flutter test` yeşil.
- Uygulama iOS simülatöründe açılıyor, 5 sekme görünüyor.
- `mvn test` yeşil; `/actuator/health` UP (yerel PostgreSQL ile).

## Test
```bash
cd mobile && flutter analyze && flutter test
cd backend && mvn -q test
```

## Geri alma
Kendi dalında (`h-033-repo-iskeleti`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
