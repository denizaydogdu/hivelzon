import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_ids.dart';

import '../../support/fixtures.dart';

/// Şema 4 → 5 (H-038): LWW zamanı ve kimlikler deterministik doldurulur,
/// kuyruk ve durum tabloları oluşur, hesap yokken kuyruk boş kalır.
void main() {
  test('şema 4 → 5: veriler korunur, zaman ve kimlikler doldurulur', () async {
    final dir = Directory.systemTemp.createTempSync('h038');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/v4.sqlite');
    final v4 =
        (jsonDecode(fixtureText('schema_v4.json')) as Map)['statements']
            as List;
    var first = true;
    AppDatabase open() => AppDatabase(
      NativeDatabase(
        file,
        setup: (raw) {
          if (!first) return;
          first = false;
          for (final s in v4) {
            raw.execute(s as String);
          }
          raw
            ..execute(
              "INSERT INTO user_story_progress (content_id, status, "
              "completed_at, updated_at) VALUES ('A1-001', 'COMPLETED', "
              "'2026-10-11T10:00:00.000Z', '2026-10-11T10:05:00.000Z')",
            )
            ..execute(
              "INSERT INTO user_story_flags (content_id, flag, value) "
              "VALUES ('A1-001', 'greet_tone', 'formal')",
            )
            ..execute(
              "INSERT INTO season_state (season_id, intro_seen, intro_seen_at) "
              "VALUES (1, 1, '2026-10-10T08:00:00.000Z')",
            )
            ..execute(
              "INSERT INTO notebook_items (id, item_key, kind, text_en, source, "
              "created_at) VALUES (1, 'phrase|can you hear me?', 'phrase', "
              "'Can you hear me?', 'auto_target_phrase', "
              "'2026-10-11T10:00:00.000Z')",
            )
            ..execute(
              "INSERT INTO review_cards (id, item_id, state, due, reps, "
              "last_review) VALUES (1, 1, 1, '2026-10-12T10:00:00.000Z', 1, "
              "'2026-10-13T09:05:00.000Z')",
            )
            ..execute(
              "INSERT INTO review_logs (card_id, rating, reviewed_at, "
              "task_type, correct, duration_ms) VALUES (1, 3, "
              "'2026-10-13T09:05:00.000Z', 'picture_choice', 1, 4200)",
            )
            ..execute(
              "INSERT INTO learning_events (client_event_id, content_id, "
              "source_id, target, at) VALUES "
              "('0123456789abcdef0123456789abcdef', 'A1-001', 's02-04', "
              "'hear', '2026-10-13T09:10:00.000Z')",
            )
            ..execute(
              "INSERT INTO speech_attempts (place, item_ref, match_level, at) "
              "VALUES ('review', 'Can you hear me?', 'full', "
              "'2026-10-13T09:11:00.000Z')",
            )
            ..execute('PRAGMA user_version = 4');
        },
      ),
    );

    final db = open();
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    // 4 → 5 → 6 (H-067) → 7 (H-078) → 8 (H-074) → 10 (H-089) tek açılışta
    expect(version.data.values.first, 10);
    expect(db.schemaVersion, 10);

    final flag = await db.select(db.userStoryFlags).getSingle();
    expect(flag.updatedAt, DateTime.utc(2026, 10, 11, 10));
    final season = await db.select(db.seasonState).getSingle();
    expect(season.updatedAt, DateTime.utc(2026, 10, 10, 8));
    final item = await db.select(db.notebookItems).getSingle();
    expect(item.updatedAt, DateTime.utc(2026, 10, 11, 10));
    final card = await db.select(db.reviewCards).getSingle();
    expect(card.updatedAt, DateTime.utc(2026, 10, 13, 9, 5));

    // Cevap: backend /review/rate kuralıyla aynı UUIDv5 (test vektörü).
    final log = await db.select(db.reviewLogs).getSingle();
    expect(log.clientId, '815799ab-b9c7-5461-9431-881f4908fde9');
    final event = await db.select(db.learningEvents).getSingle();
    expect(event.clientId, '01234567-89ab-cdef-0123-456789abcdef');
    final speech = await db.select(db.speechAttempts).getSingle();
    expect(SyncIds.isUuid(speech.clientId!), isTrue);

    // Yeni tablolar, tetikleyiciler; hesap yok → kuyruk boş.
    final names =
        (await db.customSelect("SELECT name, type FROM sqlite_master").get())
            .map((r) => r.read<String>('name'))
            .toSet();
    expect(names, containsAll(['sync_state', 'sync_outbox']));
    expect(names, contains('sync_ni_insert'));
    expect(names, contains('review_logs_client_id'));
    expect(await db.select(db.syncOutbox).get(), isEmpty);

    // Eski veriyle çalışmaya devam: yeni ifade eklenir, kuyruğa girmez.
    final store = NotebookStore(db, clock: () => DateTime.utc(2026, 10, 13));
    expect(await store.entries(), hasLength(1));
    await db.close();

    // Yeniden açılış: taşıma tekrar çalışmaz, kimlikler aynı kalır.
    final again = open();
    expect(
      (await again.select(again.reviewLogs).getSingle()).clientId,
      log.clientId,
    );
    expect(
      (await again.select(again.speechAttempts).getSingle()).clientId,
      speech.clientId,
    );
    await again.close();
  });

  test('yeni kurulum: şema 5, kimlikler yazılırken üretilir', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = NotebookStore(db, clock: () => DateTime.utc(2026, 10, 13));
    await db.customStatement(
      "INSERT INTO speech_attempts (place, item_ref, match_level, at) VALUES "
      "('review', 'x', 'full', '2026-10-13T09:00:00.000Z')",
    );
    expect(await store.entries(), isEmpty);
    // Drift ile eklenen satıra istemci varsayılanı (UUIDv4) yazılır.
    final id = await db
        .into(db.speechAttempts)
        .insert(
          SpeechAttemptsCompanion.insert(
            place: 'review',
            itemRef: 'y',
            matchLevel: 'no',
            at: DateTime.utc(2026, 10, 13),
          ),
        );
    final row = await (db.select(
      db.speechAttempts,
    )..where((t) => t.id.equals(id))).getSingle();
    expect(SyncIds.isUuid(row.clientId!), isTrue);
  });
}
