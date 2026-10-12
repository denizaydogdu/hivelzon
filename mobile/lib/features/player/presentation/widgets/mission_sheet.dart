import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../domain/episode.dart';
import 'player_ui.dart';

/// Hedef ifadeye dokunuldu (anlamı varsa).
typedef PhraseTap = void Function(int index, String phrase, Gloss gloss);

/// 🎯 paneli (H-050): bölümün görev cümlesi ve hedef ifadeleri.
///
/// Açılışta ayrı görev kartı yoktur; kullanıcı isterse üst çubuktaki 🎯
/// düğmesiyle açar. Anlamı olan ifadeye dokununca anlam paneli açılır.
Future<void> showMissionSheet(
  BuildContext context, {
  required EpisodeInfo info,
  PhraseTap? onPhraseTap,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: AppColors.sand,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.radius),
      ),
    ),
    builder: (context) => MissionSheet(info: info, onPhraseTap: onPhraseTap),
  );
}

class MissionSheet extends StatelessWidget {
  const MissionSheet({super.key, required this.info, this.onPhraseTap});

  final EpisodeInfo info;
  final PhraseTap? onPhraseTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget caption(String text, IconData icon) => Row(
      children: [
        Icon(icon, color: AppColors.eveningOrange, size: 20),
        const SizedBox(width: AppSpacing.xs),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.eveningOrange,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        key: const ValueKey('mission-sheet'),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            caption('GÖREV', Icons.track_changes_rounded),
            const SizedBox(height: AppSpacing.xs),
            Text(
              info.mission.tr,
              style: t.titleLarge?.copyWith(
                color: AppColors.seaBlue,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            if (info.targetPhrases.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              caption('HEDEF İFADELER', Icons.record_voice_over_rounded),
              const SizedBox(height: AppSpacing.xs),
              for (final (i, p) in info.targetPhrases.indexed)
                _PhraseRow(
                  index: i,
                  phrase: p,
                  gloss: info.targetPhraseGloss[p],
                  onTap: onPhraseTap,
                ),
            ],
            const SizedBox(height: AppSpacing.md),
            PrimaryAction(
              key: const ValueKey('mission-close'),
              label: 'Devam et',
              icon: Icons.play_arrow_rounded,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhraseRow extends StatelessWidget {
  const _PhraseRow({
    required this.index,
    required this.phrase,
    required this.gloss,
    required this.onTap,
  });

  final int index;
  final String phrase;
  final Gloss? gloss;
  final PhraseTap? onTap;

  @override
  Widget build(BuildContext context) {
    final g = gloss;
    final tappable = g != null && onTap != null;
    final text = Text(
      phrase,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        decoration: tappable ? TextDecoration.underline : null,
        decorationStyle: TextDecorationStyle.dotted,
        decorationColor: AppColors.seaBlue.withValues(alpha: 0.5),
      ),
    );
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(
        children: [
          Expanded(child: text),
          if (tappable)
            const Icon(
              Icons.translate_rounded,
              size: 20,
              color: AppColors.seaBlue,
            ),
        ],
      ),
    );
    if (!tappable) return row;
    return Semantics(
      button: true,
      label: '$phrase. Anlamını görmek için dokun.',
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('mission-phrase-$index'),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: () => onTap!(index, phrase, g),
        child: row,
      ),
    );
  }
}
