import 'dart:io' show Platform;

/// Golden görüntüleri macOS'ta üretildi. Linux'ta (CI) yazı tipi pikselleri farklı çizildiği
/// için karşılaştırma yalnız macOS'ta yapılır; CI'da golden testleri atlanır, aynı dosyalardaki
/// erişilebilirlik ve taşma testleri her yerde çalışır.
/// Güncelleme: macOS'ta `flutter test --update-goldens test/goldens`.
final bool skipGoldensOffMac = !Platform.isMacOS;
