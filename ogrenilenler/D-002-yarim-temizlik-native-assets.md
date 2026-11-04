# D-002: Yarım derleme temizliği uygulamanın yerel kayıtlarını bozdu (H-106)

**Tarih:** 2026-11-04 · **Kaynak:** H-106, simülatör denemesi

## Ne oldu
- 2026-11-03'te yazılan temizlik kuralı yalnız `mobile/build/`, `mobile/ios/build/` ve Xcode DerivedData'yı siliyor, `.dart_tool/` klasörünü bırakıyordu.
- Sonraki `flutter run`, `objective_c` paketinin yerel çerçevesini (`objective_c.framework`, native assets) uygulama paketine koymadı.
  - Derleme günlüğünde tek iz şu satırdı: `Target native_assets required define SdkRoot but it was not provided`.
- Uygulama açıldı ama cihazdaki **bütün kayıt okumaları** `DOBJC_initializeApi … Failed to load dynamic library` hatasıyla düştü. Etkilenen kayıtlar: ilerleme, defter, ayarlar ve hesap durumu.
  - Kullanıcı Ana Sayfa ve Öğren'de "bağlantı kurulamadı" gördü.
  - Sunucular sağlıklıydı. Hata ağdan değil, `path_provider_foundation`'ın kullandığı `objective_c` FFI'dan geliyordu.
- İlk günlük yalnız `ArgumentError` diyordu. Hata yeri bilinmediği için kaynak bulunamadı ve test ortamında yeniden üretilemedi.

## Kurallar
- **Derleme temizliği:** `cd mobile && flutter clean && flutter pub get`. `build/` tek başına silinmez, çünkü `.dart_tool/flutter_build` ve `hooks_runner` önbellekleri `build/` ile birlikte tutarlı kalmalı.
- **"Bağlantı kurulamadı" görülünce** önce sunuculara değil, `flutter run` günlüğündeki `[Hxxx] … okunamadı` satırlarına bakılır. Yerel kayıt hatası da aynı boş ya da hata ekranını verebilir.
- **Hata günlüğü teşhis edilebilir olmalı:** tür + kısa sabit açıklama + atıldığı `package:` yeri yazılır. Kişisel veri yazılmaz (`reminderErrorSummary`). Kök nedeni bulan bu oldu.
- **Kontrol:** Derlemeden sonra şüphe varsa `Runner.app/Frameworks` içinde `objective_c.framework` aranır.
