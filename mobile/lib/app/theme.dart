import 'package:flutter/material.dart';

/// hiVelzon temel teması. Marka renkleri kesinleşince (brandkit) güncellenir.
abstract final class AppTheme {
  static const Color seed = Color(0xFF3D5AFE);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: scheme.primaryContainer,
      ),
    );
  }
}
