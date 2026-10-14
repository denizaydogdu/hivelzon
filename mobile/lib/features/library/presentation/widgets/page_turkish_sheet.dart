import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import '../../application/reader_controller.dart';
import '../../domain/book.dart';

/// "Sayfanın Türkçesi" paneli (H-086): sayfanın onaylı Türkçesi cümle
/// cümle, sırasıyla (bölümün ilk sayfasında başlık önce). Okunan / seçili
/// cümle hafif vurgulu. Bir cümleye dokununca panel kapanır ve cümlenin
/// sırası döner (−1: başlık); ekran İngilizcesini vurgular. Kapat: null.
Future<int?> showPageTurkishSheet(
  BuildContext context, {
  required Book book,
  required int pageIndex,
  ReaderPlace? current,
}) => showAppSheet<int>(
  context: context,
  title: ReaderTexts.pageTurkish,
  builder: (context) => PageTurkishList(
    book: book,
    pageIndex: pageIndex,
    current: current?.pageIndex == pageIndex ? current!.sentenceIndex : null,
    onPick: (i) => Navigator.of(context).pop(i),
  ),
);

/// Panelin içeriği: kısa açıklama ve dokunulabilir Türkçe cümleler.
class PageTurkishList extends StatelessWidget {
  const PageTurkishList({
    super.key,
    required this.book,
    required this.pageIndex,
    required this.onPick,
    this.current,
  });

  final Book book;
  final int pageIndex;

  /// Sayfada vurgulu olan cümle; yoksa null.
  final int? current;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = book.turkishOf(pageIndex);
    return ListView(
      key: const ValueKey('page-turkish'),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.s8),
          child: Text(
            ReaderTexts.pageTurkishHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppPalette.ink700,
            ),
          ),
        ),
        for (final (i, tr) in lines)
          Semantics(
            button: true,
            selected: current == i,
            hint: ReaderTexts.pageTurkishItemHint,
            child: Material(
              color: current == i ? AppPalette.yellow100 : Colors.transparent,
              borderRadius: AppRadius.mdAll,
              child: InkWell(
                key: ValueKey('page-tr-$i'),
                borderRadius: AppRadius.mdAll,
                onTap: () => onPick(i),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: AppTouch.min),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpace.s8,
                      vertical: AppSpace.s8,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        tr,
                        style: i < 0
                            ? theme.textTheme.titleMedium
                            : theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
