// H-091 golden'ları: kitap sonu anlama (son sayfadan sonra). İlk görünüm,
// yanlış seçimde sakin ipucu + doğru cevap, yeniden anlatmada örnek anlatım,
// Türkçesi ve öz değerlendirme.
//
// Kitap: H-066 deneme kitabı A1-K99 (test kopyası; `comprehension` bloğu
// içerik hattındaki deneme kitabıyla aynı).
// Bilinçli görsel değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_fonts.dart';
import '../support/golden.dart';
import '../support/library_harness.dart';

Future<void> _tap(WidgetTester tester, LibraryHarness h, String key) async {
  final f = find.byKey(ValueKey(key));
  await tester.ensureVisible(f);
  await h.settle(tester);
  await tester.tap(f);
  await h.settle(tester);
}

final _cases = <String, Future<void> Function(WidgetTester, LibraryHarness)>{
  'baslangic': (tester, h) async {},
  'ipucu': (tester, h) async {
    await _tap(tester, h, 'comp-q1-o0'); // yanlış → ipucu
    await _tap(tester, h, 'comp-q2-o1'); // doğru
  },
  'anlatim': (tester, h) async {
    await _tap(tester, h, 'comp-q1-o1');
    await _tap(tester, h, 'comp-q2-o1');
    await _tap(tester, h, 'comp-show-model');
    await _tap(tester, h, 'comp-model-tr-toggle');
    await _tap(tester, h, 'comp-self-all');
    await tester.ensureVisible(find.byKey(const ValueKey('comp-self-reply')));
    await h.settle(tester);
  },
};

void main() {
  setUpAll(loadAppFonts);

  for (final MapEntry(key: id, value: act) in _cases.entries) {
    testWidgets('golden: $id', (tester) async {
      final h = LibraryHarness(suggestedLevel: 'A1');
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99?mod=oku');
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byKey(const ValueKey('reader-next')));
        await h.settle(tester);
      }
      await tester.tap(find.byKey(const ValueKey('reader-finish')));
      await h.settle(tester);
      await act(tester, h);
      await h.settle(tester);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h091_$id.png'),
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    }, skip: skipGoldensOffMac);
  }
}
