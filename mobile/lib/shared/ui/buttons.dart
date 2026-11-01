import 'package:flutter/material.dart';

import '../../app/design/design.dart';

enum _CompactKind { tonal, quiet }

/// Kompakt düğme (H-102): bilgi kartlarındaki küçük eylemler için. Görünen
/// yükseklik [AppTouch.compact]; dokunma alanı yine en az [AppTouch.min].
///
/// - [CompactButton.tonal]: kartın birincil eylemi (açık mavi dolgu). Ekranın
///   tek dolu sarı ana eylemiyle yarışmaz.
/// - [CompactButton.quiet]: ikincil eylem (yalnız yazı): "Tamam",
///   "Şimdi değil".
///
/// Görünen etiket kısa tutulabilir; [semanticLabel] verilirse ekran okuyucu
/// tam eylemi okur ("Koşullar" → "Koşulları aç").
class CompactButton extends StatelessWidget {
  const CompactButton.tonal({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticLabel,
  }) : _kind = _CompactKind.tonal;

  const CompactButton.quiet({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticLabel,
  }) : _kind = _CompactKind.quiet;

  final String label;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final _CompactKind _kind;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      semanticsLabel: semanticLabel,
      textAlign: TextAlign.center,
    );
    return switch (_kind) {
      _CompactKind.tonal => FilledButton(
        style: AppButtonStyles.compactTonal(),
        onPressed: onPressed,
        child: text,
      ),
      _CompactKind.quiet => TextButton(
        style: AppButtonStyles.compactQuiet(),
        onPressed: onPressed,
        child: text,
      ),
    };
  }
}

/// Kompakt düğmeleri yan yana dizer; sığmazsa doğal olarak alt satıra
/// kırılır. Satır arası görünür boşluk, dokunma alanının görünmez
/// dolgusundan gelir ([AppTouch.min] − [AppTouch.compact]).
class CompactActions extends StatelessWidget {
  const CompactActions({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpace.s8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );
}
