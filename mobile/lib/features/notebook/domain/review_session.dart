// Tekrar oturumu (H-036): kuyruk, oturum içi yeniden sorma, FSRS güncellemesi.
// Saf Dart; kalıcı kayıt [ReviewSession.persist] ile dışarıda yapılır.

import 'dart:math' as math;

import '../../../shared/fsrs/fsrs.dart';
import 'notebook_item.dart';
import 'retrieval_task.dart';
import 'review_policy.dart';

/// Bir cevabın sonucu (kaydedilir, ekranda kartın tamamı gösterilir).
class ReviewOutcome {
  const ReviewOutcome({
    required this.before,
    required this.after,
    required this.item,
    required this.rating,
    required this.taskType,
    required this.correct,
    required this.dontKnow,
    required this.elapsed,
    required this.reviewedAt,
    required this.requeued,
  });

  final ReviewCardState before;
  final ReviewCardState after;
  final NotebookItem item;
  final FsrsRating rating;
  final TaskType taskType;
  final bool correct;
  final bool dontKnow;
  final Duration elapsed;
  final DateTime reviewedAt;

  /// Kart bu oturumun sonuna yeniden eklendi mi.
  final bool requeued;

  bool get wasNew => before.isNew;
}

class SessionSummary {
  const SessionSummary({
    required this.reviewedCards,
    required this.answers,
    required this.firstTryCorrect,
    required this.comeBackTomorrow,
    required this.comeBackLater,
  });

  /// Oturumda görülen farklı kart sayısı.
  final int reviewedCards;
  final int answers;
  final int firstTryCorrect;

  /// Yarın (yerel gün sonuna kadar) yeniden gelecek kartlar.
  final int comeBackTomorrow;

  /// Daha sonra gelecek kartlar.
  final int comeBackLater;
}

/// Kuyruktaki kart.
class SessionCard {
  SessionCard(this.item, this.card);

  final NotebookItem item;
  ReviewCardState card;
  int requeues = 0;
  bool answeredBefore = false;
}

class ReviewSession {
  ReviewSession({
    required List<SessionCard> queue,
    required this.pool,
    required this.scheduler,
    required this.persist,
    DateTime Function()? clock,
    math.Random? random,
    this.level = 'A1',
    this.canSpeak = false,
  }) : _queue = List.of(queue),
       _clock = clock ?? (() => DateTime.now().toUtc()),
       _random = random ?? math.Random();

  final List<NotebookItem> pool;
  final FsrsScheduler scheduler;

  /// Kart ve günlük kaydı yazar (ör. Drift işlemi).
  final Future<void> Function(ReviewOutcome outcome) persist;
  final String level;

  /// Cihazda tanıma var ve açık: "Dinle ve söyle" görevi karışabilir (H-055).
  final bool canSpeak;

  final List<SessionCard> _queue;
  final DateTime Function() _clock;
  final math.Random _random;
  final Map<int, SessionCard> _seen = {};
  int _answers = 0;
  int _firstTryCorrect = 0;
  int _index = -1;
  RetrievalTask? _task;

  /// İlk kartı hazırlar.
  RetrievalTask? start() => _advance();

  int get total => _queue.length;

  /// 1 tabanlı sıra (ilerleme göstergesi için; süre gösterilmez, K-32).
  int get position => _index + 1;

  RetrievalTask? get task => _task;

  SessionCard? get current =>
      _index >= 0 && _index < _queue.length ? _queue[_index] : null;

  bool get finished => _index >= _queue.length;

  /// Cevabı değerlendirir, FSRS'i günceller ve kaydeder.
  ///
  /// "Bilmiyorum" ([dontKnow]) yanlış cevap gibi Again sayılır; kart en çok
  /// [ReviewPolicy.maxRequeuesPerCard] kez oturumun sonuna yeniden eklenir.
  ///
  /// [rating]: görev kendi notunu verdiyse ("Dinle ve söyle",
  /// [ReviewPolicy.rateSpeech]); yoksa doğruluk ve süreden hesaplanır.
  Future<ReviewOutcome> answer({
    required bool correct,
    bool dontKnow = false,
    required Duration elapsed,
    FsrsRating? rating,
  }) async {
    final sc = current;
    final task = _task;
    if (sc == null || task == null) throw StateError('oturumda kart yok');
    final ok = correct && !dontKnow;
    final listens =
        task.type == TaskType.listenChoice || task.type == TaskType.speak;
    final rated = dontKnow
        ? FsrsRating.again
        : rating ??
              ReviewPolicy.rate(
                type: task.type,
                correct: ok,
                elapsed: elapsed,
                stage: sc.card.stage,
                audioLength: listens
                    ? (sc.item.audio?.length ?? Duration.zero)
                    : Duration.zero,
              );
    return _apply(
      sc,
      task,
      rated,
      ok: ok,
      dontKnow: dontKnow,
      elapsed: elapsed,
    );
  }

  /// "Geç" (H-055): not verilmez, kaydedilmez, oturum içinde yeniden
  /// sorulmaz; kart vadesinde kalır ve sonraki oturumda gelir.
  void skip() {
    final sc = current;
    if (sc == null) throw StateError('oturumda kart yok');
    _skipped++;
  }

