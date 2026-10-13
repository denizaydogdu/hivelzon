import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../../shared/perf/perf_log.dart';
import '../../../shared/text/turkish.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../hi/application/hi_providers.dart';
import '../../hi/presentation/hi_cards.dart';
import '../../player/presentation/player_screen.dart';
import '../../topic_sets/presentation/topic_set_widgets.dart';
import '../application/card_audio_player.dart';
import '../application/notebook_providers.dart';
import '../domain/notebook_item.dart';
import '../domain/review_session.dart';
import 'widgets/card_face.dart';

/// Kart sesi çalar (ekran başına bir tane; testlerde sahte video platformu).
CardAudioPlayer createCardAudio(WidgetRef ref) {
  final source = ref.read(contentSourceProvider);
  return CardAudioPlayer(
    uriFor: (contentId, path) => resolveMediaUri(source, contentId, path),
    factory: ref.read(videoControllerFactoryProvider),
  );
}

/// Defterden çıkarılabilen kart: kullanıcının eklediği ya da konu setinden
/// gelen (H-051). Bölümün hedef ifadeleri ve bakılan kelimeler kalır.
bool isRemovable(NotebookItem item) =>
    item.source == NotebookSource.userSaved ||
    item.source == NotebookSource.topicSet;

/// Tekrar oturumunu açar; dönünce sayılar yenilenir.
Future<void> openReview(BuildContext context, WidgetRef ref) async {
  await context.push(AppRoutes.review);
  if (context.mounted) refreshNotebook(ref);
}

