import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;

import '../api/api_client.dart';
import '../api/auth_service.dart';
import '../storage/app_database.dart';
import 'sync_store.dart';
import 'sync_tables.dart';

/// Bir eşitleme turunun sonucu.
class SyncOutcome {
  const SyncOutcome._(
    this.kind, {
    this.pulled = 0,
    this.pushed = 0,
    this.error,
  });

  const SyncOutcome.skipped() : this._(SyncOutcomeKind.skipped);

  const SyncOutcome.ok({int pulled = 0, int pushed = 0})
    : this._(SyncOutcomeKind.ok, pulled: pulled, pushed: pushed);

  const SyncOutcome.failed(ApiException e)
    : this._(SyncOutcomeKind.failed, error: e);

  final SyncOutcomeKind kind;
  final int pulled;
  final int pushed;
  final ApiException? error;

  bool get ok => kind == SyncOutcomeKind.ok;
}

enum SyncOutcomeKind { ok, skipped, failed }

/// Çift yönlü eşitleme (H-038): önce çek (imleçten sonra, sayfa sayfa),
/// sonra kuyruktakileri it (≤ 500 satır ve ≤ ~900 KB'lık parçalar), en son
/// bekleyen "Söyle" silmesi.
///
/// - **Hesap yoksa hiçbir istek yapılmaz** ([SyncOutcome.skipped]).
/// - İtme idempotenttir; ağ hatasında aynı parça yeniden gönderilebilir.
/// - `STALE` çatışması: sunucudaki satır alınır. `SERVER_RECOMPUTED`: sunucunun
///   cevaplardan hesapladığı kart durumu alınır.
/// - Sunucu bir satırı reddederse (`SYNC_ROW_INVALID` …) yalnızca o satır
///   kenara alınır, gerisi gönderilir (eşitleme takılmaz).
/// - Aynı anda tek tur çalışır; ikinci çağrı süren turu bekler.
class SyncEngine {
  SyncEngine({
    required this.store,
    required this.auth,
    this.maxRows = 500,
    this.maxBytes = 900 * 1024,
    this.pullLimit = 500,
  });

  final SyncStore store;
  final AuthService auth;
  final int maxRows;
  final int maxBytes;
  final int pullLimit;

  Future<SyncOutcome>? _running;

  ApiClient get _api => auth.api;

  Future<SyncOutcome> sync() => _running ??= _run().whenComplete(() {
    _running = null;
  });

  Future<SyncOutcome> _run() async {
    final s = await store.state();
    if (s.accountUserId == null ||
        s.accountStatus == AccountStatus.pendingDeletion) {
      return const SyncOutcome.skipped();
    }
    try {
      final pulled = await _pull(s.lastPullCursor);
      final pushed = await _push(s.deviceId);
      if ((await store.state()).pendingSpeechDelete) {
        await auth.authorized(
          (b) => _api.send(
            'DELETE',
            '/api/v1/sync/speech-attempts',
            bearer: b,
            retryNetwork: true,
          ),
        );
        await store.update(
          const SyncStateCompanion(pendingSpeechDelete: Value(false)),
        );
      }
      if (await store.signedIn()) {
        await store.update(
          SyncStateCompanion(
            lastSyncAt: Value(store.now()),
            lastErrorCode: const Value(null),
            initialUploadDone: const Value(true),
          ),
        );
      }
      return SyncOutcome.ok(pulled: pulled, pushed: pushed);
    } on ApiException catch (e) {
      if (await store.signedIn()) {
        await store.update(SyncStateCompanion(lastErrorCode: Value(e.code)));
      }
      return SyncOutcome.failed(e);
    }
  }

  // ------------------------------------------------------------ çekme

  Future<int> _pull(int since) async {
    var cursor = since;
    var applied = 0;
    while (true) {
      final r = await auth.authorized(
        (b) => _api.send(
          'GET',
          '/api/v1/sync/pull',
          query: {'since': '$cursor', 'limit': '$pullLimit'},
          bearer: b,
          retryNetwork: true,
        ),
      );
      final body = r.map;
      final changes = <String, List<Map<String, dynamic>>>{
        for (final e in ((body['changes'] as Map?) ?? const {}).entries)
          e.key as String: [
            for (final row in e.value as List)
              (row as Map).cast<String, dynamic>(),
          ],
      };
      final next = (body['nextSince'] as num?)?.toInt() ?? cursor;
      applied += await store.applyRemote(changes, cursor: next);
      if (body['hasMore'] != true || next == cursor) return applied;
      cursor = next;
    }
  }

  // ------------------------------------------------------------ itme

