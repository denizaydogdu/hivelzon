import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/design/design.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/presentation/widgets/book_page_view.dart';

import '../../support/golden.dart';
import '../../support/library_harness.dart';

/// Okuyucuda "Sayfanın Türkçesi" (H-086): panel (sayfanın Türkçesi sırasıyla,
/// ses durur ve sürer, cümleye dokununca İngilizcesi vurgulanır ve
/// görünür kılınır), "Satır altı Türkçe" ayarı (kalıcı), Türkçesi olmayan
/// cümle, küçük ekran ve erişilebilirlik.
void main() {
  const page1 = [
    'Küçük Bir Kutu',
    "Ece'nin küçük bir kutusu var.",
    'Kutu kırmızı.',
    'Onu açamıyor.',
  ];

  BookWordView word(WidgetTester t, String sentence, int i) =>
      t.widget<BookWordView>(find.byKey(ValueKey('w-$sentence-$i')));

  ScrollPosition position(WidgetTester t, String pageId) => t
      .widget<SingleChildScrollView>(find.byKey(ValueKey('book-page-$pageId')))
      .controller!
      .position;

  Finder sheetText(String text) => find.descendant(
    of: find.byKey(const ValueKey('page-turkish')),
    matching: find.text(text),
  );

  Future<void> openSheet(WidgetTester tester, LibraryHarness h) async {
    await tester.tap(find.byKey(const ValueKey('reader-page-turkish')));
    await h.settle(tester);
  }

  /// Paneldeki Türkçe cümleye dokunur (küçük ekranda liste kaydırılır).
  Future<void> tapTr(WidgetTester tester, int i) async {
    final f = find.byKey(ValueKey('page-tr-$i'));
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
  }

  Future<void> closeReader(WidgetTester tester, LibraryHarness h) async {
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
  }

  /// Küçük ekran, en büyük okuma yazısı ve 1,3× sistem yazısı: sayfa
  /// görünür alandan uzun (son cümle başta görünmez).
  Future<LibraryHarness> openSmall(
    WidgetTester tester, {
    String mode = 'oku',
    bool reduceMotion = false,
    bool interlinear = false,
  }) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await tester.runAsync(() async {
      final store = BookProgressStore(h.db);
      await store.setTextSize(2);
      await store.setInterlinear(interlinear);
    });
    await h.pump(
      tester,
      '/kitap/A1-K99?mod=$mode',
      size: const Size(320, 568),
      textScale: 1.3,
      reduceMotion: reduceMotion,
    );
    return h;
  }

  /// Kelime metin alanında ve alt denetimlerin üstünde mi?
  void expectVisible(WidgetTester t, String key, String pageId) {
    final view = t.getRect(find.byKey(ValueKey('book-page-$pageId')));
    final controls = t.getRect(find.byKey(const ValueKey('reader-mode')));
    final r = t.getRect(find.byKey(ValueKey(key)));
    expect(r.top, greaterThanOrEqualTo(view.top - 0.5));
    expect(r.bottom, lessThan(controls.top));
  }

  testWidgets('panel ekrandaki sayfanın Türkçesini sırasıyla gösterir '
      '(bölüm başlığı önce); sayfa değişince o sayfanınkini', (tester) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    await openSheet(tester, h);
    expect(find.text('Sayfanın Türkçesi'), findsWidgets);
    final tops = [for (final t in page1) tester.getRect(sheetText(t)).top];
    for (var i = 1; i < tops.length; i++) {
      expect(tops[i], greaterThan(tops[i - 1]));
    }
    expect(sheetText('Ece bilmiyor.'), findsNothing);
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('page-turkish')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('reader-next')));
    await h.settle(tester);
    await openSheet(tester, h);
    expect(sheetText('"Kutuda ne var?" diye soruyor annesi.'), findsOneWidget);
    expect(sheetText('Ece bilmiyor.'), findsOneWidget);
    expect(sheetText('Kutu kırmızı.'), findsNothing);
    expect(sheetText('Küçük Bir Kutu'), findsNothing);
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
    await closeReader(tester, h);
  });

  testWidgets('sayfa sonundaki "Sayfanın Türkçesi" düğmesi de paneli açar', (
    tester,
  ) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    final footer = find.byKey(const ValueKey('reader-page-turkish-footer'));
    expect(footer, findsOneWidget);
    expect(tester.getSize(footer).height, greaterThanOrEqualTo(48));
    await tester.tap(footer);
    await h.settle(tester);
    expect(sheetText('Onu açamıyor.'), findsOneWidget);
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
    await closeReader(tester, h);
  });

  testWidgets('panel açıkken ses durur; kapanınca kaldığı yerden sürer', (
    tester,
  ) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    await h.listenFor(tester, 2.0);
    expect(h.audio.playing, isTrue);
    await openSheet(tester, h);
    expect(h.audio.playing, isFalse);
    // Panel açıkken zaman geçse de okuma ilerlemez.
    await h.listenFor(tester, 1.0);
    expect(h.audio.playing, isFalse);
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
    expect(h.audio.playing, isTrue);
    expect(h.audio.seeks.last, closeTo(2.0, 0.06));
    expect(word(tester, 'p01-s01', 0).highlighted, isTrue);
    await closeReader(tester, h);
  });

  testWidgets('duraklatılmış okuma panel kapanınca duraklı kalır', (
    tester,
  ) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    await h.listenFor(tester, 2.0);
    await tester.tap(find.byKey(const ValueKey('reader-play')));
    await h.settle(tester);
    expect(h.audio.playing, isFalse);
    await openSheet(tester, h);
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
    expect(h.audio.playing, isFalse);
    await closeReader(tester, h);
  });

  testWidgets('sesli: Türkçe cümleye dokununca panel kapanır, İngilizcesi '
      'vurgulanır, görünür kılınır ve okuma oradan sürer', (tester) async {
    final h = await openSmall(tester, mode: 'dinle');
    await h.listenFor(tester, 1.6); // p01-s01 okunuyor
    expect(h.audio.playing, isTrue);
    final pos = position(tester, 'p01');
    final view = tester.getRect(find.byKey(const ValueKey('book-page-p01')));
    expect(
      tester.getRect(find.byKey(const ValueKey('w-p01-s03-0'))).top,
      greaterThan(view.bottom),
    );
    await openSheet(tester, h);
    await tapTr(tester, 2);
    await h.settle(tester);
    expect(find.byKey(const ValueKey('page-turkish')), findsNothing);
    expect(h.audio.playing, isTrue);
    expect(h.audio.seeks.last, closeTo(4.6, 1e-9));
    expect(word(tester, 'p01-s03', 0).highlighted, isTrue);
    expect(word(tester, 'p01-s01', 0).highlighted, isFalse);
    expect(pos.pixels, greaterThan(0));
    expectVisible(tester, 'w-p01-s03-0', 'p01');
    expect(tester.takeException(), isNull);
    await closeReader(tester, h);
  });

  testWidgets('sessiz: Türkçe cümleye dokununca İngilizcesi vurgulanır ve '
      'oraya kaydırılır; ses çalmaz; sayfa çevrilince vurgu söner', (
    tester,
  ) async {
    final h = await openSmall(tester);
    final pos = position(tester, 'p01');
    expect(pos.pixels, 0);
    expect(word(tester, 'p01-s03', 0).highlighted, isFalse);
    await openSheet(tester, h);
    await tapTr(tester, 2);
    await h.settle(tester);
    expect(h.audio.playing, isFalse);
    expect(h.audio.plays, 0);
    expect(word(tester, 'p01-s03', 0).highlighted, isTrue);
    expect(pos.pixels, greaterThan(0));
    expectVisible(tester, 'w-p01-s03-0', 'p01');
    // Panel yeniden açılınca seçili cümle işaretli.
    await openSheet(tester, h);
    Color? rowColor(int i) => tester
        .widget<Material>(
          find
              .ancestor(
                of: find.byKey(ValueKey('page-tr-$i')),
                matching: find.byType(Material),
              )
              .first,
        )
        .color;
    expect(rowColor(2), AppPalette.yellow100);
    expect(rowColor(0), Colors.transparent);
    await tapTr(tester, 0);
    await h.settle(tester);
    expect(word(tester, 'p01-s01', 0).highlighted, isTrue);
    expect(word(tester, 'p01-s03', 0).highlighted, isFalse);
    await tester.tap(find.byKey(const ValueKey('reader-next')));
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('reader-prev')));
    await h.settle(tester);
    expect(word(tester, 'p01-s01', 0).highlighted, isFalse);
    await closeReader(tester, h);
  });

  testWidgets('hareketi azalt: seçilen cümleye animasyonsuz atlanır', (
    tester,
  ) async {
    final h = await openSmall(tester, reduceMotion: true);
    final pos = position(tester, 'p01');
    await openSheet(tester, h);
    await tapTr(tester, 2);
    // Panel kapanışı ve ilk kare.
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
    }
    final jumped = pos.pixels;
    expect(jumped, greaterThan(0));
    await tester.pump(const Duration(milliseconds: 16));
    expect(pos.pixels, jumped);
    await tester.pump(const Duration(milliseconds: 200));
    expect(pos.pixels, jumped);
    expectVisible(tester, 'w-p01-s03-0', 'p01');
    await closeReader(tester, h);
  });

  testWidgets('"Satır altı Türkçe" varsayılan kapalı; açılınca her cümlenin '
      'altında Türkçesi; ayar kalıcı', (tester) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    expect(find.byKey(const ValueKey('tr-p01-s01')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('reader-settings-button')));
    await h.settle(tester);
    expect(find.text('Satır altı Türkçe'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('reader-interlinear')));
    await h.settle(tester);
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
    for (final id in ['c1-h', 'p01-s01', 'p01-s02', 'p01-s03']) {
      expect(find.byKey(ValueKey('tr-$id')), findsOneWidget);
    }
    // Türkçe İngilizcenin altında, daha küçük ve soluk.
    final en = tester.getRect(find.byKey(const ValueKey('w-p01-s02-0')));
    final tr = tester.getRect(find.byKey(const ValueKey('tr-p01-s02')));
    expect(tr.top, greaterThanOrEqualTo(en.bottom - 0.5));
    final trStyle = tester
        .widget<Text>(find.byKey(const ValueKey('tr-p01-s02')))
        .style!;
    expect(
      trStyle.fontSize,
      lessThan(word(tester, 'p01-s02', 0).style.fontSize!),
    );
    expect(trStyle.color, isNot(word(tester, 'p01-s02', 0).style.color));
    expect(await tester.runAsync(BookProgressStore(h.db).interlinear), isTrue);
    // Vurgu ve anlam paneli bozulmaz.
    await h.listenFor(tester, 1.6);
    expect(word(tester, 'p01-s01', 0).highlighted, isTrue);
    await tester.tap(find.byKey(const ValueKey('w-p01-s01-3'))); // small
    await h.settle(tester);
    expect(find.byKey(const ValueKey('meaning-gloss')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('meaning-close')));
    await h.settle(tester);
    await closeReader(tester, h);

    // Yeniden açılınca açık.
    await tester.pumpWidget(const SizedBox());
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    expect(find.byKey(const ValueKey('tr-p01-s01')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('reader-settings-button')));
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('reader-interlinear')));
    await h.settle(tester);
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('tr-p01-s01')), findsNothing);
    expect(await tester.runAsync(BookProgressStore(h.db).interlinear), isFalse);
    await closeReader(tester, h);
  });

  testWidgets('Türkçesi olmayan cümle panelde ve satır altında atlanır', (
    tester,
  ) async {
    final h = LibraryHarness(withoutTurkish: const {'c1-h', 'p01-s02'});
    addTearDown(h.dispose);
    await tester.runAsync(() => BookProgressStore(h.db).setInterlinear(true));
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('tr-p01-s01')), findsOneWidget);
    expect(find.byKey(const ValueKey('tr-p01-s02')), findsNothing);
    expect(find.byKey(const ValueKey('tr-c1-h')), findsNothing);
    await openSheet(tester, h);
    expect(sheetText('Küçük Bir Kutu'), findsNothing);
    expect(sheetText('Kutu kırmızı.'), findsNothing);
    expect(sheetText('Onu açamıyor.'), findsOneWidget);
    expect(find.byKey(const ValueKey('page-tr-1')), findsNothing);
    // Panel sırası korunur: 0 → 2.
    expect(
      tester.getRect(find.byKey(const ValueKey('page-tr-2'))).top,
      greaterThan(tester.getRect(find.byKey(const ValueKey('page-tr-0'))).top),
    );
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
    await closeReader(tester, h);
  });

  testWidgets('sayfanın hiç Türkçesi yoksa düğmeler görünmez', (tester) async {
    final h = LibraryHarness(
      withoutTurkish: const {'c1-h', 'p01-s01', 'p01-s02', 'p01-s03'},
    );
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    expect(find.byKey(const ValueKey('reader-page-turkish')), findsNothing);
    expect(
      find.byKey(const ValueKey('reader-page-turkish-footer')),
      findsNothing,
    );
    // Sonraki sayfanın Türkçesi var.
    await tester.tap(find.byKey(const ValueKey('reader-next')));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('reader-page-turkish')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await closeReader(tester, h);
  });

  for (final mode in ['dinle', 'oku']) {
    testWidgets('320 × 568, metin 1,3×, en büyük yazı ($mode): satır altı '
        'Türkçe ve panel taşmaz', (tester) async {
      final h = await openSmall(tester, mode: mode, interlinear: true);
      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('tr-p01-s03')), findsOneWidget);
      await openSheet(tester, h);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Kapat'));
      await h.settle(tester);
      await tester.tap(find.byKey(const ValueKey('reader-settings-button')));
      await h.settle(tester);
      await tester.ensureVisible(
        find.byKey(const ValueKey('reader-interlinear')),
      );
      await h.settle(tester);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Kapat'));
      await h.settle(tester);
      if (mode == 'dinle') await h.listenFor(tester, 5.0);
      expect(tester.takeException(), isNull);
      await closeReader(tester, h);
    });
  }

  testWidgets('erişilebilirlik: düğme etiketleri, panel cümleleri düğme, '
      'dokunma hedefleri ve kontrast', (tester) async {
    final handle = tester.ensureSemantics();
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await tester.runAsync(() => BookProgressStore(h.db).setInterlinear(true));
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    expect(find.bySemanticsLabel('Sayfanın Türkçesi'), findsWidgets);
    expect(
      find.bySemanticsLabel("Türkçesi: Ece'nin küçük bir kutusu var."),
      findsOneWidget,
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    if (!skipGoldensOffMac) {
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
    await openSheet(tester, h);
    final node = tester.getSemantics(find.byKey(const ValueKey('page-tr-0')));
    expect(
      node,
      matchesSemantics(
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
        hasSelectedState: true,
        label: "Ece'nin küçük bir kutusu var.",
        hint: 'İngilizcesini sayfada göstermek için dokun',
      ),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    if (!skipGoldensOffMac) {
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
    await tester.tap(find.byTooltip('Kapat'));
    await h.settle(tester);
    await closeReader(tester, h);
    handle.dispose();
  });

  testWidgets('ekran okuyucu açıkken satır altı Türkçe cümle düğmesinin '
      'altında; panelden cümle seçilince panel kapanır', (tester) async {
    final handle = tester.ensureSemantics();
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(accessibleNavigation: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await tester.runAsync(() => BookProgressStore(h.db).setInterlinear(true));
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    expect(find.byKey(const ValueKey('s-p01-s02')), findsOneWidget);
    expect(find.byKey(const ValueKey('tr-p01-s02')), findsOneWidget);
    await openSheet(tester, h);
    await tapTr(tester, 1);
    await h.settle(tester);
    expect(find.byKey(const ValueKey('page-turkish')), findsNothing);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await closeReader(tester, h);
    handle.dispose();
  });
}
