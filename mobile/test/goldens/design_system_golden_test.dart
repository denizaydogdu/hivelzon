// Tasarım sistemi golden testleri (H-057).
//
// Gömülü yazı tipleriyle (Inter, Nunito) ve Material ikonlarıyla çizilir.
// Görseller `test/goldens/images/` altında. Bilinçli bir görsel değişiklikten
// sonra güncelle:
//
//   cd mobile && flutter test --update-goldens test/goldens
//
// Not: Golden'lar macOS'ta üretildi; yazı çizimi işletim sistemine göre
// birkaç piksel değişebilir. Başka bir platformda (CI) çalıştırılacaksa o
// platformda yeniden üretilir.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/design_showcase/design_showcase_screen.dart';

import '../support/app_fonts.dart';

const _width = 390.0;

Future<void> _pumpSection(
  WidgetTester tester,
  Widget section, {
  required double height,
}) async {
  tester.view.physicalSize = const Size(_width * 2, 0) + Offset(0, height * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Scaffold(
        body: RepaintBoundary(
          key: const ValueKey('golden'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.page),
            child: SingleChildScrollView(child: section),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  final sections = <String, (Widget, double)>{
    'header': (const ShowcaseHeaderSection(), 460),
    'colors': (const ShowcaseColorsSection(), 640),
    'type': (const ShowcaseTypeSection(), 640),
    'spacing': (const ShowcaseSpacingSection(), 520),
    'buttons': (const ShowcaseButtonsSection(), 620),
    'cards': (const ShowcaseCardsSection(), 820),
    'settings': (const ShowcaseSettingsSection(), 480),
    'progress': (const ShowcaseProgressSection(), 320),
    'empty': (const ShowcaseEmptySection(), 440),
  };

  for (final MapEntry(key: name, value: (widget, height)) in sections.entries) {
    testWidgets('golden: $name', (tester) async {
      await _pumpSection(tester, widget, height: height);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/showcase_$name.png'),
      );
    });
  }

  testWidgets(
    'vitrin: erişilebilirlik yönergeleri (dokunma, etiket, kontrast)',
    (tester) async {
      final handle = tester.ensureSemantics();
      // Bütün vitrin tek ekranda görünsün diye uzun yüzey.
      tester.view.physicalSize = const Size(_width * 2, 9000 * 2);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const DesignShowcaseScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    },
  );

  testWidgets('vitrin: metin 1,3× büyütülünce taşma yok', (tester) async {
    tester.view.physicalSize = const Size(_width * 2, 9000 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.3)),
            child: const DesignShowcaseScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
