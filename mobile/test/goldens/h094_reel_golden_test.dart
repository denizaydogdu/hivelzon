// H-094 P1 golden'ları: günlük üç video (bağımsız reeller) — video sayfası
// (kategori · seviye rozeti, altyazı, ifade kartı), video sonundaki kısa soru
// ve sakin bitiş. Eski hikâye kliplerinin golden'ları `h040_*`'ta kalır.
//
// Altyazı: A1-R-BOK-01 hedef sahnesi 4,2 sn'de ("Is this book good?").
// Bilinçli görsel değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/application/discover_providers.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';

import '../support/app_fonts.dart';
import '../support/discover_harness.dart';
import '../support/golden.dart';

class _Case {
  const _Case({this.act});

  final Future<void> Function(WidgetTester tester, DiscoverHarness h)? act;
}

Future<void> _jumpToLast(WidgetTester tester, DiscoverHarness h) async {
  final s = h.feedState(tester);
  s.jumpTo(s.feed.length - 1);
  await h.settle(tester);
}

final _cases = <String, _Case>{
  'gunluk': const _Case(),
  'gunluk_soru': _Case(
    act: (t, h) async {
      final s = h.feedState(t);
      s.jumpTo(s.feed.indexWhere((e) => e is PracticeEntry));
      await h.settle(t);
    },
  ),
  'gunluk_bitis': _Case(act: _jumpToLast),
  'gunluk_seviye': _Case(
    act: (t, h) async {
      await t.tap(find.byKey(const ValueKey('level-chip')));
      await h.settle(t, rounds: 12);
    },
  ),
};

void main() {
  setUpAll(loadAppFonts);

  Future<DiscoverHarness> pumpCase(
    WidgetTester tester,
    _Case c, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    final h = DiscoverHarness(
      chip: DiscoverChip.today,
      withReels: true,
      suggestedLevel: 'A1',
      durationFor: (_) => const Duration(seconds: 16),
      positionFor: (_) => const Duration(milliseconds: 4200),
    );
    addTearDown(h.dispose);
    await h.pump(tester, size: size, textScale: textScale);
    await tester.pump(const Duration(milliseconds: 600));
    await h.settle(tester);
    if (c.act != null) await c.act!(tester, h);
    await tester.pump(const Duration(milliseconds: 600));
    await h.settle(tester, rounds: 10);
    return h;
  }

  for (final MapEntry(key: id, value: c) in _cases.entries) {
    testWidgets('golden: $id', (tester) async {
      final h = await pumpCase(tester, c);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h094_$id.png'),
      );
      await h.unmount(tester);
    }, skip: skipGoldensOffMac);

    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      final h = await pumpCase(tester, c);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      if (!skipGoldensOffMac) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
      await h.unmount(tester);
    });

    testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
      tester,
    ) async {
      final h = await pumpCase(
        tester,
        c,
        size: const Size(320, 568),
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
      await h.unmount(tester);
    });
  }
}
