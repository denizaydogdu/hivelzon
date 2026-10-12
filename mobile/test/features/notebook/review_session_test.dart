import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/domain/retrieval_task.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/features/notebook/domain/review_session.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';

NotebookItem _item(int id, String en, {String? tr, bool audio = true}) =>
    NotebookItem(
      id: id,
      kind: wordCount(en) > 1 ? NotebookKind.phrase : NotebookKind.word,
      textEn: en,
      textTr: tr ?? 'tr $en',
      contentId: 'A1-001',
      imagePath: 'stills/x.jpg',
      audio: audio
          ? const MediaClip('segments/s02.mp4', start: 1, end: 2)
          : null,
      source: NotebookSource.autoTargetPhrase,
    );

ReviewCardState _new(int id, DateTime at) =>
    ReviewCardState(id: id, itemId: id, fsrs: FsrsCard.newCard(at));

ReviewCardState _review(int id, DateTime due, {int reps = 3, double s = 5}) =>
    ReviewCardState(
      id: id,
      itemId: id,
      reps: reps,
      fsrs: FsrsCard(
        state: FsrsState.review,
        step: null,
        stability: s,
        difficulty: 5,
        due: due,
        lastReview: due.subtract(const Duration(days: 3)),
      ),
    );

void main() {
  final t0 = DateTime.utc(2026, 10, 12, 9);
  final phrases = [
    'Can you hear me?',
    'Yes, I can.',
    'Again, please.',
    'Where is…?',
    'Thank you.',
  ];
  final items = [for (final (i, p) in phrases.indexed) _item(i + 1, p)];

  group('ReviewSession', () {
    test(
      'Bilmiyorum → aynı oturumun sonunda yeniden; doğru → ertesi gün',
      () async {
        var now = t0;
        final saved = <ReviewOutcome>[];
        final s = ReviewSession(
          queue: [
            for (final i in items.take(3)) SessionCard(i, _new(i.id!, t0)),
          ],
          pool: items,
          scheduler: ReviewPolicy.scheduler(),
          persist: (o) async => saved.add(o),
          clock: () => now,
          random: math.Random(1),
        );
        expect(s.start()!.item.textEn, 'Can you hear me?');
        final o1 = await s.answer(
          correct: false,
          dontKnow: true,
          elapsed: const Duration(seconds: 3),
        );
        expect(o1.rating, FsrsRating.again);
        expect(o1.requeued, isTrue);
        expect(o1.after.fsrs.due, t0.add(const Duration(minutes: 10)));
        expect(s.total, 4, reason: 'kart oturumun sonuna eklendi');
        // Diğer iki kart doğru.
        for (var i = 0; i < 2; i++) {
          now = now.add(const Duration(seconds: 20));
          s.next();
          final o = await s.answer(
            correct: true,
            elapsed: const Duration(seconds: 5),
          );
          expect(o.rating, FsrsRating.good);
          expect(o.after.fsrs.state, FsrsState.review);
        }
        // Oturum sonunda aynı kart yeniden; bu kez doğru → yarın.
        now = now.add(const Duration(seconds: 20));
        expect(s.next()!.item.textEn, 'Can you hear me?');
        final again = await s.answer(
          correct: true,
          elapsed: const Duration(seconds: 6),
        );
        expect(again.requeued, isFalse);
        expect(again.after.fsrs.state, FsrsState.review);
        final dueDay = again.after.fsrs.due.difference(now).inHours;
        expect(dueDay, inInclusiveRange(23, 25), reason: 'ertesi gün');
        expect(again.after.reps, 2);
        expect(s.next(), isNull);
        expect(s.finished, isTrue);
        expect(saved, hasLength(4));
        expect(saved.first.wasNew, isTrue);
        final sum = s.summary(
          endOfTomorrowUtc: t0.add(const Duration(days: 2)),
        );
        expect(sum.reviewedCards, 3);
        expect(sum.answers, 4);
        expect(sum.firstTryCorrect, 2);
        // Bilinmeyen kart yarın; ilk seferde Good alan yeni kartlar 2 gün sonra.
        expect(sum.comeBackTomorrow, 1);
        expect(sum.comeBackLater, 2);
      },
    );

    test('oturumda en çok iki kez yeniden sorulur', () async {
      final s = ReviewSession(
        queue: [SessionCard(items[0], _new(1, t0))],
        pool: items,
        scheduler: ReviewPolicy.scheduler(),
        persist: (_) async {},
        clock: () => t0,
        random: math.Random(2),
      );
      s.start();
      var asked = 0;
      while (!s.finished) {
        asked++;
        await s.answer(correct: false, elapsed: const Duration(seconds: 2));
        s.next();
      }
      expect(asked, 1 + ReviewPolicy.maxRequeuesPerCard);
    });

    test('olgun kartta unutma lapse sayılır', () async {
      final s = ReviewSession(
        queue: [SessionCard(items[0], _review(1, t0, s: 30))],
        pool: items,
        scheduler: ReviewPolicy.scheduler(),
        persist: (_) async {},
        clock: () => t0,
        random: math.Random(3),
      );
      s.start();
      final o = await s.answer(
        correct: false,
        elapsed: const Duration(seconds: 4),
      );
      expect(o.after.lapses, 1);
      expect(o.after.fsrs.state, FsrsState.relearning);
    });
  });

  group('günlük yeni kart sınırı', () {
    final entries = [
      for (final i in items.take(4)) NotebookEntry(i, _new(i.id!, t0)),
      NotebookEntry(
        items[4],
        _review(5, t0.subtract(const Duration(hours: 1))),
      ),
    ];

    test('hedef → sınır: 5/10/15 dk → 5/10/15 kart', () {
      expect(ReviewPolicy.newCardsPerDay(5), 5);
      expect(ReviewPolicy.newCardsPerDay(10), 10);
      expect(ReviewPolicy.newCardsPerDay(15), 15);
      expect(
        ReviewPolicy.newCardsPerDay(7),
        10,
        reason: 'bilinmeyen → varsayılan',
      );
    });

    test('önce vadesi gelen tekrar, sonra kalan sınır kadar yeni kart', () {
      final picked = pickSessionCards(entries, now: t0, newAllowed: 2);
      expect(picked.map((e) => e.card.id), [5, 1, 2]);
      expect(pickSessionCards(entries, now: t0, newAllowed: 0).length, 1);
      expect(
        pickSessionCards(entries, now: t0, newAllowed: 10, maxCards: 3).length,
        3,
      );
    });

    test('özet: bugün açılan yeni kartlar sınırdan düşülür', () {
      final o = computeOverview(
        entries,
        now: t0,
        newIntroducedToday: 3,
        newPerDay: 5,
      );
      expect(o.dueReviews, 1);
      expect(o.newAvailable, 2);
      expect(o.sessionCount, 3);
      final full = computeOverview(
        entries,
        now: t0,
        newIntroducedToday: 5,
        newPerDay: 5,
      );
      expect(full.newAvailable, 0);
      expect(full.sessionCount, 1);
    });
  });

  group('görev ve not kuralları', () {
    CardStage stage(int reps, FsrsState st, [double s = 3]) =>
        CardStage(reps: reps, state: st, stability: s);

    test('aşamaya göre görev türü', () {
      TaskType t(
        CardStage st, {
        bool audio = true,
        bool multi = true,
        int opts = 4,
      }) => ReviewPolicy.chooseTask(
        stage: st,
        hasAudio: audio,
        multiWord: multi,
        optionCount: opts,
      );
      expect(t(stage(0, FsrsState.learning)), TaskType.pictureChoice);
      expect(t(stage(1, FsrsState.review)), TaskType.pictureChoice);
      expect(t(stage(2, FsrsState.review)), TaskType.listenChoice);
      expect(
        t(stage(2, FsrsState.review), audio: false),
        TaskType.pictureChoice,
      );
      expect(t(stage(3, FsrsState.relearning)), TaskType.pictureChoice);
      expect(t(stage(4, FsrsState.review)), TaskType.arrange);
      expect(t(stage(4, FsrsState.review), multi: false), TaskType.type);
      expect(t(stage(0, FsrsState.learning), opts: 1), TaskType.selfCheck);
      expect(
        ReviewPolicy.chooseTask(
          stage: stage(3, FsrsState.review),
          hasAudio: true,
          multiWord: true,
          optionCount: 4,
          level: 'A2',
        ),
        TaskType.arrange,
      );
    });

    test('cevap → FSRS notu', () {
      FsrsRating r(
        bool ok,
        int sec, {
        double s = 3,
        TaskType type = TaskType.pictureChoice,
        int audioSec = 0,
      }) => ReviewPolicy.rate(
        type: type,
        correct: ok,
        elapsed: Duration(seconds: sec),
        stage: stage(5, FsrsState.review, s),
        audioLength: Duration(seconds: audioSec),
      );
      expect(r(false, 2), FsrsRating.again);
      expect(r(true, 20), FsrsRating.hard);
      expect(r(true, 6), FsrsRating.good);
      expect(r(true, 2), FsrsRating.good, reason: 'olgun değil → Easy yok');
      expect(r(true, 2, s: 30), FsrsRating.easy);
      expect(
        r(true, 17, type: TaskType.listenChoice, audioSec: 3),
        FsrsRating.good,
        reason: 'ses süresi düşünme süresinden düşülür',
      );
      expect(r(true, 25, type: TaskType.arrange), FsrsRating.good);
    });

    test('seçenekler: doğru cevap + farklı 3 çeldirici', () {
      final card = _new(1, t0);
      final task = buildTask(
        item: items[0],
        card: card,
        pool: [...items, _item(9, 'can you hear me')],
        random: math.Random(4),
      );
      expect(task.type, TaskType.pictureChoice);
      expect(task.options, hasLength(4));
      expect(task.options.toSet(), hasLength(4));
      expect(task.options[task.correctIndex], 'Can you hear me?');
      expect(
        task.options.where((o) => normalizeEn(o) == 'can you hear me'),
        hasLength(1),
      );
    });

    test('dizme ve yazma kontrolü', () {
      final mature = _review(1, t0, reps: 5);
      final arrange = buildTask(
        item: items[0],
        card: mature,
        pool: items,
        random: math.Random(5),
      );
      expect(arrange.type, TaskType.arrange);
      expect(arrange.answerTokens, ['Can', 'you', 'hear', 'me?']);
      expect(arrange.tokens, isNot(arrange.answerTokens));
      expect(arrange.isCorrectOrder(['Can', 'you', 'hear', 'me?']), isTrue);
      expect(arrange.isCorrectOrder(['you', 'Can', 'hear', 'me?']), isFalse);
      // "…" içeren ifadede örnek cümle dizilir.
      final where = NotebookItem(
        kind: NotebookKind.phrase,
        textEn: 'Where is…?',
        exampleEn: 'Where is the old station?',
        source: NotebookSource.autoTargetPhrase,
      );
      expect(arrangeTokens(where), ['Where', 'is', 'the', 'old', 'station?']);
      final typed = buildTask(
        item: _item(7, 'Listen.'),
        card: mature,
        pool: items,
        random: math.Random(6),
      );
      expect(typed.type, TaskType.type);
      expect(typed.isCorrectTyped(' listen '), isTrue);
      expect(typed.isCorrectTyped('lisen'), isFalse);
    });
  });
}
