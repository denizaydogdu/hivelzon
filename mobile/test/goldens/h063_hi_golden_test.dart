// H-063: Hi'nin ifadeleri (kodla çizim) golden'ları. Her ifade kum zeminde,
// ışıklı, dinlenme anında (nabız ve el sallama bitmiş). Bilinçli görsel
// değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/player/presentation/widgets/hi_avatar.dart';

import '../support/golden.dart';

void main() {
  for (final e in HiExpression.values) {
    testWidgets('golden: Hi ${e.name}', (tester) async {
      tester.view.physicalSize = const Size(200 * 2, 200 * 2);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          home: Scaffold(
            backgroundColor: AppPalette.sand,
            body: Center(
              child: RepaintBoundary(
                key: const ValueKey('golden'),
                child: ColoredBox(
                  color: AppPalette.sand,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpace.s16),
                    child: HiAvatar(size: 160, expression: e, pulseCycles: 1),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h063_hi_${e.name}.png'),
      );
    }, skip: skipGoldensOffMac);
  }
}
