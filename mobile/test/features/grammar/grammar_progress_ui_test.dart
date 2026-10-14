import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/grammar/data/grammar_progress_store.dart';

import '../../support/fake_content_source.dart';
import '../../support/grammar_harness.dart';

const _second = 'G-A1-02-there-is';
const _third = 'G-A1-03-a-an';
const _a2 = 'G-A2-01-was-were';

/// Dilbilgisi listesinde ilerleme (H-064 ek): yarım derste ince çubuk ve
/// "%43 ilerledin", biten derste onay ve "Tamamladın", başlanmamışta sakin
/// (yazı yok); seviye raflarında "A1 · 1/3 tamamlandı".
void main() {
  Finder key(String k) => find.byKey(ValueKey(k));

  Future<GrammarHarness> open(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    final h = GrammarHarness(
      lessonIds: [kTestLessonId, _second, _third, _a2],
      titles: {
        _second: 'There is / there are',
        _third: 'a / an',
        _a2: 'was / were',
      },
      suggestedLevel: 'A1',
    );
    addTearDown(h.dispose);
    await tester.runAsync(() async {
      final store = GrammarProgressStore(h.db);
      await store.markCard(kTestLessonId, 'c03');
      await store.markCard(_second, 'c02');
      await store.markCompleted(_second);
    });
    await h.pump(tester, '/hikaye', size: size, textScale: textScale);
    await tester.tap(find.text('Dilbilgisi'));
    await h.settle(tester);
    return h;
  }

  testWidgets('yarım, bitmiş ve başlanmamış ders; seviye özeti', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await open(tester);

    // Yarım: 3 / 7 kart → %43.
    expect(key('lesson-tile-progress-$kTestLessonId'), findsOneWidget);
    expect(find.text('%43 ilerledin'), findsOneWidget);
    final bar = tester.widget<LinearProgressIndicator>(
      find.descendant(
        of: key('lesson-tile-progress-$kTestLessonId'),
        matching: find.byType(LinearProgressIndicator),
      ),
    );
    expect(bar.value, closeTo(0.43, 0.001));
    expect(
      find.bySemanticsLabel(
        RegExp('^Üçüncü tekil -s, A1 seviyesi, .*yüzde 43 ilerledin\$'),
      ),
      findsOneWidget,
    );

    // Başlanmamış: çubuk ve yazı yok.
    expect(key('lesson-tile-$_third'), findsOneWidget);
    expect(key('lesson-tile-progress-$_third'), findsNothing);
    expect(
      find.bySemanticsLabel(
        RegExp('^a / an, A1 seviyesi, yaklaşık 3 dakika\$'),
      ),
      findsOneWidget,
    );

    // Seviye özetleri (biten ders "Tamamladıkların"da olsa da sayılır).
    expect(find.text('A1 · 1/3 tamamlandı'), findsOneWidget);
    expect(find.text('A2 · 0/1 tamamlandı'), findsOneWidget);
    expect(
      find.bySemanticsLabel('A1 seviyesinde 3 konudan 1 tanesi tamamlandı'),
      findsOneWidget,
    );

    // Bitmiş: onay ve "Tamamladın", çubuk yok.
    final list = find.descendant(
      of: key('grammar-view'),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      key('lesson-tile-$_second'),
      200,
      scrollable: list.first,
    );
    expect(
      find.descendant(
        of: key('grammar-shelf-completed'),
        matching: key('lesson-done-tick'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Tamamladın'), findsOneWidget);
    expect(key('lesson-tile-progress-$_second'), findsNothing);
    expect(
      find.bySemanticsLabel(RegExp('^There is / there are, .*tamamladın\$')),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('320 × 568, metin 1,3×: taşma yok', (tester) async {
    await open(tester, size: const Size(320, 568), textScale: 1.3);
    expect(tester.takeException(), isNull);
    expect(find.text('%43 ilerledin'), findsOneWidget);
  });
}
