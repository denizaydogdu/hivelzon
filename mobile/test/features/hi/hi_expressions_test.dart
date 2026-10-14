// H-063: Hi'nin ifadeleri, geçişleri, nefes, selamlama ve "hareketi azalt".
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/hi/domain/coach_rules.dart';
import 'package:hivelzon/features/hi/presentation/hi_bubble.dart';
import 'package:hivelzon/features/hi/presentation/hi_expressions.dart';
import 'package:hivelzon/features/player/presentation/widgets/hi_avatar.dart';
import 'package:hivelzon/features/player/presentation/widgets/hi_face.dart';
import 'package:hivelzon/features/player/presentation/widgets/hi_painter.dart';

const _label = 'Hi, yapay zekâ yardımcın';

Widget _host(Widget child, {bool reduce = false}) => MaterialApp(
  theme: AppTheme.light(),
  home: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: reduce),
      child: Scaffold(body: Center(child: child)),
    ),
  ),
);

HiPainter _painter(WidgetTester tester, [Finder? avatar]) {
  final paint = tester.widget<CustomPaint>(
    find.descendant(
      of: avatar ?? find.byType(HiAvatar),
      matching: find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is HiPainter,
      ),
    ),
  );
  return paint.painter! as HiPainter;
}

double _scale(WidgetTester tester) {
  final t = tester.widget<Transform>(
    find.descendant(
      of: find.byType(HiAvatar),
      matching: find.byType(Transform),
    ),
  );
  return t.transform.getMaxScaleOnAxis();
}

