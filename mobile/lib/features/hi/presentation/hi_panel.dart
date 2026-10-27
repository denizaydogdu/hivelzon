import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../notebook/application/card_audio_player.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/presentation/notebook_screen.dart' show createCardAudio;
import '../../player/presentation/widgets/hi_avatar.dart';
import '../../story/application/story_providers.dart';
import '../application/hi_providers.dart';
import '../domain/coach_rules.dart';
import 'hi_cards.dart';
import 'hi_expressions.dart';
import 'panel/hi_bridge_card.dart';
import 'panel/hi_lookup_results.dart';
import 'panel/hi_panel_parts.dart';
import 'panel/hi_suggestion_card.dart';
import 'panel/hi_week_card.dart';

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
    final plan = ref.watch(dailyPlanProvider);
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
        HiPanelIntro(
          expression: switch (plan) {
            AsyncData(:final value) => hiExpressionForSuggestion(
              value.primary.kind,
              now: DateTime.now(),
            ),
            _ => HiExpression.neutral,
          },
        ),
        const SizedBox(height: AppSpacing.md),
        HiPanelHeading(HiTexts.todayHeading),
        const SizedBox(height: AppSpacing.xs),
        switch (plan) {
          AsyncData(:final value) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                value.contextLine,
                key: const ValueKey('hi-suggestion-context'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppPalette.ink500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              HiSuggestionCard(
                suggestion: value.primary,
                onAct: () => unawaited(_act(value.primary)),
                onAnother: () =>
                    unawaited(dismissSuggestion(ref, value.primary)),
              ),
            ],
          ),
          _ => const HiPanelLoadingCard(),
        },
        if (bridge != null) ...[
          const SizedBox(height: AppSpacing.sm),
          HiBridgeCard(task: bridge),
        ],
        const SizedBox(height: AppSpacing.md),
        HiPanelHeading(HiTexts.quickHeading),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            HiQuickAction(
              key: const ValueKey('hi-quick-story'),
              icon: Icons.auto_stories_rounded,
              label: HiTexts.quickStory,
              onTap: () => unawaited(_continueStory()),
            ),
            HiQuickAction(
              key: const ValueKey('hi-quick-review'),
              icon: Icons.style_rounded,
              label: HiTexts.quickReview,
              onTap: () => widget.onNavigate(AppRoutes.review),
            ),
            HiQuickAction(
              key: const ValueKey('hi-quick-notebook'),
              icon: Icons.menu_book_rounded,
              label: HiTexts.quickNotebook,
              onTap: () => widget.onNavigate(AppRoutes.notebook),
            ),
            HiQuickAction(
              key: const ValueKey('hi-quick-sets'),
              icon: Icons.grid_view_rounded,
              label: HiTexts.quickSets,
              onTap: () => widget.onNavigate(AppRoutes.notebookSets),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        HiPanelHeading(HiTexts.lookupHeading),
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
          HiLookupResults(query: _query, audio: _audio),
        ],
        const SizedBox(height: AppSpacing.md),
        HiPanelHeading(HiTexts.weekHeading),
        const SizedBox(height: AppSpacing.xs),
        HiWeekCard(summary: week),
      ],
    );
  }
}
