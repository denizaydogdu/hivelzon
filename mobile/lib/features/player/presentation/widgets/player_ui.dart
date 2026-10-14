import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import 'hi_avatar.dart';

/// Oynatıcı katmanlarında ortak panel: kum zemin, 12 px köşe.
class PlayerPanel extends StatelessWidget {
  const PlayerPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        boxShadow: const [
          BoxShadow(
            color: AppScrim.panelShadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: AppColors.ink),
        child: child,
      ),
    );
  }
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
      minimumSize: const Size.fromHeight(56),
      textStyle: AppTypography.buttonLarge,
    );
    return icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: Text(label))
        : FilledButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon),
            label: Text(label),
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
                  fontWeight: FontWeight.w700,
                  color: AppColors.seaBlue,
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
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      style: filled
          ? IconButton.styleFrom(
              backgroundColor: AppColors.lighthouseYellow,
              foregroundColor: AppColors.ink,
            )
          : null,
      icon: Icon(Icons.volume_up_rounded, semanticLabel: semanticLabel),
    );
  }
}

/// Hi paneli (T4): ışıklı balon, Türkçe metin, isteğe bağlı ses ve eylemler.
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
        const HiAvatar(size: 120),
        const SizedBox(height: AppSpacing.sm),
        PlayerPanel(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onListen != null) ...[
                ListenButton(
                  onPressed: onListen!,
                  semanticLabel: 'Hi\'yi dinle',
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: Text(
                          title!,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.seaBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    EmphasisText(
                      text,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          alignment: WrapAlignment.center,
          children: actions,
        ),
      ],
    );
  }
}

/// Nazik, cezalandırmayan genel geri bildirimler (K-32; ürün ilkeleri).
const List<String> kGentleRetryMessages = [
  'Bir daha bakalım.',
  'Neredeyse! Bir kez daha dene.',
  'Acele yok, tekrar dene.',
];
