import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../../shared/perf/perf_log.dart';
import '../../../shared/text/turkish.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../hi/application/hi_providers.dart';
import '../../hi/presentation/hi_cards.dart';
import '../../player/presentation/player_screen.dart';
import '../../topic_sets/presentation/topic_set_widgets.dart';
import '../application/card_audio_player.dart';
import '../application/notebook_providers.dart';
import '../domain/clue_board.dart';
import '../domain/notebook_item.dart';
import '../domain/review_session.dart';
import 'widgets/card_face.dart';
import 'widgets/notebook_row.dart';

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
    item.source == NotebookSource.topicSet ||
    item.source == NotebookSource.book;

/// Tekrar oturumunu açar; dönünce sayılar yenilenir.
Future<void> openReview(BuildContext context, WidgetRef ref) async {
  await context.push(AppRoutes.review);
  if (context.mounted) refreshNotebook(ref);
}

/// Boş Defter ve boş İpucu panosu illüstrasyonları (H-058).
abstract final class NotebookIllustrations {
  static const emptyNotebook = AssetImage(
    'assets/illustrations/bos-defter.webp',
  );
  static const emptyClues = AssetImage('assets/illustrations/bos-ipucu.webp');
  static const nothingDue = AssetImage('assets/illustrations/tekrar-yok.webp');
}

