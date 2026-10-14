import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/application/reader_controller.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/presentation/widgets/book_page_view.dart';

import '../../support/library_harness.dart';

/// Okuyucu (H-067): bölüm bölüm ses (sesi olmayan bölüm sessiz okunur) ve
/// sesli modda okunan yeri izleme (kaydırma).
void main() {
  const noteText = 'Bu bölümün sesi henüz hazır değil; kendin okuyabilirsin.';

  String pageLabel(WidgetTester t) =>
      t.widget<Text>(find.byKey(const ValueKey('reader-page-label'))).data!;

  ReaderMode mode(WidgetTester t) => t
      .widget<SegmentedButton<ReaderMode>>(
        find.byKey(const ValueKey('reader-mode')),
      )
      .selected
      .single;

  Future<void> closeReader(WidgetTester tester, LibraryHarness h) async {
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
  }

  group('bölüm bölüm ses', () {
    testWidgets(
      'seslendirilmiş bölüm bitince sesi olmayan bölüme sessiz geçilir, '
      'bir kez sakin not',
      (tester) async {
        final h = LibraryHarness(unnarrated: const {'c2'});
        addTearDown(h.dispose);
        await h.pump(tester, '/kitap/A1-K99');
        expect(mode(tester), ReaderMode.listen);
        expect(h.audio.playing, isTrue);
        await h.listenFor(tester, 11.6);
        await h.settle(tester);
        expect(h.audio.playing, isFalse);
        expect(mode(tester), ReaderMode.silent);
        expect(pageLabel(tester), 's. 3 / 3');
        expect(find.text(noteText), findsOneWidget);
        // c2'nin sesi hiç açılmadı.
        expect(h.audio.opened.where((u) => u.path.endsWith('c2.m4a')), isEmpty);
        // Sessiz modun düğmeleri (son sayfada "Kitabı bitir").
        expect(find.byKey(const ValueKey('reader-finish')), findsOneWidget);
        // Kalınan yer c2'nin başı.
        final p = await tester.runAsync(
          () => BookProgressStore(h.db).get('A1-K99'),
        );
        expect(p!.chapterId, 'c2');
        expect(p.pageNumber, 3);
        await closeReader(tester, h);
      },
    );

    testWidgets('sesi olmayan bölümde "Sesli": not çıkar, sessiz kalır', (
      tester,
    ) async {
      final h = LibraryHarness(unnarrated: const {'c2'});
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99?mod=oku');
      expect(mode(tester), ReaderMode.silent);
      await tester.tap(find.byKey(const ValueKey('reader-next')));
      await h.settle(tester);
      await tester.tap(find.byKey(const ValueKey('reader-next')));
      await h.settle(tester);
      expect(pageLabel(tester), 's. 3 / 3');
      await tester.tap(find.text('Sesli'));
      await h.settle(tester);
      expect(find.text(noteText), findsOneWidget);
      expect(mode(tester), ReaderMode.silent);
      expect(h.audio.plays, 0);
      // Not kendiliğinden kapanır.
      await tester.pump(const Duration(seconds: 5));
      await h.settle(tester);
      expect(find.text(noteText), findsNothing);
      // Seslendirilmiş bölüme dönünce "Sesli" çalışır.
      await tester.tap(find.byKey(const ValueKey('reader-prev')));
      await h.settle(tester);
      await tester.tap(find.text('Sesli'));
      await h.settle(tester);
      expect(mode(tester), ReaderMode.listen);
      expect(h.audio.playing, isTrue);
      await closeReader(tester, h);
    });

    testWidgets('sesi olmayan bölümde kalınan kitap sesli istenirse sessiz '
        'açılır, not', (tester) async {
      final h = LibraryHarness(unnarrated: const {'c2'});
      addTearDown(h.dispose);
      await tester.runAsync(
        () => BookProgressStore(h.db).savePosition(
          'A1-K99',
          chapterId: 'c2',
          pageNumber: 3,
          sentenceIndex: 0,
          positionSec: null,
        ),
      );
      await h.pump(tester, '/kitap/A1-K99');
      expect(pageLabel(tester), 's. 3 / 3');
      expect(mode(tester), ReaderMode.silent);
      expect(find.text(noteText), findsOneWidget);
      expect(h.audio.plays, 0);
      await closeReader(tester, h);
    });

    testWidgets('bütün bölümleri seslendirilmiş kitap değişmez: sıradaki '
        'bölüm sesli sürer, not yok', (tester) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99');
      await h.listenFor(tester, 11.6);
      await h.settle(tester);
      expect(pageLabel(tester), 's. 3 / 3');
      expect(mode(tester), ReaderMode.listen);
      expect(h.audio.playing, isTrue);
      expect(h.audio.opened.last.path, endsWith('c2.m4a'));
      expect(find.text(noteText), findsNothing);
      await closeReader(tester, h);
    });
  });

  group('okunan yeri izleme', () {
    ScrollPosition position(WidgetTester t, String pageId) => t
        .state<ScrollableState>(
          find.descendant(
            of: find.byKey(ValueKey('book-page-$pageId')),
            matching: find.byType(Scrollable),
          ),
        )
        .position;

    /// Okunan kelime (kelime vurgusu açık: altı çizili).
    Finder spokenWord() =>
        find.byWidgetPredicate((w) => w is BookWordView && w.underline != null);

    /// Okunan kelime metin alanında ve alt denetimlerin üstünde mi?
    void expectSpokenVisible(WidgetTester t, String pageId) {
      expect(spokenWord(), findsOneWidget);
      final view = t.getRect(find.byKey(ValueKey('book-page-$pageId')));
      final controls = t.getRect(find.byKey(const ValueKey('reader-mode')));
      final word = t.getRect(spokenWord());
      expect(word.top, greaterThanOrEqualTo(view.top - 0.5));
      expect(word.bottom, lessThanOrEqualTo(view.bottom + 0.5));
      expect(word.bottom, lessThan(controls.top));
    }

    /// Küçük ekran, en büyük okuma yazısı ve 1,3× sistem yazısı: sayfa
    /// görünür alandan uzun, cümleler bile çok satırlı.
    Future<LibraryHarness> open(
      WidgetTester tester, {
      bool reduceMotion = false,
    }) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await tester.runAsync(() async {
        final store = BookProgressStore(h.db);
        await store.setTextSize(2);
        await store.setWordHighlight(true);
      });
      await h.pump(
        tester,
        '/kitap/A1-K99',
        size: const Size(320, 568),
        textScale: 1.3,
        reduceMotion: reduceMotion,
      );
      return h;
    }

    testWidgets('okunan yer görünmeyen yere geçince sayfa kayar; '
        'denetimlerin altında kalmaz', (tester) async {
      final h = await open(tester);
      final pos = position(tester, 'p01');
      final start = pos.pixels;
      // Başta son cümle (p01-s03) görünür alanın dışında.
      final view = tester.getRect(find.byKey(const ValueKey('book-page-p01')));
      expect(
        tester.getRect(find.byKey(const ValueKey('w-p01-s03-0'))).top,
        greaterThan(view.bottom),
      );
      await h.listenFor(tester, 5.0); // p01-s03 (4,6 sn) okunuyor
      await h.settle(tester);
      expect(pos.pixels, greaterThan(start));
      expectSpokenVisible(tester, 'p01');
      await h.listenFor(tester, 0.6);
      expectSpokenVisible(tester, 'p01');
      expect(tester.takeException(), isNull);
      await closeReader(tester, h);
    });

    testWidgets('okunan cümle rahat görünüyorsa sayfa kıpırdamaz', (
      tester,
    ) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99');
      await h.listenFor(tester, 6.0); // sayfa 1'in bütün cümleleri
      expect(pageLabel(tester), 's. 1 / 3');
      expect(position(tester, 'p01').pixels, 0);
      await closeReader(tester, h);
    });

    testWidgets('elle kaydırma izlemeyi durdurur ("Okunan yere dön"); '
        '~4 sn sonra izleme sürer', (tester) async {
      final h = await open(tester);
      final pos = position(tester, 'p01');
      await h.listenFor(tester, 5.0);
      await h.settle(tester);
      expect(pos.pixels, greaterThan(0));
      // Kullanıcı en üste kaydırır.
      await tester.drag(
        find.byKey(const ValueKey('book-page-p01')),
        const Offset(0, 3000),
      );
      await h.settle(tester);
      expect(pos.pixels, 0);
      expect(find.byKey(const ValueKey('reader-follow-back')), findsOneWidget);
      expect(find.text('Okunan yere dön'), findsOneWidget);
      // Okuma sürer ama sayfa kullanıcının bıraktığı yerde kalır.
      await h.listenFor(tester, 0.3);
      expect(h.audio.playing, isTrue);
      expect(pos.pixels, 0);
      // 4 sn kaydırma olmadı: izleme sürer, okunan yere döner.
      await tester.pump(const Duration(seconds: 4));
      await h.settle(tester);
      expect(find.byKey(const ValueKey('reader-follow-back')), findsNothing);
      expect(pos.pixels, greaterThan(0));
      expectSpokenVisible(tester, 'p01');
      await closeReader(tester, h);
    });

    testWidgets('"Okunan yere dön" çipine dokununca hemen döner', (
      tester,
    ) async {
      final h = await open(tester);
      final pos = position(tester, 'p01');
      await h.listenFor(tester, 5.0);
      await h.settle(tester);
      await tester.drag(
        find.byKey(const ValueKey('book-page-p01')),
        const Offset(0, 3000),
      );
      await h.settle(tester);
      expect(pos.pixels, 0);
      await tester.tap(find.byKey(const ValueKey('reader-follow-back')));
      await h.settle(tester);
      expect(find.byKey(const ValueKey('reader-follow-back')), findsNothing);
      expect(pos.pixels, greaterThan(0));
      expectSpokenVisible(tester, 'p01');
      await closeReader(tester, h);
    });

    testWidgets('hareketi azalt: kaydırma animasyonsuz (atlama)', (
      tester,
    ) async {
      final h = await open(tester, reduceMotion: true);
      final pos = position(tester, 'p01');
      bool reading() => tester
          .widget<BookWordView>(find.byKey(const ValueKey('w-p01-s03-0')))
          .highlighted;
      // Cümle değişene kadar 50 ms adımlarla.
      var before = pos.pixels;
      while (!reading()) {
        before = pos.pixels;
        h.clock.advance(0.05);
        await tester.pump(const Duration(milliseconds: 50));
      }
      // Vurgunun çizildiği karede kaydırma tek adımda bitti (ara kare yok).
      final jumped = pos.pixels;
      expect(jumped, greaterThan(before));
      await tester.pump(const Duration(milliseconds: 16));
      expect(pos.pixels, jumped);
      await tester.pump(const Duration(milliseconds: 100));
      expect(pos.pixels, jumped);
      expectSpokenVisible(tester, 'p01');
      await closeReader(tester, h);
    });

    testWidgets('yeni sayfa en üstten açılır, sonra okunan yeri izler', (
      tester,
    ) async {
      final h = await open(tester);
      await h.listenFor(tester, 6.4); // p02-s01 (6,325 sn) başladı
      await h.settle(tester);
      expect(pageLabel(tester), 's. 2 / 3');
      expect(position(tester, 'p02').pixels, 0);
      expectSpokenVisible(tester, 'p02');
      await h.listenFor(tester, 2.5); // aynı cümlenin son kelimeleri
      expectSpokenVisible(tester, 'p02');
      await closeReader(tester, h);
    });
  });
}
