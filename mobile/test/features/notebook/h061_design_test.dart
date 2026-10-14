// H-061: Defter, Kelime tekrarı, Konu seti ve Sahne avı tasarımı — yeni
// durumlar (tek satır biçimi, kaynak satırı, illüstrasyonlu boş durumlar,
// sakin geri bildirim, hafif titreşim, özet istatistikleri) ve "Hareketi
// azalt" açıkken durağanlık.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/presentation/notebook_screen.dart';
import 'package:hivelzon/features/notebook/presentation/review_screen.dart';
import 'package:hivelzon/features/notebook/presentation/widgets/notebook_row.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/topic_sets/application/topic_set_providers.dart';
import 'package:hivelzon/features/topic_sets/domain/topic_set.dart';
import 'package:hivelzon/features/topic_sets/presentation/scene_hunt_screen.dart';
import 'package:hivelzon/features/topic_sets/presentation/topic_set_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/ui/ui.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';

/// Tekrar görevindeki anlam → doğru ifade (A1-001 hedef ifadeleri).
const _answers = {
  'Beni duyabiliyor musun?': 'Can you hear me?',
  'Evet, (yapabiliyorum).': 'Yes, I can.',
  'Bir daha, lütfen.': 'Again, please.',
  '… nerede?': 'Where is…?',
  'Dinle.': 'Listen.',
};