/// Profil → Defter (H-036; tasarım H-061, taslak S04): "İfadeler | İpucu
/// panosu | Konu setleri". Bütün öğeler tek satır biçimiyle ([NotebookRow])
/// ve ilk açılışta sırayla belirir.
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

  /// Kaynak süzgeci (H-067): null hepsi, `story` hikâyeden, `book:<kimlik>`.
  String? _filter;

  /// Belirme animasyonu oynamış satırlar (kaydırınca yeniden oynamaz).
  final Set<Object> _seen = {};

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
    Widget label(String text) => Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    return Scaffold(
      appBar: AppBar(title: const Text(NotebookTexts.title)),
      body: SafeArea(
        top: false,
        child: PerfScope(
          tag: 'defter',
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.page,
                  AppSpace.s8,
                  AppSpace.page,
                  0,
                ),
                sliver: SliverList.list(
                  children: [
                    // Sekme kontrolü temadan (H-057 `segmentedButtonTheme`).
                    SegmentedButton<int>(
                      key: const ValueKey('notebook-tabs'),
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(
                          value: 0,
                          label: label(NotebookTexts.tabPhrases),
                        ),
                        ButtonSegment(
                          value: 1,
                          label: label(NotebookTexts.tabClues),
                        ),
                        ButtonSegment(
                          value: 2,
                          label: label(NotebookTexts.tabSets),
                        ),
                      ],
                      selected: {_tab},
                      onSelectionChanged: (s) => setState(() => _tab = s.first),
                    ),
                    const SizedBox(height: AppSpace.s12),
                    Text(
                      switch (_tab) {
                        0 => NotebookTexts.phrasesIntro,
                        1 => NotebookTexts.cluesIntro,
                        _ => NotebookTexts.setsIntro,
                      },
                      key: const ValueKey('notebook-intro'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppPalette.ink500,
                      ),
                    ),
                    const SizedBox(height: AppSpace.s16),
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
    const pad = EdgeInsets.symmetric(horizontal: AppSpace.page);
    final empty = entries.value?.isEmpty ?? false;
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
          AppSpace.page,
          AppSpace.s12,
          AppSpace.page,
          0,
        ),
        sliver: SliverToBoxAdapter(child: _TopicNotes()),
      ),
      SliverPadding(
        padding: pad.copyWith(top: AppSpace.s24),
        sliver: SliverToBoxAdapter(
          child: Semantics(
            header: true,
            child: Text(
              NotebookTexts.listHeading(entries.value?.length ?? 0),
              key: const ValueKey('notebook-list-heading'),
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),
      ),
      // Boş defterde arama alanı yok: yerine illüstrasyonlu davet.
      if (!empty)
        SliverPadding(
          padding: pad.copyWith(top: AppSpace.s8),
          sliver: SliverToBoxAdapter(
            child: TextField(
              key: const ValueKey('notebook-search'),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: NotebookTexts.search,
              ),
              onChanged: (v) => setState(() => _query = lowerTr(v.trim())),
            ),
          ),
        ),
      if (_bookSources(entries.value ?? const []).isNotEmpty)
        SliverPadding(
          padding: pad.copyWith(top: AppSpace.s8),
          sliver: SliverToBoxAdapter(
            child: _SourceFilter(
              books: _bookSources(entries.value!),
              selected: _filter,
              onChanged: (v) => setState(() => _filter = v),
            ),
          ),
        ),
      switch (entries) {
        AsyncData(:final value) => _list(value),
        AsyncError() => const SliverToBoxAdapter(
          child: EmptyState(
            icon: Icons.error_outline_rounded,
            title: NotebookTexts.loadError,
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
      const SliverToBoxAdapter(child: SizedBox(height: AppSpace.s32)),
    ];
  }

  Widget _list(List<NotebookEntry> all) {
    PerfLog.markAfterFrame('Defter listesi hazır');
    if (all.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyState(
          key: ValueKey('notebook-empty'),
          illustration: Image(
            image: NotebookIllustrations.emptyNotebook,
            fit: BoxFit.contain,
          ),
          title: NotebookTexts.emptyTitle,
          message: NotebookTexts.emptyBody,
        ),
      );
    }
    final q = _query;
    final f = _filter;
    bool source(NotebookItem i) => switch (f) {
      null => true,
      'story' => i.source != NotebookSource.book,
      _ => i.source == NotebookSource.book && 'book:${i.contentId}' == f,
    };
    final list = [
      for (final e in all)
        if (source(e.item) &&
            (q.isEmpty ||
                lowerTr(e.item.textEn).contains(q) ||
                (e.item.textTr != null && lowerTr(e.item.textTr!).contains(q))))
          e,
    ];
    if (list.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyState(
          key: ValueKey('notebook-no-match'),
          icon: Icons.search_off_rounded,
          title: NotebookTexts.noMatch,
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s12,
        AppSpace.page,
        0,
      ),
      sliver: SliverList.separated(
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpace.s8),
        itemBuilder: (context, i) {
          final e = list[i];
          return StaggerOnce(
            id: e.item.key,
            index: i,
            seen: _seen,
            child: _EntryRow(
              entry: e,
              audio: _audio,
              onOpen: () => _openDetail(e),
              onRemove: isRemovable(e.item) ? () => _remove(e) : null,
            ),
          );
        },
      ),
    );
  }

  Future<void> _openDetail(NotebookEntry e) async {
    await showAppSheet<void>(
      context: context,
      builder: (context) => SingleChildScrollView(
        key: const ValueKey('card-detail'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardFace(item: e.item, player: _audio),
            const SizedBox(height: AppSpace.s16),
            InfoCard(
              icon: Icons.schedule_rounded,
              tone: InfoTone.info,
              title: _dueText(e.card),
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

  /// Defterdeki kitaplar (kimlik → başlık), ilk görülme sırasıyla.
  static Map<String, String> _bookSources(List<NotebookEntry> all) => {
    for (final e in all)
      if (e.item.source == NotebookSource.book && e.item.contentId != null)
        e.item.contentId!: e.item.sourceTitle ?? e.item.contentId!,
  };

  /// H-051: hikâye mekânlarına bağlı konu setleri.
  List<Widget> _sets() => const [
    SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppSpace.page),
      sliver: SliverToBoxAdapter(child: TopicSetsSection()),
    ),
    SliverToBoxAdapter(child: SizedBox(height: AppSpace.s32)),
  ];

  List<Widget> _clues(BuildContext context) {
    final board = ref.watch(clueBoardProvider);
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.page),
        sliver: SliverToBoxAdapter(
          child: switch (board) {
            AsyncData(:final value) => _ClueBoard(data: value, seen: _seen),
            AsyncError() => const EmptyState(
              icon: Icons.error_outline_rounded,
              title: NotebookTexts.cluesError,
            ),
            _ => const ListSkeleton(
              key: ValueKey('skeleton-clues'),
              label: NotebookTexts.cluesLoading,
              rows: 3,
              padding: EdgeInsets.only(top: AppSpace.s8),
            ),
          },
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: AppSpace.s32)),
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

/// "Kelime tekrarı" kartı (taslak S04 üst kart): ikon + etiket + sayı cümle
/// içinde (tahmini süreyle) + tam genişlik "Tekrara başla".
class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({required this.overview});

  final ReviewOverview? overview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final o = overview;
    final n = o?.sessionCount ?? 0;
    final due = o != null && n > 0;
    return TappableCard(
      key: const ValueKey('notebook-review-card'),
      elevated: due,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: AppSpace.s48,
                  height: AppSpace.s48,
                  decoration: BoxDecoration(
                    color: due ? AppPalette.yellow100 : AppPalette.seaBlue50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    due ? Icons.replay_rounded : Icons.check_rounded,
                    color: due ? AppPalette.orange700 : AppPalette.seaBlue,
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CapsLabel(
                      NotebookTexts.reviewHeading,
                      tone: CapsTone.blue,
                    ),
                    const SizedBox(height: AppSpace.s4),
                    Text(
                      o == null
                          ? NotebookTexts.reviewPreparing
                          : n > 0
                          ? NotebookTexts.reviewDue(
                              n,
                              HomeTexts.reviewMinutes(n),
                            )
                          : o.totalItems == 0
                          ? NotebookTexts.reviewEmpty
                          : NotebookTexts.reviewDoneToday,
                      key: const ValueKey('notebook-review-text'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppPalette.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (due) ...[
            const SizedBox(height: AppSpace.s8),
            Text(
              NotebookTexts.reviewHowTo,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.ink500,
              ),
            ),
            const SizedBox(height: AppSpace.s16),
            FilledButton.icon(
              key: const ValueKey('notebook-start-review'),
              onPressed: () => openReview(context, ref),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(NotebookTexts.reviewStart),
            ),
          ],
        ],
      ),
    );
  }
}

/// Kaynağa göre süzme çipleri (H-067): Hepsi · Hikâyeden · kitaplar.
class _SourceFilter extends StatelessWidget {
  const _SourceFilter({
    required this.books,
    required this.selected,
    required this.onChanged,
  });

  final Map<String, String> books;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget chip(String? value, String label, {IconData? icon}) => Padding(
      padding: const EdgeInsets.only(right: AppSpace.s8),
      child: ChoiceChip(
        key: ValueKey('notebook-filter-${value ?? 'all'}'),
        avatar: icon == null ? null : Icon(icon, size: AppIconSize.sm),
        label: Text(label),
        selected: selected == value,
        showCheckmark: false,
        onSelected: (_) => onChanged(value),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
    return Semantics(
      container: true,
      label: NotebookTexts.filterLabel,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            chip(null, NotebookTexts.filterAll),
            chip('story', NotebookTexts.filterStory),
            for (final b in books.entries)
              chip(
                'book:${b.key}',
                NotebookTexts.filterBook(b.value),
                icon: Icons.menu_book_rounded,
              ),
          ],
        ),
      ),
    );
  }
}

