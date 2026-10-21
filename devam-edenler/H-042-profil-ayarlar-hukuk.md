# H-042: Profil, ayarlar, hukuki metinler, hesap silme arayüzü

- **Durum:** Devam ediyor (2026-10-21)
- **Tür:** Uygulama (kod)
- **Faz:** 1.10 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-038

## Kapsam
- Beceri ve ilerleme gösterimi.
- Bildirim ayarları, gizlilik.
- Lisans atıfları (CEFR-J vb.), KVKK aydınlatması (hukukçu metni gerekir).
- Hesap silme ve geri alma arayüzü.

## Kabul kriterleri
- Hesap silme ve geri alma arayüzden uçtan uca çalışıyor.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-042-profil-ayarlar-hukuk`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12: Profil'deki "Hi benim hakkımda ne biliyor?" görünümü H-048 kapsamındadır; bu iş yalnızca yerini ayırır. Hukuk metinleri ve lisans atıfları için kaynak: `docs/LISANS-RAPORU.md`; hukukçu soruları henüz gönderilmedi.
2026-10-13 (H-055'ten): Hukukçu sorusu: 13–17 yaş için cihazda konuşma tanıma (ses saklanmaz, gönderilmez) ve iOS izin penceresindeki Apple metni; KVKK aydınlatmasına "Söyle alıştırmaları" bölümü.
2026-10-13: Hukukçu sorusu: 13 yaş altının hesapsız, cihazda veriyle kullanımı (KVKK), mağaza aile politikaları ve ebeveyn kapısı gereksinimi.
2026-10-14: Profil ekranının yeniden tasarımı H-059'a taşındı; bu iş hukuk metinleri, bildirim ayarları ve hesap silme arayüzünün içeriğiyle kalır.
2026-10-21: **Kullanıcı onayı (plan):** (1) hesap silme/geri alma uçtan uca: oturum kapandıktan sonra da "silme bekliyor + kalıcı silme tarihi" görünür, geri almada yeni kod gerekçesi açıklanır, silme → yeniden giriş → geri alma testi; (2) Profil → "Hakkında ve lisanslar": sürüm, CEFR-J v1.6 zorunlu atfı, Octanove CC BY-SA, py-fsrs MIT, EnglishPractice MIT, yazı tipleri OFL, Flutter lisans sayfası; kullanım şartları ve gizlilik metni Profil'den de açılır (taslak işaretli); (3) günlük hatırlatma (H-013): aç/kapa + saat, günde en fazla 1, izin yalnız açınca, sakin ve spoilersiz metin, veri cihazda; `flutter_local_notifications` + `timezone` eklentisine izin verildi; (4) `docs/HUKUK-SORULARI.md`: hukukçuya tek seferde gidecek soru listesi. Profil'de CEFR seviyesi gösterilmez (K-08 vaat yasağı).
2026-10-21: **Uygulandı (commit edilmedi, onay bekliyor):**
- **(1) Silme / geri alma uçtan uca.** Silme isteğinden sonra cihazda küçük bir işaret kalır: `app_meta` `account.pendingDeletion` = hesap kimliği + kalıcı silme anı; e-posta yok.
  - **Hesap ekranı (oturum kapalı):** "Hesabın silinmek üzere" kartı, tarih ve **Hesabımı geri al**. Profil → Hesap satırı da aynı durumu söyler.
  - **Giriş ekranı:** "Geri almak için yeni bir kod gerekiyor" gerekçesi. Geri alma adımı kodun neden istendiğini de söyler.
  - **İşaret ne zaman silinir:** geri alınınca, aynı hesap başka cihazda geri alınıp girilince ya da kalıcı silme tarihi geçince. Başka hesapla girişte kalır.
  - **Kod:** `SyncStore.pendingDeletion/recordPendingDeletion/clearPendingDeletion`, `AuthService.deleteAccount/restore`, `pendingDeletionProvider`.
  - **Test:** `account_ui_test.dart` "H-042 uçtan uca" (sil → çıkış → kart → kodla giriş → geri al → işaret yok); `auth_service_test.dart` işaret grubu.
  - Backend'e dokunulmadı. Canlı uçtan uca deneme yapılmadı; yerel backend (:8080) ve Postgres (:5435) kullanıcının pilot ortamı.
- **(2) Profil → Hakkında grubu.** Satırlar:
  - **Kullanım koşulları** ve **KVKK aydınlatma metni**: "Taslak · hukuk teyidi bekliyor"; mevcut `LegalTextScreen`'i açar.
  - **Hakkında ve lisanslar** (`AboutScreen`, `/profil/hakkinda`): sürüm, atıflar (LISANS-RAPORU §4; CEFR-J zorunlu biçimi "on 11/10/26"), **Açık kaynak lisansları** (`showLicensePage`).
  - **Atıflar:** CEFR-J v1.6, Octanove C1/C2 (CC BY-SA, ayrı veri seti), py-fsrs (MIT), EnglishPractice (MIT; yalnız kod deseni, içerik yok), Inter + Nunito (OFL).
  - **MIT bildirimleri:** py-fsrs ve EnglishPractice'in MIT metinleri Lisanslar sayfasına eklendi (`app/third_party_licenses.dart`; telif satırları kaynak LICENSE dosyalarından).
  - **Sürüm:** Ek eklenti (`package_info_plus`) yerine derleme sabiti kullanıldı (`app/app_info.dart`; `--dart-define=HV_APP_VERSION`). Varsayılanın `pubspec.yaml` ile aynı olduğu testle denetlenir.
- **(3) Günlük hatırlatma** (`features/reminder/`):
  - **Profil → Öğrenme:** "Günlük hatırlatma" anahtarı (varsayılan kapalı, 19:00) ve açıkken "Hatırlatma saati".
  - **İzin:** Yalnızca açarken sorulur. Verilmezse anahtar kapalı kalır, sakin bir not çıkar. Sonradan kapatılırsa satır nedenini söyler.
  - **Kurulum:** Tek kimlikle günlük tek bildirim; Android'de `inexactAllowWhileIdle`, kesin alarm izni yok.
  - **Yeniden kurma:** Açılışta ve uygulama öne gelince (saat dilimi değiştiyse yeni dilimde). Saat dilimi cihazdan okunur (`tr.velzon.hivelzon/device` kanalı; ek eklenti yok).
  - **"Bu telefondaki verileri sil":** Hatırlatmayı kaldırır, ayarı siler.
  - **Veri:** Yalnızca `app_meta` `reminder.enabled` / `reminder.time`; eşitlenmez.
  - **Bağımlılıklar:** `flutter_local_notifications` 22.3.2 (BSD-3) + `timezone` 0.11.2 (BSD-2). Yan bağımlılıklar `xml` ve `petitparser` MIT; `dbus` MPL-2.0 ve yalnız Linux'ta derlenir. Lisans notu `pubspec.yaml`'da.
  - **Android:** `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, iki alıcı, core library desugaring.
  - **iOS:** `UNUserNotificationCenter` temsilcisi.
  - **Test:** `test/features/reminder/` (sahte zamanlayıcı ile kurallar, satır widget testi).
- **(4)** `docs/HUKUK-SORULARI.md`: hukukçuya tek seferde gidecek 9 başlık.
- **Metinler** `docs/ARAYUZ-METINLERI.md` §6 ve §12'ye eklendi.
- **Golden'lar:** Yeni olanlar `h042_hakkinda`, `h042_hesap_silme_bekliyor`, `h042_geri_al`, `h042_hatirlatma`. `h059_profil` ve `h059_profil_adsiz` yeniden üretildi; yeni satırlar görünsün diye yükseklik artırıldı.
- **Açık:**
  - Hukuk metinlerinin kesin hâli hukukçudan gelecek (`HUKUK-SORULARI.md`).
  - Octanove veri dosyası henüz depoda yok; atıf ileriye dönük.
  - Android bildirim ikonu şimdilik uygulama ikonu (`@mipmap/ic_launcher`); tek renkli ikon H-016 logo işiyle.
  - Kabul kriterinin canlı backend'le cihazda denenmesi pilot ortamı dışında yapılmalı.
