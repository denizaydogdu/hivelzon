# hiVelzon

Yapay zekâ videolarıyla İngilizce öğrenme uygulaması (iOS + Android). Tüm seviyeler (A1–C1), tamamen ücretsiz.

Velzon Bilişim Teknolojileri Ltd. Şti. (Eskişehir · info@velzon.tr) ürünüdür.

**Durum (2026-10-12):** Faz 1 (MVP) uygulaması sürüyor (`docs/UYGULAMA-PLANI.md`). Her şey yerelde çalışıyor; sunucu, video barındırma ve mağaza hesapları en sona bırakıldı (H-044).

Ana deneyim oyunlaştırılmış, sürekli bir hikâye: *The Missing Signal*. Kahraman Aleyna "Alex" Yıldız, yol arkadaşı AI asistan Hi. Sezon 1 (A1) 12 bölüm + prolog; B1–B4 üretildi ve uygulamada oynanıyor. Bitenler: repo iskeleti, bölüm paketi + content-lint, etkileşimli oynatıcı, altyazıya dokununca Türkçe anlam, başlıkla açılış ve sezon jeneriği, hikâye haritası ve kalıcı yerel ilerleme (Drift). Sıradaki: defter, ipucu panosu ve FSRS tekrarı (H-036). AI konuşma pratiği MVP'de yok, v1'de gelir.

## Belgeler

- [Proje rehberi](CLAUDE.md): bağlayıcı kararlar, kurallar, iş takibi (H-numaraları)
- [İş sırası](yapilacaklar/IS-SIRASI.md): nerede kaldık, sıradaki işler, günlük
- [Faz 1 uygulama planı](docs/UYGULAMA-PLANI.md): alt fazlar ve durumları
- [Oyun ve hikâye tasarımı](docs/OYUN-TASARIMI.md) · [Bölüm paketi biçimi](docs/BOLUM-PAKETI.md) · [Hi asistanı ve koç](docs/HI-ASISTAN-VE-KOC.md)
- [İş ve ürün planı](docs/IS-PLANI.md) · [Şartname](docs/SARTNAME.md) · [İçerik mimarisi](docs/ICERIK-MIMARISI.md) · [Lisans raporu](docs/LISANS-RAPORU.md) · [Tasarım yönü](tasarim/README.md)

## Dört ayak

1. Hazır hikâye bölümleri (yapay zekâ ile üretilen görseller ve seslerle; bölümler = video)
2. Yapay zekâ ile konuşma pratiği (v1; kotalı ve bütçe tavanlı)
3. Kişiselleştirme: tekrar (FSRS), defter, yan görevler
4. ~30 saniyelik kısa video akışı (Keşfet; bölüm klipleri)

Teknoloji: Flutter + Spring Boot 4 + PostgreSQL.

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

### İçerik (yerel)
```bash
python3 tools/dev-content-server/serve.py                  # bölüm paketleri, 127.0.0.1:8787
tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_package.py icerik/A1-00[1-4]-*   # paketleri üret
tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_package.py --season 1            # yalnızca sezon paketi
tools/content-pipeline/.venv/bin/python tools/content-pipeline/content_lint.py icerik/A1-0*             # content-lint
tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline                               # boru hattı testleri
```
Uygulama içeriği varsayılan olarak `http://127.0.0.1:8787` adresinden okur (`--dart-define=CONTENT_BASE_URL=...` ile değişir). Simülatör: `flutter run -d "hiVelzon iPhone 17"`. Drift kodunu yeniden üretmek için: `cd mobile && dart run build_runner build --force-jit`. Paket biçimi: `docs/BOLUM-PAKETI.md`.

### CI
`.github/workflows/ci.yml`: her push ve PR'da `flutter analyze` + `flutter test` ile `mvn -B verify` çalışır.
