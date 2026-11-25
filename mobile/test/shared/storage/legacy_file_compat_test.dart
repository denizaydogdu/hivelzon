import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

/// Eski cihaz dosyası uyumluluğu (H-111). `legacy_v11.sqlite.gz`: şema 11'in
/// gerçek bir dosyası; **sqlite3_flutter_libs 0.5.42 + drift 2.31.0 +
/// sqlite3 2.9.4** ile, H-111'deki yükseltmeden (drift 2.35, sqlite3 3.x
/// yerel varlıkları) önce üretildi. Yeni sürümler aynı dosyayı göç hatası
/// vermeden, bozulmadan ve aynı satırlarla açmalı.
///
/// Dosyayı yeniden üretmek (yalnız şema değişirse; eski dosya bilerek
/// eskidir, her yükseltmede yeniden üretilmez):
///
/// ```
/// cd mobile && HV_WRITE_LEGACY_DB=1 flutter test \
///   test/shared/storage/legacy_file_compat_test.dart
/// ```
///
/// Dosya gzip ile saklanır (SQLite sayfalarının çoğu boş; ~200 KB → birkaç KB).
const _fixture = 'test/fixtures/legacy_v11.sqlite.gz';

final _t0 = DateTime.utc(2026, 10, 20, 9, 30);
final _t1 = DateTime.utc(2026, 10, 21, 18, 5, 12, 345);

/// Dosyaya yazılan örnek satırlar (üretici ve uyumluluk testi aynısını kullanır).
Future<void> _seed(AppDatabase db) async {
  // Hesap açık: tetikleyiciler eşitleme kuyruğunu da doldurur.
  await db
      .into(db.syncState)
      .insert(
        SyncStateCompanion.insert(
          accountUserId: const Value('u-legacy'),
          emailMasked: const Value('d•••@example.com'),
          accountStatus: const Value('ACTIVE'),
          deviceId: const Value('dev-legacy'),
          lastPullCursor: const Value(42),
          initialUploadDone: const Value(true),
        ),
      );
  await db
      .into(db.appMeta)
      .insert(
        AppMetaCompanion.insert(key: 'activity.sourceId', value: 'src-legacy'),
      );
  await db
      .into(db.userStoryProgress)
      .insert(
        UserStoryProgressCompanion.insert(
          contentId: 'A1-001',
          status: const Value('COMPLETED'),
          checkpointSnapshot: const Value('{"flags":{"trust":"maya"}}'),
          startedAt: Value(_t0),
          completedAt: Value(_t1),
          updatedAt: _t1,
        ),
      );
  await db
      .into(db.userStoryProgress)
      .insert(
        UserStoryProgressCompanion.insert(
          contentId: 'A1-002',
          status: const Value('IN_PROGRESS'),
          lastCheckpointNodeId: const Value('s03'),
          startedAt: Value(_t1),
          updatedAt: _t1,
        ),
      );
  final itemId = await db
      .into(db.notebookItems)
      .insert(
        NotebookItemsCompanion.insert(
          itemKey: 'phrase|thank you',
          kind: 'phrase',
          textEn: 'Thank you',
          textTr: const Value('Teşekkür ederim'),
          contentId: const Value('A1-001'),
          cueId: const Value('s02-04'),
          audioPath: const Value('segments/s02.mp4'),
          audioStart: const Value(1.25),
          audioEnd: const Value(2.5),
          source: 'auto_target_phrase',
          createdAt: _t0,
          updatedAt: Value(_t0),
        ),
      );
  final cardId = await db
      .into(db.reviewCards)
      .insert(
        ReviewCardsCompanion.insert(
          itemId: itemId,
          state: const Value(2),
          stability: const Value(3.173),
          difficulty: const Value(5.2818),
          due: _t1,
          reps: const Value(2),
          lastReview: Value(_t0),
          updatedAt: Value(_t0),
        ),
      );
  await db
      .into(db.reviewLogs)
      .insert(
        ReviewLogsCompanion.insert(
          cardId: cardId,
          rating: 3,
          reviewedAt: _t0,
          taskType: 'picture_choice',
          correct: true,
          durationMs: 4200,
          wasNew: const Value(true),
          clientId: const Value('5b0f4c2e-0000-5000-8000-000000000001'),
        ),
      );
  await db
      .into(db.userBookProgress)
      .insert(
        UserBookProgressCompanion.insert(
          bookId: 'A1-K02',
          status: const Value('IN_PROGRESS'),
          chapterId: const Value('c2'),
          pageNumber: const Value(7),
          sentenceIndex: const Value(-1),
          positionSec: const Value(83.4),
          startedAt: Value(_t0),
          updatedAt: _t1,
        ),
      );
}

