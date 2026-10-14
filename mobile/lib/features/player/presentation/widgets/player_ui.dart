import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import 'hi_avatar.dart';

/// Oynatıcı katmanlarında ortak panel (H-062): kum zemin, 20 px köşe,
/// video üstünde belirgin gölge.
class PlayerPanel extends StatelessWidget {
  const PlayerPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.s24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: const BoxDecoration(
        color: AppPalette.sand,
        borderRadius: AppRadius.lgAll,
        boxShadow: [
          BoxShadow(
            color: AppScrim.panelShadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: AppPalette.ink),
        child: child,
      ),
    );
  }
}

/// Oynatıcı katmanının girişi (H-062): solarak ve hafifçe yukarı kayarak
/// belirir ([index] sırayla gecikme). "Hareketi azalt" açıksa durağan.
///
/// Yalnız görünüm: dokunma ilk karede de çalışır, oynatma ve geçiş
/// zamanlamasına dokunmaz (H-031: geçiş ≤ 150 ms; altyazı ≤ 0,2 sn).
class PlayerEntrance extends StatelessWidget {
  const PlayerEntrance({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) =>
      SoftEntrance(index: index, child: child);
}

/// Büyük, en az 56 px yüksek birincil eylem düğmesi (fener sarısı).
class PrimaryAction extends StatelessWidget {
  const PrimaryAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(AppTouch.primary),
      textStyle: AppTypography.buttonLarge,
    );
    return PressScale(
      enabled: onPressed != null,
      child: icon == null
          ? FilledButton(onPressed: onPressed, style: style, child: Text(label))
          : FilledButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon),
              label: Text(label),
            ),
    );
  }
}

/// "*kelime*" → kalın ve deniz mavisi. Hi ipuçlarındaki vurgu biçimi.
class EmphasisText extends StatelessWidget {
  const EmphasisText(this.text, {super.key, this.style, this.textAlign});

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final base = style ?? DefaultTextStyle.of(context).style;
    final spans = <TextSpan>[];
    final parts = text.split('*');
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      spans.add(
        TextSpan(
          text: parts[i],
          style: i.isOdd
              ? const TextStyle(
                  fontWeight: AppFonts.bold,
                  color: AppPalette.seaBlue,
                )
              : null,
        ),
      );
    }
    return Text.rich(
      TextSpan(style: base, children: spans),
      textAlign: textAlign,
    );
  }
}

/// Dinle düğmesi (48 px dokunma alanı).
class ListenButton extends StatelessWidget {
  const ListenButton({
    super.key,
    required this.onPressed,
    required this.semanticLabel,
    this.filled = true,
  });

  final VoidCallback onPressed;
  final String semanticLabel;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: semanticLabel,
      constraints: const BoxConstraints(
        minWidth: AppTouch.min,
        minHeight: AppTouch.min,
      ),
      style: filled
          ? IconButton.styleFrom(
              backgroundColor: AppPalette.lighthouseYellow,
              foregroundColor: AppPalette.ink,
            )
          : null,
      icon: Icon(Icons.volume_up_rounded, semanticLabel: semanticLabel),
    );
  }
}

/// Hi paneli (T4): ışıklı balon, Türkçe metin, isteğe bağlı ses ve eylemler.
///
/// Giriş (H-062): Hi sakin belirir, ardından panel ve eylemler sırayla
/// yukarı kayarak gelir. "Hareketi azalt" açıksa durağan.
class HiPanel extends StatelessWidget {
  const HiPanel({
    super.key,
    required this.text,
    this.title,
    this.onListen,
    required this.actions,
  });

  final String text;
  final String? title;
  final VoidCallback? onListen;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CalmPop(child: HiAvatar(size: 120)),
        const SizedBox(height: AppSpace.s16),
        PlayerEntrance(
          index: 1,
          child: PlayerPanel(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (onListen != null) ...[
                  ListenButton(
                    onPressed: onListen!,
                    semanticLabel: PlayerTexts.listenHi,
                  ),
                  const SizedBox(width: AppSpace.s16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpace.s8),
                          child: Text(
                            title!,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppPalette.seaBlue,
                            ),
                          ),
                        ),
                      EmphasisText(
                        text,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppPalette.ink,
                          fontWeight: AppFonts.medium,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s16),
        PlayerEntrance(
          index: 2,
          child: Wrap(
            spacing: AppSpace.s16,
            runSpacing: AppSpace.s8,
            alignment: WrapAlignment.center,
            children: actions,
          ),
        ),
      ],
    );
  }
}

/// Nazik, cezalandırmayan genel geri bildirimler (K-32; ürün ilkeleri).
const List<String> kGentleRetryMessages = PlayerTexts.gentleRetry;
