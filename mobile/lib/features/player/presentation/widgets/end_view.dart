import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/speech/speak_widgets.dart';
import '../../../../shared/speech/speech_store.dart';
import '../../../../shared/ui/ui.dart';
import '../../domain/episode.dart';
import '../../domain/episode_engine.dart';
import 'player_ui.dart';

/// Bölüm sonu: görev tamam, toplanan ipuçları, açık soru, hedef ifadeler.
///
/// H-062: sakin kutlama (`CalmCelebration`: bir kez beliren iki yumuşak
/// halka; konfeti, ses, puan yok; K-32) ve bölümler sırayla belirir.
/// "Hareketi azalt" açıksa durağan.
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

    final sections = <Widget>[
      if (clueLines.isNotEmpty)
        _EndSection(
          title: PlayerTexts.cluesLabel,
          icon: Icons.push_pin_rounded,
          children: [
            for (final c in clueLines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.s4),
                child: Text(c, style: theme.textTheme.bodyLarge),
              ),
          ],
        ),
      if (questionLines.isNotEmpty)
        _EndSection(
          title: PlayerTexts.openQuestionLabel,
          icon: Icons.help_outline_rounded,
          children: [
            for (final q in questionLines)
              Text(
                q.text,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppPalette.seaBlue,
                ),
              ),
            for (final t in nextTeaser)
              Padding(
                padding: const EdgeInsets.only(top: AppSpace.s4),
                child: Text(
                  PlayerTexts.nextTeaser(t),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      _EndSection(
        title: PlayerTexts.phrasesLabel,
        icon: Icons.record_voice_over_rounded,
        children: [
          Wrap(
            spacing: AppSpace.s8,
            runSpacing: AppSpace.s8,
            children: [
              for (final p in ep.info.targetPhrases) Chip(label: Text(p)),
            ],
          ),
          const SizedBox(height: AppSpace.s8),
          Text(
            PlayerTexts.endNotebookNote,
            key: const ValueKey('end-notebook-note'),
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      if (speak != null && ep.info.targetPhrases.isNotEmpty)
        _EndSection(
          title: SpeakTexts.endSection,
          icon: Icons.mic_rounded,
          children: [
            Text(SpeakTexts.endIntro, style: theme.textTheme.bodyMedium),
            for (final (i, p) in ep.info.targetPhrases.indexed) ...[
              const SizedBox(height: AppSpace.s16),
              Text(
                p,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppPalette.ink,
                ),
              ),
              const SizedBox(height: AppSpace.s4),
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
          ],
        ),
      if (topicSetTitle != null)
        _EndSection(
          title: topicSetIsNew
              ? PlayerTexts.newTopicSetLabel
              : PlayerTexts.topicSetLabel,
          icon: Icons.photo_library_rounded,
          children: [
            Text(
              topicSetIsNew
                  ? PlayerTexts.newTopicSet(topicSetTitle!)
                  : PlayerTexts.topicSet(topicSetTitle!),
              key: const ValueKey('end-topic-set'),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: AppFonts.medium,
              ),
            ),
            if (onOpenTopicSet != null) ...[
              const SizedBox(height: AppSpace.s8),
              OutlinedButton.icon(
                key: const ValueKey('end-open-topic-set'),
                onPressed: onOpenTopicSet,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppTouch.min),
                ),
                icon: const Icon(Icons.grid_view_rounded),
                label: const Text(PlayerTexts.openTopicSet),
              ),
            ],
          ],
        ),
    ];

    return ColoredBox(
      color: AppPalette.sand,
      child: SafeArea(
        child: ListView(
          key: const ValueKey('end-view'),
          padding: const EdgeInsets.all(AppSpace.s24),
          children: [
            const Center(
              child: CalmCelebration(
                key: ValueKey('end-celebration'),
                icon: Icons.flag_rounded,
              ),
            ),
            const SizedBox(height: AppSpace.s16),
            SoftEntrance(
              child: Semantics(
                header: true,
                child: Text(
                  PlayerTexts.endTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppPalette.seaBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.s8),
            SoftEntrance(
              index: 1,
              child: Text(
                ep.info.mission.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: AppFonts.medium,
                ),
              ),
            ),
            const SizedBox(height: AppSpace.s24),
            for (final (i, s) in sections.indexed) ...[
              if (i > 0) const SizedBox(height: AppSpace.s16),
              SoftEntrance(index: i + 2, child: s),
            ],
            const SizedBox(height: AppSpace.s24),
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

/// Bölüm sonundaki bölüm kartı: turuncu ikon + büyük harfli etiket + içerik.
class _EndSection extends StatelessWidget {
  const _EndSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppPalette.orange700),
              const SizedBox(width: AppSpace.s8),
              Flexible(child: CapsLabel(title)),
            ],
          ),
          const SizedBox(height: AppSpace.s8),
          ...children,
        ],
      ),
    );
  }
}
