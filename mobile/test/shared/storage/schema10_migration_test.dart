import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/evidence_ladder.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fixtures.dart';

/// Şema 8/9 → 10 (H-089): öğrenme kanıtı basamakları. `schema_v8.json`: şema
/// 8'in (H-074) tablo ve dizinleri, bu işten önce `AppDatabase.memory()`'den
/// alındı. (Şema 9, H-091 kitap anlama kontrolü, ayrı dalda; geçiş adımı
/// `from < 10` olduğundan 8'den de 9'dan da çalışır.)
void main() {
  AppDatabase openV8(File file, {String? account, int from = 8}) {
    final v8 =
        (jsonDecode(fixtureText('schema_v$from.json')) as Map)['statements']
            as List;
    var first = true;
    return AppDatabase(
      NativeDatabase(
        file,
        setup: (raw) {
          if (!first) return;
          first = false;
          for (final s in v8) {
            raw.execute(s as String);
          }
          String item(int id, String key, String en) =>
              'INSERT INTO notebook_items (id, item_key, kind, text_en, '
              "source, created_at) VALUES ($id, '$key', 'phrase', '$en', "
              "'auto_target_phrase', '2026-10-01T08:00:00.000Z')";
          String card(int id) =>
              'INSERT INTO review_cards (id, item_id, state, due, reps) '
              "VALUES ($id, $id, 2, '2026-10-20T08:00:00.000Z', 2)";
          String log(int card, int rating, String at, String task, int ok) =>
              'INSERT INTO review_logs (card_id, rating, reviewed_at, '
              'task_type, correct, duration_ms) VALUES '
              "($card, $rating, '$at', '$task', $ok, 3000)";
          raw
            ..execute(item(1, 'phrase|where is…', 'Where is…?'))
            ..execute(item(2, 'phrase|excuse me', 'Excuse me.'))
            ..execute(card(1))
            ..execute(card(2))
            // 1: pratik → yardımla; 4 gün sonra yazma → kendi kullandı ve
            // sonra hatırladı.
            ..execute(
              log(1, 3, '2026-10-01T09:00:00.000Z', 'picture_choice', 1),
            )
            ..execute(log(1, 3, '2026-10-05T09:00:00.000Z', 'type', 1))
            // 2: aynı gün kendini yoklama (sayılmaz) ve yanlış dinle-seç.
            ..execute(log(2, 3, '2026-10-01T10:00:00.000Z', 'self_check', 1))
            ..execute(
              log(2, 1, '2026-10-01T10:05:00.000Z', 'listen_choice', 0),
            );
          if (account != null) {
            raw.execute(
              "INSERT INTO sync_state (id, account_user_id) VALUES (1, '$account')",
            );
          }
          raw.execute('PRAGMA user_version = $from');
        },
      ),
    );
  }

  test('şema 9 (H-091) → 10: kanıt tablosu eklenir, anlama tablosu '
      'yerinde', () async {
    final dir = Directory.systemTemp.createTempSync('h089');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = openV8(File('${dir.path}/v9.sqlite'), from: 9);
    addTearDown(db.close);
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 11);
    expect(await db.select(db.userBookComprehension).get(), isEmpty);
    expect((await NotebookStore(db).evidence()).keys, ['phrase|where is…']);
  });

  test('şema 8 → 10: veriler korunur; kanıt basamakları eski cevaplardan '
      'doldurulur; hesap yoksa kuyruk boş', () async {
    final dir = Directory.systemTemp.createTempSync('h089');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = openV8(File('${dir.path}/v8.sqlite'));
    addTearDown(db.close);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 11);
    expect(db.schemaVersion, 11);
    final store = NotebookStore(db);
    expect(await store.entries(), hasLength(2));
    expect(await store.logs(), hasLength(4));
    expect(await store.evidence(), {
      'phrase|where is…': {
        EvidenceStage.helped: DateTime.utc(2026, 10, 1, 9),
        EvidenceStage.ownUse: DateTime.utc(2026, 10, 5, 9),
        EvidenceStage.recalledLater: DateTime.utc(2026, 10, 5, 9),
      },
    });
    expect(await db.select(db.syncOutbox).get(), isEmpty);
  });

  test('hesap açıksa doldurulan basamaklar eşitleme kuyruğuna girer; '
      'satır içerik metni taşımaz', () async {
    final dir = Directory.systemTemp.createTempSync('h089');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = openV8(File('${dir.path}/v8.sqlite'), account: 'u-1');
    addTearDown(db.close);

    final queued = await db.select(db.syncOutbox).get();
    expect(queued.map((e) => '${e.tbl}:${e.k1}:${e.k2}').toSet(), {
      'expression_evidence:phrase|where is…:helped',
      'expression_evidence:phrase|where is…:own_use',
      'expression_evidence:phrase|where is…:recalled_later',
    });
    final row = await SyncStore(
      db,
    ).loadRow(queued.firstWhere((e) => e.k2 == 'own_use'));
    expect(row, {
      'clientId': row!['clientId'],
      'itemKey': 'phrase|where is…',
      'stage': 'own_use',
      'at': '2026-10-05T09:00:00.000Z',
    });
  });

  test('eşitleme: öteki cihazın basamağı gelir, yereldeki ilk an korunur; '
      '"verileri de sil" kanıtları siler', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final sync = SyncStore(db);
    await sync.signIn(userId: 'u-1', emailMasked: 'x', status: 'ACTIVE');
    await db
        .into(db.evidenceRecords)
        .insert(
          EvidenceRecordsCompanion.insert(
            itemKey: 'phrase|excuse me',
            stage: 'helped',
            at: DateTime.utc(2026, 10, 2),
          ),
        );
    final queued = await db.select(db.syncOutbox).get();
    expect(queued.single.tbl, 'expression_evidence');
    await sync.applyRemote({
      'expression_evidence': [
        {
          'itemKey': 'phrase|excuse me',
          'stage': 'helped',
          'at': '2026-10-05T09:00:00.000Z',
        },
        {
          'itemKey': 'phrase|excuse me',
          'stage': 'recalled_later',
          'at': '2026-10-06T09:00:00.000Z',
        },
      ],
    });
    expect(await NotebookStore(db).evidence(), {
      'phrase|excuse me': {
        EvidenceStage.helped: DateTime.utc(2026, 10, 2),
        EvidenceStage.recalledLater: DateTime.utc(2026, 10, 6, 9),
      },
    });
    await sync.signOut();
    await sync.wipeLocalLearningData();
    expect(await NotebookStore(db).evidence(), isEmpty);
  });
}
