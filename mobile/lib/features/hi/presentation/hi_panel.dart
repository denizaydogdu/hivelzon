import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/text/turkish.dart';
import '../../notebook/application/card_audio_player.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/presentation/notebook_screen.dart' show createCardAudio;
import '../../player/presentation/widgets/hi_avatar.dart';
import '../../story/application/story_providers.dart';
import '../application/hi_providers.dart';
import '../data/hi_store.dart';
import '../domain/coach_rules.dart';
import '../domain/hi_content.dart';
import '../domain/lookup_search.dart';
import '../domain/weekly_summary.dart';
import 'hi_cards.dart';

/// Hi panelini açar (alt panel, kök gezginde: sekme çubuğunun da üstünde).
Future<void> showHiPanel(BuildContext context, WidgetRef ref) async {
  // Balon hep açık olduğu için öneri sağlayıcısı canlı kalır: her açılışta
  // güncel kayıtlarla yeniden hesaplanır.
  refreshNotebook(ref);
  refreshHi(ref);
  unawaited(
    ref
        .read(hiStoreProvider)
        .markPanelOpened()
        .then((_) => ref.invalidate(hiBadgeProvider))
        .catchError((Object _) {}),
  );
  Future<void> navigate(String route) async {
    await context.push(route);
    if (!context.mounted) return;
    await refreshWhenVisible(context, ref);
    refreshNotebook(ref);
    refreshHi(ref);
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    backgroundColor: AppColors.sand,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.radius),
      ),
    ),
    builder: (sheet) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scroll) => HiPanelView(
        scroll: scroll,
        onNavigate: (route) {
          Navigator.of(sheet).pop();
          unawaited(navigate(route));
        },
        onStoryTab: () {
          Navigator.of(sheet).pop();
          context.go(AppRoutes.story);
        },
      ),
    ),
  );
}

/// Panel içeriği: Hi'nin tanıtımı, bugünkü öneri (gerekçesiyle), yan görev,
/// hızlı eylemler, "Bu ne demek?" ve haftalık özet.
class HiPanelView extends ConsumerStatefulWidget {
  const HiPanelView({
    super.key,
    this.scroll,
    required this.onNavigate,
    required this.onStoryTab,
  });

  final ScrollController? scroll;
  final void Function(String route) onNavigate;
  final VoidCallback onStoryTab;

  @override
  ConsumerState<HiPanelView> createState() => _HiPanelViewState();
}

class _HiPanelViewState extends ConsumerState<HiPanelView> {
  late final CardAudioPlayer _audio;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _audio = createCardAudio(ref);
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  Future<void> _act(HiSuggestion s) async {
    final noteId = s.noteId;
    if (noteId != null) {
      final content = await ref.read(hiContentProvider.future);
      final note = content.note(noteId);
      if (s.errorType != null) {
        await ref.read(hiStoreProvider).markNoteRead(s.errorType!);
      }
      if (!mounted || note == null) return;
      await showHiNote(context, note);
      if (mounted) refreshHi(ref);
      return;
    }
    if (s.errorType != null) {
      await ref.read(hiStoreProvider).markNoteRead(s.errorType!);
    }
    final route = s.actionRoute;
    if (route != null) widget.onNavigate(route);
  }

