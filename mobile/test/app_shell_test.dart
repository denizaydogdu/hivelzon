import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/shared/content/content_providers.dart';

import 'support/fake_content_source.dart';

void main() {
  testWidgets('5 sekme görünür ve Konuş sekmesi "Yakında" gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
    expect(find.textContaining('Yakında'), findsNothing);
    // Ana Sayfa: tek "Hikâyeye devam" kartı (H-035).
    expect(find.text('HİKÂYEYE DEVAM'), findsOneWidget);

    await tester.tap(find.descendant(of: nav, matching: find.text('Konuş')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Yakında'), findsOneWidget);
  });
}