/// Bölgenin içinde bir nokta (0–1).
(double, double) _inside(HotspotShape s) {
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

void main() {
  late AppDatabase db;
  late InMemoryProgressRepository progress;
  late List<String?> haptics;

  setUp(() {
    db = AppDatabase.memory();
    progress = InMemoryProgressRepository();
    haptics = [];
    VideoPlayerPlatform.instance = FakeVideoPlatform(
      durationFor: (_) => const Duration(seconds: 3),
    );
  });
  tearDown(() => db.close());

  Future<void> pump(
    WidgetTester tester,
    String initial, {
    bool reduceMotion = false,
    double height = 2556,
  }) async {
    tester.view.physicalSize = Size(1179, height);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          haptics.add(call.arguments as String?);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(
          path: '/defter',
          builder: (_, s) => NotebookScreen(
            initialTab: int.parse(s.uri.queryParameters['t'] ?? '0'),
          ),
        ),
        GoRoute(
          path: AppRoutes.review,
          builder: (_, _) => const ReviewScreen(),
        ),
        GoRoute(
          path: '/konu-seti/:id',
          builder: (_, s) => TopicSetScreen(setId: s.pathParameters['id']!),
          routes: [
            GoRoute(
              path: 'sahne-avi',
              builder: (_, s) => SceneHuntScreen(
                setId: s.pathParameters['id']!,
                random: math.Random(1),
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
          contentSourceProvider.overrideWithValue(
            FakeContentSource(
              realSubtitles: true,
              packageIds: const ['A1-001', 'A1-002', 'A1-003', 'A1-004'],
            ),
          ),
          progressRepositoryProvider.overrideWithValue(progress),
          learningEventLogProvider.overrideWithValue(
            InMemoryLearningEventLog(),
          ),
          reviewRandomProvider.overrideWithValue(math.Random(7)),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(disableAnimations: reduceMotion),
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

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await settle(tester);
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  }

  Future<void> answerRight(WidgetTester tester) async {
    final meaning = tester
        .widget<Text>(find.byKey(const ValueKey('task-meaning')))
        .data!;
    await tap(tester, find.widgetWithText(OutlinedButton, _answers[meaning]!));
  }

  bool usesAsset(WidgetTester tester, String name) => tester
      .widgetList<Image>(find.byType(Image))
      .any((i) => i.image is AssetImage && '${i.image}'.contains(name));

  group('Defter', () {
    testWidgets('tek satır biçimi: bölüm etiketi; konu setinden gelene '
        'kaynak satırı', (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      final set = loadTopicSetFixture('alex-room');
      await tester.runAsync(
        () => TopicSetActions(
          NotebookStore(db),
        ).addToDeck(set, set.items.where((i) => i.id == 'radio')),
      );
      await pump(tester, '/defter', height: 4200);
      await settle(tester);

      expect(find.byType(NotebookRow), findsNWidgets(6));
      // Konu setindeki nesne de Bölüm 1'in yerinden: etiketi "B1".
      expect(find.text('B1'), findsNWidgets(6));
      final radio = find.ancestor(
        of: find.text('radio'),
        matching: find.byType(NotebookRow),
      );
      expect(
        find.descendant(of: radio, matching: find.text('Konu setinden')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: radio, matching: find.text('B1')),
        findsOneWidget,
      );
      // Bölümden gelenlerde kaynak satırı yok (kaynak, bölüm etiketidir).
      expect(find.text('Konu setinden'), findsOneWidget);

      // İpucu panosunda da aynı satır biçimi.
      await tap(tester, find.text('İpucu panosu'));
      expect(
        find.ancestor(
          of: find.text('Telsiz mesajı (ses + metin)'),
          matching: find.byType(NotebookRow),
        ),
        findsOneWidget,
      );
      await unmount(tester);
    });

    testWidgets('boş defter ve boş ipucu panosu illüstrasyonlu; boşken arama '
        'alanı yok', (tester) async {
      await pump(tester, '/defter');
      await settle(tester);
      expect(find.byKey(const ValueKey('notebook-empty')), findsOneWidget);
      expect(find.text('Defterin henüz boş'), findsOneWidget);
      expect(usesAsset(tester, 'bos-defter.webp'), isTrue);
      expect(find.byKey(const ValueKey('notebook-search')), findsNothing);

      await tap(tester, find.text('İpucu panosu'));
      expect(find.byKey(const ValueKey('clues-empty')), findsOneWidget);
      expect(find.text('Henüz ipucu yok'), findsOneWidget);
      expect(usesAsset(tester, 'bos-ipucu.webp'), isTrue);
      await unmount(tester);
    });

    testWidgets('arama eşleşmezse sakin boş durum', (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, '/defter');
      await settle(tester);
      await tester.enterText(
        find.byKey(const ValueKey('notebook-search')),
        'zzz',
      );
      await settle(tester);
      expect(find.byKey(const ValueKey('notebook-no-match')), findsOneWidget);
      expect(find.text('Aradığın ifade defterinde yok.'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('satırlar ilk açılışta sırayla belirir; "Hareketi azalt" '
        'açıkken belirme yok', (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, '/defter');
      await settle(tester);
      expect(
        find.descendant(
          of: find.byType(StaggerOnce),
          matching: find.byType(Animate),
        ),
        findsWidgets,
      );
      await unmount(tester);

      await pump(tester, '/defter', reduceMotion: true);
      await settle(tester);
      expect(find.byType(NotebookRow), findsWidgets);
      expect(find.byType(Animate), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
      await unmount(tester);
    });
  });

  group('Kelime tekrarı', () {
    testWidgets('doğru: yeşil panel + bir kez hafif titreşim; "Bilmiyorum": '
        'sakin panel, titreşim yok', (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, AppRoutes.review);
      await settle(tester);
      // Görev: ince ilerleme çubuğu, ortak "Bilmiyorum" bileşeni.
      expect(find.byKey(const ValueKey('review-progress-bar')), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Bilmiyorum'),
          matching: find.byType(DontKnowButton),
        ),
        findsOneWidget,
      );

      await answerRight(tester);
      expect(
        find.byKey(const ValueKey('feedback-panel-correct')),
        findsOneWidget,
      );
      expect(haptics, ['HapticFeedbackType.lightImpact']);
      await tap(tester, find.byKey(const ValueKey('review-continue')));

      await tap(tester, find.byKey(const ValueKey('task-dont-know')));
      expect(find.byKey(const ValueKey('feedback-panel-calm')), findsOneWidget);
      expect(find.text('Sorun değil, birlikte bakalım.'), findsOneWidget);
      expect(haptics, hasLength(1), reason: 'Bilmiyorum titreşimsiz');
      await unmount(tester);
    });

    testWidgets('özet: sakin kutlama + StatRow (sıfır olan sayı yok)', (
      tester,
    ) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, AppRoutes.review);
      await settle(tester);
      for (var i = 0; i < 12; i++) {
        if (find
            .byKey(const ValueKey('review-summary'))
            .evaluate()
            .isNotEmpty) {
          break;
        }
        await answerRight(tester);
        await tap(tester, find.byKey(const ValueKey('review-continue')));
      }
      expect(find.text('Tekrar tamam'), findsOneWidget);
      expect(find.byType(CalmCelebration), findsOneWidget);
      expect(
        find.byKey(const ValueKey('review-summary-stats')),
        findsOneWidget,
      );
      final firstTry = tester.widget<StatTile>(
        find.byKey(const ValueKey('summary-first-try')),
      );
      expect(firstTry.count, 5);
      // Hepsi ilk seferde bilindi: yarın gelecek ifade yok, kutusu da yok.
      expect(find.byKey(const ValueKey('summary-tomorrow')), findsNothing);
      expect(find.textContaining('yanlış'), findsNothing);
      await unmount(tester);
    });

    testWidgets('tekrar edilecek ifade yoksa illüstrasyonlu sakin ekran', (
      tester,
    ) async {
      await pump(tester, AppRoutes.review);
      await settle(tester);
      expect(find.byKey(const ValueKey('review-empty')), findsOneWidget);
      expect(find.text('Şu an tekrar edilecek ifade yok'), findsOneWidget);
      expect(usesAsset(tester, 'tekrar-yok.webp'), isTrue);
      expect(find.text('Geri dön'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('"Hareketi azalt" açıkken görev, geri bildirim ve özet '
        'durağan', (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, AppRoutes.review, reduceMotion: true);
      await settle(tester);
      expect(find.byType(Animate), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);

      await answerRight(tester);
      // Geri bildirim ilk karede tam: belirme ve ikon büyümesi yok.
      expect(find.byType(Animate), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
      await tap(tester, find.byKey(const ValueKey('review-continue')));

      for (var i = 0; i < 12; i++) {
        if (find
            .byKey(const ValueKey('review-summary'))
            .evaluate()
            .isNotEmpty) {
          break;
        }
        await answerRight(tester);
        await tap(tester, find.byKey(const ValueKey('review-continue')));
      }
      expect(find.byType(CalmCelebration), findsOneWidget);
      expect(find.byType(Animate), findsNothing);
      // Sayı kutuları sayarak gelmez: son değer ilk karede.
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('summary-first-try')),
          matching: find.text('5'),
        ),
        findsOneWidget,
      );
      expect(tester.hasRunningAnimations, isFalse);
      await unmount(tester);
    });

    testWidgets('hareket açıkken geri bildirim paneli ve kutlama belirir', (
      tester,
    ) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, AppRoutes.review);
      await settle(tester);
      await answerRight(tester);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('review-feedback')),
          matching: find.byType(Animate),
        ),
        findsWidgets,
      );
      await unmount(tester);
    });
  });

  group('Konu seti ve sahne avı', () {
    testWidgets('ızgara kartları basınca küçülür (PressScale); "Hareketi '
        'azalt"ta ölçek değişmez', (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, '/konu-seti/alex-room');
      await settle(tester);
      final card = find.byKey(const ValueKey('topic-item-radio'));
      await tester.ensureVisible(card);
      await tester.pump();
      expect(
        find.descendant(of: card, matching: find.byType(PressScale)),
        findsOneWidget,
      );
      final gesture = await tester.startGesture(tester.getCenter(card));
      await tester.pump(const Duration(milliseconds: 200));
      final scale = tester.widget<AnimatedScale>(
        find.descendant(of: card, matching: find.byType(AnimatedScale)),
      );
      expect(scale.scale, lessThan(1));
      await gesture.cancel();
      await unmount(tester);

      await pump(tester, '/konu-seti/alex-room', reduceMotion: true);
      await settle(tester);
      final still = find.byKey(const ValueKey('topic-item-radio'));
      await tester.ensureVisible(still);
      await tester.pump();
      final g2 = await tester.startGesture(tester.getCenter(still));
      await tester.pump(const Duration(milliseconds: 200));
      expect(
        tester
            .widget<AnimatedScale>(
              find.descendant(of: still, matching: find.byType(AnimatedScale)),
            )
            .scale,
        1,
      );
      expect(find.byType(Animate), findsNothing);
      await g2.cancel();
      await unmount(tester);
    });

    testWidgets('sahne avı: bulununca hafif titreşim; alt çubuk ortak '
        '"Bilmiyorum"; özet StatRow', (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, '/konu-seti/alex-room/sahne-avi', reduceMotion: true);
      await settle(tester);
      expect(find.byKey(const ValueKey('hunt-bottom-bar')), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byKey(const ValueKey('hunt-dont-know')),
          matching: find.byKey(const ValueKey('hunt-bottom-bar')),
        ),
        findsOneWidget,
      );
      expect(
        tester.widget(find.byKey(const ValueKey('hunt-dont-know'))),
        isA<DontKnowButton>(),
      );

      // İlk nesneyi bul (bölgenin ortasına dokun).
      final set = loadTopicSetFixture('alex-room');
      final order = [...set.items]..shuffle(math.Random(1));
      final scene = tester.getRect(find.byKey(const ValueKey('hunt-scene')));
      final (x, y) = _inside(order.first.hotspots.first);
      await tester.tapAt(
        Offset(scene.left + x * scene.width, scene.top + y * scene.height),
      );
      await settle(tester);
      expect(find.text('Buldun!'), findsOneWidget);
      expect(haptics, ['HapticFeedbackType.lightImpact']);
      await tap(tester, find.byKey(const ValueKey('hunt-next')));

      // Kalanlar "Bilmiyorum": titreşim yok.
      for (var i = 1; i < order.length; i++) {
        await tap(tester, find.byKey(const ValueKey('hunt-dont-know')));
        await tap(tester, find.byKey(const ValueKey('hunt-next')));
      }
      expect(haptics, hasLength(1));
      expect(find.text('Sahne avı tamam'), findsOneWidget);
      expect(find.byType(CalmCelebration), findsOneWidget);
      int count(String key) =>
          tester.widget<StatTile>(find.byKey(ValueKey(key))).count!;
      expect(count('hunt-stat-total'), order.length);
      expect(count('hunt-stat-alone'), 1);
      expect(count('hunt-stat-helped'), order.length - 1);
      expect(find.byType(Animate), findsNothing);
      await unmount(tester);
    });
  });
}
