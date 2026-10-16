import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/domain/book_progress.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fixtures.dart';

/// Şema 5 → 6 (H-067): Kitaplık ilerlemesi tablosu ve defterde kaynağın adı.
/// `schema_v5.json`: şema 5'in (H-038) tablo ve dizinleri, bu işten önce
/// `AppDatabase.memory()`'den alındı.
void main() {
  test('şema 5 → 6: veriler korunur, yeni tablo ve kolon eklenir; '
      'kitap ilerlemesi hesap açıkken kuyruğa girer', () async {
    final dir = Directory.systemTemp.createTempSync('h067');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/v5.sqlite');
    final v5 =
        (jsonDecode(fixtureText('schema_v5.json')) as Map)['statements']
            as List;
    var first = true;
    final db = AppDatabase(
      NativeDatabase(
        file,
        setup: (raw) {
          if (!first) return;
          first = false;
          for (final s in v5) {
            raw.execute(s as String);
          }
          raw
            ..execute(
              "INSERT INTO user_story_progress (content_id, status, "
              "updated_at) VALUES ('A1-001', 'IN_PROGRESS', "
              "'2026-10-13T10:05:00.000Z')",
            )
            ..execute(
              "INSERT INTO notebook_items (id, item_key, kind, text_en, source, "
              "created_at, updated_at) VALUES (1, 'phrase|can you hear me?', "
              "'phrase', 'Can you hear me?', 'user_saved', "
              "'2026-10-11T10:00:00.000Z', '2026-10-11T10:00:00.000Z')",
            )
            ..execute(
              "INSERT INTO review_cards (id, item_id, state, due, reps) "
              "VALUES (1, 1, 1, '2026-10-12T10:00:00.000Z', 0)",
            )
            ..execute('PRAGMA user_version = 5');
        },
      ),
    );
    addTearDown(db.close);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 9); // 5 → 6 → 7 → 8 → 9 (H-091)

    // Eski veri yerinde; yeni kolon boş.
    final entries = await NotebookStore(db).entries();
    expect(entries.single.item.textEn, 'Can you hear me?');
    expect(entries.single.item.sourceTitle, isNull);
    expect(
      (await db.select(db.userStoryProgress).getSingle()).status,
      'IN_PROGRESS',
    );

    // Yeni tablo çalışır.
    final books = BookProgressStore(db);
    await books.savePosition(
      'A1-K01',
      chapterId: 'c1',
      pageNumber: 4,
      sentenceIndex: 2,
      positionSec: 21.5,
    );
    expect((await books.get('A1-K01'))!.status, BookStatus.inProgress);

    // Hesap yokken kuyruk boş; girişte kitap ilerlemesi ve kitap kaydı da
    // ilk yüklemeye girer, sonraki değişiklik tetikleyiciyle kuyruğa yazılır.
    expect(await db.select(db.syncOutbox).get(), isEmpty);
    final sync = SyncStore(db);
    await sync.signIn(
      userId: 'u-1',
      emailMasked: 'd•••@example.com',
      status: 'ACTIVE',
    );
    final queued = await db.select(db.syncOutbox).get();
    expect(
      queued.map((e) => '${e.tbl}:${e.k1}'),
      containsAll([
        'user_book_progress:A1-K01',
        'notebook_items:phrase|can you hear me?',
      ]),
    );
    await (db.delete(db.syncOutbox)).go();
    await NotebookStore(db).addItems([
      const NotebookItem(
        kind: NotebookKind.word,
        textEn: 'box',
        source: NotebookSource.book,
        sourceTitle: 'The Blue Door',
        contentId: 'A1-K01',
        cueId: 'p01-s01',
      ),
    ]);
    await books.markCompleted('A1-K01');
    final after = await db.select(db.syncOutbox).get();
    expect(
      after.map((e) => '${e.tbl}:${e.k1}'),
      containsAll(['user_book_progress:A1-K01', 'notebook_items:word|box']),
    );
    final row = await sync.loadRow(
      after.firstWhere((e) => e.tbl == 'notebook_items'),
    );
    expect(row!['source'], 'book');
    expect(row['sourceTitle'], 'The Blue Door');
    final book = await sync.loadRow(
      after.firstWhere((e) => e.tbl == 'user_book_progress'),
    );
    expect(book!['status'], 'COMPLETED');
    expect(book['pageNumber'], 4);
    expect(book['positionSec'], 21.5);
  });
}
