import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../domain/episode.dart';
import 'hi_avatar.dart';
import 'player_ui.dart';

/// Karar anı kartı (T3): "Ne dersin?" + büyük seçenek düğmeleri.
///
/// Süre yok, geri sayım yok (K-32). İpucu yalnızca kullanıcı isterse (§8.3).
class DecisionSheet extends StatelessWidget {
  const DecisionSheet({
    super.key,
    required this.node,
    required this.onChoose,
    required this.onListen,
    required this.onHint,
  });

  final DecisionNode node;
  final ValueChanged<DecisionOption> onChoose;
  final ValueChanged<String> onListen;
  final VoidCallback? onHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PlayerPanel(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.lighthouseYellow.withValues(alpha: 0.7),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(
                  Icons.flare_rounded,
                  color: AppColors.lighthouseYellow,
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.lighthouseYellow.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Semantics(
            header: true,
            child: Text(
              'Ne dersin?',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.seaBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            node.prompt.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final o in node.options) ...[
            _OptionButton(
              option: o,
              onTap: () => onChoose(o),
              onListen: o.audio == null ? null : () => onListen(o.audio!),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          if (onHint != null)
            Align(
              child: TextButton.icon(
                onPressed: onHint,
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  foregroundColor: AppColors.seaBlue,
                ),
                icon: const HiAvatar(size: 32, glow: false),
                label: const Text(
                  'Hi\'den ipucu al',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.option,
    required this.onTap,
    this.onListen,
  });

  final DecisionOption option;
  final VoidCallback onTap;
  final VoidCallback? onListen;

  @override
  Widget build(BuildContext context) {
    final icons = _arrowIcons(option.icon);
    return Material(
      color: const Color(0xFFEAF1F8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        side: BorderSide(color: AppColors.seaBlue.withValues(alpha: 0.25)),
      ),
      child: InkWell(
        key: ValueKey('option-${option.id}'),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: Row(
              children: [
                for (final i in icons)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(i, color: AppColors.seaBlue),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      option.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.seaBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                if (onListen != null)
                  ListenButton(
                    onPressed: onListen!,
                    semanticLabel: 'Dinle: ${option.text}',
                    filled: false,
                  )
                else
                  const SizedBox(width: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `arrows:up,left` → yön simgeleri.
List<IconData> _arrowIcons(String? icon) {
  if (icon == null || !icon.startsWith('arrows:')) return const [];
  return [
    for (final d in icon.substring(7).split(','))
      switch (d.trim()) {
        'up' => Icons.arrow_upward_rounded,
        'down' => Icons.arrow_downward_rounded,
        'left' => Icons.turn_left_rounded,
        'right' => Icons.turn_right_rounded,
        _ => Icons.navigation_rounded,
      },
  ];
}
