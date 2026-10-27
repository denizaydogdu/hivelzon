# H-101: Marka simgesi ve mağaza görsellerini uygula

- **Durum:** Bitti (2026-10-27)
- **Tür:** Tasarım + mobil yapılandırma
- **Öncelik:** Orta
- **Bağımlılık:** H-016 (karar ve konsept)

## Kapsam

H-016'da verilen marka kararını uygulamak:

- `tasarim/marka/logo-hi-1024.png` tabanından iOS `AppIcon.appiconset` ve
  Android adaptive/legacy simge setlerini üretmek;
- açılış ekranındaki geçici simgeyi marka simgesiyle değiştirmek;
- mağaza için gerekli simge ve temel görselleri hazırlamak (Apple 1024,
  Google Play 512);
- mağaza adı/alt başlık metinlerini H-044 mağaza yükleme adımına hazır
  tutmak.

## Sınırlar

- Yeni bir görsel model çağrısı veya ücretli üretim yok; konsept yerel
  araçlarla üretildi.
- Mağaza hesabı açma, yükleme ve mağaza görsellerinin yayını H-044'e bağlı;
  bu iş yalnız yerel varlıkları hazırlar.
- Maskot Hi'nin yüzü logoya gömülmez; maskot ayrı karakterdir (H-005).
- Palet değişmez; `AppPalette` kullanılır.

## Kabul

- iOS ve Android simge setleri eksiksiz; uygulama simgesi geçici simgeden
  ayrılır.
- `flutter analyze` ve ilgili testler temiz.
- Simülatörde ana ekran simgesi ve açılış ekranı kontrol edilir.
- Mağaza metinleri `docs/KARARLAR-2026-10-27.md` ile aynıdır.

## Sonuç

- `mobile/tool/brand_icons.sh` deterministik olarak şunları üretir:
  - 15 iOS uygulama simgesi (20–1024 px, saydamlık yok),
  - 5 Android legacy simgesi + 5 adaptive ön planı,
  - iOS/Android açılış işaretleri,
  - 1024 px master ve 512 px Google Play simgesi.
- Android adaptive simge ve Android 12+ açılış zemini deniz mavisi; iOS
  açılış ekranı aynı marka zeminini kullanır.
- Geçici H-043 simgesi yerine H-016 konuşma balonu + “Hi” wordmark'ı geldi.
- Mağaza hesaplarına girilmedi; yükleme H-044'e bağlı kalır.
- Ücretli üretim ve Higgsfield harcaması: **0**.

## Doğrulama

- 15 iOS + 15 Android varlığı: beklenen boyutlar; iOS simgeleri tamamen
  opak; Android/iOS XML dosyaları `xmllint` ile geçerli.
- `flutter analyze`: temiz.
- `flutter test`: **1483/1483**.
- İlk tam koşuda zaman örneklemesine bağlı tek oynatıcı testi 76–92 ms
  sapmayla düştü; kelime aralığına değil anlam panelinin açıldığı konuma
  dönme sözleşmesi korunarak bir kare toleransı eklendi. Hedef test ve tam
  takım yeniden yeşil.
- `flutter build apk --debug`: geçti.
- `flutter build ios --simulator --debug`: geçti; uygulama PIRU iPhone 17
  simülatörüne temiz kuruldu ve açıldı.

## Geri alma

- `mobile/tool/brand_icons.sh` ve ürettiği iOS/Android görselleri önceki
  H-043 varlıklarına döndürülür.
- Android `colors.xml` ve iOS `LaunchScreen.storyboard` zemini yeniden kum
  rengine alınır.
