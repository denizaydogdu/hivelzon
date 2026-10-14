import 'package:flutter/material.dart';

import '../../../../app/design/tokens.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import '../../../grammar/domain/grammar_progress.dart';
import '../../../grammar/presentation/grammar_view.dart';
import '../../domain/season_map.dart';
import '../../domain/unlock_rule.dart';

/// Bölüm noktasına dokununca açılan alt panel (H-035; tasarım H-060:
/// `AppSheet` iskeleti).
///
/// Oynanabilir: "Başla" / "Devam et" (+ "Baştan başla") / "Tekrar oyna".
/// Kilitli: nazik kilit nedeni (zaman yok, suçlama yok). Yakında: tarih yok.
///
/// H-078: oynanabilir bölümde `grammarTopics` dersleri varsa ikincil düğme
/// "Bu bölümdeki dilbilgisi (~N dk)" ve konuların adları. Seçilmezse hiçbir
/// şey değişmez (H-050: bölüm yine doğrudan başlıkla açılır).
class EpisodeSheet extends StatelessWidget {
  const EpisodeSheet({
    super.key,
    required this.episode,
    required this.onPlay,
    this.grammar,
    this.onGrammar,
  });

  final MapEpisode episode;

  /// [mode]: `resume` | `restart` | `null`.
  final void Function(String contentId, String? mode) onPlay;

  /// Bölümdeki dilbilgisi dersleri (yoksa düğme yok).
  final GrammarOffer? grammar;

  /// [mode]: dersler bitince bölümün açılacağı biçim (ana düğmeyle aynı).
  final void Function(GrammarOffer offer, String? mode)? onGrammar;

  static Future<void> show(
    BuildContext context,
    MapEpisode episode, {
    required void Function(String contentId, String? mode) onPlay,
    GrammarOffer? grammar,
    void Function(GrammarOffer offer, String? mode)? onGrammar,
  }) => showAppSheet<void>(
    context: context,
    builder: (context) => EpisodeSheet(
      episode: episode,
      onPlay: onPlay,
      grammar: grammar,
      onGrammar: onGrammar,
    ),
  );

  /// Ana düğmenin biçimi: yarımsa kaldığı yerden, bittiyse baştan.
  String? get _primaryMode => episode.progress.hasCheckpoint
      ? 'resume'
      : episode.state == MapNodeState.completed
      ? 'restart'
      : null;

  void _play(BuildContext context, String? mode) {
    Navigator.of(context).pop();
    onPlay(episode.contentId, mode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = episode;
    final reason = lockReason(e.access);
    const buttonSize = Size.fromHeight(AppTouch.primary);
    final actions = <Widget>[
      if (e.playable && e.progress.hasCheckpoint) ...[
        FilledButton.icon(
          key: const ValueKey('sheet-resume'),
          onPressed: () => _play(context, 'resume'),
          style: FilledButton.styleFrom(minimumSize: buttonSize),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text(StoryTexts.resume),
        ),
        const SizedBox(height: AppSpace.s8),
        OutlinedButton(
          key: const ValueKey('sheet-restart'),
          onPressed: () => _play(context, 'restart'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTouch.min),
          ),
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
    return SingleChildScrollView(
      key: const ValueKey('episode-sheet'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: CapsLabel(
              StoryTexts.sheetLabel(e.number, e.state.labelTr),
              tone:
                  e.state == MapNodeState.locked ||
                      e.state == MapNodeState.comingSoon
                  ? CapsTone.blue
                  : CapsTone.orange,
            ),
          ),
          const SizedBox(height: AppSpace.s8),
          Semantics(
            header: true,
            child: Text(e.title, style: theme.textTheme.headlineSmall),
          ),
          if (e.teaser != null) ...[
            const SizedBox(height: AppSpace.s8),
            Text(
              e.teaser!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppPalette.ink700,
              ),
            ),
          ],
          if (reason != null) ...[
            const SizedBox(height: AppSpace.s16),
            InfoCard(
              key: const ValueKey('sheet-lock-reason'),
              icon: Icons.lock_outline_rounded,
              tone: InfoTone.info,
              title: reason,
              body: StoryTexts.lockDetail,
            ),
          ],
          if (e.state == MapNodeState.comingSoon) ...[
            const SizedBox(height: AppSpace.s16),
            const InfoCard(
              key: ValueKey('sheet-coming-soon'),
              icon: Icons.auto_stories_outlined,
              tone: InfoTone.info,
              title: StoryTexts.comingSoon,
              body: StoryTexts.comingSoonDetail,
            ),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: AppSpace.s24),
            ...actions,
          ],
          if (actions.isNotEmpty && grammar != null && onGrammar != null) ...[
            const SizedBox(height: AppSpace.s16),
            GrammarOfferButton(
              offer: grammar!,
              label: GrammarTexts.episodeOffer(grammar!.minutes),
              onPressed: () {
                Navigator.of(context).pop();
                onGrammar!(grammar!, _primaryMode);
              },
            ),
          ],
        ],
      ),
    );
  }
}
