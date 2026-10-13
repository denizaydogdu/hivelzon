import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/features/story/presentation/season_intro_screen.dart';
import 'package:hivelzon/features/story/presentation/story_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';

const _all4 = ['A1-001', 'A1-002', 'A1-003', 'A1-004'];
const _fullGate = {
  GateItem.comprehension: {'t-gorev'},
  GateItem.targetPhrase: {'k2'},
  GateItem.activeTask: {'t-kanit'},
};

EngineSnapshot _snap(String node) => EngineSnapshot(
  checkpointNodeId: node,
  flags: const {},
  passedNodes: const {},
  contentVersion: 1,
);

void main() {
  late InMemorySeasonIntroRepository intro;
  late InMemoryProgressRepository progress;
  late FakeVideoPlatform platform;
  late List<String> pushed;

  setUp(() {
    intro = InMemorySeasonIntroRepository()..seenSeasons.add(1);
    progress = InMemoryProgressRepository();
    pushed = [];
    platform = FakeVideoPlatform(
      durationFor: (_) => const Duration(seconds: 2),
    );
    VideoPlayerPlatform.instance = platform;
  });

  Future<void> pump(
    WidgetTester tester,
    FakeContentSource source, {
    bool reduceMotion = true,
  }) async {
    tester.view.physicalSize = const Size(1206, 2622); // iPhone 17
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        FakeAccessibilityFeatures(disableAnimations: reduceMotion);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final router = GoRouter(
      initialLocation: '/hikaye',
      routes: [
        GoRoute(path: '/hikaye', builder: (_, _) => const StoryScreen()),
        GoRoute(
          path: '/play/:id',
          builder: (context, state) {
            pushed.add(state.uri.toString());
            return Scaffold(
              body: Center(
                child: TextButton(
                  key: const ValueKey('fake-player-back'),
                  onPressed: () => GoRouter.of(context).pop(),
                  child: const Text('geri'),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: '/sezon/:season/jenerik',
          builder: (_, state) => SeasonIntroScreen(
            season: int.parse(state.pathParameters['season']!),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentSourceProvider.overrideWithValue(source),
          seasonIntroRepositoryProvider.overrideWithValue(intro),
          progressRepositoryProvider.overrideWithValue(progress),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
  }

  Future<void> step(WidgetTester tester, [int ms = 1200]) async {
    for (var i = 0; i < ms ~/ 100; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Finder node(int n) => find.byKey(ValueKey('map-node-$n'));

  String label(WidgetTester tester, int n) =>
      tester.getSemantics(node(n)).label;

  Future<void> tapNode(WidgetTester tester, int n) async {
    await tester.ensureVisible(node(n));
    await step(tester, 300);
    await tester.tap(node(n));
    await step(tester, 600);
  }

  testWidgets('ilk açılış: 12 düğüm; B1 sıradaki, B2–B4 kilitli, B5+ yakında', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(tester, FakeContentSource(packageIds: _all4));
    // H-054: yüklenirken spinner değil harita iskeleti; ekran okuyucu duyurur.
    expect(find.byKey(const ValueKey('skeleton-map')), findsOneWidget);
    expect(find.bySemanticsLabel('Harita yükleniyor…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await step(tester, 600);
    expect(find.byKey(const ValueKey('season-map')), findsOneWidget);
    expect(find.byKey(const ValueKey('season-map-fallback')), findsOneWidget);
    for (var n = 1; n <= 12; n++) {
      expect(node(n), findsOneWidget);
    }
    // Sayfa başlığı ve tek cümle açıklama (H-053); sezon başlığı.
    expect(find.text('Hikâye'), findsOneWidget);
    expect(
      find.text(
        'Bölümleri sırayla aç; bitirdiğin bölümü istediğin zaman yeniden '
        'oynayabilirsin.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Sezon 1 · The Missing Signal', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('0 / 12'), findsOneWidget);
    expect(find.text('Jeneriği izle'), findsOneWidget);
    expect(label(tester, 1), 'Bölüm 1, A Strange Message, sıradaki');
    expect(label(tester, 2), 'Bölüm 2, The New Neighbour, kilitli');
    expect(label(tester, 4), 'Bölüm 4, The Note, kilitli');
    expect(label(tester, 5), 'Bölüm 5, Too Late?, yakında');
    expect(label(tester, 12), 'Bölüm 12, The Lighthouse, yakında');
    // Dokunma alanı en az 48 px.
    expect(tester.getSize(node(3)).height, greaterThanOrEqualTo(48));
    // Alt kart: sıradaki bölüm.
    expect(find.text('Bölüm 1 · sıradaki'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('kilitli düğüm: nazik kilit nedeni, oynatma düğmesi yok', (
    tester,
  ) async {
    await pump(tester, FakeContentSource(packageIds: _all4));
    await step(tester, 600);
    await tapNode(tester, 3);
    expect(find.byKey(const ValueKey('episode-sheet')), findsOneWidget);
    expect(find.text('Find the Station'), findsWidgets);
    expect(find.text('İpucu 3.'), findsWidgets);
    expect(
      find.text(
        "Önce Bölüm 2'yi tamamla. Kalan adımlar: anlama, hedef ifade ve görev.",
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('sheet-play')), findsNothing);
    expect(find.byKey(const ValueKey('sheet-resume')), findsNothing);
  });

  testWidgets('yakında düğümü: tarih yok, düğme yok', (tester) async {
    await pump(tester, FakeContentSource(packageIds: _all4));
    await step(tester, 600);
    await tapNode(tester, 5);
    expect(find.byKey(const ValueKey('sheet-coming-soon')), findsOneWidget);
    expect(find.text('Bu bölüm hazırlanıyor.'), findsOneWidget);
    expect(find.byKey(const ValueKey('sheet-play')), findsNothing);
  });

  testWidgets('B1 bitti (kapı tamam), B2 yarım: durumlar, devam et, baştan', (
    tester,
  ) async {
    await progress.markCompleted('A1-001', gate: _fullGate);
    await progress.saveCheckpoint('A1-002', _snap('s03'));
    final handle = tester.ensureSemantics();
    await pump(tester, FakeContentSource(packageIds: _all4));
    await step(tester, 600);
    expect(find.text('1 / 12'), findsOneWidget);
    expect(label(tester, 1), 'Bölüm 1, A Strange Message, tamamlandı');
    expect(label(tester, 2), 'Bölüm 2, The New Neighbour, devam ediyor');
    expect(label(tester, 3), 'Bölüm 3, Find the Station, kilitli');
    handle.dispose();

    await tapNode(tester, 2);
    expect(find.text('Devam et'), findsOneWidget);
    expect(find.text('Baştan başla'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('sheet-resume')));
    await step(tester, 600);
    expect(pushed.last, '/play/A1-002?mode=resume');

    // Oynatıcıda B2 biter; geri dönünce harita yenilenir.
    await progress.markCompleted('A1-002', gate: _fullGate);
    await progress.clearCheckpoint('A1-002');
    await tester.tap(find.byKey(const ValueKey('fake-player-back')));
    await step(tester, 600);
    expect(find.text('2 / 12'), findsOneWidget);
    final h2 = tester.ensureSemantics();
    expect(label(tester, 3), 'Bölüm 3, Find the Station, sıradaki');
    h2.dispose();

    await tapNode(tester, 1);
    expect(find.text('Tekrar oyna'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('sheet-replay')));
    await step(tester, 600);
    expect(pushed.last, '/play/A1-001?mode=restart');
  });

  testWidgets('B1 bitti ama hedef ifade eksik: B2 kilitli, eksik ölçüt yazar', (
    tester,
  ) async {
    await progress.markCompleted(
      'A1-001',
      gate: {
        GateItem.comprehension: {'t-gorev'},
        GateItem.targetPhrase: {},
        GateItem.activeTask: {'t-kanit'},
      },
    );
    await pump(tester, FakeContentSource(packageIds: _all4));
    await step(tester, 600);
    await tapNode(tester, 2);
    expect(
      find.text("Önce Bölüm 1'i tamamla. Kalan adımlar: hedef ifade."),
      findsOneWidget,
    );
    expect(
      find.text(
        'Acele yok; önceki bölümü istediğin kadar tekrar oynayabilirsin.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('sıradaki düğüm: "Oyna" oynatıcıyı açar', (tester) async {
    await pump(tester, FakeContentSource(packageIds: _all4));
    await step(tester, 600);
    await tapNode(tester, 1);
    await tester.tap(find.byKey(const ValueKey('sheet-play')));
    await step(tester, 600);
    expect(pushed, ['/play/A1-001']);
  });

  testWidgets('sıradaki düğüm nabız atar; hareket azaltılınca durur', (
    tester,
  ) async {
    await pump(
      tester,
      FakeContentSource(packageIds: _all4),
      reduceMotion: false,
    );
    await step(tester, 600);
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpWidget(const SizedBox());
    await pump(tester, FakeContentSource(packageIds: _all4));
    await step(tester, 600);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('harita görseli varsa yüklenir, açılamazsa kodla çizilir', (
    tester,
  ) async {
    await pump(
      tester,
      FakeContentSource(packageIds: _all4, mapImage: 'map.jpg'),
    );
    await step(tester, 600);
    // Testte ağ yok: görsel hata verir, harita kodla çizilmiş olarak kalır.
    expect(find.byKey(const ValueKey('season-map')), findsOneWidget);
    expect(find.byKey(const ValueKey('season-map-fallback')), findsWidgets);
    expect(node(12), findsOneWidget);
  });

  testWidgets('sunucu kapalı: hata ve tekrar dene', (tester) async {
    final source = FakeContentSource(fail: true);
    await pump(tester, source);
    await step(tester, 600);
    expect(find.text('Bağlantı kurulamadı'), findsOneWidget);
    source.fail = false;
    await tester.tap(find.byKey(const ValueKey('story-retry')));
    await step(tester, 600);
    expect(node(1), findsOneWidget);
    expect(source.listCalls, 2);
  });

  testWidgets('sezon paketi yoksa harita sunucudaki bölümlerle çizilir', (
    tester,
  ) async {
    intro.seenSeasons.clear();
    await pump(tester, FakeContentSource(seasonFails: true));
    await step(tester, 600);
    expect(node(1), findsOneWidget);
    expect(node(2), findsOneWidget);
    expect(node(3), findsNothing);
    expect(find.text('0 / 2'), findsOneWidget);
    expect(find.text('Jeneriği izle'), findsNothing);
    expect(find.byKey(const ValueKey('season-intro-skip')), findsNothing);
    expect(intro.seenSeasons, isEmpty);
  });

  testWidgets(
    'tam jenerik sezonun ilk açılışında bir kez oynar; "Jeneriği izle" ile yeniden',
    (tester) async {
      intro.seenSeasons.clear();
      await pump(tester, FakeContentSource());
      await step(tester, 600);
      expect(find.byKey(const ValueKey('season-intro-skip')), findsOneWidget);
      expect(intro.seenSeasons, {1});
      expect(platform.isPlaying('_season/S1/jenerik-tam.mp4'), isTrue);
      expect(find.text('Yapay zekâ ile üretilmiştir'), findsOneWidget);
      await step(tester, 2600); // 2 sn'lik jenerik biter → harita
      expect(find.byKey(const ValueKey('season-intro-skip')), findsNothing);
      expect(node(1), findsOneWidget);

      // İkinci açılış: kendiliğinden oynamaz.
      await tester.pumpWidget(const SizedBox());
      await step(tester, 300);
      await pump(tester, FakeContentSource());
      await step(tester, 600);
      expect(find.byKey(const ValueKey('season-intro-skip')), findsNothing);

      // "Jeneriği izle" yeniden açar; "Geç" kapatır.
      await tester.tap(find.text('Jeneriği izle'));
      await step(tester, 600);
      expect(find.byKey(const ValueKey('season-intro-skip')), findsOneWidget);
      final size = tester.getSize(
        find.byKey(const ValueKey('season-intro-skip')),
      );
      expect(size.height, greaterThanOrEqualTo(48));
      await tester.tap(find.byKey(const ValueKey('season-intro-skip')));
      await step(tester, 600);
      expect(find.byKey(const ValueKey('season-intro-skip')), findsNothing);
      expect(platform.isPlaying('_season/S1/jenerik-tam.mp4'), isFalse);
      await tester.pumpWidget(const SizedBox());
      await step(tester, 4600);
    },
  );
}
