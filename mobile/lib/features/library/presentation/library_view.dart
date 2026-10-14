import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../grammar/application/grammar_providers.dart';
import '../../grammar/domain/grammar_progress.dart';
import '../../grammar/presentation/grammar_lesson_screen.dart';
import '../../grammar/presentation/grammar_view.dart';
import '../../hi/application/hi_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../application/library_providers.dart';
import '../domain/book.dart';
import '../domain/book_progress.dart';
import 'widgets/book_card.dart';
import '../../hi/presentation/hi_bubble.dart';

/// Kitabı açar; dönünce Kitaplık, Hi ve Defter yenilenir.
Future<void> openBook(
  BuildContext context,
  WidgetRef ref,
  String bookId, {
  bool listen = false,
}) async {
  await context.push(AppRoutes.book(bookId, listen: listen));
  if (!context.mounted) return;
  refreshLibrary(ref);
  refreshHi(ref);
  refreshNotebook(ref);
}

/// Kitaplık (H-067; Hikâye sekmesinde "Kitaplık"): "Bana bir kitap oku",
/// raflar (Okumaya devam et · Senin seviyen · öteki seviyeler ·
/// Okuduklarım), sakin boş / yükleniyor / hata durumları.
class LibraryView extends ConsumerWidget {
  const LibraryView({super.key, this.header});

  /// Sayfanın üst kısmı (başlık ve bölüm seçici); kaydırmayla birlikte gider.
  final Widget? header;

  static const errorImage = AssetImage(
    'assets/illustrations/baglanti-yok.webp',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(libraryProvider);
    // Kitap açma panelindeki dilbilgisi teklifi hazır olsun (H-078).
    ref.watch(bookGrammarOffersProvider);
    // Hi balonunun payı yalnızca listenin sonunda (H-064).
    final bottom =
        MediaQuery.paddingOf(context).bottom + HiBubbleInset.of(context);
    final children = <Widget>[
      ?header,
      // Yenilenirken eski veri kalır (iskelete dönüp zıplamaz).
      switch (data) {
        AsyncValue(:final value?) when value.books.isEmpty => const Padding(
          padding: EdgeInsets.only(top: AppSpace.s24),
          child: EmptyState(
            key: ValueKey('library-empty'),
            icon: Icons.auto_stories_outlined,
            title: LibraryTexts.emptyTitle,
            message: LibraryTexts.emptyBody,
          ),
        ),
        AsyncValue(:final value?) => _Shelves(data: value),
        AsyncError() => Padding(
          padding: const EdgeInsets.only(top: AppSpace.s24),
          child: EmptyState(
            key: const ValueKey('library-error'),
            illustration: const Image(image: errorImage, fit: BoxFit.contain),
            title: CommonTexts.serverDownTitle,
            message: kDebugMode
                ? '${LibraryTexts.loadError} ${CommonTexts.serverDownBody}\n\n'
                      '${CommonTexts.devServerHint}'
                : '${LibraryTexts.loadError} ${CommonTexts.serverDownBody}',
            action: FilledButton.icon(
              key: const ValueKey('library-retry'),
              onPressed: () => refreshLibraryAll(ref),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(CommonTexts.retry),
            ),
          ),
        ),
        _ => const ListSkeleton(
          key: ValueKey('skeleton-library'),
          label: LibraryTexts.loading,
          rows: 3,
          padding: EdgeInsets.only(top: AppSpace.s16),
        ),
      },
    ];
    return ListView(
      key: const ValueKey('library-view'),
      padding: EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s8,
        AppSpace.page,
        AppSpace.s32 + bottom,
      ),
      children: children,
    );
  }
}

/// Liste ve ilerleme birlikte yeniden okunur ("Tekrar dene").
void refreshLibraryAll(WidgetRef ref) {
  ref.invalidate(bookListProvider);
  refreshLibrary(ref);
}

