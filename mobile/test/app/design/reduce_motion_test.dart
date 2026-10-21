// H-043: "Hareketi azalt" oynatıcının açılışına ve alt panellere (oynatıcı
// görev ve anlam paneli, Keşfet seviye paneli) de uygulanır.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/design/design.dart';

void main() {
  Future<BuildContext> contextWith(WidgetTester tester, bool reduce) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: Builder(
          builder: (c) {
            ctx = c;
            return const SizedBox();
          },
        ),
      ),
    );
    return ctx;
  }

  testWidgets('oynatıcı sayfası: azaltılınca geçişsiz, değilse tam ekran', (
    tester,
  ) async {
    final reduced = await contextWith(tester, true);
    expect(
      fullscreenPage<void>(
        reduced,
        key: const ValueKey('p'),
        child: const SizedBox(),
      ),
      isA<NoTransitionPage<void>>(),
    );
    final normal = await contextWith(tester, false);
    final page = fullscreenPage<void>(
      normal,
      key: const ValueKey('p'),
      child: const SizedBox(),
    );
    expect(page, isA<MaterialPage<void>>());
    expect((page as MaterialPage<void>).fullscreenDialog, isTrue);
  });

  testWidgets('alt panel: azaltılınca animasyonsuz, değilse varsayılan', (
    tester,
  ) async {
    expect(
      AppMotion.sheet(await contextWith(tester, true)),
      AnimationStyle.noAnimation,
    );
    expect(AppMotion.sheet(await contextWith(tester, false)), isNull);
  });

  testWidgets('alt panel azaltılınca ilk karede tam açık', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                sheetAnimationStyle: AppMotion.sheet(context),
                builder: (_) =>
                    const SizedBox(key: ValueKey('sheet'), height: 200),
              ),
              child: const Text('aç'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('aç'));
    await tester.pump();
    await tester.pump();
    final route = ModalRoute.of(
      tester.element(find.byKey(const ValueKey('sheet'))),
    )!;
    expect(route.animation!.status, AnimationStatus.completed);
  });
}
