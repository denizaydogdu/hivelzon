// H-064: alt sekme etiketleri dar ekranda, büyük yazıda tek satır kalır.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/content/content_providers.dart';

import '../support/app_fonts.dart';
import '../support/fake_content_source.dart';
import '../support/onboarding.dart';

const _labels = [
  TabTexts.home,
  TabTexts.discover,
  TabTexts.story,
  TabTexts.talk,
  TabTexts.profile,
];

void main() {
  setUpAll(loadAppFonts);

  Future<void> pumpShell(
    WidgetTester tester, {
    required Size size,
    required double textScale,
  }) async {
    tester.view.physicalSize = size * 2;
    tester.view.devicePixelRatio = 2;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingDoneOverride,
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
  }

  for (final (size, scale) in [
    (const Size(320, 568), 1.3),
    (const Size(320, 568), 1.0),
    (const Size(393, 852), 1.3),
  ]) {
    testWidgets(
      'sekme etiketleri tek satır: ${size.width.toInt()} pt, ${scale}x',
      (tester) async {
        await pumpShell(tester, size: size, textScale: scale);
        expect(tester.takeException(), isNull);
        final nav = find.byType(NavigationBar);
        final slot = size.width / _labels.length;
        for (final label in _labels) {
          final text = find.descendant(of: nav, matching: find.text(label));
          expect(text, findsOneWidget);
          final paragraph = tester.renderObject<RenderParagraph>(text);
          // Tek satır: yükseklik bir satır yüksekliğini aşmaz ve metin
          // kesilmeden sığar.
          final lineHeight =
              paragraph.textScaler.scale(AppTypography.navLabel.fontSize!) *
              AppTypography.navLabel.height!;
          expect(
            paragraph.size.height,
            lessThanOrEqualTo(lineHeight + 0.5),
            reason: '$label iki satıra bölündü',
          );
          expect(paragraph.didExceedMaxLines, isFalse, reason: label);
          expect(paragraph.size.width, lessThanOrEqualTo(slot), reason: label);
        }
      },
    );
  }

  test('geniş ekranda kullanıcının ölçeği (en çok 1,3×) korunur', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    expect(
      AppTypography.navLabelFitScale(200, _labels),
      AppTypography.navLabelMaxScale,
    );
  });
}
