import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/player/data/drift_progress_repository.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/features/player/presentation/widgets/decision_sheet.dart';
import 'package:hivelzon/features/player/presentation/widgets/end_view.dart';
import 'package:hivelzon/features/profile/presentation/profile_screen.dart';
import 'package:hivelzon/features/speak/speak_env.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/meaning/meaning_controller.dart';
import 'package:hivelzon/shared/meaning/meaning_sheet.dart';
import 'package:hivelzon/shared/meaning/meaning_text.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';
import 'package:hivelzon/shared/speech/fake_speech_recognizer.dart';
import 'package:hivelzon/shared/speech/speak_widgets.dart';
import 'package:hivelzon/shared/speech/speech_match.dart';
import 'package:hivelzon/shared/speech/speech_providers.dart';
import 'package:hivelzon/shared/speech/speech_recognizer_port.dart';
import 'package:hivelzon/shared/speech/speech_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../../support/fake_content_source.dart';
import '../../support/fixtures.dart';

SpeakEnv _env(
  FakeSpeechRecognizer r,
  List<SpeechAttempt> log, {
  bool ready = true,
}) => SpeakEnv(recognizer: r, ensureReady: (_) async => ready, record: log.add);

Future<void> _pump(WidgetTester tester, Widget child, {double h = 4000}) async {
  tester.view.physicalSize = Size(1179, h);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('anlam paneli: "Sen de söyle"', () {
    const text = MeaningText(
      contentId: 'A1-001',
      sourceId: 'k1-ok-01',
      en: 'Yes, I can hear you.',
      words: [
        MeaningWord('Yes,', gloss: 'evet'),
        MeaningWord('I', gloss: 'ben'),
        MeaningWord('can', gloss: '-ebilmek'),
        MeaningWord('hear', gloss: 'duymak'),
        MeaningWord('you.', gloss: 'seni'),
      ],
    );

    MeaningController controller(InMemoryLearningEventLog events) =>
        MeaningController(
          text: text,
          audio: const SilentMeaningAudio(),
          events: events,
          notebook: InMemoryNotebookRepository(),
        );

    testWidgets('tanıma yoksa düğme yok', (tester) async {
      await _pump(
        tester,
        MeaningSheet(controller: controller(InMemoryLearningEventLog())),
      );
      expect(find.text('Tekrar dinle'), findsOneWidget);
      expect(find.text('Sen de söyle'), findsNothing);
    });

    testWidgets('tam → "Söyledin!"; yakın → eksik kelime; tekrara işlenmez', (
      tester,
    ) async {
      final r = FakeSpeechRecognizer()
        ..queued.add(['yes I can you'])
        ..queued.add(['yes I can hear you']);
      final log = <SpeechAttempt>[];
      final events = InMemoryLearningEventLog();
      await _pump(
        tester,
        MeaningSheet(controller: controller(events), speak: _env(r, log)),
      );
      expect(find.text('Sen de söyle'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('meaning-speak-mic')));
      await tester.pumpAndSettle();
      expect(
        find.text('Neredeyse! Şu kelimeyi duyamadım: hear'),
        findsOneWidget,
      );
      expect(find.text('Bir daha söyle'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('meaning-speak-mic')));
      await tester.pumpAndSettle();
      expect(find.text('Söyledin!'), findsOneWidget);
      expect(find.byKey(const ValueKey('meaning-speak-mic')), findsNothing);
      expect(log.map((a) => a.level), [
        SpeechMatchLevel.close,
        SpeechMatchLevel.full,
      ]);
      expect(log.every((a) => a.place == SpeechPlace.meaning), isTrue);
      expect(log.first.itemRef, 'Yes, I can hear you.');
      // Anlam olayı (bakma) yazılmaz; FSRS yok.
      expect(events.events, isEmpty);
    });

    testWidgets('2 denemeden sonra metin ve sakin dil; puan yok', (
      tester,
    ) async {
      final r = FakeSpeechRecognizer(script: const ['no']);
      await _pump(
        tester,
        MeaningSheet(
          controller: controller(InMemoryLearningEventLog()),
          speak: _env(r, []),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('meaning-speak-mic')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Bir daha dene.'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('meaning-speak-mic')));
      await tester.pumpAndSettle();
      expect(find.text('Sorun değil. İfade şöyle:'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('meaning-speak-reveal')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('meaning-speak-mic')), findsNothing);
      expect(r.listens, 2);
      expect(find.textContaining('%'), findsNothing);
      expect(find.textContaining('anlış'), findsNothing);
    });

    testWidgets('sessizlik: "Seni duyamadım"', (tester) async {
      final r = FakeSpeechRecognizer(script: const ['silence']);
      await _pump(
        tester,
        MeaningSheet(
          controller: controller(InMemoryLearningEventLog()),
          speak: _env(r, []),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('meaning-speak-mic')));
      await tester.pumpAndSettle();
      expect(find.text('Seni duyamadım. Bir daha dene.'), findsOneWidget);
    });

    testWidgets('izin verilmezse dinlenmez', (tester) async {
      final r = FakeSpeechRecognizer();
      await _pump(
        tester,
        MeaningSheet(
          controller: controller(InMemoryLearningEventLog()),
          speak: _env(r, [], ready: false),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('meaning-speak-mic')));
      await tester.pumpAndSettle();
      expect(r.listens, 0);
    });
  });

  group('karar anı: "Söyleyerek seç"', () {
    final ep = loadFixture('A1-001');
    final k1 = ep.nodes['k1']! as DecisionNode;

    Future<List<DecisionOption>> pumpSheet(
      WidgetTester tester, {
      SpeakEnv? speak,
      DecisionNode? node,
    }) async {
      final chosen = <DecisionOption>[];
      await _pump(
        tester,
        SingleChildScrollView(
          child: DecisionSheet(
            node: node ?? k1,
            onChoose: chosen.add,
            onListen: (_) {},
            onHint: null,
            speak: speak,
            contentId: 'A1-001',
          ),
        ),
      );
      return chosen;
    }

    testWidgets('tanıma yoksa mikrofon yok', (tester) async {
      await pumpSheet(tester);
      expect(find.text('Söyleyerek seç'), findsNothing);
    });

    testWidgets('söylenen seçenek seçilir (dokunmakla aynı)', (tester) async {
      final r = FakeSpeechRecognizer()..queued.add(['yes I can hear you']);
      final log = <SpeechAttempt>[];
      final chosen = await pumpSheet(tester, speak: _env(r, log));
      await tester.tap(find.byKey(const ValueKey('speak-choose-mic')));
      await tester.pumpAndSettle();
      expect(chosen.single.id, 'a');
      expect(log.single.itemRef, 'k1#a');
      expect(log.single.level, SpeechMatchLevel.full);
    });

    testWidgets('yanlış seçenek söylenirse o seçilir (tepki akışı)', (
      tester,
    ) async {
      final r = FakeSpeechRecognizer()..queued.add(["yes I'm"]);
      final chosen = await pumpSheet(tester, speak: _env(r, []));
      await tester.tap(find.byKey(const ValueKey('speak-choose-mic')));
      await tester.pumpAndSettle();
      expect(chosen.single.id, 'b');
      expect(chosen.single.correct, isFalse);
    });

    testWidgets('belirsiz/eşleşmez: seçilmez, dokunarak seçme önerilir', (
      tester,
    ) async {
      final r = FakeSpeechRecognizer(script: const ['banana tree']);
      final log = <SpeechAttempt>[];
      final chosen = await pumpSheet(tester, speak: _env(r, log));
      await tester.tap(find.byKey(const ValueKey('speak-choose-mic')));
      await tester.pumpAndSettle();
      expect(chosen, isEmpty);
      expect(
        find.text('Seni tam duyamadım. İstersen dokunarak seç.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('speak-choose-mic')));
      await tester.pumpAndSettle();
      expect(chosen, isEmpty);
      expect(find.byKey(const ValueKey('speak-choose-mic')), findsNothing);
      expect(find.text('Dokunarak seçebilirsin.'), findsOneWidget);
      expect(log.map((a) => a.level), everyElement(SpeechMatchLevel.no));
      // Dokunarak seçmek hep çalışır.
      await tester.tap(find.byKey(const ValueKey('option-a')));
      expect(chosen.single.id, 'a');
    });

    testWidgets('Türkçe seçenekli kararda mikrofon yok', (tester) async {
      final b3 = loadFixture('A1-003');
      await pumpSheet(
        tester,
        node: b3.nodes['k2']! as DecisionNode,
        speak: _env(FakeSpeechRecognizer(), []),
      );
      expect(find.text('Söyleyerek seç'), findsNothing);
    });
  });

  group('bölüm sonu: "Hedef ifadeleri söyle"', () {
    testWidgets('tanıma yoksa bölüm yok', (tester) async {
      await _pump(
        tester,
        EndView(engine: EpisodeEngine(loadFixture('A1-001')), onBack: () {}),
      );
      expect(find.text('HEDEF İFADELERİ SÖYLE'), findsNothing);
    });

    testWidgets('bir ifadeyi tam söylemek kapı ölçütünü bildirir', (
      tester,
    ) async {
      final r = FakeSpeechRecognizer(script: const ['close', 'full']);
      var spoken = 0;
      final log = <SpeechAttempt>[];
      await _pump(
        tester,
        EndView(
          engine: EpisodeEngine(loadFixture('A1-001')),
          onBack: () {},
          speak: _env(r, log),
          onSpokenTarget: () => spoken++,
        ),
      );
      expect(find.text('HEDEF İFADELERİ SÖYLE'), findsOneWidget);
      final mic = find.byKey(const ValueKey('end-speak-0-mic'));
      await tester.ensureVisible(mic);
      await tester.tap(mic);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(spoken, 0);
      await tester.tap(mic);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(spoken, 1);
      expect(find.text('Söyledin!'), findsOneWidget);
      expect(log.first.place, SpeechPlace.episodeEnd);
      expect(log.first.contentId, 'A1-001');
    });

    test(
      'söylenen hedef ifade kapının targetPhrase ölçütünü karşılar',
      () async {
        final mem = InMemoryProgressRepository();
        await mem.addGateItem('A1-001', GateItem.targetPhrase, 'speak#end');
        expect(
          (await mem.loadAll())['A1-001']!.gateItems,
          contains(GateItem.targetPhrase),
        );

        final db = AppDatabase.memory();
        addTearDown(db.close);
        final drift = DriftProgressRepository(db);
        await drift.markCompleted(
          'A1-001',
          gate: const {
            GateItem.comprehension: {'t-gorev'},
            GateItem.activeTask: {'t-kanit'},
          },
        );
        final before = (await drift.loadAll())['A1-001']!;
        expect(before.gateItems, isNot(contains(GateItem.targetPhrase)));
        await drift.addGateItem('A1-001', GateItem.targetPhrase, 'speak#end');
        await drift.addGateItem('A1-001', GateItem.targetPhrase, 'speak#end');
        final after = (await drift.loadAll())['A1-001']!;
        expect(after.gateItems, contains(GateItem.targetPhrase));
        expect(after.status, StoryStatus.completed);
        expect(after.completedAt, before.completedAt);
        expect(await db.select(db.gateProgress).get(), hasLength(3));
      },
    );
  });

  group('izin akışı ve Profil', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    Future<ProviderContainer> pumpWith(
      WidgetTester tester,
      FakeSpeechRecognizer r,
      Widget child,
    ) async {
      tester.view.physicalSize = const Size(1179, 4000);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(FakeContentSource()),
          progressRepositoryProvider.overrideWithValue(
            InMemoryProgressRepository(),
          ),
          speechRecognizerProvider.overrideWithValue(r),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(body: child),
          ),
        ),
      );
      return container;
    }

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 15; i++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    /// Sağlayıcı test bölgesinde çalışır: okumayı başlat, kareleri ilerlet.
    Future<SpeechStatus?> status(
      WidgetTester tester,
      ProviderContainer c,
    ) async {
      c.read(speechStatusProvider.future).ignore();
      await settle(tester);
      return c.read(speechStatusProvider).value;
    }

    testWidgets('ilk kullanım: önce Türkçe açıklama, sonra sistem izni', (
      tester,
    ) async {
      final r = FakeSpeechRecognizer(permission: SpeechPermission.notAsked);
      bool? result;
      final c = await pumpWith(
        tester,
        r,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await ensureSpeechReady(
                context,
                ProviderScope.containerOf(context),
              );
            },
            child: const Text('go'),
          ),
        ),
      );
      expect(await status(tester, c), SpeechStatus.needsPermission);
      await tester.tap(find.text('go'));
      await settle(tester);
      expect(find.byKey(const ValueKey('speech-permission-sheet')), findsOne);
      expect(
        find.textContaining('kaydedilmez, hiçbir yere gönderilmez'),
        findsOneWidget,
      );
      expect(r.permissionRequests, 0, reason: 'açıklamadan önce sorulmaz');
      await tester.tap(
        find.byKey(const ValueKey('speech-permission-continue')),
      );
      await settle(tester);
      expect(r.permissionRequests, 1);
      expect(result, isTrue);
      expect(await status(tester, c), SpeechStatus.ready);
    });

    testWidgets('"Şimdi değil": sistem izni sorulmaz', (tester) async {
      final r = FakeSpeechRecognizer(permission: SpeechPermission.notAsked);
      bool? result;
      await pumpWith(
        tester,
        r,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await ensureSpeechReady(
              context,
              ProviderScope.containerOf(context),
            ),
            child: const Text('go'),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('speech-permission-later')));
      await settle(tester);
      expect(result, isFalse);
      expect(r.permissionRequests, 0);
    });

    testWidgets('izin reddedilirse "Söyle" gizlenir', (tester) async {
      final r = FakeSpeechRecognizer(
        permission: SpeechPermission.notAsked,
        grantOnRequest: false,
      );
      final c = await pumpWith(
        tester,
        r,
        Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                ensureSpeechReady(context, ProviderScope.containerOf(context)),
            child: const Text('go'),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await settle(tester);
      await tester.tap(
        find.byKey(const ValueKey('speech-permission-continue')),
      );
      await settle(tester);
      expect(await status(tester, c), SpeechStatus.denied);
      expect(c.read(speechVisibleProvider), isFalse);
      expect(
        find.text('İzin verilmedi. Her şey dokunarak çalışmaya devam eder.'),
        findsOneWidget,
      );
    });

    testWidgets('Profil: destek yoksa açıklama, anahtar yok', (tester) async {
      await pumpWith(
        tester,
        FakeSpeechRecognizer(supported: false),
        const ProfileScreen(),
      );
      await settle(tester);
      expect(find.text('Söyle alıştırmaları'), findsOneWidget);
      expect(find.text('Kapalı'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('profile-speech-unsupported')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('profile-speech-toggle')), findsNothing);
    });

    testWidgets('Profil: aç/kapat (varsayılan açık) + gizlilik satırı', (
      tester,
    ) async {
      final c = await pumpWith(
        tester,
        FakeSpeechRecognizer(),
        const ProfileScreen(),
      );
      await settle(tester);
      final toggle = find.byKey(const ValueKey('profile-speech-toggle'));
      Switch switchOf() => tester.widget<Switch>(
        find.descendant(of: toggle, matching: find.byType(Switch)),
      );
      expect(switchOf().value, isTrue);
      expect(
        find.text(
          'Sesin bu telefonda yazıya çevrilir; kaydedilmez, hiçbir yere '
          'gönderilmez.',
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(toggle);
      await tester.tap(toggle);
      await settle(tester);
      expect(await status(tester, c), SpeechStatus.switchedOff);
      expect(c.read(speechVisibleProvider), isFalse);
      expect(switchOf().value, isFalse);
    });

    testWidgets('Profil: izin kapalıysa nedeni yazar', (tester) async {
      await pumpWith(
        tester,
        FakeSpeechRecognizer(permission: SpeechPermission.denied),
        const ProfileScreen(),
      );
      await settle(tester);
      expect(find.byKey(const ValueKey('profile-speech-denied')), findsOne);
    });
  });

  test('speech_attempts sütunları: transkript ya da ses alanı yok', () {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final cols = db.speechAttempts.$columns.map((c) => c.name).toSet();
    expect(cols, {
      'id',
      'place',
      'content_id',
      'item_ref',
      'match_level',
      'missing_count',
      'error_note_id',
      'at',
      // H-038: eşitleme kimliği (UUID); ses ya da yazı değil.
      'client_id',
    });
  });
}
