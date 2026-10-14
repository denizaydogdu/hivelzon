import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

/// Düğme varyantları (H-057). Tema varsayılanları:
/// - `FilledButton` → **birincil** (fener sarısı, hap biçimi);
/// - `OutlinedButton` → **ikincil** (deniz mavisi kenar);
/// - `TextButton` → **sessiz**.
///
/// Tema dışı varyantlar buradan: **tehlike** ve **"Bilmiyorum"**.
abstract final class AppButtonStyles {
  static const OutlinedBorder pill = StadiumBorder();

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppSpace.s24,
    vertical: AppSpace.s12,
  );

  /// Birincil: fener sarısı dolgu, mürekkep yazı.
  static ButtonStyle primary() => FilledButton.styleFrom(
    backgroundColor: AppPalette.lighthouseYellow,
    foregroundColor: AppPalette.ink,
    disabledBackgroundColor: AppPalette.ink100,
    disabledForegroundColor: AppPalette.ink500,
    minimumSize: const Size(AppTouch.min, AppTouch.min),
    padding: _padding,
    shape: pill,
    textStyle: AppTypography.button,
    elevation: 0,
  );

  /// İkincil: deniz mavisi kenar ve yazı, dolgusuz.
  static ButtonStyle secondary() => OutlinedButton.styleFrom(
    foregroundColor: AppPalette.seaBlue,
    disabledForegroundColor: AppPalette.ink500,
    side: const BorderSide(color: AppPalette.seaBlue, width: 1.5),
    minimumSize: const Size(AppTouch.min, AppTouch.min),
    padding: _padding,
    shape: pill,
    textStyle: AppTypography.button,
  );

  /// Sessiz: yalnız yazı (deniz mavisi).
  static ButtonStyle quiet() => TextButton.styleFrom(
    foregroundColor: AppPalette.seaBlue,
    disabledForegroundColor: AppPalette.ink500,
    minimumSize: const Size(AppTouch.min, AppTouch.min),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpace.s16,
      vertical: AppSpace.s12,
    ),
    shape: pill,
    textStyle: AppTypography.button,
  );

  /// Tehlike (kenarlı): "Hesabımı sil", "Verileri sil" gibi geri alınması
  /// zor eylemlerin ilk düğmesi.
  static ButtonStyle danger() => OutlinedButton.styleFrom(
    foregroundColor: AppPalette.danger,
    side: const BorderSide(color: AppPalette.danger, width: 1.5),
    minimumSize: const Size(AppTouch.min, AppTouch.min),
    padding: _padding,
    shape: pill,
    textStyle: AppTypography.button,
  );

  /// Tehlike (dolu): onay penceresindeki son "Sil" düğmesi.
  static ButtonStyle dangerFilled() => FilledButton.styleFrom(
    backgroundColor: AppPalette.danger,
    foregroundColor: AppPalette.white,
    minimumSize: const Size(AppTouch.min, AppTouch.min),
    padding: _padding,
    shape: pill,
    textStyle: AppTypography.button,
    elevation: 0,
  );

  /// "Bilmiyorum": ikincil ama açıkça düğme (utandırmaz); seçeneklerden
  /// ayrışan kenarlıklı, dolgusuz biçim. İkonu [dontKnowIcon].
  static ButtonStyle dontKnow({Size minimumSize = const Size(48, 48)}) =>
      OutlinedButton.styleFrom(
        minimumSize: minimumSize,
        foregroundColor: AppPalette.seaBlue,
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: AppPalette.seaBlue, width: 1.5),
        shape: pill,
        textStyle: AppTypography.button,
      );

  static const IconData dontKnowIcon = Icons.help_outline_rounded;
}