void main() {
  test(
    'üretici: legacy_v11.sqlite.gz yazılır',
    () async {
      final dir = Directory.systemTemp.createTempSync('h111gen');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File('${dir.path}/hivelzon.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      await _seed(db);
      await db.close();
      File(_fixture).writeAsBytesSync(gzip.encode(file.readAsBytesSync()));
    },
    skip: Platform.environment['HV_WRITE_LEGACY_DB'] == '1'
        ? false
        : 'yalnız HV_WRITE_LEGACY_DB=1 ile',
  );

  group('eski şema 11 dosyası (H-111)', () {
    late Directory dir;
    late AppDatabase db;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('h111');
      final file = File('${dir.path}/hivelzon.sqlite')
        ..writeAsBytesSync(gzip.decode(File(_fixture).readAsBytesSync()));
      db = AppDatabase(NativeDatabase(file));
    });
    tearDown(() async {
      await db.close();
      dir.deleteSync(recursive: true);
    });

    test('göç hatası yok; sürüm 11; bütünlük denetimi temiz', () async {
      final version = await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.data.values.single, 11);
      final check = await db.customSelect('PRAGMA integrity_check').get();
      expect(check.map((r) => r.data.values.single), ['ok']);
      final fk = await db.customSelect('PRAGMA foreign_key_check').get();
      expect(fk, isEmpty);
    });

    test('satırlar drift ile aynen okunur', () async {
      final meta = await db.select(db.appMeta).getSingle();
      expect(meta.key, 'activity.sourceId');
      expect(meta.value, 'src-legacy');

      final story = await (db.select(
        db.userStoryProgress,
      )..orderBy([(t) => OrderingTerm.asc(t.contentId)])).get();
      expect(story.map((r) => r.contentId), ['A1-001', 'A1-002']);
      expect(story[0].status, 'COMPLETED');
      expect(story[0].checkpointSnapshot, '{"flags":{"trust":"maya"}}');
      expect(story[0].startedAt, _t0);
      expect(story[0].completedAt, _t1);
      expect(story[0].completedAt!.isUtc, isTrue);
      expect(story[1].status, 'IN_PROGRESS');
      expect(story[1].lastCheckpointNodeId, 's03');
      expect(story[1].completedAt, isNull);

      final item = await db.select(db.notebookItems).getSingle();
      expect(item.itemKey, 'phrase|thank you');
      expect(item.textTr, 'Teşekkür ederim');
      expect(item.audioStart, 1.25);
      expect(item.audioEnd, 2.5);
      expect(item.createdAt, _t0);

      final card = await db.select(db.reviewCards).getSingle();
      expect(card.itemId, item.id);
      expect(card.state, 2);
      expect(card.stability, 3.173);
      expect(card.difficulty, 5.2818);
      expect(card.due, _t1);
      expect(card.reps, 2);
      expect(card.lastReview, _t0);

      final log = await db.select(db.reviewLogs).getSingle();
      expect(log.cardId, card.id);
      expect(log.rating, 3);
      expect(log.correct, isTrue);
      expect(log.dontKnow, isFalse);
      expect(log.wasNew, isTrue);
      expect(log.clientId, '5b0f4c2e-0000-5000-8000-000000000001');

      final book = await db.select(db.userBookProgress).getSingle();
      expect(book.bookId, 'A1-K02');
      expect(book.chapterId, 'c2');
      expect(book.pageNumber, 7);
      expect(book.sentenceIndex, -1);
      expect(book.positionSec, 83.4);
      expect(book.updatedAt, _t1);

      final sync = await db.select(db.syncState).getSingle();
      expect(sync.accountUserId, 'u-legacy');
      expect(sync.emailMasked, 'd•••@example.com');
      expect(sync.lastPullCursor, 42);
      expect(sync.initialUploadDone, isTrue);
    });

    test('eşitleme kuyruğu ve tetikleyiciler eski dosyada çalışır', () async {
      final before = await db.select(db.syncOutbox).get();
      expect(
        before.map((r) => r.tbl).toSet(),
        containsAll(<String>[
          'user_story_progress',
          'notebook_items',
          'review_cards',
          'review_logs',
          'user_book_progress',
        ]),
      );
      // Yazma: tetikleyici yeni satırı kuyruğa ekler.
      await db
          .into(db.userBookProgress)
          .insert(
            UserBookProgressCompanion.insert(bookId: 'A2-K01', updatedAt: _t1),
          );
      final after = await db.select(db.syncOutbox).get();
      expect(
        after.where((r) => r.tbl == 'user_book_progress' && r.k1 == 'A2-K01'),
        hasLength(1),
      );
    });
  });
}
