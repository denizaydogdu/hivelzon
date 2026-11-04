# H-106: Açılışta "[H042] hatırlatma yeniden kurulamadı: ArgumentError" günlüğü

- **Durum:** 🔄 Kod düzeltildi, simülatör doğrulaması bekliyor (2026-11-04). Günlük artık tür + kısa, kişisel
  veri içermeyen açıklama + atıldığı kod yerini yazıyor; gerçek kaynak bir sonraki simülatör çalıştırmasında
  bu satırdan okunacak.
- **Tür:** Hata incelemesi (mobil, günlük hatırlatma)
- **Öncelik:** Düşük–Orta (uygulama açıldı, kullanıcıya hata gösterilmedi)
- **Bağımlılık:** H-042 (günlük hatırlatma), H-013 (günde en fazla 1 hatırlatma)

## Gözlem

2026-11-04'te kullanıcının simülatördeki (PIRU iPhone 17, `flutter run` debug) kısa denemesinde, uygulama açılırken
şu satır iki kez görüldü:

```
[H042] hatırlatma yeniden kurulamadı: ArgumentError
```

Satır `mobile/lib/features/reminder/application/reminder_providers.dart` → `DailyReminderService.sync()`
yakalayıcısından gelir (açılışta ve uygulama öne gelince; iki kez görülmesi bununla uyumlu). Günlüğe yalnız
`e.runtimeType` yazıldığı için mesaj ve yer bilinmiyordu.

## İnceleme (simülatör açılmadan, 2026-11-04)

### 1. Kütüphane kaynağı: `ArgumentError` atabilecek yerler

`~/.pub-cache` içinde sürümler: `flutter_local_notifications 22.3.2`, platform arayüzü `12.2.0`, `timezone 0.11.2`,
`drift 2.31.0`.

| Yer | Koşul | Bizim çağrıda |
|---|---|---|
| `validateId` (platform arayüzü `helpers.dart`) | kimlik 32 bit dışı | kimlik `4201`; olmaz |
| `validateDateIsInTheFuture` (`helpers.dart:16`) | `matchDateTimeComponents == null` ve tarih geçmişte | `DateTimeComponents.time` veriliyor, denetim atlanır; tarih de hep gelecekte (`nextReminderAt`) |
| `FlutterLocalNotificationsPlugin.initialize` | o platformun ayarı `null` | iOS ve Android ayarı veriliyor; olmaz |
| `resolvePlatformSpecificImplementation` | tür parametresi soyut sınıf | somut sınıflar kullanılıyor; olmaz |
| `StandardMessageCodec.writeValue` (`message_codecs.dart:464`) | kanala desteklenmeyen tür | gönderilen haritalar yalnız `String/int/bool/null/List/Map`; olmaz |
| `timezone` | `ArgumentError` hiç atmaz (`LocationNotFoundException`, `TimeZoneInitException`) | bilinmeyen dilim zaten yakalanıp yedek dilime düşülüyor |

Yerel (Swift) taraftaki hatalar Dart'a `PlatformException` olarak gelir, `ArgumentError` olarak değil.

### 2. Gerçek eklentiyle yeniden üretme denemesi

`test/features/reminder/local_notifications_scheduler_test.dart`: gerçek `LocalNotificationsReminderScheduler`,
gerçek eklenti Dart kodu (iOS hedefi, `IOSFlutterLocalNotificationsPlugin`), yalnız yerel kanallar sahte.
`permission()` + `scheduleDaily()` hata atmadı; gönderilen `zonedSchedule` argümanları geçerli
(kimlik 4201, `timeZoneName` cihaz dilimi, `matchDateTimeComponents = time`). Cihaz dilimi `GMT+0300`, boş,
`null` ya da `PlatformException` olduğunda da yedek dilimle kuruldu. **Dart tarafındaki zamanlama yolu
`ArgumentError` üretmiyor.**

### 3. Simülatörün diskteki verisi (salt okunur; simülatör açılmadı)

- PIRU iPhone 17'deki uygulama kabının `Library/Application Support/hivelzon.sqlite` dosyası
  (`tr.velzon.hivelzon`) salt okunur açıldı: `app_meta` içinde `reminder.enabled` ve `reminder.time` **yok**,
  yani hatırlatma **kapalı** (varsayılan). Dosyanın son değişikliği 2026-11-01 17:06; `-wal` yok, günlük kipi
  `delete`. 2026-11-04 çalıştırması veritabanına hiç yazmadı (aynı kabın önbellek dosyaları 2026-11-04 tarihli,
  yani doğru kap).
