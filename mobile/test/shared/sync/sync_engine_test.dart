import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/hi/data/hi_store.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/features/notebook/domain/review_session.dart';
import 'package:hivelzon/features/player/data/drift_progress_repository.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';
import 'package:hivelzon/shared/speech/speech_match.dart';
import 'package:hivelzon/shared/speech/speech_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_engine.dart';
import 'package:hivelzon/shared/sync/sync_ids.dart';

import '../../support/fake_api_server.dart';
import '../../support/sync_harness.dart';

/// Cihazda biraz ilerleme: defter, tekrar cevabı, bölüm, bayrak, Hi kayıtları,
/// öğrenme olayı ve "Söyle" sonucu.
Future<void> seed(Device d) async {
  final notebook = NotebookStore(d.db, clock: d.clock.call);
  await notebook.addItems([phrase('Can you hear me?'), phrase('Excuse me.')]);
  final entry = (await notebook.entries()).firstWhere(
    (e) => e.item.textEn == 'Can you hear me?',
  );
  final after = reviewed(entry.card, d.clock.now);
  await notebook.saveOutcome(
    ReviewOutcome(
      before: entry.card,
      after: after,
      item: entry.item,
      rating: FsrsRating.good,
      taskType: TaskType.pictureChoice,
      correct: true,
      dontKnow: false,
      elapsed: const Duration(seconds: 4),
      reviewedAt: d.clock.now,
      requeued: false,
    ),
  );
  final progress = DriftProgressRepository(d.db, clock: d.clock.call);
  await progress.markCompleted(
    'A1-001',
    gate: {
      GateItem.activeTask: {'t-kanit'},
    },
  );
  await progress.saveEpisodeFlags('A1-001', {'greet_tone': 'formal'});
  final hi = HiStore(d.db, clock: d.clock.call);
  await hi.markTopicIntroSeen('can_questions');
  await hi.setBridgeState('order-coffee', BridgeState.done);
  await DriftLearningEventLog(d.db).record(
    LearningEvent(
      contentId: 'A1-001',
      sourceId: 's02-04',
      target: 'hear',
      at: d.clock.now,
      errorType: ErrorType.wordOrder,
    ),
  );
  await SpeechStore(d.db).record(
    SpeechAttempt(
      place: SpeechPlace.review,
      itemRef: 'Can you hear me?',
      level: SpeechMatchLevel.full,
      at: d.clock.now,
    ),
  );
}

/// Bir "Good" cevabından sonraki kart (değerler önemli değil; sunucu
/// cevaplardan yeniden hesaplar).
ReviewCardState reviewed(ReviewCardState c, DateTime at) => ReviewCardState(
  id: c.id,
  itemId: c.itemId,
  reps: 1,
  fsrs: FsrsCard(
    step: 1,
    stability: 2.3,
    difficulty: 5.1,
    due: at.add(const Duration(minutes: 10)),
    lastReview: at,
  ),
);

