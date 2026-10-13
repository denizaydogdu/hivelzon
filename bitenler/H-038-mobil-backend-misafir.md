# H-038: Mobil ↔ backend bağlantısı ve misafir modu

- **Durum:** Bitti
- **Tür:** Uygulama (kod)
- **Faz:** 1.6 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-035, H-037

## Kapsam
- Kayıt ve giriş ekranları.
- Misafir (prolog + B1) verisinin hesaba taşınması.
- İlerleme ve olay eşitleme; idempotent `client_event_id`.

## Kabul kriterleri
- Misafir → kayıt akışı veri kaybetmeden çalışıyor.
- Aynı olay iki kez gönderilince tek kayıt oluşuyor (test).

## Test
```bash
cd mobile && flutter test
cd backend && mvn verify
```

## Geri alma
Kendi dalında (`h-038-mobil-backend-misafir`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12: Mobil taraftaki yerel veri Drift'te (H-035; H-036 sonrası defter ve FSRS de). Misafirden hesaba taşıma bu tablolardan yapılır. Öğrenme olayları (H-046) `client_event_id` ile idempotent gönderilir. Misafir kapsamı: prolog + B1 (H-009).
2026-10-13: Kapsam değişti (H-009 güncellendi): misafir sınırı yok; hesap isteğe bağlı. Bu işte: isteğe bağlı "Hesap aç / giriş yap" (e-posta kodu), cihazdaki verinin hesaba ilk eşitlenmesi, sonra çift yönlü eşitleme; hesap yoksa hiçbir veri sunucuya gitmez. Sakin uyarı metni ("İlerlemen yalnızca bu telefonda…").
2026-10-13 (H-037'den): Kullanıcı kararı: "Hi'nin kayıtlarını sil" bütün cihazlarda geçerli → sunucu silme işareti (tombstone) eşitlemeyle diğer cihazlara gider. Mobil Drift şema 5: `user_story_flags` ve `season_state`'e `updatedAt`, `review_logs` ve `speech_attempts`'e UUID; kimlikler UUIDv5 kuralıyla (backend README).

2026-10-13 (doğrulama özeti):
- **Yapılan (mobil):**
  - Drift şema 5: `user_story_flags`, `season_state`, `notebook_items` ve `review_cards` tablolarına `updatedAt` eklendi. `review_logs`, `learning_events` ve `speech_attempts` tablolarına UUID `clientId` (tekil dizin) eklendi.
  - Eski satırlar deterministik dolduruldu:
    - cevap: backend `/review/rate` kuralıyla UUIDv5;
    - olay: 32 haneli kimliğin tireli hâli;
    - "Söyle": yerel sıra + içerikten UUIDv5.
  - Yeni tablolar: `sync_state` (hesap, imleç, son eşitleme, maskeli e-posta) ve `sync_outbox` (değişiklik kuyruğu). Kuyruğu SQLite tetikleyicileri doldurur, yalnızca hesap açıkken. Silinen satır kuyrukta silme işareti olarak durur.
  - Doğal anahtarlı tabloların kimliği saklanmaz, her seferinde anahtardan UUIDv5 hesaplanır.
  - Yeni klasörler:
    - `lib/shared/api/`: istemci, belirteç deposu, oturum;
    - `lib/shared/sync/`: kimlik, şema, depo, motor;
    - `lib/features/account/`: Profil → Hesap, giriş akışı, hukuk metni yer tutucusu, Ana Sayfa kartı.
  - Metinler: `AccountTexts` ve `docs/ARAYUZ-METINLERI.md` §12.
- **Backend sözleşme düzeltmesi (V5):**
  - Mobilin `hunt_done` (hi_records) ve `topic_set` (notebook_items) değerleri reddediliyordu. Reddedilen bir değer bütün itmeyi düşürürdü.
  - "Hi'nin kayıtlarını sil" öteki cihazlara gitmiyordu: `DELETE /sync/speech-attempts` yalnızca sunucuda siliyordu, öğrenme olayları hiç silinmiyordu.
  - Çözüm: `hi_reset` işareti ve `HiResetHook`.
  - UUIDv5 test vektörleri iki tarafta da aynı: `UuidsTest` ve `sync_ids_test.dart`.
- **Testler:**
  - `flutter analyze` temiz.
  - `flutter test`: 389 geçti (önce 356).
  - `mvn -B verify`: 97 geçti (önce 94).
- **Uçtan uca (simülatör "hiVelzon iPhone 17", backend 8080 dev, PostgreSQL 5435, Mailpit 8027):**
  - Araç: `integration_test/h038_e2e_test.dart` (`flutter drive --keep-app-running`, aşama 0–3). Görüntüler ve loglar `.yerel/h038/`'de.
  - A cihazı: kullanıcının yedek verisiyle (şema 4 → 5) başladı, hesapsızdı. Hesap açıldı, kod Mailpit'ten okundu. İlk yükleme sunucuya gitti: ilerleme 3, defter 10, cevap 18, olay 9, "Söyle" 1. Sonra ifade + olay + yan görev eklendi; "Şimdi eşitle" ile defter 11, olay 10, Hi kaydı 1 oldu.
  - Hesapsız dönemde sunucuya yazma olmadı. Hesabın ilk satırı 20:27:03.29'da, SIGNUP'tan 0,2 sn sonra yazıldı (denetim kaydı ve `server_updated_at`). Not: backend istek logu açılamadı; kanıt bunlar.
  - B cihazı: uygulama verisi silindi. Aynı e-postayla girişte bütün veri geri geldi (defter 11, cevap 18, olay 10). "Hi'nin kayıtlarını sil" sonrası sunucuda öğrenme olayı ve "Söyle" 0. İşaret ve yan görevin silme işareti sunucuda; `DELETE /sync/speech-attempts` çağrıldı.
  - A cihazı yeniden açıldı: açılış eşitlemesinde işaret geldi, yereldeki 10 olay, 1 "Söyle" sonucu ve yan görev silindi. Çıkıştan sonra veri cihazda kaldı, kuyruk boşaldı, LOGOUT denetim kaydına yazıldı.
- **Kapanış:** backend durduruldu. Kullanıcının simülatör verisi geri kondu ("Deniz", 3 bölüm, 10 ifade); açılışta şema 5'e taşındı, hesap yok. Normal debug derlemesi çalışıyor.
- **Bilinen sınır:** başka cihazdan gelen veriyle ekran yenileme yalnızca Ana Sayfa'da yapılıyor (`RemoteDataRefresher`). Görünmeyen sekmede türetilmiş sağlayıcıyı geçersiz kılmak, sekme yeniden görünürken Riverpod 3'te "build sırasında setState" hatası verdi. Hikâye haritası oynatıcıdan dönünce zaten yenileniyor.
2026-10-13 (ana oturum): flutter test 389/389, mvn verify 97/97 yeniden doğrulandı. Kullanıcı kararları → H-056: "bitti" her zaman kazanır; yenileme anahtarına 30 sn hoşgörü; çıkışlıyken yapılan Hi silme girişte hesaba işlenir; sekme yenileme hatası düzeltilir. Commit onayı; integration_test repoda kalır (elle çalıştırılır).
