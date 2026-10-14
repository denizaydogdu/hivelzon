// H-078 ekran golden'ları ve erişilebilirlik denetimi: Dilbilgisi rafları,
// bölüm panelindeki "Bu bölümdeki dilbilgisi", ders anlatım kartı (şemalar),
// alıştırma (yanlış → kısa açıklama), kural kartı (Defter'e eklendi) ve
// dersin sonu (sakin kutlama).
//
// Ders: H-077 deneme dersi G-A1-99 (test kopyası; ses sahte, saat durur).
// Bilinçli görsel değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';

import '../support/app_fonts.dart';
import '../support/fake_content_source.dart';
import '../support/golden.dart';
import '../support/grammar_harness.dart';

const _route = '/dilbilgisi/$kTestLessonId';

class _Case {
  const _Case(this.location, {this.prepare, this.act});

  final String location;
  final Future<void> Function(GrammarHarness h)? prepare;
  final Future<void> Function(WidgetTester tester, GrammarHarness h)? act;
}

Future<void> _tap(WidgetTester tester, GrammarHarness h, String key) async {
  final f = find.byKey(ValueKey(key));
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await h.settle(tester);
}

final _cases = <String, _Case>{
  'dilbilgisi': _Case(
    '/hikaye',
    prepare: (h) => BookProgressStore(
      h.db,
    ).savePosition('A1-K99', chapterId: 'c1', pageNumber: 1, sentenceIndex: 0),
    act: (tester, h) async {
      await tester.tap(find.text('Dilbilgisi'));
      await h.settle(tester);
    },
  ),
  'bolum_paneli': _Case(
    '/hikaye',
    act: (tester, h) async {
      await tester.tap(find.byKey(const ValueKey('map-node-1')));
      await h.settle(tester);
    },
  ),
  'ders_anlatim': _Case(
    _route,
    act: (tester, h) async {
      await h.next(tester);
      // Ses durur: düğme "Dinle" kalır (saat ilerlemez, vurgu yok).
      await _tap(tester, h, 'lesson-listen');
    },
  ),
  'alistirma': _Case(
    _route,
    act: (tester, h) async {
      await h.next(tester, 4);
      await h.audio.pause();
      await _tap(tester, h, 'opt-0');
    },
  ),
  'kural_karti': _Case(
    _route,
    act: (tester, h) async {
      await h.next(tester, 6);
      await _tap(tester, h, 'lesson-listen');
      await _tap(tester, h, 'rule-add');
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('rule-saved')),
        100,
        scrollable: find
            .descendant(
              of: find.byKey(const ValueKey('lesson-scroll-6')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await h.settle(tester);
    },
  ),
  'ders_sonu': _Case(
    _route,
    act: (tester, h) async {
      await h.next(tester, 6);
      await _tap(tester, h, 'lesson-finish');
    },
  ),
};

void main() {
  setUpAll(loadAppFonts);

  Future<GrammarHarness> pumpCase(
    WidgetTester tester,
    _Case c, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    final h = GrammarHarness(suggestedLevel: 'A1');
    addTearDown(h.dispose);
    if (c.prepare != null) await tester.runAsync(() => c.prepare!(h));
    await h.pump(tester, c.location, size: size, textScale: textScale);
    if (c.act != null) await c.act!(tester, h);
    // Belirme ve kutlama animasyonları bitsin.
    await tester.pump(const Duration(seconds: 1));
    await h.settle(tester);
    return h;
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  }

  for (final MapEntry(key: id, value: c) in _cases.entries) {
    testWidgets('golden: $id', (tester) async {
      await pumpCase(tester, c);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h078_$id.png'),
      );
      await unmount(tester);
    }, skip: skipGoldensOffMac);

    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCase(tester, c);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // Piksel ölçümü yazı tipi çizimine bağlı; yalnız golden'ların
      // üretildiği macOS'ta.
      if (!skipGoldensOffMac) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
      await unmount(tester);
    });

    testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
      tester,
    ) async {
      await pumpCase(tester, c, size: const Size(320, 568), textScale: 1.3);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }
}
