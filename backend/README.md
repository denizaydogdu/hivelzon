# hiVelzon backend

Spring Boot 4 (Java 17, Maven), PostgreSQL 17, Flyway. Modüler monolit: `auth` (e-posta kodu, belirteçler), `user` (hesap, silme), `consent` (rızalar), `audit` (denetim kaydı), `catalog` (içerik kataloğu, `VideoHostingPort`), `sync` (eşitleme motoru), `progress` ve `learning` (eşitlenen tablolar, sunucu FSRS'i), `fsrs` (py-fsrs 6.3.2 Java portu), `common` (ayar, hata modeli, güvenlik yardımcıları).

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
| `HIVELZON_CATALOG_IMPORT_ROOT` | `../icerik` | Geliştirme içe aktarmasının okuduğu içerik kökü (bölüm paketleri `<kök>/<id>/_build/package/`, sezon `<kök>/_evren/_build/season/S<n>/`) |
| `HIVELZON_CATALOG_DEV_IMPORT` | `true` (prod: `false`) | `POST /api/v1/admin/catalog/import` açık mı. prod profilinde uç hiç yok. |
| `HIVELZON_MEDIA_LOCAL_BASE_URL` | `http://127.0.0.1:8787/packages/` | `VideoHostingPort` yerel adaptörü: katalogdaki medya adresleri yerel içerik sunucusunu gösterir (Bunny H-044'te) |
| `HIVELZON_RL_SYNC_PUSH_PER_USER` / `_PULL_` / `HIVELZON_RL_REVIEW_RATE_PER_USER` | `240` / `1200` / `2000` | Saatte kullanıcı başına eşitleme itme / çekme / tekrar notu |
| `HIVELZON_JOBS_ENABLED` | `true` | Zamanlanmış işler (kalıcı silme her saat :17'de, temizlik 15 dk'da bir; UTC) |

Anahtar üretmek için: `openssl rand -base64 32`. Sırlar repoya girmez (`~/.config/hivelzon/`). Sabit süreler `application.yml`'de: kod 10 dk / 5 deneme, erişim 15 dk, yenileme 30 gün, silme penceresi 30 gün, en küçük yaş 13, yetişkin 18.

## API (v1)

Bütün hatalar RFC 9457 `application/problem+json`: `code` (makine), `detail` (Türkçe, gösterilebilir), `requestId`. Stack trace dönmez.

| Uç | Kimlik | Açıklama |
|---|---|---|
| `POST /api/v1/auth/email/start` `{email}` | açık | Her zaman `202 {codeValidSeconds}`; hesap olup olmadığı belli edilmez. Sınır aşılırsa `429 RATE_LIMITED` + `Retry-After`. |
| `POST /api/v1/auth/email/verify` `{email, code, deviceName?, birthYear?, displayName?, termsVersion?, privacyNoticeVersion?, marketing?}` | açık | Hesap varsa giriş, yoksa kayıt. Kayıtta alanlar eksikse kod harcanmadan `422 SIGNUP_DETAILS_REQUIRED`. 13 yaş altı `403 AGE_NOT_ALLOWED` (hiçbir şey saklanmaz). Hatalar: `OTP_INVALID`, `OTP_EXPIRED`, `OTP_TOO_MANY_ATTEMPTS`, `CONSENT_VERSION_OUTDATED`. |
| `POST /api/v1/auth/refresh` `{refreshToken}` | açık | Yenileme belirteci döner (eskisi kullanılmış olur). Kullanılmış belirteç yeniden gelirse aile iptal: `401 TOKEN_REUSED`. **Hoşgörü (H-056):** dönen belirteç 30 sn içinde yeniden gelirse (cevap ağda kayboldu, çift istek) yeni erişim belirteci + **aynı** halef yenileme belirteci döner, denetimde `REFRESH_GRACE_REPLAY`; koşul: aile iptal edilmemiş (çıkış, yeniden kullanım) ve halef hâlâ geçerli (dönmemiş, süresi dolmamış). 30 sn sonrası ya da halef döndükten sonra eski kural. Süre `hivelzon.security.refresh-grace` (`HIVELZON_REFRESH_GRACE`, `0s` kapalı). Halef değeri eski satırda AES-256-GCM ile şifreli durur (anahtar `HIVELZON_OTP_PEPPER`'dan alan ayrımlı HMAC ile türetilir, AAD = eski belirtecin kimliği), pencere geçince bakım işi, aile iptalinde hemen silinir (V6). |
| `POST /api/v1/auth/logout` `{refreshToken}` | açık | Bu cihaz oturumunu kapatır; `204`, idempotent. |
| `GET /api/v1/me` | Bearer | Hesap: e-posta, görünen ad, doğum yılı, `ageBand` (`TEEN_13_17` / `ADULT_18_PLUS`), rol, durum. |
| `DELETE /api/v1/me` | Bearer | `202 {status: PENDING_DELETION, scheduledPurgeAt}`; bütün oturumlar kapanır; idempotent. |
| `POST /api/v1/me/restore` | Bearer (silme isteğinden **sonra** kodla giriş) | Hesabı geri alır; eski belirteçle `403 REAUTH_REQUIRED`. |
| `GET /api/v1/me/consents` | Bearer | Her türün güncel durumu (`TERMS`, `PRIVACY_NOTICE`, `MARKETING`). |
| `POST /api/v1/me/consents` `{type, version, granted}` | Bearer | Yeni satır ekler (güncellenmez). Koşullar/aydınlatma geri çekilemez (yolu hesap silme). |
| `GET /api/v1/me/consents/history?page=&size=` | Bearer | Sayfalı geçmiş (`size` en çok 100). |
| `GET /actuator/health` | açık | Yalnızca `UP/DOWN`. Diğer actuator uçları kapalı. |
| `GET /api/v1/catalog/items?season=&page=&size=` | açık | Görünür bölümler (aşağıda), sayfalı (`size` en çok 100), sezon + sıra düzeninde. Her öğe: `contentId`, `contentVersion`, `season`, `number`, `level`, `title`, `estimatedMinutes`, `publishAt`, `packageBaseUrl`, `scenesUrl`, `manifestUrl`, `manifestSha256`, `totalBytes`, `renditionBytes`. |
| `GET /api/v1/catalog/seasons/{n}` | açık | `season.json` (dosya listesi hariç) + `packageBaseUrl`. `episodes[]` haritanın bütün yerleri; görünür bölümde `available: true` ve `item` (yukarıdaki öğe). Onaysız `teaserTr` gösterilmez. Sezon yoksa `404 NOT_FOUND`. |
| `POST /api/v1/admin/catalog/import` | Bearer, EDITOR/ADMIN; yalnızca prod dışı | Geliştirme içe aktarması; `{created, updated, unchanged, skipped, items[], seasons[]}`. (content_id, content_version) ile idempotent. Denetim kaydı `CATALOG_IMPORT`. |
| `POST /api/v1/sync/push` `{deviceId?, changes: {tablo: [satır]}}` | Bearer | Eşitleme itmesi (kurallar aşağıda). `{accepted[{table, clientId, result}], conflicts[{table, clientId, reason, serverRow}], serverTime}`. Hatalar: `SYNC_ROW_INVALID` / `SYNC_FIELD_NOT_ALLOWED` (+ `table`, `index`, `field`), `TRANSCRIPT_NOT_ALLOWED`, `413 PAYLOAD_TOO_LARGE` (500 satır ya da 1 MiB üstü), `429 RATE_LIMITED`. |
| `GET /api/v1/sync/pull?since=&limit=` | Bearer | `since` imlecinden sonraki değişiklikler (sunucu sırası), `limit` varsayılan 200, en çok 500. `{changes: {tablo: [satır]}, nextSince, hasMore, serverTime}`; `hasMore` false olana kadar `since=nextSince`. |
| `DELETE /api/v1/sync/speech-attempts` | Bearer | "Hi'nin kayıtlarını sil"in sunucu karşılığı: "Söyle" sonuçları kalıcı silinir. `204`, idempotent. |
| `POST /api/v1/review/rate` `{cardClientId, rating 1–4, reviewedAt, clientId?, taskType?, correct?, dontKnow?, durationMs?, wasNew?}` | Bearer | Cevabı kaydeder (`clientId` yoksa kart + zaman + nottan UUIDv5; tekrar → `duplicate: true`), kartı sunucuda hesaplar: `{logClientId, duplicate, card}`. Kart yoksa `404`. |

Silinmek üzere olan hesap `/me`, `/me/restore` ve `DELETE /me` dışında `403 ACCOUNT_PENDING_DELETION` alır (eşitleme ve tekrar notu dahil). `/api/**` gövde sınırı 64 KiB (eşitleme itmesi 1 MiB); aşılırsa `413 PAYLOAD_TOO_LARGE`.

### Katalog: görünürlük, önbellek, durum eşlemesi

- **Görünür = `PUBLISHED` ya da (`APPROVED`/`SCHEDULED` ve `publish_at ≤ şimdi`)** (K-05). Aynı bölümün birden çok görünür sürümü varsa en yenisi döner. Durum alanı istemciye dönmez.
- Cevaplarda güçlü `ETag` ve `Cache-Control: max-age=60, must-revalidate, public`; `If-None-Match` eşleşirse gövdesiz `304`. ETag cevabın kendisinden hesaplanır: zamanlanmış bölüm görünür olunca da değişir.
- Katalog uçları kimlik istemez (misafir ve hesapsız 13 yaş altı da içerik görür, H-009/H-002); bozuk ya da süresi dolmuş `Authorization` başlığı yok sayılır.
- **İçe aktarmada durum (editör onay ekranı H-041'e kadar):** `content.json → status` K-05 değeriyse o alınır, değilse `DRAFT`. `APPROVED`/`SCHEDULED`/`PUBLISHED` yalnızca **onay kanıtıyla** kabul edilir: `humanReviewed: true` **ve** (`ceviri.tr.json` varsa) `status: APPROVED`. Kanıt yoksa `DRAFT` olur ve rapora not düşülür; çeviri onayı tek başına bölümü onaylamaz. `SCHEDULED` için `publishAt` zorunlu. Bugün bütün bölümler `DRAFT`: açık katalog boştur.
- Medya veritabanında tutulmaz: satırda paketin yeri (`package_base_path`: `A1-001`, `_season/S1`) ve `manifest.json` SHA-256'sı vardır. Adresi `VideoHostingPort` kurar (yerelde `LocalPackageAdapter` → içerik sunucusu).

### Eşitleme kuralları (H-038 mobil entegrasyonu için)

- **Tablolar ve alanlar mobil Drift şemasıyla (4, H-038'den sonra 5) aynı adlıdır** (camelCase JSON, tablo adları aynı): `user_story_progress`, `user_story_flags`, `gate_progress`, `season_state`, `clues`, `story_links`, `notebook_items`, `review_cards`, `review_logs`, `learning_events`, `hi_records`, `speech_attempts`. `app_meta` eşitlenmez. Zamanlar ISO-8601 UTC. `checkpointSnapshot`, `answers`, `partialNotes` JSON metni ya da JSON olarak gönderilebilir; çekmede JSON döner.
- **Kimlik:** her satır `(user_id, client_id)` ile tekildir. Doğal anahtarlı tablolarda `clientId` istemciden gelmek zorunda değildir; sunucu `UUIDv5(6f1b8f1e-3c55-5d7a-9a43-6869566c7a6e, "<tablo>:<anahtar1>|<anahtar2>")` ile türetir (gönderilirse eşleşmeli). Anahtarlar: progress `contentId`; flags `contentId|flag`; gate `contentId|itemKind|nodeId`; season `seasonId`; clues `contentId|clueId`; story_links `contentId`; notebook ve kart `itemKey`; hi_records `kind|refId`. Böylece iki cihazdaki aynı satır aynı kimliği taşır. `review_logs`, `learning_events`, `speech_attempts` cihazın verdiği UUID ile tekildir: `learning_events.clientEventId` değeri `clientId` olarak gönderilir; diğer ikisine H-038'de UUID kolonu eklenir. Mobilin tamsayı kimlikleri (`id`, `itemId`, `cardId`) gönderilmez: kart `itemKey` ile deftere, cevap `cardClientId` (kartın türetilmiş kimliği) ile karta bağlanır.
- **Değişebilir tablolar** (progress, flags, season, story_links, notebook, kart, hi_records) son yazan kazanır: zaman `updatedAt` (story_links'te `recordedAt`). Yeni zaman yazılır; eşit zamanda veri farklıysa sunucuya sonra gelen kazanır; eski zaman `STALE` çatışması + `serverRow` döner. **İstisna, "bitti her zaman kazanır" (H-056):** `user_story_progress`'te durum sırası `NOT_STARTED < IN_PROGRESS < COMPLETED` geri gitmez. Daha yeni ama düşük durumlu satır gelirse gelen yazılır, durum ve `completedAt` (sunucudaki `COMPLETED` ise kayıt noktası da) korunur; aynı zamanlı düşük durumlu satır hiçbir şey değiştirmez; daha eski (ya da aynı zamanlı) ama yüksek durumlu satır gelirse sunucudaki durum yükseltilir (gelen `COMPLETED` ise kayıt noktası da alınır) ve `updatedAt` sunucudakinin 1 ms sonrası olur (yeni sıra; öteki cihazlar alır). `startedAt` ikisinden erken olanı. Sonuç gönderilenden farklıysa `MERGED` çatışması + `serverRow` döner; istemci onu olduğu gibi alır. Mobil de aynı kuralı uygular: çekilen satır yereldeki durumu düşürecekse yereldeki durum korunur ve satır yeniden kuyruğa girip sunucuya gider. Silme işaretinde ve aynı durumda düz LWW. `gate_progress` yalnız eklenir (silme işareti alanı yok, `DUPLICATE`). Aynı veri tekrar gelirse `UNCHANGED` (sıra artmaz). Sunucu saatinden 5 dk'dan ileri zaman sunucu saatine çekilir. Silme: `deleted: true` (veri kolonları boşaltılır, çekmede diğer cihazlara gider). `user_story_flags` ve `season_state` mobilde `updatedAt` taşımıyor; H-038'de eklenir (ya da bayrakta bölüm bitiş zamanı, sezonda `introSeenAt` gönderilir).
- **"Hi'nin kayıtlarını sil" bütün cihazlarda (H-038, V5):** istemci `hi_records`'a işaret iter: `{kind: "hi_reset", refId: "all", status: "cleared", updatedAt: T}`. Sunucu aynı işlemde (`HiResetHook`) T'ye kadarki `learning_events` ve `speech_attempts` satırlarını siler, T'ye kadarki `bridge_task`/`note_read` kayıtlarını silme işaretiyle kapatır. İşaret çekmeyle öteki cihazlara gider; onlar da T'ye kadarki yerel kayıtlarını siler. `DELETE /sync/speech-attempts` ayrıca durur (idempotent). `hi_records.kind` ayrıca `hunt_done` (sahne avı), `notebook_items.source` ayrıca `topic_set` alır (mobil değerleri, V5). **Çıkışlıyken silme (H-056, mobil):** hesap kapalıyken yapılan silmenin anı T cihazda (`app_meta`) bekler; **aynı hesapla** yeniden girişte T zamanlı `hi_reset` işareti ilk yüklemeyle itilir (sunucu yukarıdaki kuralla T'ye kadarkileri siler; T'den sonraki kayıtlar, ör. başka cihazınkiler, kalır). Bu yolda `DELETE /sync/speech-attempts` çağrılmaz (o çağrı T'den sonrakileri de silerdi). **Başka hesapla** girişte bekleyen silme atılır, silme yalnızca o cihazda kalır. Cihazda yerel bir `hi_reset` işareti varken çekilen T'ye kadarki kayıtlar yerelde yeniden silinir (girişteki ilk çekme eski kayıtları geri getirmesin).
- **Yalnız eklenen tablolar** (review_logs, learning_events, speech_attempts, gate_progress, clues): yoksa eklenir, varsa `DUPLICATE` (ilk yazılan kalır).
- **İtme bütündür:** önce bütün satırlar doğrulanır; biri bozuksa hiçbiri yazılmaz. Bilinmeyen alan `SYNC_FIELD_NOT_ALLOWED`; ses ya da tanıma yazısı gibi görünen alan (`transcript`, `audio…`, `recognizedText`, `confidence` …) `TRANSCRIPT_NOT_ALLOWED`. Hata cevabında yalnızca yer (`table`, `index`, `field`) döner, değer dönmez.
- **Çekme imleci:** her yazma `sync_seq`'ten yeni sıra alır. Kullanıcının bütün eşitleme yazmaları kullanıcı başına işlem kilidiyle (`pg_advisory_xact_lock`) sıralandığı için kullanıcının satırlarında sıra = işleme sırası; imleç satır kaçırmaz. Çekme, tablo sayısı kadar sabit sorgu yapar (N+1 yok; testli).
- **FSRS (K-04) yetkilisi sunucudur, kaynağı cevaplardır:** kart durumu kartın bütün `review_logs` satırları (`reviewedAt`, sonra `clientId` sırasıyla) yeni karttan yeniden oynatılarak hesaplanır (py-fsrs 6.3.2 Java portu, hedef hatırlama 0,90, 10 dk adım, fuzz yok; mobil Dart portuyla aynı 159 referans vektörü). Mobil çevrimdışı önce kendi hesabını yapar; itmede gönderdiği kart durumu sunucu hesabından farklıysa sunucu yazar ve `SERVER_RECOMPUTED` çatışması + `serverRow` döner. Böylece iki cihazın çevrimdışı tekrarları birleşir. Cevabı olmayan (yeni) kartta istemcinin satırı geçerlidir. `reps` = cevap sayısı, `lapses` = review durumunda Again sayısı (mobil kuralı).
- **Veri en aza indirme:** e-posta ya da cihaz adı eşitleme tablolarına girmez; `deviceId` yalnızca biçim olarak denetlenir, saklanmaz. "Söyle" satırı yalnızca sonuçtur (yer, içerik, beklenen ifade kimliği, eşleşme düzeyi, eksik kelime sayısı, hata notu kimliği, zaman); şemada ses/yazı/güven kolonu yoktur. Kalıcı hesap silmede bütün eşitleme satırları silinir (`SyncService` → `UserDataPurger`; kullanıcıya yabancı anahtar `RESTRICT`, unutulan tablo silmeyi durdurur).

## Testler

```bash
export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
mvn -B verify
```

`FsrsEquivalenceTest` py-fsrs çıktısını (`src/test/resources/fsrs/fsrs_vectors.json`, mobil `test/fixtures/` kopyası; kopyanın aynı kaldığı da denetlenir) 1e-9 göreli farkla ve birebir vade zamanıyla karşılaştırır. Katalog ve eşitleme listelerinde N+1 denetimi `QueryCounter` (test DataSource sarmalayıcısı) ile yapılır.

Entegrasyon testleri tek PostgreSQL konteyneri (Testcontainers) ve kontrollü saatle (`MutableClock`) çalışır; e-posta sahte `MailPort` ile yakalanır. `MailpitSmokeTest` gerçek bir Mailpit konteynerine SMTP ile gönderir.
