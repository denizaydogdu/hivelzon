import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:integration_test/integration_test.dart';

const prefix = String.fromEnvironment('SHOT_PREFIX', defaultValue: 'h097onb');

/// H-097: ilk açılışın bütün adımlarını gerçek uygulamada gezer.
///
/// Temiz (bellek içi) veritabanıyla çalışır; gerçek kullanıcı verisine
/// dokunmaz. Ekran görüntüleri `SHOT_DIR` altına yazılır:
///
///   cd mobile && SHOT_DIR=../.yerel/h097-onboarding flutter drive \
///     --driver=test_driver/integration_test.dart \
///     --target=integration_test/h097_onboarding_test.dart \
///     -d SIMULATOR_ID --dart-define=SHOT_PREFIX=h097onb
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('H-097 açılış akışı', (t) async {
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

    Future<void> shot(String name) async {
      await wait(const Duration(milliseconds: 900));
      await binding.takeScreenshot('$prefix-$name');
      debugPrint('[H097-ONB] görüntü: $prefix-$name');
    }

    Future<void> expectKey(String key) async {
      final ok = await waitFor(find.byKey(ValueKey(key)));
      expect(ok, isTrue, reason: 'Adım bulunamadı: $key');
    }

    final db = AppDatabase.memory();
    addTearDown(() async {
      await t.pumpWidget(const SizedBox.shrink());
      await t.pump(const Duration(seconds: 1));
      await db.close();
    });

    await t.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWith((ref) async {}),
        ],
        child: const HiVelzonApp(),
      ),
    );

    // 1. Karşılama
    await expectKey('onboarding-welcome');
    await wait(const Duration(seconds: 1));
    await shot('01-karsilama');

    // 2. Doğum yılı ve ad
    await t.tap(find.byKey(const ValueKey('onboarding-start')));
    await expectKey('onboarding-about');
    await t.enterText(
      find.byKey(const ValueKey('onboarding-birth-year')),
      '1995',
    );
    await t.enterText(find.byKey(const ValueKey('onboarding-name')), 'Deniz');
    await wait(const Duration(milliseconds: 500));
    await shot('02-hakkinda');

    // 3. Bilgilendirme
    await t.tap(find.byKey(const ValueKey('onboarding-about-next')));
    await expectKey('onboarding-privacy');
    await shot('03-gizlilik');

    // 4. Tercihler
    await t.tap(find.byKey(const ValueKey('onboarding-privacy-next')));
    await expectKey('onboarding-prefs');
    await shot('04-tercihler');

    // 5. Seviye
    await t.tap(find.byKey(const ValueKey('onboarding-prefs-next')));
    await expectKey('onboarding-level');
    await shot('05-seviye');

    // 6. Yerleştirme testi (havuz yüklenemezse doğrudan hazır adımına geçer).
    await t.tap(find.byKey(const ValueKey('onboarding-test-start')));
    final hasTest = await waitFor(
      find.byKey(const ValueKey('placement-prompt')),
      timeout: const Duration(seconds: 30),
    );
    debugPrint('[H097-ONB] yerleştirme testi açıldı=$hasTest');
    if (hasTest) {
      await shot('06-test');

      // "Bilmiyorum" ile hızlıca sonuca kadar ilerle; her soru tek adım.
      for (var i = 0; i < 40; i++) {
        if (find
            .byKey(const ValueKey('placement-result'))
            .evaluate()
            .isNotEmpty) {
          break;
        }
        final dontKnow = find.byKey(const ValueKey('placement-dont-know'));
        if (dontKnow.evaluate().isEmpty) {
          await wait(const Duration(milliseconds: 400));
          continue;
        }
        await t.tap(dontKnow);
        await wait(const Duration(milliseconds: 500));
      }
    }

    // 7. Sonuç
    final hasResult = await waitFor(
      find.byKey(const ValueKey('placement-result')),
      timeout: const Duration(seconds: 15),
    );
    debugPrint('[H097-ONB] sonuç açıldı=$hasResult');
    if (hasResult) {
      await shot('07-sonuc');
      await t.tap(find.byKey(const ValueKey('onboarding-result-next')));
    }

    // 8. Hazır
    await expectKey('onboarding-ready');
    await shot('08-hazir');

    // 9. Ana sayfa
    await t.tap(find.byKey(const ValueKey('onboarding-finish')));
    final home = await waitFor(
      find.byType(NavigationBar),
      timeout: const Duration(seconds: 40),
    );
    expect(home, isTrue, reason: 'Açılış bitince ana sayfa açılmadı');
    await wait(const Duration(seconds: 2));
    await shot('09-ana-sayfa');

    debugPrint('[H097-ONB] akış tamam');
  });
}
