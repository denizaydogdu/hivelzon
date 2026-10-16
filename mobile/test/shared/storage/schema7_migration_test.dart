import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/grammar/data/grammar_progress_store.dart';
import 'package:hivelzon/features/grammar/domain/grammar_progress.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fixtures.dart';

const _lesson = 'G-A1-03-third-person-s';

/// Şema 6 → 7 (H-078): dilbilgisi dersi ilerlemesi. `schema_v6.json`: şema
/// 6'nın (H-067) tablo ve dizinleri, bu işten önce `AppDatabase.memory()`'den
/// alındı.
void main() {
  test('şema 6 → 7: veriler korunur, yeni tablo eklenir; ders ilerlemesi ve '
      'kural kartı hesap açıkken kuyruğa girer', () async {
    final dir = Directory.systemTemp.createTempSync('h078');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/v6.sqlite');
    final v6 =
        (jsonDecode(fixtureText('schema_v6.json')) as Map)['statements']
            as List;
    var first = true;
    final db = AppDatabase(
      NativeDatabase(
        file,
        setup: (raw) {
          if (!first) return;
          first = false;
          for (final s in v6) {
            raw.execute(s as String);
          }
          raw
            ..execute(
              "INSERT INTO user_book_progress (book_id, status, page_number, "
              "updated_at) VALUES ('A1-K01', 'IN_PROGRESS', 3, "
              "'2026-10-13T10:05:00.000Z')",
            )
            ..execute('PRAGMA user_version = 6');
        },
      ),
    );
    addTearDown(db.close);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 9); // 6 → 7 → 8 → 9 (H-091)
    expect((await BookProgressStore(db).get('A1-K01'))!.pageNumber, 3);

    // Yeni tablo çalışır.
    var t = DateTime.utc(2026, 10, 14, 9);
    final store = GrammarProgressStore(db, clock: () => t);
    expect(await store.markCard(_lesson, 'c01'), isTrue);
    expect(await store.markCard(_lesson, 'c01'), isFalse); // aynı kart yazılmaz
    expect((await store.get(_lesson))!.status, GrammarStatus.inProgress);

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
      contains('user_grammar_progress:$_lesson'),
    );
    await (db.delete(db.syncOutbox)).go();

    t = t.add(const Duration(minutes: 3));
    expect(await store.markCompleted(_lesson, lastCard: 'c07'), isTrue);
    expect(await store.markCompleted(_lesson), isFalse); // idempotent
    await NotebookStore(db).addItems([
      const NotebookItem(
        kind: NotebookKind.rule,
        textEn: 'She goes to school.',
        textTr: 'O okula gider.',
        exampleTr: 'Tek kişiden söz ederken fiile ek gelir.',
        source: NotebookSource.grammar,
        sourceTitle: 'Üçüncü tekil -s',
        contentId: _lesson,
        cueId: 'c07',
      ),
    ]);
    final after = await db.select(db.syncOutbox).get();
    expect(
      after.map((e) => '${e.tbl}:${e.k1}'),
      containsAll([
        'user_grammar_progress:$_lesson',
        'notebook_items:rule|she goes to school',
      ]),
    );
    final row = await sync.loadRow(
      after.firstWhere((e) => e.tbl == 'user_grammar_progress'),
    );
    expect(row!['status'], 'COMPLETED');
    expect(row['lastCard'], 'c07');
    final item = await sync.loadRow(
      after.firstWhere((e) => e.tbl == 'notebook_items'),
    );
    expect(item!['kind'], 'rule');
    expect(item['source'], 'grammar');

    // Biten ders yeniden açılınca biten kalır; yalnız kalınan kart değişir.
    t = t.add(const Duration(minutes: 1));
    await store.markCard(_lesson, 'c02');
    final again = (await store.get(_lesson))!;
    expect(again.status, GrammarStatus.completed);
    expect(again.lastCard, 'c02');
  });

  test('eşitleme: gelen "görüldü" yereldeki "bitti"yi düşürmez', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = GrammarProgressStore(
      db,
      clock: () => DateTime.utc(2026, 10, 14, 9),
    );
    await store.markCompleted(_lesson, lastCard: 'c07');
    final sync = SyncStore(db);
    await sync.signIn(userId: 'u-1', emailMasked: 'x', status: 'ACTIVE');
    await sync.applyRemote({
      'user_grammar_progress': [
        {
          'lessonId': _lesson,
          'status': 'IN_PROGRESS',
          'lastCard': 'c02',
          'startedAt': '2026-10-14T08:00:00.000Z',
          'completedAt': null,
          'updatedAt': '2026-10-14T10:00:00.000Z',
        },
        {
          'lessonId': 'G-A1-04-other',
          'status': 'COMPLETED',
          'lastCard': 'c07',
          'startedAt': '2026-10-14T08:00:00.000Z',
          'completedAt': '2026-10-14T08:10:00.000Z',
          'updatedAt': '2026-10-14T08:10:00.000Z',
        },
      ],
    });
    final mine = (await store.get(_lesson))!;
    expect(mine.status, GrammarStatus.completed);
    expect(mine.lastCard, 'c07');
    expect(mine.startedAt, DateTime.utc(2026, 10, 14, 8));
    expect((await store.get('G-A1-04-other'))!.status, GrammarStatus.completed);
    // Yereldeki "bitti" sunucuya da gider.
    final queued = await db.select(db.syncOutbox).get();
    expect(
      queued.map((e) => '${e.tbl}:${e.k1}'),
      contains('user_grammar_progress:$_lesson'),
    );
  });
}
