// Dilbilgisi ilerlemesi ve raflar (H-078). Saf Dart.

import 'grammar_lesson.dart';

enum GrammarStatus {
  notStarted('NOT_STARTED'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');

  const GrammarStatus(this.code);

  final String code;

  static GrammarStatus parse(String? v) =>
      values.firstWhere((s) => s.code == v, orElse: () => notStarted);
}

class GrammarProgress {
  const GrammarProgress({
    required this.lessonId,
    required this.status,
    this.lastCard,
    this.startedAt,
    this.completedAt,
    this.updatedAt,
  });

  final String lessonId;
  final GrammarStatus status;

  /// Kalınan kart (`c03`).
  final String? lastCard;

  /// UTC.
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? updatedAt;

  bool get isCompleted => status == GrammarStatus.completed;
}

/// Dilbilgisi raflarının kuruluşu: "Hikâyende geçenler" (oynanan bölümde ya
/// da okunan kitapta geçen, bitmemiş konular) · "Senin seviyen" · öteki
/// seviyeler · "Tamamladıkların". Her ders tek rafta görünür.
class GrammarShelves {
  const GrammarShelves({
    required this.userLevel,
    this.fromStory = const [],
    this.userLevelLessons = const [],
    this.otherLevels = const [],
    this.completed = const [],
  });

  final String userLevel;
  final List<GrammarLessonSummary> fromStory;
  final List<GrammarLessonSummary> userLevelLessons;
  final List<(String, List<GrammarLessonSummary>)> otherLevels;
  final List<GrammarLessonSummary> completed;

  bool get isEmpty =>
      fromStory.isEmpty &&
      userLevelLessons.isEmpty &&
      otherLevels.isEmpty &&
      completed.isEmpty;
}

/// [storyTopics]: oynanan bölümlerin ve okunan kitapların `grammarTopics`'i
/// (karşılaşma sırasıyla). [suggestedLevel] yoksa A1.
GrammarShelves buildGrammarShelves(
  List<GrammarLessonSummary> lessons,
  Map<String, GrammarProgress> progress, {
  String? suggestedLevel,
  List<String> storyTopics = const [],
}) {
  final level = suggestedLevel ?? 'A1';
  bool done(GrammarLessonSummary l) => progress[l.id]?.isCompleted ?? false;
  final byId = {for (final l in lessons) l.id: l};
  final fromStory = <GrammarLessonSummary>[];
  for (final id in storyTopics) {
    final l = byId[id];
    if (l != null && !done(l) && !fromStory.contains(l)) fromStory.add(l);
  }
  final sorted = List.of(lessons)
    ..sort((a, b) {
      final r = levelRank(a.level).compareTo(levelRank(b.level));
      return r != 0 ? r : a.id.compareTo(b.id);
    });
  final open = [
    for (final l in sorted)
      if (!done(l) && !fromStory.contains(l)) l,
  ];
  final others = <String, List<GrammarLessonSummary>>{};
  for (final l in open) {
    if (l.level == level) continue;
    others.putIfAbsent(l.level, () => []).add(l);
  }
  final completed =
      [
        for (final l in sorted)
          if (done(l)) l,
      ]..sort((a, b) {
        final ta = progress[a.id]?.completedAt;
        final tb = progress[b.id]?.completedAt;
        if (ta == null || tb == null) return 0;
        return tb.compareTo(ta);
      });
  return GrammarShelves(
    userLevel: level,
    fromStory: fromStory,
    userLevelLessons: [
      for (final l in open)
        if (l.level == level) l,
    ],
    otherLevels: [for (final e in others.entries) (e.key, e.value)],
    completed: completed,
  );
}

/// Bir bölümün ya da kitabın "Bu bölümdeki dilbilgisi" teklifi: paketteki
/// `grammarTopics`'ten listede olan dersler (sırası korunur). Ders yoksa null.
class GrammarOffer {
  const GrammarOffer(this.lessons);

  final List<GrammarLessonSummary> lessons;

  /// Toplam süre (dk, en az 1).
  int get minutes {
    var total = 0.0;
    for (final l in lessons) {
      total += l.estimatedMinutes ?? 2;
    }
    final r = total.round();
    return r < 1 ? 1 : r;
  }

  List<String> get ids => [for (final l in lessons) l.id];

  static GrammarOffer? of(
    List<String> topics,
    List<GrammarLessonSummary> lessons,
  ) {
    if (topics.isEmpty) return null;
    final byId = {for (final l in lessons) l.id: l};
    final found = [
      for (final id in topics)
        if (byId[id] != null) byId[id]!,
    ];
    return found.isEmpty ? null : GrammarOffer(found);
  }
}
