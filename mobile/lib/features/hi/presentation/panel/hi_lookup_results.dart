// Hi paneli: "Bu ne demek?" sonuçları (H-063 bölme).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/text/turkish.dart';
import '../../../notebook/application/card_audio_player.dart';
import '../../application/hi_providers.dart';
import '../../domain/lookup_search.dart';
import 'hi_panel_parts.dart';

/// "Bu ne demek?" arama sonuçları (yalnız açılmış içerikten).
class HiLookupResults extends ConsumerWidget {
  const HiLookupResults({super.key, required this.query, required this.audio});

  final String query;
  final CardAudioPlayer audio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidates = ref.watch(lookupCandidatesProvider);
    final list = candidates.value;
    if (list == null) return const HiPanelLoadingCard();
    final results = searchLookup(query, list);
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          HiTexts.lookupNoMatch,
          key: const ValueKey('hi-lookup-empty'),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return ListenableBuilder(
      listenable: audio,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final r in results)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: HiLookupTile(result: r, audio: audio),
            ),
        ],
      ),
    );
  }
}

/// Tek sonuç: ifade, anlam, örnek ve dinleme düğmeleri.
class HiLookupTile extends StatelessWidget {
  const HiLookupTile({super.key, required this.result, required this.audio});

  final LookupCandidate result;
  final CardAudioPlayer audio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final it = result.item;
    final tag = switch (result.origin) {
      LookupOrigin.notebook => HiTexts.lookupFromNotebook,
      LookupOrigin.topicSet => HiTexts.lookupFromSet,
      LookupOrigin.episode =>
        it.episodeTag == null ? null : HiTexts.lookupSource(it.episodeTag!),
    };
    final meaning = [
      if (it.textTr != null) it.textTr!,
      ...result.alt.where((a) => a != it.textTr),
    ].join(' · ');
    return Card(
      key: ValueKey('hi-lookup-${it.textEn}'),
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    it.textEn,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (it.hasAudio)
                  IconButton(
                    tooltip: HiTexts.lookupListen,
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    onPressed: () => unawaited(audio.play(it)),
                    icon: Icon(
                      audio.playingKey == CardAudioPlayer.keyFor(it)
                          ? Icons.graphic_eq_rounded
                          : Icons.volume_up_rounded,
                      color: AppColors.seaBlue,
                    ),
                  ),
              ],
            ),
            if (meaning.isNotEmpty)
              Text(meaning, style: theme.textTheme.bodyLarge),
            if (it.exampleEn != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                upperTr(HiTexts.lookupExample),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.seaBlue,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it.exampleEn!, style: theme.textTheme.bodyLarge),
                        if (it.exampleTr != null)
                          Text(
                            it.exampleTr!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.ink.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (it.exampleAudio != null)
                    IconButton(
                      tooltip: HiTexts.lookupListenExample,
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      onPressed: () => unawaited(audio.play(it, example: true)),
                      icon: const Icon(
                        Icons.record_voice_over_rounded,
                        color: AppColors.seaBlue,
                      ),
                    ),
                ],
              ),
            ],
            if (tag != null) ...[
              const SizedBox(height: 4),
              Text(
                tag,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.ink.withValues(alpha: 0.65),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