/// İfade satırı: [NotebookRow] + ses + (çıkarılabilirse) menü, değilse ok.
class _EntryRow extends StatelessWidget {
  const _EntryRow({
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
    return NotebookRow(
      tapKey: ValueKey('entry-${item.key}'),
      onTap: onOpen,
      leading: notebookLeading(item),
      title: item.textEn,
      subtitle: item.textTr,
      source: notebookSourceLine(item),
      trailing: [
        AudioButton(player: audio, item: item, size: AppIconSize.md),
        if (onRemove != null)
          PopupMenuButton<String>(
            key: ValueKey('entry-menu-${item.key}'),
            tooltip: NotebookTexts.options,
            onSelected: (_) => onRemove!(),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'remove', child: Text(NotebookTexts.remove)),
            ],
          )
        else
          const Padding(
            padding: EdgeInsets.only(right: AppSpace.s8),
            child: Icon(
              Icons.chevron_right_rounded,
              color: AppPalette.ink300,
              semanticLabel: NotebookTexts.openCard,
            ),
          ),
      ],
    );
  }
}

class _ClueBoard extends StatelessWidget {
  const _ClueBoard({required this.data, required this.seen});

  final ClueBoardData data;
  final Set<Object> seen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (data.isEmpty) {
      return const EmptyState(
        key: ValueKey('clues-empty'),
        illustration: Image(
          image: NotebookIllustrations.emptyClues,
          fit: BoxFit.contain,
        ),
        title: NotebookTexts.cluesEmptyTitle,
        message: NotebookTexts.cluesEmptyBody,
      );
    }
    final heading = theme.textTheme.titleMedium;
    var index = 0;
    Widget enter(Object id, Widget child) =>
        StaggerOnce(id: id, index: index++, seen: seen, child: child);
    return Column(
      key: const ValueKey('clue-board'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (data.openQuestions.isNotEmpty) ...[
          Semantics(
            header: true,
            child: Text(NotebookTexts.openQuestions, style: heading),
          ),
          const SizedBox(height: AppSpace.s8),
          for (final q in data.openQuestions) ...[
            enter('q-${q.id}', _OpenQuestionCard(question: q)),
            const SizedBox(height: AppSpace.s8),
          ],
          const SizedBox(height: AppSpace.s16),
        ],
        if (data.clues.isNotEmpty) ...[
          Semantics(
            header: true,
            child: Text(NotebookTexts.foundClues, style: heading),
          ),
          const SizedBox(height: AppSpace.s8),
          for (final e in data.clues.entries) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpace.s4,
                bottom: AppSpace.s8,
              ),
              child: CapsLabel(_episodeLabel(e.key), tone: CapsTone.blue),
            ),
            for (final c in e.value)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.s8),
                child: enter(
                  'c-${c.contentId}-${c.clueId}',
                  NotebookRow(
                    tapKey: ValueKey('clue-${c.contentId}-${c.clueId}'),
                    leading: const KindBadge(
                      icon: Icons.push_pin_rounded,
                      background: AppPalette.orange50,
                      color: AppPalette.orange700,
                    ),
                    title: c.textTr,
                  ),
                ),
              ),
            const SizedBox(height: AppSpace.s8),
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