void main() {
  group('ifade değerleri', () {
    test('her ifadenin kendi yüzü var; varsayılan H-005 çizimi', () {
      expect(HiFace.of(HiExpression.neutral), const HiFace());
      final faces = HiExpression.values.map(HiFace.of).toSet();
      expect(faces, hasLength(HiExpression.values.length));
    });

    test('ara değer iki yüzün arasında; uçlar kendisi', () {
      const a = HiFace.neutral, b = HiFace.happy;
      expect(HiFace.lerp(a, b, 0), a);
      expect(HiFace.lerp(a, b, 1), b);
      final mid = HiFace.lerp(a, b, 0.5);
      expect(mid.eyeSmile, closeTo(0.5, 1e-9));
      expect(mid, isNot(a));
      expect(mid, isNot(b));
    });

    test('panel önerisi → ifade; dinlenme yalnız geç akşam uykulu', () {
      final noon = DateTime(2026, 10, 14, 12);
      final night = DateTime(2026, 10, 14, 22, 30);
      final early = DateTime(2026, 10, 15, 3);
      HiExpression m(HiSuggestionKind k, [DateTime? at]) =>
          hiExpressionForSuggestion(k, now: at ?? noon);
      expect(m(HiSuggestionKind.errorNote), HiExpression.thinking);
      expect(m(HiSuggestionKind.rest), HiExpression.happy);
      expect(m(HiSuggestionKind.rest, night), HiExpression.sleepy);
      expect(m(HiSuggestionKind.rest, early), HiExpression.sleepy);
      expect(m(HiSuggestionKind.startEpisode), HiExpression.happy);
      expect(m(HiSuggestionKind.continueEpisode), HiExpression.happy);
      expect(m(HiSuggestionKind.sceneHunt), HiExpression.happy);
      expect(m(HiSuggestionKind.startBook), HiExpression.happy);
      expect(m(HiSuggestionKind.continueBook), HiExpression.happy);
      expect(m(HiSuggestionKind.review), HiExpression.neutral);
      expect(m(HiSuggestionKind.notebook), HiExpression.neutral);
      expect(isLateEvening(DateTime(2026, 1, 1, 20, 59)), isFalse);
      expect(isLateEvening(DateTime(2026, 1, 1, 21)), isTrue);
      expect(isLateEvening(DateTime(2026, 1, 1, 5)), isFalse);
    });
  });

  group('HiAvatar', () {
    for (final e in HiExpression.values) {
      testWidgets('ifade: ${e.name} çizilir, etiket aynı kalır', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _host(HiAvatar(size: 96, glow: false, expression: e)),
        );
        await tester.pump(AppMotion.slow);
        await tester.pump(HiAvatar.waveDuration);
        expect(_painter(tester).face, HiFace.of(e));
        expect(find.bySemanticsLabel(_label), findsOneWidget);
        expect(tester.takeException(), isNull);
        handle.dispose();
      });
    }

    testWidgets('ifade değişince yüz yumuşakça geçer', (tester) async {
      Widget hi(HiExpression e) => _host(HiAvatar(glow: false, expression: e));
      await tester.pumpWidget(hi(HiExpression.neutral));
      expect(_painter(tester).face, HiFace.neutral);

      await tester.pumpWidget(hi(HiExpression.happy));
      await tester.pump(AppMotion.slow ~/ 2);
      final mid = _painter(tester).face;
      expect(mid, isNot(HiFace.neutral));
      expect(mid, isNot(HiFace.happy));
      expect(mid.eyeSmile, inExclusiveRange(0, 1));

      await tester.pump(AppMotion.slow);
      expect(_painter(tester).face, HiFace.happy);

      // Uykuluya geçerken göz kapakları iner.
      await tester.pumpWidget(hi(HiExpression.sleepy));
      await tester.pump(AppMotion.slow ~/ 2);
      final lid = _painter(tester).face.eyeOpen;
      expect(lid, inExclusiveRange(HiFace.sleepy.eyeOpen, 1));
      await tester.pump(AppMotion.slow);
      expect(_painter(tester).face, HiFace.sleepy);
    });

    testWidgets('hareketi azalt: geçiş anlık, nabız ve nefes yok', (
      tester,
    ) async {
      final expr = ValueNotifier(HiExpression.neutral);
      addTearDown(expr.dispose);
      await tester.pumpWidget(
        _host(
          ValueListenableBuilder<HiExpression>(
            valueListenable: expr,
            builder: (context, e, _) =>
                HiAvatar(expression: e, breathe: true, greet: true),
          ),
          reduce: true,
        ),
      );
      // Selamlama atlanır: doğrudan istenen ifade.
      expect(_painter(tester).face, HiFace.neutral);
      expect(tester.hasRunningAnimations, isFalse);
      expect(_scale(tester), 1);
      expect(_painter(tester).blink, 0);

      expr.value = HiExpression.happy;
      await tester.pump();
      expect(_painter(tester).face, HiFace.happy);

      expr.value = HiExpression.waving;
      await tester.pump();
      expect(_painter(tester).face, HiFace.waving);
      expect(_painter(tester).wave, 0);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('nefes: çok hafif ve yavaş; birkaç döngüden sonra durur', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const HiAvatar(size: 58, pulseCycles: 2, breathe: true)),
      );
      expect(tester.hasRunningAnimations, isTrue);
      // Yarım nefes: en büyük ölçek (%2,5'i geçmez).
      await tester.pump(HiAvatar.idlePeriod ~/ 2);
      final peak = _scale(tester);
      expect(peak, greaterThan(1));
      expect(peak, lessThanOrEqualTo(1 + HiAvatar.breathAmplitude + 1e-9));
      // Döngüler bitince durağan: ölçek 1, ışık dinlenme değerinde.
      await tester.pump(HiAvatar.idlePeriod * 2);
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
      expect(_scale(tester), 1);
      expect(_painter(tester).glow, closeTo(0.55, 1e-9));
      expect(_painter(tester).blink, 0);
    });

    testWidgets('nefes sırasında bir kez göz kırpar', (tester) async {
      await tester.pumpWidget(
        _host(const HiAvatar(pulseCycles: 1, breathe: true)),
      );
      var maxBlink = 0.0;
      for (var i = 0; i < 48; i++) {
        await tester.pump(HiAvatar.idlePeriod ~/ 48);
        final b = _painter(tester).blink;
        if (b > maxBlink) maxBlink = b;
      }
      expect(maxBlink, greaterThan(0.5));
      expect(maxBlink, lessThanOrEqualTo(1));
    });

    testWidgets('selamlama: bir kez el sallar, sonra istenen ifade', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const HiAvatar(
            glow: false,
            expression: HiExpression.happy,
            greet: true,
          ),
        ),
      );
      await tester.pump(HiAvatar.waveDuration ~/ 4);
      final waving = _painter(tester);
      expect(waving.face.hand, greaterThan(0));
      await tester.pump(HiAvatar.waveDuration ~/ 2);
      // El salınımı -1…1 arasında.
      expect(_painter(tester).wave.abs(), lessThanOrEqualTo(1));
      await tester.pump(HiAvatar.waveDuration);
      await tester.pump(AppMotion.slow);
      await tester.pump(AppMotion.slow);
      expect(_painter(tester).face, HiFace.happy);
      expect(_painter(tester).wave, 0);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('Hi balonu', () {
    testWidgets('nefes alır; etiket ve dokunma alanı değişmedi (≥ 48)', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [hiBadgeProvider.overrideWith((ref) async => false)],
          child: _host(const HiBubble()),
        ),
      );
      await tester.pump();
      final bubble = find.byKey(const ValueKey('hi-bubble'));
      expect(tester.getSize(bubble).width, greaterThanOrEqualTo(48));
      expect(tester.getSize(bubble).height, greaterThanOrEqualTo(48));
      expect(find.bySemanticsLabel("Hi'yi aç"), findsOneWidget);
      final avatar = tester.widget<HiAvatar>(find.byType(HiAvatar));
      expect(avatar.breathe, isTrue);
      expect(avatar.pulseCycles, HiBubble.breathCycles);
      // Rozet yok (öneri yok); sayı ya da ısrarlı işaret yok.
      expect(find.byKey(const ValueKey('hi-bubble-badge')), findsNothing);
      await tester.pump(HiAvatar.idlePeriod * (HiBubble.breathCycles + 1));
      expect(tester.hasRunningAnimations, isFalse);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('hareketi azalt: balon durağan', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [hiBadgeProvider.overrideWith((ref) async => false)],
          child: _host(const HiBubble(), reduce: true),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
      expect(_scale(tester), 1);
    });
  });
}
