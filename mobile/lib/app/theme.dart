import 'package:flutter/material.dart';

/// hiVelzon tasarım belirteçleri (H-045, `tasarim/README.md`).
abstract final class AppColors {
  static const Color seaBlue = Color(0xFF1F4E79);
  static const Color lighthouseYellow = Color(0xFFF2B33D);
  static const Color sand = Color(0xFFF7F1E6);
  static const Color ink = Color(0xFF2B2B2B);
  static const Color eveningOrange = Color(0xFFE98A3C);
}

abstract final class AppSpacing {
  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
}

/// hiVelzon teması: deniz mavisi birincil, fener sarısı vurgu, kum zemin.
abstract final class AppTheme {
  static const double radius = 12;

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seaBlue,
      brightness: brightness,
    ).copyWith(
      primary: isLight ? AppColors.seaBlue : null,
      secondary: AppColors.lighthouseYellow,
      onSecondary: AppColors.ink,
      tertiary: AppColors.eveningOrange,
      surface: isLight ? AppColors.sand : null,
      onSurface: isLight ? AppColors.ink : null,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
      cardTheme: CardThemeData(shape: shape, elevation: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: shape,
          backgroundColor: AppColors.lighthouseYellow,
          foregroundColor: AppColors.ink,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: shape),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppColors.lighthouseYellow.withValues(alpha: 0.35),
      ),
    );
  }
}
