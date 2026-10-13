# H-037: Backend çekirdek

- **Durum:** Devam ediyor (Bölüm 1 bitti ve gönderildi; Bölüm 2: veri)
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
2026-10-12 (H-054'ten): Kabul kriterlerine ek: filtrelenen kolonlarda indeks, N+1 sorgu denetimi (test), listelerde sayfalama, nadiren değişen içerik kataloğu cevaplarına önbellek (ETag/Cache-Control), açılış süresi ölçümü.

## Kullanıcı kararı: giriş yöntemi (2026-10-13)
**E-postaya tek kullanımlık kod (parolasız).** Parola tutulmaz; her girişte e-postaya 6 haneli kod gider. Apple ve Google ile giriş geliştirici hesapları açılınca H-044'te eklenir (Google eklenirse App Store kuralı gereği Apple da). Yerelde e-posta, projeye ait yerel test posta kutusuyla (Mailpit, kendi docker-compose servisi) doğrulanır.

## İki bölümde yapılır
- **Bölüm 1 (kimlik):** e-posta kodu ile kayıt/giriş, oturum (kısa ömürlü erişim + dönen yenileme belirteci), kullanıcı, rızalar (yalnız ekleme), denetim kaydı (IP/port/saat), 30 gün geri alınabilir hesap silme (`PENDING_DELETION`), hız sınırı, ProblemDetail.
- **Bölüm 2 (veri):** içerik kataloğu API'si (ETag/önbellek), ilerleme ve öğrenme olayı eşitleme (idempotent `client_event_id`), indeksler, sayfalama, N+1 denetimi.
- Hesap silme durum adı: **`PENDING_DELETION`** (şartname §10'daki `DELETION_PENDING` notu bu karara göre kapanır).

## Doğrulama: Bölüm 1 (kimlik) — 2026-10-13
**Yapılan:** `auth` (e-posta kodu, JWT + dönen yenileme belirteci, hız sınırı, SMTP `MailPort`), `user` (`/me`, silme, geri alma, kalıcı silme işi), `consent` (yalnız ekleme), `audit` (`audit_log`), `common` (ProblemDetail, istek kimliği, sır doğrulama, sayfalama yardımcısı). Migration `V2__identity_core.sql`. Mailpit `docker-compose.yml`'de (SMTP 127.0.0.1:1027, arayüz 127.0.0.1:8027; 1025/1026 ve 8025/8026 başka projelerde). Ayarlar `backend/README.md` ve kök `README.md`'de.

**Testler:** `cd backend && mvn -B verify` → **44 test, 0 hata, BUILD SUCCESS** (11 sınıf): OtpFlowTest 14 (kayıt, giriş, numaralandırma yok, kod düz metin değil, 5 denemede kilit, 10 dk süre, e-posta 5/sa ve IP 20/sa sınırı, 13 yaş altı hiçbir şey saklamaz, doğrulama hataları, eski sürüm), TokenFlowTest 7 (dönme, yeniden kullanımda aile iptali, çıkış idempotent, 30 gün / 15 dk süreler, yenileme sınırı), ConsentFlowTest 4 (veritabanı UPDATE/DELETE/TRUNCATE reddi dahil), AccountDeletionTest 3 (silme → bekleme → yeni kodla geri alma; 30 gün dolunca kalıcı silme, idempotent, denetim anonim kalır), AuditPrivacyTest 2 (DEBUG loglarda ve tablolarda e-posta/kod/belirteç yok), MeQueryCountTest 2 (N+1 denetimi), ProblemDetailTest 3, HealthEndpointTest 4, SecretsValidatorTest 3 (prod'da sır yoksa başlamaz), PageParamsTest 1, MailpitSmokeTest 1 (gerçek Mailpit konteyneri).

**Elle akış** (geliştirme profili, yerel PostgreSQL 5435, Mailpit 8027; çıktı `.yerel/h037/flow-output.txt`, git dışı): start 202 → kayıt bilgisi olmadan 422 `SIGNUP_DETAILS_REQUIRED` → Mailpit'ten okunan kodla kayıt 200 → `/me` 200 (`ADULT_18_PLUS`) → rızalar 200 (ticari ileti `false`) → refresh 200 → eski belirteçle refresh 401 `TOKEN_REUSED` → logout 204 → yeni kodla giriş 200 → `DELETE /me` 202 `PENDING_DELETION` (+30 gün) → eski belirteçle geri alma 403 `REAUTH_REQUIRED` → yeni kodla giriş 200 (`accountStatus: PENDING_DELETION`) → `/me/restore` 200 `ACTIVE` → belirteçsiz `/me` 401 `UNAUTHORIZED`. Uygulama logunda e-posta adresi 0 kez geçti. Uygulama durduruldu; compose servisleri açık bırakıldı.

**Not:** Bu makinede 127.0.0.1:5434 başka bir projenin konteynerinde (`velzon-postgres`); hiVelzon PostgreSQL'i `HIVELZON_PG_PORT=5435` ile çalışıyor. Dokunulmadı.

**Açık sorular (kullanıcıya):**
- Yaş yalnızca doğum yılından hesaplanıyor (bu yıl − doğum yılı): yıl içinde 13'üne girecek biri yılın başında kabul edilir. Ay da sorulsun mu? (Hukuk teyidi H-002 ile birlikte.)
- Kullanım koşulları / KVKK aydınlatma / ticari ileti metin sürümleri şimdilik `taslak-1`; metinler yazılınca ortam değişkeninden güncellenir.
- 13 yaş altı denemede kod isteğinin denetim satırı (`OTP_START`, kişiye bağlanmayan IP/port) ve hız sayaçları kalır; başka hiçbir şey saklanmaz. Uygun mu?
- Üretim e-posta sağlayıcısı (SMTP) H-044'te seçilecek.
2026-10-13 (ana oturum): Bölüm 1 doğrulandı (mvn verify 44/44). Kullanıcı kararları: yaş kontrolü yalnız doğum yılıyla kalır; yerel PostgreSQL varsayılan portu 5435 (5434 başka projede); Bölüm 1 commit + push, sonra Bölüm 2. Kullanıcı ayrıca "13 yaş sınırı kaldırılsın" dedi → H-002 kararını değiştirir; sonuçları kullanıcıya soruldu (karar bekliyor).
