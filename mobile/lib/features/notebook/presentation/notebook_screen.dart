import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../shared/content/content_providers.dart';
import '../../player/presentation/player_screen.dart';
import '../application/card_audio_player.dart';
import '../application/notebook_providers.dart';
import '../domain/notebook_item.dart';
import '../domain/review_session.dart';
import 'widgets/card_face.dart';

/// Kart sesi çalar (ekran başına bir tane; testlerde sahte video platformu).
CardAudioPlayer createCardAudio(WidgetRef ref) {
  final source = ref.read(contentSourceProvider);
  return CardAudioPlayer(
    uriFor: source.mediaUri,
    factory: ref.read(videoControllerFactoryProvider),
  );
}

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
      body: SafeArea(
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
                  Row(
                    children: [
                      if (context.canPop())
                        IconButton(
                          tooltip: 'Geri',
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PROFİL',
                              style: theme.textTheme.labelMedium?.copyWith(
                                letterSpacing: 1.4,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink.withValues(alpha: 0.7),
                              ),
                            ),
                            Semantics(
                              header: true,
                              child: Text(
                                'Defter',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<int>(
                    key: const ValueKey('notebook-tabs'),
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      selectedBackgroundColor: AppColors.seaBlue,
                      selectedForegroundColor: Colors.white,
                    ),
                    segments: const [
                      ButtonSegment(value: 0, label: Text('İfadeler')),
                      ButtonSegment(value: 1, label: Text('İpucu panosu')),
                    ],
                    selected: {_tab},
                    onSelectionChanged: (s) => setState(() => _tab = s.first),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
            if (_tab == 0) ..._phrases(context) else ..._clues(context),
          ],
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
      SliverPadding(
        padding: pad.copyWith(top: AppSpacing.md),
        sliver: SliverToBoxAdapter(
          child: Text(
            'Topladığım ifadeler',
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
              hintText: 'İfade ya da Türkçesi ara',
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          ),
        ),
      ),
      switch (entries) {
        AsyncData(:final value) => _list(value),
        AsyncError() => const SliverToBoxAdapter(
          child: _Message(
            icon: Icons.error_outline_rounded,
            text: 'Defter açılamadı. Uygulamayı yeniden başlatmayı dene.',
          ),
        ),
        _ => const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      },
      const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
    ];
  }

  Widget _list(List<NotebookEntry> all) {
    if (all.isEmpty) {
      return const SliverToBoxAdapter(
        child: _Message(
          icon: Icons.menu_book_outlined,
          text:
              'Defterin henüz boş. Bir bölümü bitirince hedef ifadeler buraya '
              'gelir. Altyazıda bir kelimeye dokunup "Deftere ekle" de '
              'diyebilirsin.',
        ),
      );
    }
    final q = _query;
    final list = q.isEmpty
        ? all
        : [
            for (final e in all)
              if (e.item.textEn.toLowerCase().contains(q) ||
                  (e.item.textTr?.toLowerCase().contains(q) ?? false))
                e,
          ];
    if (list.isEmpty) {
      return const SliverToBoxAdapter(
        child: _Message(
          icon: Icons.search_off_rounded,
          text: 'Eşleşen ifade yok.',
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
          onRemove: list[i].item.source == NotebookSource.userSaved
              ? () => _remove(list[i])
              : null,
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
                tooltip: 'Kapat',
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
        SnackBar(content: Text('"${e.item.textEn}" defterden çıkarıldı.')),
      );
    }
  }

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
              text: 'İpucu panosu açılamadı.',
            ),
            _ => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
          },
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
    ];
  }
}

String _dueText(ReviewCardState c) {
  if (c.isNew) return 'Yeni kart: ilk tekrarını bekliyor.';
  final now = DateTime.now().toUtc();
  if (!c.fsrs.due.isAfter(now)) return 'Tekrar zamanı geldi.';
  final local = c.fsrs.due.toLocal();
  final today = DateTime.now();
  final days = DateTime(
    local.year,
    local.month,
    local.day,
  ).difference(DateTime(today.year, today.month, today.day)).inDays;
  if (days <= 0) return 'Bugün yeniden gelecek.';
  if (days == 1) return 'Yarın yeniden gelecek.';
  return '$days gün sonra yeniden gelecek.';
}

/// Tekrar girişi (T5 üst kart).
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
              'TEKRAR',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.seaBlue,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              o == null
                  ? 'Kartlar hazırlanıyor…'
                  : n > 0
                  ? '$n kart seni bekliyor.'
                  : o.totalItems == 0
                  ? 'Bölüm bitirdikçe kartların burada birikir.'
                  : 'Bugünlük tekrar bitti. Kartlar zamanı gelince geri gelir.',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (o != null && n > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Resme bak, dinle, seç. Bilmediğin kart sorun değil: '
                'oturumun sonunda yeniden gelir.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                key: const ValueKey('notebook-start-review'),
                onPressed: () => openReview(context, ref),
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Tekrara başla'),
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
                          fontWeight: FontWeight.w600,
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
                    tooltip: 'Seçenekler',
                    onSelected: (_) => onRemove!(),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'remove',
                        child: Text('Defterden çıkar'),
                      ),
                    ],
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.ink,
                    semanticLabel: 'Kartı aç',
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
        text:
            'Henüz ipucu yok. Bölüm sonunda bulduğun ipuçları ve açık sorular '
            'burada toplanır.',
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
          Text('Açık sorular', style: heading),
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
                      'AÇIK SORU · BÖLÜM ${q.openedNumber}',
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (q.partialNote != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Şimdilik bildiğin: ${q.partialNote}',
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
          Text('Bulduğun ipuçları', style: heading),
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
    return m == null ? contentId : 'BÖLÜM ${int.parse(m.group(1)!)}';
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
