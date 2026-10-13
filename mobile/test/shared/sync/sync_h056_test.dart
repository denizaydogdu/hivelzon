import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/hi/data/hi_store.dart';
import 'package:hivelzon/features/player/data/drift_progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';
import 'package:hivelzon/shared/speech/speech_match.dart';
import 'package:hivelzon/shared/speech/speech_store.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fake_api_server.dart';
import '../../support/sync_harness.dart';

/// H-056: "bitti" her zaman kazanır ve çıkışlıyken yapılan Hi silmesi.
void main() {
  late FakeApiServer server;
  late TestClock clock;
  final devices = <Device>[];

  Device device() {
    final d = Device(server, clock);
    devices.add(d);
    return d;
  }

  setUp(() {
    clock = TestClock();
    server = FakeApiServer(clock: clock.call);
  });
  tearDown(() async {
    for (final d in devices) {
      await d.close();
    }
    devices.clear();
  });

  const email = 'deniz@example.com';

  DriftProgressRepository repo(Device d) =>
      DriftProgressRepository(d.db, clock: clock.call);

  Future<String?> localStatus(Device d, String id) async => (await (d.db.select(
    d.db.userStoryProgress,
  )..where((t) => t.contentId.equals(id))).getSingleOrNull())?.status;

  String? serverStatus(String id) =>
      server
              .dataOf(email)['user_story_progress']
              ?.values
              .firstWhere((r) => r['contentId'] == id)['status']
          as String?;

  EngineSnapshot snapshot(String node) => EngineSnapshot(
    contentVersion: 1,
    checkpointNodeId: node,
    flags: const {},
    passedNodes: const {},
  );

  group('"Bitti" her zaman kazanır', () {
    test('çekilen daha yeni "devam ediyor" yereldeki bitmiş bölümü '
        'düşürmez; bitmiş hâli sunucuya gider', () async {
      final a = device();
      await a.signIn(email);
      await a.engine.sync();
      await repo(a).markCompleted('A1-001', gate: const {});
      // Başka cihaz daha yeni bir "devam ediyor" yazmış; bu cihaz henüz
      // itmeden çeker.
      server.put(email, 'user_story_progress', {
        'contentId': 'A1-001',
        'status': 'IN_PROGRESS',
        'lastCheckpointNodeId': 's03',
        'checkpointSnapshot': null,
        'startedAt': clock.now
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
        'completedAt': null,
        'updatedAt': clock.now
            .add(const Duration(minutes: 1))
            .toIso8601String(),
      });
      expect((await a.engine.sync()).ok, isTrue);
      expect(await localStatus(a, 'A1-001'), 'COMPLETED');
      expect(serverStatus('A1-001'), 'COMPLETED');
      final row = await (a.db.select(
        a.db.userStoryProgress,
      )..where((t) => t.contentId.equals('A1-001'))).getSingle();
      expect(row.completedAt, isNotNull);
      // Başlama zamanı en erkeni.
      expect(row.startedAt, clock.now.subtract(const Duration(hours: 1)));
      expect(await a.db.select(a.db.syncOutbox).get(), isEmpty);
    });

    for (final completerFirst in [true, false]) {
      test('iki cihaz çevrimdışı: A bitirir (t1), B sonra kaldığı yeri '
          'kaydeder (t2 > t1); ${completerFirst ? 'A' : 'B'} önce '
          'eşitler → ikisinde de bitti', () async {
        final a = device();
        final b = device();
        await a.signIn(email);
        await b.signIn(email);
        await repo(a).saveCheckpoint('A1-002', snapshot('s01'));
        await a.engine.sync();
        await b.engine.sync();
        expect(await localStatus(b, 'A1-002'), 'IN_PROGRESS');

        server.offline = true;
        clock.advance(const Duration(minutes: 5));
        await repo(a).markCompleted(
          'A1-002',
          gate: {
            GateItem.activeTask: {'t-a'},
          },
        );
        clock.advance(const Duration(minutes: 5));
        await repo(b).saveCheckpoint('A1-002', snapshot('s04'));
        await repo(b).addGateItem('A1-002', GateItem.comprehension, 'q-b');
        server.offline = false;

        final first = completerFirst ? a : b;
        final second = completerFirst ? b : a;
        expect((await first.engine.sync()).ok, isTrue);
        expect((await second.engine.sync()).ok, isTrue);
        expect((await first.engine.sync()).ok, isTrue);

        expect(serverStatus('A1-002'), 'COMPLETED');
        expect(await localStatus(a, 'A1-002'), 'COMPLETED');
        expect(await localStatus(b, 'A1-002'), 'COMPLETED');
        // Kapı öğeleri yalnızca eklenir: iki cihazınki de iki tarafta.
        for (final d in [a, b]) {
          final gate = await d.db.select(d.db.gateProgress).get();
          expect(gate.map((g) => g.nodeId).toSet(), {'t-a', 'q-b'});
          expect(await d.db.select(d.db.syncOutbox).get(), isEmpty);
        }
        final progress = await repo(b).loadAll();
        expect(progress['A1-002']!.status, StoryStatus.completed);
      });
    }

    test('bitmiş bölüm yeniden oynanınca da "bitti" kalır', () async {
      final a = device();
      final b = device();
      await a.signIn(email);
      await b.signIn(email);
      await repo(a).markCompleted('A1-003', gate: const {});
      await a.engine.sync();
      await b.engine.sync();
      clock.advance(const Duration(minutes: 1));
      await repo(b).saveCheckpoint('A1-003', snapshot('s02'));
      await b.engine.sync();
      await a.engine.sync();
      expect(serverStatus('A1-003'), 'COMPLETED');
      expect(await localStatus(a, 'A1-003'), 'COMPLETED');
    });
  });

  group('çıkışlıyken "Hi\'nin kayıtlarını sil" (H-056)', () {
    Future<void> seedHi(Device d) async {
      await DriftLearningEventLog(d.db).record(
        LearningEvent(
          contentId: 'A1-001',
          sourceId: 's02-04',
          target: 'hear',
          at: clock.now,
        ),
      );
      await SpeechStore(d.db).record(
        SpeechAttempt(
          place: SpeechPlace.review,
          itemRef: 'Can you hear me?',
          level: SpeechMatchLevel.full,
          at: clock.now,
        ),
      );
      await HiStore(
        d.db,
        clock: clock.call,
      ).setBridgeState('order-coffee', BridgeState.done);
    }

    test('aynı hesapla yeniden girişte sunucuya ve öteki cihaza işlenir; '
        'çekilen eski kayıtlar geri gelmez', () async {
      final a = device();
      final b = device();
      await seedHi(a);
      await a.signIn(email);
      await a.engine.sync();
      await b.signIn(email);
      await b.engine.sync();
      expect(await b.db.select(b.db.learningEvents).get(), hasLength(1));

      await a.auth.signOut();
      clock.advance(const Duration(minutes: 10));
      await HiStore(a.db, clock: clock.call).deleteLearningData();
      expect(await a.store.pendingHiReset(), clock.now);
      // Çıkışlıyken hiçbir şey gitmez.
      final data = server.dataOf(email);
      expect(data['learning_events'], hasLength(1));

      clock.advance(const Duration(minutes: 5));
      await a.signIn(email);
      expect(await a.store.pendingHiReset(), isNull);
      expect((await a.engine.sync()).ok, isTrue);
      // İlk çekme eski kayıtları getirdi ama işaret onları yeniden sildi.
      expect(await a.db.select(a.db.learningEvents).get(), isEmpty);
      expect(await a.db.select(a.db.speechAttempts).get(), isEmpty);
      expect(data['learning_events'] ?? {}, isEmpty);
      expect(data['speech_attempts'] ?? {}, isEmpty);
      final marker = data['hi_records']!.values.firstWhere(
        (r) => r['kind'] == HiRecordKind.hiReset,
      );
      expect(
        DateTime.parse(marker['updatedAt'] as String),
        clock.now.subtract(const Duration(minutes: 5)),
      );

      await b.engine.sync();
      expect(await b.db.select(b.db.learningEvents).get(), isEmpty);
      expect(await b.db.select(b.db.speechAttempts).get(), isEmpty);
      expect(
        (await b.db.select(b.db.hiRecords).get()).map((r) => r.kind),
        isNot(contains(HiRecordKind.bridgeTask)),
      );
    });

    test(
      'silmeden sonraki kayıtlar kalır (yalnızca o ana kadarkiler)',
      () async {
        final a = device();
        final b = device();
        await a.signIn(email);
        await b.signIn(email);
        await a.auth.signOut();
        await HiStore(a.db, clock: clock.call).deleteLearningData();
        final resetAt = clock.now;
        // B, A'nın silmesinden sonra yeni bir kayıt yapar.
        clock.advance(const Duration(minutes: 1));
        await seedHi(b);
        await b.engine.sync();
        await a.signIn(email);
        await a.engine.sync();
        final data = server.dataOf(email);
        expect(data['learning_events'], hasLength(1));
        expect(await a.db.select(a.db.learningEvents).get(), hasLength(1));
        expect(await a.store.pendingHiReset(), isNull);
        expect(resetAt.isBefore(clock.now), isTrue);
      },
    );

    test(
      'başka hesapla girişte işlenmez; silme yalnızca bu cihazda kalır',
      () async {
        final a = device();
        final b = device();
        await seedHi(a);
        await a.signIn(email);
        await a.engine.sync();
        await a.auth.signOut();
        await HiStore(a.db, clock: clock.call).deleteLearningData();
        expect(await a.store.pendingHiReset(), isNotNull);

        await a.signIn('baska@example.com');
        await a.engine.sync();
        expect(await a.store.pendingHiReset(), isNull);
        final other = server.dataOf('baska@example.com');
        expect(
          (other['hi_records'] ?? {}).values.where(
            (r) => r['kind'] == HiRecordKind.hiReset,
          ),
          isEmpty,
        );
        // İlk hesabın sunucudaki kayıtları yerinde.
        expect(server.dataOf(email)['learning_events'], hasLength(1));
        // Sonra ilk hesaba dönülse de eski silme artık uygulanmaz.
        await a.auth.signOut();
        await a.signIn(email);
        await a.engine.sync();
        expect(server.dataOf(email)['learning_events'], hasLength(1));
        await b.signIn(email);
        await b.engine.sync();
        expect(await b.db.select(b.db.learningEvents).get(), hasLength(1));
      },
    );

    test('bu cihazda hiç hesap açılmadıysa bekleyen silme saklanmaz', () async {
      final a = device();
      await seedHi(a);
      await HiStore(a.db, clock: clock.call).deleteLearningData();
      expect(await a.store.pendingHiReset(), isNull);
      expect(
        await (a.db.select(
          a.db.appMeta,
        )..where((t) => t.key.equals(SyncStore.lastAccountKey))).get(),
        isEmpty,
      );
    });
  });
}
