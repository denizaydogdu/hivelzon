import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/talk/data/talk_progress_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fixtures.dart';

/// Şema 10 → 11 (H-090): bitirilen Konuş görevleri. `schema_v10.json`: şema
/// 10'un (H-089) tablo ve dizinleri, bu işten önce `AppDatabase.memory()`'den
/// alındı.
void main() {
  AppDatabase openV10(File file, {String? account}) {
    final v10 =
        (jsonDecode(fixtureText('schema_v10.json')) as Map)['statements']
            as List;
    var first = true;
    return AppDatabase(
      NativeDatabase(
        file,
        setup: (raw) {
          if (!first) return;
          first = false;
          for (final s in v10) {
            raw.execute(s as String);
          }
          raw.execute(
            "INSERT INTO expression_evidence (item_key, stage, at) VALUES "
            "('phrase|thank you', 'helped', '2026-10-10T09:00:00.000Z')",
          );
          if (account != null) {
            raw.execute(
              "INSERT INTO sync_state (id, account_user_id) VALUES (1, '$account')",
            );
          }
          raw.execute('PRAGMA user_version = 10');
        },
      ),
    );
  }

  test('şema 10 → 11: Konuş tablosu eklenir, veriler yerinde', () async {
    final dir = Directory.systemTemp.createTempSync('h090');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = openV10(File('${dir.path}/v10.sqlite'));
    addTearDown(db.close);
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 11);
    expect(db.schemaVersion, 11);
    expect(await db.select(db.userTalkProgress).get(), isEmpty);
    expect(await db.select(db.evidenceRecords).get(), hasLength(1));
    expect(await db.select(db.syncOutbox).get(), isEmpty);
  });

  test('hesap açıksa bitirilen görev eşitleme kuyruğuna girer; satırda '
      'yalnız kimlik ve zamanlar var; "verileri de sil" siler', () async {
    final dir = Directory.systemTemp.createTempSync('h090');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = openV10(File('${dir.path}/v10.sqlite'), account: 'u-1');
    addTearDown(db.close);
    final store = TalkProgressStore(
      db,
      clock: () => DateTime.utc(2026, 10, 16, 9),
    );
    await store.markDone('cafe-rosa');
    final queued = await db.select(db.syncOutbox).get();
    expect(queued.single.tbl, 'user_talk_progress');
    final row = await SyncStore(db).loadRow(queued.single);
    expect(row, {
      'clientId': row!['clientId'],
      'deleted': false,
      'taskId': 'cafe-rosa',
      'completedAt': '2026-10-16T09:00:00.000Z',
      'lastDoneAt': '2026-10-16T09:00:00.000Z',
      'updatedAt': '2026-10-16T09:00:00.000Z',
    });

    // Öteki cihazdan gelen satır (son yazan kazanır).
    await SyncStore(db).applyRemote({
      'user_talk_progress': [
        {
          'taskId': 'late-maya',
          'completedAt': '2026-10-15T09:00:00.000Z',
          'lastDoneAt': '2026-10-15T09:00:00.000Z',
          'updatedAt': '2026-10-15T09:00:00.000Z',
        },
      ],
    });
    expect((await store.doneAt()).keys.toSet(), {'cafe-rosa', 'late-maya'});
    await SyncStore(db).wipeLocalLearningData();
    expect(await db.select(db.userTalkProgress).get(), isEmpty);
  });
}