- Hatırlatma kapalıyken `sync()` ilk satırda `store.read()` ile ayarı okur ve hemen döner; zamanlayıcıya ve
  eklentiye hiç dokunmaz. Bu dosyanın bir kopyasıyla (`NativeDatabase.createInBackground`) `ReminderStore.read()`
  ve `sync()` testte hatasız çalıştı (`ReminderSettings(false, 19:00)`).
- Simülatörün birleşik günlük dosyaları (`tracev3`) sıkıştırılmış; içinden `H042` satırı okunamadı.

### Sonuç: kök neden kanıtlanamadı

- **Kanıtlanan:** hata hatırlatma zamanlama yolundan (eklenti, saat dilimi, kimlik, tarih) gelmiyor; hatırlatma
  kapalıyken bu yol hiç çalışmıyor. Bu durumda `sync()` içinde hata atabilecek tek adım `store.read()`
  (eski kayıt taşıma beklemesi + `app_meta` sorgusu).
- **Kanıtlanamayan:** `store.read()`'in o çalıştırmada neden `ArgumentError` attığı. Testte (bellek içi ve
  simülatör veritabanının kopyası) üretilemedi. Bir aday: veritabanı o çalıştırmada açılamadıysa (2026-11-04'te
  hiçbir yazma olmaması bununla uyumlu) hata buradan gelir; ama bu bir **tahmindir**, kod buna göre
  değiştirilmedi.
- Tahmine dayalı davranış düzeltmesi yapılmadı. Yapılan: bir sonraki çalıştırmada kaynağı gösterecek
  teşhis günlüğü.

## Düzeltme (davranış değişmedi)

- `reminder_scheduler.dart`: yeni `reminderErrorSummary(error, [stack])`. Yazdıkları:
  - tür;
  - `ArgumentError`'da parametre adı (`name=…`) ve kütüphanenin sabit açıklaması (en fazla 120 karakter);
    **geçersiz değer yazılmaz**;
  - `PlatformException`'da yalnız `code` (mesaj/ayrıntı yazılmaz);
  - yığındaki ilk `package:…:satır:sütun` yeri (makinedeki dosya yolu yazılmaz).
  - Öteki hatalarda hata metni (`toString`) yazılmaz: e-posta, yol, token içerebilir.
- `reminder_providers.dart`: beş `[H042]` yakalayıcısı ve `reminder_scheduler.dart`'taki saat dilimi yakalayıcısı
  `${e.runtimeType}` yerine `${reminderErrorSummary(e, st)}` yazar. Satırlar yine `…: <Tür>` ile başlar.
  Örnek: `[H042] saat dilimi okunamadı: LocationNotFoundException @ package:timezone/src/location_database.dart:41:7`.
- Hatırlatma davranışı aynı: varsayılan kapalı, izin yalnız kullanıcı açınca, günde tek bildirim (aynı kimlik),
  saati kullanıcı seçer (H-013); hata uygulamayı düşürmez, ayarı değiştirmez.

## Testler

- `test/features/reminder/reminder_error_log_test.dart` (önce kırmızı: `reminderErrorSummary` yoktu):
  - `reminderErrorSummary` · ArgumentError: tür + parametre adı + sabit açıklama + atıldığı yer; değer yazılmaz
  - `reminderErrorSummary` · atıldığı kütüphane yeri yazılır (kanal kodlayıcısı örneği)
  - `reminderErrorSummary` · başka hatalarda hata metni yazılmaz (e-posta, yol, token)
  - `reminderErrorSummary` · PlatformException: yalnız kod, mesaj ve ayrıntı yazılmaz
  - `reminderErrorSummary` · uzun açıklama kısaltılır (en fazla 120 karakter)
  - `DailyReminderService günlüğü` · açılış eşlemesi hata verirse günlükte tür ve kısa açıklama olur; uygulama
    düşmez, ayar değişmez
  - `DailyReminderService günlüğü` · hatırlatma kapalıysa sync işletim sistemine dokunmaz, günlük boş
