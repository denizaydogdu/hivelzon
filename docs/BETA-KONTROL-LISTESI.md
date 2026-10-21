# İç beta kontrol listesi (H-043)

Faz 1.11. Amaç: uygulamayı iç beta için gerçek telefonlara güvenle kurabilmek. Liste üç bölümdür:

1. bu Mac'te yapılıp doğrulanabilenler (komutlarla);
2. gerçek telefon isteyenler;
3. H-044 (imza, mağaza, gerçek adresler) bekleyenler.

Kabul ölçütü (H-043): 1. ve 2. bölüm tamam. 3. bölüm H-044'tedir.

## 1. Yerelde doğrulananlar

| # | Madde | Durum | Doğrulama |
|---|---|---|---|
| 1.1 | Statik denetim ve bütün testler | Tamam (2026-10-21) | `cd mobile && flutter analyze && flutter test` |
| 1.2 | Android release manifestinde `INTERNET` izni | Tamam | `grep INTERNET mobile/android/app/src/main/AndroidManifest.xml`. Daha önce izin yalnız debug/profile manifestlerindeydi; release derlemesi ağa çıkamazdı. |
| 1.3 | Yerel çökme kaydı | Tamam | `flutter test test/shared/diagnostics` |
| 1.4 | Sakin hata ekranı (yalnız release) | Tamam | Aynı test dosyası (`CalmErrorBox`) |
| 1.5 | Profil → **Hata kaydını paylaş** | Tamam | Aynı test dosyası |
| 1.6 | "Bu telefondaki verileri sil" hata kaydını da siler | Tamam | `flutter test test/features/account/account_ui_test.dart` |
| 1.7 | Sonsuz yükleme yok, hata ekranlarında **Tekrar dene** | Tamam | `flutter test test/goldens/h043_states_test.dart test/features/discover/discover_limit_test.dart` |
| 1.8 | Keşfet: yaş okunamazsa 20 dk sınırı (kullanıcı kararı 2) | Tamam | `flutter test test/features/discover/discover_limit_test.dart` |
| 1.9 | Hata ve boş durumlarda erişilebilirlik; 320 × 568, metin 1,3× | Tamam | `flutter test test/goldens/h043_states_test.dart` (kontrast denetimi yalnız macOS'ta) |
| 1.10 | h063 (Hi), h086 (sayfanın Türkçesi), h091 (kitap sonu anlama) için erişilebilirlik ve taşma testleri | Tamam | Aynı dosya |
| 1.11 | "Hareketi azalt": Keşfet ve oynatıcı geçişleri, alt paneller | Tamam | `flutter test test/app/design/reduce_motion_test.dart test/features/player/player_screen_test.dart` |
| 1.12 | iOS geliştirme bölgesi `tr`, Türkçe `InfoPlist.strings` | Tamam | `flutter build ios --simulator --debug --no-codesign` (aşağıda) |
| 1.13 | Sürüm `0.1.0+N`, `AppInfo` ile aynı | Tamam | `flutter test test/features/profile/profile_about_test.dart` |
| 1.14 | Geçici simge ve açılış ekranı | Tamam | `bash mobile/tool/placeholder_icons.sh` ile yeniden üretilir. **Geçici; asıl logo H-016.** |
| 1.15 | Android derlemesi | Tamam | `cd mobile && flutter build apk --debug` |
| 1.16 | iOS simülatör derlemesi | Tamam | `cd mobile && flutter build ios --simulator --debug --no-codesign` |
| 1.17 | `debugPrint` taraması | Tamam | Aşağıdaki not |

### Çökme kaydı nasıl çalışır

Kod: `mobile/lib/shared/diagnostics/`.

- **Yakalananlar:** `FlutterError.onError` (çizim hataları), `PlatformDispatcher.instance.onError` (yakalanmamış platform ve asenkron hatalar) ve `runZonedGuarded` (`main.dart`).
- **Ne saklanır:** son 200 satır. Her satırda yalnızca etiket (`flutter`, `platform`, `zone`), hata türü (`runtimeType`), yığının ilk 8 satırı, uygulama sürümü ve UTC saat bulunur.
  - Hata mesajı saklanmaz; mesaj adres, e-posta ya da kullanıcı metni içerebilir.
  - Yığın satırlarında adres, e-posta, belirteç, UUID ve kullanıcı klasörü adı yer tutucuyla değiştirilir.
  - Satır başına en çok 160 karakter tutulur.
  - Art arda gelen aynı hata tek satırda sayılır (`×N`).
- **Nerede:** `Application Support/diagnostics/crash_log.json`. Yazma atomiktir: önce geçici dosyaya yazılır, sonra yeniden adlandırılır.
  - **Neden Drift değil:** hata, veritabanının kendisinden de gelebilir. Hata yolunda veritabanına yazmak yeni hata ve döngü doğurabilir. Dosya, eşitleme tablolarından da bağımsız kalır.
- **Kimseye gitmez:** Üçüncü taraf ve ağ yoktur. Kullanıcı isterse Profil → Hakkında → **Hata kaydını paylaş** ile sistem paylaşım penceresinden düz metin olarak kendisi gönderir (`share_plus`, BSD-3).
- **Sakin hata ekranı:** Yayın derlemesinde `ErrorWidget.builder` kırmızı ekran yerine kum zeminli sakin bir kutu gösterir: "Burası şu an gösterilemiyor."

### `debugPrint` taraması (2026-10-21)

- `lib/` altında 154 `debugPrint` çağrısı var. H-043'ün yeni çağrılarının 6'sı `[H043]` etiketlidir.
  - Bu çağrılar yayın derlemesinde de cihaz günlüğüne yazar; günlük cihazda kalır.
- Hepsi `grep -rn debugPrint mobile/lib` ile tarandı. **Belirteç, e-posta, kod, tanınan konuşma (transcript), kullanıcının yazdığı mesaj ya da ad yazan çağrı yok.** Şöyle yazılıyor:
  - Hesap ve eşitleme hataları ile hatırlatma hatalarında yalnızca `runtimeType`.
  - Konuşma tanımada yalnızca platform hata kodu (`errorMsg`) ve izin sonucu.
  - Oynatıcıda içerik kimliği ve süreler.
- Bazı çağrılar yerel okuma/yazma hatasının metnini yazar (`$e`). Bu metinde SQL ya da içerik adresi olabilir, kişisel veri olmaz.
- Yeni günlük satırı eklerken kural aynı: kişisel veri yok, gerekiyorsa yalnızca `runtimeType`.

## 2. Gerçek telefon isteyenler

H-054 ölçümleri simülatörde ve **debug** derlemeyle yapıldı. Gerçek cihazda **profile** derlemesiyle ölçülür ve aşağıdaki temel değerlerle karşılaştırılır (`bitenler/H-054-performans-temel.md`):

| Ölçüm | H-054 temel (simülatör, debug) | Gerçek telefonda hedef |
|---|---|---|
| Soğuk açılış → ilk kare (`simctl launch`) | 1990–2030 ms (kurulumdan sonraki ilk açılış 3574 ms) | Temelden kötü değil; ucuz Android'de not et |
| `main()` → ilk kare | 798–869 ms | |
| Soğuk açılış → Ana Sayfa hazır | 2251–2388 ms | 4G ağ koşuluyla ayrıca ölç |
| Sıcak açılış → ilk kare | 637–1095 ms; ön plana dönüş 8–11 ms | |
| Bölüm açılışı → başlık videosunun ilk karesi (B1, 720p) | 830 ms | 4G ağ koşuluyla |
| Segment geçişleri | auto 33–44 ms, karar 141 ms | H-031 sınırı 150 ms |
| Harita kaydırma | ort. 1,3–1,7 ms derleme; 16,7 ms üstü kare 0 | Ucuz Android'de 60 fps'e yakın; takılan kare sayısı not edilir |
| Defter kaydırma | 16,7 ms üstü kare 0 | |
| Ses–yazı farkı | 0,003–0,010 sn (dosyada) | **≤ 0,2 sn** (gerçek telefonda kulakla + kayıtla) |

Ölçüm satırları uygulamanın `[H054]` günlüğünde görünür. Günlük yalnızca debug ve profile derlemelerde açılır.

| # | Madde | Telefon | Not |
|---|---|---|---|
| 2.1 | Ucuz Android'de oynatıcı: bellek ve ısınma (10 dk bölüm + Keşfet) | Düşük uçlu Android | Android Studio Profiler ya da `adb shell dumpsys meminfo tr.velzon.hivelzon` |
| 2.2 | Gerçek telefonda ses–yazı farkı ≤ 0,2 sn | iPhone + Android | B1–B4'te karar anı öncesi satırlar |
| 2.3 | Soğuk açılış, bölüm açılışı, harita kare hızı (4G) | Ucuz Android, iPhone | Yukarıdaki tablo; Wi-Fi yerine telefon verisi ya da ağ kısıtlama |
| 2.4 | "Söyle" izin akışı (iPhone) | iPhone | İzin penceresi Türkçe mi (`tr.lproj`)? Apple'ın sabit "ses Apple'a gönderilebilir" cümlesi çıkıyor mu? Biz cihazda tanımayı zorunlu tutuyoruz; metin ve hukuk incelemesi (H-055). İzin reddedilince her şey dokunarak çalışıyor mu? |
| 2.5 | "Söyle" izin akışı (Android), İngilizce dil paketi **yokken** | Android | Paket yoksa "Söyle" düğmeleri görünmemeli (H-055). Paket indirilince görünmeli. |
| 2.6 | Android'de `audio_service` (kilit ekranında kitap dinleme), bildirimler (günlük hatırlatma), Drift veritabanı | Android | Yeniden başlatma sonrası hatırlatma (BOOT_COMPLETED) |
| 2.7 | Uçtan uca deneme: açılış → B1 → defter → kelime tekrarı → Keşfet → kitap → Profil (hata kaydını paylaş) | iPhone + Android | `tools/device-build.sh` ile |
| 2.8 | Geçici simge ve açılış ekranı telefonda düzgün mü | iPhone + Android | Android 12+ sistem açılış ekranı kum renginde |

### Cihaz derlemesi (yerel ağ)

```bash
tools/device-build.sh print                     # adresleri ve adımları yaz
tools/device-build.sh run profile -- -d <cihaz>  # telefonda profile ile çalıştır
tools/device-build.sh apk profile                # Android APK (profile)
tools/device-build.sh ios debug                  # iOS (Xcode'daki geliştirici takımıyla imzalanır)
```

- **Adres:** Betik Mac'in yerel ağ adresini bulur (`route` + `ipconfig`; elle `HV_LAN_IP=…`). Şunları bu adresle verir:
  - `CONTENT_BASE_URL` = `http://<ip>:8788`
  - `REEL_CATALOG_URL` = `http://<ip>:8080/api/v1/catalog/reels`
  - `API_BASE_URL` = `http://<ip>:8080`
  - `HV_APP_VERSION` = `0.1.0+N`
- **Çalışan servislere dokunmaz:** Backend (:8080) ve içerik sunucusu (127.0.0.1:8787) durdurulmaz, yeniden başlatılmaz. Betik yalnızca yapılacakları yazar:
  - **İçerik sunucusu:** Ayrı terminalde, ayrı portta ikinci bir örnek açılır: `python3 tools/dev-content-server/serve.py --host <ip> --port 8788`. `--host` H-043'te eklendi; varsayılan yine 127.0.0.1. Yalnızca güvenilen ağda açılır ve iş bitince kapatılır.
  - **Backend:** Spring Boot bütün arayüzleri dinler (`*:8080`). Ulaşılamıyorsa macOS Güvenlik Duvarı'nda Java'ya izin verilir.
  - **Reel videoları:** Backend'in verdiği medya kökünden gelir (`HIVELZON_MEDIA_LOCAL_BASE_URL`, varsayılan `http://127.0.0.1:8787/packages/`). Telefonda açılmaları için backend'in **bir sonraki** başlatılışında `HIVELZON_MEDIA_LOCAL_BASE_URL=http://<ip>:8788/packages/` verilir.
- **Düz HTTP:**
  - **iOS:** `Info.plist`'te zaten `NSAllowsLocalNetworking` var; yerel ağ IP'sine düz HTTP çalışır. Debug ve profile derlemede ilk bağlantıda "Yerel ağ" izni sorulur. Türkçe metni `tr.lproj/InfoPlist.strings`'te; anahtarı Flutter aracı yalnızca debug/profile'da ekler.
  - **Android:** Debug ve profile derlemelerde `network_security_config.xml` düz HTTP'ye izin verir (`base-config`, yalnızca `src/debug` ve `src/profile`). Release etkilenmez.
- **Yapı numarası:** Her derlemede artar. Varsayılan `git rev-list --count HEAD`; elle `HV_BUILD_NUMBER=…`. Flutter'a `--build-name 0.1.0 --build-number N` gider. Uygulamadaki **Hakkında** satırı da aynı değeri göstersin diye `--dart-define=HV_APP_VERSION=0.1.0+N` verilir.
- **Sürüm kuralı:** `pubspec.yaml` `version: 0.1.0+1` ile `lib/app/app_info.dart` varsayılanı aynı tutulur; test bunu denetler. Sürüm adı değişince ikisi birlikte değişir. Yapı numarası pubspec'e yazılmaz, derleme anında verilir.

## 3. H-044 bekleyenler

| # | Madde | Not |
|---|---|---|
| 3.1 | Android imza anahtarı (upload key), Play App Signing | Kullanıcı kararı 6: H-044 |
| 3.2 | iOS dağıtım imzası, TestFlight | Geliştirici hesapları H-044 |
| 3.3 | Google Play iç test kanalı | |
| 3.4 | **Gerçek adresler (HTTPS)** | **Risk:** `CONTENT_BASE_URL` (`http://127.0.0.1:8787`), `REEL_CATALOG_URL` (`http://127.0.0.1:8080/...`) ve `API_BASE_URL` (`http://127.0.0.1:8080`) varsayılanları yerel geliştirme içindir. `--dart-define` verilmeden yapılan bir **release** derlemesi telefonda hiçbir içeriğe ulaşamaz: 127.0.0.1 telefonun kendisidir ve Android release'te düz HTTP kapalıdır. Mağaza derlemesi bu üç değer HTTPS adresleriyle verilmeden yapılmaz. Gerekirse derleme anında boş/yerel adres denetimi H-044'te eklenir. |
| 3.5 | iOS `NSAllowsLocalNetworking` | Şu an bütün derlemelerde açık. Yayın derlemesinde gerekip gerekmediği H-044'te gözden geçirilir. |
| 3.6 | Asıl uygulama simgesi ve açılış ekranı | H-016 (logo, palet, ad kontrolü). Şimdiki simge **geçicidir**. |
| 3.7 | Mağaza aile politikaları, yaş derecelendirmesi | H-043/H-044 (H-002 hukuk teyidiyle) |
| 3.8 | Bunny Stream, sunucu | H-044 |
