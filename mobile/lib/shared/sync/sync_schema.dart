import 'package:drift/drift.dart';

import '../storage/app_database.dart';
import 'sync_ids.dart';

/// Eşitleme şeması (H-038, Drift şema 5): kimlik dizinleri ve değişiklik
/// tetikleyicileri.
///
/// **Kuyruk (`sync_outbox`)** yalnızca hesap açıkken dolar: tetikleyicilerin
/// koşulu `sync_state.account_user_id` doluluğu ve sunucudan gelen satırlar
/// yazılırken (`applying = 1`) susmalarıdır. Hesap yokken hiçbir değişiklik
/// kaydedilmez; ilk girişte cihazdaki bütün satırlar bir kez kuyruğa alınır
/// ([SyncSql.enqueueAll]).
///
/// Tetikleyiciler satırın **anahtarını** yazar; itmede satırın güncel hâli
/// okunur, satır yoksa silme işareti gönderilir. Böylece aynı satırın art arda
/// değişiklikleri tek kayıt olur (`rev` artar).
abstract final class SyncSql {
  static const tracked =
      'EXISTS (SELECT 1 FROM sync_state WHERE id = 1 '
      'AND account_user_id IS NOT NULL AND applying = 0)';

  static const now = "strftime('%Y-%m-%dT%H:%M:%fZ', 'now')";

  static String enqueue(
    String tbl,
    String k1, {
    String k2 = "''",
    String k3 = "''",
    bool deleted = false,
  }) =>
      'INSERT INTO sync_outbox (tbl, k1, k2, k3, deleted, rev, changed_at, blocked) '
      "VALUES ('$tbl', $k1, $k2, $k3, ${deleted ? 1 : 0}, 1, $now, 0) "
      'ON CONFLICT (tbl, k1, k2, k3) DO UPDATE SET deleted = excluded.deleted, '
      'rev = sync_outbox.rev + 1, changed_at = excluded.changed_at, blocked = 0;';

  /// (tablo, kısa ad, anahtar ifadeleri) — doğal anahtarlı, değişebilir tablolar.
  static const mutable = <(String, String, List<String>)>[
    ('user_story_progress', 'usp', ['content_id']),
    ('user_story_flags', 'usf', ['content_id', 'flag']),
    ('season_state', 'ss', ['CAST(season_id AS TEXT)']),
    ('story_links', 'sl', ['content_id']),
    ('hi_records', 'hr', ['kind', 'ref_id']),
    ('user_book_progress', 'ubp', ['book_id']),
    ('user_grammar_progress', 'ugp', ['lesson_id']),
    ('daily_activity', 'da', ['day', 'source_id']),
  ];

  /// Yalnız eklenen, doğal anahtarlı tablolar.
  static const appendNatural = <(String, String, List<String>)>[
    ('gate_progress', 'gp', ['content_id', 'item_kind', 'node_id']),
    ('clues', 'cl', ['content_id', 'clue_id']),
  ];

  /// Yalnız eklenen, UUID kimlikli tablolar.
  static const appendById = <(String, String)>[
    ('review_logs', 'rl'),
    ('learning_events', 'le'),
    ('speech_attempts', 'sa'),
  ];

  static List<String> _keys(String prefix, List<String> cols) => [
    for (final c in cols)
      c.startsWith('CAST(')
          ? c.replaceFirst('CAST(', 'CAST($prefix.')
          : '$prefix.$c',
  ];

  static String _enq(String tbl, List<String> k, {bool deleted = false}) =>
      enqueue(
        tbl,
        k[0],
        k2: k.length > 1 ? k[1] : "''",
        k3: k.length > 2 ? k[2] : "''",
        deleted: deleted,
      );

  /// Tetikleyiciler (idempotent: `IF NOT EXISTS`).
  static List<String> triggers() {
    final out = <String>[];
    String trig(
      String name,
      String event,
      String table,
      String when,
      String body,
    ) =>
        'CREATE TRIGGER IF NOT EXISTS sync_${name}_$event AFTER '
        '${event.toUpperCase()} ON $table WHEN $when BEGIN $body END';
    for (final (t, n, cols) in mutable) {
      out
        ..add(trig(n, 'insert', t, tracked, _enq(t, _keys('NEW', cols))))
        ..add(trig(n, 'update', t, tracked, _enq(t, _keys('NEW', cols))))
        ..add(
          trig(
            n,
            'delete',
            t,
            tracked,
            _enq(t, _keys('OLD', cols), deleted: true),
          ),
        );
    }
    for (final (t, n, cols) in appendNatural) {
      out.add(trig(n, 'insert', t, tracked, _enq(t, _keys('NEW', cols))));
    }
    for (final (t, n) in appendById) {
      out.add(
        trig(
          n,
          'insert',
          t,
          '$tracked AND NEW.client_id IS NOT NULL',
          _enq(t, ['NEW.client_id']),
        ),
      );
    }
    // Defter: anahtar `item_key`; silinince kartın da silme işareti gider
    // (kart, cevaplarla birlikte zincirleme silinir).
    out
      ..add(
        trig(
          'ni',
          'insert',
          'notebook_items',
          tracked,
          _enq('notebook_items', ['NEW.item_key']),
        ),
      )
      ..add(
        trig(
          'ni',
          'update',
          'notebook_items',
          tracked,
          _enq('notebook_items', ['NEW.item_key']),
        ),
      )
      ..add(
        trig(
          'ni',
          'delete',
          'notebook_items',
          tracked,
          _enq('notebook_items', ['OLD.item_key'], deleted: true) +
              _enq('review_cards', ['OLD.item_key'], deleted: true),
        ),
      );
    // Kart: anahtar defterdeki ifadenin `item_key`'i.
    const cardKey =
        '(SELECT item_key FROM notebook_items WHERE id = NEW.item_id)';
    const cardWhen =
        '$tracked AND EXISTS (SELECT 1 FROM notebook_items WHERE id = NEW.item_id)';
    out
      ..add(
        trig(
          'rc',
          'insert',
          'review_cards',
          cardWhen,
          _enq('review_cards', [cardKey]),
        ),
      )
      ..add(
        trig(
          'rc',
          'update',
          'review_cards',
          cardWhen,
          _enq('review_cards', [cardKey]),
        ),
      );
    return out;
  }

