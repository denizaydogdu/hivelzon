// Sahne avı sonuçlarının defterdeki ifadelere yazılması (H-051, H-089).
// Saf Dart.

import '../../notebook/domain/notebook_item.dart';
import '../../notebook/domain/review_policy.dart';
import '../../notebook/domain/review_session.dart';
import 'topic_set.dart';

/// Defterdeki öğeler için **pratik** sonuçları (H-089): sahne avı tanımadır
/// (İngilizce adı okuyup nesneyi bulmak), hatırlama değildir; FSRS'e yazılmaz
/// (`rating` yok, kart değişmez). Kendisi bulduysa kanıt basamağına
/// "yardımla yaptı" işlenir. Defterde olmayan öğe yazılmaz; aynı öğe bir kez.
List<ReviewOutcome> huntOutcomes({
  required List<HuntResult> results,
  required List<NotebookEntry> entries,
  required DateTime now,
}) {
  final byKey = {for (final e in entries) e.item.key: e};
  final out = <ReviewOutcome>[];
  final seen = <String>{};
  for (final r in results) {
    final key = r.item.notebookKey;
    final e = byKey[key];
    if (e == null || !seen.add(key)) continue;
    out.add(
      ReviewOutcome(
        before: e.card,
        after: e.card,
        item: e.item,
        rating: null,
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
