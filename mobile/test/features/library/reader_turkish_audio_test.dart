import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/application/book_media_session.dart';

import '../../support/library_harness.dart';

/// "Sayfanın Türkçesi"ni Hi'nin sesiyle dinleme (H-105): düğme yalnız
/// panelde ve sayfanın Türkçe sesi varsa; yalnız dokununca çalar; İngilizce
/// anlatımla aynı anda çalmaz; panel kapanınca durur; küçük ekranda taşmaz.
void main() {
  final listen = find.byKey(const ValueKey('page-tr-listen'));

  Future<void> openSheet(WidgetTester tester, LibraryHarness h) async {
    await tester.tap(find.byKey(const ValueKey('reader-page-turkish')));
    await h.settle(tester);
  }

  Future<void> closeSheet(WidgetTester tester, LibraryHarness h) async {
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
  }

  Future<void> closeReader(WidgetTester tester, LibraryHarness h) async {
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
  }

  /// Düğme çalıyor mu (durdurma simgesi ve "Durdur" etiketi).
  bool playing(WidgetTester tester) => find
      .descendant(of: listen, matching: find.byIcon(Icons.stop_rounded))
      .evaluate()
      .isNotEmpty;

  testWidgets('Türkçe sesi olmayan sayfada düğme yok', (tester) async {
    final h = LibraryHarness(turkishAudio: const {'p02'});
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    await openSheet(tester, h);
    expect(find.byKey(const ValueKey('page-turkish')), findsOneWidget);
    expect(listen, findsNothing);
    await closeSheet(tester, h);
    await closeReader(tester, h);
    expect(h.players, isEmpty);
  });

  testWidgets('kendiliğinden çalmaz; dokununca sayfanın Türkçe sesi çalar, '
      'ikinci dokunuş durdurur; panel kapanınca durur', (tester) async {
    final h = LibraryHarness(turkishAudio: const {'p01'});
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    await openSheet(tester, h);
    expect(listen, findsOneWidget);
    expect(find.text('Türkçesini dinle'), findsOneWidget);
    expect(h.players, isEmpty);
    expect(playing(tester), isFalse);

    await tester.tap(listen);
    await h.settle(tester);
    expect(h.players, hasLength(1));
    expect(
      h.players.single.uri.toString(),
      'http://test.invalid/books/A1-K99/audio/tr/p01.m4a',
    );
    expect(h.players.single.played, isTrue);
    expect(playing(tester), isTrue);
    expect(find.bySemanticsLabel('Durdur'), findsOneWidget);

    await tester.tap(listen);
    await h.settle(tester);
    expect(playing(tester), isFalse);

    await tester.tap(listen);
    await h.settle(tester);
    expect(playing(tester), isTrue);
    await closeSheet(tester, h);
    expect(listen, findsNothing);
    expect(h.players.last.disposed, isTrue);
    await closeReader(tester, h);
  });

  testWidgets('İngilizce anlatım panelle durur, Türkçe çalarken duraklı '
      'kalır; panel kapanınca Türkçe durur, İngilizce kaldığı yerden sürer', (
    tester,
  ) async {
    final h = LibraryHarness(turkishAudio: const {'p01'});
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    await h.listenFor(tester, 2.0);
    expect(h.audio.playing, isTrue);
    await openSheet(tester, h);
    expect(h.audio.playing, isFalse);
    await tester.tap(listen);
    await h.settle(tester);
    expect(playing(tester), isTrue);
    expect(h.audio.playing, isFalse);
    await closeSheet(tester, h);
    expect(h.audio.playing, isTrue);
    expect(h.audio.seeks.last, closeTo(2.0, 0.06));
    await closeReader(tester, h);
  });

  testWidgets('İngilizce yeniden başlarsa (kilit ekranı) Türkçe durur; '
      'Türkçe başlarken çalan İngilizce duraklar', (tester) async {
    final h = LibraryHarness(turkishAudio: const {'p01'}, background: true);
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    await h.listenFor(tester, 1.0);
    expect(h.engine.playing, isTrue);
    await openSheet(tester, h);
    expect(h.engine.playing, isFalse);

    await tester.tap(listen);
    await h.settle(tester);
    expect(playing(tester), isTrue);

    // Kilit ekranından "oynat": İngilizce başlar, Türkçe durur.
    h.session.press(BookRemoteCommand.play);
    await h.settle(tester);
    expect(h.engine.playing, isTrue);
    expect(playing(tester), isFalse);

    // Türkçeye yeniden dokununca İngilizce duraklar.
    await tester.tap(listen);
    await h.settle(tester);
    expect(h.engine.playing, isFalse);
    expect(playing(tester), isTrue);

    await closeSheet(tester, h);
    await tester.pumpWidget(const SizedBox());
    await h.settle(tester, rounds: 3);
  });

  testWidgets('320×568, 1,3× yazı: taşma yok; dokunma alanı ≥ 44; ekran '
      'okuyucu etiketi', (tester) async {
    final semantics = tester.ensureSemantics();
    final h = LibraryHarness(turkishAudio: const {'p01'});
    addTearDown(h.dispose);
    await h.pump(
      tester,
      '/kitap/A1-K99?mod=oku',
      size: const Size(320, 568),
      textScale: 1.3,
    );
    await openSheet(tester, h);
    expect(tester.takeException(), isNull);
    final size = tester.getSize(
      find.descendant(of: listen, matching: find.byType(IconButton)),
    );
    expect(size.width, greaterThanOrEqualTo(44));
    expect(size.height, greaterThanOrEqualTo(44));
    expect(find.bySemanticsLabel('Türkçesini dinle'), findsOneWidget);
    await tester.tap(listen);
    await h.settle(tester);
    expect(tester.takeException(), isNull);
    await closeSheet(tester, h);
    await closeReader(tester, h);
    semantics.dispose();
  });
}
