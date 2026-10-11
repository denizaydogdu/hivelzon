# WishSay Desen Raporu (H-021)

- **Tarih:** 2026-10-11
- **İş:** H-021 — WishSay desenlerinin incelemesi (araştırma, kodsuz)
- **İncelenen depo:** `~/Dev/wishsay`, `main` dalı, HEAD `d99fe1a` ("W-069: İnceleme düzeltmeleri dalını birleştir", 2026-10-11 16:39).
- **Yöntem:** Yalnızca okuma (`ls`, `cat`, `grep`, `find`, `git log`, `git show`). WishSay'de hiçbir dosya değiştirilmedi. Build, test, migration ya da sunucu çalıştırılmadı.
- **Dikkat:** İnceleme sırasında WishSay'e W-069 birleştirmesi geldi (yeni `common/AdvisoryLocks.java`, `V13__media_upload_reservation.sql`, D-120…D-124). Satır numaraları `d99fe1a` içindir; WishSay canlı geliştirildiği için taşıma anında yeniden doğrulanmalıdır.
- **Kısaltmalar:** `B/` = `wishsay/backend/src/main/java/com/wishsay/`, `MIG/` = `wishsay/backend/src/main/resources/db/migration/`, `MOB/` = `wishsay/mobile/`.
- **Sırlar:** Depoda gerçek sır bulunmadı. Yalnızca herkese açık **geliştirme** değerleri var; değerler bu rapora kopyalanmadı. Yerleri §Riskler R-14'te.

---

## 1. Özet (10 madde)

1. **Yığın HiVelzon planıyla birebir uyumlu:** Spring Boot **4.1.1**, Java 17, Flyway, PostgreSQL 16, Testcontainers. Flutter tarafında 3.38 / Dart 3.10, Riverpod 3, go_router 17, dio 5. Kopyala-uyarla yaklaşımı (IS-PLANI §10) teknik olarak sorunsuz.
2. **Kimlik doğrulama sağlam ama eksik:** JWT HS256 (15 dk) + tek kullanımlık, SHA-256'yla saklanan opak refresh token (30 gün, çalıntı tespiti) + BCrypt. **Girişte hız sınırı ve brute-force koruması yok** (WishSay W-070 A3). Ayrıca refresh döndürmesinde yarış (A5) ve hesap keşfi riski (A4) var. Bu üç açık düzeltilmeden **aynen kopyalanmamalı**.
3. **`audit_log` en değerli desen:** Yalnızca eklemeye açık, trigger'la korunan, SHA-256 hash zincirli tablo. IP, kaynak port, User-Agent, `request_id` ve UTC (`clock_timestamp()`) tutuyor; güvenilen proxy CIDR'leri dışında `X-Forwarded-For`'a güvenmiyor. **Uyarlanarak alınmalı.** Zincir, tek bir global advisory lock'la sıraya giriyor. Bu yüzden HiVelzon'un yüksek hacimli öğrenme olaylarına **uygulanmamalı**.
4. **`user_consents` da yalnızca eklemeye açık:** Her onay ya da geri çekme yeni bir satır; güncel durum `order by id desc limit 1` ile okunuyor. SARTNAME §10'daki `granted_at/withdrawn_at` (güncellenen satır) taslağı bu desenle **çelişiyor**. WishSay deseni seçilmeli; HiVelzon'a metin hash'i ve `locale` eklenmeli.
5. **30 gün geri alınabilir silme olgun:**
   - Durum, `users` tablosundaki zaman damgalarından türetiliyor (`deletion_requested_at`, `deleted_at`).
   - Günlük UTC cron işi, keyset sayfalama kullanıyor ve hesap başına ayrı işlem açıyor.
   - Kilitten sonra durum yeniden kontrol ediliyor; böylece iş idempotent.
   - Satır silinmiyor, anonimleştirilmiş bir "mezar taşı" kalıyor.
   - SARTNAME'deki ayrı `account_deletion_requests` tablosu ve `status` enum'u bununla **çelişiyor**; karar gerekiyor.
6. **`403 SENSITIVE_CONSENT_REQUIRED` deseni `VOICE_CONSENT_REQUIRED` için aynen kullanılabilir.** Koruma, her yan etkiden önce çalışıyor ve hiçbir şey yazmıyor. Testler hem engellenen hem engellenmeyen uçları listeliyor (D-081).
7. **Hata modeli taşınmaya hazır:** RFC 9457 ProblemDetail + makinece okunur `code` + gerektiğinde ek alanlar. `type: about:blank` Spring 7'de elle verilmeli (D-032). Kodlar tek bir `ErrorCode` sınıfında toplu.
8. **Sırlar iyi yönetiliyor:** Ana `application.yml`'de sırların varsayılanı boş. Dev ve test profilleri dışında `StartupSecretsCheck` eksik, kısa (<32 bayt) ya da bilinen dev değerine eşit sırla uygulamayı **hiç açmıyor**. Aynen alınmalı; HiVelzon'un yapay zekâ ve Higgsfield anahtarları da bu listeye eklenmeli.
9. **Kopyalanmaması gerekenler:**
   - UGC'ye özgü desenler: anonimlik, takma ad HMAC'i, etiketleme, NSFW, `pre_deletion_status`.
   - 5651'e dayalı 730 günlük saklama süresi (HiVelzon'da UGC yok; hukuki dayanağı ayrıca değerlendirilmeli).
   - İç içe `REQUIRES_NEW` başarısız giriş kaydı: bağlantı havuzunu tüketiyor (W-070 A2).
   - Herkese açık CORS varsayılanı `*`.
10. **Açık güvenlik bulguları (WishSay W-070, 2026-10-11):**
    - Backend'de A1–A9 (A1 kritik, anonimlik).
    - KVKK tarafında B1–B15.
    - Flutter'da C1–C10. Bunlar: release'in debug anahtarıyla imzalanması, uygulama silinince keychain'de kalan token, release'te `http://localhost` varsayılanı, `allowBackup`.

    HiVelzon bu bulguların **düzeltilmiş** hâlini almalı. İlgili W- maddeleri §7'de tek tek eşlendi.

---

## 2. Yığın tablosu

