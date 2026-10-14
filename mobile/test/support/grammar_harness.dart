import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/grammar/application/grammar_providers.dart';
import 'package:hivelzon/features/grammar/presentation/grammar_lesson_screen.dart';
import 'package:hivelzon/features/library/application/book_audio.dart';
import 'package:hivelzon/features/library/application/library_providers.dart';
import 'package:hivelzon/features/library/presentation/reader_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/story/presentation/story_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/speech/example_speech.dart';
import 'package:hivelzon/shared/speech/speech_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import 'fake_book_audio.dart';
import 'fake_content_source.dart';
import 'fake_example_speech.dart';

/// Dilbilgisi testlerinin ortamı (H-078): bellekte veritabanı, sahte içerik
/// (deneme dersi G-A1-99 kopyaları, deneme kitabı A1-K99, bölüm A1-001),
/// sahte ders ve kitap sesi, elle ilerletilen saat. Oynatıcı yerine
/// açılışını yazan bir yer tutucu sayfa vardır (`play:<bölüm>:<biçim>`).
class GrammarHarness {
  GrammarHarness({
    List<String> lessonIds = const [kTestLessonId],
    Map<String, String> titles = const {},
    Map<String, List<String>> topics = const {
      'A1-001': [kTestLessonId],
      'A1-K99': [kTestLessonId],
    },
    List<String> bookIds = const ['A1-K99'],
    bool silent = false,
    bool noEnglishAudio = false,
    bool grammarFails = false,
    String? episodeLink,
    this.suggestedLevel,
    bool deviceVoice = false,
  }) : speech = FakeExampleSpeech(hasVoice: deviceVoice),
       db = AppDatabase.memory(),
       source = FakeContentSource(packageIds: const ['A1-001'])
         ..books = testBookSummaries(bookIds, grammarTopics: topics)
         ..grammarTopics = topics
         ..lessons = testLessonSummaries(lessonIds, titles: titles)
         ..lessonsSilent = silent
         ..lessonsNoEnglishAudio = noEnglishAudio
         ..grammarFails = grammarFails
         ..lessonEpisodeLink = episodeLink {
    audio = FakeBookAudio(clock);
    bookAudio = FakeBookAudio(
      clock,
      durations: const {'c1.m4a': 11.3, 'c2.m4a': 7.0},
    );
  }

  final AppDatabase db;

  /// Cihaz sesi (H-064); varsayılan: cihazda İngilizce ses yok.
  final FakeExampleSpeech speech;
  final FakeContentSource source;
  final clock = ReaderTestClock();
  final progress = InMemoryProgressRepository();
  late final FakeBookAudio audio;
  late final FakeBookAudio bookAudio;
  final String? suggestedLevel;
  late GoRouter router;

  /// Oynatıcı yer tutucusunun açılışları (`A1-001:null`).
  final List<String> played = [];

  Future<void> dispose() => db.close();

  /// Uygulamayı [location]'da açar. Yollar: `/hikaye`, `/dilbilgisi/:id`,
  /// `/kitap/:id`, `/play/:id`.
  Future<void> pump(
    WidgetTester tester,
    String location, {
    Size size = const Size(390, 844),
    double textScale = 1,
    bool reduceMotion = false,
    bool speech = false,
  }) async {
    tester.view.physicalSize = size * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    if (reduceMotion) {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
    }
    await tester.runAsync(() async {
      await db
          .into(db.seasonState)
          .insertOnConflictUpdate(
            SeasonStateCompanion.insert(
              seasonId: const Value(1),
              introSeen: const Value(true),
            ),
          );
      if (suggestedLevel != null) {
        await db
            .into(db.appMeta)
            .insertOnConflictUpdate(
              AppMetaCompanion.insert(
                key: 'placement.suggestedLevel',
                value: suggestedLevel!,
              ),
            );
      }
    });
    router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(path: '/hikaye', builder: (_, _) => const StoryScreen()),
        GoRoute(
          path: '/dilbilgisi/:id',
          builder: (_, s) => GrammarLessonScreen(
            lessonIds: [
              s.pathParameters['id']!,
              for (final x in (s.uri.queryParameters['sonra'] ?? '').split(','))
                if (x.isNotEmpty) x,
            ],
            continueKind: GrammarContinue.parse(s.uri.queryParameters['devam']),
          ),
        ),
        GoRoute(
          path: '/kitap/:bookId',
          builder: (_, s) => ReaderScreen(
            key: ValueKey(s.pathParameters['bookId']),
            bookId: s.pathParameters['bookId']!,
            listen: s.uri.queryParameters['mod'] != 'oku',
            startPage: s.uri.queryParameters['sayfa'],
            startSentence: s.uri.queryParameters['cumle'],
          ),
        ),
        GoRoute(
          path: '/play/:contentId',
          builder: (_, s) {
            final id =
                '${s.pathParameters['contentId']}:'
                '${s.uri.queryParameters['mode']}';
            played.add(id);
            return Scaffold(body: Center(child: Text('play:$id')));
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(source),
          progressRepositoryProvider.overrideWithValue(progress),
          learningEventLogProvider.overrideWithValue(
            InMemoryLearningEventLog(),
          ),
          grammarAudioFactoryProvider.overrideWithValue(
            () => audio as BookAudio,
          ),
          grammarClockProvider.overrideWithValue(clock.call),
          bookAudioFactoryProvider.overrideWithValue(
            () => bookAudio as BookAudio,
          ),
          readerClockProvider.overrideWithValue(clock.call),
          libraryRandomProvider.overrideWithValue(math.Random(3)),
          speechVisibleProvider.overrideWithValue(speech),
          exampleSpeechProvider.overrideWithValue(this.speech as ExampleSpeech),
        ],
        child: RepaintBoundary(
          key: const ValueKey('golden'),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            routerConfig: router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  /// Veritabanı ve sahte gelecekler çözülsün.
  Future<void> settle(WidgetTester tester, {int rounds = 30}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  /// Ses çalarken [seconds] kadar zaman geçer (saat ve zamanlayıcı birlikte).
  Future<void> listenFor(WidgetTester tester, double seconds) async {
    final steps = (seconds / 0.05).round();
    for (var i = 0; i < steps; i++) {
      clock.advance(0.05);
      await tester.pump(const Duration(milliseconds: 50));
    }
    await settle(tester, rounds: 3);
  }

  /// Ders ekranında [n] kart ilerler ("Devam et").
  Future<void> next(WidgetTester tester, [int n = 1]) async {
    for (var i = 0; i < n; i++) {
      await tester.tap(find.byKey(const ValueKey('lesson-next')));
      await settle(tester, rounds: 20);
    }
  }
}
