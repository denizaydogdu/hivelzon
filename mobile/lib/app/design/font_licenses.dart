import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Gömülü yazı tiplerinin lisanslarını Flutter'ın Lisanslar sayfasına ekler
/// (H-057). İkisi de SIL Open Font License 1.1.
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, path) in const [
      ('Inter', 'assets/fonts/inter/OFL.txt'),
      ('Nunito', 'assets/fonts/nunito/OFL.txt'),
    ]) {
      final text = await rootBundle.loadString(path);
      yield LicenseEntryWithLineBreaks([family], text);
    }
  });
}
