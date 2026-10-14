import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/content/content_providers.dart';
import '../../application/reader_controller.dart';
import '../../domain/book.dart';

/// Kelime ya da cümleye dokunma / uzun basma (cümle yeri + kelime sırası;
/// cümleye bütün olarak dokunulduysa kelime null).
typedef WordAction = void Function(ReaderPlace place, int? wordIndex);

/// Renkli, resimli kitap sayfası (H-067): üstte resim, altta metin. Okunan
/// cümlenin zemini vurgulanır; kelime vurgusu açıksa okunan kelimenin altı
/// çizilir (yerleşim kaymaz).
///
/// Kelimeler dokunulabilir (`WidgetSpan`): dokununca anlam paneli, uzun
/// basınca [onWordLongPress]. Ekran okuyucu açıkken metin cümle cümle
/// düğme olarak çizilir (her cümle ayrı okunur; dokununca anlam paneli).
class BookPageView extends ConsumerWidget {
  const BookPageView({
    super.key,
    required this.book,
    required this.pageIndex,
    required this.colors,
    required this.textSize,
    required this.onWordTap,
    required this.onWordLongPress,
    this.highlighted,
    this.highlightedWord,
  });

  final Book book;
  final int pageIndex;
  final BookColors colors;
  final int textSize;
  final ReaderPlace? highlighted;
  final int? highlightedWord;
  final WordAction onWordTap;
  final WordAction onWordLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = book.pages[pageIndex];
    final chapter = book.chapterOf(page);
    final accessible = MediaQuery.accessibleNavigationOf(context);
    final body = AppTypography.reading(textSize).copyWith(color: colors.text);
    final heading = AppTypography.readingHeading(
      textSize,
    ).copyWith(color: colors.text);
    Widget sentences(List<(BookSentence, int)> list, TextStyle style) =>
        accessible
        ? _AccessibleParagraph(
            sentences: list,
            pageIndex: pageIndex,
            style: style,
            colors: colors,
            highlighted: highlighted,
            onTap: onWordTap,
          )
        : _Paragraph(
            sentences: list,
            pageIndex: pageIndex,
            style: style,
            colors: colors,
            highlighted: highlighted,
            highlightedWord: highlightedWord,
            onWordTap: onWordTap,
            onWordLongPress: onWordLongPress,
          );
    final paragraphs = <List<(BookSentence, int)>>[];
    int? last;
    for (final (i, s) in page.sentences.indexed) {
      if (paragraphs.isEmpty || s.paragraph != last) paragraphs.add([]);
      paragraphs.last.add((s, i));
      last = s.paragraph;
    }
    final image = page.image;
    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        key: ValueKey('book-page-${page.id}'),
        padding: const EdgeInsets.fromLTRB(
          AppSpace.s24,
          AppSpace.s8,
          AppSpace.s24,
          AppSpace.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (image != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.s16),
                child: ClipRRect(
                  borderRadius: AppRadius.lgAll,
                  child: SizedBox(
                    height: (c.maxHeight * 0.38).clamp(120.0, 360.0),
                    child: _PageImage(
                      uri: ref
                          .watch(contentSourceProvider)
                          .bookMediaUri(book.id, image),
                      colors: colors,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.s16),
                child: ExcludeSemantics(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: AppSpace.s48,
                      height: AppSpace.s4,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ),
                ),
              ),
            if (book.isChapterStart(pageIndex)) ...[
              Text(
                ReaderTexts.chapterLabel(book.chapterIndexOf(chapter.id) + 1),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.accent,
                  fontWeight: AppFonts.bold,
                ),
              ),
              const SizedBox(height: AppSpace.s4),
              Semantics(
                header: true,
                child: sentences([(chapter.heading, -1)], heading),
              ),
              const SizedBox(height: AppSpace.s16),
            ],
            for (final (i, p) in paragraphs.indexed) ...[
              if (i > 0) const SizedBox(height: AppSpace.s16),
              sentences(p, body),
            ],
          ],
        ),
      ),
    );
  }
}

