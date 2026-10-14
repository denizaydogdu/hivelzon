import 'package:flutter/material.dart';

import 'design/design.dart';

export 'design/design.dart';

/// Eski renk adları (H-045). Yeni kod [AppPalette] kullanır; bu sınıf
/// mevcut ekranlar derlensin diye kalır ve ekran fazlarında (H-059+)
/// kademeli olarak kaldırılır.
abstract final class AppColors {
  static const Color seaBlue = AppPalette.seaBlue;
  static const Color lighthouseYellow = AppPalette.lighthouseYellow;
  static const Color sand = AppPalette.sand;
  static const Color ink = AppPalette.ink;
  static const Color eveningOrange = AppPalette.eveningOrange;
}

/// Eski boşluk adları (8 / 16 / 24 / 32). Yeni kod [AppSpace] kullanır.
abstract final class AppSpacing {
  static const double xs = AppSpace.s8;
  static const double sm = AppSpace.s16;
  static const double md = AppSpace.s24;
  static const double lg = AppSpace.s32;
}

/// hiVelzon teması (H-057): deniz mavisi birincil, fener sarısı ana eylem,
/// kum zemin, beyaz kartlar; Nunito başlık + Inter metin.
///
/// Uygulama açık temaya sabittir (`ThemeMode.light`); [dark] ileride
/// karanlık mod işi için derlenebilir tutulur.
abstract final class AppTheme {
  /// Kart ve panel köşesi (eski ad; yeni kod [AppRadius.md]).
  static const double radius = AppRadius.md;

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppPalette.seaBlue,
          brightness: brightness,
        ).copyWith(
          primary: isLight ? AppPalette.seaBlue : null,
          onPrimary: isLight ? AppPalette.white : null,
          primaryContainer: isLight ? AppPalette.seaBlue100 : null,
          onPrimaryContainer: isLight ? AppPalette.seaBlue900 : null,
          secondary: AppPalette.lighthouseYellow,
          onSecondary: AppPalette.ink,
          secondaryContainer: isLight ? AppPalette.yellow100 : null,
          onSecondaryContainer: isLight ? AppPalette.ink : null,
          tertiary: AppPalette.eveningOrange,
          error: isLight ? AppPalette.danger : null,
          errorContainer: isLight ? AppPalette.dangerSurface : null,
          surface: isLight ? AppPalette.sand : null,
          onSurface: isLight ? AppPalette.ink : null,
          onSurfaceVariant: isLight ? AppPalette.ink500 : null,
          surfaceContainerLowest: isLight ? AppPalette.white : null,
          surfaceContainerLow: isLight ? AppPalette.sand50 : null,
          surfaceContainer: isLight ? AppPalette.sand200 : null,
          surfaceContainerHigh: isLight ? AppPalette.sand200 : null,
          surfaceContainerHighest: isLight ? AppPalette.sand300 : null,
          outline: isLight ? AppPalette.ink300 : null,
          outlineVariant: isLight ? AppPalette.ink200 : null,
        );
    final ink = scheme.onSurface;
    final text = AppTypography.textTheme(ink);
    final cardColor = isLight ? AppPalette.white : scheme.surfaceContainer;
    const cardShape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
    final inputBorder = OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(color: scheme.outlineVariant),
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: AppFonts.body,
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: AppShadows.materialShadow,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppShadows.materialShadow,
        elevation: 1,
        shape: cardShape,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: AppButtonStyles.primary(),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: isLight
            ? AppButtonStyles.secondary()
            : OutlinedButton.styleFrom(shape: AppButtonStyles.pill),
      ),
      textButtonTheme: TextButtonThemeData(
        style: isLight
            ? AppButtonStyles.quiet()
            : TextButton.styleFrom(shape: AppButtonStyles.pill),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(AppTouch.min, AppTouch.min),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.s16,
          vertical: AppSpace.s12,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
        dragHandleColor: scheme.outline,
        dragHandleSize: const Size(AppSpace.s32, AppSpace.s4),
        showDragHandle: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        titleTextStyle: text.titleLarge,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardColor,
        selectedColor: AppPalette.seaBlue100,
        side: BorderSide(color: scheme.outlineVariant),
        shape: const StadiumBorder(),
        labelStyle: text.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.s8),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: cardColor,
          selectedBackgroundColor: isLight ? AppPalette.seaBlue : null,
          selectedForegroundColor: isLight ? AppPalette.white : null,
          foregroundColor: ink,
          side: BorderSide(color: scheme.outlineVariant),
          minimumSize: const Size(AppTouch.min, AppTouch.min),
          textStyle: text.labelLarge,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        titleTextStyle: text.bodyLarge?.copyWith(fontWeight: AppFonts.medium),
        subtitleTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        shape: cardShape,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppPalette.white : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : null,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: AppPalette.seaBlue100,
        circularTrackColor: AppPalette.seaBlue100,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight ? AppPalette.ink : null,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppPalette.white),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight ? AppPalette.white : null,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppShadows.materialShadow,
        elevation: 2,
        indicatorColor: AppPalette.lighthouseYellow.withValues(alpha: 0.35),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => AppTypography.navLabel.copyWith(
            color: ink,
            fontWeight: s.contains(WidgetState.selected)
                ? AppFonts.bold
                : AppFonts.medium,
          ),
        ),
      ),
    );
  }
}