  /// İlk giriş: cihazdaki bütün satırlar kuyruğa (aynı anahtar varsa korunur).
  static List<String> enqueueAll() {
    String ins(String tbl, List<String> cols, String from) {
      final k = [...cols, "''", "''"].take(3).toList();
      return 'INSERT OR IGNORE INTO sync_outbox '
          '(tbl, k1, k2, k3, deleted, rev, changed_at, blocked) '
          "SELECT '$tbl', ${k[0]}, ${k[1]}, ${k[2]}, 0, 1, $now, 0 FROM $from";
    }

    return [
      for (final (t, _, cols) in mutable) ins(t, cols, t),
      for (final (t, _, cols) in appendNatural) ins(t, cols, t),
      for (final (t, _) in appendById)
        ins(t, ['client_id'], '$t WHERE client_id IS NOT NULL'),
      ins('notebook_items', ['item_key'], 'notebook_items'),
      ins(
        'review_cards',
        ['ni.item_key'],
        'review_cards rc JOIN notebook_items ni ON ni.id = rc.item_id',
      ),
    ];
  }
}

/// Kimlik dizinleri ve tetikleyiciler (her açılışta, idempotent).
Future<void> installSyncSchema(AppDatabase db) async {
  for (final t in ['review_logs', 'learning_events', 'speech_attempts']) {
    await db.customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS ${t}_client_id ON $t (client_id)',
    );
  }
  for (final s in SyncSql.triggers()) {
    await db.customStatement(s);
  }
}

/// Şema 4 → 5: var olan satırlara LWW zamanı ve kimlik (deterministik).
///
/// - bayrak: bölümün bitiş (yoksa güncelleme) zamanı; sezon: jenerik zamanı;
///   defter: oluşturma; kart: son tekrar, yoksa vade.
/// - cevap: kart + zaman + nottan UUIDv5 (backend `/review/rate` kuralı);
///   öğrenme olayı: eski 32 haneli kimliğin tireli biçimi; "Söyle" sonucu:
///   yerel sıra + içerikten UUIDv5.
Future<void> backfillSchema5(AppDatabase db) async {
  await db.customStatement(
    'UPDATE user_story_flags SET updated_at = COALESCE('
    '(SELECT COALESCE(p.completed_at, p.updated_at) FROM user_story_progress p '
    'WHERE p.content_id = user_story_flags.content_id), ${SyncSql.now}) '
    'WHERE updated_at IS NULL',
  );
  await db.customStatement(
    'UPDATE season_state SET updated_at = COALESCE(intro_seen_at, ${SyncSql.now}) '
    'WHERE updated_at IS NULL',
  );
  await db.customStatement(
    'UPDATE notebook_items SET updated_at = created_at WHERE updated_at IS NULL',
  );
  await db.customStatement(
    'UPDATE review_cards SET updated_at = COALESCE(last_review, due) '
    'WHERE updated_at IS NULL',
  );

  final logs = await db
      .customSelect(
        'SELECT rl.id AS id, rl.rating AS rating, rl.reviewed_at AS reviewed_at, '
        'ni.item_key AS item_key FROM review_logs rl '
        'JOIN review_cards rc ON rc.id = rl.card_id '
        'JOIN notebook_items ni ON ni.id = rc.item_id WHERE rl.client_id IS NULL',
      )
      .get();
  for (final r in logs) {
    final at = DateTime.parse(r.read<String>('reviewed_at')).toUtc();
    final id = SyncIds.reviewLog(
      SyncIds.card(r.read<String>('item_key')),
      at,
      r.read<int>('rating'),
    );
    await db.customUpdate(
      'UPDATE review_logs SET client_id = ? WHERE id = ?',
      variables: [Variable.withString(id), Variable.withInt(r.read<int>('id'))],
    );
  }
  final events = await db
      .customSelect(
        'SELECT id, client_event_id FROM learning_events WHERE client_id IS NULL',
      )
      .get();
  for (final r in events) {
    await db.customUpdate(
      'UPDATE learning_events SET client_id = ? WHERE id = ?',
      variables: [
        Variable.withString(
          SyncIds.fromLegacyEventId(r.read<String>('client_event_id')),
        ),
        Variable.withInt(r.read<int>('id')),
      ],
    );
  }
  final speech = await db
      .customSelect(
        'SELECT id, place, item_ref, at FROM speech_attempts WHERE client_id IS NULL',
      )
      .get();
  for (final r in speech) {
    final name =
        'speech_attempts:${r.read<int>('id')}|${r.read<String>('place')}|'
        '${r.read<String>('item_ref')}|${r.read<String>('at')}';
    await db.customUpdate(
      'UPDATE speech_attempts SET client_id = ? WHERE id = ?',
      variables: [
        Variable.withString(SyncIds.v5(name)),
        Variable.withInt(r.read<int>('id')),
      ],
    );
  }
}