class _PageImage extends StatelessWidget {
  const _PageImage({required this.uri, required this.colors});

  final Uri uri;
  final BookColors colors;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: colors.surface,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: colors.accent,
          size: AppIconSize.xl,
        ),
      ),
    );
    return Image.network(
      uri.toString(),
      fit: BoxFit.cover,
      width: double.infinity,
      cacheWidth: 1080,
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, sync) =>
          frame == null && !sync ? placeholder : child,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

/// Bir paragraf: kelimeler dokunulabilir; ekran okuyucu paragrafı tek
/// metin olarak okur.
class _Paragraph extends StatelessWidget {
  const _Paragraph({
    required this.sentences,
    required this.pageIndex,
    required this.style,
    required this.colors,
    required this.highlighted,
    required this.highlightedWord,
    required this.onWordTap,
    required this.onWordLongPress,
  });

  final List<(BookSentence, int)> sentences;
  final int pageIndex;
  final TextStyle style;
  final BookColors colors;
  final ReaderPlace? highlighted;
  final int? highlightedWord;
  final WordAction onWordTap;
  final WordAction onWordLongPress;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    for (final (k, (s, index)) in sentences.indexed) {
      final place = ReaderPlace(pageIndex, index);
      final on = highlighted == place;
      final bg = on ? colors.highlight : null;
      if (k > 0) spans.add(TextSpan(text: ' ', style: style));
      for (final (i, w) in s.words.indexed) {
        if (i > 0) {
          spans.add(
            TextSpan(
              text: ' ',
              style: style.copyWith(backgroundColor: bg),
            ),
          );
        }
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: BookWordView(
              key: ValueKey('w-${s.id}-$i'),
              text: w.w,
              style: style,
              background: bg,
              underline: on && highlightedWord == i ? colors.accent : null,
              highlighted: on,
              onTap: () => onWordTap(place, i),
              onLongPress: () => onWordLongPress(place, i),
            ),
          ),
        );
      }
    }
    return Semantics(
      container: true,
      label: sentences.map((e) => e.$1.text).join(' '),
      child: ExcludeSemantics(child: Text.rich(TextSpan(children: spans))),
    );
  }
}

/// Tek kelime (dokunma hedefi). [highlighted]: okunan cümlede mi.
class BookWordView extends StatelessWidget {
  const BookWordView({
    super.key,
    required this.text,
    required this.style,
    required this.highlighted,
    required this.onTap,
    required this.onLongPress,
    this.background,
    this.underline,
  });

  final String text;
  final TextStyle style;
  final bool highlighted;
  final Color? background;

  /// Okunan kelimenin alt çizgisi (kelime vurgusu açıkken).
  final Color? underline;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Text(
        text,
        style: style.copyWith(
          backgroundColor: background,
          decoration: underline == null ? null : TextDecoration.underline,
          decorationColor: underline,
          decorationThickness: 2.5,
        ),
      ),
    );
  }
}

/// Ekran okuyucu açıkken: her cümle ayrı düğme (dokun: anlam paneli,
/// uzun bas: kelime yok, cümle seslendirilir ya da sesli modda eklenmez).
class _AccessibleParagraph extends StatelessWidget {
  const _AccessibleParagraph({
    required this.sentences,
    required this.pageIndex,
    required this.style,
    required this.colors,
    required this.highlighted,
    required this.onTap,
  });

  final List<(BookSentence, int)> sentences;
  final int pageIndex;
  final TextStyle style;
  final BookColors colors;
  final ReaderPlace? highlighted;
  final WordAction onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (s, index) in sentences)
          Semantics(
            button: true,
            hint: ReaderTexts.sentenceHint,
            child: InkWell(
              key: ValueKey('s-${s.id}'),
              onTap: () => onTap(ReaderPlace(pageIndex, index), null),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppTouch.min),
                child: Container(
                  color: highlighted == ReaderPlace(pageIndex, index)
                      ? colors.highlight
                      : null,
                  alignment: Alignment.centerLeft,
                  child: Text(s.text, style: style),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
