// 17 Ekim 2026 ürün incelemesi — Regresyon #3 (kitap okuma ve yeniden anlatma).
//
// Bulgular:
// - Kitabı **yalnız açmak** günlük okuma adımını tamamlamış sayılabiliyordu
//   (`reader_screen.dart` ilk açılışta konum yazıyordu; Hi `lastRead`'e
//   bakıyordu).
// - **Örnek özeti açmak** yeniden anlatma yapıldı diye saklanıyordu
//   (`retellDone: _modelShown || _selfCheck != null`).
//
// Doğru davranış: kayıt gerçek ilerlemeyle (sayfa/cümle) oluşur; yeniden
// anlatma yalnız gerçek bir denemeyle (yazılan anlatım) ya da kullanıcının
// kendini değerlendirmesiyle sayılır. Örnek görüntülemek ikisi de değildir.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_comprehension_store.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/domain/book_comprehension.dart';
import 'package:hivelzon/features/library/domain/book_progress.dart';
import 'package:hivelzon/features/library/presentation/reader_screen.dart';

import '../support/library_harness.dart';

void main() {
  Future<void> toEnd(WidgetTester tester, LibraryHarness h) async {
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byKey(const ValueKey('reader-next')));
      await h.settle(tester);
    }
    await tester.tap(find.byKey(const ValueKey('reader-finish')));
    await h.settle(tester);
  }

  Future<void> tapKey(WidgetTester tester, LibraryHarness h, String key) async {
    final f = find.byKey(ValueKey(key));
    await tester.ensureVisible(f);
    await h.settle(tester);
    await tester.tap(f);
    await h.settle(tester);
  }

  group('bulgu 1: kitabı açmak okuma adımı değildir', () {
    testWidgets('sessiz modda açmak ilerleme yazmaz; sayfa çevirince yazar', (
      tester,
    ) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99?mod=oku');
      expect(find.byType(ReaderScreen), findsOneWidget);
      expect(find.text('s. 1 / 3'), findsOneWidget);

      // Açmak: kayıt yok (ne "okunuyor" ne "bugün okundu").
      expect(
        await tester.runAsync(() => BookProgressStore(h.db).get('A1-K99')),
        isNull,
      );

      // Gerçek ilerleme: sonraki sayfa.
      await tapKey(tester, h, 'reader-next');
      final p = await tester.runAsync(
        () => BookProgressStore(h.db).get('A1-K99'),
      );
      expect(p, isNotNull);
      expect(p!.status, BookStatus.inProgress);
      expect(p.pageNumber, 2);
    });

    testWidgets('açmak "son okuma"yı güncellemez; ilerleme günceller', (
      tester,
    ) async {
      // Hi'nin günlük ana adımı `books.lastRead`e (>= `updatedAt`) bakar;
      // açmak bu alanı yazarsa adım yanlışlıkla tamamlanır. Zincirin kökü:
      // açılışta kayıt yok, ilerlemede kayıt var.
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99?mod=oku');
      final store = BookProgressStore(h.db);
      final opened = await tester.runAsync(() => store.all());
      expect(opened, isEmpty);

      await tapKey(tester, h, 'reader-next');
      final after = await tester.runAsync(() => store.all());
      expect(after!.keys, ['A1-K99']);
      final p = after['A1-K99']!;
      expect(p.status, BookStatus.inProgress);
      expect(p.updatedAt, isNotNull);
    });
  });

  group('bulgu 2: örnek özeti açmak yeniden anlatma değildir', () {
    testWidgets('yalnız örnek açıp bitirmek: retellDone false', (tester) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99?mod=oku');
      await toEnd(tester, h);
      await tapKey(tester, h, 'comp-show-model');
      expect(find.byKey(const ValueKey('comp-model-en')), findsOneWidget);
      await tapKey(tester, h, 'comp-finish');
      final r = await tester.runAsync(
        () => BookComprehensionStore(h.db).get('A1-K99'),
      );
      expect(r, isNotNull);
      expect(r!.retellDone, isFalse);
      expect(r.selfCheck, isNull);
    });

    testWidgets('anlatım yazınca retellDone true', (tester) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99?mod=oku');
      await toEnd(tester, h);
      await tester.enterText(
        find.byKey(const ValueKey('comp-retell-field')),
        'Ece has a red box.',
      );
      await tapKey(tester, h, 'comp-finish');
      final r = await tester.runAsync(
        () => BookComprehensionStore(h.db).get('A1-K99'),
      );
      expect(r!.retellDone, isTrue);
    });

    testWidgets('kendini değerlendirme retellDone true, türü ayrı saklanır', (
      tester,
    ) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99?mod=oku');
      await toEnd(tester, h);
      await tapKey(tester, h, 'comp-show-model');
      // "Bazılarını söyledim" beyanı (çip anahtarı comp-self-some).
      await tapKey(tester, h, 'comp-self-some');
      await tapKey(tester, h, 'comp-finish');
      final r = await tester.runAsync(
        () => BookComprehensionStore(h.db).get('A1-K99'),
      );
      expect(r!.retellDone, isTrue);
      expect(r.selfCheck, RetellSelfCheck.some);
    });
  });
}
