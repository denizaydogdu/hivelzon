# H-110: Golden görüntülerin macOS 27.2.1 için yenilenmesi

- **Durum:** Devam ediyor (2026-11-25): golden'lar yenilendi, mobil 1526/1526 yerelde geçti; commit kullanıcı onayı bekliyor.
- **Tür:** Test bakımı (mobil)
- **Öncelik:** Yüksek (yerelde 84 test kırmızıydı; CI golden'ları atladığı için görünmüyordu)
- **Bağımlılık:** yok

## Sorun
2026-11-25'te `flutter test` 1442 geçti / **84 kaldı**; hepsi `test/goldens/` altında. Kod 2026-11-20'den beri
değişmedi. macOS 2026-11-21'de 27.2.1'e güncellendi (`softwareupdate --history`); Flutter aynı (3.38.5).
Golden'lar yalnız macOS'ta karşılaştırılır (`test/support/golden.dart`, `skipGoldensOffMac`); CI Linux'ta atlar.

## Kanıt
- Farklar %0,09–%0,67; en büyüğü yazı ölçeği vitrini (`showcase_type`). `isolatedDiff` görüntüsü yalnız harf
  kenarlarında soluk piksel gösteriyor; düzen, boyut ve satır kırılımı aynı → işletim sisteminin yazı çizimi değişti.

## Yapılan
- `flutter test --update-goldens test/goldens` → 92 PNG güncellendi; `test/goldens/failures/` silindi.
- `flutter analyze` temiz; `flutter test` **1526/1526**.

## Not
macOS güncellemesi sonrası aynı durum tekrar eder. Golden'a tolerans eklemek küçük gerçek bozulmaları
gizleyebileceği için önerilmedi; güncellemeden sonra önce farkın yalnız yazı kenarı olduğu görüntüyle doğrulanır.

## Geri alma
`git checkout -- mobile/test/goldens`
