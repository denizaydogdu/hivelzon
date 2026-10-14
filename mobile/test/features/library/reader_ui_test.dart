import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/domain/book_progress.dart';
import 'package:hivelzon/features/library/presentation/widgets/book_page_view.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';

import '../../support/golden.dart';
import '../../support/library_harness.dart';

/// Okuyucu (H-067): sesli/sessiz, vurgu, otomatik sayfa, anlam paneli,
/// Defter'e ekleme, kaldığı yer, uyku zamanlayıcısı, hareketi azalt,
/// erişilebilirlik ve büyük yazı.
void main() {
  BookWordView word(WidgetTester t, String sentence, int i) =>
      t.widget<BookWordView>(find.byKey(ValueKey('w-$sentence-$i')));

  String pageLabel(WidgetTester t) =>
      t.widget<Text>(find.byKey(const ValueKey('reader-page-label'))).data!;

  Future<void> closeReader(WidgetTester tester, LibraryHarness h) async {
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
  }

  testWidgets(
    'sesli mod: okunan cümle vurgulanır, ilerler; sayfa kendiliğinden '
    'çevrilir; ilerleme kaydedilir',
    (tester) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99');
      expect(h.audio.playing, isTrue);
      expect(pageLabel(tester), 's. 1 / 3');
      // Başlık okunuyor.
      expect(word(tester, 'c1-h', 0).highlighted, isTrue);
      expect(word(tester, 'p01-s01', 0).highlighted, isFalse);
      await h.listenFor(tester, 1.5);
      expect(word(tester, 'c1-h', 0).highlighted, isFalse);
      expect(word(tester, 'p01-s01', 0).highlighted, isTrue);
      await h.listenFor(tester, 1.8); // 3,3 sn: ikinci cümle
      expect(word(tester, 'p01-s01', 0).highlighted, isFalse);
      expect(word(tester, 'p01-s02', 2).highlighted, isTrue);
      // 6,325 sn'de 2. sayfa.
      await h.listenFor(tester, 3.3);
      await h.settle(tester);
      expect(pageLabel(tester), 's. 2 / 3');
      expect(word(tester, 'p02-s01', 0).highlighted, isTrue);
      final p = await tester.runAsync(
        () => BookProgressStore(h.db).get('A1-K99'),
      );
      expect(p!.status, BookStatus.inProgress);
      expect(p.pageNumber, 2);
      expect(p.sentenceIndex, 0);
      await closeReader(tester, h);
    },
  );

  testWidgets(
    'duraklat, 10 sn geri, hız; kelime vurgusu ayarı ve yazı boyutu',
    (tester) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99');
      await tester.tap(find.byKey(const ValueKey('reader-play')));
      await h.settle(tester);
      expect(h.audio.playing, isFalse);
      expect(find.byTooltip('Dinle'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('reader-speed')));
      await h.settle(tester);
      expect(find.text('1,25x'), findsOneWidget);
      expect(h.audio.speeds.last, 1.25);
      await tester.tap(find.byKey(const ValueKey('reader-play')));
      await h.settle(tester);
      expect(h.audio.playing, isTrue);
      await h.listenFor(tester, 2.0);
      await tester.tap(find.byKey(const ValueKey('reader-back10')));
      await h.settle(tester);
      expect(h.audio.seeks.last, 0);

      // Ayarlar: kelime vurgusu açılır, yazı büyür (cihazda saklanır).
      await tester.tap(find.byKey(const ValueKey('reader-settings-button')));
      await h.settle(tester);
      final before = word(tester, 'p01-s01', 0).style.fontSize!;
      await tester.tap(find.byKey(const ValueKey('reader-word-highlight')));
      await tester.tap(find.byKey(const ValueKey('text-size-2')));
      await h.settle(tester);
      await tester.tap(find.byTooltip('Kapat'));
      await h.settle(tester);
      expect(word(tester, 'p01-s01', 0).style.fontSize, greaterThan(before));
      final store = BookProgressStore(h.db);
      expect(await tester.runAsync(store.textSize), 2);
      expect(await tester.runAsync(store.wordHighlight), isTrue);
      // "small" (1,975–2,35 sn; 1,25x hızda ~1,6 sn sonra) altı çizili.
      await h.listenFor(tester, 1.65);
      expect(word(tester, 'p01-s01', 3).underline, isNotNull);
      expect(word(tester, 'p01-s01', 0).underline, isNull);
      await closeReader(tester, h);
    },
  );

  testWidgets('kelimeye dokun → ses durur, anlam paneli; kapanınca sürer; '
      '"Deftere ekle" kitap kaynağıyla kaydeder', (tester) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    await h.listenFor(tester, 2.0);
    expect(h.audio.playing, isTrue);
    await tester.tap(find.byKey(const ValueKey('w-p01-s01-3'))); // small
    await h.settle(tester);
    expect(find.byKey(const ValueKey('meaning-gloss')), findsOneWidget);
    expect(find.text('küçük'), findsWidgets);
    // Panel kelimenin sesini kitaptan çaldı; okuma durdu.
    expect(h.audio.seeks.last, closeTo(1.975, 1e-9));
    await h.listenFor(tester, 0.6);
    await tester.tap(find.byKey(const ValueKey('meaning-save')));
    await h.settle(tester);
    expect(find.text('"small" deftere eklendi.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('meaning-close')));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('meaning-gloss')), findsNothing);
    // Kaldığı yerden (~2,0 sn) sürer.
    expect(h.audio.playing, isTrue);
    expect(h.audio.seeks.last, closeTo(2.0, 0.06));
    final items = await tester.runAsync(() => NotebookStore(h.db).entries());
    final item = items!.single.item;
    expect(item.textEn, 'small');
    expect(item.source, NotebookSource.book);
    expect(item.sourceTitle, 'The Test Box');
    expect(item.exampleEn, 'Ece has a small box.');
    expect(item.audio!.start, 1.975);
    expect(items.single.card.isNew, isTrue);
    await closeReader(tester, h);
  });

  testWidgets('sesli modda uzun basma: tek dokunuşla Defter, ses durmaz; '
      'Defter\'de kaynak satırı ve kitaba göre süzme', (tester) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    await h.listenFor(tester, 1.0);
    await tester.longPress(find.byKey(const ValueKey('w-p01-s01-4'))); // box.
    await h.settle(tester);
    expect(find.text('Deftere eklendi'), findsOneWidget);
    expect(h.audio.playing, isTrue);
    await tester.longPress(find.byKey(const ValueKey('w-p01-s01-4')));
    await h.settle(tester);
    expect(find.text('"box" zaten defterinde.'), findsOneWidget);
    expect(
      (await tester.runAsync(() => NotebookStore(h.db).entries()))!.length,
      1,
    );
    await closeReader(tester, h);

    // Defter: satırın kaynağı ve süzgeç.
    await tester.pumpWidget(const SizedBox());
    await h.pump(tester, '/defter');
    // Satır listenin altında (görünür alanın dışında da kurulur).
    Finder text(String t) => find.text(t, skipOffstage: false);
    expect(text('Kitap: The Test Box, s. 1'), findsOneWidget);
    expect(find.byKey(const ValueKey('notebook-filter-story')), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const ValueKey('notebook-filter-story')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('notebook-filter-story')));
    await h.settle(tester);
    expect(text('box'), findsNothing);
    await tester.ensureVisible(
      find.byKey(const ValueKey('notebook-filter-book:A1-K99')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('notebook-filter-book:A1-K99')));
    await h.settle(tester);
    expect(text('box'), findsOneWidget);
  });

  testWidgets('sessiz mod: ses yok; uzun basılan cümle tek başına çalar; '
      'sayfa çevrilir; "Kitabı bitir" → sakin kutlama ve kaydedilenler', (
    tester,
  ) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    expect(h.audio.playing, isFalse);
    expect(find.byKey(const ValueKey('reader-play')), findsNothing);
    expect(word(tester, 'c1-h', 0).highlighted, isFalse);
    await tester.longPress(find.byKey(const ValueKey('w-p01-s02-1')));
    await h.settle(tester);
    expect(h.audio.playing, isTrue);
    expect(h.audio.seeks.last, closeTo(3.1, 1e-9));
    expect(word(tester, 'p01-s02', 0).highlighted, isTrue);
    await h.listenFor(tester, 1.2);
    expect(h.audio.playing, isFalse);
    expect(word(tester, 'p01-s02', 0).highlighted, isFalse);
    // Sessiz modda anlam panelinden ekle.
    await tester.tap(find.byKey(const ValueKey('w-p01-s02-3'))); // red.
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('meaning-save')));
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('meaning-close')));
    await h.settle(tester);

    await tester.tap(find.byKey(const ValueKey('reader-next')));
    await h.settle(tester);
    expect(pageLabel(tester), 's. 2 / 3');
    await tester.drag(
      find.byKey(const ValueKey('reader-pages')),
      const Offset(-300, 0),
    );
    await h.settle(tester);
    expect(pageLabel(tester), 's. 3 / 3');
    await tester.tap(find.byKey(const ValueKey('reader-finish')));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('end-of-book')), findsOneWidget);
    expect(find.text('Kitabı bitirdin'), findsOneWidget);
    // Aynı seviyede başka kitap yok: "Sıradaki kitabı aç" görünmez.
    expect(find.byKey(const ValueKey('end-next-book')), findsNothing);
    expect(find.text('Bu kitapta kaydettiklerin'), findsOneWidget);
    expect(find.text('red'), findsOneWidget);
    expect(find.text('Kitap: The Test Box, s. 1'), findsOneWidget);
    // Puan, lig ve geri sayım yok.
    for (final bad in ['puan', 'Puan', 'lig', 'saniye kaldı']) {
      expect(find.textContaining(bad), findsNothing);
    }
    final p = await tester.runAsync(
      () => BookProgressStore(h.db).get('A1-K99'),
    );
    expect(p!.status, BookStatus.completed);
    await tester.tap(find.byKey(const ValueKey('end-read-again')));
    await h.settle(tester);
    expect(pageLabel(tester), 's. 1 / 3');
    await closeReader(tester, h);
  });

  testWidgets('kitap sonu: aynı seviyede açılmamış kitap sesli açılır', (
    tester,
  ) async {
    final h = LibraryHarness(bookIds: ['A1-K99', 'A1-K02']);
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byKey(const ValueKey('reader-next')));
      await h.settle(tester);
    }
    await tester.tap(find.byKey(const ValueKey('reader-finish')));
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('end-next-book')));
    await h.settle(tester);
    expect(find.text('The Test Box A1-K02'), findsOneWidget);
    expect(h.audio.playing, isTrue);
    await closeReader(tester, h);
  });

  testWidgets('yarıda kalan kitap kaldığı cümleden açılır', (tester) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await tester.runAsync(
      () => BookProgressStore(h.db).savePosition(
        'A1-K99',
        chapterId: 'c1',
        pageNumber: 2,
        sentenceIndex: 1,
        positionSec: 9.525,
      ),
    );
    await h.pump(tester, '/kitap/A1-K99');
    expect(pageLabel(tester), 's. 2 / 3');
    expect(word(tester, 'p02-s02', 0).highlighted, isTrue);
    expect(h.audio.seeks.first, closeTo(9.525, 1e-9));
    expect(h.audio.playing, isTrue);
    await closeReader(tester, h);
  });

  testWidgets('bölüm listesi ve uyku zamanlayıcısı (bölüm sonunda durur)', (
    tester,
  ) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    await tester.tap(find.byKey(const ValueKey('reader-chapters-button')));
    await h.settle(tester);
    expect(find.text('2. The Key'), findsOneWidget);
    expect(find.text('Anahtar'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('chapter-c2')));
    await h.settle(tester);
    expect(pageLabel(tester), 's. 3 / 3');
    expect(h.audio.opened.last.path, endsWith('audio/c2.m4a'));
    await tester.tap(find.byKey(const ValueKey('reader-chapters-button')));
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('chapter-c1')));
    await h.settle(tester);
    expect(pageLabel(tester), 's. 1 / 3');

    await tester.tap(find.byKey(const ValueKey('reader-sleep-button')));
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('sleep-endOfChapter')));
    await h.settle(tester);
    expect(find.text('Uyku zamanlayıcısı: Bölüm sonunda'), findsOneWidget);
    await h.listenFor(tester, 11.6);
    expect(h.audio.playing, isFalse);
    expect(
      find.text('Uyku zamanlayıcısı sesi durdurdu. İyi uykular!'),
      findsOneWidget,
    );
    // Bir sonraki bölümün başında bekler (kaldığı yer orası).
    expect(pageLabel(tester), 's. 3 / 3');
    await closeReader(tester, h);
  });

  testWidgets('hareketi azalt: sayfa kaymadan çevrilir', (tester) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99', reduceMotion: true);
    await tester.tap(find.byKey(const ValueKey('reader-chapters-button')));
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('chapter-c2')));
    await h.settle(tester);
    // Otomatik çevirmede ara kare yok: tek karede yeni sayfa.
    await tester.tap(find.byKey(const ValueKey('reader-chapters-button')));
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('chapter-c1')));
    await tester.pump();
    await tester.pump();
    final pv = tester.widget<PageView>(
      find.byKey(const ValueKey('reader-pages')),
    );
    expect(pv.controller!.page, 0);
    await h.listenFor(tester, 6.5);
    await tester.pump();
    expect(pv.controller!.page, 1.0);
    await closeReader(tester, h);
  });

  testWidgets('ses açılamazsa sessiz okunur, sakin not', (tester) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    h.audio.failOpen = true;
    await h.pump(tester, '/kitap/A1-K99');
    expect(
      find.text('Bu kitabın sesi şu an açılamıyor. Sessiz okuyabilirsin.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('reader-next')), findsOneWidget);
    await closeReader(tester, h);
  });

  testWidgets('kitap açılamazsa hata ve "Tekrar dene"', (tester) async {
    final h = LibraryHarness(booksFail: true);
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    expect(find.byKey(const ValueKey('reader-error')), findsOneWidget);
    h.source.booksFail = false;
    await tester.tap(find.byKey(const ValueKey('reader-retry')));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('reader-pages')), findsOneWidget);
    await closeReader(tester, h);
  });

  testWidgets('erişilebilirlik: dokunma hedefleri, etiketler, kontrast', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99');
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    if (!skipGoldensOffMac) {
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }
    // Ekran okuyucu paragrafı metin olarak okur.
    expect(
      find.bySemanticsLabel('Ece has a small box. The box is red.'),
      findsOneWidget,
    );
    await closeReader(tester, h);
    handle.dispose();
  });

  testWidgets('ekran okuyucu açıkken cümleler ayrı düğme; dokununca anlam', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(accessibleNavigation: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    expect(find.byKey(const ValueKey('s-p01-s01')), findsOneWidget);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await tester.tap(find.byKey(const ValueKey('s-p01-s01')));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('meaning-reveal')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('meaning-close')));
    await h.settle(tester);
    await closeReader(tester, h);
    handle.dispose();
  });

  for (final mode in ['dinle', 'oku']) {
    testWidgets('320 × 568, metin 1,3× ($mode): taşma yok', (tester) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(
        tester,
        '/kitap/A1-K99?mod=$mode',
        size: const Size(320, 568),
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const ValueKey('reader-settings-button')));
      await h.settle(tester);
      await tester.tap(find.byKey(const ValueKey('text-size-2')));
      await h.settle(tester);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Kapat'));
      await h.settle(tester);
      if (mode == 'oku') {
        await tester.tap(find.byKey(const ValueKey('reader-next')));
        await h.settle(tester);
        await tester.tap(find.byKey(const ValueKey('reader-next')));
        await h.settle(tester);
        await tester.tap(find.byKey(const ValueKey('reader-finish')));
        await h.settle(tester);
        expect(find.byKey(const ValueKey('end-of-book')), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
      await closeReader(tester, h);
    });
  }
}
