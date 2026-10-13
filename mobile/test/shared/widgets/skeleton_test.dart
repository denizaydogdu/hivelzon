import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/shared/widgets/skeleton.dart';

Widget _app(Widget child, {bool still = false}) => MaterialApp(
  theme: AppTheme.light(),
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: still, size: const Size(400, 800)),
    child: Scaffold(body: child),
  ),
);

double _opacity(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find.descendant(
        of: find.byType(Skeleton),
        matching: find.byType(FadeTransition),
      ),
    )
    .opacity
    .value;

void main() {
  testWidgets('iskelet: tek duyuru, kutular okunmaz, hafif nabız', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(const ListSkeleton(label: 'Defterin hazırlanıyor…', rows: 3)),
    );
    expect(find.bySemanticsLabel('Defterin hazırlanıyor…'), findsOneWidget);
    expect(find.byType(SkeletonBox), findsNWidgets(9)); // satır başına 3
    final a = _opacity(tester);
    await tester.pump(const Duration(milliseconds: 450));
    final b = _opacity(tester);
    expect(a, isNot(b));
    expect(b, inInclusiveRange(0.55, 1.0));
    handle.dispose();
  });

  testWidgets('hareketi azalt: iskelet durağan', (tester) async {
    await tester.pumpWidget(
      _app(const ContinueCardSkeleton(label: 'Yükleniyor…'), still: true),
    );
    expect(_opacity(tester), 1.0);
    await tester.pump(const Duration(milliseconds: 450));
    expect(_opacity(tester), 1.0);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('harita iskeleti: bölüm yerleri, taşma yok', (tester) async {
    await tester.pumpWidget(
      _app(const MapSkeleton(label: 'Harita yükleniyor…')),
    );
    expect(find.byKey(const ValueKey('skeleton-map')), findsOneWidget);
    // 2 başlık satırı + 6 bölüm yeri.
    expect(find.byType(SkeletonBox), findsNWidgets(8));
    expect(tester.takeException(), isNull);
  });

  testWidgets('kutu rengi temadan: açık ve koyu temada belli belirsiz', (
    tester,
  ) async {
    late Color light, dark;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (c) {
            light = SkeletonBox.colorOf(c);
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Builder(
          builder: (c) {
            dark = SkeletonBox.colorOf(c);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(light.a, closeTo(0.08, 0.01));
    expect(dark.a, closeTo(0.08, 0.01));
  });
}