class _Shelves extends ConsumerWidget {
  const _Shelves({required this.data});

  final LibraryData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = data.shelves;
    final p = data.progress;
    void open(BookSummary b) {
      final offer = ref.read(bookGrammarOffersProvider).value?[b.id];
      if (offer == null) {
        openBook(context, ref, b.id);
      } else {
        showBookOpenSheet(context, ref, b, offer);
      }
    }

    return StaggeredList(
      spacing: AppSpace.s24,
      children: [
        _ReadToMeCard(data: data),
        if (s.continueReading.isNotEmpty)
          _Shelf(
            id: 'continue',
            title: LibraryTexts.shelfContinue,
            books: s.continueReading,
            progress: p,
            onOpen: open,
          ),
        if (s.userLevelBooks.isNotEmpty)
          _Shelf(
            id: 'mine',
            title: LibraryTexts.shelfMine(s.userLevel),
            books: s.userLevelBooks,
            progress: p,
            onOpen: open,
          ),
        for (final (level, books) in s.otherLevels)
          _Shelf(
            id: 'level-$level',
            title: LibraryTexts.shelfLevel(level),
            books: books,
            progress: p,
            onOpen: open,
          ),
        if (s.finished.isNotEmpty)
          _Shelf(
            id: 'finished',
            title: LibraryTexts.shelfFinished,
            books: s.finished,
            progress: p,
            onOpen: open,
          ),
      ],
    );
  }
}

class _Shelf extends StatelessWidget {
  const _Shelf({
    required this.id,
    required this.title,
    required this.books,
    required this.progress,
    required this.onOpen,
  });

  final String id;
  final String title;
  final List<BookSummary> books;
  final Map<String, BookProgress> progress;
  final ValueChanged<BookSummary> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('shelf-$id'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(title),
        const SizedBox(height: AppSpace.s8),
        // Yatay raf: yükseklik en uzun kartınki (yazı büyütmede taşmaz).
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, b) in books.indexed) ...[
                if (i > 0) const SizedBox(width: AppSpace.s12),
                BookCard(
                  book: b,
                  progress: progress[b.id],
                  onTap: () => onOpen(b),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// "Bana bir kitap oku": seviye seç → okunmamış kitap sesli açılır.
class _ReadToMeCard extends ConsumerWidget {
  const _ReadToMeCard({required this.data});

  final LibraryData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('read-to-me-card'),
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: const BoxDecoration(
        color: AppPalette.seaBlue,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const ExcludeSemantics(
                child: Icon(
                  Icons.headphones_rounded,
                  color: AppPalette.lighthouseYellow,
                  size: AppIconSize.lg,
                ),
              ),
              const SizedBox(width: AppSpace.s12),
              Expanded(
                child: Text(
                  LibraryTexts.readToMeHint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.s12),
          FilledButton.icon(
            key: const ValueKey('read-to-me'),
            onPressed: () => showReadToMeSheet(context, ref, data),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.primary),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text(LibraryTexts.readToMe),
          ),
        ],
      ),
    );
  }
}

/// Seviye seçici; seçilen seviyede okunmamış kitap varsa sesli açar.
Future<void> showReadToMeSheet(
  BuildContext context,
  WidgetRef ref,
  LibraryData data,
) async {
  final levels = levelsWithBooks(data.books);
  if (levels.isEmpty) return;
  final suggested = data.shelves.userLevel;
  final initial = levels.contains(suggested) ? suggested : levels.first;
  final picked = await showAppSheet<String>(
    context: context,
    title: LibraryTexts.pickLevel,
    builder: (context) => SingleChildScrollView(
      child: _LevelPicker(
        levels: levels,
        initial: initial,
        suggested: suggested,
        data: data,
      ),
    ),
  );
  if (picked == null || !context.mounted) return;
  await openBook(context, ref, picked, listen: true);
}

