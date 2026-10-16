import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/shared/content/content_providers.dart';

import 'support/fake_content_source.dart';
import 'support/onboarding.dart';

void main() {
  testWidgets('5 sekme görünür; Konuş sekmesi yönlendirmeli sahneleri '
      'gösterir (H-090; AI sohbeti yok, H-007)', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingDoneOverride,
          contentSourceProvider.overrideWithValue(FakeContentSource()),
          progressRepositoryProvider.overrideWithValue(
            InMemoryProgressRepository(),
          ),
          seasonIntroRepositoryProvider.overrideWithValue(
            InMemorySeasonIntroRepository(),
          ),
        ],
        child: const HiVelzonApp(),
      ),
    );
    await tester.pumpAndSettle();

    final nav = find.byType(NavigationBar);
    expect(nav, findsOneWidget);
    for (final label in ['Ana Sayfa', 'Keşfet', 'Hikâye', 'Konuş', 'Profil']) {
      expect(
        find.descendant(of: nav, matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(find.textContaining('yakında'), findsNothing);
    // Ana Sayfa: selam + "Bugünün planı" bölümü (H-035, H-053, H-088).
    expect(find.text('Merhaba!'), findsOneWidget);
    expect(find.text('Bugünün planı'), findsOneWidget);
    expect(find.byKey(const ValueKey('home-continue')), findsOneWidget);

    await tester.tap(find.descendant(of: nav, matching: find.text('Konuş')));
    // Liste yüklenirken iskelet sakin nabız atar (pumpAndSettle bitmez).
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.byKey(const ValueKey('talk-screen')), findsOneWidget);
    expect(find.textContaining('yapay zekâ yok'), findsOneWidget);
    expect(find.byKey(const ValueKey('page-title')), findsWidgets);
  });
}
