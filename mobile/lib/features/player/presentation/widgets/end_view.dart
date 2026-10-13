import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/speech/speak_widgets.dart';
import '../../../../shared/speech/speech_store.dart';
import '../../../../shared/text/turkish.dart';
import '../../domain/episode.dart';
import '../../domain/episode_engine.dart';
import 'hi_avatar.dart';
import 'player_ui.dart';

/// Bölüm sonu: görev tamam, toplanan ipuçları, açık soru, hedef ifadeler.
class EndView extends StatelessWidget {
  const EndView({
    super.key,
    required this.engine,
    required this.onBack,
    this.topicSetTitle,
    this.topicSetIsNew = true,
    this.onOpenTopicSet,
    this.speak,
    this.onSpokenTarget,
  });

  /// "Hedef ifadeleri söyle" (H-055): yalnızca cihazda tanıma varsa. İsteğe
  /// bağlı; en az birini tam söylemek kapının "hedef ifade" ölçütünü de
  /// karşılar ([onSpokenTarget]).
  final SpeakEnv? speak;
  final VoidCallback? onSpokenTarget;

  final EpisodeEngine engine;
  final VoidCallback onBack;

  /// Bu bölüm bitince açılan konu seti (H-051); yoksa satır gösterilmez.
  final String? topicSetTitle;

  /// İlk bitirişte "açıldı"; tekrar oynayışta yalnızca setin adı.
  final bool topicSetIsNew;
  final VoidCallback? onOpenTopicSet;

  @override
  Widget build(BuildContext context) {
    final ep = engine.episode;
    final theme = Theme.of(context);
    final visited = engine.history.toSet();
    final clueLines = <String>[
      for (final n in ep.nodes.values.whereType<CardNode>())
        if (n.kind == CardKind.clue && visited.contains(n.id))
          for (final l in engine.linesFor(n))
            if (l.style != 'heading') l.text,
    ];
    final questionLines = <CardLine>[
      for (final n in ep.nodes.values.whereType<CardNode>())
        if (n.kind == CardKind.openQuestion && visited.contains(n.id))
          ...engine.linesFor(n).where((l) => l.style != 'caption'),
    ];
    final nextTeaser = <String>[
      for (final n in ep.nodes.values.whereType<CardNode>())
        if (n.kind == CardKind.openQuestion && visited.contains(n.id))
          for (final l in engine.linesFor(n))
            if (l.style == 'caption' && l.lang == Lang.en) l.text,
    ];

    Widget section(String title, IconData icon, List<Widget> children) =>
        PlayerPanel(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.eveningOrange),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.eveningOrange,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ...children,
            ],
          ),
        );

    return ColoredBox(
      color: AppColors.sand,
      child: SafeArea(
        child: ListView(
          key: const ValueKey('end-view'),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const Center(child: HiAvatar(size: 96)),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              header: true,
              child: Text(
                'Görev tamam!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.seaBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              ep.info.mission.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            if (clueLines.isNotEmpty) ...[
              section('TOPLANAN İPUÇLARI', Icons.push_pin_rounded, [
                for (final c in clueLines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(c, style: theme.textTheme.bodyLarge),
                  ),
              ]),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (questionLines.isNotEmpty) ...[
              section('AÇIK SORU', Icons.help_outline_rounded, [
                for (final q in questionLines)
                  Text(
                    q.text,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.seaBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                for (final t in nextTeaser)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Sıradaki: $t',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
              ]),
              const SizedBox(height: AppSpacing.sm),
            ],
            section('BU BÖLÜMÜN İFADELERİ', Icons.record_voice_over_rounded, [
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final p in ep.info.targetPhrases)
                    Chip(
                      label: Text(p),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: AppColors.seaBlue.withValues(alpha: 0.3),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                PlayerTexts.endNotebookNote,
                key: const ValueKey('end-notebook-note'),
                style: theme.textTheme.bodyMedium,
              ),
            ]),
            if (speak != null && ep.info.targetPhrases.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              section(upperTr(SpeakTexts.endSection), Icons.mic_rounded, [
                Text(SpeakTexts.endIntro, style: theme.textTheme.bodyMedium),
                for (final (i, p) in ep.info.targetPhrases.indexed) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    p,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SpeakPractice(
                    key: ValueKey('end-speak-$i'),
                    expected: p,
                    env: speak!,
                    place: SpeechPlace.episodeEnd,
                    contentId: ep.info.id,
                    keyPrefix: 'end-speak-$i',
                    dense: true,
                    onAttempt: (c) {
                      if (c.succeeded) onSpokenTarget?.call();
                    },
                  ),
                ],
              ]),
            ],
            if (topicSetTitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              section(
                upperTr(
                  topicSetIsNew
                      ? PlayerTexts.newTopicSetLabel
                      : PlayerTexts.topicSetLabel,
                ),
                Icons.photo_library_rounded,
                [
                  Text(
                    topicSetIsNew
                        ? PlayerTexts.newTopicSet(topicSetTitle!)
                        : PlayerTexts.topicSet(topicSetTitle!),
                    key: const ValueKey('end-topic-set'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (onOpenTopicSet != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    OutlinedButton.icon(
                      key: const ValueKey('end-open-topic-set'),
                      onPressed: onOpenTopicSet,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        foregroundColor: AppColors.seaBlue,
                        side: const BorderSide(
                          color: AppColors.seaBlue,
                          width: 1.5,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      icon: const Icon(Icons.grid_view_rounded),
                      label: const Text(PlayerTexts.openTopicSet),
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            PrimaryAction(
              key: const ValueKey('end-back'),
              label: PlayerTexts.backToMap,
              icon: Icons.map_rounded,
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}
