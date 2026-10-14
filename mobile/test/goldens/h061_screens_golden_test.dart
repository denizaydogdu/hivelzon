// H-061 ekran golden'ları ve erişilebilirlik denetimi: Defter (ifadeler /
// boş / ipucu panosu / boş ipucu panosu / konu setleri), Kelime tekrarı
// (görev / doğru geri bildirimi / "Bilmiyorum" geri bildirimi / özet / tekrar
// yok), Konu seti ızgarası, Sahne avı (oyun / özet).
//
// Veriler gerçek yerel veritabanından (bellekte), içerik sahte kaynaktan;
// yazı tipleri gömülü (`loadAppFonts`). Ağ görselleri testte açılmaz: yer
// tutucu kutular görünür. Bilinçli görsel değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/notebook/presentation/notebook_screen.dart';
import 'package:hivelzon/features/notebook/presentation/review_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/topic_sets/application/topic_set_providers.dart';
import 'package:hivelzon/features/topic_sets/presentation/scene_hunt_screen.dart';
import 'package:hivelzon/features/topic_sets/presentation/topic_set_screen.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../support/app_fonts.dart';
import '../support/fake_content_source.dart';
import '../support/fake_video_platform.dart';
import '../support/golden.dart';

/// Tekrar görevindeki anlam → doğru ifade (A1-001 hedef ifadeleri).
const _answers = {
  'Beni duyabiliyor musun?': 'Can you hear me?',
  'Evet, (yapabiliyorum).': 'Yes, I can.',
  'Bir daha, lütfen.': 'Again, please.',
  '… nerede?': 'Where is…?',
  'Dinle.': 'Listen.',
};

class _Case {
  const _Case(
    this.route, {
    this.completed = true,
    this.prepare,
    this.act,
    this.reduceMotion = false,
  });

  final String route;

  /// Bölüm 1 bitti mi (defterde 5 ifade, ipuçları, Alex'in odası açık).
  final bool completed;
  final Future<void> Function(AppDatabase db)? prepare;
  final Future<void> Function(WidgetTester tester)? act;

  /// Sahne avının ipucu nabzı gibi süren animasyonlar durağan çizilsin.
  final bool reduceMotion;
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await _settle(tester);
}

/// Görevdeki anlamın doğru seçeneğine dokunur.
Future<void> _answerRight(WidgetTester tester) async {
  final meaning = tester
      .widget<Text>(find.byKey(const ValueKey('task-meaning')))
      .data!;
  await _tap(tester, find.widgetWithText(OutlinedButton, _answers[meaning]!));
}

/// Konu setindeki "radio" ve "clock" defterde (ızgarada işaretli görünsün).
Future<void> _twoInDeck(AppDatabase db) async {
  final set = loadTopicSetFixture('alex-room');
  await TopicSetActions(
    NotebookStore(db),
  ).addToDeck(set, set.items.where((i) => i.id == 'radio' || i.id == 'clock'));
}

final _cases = <String, _Case>{
  'defter': _Case('/defter', prepare: _twoInDeck),
  'defter_bos': const _Case('/defter', completed: false),
  'ipucu_panosu': const _Case('/defter?t=1'),
  'ipucu_bos': const _Case('/defter?t=1', completed: false),
  'konu_setleri': const _Case('/defter?t=2'),
  'tekrar_gorev': const _Case(AppRoutes.review),
  'tekrar_dogru': _Case(AppRoutes.review, act: _answerRight),
  'tekrar_bilmiyorum': _Case(
    AppRoutes.review,
    act: (t) => _tap(t, find.byKey(const ValueKey('task-dont-know'))),
  ),
  'tekrar_ozet': _Case(
    AppRoutes.review,
    act: (tester) async {
      for (var i = 0; i < 12; i++) {
        if (find
            .byKey(const ValueKey('review-summary'))
            .evaluate()
            .isNotEmpty) {
          break;
        }
        // İlk görevi bilmeyelim: özet "yarın" ve "ilk seferde" sayılarını
        // birlikte göstersin.
        if (i == 0) {
          await _tap(tester, find.byKey(const ValueKey('task-dont-know')));
        } else {
          await _answerRight(tester);
        }
        await _tap(tester, find.byKey(const ValueKey('review-continue')));
      }
    },
  ),
  'tekrar_yok': const _Case(AppRoutes.review, completed: false),
  'konu_seti': _Case('/konu-seti/alex-room', prepare: _twoInDeck),
  'sahne_avi': const _Case(
    '/konu-seti/alex-room/sahne-avi',
    reduceMotion: true,
  ),
  'sahne_avi_ozet': _Case(
    '/konu-seti/alex-room/sahne-avi',
    prepare: _twoInDeck,
    reduceMotion: true,
    act: (tester) async {
      for (var i = 0; i < 10; i++) {
        await _tap(tester, find.byKey(const ValueKey('hunt-dont-know')));
        await _tap(tester, find.byKey(const ValueKey('hunt-next')));
      }
    },
  ),
};

void main() {
  setUpAll(loadAppFonts);
  setUp(() {
    VideoPlayerPlatform.instance = FakeVideoPlatform(
      durationFor: (_) => const Duration(seconds: 3),
    );
  });

  Future<void> pumpCase(
    WidgetTester tester,
    _Case c, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    if (c.reduceMotion) {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
    }
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final progress = InMemoryProgressRepository();
    if (c.completed) {
      await progress.markCompleted('A1-001', gate: const {});
    }
    if (c.prepare != null) await tester.runAsync(() => c.prepare!(db));
    final router = GoRouter(
      initialLocation: c.route,
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
    await _settle(tester);
    if (c.act != null) await c.act!(tester);
    await tester.pumpAndSettle();
    // Sayı kutuları ve belirme animasyonları bitsin; görseller hata verip
    // yer tutucuya geçsin.
    await _settle(tester);
    await tester.pumpAndSettle();
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await _settle(tester);
  }

  for (final MapEntry(key: id, value: c) in _cases.entries) {
    testWidgets('golden: $id', (tester) async {
      await pumpCase(tester, c);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h061_$id.png'),
      );
      await unmount(tester);
    }, skip: skipGoldensOffMac);

    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCase(tester, c);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // Piksel ölçümü yazı tipi çizimine bağlı; yalnız golden'ların
      // üretildiği macOS'ta.
      if (!skipGoldensOffMac) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
      await unmount(tester);
    });

    testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
      tester,
    ) async {
      await pumpCase(tester, c, size: const Size(320, 568), textScale: 1.3);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }
}
