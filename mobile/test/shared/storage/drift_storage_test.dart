import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/player/data/drift_progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/legacy_prefs_import.dart';

EngineSnapshot _snap(String node, {Map<String, String> flags = const {}}) =>
    EngineSnapshot(
      checkpointNodeId: node,
      flags: flags,
      passedNodes: {'k1', node},
      contentVersion: 2,
    );

const _fullGate = {
  GateItem.comprehension: {'t-gorev'},
  GateItem.targetPhrase: {'k2'},
  GateItem.activeTask: {'t-kanit'},
};

/// Eski `shared_preferences` deposunun sahtesi.
class _FakeLegacy implements LegacyKeyValueSource {
  _FakeLegacy(this.values);

  final Map<String, Object> values;
  int reads = 0;

  @override
  Future<Set<String>> keys() async {
    reads++;
    return values.keys.toSet();
  }

  @override
  Future<String?> getString(String key) async => values[key] as String?;

  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;
}

void main() {
  late AppDatabase db;
  var now = DateTime.utc(2026, 10, 12, 9);

  setUp(() {
    db = AppDatabase.memory();
    now = DateTime.utc(2026, 10, 12, 9);
  });
  tearDown(() => db.close());

  DriftProgressRepository repo([Future<void>? ready]) =>
      DriftProgressRepository(db, ready: ready, clock: () => now);

  group('DriftProgressRepository', () {
    test('tablolar şartnamedeki adlarla oluşur', () async {
      final rows = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
          )
          .get();
      expect(
        rows.map((r) => r.read<String>('name')),
        containsAll([
          'user_story_progress',
          'user_story_flags',
          'gate_progress',
          'season_state',
          'app_meta',
        ]),
      );
    });

    test('kontrol noktası: IN_PROGRESS, startedAt UTC ve korunur', () async {
      final r = repo();
      await r.saveCheckpoint('A1-001', _snap('s02', flags: {'f': 'a'}));
      now = now.add(const Duration(minutes: 5));
      await r.saveCheckpoint('A1-001', _snap('s05'));
      final cp = await r.loadCheckpoint('A1-001');
      expect(cp!.checkpointNodeId, 's05');
      expect(cp.passedNodes, {'k1', 's05'});
      expect(cp.contentVersion, 2);
      final p = (await r.loadAll())['A1-001']!;
      expect(p.status, StoryStatus.inProgress);
      expect(p.lastCheckpointNodeId, 's05');
      expect(p.startedAt, DateTime.utc(2026, 10, 12, 9));
      expect(p.startedAt!.isUtc, isTrue);
      expect(p.completedAt, isNull);
      // Saklanan metin UTC (ISO-8601, Z ya da +00:00).
      final raw = await db
          .customSelect('SELECT started_at FROM user_story_progress')
          .getSingle();
      expect(raw.read<String>('started_at'), startsWith('2026-10-12T09:00:00'));
    });

    test(
      'bitiş: COMPLETED, kapı birleşir, tekrar oynamak geri almaz',
      () async {
        final r = repo();
        await r.saveCheckpoint('A1-001', _snap('s02'));
        await r.markCompleted(
          'A1-001',
          gate: {
            GateItem.comprehension: {'t-gorev'},
            GateItem.targetPhrase: {},
            GateItem.activeTask: {'t-kanit'},
          },
        );
        await r.clearCheckpoint('A1-001');
        var p = (await r.loadAll())['A1-001']!;
        expect(p.status, StoryStatus.completed);
        expect(p.gateComplete, isFalse);
        expect(p.missingGateItems, {GateItem.targetPhrase});
        expect(p.hasCheckpoint, isFalse);
        expect(await r.loadCheckpoint('A1-001'), isNull);

        // Tekrar: önce kontrol noktası (COMPLETED kalır), sonra eksik ölçüt.
        await r.saveCheckpoint('A1-001', _snap('s03'));
        p = (await r.loadAll())['A1-001']!;
        expect(p.status, StoryStatus.completed);
        expect(p.hasCheckpoint, isTrue);
        await r.markCompleted('A1-001', gate: _fullGate);
        await r.markCompleted('A1-001', gate: _fullGate); // idempotent
        p = (await r.loadAll())['A1-001']!;
        expect(p.gateComplete, isTrue);
        final gates = await db.select(db.gateProgress).get();
        expect(gates.length, 3);
      },
    );

    test(
      'bayraklar: yazılır, değiştirilir, bozuk kayıt baştan başlatır',
      () async {
        final r = repo();
        await r.saveEpisodeFlags('A1-002', {'greet_tone': 'formal'});
        await r.saveEpisodeFlags('A1-002', {'greet_tone': 'friendly'});
        expect(await r.loadEpisodeFlags('A1-002'), {'greet_tone': 'friendly'});
        expect(await r.loadEpisodeFlags('A1-009'), isEmpty);

        await db
            .into(db.userStoryProgress)
            .insert(
              UserStoryProgressCompanion.insert(
                contentId: 'A1-003',
                checkpointSnapshot: const Value('{bozuk'),
                lastCheckpointNodeId: const Value('x'),
                updatedAt: now,
              ),
            );
        expect(await r.loadCheckpoint('A1-003'), isNull);
        expect((await r.loadAll())['A1-003']!.hasCheckpoint, isFalse);
      },
    );

    test(
      'uygulama yeniden açılınca ilerleme yerinde (dosya veritabanı)',
      () async {
        final dir = await Directory.systemTemp.createTemp('hivelzon-db');
        addTearDown(() => dir.delete(recursive: true));
        final file = File('${dir.path}/hivelzon.sqlite');

        var first = AppDatabase(NativeDatabase(file));
        var r = DriftProgressRepository(first, clock: () => now);
        await r.markCompleted('A1-001', gate: _fullGate);
        await r.saveCheckpoint('A1-002', _snap('s04'));
        await DriftSeasonIntroRepository(first).markSeen(1);
        await first.close();

        // "Uygulamayı kapat-aç": yeni bağlantı, aynı dosya.
        first = AppDatabase(NativeDatabase(file));
        addTearDown(first.close);
        r = DriftProgressRepository(first, clock: () => now);
        final all = await r.loadAll();
        expect(all['A1-001']!.status, StoryStatus.completed);
        expect(all['A1-001']!.gateComplete, isTrue);
        expect(all['A1-002']!.lastCheckpointNodeId, 's04');
        expect((await r.loadCheckpoint('A1-002'))!.checkpointNodeId, 's04');
        expect(await DriftSeasonIntroRepository(first).seen(1), isTrue);
      },
    );

    test('hazırlık (taşıma) bitmeden okuma yapılmaz', () async {
      var done = false;
      final ready = Future<void>.delayed(
        const Duration(milliseconds: 20),
        () => done = true,
      );
      await repo(ready).loadAll();
      expect(done, isTrue);
    });
  });

  group('DriftSeasonIntroRepository', () {
    test('izlendi / unut', () async {
      final r = DriftSeasonIntroRepository(db);
      expect(await r.seen(1), isFalse);
      await r.markSeen(1);
      await r.markSeen(1);
      expect(await r.seen(1), isTrue);
      expect(await r.seen(2), isFalse);
      await r.forget(1);
      expect(await r.seen(1), isFalse);
    });
  });

  group('LegacyPrefsImport (shared_preferences → Drift)', () {
    final legacyValues = <String, Object>{
      'player.checkpoint.A1-002':
          '{"checkpoint":"s03","flags":{},"passed":["k1"],"contentVersion":2}',
      'player.checkpoint.A1-009': '{bozuk',
      'player.flags.A1-001': '{"greet_tone":"formal"}',
      'player.flags.A1-004': '{bozuk',
      'story.seasonIntroSeen.1': true,
      'story.seasonIntroSeen.2': false,
      'meaning.notebook': '[]', // H-036'ya kadar shared_preferences'ta kalır
    };

    test(
      'bir kez taşır: kontrol noktası, biten bölüm, bayrak, jenerik',
      () async {
        final legacy = _FakeLegacy(Map.of(legacyValues));
        final imp = LegacyPrefsImport(db, legacy, clock: () => now);
        expect(await imp.run(), isTrue);
        final r = repo();
        final all = await r.loadAll();
        expect(all.keys.toSet(), {'A1-001', 'A1-002'});
        expect(all['A1-001']!.status, StoryStatus.completed);
        // Eski sürüm kapıyı kaydetmiyordu: biten bölüm kilit bırakmaz (K-29).
        expect(all['A1-001']!.gateComplete, isTrue);
        expect(await r.loadEpisodeFlags('A1-001'), {'greet_tone': 'formal'});
        expect(all['A1-002']!.status, StoryStatus.inProgress);
        expect((await r.loadCheckpoint('A1-002'))!.checkpointNodeId, 's03');
        final intro = DriftSeasonIntroRepository(db);
        expect(await intro.seen(1), isTrue);
        expect(await intro.seen(2), isFalse);

        // İkinci çalıştırma hiçbir şey yapmaz (işaret var).
        expect(await imp.run(), isFalse);
        expect(legacy.reads, 1);
      },
    );

    test('veritabanındaki yeni kayıtların üzerine yazmaz', () async {
      final r = repo();
      await r.saveCheckpoint('A1-002', _snap('s07'));
      await LegacyPrefsImport(
        db,
        _FakeLegacy(Map.of(legacyValues)),
        clock: () => now,
      ).run();
      expect((await r.loadCheckpoint('A1-002'))!.checkpointNodeId, 's07');
    });

    test('eski kayıt yoksa yalnızca işaret yazılır', () async {
      expect(
        await LegacyPrefsImport(db, _FakeLegacy({}), clock: () => now).run(),
        isTrue,
      );
      expect(await repo().loadAll(), isEmpty);
      final meta = await db.select(db.appMeta).get();
      expect(meta.single.key, LegacyPrefsImport.markerKey);
    });
  });
}
