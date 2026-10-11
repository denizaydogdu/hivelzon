# hiVelzon

Yapay zekâ videolarıyla İngilizce öğrenme uygulaması (iOS + Android). Tüm seviyeler (A1–C1), tamamen ücretsiz.

Velzon Bilişim Teknolojileri Ltd. Şti. (Eskişehir · info@velzon.tr) ürünüdür.

**Durum:** Faz 1 (MVP) uygulaması başladı (`docs/UYGULAMA-PLANI.md`). İlk iş: repo iskeleti (H-033).

## Belgeler

- [İş ve ürün planı](docs/IS-PLANI.md): vizyon, rakipler, ürün kapsamı, içerik hattı, maliyet modeli, KVKK, mimari, yol haritası
- [İş sırası](yapilacaklar/IS-SIRASI.md): nerede kaldık, sıradaki işler
- [Proje rehberi](CLAUDE.md): klasörler, iş takibi (H-numaraları), kurallar

## Dört ayak

1. Hazır ders videoları (Higgsfield ile üretilen yapay zekâ öğretmen)
2. Yapay zekâ ile konuşma pratiği (kotalı)
3. Kişiselleştirilmiş etkinlikler
4. ~30 saniyelik kısa video akışı

Önerilen teknoloji: Flutter + Spring Boot 4 + PostgreSQL.

## Geliştirici kurulumu

Depo düzeni: `mobile/` (Flutter, iOS + Android, paket kimliği `tr.velzon.hivelzon`), `backend/` (Spring Boot 4, Java 17, Maven), `docker-compose.yml` (yerel PostgreSQL 17).

### Gerekenler
- **Flutter 3.38.5** (stable): `flutter --version`, sonra `flutter doctor`.
- **Xcode** ve iOS simülatörü (macOS).
- **Android SDK** (Android Studio ile). `adb` için platform-tools'u PATH'e ekleyin (`~/.zshrc`):
  ```bash
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
  ```
  Ardından `adb version` ve `flutter doctor --android-licenses`.
- **Java 17** ve **Maven 3.6.3+**.
- **Docker**: macOS'ta Colima (`brew install colima docker docker-compose`, sonra `colima start`).

### Mobil
```bash
cd mobile
flutter pub get
flutter analyze && flutter test
xcrun simctl list devices available        # simülatör seç
xcrun simctl boot <cihaz-id> && open -a Simulator
flutter run -d <cihaz-id>
```

### Backend
```bash
docker compose up -d --wait                # PostgreSQL 17, localhost:5434
cd backend
mvn spring-boot:run
curl localhost:8080/actuator/health        # {"status":"UP"} beklenir
```
Veritabanı ayarları ortam değişkenlerinden okunur: `HIVELZON_DB_URL`, `HIVELZON_DB_USER`, `HIVELZON_DB_PASSWORD`, `HIVELZON_PORT`. Varsayılanlar yalnızca yerel `docker-compose.yml` içindir; gerçek sırlar repoya girmez (`~/.config/hivelzon/`).

### Backend testleri (Testcontainers)
`mvn -B verify` testleri gerçek bir PostgreSQL konteynerinde çalıştırır. Colima kullanıyorsanız Testcontainers Docker soketini kendiliğinden bulamaz; şu değişkenleri tanımlayın:
```bash
export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
# Ryuk konteyneri başlamazsa: export TESTCONTAINERS_RYUK_DISABLED=true
cd backend && mvn -B verify
```

### CI
`.github/workflows/ci.yml`: her push ve PR'da `flutter analyze` + `flutter test` ile `mvn -B verify` çalışır.
