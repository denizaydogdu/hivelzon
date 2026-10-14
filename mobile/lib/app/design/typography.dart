import 'package:flutter/material.dart';

/// Yazı tipleri ve ölçek (H-057).
///
/// - **Nunito** (yuvarlak, sıcak): display / headline / title — başlıklar
///   700.
/// - **Inter**: body / label — 400 ve 500 (vurgu 700).
/// - Yalnız 3 ağırlık: 400 / 500 / 700 (`w600` yok). En küçük yazı 12 px.
///
/// Boyutlar ve satır yükseklikleri Material 3 ölçeğiyle aynıdır (mevcut
/// yerleşimler bozulmasın); yalnızca `labelSmall` 11 → 12 px.
/// İkisi de uygulamaya gömülüdür (SIL OFL 1.1, `assets/fonts/`).
abstract final class AppFonts {
  static const String heading = 'Nunito';
  static const String body = 'Inter';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;
}

/// Yazı ölçeği. `Theme.of(context).textTheme` üzerinden kullanılır; burada
/// yalnızca tanım vardır.
abstract final class AppTypography {
  static TextStyle _h(double size, double lineHeight) => TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: AppFonts.bold,
    letterSpacing: 0,
  );

  static TextStyle _b(
    double size,
    double lineHeight,
    FontWeight weight, {
    double letterSpacing = 0,
  }) => TextStyle(
    fontFamily: AppFonts.body,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
  );

  /// Ölçek (boyut / satır yüksekliği, px).
  static TextTheme textTheme(Color ink) {
    final base = TextTheme(
      displayLarge: _h(57, 64),
      displayMedium: _h(45, 52),
      displaySmall: _h(36, 44),
      headlineLarge: _h(32, 40),
      headlineMedium: _h(28, 36),
      headlineSmall: _h(24, 32),
      titleLarge: _h(22, 28),
      titleMedium: _h(16, 24),
      titleSmall: _h(14, 20),
      bodyLarge: _b(16, 24, AppFonts.regular),
      bodyMedium: _b(14, 20, AppFonts.regular),
      bodySmall: _b(12, 16, AppFonts.regular),
      labelLarge: _b(14, 20, AppFonts.medium),
      labelMedium: _b(12, 16, AppFonts.medium, letterSpacing: 0.2),
      labelSmall: _b(12, 16, AppFonts.medium, letterSpacing: 0.2),
    );
    return base.apply(bodyColor: ink, displayColor: ink);
  }

  /// Düğme etiketi (birincil/ikincil/sessiz/tehlike).
  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 16,
    height: 1.25,
    fontWeight: AppFonts.bold,
  );

  /// Büyük ana eylem (oynatıcı `PrimaryAction`).
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 18,
    height: 1.25,
    fontWeight: AppFonts.bold,
  );

  /// Büyük harfli küçük etiket (`CapsLabel`).
  static const TextStyle caps = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: AppFonts.bold,
    letterSpacing: 1.2,
  );

  /// İstatistik sayısı (`StatTile`).
  static const TextStyle statNumber = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: AppFonts.bold,
  );

  /// Alt sekme etiketi.
  static const TextStyle navLabel = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: AppFonts.medium,
  );
}
