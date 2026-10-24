import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:hivelzon/features/onboarding/data/onboarding_store.dart';
import 'package:hivelzon/features/profile/data/user_profile_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('H-097 Keşfet kategori akışları', (t) async {
    late ProviderContainer container;
    Future<void> wait(Duration d) async {
      final end = DateTime.now().add(d);
      while (DateTime.now().isBefore(end)) {
        await t.pump(const Duration(milliseconds: 100));
      }
    }

    Future<bool> waitFor(
      Finder f, {
      Duration timeout = const Duration(seconds: 40),
    }) async {
      final end = DateTime.now().add(timeout);
      while (DateTime.now().isBefore(end)) {
        await t.pump(const Duration(milliseconds: 200));
        if (f.evaluate().isNotEmpty) return true;
      }
      return false;
    }

    final db = AppDatabase.memory();
    final now = DateTime.now().toUtc();
    Future<void> meta(String key, String value) => db
        .into(db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: key, value: value),
        );
    await meta(OnboardingStore.completedKey, now.toIso8601String());
    await meta(OnboardingStore.suggestedLevelKey, 'A1');
    await meta(UserProfileStore.displayNameKey, 'Deniz');
    await meta(NotebookStore.dailyGoalKey, '10');

    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        legacyImportProvider.overrideWith((ref) async {}),
        onboardingGateProvider.overrideWith(_DoneOnboardingGate.new),
      ],
    );
    addTearDown(() async {
      await t.pumpWidget(const SizedBox.shrink());
      await t.pump(const Duration(seconds: 1));
      container.dispose();
      await db.close();
    });

    await t.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const HiVelzonApp(),
      ),
    );
    await waitFor(
      find.byType(NavigationBar),
      timeout: const Duration(seconds: 60),
    );
    final router = container.read(routerProvider);
    router.go(AppRoutes.discover);
    await waitFor(find.byKey(const ValueKey('discover-title')));
    await wait(const Duration(seconds: 3));

    Future<void> shot(String name) async {
      await wait(const Duration(milliseconds: 700));
      await binding.takeScreenshot(name);
    }

    final pages = await waitFor(
      find.byKey(const ValueKey('discover-pages')),
      timeout: const Duration(seconds: 60),
    );
    debugPrint(
      '[DP] pages=$pages error=${find.byKey(const ValueKey('discover-error')).evaluate().length}',
    );
    await wait(const Duration(seconds: 4));
    await shot('d-01-bugun');

    for (final (key, name) in [
      ('chip-storyClips', 'd-02-hikaye'),
      ('chip-cinema', 'd-03-sinema'),
      ('chip-sport', 'd-04-spor'),
      ('chip-book', 'd-05-kitap'),
    ]) {
      final chip = find.byKey(ValueKey(key));
      debugPrint('[DP] $key bulundu=${chip.evaluate().length}');
      if (chip.evaluate().isEmpty) continue;
      await t.tap(chip);
      await wait(const Duration(seconds: 5));
      final err = find
          .byKey(const ValueKey('discover-error'))
          .evaluate()
          .length;
      final pg = find.byKey(const ValueKey('discover-pages')).evaluate().length;
      debugPrint('[DP] $key sonrası error=$err pages=$pg');
      await shot(name);
    }
  });
}

class _DoneOnboardingGate extends OnboardingGateNotifier {
  @override
  OnboardingGate build() => OnboardingGate.done;
}
