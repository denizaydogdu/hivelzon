# H-033: Repo iskeleti (mobil + backend)

- **Durum:** Bitti
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

2026-10-11: İskelet kuruldu ve doğrulandı (gerçek çıktılar):
- Sürümler: Flutter 3.38.5, flutter_riverpod ^3.3.2, go_router ^17.5.0; Spring Boot 4.0.8 (Maven Central'daki en güncel 4.0.x), Java 17, Maven 3.6.3 (wrapper gerekmedi), Flyway 11.14.1, PostgreSQL JDBC 42.7.13, Testcontainers 2.0.5, PostgreSQL 17 (`postgres:17-alpine`).
- `cd mobile && flutter analyze` → "No issues found!"; `flutter test` → "+1: All tests passed!" (5 sekme görünür, Konuş → "Yakında").
- `cd backend && mvn -B verify` → "Tests run: 2, Failures: 0, Errors: 0, Skipped: 0", BUILD SUCCESS (health UP + Flyway V1 uygulandı; Testcontainers ile). Colima'da `DOCKER_HOST` ve `TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE` gerekiyor (README); Ryuk çalıştı, kapatmak gerekmedi. Değişkenler olmadan "Could not find a valid Docker environment" hatası alınır.
- iOS: yeni simülatör "hiVelzon iPhone 17" (iOS 26.5) oluşturuldu; `flutter build ios --simulator --debug` → "✓ Built build/ios/iphonesimulator/Runner.app" (29,2 sn); `simctl install/launch` ile açıldı, ekran görüntüsünde 5 sekme görünüyor.
- Yerel çalıştırma: `docker compose up -d --wait` (localhost:5434; 5432/5433 başka projelerde dolu) → `mvn spring-boot:run` → Flyway "Successfully applied 1 migration … now at version v1" → `curl localhost:8080/actuator/health` → `{"groups":["liveness","readiness"],"status":"UP"}`.
- Yapılmayan: Android derlemesi ve emülatör denemesi (kabul kriterinde yok); CI iş akışı yazıldı ama GitHub'da henüz çalışmadı (push yok).
