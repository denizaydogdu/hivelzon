import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../domain/season_map.dart';
import '../../domain/unlock_rule.dart';

/// Bölüm noktasına dokununca açılan alt panel (H-035).
///
/// Oynanabilir: "Başla" / "Devam et" (+ "Baştan başla") / "Tekrar oyna".
/// Kilitli: nazik kilit nedeni (zaman yok, suçlama yok). Yakında: tarih yok.
class EpisodeSheet extends StatelessWidget {
  const EpisodeSheet({super.key, required this.episode, required this.onPlay});

  final MapEpisode episode;

  /// [mode]: `resume` | `restart` | `null`.
  final void Function(String contentId, String? mode) onPlay;

  static Future<void> show(
    BuildContext context,
    MapEpisode episode, {
    required void Function(String contentId, String? mode) onPlay,
  }) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => EpisodeSheet(episode: episode, onPlay: onPlay),
  );

  void _play(BuildContext context, String? mode) {
    Navigator.of(context).pop();
    onPlay(episode.contentId, mode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = episode;
    final reason = lockReason(e.access);
    const buttonSize = Size(48, 48);
    final actions = <Widget>[
      if (e.playable && e.progress.hasCheckpoint) ...[
        FilledButton.icon(
          key: const ValueKey('sheet-resume'),
          onPressed: () => _play(context, 'resume'),
          style: FilledButton.styleFrom(minimumSize: buttonSize),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text(StoryTexts.resume),
        ),
        const SizedBox(height: AppSpacing.xs),
        OutlinedButton(
          key: const ValueKey('sheet-restart'),
          onPressed: () => _play(context, 'restart'),
          style: OutlinedButton.styleFrom(minimumSize: buttonSize),
          child: const Text(StoryTexts.restart),
        ),
      ] else if (e.playable && e.state == MapNodeState.completed)
        FilledButton.icon(
          key: const ValueKey('sheet-replay'),
          onPressed: () => _play(context, 'restart'),
          style: FilledButton.styleFrom(minimumSize: buttonSize),
          icon: const Icon(Icons.replay_rounded),
          label: const Text(StoryTexts.replay),
        )
      else if (e.playable)
        FilledButton.icon(
          key: const ValueKey('sheet-play'),
          onPressed: () => _play(context, null),
          style: FilledButton.styleFrom(minimumSize: buttonSize),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text(StoryTexts.play),
        ),
    ];
    return SafeArea(
      child: Padding(
        key: const ValueKey('episode-sheet'),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              StoryTexts.sheetLabel(e.number, e.state.labelTr),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Semantics(
              header: true,
              child: Text(
                e.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (e.teaser != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(e.teaser!, style: theme.textTheme.bodyLarge),
            ],
            if (reason != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _Note(
                key: const ValueKey('sheet-lock-reason'),
                icon: Icons.lock_outline_rounded,
                text: reason,
                detail: StoryTexts.lockDetail,
              ),
            ],
            if (e.state == MapNodeState.comingSoon) ...[
              const SizedBox(height: AppSpacing.sm),
              const _Note(
                key: ValueKey('sheet-coming-soon'),
                icon: Icons.auto_stories_outlined,
                text: StoryTexts.comingSoon,
                detail: StoryTexts.comingSoonDetail,
              ),
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              ...actions,
            ],
          ],
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({
    super.key,
    required this.icon,
    required this.text,
    required this.detail,
  });

  final IconData icon;
  final String text;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(detail, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
