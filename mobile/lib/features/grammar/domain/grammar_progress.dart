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

/// Kalınan kartın sırası (`c03` → 3). Kart kimlikleri `c01`, `c02`… sırayla
/// verilir (`grammarexport.py`); başka biçimde null.
int? grammarCardNumber(String? cardId) {
  final m = RegExp(r'^c(\d+)$').firstMatch(cardId ?? '');
  return m == null ? null : int.parse(m.group(1)!);
}

/// Listedeki ders kartının ilerlemesi (Dilbilgisi listesi, H-064 ek).
class GrammarLessonProgress {
  const GrammarLessonProgress(this.status, [this.percent]);

  static const notStarted = GrammarLessonProgress(GrammarStatus.notStarted, 0);
  static const completed = GrammarLessonProgress(GrammarStatus.completed, 100);

  final GrammarStatus status;

  /// 0–100. Sürüyor ama kart sayısı ya da kart sırası bilinmiyorsa null
  /// (yalnız "Başladın" yazar).
  final int? percent;

  bool get isCompleted => status == GrammarStatus.completed;
  bool get isStarted => status != GrammarStatus.notStarted;

  @override
  bool operator ==(Object other) =>
      other is GrammarLessonProgress &&
      other.status == status &&
      other.percent == percent;

  @override
  int get hashCode => Object.hash(status, percent);

  @override
  String toString() => 'GrammarLessonProgress(${status.code}, $percent)';
}

/// Dersin ilerlemesi: bitti → %100; başlanmadı → %0; sürüyorsa görülen kart
/// / kart sayısı. Kalınan kart (`lastCard`) sayılır: `c03` → 3 kart görüldü.
/// Bitmemiş ders %100 göstermez (en çok %99), başlanmış ders en az %1.
/// Kullanıcı geri dönerse yüzde de geri gider (kalınan yer).
GrammarLessonProgress grammarLessonProgress(
  GrammarLessonSummary lesson,
  GrammarProgress? progress,
) {
  if (progress == null) return GrammarLessonProgress.notStarted;
  switch (progress.status) {
    case GrammarStatus.completed:
      return GrammarLessonProgress.completed;
    case GrammarStatus.notStarted:
      return GrammarLessonProgress.notStarted;
    case GrammarStatus.inProgress:
      final total = lesson.cardCount;
      final seen = grammarCardNumber(progress.lastCard);
      if (total == null || total <= 0 || seen == null) {
        return const GrammarLessonProgress(GrammarStatus.inProgress);
      }
      final p = (seen.clamp(0, total) * 100 / total).round().clamp(1, 99);
      return GrammarLessonProgress(GrammarStatus.inProgress, p);
  }
}

/// Bir seviyenin özeti: tamamlanan / toplam ders ("A1 · 3/16 tamamlandı").
class GrammarLevelSummary {
  const GrammarLevelSummary({
    required this.level,
    required this.completed,
    required this.total,
  });

  final String level;
  final int completed;
  final int total;

  @override
  bool operator ==(Object other) =>
      other is GrammarLevelSummary &&
      other.level == level &&
      other.completed == completed &&
      other.total == total;

  @override
  int get hashCode => Object.hash(level, completed, total);

  @override
  String toString() => 'GrammarLevelSummary($level, $completed/$total)';
}

/// Seviye başına özet (bütün dersler; raftan bağımsız: biten ders
/// "Tamamladıkların"da görünse de seviyesinde sayılır).
Map<String, GrammarLevelSummary> grammarLevelSummaries(
  List<GrammarLessonSummary> lessons,
  Map<String, GrammarProgress> progress,
) {
  final done = <String, int>{};
  final total = <String, int>{};
  for (final l in lessons) {
    total[l.level] = (total[l.level] ?? 0) + 1;
    if (progress[l.id]?.isCompleted ?? false) {
      done[l.level] = (done[l.level] ?? 0) + 1;
    }
  }
  return {
    for (final e in total.entries)
      e.key: GrammarLevelSummary(
        level: e.key,
        completed: done[e.key] ?? 0,
        total: e.value,
      ),
  };
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
