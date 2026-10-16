import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/talk/presentation/talk_screen.dart';
import 'package:hivelzon/features/talk/presentation/talk_task_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/speech/example_speech.dart';
import 'package:hivelzon/shared/speech/fake_speech_recognizer.dart';
import 'package:hivelzon/shared/speech/speech_providers.dart';
import 'package:hivelzon/shared/speech/speech_recognizer_port.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import 'fake_content_source.dart';
import 'fake_example_speech.dart';

/// Konuş testlerinin ortamı (H-090): bellekte veritabanı, sahte içerik
/// (gerçek `talk.json` kopyası), bitmiş bölümler, sahte tanıyıcı ve cihaz
/// sesi. [speech]: "Söyle" görünür mü (cihazda tanıma + izin).
class TalkHarness {
  TalkHarness({
    this.completed = const ['A1-001', 'A1-002', 'A1-003'],
    this.speech = false,
    List<String> script = const ['full'],
    SpeechPermission permission = SpeechPermission.granted,
    bool deviceVoice = true,
  }) : recognizer = FakeSpeechRecognizer(
         script: script,
         permission: permission,
       ),
       voice = FakeExampleSpeech(hasVoice: deviceVoice);

  final List<String> completed;
  final bool speech;
  final FakeSpeechRecognizer recognizer;
  final FakeExampleSpeech voice;
  final db = AppDatabase.memory();
  final source = FakeContentSource(packageIds: const ['A1-001', 'A1-002']);
  final progress = InMemoryProgressRepository();
  late GoRouter router;

  Future<void> dispose() => db.close();

  /// Bölüm bitince defterine giren hedef ifadeler (kanıt için).
  Future<void> addTargets(List<String> phrases) => NotebookStore(db).addItems([
    for (final p in phrases)
      NotebookItem(
        kind: wordCount(p) > 1 ? NotebookKind.phrase : NotebookKind.word,
        textEn: p,
        textTr: '…',
        source: NotebookSource.autoTargetPhrase,
        contentId: 'A1-002',
      ),
  ]);

  Future<void> pump(
    WidgetTester tester,
    String location, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.runAsync(() async {
      for (final id in completed) {
        await progress.markCompleted(id, gate: const {});
      }
    });
    router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(path: '/konus', builder: (_, _) => const TalkScreen()),
        GoRoute(
          path: '/konusma/:id',
          builder: (_, s) => TalkTaskScreen(taskId: s.pathParameters['id']!),
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
          speechRecognizerProvider.overrideWithValue(recognizer),
          speechVisibleProvider.overrideWithValue(speech),
          exampleSpeechProvider.overrideWithValue(voice as ExampleSpeech),
        ],
        child: RepaintBoundary(
          key: const ValueKey('golden'),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      ),
    );
    await settle(tester);
  }

  Future<void> settle(WidgetTester tester, {int rounds = 25}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  /// Tembel listede henüz kurulmamış öğeye kaydırır.
  Future<void> scrollTo(WidgetTester tester, Finder f) async {
    if (f.evaluate().isNotEmpty) return;
    await tester.scrollUntilVisible(
      f,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
  }

  Future<void> tap(WidgetTester tester, String key) async {
    final f = find.byKey(ValueKey(key));
    await scrollTo(tester, f);
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await settle(tester);
  }
}
