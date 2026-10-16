import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_comprehension_store.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/domain/book_comprehension.dart';
import 'package:hivelzon/features/library/domain/book_progress.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fake_content_source.dart';
import '../../support/library_harness.dart';

/// Kitap sonu anlama (H-091): son sayfadan sonra 2 soru + isteğe bağlı
/// yeniden anlatma; atla / bitir; sonuç kitap ilerlemesinden ayrı ve
/// yalnızca sayılarla kaydedilir (yazılan metin yok).
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

  String feedback(WidgetTester tester, int q) =>
      tester.widget<Text>(find.byKey(ValueKey('comp-q$q-feedback'))).data!;

  group('içerik', () {
    test('paketteki comprehension okunur', () {
      final c = loadTestBook().comprehension!;
      expect(c.questions, hasLength(2));
      expect(c.questions.first.prompt, 'What color is the box?');
      expect(c.questions.first.promptTr, 'Kutu ne renk?');
      expect(c.questions.first.answer, 1);
      expect(c.questions.first.pageId, 'p01');
      expect(c.modelEn, startsWith('Ece has a small red box.'));
      expect(c.modelTr, isNotEmpty);
    });

    test('bozuk ya da eksik içerik yok sayılır (okuyucu doğrudan sona '
        'geçer)', () {
      expect(BookComprehension.fromJson(null), isNull);
      expect(BookComprehension.fromJson({'questions': []}), isNull);
      final bad = BookComprehension.fromJson({
        'questions': [
          {
            'id': 'q1',
            'prompt': 'Why?',
            'options': ['A', 'B', 'C'],
            'answer': 5,
          },
          {
            'id': 'q2',
            'prompt': 'Who?',
            'options': ['A', 'B', 'C'],
            'answer': 2,
          },
        ],
        'retell': {'modelEn': 'Ece opens it.'},
      })!;
      // Cevap sırası geçersiz soru düşer; geçerli olan kalır.
      expect(bad.questions.single.id, 'q2');
      expect(bad.modelTr, isNull);
    });
  });

  testWidgets('son sayfadan sonra anlama: yanlışta sakin ipucu, doğrusu; '
      'örnek anlatım ve öz değerlendirme; Bitir sonucu kaydeder, yazılan '
      'metin kaydedilmez; sonra kitap sonu', (tester) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    await toEnd(tester, h);
    expect(find.byKey(const ValueKey('comprehension')), findsOneWidget);
    expect(find.byKey(const ValueKey('end-of-book')), findsNothing);
    expect(find.text('Kısa bir hatırlama'), findsOneWidget);
    expect(find.text('Soru 1 / 2'), findsOneWidget);
    expect(find.text('What color is the box?'), findsOneWidget);
    expect(find.text('Kutu ne renk?'), findsOneWidget);
    // Kitap bitti sayılır (anlama ayrı bir veridir).
    final p = await tester.runAsync(
      () => BookProgressStore(h.db).get('A1-K99'),
    );
    expect(p!.status, BookStatus.completed);

    // Soru 1: önce yanlış → ipucu (sayfa numarası), sonra doğru.
    await tapKey(tester, h, 'comp-q1-o0');
    expect(feedback(tester, 1), 'Bu değil. İpucu: cevap 1. sayfada.');
    // Denenen seçenek bir daha seçilemez.
    await tapKey(tester, h, 'comp-q1-o0');
    expect(feedback(tester, 1), 'Bu değil. İpucu: cevap 1. sayfada.');
    await tapKey(tester, h, 'comp-q1-o1');
    expect(feedback(tester, 1), 'Evet, doğru.');
    // Çözülen soru kilitlenir.
    await tapKey(tester, h, 'comp-q1-o2');
    expect(feedback(tester, 1), 'Evet, doğru.');

    // Soru 2: iki yanlış → doğrusu gösterilir (suçlama yok).
    await tapKey(tester, h, 'comp-q2-o0');
    await tapKey(tester, h, 'comp-q2-o2');
    expect(feedback(tester, 2), 'Doğrusu bu. Cevap 3. sayfada geçiyor.');

    // Yeniden anlatma: yazılır ama kaydedilmez.
    await tester.ensureVisible(find.byKey(const ValueKey('comp-retell-field')));
    await tester.enterText(
      find.byKey(const ValueKey('comp-retell-field')),
      'Ece finds a key secretword',
    );
    await h.settle(tester);
    expect(find.byKey(const ValueKey('comp-model-en')), findsNothing);
    await tapKey(tester, h, 'comp-show-model');
    expect(find.byKey(const ValueKey('comp-model-en')), findsOneWidget);
    expect(find.byKey(const ValueKey('comp-model-tr')), findsNothing);
    await tapKey(tester, h, 'comp-model-tr-toggle');
    expect(find.byKey(const ValueKey('comp-model-tr')), findsOneWidget);
    await tapKey(tester, h, 'comp-self-some');
    expect(
      find.text('Eksik kalanlar örnekte. Anlattıkça daha kolay gelir.'),
      findsOneWidget,
    );
    // Puan, lig, geri sayım yok (K-32).
    for (final bad in ['lig', 'saniye', 'yanlış', 'skor', '%']) {
      expect(find.textContaining(bad), findsNothing);
    }

    await tapKey(tester, h, 'comp-finish');
    expect(find.byKey(const ValueKey('end-of-book')), findsOneWidget);
    final r = await tester.runAsync(
      () => BookComprehensionStore(h.db).get('A1-K99'),
    );
    expect(r!.answered, 2);
    expect(r.firstTryCorrect, 0);
    expect(r.retellDone, isTrue);
    expect(r.selfCheck, RetellSelfCheck.some);
    expect(r.contentVersion, 1);
    // Yazılan metin hiçbir tabloda yok.
    final rows = await tester.runAsync(
      () => h.db.customSelect('SELECT * FROM user_book_comprehension').get(),
    );
    expect(jsonEncode(rows!.single.data), isNot(contains('secretword')));

    // Baştan okuyup yeniden bitirince anlama yeniden gelir.
    await tapKey(tester, h, 'end-read-again');
    await toEnd(tester, h);
    expect(find.byKey(const ValueKey('comprehension')), findsOneWidget);
    await tapKey(tester, h, 'comp-skip');
    expect(find.byKey(const ValueKey('end-of-book')), findsOneWidget);
    // Atlamak önceki sonucu silmez, değiştirmez.
    final again = await tester.runAsync(
      () => BookComprehensionStore(h.db).get('A1-K99'),
    );
    expect(again!.selfCheck, RetellSelfCheck.some);
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
  });

  testWidgets('Atla: hiçbir şey kaydedilmez, kitap sonu açılır', (
    tester,
  ) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    await toEnd(tester, h);
    final skip = find.bySemanticsLabel('Hatırlamayı atla, kitabın sonuna geç');
    expect(skip, findsOneWidget);
    await tapKey(tester, h, 'comp-skip');
    expect(find.byKey(const ValueKey('end-of-book')), findsOneWidget);
    expect(find.byKey(const ValueKey('comprehension')), findsNothing);
    final r = await tester.runAsync(
      () => BookComprehensionStore(h.db).get('A1-K99'),
    );
    expect(r, isNull);
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
  });

  testWidgets('tek soru cevaplanıp Bitir: yalnız yapılan kadarı yazılır', (
    tester,
  ) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/kitap/A1-K99?mod=oku');
    await toEnd(tester, h);
    await tapKey(tester, h, 'comp-q1-o1'); // ilk denemede doğru
    await tapKey(tester, h, 'comp-finish');
    final r = await tester.runAsync(
      () => BookComprehensionStore(h.db).get('A1-K99'),
    );
    expect(r!.answered, 1);
    expect(r.firstTryCorrect, 1);
    expect(r.retellDone, isFalse);
    expect(r.selfCheck, isNull);
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
  });

  testWidgets('büyük yazı ve dar ekranda taşma yok; dokunma alanları '
      'yeterli', (tester) async {
    final h = LibraryHarness();
    addTearDown(h.dispose);
    final handle = tester.ensureSemantics();
    await h.pump(
      tester,
      '/kitap/A1-K99?mod=oku',
      size: const Size(320, 640),
      textScale: 2,
    );
    await toEnd(tester, h);
    expect(find.byKey(const ValueKey('comprehension')), findsOneWidget);
    await tapKey(tester, h, 'comp-show-model');
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
    await tester.tap(find.byKey(const ValueKey('reader-close')));
    await h.settle(tester);
  });

  test('anlama sonucu hesap açıkken eşitleme kuyruğuna girer; satırda metin '
      'yok', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = BookComprehensionStore(
      db,
      clock: () => DateTime.utc(2026, 10, 16, 9),
    );
    await store.save(
      bookId: 'A1-K01',
      contentVersion: 1,
      answered: 2,
      firstTryCorrect: 2,
      retellDone: true,
      selfCheck: RetellSelfCheck.all,
    );
    expect(await db.select(db.syncOutbox).get(), isEmpty); // hesap yok
    final sync = SyncStore(db);
    await sync.signIn(userId: 'u-1', emailMasked: 'x', status: 'ACTIVE');
    final queued = await db.select(db.syncOutbox).get();
    expect(
      queued.map((e) => '${e.tbl}:${e.k1}'),
      contains('user_book_comprehension:A1-K01'),
    );
    final row = await sync.loadRow(
      queued.firstWhere((e) => e.tbl == 'user_book_comprehension'),
    );
    expect(row!['bookId'], 'A1-K01');
    expect(row['answered'], 2);
    expect(row['firstTryCorrect'], 2);
    expect(row['retellDone'], isTrue);
    expect(row['selfCheck'], 'all');
    expect(row['updatedAt'], '2026-10-16T09:00:00.000Z');
    expect(row.keys.toSet(), {
      'bookId',
      'contentVersion',
      'answered',
      'firstTryCorrect',
      'retellDone',
      'selfCheck',
      'completedAt',
      'updatedAt',
      'deleted',
      'clientId',
    });

    // Öteki cihazdan gelen daha yeni sonuç yazılır.
    await sync.applyRemote({
      'user_book_comprehension': [
        {
          'bookId': 'A1-K01',
          'contentVersion': 1,
          'answered': 2,
          'firstTryCorrect': 1,
          'retellDone': false,
          'selfCheck': null,
          'completedAt': '2026-10-16T10:00:00.000Z',
          'updatedAt': '2026-10-16T10:00:00.000Z',
          'deleted': false,
        },
      ],
    });
    final r = await store.get('A1-K01');
    expect(r!.firstTryCorrect, 1);
    expect(r.selfCheck, isNull);
    // "Bu telefondaki verileri de sil": anlama da silinir.
    await sync.signOut();
    await sync.wipeLocalLearningData();
    expect(await store.get('A1-K01'), isNull);
  });
}
