import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/grammar/data/grammar_progress_store.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/shared/meaning/meaning_sheet.dart';

import '../../support/fake_content_source.dart';
import '../../support/grammar_harness.dart';

const _second = 'G-A1-02-there-is';

/// Dilbilgisi giriş noktaları (H-078): Hikâye'de "Macera · Kitaplık ·
/// Dilbilgisi", raflar, bölüm panelinde ve kitap açma panelinde "Bu
/// bölümdeki dilbilgisi" (dersler sırayla → "Bölümü başlat"), anlam panelinde
/// "Bu yapı ne?".
void main() {
  Finder key(String k) => find.byKey(ValueKey(k));

  Future<void> openGrammar(WidgetTester tester, GrammarHarness h) async {
    await tester.tap(find.text('Dilbilgisi'));
    await h.settle(tester);
  }

  Future<void> finishLesson(WidgetTester tester, GrammarHarness h) async {
    await h.next(tester, 6);
    await tester.tap(key('lesson-finish'));
    await h.settle(tester);
  }

  testWidgets('üç bölüm; Dilbilgisi rafları: hikâyende geçenler, senin '
      'seviyen, öteki seviyeler', (tester) async {
    final h = GrammarHarness(
      lessonIds: [kTestLessonId, _second, 'G-A2-01-was-were'],
      titles: {_second: 'There is / there are', 'G-A2-01-was-were': 'was'},
    );
    addTearDown(h.dispose);
    await tester.runAsync(
      () => BookProgressStore(h.db).savePosition(
        'A1-K99',
        chapterId: 'c1',
        pageNumber: 1,
        sentenceIndex: 0,
      ),
    );
    await h.pump(tester, '/hikaye');
    expect(find.text('Macera'), findsOneWidget);
    expect(find.text('Kitaplık'), findsOneWidget);
    expect(key('season-map'), findsOneWidget);

    await openGrammar(tester, h);
    expect(key('season-map'), findsNothing);
    expect(
      find.text('Hi, İngilizcenin nasıl işlediğini Türkçe ve kısaca anlatır.'),
      findsOneWidget,
    );
    expect(key('grammar-shelf-story'), findsOneWidget);
    expect(
      find.descendant(
        of: key('grammar-shelf-story'),
        matching: key('lesson-tile-$kTestLessonId'),
      ),
      findsOneWidget,
    );
    expect(find.text('Senin seviyen · A1'), findsOneWidget);
    expect(find.text('A2 konuları'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        RegExp(
          '^Üçüncü tekil -s, A1 seviyesi, '
          'yaklaşık 3 dakika',
        ),
      ),
      findsOneWidget,
    );

    // Ders açılır, bitince "Tamamladıkların"a geçer.
    await tester.tap(key('lesson-tile-$kTestLessonId'));
    await h.settle(tester);
    expect(key('lesson-card-c01'), findsOneWidget);
    await finishLesson(tester, h);
    await tester.tap(key('lesson-back'));
    await h.settle(tester);
    expect(key('grammar-shelf-story'), findsNothing);
    final list = find.descendant(
      of: key('grammar-view'),
      matching: find.byType(Scrollable),
    );
    final sections = key('story-sections');
    final sectionsTop = tester.getTopLeft(sections).dy;
    await tester.scrollUntilVisible(
      find.text('Tamamladıkların'),
      200,
      scrollable: list.first,
    );
    // Bölüm seçici sabit: yalnız liste kayar (2026-10-26).
    expect(sections, findsOneWidget);
    expect(tester.getTopLeft(sections).dy, sectionsTop);
    expect(key('lesson-done-tick'), findsOneWidget);
  });

  testWidgets('boş ve hata durumları; "Tekrar dene"', (tester) async {
    final empty = GrammarHarness(lessonIds: const []);
    addTearDown(empty.dispose);
    await empty.pump(tester, '/hikaye');
    await openGrammar(tester, empty);
    expect(key('grammar-empty'), findsOneWidget);
    expect(find.text('Dersler hazırlanıyor'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    final h = GrammarHarness(grammarFails: true);
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye');
    await openGrammar(tester, h);
    expect(key('grammar-error'), findsOneWidget);
    h.source.grammarFails = false;
    await tester.tap(key('grammar-retry'));
    await h.settle(tester);
    expect(key('lesson-tile-$kTestLessonId'), findsOneWidget);
  });

  testWidgets('bölüm paneli: "Bu bölümdeki dilbilgisi" → dersler sırayla → '
      '"Bölümü başlat" bölümü bugünkü gibi açar', (tester) async {
    final h = GrammarHarness(
      lessonIds: [kTestLessonId, _second],
      titles: {_second: 'There is / there are'},
      topics: {
        'A1-001': [kTestLessonId, _second],
      },
    );
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye');
    await tester.tap(key('map-node-1'));
    await h.settle(tester);
    expect(key('sheet-play'), findsOneWidget);
    expect(find.text('Bu bölümdeki dilbilgisi (~5 dk)'), findsOneWidget);
    expect(find.text('Üçüncü tekil -s · There is / there are'), findsOneWidget);

    await tester.tap(key('grammar-offer'));
    await h.settle(tester);
    expect(key('episode-sheet'), findsNothing);
    expect(key('lesson-card-c01'), findsOneWidget);
    expect(h.played, isEmpty, reason: 'bölüm henüz açılmadı');
    await finishLesson(tester, h);
    expect(find.text('Sıradaki konu: There is / there are'), findsOneWidget);
    await tester.tap(key('lesson-next-topic'));
    await h.settle(tester);
    expect(find.text('Kart 1 / 7'), findsOneWidget);
    await finishLesson(tester, h);
    expect(find.text('Bölümü başlat'), findsOneWidget);
    await tester.tap(key('lesson-continue'));
    await h.settle(tester);
    expect(find.text('play:A1-001:null'), findsOneWidget);
    final done = await tester.runAsync(() => GrammarProgressStore(h.db).all());
    expect(done!.values.every((p) => p.isCompleted), isTrue);
    expect(done.keys, containsAll([kTestLessonId, _second]));
  });

  testWidgets('bölüm paneli: dersten vazgeçilirse bölüm açılmaz; Başla '
      'her zamanki gibi', (tester) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye');
    await tester.tap(key('map-node-1'));
    await h.settle(tester);
    await tester.tap(key('grammar-offer'));
    await h.settle(tester);
    await tester.tap(key('lesson-close'));
    await h.settle(tester);
    expect(h.played, isEmpty);
    expect(key('season-map'), findsOneWidget);

    await tester.tap(key('map-node-1'));
    await h.settle(tester);
    await tester.tap(key('sheet-play'));
    await h.settle(tester);
    expect(find.text('play:A1-001:null'), findsOneWidget);
  });

  testWidgets('konusu olmayan bölümde düğme yok', (tester) async {
    final h = GrammarHarness(topics: const {});
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye');
    await tester.tap(key('map-node-1'));
    await h.settle(tester);
    expect(key('sheet-play'), findsOneWidget);
    expect(key('grammar-offer'), findsNothing);
  });

  testWidgets('kitap açma paneli: "Kitabı aç" ya da önce dilbilgisi', (
    tester,
  ) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye');
    await tester.tap(find.text('Kitaplık'));
    await h.settle(tester);
    await tester.tap(key('book-card-A1-K99'));
    await h.settle(tester);
    expect(key('book-open-sheet'), findsOneWidget);
    expect(find.text('Bu kitaptaki dilbilgisi (~3 dk)'), findsOneWidget);
    await tester.tap(key('grammar-offer'));
    await h.settle(tester);
    await finishLesson(tester, h);
    expect(find.text('Kitabı aç'), findsOneWidget);
    await tester.tap(key('lesson-continue'));
    await h.settle(tester);
    expect(find.text('The Test Box'), findsWidgets);
    expect(key('reader-close'), findsOneWidget);
    await tester.tap(key('reader-close'));
    await h.settle(tester);

    // Kitap artık "Okumaya devam et" rafında da görünür.
    await tester.tap(key('book-card-A1-K99').first);
    await h.settle(tester);
    await tester.tap(key('book-sheet-open'));
    await h.settle(tester);
    expect(key('reader-close'), findsOneWidget);
  });

  testWidgets('konusu olmayan kitap doğrudan açılır', (tester) async {
    final h = GrammarHarness(topics: const {});
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye');
    await tester.tap(find.text('Kitaplık'));
    await h.settle(tester);
    await tester.tap(key('book-card-A1-K99'));
    await h.settle(tester);
    expect(key('book-open-sheet'), findsNothing);
    expect(key('reader-close'), findsOneWidget);
  });

  testWidgets('anlam paneli: "Bu yapı ne?" kitabın konusunu açar', (
    tester,
  ) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    await tester.tap(key('w-p01-s01-3')); // small
    await h.settle(tester);
    expect(key('meaning-structures'), findsOneWidget);
    expect(find.text('BU YAPI NE?'), findsOneWidget);
    final chip = key('meaning-structure-$kTestLessonId');
    expect(
      find.descendant(of: chip, matching: find.text('Üçüncü tekil -s')),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      chip,
      100,
      scrollable: find
          .descendant(
            of: find.byType(MeaningSheet),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(chip);
    await h.settle(tester);
    expect(key('lesson-card-c01'), findsOneWidget);
    expect(key('meaning-structures'), findsNothing);
  });

  testWidgets('anlam paneli: konusu olmayan kitapta "Bu yapı ne?" yok', (
    tester,
  ) async {
    final h = GrammarHarness(topics: const {});
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    await tester.tap(key('w-p01-s01-3'));
    await h.settle(tester);
    expect(key('meaning-word-3'), findsOneWidget);
    expect(key('meaning-structures'), findsNothing);
  });

  testWidgets('320 × 568, metin 1,3×: üç bölüm sığar (kesilmez), raflar '
      'taşmaz', (tester) async {
    final h = GrammarHarness(
      lessonIds: [kTestLessonId, _second, 'G-B1-01-present-perfect'],
    );
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye', size: const Size(320, 568), textScale: 1.3);
    expect(tester.takeException(), isNull);
    for (final t in ['Macera', 'Kitaplık', 'Dilbilgisi']) {
      final p = tester.renderObject<RenderParagraph>(find.text(t));
      expect(p.didExceedMaxLines, isFalse, reason: t);
    }
    await openGrammar(tester, h);
    expect(tester.takeException(), isNull);
    expect(key('grammar-view'), findsOneWidget);
  });
}
