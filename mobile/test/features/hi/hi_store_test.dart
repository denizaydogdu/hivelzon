import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/hi/data/hi_store.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/evidence_ladder.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/features/notebook/domain/review_session.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

import '../../support/fixtures.dart';

final _now = DateTime.utc(2026, 10, 13, 9);

NotebookItem _item(String en) => NotebookItem(
  kind: NotebookKind.phrase,
  textEn: en,
  textTr: 'x',
  contentId: 'A1-001',
  source: NotebookSource.userSaved,
  createdAt: _now,
);

void main() {
  late AppDatabase db;
  late HiStore store;

  setUp(() {
    db = AppDatabase.memory();
    store = HiStore(db, clock: () => _now);
  });
  tearDown(() => db.close());

  test('konu tanıtımı konu başına bir kez; ilk an korunur', () async {
    expect(await store.seenTopicIntros(), isEmpty);
    await store.markTopicIntroSeen('time');
    final first = await db.select(db.hiRecords).getSingle();
    await store.markTopicIntroSeen('time');
    final rows = await db.select(db.hiRecords).get();
    expect(rows, hasLength(1));
    expect(rows.single.updatedAt, first.updatedAt);
    expect(await store.seenTopicIntros(), {'time'});
  });

  test('yan görev durumu, sahne avı, not ve panel günü', () async {
    await store.setBridgeState('bt-a1-001', BridgeState.done);
    await store.setBridgeState('bt-a1-002', BridgeState.dismissed);
    expect(await store.bridgeStates(), {
      'bt-a1-001': BridgeState.done,
      'bt-a1-002': BridgeState.dismissed,
    });
    await store.markHuntDone('harbour');
    expect(await store.huntedSets(), {'harbour'});
    await store.markNoteRead(ErrorType.preposition);
    expect((await store.notesReadAt())['preposition'], _now);
    expect(await store.panelOpenedDay(), isNull);
    await store.markPanelOpened();
    expect(await store.panelOpenedDay(), localDay(_now));
  });

  test('hata olayları penceresi ve bilgi sayıları', () async {
    final log = DriftLearningEventLog(db);
    await log.record(
      LearningEvent(
        contentId: 'A1-001',
        sourceId: 's02-04',
        target: 'hear',
        at: _now,
      ),
    );
    await log.record(
      LearningEvent(
        contentId: 'A1-004',
        sourceId: 'k2#b',
        target: "It's in seven o'clock.",
        at: _now.subtract(const Duration(days: 1)),
        errorType: ErrorType.preposition,
      ),
    );
    await log.record(
      LearningEvent(
        contentId: 'A1-003',
        sourceId: 'k1#b',
        target: 'Harbour where?',
        at: _now.subtract(const Duration(days: 9)),
        errorType: ErrorType.wordOrder,
      ),
    );
    final recent = await store.errorsSince(
      _now.subtract(const Duration(days: 7)),
    );
    expect(recent.single.type, ErrorType.preposition);
    expect(recent.single.sourceId, 'k2#b');
    final k = await store.knowledge();
    expect(k.lookups, 1);
    expect(k.errors, 2);
    expect(k.errorCounts, {ErrorType.preposition: 1, ErrorType.wordOrder: 1});
  });

  test('silme kapsamı: öğrenme olayları + kanıt + yan görev + not; ilerleme, '
      'defter, konu tanıtımı ve sahne avı kalır', () async {
    final notebook = NotebookStore(db, clock: () => _now);
    await notebook.addItems([_item('Again, please.')]);
    // H-093: öğrenme kanıtı Hi'nin kayıtlarıyla silinir; kart kalır.
    await notebook.recordSpokenPractice('Again, please.');
    await db
        .into(db.userStoryProgress)
        .insert(
          UserStoryProgressCompanion.insert(
            contentId: 'A1-001',
            status: const Value('COMPLETED'),
            completedAt: Value(_now),
            updatedAt: _now,
          ),
        );
    await db
        .into(db.appMeta)
        .insert(
          AppMetaCompanion.insert(key: 'profile.displayName', value: 'Deniz'),
        );
    await DriftLearningEventLog(db).record(
      LearningEvent(
        contentId: 'A1-001',
        sourceId: 'k1#b',
        target: 'Yes, I am.',
        at: _now,
        errorType: ErrorType.verbForm,
      ),
    );
    await store.setBridgeState('bt-a1-001', BridgeState.done);
    await store.markNoteRead(ErrorType.verbForm);
    await store.markTopicIntroSeen('can-questions');
    await store.markHuntDone('alex-room');
    await store.markPanelOpened();

    expect(await store.deleteLearningData(), 4);

    expect(await db.select(db.learningEvents).get(), isEmpty);
    expect(await notebook.evidence(), isEmpty);
    expect((await store.knowledge()).evidence, isEmpty);
    expect(await store.bridgeStates(), isEmpty);
    expect(await store.notesReadAt(), isEmpty);
    expect(await store.panelOpenedDay(), isNull);
    // Kalanlar.
    expect(await store.seenTopicIntros(), {'can-questions'});
    expect(await store.huntedSets(), {'alex-room'});
    expect(await notebook.entries(), hasLength(1));
    expect(
      (await db.select(db.userStoryProgress).getSingle()).status,
      'COMPLETED',
    );
    expect(await db.select(db.appMeta).get(), hasLength(1));
  });

  test('haftalık okumalar: ifade, tekrar, biten bölüm', () async {
    final notebook = NotebookStore(db, clock: () => _now);
    await notebook.addItems([_item('Thank you.'), _item('Go straight.')]);
    await db
        .into(db.userStoryProgress)
        .insert(
          UserStoryProgressCompanion.insert(
            contentId: 'A1-002',
            status: const Value('COMPLETED'),
            completedAt: Value(_now.subtract(const Duration(days: 2))),
            updatedAt: _now,
          ),
        );
    final since = _now.subtract(const Duration(days: 7));
    expect(await store.itemsCreatedSince(since), hasLength(2));
    expect(await store.completedSince(since), hasLength(1));
    expect(await store.reviewsSince(since), isEmpty);
  });

  test('H-093: kanıt satırları haftalık okumada ve gizlilik listesinde '
      '(ifade, basamak, tarih; en yeni önce)', () async {
    final notebook = NotebookStore(db, clock: () => _now);
    await notebook.addItems([_item('Excuse me.'), _item('Go straight.')]);
    Future<void> put(String key, String stage, Duration ago) => db
        .into(db.evidenceRecords)
        .insert(
          EvidenceRecordsCompanion.insert(
            itemKey: key,
            stage: stage,
            at: _now.subtract(ago),
          ),
        );
    await put('phrase|excuse me', 'helped', const Duration(days: 9));
    await put('phrase|excuse me', 'recalled_later', const Duration(days: 1));
    // Defterde henüz olmayan hedef ifade (karar anında söylendi).
    await put('phrase|where is…', 'helped', const Duration(hours: 2));
    final week = await store.evidenceSince(
      _now.subtract(const Duration(days: 7)),
    );
    expect(week, hasLength(2));
    expect(week.map((e) => e.$1).toSet(), {
      EvidenceStage.recalledLater,
      EvidenceStage.helped,
    });
    final k = await store.knowledge();
    expect(
      [for (final e in k.evidence) (e.text, e.stage)],
      [
        ('where is…', EvidenceStage.helped),
        ('Excuse me.', EvidenceStage.recalledLater),
        ('Excuse me.', EvidenceStage.helped),
      ],
    );
    expect(k.evidence.first.at, _now.subtract(const Duration(hours: 2)));
  });

  test('H-093: son tekrar anı hatırlama cevabı ya da tekrar pratiğidir '
      '(review_logs yalnız hatırlama tutar)', () async {
    expect(await store.lastReviewAt(), isNull);
    final notebook = NotebookStore(db, clock: () => _now);
    await notebook.addItems([_item('Excuse me.')]);
    final entry = (await notebook.entries()).single;
    final card = entry.card;
    ReviewOutcome practice(TaskType t, DateTime at, {bool correct = true}) =>
        ReviewOutcome(
          before: card,
          after: card,
          item: entry.item,
          rating: null,
          taskType: t,
          correct: correct,
          dontKnow: false,
          elapsed: const Duration(seconds: 3),
          reviewedAt: at,
          requeued: false,
        );
    final practiceAt = _now.subtract(const Duration(hours: 1));
    await notebook.saveOutcome(
      practice(TaskType.pictureChoice, practiceAt, correct: true),
    );
    expect(await db.select(db.reviewLogs).get(), isEmpty);
    expect(await store.lastReviewAt(), practiceAt);
    // Sahne avı tekrar oturumu değildir: anı değiştirmez.
    await notebook.saveOutcome(
      practice(TaskType.sceneHunt, _now, correct: true),
    );
    expect(await store.lastReviewAt(), practiceAt);
    // Daha eski pratik anı geri almaz (yalnız daha yeni yazılır).
    await notebook.saveOutcome(
      practice(
        TaskType.arrange,
        _now.subtract(const Duration(days: 1)),
        correct: false,
      ),
    );
    expect(await store.lastReviewAt(), practiceAt);
    // Hatırlama cevabı daha yeniyse o.
    await db
        .into(db.reviewLogs)
        .insert(
          ReviewLogsCompanion.insert(
            cardId: card.id,
            rating: 3,
            reviewedAt: _now.subtract(const Duration(minutes: 5)),
            taskType: 'type',
            correct: true,
            durationMs: 4000,
          ),
        );
    expect(
      await store.lastReviewAt(),
      _now.subtract(const Duration(minutes: 5)),
    );
  });

  /// Şema 4 dosyası (fixture), [drop] tabloları kaldırılıp [version]'a
  /// indirilmiş; içinde bir defter ifadesi + kartı (ve varsa konu tanıtımı).
  AppDatabase oldDatabase(String tag, int version, List<String> drop) {
    final dir = Directory.systemTemp.createTempSync(tag);
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/v$version.sqlite');
    final v4 =
        (jsonDecode(fixtureText('schema_v4.json')) as Map)['statements']
            as List;
    return AppDatabase(
      NativeDatabase(
        file,
        setup: (raw) {
          for (final s in v4) {
            raw.execute(s as String);
          }
          raw.execute(
            "INSERT INTO notebook_items (id, item_key, kind, text_en, text_tr, "
            "content_id, source, created_at) VALUES (1, 'phrase|hello.', 'phrase', "
            "'Hello.', 'x', 'A1-001', 'user_saved', '2026-10-13T09:00:00.000Z')",
          );
          raw.execute(
            "INSERT INTO review_cards (id, item_id, due) "
            "VALUES (1, 1, '2026-10-13T09:00:00.000Z')",
          );
          if (!drop.contains('hi_records')) {
            raw.execute(
              "INSERT INTO hi_records (kind, ref_id, status, updated_at) VALUES "
              "('topic_intro', 'time', 'seen', '2026-10-13T09:00:00.000Z')",
            );
          }
          for (final t in drop) {
            raw.execute('DROP TABLE $t');
          }
          raw.execute('PRAGMA user_version = $version');
        },
      ),
    );
  }

  test('şema 2 → 3: Hi tablosu oluşur, eski veriler korunur', () async {
    final migrated = oldDatabase('h048', 2, ['hi_records', 'speech_attempts']);
    final tables = await migrated
        .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
        .get();
    expect(tables.map((r) => r.read<String>('name')), contains('hi_records'));
    final version = await migrated
        .customSelect('PRAGMA user_version')
        .getSingle();
    expect(version.data.values.first, migrated.schemaVersion);
    expect(await NotebookStore(migrated).entries(), hasLength(1));
    final s = HiStore(migrated, clock: () => _now);
    await s.markTopicIntroSeen('time');
    expect(await s.seenTopicIntros(), {'time'});
    await migrated.close();
  });

  test('şema 3 → 4: "Söyle" tablosu oluşur, eski veriler korunur', () async {
    final migrated = oldDatabase('h055', 3, ['speech_attempts']);
    final tables = await migrated
        .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
        .get();
    expect(
      tables.map((r) => r.read<String>('name')),
      contains('speech_attempts'),
    );
    final version = await migrated
        .customSelect('PRAGMA user_version')
        .getSingle();
    expect(version.data.values.first, migrated.schemaVersion);
    expect(await NotebookStore(migrated).entries(), hasLength(1));
    expect(await HiStore(migrated).seenTopicIntros(), {'time'});
    await migrated.close();
  });
}