/// Açık soru: deniz mavisi kart, sarı etiket.
class _OpenQuestionCard extends StatelessWidget {
  const _OpenQuestionCard({required this.question});

  final OpenQuestion question;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = question;
    return Container(
      key: ValueKey('open-question-${q.id}'),
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: const BoxDecoration(
        color: AppPalette.seaBlue,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.level1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExcludeSemantics(
            child: Icon(
              Icons.help_outline_rounded,
              color: AppPalette.lighthouseYellow,
            ),
          ),
          const SizedBox(width: AppSpace.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NotebookTexts.openQuestionLabel(q.openedNumber),
                  style: AppTypography.caps.copyWith(
                    color: AppPalette.lighthouseYellow,
                  ),
                ),
                const SizedBox(height: AppSpace.s4),
                Text(
                  q.textTr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppPalette.white,
                  ),
                ),
                if (q.partialNote != null) ...[
                  const SizedBox(height: AppSpace.s4),
                  Text(
                    NotebookTexts.partialNote(q.partialNote!),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppPalette.seaBlue100,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Hi'nin konu notları: bölümde görülen konu kartları (H-048).
class _TopicNotes extends ConsumerWidget {
  const _TopicNotes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final intros = ref.watch(seenTopicIntrosProvider).value;
    if (intros == null) return const SizedBox.shrink();
    return TappableCard(
      key: const ValueKey('notebook-topic-notes'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const KindBadge(icon: Icons.lightbulb_outline_rounded),
              const SizedBox(width: AppSpace.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HiTexts.topicNotesHeading,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppPalette.seaBlue,
                      ),
                    ),
                    Text(
                      intros.isEmpty
                          ? HiTexts.topicNotesEmpty
                          : HiTexts.topicNotesCount(intros.length),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppPalette.ink500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (intros.isNotEmpty) ...[
            const SizedBox(height: AppSpace.s8),
            Wrap(
              spacing: AppSpace.s8,
              runSpacing: AppSpace.s8,
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
    );
  }
}
