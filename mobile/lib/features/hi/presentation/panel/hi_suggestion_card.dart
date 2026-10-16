// Hi paneli: bugünkü öneri kartı ve hızlı eylem düğmesi (H-063 bölme).

import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../domain/coach_rules.dart';

/// Bugünkü tek öneri ve görünür gerekçesi ("Neden?").
class HiSuggestionCard extends StatelessWidget {
  const HiSuggestionCard({
    super.key,
    required this.suggestion,
    required this.onAct,
    this.onAnother,
  });

  final HiSuggestion suggestion;
  final VoidCallback onAct;

  /// "Başka bir öneri" (H-088): öneriyi bugünlük geçer.
  final VoidCallback? onAnother;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = suggestion;
    return Card(
      key: ValueKey('hi-suggestion-${s.kind.name}'),
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              s.title,
              key: const ValueKey('hi-suggestion-title'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              HiTexts.why,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.seaBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              s.reasonTr,
              key: const ValueKey('hi-suggestion-reason'),
              style: theme.textTheme.bodyLarge,
            ),
            if (s.hasAction && s.actionLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              FilledButton(
                key: const ValueKey('hi-suggestion-action'),
                onPressed: onAct,
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                child: Text(s.actionLabel!),
              ),
              if (onAnother != null && s.dismissible)
                Align(
                  child: TextButton(
                    key: const ValueKey('hi-suggestion-another'),
                    onPressed: onAnother,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Text(HiTexts.another),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Hızlı eylem düğmesi (en az 48 dp).
class HiQuickAction extends StatelessWidget {
  const HiQuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(48, 48),
      backgroundColor: Colors.white.withValues(alpha: 0.7),
    ),
    icon: Icon(icon, color: AppColors.seaBlue),
    label: Text(label),
  );
}
