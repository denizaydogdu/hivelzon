// H-059 simülatör ekran görüntüleri: Profil (üst + alt), Günlük hedef ve Ad
// panelleri, Hesap, "Hi benim hakkımda ne biliyor?", hukuk metni.
//
// Yalnızca gezinir ve görüntü alır; veri değiştirmez (panel açılır, seçim
// yapılmadan kapatılır). Gerçek kullanıcı verisiyle çalışır; önce yedek alın.
//
//   cd mobile && SHOT_DIR=../.yerel/h059 flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/h059_screens_test.dart \
//     -d <simülatör> --dart-define=SHOT_PREFIX=sonra
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/app.dart';
import 'package:integration_test/integration_test.dart';

const prefix = String.fromEnvironment('SHOT_PREFIX', defaultValue: 'sonra');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('H-059 ekranları', (t) async {
    Future<void> wait(Duration d) async {
      final end = DateTime.now().add(d);
      while (DateTime.now().isBefore(end)) {
        await t.pump(const Duration(milliseconds: 100));
      }
    }

    Future<void> waitFor(Finder f, {int seconds = 30}) async {
      final end = DateTime.now().add(Duration(seconds: seconds));
      while (DateTime.now().isBefore(end)) {
        await t.pump(const Duration(milliseconds: 200));
        if (f.evaluate().isNotEmpty) return;
      }
      throw TestFailure('Bulunamadı: $f');
    }

    Future<void> shot(String name) async {
      await wait(const Duration(milliseconds: 1200));
      await binding.takeScreenshot('$prefix-$name');
      debugPrint('[H059] görüntü: $prefix-$name');
    }

    GoRouter router() => GoRouter.of(t.element(find.byType(NavigationBar)));

    Future<void> go(String path) async {
      router().go(path);
      await wait(const Duration(milliseconds: 1500));
    }

    await t.pumpWidget(const ProviderScope(child: HiVelzonApp()));
    await waitFor(find.byType(NavigationBar), seconds: 60);
    await wait(const Duration(seconds: 3));

    // Profil: üst ve alt.
    await go('/profil');
    await shot('profil');
    final list = find.byType(Scrollable).first;
    await t.drag(list, const Offset(0, -2000));
    await wait(const Duration(milliseconds: 800));
    await shot('profil-alt');
    await t.drag(list, const Offset(0, 2000));
    await wait(const Duration(milliseconds: 500));

    // Paneller (yalnızca yeni tasarımda).
    for (final (key, name) in [
      ('profile-goal', 'gunluk-hedef'),
      ('profile-name-row', 'ad'),
    ]) {
      final f = find.byKey(ValueKey(key));
      if (f.evaluate().isEmpty) continue;
      await t.ensureVisible(f);
      await t.tap(f);
      await wait(const Duration(milliseconds: 900));
      await shot(name);
      final close = find.byTooltip('Kapat');
      if (close.evaluate().isNotEmpty) {
        await t.tap(close.last);
      } else {
        Navigator.of(t.element(f)).pop();
      }
      await wait(const Duration(milliseconds: 700));
    }

    await go('/profil/hesap');
    await shot('hesap');
    await go('/profil/hi');
    await shot('hi-gizlilik');
    final hiList = find.byType(Scrollable).last;
    await t.drag(hiList, const Offset(0, -2000));
    await wait(const Duration(milliseconds: 800));
    await shot('hi-gizlilik-alt');
    await go('/profil/hesap/metin/kosullar');
    await shot('hukuk');
    await go('/profil');
  });
}
