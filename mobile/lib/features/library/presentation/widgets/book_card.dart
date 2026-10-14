import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/content/content_providers.dart';
import '../../../../shared/ui/ui.dart';
import '../../domain/book.dart';
import '../../domain/book_progress.dart';

/// Kitap kartı (H-067): kapak, tür, süre, seviye ve ilerleme halkası.
class BookCard extends ConsumerWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.progress,
  });

  final BookSummary book;
  final BookProgress? progress;
  final VoidCallback onTap;

  static const double width = 136;
  static const double coverAspect = 3 / 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final p = progress;
    final done = p?.isCompleted ?? false;
    final reading = p?.isInProgress ?? false;
    final pct = reading ? (p!.fraction(book.pageCount) * 100).round() : null;
    final genre = book.genre == null
        ? null
        : LibraryTexts.genre(book.genre!.code);
    return SizedBox(
      width: width,
      child: Semantics(
        button: true,
        container: true,
        excludeSemantics: true,
        label: LibraryTexts.cardSemantics(
          title: book.title,
          level: book.level,
          genre: genre,
          minutes: book.estimatedMinutes,
          percent: pct,
          done: done,
        ),
        onTap: onTap,
        child: PressScale(
          child: Material(
            color: AppPalette.white,
            borderRadius: AppRadius.mdAll,
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            child: InkWell(
              key: ValueKey('book-card-${book.id}'),
              onTap: onTap,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: AppRadius.mdAll,
                  border: Border.fromBorderSide(
                    BorderSide(color: AppPalette.sand200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: coverAspect,
                          child: _Cover(book: book),
                        ),
                        Positioned(
                          left: AppSpace.s8,
                          top: AppSpace.s8,
                          child: _LevelBadge(level: book.level),
                        ),
                        if (reading || done)
                          Positioned(
                            right: AppSpace.s4,
                            bottom: AppSpace.s4,
                            child: _ProgressBadge(percent: pct, done: done),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpace.s8,
                        AppSpace.s8,
                        AppSpace.s8,
                        AppSpace.s12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppPalette.ink,
                            ),
                          ),
                          const SizedBox(height: AppSpace.s4),
                          Text(
                            [
                              ?genre,
                              if (book.estimatedMinutes != null)
                                LibraryTexts.minutes(book.estimatedMinutes!),
                            ].join(' · '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppPalette.ink500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Cover extends ConsumerWidget {
  const _Cover({required this.book});

  final BookSummary book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallback = BookCoverPlaceholder(title: book.title, level: book.level);
    final cover = book.cover;
    if (cover == null) return fallback;
    return Image.network(
      ref.watch(contentSourceProvider).bookMediaUri(book.id, cover).toString(),
      fit: BoxFit.cover,
      cacheWidth: 408,
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, sync) =>
          frame == null && !sync ? fallback : child,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

/// Kapak yokken ya da yüklenirken: seviyeye göre sakin renkli yüzey ve
/// kitap ikonu (başlık kartın altında yazılı; burada tekrar edilmez).
class BookCoverPlaceholder extends StatelessWidget {
  const BookCoverPlaceholder({
    super.key,
    required this.title,
    required this.level,
  });

  final String title;
  final String level;

  static const _tones = [
    (AppPalette.seaBlue100, AppPalette.seaBlue),
    (AppPalette.yellow100, AppPalette.orange700),
    (AppPalette.orange50, AppPalette.orange700),
    (AppPalette.successSurface, AppPalette.success),
    (AppPalette.sand200, AppPalette.ink700),
    (AppPalette.seaBlue50, AppPalette.seaBlue700),
  ];

  @override
  Widget build(BuildContext context) {
    final i = kBookLevels.indexOf(level);
    final (bg, fg) = _tones[(i < 0 ? 0 : i) % _tones.length];
    return ColoredBox(
      color: bg,
      child: Center(
        child: Icon(
          Icons.auto_stories_rounded,
          color: fg,
          size: AppIconSize.xl,
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpace.s8,
      vertical: AppSpace.s4 / 2,
    ),
    decoration: BoxDecoration(
      color: AppPalette.seaBlue,
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Text(
      level,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppPalette.white,
        fontWeight: AppFonts.bold,
      ),
    ),
  );
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.percent, required this.done});

  final int? percent;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpace.s4),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        shape: BoxShape.circle,
        boxShadow: AppShadows.level1,
      ),
      child: done
          ? const SizedBox.square(
              dimension: AppSpace.s32 + AppSpace.s8,
              child: Icon(
                Icons.check_rounded,
                color: AppPalette.success,
                size: AppIconSize.md,
              ),
            )
          : ProgressRing(
              value: (percent ?? 0) / 100,
              semanticLabel: LibraryTexts.shelfContinue,
              size: AppSpace.s32 + AppSpace.s8,
              strokeWidth: AppSpace.s4,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.s4),
                  child: Text(
                    LibraryTexts.percent(percent ?? 0),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
