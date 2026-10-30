# H-068: Arka planda dinleme ve kilit ekranı

- **Durum:** Devam ediyor (2026-10-30 itibarıyla değişmedi): kod main'de; simülatörde arka planda çalma daha önce doğrulandı. Kalan gerçek iPhone'da arka plan sesi, kilit ekranı görünümü ve kumanda kontrolü. Kullanıcının cihazı/test izni gerekir.
- **Tür:** Uygulama (kod)
- **Faz:** Kitaplık K3 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-067

## Kapsam
- `just_audio` + `audio_service` (lisans kontrolü önce).
- iOS `UIBackgroundModes: audio`.
- Android medya bildirimi.
- Kilit ekranı denetimleri: oynat/duraklat, 10 sn geri, kitap adı ve kapak.
- Uyku zamanlayıcısı arka planda da çalışır.
- Mikrofon gibi yeni izin istenmez.

## Kabul kriterleri
- Ekran kilitliyken ses sürer; kilit ekranından duraklatılır.
- Testler yeşil.

## Test
`cd mobile && flutter analyze && flutter test` + simülatör/cihaz denemesi

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.

### Uygulama (2026-10-14, dal `h-068-arka-planda-dinleme`)
**Paketler ve lisanslar** (pub önbelleğindeki `LICENSE` dosyalarından doğrulandı):

| Paket | Sürüm | Lisans |
|---|---|---|
| `just_audio` | 0.10.6 | MIT |
| `audio_service` | 0.18.19 | MIT |
| `audio_session` | 0.2.4 | MIT |
| yan: `just_audio_platform_interface` 4.6.0, `just_audio_web` 0.4.16, `audio_service_platform_interface` 0.1.3, `audio_service_web` 0.1.4 | | MIT |
| yan: `flutter_cache_manager` 3.4.5 (kapak indirme), `synchronized` 3.4.0 | | MIT |
| yan: `sqflite*` 2.4.x (önbellek dizini) | | BSD-2-Clause |
| yan: `rxdart` 0.28.0 | | Apache-2.0 |
| geliştirme: `fake_async` 1.3.3 (zaten `flutter_test` ile geliyordu) | | Apache-2.0 |

**Kod** (`mobile/lib/features/library/application/`):
- `BookAudio` arayüzü değişmedi; okuyucu mantığı ve H-067 testleri aynen geçer.
- `book_media_session.dart`: `BookMediaSession` (komut akışı + künye) ve `BookRemoteCommand` (oynat, duraklat, 10 sn geri, sonraki bölüm, durdur).
- `background_book_audio.dart`: `BackgroundBookAudio` (`BookAudio` + `BookMediaSession`). Altında `BookAudioEngine` (`JustAudioEngine`) ve `BookSessionHost` var.
  - Kesintiler (arama, kulaklığın çıkması) çalara bırakılmaz. Okuyucuya komut olarak gelir; okuyucu sesin tek sahibidir, saat kaymaz.
  - Duraklama bildirime 0,8 sn gecikmeyle yansır. Bölüm geçişindeki anlık duraklama Android ön plan hizmetini düşürmez (Android 12+ arka planda yeniden başlatmayı yasaklar). Kilit ekranından duraklatma hemen yansır.
- `audio_service_host.dart`: uygulamada tek oturum (`audio_service` + `audio_session`).
  - iOS: `AVAudioSession` `playback` kategorisi, `spokenAudio` kipi. Her çalmada yeniden ayarlanır, çünkü "Söyle" kategoriyi değiştirebilir.
  - Kilit ekranı: 10 sn geri (iOS skipBackward 10 sn), oynat/duraklat, sıradaki bölümün sesi varsa "Sonraki bölüm". Kulaklığın "geri" düğmesi = 10 sn geri.
  - Künye: başlık = bölüm adı, albüm/sanatçı = kitap adı, kapak = paketteki `images/cover.webp`, süre.
  - Sahiplik: eski okuyucu yenisinin oturumunu kapatamaz.
  - Kapanınca `idle` durumu gönderilir; hizmet ve bildirim kalkar, ses odağı bırakılır.
