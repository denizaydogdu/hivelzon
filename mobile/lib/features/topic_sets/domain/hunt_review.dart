// Sahne avı sonuçlarının kelime tekrarına (FSRS) aktarılması (H-051). Saf Dart.

import '../../../shared/fsrs/fsrs.dart';
import '../../notebook/domain/notebook_item.dart';
import '../../notebook/domain/review_policy.dart';
import '../../notebook/domain/review_session.dart';
import 'topic_set.dart';

/// Defterdeki öğeler için tekrar sonuçları: kendisi bulduysa Good, "Bilmiyorum"
/// ya da 2+ kaçırma Again. Defterde olmayan öğe yazılmaz. Aynı yerel günde zaten
/// tekrar edilmiş kart atlanır: sahne avını arka arkaya oynamak aralıkları
/// şişirmez ya da kartı cezalandırmaz.
List<ReviewOutcome> huntOutcomes({
  required List<HuntResult> results,
  required List<NotebookEntry> entries,
  required FsrsScheduler scheduler,
  required DateTime now,
}) {
  final byKey = {for (final e in entries) e.item.key: e};
  final today = now.toLocal();
  bool sameDay(DateTime? t) {
    if (t == null) return false;
    final l = t.toLocal();
    return l.year == today.year && l.month == today.month && l.day == today.day;
  }

  final out = <ReviewOutcome>[];
  final seen = <String>{};
  for (final r in results) {
    final key = r.item.notebookKey;
    final e = byKey[key];
    if (e == null || !seen.add(key) || sameDay(e.card.fsrs.lastReview)) {
      continue;
    }
    final before = e.card;
    final rating = r.rating;
    final fsrs = scheduler.review(before.fsrs, rating, now.toUtc());
    final lapse =
        before.fsrs.state == FsrsState.review && rating == FsrsRating.again;
    out.add(
      ReviewOutcome(
        before: before,
        after: before.copyWith(
          fsrs: fsrs,
          reps: before.reps + 1,
          lapses: before.lapses + (lapse ? 1 : 0),
        ),
        item: e.item,
        rating: rating,
        taskType: TaskType.sceneHunt,
        correct: r.foundAlone,
        dontKnow: r.revealed,
        elapsed: r.elapsed,
        reviewedAt: now.toUtc(),
        requeued: false,
      ),
    );
  }
  return out;
}
