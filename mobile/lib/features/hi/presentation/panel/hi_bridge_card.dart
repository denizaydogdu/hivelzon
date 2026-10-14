// Hi paneli: gerçek hayat köprü görevi (yan görev) kartı (H-063 bölme).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/text/turkish.dart';
import '../../application/hi_providers.dart';
import '../../data/hi_store.dart';
import '../../domain/hi_content.dart';
import '../hi_listen_button.dart';

/// Gerçek hayat köprü görevi (yan görev): "Yaptım" ya da "Geç".
class HiBridgeCard extends ConsumerStatefulWidget {
  const HiBridgeCard({super.key, required this.task});

  final BridgeTask task;

  @override
  ConsumerState<HiBridgeCard> createState() => _HiBridgeCardState();
}

class _HiBridgeCardState extends ConsumerState<HiBridgeCard> {
  bool _thanked = false;

  Future<void> _set(BridgeState s) async {
    await ref.read(hiStoreProvider).setBridgeState(widget.task.id, s);
    if (!mounted) return;
    if (s == BridgeState.done) {
      setState(() => _thanked = true);
      await Future<void>.delayed(const Duration(milliseconds: 1600));
      if (!mounted) return;
    }
    ref.invalidate(bridgeTaskProvider);
    ref.invalidate(hiKnowledgeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = widget.task;
    return Card(
      key: ValueKey('hi-bridge-${t.id}'),
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.lighthouseYellow.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        side: const BorderSide(color: AppColors.lighthouseYellow),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upperTr(HiTexts.bridgeLabel),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.seaBlue,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        t.titleTr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (t.audio != null) HiListenButton(path: t.audio!),
              ],
            ),
            const SizedBox(height: 4),
            Text(t.textTr, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              HiTexts.bridgeNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.ink.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            if (_thanked)
              Text(
                HiTexts.bridgeThanks,
                key: const ValueKey('hi-bridge-thanks'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  FilledButton(
                    key: const ValueKey('hi-bridge-done'),
                    onPressed: () => unawaited(_set(BridgeState.done)),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Text(HiTexts.bridgeDone),
                  ),
                  TextButton(
                    key: const ValueKey('hi-bridge-dismiss'),
                    onPressed: () => unawaited(_set(BridgeState.dismissed)),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Text(HiTexts.bridgeDismiss),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
