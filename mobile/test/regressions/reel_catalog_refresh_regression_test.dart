// 21 Ekim 2026 takip incelemesi — Bulgu 1 (H-096): reel kataloğu açık
// oturumda hiç yenilenmiyordu. Backend'den geri çekilen reel, uygulama öne
// gelse ya da Keşfet'e dönülse de oynamaya devam ediyordu.
//
// Bu dosya **doğru davranışı** bekler:
// - Uygulama öne gelince ve Keşfet sekmesine dönülünce katalog yeniden
//   okunur; en kısa aralık [reelCatalogRefreshIntervalProvider] (varsayılan
//   1 dk) — art arda dönüşler backend'i yormaz.
// - Açık video artık yayında değilse sakin biçimde durur, kısa bir not
//   görünür; günlük sette yerine aynı seviye-konudan yedek gelir (mevcut
//   seçki kuralları, plan §5) ve akış aynı sıradan sürer.
// - Katalog değişmediyse akış yeniden kurulmaz; okuma başarısızsa açık video
//   kesilmez (yeni paket açılışı kaynakta kapalıdır: http_reel_catalog_test).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/application/discover_providers.dart';
import 'package:hivelzon/features/discover/data/discover_store.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';
import 'package:hivelzon/features/discover/domain/reel.dart';
import 'package:hivelzon/features/discover/presentation/discover_screen.dart';
import 'package:hivelzon/l10n/tr_strings.dart';

import '../support/discover_harness.dart';
import '../support/fake_content_source.dart';

List<String> _ids(DiscoverHarness h, WidgetTester tester) => [
  for (final e in h.feedState(tester).feed.whereType<VideoEntry>()) e.video.id,
];

/// İki Sinema (yedek için), bir Spor, bir Kitap (A1).
List<Reel> _reels() => [
  reelLike('A1-R-CIN-01', id: 'A1-R-CIN-01', family: 'FAM-CIN-1'),
  reelLike('A1-R-CIN-01', id: 'A1-R-CIN-02', family: 'FAM-CIN-2'),
  reelLike('A1-R-SPO-01', id: 'A1-R-SPO-01', family: 'FAM-SPO-1'),
  reelLike('A1-R-BOK-01', id: 'A1-R-BOK-01', family: 'FAM-BOK-1'),
];

Future<DiscoverHarness> _pump(
  WidgetTester tester, {
  Duration? interval,
  DateTime Function()? clockOf,
}) async {
  final h = DiscoverHarness(
    chip: DiscoverChip.today,
    withReels: true,
    reels: _reels(),
    suggestedLevel: 'A1',
    clockOf: clockOf,
    durationFor: (_) => const Duration(seconds: 30),
  );
  addTearDown(h.dispose);
  // Yaşam döngüsü durumu testler arasında taşınmasın.
  addTearDown(
    () => tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    ),
  );
  await h.pump(
    tester,
    overrides: [
      if (interval != null)
        reelCatalogRefreshIntervalProvider.overrideWithValue(interval),
    ],
  );
  return h;
}

