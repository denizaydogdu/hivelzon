import 'package:flutter/material.dart';

import '../../app/design/buttons.dart';
import '../../app/design/tokens.dart';

/// "Bilmiyorum" düğmesi (H-057 biçimi, H-061 ortak bileşen): kelime tekrarı,
/// sahne avı ve seviye sorularında aynı görünüm. İkincil ama açıkça düğme;
/// utandırmaz. Ekranlardaki `OutlinedButton.icon` kopyalarının yerine.
class DontKnowButton extends StatelessWidget {
  const DontKnowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = false,
    this.minimumSize = const Size(AppTouch.min, AppTouch.min),
  });

  final String label;
  final VoidCallback? onPressed;

  /// Tam genişlik (taslak S05: seçeneklerin altında).
  final bool expand;
  final Size minimumSize;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    style: AppButtonStyles.dontKnow(
      minimumSize: expand ? Size.fromHeight(minimumSize.height) : minimumSize,
    ),
    icon: const Icon(AppButtonStyles.dontKnowIcon),
    label: Text(label),
  );
}
