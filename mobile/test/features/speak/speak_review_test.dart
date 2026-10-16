import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/hi/domain/coach_rules.dart';
import 'package:hivelzon/features/hi/domain/weekly_summary.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/features/notebook/domain/review_session.dart';
import 'package:hivelzon/features/notebook/presentation/review_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/speech/fake_speech_recognizer.dart';
import 'package:hivelzon/shared/speech/speak_controller.dart';
import 'package:hivelzon/shared/speech/speak_widgets.dart';
import 'package:hivelzon/shared/speech/speech_match.dart';
import 'package:hivelzon/shared/speech/speech_providers.dart';
import 'package:hivelzon/shared/speech/speech_recognizer_port.dart';
import 'package:hivelzon/shared/speech/speech_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';

CardStage _stage(int reps, {FsrsState s = FsrsState.review, double st = 5}) =>
    CardStage(reps: reps, state: s, stability: st);

void main() {
  group('ReviewPolicy: "Dinle ve söyle" seçimi', () {
    TaskType t(
      CardStage st, {
      bool speak = true,
      bool audio = true,
      bool multi = true,
    }) => ReviewPolicy.chooseTask(
      stage: st,
      hasAudio: audio,
      multiWord: multi,
      optionCount: 4,
      canSpeak: speak,
    );

    test('orta-geç aşamada diğer görevlerle karışık', () {
      expect(t(_stage(2)), TaskType.speak);
      expect(t(_stage(3)), TaskType.listenChoice);
      expect(t(_stage(4)), TaskType.arrange);
      expect(t(_stage(5)), TaskType.speak);
      expect(t(_stage(6)), TaskType.arrange);
      expect(t(_stage(8)), TaskType.speak);
    });

    test('tanıma yoksa, ses yoksa, tek kelimede ya da öğrenmede yok', () {
      expect(t(_stage(2), speak: false), TaskType.listenChoice);
      expect(t(_stage(2), audio: false), TaskType.pictureChoice);
      expect(t(_stage(5), multi: false), TaskType.type);
      expect(t(_stage(2, s: FsrsState.relearning)), TaskType.pictureChoice);
      expect(t(_stage(0, s: FsrsState.learning)), TaskType.pictureChoice);
    });

    test('sonuç → FSRS notu', () {
      FsrsRating r(
        SpeechMatchLevel l, {
        int sec = 3,
        double st = 5,
        int attempts = 1,
      }) => ReviewPolicy.rateSpeech(
        level: l,
        elapsed: Duration(seconds: sec),
        stage: _stage(5, st: st),
        attempts: attempts,
      );
      expect(r(SpeechMatchLevel.full), FsrsRating.good);
      expect(r(SpeechMatchLevel.full, st: 30), FsrsRating.easy);
      expect(r(SpeechMatchLevel.full, st: 30, sec: 20), FsrsRating.good);
      expect(
        r(SpeechMatchLevel.full, st: 30, attempts: 2),
        FsrsRating.hard,
      ); // 2. denemede tam → Hard
      expect(r(SpeechMatchLevel.close), FsrsRating.hard);
      expect(r(SpeechMatchLevel.no), FsrsRating.again);
    });

    test('anlamı ters söyleyiş Good/Easy almaz (H-087)', () {
      for (final (exp, heard) in const [
        ('I can help you.', 'I can not help you'),
        ('I agree.', "I don't agree"),
      ]) {
        final m = SpeechMatcher.compareAny(exp, [heard]);
        final rating = ReviewPolicy.rateSpeech(
          level: m.level,
          elapsed: const Duration(seconds: 1),
          stage: _stage(5, st: 30),
        );
        expect(
          rating,
          isNot(anyOf(FsrsRating.good, FsrsRating.easy)),
          reason: '$exp ← $heard',
        );
      }
    });

    test('oturum: verilen not kullanılır; "Geç" kaydetmez', () async {
      final t0 = DateTime.utc(2026, 10, 13, 9);
      final item = NotebookItem(
        id: 1,
        kind: NotebookKind.phrase,
        textEn: 'Yes, I can.',
        contentId: 'A1-001',
        audio: const MediaClip('segments/s02.mp4', start: 1, end: 2),
        source: NotebookSource.autoTargetPhrase,
      );
      ReviewCardState card(int id) => ReviewCardState(
        id: id,
        itemId: id,
        reps: 2,
        fsrs: FsrsCard(
          state: FsrsState.review,
          step: null,
          stability: 5,
          difficulty: 5,
          due: t0,
          lastReview: t0.subtract(const Duration(days: 3)),
        ),
      );
      final saved = <ReviewOutcome>[];
      final s = ReviewSession(
        queue: [SessionCard(item, card(1)), SessionCard(item, card(2))],
        pool: [item],
        scheduler: ReviewPolicy.scheduler(),
        persist: (o) async => saved.add(o),
        clock: () => t0,
        random: math.Random(1),
        canSpeak: true,
      );
      expect(s.start()!.type, TaskType.speak);
      s.skip();
      expect(saved, isEmpty);
      expect(s.next()!.type, TaskType.speak);
      final o = await s.answer(
        correct: true,
        elapsed: const Duration(seconds: 4),
        rating: FsrsRating.hard,
      );
      expect(o.rating, FsrsRating.hard);
      expect(o.taskType, TaskType.speak);
      expect(saved, hasLength(1));
      expect(s.skipped, 1);
    });
  });

  group('SpeakController', () {
    test('en çok 2 deneme; en iyi sonuç; metin gösterimi', () async {
      final r = FakeSpeechRecognizer()
        ..queued.add(['yes can'])
        ..queued.add(['yes I'])
        ..queued.add(['yes I can']);
      final c = SpeakController(expected: 'Yes, I can.', recognizer: r);
      expect((await c.listen())!.level, SpeechMatchLevel.close);
      expect(c.finished, isFalse);
      expect((await c.listen())!.level, SpeechMatchLevel.close);
      expect(c.finished, isTrue);
      expect(c.revealed, isTrue);
      expect(c.bestLevel, SpeechMatchLevel.close);
      expect(await c.listen(), isNull, reason: 'denemeler doldu');
      expect(r.listens, 2);
    });

    test('tipik hata: hata kataloğu kimliği', () async {
      final r = FakeSpeechRecognizer()..queued.add(['yes I am']);
      final c = SpeakController(expected: 'Yes, I can.', recognizer: r);
      await c.listen();
      expect(c.errorNoteId, 'can-short-answer');
    });
  });

  group('resolveSpeechStatus', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    Future<SpeechStatus> st(FakeSpeechRecognizer r) =>
        resolveSpeechStatus(r, () => SpeechStore(db));

    test('destek, ayar ve izin', () async {
      expect(
        await st(FakeSpeechRecognizer(supported: false)),
        SpeechStatus.unsupported,
      );
      expect(await st(FakeSpeechRecognizer()), SpeechStatus.ready);
      expect(
        await st(FakeSpeechRecognizer(permission: SpeechPermission.notAsked)),
        SpeechStatus.needsPermission,
      );
      expect(
        await st(FakeSpeechRecognizer(permission: SpeechPermission.denied)),
        SpeechStatus.denied,
      );
      // Android: sorulmuş ama izin yok → reddedilmiş.
      await SpeechStore(db).markPermissionAsked();
      expect(
        await st(FakeSpeechRecognizer(permission: SpeechPermission.notAsked)),
        SpeechStatus.denied,
      );
      await SpeechStore(db).setEnabled(false);
      expect(await st(FakeSpeechRecognizer()), SpeechStatus.switchedOff);
      expect(SpeechStatus.switchedOff.showsPractice, isFalse);
      expect(SpeechStatus.needsPermission.showsPractice, isTrue);
    });

    test('HV_FAKE_SPEECH senaryosu', () async {
      final f = FakeSpeechRecognizer.fromScenario('ask,close,full');
      expect(await f.permission(), SpeechPermission.notAsked);
      expect(await f.requestPermission(), isTrue);
      final h1 = await f.listenOnce(debugExpected: 'Can you hear me?');
      expect(h1.alternatives.single, 'Can you me?');
      final h2 = await f.listenOnce(debugExpected: 'Can you hear me?');
      expect(h2.alternatives.single, 'Can you hear me?');
      expect(
        await FakeSpeechRecognizer.fromScenario('unsupported').support(),
        SpeechSupport.unsupported,
      );
    });
  });

  testWidgets('gizlilik: tanıma yazısı ve ses hiçbir tabloda saklanmaz', (
    tester,
  ) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = SpeechStore(db);
    // Ayırt edici kelimeler yalnızca "duyulan" yazıda var.
    final r = FakeSpeechRecognizer()
      ..queued.add(['zebra yes I am quokka'])
      ..queued.add(['yes I can platypus']);
    final writes = <Future<void>>[];
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SpeakPractice(
            expected: 'Yes, I can.',
            env: SpeakEnv(
              recognizer: r,
              ensureReady: (_) async => true,
              record: (a) => writes.add(store.record(a)),
            ),
            place: SpeechPlace.review,
            contentId: 'A1-001',
          ),
        ),
      ),
    );
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byKey(const ValueKey('speak-mic')));
      await tester.pumpAndSettle();
    }
    expect(find.text('Söyledin!'), findsOneWidget);
    await tester.runAsync(() => Future.wait(writes));
    final dump = await tester.runAsync(() async {
      final tables = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
          .get();
      final out = StringBuffer();
      for (final t in tables) {
        final name = t.read<String>('name');
        for (final row
            in await db.customSelect('SELECT * FROM "$name"').get()) {
          out.writeln(row.data.values.join('|'));
        }
      }
      return out.toString();
    });
    expect(dump, contains('Yes, I can.'), reason: 'beklenen ifade içerikten');
    for (final w in ['zebra', 'quokka', 'platypus', 'I am']) {
      expect(dump, isNot(contains(w)), reason: w);
    }
    final rows = await tester.runAsync(store.attempts);
    expect(rows!.map((a) => a.level), [
      SpeechMatchLevel.close,
      SpeechMatchLevel.full,
    ]);
    expect(rows.first.errorNoteId, 'can-short-answer');
    expect(rows.first.missingCount, 1);
  });

  test('haftalık özet: "Hatırlama" konu sayılmaz', () {
    final now = DateTime.utc(2026, 10, 13, 12);
    DateTime ago(int d) => now.subtract(Duration(days: d));
    WeeklySummary s(List<ErrorObservation> e) => computeWeeklySummary(
      now: now,
      itemCreatedAt: const [],
      reviews: const [],
      completedAt: const [],
      errors: e,
    );
    expect(
      s([
        for (var i = 0; i < 5; i++)
          ErrorObservation(type: ErrorType.recall, at: ago(1)),
      ]).focus,
      isNull,
    );
    expect(
      s([
        for (var i = 0; i < 5; i++)
          ErrorObservation(type: ErrorType.recall, at: ago(1)),
        ErrorObservation(type: ErrorType.preposition, at: ago(2)),
      ]).focus,
      ErrorType.preposition,
    );
  });

  group('Kelime tekrarı ekranı: "Dinle ve söyle"', () {
    late AppDatabase db;
    setUp(() {
      db = AppDatabase.memory();
      VideoPlayerPlatform.instance = FakeVideoPlatform(
        durationFor: (_) => const Duration(seconds: 30),
      );
    });
    tearDown(() => db.close());

    Future<void> seed(WidgetTester tester) async {
      await tester.runAsync(() async {
        final store = NotebookStore(db);
        await store.addItems([
          NotebookItem(
            kind: NotebookKind.phrase,
            textEn: 'Yes, I can.',
            textTr: 'Evet, duyabiliyorum.',
            contentId: 'A1-001',
            audio: const MediaClip('segments/s02.mp4', start: 1, end: 2),
            source: NotebookSource.autoTargetPhrase,
            createdAt: DateTime.utc(2026, 10, 1),
          ),
        ]);
        await db
            .update(db.reviewCards)
            .write(
              ReviewCardsCompanion(
                state: const Value(2),
                step: const Value(null),
                stability: const Value(5),
                difficulty: const Value(5),
                reps: const Value(2),
                due: Value(DateTime.utc(2026, 10, 2)),
                lastReview: Value(DateTime.utc(2026, 9, 29)),
              ),
            );
      });
    }

    Future<void> pump(WidgetTester tester, FakeSpeechRecognizer r) async {
      tester.view.physicalSize = const Size(1179, 3200);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final router = GoRouter(
        initialLocation: AppRoutes.review,
        routes: [
          GoRoute(path: '/', builder: (_, _) => const Text('ana')),
          GoRoute(
            path: AppRoutes.review,
            builder: (_, _) => const ReviewScreen(),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            legacyImportProvider.overrideWithValue(Future<void>.value()),
            contentSourceProvider.overrideWithValue(FakeContentSource()),
            progressRepositoryProvider.overrideWithValue(
              InMemoryProgressRepository(),
            ),
            learningEventLogProvider.overrideWithValue(
              InMemoryLearningEventLog(),
            ),
            reviewRandomProvider.overrideWithValue(math.Random(3)),
            speechRecognizerProvider.overrideWithValue(r),
          ],
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      );
    }

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 20; i++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    testWidgets('tam söyleyince Good; metin önce gizli', (tester) async {
      await seed(tester);
      final r = FakeSpeechRecognizer()..queued.add(['yes I can']);
      await pump(tester, r);
      await settle(tester);
      expect(find.byKey(const ValueKey('task-speak')), findsOneWidget);
      expect(find.text('Dinle ve söyle.'), findsOneWidget);
      expect(find.text('Yes, I can.'), findsNothing);
      expect(find.byKey(const ValueKey('task-dont-know')), findsOneWidget);
      expect(find.byKey(const ValueKey('task-skip')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('review-speak-mic')));
      await settle(tester);
      expect(find.text('Söyledin!'), findsOneWidget);
      final logs = await tester.runAsync(() => db.select(db.reviewLogs).get());
      expect(logs!.single.taskType, 'speak');
      expect(logs.single.rating, FsrsRating.good.value);
      expect(logs.single.correct, isTrue);
      final attempts = await tester.runAsync(
        () => db.select(db.speechAttempts).get(),
      );
      expect(attempts!.single.place, 'review');
      // Kart sesinin durdurma zamanlayıcısı.
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('yakın → "Devam et" ile Hard', (tester) async {
      await seed(tester);
      final r = FakeSpeechRecognizer()..queued.add(['yes can']);
      await pump(tester, r);
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('review-speak-mic')));
      await settle(tester);
      expect(find.text('Neredeyse! Şu kelimeyi duyamadım: I'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('review-speak-accept')));
      await settle(tester);
      final logs = await tester.runAsync(() => db.select(db.reviewLogs).get());
      expect(logs!.single.rating, FsrsRating.hard.value);
      expect(find.text('Neredeyse!'), findsOneWidget);
      // Kart sesinin durdurma zamanlayıcısı.
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('2 denemede olmadı → Again ve metin', (tester) async {
      await seed(tester);
      final r = FakeSpeechRecognizer(script: const ['no']);
      await pump(tester, r);
      await settle(tester);
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byKey(const ValueKey('review-speak-mic')));
        await settle(tester);
      }
      final logs = await tester.runAsync(() => db.select(db.reviewLogs).get());
      expect(logs!.single.rating, FsrsRating.again.value);
      expect(find.text('Sorun değil. İfade şöyle:'), findsOneWidget);
      expect(find.text('Yes, I can.'), findsWidgets);
      // Kart sesinin durdurma zamanlayıcısı.
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('"Geç": not ve kayıt yok', (tester) async {
      await seed(tester);
      await pump(tester, FakeSpeechRecognizer());
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('task-skip')));
      await settle(tester);
      final logs = await tester.runAsync(() => db.select(db.reviewLogs).get());
      expect(logs, isEmpty);
      expect(find.byKey(const ValueKey('review-summary')), findsOneWidget);
    });

    testWidgets('cihaz desteklemiyorsa "Dinle ve söyle" gelmez', (
      tester,
    ) async {
      await seed(tester);
      await pump(tester, FakeSpeechRecognizer(supported: false));
      await settle(tester);
      expect(find.byKey(const ValueKey('task-speak')), findsNothing);
      expect(find.byKey(const ValueKey('task-self_check')), findsOneWidget);
      expect(find.byKey(const ValueKey('review-speak-mic')), findsNothing);
    });
  });
}