| Katman | WishSay (gözlenen) | Kaynak | HiVelzon için not |
|---|---|---|---|
| Dil / çalışma ortamı | Java 17 | `wishsay/backend/pom.xml:18` | SARTNAME ile aynı. WebSocket ses akışı ve çok sayıda dış çağrı için Java 21'in sanal thread'leri değerlendirilebilir (açık soru S-08). |
| Çatı | Spring Boot **4.1.1** (`spring-boot-starter-parent`), webmvc, security, data-jpa, validation | `pom.xml:7-9, 45-60` | Aynen. Boot 4 = Jackson 3 (`tools.jackson.*`), D-033'e bakın. |
| JSON | Jackson 3, `spring.jackson.use-jackson2-defaults: true` | `application.yml:25-30` | Yeni projede Jackson 3 varsayılanlarıyla başlanabilir. Geriye uyum yükü yok, karar verilmeli. |
| Kimlik | jjwt 0.13.0 (HS256), BCrypt (`BCryptPasswordEncoder`, varsayılan güç 10) | `pom.xml:20, 74-90`; `B/common/SecurityConfig.java:95-98` | §3.1 |
| Veritabanı | PostgreSQL 16 (docker, port **5433**), `citext`, `pg_trgm` | `wishsay/infra/docker-compose.yml`; `MIG/V1__init.sql:1`; `MIG/V11…:8` | Port çakışmasını önlemek için HiVelzon'a **başka bir port** verilmeli (ör. 5434). İki proje aynı anda çalışabilir (D-001). |
| Migration | **Flyway** (`spring-boot-starter-flyway`, `flyway-database-postgresql`), `V1…V13` düz SQL, `ddl-auto: none` | `pom.xml:61-68`; `application.yml:9-18` | Aynen. Migration'larda bol "neden" yorumu var; aynı alışkanlık sürdürülmeli. |
| Veri erişimi | JPA (entity) + yoğun `JdbcTemplate` / `NamedParameterJdbcTemplate` (denetim, onay, yaşam döngüsü SQL'i) | `B/audit/AuditService.java`, `B/user/AccountLifecycleRepository.java` | Karma yaklaşım bilinçli: kilit sırası ve toplu SQL kontrolü için. Aynen. |
| Nesne depolama | S3 SDK + MinIO (`pgsty/minio`, sabit etiket) | `pom.xml:96-112`; D-110 | HiVelzon video/HLS + CDN için yeniden değerlendirilmeli (K-13, H-012). |
| Paket düzeni | Özellik başına paket: `audit, auth, category, comment, common, consent, dev, expectation, lang, legal, media, moderation, notification, search, tag, user` | `find B/ -type d` | SARTNAME §9.3 modül listesiyle uyumlu "modüler monolit". `identity` = WishSay `auth + user + consent`. |
| Test | JUnit 5 + Spring Boot Test + MockMvc + **Testcontainers** (`postgres:16-alpine`, MinIO). 45 test sınıfı. Her test öncesi `TRUNCATE` (denetim bayrağıyla). Colima için Maven profili. | `wishsay/backend/src/test/java/com/wishsay/IntegrationTest.java:27-55`; `TestcontainersConfiguration.java:28-34`; `pom.xml:168-196` | Aynen. D-012, D-041. |
| Mobil | Flutter 3.38, Dart ^3.10.4; `flutter_riverpod ^3.3.2`, `go_router ^17.5.0`, `dio ^5.11.1`, `flutter_secure_storage ^11.2.0`, `intl`, ARB (TR şablon). 44 birim/widget test dosyası + 7 entegrasyon testi. | `MOB/pubspec.yaml:21-52`; `MOB/README.md` | Aynen. `webview_flutter` ve ML Kit HiVelzon'da gerekmez. |
| Mobil API katmanı | `AuthInterceptor`: 401'de tek uçuşlu (single-flight) yenileme; problem+json → `ApiException`; token keychain/keystore'da | `MOB/lib/api/auth_interceptor.dart:11-20, 104-114`; `MOB/lib/api/token_store.dart:19-56` | Uyarlanır: W-070 C2, C3, C4 ve C7 düzeltilerek. |
| CI | **Yok** (`.github/` yok, başka CI dosyası yok) | `ls -a wishsay` | HiVelzon'da ilk günden basit bir CI kurulmalı (öneri). |
| Yerel altyapı | `infra/docker-compose.yml`: Postgres 16 + MinIO | — | Aynen, port farklı. |

---

## 3. Desen başına inceleme

Her desen için:
- dosya yolları,
- nasıl çalıştığı,
- veri modeli,
- HiVelzon kararı: **Aynen / Uyarlanır / Alınmaz**.

### 3.1 Kimlik doğrulama

**Dosyalar**
- `B/auth/AuthController.java:15-51`: `/api/v1/auth/{register,login,restore,refresh,logout}`
- `B/auth/AuthService.java`:
  - `register` 65-109;
  - `login` 111-121;
  - `restore` 130-154;
  - `authenticate` 167-181;
  - `refresh` 202-230;
  - `issueTokens` 247-254.
- `B/auth/JwtService.java:24-54`: HS256; en az 32 baytlık anahtar zorunlu; `iss=wishsay`, `sub=userId`, `role` claim'i.
- `B/auth/JwtAuthenticationFilter.java:45-70`: kullanıcı satırını **her istekte** veritabanından yeniden okur. Rol token'dan değil, veritabanından gelir; silinen ya da yaptırımlı hesap anında düşer.
- `B/auth/TokenHasher.java:15-28`: 32 bayt `SecureRandom` refresh token; veritabanında yalnızca SHA-256 hex hâli saklanır.
- `B/common/SecurityConfig.java:30-66`: stateless; CSRF, form ve basic kapalı; rol eşlemeleri satır 40-48; BCrypt satır 95-98.
- `B/user/AccountSanctions.java:29-44`: askı ve yasakta 403 (`reason`, `until`, `appealEmail`).
- Belge: `wishsay/docs/api.md:9-21`.

**Nasıl çalışır**
- **Kayıt** (`AuthService.register`), sırasıyla:
  - yaş kutusu;
  - politika sürümleri `GET /policies` ile birebir aynı mı;
  - hassas veri rızası;
  - e-posta ve handle benzersiz mi.
  Ardından onay satırları + token + `AUTH_REGISTER` denetimi yazılır.
- **Giriş:**
  - Her başarısızlık aynı `401 INVALID_CREDENTIALS` döner; gerçek neden yalnızca denetim kaydına yazılır.
  - Askı, yasak ve silme bekleyişi **şifre doğrulandıktan sonra** açıklanır (D-020).
- **Refresh:** tek kullanımlıktır. İptal edilmiş bir token yeniden gelirse kullanıcının **tüm** refresh token'ları iptal edilir (`AUTH_REFRESH_REUSE_DETECTED`). Kasıtlı iptaller (silme, yasak) bu kontrolden önce ayıklanır (D-071).
- **Hız sınırı:** Yalnızca yorum (30/10 dk) ve medya (20/10 dk) uçlarında var. Sayım veritabanından yapılıyor ve kullanıcı başına advisory lock'la sıraya giriyor (`B/comment/CommentService.java:355`, `B/common/AdvisoryLocks.java:17-27`, D-120). **Giriş, kayıt, refresh ve restore uçlarında hız sınırı ya da hesap kilitleme yok.**

**Veri modeli** (`MIG/V1__init.sql:3-28`, `V3`, `V8`)
- `users(id uuid PK default gen_random_uuid(), email citext UNIQUE, password_hash varchar(100), handle varchar(64) UNIQUE, locale CHECK tr|en, allow_tagging, default_anonymous, role CHECK USER|MODERATOR|LEGAL, age_confirmed_at, created_at, deleted_at, deletion_requested_at, suspended_until, banned_at, sanction_reason)`
- `refresh_tokens(id uuid PK, user_id FK CASCADE, token_hash varchar(64) UNIQUE, created_at, expires_at, revoked_at)`

**Karar: Uyarlanır.**

Aynen alınacaklar:
- JWT + opak refresh tasarımı;
- token hash'leme;
- her istekte kullanıcıyı yeniden okuma;
- "durumu şifreden sonra açıkla" kuralı;
- tekdüze 401.

Düzeltilerek alınacaklar (W-070):
- **A3:** Giriş, kayıt, refresh ve restore için IP ve e-posta başına hız sınırı + artan bekleme. `LoginRequest.email` alanına `@Size(max=254)` eklenmeli (`B/auth/AuthDtos.java:32` sınırsız; değişmez denetim tablosuna MB'larca veri yazılabiliyor).
- **A4:** E-posta bilinmiyorsa da sahte bir BCrypt karşılaştırması yapılmalı (zamanlama farkı kapanır). Kayıtta `409 EMAIL_TAKEN` hesap keşfine yol açıyor; W-071'deki "aynı yanıt + mevcut adrese bilgi e-postası" deseni izlenmeli.
- **A5:** Refresh döndürmesi koşullu güncellemeyle yapılmalı: `update … set revoked_at=now() where id=? and revoked_at is null`, ardından etkilenen satır sayısı kontrol edilir.
- **A2:** Başarısız girişin denetim kaydı iç içe `REQUIRES_NEW` ile yazılmamalı; havuz tükenmesine yol açıyor.
- **E-posta doğrulaması** (W-071, henüz yapılmadı): HiVelzon'da ilk sürümden itibaren olmalı. Çocuk kullanıcı ve veli onayı ihtimali düşünüldüğünde ayrıca önemli.
- **Hesap kurtarma (parola sıfırlama):** WishSay'de **yok**. SARTNAME §12.4 istiyor, sıfırdan tasarlanmalı.

HiVelzon'da alınmayacaklar:
- `handle` (sosyal özellik yok, veri minimizasyonu);
- `allow_tagging`, `default_anonymous`.

### 3.2 `user_consents` ve politika sürümü

**Dosyalar**
- `MIG/V2__audit_and_consents.sql:113-137`: tablo + değişmezlik trigger'ları
- `MIG/V9__sensitive_data_consent.sql:7-10`: yeni tür eklemek için CHECK genişletme kalıbı
- `B/consent/ConsentType.java:4-20`: `AGE_13_PLUS, CONTENT_POLICY, PRIVACY_NOTICE, ALLOW_TAGGING, SENSITIVE_DATA_PUBLICATION`
- `B/consent/ConsentService.java`:
  - `versionFor` 44-49;
  - `record` 51-60;
  - `latest` 67-75;
  - `setSensitiveDataConsent` 105-121.
- `B/consent/PolicyController.java:17-20`: herkese açık `GET /api/v1/policies`
- `application.yml:67-69`: sürümler ortam değişkeninden gelir, tarih biçiminde (`YYYY-MM-DD`)

**Nasıl çalışır**
- Her onay kutusu ayrı bir satırdır. Geri çekme `granted=false` olan yeni bir satırdır. Güncel durum en son satırdır (`order by id desc limit 1`, D-080).
- Satırla birlikte IP, port, User-Agent ve `request_id` de yazılır.
- Ayrı uçtan verilen onay önce kullanıcı satırını `FOR NO KEY UPDATE` ile kilitler (D-050, D-073). Değişiklik yoksa hiçbir şey yazılmaz (idempotent). Aynı onay yeni bir politika sürümüyle verilirse yeniden yazılır.
- Kayıtta istemci, gösterdiği sürümü gönderir. Sunucunun sürümüyle eşleşmezse `400 POLICY_VERSION_MISMATCH` döner.
- Saklama: Aktif hesabın onayları **hiç** silinmez. Silinen hesabınkiler `users.deleted_at + 730 gün` sonra silinir (W-043, `B/audit/AuditRetentionService.java:65-72`).

**Veri modeli**
- `user_consents(id bigserial PK, user_id uuid NOT NULL — kasıtlı olarak FK yok, consent_type text CHECK(...), policy_version text, granted boolean, ip inet, source_port int, user_agent text ≤512, request_id text, created_at timestamptz default clock_timestamp())`
- İndeksler: `(user_id, created_at)` ve `(created_at)`.

**Karar: Uyarlanır.**

Alınacaklar:
- yalnızca ekleme + "en son satır" deseni;
- FK'siz tasarım;
- değişmezlik trigger'ları;
- kilit + idempotentlik;
- `POLICY_VERSION_MISMATCH` akışı.

Değişiklikler:
- **Metin kanıtı:** `policy_version` yalnızca bir tarih; hangi metnin onaylandığını kanıtlamıyor. HiVelzon'da `document_sha256` (onaylanan metnin hash'i) ve `locale` (TR/EN metin) kolonları eklenmeli (SARTNAME §10.1: "doğrulanabilir referans").
- **Sürüm damgası (W-070 B10):** Sonradan verilen onaylar istemcinin gösterdiği sürümle değil, sunucunun güncel sürümüyle damgalanıyor. HiVelzon'da istemci her onayda sürümü göndermeli.
- **Türler:** `PRIVACY_NOTICE`, `TERMS_OF_USE`, `AGE_BAND_DECLARATION` (13+ / 18+), `VOICE_PROCESSING` (açık rıza), `PARENTAL_CONSENT` (H-002'ye bağlı), `PUSH_NOTIFICATIONS` (isteğe bağlı; işletim sistemi izni zaten ayrı).
- **`source` alanı** (SARTNAME): `REGISTRATION | SETTINGS | FEATURE_GATE` gibi bir değer eklenebilir.

### 3.3 `audit_log`

**Dosyalar**
- `MIG/V2__audit_and_consents.sql`:
  - tablo 15-40;
  - kanonik serileştirme 44-60;
  - zincir trigger'ı 65-87;
  - yalnızca-ekleme koruması 89-111.
- `MIG/V4__audit_email_index.sql:8-9`: `details->>'email'` kısmi indeksi
- `B/audit/AuditService.java`:
  - `record` / `recordAs` (`MANDATORY`) 43-53;
  - `recordFailedLogin` (`REQUIRES_NEW`) 59-62;
  - `recordIndependently` 79-83;
  - `insert` 95-107.
- `B/audit/AuditContextFilter.java:20-44`: IP, port, UA ve sunucu üretimi `X-Request-Id` (yanıt başlığına da konur)
- `B/audit/ClientIpResolver.java:24-101`: `X-Forwarded-For` yalnızca güvenilen proxy CIDR'lerinden kabul edilir; sağdan sola yürünür. Port `X-Forwarded-Port`'tan alınır.
- `application.yml:34-36`: `server.forward-headers-strategy: none` (Tomcat adresi kendi başına değiştiremez)
- `B/audit/AuditChainVerifier.java:28-56`: zinciri doğrular
- `B/audit/AuditRetentionService.java:53-81`: önek silme + `AUDIT_PURGE` satırı (sildiği son hash'i de yazar)
- `B/audit/AuditRetentionJob.java:15-18`: günlük, `zone="UTC"`
- `B/audit/AuditAction.java`: yaklaşık 53 eylem türü (enum)
- `B/legal/LegalController.java:19-40`: `LEGAL` rolü için `GET /api/v1/legal/audit` (JSON/CSV)

**Nasıl çalışır**
- Denetim satırı, iş değişikliğiyle **aynı işlemde** ve o işlemin **son yazısı** olarak yazılır. Önce `entityManager.flush()` çağrılır; amaç, advisory lock'tan sonra satır kilidi istenmemesi (deadlock önleme).
- Trigger:
  - `pg_advisory_xact_lock(5651031)` ile **tüm sistemde tek sıra** oluşturur;
  - `id` değerini kilitten sonra atar;
  - `hash = sha256(prev_hash || kanonik_satır)` hesaplar.
- `READ COMMITTED` dışındaki izolasyon seviyeleri reddedilir.
- UPDATE hiçbir zaman yapılamaz. DELETE ve TRUNCATE yalnızca `set_config('wishsay.audit_purge','on',true)` yapılmış bir işlemde mümkündür.
- Reddedilen isteklerin kaydı (hız sınırı, başarısız giriş) ayrı işlemde yazılır (D-051).

**Veri modeli**
- `audit_log(id bigserial, occurred_at timestamptz default clock_timestamp(), actor_user_id uuid, action text, target_type text, target_id text, ip inet, source_port int, user_agent text ≤512, request_id text, details jsonb, prev_hash bytea, hash bytea NOT NULL)`
- `users` tablosuna FK yok.

**Karar: Uyarlanır.**

Aynen alınacaklar:
- tablo şeması;
- `ClientIpResolver` ve `forward-headers-strategy: none`;
- `AuditContextFilter` ve `X-Request-Id`;
- "aynı işlemde, son yazı" kuralı;
- FK yokluğu;
- yalnızca-ekleme trigger'ları;
- zincir ve doğrulayıcı.

Değişiklikler:
- **Kapsam daraltılmalı.** IS-PLANI §9.4 "her yazma işlemi" diyor. Global tek kilit nedeniyle bu, öğrenme olaylarında (ilerleme ping'leri, quiz cevapları, SRS tekrarları) darboğaz olur. Öneri:
  - `audit_log` yalnızca güvenlik ve hukuk açısından anlamlı eylemleri tutsun: kimlik, onay, hesap yaşam döngüsü, yönetici eylemleri, içerik yayınlama, konuşma oturumunun açılıp kapanması, kota veya bütçe reddi;
  - öğrenme verisi `learning_events` tablosuna gitsin (ICERIK-MIMARISI §7.7; zaten "IP yazılmaz" diyor).
- **Maliyet kaydı ayrı tablo olmalı** (`ai_usage_ledger` ya da `generation_jobs.actual_cost`). `audit_log` yalnızca referans tutar.
- **Veritabanı rolleri ayrılmalı (W-042 + R-07):** Migration sahibi rol ile uygulamanın çalışma rolü ayrı olmalı. Uygulama rolünden `UPDATE/DELETE/TRUNCATE` ve trigger değiştirme yetkisi alınmalı. Saklama silmesi `SECURITY DEFINER` bir fonksiyonla yapılmalı. Zincirin son hash'i düzenli olarak dışarıya yazılmalı (dış çapa).
- **Saklama süresi:** WishSay'in 730 günü 5651 (yer sağlayıcı / UGC) gerekçesine dayanıyor. HiVelzon'da kullanıcı içeriği yok; süre hukukçuyla yeniden belirlenmeli (S-03).
- **`details` içeriği:** Token, parola, transkript, prompt ve ses kesinlikle yazılmaz (SARTNAME §10.1). E-posta yazılıyor (WishSay: kayıt ve silme anlık görüntüsü); saklama süresine tabidir.

### 3.4 30 günlük geri alınabilir hesap silme

**Dosyalar**
- `MIG/V8__account_grace_tag_withdraw_privacy.sql:1-15`: `deletion_requested_at` + kısmi indeks; satır 39-83 eski kayıtlar için migration
- `B/user/AccountService.java:95-109`: `DELETE /me` (anlık görüntü → gizle → token'ları iptal et → `ACCOUNT_DELETE`)
- `B/user/MeController.java:34-38`
- `B/auth/AuthService.java:130-154`: `POST /auth/restore` (önce `lockIdByEmail` satır kilidi)
- `B/user/AccountDeletionPolicy.java:15-47`: `grace()`, `scheduledAt`, `isExpired`, `pendingError` (403 + `deletionScheduledAt`)
- `B/user/AccountPurgeJob.java:15-18`: `cron 0 0 4 * * *`, `zone="UTC"`, `"-"` ile kapatılır
- `B/user/AccountPurgeService.java`:
  - keyset ile toplu okuma 70-109;
  - `purgeOne` 112-135: kilit → yeniden kontrol → anonimleştir → içeriği temizle → commit sonrası medya süpürmesi → `ACCOUNT_PURGE`.
- `B/user/AccountLifecycleRepository.java:28-125`: `hide`, `restore`, `purgeContent`
- `B/user/User.java:81-98`: tek yüklem tanımları (`isDeleted`, `isPendingDeletion`, `isGone`, `isSanctionedAt`)
- `B/user/UserRepository.java:21, 28, 45`: `lockIdByEmail`, `findForUpdate`, `findDeletedIdByOriginalEmail`
- Belge: `wishsay/docs/api.md:53-73`

**Nasıl çalışır**
- **`PENDING_DELETION` bir enum değil.** Durum `deletion_requested_at IS NOT NULL AND deleted_at IS NULL` koşulundan türetilir. Hata kodu `ACCOUNT_PENDING_DELETION`'dır.
- `DELETE /me` sonrası bekleme süresinde:
  - içerik anında gizlenir;
  - token'lar iptal edilir;
  - e-posta ve handle bloke kalır.
- Doğru şifreyle giriş `403 ACCOUNT_PENDING_DELETION` döner; istemci geri yüklemeyi önerir.
- 30. günden itibaren giriş ve geri yükleme `401` döner.
- Günlük iş:
  - her hesabı ayrı işlemde işler;
  - `FOR NO KEY UPDATE` ile kilitler ve durumu yeniden kontrol eder;
  - hata olursa hesabı bir sonraki koşuya bırakır.
  Bu yüzden iş idempotent ve çok sunuculu kurulumda güvenlidir (D-073).
- `users` satırı **silinmez**: e-posta `deleted-<id>@deleted.invalid` olur, handle `deleted_<id>`, parola rastgele bir hash; `deleted_at` yazılır.
- `audit_log` ve `user_consents` silinmez.
- Silinen bir hesaba ait sonraki giriş denemeleri, denetim kaydındaki `ACCOUNT_DELETE` anlık görüntüsü üzerinden hesaba bağlanır (W-046, D-030).

**Veri modeli**
- `users.deletion_requested_at`, `users.deleted_at`
- `idx_users_deletion_pending (deletion_requested_at, id) WHERE … AND deleted_at IS NULL`
- İçerikte `pre_deletion_status`

**Karar: Uyarlanır.**

Aynen alınacaklar:
- zaman damgasından türetilen durum;
- politika sınıfı;
- günlük UTC cron + keyset + hesap başına işlem + kilitten sonra yeniden kontrol;
- anonimleştirilmiş mezar taşı satırı;
- denetim anlık görüntüsü;
- `403 ACCOUNT_PENDING_DELETION` + `restore` akışı.

Değişiklikler:
- **`pre_deletion_status` gizleme adımı gerekmez.** HiVelzon'da başkalarına görünen kullanıcı içeriği yok. Bekleme süresinde yapılacaklar:
  - hesabı kilitlemek;
  - kişiselleştirme, bildirim ve konuşma işlemlerini durdurmak.
- **Kalıcı silme adımı** (IS-PLANI §9.4 ve ICERIK §7.7):
  - `learning_events`, `user_content_progress`, `srs_cards`, `srs_review_log`, `user_skill_estimates`, `user_level_history`, `speaking_sessions`, `speaking_turns`, `usage_quotas`, `refresh_tokens` **silinir**;
  - yalnızca anonim madde istatistikleri kalır.
  - Partition'lı `learning_events` için `DELETE … WHERE user_id=?` bütün partition'ları tarar; indeks planı buna göre yapılmalı.
- **Silme tetikleyicisi** UTC'de ve "son gün" tanımı WishSay'dekiyle aynı olmalı (`!scheduledAt.isAfter(now)` ise süre dolmuştur).
- **B8 dersi:** Kalıcı silme, serbest metin alanlarını da temizlemeli (WishSay `sanction_reason`'ı unutuyor).
- **B13 dersi:** Süresi dolmuş refresh token satırları da periyodik olarak silinmeli.

### 3.5 Hassas veri rızası yoksa `403 …_CONSENT_REQUIRED`

**Dosyalar**
- `B/consent/ConsentService.java:91-97`: `requireSensitiveDataConsent`
- Çağrı yerleri:
  - `B/expectation/ExpectationService.java:73, 163`
  - `B/comment/CommentService.java:128, 183`
  - `B/expectation/OutcomeService.java:70`
  - `B/media/MediaService.java:127`
- `B/consent/ConsentController.java:22-32`: `POST` / `DELETE /api/v1/me/consents/sensitive-data` (204)
- `B/common/ErrorCode.java:22-26`
- İstemci: `MOB/lib/consent/sensitive_consent.dart`, `MOB/lib/consent/sensitive_consent_sheet.dart`
- Testler:
  - `wishsay/backend/src/test/java/com/wishsay/consent/SensitiveDataConsentIntegrationTest.java`
  - `MOB/test/sensitive_consent_*_test.dart`

**Nasıl çalışır**
- Koruma, gövde doğrulamasından hemen sonra ve kilit, hız sınırı, denetim gibi her yan etkiden **önce** çalışır.
- Reddedilen istek hiçbir şey yazmaz ve denetim kaydı da oluşturmaz.
- İstemci 403'ü oturumu kapatma olarak yorumlamaz. Rıza diyaloğunu gösterir, `POST` eder ve isteği tekrarlar.
- Rıza Ayarlar'dan geri çekilebilir. Geri çekmek mevcut içeriği gizlemez.

**Karar: Aynen** (yalnızca tür ve kod adı değişir).
- Kod: `VOICE_CONSENT_REQUIRED`.
- Uç: `POST|DELETE /api/v1/me/consents/voice-processing`.
- Korunan uçlar:
  - sesli konuşma oturumu başlatma;
  - ses turu gönderme;
  - telaffuz puanlama;
  - WebSocket el sıkışması.
- Metin modu bu korumaya **takılmamalı**. Test, engellenmemesi gereken uçları da açıkça listelemeli (D-081).
- 13–17 yaş kararına göre aynı desenle `PARENTAL_CONSENT_REQUIRED` gerekebilir.
- Sağlayıcıya ses gönderimi **koruma geçildikten sonra** başlamalı.

### 3.6 Rol tabanlı yönetici/moderatör paneli

**Dosyalar**
- `B/user/Role.java:4`: `USER, MODERATOR, LEGAL`
- `MIG/V2…sql:11-12`: rol CHECK kısıtı
- `B/common/SecurityConfig.java:45-47`: `/api/v1/mod/**` → `MODERATOR`, `/api/v1/legal/**` → `LEGAL`
- `B/moderation/ModController.java:29-164`: raporlar, inceleme kuyruğu, gizle/geri getir, medya onayı, askı/yasak/kaldırma, `*-author` uçları
- `B/moderation/SanctionService.java:31, 186`: moderatör ve LEGAL hesaplara yaptırım uygulanamaz
- Mobil: `MOB/lib/moderation/{mod_panel_screen,mod_detail_screen,mod_list_controller,mod_actions,mod_media}.dart`
- Rol atama: **API yok.** Rol yalnızca veritabanından ya da dev tohumundan atanıyor (`B/dev/DevSeeder.java:88-118`).

**Nasıl çalışır**
- URL öneki bazında yetki var. Metot düzeyinde güvenlik (`@PreAuthorize`) yok.
- Rol JWT'de taşınsa da her istekte veritabanından okunur, böylece rol değişikliği anında geçerli olur.
- Panel uygulamanın içinde ve yalnızca bu role görünür.

**Karar: Uyarlanır.**
- **Roller:** `USER`, `EDITOR` (içerik inceleme ve yayın), `ADMIN` (bütçe tavanı, kota, rol atama), gerekirse `LEGAL` (denetim dışa aktarımı). En az yetki ilkesi gereği bütçe ve yayın ayrılabilir.
- **Rol atama:** Denetlenen bir uç ya da yalnızca migration/CLI ile yapılmalı. Rol değişikliği `audit_log`'a yazılmalı (SARTNAME §12.4).
- **Panelin yeri:** İçerik yönetimi (ICERIK-MIMARISI §6.10 ve §9.1, K-12) mobil uygulama içinde mi, ayrı web panelinde mi olacak? Açık soru (S-05). WishSay'in mobil panel deseni yalnızca "bildirilen yapay zekâ yanıtları" gibi hafif işler için uygundur.
- **Yayın koruması:** "AI'ın yayın yetkisi yok" ve "`APPROVED` olmadan yayın yok" kuralları, WishSay'deki durum geçiş korumalarının (D-019, D-072) benzeriyle **backend'de** uygulanmalı.

### 3.7 Sırların ve ortam değişkenlerinin yönetimi

**Dosyalar**
- `application.yml:5-8, 41-47, 53-56, 90-97`: sırların varsayılanı boş (`${WISHSAY_JWT_SECRET:}` gibi)
- `application-dev.yml`, `src/test/resources/application-test.yml`: herkese açık dev ve test değerleri
- `B/common/StartupSecretsCheck.java:23-117`: `EnvironmentPostProcessor`; `META-INF/spring.factories` ile kayıtlı. `dev | test` dışında şu durumlarda açılışı durdurur:
  - JWT ya da alias sırrı eksik, 32 bayttan kısa ya da dev değerine eşit;
  - medya anahtarları eksik ya da dev değeri;
  - NSFW taraması kapalı (bu kontrol D-121'e göre bağlanmış boolean değerle yapılır);
  - veritabanı parolası boş.
- `wishsay/.gitignore`: `.env`, `*.local`, `backend/models/`
- Dersler: D-007, D-018, D-121.

**Karar: Aynen.**
- HiVelzon listesine eklenecekler:
  - `HIVELZON_JWT_SECRET`, `HIVELZON_DB_PASSWORD`;
  - LLM, STT, TTS ve telaffuz sağlayıcı anahtarları;
  - nesne depolama ve CDN imzalama anahtarı;
  - SMTP;
  - push (APNs/FCM).
- Higgsfield CLI kimliği **sunucuda değil**, içerik üretim makinesinde kalır.
- Ek öneriler:
  - Canlıda `TRUSTED_PROXIES` boşsa en azından uyarı verilmeli (W-070 B11).
  - `CORS_ORIGINS` için `*` varsayılanı kaldırılmalı. Mobil istemci CORS kullanmaz; web olmadığı için boş liste güvenli varsayılandır.

### 3.8 Hukuki metinlerin `docs/`tan uygulamaya kopyalanması

**Dosyalar**
- Kaynak metinler: `wishsay/docs/{privacy,content-policy}.{tr,en}.md`. Her birinde `_Son güncelleme: …_` satırı var (`privacy.tr.md:5`).
- `MOB/tool/sync_legal.sh:1-15`: dört dosyayı `assets/legal/` altına kopyalar.
- `MOB/pubspec.yaml`: `assets/legal/` asset olarak tanımlı.
- `MOB/test/legal_assets_test.dart:27-50`: kopya kaynakla birebir aynı mı; metindeki tarih `kBundled*PolicyVersion` ile eşleşiyor mu.
- `MOB/lib/config/app_info.dart:10-12`: istemcinin pakete gömülü sürümleri.
- Sunucu sürümleri: `application.yml:67-69`. Kayıtta eşleşmezse `POLICY_VERSION_MISMATCH` döner.
- Dersler: D-014, D-017.

**Karar: Aynen** (iki uyarıyla).
- **Sürüm üç yerde tutuluyor:** metin tarihi, istemci sabiti ve sunucu ortam değişkeni. Sunucuda sürüm yükseltilince eski uygulamalar **kayıt olamaz** (gömülü metin eski kalır). HiVelzon'da şu iki seçenekten biri seçilmeli:
  - metinler sunucudan da sunulsun (`GET /policies/{type}?locale=` + hash);
  - ya da sürüm yükseltme mağaza sürümüyle birlikte planlansın.

  Açık soru S-06.
- **HiVelzon metinleri:**
  - aydınlatma ve gizlilik;
  - kullanım koşulları;
  - `VOICE_PROCESSING` açık rıza metni;
  - veli onayı metni (gerekirse);
  - yapay zekâ şeffaflık notu.

  Test, hash'i de doğrulamalı (§3.2 `document_sha256`).

### 3.9 Hata formatı ve hata kodları

**Dosyalar**
- `B/common/ApiException.java:9-41`: `status` + `code` + ek özellikler
- `B/common/Problems.java:8-41`: `type=about:blank` (Spring 7'de elle, D-032), durumdan varsayılan kod üretimi
- `B/common/GlobalExceptionHandler.java:22-81`:
  - doğrulama hatasında `errors[{field,message}]`;
  - beklenmeyen hata loglanır, istemciye yalnızca `INTERNAL_ERROR` döner (stack trace sızmaz);
  - 413 eşlemesi;
  - framework'ün ürettiği her ProblemDetail'e `code` eklenir.
- `B/common/SecurityConfig.java:49-62`: 401 ve 403 de aynı biçimde (`TOKEN_EXPIRED` ayrımıyla)
- `B/common/ErrorCode.java:4-63`: yaklaşık 30 sabit
- Belge: `wishsay/docs/api.md:75-132`, kod tablosu
- İstemci: `MOB/lib/api/api_error.dart`, `MOB/lib/ui/error_text.dart` (kod → ARB metni)

**Karar: Aynen.**
- Genel kodlar olduğu gibi alınır: `VALIDATION_ERROR, UNAUTHORIZED, TOKEN_EXPIRED, FORBIDDEN, NOT_FOUND, CONFLICT, RATE_LIMITED, INTERNAL_ERROR, INVALID_CREDENTIALS, INVALID_REFRESH_TOKEN, POLICY_VERSION_MISMATCH, ACCOUNT_PENDING_DELETION, ACCOUNT_SUSPENDED/BANNED`.
- HiVelzon'a özgü yeni kodlar (SARTNAME §11.1):
  - `QUOTA_EXCEEDED` (429, `resetsAt` ile);
  - `BUDGET_EXCEEDED` (503; aylık tavan dolmuş, kullanıcıya nötr mesaj);
  - `CONTENT_NOT_AVAILABLE` (geri çekilmiş içerik; istemci alternatif önerir);
  - `VOICE_CONSENT_REQUIRED`;
  - `PARENTAL_CONSENT_REQUIRED`;
  - `AGE_NOT_ELIGIBLE`;
  - `EMAIL_NOT_VERIFIED`;
  - `PROVIDER_UNAVAILABLE` (503; sağlayıcı adı dönülmez);
  - `APP_UPDATE_REQUIRED`.
- `detail` İngilizce ve yalnızca hata ayıklama içindir. İstemci `code` üzerinden çevirir.

### 3.10 API versiyonlama

**Gözlem**
- Her controller'da sabit `/api/v1` öneki var (`@RequestMapping("/api/v1/…")`, örn. `B/auth/AuthController.java:16`). Ortak bir önek yapılandırması yok.
- Geriye uyumluluk politikası yazılı değil. Yalnızca istemci tarafında bir ders var: istemci eski sunucuda da çalışmalı (D-056).
- `nextCursor` opak sayfalama (`api.md:134-137`).
- "Zorunlu güncelleme" mekanizması **yok** (D-031 yalnızca ileride eklenebileceğini söylüyor).

**Karar: Uyarlanır.**
- `/api/v1` öneki korunmalı.
- Kural olarak yalnızca ekleyici değişiklik yapılmalı; alan silme ya da anlam değiştirme `v2` gerektirmeli.
- `GET /api/v1/app-config` gibi bir uçla `minSupportedVersion` dönülmeli ve `APP_UPDATE_REQUIRED` eklenmeli. İçerik uygulama güncellemesi olmadan değişeceği için (ICERIK §9.7) bu ilk sürümde gerekli.
- Bu politika `docs/api.md`'ye yazılmalı (SARTNAME §11.1, son madde).

### 3.11 ID tipi

**Gözlem**
- Varlık tabloları `uuid` kullanıyor: Postgres'te `gen_random_uuid()` (v4), Java'da `UUID.randomUUID()` (`B/user/User.java:72`). API'de UUID dizesi olarak dönüyor.
- **İstisna:** `audit_log.id` ve `user_consents.id` `bigserial`. Zincir sırası ve "en son satır" okuması için bilinçli seçilmiş.
- `categories` için doğal anahtar `slug`.
- D-040: Java'nın `UUID.compareTo` sırası Postgres'in uuid sırasıyla aynı değil (sayfalama testlerinde dikkat).

**Karar: Uyarlanır.**
- Varlıklar ve API'de UUID kullanılmalı.
- Yalnızca eklemeye açık kanıt tablolarında `bigserial` belgelenmiş bir istisna olarak kalabilir.
- ICERIK-MIMARISI §7.7 `learning_events` için **UUIDv7** öneriyor:
  - PostgreSQL 16'da yerleşik `uuidv7()` yok (PG 18'de var). Değer Java'da üretilmeli (küçük bir yardımcı ya da kütüphane).
  - v4 ve v7 aynı `uuid` tipini kullanır; SARTNAME'nin "karma kullanım yok" kuralı tip düzeyinde bozulmaz.
  - Yine de "hangi tabloda v7" sorusu yazılı bir karara bağlanmalı.

### 3.12 Zaman damgası / UTC kuralı

**Gözlem**
- Tüm kolonlar `timestamptz`.
- `hibernate.jdbc.time_zone: UTC` (`application.yml:13-16`).
- Java'da `Instant` kullanılıyor; mikrosaniyeye kırpılıyor (`truncatedTo(MICROS)`, Postgres hassasiyeti).
- Denetim zamanı `clock_timestamp()` (işlem başında donmaz).
- Kanonik hash'te UTC metin kullanılıyor.
- Cron işleri `zone = "UTC"`.
- API'de ISO-8601 UTC dizeleri (`api.md:4`).
- İstemci gösterirken `toLocal()` yapıyor (D-027).

**Karar: Aynen.**
- HiVelzon'a eklenecek tek konu: **günlük seri ve kota sınırları kullanıcının yerel gününe göre** hesaplanmalı (Europe/Istanbul ya da cihaz saat dilimi).
- Bunun için `user_profiles.timezone` (IANA) alanı gerekir. Saklama UTC'de kalır, gün sınırı hesapta uygulanır.

### 3.13 Log maskeleme

**Gözlem**
- Ayrı bir maskeleme katmanı (logback deseni, `MessageConverter` vb.) **yok**.
- Koruma disiplinle sağlanıyor: loglarda yalnızca id ve sayaç var (`grep log.` taraması). W-070 "loglarda kişisel veri yok" diyor.
- Beklenmeyen hatalar tam stack trace ile loglanıyor (`GlobalExceptionHandler.java:41`).
- Dev profilinde `com.wishsay: DEBUG`.
- `DevSeeder` dev tohum parolasını loga yazıyor (`B/dev/DevSeeder.java:113`; yalnızca dev profili).
- E-posta, kişisel veri olarak loglara değil denetim kaydının `details` alanına yazılıyor (saklama süresine tabi).

**Karar: Uyarlanır.**
- HiVelzon'da risk çok daha yüksek: transkript, prompt, sağlayıcı yanıtı ve ses. Öneriler:
  1. Sağlayıcı adaptörlerinde gövde loglaması kapalı olmalı; yalnızca `requestId`, süre, token sayısı ve maliyet loglanmalı.
  2. Logback'te `Authorization`, `refreshToken`, e-posta ve `sk-…` gibi anahtar desenleri için maskeleyici dönüştürücü kullanılmalı (ikinci savunma hattı).
  3. Stack trace'e girebilecek istisna mesajlarına kullanıcı metni konmamalı.
  4. Çökme raporlayıcıda (IS-PLANI §9.2) PII ve ekran görüntüsü kapalı olmalı.
  5. Bunu doğrulayan bir test yazılmalı: bilinen bir sır loga düşmüyor.

---

## 4. Veri modeli karşılaştırması

Karşılaştırılan kaynaklar:
- WishSay migration'ları (V1–V13);
- `SARTNAME.md` §10;
- `ICERIK-MIMARISI.md` §7.7, §9.3, §9.4.

### 4.1 Kimlik, onay ve denetim tabloları

| Konu | WishSay | SARTNAME §10 | Fark / çelişki | Öneri |
|---|---|---|---|---|
| Hesap durumu | Zaman damgalarından türetilir (`deletion_requested_at`, `deleted_at`, `suspended_until`, `banned_at`), tek yüklem (`User.isGone`) | `users.status` enum (ACTIVE, DELETION_PENDING, DELETED, SUSPENDED) | **Çelişki.** Enum ile zaman damgası çift kaynak olur (D-071). Ayrıca ad tutarsız: SARTNAME `DELETION_PENDING`, CLAUDE.md ve IS-PLANI `PENDING_DELETION`. | Zaman damgaları esas olsun. İstenirse `status` üretilmiş (generated) kolon ya da yalnızca API alanı olsun. Tek ad seçilsin: `PENDING_DELETION` (hata kodu `ACCOUNT_PENDING_DELETION` ile uyumlu). |
| Silme talebi | `users.deletion_requested_at` kolonu + denetim satırları (geçmiş) | Ayrı `account_deletion_requests` tablosu (requested, scheduled, cancelled, completed, status) | **Çelişki / fazlalık.** Geçmiş WishSay'de `audit_log`'da (`ACCOUNT_DELETE`, `ACCOUNT_RESTORE`, `ACCOUNT_PURGE`). | MVP'de kolon + denetim yeterli. "Kullanıcıya talep durumunu göster" (SARTNAME §12.2) kolonla karşılanır. Ayrı tablo yalnızca birden çok talep geçmişi gerekirse açılmalı. |
| `users` alanları | `email citext`, `password_hash`, `handle`, `locale`, `role`, `age_confirmed_at`, `created_at` + durum | `id`, `email`, `status`, `created_at`, `updated_at`, `last_login_at` | SARTNAME'de `role`, `locale`, yaş alanı ve `password_hash` yok. `last_login_at` WishSay'de yok (denetim kaydından türetilir). `handle` HiVelzon'da gereksiz. | Eklenmeli: `role`, `locale`, `age_band` ya da `birth_year` (13–17 kuralları için; minimizasyon gereği doğum tarihi değil), `email_verified_at`, `timezone` (profilde de olabilir). `last_login_at` isteğe bağlı (kişisel veri; gerekli mi?). |
| Refresh token | `refresh_tokens` (hash, `expires_at`, `revoked_at`) | **Yok** | Eksik | Eklenmeli. Süresi dolanlar 30 gün sonra silinsin (W-070 B13). |
| `user_consents` | Yalnızca ekleme; `granted boolean` satır başına; `policy_version`; IP/port/UA/`request_id`; FK yok; `id bigserial` | `granted_at`, `withdrawn_at` (güncellenen satır izlenimi), `document_version`, `locale`, `source`, "doğrulanabilir referans" | **Çelişki:** güncellenen satır ile yalnızca ekleme. SARTNAME'de IP/UA yok. WishSay'de `locale` ve metin hash'i yok. | WishSay deseni + SARTNAME'nin `locale`, `source` ve `document_sha256` alanları. `withdrawn_at` yerine `granted=false` satırı. |
| Denetim | `audit_log` (`action`, `actor_user_id`, `target_type/id`, `details jsonb`, `request_id`, hash zinciri) | `audit_events` (`actor_id`, `event_type`, `occurred_at`, `metadata`) | Ad farkı. SARTNAME'de hash zinciri, `target` ve `request_id` yok. Kavram aynı. | `audit_log` adı ve WishSay şeması kullanılsın. SARTNAME'nin "IP kişisel veridir, erişim ve saklama kısıtlanır" ve "`metadata`'da token, transkript yok" kuralları eklensin. |
| Roller | `users.role` CHECK (`USER`, `MODERATOR`, `LEGAL`) | Tanımlı değil ("least privilege") | Eksik | `USER`, `EDITOR`, `ADMIN` (+ gerekirse `LEGAL`). Rol değişikliği denetlenir. |
| Yaş | `age_confirmed_at` + `AGE_13_PLUS` onay satırı (yalnızca kutu, W-028) | §12.3 "13+", IS-PLANI §9.2 "13 altı kayıt yok; 13–17 konuşma kısıtlı" | WishSay'in tek kutusu 13–17 ayrımını yapamaz | Yaş bandı beyanı + onay türü. Veli onayı akışı H-002'ye bağlı. |

### 4.2 Öğrenme, içerik ve maliyet tabloları

| Konu | WishSay | SARTNAME §10 | Fark / çelişki | Öneri |
|---|---|---|---|---|
| ID | UUID v4 + `bigserial` (kanıt tabloları) | "UUID veya mevcut projede standart olan; karma yok" | ICERIK §7.7 `learning_events` için UUIDv7 diyor | UUID (v4 genel, v7 yüksek hacimli ekleme tabloları). `bigserial` istisnası belgelensin (§3.11). |
| Zaman | `timestamptz`, UTC, mikrosaniye | UTC saklama, yerel gösterim | Uyumlu | Aynen + `timezone` ile yerel gün sınırı (§3.12). |
| Öğrenme olayları | Karşılığı yok (WishSay'de her yazma `audit_log`'a gidiyor) | `quiz_attempts`, `learning_progress` vb. ayrı tablolar | ICERIK §7.7'de tek `learning_events` (yalnızca ekleme, aylık partition, `client_event_id` UNIQUE). | **Teknik çelişki:** PostgreSQL'de partition'lı tabloda UNIQUE kısıt partition anahtarını (`occurred_at`) içermek zorunda. Tek başına `client_event_id UNIQUE` kurulamaz. Seçenekler: `(client_event_id, occurred_at)` (istemci zamanı sabitse), ayrı bir idempotentlik tablosu, ya da partition'sız başlayıp hacim gelince bölmek. **Karar gerekli.** |
| Denetim kapsamı | "Her yazma işlemi `audit_log`'a" (WishSay CLAUDE.md) | — | IS-PLANI §9.4 aynı kuralı HiVelzon'a taşıyor; global zincir kilidiyle ölçeklenmez | Kapsam daraltılsın (§3.3). Öğrenme yazıları `learning_events`'e. |
| İlerleme | — | `learning_progress(user_id, lesson_id, …)`: sürümsüz | ICERIK §9.4: `user_content_progress(user, content_id, version_id)` | **Çelişki.** ICERIK'in sürümlü modeli seçilmeli; SARTNAME güncellenmeli. |
| İçerik sürümü | — | `stories.content_version` alanı + `status`, `review_status`, `translation_status` | ICERIK §9.4: `content` + değişmez `content_version` + `published_version_id`. §9.3: `DRAFT → IN_REVIEW → APPROVED → SCHEDULED → PUBLISHED → ARCHIVED` + `WITHDRAWN`. | **Çelişki.** Üç ayrı durum kolonu yerine tek durum makinesi + kontrol listesi. SARTNAME tablosu ICERIK'e göre yeniden yazılmalı (K-05). |
| Kelime | — | `vocabulary_items` + `user_vocabulary(review_due_at, last_result, review_count)` | ICERIK §7.7: `srs_cards(stability, difficulty, due_at, reps, lapses)` + `srs_review_log` (FSRS) | **Çakışma.** `user_vocabulary` ile `srs_cards` aynı şey. FSRS alanlarıyla tek tablo (K-04). Kelime kaydı `lemma`'ya bağlı, sürüme değil (ICERIK §9.4). |
| Konuşma ve maliyet | — | `speaking_sessions` (`provider`, `model`, `quota_units`, `retention_until`), `usage_quotas` (atomik) | IS-PLANI §9.4 "AI oturum maliyeti `audit_log`'a" diyor | Maliyet ayrı tabloda/ledger'da. `audit_log`'a yalnızca oturum açma/kapama + referans. Atomik kota için WishSay'in `AdvisoryLocks` + "say, sonra yaz aynı kilit altında" deseni (D-120) doğrudan kullanılabilir. |
| Üretim işleri | — | `generation_jobs` (`approved_by`, `estimated/actual_cost`, `external_job_id`) | WishSay'de yok; videoGenerator `job/JobPipeline` + `BudgetGuard` (CLAUDE.md) | videoGenerator deseni (H-022). `external_job_id` UNIQUE ile çift ücret koruması. |
| Saklama | Denetim 730 gün; onay hesaba bağlı (aktifken süresiz, silmeden 730 gün sonra) | Tablo bazında belgelenir | ICERIK §7.7: ham olaylar 12 ay, özetler hesap silinene kadar, periyodik imha ≤ 6 ay | Saklama ve imha politikası tablosu `docs/`ta tek yerde tutulmalı. Onay saklama kuralı (W-043) aynen. |

---

## 5. HiVelzon için önemli WishSay dersleri (`wishsay/ogrenilenler/`)

Toplam 80 ders tarandı. HiVelzon'u doğrudan ilgilendirenler aşağıda. UGC'ye, panoya, ML Kit'e ve NSFW'ye özgü olanlar dışarıda bırakıldı.

### 5.1 Ortam

| D- | Ders | HiVelzon'da uygulanışı |
|---|---|---|
| D-001 | Port 5432 yerel Homebrew Postgres'e ait; WishSay 5433'te | HiVelzon için ayrı port (öneri 5434) ve ayrı container adı |
| D-003 | Her zaman `./mvnw` | Aynen |
| D-012 | Colima + Testcontainers için `DOCKER_HOST` Maven profili | `pom.xml` profili aynen kopyalanır |
| D-013, D-033 | start.spring.io yalnızca 4.x sunuyor. Boot 4 = Jackson 3 (`tools.jackson.*`); `jjwt-jackson` Jackson 2 getiriyor; sürüm değişince `clean verify` | Aynen |
| D-022, D-029 | Migration içeren dal ve e2e için ayrı veritabanı; dev tohumu yalnızca boş veritabanında | Aynen |

### 5.2 Güvenlik

| D- | Ders | HiVelzon'da uygulanışı |
|---|---|---|
| D-007, D-018 | Sırlar ortam değişkeninde; varsayılan yalnızca dev/test profilinde; `StartupSecretsCheck` ile açılışta hızlı hata | Aynen (§3.7) |
| D-121 | Güvenlik bayrağı, Spring'in bağladığı boolean değerle kontrol edilir (`0/off/no` da false) | Örneğin "ses saklama kapalı olmalı" gibi bayraklarda |
| D-008, D-030 | Varlık sızdırmayan tekdüze hata; ayrım yalnızca denetim kaydına | Giriş, kayıt ve parola sıfırlamada |
| D-020, D-071 | Kilit ve silme durumu şifreden sonra açıklanır. 403 (401 değil) → istemci yenilemeye çalışmaz. Kasıtlı iptaller hırsızlık kontrolünden önce ayıklanır. Hesap durumu tek yüklemde tanımlanır. | Aynen |
| D-019 | Onay belirli bir metne aittir; metin değişince onay düşer | Politika ve rıza sürümleri; `document_sha256` |
| D-051 | Reddedilen isteğin denetim kaydı kendi işleminde (bağlantı havuzu riskine dikkat, W-070 A2) | Kota ve bütçe reddi |
| D-120 | "Say, sonra yaz" sınırı yarışa açık; sayım ve yazma aynı advisory lock altında | **Günlük konuşma kotası ve aylık bütçe tavanı** için doğrudan |
| D-112 | Güvenilmeyen görsel yalnızca saf Java çözücüye verilir, bellek ölçülür | Kullanıcı yüklemesi yok; ses girişinde benzer ilke (boyut ve süre sınırı, güvenli çözücü) |

### 5.3 Mimari

| D- | Ders | HiVelzon'da uygulanışı |
|---|---|---|
| D-021 | Başkasının kaydına kişisel veri kopyalanmaz; id saklanır, okurken çözülür | Bildirimler, ders sonu özetleri |
| D-050, D-073 | Durum kilidi `FOR NO KEY UPDATE`; kilit, okumadan önce alınır; her yolda aynı sıra | Silme, restore, rıza, kota |
| D-080 | Yalnızca eklemeye açık onayda güncel durum = en son satır (kilit altında, `id` sırası) | `user_consents` |
| D-062 | Geriye dönük doldurma: durum satırı + keyset + tek özet denetim | Seviye ve beceri yeniden hesaplamaları |
| D-113, D-122 | İki sistemli yazma: önce kayıt, sonra nesne; depo silmesi commit'ten sonra ve tekrarlanabilir; anahtar kimlik taşımaz | Video ve ses varlıkları, hesap silmede nesneler |
| D-123 | İmzalı URL önbellek anahtarı olmaz | HLS/CDN imzalı URL'ler ve Flutter önbelleği |
| D-056 | Backend'den önce yazılan istemci eski sunucuda da çalışmalı (null olabilir alanlar, 404 → nazik durum) | Uygulama güncellemesiz içerik akışı |
| D-032, D-100 | ProblemDetail `type` elle; `NON_NULL` DTO'da "null olabilir" alan `ALWAYS` ister | Aynen |
| D-118 | Multipart gövde tek kullanımlık; 401 sonrası tekrar denemede `FormData.clone()` | Ses yüklemesi |
| D-124 | Metni UTF-16 uzunluğunda kesme; sunucunun saydığı birimle ve grafem sınırında kes | Sohbet metin girişi |

### 5.4 Test ve süreç

| D- | Ders | HiVelzon'da uygulanışı |
|---|---|---|
| D-017 | Elle kopyalanan dosya betikle kopyalanır ve testle kaynağına eşit tutulur | Hukuki metinler; ileride içerik manifestleri |
| D-081 | Yazma koruması: engellenen ve engellenmeyen uç listeleri testte | `VOICE_CONSENT_REQUIRED`, `EMAIL_NOT_VERIFIED` |
| D-040, D-041 | UUID sırası Java ve Postgres'te farklı; referans tabloları testte temizlenmez | İçerik kataloğu tohumları |
| D-014 | Politika metni yazmak ürün açıklarını ortaya çıkarır; metin kodun gerçekte yaptığını anlatmalı | Aydınlatma metni + ses rızası |
| D-011, D-042 | Ajan raporu bağımsız doğrulanır; ajan aynı dizinde çalışırken commit yol listesiyle sınırlanır | HiVelzon iş akışında da |
| D-027 | Sunucu UTC gönderir, istemci `toLocal()` ile gösterir; serbest JSON'da `v is T ? v : null` | Aynen |

---

## 6. Riskler

| # | Risk | Kaynak | Etki | Öneri |
|---|---|---|---|---|
| R-01 | **Girişte hız sınırı ve kilitleme yok.** `LoginRequest.email` boyutsuz. | W-070 A3/B2; `B/auth/AuthDtos.java:32` | Kaba kuvvet saldırısı; değişmez denetim tablosuna büyük veri yazılması | HiVelzon'da ilk günden IP ve e-posta başına sınır + `@Size`. Kopyalanırken düzeltilmeli. |
| R-02 | Başarısız giriş kaydı iç içe `REQUIRES_NEW` → istek başına 2 bağlantı; ~10 eşzamanlı yanlış girişle havuz tükeniyor | W-070 A2/B3; `B/audit/AuditService.java:59-73`; `B/auth/AuthService.java:257-261` | Kimlik doğrulaması gerektirmeyen DoS | Deseni **aynen kopyalamayın**. Kaydı işlem dışında, rollback sonrası tek bağlantıyla yazın ya da havuz ve sınırla koruyun. |
| R-03 | Refresh döndürmesi yarışa açık (iki paralel istek → iki geçerli zincir) | W-070 A5; `B/auth/AuthService.java:202-230` | Çalıntı tespiti atlanabilir | Koşullu `UPDATE … WHERE revoked_at IS NULL` + satır sayısı kontrolü |
| R-04 | Hesap keşfi: bilinmeyen e-postada BCrypt çalışmıyor; kayıtta `409 EMAIL_TAKEN`; e-posta doğrulaması yok | W-070 A4; W-071 (yapılmadı) | Kayıtlı e-postalar tespit edilebilir; başkasının adresiyle kayıt | Sahte hash karşılaştırması + W-071 deseni (doğrulama kodu, tekdüze yanıt) |
| R-05 | Flutter release Android'de debug anahtarıyla imzalanıyor; release'te `http://localhost` varsayılanı; iOS `NSAllowsLocalNetworking` her yapılandırmada açık; `allowBackup` | W-070 C1, C5, C6 | Mağaza ve güvenlik sorunu | HiVelzon iskeletinde release imzası yoksa derleme **başarısız olsun**; `https` zorunlu; ATS istisnası yalnızca debug'da; `allowBackup=false` |
| R-06 | Keychain token'ı uygulama silinip yeniden kurulunca kalıyor → eski kullanıcıyla otomatik giriş, 13+ onboarding atlanıyor. Yenileme sırasında çıkış oturumu geri getiriyor. Refresh'teki her 4xx oturumu kapatıyor. | W-070 C2, C3, C4, C7; `MOB/lib/api/token_store.dart:21` (varsayılan seçenekler) | Çocuk kullanıcıda yanlış hesapla oturum; yaş kapısının atlanması | `first_unlock_this_device` + ilk açılış işaretiyle keychain temizliği + oturum nesil sayacı. **`token_store.dart` ve `auth_interceptor.dart` aynen kopyalanmamalı.** |
| R-07 | Denetim tablosunun yalnızca-ekleme koruması yalnızca uygulama hatalarına karşı. `wishsay.audit_purge` GUC'unu herhangi bir bağlantı açabiliyor; tablo sahibi rol trigger'ı kapatabiliyor. Dış çapa yok. | W-042 (açık); `MIG/V2…sql:89-103`; `IntegrationTest.java:47-50` | İçeriden değiştirme kanıtlanamaz | Ayrı DB rolleri, `REVOKE`, `SECURITY DEFINER` silme, son hash'in dışarıya yazılması |
| R-08 | Global tek advisory lock'lu zincir her denetim yazısını sıraya sokuyor; `READ COMMITTED` zorunlu | `MIG/V2…sql:65-83` | Yüksek yazma hacminde gecikme | Denetim kapsamını daraltın (§3.3). Öğrenme olaylarını ayrı tabloya alın. |
| R-09 | Sonradan verilen onaylar sunucunun sürümüyle damgalanıyor, istemcinin gösterdiğiyle değil. Sürüm 3 yerde. Sürüm yükselince eski uygulama kayıt olamıyor. | W-070 B10; §3.8 | Onay kanıtı zayıflar; kayıt kesintisi | İstemci sürüm + hash göndersin; politika metinleri sunucudan da sunulsun (S-06) |
| R-10 | Kalıcı silmede serbest metin (`sanction_reason`) ve süresi dolmuş refresh token'lar kalıyor | W-070 B8, B13 | Saklama ilkesine aykırı | HiVelzon purge listesinde serbest metin ve token temizliği |
| R-11 | Proxy arkasında `trusted-proxies` boşsa tüm kayıtlara proxy IP'si yazılır | W-070 B11; `application.yml:63-66` | Denetim kaydı değersizleşir | Canlıda boşsa açılış uyarısı/hatası; dağıtım kontrol listesine madde |
| R-12 | CI yok; testler yalnızca yerelde ve elle | `wishsay/` (`.github` yok) | Gerilemeler fark edilmez | HiVelzon'da ilk commit'ten itibaren `./mvnw verify` + `flutter analyze/test` CI'ı |
| R-13 | 730 günlük denetim saklaması 5651'e (UGC, yer sağlayıcı) dayanıyor. Yurt dışı sunucu kararı (W-066) m.9 yükü getiriyor. | `AuditRetentionService.java:20-22`; W-066 | HiVelzon'a doğrudan taşınırsa gereksiz uzun saklama | Hukukçuyla HiVelzon'a özgü süre (S-03, S-04) |
| R-14 | **Depodaki dev sır değerleri** (herkese açık, işe yaramayan dev değerleri; gerçek sır değil): `wishsay/backend/src/main/resources/application-dev.yml`, `wishsay/backend/src/test/resources/application-test.yml`, `wishsay/infra/docker-compose.yml`, `B/common/StartupSecretsCheck.java` (reddedilecek dev değerleri sabit olarak), `B/dev/DevSeeder.java` (dev tohum parolası, ayrıca loga yazılıyor) ve `wishsay/README.md` (deneme hesapları). Depo 2026-10-11'e kadar herkese açıktı (D-007). | — | Bu değerler HiVelzon'a kopyalanırsa tahmin edilebilir sır olur | HiVelzon kendi dev değerlerini üretmeli. `StartupSecretsCheck` HiVelzon'un dev değerleriyle yeniden yazılmalı. Tohum parolası loglanmamalı. |
| R-15 | Rol atama API'si yok; roller veritabanında elle değiştiriliyor ve bu denetlenmiyor | `B/dev/DevSeeder.java:118`; `B/user/User.java:114` | SARTNAME §12.4 "admin aksiyonları denetlenir" karşılanmaz | Rol atama denetlenen bir uç ya da migration/CLI ile |
| R-16 | Parola sıfırlama ve hesap kurtarma yok | — | SARTNAME §12.4 karşılanmaz | Sıfırdan tasarım (e-posta kodu, hız sınırı, tekdüze yanıt) |
| R-17 | WishSay canlı geliştiriliyor (inceleme sırasında birleştirme geldi). W-070 bulguları henüz kapanmadı. | `git log` | Kopyalanan kod eski sürümde kalabilir | Taşıma anında kaynak commit'i not edilmeli; W-070 kapanınca düzeltilmiş hâli alınmalı (CLAUDE.md "kaynağı belirterek") |

**Kopyalanmaması gereken kısımlar (özet):**
- anonimlik ve takma ad HMAC'i (`B/comment/CommentAliases`);
- etiketleme ve onay akışları;
- `pre_deletion_status` gizleme;
- NSFW, ONNX ve görsel işleme;
- Lingua dil tespiti;
- 3B pano ve WebView köprüsü;
- `categories` (KVKK m.6 gerekçeli kısıtlar UGC'ye özgü);
- `use-jackson2-defaults` (yeni projede gerekmez);
- W-070'te açık kalan desenler (R-01…R-06).

---

## 7. HiVelzon'a taşıma önerisi (sıralı)

Not: Bu liste kod onayından **sonra** uygulanacak sıradır; H-021 kapsamında kod yazılmadı. Her adımda kaynak commit'i (`d99fe1a` ya da daha yenisi) taşınan dosyanın başına yorum olarak yazılmalı (CLAUDE.md: "kaynağı belirterek"). İki repo birbirine bağlanmaz.

1. **Proje iskeleti ve ortam**
   - Kaynaklar: `wishsay/backend/pom.xml` (parent 4.1.x, Flyway, Testcontainers, Colima profili; Lingua, ONNX, S3 ve TwelveMonkeys hariç), `wishsay/infra/docker-compose.yml` (yalnızca Postgres; **farklı port**).
   - Yapılacak: Java sürümü kararı (S-08).
2. **Ortak hata modeli**
   - Kaynaklar: `B/common/ApiException.java`, `Problems.java`, `ErrorCode.java` (genel kodlar), `GlobalExceptionHandler.java`.
   - Yapılacak: HiVelzon kodları eklenir (§3.9). Sözleşme testi `AuthIntegrationTest` desenine göre yazılır (D-032).
3. **Sır kontrolü**
   - Kaynaklar: `B/common/StartupSecretsCheck.java` + `META-INF/spring.factories` + `StartupSecretsCheckTest`.
   - Yapılacak: HiVelzon sırlarıyla ve **yeni dev değerleriyle** yeniden yazılır.
4. **Denetim altyapısı**
   - Kaynaklar: `MIG/V2…sql` (yalnızca `audit_log` kısmı), `B/audit/{AuditService, AuditContextFilter, AuditRequestContext, ClientIpResolver, IpAddresses, ClientAddress, AuditChainVerifier, AuditRetentionService, AuditRetentionJob}`, `application.yml` (`forward-headers-strategy: none`).
   - Değişiklikler: DB rol ayrımı (R-07); `REQUIRES_NEW` düzeltmesi (R-02); kapsam listesi (§3.3); saklama süresi parametreli (S-03).
5. **Onay kayıtları**
   - Kaynaklar: `MIG/V2…sql` (`user_consents` kısmı) + `MIG/V9` kalıbı, `B/consent/*`.
   - Değişiklikler: `document_sha256`, `locale`, `source`; HiVelzon onay türleri; istemci sürümü gönderir (R-09).
6. **Kimlik**
   - Kaynaklar: `MIG/V1__init.sql` (`users` ve `refresh_tokens`; `handle`, `allow_tagging` ve `default_anonymous` hariç), `B/auth/*`, `B/common/SecurityConfig.java`, `B/user/{User, UserRepository, AccountSanctions}`.
   - Düzeltmeler: R-01, R-03, R-04. Yeni: e-posta doğrulaması (W-071 deseni), parola sıfırlama (R-16), yaş bandı.
7. **Hesap silme**
   - Kaynaklar: `MIG/V8` (yalnızca `deletion_requested_at` ve indeks), `B/user/{AccountDeletionPolicy, AccountPurgeJob, AccountPurgeService, AccountService.delete}`, `B/auth/AuthService.restore`.
   - Değişiklikler: `AccountLifecycleRepository` yeniden yazılır (gizleme yok; öğrenme, SRS, konuşma ve olay tabloları silinir); R-10.
8. **Rıza koruması**
   - Kaynaklar: `ConsentService.requireSensitiveDataConsent` + `ConsentController` + `SensitiveDataConsentIntegrationTest` deseni.
   - Uygulama: `VOICE_CONSENT_REQUIRED` (D-081).
9. **Kota ve bütçe sınırı**
   - Kaynaklar: `B/common/AdvisoryLocks.java` + `CommentService.checkRateLimit` deseni (D-120).
   - Uygulama: `usage_quotas` ve aylık tavana uygulanır. Bütçe tarafı videoGenerator `BudgetGuard` ile birleştirilir (H-022).
10. **Roller ve yönetim**
    - Kaynaklar: `B/user/Role.java`, `SecurityConfig` URL eşlemeleri.
    - Değişiklikler: roller `USER/EDITOR/ADMIN(/LEGAL)`; denetlenen rol atama (R-15); panelin yeri kararı (S-05).
11. **Flutter iskeleti**
    - Kaynaklar: `MOB/pubspec.yaml` (WebView ve ML Kit hariç), `MOB/l10n.yaml` + `lib/l10n/*.arb` düzeni, `MOB/lib/api/{api_error, wishsay_api}` (yapı olarak), `MOB/lib/ui/error_text.dart`, `MOB/lib/consent/*`.
    - `MOB/lib/api/{token_store, auth_interceptor}.dart` **W-070 C2–C7 düzeltilerek** alınır (R-05, R-06).
12. **Hukuki metinler**
    - Kaynaklar: `MOB/tool/sync_legal.sh`, `MOB/test/legal_assets_test.dart`, `MOB/lib/config/app_info.dart` (sürüm sabitleri).
    - Ekler: hash doğrulaması; S-06 kararına göre sunucudan sunum.
13. **API belgesi ve sürüm politikası**
    - Kaynak: `wishsay/docs/api.md` "Conventions" bölümü (satır 7-147) şablon olarak.
    - Ekler: `app-config` / `minSupportedVersion` ve geriye uyum kuralı (§3.10).
14. **Dersler ve CI**
    - §5'teki dersler HiVelzon'un `ogrenilenler/` klasörüne kaynak gösterilerek **özet** olarak eklenir. Yalnızca geçerli olanlar alınır; yeni D-numarası verilir.
    - Basit bir CI kurulur (R-12).

---

## 8. Açık sorular

Kullanıcı ya da hukukçu kararı gerekenler:

- **S-01 — Hesap durumu modeli:** Zaman damgasından türetilen durum (WishSay) mı, `users.status` enum'u (SARTNAME) mı? Silme talebi için ayrı tablo gerekli mi? **Öneri:** WishSay modeli, ad `PENDING_DELETION`.
- **S-02 — Onay tablosu modeli:** Yalnızca ekleme (WishSay) mı, `granted_at/withdrawn_at` ile güncellenen satır (SARTNAME) mı? **Öneri:** yalnızca ekleme + `document_sha256`.
- **S-03 — Denetim saklama süresi:** HiVelzon'da UGC yok. 5651'e dayanan 730 gün geçerli mi, daha kısa bir süre mi (ör. 1 yıl)? Hukukçu teyidi gerekir.
- **S-04 — Sunucu ülkesi:** WishSay için yurt dışı sunucu seçildi (W-066). HiVelzon da aynı altyapıda mı olacak? m.9 standart sözleşmesi ortak mı yapılacak? Ses verisi sağlayıcıları zaten yurt dışında (IS-PLANI §9.1).
- **S-05 — Yönetim paneli yeri:** İçerik editörü ve bütçe paneli mobil uygulama içinde mi (WishSay deseni), ayrı bir iç web panelinde mi, yoksa yalnızca CLI ve dosya tabanlı mı (K-12)?
- **S-06 — Politika metinlerinin dağıtımı:** Yalnızca uygulamaya gömülü (WishSay; sürüm yükselince eski uygulama kayıt olamaz) mı, sunucudan da mı sunulacak?
- **S-07 — 13–17 yaş:** Yaş bandı mı, doğum yılı mı toplanacak? Konuşma pratiği için veli onayı mı, 18+ sınırı mı (H-002)? `PARENTAL_CONSENT` türü gerekli mi?
- **S-08 — Java sürümü:** Java 17 (WishSay ile aynı) mı, Java 21 mi (sanal thread'ler; WebSocket ses akışı ve çok sayıda sağlayıcı çağrısı)?
- **S-09 — `learning_events` idempotentliği:** Partition'lı tabloda global `client_event_id UNIQUE` kurulamaz. Hangi seçenek: `(client_event_id, occurred_at)`, ayrı idempotentlik tablosu, ya da ilk sürümde partition'sız başlamak?
- **S-10 — Denetim kapsamı:** IS-PLANI §9.4'teki "her yazma işlemi" kuralı HiVelzon'da "güvenlik ve hukuk açısından anlamlı yazmalar" olarak daraltılsın mı? **Öneri:** evet.
- **S-11 — Ortak kod:** WishSay W-070 düzeltmeleri bitmeden HiVelzon Faz 1 başlarsa, düzeltmeler HiVelzon'da bağımsız mı yapılacak, yoksa WishSay'in düzeltilmesi mi beklenecek? (CLAUDE.md: videoGenerator ve WishSay'de HiVelzon oturumundan değişiklik yapılmaz.)
