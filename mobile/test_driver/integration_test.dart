import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// `flutter drive` sürücüsü: ekran görüntüleri `SHOT_DIR` klasörüne
/// (varsayılan `../.yerel/h038`, git'e girmez) yazılır.
Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    final dir = Platform.environment['SHOT_DIR'] ?? '../.yerel/h038';
    await File('$dir/$name.png').writeAsBytes(bytes);
    return true;
  },
);
