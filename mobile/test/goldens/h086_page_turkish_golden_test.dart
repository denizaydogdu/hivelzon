// H-086 golden'ları: okuyucuda "Sayfanın Türkçesi" paneli (okuma duraklı,
// okunan cümle panelde işaretli) ve "Satır altı Türkçe" açık sayfa.
//
// Kitap: H-066 deneme kitabı A1-K99 (test kopyası); ağ görselleri testte
// açılmaz, sayfa resmi yerine palet renkli yer tutucu görünür.
// Bilinçli görsel değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';

import '../support/app_fonts.dart';
import '../support/golden.dart';
import '../support/library_harness.dart';

class _Case {
  const _Case(this.location, {this.interlinear = false, this.act});

  final String location;
  final bool interlinear;
  final Future<void> Function(WidgetTester tester, LibraryHarness h)? act;
}

final _cases = <String, _Case>{
  'panel': _Case(
    '/kitap/A1-K99',
    act: (tester, h) async {
      // "The box is red." okunurken panel açılır; ses durur.
      await h.listenFor(tester, 3.4);
      await tester.tap(find.byKey(const ValueKey('reader-page-turkish')));
      await h.settle(tester);
    },
  ),
  'satir_alti': _Case(
    '/kitap/A1-K99',
    interlinear: true,
    act: (tester, h) async {
      await h.listenFor(tester, 3.4);
      await tester.tap(find.byKey(const ValueKey('reader-play')));
      await h.settle(tester);
    },
  ),
};

void main() {
  setUpAll(loadAppFonts);

  for (final MapEntry(key: id, value: c) in _cases.entries) {
    testWidgets('golden: $id', (tester) async {
      final h = LibraryHarness(suggestedLevel: 'A1');
      addTearDown(h.dispose);
      if (c.interlinear) {
        await tester.runAsync(
          () => BookProgressStore(h.db).setInterlinear(true),
        );
      }
      await h.pump(tester, c.location);
      if (c.act != null) await c.act!(tester, h);
      await h.settle(tester);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h086_$id.png'),
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    }, skip: skipGoldensOffMac);
  }
}