/// Uygulama arka plana gidip geri gelir.
Future<void> _background(WidgetTester tester, DiscoverHarness h) async {
  for (final s in [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
  ]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
  await h.settle(tester, rounds: 6);
}

Future<void> _foreground(WidgetTester tester, DiscoverHarness h) async {
  for (final s in [
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
  await h.settle(tester, rounds: 30);
}

/// CIN-01 backend kataloğundan düşer (geri çekildi).
void _withdrawCinema(DiscoverHarness h) {
  h.source.reelCatalog = catalogOf([
    for (final r in _reels())
      if (r.id != 'A1-R-CIN-01') r,
  ]);
}

void main() {
  testWidgets('öne gelince: geri çekilen açık video durur, yedek aynı yerde', (
    tester,
  ) async {
    final h = await _pump(tester, interval: Duration.zero);
    expect(_ids(h, tester), ['A1-R-CIN-01', 'A1-R-SPO-01', 'A1-R-BOK-01']);
    expect(h.video.isPlaying('A1-R-CIN-01.mp4'), isTrue);
    final before = h.source.reelListCalls;

    await _background(tester, h);
    _withdrawCinema(h);
    await _foreground(tester, h);

    // Tek okuma (aynı sonuç sağlayıcıya aktarılır; ikinci istek yok).
    expect(h.source.reelListCalls, before + 1);
    expect(find.text(DiscoverTexts.reelWithdrawn), findsOneWidget);
    expect(h.video.isPlaying('A1-R-CIN-01.mp4'), isFalse);
    // Mevcut seçki kuralı: aynı seviye-konudan yedek, aynı sırada.
    expect(_ids(h, tester), ['A1-R-CIN-02', 'A1-R-SPO-01', 'A1-R-BOK-01']);
    expect(h.feedState(tester).index, 0);
    final set = await tester.runAsync(
      () => DiscoverStore(h.db).dailySet(h.clock),
    );
    expect(set!.items.map((i) => i.id), [
      'A1-R-CIN-02',
      'A1-R-SPO-01',
      'A1-R-BOK-01',
    ]);
    await h.unmount(tester);
  });

  testWidgets('ikinci videodayken geri çekilirse yedeği aynı sırada açılır', (
    tester,
  ) async {
    final h = await _pump(tester, interval: Duration.zero);
    // Sinema yerine Spor geri çekilsin: kullanıcı ikinci videoda (SPO-01).
    final s = h.feedState(tester);
    s.jumpTo(
      s.feed.indexWhere((e) => e is VideoEntry && e.video.id == 'A1-R-SPO-01'),
    );
    await h.settle(tester);
    expect(h.video.isPlaying('A1-R-SPO-01.mp4'), isTrue);

    await _background(tester, h);
    // Spor'un yedeği yok: seçki daha az videoyla sürer (plan §5).
    h.source.reelCatalog = catalogOf([
      for (final r in _reels())
        if (r.id != 'A1-R-SPO-01') r,
    ]);
    await _foreground(tester, h);

    expect(find.text(DiscoverTexts.reelWithdrawn), findsOneWidget);
    expect(h.video.isPlaying('A1-R-SPO-01.mp4'), isFalse);
    expect(_ids(h, tester), ['A1-R-CIN-01', 'A1-R-BOK-01']);
    await h.unmount(tester);
  });

  testWidgets('Keşfet sekmesine dönünce katalog yenilenir', (tester) async {
    final h = await _pump(tester, interval: Duration.zero);
    final before = h.source.reelListCalls;
    h.tabVisible.value = false;
    await h.settle(tester, rounds: 6);
    expect(h.video.isPlaying('A1-R-CIN-01.mp4'), isFalse);
    _withdrawCinema(h);

    h.tabVisible.value = true;
    await h.settle(tester, rounds: 30);

    expect(h.source.reelListCalls, before + 1);
    expect(find.text(DiscoverTexts.reelWithdrawn), findsOneWidget);
    expect(_ids(h, tester).first, 'A1-R-CIN-02');
    await h.unmount(tester);
  });

  testWidgets('yenileme aralığı: art arda dönüşler backend\'i yormaz', (
    tester,
  ) async {
    var now = DateTime(2026, 10, 21, 10);
    final h = await _pump(tester, clockOf: () => now);
    final before = h.source.reelListCalls;

    // Açılıştan hemen sonra (1 dk dolmadan) okuma yok.
    await _background(tester, h);
    await _foreground(tester, h);
    expect(h.source.reelListCalls, before);

    now = now.add(const Duration(minutes: 2));
    await _background(tester, h);
    await _foreground(tester, h);
    expect(h.source.reelListCalls, before + 1);

    // Hemen yine: okuma yok.
    await _background(tester, h);
    await _foreground(tester, h);
    h.tabVisible.value = false;
    await h.settle(tester, rounds: 6);
    h.tabVisible.value = true;
    await h.settle(tester, rounds: 12);
    expect(h.source.reelListCalls, before + 1);
    await h.unmount(tester);
  });

  testWidgets('katalog değişmediyse akış yeniden kurulmaz', (tester) async {
    final h = await _pump(tester, interval: Duration.zero);
    final state = h.feedState(tester);
    final loads = h.source.reelLoadCalls;
    await _background(tester, h);
    await _foreground(tester, h);
    expect(identical(h.feedState(tester), state), isTrue);
    expect(h.source.reelLoadCalls, loads);
    expect(find.text(DiscoverTexts.reelWithdrawn), findsNothing);
    expect(h.video.isPlaying('A1-R-CIN-01.mp4'), isTrue);
    await h.unmount(tester);
  });

  testWidgets('yenileme okunamazsa açık video kesilmez, not çıkmaz', (
    tester,
  ) async {
    final h = await _pump(tester, interval: Duration.zero);
    await _background(tester, h);
    h.source.reelsFail = true;
    await _foreground(tester, h);
    expect(find.byType(DiscoverFeed), findsOneWidget);
    expect(find.text(DiscoverTexts.reelWithdrawn), findsNothing);
    expect(h.video.isPlaying('A1-R-CIN-01.mp4'), isTrue);
    await h.unmount(tester);
  });
}
