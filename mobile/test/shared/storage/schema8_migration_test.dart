import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/grammar/data/grammar_progress_store.dart';
import 'package:hivelzon/shared/activity/daily_activity_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fixtures.dart';

const _day = '2026-10-14';

/// Şema 7 → 8 (H-074): günlük ölçülen süre. `schema_v7.json`: şema 7'nin
/// (H-078) tablo ve dizinleri, bu işten önce `AppDatabase.memory()`'den
/// alındı.
void main() {
  test('şema 7 → 8: veriler korunur, yeni tablo eklenir; günlük süre hesap '
      'açıkken kuyruğa girer ve günün toplamı olarak gider', () async {
    final dir = Directory.systemTemp.createTempSync('h074');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/v7.sqlite');
    final v7 =
        (jsonDecode(fixtureText('schema_v7.json')) as Map)['statements']
            as List;
    var first = true;
    final db = AppDatabase(
      NativeDatabase(
        file,
        setup: (raw) {
          if (!first) return;
          first = false;
          for (final s in v7) {
            raw.execute(s as String);
          }
          raw
            ..execute(
              "INSERT INTO user_grammar_progress (lesson_id, status, "
              "last_card, updated_at) VALUES ('G-A1-03-third-person-s', "
              "'IN_PROGRESS', 'c02', '2026-10-14T09:00:00.000Z')",
            )
            ..execute('PRAGMA user_version = 7');
        },
      ),
    );
    addTearDown(db.close);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 10); // 7 → 8 → 9 (H-091) → 10 (H-089)
    expect(
      (await GrammarProgressStore(db).get('G-A1-03-third-person-s'))!.lastCard,
      'c02',
    );

    // Hesap yokken kuyruk boş kalır.
    final store = DailyActivityStore(db);
    final t = DateTime.utc(2026, 10, 14, 9);
    await store.addSeconds({_day: 120}, t);
    expect(await db.select(db.syncOutbox).get(), isEmpty);
    final source = await store.sourceId();
    expect(await DailyActivityStore(db).sourceId(), source); // kurulumda sabit

    final sync = SyncStore(db);
    await sync.signIn(userId: 'u-1', emailMasked: 'x', status: 'ACTIVE');
    final queued = await db.select(db.syncOutbox).get();
    expect(
      queued.map((e) => '${e.tbl}:${e.k1}:${e.k2}'),
      contains('daily_activity:$_day:$source'),
    );
    await db.delete(db.syncOutbox).go();

    await store.addSeconds({_day: 30}, t.add(const Duration(minutes: 5)));
    final after = await db.select(db.syncOutbox).get();
    expect(after, hasLength(1));
    final row = await sync.loadRow(after.single);
    expect(row!['day'], _day);
    expect(row['sourceId'], source);
    expect(row['activeSeconds'], 150);
    expect(row['updatedAt'], '2026-10-14T09:05:00.000Z');
    expect(row['deleted'], isFalse);
    expect(row.keys, isNot(contains('deviceId')));
  });

  test('eşitleme: öteki cihazın süresi gelir ve günün toplamına eklenir; '
      'kendi satırımızın eski kopyası üzerine yazılmaz', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = DailyActivityStore(db);
    await store.addSeconds({_day: 200}, DateTime.utc(2026, 10, 14, 9));
    final mine = await store.sourceId();
    final sync = SyncStore(db);
    await sync.signIn(userId: 'u-1', emailMasked: 'x', status: 'ACTIVE');
    await sync.applyRemote({
      'daily_activity': [
        {
          'day': _day,
          'sourceId': 'tablet',
          'activeSeconds': 300,
          'updatedAt': '2026-10-14T10:00:00.000Z',
          'deleted': false,
        },
        // Sunucudaki eski kopyamız: yereldeki daha yeni, yerel kalır.
        {
          'day': _day,
          'sourceId': mine,
          'activeSeconds': 50,
          'updatedAt': '2026-10-14T08:00:00.000Z',
          'deleted': false,
        },
      ],
    });
    expect(await store.secondsOn(_day), 500);
    // "Bu telefondaki verileri de sil": süre de silinir.
    await sync.signOut();
    await sync.wipeLocalLearningData();
    expect(await store.secondsOn(_day), 0);
  });
}
