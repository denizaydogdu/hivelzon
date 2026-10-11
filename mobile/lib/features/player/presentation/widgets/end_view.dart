import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../domain/episode.dart';
import '../../domain/episode_engine.dart';
import 'hi_avatar.dart';
import 'player_ui.dart';

/// Bölüm sonu: görev tamam, toplanan ipuçları, açık soru, hedef ifadeler.
class EndView extends StatelessWidget {
  const EndView({super.key, required this.engine, required this.onBack});

  final EpisodeEngine engine;
  final VoidCallback onBack;

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
            ]),
            const SizedBox(height: AppSpacing.md),
            PrimaryAction(
              key: const ValueKey('end-back'),
              label: 'Hikâye\'ye dön',
              icon: Icons.map_rounded,
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}