  int _skipped = 0;

  /// Geçilen kart sayısı.
  int get skipped => _skipped;

  Future<ReviewOutcome> _apply(
    SessionCard sc,
    RetrievalTask task,
    FsrsRating rating, {
    required bool ok,
    required bool dontKnow,
    required Duration elapsed,
  }) async {
    final at = _clock().toUtc();
    final before = sc.card;
    final fsrs = scheduler.review(before.fsrs, rating, at);
    final lapse =
        before.fsrs.state == FsrsState.review && rating == FsrsRating.again;
    final after = before.copyWith(
      fsrs: fsrs,
      reps: before.reps + 1,
      lapses: before.lapses + (lapse ? 1 : 0),
    );
    sc.card = after;
    final requeue =
        rating == FsrsRating.again &&
        sc.requeues < ReviewPolicy.maxRequeuesPerCard;
    final outcome = ReviewOutcome(
      before: before,
      after: after,
      item: sc.item,
      rating: rating,
      taskType: task.type,
      correct: ok,
      dontKnow: dontKnow,
      elapsed: elapsed,
      reviewedAt: at,
      requeued: requeue,
    );
    await persist(outcome);
    _answers++;
    if (!sc.answeredBefore && ok) _firstTryCorrect++;
    sc.answeredBefore = true;
    _seen[after.id] = sc;
    if (requeue) {
      sc.requeues++;
      _queue.add(sc);
    }
    return outcome;
  }

  /// Sıradaki karta geçer; oturum bittiyse null.
  RetrievalTask? next() => _advance();

  RetrievalTask? _advance() {
    _index++;
    final sc = current;
    if (sc == null) {
      _task = null;
      return null;
    }
    _task = buildTask(
      item: sc.item,
      card: sc.card,
      pool: pool,
      random: _random,
      level: level,
      canSpeak: canSpeak,
    );
    return _task;
  }

  /// [endOfTomorrowUtc]: yerel olarak yarının sonu (UTC).
  SessionSummary summary({required DateTime endOfTomorrowUtc}) {
    var tomorrow = 0;
    var later = 0;
    for (final sc in _seen.values) {
      if (!sc.card.fsrs.due.isAfter(endOfTomorrowUtc)) {
        tomorrow++;
      } else {
        later++;
      }
    }
    return SessionSummary(
      reviewedCards: _seen.length,
      answers: _answers,
      firstTryCorrect: _firstTryCorrect,
      comeBackTomorrow: tomorrow,
      comeBackLater: later,
    );
  }
}

/// Oturum kartları: önce vadesi gelmiş tekrarlar (en eski önce), sonra yeni
/// kartlar (günlük sınır kadar, en eski önce); toplam en çok [maxCards].
List<NotebookEntry> pickSessionCards(
  List<NotebookEntry> entries, {
  required DateTime now,
  required int newAllowed,
  int maxCards = ReviewPolicy.sessionMaxCards,
}) {
  final due = [
    for (final e in entries)
      if (!e.card.isNew && !e.card.fsrs.due.isAfter(now)) e,
  ]..sort((a, b) => a.card.fsrs.due.compareTo(b.card.fsrs.due));
  final fresh = [
    for (final e in entries)
      if (e.card.isNew) e,
  ]..sort((a, b) => a.card.id.compareTo(b.card.id));
  final out = due.take(maxCards).toList();
  final room = math.min(math.max(0, newAllowed), maxCards - out.length);
  out.addAll(fresh.take(math.max(0, room)));
  return out;
}

/// Ana Sayfa ve Defter için özet sayılar (Hi-A da kullanır).
class ReviewOverview {
  const ReviewOverview({
    required this.dueReviews,
    required this.newAvailable,
    required this.totalItems,
    required this.newPerDay,
    this.nextDue,
  });

  static const empty = ReviewOverview(
    dueReviews: 0,
    newAvailable: 0,
    totalItems: 0,
    newPerDay: 0,
  );

  final int dueReviews;

  /// Bugün başlanabilecek yeni kart (günlük sınır düşülmüş).
  final int newAvailable;
  final int totalItems;
  final int newPerDay;

  /// Sıradaki vadesi gelecek kart (UTC); hepsi bugün bittiyse sonraki.
  final DateTime? nextDue;

  /// Oturumda sorulacak kart sayısı.
  int get sessionCount =>
      math.min(dueReviews + newAvailable, ReviewPolicy.sessionMaxCards);
}

ReviewOverview computeOverview(
  List<NotebookEntry> entries, {
  required DateTime now,
  required int newIntroducedToday,
  required int newPerDay,
}) {
  var due = 0;
  var fresh = 0;
  DateTime? next;
  for (final e in entries) {
    if (e.card.isNew) {
      fresh++;
    } else if (!e.card.fsrs.due.isAfter(now)) {
      due++;
    } else if (next == null || e.card.fsrs.due.isBefore(next)) {
      next = e.card.fsrs.due;
    }
  }
  final allowed = math.max(0, newPerDay - newIntroducedToday);
  return ReviewOverview(
    dueReviews: due,
    newAvailable: math.min(fresh, allowed),
    totalItems: entries.length,
    newPerDay: newPerDay,
    nextDue: next,
  );
}
