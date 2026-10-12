import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/application/deck_sync.dart';
import 'package:hivelzon/features/notebook/data/legacy_notebook_import.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/features/notebook/domain/review_session.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/legacy_prefs_import.dart';

import '../../support/fake_content_source.dart';
import '../../support/fixtures.dart';

class _FakeLegacy implements LegacyKeyValueSource {
  _FakeLegacy(this.values);

  final Map<String, Object> values;

  @override
  Future<Set<String>> keys() async => values.keys.toSet();

  @override
  Future<String?> getString(String key) async => values[key] as String?;

  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;
}

NotebookItem _item(
  String en, {
  NotebookSource source = NotebookSource.autoTargetPhrase,
  String? image,
}) => NotebookItem(
  kind: NotebookKind.phrase,
  textEn: en,
  textTr: 'tr',
  contentId: 'A1-001',
  imagePath: image,
  source: source,
);

void main() {
  late AppDatabase db;
  late NotebookStore store;
  var now = DateTime.utc(2026, 10, 12, 9);

  setUp(() {
    db = AppDatabase.memory();
    now = DateTime.utc(2026, 10, 12, 9);
    store = NotebookStore(db, clock: () => now);
  });
  tearDown(() => db.close());

  group('NotebookStore', () {
    test(
      'ifade bir kez girer; eksik görsel sonradan dolar, dolu alan korunur',
      () async {
        expect(await store.addItems([_item('Can you hear me?')]), 1);
        expect(
          await store.addItems([
            _item('can you hear me', image: 'stills/a.jpg'),
            _item('Yes, I can.', image: 'stills/b.jpg'),
          ]),
          1,
        );
        await store.addItems([
          _item('Can you hear me?', image: 'stills/z.jpg'),
        ]);
        final entries = await store.entries();
        expect(entries, hasLength(2));
        final can = entries.firstWhere(
          (e) => e.item.textEn == 'Can you hear me?',
        );
        expect(can.item.imagePath, 'stills/a.jpg');
        expect(can.card.isNew, isTrue);
        expect(can.card.fsrs.due, now);
      },
    );

    test('yalnızca kullanıcının eklediği kart silinir (kartıyla)', () async {
      await store.addItems([
        _item('Auto.'),
        _item('Mine.', source: NotebookSource.userSaved),
      ]);
      final e = await store.entries();
      final auto = e.firstWhere((x) => x.item.textEn == 'Auto.');
      final mine = e.firstWhere((x) => x.item.textEn == 'Mine.');
      expect(await store.removeUserItem(auto.item.id!), isFalse);
      expect(await store.removeUserItem(mine.item.id!), isTrue);
      expect((await store.entries()).map((x) => x.item.textEn), ['Auto.']);
      final cards = await db.select(db.reviewCards).get();
      expect(cards, hasLength(1));
    });

    test(
      'cevap kaydı: kart güncellenir, günlük yeni kart sayılır (yerel gün)',
      () async {
        await store.addItems([_item('A b.'), _item('C d.')]);
        final entries = await store.entries();
        final s = ReviewSession(
          queue: [for (final e in entries) SessionCard(e.item, e.card)],
          pool: [for (final e in entries) e.item],
          scheduler: ReviewPolicy.scheduler(),
          persist: store.saveOutcome,
          clock: () => now,
        );
        s.start();
        await s.answer(
          correct: false,
          dontKnow: true,
          elapsed: const Duration(seconds: 2),
        );
        s.next();
        await s.answer(correct: true, elapsed: const Duration(seconds: 5));
        s.next();
        now = now.add(const Duration(minutes: 1));
        await s.answer(correct: true, elapsed: const Duration(seconds: 5));
        final logs = await store.logs();
        expect(logs.map((l) => l.rating), [1, 3, 3]);
        expect(logs.map((l) => l.wasNew), [true, true, false]);
        expect(logs.first.dontKnow, isTrue);
        expect(
          await store.newIntroducedBetween(
            now.subtract(const Duration(hours: 1)),
            now.add(const Duration(hours: 1)),
          ),
          2,
        );
        expect(
          await store.newIntroducedBetween(
            now.add(const Duration(hours: 1)),
            now.add(const Duration(days: 1)),
          ),
          0,
        );
        final after = await store.entries();
        expect(
          after.every((e) => e.card.fsrs.state == FsrsState.review),
          isTrue,
        );
        expect(after.every((e) => e.card.reps >= 1), isTrue);
      },
    );

    test('günlük hedef ayarı (varsayılan 10)', () async {
      expect(await store.dailyGoalMinutes(), 10);
      await store.setDailyGoalMinutes(5);
      expect(await store.dailyGoalMinutes(), 5);
    });
  });

  group('DeckSync', () {
    late InMemoryProgressRepository progress;
    late DeckSync sync;
    late InMemoryLearningEventLog events;

    setUp(() {
      progress = InMemoryProgressRepository();
      events = InMemoryLearningEventLog();
      sync = DeckSync(
        store: store,
        source: FakeContentSource(realSubtitles: true),
        progress: progress,
        lookups: (id) async => [
          for (final e in await events.recent())
            if (e.contentId == id) e,
        ],
      );
    });

    test(
      'bitmiş bölüm bir kez aktarılır: kartlar, ipuçları, açık soru',
      () async {
        await events.record(
          LearningEvent(
            contentId: 'A1-001',
            sourceId: 's02-02',
            target: 'Channel',
            at: now,
          ),
        );
        await progress.markCompleted('A1-001', gate: const {});
        await progress.saveCheckpoint(
          'A1-002',
          const EngineSnapshot(
            checkpointNodeId: 's02',
            flags: {},
            passedNodes: {},
            contentVersion: 1,
          ),
        );
        expect(await sync.syncCompleted(), 1);
        expect(await sync.syncCompleted(), 0, reason: 'işaret var');
        final entries = await store.entries();
        expect(entries.map((e) => e.item.textEn).toSet(), {
          'Can you hear me?',
          'Yes, I can.',
          'Again, please.',
          'Where is…?',
          'Listen.',
          'channel',
        });
        expect((await store.clues()).map((c) => c.clueId), ['C1', 'C2']);
        final links = await store.storyLinks();
        expect(links.single.openQuestionTr, 'Old Station nerede?');
        expect(await store.meta(DeckSync.markerKey('A1-001')), startsWith('v'));
        expect(
          DeckSync.isCurrentMarker(
            await store.meta(DeckSync.markerKey('A1-001')),
          ),
          isTrue,
        );
        // Eski biçim işareti (H-052 öncesi): bir kez yeniden aktarılır,
        // var olan kartlar çoğalmaz.
        await store.setMeta(DeckSync.markerKey('A1-001'), 'v1 items=4');
        expect(await sync.syncCompleted(), 1);
        expect((await store.entries()).length, entries.length);
        expect(await sync.syncCompleted(), 0);
      },
    );

    test('bölüm sonu kancası + kaydedilen ifade zenginleşir', () async {
      final repo = DriftNotebookRepository(store);
      await repo.add(
        SavedPhrase(
          contentId: 'A1-001',
          sourceId: 's03-02',
          kind: SavedKind.phrase,
          en: 'the old station',
          tr: 'eski istasyon',
          context: 'Meet me at the old station.',
          savedAt: now,
        ),
      );
      await sync.onEpisodeCompleted(loadFixture('A1-001'));
      final saved = (await store.entries()).firstWhere(
        (e) => e.item.textEn == 'the old station',
      );
      expect(saved.item.source, NotebookSource.userSaved);
      expect(saved.item.audio!.path, 'segments/s03.mp4');
      expect(saved.item.imagePath, isNotNull);
      expect(saved.item.exampleTr, 'Benimle eski istasyonda buluş.');
      // İpucu kartı kancası tekil yazar.
      await sync.onEpisodeCompleted(loadFixture('A1-001'));
      expect(await store.clues(), hasLength(2));
    });
  });

  group('taşıma', () {
    test('shared_preferences defteri ve olayları bir kez Drift\'e', () async {
      final legacy = _FakeLegacy({
        LegacyNotebookImport.notebookKey: jsonEncode([
          {
            'contentId': 'A1-001',
            'sourceId': 's02-04',
            'kind': 'phrase',
            'en': 'Can you hear me?',
            'tr': 'Beni duyabiliyor musun?',
            'context': 'Can you hear me?',
            'savedAt': '2026-10-11T18:00:00.000Z',
          },
          {'bozuk': true},
        ]),
        LegacyNotebookImport.eventsKey: jsonEncode([
          {
            'contentId': 'A1-001',
            'sourceId': 's02-02',
            'target': 'Channel',
            'at': '2026-10-11T18:01:00.000Z',
          },
          {
            'contentId': 'A1-001',
            'sourceId': 's02-04',
            'target': 'sentence',
            'at': '2026-10-11T18:02:00.000Z',
          },
        ]),
      });
      final imp = LegacyNotebookImport(db, legacy, clock: () => now);
      expect(await imp.run(), isTrue);
      expect(await imp.run(), isFalse);
      final entries = await store.entries();
      expect(entries.single.item.source, NotebookSource.userSaved);
      expect(entries.single.item.createdAt, DateTime.utc(2026, 10, 11, 18));
      expect(entries.single.card.isNew, isTrue);
      final log = DriftLearningEventLog(db);
      final ev = await log.recent();
      expect(ev.map((e) => e.target), ['Channel', 'sentence']);
      expect(ev.first.clientEventId, startsWith('legacy-'));
      await log.record(
        LearningEvent(
          contentId: 'A1-001',
          sourceId: 'review:arrange',
          target: 'Can you hear me?',
          at: now,
          errorType: ErrorType.wordOrder,
        ),
      );
      final rows = await db.select(db.learningEvents).get();
      expect(rows.last.errorType, 'word_order');
      expect(rows.last.errorTaxonomyVersion, kErrorTaxonomyVersion);
      expect(rows.first.errorType, isNull);
      expect(await log.lookupsFor('A1-001'), hasLength(2));
    });

    test(
      'şema 1 → 2: eski tablolar ve veriler korunur, yeni tablolar oluşur',
      () async {
        final dir = Directory.systemTemp.createTempSync('h036');
        addTearDown(() => dir.deleteSync(recursive: true));
        final file = File('${dir.path}/v1.sqlite');
        final v1 =
            (jsonDecode(fixtureText('schema_v1.json')) as Map)['statements']
                as List;
        var first = true;
        AppDatabase open() => AppDatabase(
          NativeDatabase(
            file,
            setup: (raw) {
              if (!first) return;
              first = false;
              for (final s in v1) {
                raw.execute(s as String);
              }
              raw.execute(
                "INSERT INTO user_story_progress (content_id, status, updated_at) "
                "VALUES ('A1-001', 'COMPLETED', '2026-10-11T10:00:00.000Z')",
              );
              raw.execute('PRAGMA user_version = 1');
            },
          ),
        );
        final migrated = open();
        final tables = await migrated
            .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
            .get();
        expect(
          tables.map((r) => r.read<String>('name')),
          containsAll([
            'user_story_progress',
            'notebook_items',
            'review_cards',
            'review_logs',
            'learning_events',
            'clues',
            'story_links',
          ]),
        );
        final version = await migrated
            .customSelect('PRAGMA user_version')
            .getSingle();
        expect(version.data.values.first, 2);
        final row = await migrated
            .select(migrated.userStoryProgress)
            .getSingle();
        expect(row.status, 'COMPLETED');
        final s = NotebookStore(migrated, clock: () => now);
        expect(await s.addItems([_item('After migration.')]), 1);
        await migrated.close();
        // Yeniden açılış: taşıma tekrar çalışmaz, veri yerinde.
        final again = open();
        expect(await NotebookStore(again).entries(), hasLength(1));
        await again.close();
      },
    );
  });
}