  Future<int> _push(String? deviceId) async {
    final entries = await store.pending();
    var pushed = 0;
    final chunk = <(SyncOutboxRow, Map<String, Object?>)>[];
    var bytes = 0;
    for (final e in entries) {
      final row = await store.loadRow(e);
      if (row == null) {
        // Yalnız eklenen satır gönderilmeden silinmiş: kuyruktan çıkar.
        await store.markSent([e]);
        continue;
      }
      final size = utf8.encode(jsonEncode(row)).length + 1;
      if (chunk.isNotEmpty &&
          (chunk.length >= maxRows || bytes + size > maxBytes)) {
        pushed += await _send(deviceId, List.of(chunk));
        chunk.clear();
        bytes = 0;
      }
      chunk.add((e, row));
      bytes += size;
    }
    if (chunk.isNotEmpty) pushed += await _send(deviceId, chunk);
    if (pushed > 0) {
      await store.update(SyncStateCompanion(lastPushAt: Value(store.now())));
    }
    return pushed;
  }

  static const _rowErrors = {
    'SYNC_ROW_INVALID',
    'SYNC_FIELD_NOT_ALLOWED',
    'TRANSCRIPT_NOT_ALLOWED',
  };

  /// Bir parçayı gönderir; reddedilen satırı kenara alıp kalanı yeniden
  /// dener, çok büyükse ikiye böler.
  Future<int> _send(
    String? deviceId,
    List<(SyncOutboxRow, Map<String, Object?>)> chunk,
  ) async {
    if (chunk.isEmpty) return 0;
    final byTable = <String, List<(SyncOutboxRow, Map<String, Object?>)>>{};
    for (final c in chunk) {
      byTable.putIfAbsent(c.$1.tbl, () => []).add(c);
    }
    final ApiResponse r;
    try {
      r = await auth.authorized(
        (b) => _api.send(
          'POST',
          '/api/v1/sync/push',
          body: {
            'deviceId': ?deviceId,
            'changes': {
              for (final e in byTable.entries)
                e.key: [for (final c in e.value) c.$2],
            },
          },
          bearer: b,
          retryNetwork: true,
        ),
      );
    } on ApiException catch (e) {
      if (e.code == 'PAYLOAD_TOO_LARGE' && chunk.length > 1) {
        final half = chunk.length ~/ 2;
        return await _send(deviceId, chunk.sublist(0, half)) +
            await _send(deviceId, chunk.sublist(half));
      }
      if (_rowErrors.contains(e.code) || e.code == 'PAYLOAD_TOO_LARGE') {
        final bad = _rejected(e, byTable, chunk);
        for (final b in bad) {
          await store.block(b.$1);
        }
        final rest = chunk.where((c) => !bad.contains(c)).toList();
        if (rest.length == chunk.length) return 0;
        return _send(deviceId, rest);
      }
      rethrow;
    }
    final byId = {
      for (final c in chunk) '${c.$2['clientId']}'.toLowerCase(): c.$1,
    };
    final body = r.map;
    final sent = <SyncOutboxRow>[];
    for (final a in (body['accepted'] as List? ?? const [])) {
      final e = byId['${(a as Map)['clientId']}'.toLowerCase()];
      if (e != null) sent.add(e);
    }
    final serverRows = <String, List<Map<String, dynamic>>>{};
    for (final c in (body['conflicts'] as List? ?? const [])) {
      final m = (c as Map).cast<String, dynamic>();
      final row = (m['serverRow'] as Map?)?.cast<String, dynamic>();
      if (row != null) {
        serverRows.putIfAbsent(m['table'] as String, () => []).add(row);
      }
      final e = byId['${m['clientId']}'.toLowerCase()];
      if (e != null) sent.add(e);
    }
    if (serverRows.isNotEmpty) {
      await store.applyRemote(serverRows, force: true);
    }
    await store.markSent(sent);
    return sent.length;
  }

  /// Hata cevabındaki yer (`table`, `index`) → parçadaki satır; yer yoksa
  /// parçanın tamamı.
  List<(SyncOutboxRow, Map<String, Object?>)> _rejected(
    ApiException e,
    Map<String, List<(SyncOutboxRow, Map<String, Object?>)>> byTable,
    List<(SyncOutboxRow, Map<String, Object?>)> chunk,
  ) {
    final table = e.properties['table'];
    final index = e.properties['index'];
    if (table is String && index is num) {
      final rows = byTable[table];
      if (rows != null && index >= 0 && index < rows.length) {
        return [rows[index.toInt()]];
      }
    }
    if (table is String && byTable.containsKey(table)) return byTable[table]!;
    return chunk;
  }
}

/// Tablo adının bilinip bilinmediği (testler için).
bool isSyncTable(String name) => syncTablesByName.containsKey(name);
