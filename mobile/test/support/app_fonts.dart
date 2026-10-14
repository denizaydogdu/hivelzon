import 'dart:io';

import 'package:flutter/services.dart';

/// Gömülü yazı tiplerini (Inter, Nunito) ve Material ikonlarını testlere
/// yükler (H-057). Flutter testleri varsayılan olarak her yazıyı kutu
/// biçimli "FlutterTest" yazı tipiyle çizer; golden ve glif testleri gerçek
/// yazı tipini görmek için bunu çağırır. Bir kez yüklemek yeter.
Future<void> loadAppFonts() async {
  if (_loaded) return;
  // Eşzamanlı okuma: `testWidgets`in sahte zamanında dosya G/Ç'si beklemez.
  Future<ByteData> read(String path) =>
      Future.value(ByteData.sublistView(File(path).readAsBytesSync()));

  final inter = FontLoader('Inter');
  for (final w in ['Regular', 'Medium', 'Bold']) {
    inter.addFont(read('assets/fonts/inter/Inter-$w.ttf'));
  }
  final nunito = FontLoader('Nunito');
  for (final w in ['Regular', 'Medium', 'Bold']) {
    nunito.addFont(read('assets/fonts/nunito/Nunito-$w.ttf'));
  }
  await Future.wait([inter.load(), nunito.load()]);

  // Material ikonları Flutter SDK'dan (yoksa ikonlar kutu görünür).
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root != null) {
    final icons = File(
      '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
    if (icons.existsSync()) {
      await (FontLoader('MaterialIcons')..addFont(read(icons.path))).load();
    }
  }
  _loaded = true;
}

bool _loaded = false;