  Future<void> _continueStory() async {
    final input = await ref.read(coachInputProvider.future);
    final ip = input.inProgress;
    final nx = input.next;
    if (ip != null) {
      widget.onNavigate(AppRoutes.play(ip.contentId, mode: 'resume'));
    } else if (nx != null) {
      widget.onNavigate(AppRoutes.play(nx.contentId));
    } else {
      widget.onStoryTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestion = ref.watch(hiSuggestionProvider);
    final bridge = ref.watch(bridgeTaskProvider).value;
    final week = ref.watch(weeklySummaryProvider).value;
    return ListView(
      key: const ValueKey('hi-panel'),
      controller: widget.scroll,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.lg,
      ),
      children: [
        Row(
          children: [
            const HiAvatar(size: 64),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HiTexts.intro,
                    key: const ValueKey('hi-disclosure'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(HiTexts.introSub, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            IconButton(
              tooltip: CommonTexts.close,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _Heading(HiTexts.todayHeading),
        const SizedBox(height: AppSpacing.xs),
        switch (suggestion) {
          AsyncData(:final value) => _SuggestionCard(
            suggestion: value,
            onAct: () => unawaited(_act(value)),
          ),
          _ => const _LoadingCard(),
        },
        if (bridge != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _BridgeCard(task: bridge),
        ],
        const SizedBox(height: AppSpacing.md),
        _Heading(HiTexts.quickHeading),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            _Quick(
              key: const ValueKey('hi-quick-story'),
              icon: Icons.auto_stories_rounded,
              label: HiTexts.quickStory,
              onTap: () => unawaited(_continueStory()),
            ),
            _Quick(
              key: const ValueKey('hi-quick-review'),
              icon: Icons.style_rounded,
              label: HiTexts.quickReview,
              onTap: () => widget.onNavigate(AppRoutes.review),
            ),
            _Quick(
              key: const ValueKey('hi-quick-notebook'),
              icon: Icons.menu_book_rounded,
              label: HiTexts.quickNotebook,
              onTap: () => widget.onNavigate(AppRoutes.notebook),
            ),
            _Quick(
              key: const ValueKey('hi-quick-sets'),
              icon: Icons.grid_view_rounded,
              label: HiTexts.quickSets,
              onTap: () => widget.onNavigate(AppRoutes.notebookSets),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _Heading(HiTexts.lookupHeading),
        const SizedBox(height: 4),
        Text(HiTexts.lookupIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          key: const ValueKey('hi-lookup'),
          textInputAction: TextInputAction.search,
          autocorrect: false,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            hintText: HiTexts.lookupHint,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (v) => setState(() => _query = v.trim()),
        ),
        if (_query.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          _LookupResults(query: _query, audio: _audio),
        ],
        const SizedBox(height: AppSpacing.md),
        _Heading(HiTexts.weekHeading),
        const SizedBox(height: AppSpacing.xs),
        _WeekCard(summary: week),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    label: HiTexts.loading,
    child: Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
    ),
  );
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.suggestion, required this.onAct});

  final HiSuggestion suggestion;
  final VoidCallback onAct;

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
            ],
          ],
        ),
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick({
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

class _BridgeCard extends ConsumerStatefulWidget {
  const _BridgeCard({required this.task});

  final BridgeTask task;

  @override
  ConsumerState<_BridgeCard> createState() => _BridgeCardState();
}

class _BridgeCardState extends ConsumerState<_BridgeCard> {
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

class _LookupResults extends ConsumerWidget {
  const _LookupResults({required this.query, required this.audio});

  final String query;
  final CardAudioPlayer audio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidates = ref.watch(lookupCandidatesProvider);
    final list = candidates.value;
    if (list == null) return const _LoadingCard();
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
              child: _LookupTile(result: r, audio: audio),
            ),
        ],
      ),
    );
  }
}

class _LookupTile extends StatelessWidget {
  const _LookupTile({required this.result, required this.audio});

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

class _WeekCard extends StatelessWidget {
  const _WeekCard({required this.summary});

  final WeeklySummary? summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = summary;
    if (s == null) return const _LoadingCard();
    final lines = <String>[
      if (s.phrasesAdded > 0) HiTexts.weekPhrases(s.phrasesAdded),
      if (s.phrasesReviewed > 0) HiTexts.weekReviews(s.phrasesReviewed),
      if (s.episodesCompleted > 0) HiTexts.weekEpisodes(s.episodesCompleted),
      if (s.focus != null) HiTexts.weekFocus(s.focus!.labelTr),
    ];
    return Card(
      key: const ValueKey('hi-week'),
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              HiTexts.weekSub,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.ink.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            if (lines.isEmpty)
              Text(HiTexts.weekEmpty, style: theme.textTheme.bodyLarge)
            else
              for (final l in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 20,
                          color: AppColors.seaBlue,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(l, style: theme.textTheme.bodyLarge),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
