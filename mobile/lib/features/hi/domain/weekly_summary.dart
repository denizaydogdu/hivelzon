// Haftalık özet (H-048): son 7 gün, yalnızca yerel kayıtlar. Saf Dart.
//
// Olumlu çerçeve: yapılan sayılır, yapılmayan söylenmez; seri ve kıyas yok
// (K-16, K-32). H-093: tekrar ve ekleme sayılarının yanında öğrenme kanıtı
// basamaklarından tek cümle (`docs/KELIME-TEKRARI.md` §3); yüzde yok.

import '../../../shared/meaning/error_taxonomy.dart';
import '../../notebook/domain/evidence_ladder.dart';
import 'coach_rules.dart';

class WeeklySummary {
  const WeeklySummary({
    required this.phrasesAdded,
    required this.phrasesReviewed,
    required this.episodesCompleted,
    this.focus,
    this.recalledLater = 0,
    this.ownUse = 0,
    this.helped = 0,
  });

  final int phrasesAdded;

  /// Kelime tekrarında hatırlama sorusu cevaplanan farklı ifade sayısı
  /// (`review_logs`; H-089'dan beri pratik orada yok). Pratiği yapılıp
  /// hatırlama sorusuna gelmeden bırakılan ifade sayılmaz; pratik
  /// başarısı [helped] ile görünür.
  final int phrasesReviewed;
  final int episodesCompleted;

  /// En çok yeniden denenen **dil konusu** (yoksa null). "Hatırlama" ve
  /// "Diğer" konu değildir; sayılmaz ([kNonTopicErrorTypes]).
  final ErrorType? focus;

  /// Bu hafta ilk kez "birkaç gün sonra hatırladı" basamağına ulaşan ifade
  /// sayısı (H-093).
  final int recalledLater;

  /// Bu hafta ilk kez "kendi kullandı" basamağına ulaşan ifade sayısı.
  final int ownUse;

  /// Bu hafta ilk kez "yardımla yaptı" basamağına ulaşan ifade sayısı.
  final int helped;

  /// Haftanın en güçlü kanıtı: (basamak, ifade sayısı); yoksa null. Tek
  /// cümle gösterilir; daha zayıf basamaklar sayılmaz (sayı yığını yok).
  (EvidenceStage, int)? get topEvidence {
    if (recalledLater > 0) return (EvidenceStage.recalledLater, recalledLater);
    if (ownUse > 0) return (EvidenceStage.ownUse, ownUse);
    if (helped > 0) return (EvidenceStage.helped, helped);
    return null;
  }

  bool get isEmpty =>
      phrasesAdded == 0 &&
      phrasesReviewed == 0 &&
      episodesCompleted == 0 &&
      focus == null &&
      topEvidence == null;
}

/// Haftalık özette "en çok çalışılan konu" sayılmayan türler (H-055 ile
/// düzeltildi): tekrar kartını hatırlayamamak ve sınıflanmamış hata bir dil
/// konusu değildir.
const Set<ErrorType> kNonTopicErrorTypes = {ErrorType.recall, ErrorType.other};

/// [itemCreatedAt]: defter ifadelerinin eklenme anı; [reviews]: (kart, an);
/// [completedAt]: bölüm bitiş anları; [evidence]: kanıt basamağı satırları
/// (ifade + basamak başına ilk an; H-093). Hepsi UTC; pencere `[now-7g, now]`.
WeeklySummary computeWeeklySummary({
  required DateTime now,
  required Iterable<DateTime> itemCreatedAt,
  required Iterable<(int cardId, DateTime at)> reviews,
  required Iterable<DateTime> completedAt,
  required Iterable<ErrorObservation> errors,
  Iterable<(EvidenceStage stage, DateTime at)> evidence = const [],
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
  // Satırlar ifade + basamak başına tektir: pencere içindekiler sayılır.
  final stages = <EvidenceStage, int>{};
  for (final (stage, at) in evidence) {
    if (inWindow(at)) stages[stage] = (stages[stage] ?? 0) + 1;
  }
  return WeeklySummary(
    phrasesAdded: itemCreatedAt.where(inWindow).length,
    phrasesReviewed: {
      for (final r in reviews)
        if (inWindow(r.$2)) r.$1,
    }.length,
    episodesCompleted: completedAt.where(inWindow).length,
    focus: focus,
    recalledLater: stages[EvidenceStage.recalledLater] ?? 0,
    ownUse: stages[EvidenceStage.ownUse] ?? 0,
    helped: stages[EvidenceStage.helped] ?? 0,
  );
}
