# H-095: Hukukçu cevaplarının uygulanması

- **Durum:** Bitti (2026-10-21); metinlerde yer tutucular (veri sorumlusu, adres, iletişim, mahkeme, sağlayıcılar) ayrı fazda doldurulacak
- **Tür:** Uygulama (kod) + metin
- **Faz:** F1 MVP — H-042'nin devamı
- **Bağımlılık:** H-042, H-037; kaynak: `docs/HUKUK-SORULARI.md` → "Cevaplar" (2026-10-21)

## Kapsam (kullanıcı onayı 2026-10-21)
1. **Metin sürümü değişince yeniden onay yok:** backend `CONSENT_VERSION_OUTDATED` eşitlemeyi durdurmaz; uygulama yeni sürümü sakin bir bildirimle gösterir ("Gizlilik metni güncellendi" + metne bağlantı). Kabul kaydı istenmez.
2. **2 yıl saklama:** hesap kalıcı silinince rıza kayıtları ve denetim kaydı (IP, port, saat) hemen silinmez; **2 yıl** saklanır, süre dolunca silinir (zamanlanmış temizlik). Hesapla bağı koparılabilir ama ispat için gereken alanlar kalır.
3. **KVKK aydınlatma metni ve kullanım koşulları:** Claude taslak yazar (sade, "sen" dili), uygulamadaki 3 bölümlük taslağın yerine geçer; "hukukçu gözden geçirecek" notu kalır. Veri sorumlusu unvanı/adresi/iletişimi ve yetkili mahkeme **yer tutucu** (ayrı faz).

## Kabul kriterleri
- Eski sürüm onaylı hesap eşitlemeye devam eder; bildirim görünür (test).
- Kalıcı silmede rıza ve denetim kayıtları kalır; 2 yıldan eski olanlar temizlenir (test).
- Yeni metinler `docs/ARAYUZ-METINLERI.md` ile tutarlı; erişilebilirlik ve taşma testleri geçer.

## Test
```bash
cd mobile && flutter analyze && flutter test
cd backend && DOCKER_HOST=unix://$HOME/.colima/default/docker.sock TESTCONTAINERS_RYUK_DISABLED=true mvn -B test
```

## Geri alma
Kendi dalında; `git revert`.

## Notlar

### 2026-10-21 — uygulama (worktree, commit yok; kullanıcı onayı bekliyor)
- **Yeniden onay yok (kapsam 1).** Backend `CONSENT_VERSION_OUTDATED` kaldırıldı (`ErrorCode`, `OtpService`, `ConsentService`). Kayıtta ve `POST /me/consents`'te istemcinin gösterdiği sürüm olduğu gibi kaydedilir; eski sürüm hiçbir isteği durdurmaz. `GET /me/consents` → `upToDate` yalnızca bilgi. Sürümler `taslak-2` (koşullar, aydınlatma; yenilik izni `taslak-1` kalır); uygulamada `ApiConfig.defaultLegalVersion = 'taslak-2'`.
- **Uygulama bildirimi.** `LegalUpdateNotice` (`account_providers.dart`) + `LegalUpdateCard` (Ana Sayfa, hesap kartının üstünde). Açılış bittiyse ve cihazda görülen sürüm (`app_meta` `legal.seenTermsVersion` / `legal.seenPrivacyVersion`; yoksa `onboarding.noticeVersion`) güncelden farklıysa bir kez görünür. "Tamam" ya da metni açmak kapatır. Açılıştaki "Anladım, devam et" güncel sürümleri görüldü sayar. Sunucuya istek yok.
- **2 yıl saklama (kapsam 2).** V16 `record_retention`: `consents.user_id` yabancı anahtarı kaldırıldı, `account_tombstones (user_id, purged_at)` eklendi. Kalıcı silmede rızalar silinmez, denetim satırları boşaltılmaz (eski kimlik mezar taşı olarak kalır). `RecordRetentionJob` (her gün 03:41 UTC, `hivelzon.jobs.retention-cron`; süre `hivelzon.retention.records: 2y`, takvimle): rızaları silinmeden 2 yıl sonra (mezar taşıyla), denetim satırlarını olay tarihinden 2 yıl sonra siler. `CONTENT_*` satırları editör geçmişi olduğu için silinmez, yalnızca IP/port/tarayıcı özeti/istek kimliği boşaltılır. Süre sıfır/negatifse temizlik bir şey silmez.
- **Metinler (kapsam 3).** `AccountTexts.termsSections` (12 bölüm) ve `privacySections` (15 bölüm) Claude taslağı; "Taslak · hukukçu gözden geçirecek". Yer tutucular: veri sorumlusu unvanı (Velzon iştiraki notuyla), adres, e-posta, yetkili mahkeme şehri, barındırma ve e-posta gönderim sağlayıcısı.
- **Belgeler:** `docs/SARTNAME.md` (karar notu, §12.1, §12.2), `backend/README.md`, `docs/ARAYUZ-METINLERI.md` (Profil "Hakkında" satırı, §12 hukuk metni ekranı + metin güncellendi kartı, §13 açılış).
- **Açık:** (a) yenilik e-postası izninden uygulama içinden vazgeçme yolu yok (metin "bize yazarak" diyor); (b) yenilik e-postasının hukuki sebebi (açık rıza?) taslakta belirtilmedi; (c) barındırma sağlayıcısının erişim kayıtları (IP) aydınlatmada "seni tanımak için kullanmayız" diye geçiyor, H-044'te sağlayıcıyla doğrulanmalı; (d) denetim süresi olay tarihinden sayılıyor (silmeden değil), hukukçu teyidi.
- **Testler (2026-10-21):** `flutter analyze` temiz; `flutter test` 1426 geçti. Backend `mvn -B test` (Testcontainers) 155 geçti. Yeni: `AccountDeletionTest.retentionDeletesConsentsTwoYearsAfterPurgeAndAuditTwoYearsAfterEvent`, `ConsentFlowTest.accountThatAcceptedOlderTextsKeepsUsingEverything`, `OtpFlowTest.olderTermsVersionIsAcceptedAndRecorded`, `legal_update_notice_test.dart`, `account_ui_test.dart` H-095 üçlüsü, h059 metin güncellendi kartı (golden + erişilebilirlik + 320×568·1,3×).
- **Golden'lar (bilerek güncellendi):** `h059_hukuk`, `h059_profil`, `h059_profil_adsiz` (ipucu "Taslak · hukukçu gözden geçirecek"), `h039_bilgilendirme` (taslak kartı metni); yeni `h059_metin_guncellendi`.
