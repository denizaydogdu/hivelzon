# hiVelzon backend

Spring Boot 4 (Java 17, Maven), PostgreSQL 17, Flyway. Modüler monolit: `auth` (e-posta kodu, belirteçler), `user` (hesap, silme), `consent` (rızalar), `audit` (denetim kaydı), `common` (ayar, hata modeli, güvenlik yardımcıları).

## Çalıştırma (yerel)

```bash
colima start
docker compose up -d --wait          # repo kökünde: PostgreSQL + Mailpit
cd backend && mvn spring-boot:run    # varsayılan profil = geliştirme
curl localhost:8080/actuator/health  # {"status":"UP"}
```

- Varsayılan port 5435 (5432–5434 bu makinede başka projelerde). Doluysa: `HIVELZON_PG_PORT=<port> docker compose up -d --wait` ve backend için `HIVELZON_DB_URL=jdbc:postgresql://localhost:<port>/hivelzon`.
- Giriş kodu e-postaları dışarı gitmez; projeye ait Mailpit'e düşer: arayüz <http://127.0.0.1:8027>, SMTP `127.0.0.1:1027`. Kodu API'den okumak için: `curl -s 'http://127.0.0.1:8027/api/v1/search?query=to:ADRES'`.

## Ayarlar (ortam değişkenleri)

| Değişken | Varsayılan (yalnızca geliştirme) | Açıklama |
|---|---|---|
| `HIVELZON_DB_URL` / `_USER` / `_PASSWORD` | `jdbc:postgresql://localhost:5435/hivelzon`, `hivelzon`, `hivelzon` | Veritabanı |
| `HIVELZON_PORT` | `8080` | HTTP portu |
| `HIVELZON_JWT_SECRET` | yok | Erişim belirteci (HS256) anahtarı, Base64, en az 32 bayt. **prod profilinde zorunlu**; yoksa uygulama başlamaz. Geliştirmede tanımlı değilse her açılışta geçici rastgele anahtar üretilir (yeniden başlatınca oturumlar düşer). |
| `HIVELZON_OTP_PEPPER` | yok | E-posta, IP ve kod özetleri için HMAC anahtarı, Base64, en az 32 bayt. JWT anahtarından farklı olmalı. prod'da zorunlu. |
| `HIVELZON_SMTP_HOST` / `_PORT` / `_USER` / `_PASSWORD` / `_AUTH` / `_STARTTLS` | `localhost`, `1027`, boş, boş, `false`, `false` | SMTP (yerelde Mailpit) |
| `HIVELZON_MAIL_FROM` | `hiVelzon <no-reply@hi.velzon.tr>` | Gönderen |
| `HIVELZON_RL_OTP_START_PER_EMAIL` | `5` | Saatte e-posta başına kod isteği |
| `HIVELZON_RL_OTP_START_PER_IP` | `20` | Saatte IP başına kod isteği |
| `HIVELZON_RL_OTP_VERIFY_PER_IP` | `60` | Saatte IP başına kod doğrulama |
| `HIVELZON_RL_REFRESH_PER_IP` | `120` | Saatte IP başına belirteç yenileme |
| `HIVELZON_TERMS_VERSION` / `_PRIVACY_NOTICE_VERSION` / `_MARKETING_VERSION` | `taslak-1` | Hukuk metinlerinin güncel sürümleri |
| `HIVELZON_JOBS_ENABLED` | `true` | Zamanlanmış işler (kalıcı silme her saat :17'de, temizlik 15 dk'da bir; UTC) |

Anahtar üretmek için: `openssl rand -base64 32`. Sırlar repoya girmez (`~/.config/hivelzon/`). Sabit süreler `application.yml`'de: kod 10 dk / 5 deneme, erişim 15 dk, yenileme 30 gün, silme penceresi 30 gün, en küçük yaş 13, yetişkin 18.

## API (v1)

Bütün hatalar RFC 9457 `application/problem+json`: `code` (makine), `detail` (Türkçe, gösterilebilir), `requestId`. Stack trace dönmez.

| Uç | Kimlik | Açıklama |
|---|---|---|
| `POST /api/v1/auth/email/start` `{email}` | açık | Her zaman `202 {codeValidSeconds}`; hesap olup olmadığı belli edilmez. Sınır aşılırsa `429 RATE_LIMITED` + `Retry-After`. |
| `POST /api/v1/auth/email/verify` `{email, code, deviceName?, birthYear?, displayName?, termsVersion?, privacyNoticeVersion?, marketing?}` | açık | Hesap varsa giriş, yoksa kayıt. Kayıtta alanlar eksikse kod harcanmadan `422 SIGNUP_DETAILS_REQUIRED`. 13 yaş altı `403 AGE_NOT_ALLOWED` (hiçbir şey saklanmaz). Hatalar: `OTP_INVALID`, `OTP_EXPIRED`, `OTP_TOO_MANY_ATTEMPTS`, `CONSENT_VERSION_OUTDATED`. |
| `POST /api/v1/auth/refresh` `{refreshToken}` | açık | Yenileme belirteci döner (eskisi kullanılmış olur). Kullanılmış belirteç yeniden gelirse aile iptal: `401 TOKEN_REUSED`. |
| `POST /api/v1/auth/logout` `{refreshToken}` | açık | Bu cihaz oturumunu kapatır; `204`, idempotent. |
| `GET /api/v1/me` | Bearer | Hesap: e-posta, görünen ad, doğum yılı, `ageBand` (`TEEN_13_17` / `ADULT_18_PLUS`), rol, durum. |
| `DELETE /api/v1/me` | Bearer | `202 {status: PENDING_DELETION, scheduledPurgeAt}`; bütün oturumlar kapanır; idempotent. |
| `POST /api/v1/me/restore` | Bearer (silme isteğinden **sonra** kodla giriş) | Hesabı geri alır; eski belirteçle `403 REAUTH_REQUIRED`. |
| `GET /api/v1/me/consents` | Bearer | Her türün güncel durumu (`TERMS`, `PRIVACY_NOTICE`, `MARKETING`). |
| `POST /api/v1/me/consents` `{type, version, granted}` | Bearer | Yeni satır ekler (güncellenmez). Koşullar/aydınlatma geri çekilemez (yolu hesap silme). |
| `GET /api/v1/me/consents/history?page=&size=` | Bearer | Sayfalı geçmiş (`size` en çok 100). |
| `GET /actuator/health` | açık | Yalnızca `UP/DOWN`. Diğer actuator uçları kapalı. |

Silinmek üzere olan hesap `/me`, `/me/restore` ve `DELETE /me` dışında `403 ACCOUNT_PENDING_DELETION` alır.

## Testler

```bash
export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
mvn -B verify
```

Entegrasyon testleri tek PostgreSQL konteyneri (Testcontainers) ve kontrollü saatle (`MutableClock`) çalışır; e-posta sahte `MailPort` ile yakalanır. `MailpitSmokeTest` gerçek bir Mailpit konteynerine SMTP ile gönderir.