/// Profil → Defter (H-036, tasarım T5): "İfadeler | İpucu panosu".
class NotebookScreen extends ConsumerStatefulWidget {
  const NotebookScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  ConsumerState<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends ConsumerState<NotebookScreen> {
  late int _tab = widget.initialTab;
  late final CardAudioPlayer _audio;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _audio = createCardAudio(ref);
    // Vadesi gelen kartlar (ör. 10 dk sonra dönen kart) için sayılar her
    // açılışta yeniden hesaplanır.
    Future.microtask(() {
      if (mounted) refreshNotebook(ref);
    });
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text(
          NotebookTexts.title,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: PerfScope(
          tag: 'defter',
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  AppSpacing.xs,
                  AppSpacing.sm,
                  0,
                ),
                sliver: SliverList.list(
                  children: [
                    SegmentedButton<int>(
                      key: const ValueKey('notebook-tabs'),
                      showSelectedIcon: false,
                      style: SegmentedButton.styleFrom(
                        minimumSize: const Size(48, 48),
                        selectedBackgroundColor: AppColors.seaBlue,
                        selectedForegroundColor: Colors.white,
                      ),
                      segments: const [
                        ButtonSegment(
                          value: 0,
                          label: Text(NotebookTexts.tabPhrases),
                        ),
                        ButtonSegment(
                          value: 1,
                          label: Text(NotebookTexts.tabClues),
                        ),
                        ButtonSegment(
                          value: 2,
                          label: Text(NotebookTexts.tabSets),
                        ),
                      ],
                      selected: {_tab},
                      onSelectionChanged: (s) => setState(() => _tab = s.first),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      switch (_tab) {
                        0 => NotebookTexts.phrasesIntro,
                        1 => NotebookTexts.cluesIntro,
                        _ => NotebookTexts.setsIntro,
                      },
                      key: const ValueKey('notebook-intro'),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
              ...switch (_tab) {
                0 => _phrases(context),
                1 => _clues(context),
                _ => _sets(),
              },
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _phrases(BuildContext context) {
    final overview = ref.watch(reviewOverviewProvider);
    final entries = ref.watch(notebookEntriesProvider);
    final theme = Theme.of(context);
    final pad = const EdgeInsets.symmetric(horizontal: AppSpacing.sm);
    return [
      SliverPadding(
        padding: pad,
        sliver: SliverToBoxAdapter(
          child: _ReviewCard(overview: overview.value),
        ),
      ),
      // Hi'nin konu notları (H-048): görülen konu kartları yeniden açılır.
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.sm,
          0,
        ),
        sliver: SliverToBoxAdapter(child: _TopicNotes()),
      ),
      SliverPadding(
        padding: pad.copyWith(top: AppSpacing.md),
        sliver: SliverToBoxAdapter(
          child: Text(
            NotebookTexts.listHeading(entries.value?.length ?? 0),
            key: const ValueKey('notebook-list-heading'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: pad.copyWith(top: AppSpacing.xs),
        sliver: SliverToBoxAdapter(
          child: TextField(
            key: const ValueKey('notebook-search'),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: NotebookTexts.search,
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) => setState(() => _query = lowerTr(v.trim())),
          ),
        ),
      ),
      switch (entries) {
        AsyncData(:final value) => _list(value),
        AsyncError() => const SliverToBoxAdapter(
          child: _Message(
            icon: Icons.error_outline_rounded,
            text: NotebookTexts.loadError,
          ),
        ),
        // H-054: spinner yerine liste iskeleti.
        _ => const SliverToBoxAdapter(
          child: ListSkeleton(
            key: ValueKey('skeleton-notebook'),
            label: NotebookTexts.listLoading,
          ),
        ),
      },
      const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
    ];
  }

  Widget _list(List<NotebookEntry> all) {
    PerfLog.markAfterFrame('Defter listesi hazır');
    if (all.isEmpty) {
      return const SliverToBoxAdapter(
        child: _Message(
          icon: Icons.menu_book_outlined,
          text: NotebookTexts.empty,
        ),
      );
    }
    final q = _query;
    final list = q.isEmpty
        ? all
        : [
            for (final e in all)
              if (lowerTr(e.item.textEn).contains(q) ||
                  (e.item.textTr != null &&
                      lowerTr(e.item.textTr!).contains(q)))
                e,
          ];
    if (list.isEmpty) {
      return const SliverToBoxAdapter(
        child: _Message(
          icon: Icons.search_off_rounded,
          text: NotebookTexts.noMatch,
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
        0,
      ),
      sliver: SliverList.separated(
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (context, i) => _EntryTile(
          entry: list[i],
          audio: _audio,
          onOpen: () => _openDetail(list[i]),
          onRemove: isRemovable(list[i].item) ? () => _remove(list[i]) : null,
        ),
      ),
    );
  }

  Future<void> _openDetail(NotebookEntry e) async {
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
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        builder: (context, scroll) => ListView(
          key: const ValueKey('card-detail'),
          controller: scroll,
          padding: const EdgeInsets.all(AppSpacing.sm),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: CommonTexts.close,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            CardFace(item: e.item, player: _audio),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _dueText(e.card),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.ink.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
    await _audio.stop();
  }

  Future<void> _remove(NotebookEntry e) async {
    final id = e.item.id;
    if (id == null) return;
    final removed = await ref.read(notebookStoreProvider).removeUserItem(id);
    if (!mounted) return;
    refreshNotebook(ref);
    if (removed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(NotebookTexts.removed(e.item.textEn))),
      );
    }
  }

  /// H-051: hikâye mekânlarına bağlı konu setleri.
  List<Widget> _sets() => const [
    SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      sliver: SliverToBoxAdapter(child: TopicSetsSection()),
    ),
    SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
  ];

  List<Widget> _clues(BuildContext context) {
    final board = ref.watch(clueBoardProvider);
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        sliver: SliverToBoxAdapter(
          child: switch (board) {
            AsyncData(:final value) => _ClueBoard(data: value),
            AsyncError() => const _Message(
              icon: Icons.error_outline_rounded,
              text: NotebookTexts.cluesError,
            ),
            _ => const ListSkeleton(
              key: ValueKey('skeleton-clues'),
              label: NotebookTexts.cluesLoading,
              rows: 3,
              padding: EdgeInsets.only(top: AppSpacing.xs),
            ),
          },
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
    ];
  }
}

String _dueText(ReviewCardState c) {
  if (c.isNew) return NotebookTexts.dueNew;
  final now = DateTime.now().toUtc();
  if (!c.fsrs.due.isAfter(now)) return NotebookTexts.dueNow;
  final local = c.fsrs.due.toLocal();
  final today = DateTime.now();
  final days = DateTime(
    local.year,
    local.month,
    local.day,
  ).difference(DateTime(today.year, today.month, today.day)).inDays;
  if (days <= 0) return NotebookTexts.dueToday;
  if (days == 1) return NotebookTexts.dueTomorrow;
  return NotebookTexts.dueInDays(days);
}

/// "Kelime tekrarı" kartı (T5 üst kart): sayı cümle içinde, tahmini süreyle.
class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({required this.overview});

  final ReviewOverview? overview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final o = overview;
    final n = o?.sessionCount ?? 0;
    return Card(
      key: const ValueKey('notebook-review-card'),
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              upperTr(NotebookTexts.reviewHeading),
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.seaBlue,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              o == null
                  ? NotebookTexts.reviewPreparing
                  : n > 0
                  ? NotebookTexts.reviewDue(n, HomeTexts.reviewMinutes(n))
                  : o.totalItems == 0
                  ? NotebookTexts.reviewEmpty
                  : NotebookTexts.reviewDoneToday,
              key: const ValueKey('notebook-review-text'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (o != null && n > 0) ...[
              const SizedBox(height: 4),
              Text(
                NotebookTexts.reviewHowTo,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                key: const ValueKey('notebook-start-review'),
                onPressed: () => openReview(context, ref),
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(NotebookTexts.reviewStart),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.entry,
    required this.audio,
    required this.onOpen,
    this.onRemove,
  });

  final NotebookEntry entry;
  final CardAudioPlayer audio;
  final VoidCallback onOpen;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final item = entry.item;
    final theme = Theme.of(context);
    final tag = item.episodeTag;
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InkWell(
        key: ValueKey('entry-${item.key}'),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onOpen,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                if (tag != null) EpisodeTag(tag: tag),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.textEn,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (item.textTr != null)
                        Text(
                          item.textTr!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.ink.withValues(alpha: 0.7),
                          ),
                        ),
                    ],
                  ),
                ),
                AudioButton(player: audio, item: item, size: 24),
                if (onRemove != null)
                  PopupMenuButton<String>(
                    key: ValueKey('entry-menu-${item.key}'),
                    tooltip: NotebookTexts.options,
                    onSelected: (_) => onRemove!(),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'remove',
                        child: Text(NotebookTexts.remove),
                      ),
                    ],
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.ink,
                    semanticLabel: NotebookTexts.openCard,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClueBoard extends StatelessWidget {
  const _ClueBoard({required this.data});

  final ClueBoardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (data.isEmpty) {
      return const _Message(
        icon: Icons.push_pin_outlined,
        text: NotebookTexts.cluesEmpty,
      );
    }
    final heading = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    return Column(
      key: const ValueKey('clue-board'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (data.openQuestions.isNotEmpty) ...[
          Text(NotebookTexts.openQuestions, style: heading),
          const SizedBox(height: AppSpacing.xs),
          for (final q in data.openQuestions) ...[
            Card(
              key: ValueKey('open-question-${q.id}'),
              margin: EdgeInsets.zero,
              color: AppColors.seaBlue,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NotebookTexts.openQuestionLabel(q.openedNumber),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.lighthouseYellow,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      q.textTr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (q.partialNote != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        NotebookTexts.partialNote(q.partialNote!),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          const SizedBox(height: AppSpacing.sm),
        ],
        if (data.clues.isNotEmpty) ...[
          Text(NotebookTexts.foundClues, style: heading),
          const SizedBox(height: AppSpacing.xs),
          for (final e in data.clues.entries) ...[
            Text(
              _episodeLabel(e.key),
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.seaBlue,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            for (final c in e.value)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Material(
                  key: ValueKey('clue-${c.contentId}-${c.clueId}'),
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.push_pin_rounded,
                          color: AppColors.eveningOrange,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            c.textTr,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ],
    );
  }

  static String _episodeLabel(String contentId) {
    final m = RegExp(r'-(\d{3})$').firstMatch(contentId);
    return m == null
        ? contentId
        : NotebookTexts.clueEpisode(int.parse(m.group(1)!));
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.seaBlue),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    ),
  );
}

/// Hi'nin konu notları: bölümde görülen konu kartları (H-048).
class _TopicNotes extends ConsumerWidget {
  const _TopicNotes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final intros = ref.watch(seenTopicIntrosProvider).value;
    if (intros == null) return const SizedBox.shrink();
    return Card(
      key: const ValueKey('notebook-topic-notes'),
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              HiTexts.topicNotesHeading,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.seaBlue,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              intros.isEmpty
                  ? HiTexts.topicNotesEmpty
                  : HiTexts.topicNotesCount(intros.length),
              style: theme.textTheme.bodyMedium,
            ),
            if (intros.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final t in intros)
                    ActionChip(
                      key: ValueKey('topic-note-${t.id}'),
                      label: Text(t.titleEn),
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      onPressed: () => showTopicIntro(context, t),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
