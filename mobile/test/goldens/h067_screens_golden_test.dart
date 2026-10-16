// H-067 ekran golden'ları ve erişilebilirlik denetimi: Kitaplık (raflar),
// okuyucu (sesli, okunan cümle vurgulu) ve kitap sonu (sakin kutlama +
// "Bu kitapta kaydettiklerin").
//
// Kitap: H-066 deneme kitabı A1-K99 (test kopyası); ağ görselleri testte
// açılmaz, kapak ve sayfa resmi yerine palet renkli yer tutucu görünür.
// Bilinçli görsel değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/domain/book_notebook.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';

import '../support/app_fonts.dart';
import '../support/fake_content_source.dart';
import '../support/golden.dart';
import '../support/library_harness.dart';

class _Case {
  const _Case(this.location, {this.prepare, this.act, this.books});

  final String location;
  final List<String>? books;
  final Future<void> Function(LibraryHarness h)? prepare;
  final Future<void> Function(WidgetTester tester, LibraryHarness h)? act;
}

Future<void> _saveWords(LibraryHarness h) async {
  final book = loadTestBook();
  final repo = DriftNotebookRepository(NotebookStore(h.db));
  final now = DateTime.utc(2026, 10, 14, 20);
  await repo.add(bookWordSave(book, 0, 0, 3, now: now)); // small
  await repo.add(bookWordSave(book, 2, 0, 3, now: now)); // key
}

final _cases = <String, _Case>{
  'kitaplik': _Case(
    '/hikaye',
    books: const ['A1-K01', 'A1-K02', 'A1-K03', 'A2-K01', 'A2-K02', 'B1-K01'],
    prepare: (h) async {
      final s = BookProgressStore(h.db);
      await s.savePosition(
        'A1-K02',
        chapterId: 'c1',
        pageNumber: 2,
        sentenceIndex: 0,
      );
      await s.savePosition(
        'A2-K01',
        chapterId: 'c2',
        pageNumber: 3,
        sentenceIndex: 0,
      );
      await s.markCompleted('A2-K01');
    },
    act: (tester, h) async {
      await tester.tap(find.text('Kitaplık'));
      await h.settle(tester);
    },
  ),
  'okuyucu': _Case(
    '/kitap/A1-K99',
    act: (tester, h) async {
      // "The box is red." okunuyor; kelime vurgusu kapalı.
      await h.listenFor(tester, 3.4);
      await tester.tap(find.byKey(const ValueKey('reader-play')));
      await h.settle(tester);
    },
  ),
  'kitap_sonu': _Case(
    '/kitap/A1-K99?mod=oku',
    prepare: _saveWords,
    act: (tester, h) async {
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byKey(const ValueKey('reader-next')));
        await h.settle(tester);
      }
      await tester.tap(find.byKey(const ValueKey('reader-finish')));
      await h.settle(tester);
      await tester.tap(find.byKey(const ValueKey('comp-skip')));
      await h.settle(tester);
    },
  ),
};

void main() {
  setUpAll(loadAppFonts);

  Future<LibraryHarness> pumpCase(
    WidgetTester tester,
    _Case c, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    final h = LibraryHarness(
      bookIds: c.books ?? const ['A1-K99'],
      suggestedLevel: 'A1',
    );
    addTearDown(h.dispose);
    if (c.prepare != null) await tester.runAsync(() => c.prepare!(h));
    await h.pump(tester, c.location, size: size, textScale: textScale);
    if (c.act != null) await c.act!(tester, h);
    // Belirme animasyonları bitsin; görseller hata verip yer tutucuya geçsin.
    await h.settle(tester);
    return h;
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  }

  for (final MapEntry(key: id, value: c) in _cases.entries) {
    testWidgets('golden: $id', (tester) async {
      await pumpCase(tester, c);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h067_$id.png'),
      );
      await unmount(tester);
    }, skip: skipGoldensOffMac);

    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCase(tester, c);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // Piksel ölçümü yazı tipi çizimine bağlı; yalnız golden'ların
      // üretildiği macOS'ta.
      if (!skipGoldensOffMac) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
      await unmount(tester);
    });

    testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
      tester,
    ) async {
      await pumpCase(tester, c, size: const Size(320, 568), textScale: 1.3);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }
}
