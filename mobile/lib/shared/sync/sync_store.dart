import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';

import '../storage/app_database.dart';
import 'sync_ids.dart';
import 'sync_schema.dart';
import 'sync_tables.dart';

/// Hesap ve eşitleme durumu, değişiklik kuyruğu ve sunucudan gelen satırların
/// yerel veritabanına yazılması (H-038).
///
/// Kurallar:
/// - Hesap yoksa kuyruk boştur ve boş kalır (tetikleyiciler susar); hiçbir
///   satır cihaz dışına hazırlanmaz.
/// - Sunucudan gelen satırlar `applying = 1` iken yazılır: tetikleyiciler
///   bunları yeniden kuyruğa almaz.
/// - Değişebilir satırda yerel kopya kuyruktaysa ve yerel zaman daha yeniyse
///   yerel kalır (itmede sunucuya gider); aksi hâlde sunucudaki alınır (LWW).
class SyncStore {
  SyncStore(this.db, {DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase db;
  final DateTime Function() _clock;

  DateTime now() => _clock().toUtc();

  // ------------------------------------------------------------ durum

  Future<SyncStateRow> state() async {
    final row = await (db.select(
      db.syncState,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row != null) return row;
    await db
        .into(db.syncState)
        .insert(
          SyncStateCompanion.insert(deviceId: Value(SyncIds.v4())),
          mode: InsertMode.insertOrIgnore,
        );
    return (db.select(db.syncState)..where((t) => t.id.equals(1))).getSingle();
  }

  final _changes = StreamController<void>.broadcast(sync: true);

  void _changed() => _changes.add(null);

  /// Durum satırı; bu depo üzerinden her yazmada yeniden okunur. (Drift'in
  /// izleme sorgusu kullanılmaz: kapanışta zamanlayıcı bırakıyor ve uygulama
  /// boyunca açık kalan bir akış için gereksiz.)
  Stream<SyncStateRow> watchState() {
    StreamSubscription<void>? sub;
    late final StreamController<SyncStateRow> c;
    Future<void> emit() async {
      try {
        final row = await state();
        if (!c.isClosed) c.add(row);
      } on Object catch (e, st) {
        if (!c.isClosed) c.addError(e, st);
      }
    }

    c = StreamController<SyncStateRow>(
      onListen: () {
        sub = _changes.stream.listen((_) => unawaited(emit()));
        unawaited(emit());
      },
      onCancel: () => sub?.cancel(),
    );
    return c.stream;
  }

  Future<bool> signedIn() async => (await state()).accountUserId != null;

  Future<void> update(SyncStateCompanion c) async {
    await state();
    await (db.update(db.syncState)..where((t) => t.id.equals(1))).write(c);
    _changed();
  }

  /// Bu cihazda en son oturum açan hesabın kimliği (`app_meta`; çıkıştan
  /// sonra da kalır). Çıkışlıyken yapılan Hi silmesinin hangi hesaba
  /// işleneceğini belirler (H-056).
  static const lastAccountKey = 'sync.lastAccountUserId';

  /// Çıkışlıyken "Hi'nin kayıtlarını sil" anı (UTC, ISO-8601): aynı hesapla
  /// yeniden girişte `hi_reset` işareti olarak sunucuya gider (H-056).
  static const pendingHiResetKey = 'sync.pendingHiResetAt';

  Future<String?> _meta(String key) async => (await (db.select(
    db.appMeta,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _setMeta(String key, String value) => db
      .into(db.appMeta)
      .insertOnConflictUpdate(AppMetaCompanion.insert(key: key, value: value));

  Future<void> _deleteMeta(String key) =>
      (db.delete(db.appMeta)..where((t) => t.key.equals(key))).go();

  /// Silme isteği bekleyen hesap (H-042): hesap kimliği ve kalıcı silme anı
  /// (JSON). Çıkıştan sonra da kalır; Hesap ekranı "silinmek üzere" kartını
  /// bundan gösterir. E-posta yazılmaz (maskeli de değil).
  static const pendingDeletionKey = 'account.pendingDeletion';

  /// Silme isteği bekleyen hesap; kalıcı silme anı geçtiyse işaret silinir
  /// ve `null` döner.
  Future<PendingDeletion?> pendingDeletion() async {
    final raw = await _meta(pendingDeletionKey);
    if (raw == null) return null;
    final m = PendingDeletion.tryParse(raw);
    if (m == null || !m.purgeAt.isAfter(now())) {
      await _deleteMeta(pendingDeletionKey);
      return null;
    }
    return m;
  }

  /// Silme isteği alındı (ya da silinmek üzere olan hesapla girildi).
  Future<void> recordPendingDeletion(String? userId, DateTime purgeAt) =>
      _setMeta(
        pendingDeletionKey,
        PendingDeletion(userId: userId, purgeAt: purgeAt.toUtc()).encode(),
      );

  /// Hesap geri alındı.
  Future<void> clearPendingDeletion() => _deleteMeta(pendingDeletionKey);

  /// Bekleyen (çıkışlıyken yapılmış) Hi silmesinin anı; yoksa `null`.
  Future<DateTime?> pendingHiReset() async =>
      DateTime.tryParse(await _meta(pendingHiResetKey) ?? '')?.toUtc();

  /// Çıkışlıyken Hi kayıtları silindi (H-056). Bu cihazda daha önce bir
  /// hesap açılmışsa silme anı saklanır; o hesapla yeniden girişte bütün
  /// cihazlara işlenir. Hiç hesap açılmamışsa saklanmaz (gidecek yer yok).
  /// Art arda silmelerde en geç an kalır. Çağıran işlem içinde çalışabilir.
  Future<void> recordSignedOutHiReset(DateTime at) async {
    if (await _meta(lastAccountKey) == null) return;
    final old = await pendingHiReset();
    final t = at.toUtc();
    if (old != null && !t.isAfter(old)) return;
    await _setMeta(pendingHiResetKey, t.toIso8601String());
  }

  /// Giriş: hesap yazılır, imleç sıfırlanır ve cihazdaki bütün satırlar
  /// kuyruğa alınır (ilk yükleme). Aynı hesaba yeniden girişte de güvenlidir:
  /// sunucu aynı satırı `UNCHANGED`/`DUPLICATE` sayar.
  ///
  /// Çıkışlıyken yapılmış bir Hi silmesi bekliyorsa (H-056):
  /// - **aynı hesap** ([lastAccountKey]): silme anıyla `hi_reset` işareti
  ///   yazılır ve ilk yüklemeyle sunucuya gider; sunucu o ana kadarki
  ///   kayıtları siler, öteki cihazlar çekmeyle aynısını yapar;
  /// - **başka hesap**: silme yalnızca bu cihazda kalır; bekleyen silme
  ///   atılır (başka hesabın verisine dokunulmaz).
  Future<void> signIn({
    required String userId,
    required String emailMasked,
    required String status,
    DateTime? scheduledPurgeAt,
  }) async {
    await state();
    await db.transaction(() async {
      await db.delete(db.syncOutbox).go();
      await (db.update(db.syncState)..where((t) => t.id.equals(1))).write(
        SyncStateCompanion(
          accountUserId: Value(userId),
          emailMasked: Value(emailMasked),
          accountStatus: Value(status),
          scheduledPurgeAt: Value(scheduledPurgeAt),
          lastPullCursor: const Value(0),
          lastSyncAt: const Value(null),
          lastPushAt: const Value(null),
          initialUploadDone: const Value(false),
          applying: const Value(false),
          pendingSpeechDelete: const Value(false),
          lastErrorCode: const Value(null),
          signedOutReason: const Value(null),
        ),
      );
      final pending = await pendingHiReset();
      if (pending != null) {
        if (await _meta(lastAccountKey) == userId) {
          await _writeHiResetMarker(pending);
        }
        await _deleteMeta(pendingHiResetKey);
      }
      await _setMeta(lastAccountKey, userId);
      // H-042: silme bekliyor işareti. Silinmek üzere olan hesapla girişte
      // yazılır; aynı hesap etkin geldiyse (başka cihazda geri alındı)
      // silinir. Başka bir hesabın işaretine dokunulmaz.
      if (status == 'PENDING_DELETION' && scheduledPurgeAt != null) {
        await recordPendingDeletion(userId, scheduledPurgeAt);
      } else if (status != 'PENDING_DELETION') {
        final marker = PendingDeletion.tryParse(
          await _meta(pendingDeletionKey) ?? '',
        );
        if (marker != null &&
            (marker.userId == null || marker.userId == userId)) {
          await _deleteMeta(pendingDeletionKey);
        }
      }
      for (final sql in SyncSql.enqueueAll()) {
        await db.customStatement(sql);
      }
    });
    _notifyOutbox();
    _changed();
  }

  /// `hi_reset` işareti (daha geç bir işaret varsa o kalır).
  Future<void> _writeHiResetMarker(DateTime at) async {
    final existing = await _localHiReset();
    if (existing != null && !at.isAfter(existing)) return;
    await db.customInsert(
      'INSERT INTO hi_records (kind, ref_id, status, updated_at) '
      "VALUES ('hi_reset', 'all', 'cleared', ?) "
      'ON CONFLICT (kind, ref_id) DO UPDATE SET status = excluded.status, '
      'updated_at = excluded.updated_at',
      variables: [Variable<DateTime>(at.toUtc())],
      updates: {db.hiRecords},
    );
  }

  /// Yereldeki `hi_reset` işaretinin anı.
  Future<DateTime?> _localHiReset() async {
    final r = await db
        .customSelect(
          "SELECT updated_at AS t FROM hi_records WHERE kind = 'hi_reset' "
          "AND ref_id = 'all'",
        )
        .getSingleOrNull();
    final v = r?.data['t'];
    return v is String ? DateTime.tryParse(v)?.toUtc() : null;
  }

  /// Bu cihazda oturumu kapatır: eşitleme durur, kuyruk boşalır. Cihazdaki
  /// öğrenme verisi **silinmez** (kullanıcının verisi).
  Future<void> signOut({String? reason}) async {
    await state();
    await db.transaction(() async {
      await db.delete(db.syncOutbox).go();
      await (db.update(db.syncState)..where((t) => t.id.equals(1))).write(
        SyncStateCompanion(
          accountUserId: const Value(null),
          emailMasked: const Value(null),
          accountStatus: const Value(null),
          scheduledPurgeAt: const Value(null),
          lastPullCursor: const Value(0),
          lastSyncAt: const Value(null),
          lastPushAt: const Value(null),
          initialUploadDone: const Value(false),
          applying: const Value(false),
          pendingSpeechDelete: const Value(false),
          lastErrorCode: const Value(null),
          signedOutReason: Value(reason),
        ),
      );
    });
    _notifyOutbox();
    _changed();
  }

  void _notifyOutbox() =>
      db.notifyUpdates({TableUpdate.onTable(db.syncOutbox)});

  // ------------------------------------------------------------ kuyruk

  /// Gönderilecek değişiklikler, tablo uygulama sırasıyla (defter → kart →
  /// cevap). Reddedilmiş satırlar atlanır.
  Future<List<SyncOutboxRow>> pending() async {
    final rows = await (db.select(
      db.syncOutbox,
    )..where((t) => t.blocked.equals(false))).get();
    int order(String t) => syncTablesByName[t]?.order ?? 999;
    rows.sort((a, b) {
      final o = order(a.tbl).compareTo(order(b.tbl));
      return o != 0 ? o : a.changedAt.compareTo(b.changedAt);
    });
    return rows;
  }

  /// Kuyruktaki (gönderilmeyi bekleyen) değişiklik sayısı. Kuyruğu SQLite
  /// tetikleyicileri doldurduğu için eşitlenen bütün tablolar "okunan" diye
  /// bildirilir: herhangi birine yazılınca yeniden sayılır.
  Stream<int> watchPendingCount() => db
      .customSelect(
        'SELECT count(*) AS n FROM sync_outbox WHERE blocked = 0',
        readsFrom: {db.syncOutbox, for (final t in syncTables) _table(t.name)},
      )
      .watchSingle()
      .map((r) => r.read<int>('n'));

  Expression<bool> _same(SyncOutbox t, SyncOutboxRow e) =>
      t.tbl.equals(e.tbl) &
      t.k1.equals(e.k1) &
      t.k2.equals(e.k2) &
      t.k3.equals(e.k3);

  /// Gönderildi: aynı sürümdeyse kuyruktan çıkar (arada yeniden değiştiyse
  /// kalır ve bir sonraki itmede gider).
  Future<void> markSent(Iterable<SyncOutboxRow> entries) async {
    await db.transaction(() async {
      for (final e in entries) {
        await (db.delete(
          db.syncOutbox,
        )..where((t) => _same(t, e) & t.rev.equals(e.rev))).go();
      }
    });
  }

  /// Sunucu reddetti: satır yeniden değişene kadar atlanır.
  Future<void> block(SyncOutboxRow e) async {
    await (db.update(db.syncOutbox)
          ..where((t) => _same(t, e) & t.rev.equals(e.rev)))
        .write(const SyncOutboxCompanion(blocked: Value(true)));
  }

  // ------------------------------------------------------------ satır → JSON

  static List<Variable> _keyVars(SyncTableSpec spec, SyncOutboxRow e) {
    final raw = [e.k1, e.k2, e.k3];
    return [
      for (var i = 0; i < spec.keys.length; i++)
        spec.keys[i].type == SyncType.integer
            ? Variable.withInt(int.parse(raw[i]))
            : Variable.withString(raw[i]),
    ];
  }

  static String _where(SyncTableSpec spec, {String alias = ''}) =>
      spec.keys.map((k) => '$alias${k.column} = ?').join(' AND ');

  /// Kuyruktaki kaydın gönderilecek JSON satırı. Satır silinmişse:
  /// değişebilir tabloda silme işareti, yalnız eklenen tabloda `null`.
  Future<Map<String, Object?>?> loadRow(SyncOutboxRow e) async {
    final spec = syncTablesByName[e.tbl];
    if (spec == null) return null;
    QueryRow? row;
    switch (spec.name) {
      case 'review_cards':
        row = await db
            .customSelect(
              'SELECT rc.*, ni.item_key AS item_key FROM review_cards rc '
              'JOIN notebook_items ni ON ni.id = rc.item_id '
              'WHERE ni.item_key = ?',
              variables: [Variable.withString(e.k1)],
            )
            .getSingleOrNull();
      case 'review_logs':
        row = await db
            .customSelect(
              'SELECT rl.*, ni.item_key AS item_key FROM review_logs rl '
              'JOIN review_cards rc ON rc.id = rl.card_id '
              'JOIN notebook_items ni ON ni.id = rc.item_id '
              'WHERE rl.client_id = ?',
              variables: [Variable.withString(e.k1)],
            )
            .getSingleOrNull();
      case 'learning_events' || 'speech_attempts':
        row = await db
            .customSelect(
              'SELECT * FROM ${spec.name} WHERE client_id = ?',
              variables: [Variable.withString(e.k1)],
            )
            .getSingleOrNull();
      default:
        row = await db
            .customSelect(
              'SELECT * FROM ${spec.name} WHERE ${_where(spec)}',
              variables: _keyVars(spec, e),
            )
            .getSingleOrNull();
    }
    if (row == null) {
      if (!spec.mutable) return null;
      return {
        'clientId': _clientId(spec, e),
        for (var i = 0; i < spec.keys.length; i++)
          spec.keys[i].json: spec.keys[i].type == SyncType.integer
              ? int.parse([e.k1, e.k2, e.k3][i])
              : [e.k1, e.k2, e.k3][i],
        spec.lww!.json: e.changedAt.toUtc().toIso8601String(),
        'deleted': true,
      };
    }
    final data = row.data;
    final out = <String, Object?>{'clientId': _clientId(spec, e)};
    if (spec.mutable) out['deleted'] = false;
    for (final c in spec.all) {
      if (spec.name == 'review_logs' && c.json == 'cardClientId') {
        out[c.json] = SyncIds.card(data['item_key'] as String);
        continue;
      }
      out[c.json] = _toJson(c, data[c.column]);
    }
    // Eski kayıtta LWW zamanı yoksa değişikliğin zamanı kullanılır.
    final lww = spec.lww;
    if (lww != null && out[lww.json] == null) {
      out[lww.json] = e.changedAt.toUtc().toIso8601String();
    }
    return out;
  }

  static String _clientId(SyncTableSpec spec, SyncOutboxRow e) {
    if (!spec.naturalKey) return e.k1;
    final keys = [e.k1, e.k2, e.k3].take(spec.keys.length).toList();
    return SyncIds.natural(spec.name, keys);
  }

  static Object? _toJson(SyncCol c, Object? v) {
    if (v == null) return null;
    switch (c.type) {
      case SyncType.text:
        return v as String;
      case SyncType.integer:
        return (v as num).toInt();
      case SyncType.real:
        return (v as num).toDouble();
      case SyncType.boolean:
        return v is bool ? v : (v as num) != 0;
      case SyncType.dateTime:
        return DateTime.parse(v as String).toUtc().toIso8601String();
      case SyncType.jsonObject:
      case SyncType.jsonArray:
        try {
          return jsonDecode(v as String);
        } on FormatException {
          return null;
        }
    }
  }

  // ------------------------------------------------------------ JSON → satır

  Variable _var(SyncCol c, Object? v) {
    final value = v ?? c.localDefault;
    switch (c.type) {
      case SyncType.text:
        return Variable<String>(value as String?);
      case SyncType.integer:
        return Variable<int>((value as num?)?.toInt());
      case SyncType.real:
        return Variable<double>((value as num?)?.toDouble());
      case SyncType.boolean:
        return Variable<bool>(value as bool?);
      case SyncType.dateTime:
        return Variable<DateTime>(
          value == null ? null : DateTime.parse(value as String).toUtc(),
        );
      case SyncType.jsonObject:
      case SyncType.jsonArray:
        return Variable<String>(
          value == null ? null : (value is String ? value : jsonEncode(value)),
        );
    }
  }

  /// Sunucudan gelen satırları yazar (tek işlem; tetikleyiciler susar).
  /// [force]: çatışma cevabı (`serverRow`), yerel kopyaya bakmadan alınır.
  /// [cursor] verilirse çekme imleci aynı işlemde ilerler.
  Future<int> applyRemote(
    Map<String, List<Map<String, dynamic>>> changes, {
    bool force = false,
    int? cursor,
  }) async {
    var applied = 0;
    await state();
    await db.transaction(() async {
      await db.customStatement(
        'UPDATE sync_state SET applying = 1 WHERE id = 1',
      );
      Map<String, int>? cardIds;
      for (final spec in syncTables) {
        for (final row in changes[spec.name] ?? const []) {
          if (spec.name == 'review_logs') {
            cardIds ??= await _cardIdsByClientId();
          }
          if (await _applyRow(spec, row, force, cardIds)) applied++;
        }
      }
      // Yerelde bir Hi silme işareti varsa, o ana kadarki kayıtlar çekmeyle
      // geri gelmesin (ör. girişteki ilk çekme, işaret henüz itilmeden; H-056).
      if (changes.containsKey('learning_events') ||
          changes.containsKey('speech_attempts') ||
          changes.containsKey('hi_records')) {
        final reset = await _localHiReset();
        if (reset != null) await applyHiReset(reset);
      }
      if (cursor != null) {
        await (db.update(db.syncState)..where((t) => t.id.equals(1))).write(
          SyncStateCompanion(lastPullCursor: Value(cursor)),
        );
      }
      await db.customStatement(
        'UPDATE sync_state SET applying = 0 WHERE id = 1',
      );
    });
    _changed();
    return applied;
  }

  Future<Map<String, int>> _cardIdsByClientId() async {
    final rows = await db
        .customSelect(
          'SELECT rc.id AS id, ni.item_key AS item_key FROM review_cards rc '
          'JOIN notebook_items ni ON ni.id = rc.item_id',
        )
        .get();
    return {
      for (final r in rows)
        SyncIds.card(r.read<String>('item_key')): r.read<int>('id'),
    };
  }

  List<String> _keyStrings(SyncTableSpec spec, Map<String, dynamic> row) => [
    for (final k in spec.keys) '${row[k.json]}',
  ];

  Future<bool> _applyRow(
    SyncTableSpec spec,
    Map<String, dynamic> row,
    bool force,
    Map<String, int>? cardIds,
  ) async {
    if (!spec.mutable) return _insertAppendOnly(spec, row, cardIds);
    final keys = _keyStrings(spec, row);
    if (keys.any((k) => k == 'null')) return false;
    final padded = [...keys, '', ''].take(3).toList();
    final outbox =
        await (db.select(db.syncOutbox)..where(
              (t) =>
                  t.tbl.equals(spec.name) &
                  t.k1.equals(padded[0]) &
                  t.k2.equals(padded[1]) &
                  t.k3.equals(padded[2]),
            ))
            .getSingleOrNull();
    final serverTime = DateTime.tryParse('${row[spec.lww!.json]}')?.toUtc();
    if (!force && outbox != null && serverTime != null) {
      final local = await _localLww(spec, keys) ?? outbox.changedAt.toUtc();
      // Yerel daha yeni: yerel kalır, itmede sunucuya gider.
      if (local.isAfter(serverTime)) return false;
    }
    final deleted = row['deleted'] == true;
    // Bu cihazın kendi ittiği satır geri geldiyse (aynı zaman, kuyrukta
    // değil) yazılmaz: ekranlar boşuna yenilenmesin.
    if (!force && outbox == null && !deleted && serverTime != null) {
      final local = await _localLww(spec, keys);
      if (local != null &&
          local.isAtSameMomentAs(serverTime) &&
          !await _raisesProgress(spec, row)) {
        return false;
      }
    }
    // "Bitti" her zaman kazanır (H-056): gelen satır yereldeki bölüm
    // durumunu düşürecekse yereldeki durum korunur ve sunucuya da gider.
    var data = row;
    var raised = false;
    final progressTable = _progressTables[spec.name];
    if (progressTable != null && !deleted) {
      final merged = await _keepHigherProgress(progressTable, row);
      if (merged != null) {
        data = merged;
        raised = true;
      }
    }
    if (deleted) {
      await _deleteLocal(spec, keys);
    } else if (!await _upsert(spec, data)) {
      return false;
    }
    if (raised) {
      await _enqueueProgress(spec.name, keys[0]);
    } else if (outbox != null) {
      await (db.delete(db.syncOutbox)..where(
            (t) =>
                t.tbl.equals(spec.name) &
                t.k1.equals(padded[0]) &
                t.k2.equals(padded[1]) &
                t.k3.equals(padded[2]),
          ))
          .go();
    }
    if (spec.name == 'hi_records' &&
        !deleted &&
        row['kind'] == 'hi_reset' &&
        serverTime != null) {
      await applyHiReset(serverTime);
    }
    return true;
  }

  /// Bölüm durumunun sırası: başlamadı < devam ediyor < bitti.
  static int progressRank(Object? status) => switch (status) {
    'COMPLETED' => 2,
    'IN_PROGRESS' => 1,
    _ => 0,
  };

  /// Durumu "bitti kazanır" kuralıyla birleşen tablolar (H-056; kitap
  /// ilerlemesi H-067, dilbilgisi dersi H-078): anahtar ve "kalınan yer" alanları (yerel bitmişse
  /// yereldeki kalır).
  static const _progressTables = <String, _ProgressTable>{
    'user_story_progress':
        _ProgressTable('user_story_progress', 'contentId', 'content_id', [
          ('lastCheckpointNodeId', 'last_checkpoint_node_id'),
          ('checkpointSnapshot', 'checkpoint_snapshot'),
        ]),
    'user_book_progress':
        _ProgressTable('user_book_progress', 'bookId', 'book_id', [
          ('chapterId', 'chapter_id'),
          ('pageNumber', 'page_number'),
          ('sentenceIndex', 'sentence_index'),
          ('positionSec', 'position_sec'),
        ]),
    'user_grammar_progress': _ProgressTable(
      'user_grammar_progress',
      'lessonId',
      'lesson_id',
      [('lastCard', 'last_card')],
    ),
  };

  /// Gelen ilerleme satırı yereldeki durumu yükseltiyor mu? (Sunucu
  /// birleştirmesi zamanı değiştirmeden durumu yükseltebilir: aynı zamanlı
  /// satır "kendi itmemiz" sayılıp atlanmasın.)
  Future<bool> _raisesProgress(
    SyncTableSpec spec,
    Map<String, dynamic> row,
  ) async {
    final p = _progressTables[spec.name];
    if (p == null) return false;
    final local = await db
        .customSelect(
          'SELECT status FROM ${p.table} WHERE ${p.keyColumn} = ?',
          variables: [Variable.withString('${row[p.keyJson]}')],
        )
        .getSingleOrNull();
    return progressRank(row['status']) > progressRank(local?.data['status']);
  }

  /// Gelen ilerleme satırı yereldekinden düşük durumdaysa birleştirilmiş
  /// satır (durum ve bitiş zamanı yereldeki; yerel bitmişse kaldığı yer de
  /// yereldeki; başlama zamanı en erken; zaman en geç); değilse `null`.
  /// Sunucu da aynı kuralı uygular (backend `ProgressMerger`).
  Future<Map<String, dynamic>?> _keepHigherProgress(
    _ProgressTable p,
    Map<String, dynamic> row,
  ) async {
    final local = await db
        .customSelect(
          'SELECT status, ${p.place.map((c) => c.$2).join(', ')}, '
          'started_at, completed_at, updated_at FROM ${p.table} '
          'WHERE ${p.keyColumn} = ?',
          variables: [Variable.withString('${row[p.keyJson]}')],
        )
        .getSingleOrNull();
    if (local == null) return null;
    final status = local.data['status'] as String?;
    if (progressRank(status) <= progressRank(row['status'])) return null;
    DateTime? t(Object? v) =>
        v is String ? DateTime.tryParse(v)?.toUtc() : null;
    String? iso(DateTime? v) => v?.toUtc().toIso8601String();
    DateTime? earliest(DateTime? a, DateTime? b) =>
        a == null ? b : (b == null || a.isBefore(b) ? a : b);
    DateTime? latest(DateTime? a, DateTime? b) =>
        a == null ? b : (b == null || a.isAfter(b) ? a : b);
    final merged = Map<String, dynamic>.of(row)
      ..['status'] = status
      ..['completedAt'] = iso(t(local.data['completed_at']))
      ..['startedAt'] = iso(
        earliest(t(local.data['started_at']), t(row['startedAt'])),
      )
      ..['updatedAt'] = iso(
        latest(t(local.data['updated_at']), t(row['updatedAt'])),
      );
    if (status == 'COMPLETED') {
      for (final (json, column) in p.place) {
        merged[json] = local.data[column];
      }
    }
    return merged;
  }

  /// Yereldeki (daha ileri) ilerleme sunucuya gitsin: kuyruğa yazılır
  /// (sunucudan gelen satır yazılırken tetikleyiciler sustuğu için elle).
  Future<void> _enqueueProgress(String table, String key) => db.customStatement(
    'INSERT INTO sync_outbox (tbl, k1, k2, k3, deleted, rev, changed_at, '
    "blocked) VALUES (?, ?, '', '', 0, 1, ?, 0) "
    'ON CONFLICT (tbl, k1, k2, k3) DO UPDATE SET deleted = 0, '
    'rev = sync_outbox.rev + 1, changed_at = excluded.changed_at, blocked = 0',
    [table, key, now().toIso8601String()],
  );

  Future<DateTime?> _localLww(SyncTableSpec spec, List<String> keys) async {
    final col = spec.lww!.column;
    final QueryRow? r;
    if (spec.name == 'review_cards') {
      r = await db
          .customSelect(
            'SELECT rc.$col AS t FROM review_cards rc JOIN notebook_items ni '
            'ON ni.id = rc.item_id WHERE ni.item_key = ?',
            variables: [Variable.withString(keys[0])],
          )
          .getSingleOrNull();
    } else {
      r = await db
          .customSelect(
            'SELECT $col AS t FROM ${spec.name} WHERE ${_where(spec)}',
            variables: [
              for (var i = 0; i < spec.keys.length; i++)
                spec.keys[i].type == SyncType.integer
                    ? Variable.withInt(int.parse(keys[i]))
                    : Variable.withString(keys[i]),
            ],
          )
          .getSingleOrNull();
    }
    final v = r?.data['t'];
    return v is String ? DateTime.tryParse(v)?.toUtc() : null;
  }

  Future<void> _deleteLocal(SyncTableSpec spec, List<String> keys) async {
    // Kartın silinmesi defterdeki ifadenin silinmesiyle gelir (zincirleme).
    if (spec.name == 'review_cards') return;
    await db.customUpdate(
      'DELETE FROM ${spec.name} WHERE ${_where(spec)}',
      variables: [
        for (var i = 0; i < spec.keys.length; i++)
          spec.keys[i].type == SyncType.integer
              ? Variable.withInt(int.parse(keys[i]))
              : Variable.withString(keys[i]),
      ],
      updates: {_table(spec.name)},
      updateKind: UpdateKind.delete,
    );
  }

  Future<bool> _upsert(SyncTableSpec spec, Map<String, dynamic> row) async {
    if (spec.name == 'review_cards') {
      final item = await db
          .customSelect(
            'SELECT id FROM notebook_items WHERE item_key = ?',
            variables: [Variable.withString('${row['itemKey']}')],
          )
          .getSingleOrNull();
      if (item == null) return false;
      final cols = [spec.lww!, ...spec.data];
      await db.customInsert(
        'INSERT INTO review_cards (item_id, ${cols.map((c) => c.column).join(', ')}) '
        'VALUES (?, ${List.filled(cols.length, '?').join(', ')}) '
        'ON CONFLICT (item_id) DO UPDATE SET '
        '${cols.map((c) => '${c.column} = excluded.${c.column}').join(', ')}',
        variables: [
          Variable.withInt(item.read<int>('id')),
          for (final c in cols) _var(c, row[c.json]),
        ],
        updates: {db.reviewCards},
      );
      return true;
    }
    final cols = spec.all;
    final conflict = spec.keys.map((k) => k.column).join(', ');
    final set = [
      ?spec.lww,
      ...spec.data,
    ].map((c) => '${c.column} = excluded.${c.column}').join(', ');
    await db.customInsert(
      'INSERT INTO ${spec.name} (${cols.map((c) => c.column).join(', ')}) '
      'VALUES (${List.filled(cols.length, '?').join(', ')}) '
      'ON CONFLICT ($conflict) DO UPDATE SET $set',
      variables: [for (final c in cols) _var(c, row[c.json])],
      updates: {_table(spec.name)},
    );
    return true;
  }

  Future<bool> _insertAppendOnly(
    SyncTableSpec spec,
    Map<String, dynamic> row,
    Map<String, int>? cardIds,
  ) async {
    final id = row['clientId'] as String?;
    final cols = <String>[];
    final vars = <Variable>[];
    switch (spec.name) {
      case 'review_logs':
        final card = cardIds?[row['cardClientId']];
        if (card == null || id == null) return false;
        cols.addAll(['card_id', 'client_id']);
        vars.addAll([Variable.withInt(card), Variable.withString(id)]);
        for (final c in spec.data.where((c) => c.json != 'cardClientId')) {
          cols.add(c.column);
          vars.add(_var(c, row[c.json]));
        }
      case 'learning_events':
        if (id == null) return false;
        cols.addAll(['client_event_id', 'client_id']);
        vars.addAll([Variable.withString(id), Variable.withString(id)]);
        for (final c in spec.data) {
          cols.add(c.column);
          vars.add(_var(c, row[c.json]));
        }
      case 'speech_attempts':
        if (id == null) return false;
        cols.add('client_id');
        vars.add(Variable.withString(id));
        for (final c in spec.data) {
          cols.add(c.column);
          vars.add(_var(c, row[c.json]));
        }
      default:
        for (final c in spec.all) {
          cols.add(c.column);
          vars.add(_var(c, row[c.json]));
        }
    }
    final n = await db.customInsert(
      'INSERT OR IGNORE INTO ${spec.name} (${cols.join(', ')}) '
      'VALUES (${List.filled(cols.length, '?').join(', ')})',
      variables: vars,
      updates: {_table(spec.name)},
    );
    return n > 0;
  }

  TableInfo _table(String name) =>
      db.allTables.firstWhere((t) => t.actualTableName == name);

  /// "Hi'nin kayıtlarını sil" işareti geldi: [at] anına kadarki öğrenme
  /// olayları, "Söyle" sonuçları, öğrenme kanıtları (H-093), yan görev ve
  /// not kayıtları bu cihazda da silinir (H-038). Konu tanıtımı ve sahne avı
  /// kalır (ilerleme sayılır).
  Future<void> applyHiReset(DateTime at) async {
    final t = Variable<DateTime>(at.toUtc());
    await db.customUpdate(
      'DELETE FROM expression_evidence WHERE julianday(at) <= julianday(?)',
      variables: [t],
      updates: {db.evidenceRecords},
      updateKind: UpdateKind.delete,
    );
    await db.customUpdate(
      'DELETE FROM learning_events WHERE julianday(at) <= julianday(?)',
      variables: [t],
      updates: {db.learningEvents},
      updateKind: UpdateKind.delete,
    );
    await db.customUpdate(
      'DELETE FROM speech_attempts WHERE julianday(at) <= julianday(?)',
      variables: [t],
      updates: {db.speechAttempts},
      updateKind: UpdateKind.delete,
    );
    await db.customUpdate(
      "DELETE FROM hi_records WHERE kind IN ('bridge_task', 'note_read') "
      'AND julianday(updated_at) <= julianday(?)',
      variables: [t],
      updates: {db.hiRecords},
      updateKind: UpdateKind.delete,
    );
  }

  // ------------------------------------------------------------ silme

  /// "Bu telefondaki verileri de sil" (çıkışta, ayrı onayla): öğrenme
  /// verisi ve ad silinir; ayarlar (günlük hedef, "Söyle") kalır. Oturum
  /// kapalıyken çağrılır: silme işareti oluşmaz, hesaptaki veri durur.
  Future<void> wipeLocalLearningData() async {
    await db.transaction(() async {
      for (final t in [
        'review_logs',
        'review_cards',
        'notebook_items',
        'learning_events',
        'speech_attempts',
        'hi_records',
        'clues',
        'story_links',
        'gate_progress',
        'user_story_flags',
        'user_story_progress',
        'user_book_progress',
        'user_grammar_progress',
        'daily_activity',
        'user_book_comprehension',
        'user_talk_progress',
        'expression_evidence',
        'season_state',
      ]) {
        await db.customUpdate(
          'DELETE FROM $t',
          updates: {_table(t)},
          updateKind: UpdateKind.delete,
        );
      }
      await db.customUpdate(
        "DELETE FROM app_meta WHERE key IN ('profile.displayName', "
        "'hi.panelOpenedDay', 'review.lastPracticeAt')",
        updates: {db.appMeta},
        updateKind: UpdateKind.delete,
      );
    });
  }
}

/// "Bitti kazanır" tablosunun tanımı ([SyncStore._progressTables]).
class _ProgressTable {
  const _ProgressTable(this.table, this.keyJson, this.keyColumn, this.place);

  final String table;
  final String keyJson;
  final String keyColumn;

  /// Kalınan yer: (JSON adı, kolon).
  final List<(String, String)> place;
}

/// Silme isteği bekleyen hesap (H-042; `app_meta`
/// [SyncStore.pendingDeletionKey]). E-posta tutulmaz.
class PendingDeletion {
  const PendingDeletion({required this.userId, required this.purgeAt});

  /// Hesap kimliği (aynı hesap başka cihazda geri alınınca işareti silmek
  /// için); yoksa `null`.
  final String? userId;

  /// Kalıcı silme anı (UTC).
  final DateTime purgeAt;

  String encode() => jsonEncode({
    'userId': ?userId,
    'purgeAt': purgeAt.toUtc().toIso8601String(),
  });

  static PendingDeletion? tryParse(String raw) {
    try {
      final m = jsonDecode(raw);
      if (m is! Map) return null;
      final at = DateTime.tryParse('${m['purgeAt']}');
      if (at == null) return null;
      final id = m['userId'];
      return PendingDeletion(
        userId: id is String ? id : null,
        purgeAt: at.toUtc(),
      );
    } on FormatException {
      return null;
    }
  }
}
