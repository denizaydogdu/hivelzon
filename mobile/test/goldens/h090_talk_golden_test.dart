// H-090 golden'ları: Konuş sekmesi, sahne (giriş, tur, seçenekler ve kibar
// tepki, söyleyerek kabul, kelimelerle kur, bitiş) ve kısa mesaj (ipucu,
// kabul, öz değerlendirme). Ayrıca erişilebilirlik yönergeleri ve
// 320 × 568 · 1,3× taşma testi (bu ekranlar başka dosyada denetlenmez).
//
// Görseller sahte içerik adresinden açılmaz; yer tutucu çizilir (medya git
// dışında). Bilinçli görsel değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens/h090_talk_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_fonts.dart';
import '../support/golden.dart';
import '../support/talk_harness.dart';

class _Case {
  const _Case(this.route, this.expectKey, {this.act, this.speech = false});

  final String route;
  final String expectKey;
  final Future<void> Function(WidgetTester, TalkHarness)? act;
  final bool speech;
}

Future<void> _optText(WidgetTester t, TalkHarness h, String text) async {
  final f = find.widgetWithText(OutlinedButton, text);
  await h.scrollTo(t, f);
  await t.ensureVisible(f);
  await t.pump();
  await t.tap(f);
  await h.settle(t);
}

const _all = ['A1-001', 'A1-002', 'A1-003', 'A1-004', 'A1-005', 'A1-009'];

final _cases = <String, _Case>{
  'sekme': const _Case('/konus', 'talk-screen'),
  'sahne_giris': const _Case('/konusma/cafe-rosa', 'talk-start'),
  'sahne_tur': _Case(
    '/konusma/cafe-rosa',
    'talk-panel',
    speech: true,
    act: (t, h) async {
      await h.tap(t, 'talk-start');
      await h.tap(t, 'talk-line-tr');
    },
  ),
  'sahne_tepki': _Case(
    '/konusma/cafe-rosa',
    'talk-reaction',
    act: (t, h) async {
      await h.tap(t, 'talk-start');
      await h.tap(t, 'talk-choose');
      await _optText(t, h, 'I want tea.');
    },
  ),
  'sahne_soyledin': _Case(
    '/konusma/cafe-rosa',
    'talk-accepted',
    speech: true,
    act: (t, h) async {
      await h.tap(t, 'talk-start');
      await h.tap(t, 'talk-mic');
    },
  ),
  'sahne_kur': _Case(
    '/konusma/ask-the-way',
    'talk-built',
    act: (t, h) async {
      await h.tap(t, 'talk-start');
      await h.tap(t, 'talk-build');
      await h.tap(t, 'talk-tile-0');
    },
  ),
  'sahne_bitti': _Case(
    '/konusma/maya-neighbour',
    'talk-end',
    act: (t, h) async {
      await h.tap(t, 'talk-start');
      for (var i = 0; i < 4; i++) {
        await h.tap(t, 'talk-skip');
        await h.tap(t, 'talk-next');
      }
    },
  ),
  'mesaj_ipucu': _Case(
    '/konusma/late-maya',
    'message-hint',
    act: (t, h) async {
      await t.enterText(
        find.byKey(const ValueKey('message-field')),
        "Sorry, I'm not late.",
      );
      await h.tap(t, 'message-send');
    },
  ),
  'mesaj_tamam': _Case(
    '/konusma/late-maya',
    'message-done',
    act: (t, h) async {
      await t.enterText(
        find.byKey(const ValueKey('message-field')),
        "Sorry, Maya. I'm late.",
      );
      await h.tap(t, 'message-send');
    },
  ),
  'mesaj_oz': _Case(
    '/konusma/hi-intro',
    'message-similar',
    act: (t, h) async {
      await t.enterText(
        find.byKey(const ValueKey('message-field')),
        'Hello! I am Alex.',
      );
      await h.tap(t, 'message-send');
    },
  ),
};

void main() {
  setUpAll(loadAppFonts);

  Future<TalkHarness> pumpCase(
    WidgetTester tester,
    _Case c, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    final h = TalkHarness(completed: _all, speech: c.speech);
    addTearDown(h.dispose);
    await h.pump(tester, c.route, size: size, textScale: textScale);
    await c.act?.call(tester, h);
    await h.settle(tester);
    final f = find.byKey(ValueKey(c.expectKey));
    await h.scrollTo(tester, f);
    expect(f, findsWidgets);
    return h;
  }

  for (final MapEntry(key: id, value: c) in _cases.entries) {
    testWidgets('golden: $id', (tester) async {
      await pumpCase(tester, c);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h090_$id.png'),
      );
    }, skip: skipGoldensOffMac);

    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCase(tester, c);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      if (!skipGoldensOffMac) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
    });

    testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
      tester,
    ) async {
      await pumpCase(tester, c, size: const Size(320, 568), textScale: 1.3);
      expect(tester.takeException(), isNull);
    });
  }
}
