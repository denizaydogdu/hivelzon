import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/features/story/presentation/season_intro_screen.dart';
import 'package:hivelzon/features/story/presentation/story_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';

void main() {
  late InMemorySeasonIntroRepository intro;
  late FakeVideoPlatform platform;

  setUp(() {
    intro = InMemorySeasonIntroRepository();
    platform = FakeVideoPlatform(
      durationFor: (_) => const Duration(seconds: 2),
    );
    VideoPlayerPlatform.instance = platform;
  });

  Future<void> pump(WidgetTester tester, FakeContentSource source) async {
    final router = GoRouter(
      initialLocation: '/hikaye',
      routes: [
        GoRoute(path: '/hikaye', builder: (_, _) => const StoryScreen()),
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

  testWidgets('bölümler listelenir; başta sezon başlığı', (tester) async {
    intro.seenSeasons.add(1);
    await pump(tester, FakeContentSource());
    expect(find.text('Bölümler yükleniyor…'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('A Strange Message'), findsOneWidget);
    expect(find.text('The New Neighbour'), findsOneWidget);
    expect(find.textContaining('Sezon 1 · Bölüm 1'), findsOneWidget);
    expect(find.text('SEZON 1'), findsOneWidget);
    expect(find.text('The Missing Signal'), findsOneWidget);
    expect(find.text('Jeneriği izle'), findsOneWidget);
    // Başlık listenin en üstünde.
    expect(
      tester.getTopLeft(find.text('The Missing Signal')).dy,
      lessThan(tester.getTopLeft(find.text('A Strange Message')).dy),
    );
    expect(find.byKey(const ValueKey('season-intro-skip')), findsNothing);
  });

  testWidgets('sunucu kapalı: hata ve tekrar dene', (tester) async {
    intro.seenSeasons.add(1);
    final source = FakeContentSource(fail: true);
    await pump(tester, source);
    await tester.pumpAndSettle();
    expect(find.text('Sunucu çalışmıyor'), findsOneWidget);
    source.fail = false;
    await tester.tap(find.byKey(const ValueKey('story-retry')));
    await tester.pumpAndSettle();
    expect(find.text('A Strange Message'), findsOneWidget);
    expect(source.listCalls, 2);
  });

  testWidgets('sezon paketi yoksa başlık gizli, liste çalışır', (tester) async {
    await pump(tester, FakeContentSource(seasonFails: true));
    await step(tester, 600);
    expect(find.text('A Strange Message'), findsOneWidget);
    expect(find.text('Jeneriği izle'), findsNothing);
    expect(find.byKey(const ValueKey('season-intro-skip')), findsNothing);
    expect(intro.seenSeasons, isEmpty);
  });

  testWidgets(
    'tam jenerik sezonun ilk açılışında bir kez oynar; "Jeneriği izle" ile yeniden',
    (tester) async {
      await pump(tester, FakeContentSource());
      await step(tester, 600);
      // İlk açılış: jenerik kendiliğinden açılır ve izlendi olarak işaretlenir.
      expect(find.byKey(const ValueKey('season-intro-skip')), findsOneWidget);
      expect(intro.seenSeasons, {1});
      expect(platform.isPlaying('_season/S1/jenerik-tam.mp4'), isTrue);
      expect(find.text('Yapay zekâ ile üretilmiştir'), findsOneWidget);
      await step(tester, 2600); // 2 sn'lik jenerik biter → liste
      expect(find.byKey(const ValueKey('season-intro-skip')), findsNothing);
      expect(find.text('A Strange Message'), findsOneWidget);

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
