// H-068 simülatör denemesi: kitap sesi uygulama arka plandayken sürer.
//
// Kitap sesli açılır; test "[H068] ARKA PLAN" yazınca dışarıdan uygulama
// arka plana alınır (ör. `xcrun simctl launch <cihaz> com.apple.Preferences`),
// birkaç saniye sonra öne getirilir (`xcrun simctl launch <cihaz>
// tr.velzon.hivelzon`). Test, arka planda geçen sürede çaların konumunun
// ilerlediğini (ses durmadı) ve okuyucu kapanınca oturumun kapandığını sınar.
// Veri değiştirir (kitap ilerlemesi); geçici simülatörde çalıştırın.
//
//   cd mobile && flutter drive --driver=test_driver/integration_test.dart \
//     --target=integration_test/h068_background_test.dart -d <geçici cihaz> \
//     --dart-define=CONTENT_BASE_URL=http://127.0.0.1:8787 \
//     --dart-define=H068_BOOK=A1-K01
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/features/library/application/audio_service_host.dart';
import 'package:hivelzon/features/library/application/background_book_audio.dart';
import 'package:hivelzon/features/library/application/library_providers.dart';
import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:integration_test/integration_test.dart';

const bookId = String.fromEnvironment('H068_BOOK', defaultValue: 'A1-K01');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('H-068: arka planda ses sürer, kapanınca oturum kapanır', (
    t,
  ) async {
    unawaited(AudioServiceBookSessionHost.start());
    final states = <AppLifecycleState>[];
    final listener = AppLifecycleListener(onStateChange: states.add);
    addTearDown(listener.dispose);

    JustAudioEngine? engine;
    Future<void> wait(Duration d) async {
      final end = DateTime.now().add(d);
      while (DateTime.now().isBefore(end)) {
        await t.pump(const Duration(milliseconds: 100));
      }
    }

    await t.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingGateProvider.overrideWith(_DoneOnboardingGate.new),
          bookAudioFactoryProvider.overrideWithValue(
            () => BackgroundBookAudio(
              engine: engine = JustAudioEngine(),
              host: AudioServiceBookSessionHost.instance,
            ),
          ),
        ],
        child: const HiVelzonApp(),
      ),
    );
    final end = DateTime.now().add(const Duration(seconds: 60));
    while (find.byType(NavigationBar).evaluate().isEmpty &&
        DateTime.now().isBefore(end)) {
      await t.pump(const Duration(milliseconds: 200));
    }
    final router = GoRouter.of(t.element(find.byType(NavigationBar)));
    unawaited(router.push('/kitap/$bookId?mod=dinle'));
    await wait(const Duration(seconds: 5));
    expect(engine, isNotNull);
    final p0 = engine!.position;
    debugPrint('[H068] ön planda konum: ${p0.toStringAsFixed(2)} sn');
    expect(p0, greaterThan(1));
    expect(AudioServiceBookSessionHost.instance.owner, isNotNull);

    debugPrint('[H068] ARKA PLAN');
    final bgAt = DateTime.now();
    // Arka planda kare çizilmez; düz bekleme (öne dönünce sürer).
    while (!states.contains(AppLifecycleState.paused) ||
        !(states.isNotEmpty && states.last == AppLifecycleState.resumed)) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (DateTime.now().difference(bgAt) > const Duration(seconds: 60)) {
        fail('uygulama arka plana alınıp öne getirilmedi: $states');
      }
    }
    final pausedAt = states.indexOf(AppLifecycleState.paused);
    final elapsed = DateTime.now().difference(bgAt).inMilliseconds / 1000;
    final p1 = engine!.position;
    debugPrint(
      '[H068] durumlar: $states; geçen ${elapsed.toStringAsFixed(1)} sn, '
      'konum ${p0.toStringAsFixed(2)} → ${p1.toStringAsFixed(2)} sn',
    );
    expect(pausedAt, greaterThanOrEqualTo(0));
    // Ses arka planda sürdü: konum geçen sürenin çoğu kadar ilerledi
    // (bölüm sonu geçişi payı).
    expect(p1 - p0, greaterThan(elapsed * 0.7));

    await wait(const Duration(seconds: 1));
    final close = find.byKey(const ValueKey('reader-close'));
    await t.tap(close);
    await wait(const Duration(seconds: 2));
    expect(AudioServiceBookSessionHost.instance.owner, isNull);
    debugPrint('[H068] okuyucu kapandı, oturum kapandı');
  });
}

class _DoneOnboardingGate extends OnboardingGateNotifier {
  @override
  OnboardingGate build() => OnboardingGate.done;
}
