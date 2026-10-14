// H-039 açılış golden'ları: karşılama, doğum yılı ve ad, bilgilendirme,
// seviye, soru, sonuç ve hazır adımları (390 × 844, gömülü yazı tipleri).
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:hivelzon/features/onboarding/presentation/onboarding_screen.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/shared/api/token_store.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../support/app_fonts.dart';
import '../support/fake_api_server.dart';
import '../support/fake_content_source.dart';
import '../support/golden.dart';
import '../support/placement.dart';

void main() {
  setUpAll(loadAppFonts);
  setUp(() => SyncController.listenLifecycle = false);
  tearDown(() => SyncController.listenLifecycle = true);

  testWidgets('golden: açılış adımları', (tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final bank = loadBank();

    Future<void> settle([int frames = 10]) async {
      for (var i = 0; i < frames; i++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    Future<void> tapKey(String key) async {
      final f = find.byKey(ValueKey(key));
      await tester.ensureVisible(f);
      await tester.pump();
      await tester.tap(f);
      await settle();
    }

    Future<void> shot(String step, String name) async {
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(ValueKey('onboarding-$step')),
        matchesGoldenFile('images/h039_$name.png'),
      );
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(FakeContentSource()),
          seasonIntroRepositoryProvider.overrideWithValue(
            InMemorySeasonIntroRepository(),
          ),
          apiHttpClientProvider.overrideWithValue(FakeApiServer().client),
          tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
          placementBankProvider.overrideWith((ref) async => bank),
        ],
        child: const HiVelzonApp(),
      ),
    );
    await settle();
    final context = tester.element(
      find.byKey(const ValueKey('onboarding-welcome')),
    );
    await tester.runAsync(
      () => precacheImage(OnboardingScreen.welcomeImage, context),
    );
    await settle();
    await shot('welcome', 'karsilama');

    await tapKey('onboarding-start');
    await tester.enterText(
      find.byKey(const ValueKey('onboarding-birth-year')),
      '2008',
    );
    await tester.enterText(
      find.byKey(const ValueKey('onboarding-name')),
      'Deniz',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await shot('about', 'hakkinda');

    await tapKey('onboarding-about-next');
    await shot('privacy', 'bilgilendirme');
    await tapKey('onboarding-privacy-next');
    await shot('prefs', 'ayarlar');
    await tapKey('onboarding-prefs-next');
    await shot('level', 'seviye');

    await tapKey('onboarding-test-start');
    // A1'in okuma maddesine kadar ilerle (3 doğru).
    for (var i = 0; i < 3; i++) {
      final prompt = tester
          .widget<Text>(find.byKey(const ValueKey('placement-prompt')))
          .data!;
      final item = bank.stages.values
          .expand((s) => s)
          .firstWhere((i) => i.prompt == prompt);
      await tapKey('placement-option-${item.answer}');
    }
    await shot('test', 'soru_okuma');
    for (var i = 0; i < 5; i++) {
      await tapKey('placement-dont-know');
    }
    await shot('result', 'sonuc');
    await tapKey('onboarding-result-next');
    await shot('ready', 'hazir');

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }, skip: skipGoldensOffMac);
}
