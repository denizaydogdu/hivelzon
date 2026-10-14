import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import '../../../notebook/application/notebook_providers.dart';
import '../../../notebook/domain/notebook_item.dart';
import '../../../notebook/presentation/widgets/notebook_row.dart';
import '../../domain/book.dart';

/// Bu kitaptan Defter'e eklenenler (en son eklenen önce).
final bookSavedItemsProvider = FutureProvider.autoDispose
    .family<List<NotebookItem>, String>((ref, bookId) async {
      final entries = await ref.watch(notebookStoreProvider).entries();
      return [
        for (final e in entries)
          if (e.item.source == NotebookSource.book &&
              e.item.contentId == bookId)
            e.item,
      ];
    }, retry: (_, _) => null);

/// Kitabın sonu (H-067): sakin kutlama ve "Bu kitapta kaydettiklerin".
/// Puan, lig, seri ya da geri sayım yok (K-32).
class EndOfBookView extends ConsumerWidget {
  const EndOfBookView({
    super.key,
    required this.book,
    required this.colors,
    required this.onBack,
    required this.onReadAgain,
    this.onNextBook,
  });

  final Book book;
  final BookColors colors;
  final VoidCallback onBack;
  final VoidCallback onReadAgain;

  /// Aynı seviyede açılmamış kitap varsa.
  final VoidCallback? onNextBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final saved = ref.watch(bookSavedItemsProvider(book.id));
    return SingleChildScrollView(
      key: const ValueKey('end-of-book'),
      padding: const EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s16,
        AppSpace.page,
        AppSpace.s32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: CalmCelebration(icon: Icons.auto_stories_rounded),
          ),
          const SizedBox(height: AppSpace.s16),
          Semantics(
            header: true,
            child: Text(
              ReaderTexts.endTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colors.text,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s8),
          Text(
            ReaderTexts.endBody(book.title),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: colors.text),
          ),
          const SizedBox(height: AppSpace.s24),
          Semantics(
            header: true,
            child: Text(
              ReaderTexts.savedHeading,
              style: theme.textTheme.titleMedium?.copyWith(color: colors.text),
            ),
          ),
          const SizedBox(height: AppSpace.s8),
          switch (saved) {
            AsyncData(:final value) when value.isEmpty => InfoCard(
              key: const ValueKey('end-saved-empty'),
              icon: Icons.bookmark_add_outlined,
              title: ReaderTexts.savedEmpty,
            ),
            AsyncData(:final value) => Column(
              key: const ValueKey('end-saved-list'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, item) in value.indexed) ...[
                  if (i > 0) const SizedBox(height: AppSpace.s8),
                  NotebookRow(
                    leading: notebookLeading(item),
                    title: item.textEn,
                    subtitle: item.textTr,
                    source: notebookSourceLine(item),
                  ),
                ],
                const SizedBox(height: AppSpace.s8),
                Text(
                  ReaderTexts.savedReviewNote,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.text,
                  ),
                ),
              ],
            ),
            _ => const SizedBox(height: AppSpace.s48),
          },
          const SizedBox(height: AppSpace.s24),
          if (onNextBook != null) ...[
            FilledButton.icon(
              key: const ValueKey('end-next-book'),
              onPressed: onNextBook,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              icon: const Icon(Icons.headphones_rounded),
              label: const Text(ReaderTexts.nextBook),
            ),
            const SizedBox(height: AppSpace.s12),
          ],
          OutlinedButton.icon(
            key: const ValueKey('end-back'),
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.min),
            ),
            icon: const Icon(Icons.auto_stories_outlined),
            label: const Text(ReaderTexts.backToLibrary),
          ),
          const SizedBox(height: AppSpace.s8),
          TextButton(
            key: const ValueKey('end-read-again'),
            onPressed: onReadAgain,
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.min),
            ),
            child: const Text(ReaderTexts.readAgain),
          ),
        ],
      ),
    );
  }
}
