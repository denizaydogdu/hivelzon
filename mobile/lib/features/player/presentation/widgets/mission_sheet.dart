import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import '../../domain/episode.dart';
import 'player_ui.dart';

/// Hedef ifadeye dokunuldu (anlamı varsa).
typedef PhraseTap = void Function(int index, String phrase, Gloss gloss);

/// 🎯 paneli (H-050): bölümün görev cümlesi ve hedef ifadeleri.
///
/// Açılışta ayrı görev kartı yoktur; kullanıcı isterse üst çubuktaki 🎯
/// düğmesiyle açar. Anlamı olan ifadeye dokununca anlam paneli açılır.
/// Zemin, köşe ve tutamaç temadan (`bottomSheetTheme`, H-062).
Future<void> showMissionSheet(
  BuildContext context, {
  required EpisodeInfo info,
  PhraseTap? onPhraseTap,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
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
        Icon(icon, color: AppPalette.orange700, size: AppIconSize.sm),
        const SizedBox(width: AppSpace.s8),
        Flexible(child: CapsLabel(text)),
      ],
    );
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        key: const ValueKey('mission-sheet'),
        padding: const EdgeInsets.fromLTRB(
          AppSpace.s24,
          0,
          AppSpace.s24,
          AppSpace.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            caption(PlayerTexts.missionLabel, Icons.track_changes_rounded),
            const SizedBox(height: AppSpace.s8),
            Text(
              info.mission.tr,
              style: t.titleLarge?.copyWith(
                color: AppPalette.seaBlue,
                height: 1.3,
              ),
            ),
            if (info.targetPhrases.isNotEmpty) ...[
              const SizedBox(height: AppSpace.s24),
              caption(
                PlayerTexts.targetPhrasesLabel,
                Icons.record_voice_over_rounded,
              ),
              const SizedBox(height: AppSpace.s8),
              Container(
                decoration: const BoxDecoration(
                  color: AppPalette.white,
                  borderRadius: AppRadius.mdAll,
                  boxShadow: AppShadows.level1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s16),
                child: Column(
                  children: [
                    for (final (i, p) in info.targetPhrases.indexed) ...[
                      if (i > 0) const Divider(),
                      _PhraseRow(
                        index: i,
                        phrase: p,
                        gloss: info.targetPhraseGloss[p],
                        onTap: onPhraseTap,
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpace.s24),
            PrimaryAction(
              key: const ValueKey('mission-close'),
              label: PlayerTexts.continueAction,
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
      style: AppTypography.lead.copyWith(
        fontWeight: AppFonts.bold,
        color: AppPalette.ink,
        decoration: tappable ? TextDecoration.underline : null,
        decorationStyle: TextDecorationStyle.dotted,
        decorationColor: AppPalette.seaBlue300,
      ),
    );
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppTouch.primary),
      child: Row(
        children: [
          Expanded(child: text),
          if (tappable)
            const Icon(
              Icons.translate_rounded,
              size: AppIconSize.sm,
              color: AppPalette.seaBlue,
            ),
        ],
      ),
    );
    if (!tappable) return row;
    return Semantics(
      button: true,
      label: PlayerTexts.tapForMeaning(phrase),
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('mission-phrase-$index'),
        borderRadius: AppRadius.mdAll,
        onTap: () => onTap!(index, phrase, g),
        child: row,
      ),
    );
  }
}
