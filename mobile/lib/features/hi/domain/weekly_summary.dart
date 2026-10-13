// Haftalık özet (H-048): son 7 gün, yalnızca yerel kayıtlar. Saf Dart.
//
// Olumlu çerçeve: yapılan sayılır, yapılmayan söylenmez; seri ve kıyas yok
// (K-16, K-32).

import '../../../shared/meaning/error_taxonomy.dart';
import 'coach_rules.dart';

class WeeklySummary {
  const WeeklySummary({
    required this.phrasesAdded,
    required this.phrasesReviewed,
    required this.episodesCompleted,
    this.focus,
  });

  final int phrasesAdded;

  /// Tekrar edilen farklı ifade sayısı.
  final int phrasesReviewed;
  final int episodesCompleted;

  /// En çok yeniden denenen **dil konusu** (yoksa null). "Hatırlama" ve
  /// "Diğer" konu değildir; sayılmaz ([kNonTopicErrorTypes]).
  final ErrorType? focus;

  bool get isEmpty =>
      phrasesAdded == 0 &&
      phrasesReviewed == 0 &&
      episodesCompleted == 0 &&
      focus == null;
}

/// Haftalık özette "en çok çalışılan konu" sayılmayan türler (H-055 ile
/// düzeltildi): tekrar kartını hatırlayamamak ve sınıflanmamış hata bir dil
/// konusu değildir.
const Set<ErrorType> kNonTopicErrorTypes = {ErrorType.recall, ErrorType.other};

/// [itemCreatedAt]: defter ifadelerinin eklenme anı; [reviews]: (kart, an);
/// [completedAt]: bölüm bitiş anları. Hepsi UTC; pencere `[now-7g, now]`.
WeeklySummary computeWeeklySummary({
  required DateTime now,
  required Iterable<DateTime> itemCreatedAt,
  required Iterable<(int cardId, DateTime at)> reviews,
  required Iterable<DateTime> completedAt,
  required Iterable<ErrorObservation> errors,
}) {
  final since = now.subtract(kCoachWindow);
  bool inWindow(DateTime t) => !t.isBefore(since) && !t.isAfter(now);
  final counts = <ErrorType, int>{};
  final last = <ErrorType, DateTime>{};
  for (final e in errors) {
    if (!inWindow(e.at) || kNonTopicErrorTypes.contains(e.type)) continue;
    counts[e.type] = (counts[e.type] ?? 0) + 1;
    final l = last[e.type];
    if (l == null || e.at.isAfter(l)) last[e.type] = e.at;
  }
  ErrorType? focus;
  for (final t in counts.keys) {
    if (focus == null ||
        counts[t]! > counts[focus]! ||
        (counts[t] == counts[focus] && last[t]!.isAfter(last[focus]!))) {
      focus = t;
    }
  }
  return WeeklySummary(
    phrasesAdded: itemCreatedAt.where(inWindow).length,
    phrasesReviewed: {
      for (final r in reviews)
        if (inWindow(r.$2)) r.$1,
    }.length,
    episodesCompleted: completedAt.where(inWindow).length,
    focus: focus,
  );
}
