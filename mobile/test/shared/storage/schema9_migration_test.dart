import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_comprehension_store.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/domain/book_comprehension.dart';
import 'package:hivelzon/shared/activity/daily_activity_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fixtures.dart';

/// Şema 8 → 9 (H-091): kitap sonu anlama sonucu. `schema_v8.json`: şema 8'in
/// (H-074) tablo ve dizinleri, bu işten önce `AppDatabase.memory()`'den
/// alındı.
void main() {
  test('şema 8 → 9: veriler korunur, anlama tablosu eklenir ve hesap '
      'açıkken eşitlenir', () async {
    final dir = Directory.systemTemp.createTempSync('h091');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/v8.sqlite');
    final v8 =
        (jsonDecode(fixtureText('schema_v8.json')) as Map)['statements']
            as List;
    expect(v8.where((s) => '$s'.contains('user_book_comprehension')), isEmpty);
    var first = true;
    final db = AppDatabase(
      NativeDatabase(
        file,
        setup: (raw) {
          if (!first) return;
          first = false;
          for (final s in v8) {
            raw.execute(s as String);
          }
          raw
            ..execute(
              "INSERT INTO user_book_progress (book_id, status, chapter_id, "
              "page_number, sentence_index, updated_at) VALUES ('A1-K01', "
              "'COMPLETED', 'c3', 11, 2, '2026-10-15T09:00:00.000Z')",
            )
            ..execute(
              "INSERT INTO daily_activity (day, source_id, active_seconds, "
              "updated_at) VALUES ('2026-10-15', 's-1', 300, "
              "'2026-10-15T09:00:00.000Z')",
            )
            ..execute('PRAGMA user_version = 8');
        },
      ),
    );
    addTearDown(db.close);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 11); // 8 → 9 → 10 (H-089) → 11 (H-090)
    expect((await BookProgressStore(db).get('A1-K01'))!.pageNumber, 11);
    expect(await DailyActivityStore(db).secondsOn('2026-10-15'), 300);

    final store = BookComprehensionStore(
      db,
      clock: () => DateTime.utc(2026, 10, 16, 8),
    );
    expect(await store.get('A1-K01'), isNull);
    await store.save(
      bookId: 'A1-K01',
      contentVersion: 1,
      answered: 2,
      firstTryCorrect: 1,
      retellDone: false,
    );
    expect(await db.select(db.syncOutbox).get(), isEmpty);

    final sync = SyncStore(db);
    await sync.signIn(userId: 'u-1', emailMasked: 'x', status: 'ACTIVE');
    final queued = await db.select(db.syncOutbox).get();
    expect(
      queued.map((e) => '${e.tbl}:${e.k1}'),
      containsAll([
        'user_book_comprehension:A1-K01',
        'user_book_progress:A1-K01',
      ]),
    );
    await db.delete(db.syncOutbox).go();
    await store.save(
      bookId: 'A1-K01',
      contentVersion: 1,
      answered: 2,
      firstTryCorrect: 2,
      retellDone: true,
      selfCheck: RetellSelfCheck.notYet,
    );
    final after = await db.select(db.syncOutbox).get();
    expect(after.single.tbl, 'user_book_comprehension');
    final row = await sync.loadRow(after.single);
    expect(row!['selfCheck'], 'not_yet');
    expect(row['firstTryCorrect'], 2);
  });
}
