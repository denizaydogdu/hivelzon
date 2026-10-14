// H-040 Keşfet golden'ları ve erişilebilirlik denetimi: klip (altyazı,
// dilbilgisi etiketi, Kaydet · Anlam · Tam hikâye, yapay zekâ notu), quiz
// kartı (yanlış seçimden sonra sakin geri bildirim), mola kartı, bitiş kartı
// ve günlük süre kartı (13–17).
//
// Video sahte platformdan gelir (görüntü yok, koyu zemin); altyazı sahte
// konumla (11,5 sn: "Can you hear me?") görünür. Bilinçli görsel
// değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/domain/clip.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';

import '../support/app_fonts.dart';
import '../support/discover_harness.dart';
import '../support/fake_content_source.dart';
import '../support/golden.dart';

class _Case {
  const _Case({this.age = TestAge.adult, this.watched, this.clips, this.act});

  final TestAge age;
  final int? watched;
  final int? clips;
  final Future<void> Function(WidgetTester tester, DiscoverHarness h)? act;
}

Future<void> _jumpTo<T extends FeedEntry>(
  WidgetTester tester,
  DiscoverHarness h,
) async {
  final s = h.feedState(tester);
  s.jumpTo(s.feed.indexWhere((e) => e is T));
  await h.settle(tester);
}

ClipCatalog _catalog(int n) {
  final base = loadClipFixture();
  return ClipCatalog(
    season: 1,
    aiLabel: base.aiLabel,
    clips: [
      for (var i = 0; i < n; i++)
        copyClip(base.clips[i % base.clips.length], id: 'S1-K${i + 1}'),
    ],
  );
}

final _cases = <String, _Case>{
  'klip': const _Case(),
  'quiz': _Case(
    act: (tester, h) async {
      await _jumpTo<QuizEntry>(tester, h);
      await tester.tap(find.byKey(const ValueKey('quiz-opt-1')));
      await h.settle(tester);
    },
  ),
  'mola': _Case(clips: 12, act: (t, h) => _jumpTo<BreakEntry>(t, h)),
  'bitis': _Case(act: (t, h) => _jumpTo<EndEntry>(t, h)),
  'sure_doldu': const _Case(age: TestAge.teen, watched: 20 * 60),
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
      age: c.age,
      catalog: c.clips == null ? null : _catalog(c.clips!),
      durationFor: (_) => const Duration(seconds: 16),
      positionFor: (_) => const Duration(milliseconds: 11500),
    );
    addTearDown(h.dispose);
    if (c.watched != null) await h.watched(tester, c.watched!);
    await h.pump(tester, size: size, textScale: textScale);
    // Konum 0,5 sn'de bir gelir; altyazı ve belirme animasyonları otursun.
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
        matchesGoldenFile('images/h040_$id.png'),
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
