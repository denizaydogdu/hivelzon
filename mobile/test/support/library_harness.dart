import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/library/application/background_book_audio.dart';
import 'package:hivelzon/features/library/application/book_audio.dart';
import 'package:hivelzon/features/library/application/library_providers.dart';
import 'package:hivelzon/features/library/presentation/reader_screen.dart';
import 'package:hivelzon/features/notebook/presentation/notebook_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/story/presentation/story_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/speech/speech_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import 'fake_audio_session.dart';
import 'fake_book_audio.dart';
import 'fake_content_source.dart';

/// Kitaplık ve okuyucu testlerinin ortamı (H-067): bellekte veritabanı,
/// sahte içerik (deneme kitabı A1-K99 kopyaları), sahte kitap sesi ve elle
/// ilerletilen saat.
class LibraryHarness {
  LibraryHarness({
    List<String> bookIds = const ['A1-K99'],
    this.suggestedLevel,
    bool booksFail = false,
    Set<String> unnarrated = const {},
    Set<String> withoutTurkish = const {},
    this.background = false,
  }) : db = AppDatabase.memory(),
       source = FakeContentSource(packageIds: const ['A1-001'])
         ..books = testBookSummaries(bookIds)
         ..booksFail = booksFail
         ..unnarratedChapters = unnarrated
         ..withoutTurkish = withoutTurkish {
    audio = FakeBookAudio(
      clock,
      durations: const {'c1.m4a': 11.3, 'c2.m4a': 7.0},
    );
    engine = FakeAudioEngine(
      clock,
      durations: const {'c1.m4a': 11.3, 'c2.m4a': 7.0},
    );
  }

  /// H-068: okuyucu gerçek arka plan bağdaştırıcısıyla (`BackgroundBookAudio`)
  /// açılır; altında sahte motor ([engine]) ve sahte oturum ([session]).
  final bool background;
  late final FakeAudioEngine engine;
  final session = FakeSessionHost();

  /// Son açılan arka plan sesi.
  BackgroundBookAudio? backgroundAudio;

  BookAudio _makeAudio() {
    if (!background) return audio;
    return backgroundAudio = BackgroundBookAudio(
      engine: engine,
      host: session,
      pauseStateDelay: Duration.zero,
    );
  }

  final AppDatabase db;
  final FakeContentSource source;
  final clock = ReaderTestClock();
  late final FakeBookAudio audio;
  final String? suggestedLevel;
  late GoRouter router;

  Future<void> dispose() async {
    await session.close();
    await db.close();
  }

  /// Uygulamayı [location]'da açar. Yollar: `/hikaye`, `/kitap/:id`,
  /// `/defter`.
  Future<void> pump(
    WidgetTester tester,
    String location, {
    Size size = const Size(390, 844),
    double textScale = 1,
    bool reduceMotion = false,
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
    // Sezon jeneriği izlenmiş olsun (harita açılınca kendiliğinden oynamasın).
    await tester.runAsync(
      () => db
          .into(db.seasonState)
          .insertOnConflictUpdate(
            SeasonStateCompanion.insert(
              seasonId: const Value(1),
              introSeen: const Value(true),
            ),
          ),
    );
    if (suggestedLevel != null) {
      await tester.runAsync(
        () => db
            .into(db.appMeta)
            .insertOnConflictUpdate(
              AppMetaCompanion.insert(
                key: 'placement.suggestedLevel',
                value: suggestedLevel!,
              ),
            ),
      );
    }
    router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(path: '/hikaye', builder: (_, _) => const StoryScreen()),
        GoRoute(
          path: '/kitap/:bookId',
          builder: (_, s) => ReaderScreen(
            key: ValueKey(s.pathParameters['bookId']),
            bookId: s.pathParameters['bookId']!,
            listen: s.uri.queryParameters['mod'] != 'oku',
          ),
        ),
        GoRoute(path: '/defter', builder: (_, _) => const NotebookScreen()),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(source),
          progressRepositoryProvider.overrideWithValue(
            InMemoryProgressRepository(),
          ),
          learningEventLogProvider.overrideWithValue(
            InMemoryLearningEventLog(),
          ),
          bookAudioFactoryProvider.overrideWithValue(_makeAudio),
          readerClockProvider.overrideWithValue(clock.call),
          libraryRandomProvider.overrideWithValue(math.Random(3)),
          speechVisibleProvider.overrideWithValue(false),
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

  /// Okuyucu çalarken [seconds] kadar zaman geçer (saat ve zamanlayıcı
  /// birlikte, 50 ms adımlarla).
  Future<void> listenFor(WidgetTester tester, double seconds) async {
    final steps = (seconds / 0.05).round();
    for (var i = 0; i < steps; i++) {
      clock.advance(0.05);
      await tester.pump(const Duration(milliseconds: 50));
    }
    await settle(tester, rounds: 3);
  }
}