void main() {
  late FakeApiServer server;
  late TestClock clock;
  final devices = <Device>[];

  Device device({int maxRows = 500}) {
    final d = Device(server, clock, maxRows: maxRows);
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

  test(
    'hesap yokken hiçbir istek yapılmaz, hiçbir şey kuyruğa girmez',
    () async {
      final a = device();
      await seed(a);
      expect((await a.engine.sync()).kind, SyncOutcomeKind.skipped);
      expect(server.requests, isEmpty);
      expect(await a.db.select(a.db.syncOutbox).get(), isEmpty);
      // "Hi'nin kayıtlarını sil" de hesapsız yalnızca yereldir.
      await HiStore(a.db, clock: clock.call).deleteLearningData();
      expect(await a.engine.sync(), isA<SyncOutcome>());
      expect(server.requests, isEmpty);
      final marker = await (a.db.select(
        a.db.hiRecords,
      )..where((t) => t.kind.equals(HiRecordKind.hiReset))).get();
      expect(marker, isEmpty);
    },
  );

  test(
    'ilk yükleme: bütün yerel veri parçalar hâlinde gider, idempotent',
    () async {
      final a = device(maxRows: 50);
      final notebook = NotebookStore(a.db, clock: clock.call);
      await notebook.addItems([
        for (var i = 0; i < 120; i++) phrase('Phrase $i.'),
      ]);
      await seed(a);
      await a.signIn('deniz@example.com');
      final outcome = await a.engine.sync();
      expect(outcome.ok, isTrue, reason: '${outcome.error}');
      expect(server.pushSizes, everyElement(lessThanOrEqualTo(50)));
      expect(server.pushSizes.length, greaterThanOrEqualTo(5));
      final data = server.dataOf('deniz@example.com');
      expect(data['notebook_items'], hasLength(122));
      expect(data['review_cards'], hasLength(122));
      expect(data['review_logs'], hasLength(1));
      expect(data['user_story_progress'], hasLength(1));
      expect(data['gate_progress'], hasLength(1));
      expect(data['user_story_flags'], hasLength(1));
      expect(data['hi_records'], hasLength(2));
      expect(data['learning_events'], hasLength(1));
      expect(data['speech_attempts'], hasLength(1));
      expect(await a.db.select(a.db.syncOutbox).get(), isEmpty);
      final state = await a.store.state();
      expect(state.initialUploadDone, isTrue);
      expect(state.lastSyncAt, clock.now);

      // Cevap karta kartın UUIDv5'iyle bağlı; kimliği backend kuralıyla aynı.
      final log = data['review_logs']!.values.single;
      final card = SyncIds.card(
        itemKey(NotebookKind.phrase, 'Can you hear me?'),
      );
      expect(log['cardClientId'], card);
      expect(log['clientId'], SyncIds.reviewLog(card, clock.now, 3));
      // Öğrenme olayı: olay kimliğinin UUID biçimi.
      final event = await a.db.select(a.db.learningEvents).getSingle();
      expect(data['learning_events']!.keys.single, event.clientId);
      expect(event.clientId, SyncIds.fromLegacyEventId(event.clientEventId));

      // İkinci tur: gönderilecek bir şey yok.
      final pushes = server.pushSizes.length;
      expect((await a.engine.sync()).pushed, 0);
      expect(server.pushSizes.length, pushes);
    },
  );

  test('ikinci cihaz: önce çeker, sonra kendi verisini iter; LWW', () async {
    final a = device();
    await seed(a);
    await a.signIn('deniz@example.com');
    expect((await a.engine.sync()).ok, isTrue);

    clock.advance(const Duration(hours: 1));
    final b = device();
    // B'de yalnızca kendine ait bir ifade ve daha eski bir bayrak var.
    await NotebookStore(
      b.db,
      clock: clock.call,
    ).addItems([phrase('Only on B.')]);
    await b.db
        .into(b.db.userStoryFlags)
        .insert(
          UserStoryFlagsCompanion.insert(
            contentId: 'A1-001',
            flag: 'greet_tone',
            value: 'casual',
            updatedAt: Value(DateTime.utc(2026, 10, 1)),
          ),
        );
    await b.signIn('deniz@example.com');
    final outcome = await b.engine.sync();
    expect(outcome.ok, isTrue, reason: '${outcome.error}');
    expect(outcome.pulled, greaterThan(0));

    final items = await NotebookStore(b.db).entries();
    expect(items.map((e) => e.item.textEn).toSet(), {
      'Can you hear me?',
      'Excuse me.',
      'Only on B.',
    });
    // A'nın bayrağı daha yeni: B'de o kalır.
    final flag = await b.db.select(b.db.userStoryFlags).getSingle();
    expect(flag.value, 'formal');
    final progress = await DriftProgressRepository(b.db).loadAll();
    expect(progress['A1-001']!.status, StoryStatus.completed);
    expect(await b.db.select(b.db.reviewLogs).get(), hasLength(1));
    expect(await b.db.select(b.db.learningEvents).get(), hasLength(1));
    expect(server.dataOf('deniz@example.com')['notebook_items'], hasLength(3));

    // A da B'nin ifadesini alır.
    expect((await a.engine.sync()).ok, isTrue);
    expect(await NotebookStore(a.db).entries(), hasLength(3));
  });

  test('silme işareti öteki cihaza gider (defter)', () async {
    final a = device();
    final b = device();
    await NotebookStore(a.db, clock: clock.call).addItems([phrase('Bye.')]);
    await a.signIn('deniz@example.com');
    await a.engine.sync();
    await b.signIn('deniz@example.com');
    await b.engine.sync();
    expect(await NotebookStore(b.db).entries(), hasLength(1));

    clock.advance(const Duration(minutes: 5));
    final id = (await NotebookStore(a.db).entries()).single.item.id!;
    expect(await NotebookStore(a.db).removeUserItem(id), isTrue);
    await a.engine.sync();
    final row = server
        .dataOf('deniz@example.com')['notebook_items']!
        .values
        .single;
    expect(row['deleted'], isTrue);
    expect(row['textEn'], isNull);

    await b.engine.sync();
    expect(await NotebookStore(b.db).entries(), isEmpty);
    expect(await b.db.select(b.db.reviewCards).get(), isEmpty);
  });

  test(
    "Hi'nin kayıtlarını sil: işaret sunucuya ve öteki cihaza gider",
    () async {
      final a = device();
      final b = device();
      await seed(a);
      await a.signIn('deniz@example.com');
      await a.engine.sync();
      await b.signIn('deniz@example.com');
      await b.engine.sync();
      expect(await b.db.select(b.db.learningEvents).get(), hasLength(1));
      expect(await b.db.select(b.db.speechAttempts).get(), hasLength(1));
      // H-093: öğrenme kanıtı da Hi'nin kayıtlarıyla silinir.
      expect(await b.db.select(b.db.evidenceRecords).get(), isNotEmpty);

      clock.advance(const Duration(minutes: 10));
      await HiStore(a.db, clock: clock.call).deleteLearningData();
      expect((await a.store.state()).pendingSpeechDelete, isTrue);
      expect((await a.engine.sync()).ok, isTrue);
      expect(server.requests, contains('DELETE /api/v1/sync/speech-attempts'));
      expect((await a.store.state()).pendingSpeechDelete, isFalse);
      final data = server.dataOf('deniz@example.com');
      expect(data['learning_events'] ?? {}, isEmpty);
      expect(data['speech_attempts'] ?? {}, isEmpty);
      expect(data['expression_evidence'] ?? {}, isEmpty);
      final bridge = data['hi_records']!.values.firstWhere(
        (r) => r['kind'] == 'bridge_task',
      );
      expect(bridge['deleted'], isTrue);

      await b.engine.sync();
      expect(await b.db.select(b.db.learningEvents).get(), isEmpty);
      expect(await b.db.select(b.db.speechAttempts).get(), isEmpty);
      expect(await b.db.select(b.db.evidenceRecords).get(), isEmpty);
      final kinds = (await b.db.select(b.db.hiRecords).get()).map(
        (r) => r.kind,
      );
      expect(
        kinds,
        containsAll([HiRecordKind.topicIntro, HiRecordKind.hiReset]),
      );
      expect(kinds, isNot(contains(HiRecordKind.bridgeTask)));
      // İlerleme ve defter yerinde.
      expect(await NotebookStore(b.db).entries(), hasLength(2));
      // İşaretten sonraki yeni kayıt kalır ve gider.
      clock.advance(const Duration(minutes: 1));
      await DriftLearningEventLog(b.db).record(
        LearningEvent(
          contentId: 'A1-002',
          sourceId: 's03-01',
          target: 'map',
          at: clock.now,
        ),
      );
      await b.engine.sync();
      expect(data['learning_events'], hasLength(1));
    },
  );

  test('STALE: sunucudaki daha yeni satır alınır', () async {
    final a = device();
    await DriftProgressRepository(
      a.db,
      clock: clock.call,
    ).saveEpisodeFlags('A1-002', {'greet_tone': 'formal'});
    await a.signIn('deniz@example.com');
    // Başka cihaz daha yeni bir değer yazmış; bu cihaz onu henüz çekmemiş.
    server.put('deniz@example.com', 'user_story_flags', {
      'contentId': 'A1-002',
      'flag': 'greet_tone',
      'value': 'casual',
      'updatedAt': clock.now.add(const Duration(minutes: 1)).toIso8601String(),
    });
    await a.store.update(const SyncStateCompanion(lastPullCursor: Value(999)));
    final outcome = await a.engine.sync();
    expect(outcome.ok, isTrue);
    expect(
      (await a.db.select(a.db.userStoryFlags).getSingle()).value,
      'casual',
    );
    expect(await a.db.select(a.db.syncOutbox).get(), isEmpty);
  });

  test('SERVER_RECOMPUTED: kart durumu sunucudan alınır', () async {
    final a = device();
    await NotebookStore(a.db, clock: clock.call).addItems([phrase('Hello.')]);
    await a.signIn('deniz@example.com');
    server.recomputeCard = (c) => {...c, 'reps': 7, 'state': 2, 'step': null};
    expect((await a.engine.sync()).ok, isTrue);
    final card = await a.db.select(a.db.reviewCards).getSingle();
    expect(card.reps, 7);
    expect(card.state, 2);
    // Sunucunun satırı kuyruğa geri girmez (yeniden itme döngüsü yok).
    expect(await a.db.select(a.db.syncOutbox).get(), isEmpty);
  });

  test('reddedilen satır kenara alınır, gerisi gider', () async {
    final a = device();
    await NotebookStore(
      a.db,
      clock: clock.call,
    ).addItems([phrase('One.'), phrase('Two.'), phrase('Three.')]);
    await a.signIn('deniz@example.com');
    server.rejectRow = (t, r) => t == 'notebook_items' && r['textEn'] == 'One.';
    expect((await a.engine.sync()).ok, isTrue);
    expect(server.dataOf('deniz@example.com')['notebook_items'], hasLength(2));
    final left = await a.db.select(a.db.syncOutbox).get();
    expect(left.where((e) => e.blocked), hasLength(1));
    server.rejectRow = null;
    final pushes = server.pushSizes.length;
    await a.engine.sync();
    expect(
      server.pushSizes.length,
      pushes,
      reason: 'kenara alınan yeniden denenmez',
    );
  });

  test('bağlantı yokken sessizce bekler, gelince gönderir', () async {
    final a = device();
    await a.signIn('deniz@example.com');
    await a.engine.sync();
    server.offline = true;
    await NotebookStore(a.db, clock: clock.call).addItems([phrase('Later.')]);
    final failed = await a.engine.sync();
    expect(failed.kind, SyncOutcomeKind.failed);
    expect(failed.error!.isNetwork, isTrue);
    expect((await a.store.state()).lastErrorCode, 'NETWORK');
    expect(await a.db.select(a.db.syncOutbox).get(), isNotEmpty);
    server.offline = false;
    expect((await a.engine.sync()).ok, isTrue);
    expect((await a.store.state()).lastErrorCode, isNull);
    expect(server.dataOf('deniz@example.com')['notebook_items'], hasLength(1));
  });

  test('çıkış: veri cihazda kalır, eşitleme durur, kuyruk boşalır', () async {
    final a = device();
    await seed(a);
    await a.signIn('deniz@example.com');
    await a.engine.sync();
    await a.auth.signOut();
    expect(server.requests, contains('POST /api/v1/auth/logout'));
    expect(await a.store.signedIn(), isFalse);
    expect(a.tokens.tokens, isNull);
    final before = server.requests.length;
    await NotebookStore(a.db, clock: clock.call).addItems([phrase('After.')]);
    expect(await a.db.select(a.db.syncOutbox).get(), isEmpty);
    expect((await a.engine.sync()).kind, SyncOutcomeKind.skipped);
    expect(server.requests.length, before);
    expect(await NotebookStore(a.db).entries(), hasLength(3));
    // İsteğe bağlı: bu telefondaki verileri de sil.
    await a.store.wipeLocalLearningData();
    expect(await NotebookStore(a.db).entries(), isEmpty);
    expect(await a.db.select(a.db.userStoryProgress).get(), isEmpty);
    expect(await a.db.select(a.db.syncOutbox).get(), isEmpty);
  });
}
