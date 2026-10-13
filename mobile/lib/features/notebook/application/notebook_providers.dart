import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/content/content_providers.dart';
import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/storage/storage_providers.dart';
import '../../hi/application/hi_providers.dart';
import '../../player/data/progress_repository.dart';
import '../data/notebook_store.dart';
import '../domain/clue_board.dart';
import '../domain/notebook_item.dart';
import '../domain/review_policy.dart';
import '../domain/review_session.dart';
import 'deck_sync.dart';

final notebookStoreProvider = Provider<NotebookStore>(
  (ref) => NotebookStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

final deckSyncProvider = Provider<DeckSync>((ref) {
  final events = ref.watch(learningEventLogProvider);
  return DeckSync(
    store: ref.watch(notebookStoreProvider),
    source: ref.watch(contentSourceProvider),
    progress: ref.watch(progressRepositoryProvider),
    lookups: (id) async => [
      for (final e in await events.recent())
        if (e.contentId == id && e.errorType == null) e,
    ],
  );
});

/// Yerel günün başı ve sonu (UTC). Günlük yeni kart sınırı yerel güne göredir.
(DateTime, DateTime) localDayBounds(DateTime nowUtc, {int addDays = 0}) {
  final l = nowUtc.toLocal();
  final start = DateTime(l.year, l.month, l.day + addDays);
  final end = DateTime(l.year, l.month, l.day + addDays + 1);
  return (start.toUtc(), end.toUtc());
}

/// Ana Sayfa "Tekrar (n)", Defter ve Hi-A için özet. Hata uygulamayı
/// durdurmaz: sayılar sıfır görünür, giriş gizlenir.
final reviewOverviewProvider = FutureProvider.autoDispose<ReviewOverview>((
  ref,
) async {
  try {
    final store = ref.watch(notebookStoreProvider);
    try {
      await ref.watch(deckSyncProvider).syncCompleted();
    } on Object catch (e) {
      debugPrint('[H036] defter eşitlenemedi: $e');
    }
    final now = store.now();
    final (from, to) = localDayBounds(now);
    final goal = await store.dailyGoalMinutes();
    return computeOverview(
      await store.entries(),
      now: now,
      newIntroducedToday: await store.newIntroducedBetween(from, to),
      newPerDay: ReviewPolicy.newCardsPerDay(goal),
    );
  } on Object catch (e) {
    debugPrint('[H036] tekrar özeti okunamadı: $e');
    return ReviewOverview.empty;
  }
}, retry: (_, _) => null);

/// Defter listesi (önce eşitleme: biten bölümlerin ifadeleri gelsin).
final notebookEntriesProvider = FutureProvider.autoDispose<List<NotebookEntry>>(
  (ref) async {
    await ref.watch(reviewOverviewProvider.future);
    return ref.watch(notebookStoreProvider).entries();
  },
  retry: (_, _) => null,
);

class ClueBoardData {
  const ClueBoardData({required this.clues, required this.openQuestions});

  final Map<String, List<ClueItem>> clues;
  final List<OpenQuestion> openQuestions;

  bool get isEmpty => clues.isEmpty && openQuestions.isEmpty;
}

final clueBoardProvider = FutureProvider.autoDispose<ClueBoardData>((
  ref,
) async {
  await ref.watch(reviewOverviewProvider.future);
  final store = ref.watch(notebookStoreProvider);
  return ClueBoardData(
    clues: cluesByEpisode(await store.clues()),
    openQuestions: deriveOpenQuestions(await store.storyLinks()),
  );
}, retry: (_, _) => null);

final dailyGoalProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.watch(notebookStoreProvider).dailyGoalMinutes(),
  retry: (_, _) => null,
);

/// Tekrar ya da defter değişince sayıları yeniler.
void refreshNotebook(WidgetRef ref) {
  ref.invalidate(reviewOverviewProvider);
  ref.invalidate(notebookEntriesProvider);
  ref.invalidate(clueBoardProvider);
  // Hi'nin önerisi tekrar sayısına bakar (H-048).
  ref.invalidate(coachInputProvider);
  ref.invalidate(hiBadgeProvider);
}
