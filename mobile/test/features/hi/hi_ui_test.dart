import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/features/hi/data/hi_store.dart';
import 'package:hivelzon/features/hi/presentation/hi_bubble.dart';
import 'package:hivelzon/features/player/data/drift_progress_repository.dart';
import 'package:hivelzon/features/player/presentation/widgets/hi_avatar.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/widgets/placeholder_view.dart';
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
import '../../support/onboarding.dart';

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

  Future<void> pumpApp(
    WidgetTester tester, {
    double height = 2556,
    double width = 1179,
    bool clips = false,
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingDoneOverride,
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(
            FakeContentSource(realSubtitles: true)..withClips = clips,
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

  group('balon katmanı: içerik altından kayar (H-064)', () {
    final bubble = find.byKey(const ValueKey('hi-bubble'));

    /// Sekme kökünün kaydırılan listesi (iç içe yatay raflar değil).
    Finder rootList(String? key) => key == null
        ? find.byType(Scrollable).hitTestable().first
        : find
              .descendant(
                of: find.byKey(ValueKey(key)),
                matching: find.byType(Scrollable),
              )
              .first;

    /// Listede görünen yazı ve ikonların ekrandaki dikdörtgenleri.
    List<Rect> contentRects(WidgetTester tester, Finder list) => [
      for (final e
          in find
              .descendant(
                of: list,
                matching: find.byWidgetPredicate(
                  (w) => w is RichText || w is Icon,
                ),
              )
              .evaluate())
        if ((e.renderObject as RenderBox?)?.hasSize ?? false)
          tester.getRect(find.byWidget(e.widget).first),
    ];

    // Sekme kökleri: Ana Sayfa, Profil, Konuş (yer tutucu), Hikâye ·
    // Kitaplık ve Dilbilgisi.
    final roots = <(String, String?, String?)>[
      (AppRoutes.home, null, null),
      (AppRoutes.profile, 'profile-list', null),
      (AppRoutes.talk, null, null),
      (AppRoutes.story, 'library-view', 'Kitaplık'),
      (AppRoutes.story, 'grammar-view', 'Dilbilgisi'),
    ];

    Future<Finder> open(
      WidgetTester tester,
      String route,
      String? key,
      String? section,
    ) async {
      // Hikâye sekmesinde jenerik izlenmiş sayılır (harita açılır).
      await container.read(seasonIntroRepositoryProvider).markSeen(1);
      go(route);
      await settle(tester, 30);
      if (section != null) {
        await tester.tap(find.text(section));
        await settle(tester, 30);
      }
      return rootList(key);
    }

    testWidgets('sayfa alt şerit bırakmaz; uzun liste balonun altından '
        'kayar', (tester) async {
      // Kısa ekran: listeler sığmaz, kaydırılır.
      await pumpApp(tester, height: 1704);
      final shell = tester.getRect(find.byType(NavigationBar));
      for (final (route, key, section) in roots) {
        final list = await open(tester, route, key, section);
        final b = tester.getRect(bubble);
        // Liste menünün üstüne kadar uzanır (eskiden balon kadar kısaydı).
        expect(
          tester.getBottomLeft(list).dy,
          moreOrLessEquals(shell.top, epsilon: 0.5),
          reason: '$route $key',
        );
        expect(tester.getBottomLeft(list).dy, greaterThan(b.bottom));
        final pos = tester.state<ScrollableState>(list).position;
        // Konuş yer tutucusu kısa: balonun satırına içerik düşmeyebilir.
        if (pos.maxScrollExtent <= 0 || route == AppRoutes.talk) continue;
        // Liste sonunda değilken balonun satırında içerik görünür.
        pos.jumpTo(pos.maxScrollExtent / 2);
        await settle(tester, 4);
        final inRow = contentRects(
          tester,
          list,
        ).where((r) => r.bottom > b.top && r.top < b.bottom);
        expect(inRow, isNotEmpty, reason: '$route $key: balon satırı boş');
        pos.jumpTo(0);
        await settle(tester, 4);
      }
    });

    testWidgets('liste sonunda son öğe balonun tamamen üstünde', (
      tester,
    ) async {
      await pumpApp(tester, height: 1704);
      for (final (route, key, section) in roots) {
        final list = await open(tester, route, key, section);
        final pos = tester.state<ScrollableState>(list).position;
        pos.jumpTo(pos.maxScrollExtent);
        await settle(tester, 6);
        final b = tester.getRect(bubble);
        final rects = contentRects(tester, list);
        expect(rects, isNotEmpty, reason: '$route $key');
        final last = rects.map((r) => r.bottom).reduce(math.max);
        expect(last, lessThanOrEqualTo(b.top), reason: '$route $key');
        pos.jumpTo(0);
        await settle(tester, 4);
      }
    });

    testWidgets('balon yokken fazladan son dolgu yok', (tester) async {
      Future<EdgeInsets> padding({bool? visible}) async {
        const view = PlaceholderView(
          title: 'Konuş',
          icon: Icons.chat_bubble,
          heading: 'Yakında',
          message: 'Gövde',
        );
        await tester.pumpWidget(
          MaterialApp(
            home: visible == null
                ? view
                : HiBubbleInset(visible: visible, child: view),
          ),
        );
        return tester.widget<ListView>(find.byType(ListView)).padding!
            as EdgeInsets;
      }

      final none = await padding();
      final hidden = await padding(visible: false);
      final shown = await padding(visible: true);
      expect(hidden, none);
      expect(shown.bottom - hidden.bottom, HiBubble.clearance);
      expect(shown.top, hidden.top);
      expect(shown.right, hidden.right);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 5));
    });

    for (final (w, h, scale, wide) in [
      (1179.0, 2556.0, 1.0, true),
      (960.0, 1704.0, 1.0, false),
      (960.0, 1704.0, 1.3, false),
      (1179.0, 2556.0, 1.3, false),
      (1179.0, 1704.0, 1.3, false),
    ]) {
      testWidgets('Hikâye: odak kartının dokunma alanını balon örtmez '
          '(${w ~/ 3}×${h ~/ 3}, $scale×)', (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await pumpApp(tester, height: h, width: w);
        await container.read(seasonIntroRepositoryProvider).markSeen(1);
        go(AppRoutes.story);
        await settle(tester, 40);
        // Kısa ekranda sayfa kayar; odak kartı sayfanın sonundadır.
        final scroll = find.byKey(const ValueKey('story-scroll'));
        if (scroll.evaluate().isNotEmpty) {
          final pos = tester
              .state<ScrollableState>(
                find
                    .descendant(of: scroll, matching: find.byType(Scrollable))
                    .first,
              )
              .position;
          pos.jumpTo(pos.maxScrollExtent);
          await settle(tester, 6);
        }
        final card = find.byKey(const ValueKey('story-focus-card'));
        expect(card, findsOneWidget);
        final b = tester.getRect(bubble);
        final c = tester.getRect(card);
        expect(c.overlaps(b), isFalse, reason: '$c / $b');
        // Tam genişlikte şerit yok: kart ya balonun solunda biter (yer
        // varsa) ya da dar ekranda / büyük yazıda balonun üstünde.
        if (wide) {
          expect(c.right, lessThanOrEqualTo(b.left));
        } else {
          expect(c.bottom, lessThanOrEqualTo(b.top));
        }
        final chevron = find.descendant(
          of: card,
          matching: find.byIcon(Icons.chevron_right_rounded),
        );
        expect(chevron.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('Keşfet: alt denetimler balonun altında kalmaz (H-055)', (
      tester,
    ) async {
      await pumpApp(tester, clips: true);
      go(AppRoutes.discover);
      await settle(tester, 40);
      final b = tester.getRect(bubble);
      // Varsayılan açılış günlük reel seçkisi (H-094): "Kaydet" rayı altta.
      final save = find.byKey(const ValueKey('reel-save'));
      expect(save, findsWidgets);
      expect(tester.getRect(save.first).bottom, lessThanOrEqualTo(b.top));

      // "Hikâye klipleri"ne geçince de aynı kural (eski akış korunur).
      await tester.ensureVisible(find.byKey(const ValueKey('chip-storyClips')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('chip-storyClips')));
      await settle(tester, 40);
      final clipSave = find.byKey(const ValueKey('clip-save'));
      expect(clipSave, findsWidgets);
      expect(tester.getRect(clipSave.first).bottom, lessThanOrEqualTo(b.top));
      // Oynatıcı zamanlayıcıları kapansın.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 31));
    });
  });

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
    // H-088: Ana Sayfa kartında da "Neden?" var; panelde tek öneri.
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('hi-panel')),
        matching: find.text('Neden?'),
      ),
      findsOneWidget,
    );
    // H-088: aynı gerekçe Ana Sayfa kartında ve panelde (tek karar).
    expect(
      find.text(
        'Hikâye buradan başlıyor. Yaklaşık 6 dk sürer; günlük hedefine '
        '(10 dk) sığar.',
      ),
      findsNWidgets(2),
    );
    for (final k in ['story', 'review', 'notebook', 'sets']) {
      expect(find.byKey(ValueKey('hi-quick-$k')), findsOneWidget);
    }
    expect(await tester.runAsync(store.panelOpenedDay), isNotNull);

    // H-063 bölme eşdeğerliği: aynı anahtarlar, metinler ve başlıklar.
    for (final k in [
      'hi-panel',
      'hi-disclosure',
      'hi-suggestion-title',
      'hi-suggestion-reason',
      'hi-suggestion-action',
    ]) {
      expect(find.byKey(ValueKey(k)), findsOneWidget, reason: k);
    }
    expect(find.text(HiTexts.introSub), findsOneWidget);
    expect(find.byTooltip(CommonTexts.close), findsOneWidget);
    for (final h in [HiTexts.todayHeading, HiTexts.quickHeading]) {
      final node = tester.getSemantics(find.text(h));
      expect(node.flagsCollection.isHeader, isTrue, reason: h);
    }
    // H-063: Hi önce bir kez el sallar, sonra hikâye önerisine mutlu bakar.
    final avatar = find.byKey(const ValueKey('hi-panel-avatar'));
    expect(tester.widget<HiAvatar>(avatar).greet, isTrue);
    expect(tester.widget<HiAvatar>(avatar).expression, HiExpression.happy);

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
      // H-088: Ana Sayfa'nın birincil kartı da aynı öneriyi gösterir.
      expect(find.text("Hi'nin notu: Saat ve gün: at / on"), findsNWidgets(2));
      expect(find.byKey(const ValueKey('home-plan-errorNote')), findsOneWidget);
      // H-063: Hi'nin notu önerisinde Hi düşünür.
      expect(
        tester
            .widget<HiAvatar>(find.byKey(const ValueKey('hi-panel-avatar')))
            .expression,
        HiExpression.thinking,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('hi-panel')),
          matching: find.textContaining(
            'Son 7 günde "Edat" konusunda 2 kez takıldın.',
          ),
        ),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('hi-suggestion-action')));
      await settle(tester, 30);
      expect(
        find.byKey(const ValueKey('hi-note-time-preposition')),
        findsOneWidget,
      );
      expect(find.text("It's in seven o'clock."), findsOneWidget);
      expect(
        tester
            .widget<HiAvatar>(
              find.descendant(
                of: find.byKey(const ValueKey('hi-note-time-preposition')),
                matching: find.byType(HiAvatar),
              ),
            )
            .expression,
        HiExpression.thinking,
      );
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
        // H-093: öğrenme kanıtı (ifade, basamak, tarih) görünür ve silinir.
        await db
            .into(db.evidenceRecords)
            .insert(
              EvidenceRecordsCompanion.insert(
                itemKey: 'phrase|can you hear me',
                stage: 'helped',
                at: DateTime.now().toUtc(),
              ),
            );
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
      await reveal(
        tester,
        find.byKey(const ValueKey('profile-hi-privacy')),
        'profile-list',
      );
      await tester.tap(find.byKey(const ValueKey('profile-hi-privacy')));
      await settle(tester, 40);

      expect(find.text('Hi benim hakkımda ne biliyor?'), findsWidgets);
      expect(find.byKey(const ValueKey('hi-privacy')), findsOneWidget);
      expect(find.text('1 bölüm bitti.'), findsOneWidget);
      expect(find.text('Fiil yapısı · 1'), findsOneWidget);
      expect(
        find.text('0 yan görevi yaptın, 1 tanesini geçtin.'),
        findsOneWidget,
      );
      expect(
        find.textContaining('1 kez söyledin; 1 tanesinde ifadenin tamamı'),
        findsOneWidget,
      );
      expect(find.text('Öğrenme kanıtların'), findsOneWidget);
      expect(find.text('“Can you hear me?”'), findsOneWidget);
      expect(
        find.text(
          'Yardımla yaptın · ${AccountTexts.date(DateTime.now().toUtc())}',
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('hi-privacy-week-evidence')),
        findsOneWidget,
      );
      expect(find.text('1 ifadeyi yardımla yaptın.'), findsOneWidget);
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
        await tester.runAsync(() => db.select(db.evidenceRecords).get()),
        isEmpty,
      );
      expect(find.text('“Can you hear me?”'), findsNothing);
      expect(
        find.textContaining('Henüz yok. Bir ifadeyi yardımla yaptığında'),
        findsOneWidget,
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