- `main.dart`: `AudioService.init` başlangıçta bir kez çağrılır, beklenmez (eklenti belgesindeki gibi).
- `reader_controller.dart`:
  - Komutları dinler.
  - Bölüm açılınca künyeyi gönderir.
  - `nextChapter()` ekler.
  - `resync()`: öne dönünce konumu duvar saatinden değil çalardan alır; vurgu, sayfa, bölüm sonu ve uyku zamanlayıcısı hemen eşlenir.
- `reader_screen.dart`: `WidgetsBindingObserver` kullanır; `resumed` olunca `resync()` çağrılır.
- Okuyucu kapanınca (`dispose`) çalar durur ve oturum kapanır.
- Uyku zamanlayıcısı okuyucunun 50 ms adımıyla arka planda da çalışır. Ses çaldığı için iOS ve Android süreci askıya almaz.
- Arka plan sesini yalnız kitap okuyucusu kullanır.
  - Bölüm, Keşfet ve dilbilgisi `video_player` ile kalır. Arka plana geçince yine durur.
  - Dilbilgisi için `VideoPlayerBookAudio` korunur.

**Platform ayarları:**
- iOS `Info.plist`: `UIBackgroundModes = [audio]`.
- Android `AndroidManifest.xml`:
  - Eklenen izinler: `WAKE_LOCK`, `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`. Bunlar kurulum izinleridir; kullanıcıya sorulmaz.
  - `AudioService` hizmeti eklendi (`mediaPlayback`) ve `MediaButtonReceiver` eklendi.
  - `MainActivity` artık `AudioServiceActivity`'den türer.
- Bildirim:
  - Kanal "Kitap dinleme"; rozet yok, varsayılan önem.
  - Android 13+ medya oturumu bildirimi `POST_NOTIFICATIONS` muafiyetindedir, bu yüzden izin istenmez.
- Yeni mikrofon ya da ağ izni yok.

**Testler:**
- `test/features/library/background_book_audio_test.dart`: 9 bağdaştırıcı testi. Sahte motor ve sahte oturumla aç/çal/duraklat/atla/hız/konum, künye, duraklama gecikmesi, komut sahipliği, kapatma, oturum hatası.
- `test/features/library/reader_background_test.dart`: 7 test.
  - Künye ve kapak.
  - Kilit ekranı komutları.
  - Öne dönünce çalardan eşleme. Test `resync` olmadan kırmızı olduğu denetlenerek doğrulandı.
  - Uyku zamanlayıcısı arka planda durdurur.
  - Okuyucu kapanınca oturum kapanır.
  - Taklit edilen yaşam döngüsünde (paused → resumed) bölüm sonu uyku zamanlayıcısı.
- H-067 okuyucu testleri değişmedi. `library_harness.dart`'a yalnız `background: true` seçeneği eklendi.
- `cd mobile && dart format . && flutter analyze && flutter test`: 863 test yeşil.

**Elle deneme:**
- `flutter build ios --simulator --debug` geçti (`pod install` ile). `flutter build apk --debug` geçti.
- Geçici simülatörde (iPhone 17 Pro, iOS 26.5; sonra silindi) `integration_test/h068_background_test.dart` çalıştırıldı.
  - Kitap: A1-K01; içerik sunucusu ayrı portta (8797).
  - Uygulama `simctl launch com.apple.Preferences` ile arka plana alındı ve 10 sn sonra öne getirildi.
  - Yaşam döngüsü: paused → resumed.
  - Arka planda geçen 11,9 sn'de çalar konumu 3,63 → 15,56 sn ilerledi; ses durmadı.
  - Okuyucu kapanınca oturumun sahibi kalmadı.
- Kilit ekranı görünümü (künye, kapak, düğmeler) simülatörde gözle denetlenmedi; gerçek cihazda bakılmalı.
- Android cihaz ya da emülatör denemesi yapılmadı.
