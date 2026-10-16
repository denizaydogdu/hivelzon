import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/domain/retrieval_task.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/features/notebook/domain/review_session.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';
import 'package:hivelzon/shared/speech/speech_match.dart';

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
    test('yeni kart: pratik (resimden seç) FSRS\'e yazılmaz; başarılıysa '
        'oturum sonunda hatırlama gelir ve FSRS onu yazar', () async {
      var now = t0;
      final saved = <ReviewOutcome>[];
      final s = ReviewSession(
        queue: [for (final i in items.take(2)) SessionCard(i, _new(i.id!, t0))],
        pool: items,
        scheduler: ReviewPolicy.scheduler(),
        persist: (o) async => saved.add(o),
        clock: () => now,
        random: math.Random(1),
      );
      expect(s.start()!.type, TaskType.pictureChoice);
      final p1 = await s.answer(
        correct: true,
        elapsed: const Duration(seconds: 3),
      );
      expect(p1.practice, isTrue);
      expect(p1.rating, isNull, reason: 'tanıma not almaz');
      expect(p1.after, same(p1.before), reason: 'kart değişmez');
      expect(p1.recallFollows, isTrue);
      expect(s.total, 3, reason: 'hatırlama sorusu sona eklendi');
      // İkinci kart: pratikte "Bilmiyorum" → not yok, pratik yeniden gelir.
      now = now.add(const Duration(seconds: 20));
      expect(s.next()!.type, TaskType.pictureChoice);
      final p2 = await s.answer(
        correct: false,
        dontKnow: true,
        elapsed: const Duration(seconds: 3),
      );
      expect(p2.rating, isNull);
      expect(p2.requeued, isTrue);
      expect(p2.recallFollows, isFalse);
      expect(s.total, 4);
      // Oturum sonunda ilk kart: hatırlama (kendini yokla) → Good, ertesi gün.
      now = now.add(const Duration(seconds: 20));
      final r1 = s.next()!;
      expect(r1.item.textEn, 'Can you hear me?');
      expect(r1.type, TaskType.selfCheck);
      final o = await s.answer(
        correct: true,
        elapsed: const Duration(seconds: 40),
      );
      expect(o.rating, FsrsRating.good, reason: 'yavaş doğru da Good');
      expect(o.after.fsrs.state, FsrsState.review);
      expect(o.after.reps, 1);
      expect(o.wasNew, isTrue);
      // İkinci kart yine pratikle gelir.
      expect(s.next()!.type, TaskType.pictureChoice);
      final p3 = await s.answer(
        correct: true,
        elapsed: const Duration(seconds: 3),
      );
      expect(p3.recallFollows, isTrue);
      final r2 = s.next()!;
      expect(r2.type, TaskType.selfCheck);
      final o2 = await s.answer(
        correct: false,
        dontKnow: true,
        elapsed: const Duration(seconds: 3),
      );
      expect(o2.rating, FsrsRating.again);
      expect(o2.requeued, isTrue, reason: '1 yeniden sorma hakkı kaldı');
      // Again sonrası kart öğrenmede: önce pratik (dinle-seç), sonra hatırlama.
      expect(s.next()!.type, TaskType.listenChoice);
      await s.answer(correct: true, elapsed: const Duration(seconds: 3));
      expect(s.next()!.type, TaskType.selfCheck);
      await s.answer(correct: true, elapsed: const Duration(seconds: 3));
      expect(s.next(), isNull);
      expect(saved.map((o) => o.rating?.name ?? 'pratik'), [
        'pratik',
        'pratik',
        'good',
        'pratik',
        'again',
        'pratik',
        'good',
      ]);
      final sum = s.summary(endOfTomorrowUtc: t0.add(const Duration(days: 2)));
      expect(sum.reviewedCards, 2);
      expect(sum.answers, 7);
      expect(sum.firstTryCorrect, 1);
    });

    test('pratikte de en çok iki kez yeniden sorulur', () async {
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
        final o = await s.answer(
          correct: false,
          elapsed: const Duration(seconds: 2),
        );
        expect(o.rating, isNull);
        s.next();
      }
      expect(asked, 1 + ReviewPolicy.maxRequeuesPerCard);
    });

    test('vadesi gelen uzun vade kartı önce yardımsız hatırlanır; unutma '
        'lapse sayılır', () async {
      final s = ReviewSession(
        queue: [SessionCard(items[0], _review(1, t0, s: 30))],
        pool: items,
        scheduler: ReviewPolicy.scheduler(),
        persist: (_) async {},
        clock: () => t0,
        random: math.Random(3),
      );
      expect(s.start()!.type.isRecall, isTrue);
      final o = await s.answer(
        correct: false,
        elapsed: const Duration(seconds: 4),
      );
      expect(o.after.lapses, 1);
      expect(o.after.fsrs.state, FsrsState.relearning);
      expect(s.next()!.type.isRecall, isFalse, reason: 'yeniden: önce pratik');
    });

    test(
      'taklit ("Dinle ve söyle") başarısı FSRS\'te Good/Easy sayılmaz',
      () async {
        final item = _item(1, 'Yes, I can.');
        // Yeniden öğrenmedeki kart, tek sayılı tekrar: dinle ve söyle.
        final card = ReviewCardState(
          id: 1,
          itemId: 1,
          reps: 5,
          lapses: 1,
          fsrs: FsrsCard(
            state: FsrsState.relearning,
            step: 0,
            stability: 30,
            difficulty: 5,
            due: t0,
            lastReview: t0.subtract(const Duration(days: 1)),
          ),
        );
        final saved = <ReviewOutcome>[];
        final s = ReviewSession(
          queue: [SessionCard(item, card)],
          pool: items,
          scheduler: ReviewPolicy.scheduler(),
          persist: (o) async => saved.add(o),
          clock: () => t0,
          random: math.Random(1),
          canSpeak: true,
        );
        expect(s.start()!.type, TaskType.speak);
        // Ekran hızlı, ilk denemede tam söylemeyi bile not olarak verse yok sayılır.
        final o = await s.answer(
          correct: true,
          elapsed: const Duration(seconds: 1),
          rating: FsrsRating.easy,
        );
        expect(o.rating, isNull);
        expect(o.after.fsrs, same(card.fsrs));
        expect(saved.single.practice, isTrue);
        // Sonra sesi duymadan söyleme: hatırlama, not alır.
        final recall = s.next()!;
        expect(recall.type, TaskType.speakRecall);
        final r = await s.answer(
          correct: true,
          elapsed: const Duration(seconds: 1),
          rating: FsrsRating.good,
        );
        expect(r.rating, FsrsRating.good);
      },
    );
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

    test('görev türleri: hatırlama ve pratik ayrımı', () {
      expect(
        [
          for (final t in TaskType.values)
            if (t.isRecall) t,
        ],
        [TaskType.type, TaskType.selfCheck, TaskType.speakRecall],
      );
      expect(TaskType.speak.isRecall, isFalse, reason: 'taklit');
      expect(TaskType.listenChoice.isRecall, isFalse, reason: 'tanıma');
      expect(TaskType.pictureChoice.isRecall, isFalse, reason: 'tanıma');
      expect(TaskType.arrange.isRecall, isFalse, reason: 'kelimeler verili');
      expect(TaskType.sceneHunt.isRecall, isFalse, reason: 'tanıma');
      expect(TaskType.parse('speak_recall'), TaskType.speakRecall);
    });

    test('aşamaya göre görev türü', () {
      TaskType t(
        CardStage st, {
        bool audio = true,
        bool multi = true,
        int opts = 4,
        bool speak = false,
        bool recallOnly = false,
        String level = 'A1',
      }) => ReviewPolicy.chooseTask(
        stage: st,
        hasAudio: audio,
        multiWord: multi,
        optionCount: opts,
        canSpeak: speak,
        recallOnly: recallOnly,
        level: level,
      );
      // Pratik: yeni / öğrenme / yeniden öğrenme.
      expect(t(stage(0, FsrsState.learning)), TaskType.pictureChoice);
      expect(t(stage(1, FsrsState.learning)), TaskType.listenChoice);
      expect(t(stage(1, FsrsState.learning), audio: false), TaskType.arrange);
      expect(
        t(stage(1, FsrsState.learning), audio: false, multi: false),
        TaskType.pictureChoice,
      );
      expect(
        t(stage(3, FsrsState.relearning), speak: true),
        TaskType.speak,
        reason: 'tek sayılı tekrarda dinle ve söyle',
      );
      expect(
        t(stage(4, FsrsState.relearning), speak: true),
        TaskType.listenChoice,
      );
      expect(t(stage(0, FsrsState.learning), opts: 1), TaskType.arrange);
      expect(
        t(stage(0, FsrsState.learning), opts: 1, multi: false),
        TaskType.selfCheck,
        reason: 'pratik yoksa doğrudan hatırlama',
      );
      // Hatırlama: uzun vade kartı ya da pratik sonrası soru.
      expect(
        t(stage(0, FsrsState.learning), recallOnly: true),
        TaskType.selfCheck,
      );
      expect(t(stage(1, FsrsState.review)), TaskType.selfCheck);
      expect(t(stage(3, FsrsState.review)), TaskType.selfCheck);
      expect(
        t(stage(4, FsrsState.review)),
        TaskType.selfCheck,
        reason: 'kalıp, tanıma kapalı → kendini yokla',
      );
      expect(t(stage(4, FsrsState.review), speak: true), TaskType.speakRecall);
      expect(t(stage(4, FsrsState.review), multi: false), TaskType.type);
      expect(
        t(stage(3, FsrsState.review), multi: false, level: 'A2'),
        TaskType.type,
      );
      expect(
        t(stage(2, FsrsState.review), speak: true),
        TaskType.selfCheck,
        reason: 'uzun vade kartında taklit ya da seçenek yok',
      );
    });

    test('hatırlama → FSRS notu; yavaş doğru Hard değil (erişilebilirlik)', () {
      FsrsRating r(
        bool ok,
        int sec, {
        double s = 3,
        TaskType type = TaskType.type,
      }) => ReviewPolicy.rate(
        type: type,
        correct: ok,
        elapsed: Duration(seconds: sec),
        stage: stage(5, FsrsState.review, s),
      );
      expect(r(false, 2), FsrsRating.again);
      expect(r(true, 60), FsrsRating.good, reason: 'yavaş doğru → Good');
      expect(r(true, 6), FsrsRating.good);
      expect(r(true, 2), FsrsRating.good, reason: 'olgun değil → Easy yok');
      expect(r(true, 2, s: 30), FsrsRating.easy);
      expect(
        r(true, 1, s: 30, type: TaskType.selfCheck),
        FsrsRating.good,
        reason: 'kendini yoklamada hız ölçülmez',
      );
      expect(
        r(true, 1, s: 30, type: TaskType.listenChoice),
        FsrsRating.hard,
        reason: 'pratik hiçbir zaman Good/Easy değil',
      );
    });

    test('"Söyle" (hatırlama): anlamı değiştiren ek → Again; eksik kelime → '
        'Hard', () {
      FsrsRating r(
        SpeechMatchLevel l, {
        List<String> changed = const [],
        int attempts = 1,
      }) => ReviewPolicy.rateSpeech(
        level: l,
        elapsed: const Duration(seconds: 3),
        stage: stage(5, FsrsState.review, 5),
        attempts: attempts,
        changedWords: changed,
      );
      expect(r(SpeechMatchLevel.close), FsrsRating.hard);
      expect(r(SpeechMatchLevel.close, changed: ['not']), FsrsRating.again);
      expect(r(SpeechMatchLevel.full), FsrsRating.good);
      expect(r(SpeechMatchLevel.full, attempts: 2), FsrsRating.hard);
      // Gerçek eşleştirmeyle: "I can not help you" ← "I can help you."
      final m = SpeechMatcher.compareAny('I can help you.', [
        'I can not help you',
      ]);
      expect(m.level, SpeechMatchLevel.close);
      expect(r(m.level, changed: m.changedWords), FsrsRating.again);
      final miss = SpeechMatcher.compareAny('Where is the station?', [
        'where is station',
      ]);
      expect(miss.level, SpeechMatchLevel.close);
      expect(r(miss.level, changed: miss.changedWords), FsrsRating.hard);
    });

    test('taklit başarısı: tam ya da yalnız eksik kelime; anlam değişirse '
        'değil', () {
      expect(
        ReviewPolicy.speechPracticeSucceeded(SpeechMatchLevel.full),
        isTrue,
      );
      expect(
        ReviewPolicy.speechPracticeSucceeded(SpeechMatchLevel.close),
        isTrue,
      );
      expect(
        ReviewPolicy.speechPracticeSucceeded(
          SpeechMatchLevel.close,
          changedWords: ['not'],
        ),
        isFalse,
      );
      expect(
        ReviewPolicy.speechPracticeSucceeded(SpeechMatchLevel.no),
        isFalse,
      );
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
      final relearning = ReviewCardState(
        id: 1,
        itemId: 1,
        reps: 5,
        fsrs: FsrsCard(state: FsrsState.relearning, step: 0, due: t0),
      );
      final arrange = buildTask(
        item: _item(1, 'Can you hear me?', audio: false),
        card: relearning,
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
