import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/features/player/presentation/widgets/end_view.dart';

import '../../support/fixtures.dart';

/// H-051: bölüm sonunda açılan konu seti satırı.
void main() {
  Future<void> pump(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(1179, 4000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('ilk bitiriş: "Yeni konu seti açıldı" ve düğme', (tester) async {
    var opened = 0;
    await pump(
      tester,
      EndView(
        engine: EpisodeEngine(loadFixture('A1-001')),
        onBack: () {},
        topicSetTitle: "Alex'in odası",
        onOpenTopicSet: () => opened++,
      ),
    );
    expect(find.text('YENİ KONU SETİ'), findsOneWidget);
    expect(find.text("Yeni konu seti açıldı: Alex'in odası"), findsOneWidget);
    await tester.tap(find.text('Konu setini aç'));
    expect(opened, 1);
  });

  testWidgets('tekrar oynayış: yalnızca setin adı; set yoksa satır yok', (
    tester,
  ) async {
    await pump(
      tester,
      EndView(
        engine: EpisodeEngine(loadFixture('A1-001')),
        onBack: () {},
        topicSetTitle: "Alex'in odası",
        topicSetIsNew: false,
        onOpenTopicSet: () {},
      ),
    );
    expect(find.text('KONU SETİ'), findsOneWidget);
    expect(
      find.text("Bu bölümün yerindeki nesneler: Alex'in odası"),
      findsOneWidget,
    );
    await pump(
      tester,
      EndView(engine: EpisodeEngine(loadFixture('A1-001')), onBack: () {}),
    );
    expect(find.byKey(const ValueKey('end-topic-set')), findsNothing);
  });
}
