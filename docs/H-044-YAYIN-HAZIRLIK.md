# H-044 — Yayın Hazırlığı: Sunucu, Medya CDN'i ve Mağaza

- **Durum:** Devam ediyor (2026-10-25). Hesap gerektirmeyen kod ve güvenlikler bitti; dış hesaplar, sunucu ve mağaza yüklemesi kullanıcıya bağlı.
- **İlgili iş:** `devam-edenler/H-044-dis-hesaplar-barindirma-magaza.md`
- **Kararlar:** Sunucu **Almanya**'da; medya CDN'den (Bunny); kullanıcı verisi Almanya'da; hesaplar en sonda (2026-10-11 ve 2026-10-21 kararları).
- **Kural:** Bu belgedeki dış hesap, ödeme, DNS ve mağaza adımları **kullanıcı onayı olmadan** yapılmaz. Sırlar repoya girmez.

## 1. Kodda hazır olanlar (2026-10-25)

| Konu | Davranış | Yer |
|---|---|---|
| Release adres kapısı | Release derlemesi yalnız **genel HTTPS** adresleriyle açılır. Boş, `http`, `localhost`, özel ağ IP'si ve kullanıcı bilgisi içeren adres uygulamayı başlatmaz. Debug/profile etkilenmez. | `mobile/lib/app/release_config.dart`, `mobile/lib/main.dart` |
| Android imzalama | Release artık **debug anahtarıyla imzalanmaz**. `android/key.properties` yoksa çıktı imzasız kalır ve mağazaya yüklenemez. | `mobile/android/app/build.gradle.kts` |
| Android upload key şablonu | `android/key.properties.example`; `key.properties`, `*.jks`, `*.keystore` git dışında. | `mobile/android/` |
| iOS mağaza plist'i | Release `Info-Release.plist` kullanır: `NSAllowsLocalNetworking` **yok**. Debug/profile yerel ağ iznini korur. | `mobile/ios/Runner/Info-Release.plist`, `project.pbxproj` |
| Backend üretim kapısı | `prod` profilinde medya `cdn` olmalı, CDN adresi genel HTTPS olmalı, geliştirme içe aktarması kapalı olmalı; aksi halde uygulama **başlamaz**. | `ProductionConfigValidator.java` |
| Ters vekil | `prod` profilinde `server.forward-headers-strategy: framework`; hız sınırı ve denetim kaydı gerçek istemci IP'sini görür. | `application-prod.yml` |
| Sürümlü reel paketleri | Reel paket adresi `…/packages/_reels/<id>/v<N>/` olur; `content_version` arttıkça yeni klasör, eski dosya ezilmez. | `CdnPackageAdapter.java`, `CatalogService.mapReel` |
| Mutlak medya adresi | Paket içinde `https://…m3u8` gibi mutlak adres kullanılabilir (Bunny Stream). `http` ve kullanıcı bilgisi reddedilir. | `http_content_source.dart` |

**Bilerek yapılmayanlar:** Reel dışındaki paketler (bölüm, kitap, dilbilgisi) mobilde sabit `packages/<id>/` yolundan okunur; bu yüzden onların CDN yolu sürümlenmez. Sürümleme yalnız reellerde ve backend'in verdiği `packageBaseUrl` üzerinden çalışır.

## 2. Doğrulama (2026-10-25)

```bash
cd backend && mvn verify                 # Testcontainers: DOCKER_HOST + TESTCONTAINERS_RYUK_DISABLED=true
cd mobile && flutter analyze && flutter test
cd mobile && flutter build apk --debug
cd mobile && flutter build apk --release     # key.properties yoksa imzasız çıkar (beklenen)
cd mobile && flutter build ios --release --no-codesign
```

- `flutter analyze`: temiz.
- Mobil test: **1472/1472**.
- Backend: **164/164** (Testcontainers/PostgreSQL dahil).
- Android debug APK üretildi; release APK **imzasız** (`apksigner`: `DOES NOT VERIFY`) — debug anahtarı kullanılmıyor.
- iOS release `Runner.app` üretildi; paket `Info.plist` içinde `NSAllowsLocalNetworking` ve `NSAppTransportSecurity` **yok**, `CFBundleDisplayName` = **Hi**.

## 3. Ortam değişkenleri (sırlar yalnız sunucuda)

`/etc/hivelzon/backend.env` (izin `0600`, repo dışı):

