# H-056: Eşitleme ince ayarı (H-038 sonrası)

- **Durum:** Bitti
- **Tür:** Uygulama + backend
- **Bağımlılık:** H-038

## Kullanıcı kararları (2026-10-13)
- **"Bitti" her zaman kazanır:** bitmiş bölüm hiçbir eşitlemeyle "devam ediyor"a dönmez (sunucu ve telefon; kapı öğeleri de yalnızca eklenir).
- **Yenileme anahtarına 30 sn hoşgörü:** aynı eski yenileme anahtarı 30 sn içinde tekrar gelirse aynı yeni anahtar döner; çalıntı koruması 30 sn sonrası için aynen.
- **Çıkışlıyken "Hi'nin kayıtlarını sil":** silme isteği telefonda bekler; aynı hesapla yeniden girişte sunucuya ve diğer cihazlara işlenir.
- **Sekme yenileme hatası:** başka cihazdan veri gelince bütün sekmeler güvenle yenilenir (Riverpod 3 "setState during build" sorunu; oynatıcıdan dönüşteki yenileme de denetlenir).

## Kabul kriterleri
- Her karar için test (mobil + backend); flutter test ve mvn verify yeşil.

## Notlar
2026-10-13 (doğrulama özeti):
- **"Bitti" her zaman kazanır:**
  - Backend: `SyncTable`'a isteğe bağlı birleştirici (`SyncMerger`), `ProgressMerger` (`user_story_progress`). Durum sırası `NOT_STARTED < IN_PROGRESS < COMPLETED` geri gitmez; sonuç gönderilenden farklıysa `MERGED` çatışması + `serverRow`. Yükseltmede `updatedAt` sunucudakinin 1 ms sonrası (yeni sıra; satırı iten cihaz onu "kendi itmesi" sanmaz). `gate_progress` yalnız eklenir (testle doğrulandı).
  - Mobil (`SyncStore._applyRow`): çekilen ya da çatışmadan gelen satır yereldeki durumu düşürecekse durum, bitiş zamanı (bitmişse kayıt noktası da) yereldeki kalır, başlama en erken, zaman en geç; satır yeniden kuyruğa girer. Aynı zamanlı ama durumu yükselten satır artık "kendi itmemiz" diye atlanmaz.
  - Testler: backend `ProgressMergeTest` (7); mobil `sync_h056_test.dart` (iki cihaz çevrimdışı, iki sıra; yeniden oynanan bitmiş bölüm; kapı öğeleri birleşir).
- **Yenileme anahtarına 30 sn hoşgörü:**
  - Backend V6: dönen belirtecin satırında halefin kimliği ve değeri (AES-256-GCM, anahtar `HIVELZON_OTP_PEPPER`'dan alan ayrımlı HMAC ile türetilir, AAD = eski belirteç kimliği). Pencere içinde aynı eski anahtar → yeni erişim belirteci + aynı halef, denetimde `REFRESH_GRACE_REPLAY`. Pencere sonrası, halef döndükten sonra ya da çıkıştan sonra eski kural (`TOKEN_REUSED`, aile iptal). Süre `hivelzon.security.refresh-grace` (`HIVELZON_REFRESH_GRACE`, varsayılan 30 sn, `0s` kapalı). Şifreli değer pencere geçince bakım işinde, aile iptalinde hemen silinir.
  - Mobil: yenileme isteği bağlantı hatasında yeniden denenir (`retryNetwork`, toplam ~3,5 sn < 30 sn): cevap yolda kaybolsa da oturum düşmez.
  - Testler: backend `TokenFlowTest` (+6), `AuditPrivacyTest` güncellendi; mobil `auth_service_test.dart` (+2; kayıp cevap, 30 sn sınırı).
- **Çıkışlıyken "Hi'nin kayıtlarını sil":** `SyncStore.recordSignedOutHiReset`: bu cihazda daha önce hesap açıldıysa (`app_meta` `sync.lastAccountUserId`) silme anı `sync.pendingHiResetAt`'te bekler. Aynı hesapla girişte o anla `hi_reset` işareti yazılıp ilk yüklemeyle gider (sunucu ve öteki cihazlar T'ye kadarkileri siler; T'den sonrakiler kalır). Başka hesapla girişte bekleyen silme atılır; silme yalnızca o cihazda kalır, sonra ilk hesaba dönülse de uygulanmaz. Hiç hesap açılmamışsa saklanmaz. Yerelde `hi_reset` işareti varken çekilen T'ye kadarki kayıtlar yeniden silinir (girişteki ilk çekme eski kayıtları geri getirmez). Bu yolda `DELETE /sync/speech-attempts` çağrılmaz: o çağrı başka cihazın T'den sonraki "Söyle" sonuçlarını da silerdi; sunucu işaretle T'ye kadarkileri zaten siler. Testler: `sync_h056_test.dart` (4).
- **Sekme yenileme hatası:**
  - Neden (yeniden üretildi): Riverpod 3 görünmeyen sekmedeki abonelikleri duraklatır. Yalnızca duraklatılmış dinleyicisi olan sağlayıcı geçersiz kılınınca kirli bekler; sekme açılırken (build içinde) abonelik sürdürülür, zincir hesaplanır ve bağlı türetilmiş sağlayıcı (`seasonMapProvider` → `storyProgressProvider`) zamanlayıcıyı tetikler: `ProviderScope` build sırasında `setState`.
  - Çözüm: `lib/shared/state/safe_refresh.dart` → `invalidateAndFlush`: geçersiz kılar, ardından var olan her sağlayıcıyı build dışında bir kez okur (zincir hemen hesaplanır, kirli sağlayıcı kalmaz; build sırasında çağrılırsa kare sonuna ertelenir). `refreshNotebook`, `refreshHi`, `refreshWhenVisible` (oynatıcıdan / Hi panelinden dönüş) bunu kullanır.
  - Gelen veri: `RemoteDataRefresher` (yalnız Ana Sayfa) kaldırıldı. Uygulama kökü (`HiVelzonApp`, hiç duraklatılmaz) `dataVersion`'ı dinler ve `refreshLocalData` ile bütün sekmeleri (Ana Sayfa, Hikâye haritası, Defter, Profil, Hi, konu setleri) yeniler.
  - Testler: `test/app/tab_refresh_test.dart` (5): eski yol hatayı yeniden üretir; yeni yolda gelen veri, art arda veri, Profil'den ve Hikâye'den dönüş yenilemesi hatasız ve ekranlar güncel. Eski `refreshWhenVisible` gövdesiyle "Profil'den dönüş" testi kırılıyor (doğrulandı).
- **Doğrulama:** `flutter analyze` temiz; `flutter test` 404/404 (önce 389); `mvn -B verify` 110/110 (önce 97).
- **Uçtan uca (simülatör):** yapılmadı (isteğe bağlıydı); davranış widget ve eşitleme testleriyle doğrulandı. Kullanıcının simülatör verisine dokunulmadı.
2026-10-14 (ana oturum): flutter test 404/404, mvn verify 110/110 yeniden doğrulandı. Gecikmeli silmede DELETE speech-attempts çağrılmaması (yalnız T'ye kadar işaret) kabul edildi. Commit onayı.
