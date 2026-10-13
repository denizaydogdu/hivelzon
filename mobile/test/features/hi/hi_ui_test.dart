import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/features/hi/data/hi_store.dart';
import 'package:hivelzon/features/hi/presentation/hi_bubble.dart';
import 'package:hivelzon/features/player/data/drift_progress_repository.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/speech/speech_match.dart';
import 'package:hivelzon/shared/speech/speech_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';

void main() {
  late AppDatabase db;
  late HiStore store;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase.memory();
    store = HiStore(db);
    VideoPlayerPlatform.instance = FakeVideoPlatform(
      durationFor: (_) => const Duration(seconds: 30),
    );
  });
  tearDown(() => db.close());

  Future<void> settle(WidgetTester tester, [int frames = 20]) async {
    for (var i = 0; i < frames; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> pumpApp(WidgetTester tester, {double height = 2556}) async {
    tester.view.physicalSize = Size(1179, height);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(
            FakeContentSource(realSubtitles: true),
          ),
          seasonIntroRepositoryProvider.overrideWithValue(
            InMemorySeasonIntroRepository(),
          ),
        ],
        child: const HiVelzonApp(),
      ),
    );
    container = ProviderScope.containerOf(
      tester.element(find.byType(HiVelzonApp)),
    );
    await settle(tester);
  }

  /// Tembel listede öğeyi görünür yapar ([list]: listenin anahtarı).
  Future<void> reveal(WidgetTester tester, Finder f, String list) async {
    await tester.dragUntilVisible(
      f,
      find.byKey(ValueKey(list)),
      const Offset(0, -200),
    );
    await settle(tester, 4);
  }

  void go(String route) => container.read(routerProvider).go(route);

  Future<void> openPanel(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('hi-bubble')));
    await settle(tester, 30);
  }

  test('balon yolları: yalnızca beş sekmenin kökü', () {
    for (final p in ['/', '/kesfet', '/hikaye', '/konus', '/profil']) {
      expect(hiBubbleVisibleFor(p), isTrue, reason: p);
    }
    for (final p in [
      '/profil/defter',
      '/profil/hi',
      '/tekrar',
      '/play/A1-001',
      '/konu-seti/harbour',
      '/konu-seti/harbour/sahne-avi',
      '/sezon/1/jenerik',
    ]) {
      expect(hiBubbleVisibleFor(p), isFalse, reason: p);
    }
  });

  testWidgets(
    'balon kart içeriğini örtmez: Ana Sayfa, Hikâye, Profil (H-055)',
    (tester) async {
      await pumpApp(tester);
      final bubble = find.byKey(const ValueKey('hi-bubble'));
      // Ana Sayfa ve Profil: kaydırılan alan balonun üstünde biter.
      for (final route in [AppRoutes.home, AppRoutes.profile]) {
        go(route);
        await settle(tester, 30);
        final top = tester.getTopLeft(bubble).dy;
        final list = find.byType(Scrollable).hitTestable().first;
        expect(
          tester.getBottomLeft(list).dy,
          lessThanOrEqualTo(top),
          reason: route,
        );
      }
      // Hikâye: odak kartı balonun üstünde (jenerik izlenmiş sayılır).
      await container.read(seasonIntroRepositoryProvider).markSeen(1);
      go(AppRoutes.story);
      await settle(tester, 40);
      final card = find.byKey(const ValueKey('story-focus-card'));
      expect(card, findsOneWidget);
      expect(
        tester.getBottomLeft(card).dy,
        lessThanOrEqualTo(tester.getTopLeft(bubble).dy),
      );
    },
  );

  testWidgets('balon sekmelerde görünür; Defter ve tekrarda gizlenir', (
    tester,
  ) async {
    await pumpApp(tester);
    final bubble = find.byKey(const ValueKey('hi-bubble'));
    expect(bubble, findsOneWidget);
    expect(find.bySemanticsLabel(RegExp("^Hi'yi aç")), findsOneWidget);
    expect(tester.getSize(bubble).width, greaterThanOrEqualTo(48));

    go(AppRoutes.profile);
    await settle(tester);
    expect(bubble, findsOneWidget);

    go(AppRoutes.notebook);
    await settle(tester, 30);
    expect(find.text('Defter'), findsWidgets);
    expect(bubble, findsNothing);

    go(AppRoutes.talk);
    await settle(tester);
    expect(bubble, findsOneWidget);

    container.read(routerProvider).push(AppRoutes.review);
    await settle(tester, 40);
    expect(bubble, findsNothing);
  });

  testWidgets('panel: Hi kendini tanıtır, tek öneri + gerekçe, hızlı eylemler; '
      'nokta panel açılınca kalkar', (tester) async {
    await pumpApp(tester);
    expect(find.byKey(const ValueKey('hi-bubble-badge')), findsOneWidget);
    await openPanel(tester);

    expect(find.text('Ben Hi, yapay zekâ asistanınım.'), findsOneWidget);
    expect(find.text('Bugünkü öneri'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('hi-suggestion-startEpisode')),
      findsOneWidget,
    );
    expect(find.text('Sıradaki bölüm: A Strange Message'), findsOneWidget);
    expect(find.text('Neden?'), findsOneWidget);
    expect(
      find.text(
        'Hikâye buradan başlıyor. Yaklaşık 6 dk sürer; günlük hedefine '
        '(10 dk) sığar.',
      ),
      findsOneWidget,
    );
    for (final k in ['story', 'review', 'notebook', 'sets']) {
      expect(find.byKey(ValueKey('hi-quick-$k')), findsOneWidget);
    }
    expect(await tester.runAsync(store.panelOpenedDay), isNotNull);

    Navigator.of(tester.element(find.byKey(const ValueKey('hi-panel')))).pop();
    await settle(tester, 30);
    expect(find.byKey(const ValueKey('hi-bubble-badge')), findsNothing);
  });

  testWidgets(
    '"Bu ne demek?": açılan bölümün kelimesi (İ ile), eşleşme yoksa sakin '
    'cevap; yan görev ve haftalık özet',
    (tester) async {
      await tester.runAsync(
        () =>
            DriftProgressRepository(db).markCompleted('A1-001', gate: const {}),
      );
      await pumpApp(tester, height: 4200);
      await openPanel(tester);

      // Yan görev (B1 bitti): üstte, öneriden sonra.
      final bridge = find.byKey(const ValueKey('hi-bridge-bt-a1-001'));
      expect(bridge, findsOneWidget);
      expect(find.text('Sorulara kulak ver'), findsOneWidget);
      await reveal(
        tester,
        find.byKey(const ValueKey('hi-bridge-done')),
        'hi-panel',
      );
      await tester.tap(find.byKey(const ValueKey('hi-bridge-done')));
      await settle(tester, 10);
      expect(find.byKey(const ValueKey('hi-bridge-thanks')), findsOneWidget);
      expect(await tester.runAsync(store.bridgeStates), {
        'bt-a1-001': BridgeState.done,
      });
      await settle(tester, 50);
      expect(bridge, findsNothing);

      // "Bu ne demek?"
      final field = find.byKey(const ValueKey('hi-lookup'));
      await reveal(tester, field, 'hi-panel');
      await tester.enterText(field, 'İSTASYON');
      await settle(tester, 30);
      expect(find.byKey(const ValueKey('hi-lookup-station')), findsOneWidget);
      expect(find.text('istasyon'), findsWidgets);

      await tester.enterText(field, 'pineapple');
      await settle(tester, 10);
      expect(
        find.text(
          'Bunu henüz bilmiyorum; bölümlerde geçen kelimeleri arayabilirim.',
        ),
        findsOneWidget,
      );
      // Açılmamış bölümün (B3) kelimesi gösterilmez.
      await tester.enterText(field, 'between');
      await settle(tester, 10);
      expect(find.byKey(const ValueKey('hi-lookup-between')), findsNothing);

      // Haftalık özet (en altta).
      await reveal(tester, find.byKey(const ValueKey('hi-week')), 'hi-panel');
      expect(find.text('1 bölüm bitirdin.'), findsOneWidget);
      expect(find.textContaining('yeni ifade topladın'), findsOneWidget);
    },
  );

  testWidgets(
    'tekrarlayan hata → Hi\'nin notu kartı; not okununca öneri değişir',
    (tester) async {
      await tester.runAsync(() async {
        final log = DriftLearningEventLog(db);
        for (final h in [3, 1]) {
          await log.record(
            LearningEvent(
              contentId: 'A1-004',
              sourceId: 'k2#b',
              target: "It's in seven o'clock.",
              at: DateTime.now().toUtc().subtract(Duration(hours: h)),
              errorType: ErrorType.preposition,
            ),
          );
        }
      });
      await pumpApp(tester, height: 3600);
      await openPanel(tester);
      expect(
        find.byKey(const ValueKey('hi-suggestion-errorNote')),
        findsOneWidget,
      );
      expect(find.text("Hi'nin notu: Saat ve gün: at / on"), findsOneWidget);
      expect(
        find.textContaining('Son 7 günde "Edat" konusunda 2 kez takıldın.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('hi-suggestion-action')));
      await settle(tester, 30);
      expect(
        find.byKey(const ValueKey('hi-note-time-preposition')),
        findsOneWidget,
      );
      expect(find.text("It's in seven o'clock."), findsOneWidget);
      expect(find.text("It's seven o'clock."), findsOneWidget);
      expect(
        (await tester.runAsync(store.notesReadAt))!.keys,
        contains('preposition'),
      );
      Navigator.of(
        tester.element(find.byKey(const ValueKey('hi-note-time-preposition'))),
      ).pop();
      await settle(tester, 30);
      // Not okundu: aynı hatalar yeniden önerilmez → sıradaki bölüm.
      expect(
        find.byKey(const ValueKey('hi-suggestion-startEpisode')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Profil → "Hi benim hakkımda ne biliyor?": sayılar ve onaylı silme '
    '(ilerleme ve defter kalır)',
    (tester) async {
      await tester.runAsync(() async {
        await DriftProgressRepository(
          db,
        ).markCompleted('A1-001', gate: const {});
        await DriftLearningEventLog(db).record(
          LearningEvent(
            contentId: 'A1-001',
            sourceId: 'k1#b',
            target: 'Yes, I am.',
            at: DateTime.now().toUtc(),
            errorType: ErrorType.verbForm,
          ),
        );
        await store.setBridgeState('bt-a1-001', BridgeState.dismissed);
        // H-055: "Söyle" sonucu da Hi'nin kayıtlarındandır.
        await SpeechStore(db).record(
          SpeechAttempt(
            place: SpeechPlace.review,
            itemRef: 'Yes, I can.',
            level: SpeechMatchLevel.full,
            at: DateTime.now().toUtc(),
          ),
        );
      });
      await pumpApp(tester, height: 4400);
      go(AppRoutes.profile);
      await settle(tester, 30);
      await tester.tap(find.byKey(const ValueKey('profile-hi-privacy')));
      await settle(tester, 40);

      expect(find.text('Hi benim hakkımda ne biliyor?'), findsWidgets);
      expect(find.byKey(const ValueKey('hi-privacy')), findsOneWidget);
      expect(find.text('1 bölüm bitti.'), findsOneWidget);
      expect(find.text('Fiil yapısı: 1'), findsOneWidget);
      expect(
        find.text('0 yan görevi yaptın, 1 tanesini geçtin.'),
        findsOneWidget,
      );
      expect(
        find.textContaining('1 kez söyledin; 1 tanesinde ifadenin tamamı'),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('hi-bubble')), findsNothing);
      final itemsBefore = await tester.runAsync(
        () => db.select(db.notebookItems).get(),
      );
      expect(itemsBefore, isNotEmpty);

      // Vazgeç: hiçbir şey silinmez.
      await reveal(
        tester,
        find.byKey(const ValueKey('hi-privacy-delete')),
        'hi-privacy',
      );
      await tester.tap(find.byKey(const ValueKey('hi-privacy-delete')));
      await settle(tester, 10);
      expect(find.text("Hi'nin kayıtları silinsin mi?"), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('hi-privacy-cancel')));
      await settle(tester, 10);
      expect(
        await tester.runAsync(() => db.select(db.learningEvents).get()),
        hasLength(1),
      );

      await tester.tap(find.byKey(const ValueKey('hi-privacy-delete')));
      await settle(tester, 10);
      await tester.tap(find.byKey(const ValueKey('hi-privacy-confirm')));
      await settle(tester, 30);
      expect(
        find.text("Hi'nin kayıtları silindi. İlerlemen ve defterin yerinde."),
        findsOneWidget,
      );
      expect(
        await tester.runAsync(() => db.select(db.learningEvents).get()),
        isEmpty,
      );
      expect(await tester.runAsync(store.bridgeStates), isEmpty);
      expect(
        await tester.runAsync(() => db.select(db.speechAttempts).get()),
        isEmpty,
      );
      expect(
        await tester.runAsync(() => db.select(db.notebookItems).get()),
        hasLength(itemsBefore!.length),
      );
      expect(
        (await tester.runAsync(
          () => db.select(db.userStoryProgress).get(),
        ))!.single.status,
        'COMPLETED',
      );
      expect(find.text('Kayıt yok.'), findsOneWidget);
    },
  );
}
