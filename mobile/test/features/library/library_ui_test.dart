import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/presentation/reader_screen.dart';

import '../../support/library_harness.dart';

/// Hikâye sekmesi → Kitaplık (H-067): bölüm seçici, raflar, "Bana bir kitap
/// oku", boş / hata durumları.
void main() {
  Future<void> openLibrary(WidgetTester tester, LibraryHarness h) async {
    await tester.tap(find.text('Kitaplık'));
    await h.settle(tester);
  }

  testWidgets('Macera · Kitaplık: harita değişmez, Kitaplık rafları gösterir', (
    tester,
  ) async {
    final h = LibraryHarness(
      bookIds: ['A1-K01', 'A1-K02', 'A2-K01', 'B1-K01'],
      suggestedLevel: 'A2',
    );
    addTearDown(h.dispose);
    await tester.runAsync(() async {
      final s = BookProgressStore(h.db);
      await s.savePosition(
        'A1-K02',
        chapterId: 'c1',
        pageNumber: 2,
        sentenceIndex: 0,
      );
      await s.savePosition(
        'B1-K01',
        chapterId: 'c2',
        pageNumber: 3,
        sentenceIndex: 0,
      );
      await s.markCompleted('B1-K01');
    });
    await h.pump(tester, '/hikaye');
    expect(find.text('Macera'), findsOneWidget);
    expect(find.byKey(const ValueKey('season-map')), findsOneWidget);

    await openLibrary(tester, h);
    expect(find.byKey(const ValueKey('season-map')), findsNothing);
    expect(find.byKey(const ValueKey('read-to-me')), findsOneWidget);
    expect(find.text('Okumaya devam et'), findsOneWidget);
    expect(find.text('Senin seviyen · A2'), findsOneWidget);
    expect(find.text('A1 kitapları'), findsOneWidget);
    expect(find.text('B1 kitapları'), findsOneWidget);
    final list = find.descendant(
      of: find.byKey(const ValueKey('library-view')),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('Okuduklarım'),
      200,
      scrollable: list.first,
    );
    expect(find.text('Okuduklarım'), findsOneWidget);
    // Yarım kitabın kartı yüzdesiyle (2. sayfa / 3 → %33).
    final cont = find.byKey(const ValueKey('shelf-continue'));
    expect(
      find.descendant(of: cont, matching: find.text('%33')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: cont,
        matching: find.bySemanticsLabel(RegExp('yüzde 33 okundu')),
      ),
      findsOneWidget,
    );
    // Geri dönünce harita yerinde.
    await tester.scrollUntilVisible(
      find.text('Macera'),
      -200,
      scrollable: list.first,
    );
    await tester.tap(find.text('Macera'));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('season-map')), findsOneWidget);
  });

  testWidgets('"Bana bir kitap oku": önerilen seviye seçili, okunmamış kitap '
      'sesli açılır; kalmadıysa sakin not', (tester) async {
    final h = LibraryHarness(
      bookIds: ['A1-K01', 'A2-K01', 'A2-K02'],
      suggestedLevel: 'A2',
    );
    addTearDown(h.dispose);
    await tester.runAsync(
      () => BookProgressStore(h.db).savePosition(
        'A2-K01',
        chapterId: 'c1',
        pageNumber: 1,
        sentenceIndex: 0,
      ),
    );
    await h.pump(tester, '/hikaye');
    await openLibrary(tester, h);
    await tester.tap(find.byKey(const ValueKey('read-to-me')));
    await h.settle(tester);
    expect(find.text('Önerilen seviye: A2'), findsOneWidget);
    final a2 = tester.widget<ChoiceChip>(
      find.byKey(const ValueKey('level-A2')),
    );
    expect(a2.selected, isTrue);
    await tester.tap(find.byKey(const ValueKey('open-random-book')));
    await h.settle(tester);
    // A2'de okunmamış tek kitap: A2-K02; sesli açılır.
    final reader = tester.widget<ReaderScreen>(find.byType(ReaderScreen));
    expect(reader.bookId, 'A2-K02');
    expect(reader.listen, isTrue);
    expect(h.audio.playing, isTrue);
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);

    // A2'deki iki kitap da açıldı: sakin not, kitap açılmaz.
    await tester.tap(find.byKey(const ValueKey('read-to-me')));
    await h.settle(tester);
    await tester.tap(find.byKey(const ValueKey('open-random-book')));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('no-unread')), findsOneWidget);
    expect(find.byType(ReaderScreen), findsNothing);
    // Başka seviye seçilebilir.
    await tester.tap(find.byKey(const ValueKey('level-A1')));
    await h.settle(tester);
    expect(find.byKey(const ValueKey('no-unread')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('open-random-book')));
    await h.settle(tester);
    expect(
      tester.widget<ReaderScreen>(find.byType(ReaderScreen)).bookId,
      'A1-K01',
    );
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
  });

  testWidgets('boş Kitaplık ve bağlantı hatası sakin; "Tekrar dene" çalışır', (
    tester,
  ) async {
    final h = LibraryHarness(bookIds: const []);
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye');
    await openLibrary(tester, h);
    expect(find.byKey(const ValueKey('library-empty')), findsOneWidget);
    expect(find.text('Kitaplar hazırlanıyor'), findsOneWidget);

    final e = LibraryHarness(bookIds: const ['A1-K01'], booksFail: true);
    addTearDown(e.dispose);
    await tester.pumpWidget(const SizedBox());
    await e.pump(tester, '/hikaye');
    await openLibrary(tester, e);
    expect(find.byKey(const ValueKey('library-error')), findsOneWidget);
    expect(find.text('Bağlantı kurulamadı'), findsOneWidget);
    e.source.booksFail = false;
    await tester.tap(find.byKey(const ValueKey('library-retry')));
    await e.settle(tester);
    expect(find.byKey(const ValueKey('library-error')), findsNothing);
    expect(find.byKey(const ValueKey('book-card-A1-K01')), findsWidgets);
  });

  testWidgets('kitap kartına dokununca okuyucu açılır', (tester) async {
    final h = LibraryHarness(bookIds: ['A1-K99']);
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye');
    await openLibrary(tester, h);
    await tester.tap(find.byKey(const ValueKey('book-card-A1-K99')).first);
    await h.settle(tester);
    expect(find.byType(ReaderScreen), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
    // Dönüşte kitap "Okumaya devam et" rafında.
    expect(find.text('Okumaya devam et'), findsOneWidget);
  });

  testWidgets('320 × 568, metin 1,3×: Kitaplık ve seçici taşmaz', (
    tester,
  ) async {
    final h = LibraryHarness(bookIds: ['A1-K01', 'A1-K02', 'A2-K01']);
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye', size: const Size(320, 568), textScale: 1.3);
    expect(tester.takeException(), isNull);
    await openLibrary(tester, h);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const ValueKey('read-to-me')));
    await h.settle(tester);
    expect(tester.takeException(), isNull);
  });
}