- `test/features/reminder/local_notifications_scheduler_test.dart` (kanıt testi):
  - iOS: günlük hatırlatma tek kimlikle, her gün aynı saatte, cihaz diliminde kurulur
  - iOS: cihaz dilimi tanınmazsa ya da okunamazsa yedek dilimle kurulur, hata atılmaz
- Sonuç (2026-11-04): `flutter analyze` temiz; `flutter test` **1526/1526** (önce 1517 + 9 yeni).

## Kabul kriterleri

- [ ] Hatanın gerçek nedeni (hangi çağrı, hangi argüman) bulunup bu dosyaya yazıldı. — **Kısmen:** zamanlama
  yolu dışlandı, kaynak `store.read()` adımına daraltıldı; kesin yer bir sonraki simülatör günlüğünden okunacak.
- [x] Neden bir kusursa düzeltildi ve onu yakalayan test eklendi; kusur değilse gerekçesi yazıldı. — Davranış
  kusuru kanıtlanmadı; teşhis eksikliği (yalnız tür) düzeltildi ve testlendi.
- [x] `cd mobile && flutter analyze && flutter test` yeşil (1526/1526).

## Kullanıcının simülatörde denemesi (izinle)

1. `flutter run -d "PIRU iPhone 17"` ile uygulamayı aç; konsolda `[H042]` ile başlayan satırlara bak.
2. Satır yine çıkarsa tamamını (ör. `ArgumentError name=… "…" @ package:…:satır:sütun`) bu dosyaya ekle;
   kesin kaynak buradan okunur ve ayrı, küçük bir düzeltme yapılır.
3. Satır çıkmazsa: Profil → günlük hatırlatmayı aç, izin ver, saati değiştir; uygulamayı arka plana alıp öne
   getir. `[H042]` satırı çıkmamalı; bildirim seçilen saatte bir kez gelmeli.
4. İş sonunda simülatör/sunucu kapatılır ve temizlik yapılır (CLAUDE.md).

## Geri alma

Tek commit olarak geri alınır (yalnız günlük metni ve testler; davranış değişmedi).

## Kök neden bulundu (2026-11-04 öğleden sonra, simülatör)

Yeni teşhis günlüğü ilk açılışta kaynağı gösterdi:
`ArgumentError "Couldn't resolve native function 'DOBJC_initializeApi' in 'package:objective_c/objective_c.dylib' …" @ package:objective_c/src/internal.dart:237:22`.

- Hata hatırlatmaya özgü değil: aynı açılışta H035/H036/H038/H039/H053/H060/H074/H103 kayıt okumaları da aynı hatayla düştü. Ana Sayfa ve Öğren "bağlantı kurulamadı" gösterdi. Kullanıcı bunu bildirdi.
- `Runner.app/Frameworks` içinde `objective_c.framework` yoktu; `build/native_assets/ios` boştu. Derleme günlüğünde `Target native_assets required define SdkRoot but it was not provided` satırı vardı.
- **Neden:** Temizlik kuralı (2026-11-03) yalnız `mobile/build/` ve DerivedData'yı siliyor, `.dart_tool/` klasörünü bırakıyordu. Bu yüzden `.dart_tool/flutter_build` ve `hooks_runner` önbellekleri bayatladı. Sonraki derlemede yerel varlık (native assets) adımı atlandı ve `objective_c` çerçevesi pakete girmedi. `path_provider_foundation` ve benzeri eklentiler `objective_c` FFI kullandığı için cihazdaki bütün yerel kayıtlar (drift) okunamadı.
- **Düzeltme:** `flutter clean && flutter pub get` sonrası yeniden derlendi. `objective_c.framework` pakette, `DOBJC` hatası 0, `[H0xx] … okunamadı` satırı yok, Ana Sayfa 2.280 ms'de hazır.
- **Kalıcı önlem:** `CLAUDE.md` temizlik kuralı değişti. Derleme çıktıları artık `flutter clean && flutter pub get` ile temizleniyor; `.dart_tool/` tek başına bırakılmıyor.
- Teşhis günlüğü (`reminderErrorSummary`) kalıyor: kaynağı bulan oydu.
- **Kalan:** Kullanıcı simülatörde Ana Sayfa, Öğren ve hatırlatmayı denedikten sonra `bitenler/`e taşınır.
