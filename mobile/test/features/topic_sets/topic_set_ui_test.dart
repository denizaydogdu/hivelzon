import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/presentation/notebook_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/topic_sets/application/topic_set_providers.dart';
import 'package:hivelzon/features/topic_sets/domain/topic_set.dart';
import 'package:hivelzon/features/topic_sets/presentation/scene_hunt_screen.dart';
import 'package:hivelzon/features/topic_sets/presentation/topic_set_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';

void main() {
  late AppDatabase db;
  late InMemoryProgressRepository progress;
  late FakeContentSource source;

  setUp(() {
    db = AppDatabase.memory();
    progress = InMemoryProgressRepository();
    source = FakeContentSource(
      realSubtitles: true,
      packageIds: const ['A1-001', 'A1-002', 'A1-003', 'A1-004'],
    );
    VideoPlayerPlatform.instance = FakeVideoPlatform(
      durationFor: (_) => const Duration(seconds: 3),
    );
  });
  tearDown(() => db.close());

  NotebookStore store() => NotebookStore(db);

  Future<void> pump(
    WidgetTester tester,
    String initial, {
    int seed = 1,
    bool screenReader = false,
  }) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(path: '/defter', builder: (_, _) => const NotebookScreen()),
        GoRoute(
          path: '/konu-seti/:id',
          builder: (_, s) => TopicSetScreen(setId: s.pathParameters['id']!),
          routes: [
            GoRoute(
              path: 'sahne-avi',
              builder: (_, s) => SceneHuntScreen(
                setId: s.pathParameters['id']!,
                random: math.Random(seed),
              ),
            ),
          ],
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
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: true,
              accessibleNavigation: screenReader,
            ),
            child: child!,
          ),
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

  Future<void> tapKey(WidgetTester tester, String key) async {
    final f = find.byKey(ValueKey(key));
    // Tembel ızgara/liste: öğe ağaçta değilse aşağı kaydırarak bul.
    for (var i = 0; i < 20 && f.evaluate().isEmpty; i++) {
      final pos = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position;
      pos.jumpTo(math.min(pos.pixels + 200, pos.maxScrollExtent));
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await settle(tester);
  }

  /// Izgarada aşağı kaydırılınca üstteki satırlar ağaçtan çıkar: başa dön.
  Future<void> toTop(WidgetTester tester) async {
    tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .jumpTo(0);
    await settle(tester);
  }

  testWidgets('Defter → Konu setleri: açık setler, kilitli set sakin nedenle', (
    tester,
  ) async {
    await progress.markCompleted('A1-001', gate: const {});
    await progress.markCompleted('A1-002', gate: const {});
    await pump(tester, '/defter');
    await settle(tester);
    await tester.tap(find.text('Konu setleri'));
    await settle(tester);

    expect(
      find.text(
        'Hikâyedeki yerlerin nesneleri. Bir bölümü bitirince o bölümün yeri '
        'açılır.',
      ),
      findsOneWidget,
    );
    expect(find.text("Alex'in odası"), findsOneWidget);
    expect(find.text("Maya'nın dükkânı"), findsOneWidget);
    expect(find.text('10 nesne'), findsOneWidget);
    expect(find.text('8 nesne'), findsOneWidget);
    expect(find.text('Liman'), findsOneWidget);
    expect(find.text("Bölüm 3'ü bitirince açılır."), findsOneWidget);
    expect(find.text("Bölüm 4'ü bitirince açılır."), findsOneWidget);

    // Kilitli set açılmaz.
    await tester.tap(find.byKey(const ValueKey('topic-set-harbour')));
    await settle(tester);
    expect(find.byKey(const ValueKey('topic-set-screen')), findsNothing);

    // Açık set ızgarası.
    await tapKey(tester, 'topic-set-alex-room');
    expect(find.byKey(const ValueKey('topic-set-screen')), findsOneWidget);
    expect(find.text('Sahne avına başla'), findsOneWidget);
  });

  testWidgets('Izgara: nesneler, kart, tek tek ve hepsini deftere ekle', (
    tester,
  ) async {
    await progress.markCompleted('A1-001', gate: const {});
    await pump(tester, '/konu-seti/alex-room');
    await settle(tester);

    expect(find.text("Alex'in odası"), findsOneWidget); // üst çubuk
    expect(
      find.text('Bu sette 10 nesne var. Birine dokununca kartı açılır.'),
      findsOneWidget,
    );
    expect(find.text('radio'), findsOneWidget);
    expect(find.text('telsiz'), findsOneWidget);

    // Kart: Türkçesi, örnek cümle, karakterin sesi; tek ekleme.
    await tapKey(tester, 'topic-item-radio');
    expect(find.byKey(const ValueKey('topic-item-detail')), findsOneWidget);
    expect(find.text('TÜRKÇE ANLAMI'), findsOneWidget);
    expect(find.text('ÖRNEK CÜMLE'), findsOneWidget);
    expect(find.text('E! The message on the radio!'), findsOneWidget);
    expect(find.text('E! Telsizdeki mesaj!'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('audio-phrase-word|radio')),
      findsOneWidget,
    );
    await tapKey(tester, 'topic-item-add');
    expect(find.text('Defterinde'), findsOneWidget);
    var entries = await store().entries();
    expect(entries.single.item.textEn, 'radio');
    expect(entries.single.item.source, NotebookSource.topicSet);
    expect(
      entries.single.item.imagePath,
      '_season/S1/sets/alex-room/radio.webp',
    );
    expect(entries.single.item.cueId, 'set:alex-room/radio');
    expect(entries.single.card.isNew, isTrue);
    await tester.tap(find.byTooltip('Kapat'));
    await settle(tester);
    await toTop(tester);
    expect(find.text("Bu sette 10 nesne var; 1'i defterinde."), findsOneWidget);

    // Sesi olmayan nesnede ses düğmesi yok.
    await tapKey(tester, 'topic-item-cup');
    expect(find.byKey(const ValueKey('audio-phrase-word|cup')), findsNothing);
    await tester.tap(find.byTooltip('Kapat'));
    await settle(tester);

    // Hepsini ekle (idempotent: radio ikinci kez girmez).
    await toTop(tester);
    await tapKey(tester, 'topic-set-add-all');
    await toTop(tester);
    expect(find.text('Hepsi defterinde'), findsOneWidget);
    expect(
      find.text("Bu sette 10 nesne var; 10'u defterinde."),
      findsOneWidget,
    );
    entries = await store().entries();
    expect(entries.length, 10);
    expect(entries.map((e) => e.item.key).toSet().length, 10);
    final button = tester.widget<ButtonStyleButton>(
      find.byKey(const ValueKey('topic-set-add-all')),
    );
    expect(button.onPressed, isNull);
  });

  (double, double) inside(HotspotShape s) {
    final (l, t, r, b) = s.bounds;
    if (s is RectShape) return ((l + r) / 2, (t + b) / 2);
    final pts = s.points;
    final n = pts.length;
    final cx = pts.map((e) => e.$1).reduce((a, b) => a + b) / n;
    final cy = pts.map((e) => e.$2).reduce((a, b) => a + b) / n;
    if (s.contains(cx, cy)) return (cx, cy);
    for (var i = 0; i < n; i++) {
      final x = (pts[i].$1 + pts[(i + 1) % n].$1 + pts[(i + 2) % n].$1) / 3;
      final y = (pts[i].$2 + pts[(i + 1) % n].$2 + pts[(i + 2) % n].$2) / 3;
      if (s.contains(x, y)) return (x, y);
    }
    throw StateError('içeride nokta yok');
  }

  Future<void> tapItem(WidgetTester tester, TopicSetItem it) async {
    final rect = tester.getRect(find.byKey(const ValueKey('hunt-scene')));
    final (x, y) = inside(it.hotspots.first);
    await tester.tapAt(
      Offset(rect.left + x * rect.width, rect.top + y * rect.height),
    );
    await settle(tester);
  }

  /// [target] dışında, ona isabet etmeyen bir öğe.
  TopicSetItem other(TopicSet set, TopicSetItem target) {
    for (final o in set.items) {
      if (o.id == target.id) continue;
      final (x, y) = inside(o.hotspots.first);
      if (!target.hitAt(
        x * 1000,
        y * 1000,
        width: 1000,
        height: 1000,
        tolerance: 40,
      )) {
        return o;
      }
    }
    throw StateError('başka öğe yok');
  }

  testWidgets(
    'Sahne avı: doğru, iki kaçırmada ipucu, Bilmiyorum, özet ve FSRS',
    (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      final set = loadTopicSetFixture('alex-room');
      // Öğeler defterde (yeni kartlar): sonuçlar kelime tekrarına yazılır.
      final order = [...set.items]..shuffle(math.Random(1));

      await pump(tester, '/konu-seti/alex-room/sahne-avi');
      await settle(tester);
      // Mağaza gerçek zamanlı bölgede kurulur (sahte zaman bölgesindeki
      // Future'lar runAsync içinde tamamlanmaz).
      await tester.runAsync(
        () => TopicSetActions(store()).addToDeck(set, set.items),
      );
      expect(find.byKey(const ValueKey('scene-hunt')), findsOneWidget);
      expect(find.text('Nesne 1 / 10'), findsOneWidget);
      final first = order[0];
      expect(find.text(first.findEn), findsOneWidget);
      // Başta yalnızca İngilizce; Türkçe yardım ilk yanlıştan sonra.
      expect(find.text(first.findTr), findsNothing);

      // 1) İki yanlış dokunuş → nazik mesaj + Türkçe yardım, sonra ipucu.
      final wrong = other(set, first);
      await tapItem(tester, wrong);
      expect(find.text('Bir daha bakalım.'), findsOneWidget);
      expect(find.text(first.findTr), findsOneWidget);
      expect(find.byKey(const ValueKey('hunt-hint')), findsNothing);
      await tapItem(tester, wrong);
      expect(find.text('İpucu: parlayan yere bak.'), findsOneWidget);
      expect(find.byKey(const ValueKey('hunt-hint')), findsOneWidget);
      await tapItem(tester, first);
      expect(find.text('Buldun!'), findsOneWidget);
      expect(find.byKey(const ValueKey('hunt-highlight')), findsOneWidget);
      expect(find.textContaining(first.tr, findRichText: true), findsOneWidget);
      await tapKey(tester, 'hunt-next');

      // 2) Bilmiyorum → yeri gösterilir.
      expect(find.text('Nesne 2 / 10'), findsOneWidget);
      // H-061: ortak `DontKnowButton` bileşeni; içindeki düğmenin biçimi.
      final dontKnow = tester.widget<ButtonStyleButton>(
        find.descendant(
          of: find.byKey(const ValueKey('hunt-dont-know')),
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        ),
      );
      expect(dontKnow.style!.minimumSize!.resolve({})!.height, 48);
      await tapKey(tester, 'hunt-dont-know');
      expect(
        find.text('Burada. Sorun değil, birlikte bakalım.'),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('hunt-highlight')), findsOneWidget);
      await tapKey(tester, 'hunt-next');

      // 3–10) İlk dokunuşta doğru.
      for (final it in order.skip(2)) {
        expect(find.text(it.findEn), findsOneWidget);
        expect(find.text(it.findTr), findsNothing);
        await tapItem(tester, it);
        expect(find.text('Buldun!'), findsOneWidget, reason: it.id);
        await tapKey(tester, 'hunt-next');
      }
      await settle(tester);

      expect(find.text('Sahne avı tamam'), findsOneWidget);
      expect(
        find.text('10 nesneden 8 tanesini kendin buldun.'),
        findsOneWidget,
      );
      expect(
        find.text('Defterindeki 10 ifadenin tekrar zamanı güncellendi.'),
        findsOneWidget,
      );

      final logs = await tester.runAsync(() => store().logs());
      expect(logs!.length, 10);
      expect(logs.every((l) => l.taskType == 'scene_hunt'), isTrue);
      expect(logs.where((l) => l.rating == FsrsRating.again.value).length, 2);
      expect(logs.where((l) => l.dontKnow).length, 1);

      // Tekrar oyna: aynı gün ikinci oyun kartları yeniden yazmaz.
      await tapKey(tester, 'hunt-again');
      expect(find.text('Nesne 1 / 10'), findsOneWidget);
    },
  );

  testWidgets('Sahne avı: defterde değilse FSRS yazılmaz, eklemeyi önerir', (
    tester,
  ) async {
    await progress.markCompleted('A1-001', gate: const {});
    final set = loadTopicSetFixture('alex-room');
    await pump(tester, '/konu-seti/alex-room/sahne-avi', seed: 5);
    await settle(tester);
    for (var i = 0; i < set.items.length; i++) {
      await tapKey(tester, 'hunt-dont-know');
      await tapKey(tester, 'hunt-next');
    }
    await settle(tester);
    expect(find.text('Bu sefer nesnelere birlikte baktık.'), findsOneWidget);
    expect(
      find.text(
        'Bu nesneleri defterine eklersen kelime tekrarında da karşına çıkar.',
      ),
      findsOneWidget,
    );
    expect((await tester.runAsync(() => store().logs()))!, isEmpty);
    await tapKey(tester, 'hunt-add-all');
    expect((await tester.runAsync(() => store().entries()))!.length, 10);
  });

  testWidgets('Ekran okuyucu: Türkçe bölge etiketleri ve seçenek listesi', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await progress.markCompleted('A1-001', gate: const {});
    final set = loadTopicSetFixture('alex-room');
    final order = [...set.items]..shuffle(math.Random(1));
    await pump(tester, '/konu-seti/alex-room/sahne-avi', screenReader: true);
    await settle(tester);

    // Bölgeler Türkçe adlarıyla okunur.
    expect(find.bySemanticsLabel('telsiz'), findsWidgets);
    expect(find.bySemanticsLabel("Alex'in odası sahnesi"), findsOneWidget);
    // Türkçe yardım satırı ipucuna kadar gizli; seçenekler görünür.
    expect(find.text(order[0].findTr), findsNothing);
    expect(find.text('Doğru nesneyi seç:'), findsOneWidget);
    expect(find.byKey(ValueKey('hunt-choice-${order[0].id}')), findsOneWidget);
    await tapKey(tester, 'hunt-choice-${order[0].id}');
    expect(find.text('Buldun!'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('Sahne avı: yakınlaştırınca dokunma denetimi doğru kalır', (
    tester,
  ) async {
    await progress.markCompleted('A1-001', gate: const {});
    final set = loadTopicSetFixture('alex-room');
    final order = [...set.items]..shuffle(math.Random(1));
    await pump(tester, '/konu-seti/alex-room/sahne-avi');
    await settle(tester);
    final target = order[0];
    final before = tester.getRect(find.byKey(const ValueKey('hunt-scene')));
    final (x, y) = inside(target.hotspots.first);
    final plain = Offset(
      before.left + x * before.width,
      before.top + y * before.height,
    );
    final viewer = tester.widget<InteractiveViewer>(
      find.byKey(const ValueKey('hunt-zoom')),
    );
    final zoom = viewer.transformationController!;
    final box = tester.getRect(find.byKey(const ValueKey('hunt-zoom')));
    const scale = 2.5;

    // A) Sol üstten 2,5 kat büyüt: hedefin eski ekran yeri artık başka bir
    // noktayı gösterir; oraya dokunmak isabet sayılmaz.
    zoom.value = Matrix4.identity()..scaleByDouble(scale, scale, 1, 1);
    await settle(tester);
    var zoomed = tester.getRect(find.byKey(const ValueKey('hunt-scene')));
    expect(zoomed.width, closeTo(before.width * scale, 0.5));
    final px = (plain.dx - zoomed.left) / zoomed.width * before.width;
    final py = (plain.dy - zoomed.top) / zoomed.height * before.height;
    expect(
      target.hitAt(
        px,
        py,
        width: before.width,
        height: before.height,
        tolerance: 14,
      ),
      isFalse,
      reason: 'ön koşul: eski yer büyütülmüş görselde hedef değil',
    );
    await tester.tapAt(plain);
    await settle(tester);
    expect(find.text('Buldun!'), findsNothing);
    expect(find.text('Bir daha bakalım.'), findsOneWidget);

    // B) Hedefin üstüne ortalanmış büyütme: ekranda büyümüş hedefe dokunmak
    // isabettir.
    final local = plain - box.topLeft;
    zoom.value = Matrix4.identity()
      ..translateByDouble(
        box.width / 2 - local.dx * scale,
        box.height / 2 - local.dy * scale,
        0,
        1,
      )
      ..scaleByDouble(scale, scale, 1, 1);
    await settle(tester);
    zoomed = tester.getRect(find.byKey(const ValueKey('hunt-scene')));
    await tester.tapAt(
      Offset(zoomed.left + x * zoomed.width, zoomed.top + y * zoomed.height),
    );
    await settle(tester);
    expect(find.text('Buldun!'), findsOneWidget);
  });

  testWidgets(
    'Defter: konu setinden gelen ifade çıkarılabilir; set yeniden ekler',
    (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      final set = loadTopicSetFixture('alex-room');
      await pump(tester, '/defter');
      await settle(tester);
      await tester.runAsync(
        () => TopicSetActions(
          store(),
        ).addToDeck(set, set.items.where((i) => i.id == 'radio')),
      );
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
      await pump(tester, '/defter');
      await settle(tester);
      await tapKey(tester, 'entry-menu-word|radio');
      await tester.tap(find.text('Defterden çıkar'));
      await settle(tester);
      expect(find.text('"radio" defterinden çıkarıldı.'), findsOneWidget);
      final left = (await tester.runAsync(() => store().entries()))!;
      expect(left.any((e) => e.item.textEn == 'radio'), isFalse);
      // Set etkilenmez; "Hepsini defterime ekle" yeniden ekler.
      await tester.runAsync(
        () => TopicSetActions(store()).addToDeck(set, set.items),
      );
      final again = (await tester.runAsync(() => store().entries()))!;
      expect(again.any((e) => e.item.textEn == 'radio'), isTrue);
    },
  );

  testWidgets(
    'Sahne avı: büyütme düğmesi 2 kat büyütür; "tamamını göster" geri alır',
    (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, '/konu-seti/alex-room/sahne-avi');
      await settle(tester);
      final zoom = tester
          .widget<InteractiveViewer>(find.byKey(const ValueKey('hunt-zoom')))
          .transformationController!;
      expect(find.byKey(const ValueKey('hunt-zoom-reset')), findsNothing);
      await tapKey(tester, 'hunt-zoom-in');
      expect(zoom.value.getMaxScaleOnAxis(), closeTo(2, 1e-6));
      await tapKey(tester, 'hunt-zoom-reset');
      expect(zoom.value.getMaxScaleOnAxis(), closeTo(1, 1e-6));
    },
  );
}
