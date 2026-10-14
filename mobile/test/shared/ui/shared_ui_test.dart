import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/shared/ui/ui.dart';

Widget _app(Widget child, {bool still = false}) => MaterialApp(
  theme: AppTheme.light(),
  home: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: still),
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  ),
);

double _scaleOf(WidgetTester tester) =>
    tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;

void main() {
  testWidgets('PressScale: basınca 0,97; bırakınca 1', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(TappableCard(onTap: () => taps++, child: const Text('Kart'))),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Kart')),
    );
    await tester.pump();
    expect(_scaleOf(tester), AppMotion.pressScale);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(_scaleOf(tester), 1);
    expect(taps, 1);
  });

  testWidgets('PressScale: hareketi azalt açıksa ölçek değişmez', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(TappableCard(onTap: () {}, child: const Text('Kart')), still: true),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Kart')),
    );
    await tester.pump();
    expect(_scaleOf(tester), 1);
    await gesture.up();
  });

  testWidgets('StaggeredList: sırayla belirir; hareketi azalt → durağan', (
    tester,
  ) async {
    final items = [for (var i = 0; i < 3; i++) Text('öğe $i')];
    await tester.pumpWidget(_app(StaggeredList(children: items)));
    expect(find.byType(Animate), findsNWidgets(3));
    await tester.pumpAndSettle();
    expect(find.text('öğe 2'), findsOneWidget);

    await tester.pumpWidget(_app(StaggeredList(children: items), still: true));
    expect(find.byType(Animate), findsNothing);
    expect(find.text('öğe 0'), findsOneWidget);
  });

  testWidgets('ProgressRing: tek duyuru ve değer; azaltılmışsa anında dolu', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        const ProgressRing(
          value: 0.6,
          semanticLabel: 'Günlük hedef: 6 / 10 dk',
        ),
        still: true,
      ),
    );
    expect(
      tester.getSemantics(find.byType(ProgressRing)),
      matchesSemantics(label: 'Günlük hedef: 6 / 10 dk', value: '%60'),
    );
    final tween = tester.widget<TweenAnimationBuilder<double>>(
      find.byType(TweenAnimationBuilder<double>),
    );
    expect(tween.duration, Duration.zero);
    handle.dispose();
  });

  testWidgets('CapsLabel: Türkçe büyük harf, ekran okuyucuya normal yazım', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(const CapsLabel('ipucu bölüm')));
    expect(find.text('İPUCU BÖLÜM'), findsOneWidget);
    expect(find.bySemanticsLabel('ipucu bölüm'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('SettingsRow.toggle: satıra dokununca değişir, durum okunur', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var on = false;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => _app(
          SettingsGroup(
            title: 'Öğrenme',
            children: [
              SettingsRow.toggle(
                title: 'Söyle alıştırmaları',
                value: on,
                onChanged: (v) => setState(() => on = v),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Söyle alıştırmaları'));
    await tester.pumpAndSettle();
    expect(on, isTrue);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    expect(
      tester.getSemantics(find.byType(SettingsRow)),
      matchesSemantics(
        hasToggledState: true,
        isToggled: true,
        label: 'Söyle alıştırmaları',
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );
    expect(
      tester.getSize(find.byType(SettingsRow)).height,
      greaterThanOrEqualTo(AppTouch.min),
    );
    handle.dispose();
  });

  testWidgets('showAppSheet: başlık, Kapat düğmesi kapatır', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showAppSheet<void>(
                context: context,
                title: 'Anlam',
                builder: (_) => const Text('içerik'),
              ),
              child: const Text('aç'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('aç'));
    await tester.pumpAndSettle();
    expect(find.text('Anlam'), findsOneWidget);
    expect(find.text('içerik'), findsOneWidget);
    await tester.tap(find.byTooltip('Kapat'));
    await tester.pumpAndSettle();
    expect(find.text('içerik'), findsNothing);
  });

  testWidgets('InfoCard: her ton çizilir, eylem görünür', (tester) async {
    await tester.pumpWidget(
      _app(
        Column(
          children: [
            for (final t in InfoTone.values)
              InfoCard(tone: t, title: t.name, body: 'açıklama'),
            InfoCard(
              title: 'eylemli',
              action: TextButton(onPressed: () {}, child: const Text('Tamam')),
            ),
          ],
        ),
      ),
    );
    for (final t in InfoTone.values) {
      expect(find.text(t.name), findsOneWidget);
    }
    expect(find.text('Tamam'), findsOneWidget);
  });

  testWidgets('sayfa geçişi: hareketi azalt açıksa sayfa doğrudan', (
    tester,
  ) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
        still: true,
      ),
    );
    const child = Text('sayfa');
    final out = appFadeThroughTransition(
      ctx,
      const AlwaysStoppedAnimation(0.2),
      const AlwaysStoppedAnimation(0),
      child,
    );
    expect(identical(out, child), isTrue);
  });
}
