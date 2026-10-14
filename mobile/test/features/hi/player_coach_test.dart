import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/hi/data/hi_store.dart';
import 'package:hivelzon/features/hi/domain/hi_content.dart';
import 'package:hivelzon/features/player/application/player_session.dart';
import 'package:hivelzon/features/player/application/segment_player_pool.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/presentation/player_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';

/// Bellek içi koç: Drift'i sahte zamanlı widget testinden uzak tutar.
class _MemoryCoach implements PlayerCoach {
  final Set<String> seen = {};

  /// Konu kartlarına verilecek Hi sesi (H-083; fixture'da ses yok).
  String? introAudio;

  TopicIntro _withAudio(TopicIntro t) => introAudio == null
      ? t
      : TopicIntro(
          id: t.id,
          contentId: t.contentId,
          node: t.node,
          cue: t.cue,
          titleEn: t.titleEn,
          linesTr: t.linesTr,
          exampleEn: t.exampleEn,
          exampleTr: t.exampleTr,
          audio: introAudio,
        );

  @override
  Future<EpisodeCoaching> forEpisode(String contentId) async {
    final hi = loadHiFixture();
    return EpisodeCoaching(
      introsByNode: {
        for (final t in hi.topicIntros)
          if (t.contentId == contentId && !seen.contains(t.id))
            t.node: _withAudio(t),
      },
      decisionErrors: {
        for (final d in hi.decisionErrors)
          if (d.contentId == contentId) d.sourceId: d.errorType,
      },
    );
  }

  @override
  Future<void> markTopicSeen(String topicId) async => seen.add(topicId);
}

/// Hi sesi için kayıtlı denetleyici (platforma gitmez).
class _ClipController extends VideoPlayerController {
  _ClipController(super.uri) : super.networkUrl();

  bool played = false;
  bool disposed = false;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> play() async => played = true;

  @override
  Future<void> dispose() async {
    disposed = true;
    await super.dispose();
  }
}

void main() {
  late AppDatabase db;
  late HiStore store;
  late _MemoryCoach coach;
  late InMemoryLearningEventLog events;

  setUp(() {
    db = AppDatabase.memory();
    store = HiStore(db);
    events = InMemoryLearningEventLog();
    coach = _MemoryCoach();
    VideoPlayerPlatform.instance = FakeVideoPlatform(
      durationFor: (uri) => uri.endsWith('.m4a')
          ? const Duration(milliseconds: 500)
          : const Duration(seconds: 1),
    );
  });
  tearDown(() => db.close());

  Future<void> step(WidgetTester tester, [int ms = 1200]) async {
    for (var i = 0; i < ms ~/ 100; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> pumpPlayer(
    WidgetTester tester, {
    VideoControllerFactory? factory,
  }) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentSourceProvider.overrideWithValue(FakeContentSource()),
          progressRepositoryProvider.overrideWithValue(
            InMemoryProgressRepository(),
          ),
          learningEventLogProvider.overrideWithValue(events),
          notebookRepositoryProvider.overrideWithValue(
            InMemoryNotebookRepository(),
          ),
          playerHooksProvider.overrideWithValue(null),
          playerCoachProvider.overrideWithValue(coach),
          if (factory != null)
            videoControllerFactoryProvider.overrideWithValue(factory),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: PlayerScreen(
              contentId: 'A1-001',
              startMode: PlayerStartMode.restart,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'konu kartı: s02 bitince (başlıktan sonra) bir kez; kapanınca karar gelir; '
    'yanlış seçim hata türüyle yazılır',
    (tester) async {
      await pumpPlayer(tester);
      await step(tester, 300);
      // Başlık ekranında kart yok.
      expect(find.text('SEZON 1 · BÖLÜM 1'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('topic-intro-can-questions')),
        findsNothing,
      );
      await step(tester, 1500); // başlık → s02
      await step(tester, 1500); // s02 biter

      expect(
        find.byKey(const ValueKey('topic-intro-can-questions')),
        findsOneWidget,
      );
      expect(find.text('Can you…?'), findsOneWidget);
      expect(find.text('Can you hear me?'), findsOneWidget);
      expect(find.text('Ne dersin?'), findsNothing); // karar beklemede
      // Kart cevabı vermez.
      expect(find.textContaining('Yes, I can'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('topic-intro-continue')));
      await step(tester, 300);
      expect(find.text('Ne dersin?'), findsOneWidget);
      expect(coach.seen, {'can-questions'});

      // Yanlış seçim → öğrenme olayı (verb_form, k1#b).
      await tester.tap(find.byKey(const ValueKey('option-b')));
      await step(tester, 300);
      final e = events.events.single;
      expect(e.errorType, ErrorType.verbForm);
      expect(e.sourceId, 'k1#b');
      expect(e.contentId, 'A1-001');
      await tester.pumpWidget(const SizedBox());
      await step(tester, 1500);
    },
  );

  testWidgets('konu kartının Hi sesi oturumun çalarıyla çalar; kart kapanınca '
      'durur (H-083)', (tester) async {
    coach.introAudio = 'hi/intro-can-questions.m4a';
    final clips = <_ClipController>[];
    await pumpPlayer(
      tester,
      // Videolar sahte platformda; Hi sesi kayıtlı denetleyicide.
      factory: (uri) {
        if (!uri.path.endsWith('.m4a')) {
          return VideoPlayerController.networkUrl(uri);
        }
        final c = _ClipController(uri);
        clips.add(c);
        return c;
      },
    );
    await step(tester, 300);
    await step(tester, 1500);
    await step(tester, 1500);
    expect(
      find.byKey(const ValueKey('topic-intro-can-questions')),
      findsOneWidget,
    );
    expect(clips, isEmpty, reason: 'kendiliğinden çalmaz');
    await tester.tap(find.byKey(const ValueKey('hi-listen')));
    await step(tester, 200);
    expect(
      clips.single.dataSource,
      'http://test.invalid/_season/S1/hi/intro-can-questions.m4a',
    );
    expect(clips.single.played, isTrue);

    await tester.tap(find.byKey(const ValueKey('topic-intro-continue')));
    await step(tester, 100);
    expect(clips.single.disposed, isTrue);
    await tester.pumpWidget(const SizedBox());
    await step(tester, 1500);
  });

  testWidgets('görülmüş konu kartı yeniden gösterilmez', (tester) async {
    coach.seen.add('can-questions');
    await pumpPlayer(tester);
    await step(tester, 300);
    await step(tester, 1500);
    await step(tester, 1500);
    expect(
      find.byKey(const ValueKey('topic-intro-can-questions')),
      findsNothing,
    );
    expect(find.text('Ne dersin?'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await step(tester, 1500);
  });

  test('HiPlayerCoach: görülmemiş kartlar ve karar eşlemesi (Drift)', () async {
    final c = HiPlayerCoach(store, () async => loadHiFixture());
    var b4 = await c.forEpisode('A1-004');
    expect(b4.introsByNode.keys, ['k1-ok']);
    expect(b4.decisionErrors['k2#b'], ErrorType.preposition);
    await c.markTopicSeen('time');
    b4 = await c.forEpisode('A1-004');
    expect(b4.introsByNode, isEmpty);
    expect((await c.forEpisode('A1-001')).introsByNode.keys, ['s02', 's05']);
  });
}