| Değişken | Örnek / kural |
|---|---|
| `HIVELZON_DB_URL` | `jdbc:postgresql://127.0.0.1:5432/hivelzon` |
| `HIVELZON_DB_USER` / `HIVELZON_DB_PASSWORD` | Yalnız veritabanı kullanıcısı; uygulama kullanıcısı süper kullanıcı olmaz. |
| `HIVELZON_JWT_SECRET` | Base64, en az 32 bayt; parola yöneticisinde saklanır. |
| `HIVELZON_OTP_PEPPER` | Base64, en az 32 bayt; JWT anahtarından **farklı**. |
| `HIVELZON_MEDIA_PROVIDER` | `cdn` |
| `HIVELZON_MEDIA_CDN_BASE_URL` | `https://media.hi.velzon.tr/packages/` |
| `HIVELZON_CATALOG_DEV_IMPORT` | `false` |
| `HIVELZON_SMTP_HOST` / `PORT` / `USER` / `PASSWORD` | Gerçek e-posta sağlayıcısı; `AUTH=true`, `STARTTLS=true`. |
| `HIVELZON_SMTP_AUTH` / `HIVELZON_SMTP_STARTTLS` | `true` / `true` |
| `HIVELZON_MAIL_FROM` | `Hi <no-reply@hi.velzon.tr>` |
| `HIVELZON_PORT` | `8080` (yalnız 127.0.0.1'e bağlanır) |
| `HIVELZON_JOBS_ENABLED` | `true` |
| `PD_API_KEY` | Yalnız Türkçe seslendirme/konuşma tanıma kullanılacaksa. |
| `HIVELZON_TERMS_VERSION` / `HIVELZON_PRIVACY_NOTICE_VERSION` | Uygulamadaki sürümlerle **aynı** olmalı (`taslak-2`). |

Uygulama derlemesindeki üç adres:

| `--dart-define` | Değer |
|---|---|
| `API_BASE_URL` | `https://api.hi.velzon.tr` |
| `CONTENT_BASE_URL` | `https://media.hi.velzon.tr` |
| `REEL_CATALOG_URL` | `https://api.hi.velzon.tr/api/v1/catalog/reels` |

## 4. Sunucu (Almanya)

1. Ubuntu 24.04 LTS, 2 vCPU / 4 GB RAM / 40 GB SSD; sağlayıcı ve bölge kullanıcı kararıyla.
2. SSH anahtarıyla giriş; parola girişi kapalı; güvenlik duvarında yalnız 22 (kısıtlı IP), 80, 443 açık. **8080 ve 5432 dışarı kapalı.**
3. Docker + Compose kurulur; PostgreSQL 17 `postgres:17-alpine`, adlandırılmış hacim, yalnız `127.0.0.1:5432`.
4. Backend imajı `prod` profiliyle çalışır; ortam dosyası `--env-file /etc/hivelzon/backend.env`, `restart: unless-stopped`.
5. TLS: Caddy (otomatik sertifika) ya da nginx + certbot. `api.hi.velzon.tr` → `127.0.0.1:8080`; `media.hi.velzon.tr` → Bunny Pull Zone (CNAME).
6. Sağlık: `curl -fsS https://api.hi.velzon.tr/actuator/health` → `{"status":"UP"}`.
7. Yedek: günlük `pg_dump` (şifreli), **farklı sağlayıcı/bölgede** en az 14 gün; ayda bir geri yükleme denemesi. Yedek anahtarı sunucuda değil.
8. Günlükler: erişim ve uygulama günlükleri 30 gün; kişisel veri içeren gövde loglanmaz.
9. İzleme: disk, bellek, 5xx oranı ve sağlık ucu için basit uyarı.

> Backend portu doğrudan internete açılırsa `X-Forwarded-For` sahtelenebilir. Bu yüzden yalnız ters vekil erişir; güvenlik duvarı bunu zorunlu kılar.

## 5. Bunny (medya CDN'i)

1. Storage Zone (Almanya/Falkenstein) ve Pull Zone: `media.hi.velzon.tr`.
2. Klasör düzeni:

```
packages/index.json                       # bölüm listesi (mobil okur)
packages/<id>/…                           # bölüm, kitap, dilbilgisi (sabit yol)
packages/_reels/<id>/v<N>/reel.json       # sürümlü reel paketi
packages/_reels/<id>/v<N>/video/…
packages/_reels/<id>/v<N>/stills/…
packages/_reels/<id>/v<N>/audio/…
```

3. **Sürümlü klasör kuralı:** Yayındaki `v<N>` dosyaları asla değiştirilmez. Yeni içerik `v<N+1>` klasörüne yüklenir, backend'de yeni sürüm onaylanır; katalog yeni klasöre işaret eder.
4. `index.json` kısa önbellek (60 sn), `v<N>` yolları uzun önbellek (`immutable`).
5. Büyük videolar için Bunny Stream + HLS düşünülebilir: `playlist.m3u8` adresi paket içine **mutlak HTTPS** olarak yazılır; mobil bunu destekler. Mevcut 11–13 sn'lik reellerde doğrudan mp4 yeterlidir.
6. Yükleme sonrası kontrol: `reel.json`, bir mp4, bir m4a ve bir görsel `200` dönmeli; `reel-lint` **0 hata** olmalı.

## 6. Apple (TestFlight)

1. App Store Connect'te uygulama kaydı: bundle `tr.velzon.hivelzon`, ad **Hi**, birincil dil Türkçe, SKU kullanıcı kararı.
2. Takım `6YB6UUDVS5`; Apple Distribution kimliği makinede hazır. Xcode otomatik imza ile App Store profilini üretir.
3. `flutter build ipa --release` + üç `--dart-define`; `--export-method app-store`.
4. TestFlight iç test grubu (kullanıcı + ekip). Dış test için Apple incelemesi gerekir.
5. Gizlilik: izleme yok; e-posta ve öğrenme ilerlemesi kullanıcıyla ilişkili. Gizlilik politikası URL'si ve uygulama içi hesap silme (H-042) hazır.
6. Yaş derecelendirmesi ve ihracat uyumluluğu (özel şifreleme yok) formları doldurulur.
7. Gizlilik manifesti: eklentiler kendi manifestlerini getiriyor; App Store ek şart koşarsa uygulama düzeyinde `PrivacyInfo.xcprivacy` eklenir.

## 7. Google Play

1. Play Console geliştirici hesabı (tek seferlik ücret — **kullanıcı onayı gerekir**).
2. Uygulama: paket `tr.velzon.hivelzon`, ad **Hi**, varsayılan dil Türkçe.
3. Play App Signing açık; **upload key** yerelde üretilir, repo dışında saklanır:

```bash
keytool -genkeypair -v -keystore ~/.config/hivelzon/upload-keystore.jks \
  -keyalg RSA -keysize 4096 -validity 10000 -alias upload
cp mobile/android/key.properties.example mobile/android/key.properties
# storeFile/storePassword/keyAlias/keyPassword gerçek değerlerle doldurulur
```

4. `flutter build appbundle --release` + üç `--dart-define` → `build/app/outputs/bundle/release/app-release.aab`.
5. Dahili test → kapalı test (yeni kişisel hesaplarda 12 test kullanıcısı şartı) → üretim.
6. Veri güvenliği formu, içerik derecelendirmesi, hedef API düzeyi ve gizlilik politikası URL'si doldurulur.

## 8. KVKK ve hukuk

- Veri sorumlusu unvanı, adres, iletişim ve mahkeme yer tutucuları hâlâ doldurulmadı (`docs/HUKUK-SORULARI.md`).
- Yurt dışı aktarım: sunucu Almanya; hukukçu 2026-10-21'de standart sözleşme/Kurul bildirimi gerekmediğini söyledi. Sağlayıcılarla (barındırma, Bunny, e-posta) veri işleme sözleşmeleri dosyalanır.
- Mağaza gizlilik politikası URL'si yayına alınır; uygulama içi metin sürümü backend ile aynı tutulur.
- Saklama: rıza ve denetim kayıtları 2 yıl; hesap silme 30 gün geri alma sonrası kalıcı (H-042/H-095).

## 9. Mağaza derleme komutu (tek örnek)

```bash
cd mobile
flutter build appbundle --release \
  --build-name 0.1.0 --build-number <N> \
  --dart-define=API_BASE_URL=https://api.hi.velzon.tr \
  --dart-define=CONTENT_BASE_URL=https://media.hi.velzon.tr \
  --dart-define=REEL_CATALOG_URL=https://api.hi.velzon.tr/api/v1/catalog/reels \
  --dart-define=TERMS_VERSION=taslak-2 \
  --dart-define=PRIVACY_NOTICE_VERSION=taslak-2
```

Yanlış adresle derlenen paket açılışta durur; mağazaya işlevsiz sürüm gönderilmez.

## 10. Kabul kontrol listesi

- [ ] Sunucuda `prod` profili açılıyor; sağlık ucu `UP`.
- [ ] `HIVELZON_MEDIA_PROVIDER=local` ile prod **başlamıyor** (kapı çalışıyor).
- [ ] CDN'de `packages/index.json`, bir bölüm paketi ve bir `v<N>` reel paketi `200`.
- [ ] Uygulama sunucudaki backend ve CDN medyasıyla uçtan uca çalışıyor (giriş, eşitleme, Keşfet, oynatıcı).
- [ ] TestFlight iç test sürümü yüklendi.
- [ ] Play dahili test sürümü yüklendi.
- [ ] Yedek alındı ve geri yükleme denendi.
- [ ] Repoda sır yok: `git grep -nE "BEGIN (RSA|PRIVATE)|storePassword=|HIVELZON_JWT_SECRET=."`.
- [ ] Gizlilik politikası URL'si ve veri sorumlusu bilgileri dolu.

## 11. Kullanıcıdan gerekenler

1. Sunucu sağlayıcısı/bölgesi ve SSH erişimi; alan adı DNS yönetimi (`hi.velzon.tr`).
2. Bunny hesabı ve Storage/Pull Zone.
3. Apple App Store Connect uygulama kaydı ve test kullanıcıları.
4. Google Play geliştirici hesabı (ücret onayı) ve test kullanıcıları.
5. Veri sorumlusu bilgileri ve hukukçu onaylı nihai metinler.
6. Muhasebe kararları (yurt dışı hizmet KDV, fatura akışı).

Bunlar tamamlanana kadar uygulama yerelde çalışmaya devam eder; H-092 pilotu H-044'ten sonra yapılır.