class _LevelPicker extends ConsumerStatefulWidget {
  const _LevelPicker({
    required this.levels,
    required this.initial,
    required this.suggested,
    required this.data,
  });

  final List<String> levels;
  final String initial;
  final String suggested;
  final LibraryData data;

  @override
  ConsumerState<_LevelPicker> createState() => _LevelPickerState();
}

class _LevelPickerState extends ConsumerState<_LevelPicker> {
  late String _level = widget.initial;
  bool _none = false;

  void _open() {
    final b = pickUnreadBook(
      widget.data.books,
      widget.data.progress,
      _level,
      ref.read(libraryRandomProvider),
      preferAudio: true,
    );
    if (b == null) {
      setState(() => _none = true);
      return;
    }
    Navigator.of(context).pop(b.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      key: const ValueKey('level-picker'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LibraryTexts.suggested(widget.suggested),
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink500),
        ),
        const SizedBox(height: AppSpace.s12),
        Wrap(
          spacing: AppSpace.s8,
          runSpacing: AppSpace.s8,
          children: [
            for (final l in widget.levels)
              ChoiceChip(
                key: ValueKey('level-$l'),
                label: Text(l),
                selected: _level == l,
                showCheckmark: false,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onSelected: (_) => setState(() {
                  _level = l;
                  _none = false;
                }),
              ),
          ],
        ),
        if (_none) ...[
          const SizedBox(height: AppSpace.s16),
          const InfoCard(
            key: ValueKey('no-unread'),
            tone: InfoTone.info,
            title: LibraryTexts.noUnreadTitle,
            body: LibraryTexts.noUnreadBody,
          ),
        ],
        const SizedBox(height: AppSpace.s16),
        FilledButton.icon(
          key: const ValueKey('open-random-book'),
          onPressed: _open,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTouch.primary),
          ),
          icon: const Icon(Icons.headphones_rounded),
          label: const Text(LibraryTexts.openRandom),
        ),
      ],
    );
  }
}

/// Kitap açma paneli (H-078): yalnız kitapta dilbilgisi dersi varsa açılır.
/// "Kitabı aç" (ana düğme) ve ikincil "Bu kitaptaki dilbilgisi (~N dk)".
/// Dersler bitince "Kitabı aç" seçilirse kitap bugünkü gibi açılır.
Future<void> showBookOpenSheet(
  BuildContext context,
  WidgetRef ref,
  BookSummary book,
  GrammarOffer offer,
) async {
  final choice = await showAppSheet<String>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return SingleChildScrollView(
        key: const ValueKey('book-open-sheet'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: CapsLabel(
                [
                  book.level,
                  if (book.genre != null) LibraryTexts.genre(book.genre!.code),
                ].join(' · '),
              ),
            ),
            const SizedBox(height: AppSpace.s8),
            Semantics(
              header: true,
              child: Text(book.title, style: theme.textTheme.headlineSmall),
            ),
            if (book.titleTr != null)
              Text(
                book.titleTr!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppPalette.ink700,
                ),
              ),
            const SizedBox(height: AppSpace.s24),
            FilledButton.icon(
              key: const ValueKey('book-sheet-open'),
              onPressed: () => Navigator.of(context).pop('open'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              icon: const Icon(Icons.menu_book_rounded),
              label: const Text(GrammarTexts.openBookNow),
            ),
            const SizedBox(height: AppSpace.s16),
            GrammarOfferButton(
              offer: offer,
              label: GrammarTexts.bookOffer(offer.minutes),
              onPressed: () => Navigator.of(context).pop('grammar'),
            ),
          ],
        ),
      );
    },
  );
  if (!context.mounted || choice == null) return;
  if (choice == 'open') {
    await openBook(context, ref, book.id);
    return;
  }
  final go = await playGrammarLessons(
    context,
    ref,
    offer.ids,
    then: GrammarContinue.book,
  );
  if (go && context.mounted) await openBook(context, ref, book.id);
}
