import 'package:flutter/material.dart';

import 'tokens.dart';

/// Kitap sayfasının renkleri (H-067). Kitabın paletinden (`book.json →
/// palette`) gelir; okunurluk korunur: yazı zemine karşı en az 4,5:1, vurgu
/// zemini üstündeki yazı da 4,5:1. Tutmayan renk belirteçle değiştirilir.
@immutable
class BookColors {
  const BookColors({
    required this.background,
    required this.text,
    required this.accent,
    required this.surface,
    required this.highlight,
    required this.onAccent,
  });

  /// Paletten ([background] … `0xFFRRGGBB`) okunur renkler.
  factory BookColors.fromPalette({
    required int background,
    required int text,
    required int accent,
    int? surface,
    int? highlight,
  }) {
    final bg = Color(background);
    var fg = Color(text);
    if (contrast(fg, bg) < 4.5) {
      fg = contrast(AppPalette.ink, bg) >= 4.5
          ? AppPalette.ink
          : AppPalette.white;
    }
    var ac = Color(accent);
    // Düğme ve ikon rengi: zemine karşı en az 3:1 (büyük öğe), yazı gibi
    // kullanıldığı yerde (sayfa numarası) 4,5:1 aranır.
    if (contrast(ac, bg) < 4.5) ac = fg;
    var hl = highlight == null ? AppPalette.yellow200 : Color(highlight);
    if (contrast(fg, hl) < 4.5) hl = AppPalette.yellow100;
    if (contrast(fg, hl) < 4.5) hl = bg;
    final sf = surface == null ? AppPalette.white : Color(surface);
    final onAc = contrast(AppPalette.white, ac) >= 4.5
        ? AppPalette.white
        : AppPalette.ink;
    return BookColors(
      background: bg,
      text: fg,
      accent: ac,
      surface: contrast(fg, sf) >= 4.5 ? sf : AppPalette.white,
      highlight: hl,
      onAccent: onAc,
    );
  }

  final Color background;
  final Color text;
  final Color accent;

  /// Denetim çubuğu ve kartların zemini.
  final Color surface;

  /// Okunan cümlenin zemini.
  final Color highlight;

  /// Vurgu renginin üstündeki yazı/ikon.
  final Color onAccent;

  /// WCAG kontrast oranı.
  static double contrast(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final hi = la > lb ? la : lb;
    final lo = la > lb ? lb : la;
    return (hi + 0.05) / (lo + 0.05);
  }
}
