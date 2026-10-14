import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/notebook/application/notebook_providers.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/story/application/story_providers.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/features/story/presentation/story_screen.dart';
import 'package:hivelzon/features/profile/presentation/profile_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';

import '../support/fake_content_source.dart';
import '../support/onboarding.dart';

/// H-056: başka cihazdan veri gelince (ya da oynatıcıdan dönünce) bütün
/// sekmeler güvenle yenilenir; görünmeyen sekme yeniden açılırken
/// "setState() or markNeedsBuild() called during build" hatası olmaz.
void main() {
  late InMemoryProgressRepository progress;
  late ProviderContainer container;

  /// Sağlayıcı dinleyicilerinde yakalanan hatalar (Riverpod bunları
  /// normalde bölgeye — test başarısızlığına — iletir; burada toplanır).
  final errors = <Object>[];

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  Future<void> pumpApp(WidgetTester tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    progress = InMemoryProgressRepository();
    container = ProviderContainer(
      // ignore: invalid_use_of_internal_member
      onError: (e, _) => errors.add(e),
      overrides: [
        onboardingDoneOverride,
        contentSourceProvider.overrideWithValue(FakeContentSource()),
        progressRepositoryProvider.overrideWithValue(progress),
        seasonIntroRepositoryProvider.overrideWithValue(
          InMemorySeasonIntroRepository()..seenSeasons.add(1),
        ),
      ],
    );
    addTearDown(container.dispose);
    errors.clear();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const HiVelzonApp(),
      ),
    );
    await settle(tester);
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await settle(tester);
  }

  /// Bütün sekmeler bir kez açılır (abonelikler kurulur), sonra Profil'de
  /// kalınır: Ana Sayfa ve Hikâye görünmez (duraklatılmış).
  Future<void> visitAllThenProfile(WidgetTester tester) async {
    for (final tab in ['Hikâye', 'Ana Sayfa', 'Profil']) {
      await openTab(tester, tab);
    }
  }

  Future<void> completeFirstEpisode() => progress.markCompleted(
    'A1-001',
    gate: const {
      GateItem.comprehension: {'t-gorev'},
      GateItem.targetPhrase: {'k2'},
      GateItem.activeTask: {'t-kanit'},
    },
  );

  Object? takeAll(WidgetTester tester) {
    final e = tester.takeException() ?? (errors.isEmpty ? null : errors.first);
    errors.clear();
    return e;
  }

  testWidgets(
    'eski yol (yeniden üretim): görünmeyen sekmede doğrudan geçersiz kılma, '
    'sekme açılırken build sırasında setState hatası verir',
    (tester) async {
      await pumpApp(tester);
      await visitAllThenProfile(tester);
      container
        ..invalidate(storyProgressProvider)
        ..invalidate(reviewOverviewProvider)
        ..invalidate(coachInputProvider)
        ..invalidate(hiBadgeProvider);
      await settle(tester);
      await openTab(tester, 'Hikâye');
      final error = takeAll(tester);
      expect(error, isNotNull);
      expect('$error', contains('called during build'));
    },
  );

  testWidgets(
    'başka cihazdan veri gelince görünmeyen sekmeler de hatasız yenilenir',
    (tester) async {
      await pumpApp(tester);
      await visitAllThenProfile(tester);
      expect(takeAll(tester), isNull);

      await completeFirstEpisode();
      // Eşitleme turu veri çekti (SyncController sürümü artırır).
      container.read(syncControllerProvider.notifier).notifyDataChanged();
      await settle(tester);
      expect(takeAll(tester), isNull);

      await openTab(tester, 'Hikâye');
      expect(takeAll(tester), isNull);
      expect(find.text('1 / 12'), findsOneWidget);

      await openTab(tester, 'Ana Sayfa');
      expect(takeAll(tester), isNull);
      expect(find.text('The New Neighbour'), findsOneWidget);

      await openTab(tester, 'Profil');
      expect(takeAll(tester), isNull);
    },
  );

  testWidgets(
    'art arda iki veri gelişi ve sekmeler arasında gezinme: hata yok',
    (tester) async {
      await pumpApp(tester);
      await visitAllThenProfile(tester);
      final sync = container.read(syncControllerProvider.notifier);
      sync.notifyDataChanged();
      await tester.pump();
      await completeFirstEpisode();
      sync.notifyDataChanged();
      // Kare arasında sekme değişir (yenileme sürerken görünür olur).
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Hikâye'),
        ),
      );
      await settle(tester);
      expect(takeAll(tester), isNull);
      expect(find.text('1 / 12'), findsOneWidget);
    },
  );

  testWidgets(
    'oynatıcıdan / Hi panelinden dönüş yenilemesi (refreshWhenVisible) '
    'görünmeyen sekmeler varken: sekmeler açılırken hata yok',
    (tester) async {
      await pumpApp(tester);
      await visitAllThenProfile(tester);
      await completeFirstEpisode();
      // Profil'den açılan Hi paneli → bir ekrana gidip dönüş (hi_panel).
      final profile = tester.element(find.byType(ProfileScreen));
      await refreshWhenVisible(profile, profile as WidgetRef);
      await settle(tester);
      expect(takeAll(tester), isNull);
      await openTab(tester, 'Hikâye');
      expect(takeAll(tester), isNull);
      expect(find.text('1 / 12'), findsOneWidget);
      await openTab(tester, 'Ana Sayfa');
      expect(takeAll(tester), isNull);
      expect(find.text('The New Neighbour'), findsOneWidget);
    },
  );

  testWidgets('Hikâye ekranından dönüş ve Hi/defter yenilemesi: öteki sekmeler '
      'açılırken hata yok', (tester) async {
    await pumpApp(tester);
    for (final tab in ['Profil', 'Ana Sayfa', 'Hikâye']) {
      await openTab(tester, tab);
    }
    await completeFirstEpisode();
    final story = tester.element(find.byType(StoryScreen)) as WidgetRef;
    await refreshWhenVisible(story as BuildContext, story);
    refreshHi(story);
    refreshNotebook(story);
    await settle(tester);
    expect(takeAll(tester), isNull);
    expect(find.text('1 / 12'), findsOneWidget);
    await openTab(tester, 'Ana Sayfa');
    expect(takeAll(tester), isNull);
    expect(find.text('The New Neighbour'), findsOneWidget);
    await openTab(tester, 'Profil');
    expect(takeAll(tester), isNull);
  });
}
