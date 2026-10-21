/// Uygulama sürümü (H-042: Profil → "Hakkında ve lisanslar").
///
/// Ek eklenti (`package_info_plus`) yerine derleme sabiti: tek kullanım yeri
/// bir metin satırı. Varsayılan `pubspec.yaml` `version:` ile aynıdır (test
/// denetler: `test/app/app_info_test.dart`). Mağaza derlemesinde sürüm
/// `--build-name/--build-number` ile değişirse aynı değer
/// `--dart-define=HV_APP_VERSION=1.2.0+7` ile de verilir.
abstract final class AppInfo {
  static const version = String.fromEnvironment(
    'HV_APP_VERSION',
    defaultValue: '1.0.0+1',
  );

  /// `1.0.0 (1)` biçimi.
  static String get display {
    final parts = version.split('+');
    return parts.length == 2 ? '${parts[0]} (${parts[1]})' : version;
  }
}
