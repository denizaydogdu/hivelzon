import 'dart:convert';

import 'package:hivelzon/shared/sync/sync_ids.dart';
import 'package:hivelzon/shared/sync/sync_tables.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Backend sözleşmesinin (README "API (v1)", "Eşitleme kuralları") bellek içi
/// kopyası: e-posta kodu, belirteç rotasyonu, `/me`, eşitleme itme/çekme
/// (LWW, yalnız eklenen, silme işareti, "Hi'nin kayıtlarını sil" işareti),
/// ProblemDetail hataları. Testlerde gerçek HTTP yerine [client] kullanılır.
class FakeApiServer {
  FakeApiServer({DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc());

  final DateTime Function() _clock;

  /// Gelen bütün istekler (yöntem + yol).
  final requests = <String>[];

  /// Yalnızca kullanıcı verisi taşıyan uçlara (eşitleme, hesap) gelenler.
  Iterable<String> get userDataRequests => requests.where(
    (r) => r.contains('/api/v1/sync') || r.contains('/api/v1/me'),
  );

  /// Ağ yok gibi davran (istemci `ClientException` alır).
  bool offline = false;

  int accessTtlSeconds = 900;
  int maxRowsPerPush = 500;
  final pushSizes = <int>[];

  /// İtmede bu satırı reddet (`SYNC_ROW_INVALID` + tablo ve sıra).
  bool Function(String table, Map<String, dynamic> row)? rejectRow;

  /// Verilirse itilen kart sunucuda "yeniden hesaplanır": dönen satır yazılır
  /// ve `SERVER_RECOMPUTED` çatışması döner (backend FSRS yetkisi).
  Map<String, dynamic> Function(Map<String, dynamic> card)? recomputeCard;

  // hesaplar
  final accounts = <String, _Account>{};
  final codes = <String, String>{};
  String? lastCode;
  final _refresh = <String, String>{}; // belirteç → e-posta
  final _usedRefresh = <String>{};
  final _access = <String, String>{}; // belirteç → e-posta
  var _n = 0;
  int refreshCalls = 0;

  // eşitleme verisi (tek kullanıcılı testler için hesap başına)
  final rows = <String, Map<String, Map<String, Map<String, dynamic>>>>{};
  var _seq = 0;

  MockClient get client => MockClient(_handle);

  Map<String, Map<String, Map<String, dynamic>>> dataOf(String email) =>
      rows.putIfAbsent(accounts[email]!.id, () => {});

  Future<http.Response> _handle(http.Request r) async {
    final path = r.url.path;
    requests.add('${r.method} $path');
    if (offline) throw http.ClientException('offline', r.url);
    final body = r.body.isEmpty ? null : jsonDecode(r.body);
    switch ((r.method, path)) {
      case ('POST', '/api/v1/auth/email/start'):
        final email = (body as Map)['email'] as String;
        final code = (100000 + _n++).toString();
        codes[email] = code;
        lastCode = code;
        return _json(202, {'codeValidSeconds': 600});
      case ('POST', '/api/v1/auth/email/verify'):
        return _verify(body as Map<String, dynamic>);
      case ('POST', '/api/v1/auth/refresh'):
        refreshCalls++;
        final t = (body as Map)['refreshToken'] as String;
        if (_usedRefresh.contains(t)) {
          final email = _refresh.remove(t) ?? _owner(t);
          _refresh.removeWhere((_, e) => e == email);
          _access.removeWhere((_, e) => e == email);
          return _problem(401, 'TOKEN_REUSED');
        }
        final email = _refresh[t];
        if (email == null) return _problem(401, 'REFRESH_TOKEN_INVALID');
        _usedRefresh.add(t);
        return _json(200, _tokens(email, newUser: false));
      case ('POST', '/api/v1/auth/logout'):
        _refresh.remove((body as Map)['refreshToken']);
        return http.Response('', 204);
    }
    final email =
        _access[(r.headers['Authorization'] ?? '').replaceFirst('Bearer ', '')];
    if (email == null) return _problem(401, 'UNAUTHORIZED');
    final acc = accounts[email]!;
    switch ((r.method, path)) {
      case ('GET', '/api/v1/me'):
        return _json(200, acc.me(email));
      case ('DELETE', '/api/v1/me'):
        acc.status = 'PENDING_DELETION';
        acc.purgeAt = _clock().add(const Duration(days: 30));
        _refresh.removeWhere((_, e) => e == email);
        _access.removeWhere((_, e) => e == email);
        return _json(202, {
          'status': acc.status,
          'scheduledPurgeAt': acc.purgeAt!.toIso8601String(),
        });
      case ('POST', '/api/v1/me/restore'):
        acc.status = 'ACTIVE';
        acc.purgeAt = null;
        return _json(200, acc.me(email));
    }
    if (acc.status != 'ACTIVE') {
      return _problem(403, 'ACCOUNT_PENDING_DELETION');
    }
    switch ((r.method, path)) {
      case ('POST', '/api/v1/sync/push'):
        return _push(email, body as Map<String, dynamic>);
      case ('GET', '/api/v1/sync/pull'):
        return _pull(
          email,
          int.parse(r.url.queryParameters['since'] ?? '0'),
          int.parse(r.url.queryParameters['limit'] ?? '200'),
        );
      case ('DELETE', '/api/v1/sync/speech-attempts'):
        dataOf(email).remove('speech_attempts');
        return http.Response('', 204);
    }
    return _problem(404, 'NOT_FOUND');
  }

  String? _owner(String token) => _refresh[token];

  http.Response _verify(Map<String, dynamic> b) {
    final email = b['email'] as String;
    if (codes[email] != b['code']) return _problem(400, 'OTP_INVALID');
    var acc = accounts[email];
    var created = false;
    if (acc == null) {
      final year = b['birthYear'] as int?;
      if (year == null || b['termsVersion'] == null) {
        return _problem(422, 'SIGNUP_DETAILS_REQUIRED');
      }
      if (_clock().year - year < 13) return _problem(403, 'AGE_NOT_ALLOWED');
      acc = accounts[email] = _Account(
        'u-${accounts.length + 1}-0000-0000-0000-000000000000',
        year,
      );
      created = true;
    }
    codes.remove(email);
    return _json(200, {
      ..._tokens(email, newUser: created),
      'accountStatus': acc.status,
    });
  }

  Map<String, dynamic> _tokens(String email, {required bool newUser}) {
    final a = 'acc-${_n++}';
    final rt = 'ref-${_n++}';
    _access[a] = email;
    _refresh[rt] = email;
    return {
      'tokenType': 'Bearer',
      'accessToken': a,
      'expiresIn': accessTtlSeconds,
      'refreshToken': rt,
      'refreshExpiresIn': 2592000,
      'newUser': newUser,
    };
  }

  /// Bir hesabın erişim belirteçlerini geçersiz kılar (süre doldu gibi).
  void expireAccessTokens() => _access.clear();

  // ------------------------------------------------------------ eşitleme

  http.Response _push(String email, Map<String, dynamic> body) {
    final changes = (body['changes'] as Map).cast<String, dynamic>();
    final total = changes.values.fold<int>(0, (n, l) => n + (l as List).length);
    if (total > maxRowsPerPush) return _problem(413, 'PAYLOAD_TOO_LARGE');
    if (rejectRow != null) {
      for (final e in changes.entries) {
        final list = (e.value as List).cast<Map<String, dynamic>>();
        for (var i = 0; i < list.length; i++) {
          if (rejectRow!(e.key, list[i])) {
            return _problem(400, 'SYNC_ROW_INVALID', {
              'table': e.key,
              'index': i,
            });
          }
        }
      }
    }
    // Doğrulama (hepsi ya da hiçbiri): doğal anahtar kimliği eşleşmeli.
    for (final e in changes.entries) {
      final spec = syncTablesByName[e.key];
      if (spec == null) return _problem(400, 'SYNC_ROW_INVALID');
      var i = 0;
      for (final row in (e.value as List).cast<Map<String, dynamic>>()) {
        if (spec.naturalKey) {
          final id = SyncIds.natural(spec.name, [
            for (final k in spec.keys) row[k.json] as Object,
          ]);
          if (row['clientId'] != null && row['clientId'] != id) {
            return _problem(400, 'SYNC_ROW_INVALID', {
              'table': spec.name,
              'index': i,
              'field': 'clientId',
            });
          }
        }
        for (final k in row.keys) {
          if (k.toLowerCase().contains('transcript')) {
            return _problem(400, 'TRANSCRIPT_NOT_ALLOWED');
          }
        }
        i++;
      }
    }
    pushSizes.add(total);
    final data = dataOf(email);
    final accepted = <Map<String, dynamic>>[];
    final conflicts = <Map<String, dynamic>>[];
    for (final spec in syncTables) {
      for (final row
          in ((changes[spec.name] as List?) ?? const [])
              .cast<Map<String, dynamic>>()) {
        final id = spec.naturalKey
            ? SyncIds.natural(spec.name, [
                for (final k in spec.keys) row[k.json] as Object,
              ])
            : row['clientId'] as String;
        final table = data.putIfAbsent(spec.name, () => {});
        final stored = table[id];
        if (!spec.mutable) {
          if (stored == null) {
            table[id] = {...row, 'clientId': id, '_seq': ++_seq};
          }
          accepted.add({
            'table': spec.name,
            'clientId': id,
            'result': stored == null ? 'CREATED' : 'DUPLICATE',
          });
          continue;
        }
        final incoming = DateTime.parse(row[spec.lww!.json] as String);
        final deleted = row['deleted'] == true;
        final clean = {
          ...row,
          'clientId': id,
          'deleted': deleted,
          if (deleted)
            for (final c in spec.data) c.json: null,
        };
        if (stored != null) {
          final old = DateTime.parse(stored[spec.lww!.json] as String);
          if (old.isAfter(incoming)) {
            conflicts.add({
              'table': spec.name,
              'clientId': id,
              'reason': 'STALE',
              'serverRow': _public(stored),
            });
            continue;
          }
          final same =
              spec.data.every(
                (c) => jsonEncode(stored[c.json]) == jsonEncode(clean[c.json]),
              ) &&
              stored['deleted'] == deleted &&
              !incoming.isAfter(old);
          if (same) {
            accepted.add({
              'table': spec.name,
              'clientId': id,
              'result': 'UNCHANGED',
            });
            continue;
          }
        }
        if (spec.name == 'review_cards' && !deleted && recomputeCard != null) {
          final server = {...recomputeCard!(clean), 'clientId': id};
          table[id] = {...server, '_seq': ++_seq};
          conflicts.add({
            'table': spec.name,
            'clientId': id,
            'reason': 'SERVER_RECOMPUTED',
            'serverRow': server,
          });
          continue;
        }
        table[id] = {...clean, '_seq': ++_seq};
        accepted.add({
          'table': spec.name,
          'clientId': id,
          'result': stored == null ? 'CREATED' : 'UPDATED',
        });
        if (spec.name == 'hi_records' &&
            !deleted &&
            row['kind'] == 'hi_reset') {
          _hiReset(data, incoming);
        }
      }
    }
    return _json(200, {
      'accepted': accepted,
      'conflicts': conflicts,
      'serverTime': _clock().toIso8601String(),
    });
  }

  void _hiReset(
    Map<String, Map<String, Map<String, dynamic>>> data,
    DateTime t,
  ) {
    for (final name in ['learning_events', 'speech_attempts']) {
      data[name]?.removeWhere(
        (_, r) => !DateTime.parse(r['at'] as String).isAfter(t),
      );
    }
    for (final r in (data['hi_records'] ?? const {}).values) {
      if ((r['kind'] == 'bridge_task' || r['kind'] == 'note_read') &&
          r['deleted'] != true &&
          !DateTime.parse(r['updatedAt'] as String).isAfter(t)) {
        r
          ..['deleted'] = true
          ..['status'] = null
          ..['updatedAt'] = t.toIso8601String()
          ..['_seq'] = ++_seq;
      }
    }
  }

  /// Sunucudaki satırı değiştirir (ör. başka cihazdan gelmiş gibi).
  void put(String email, String table, Map<String, dynamic> row) {
    final spec = syncTablesByName[table]!;
    final id = spec.naturalKey
        ? SyncIds.natural(table, [
            for (final k in spec.keys) row[k.json] as Object,
          ])
        : row['clientId'] as String;
    dataOf(email).putIfAbsent(table, () => {})[id] = {
      ...row,
      'clientId': id,
      if (spec.mutable) 'deleted': row['deleted'] ?? false,
      '_seq': ++_seq,
    };
  }

  static Map<String, dynamic> _public(Map<String, dynamic> r) =>
      Map.of(r)..remove('_seq');

  http.Response _pull(String email, int since, int limit) {
    final all = <(int, String, Map<String, dynamic>)>[];
    dataOf(email).forEach((table, byId) {
      for (final r in byId.values) {
        final s = r['_seq'] as int;
        if (s > since) all.add((s, table, r));
      }
    });
    all.sort((a, b) => a.$1.compareTo(b.$1));
    final page = all.take(limit).toList();
    final changes = <String, List<Map<String, dynamic>>>{};
    for (final (_, t, r) in page) {
      changes.putIfAbsent(t, () => []).add(_public(r));
    }
    return _json(200, {
      'changes': changes,
      'nextSince': page.isEmpty ? since : page.last.$1,
      'hasMore': all.length > page.length,
      'serverTime': _clock().toIso8601String(),
    });
  }

  // ------------------------------------------------------------ yardımcılar

  static http.Response _json(int status, Object body) => http.Response.bytes(
    utf8.encode(jsonEncode(body)),
    status,
    headers: {'content-type': 'application/json'},
  );

  static http.Response _problem(
    int status,
    String code, [
    Map<String, Object?> extra = const {},
  ]) => http.Response.bytes(
    utf8.encode(
      jsonEncode({
        'status': status,
        'code': code,
        'detail': 'Sunucu metni ($code).',
        ...extra,
      }),
    ),
    status,
    headers: {'content-type': 'application/problem+json'},
  );
}

class _Account {
  _Account(this.id, this.birthYear);

  final String id;
  final int birthYear;
  String status = 'ACTIVE';
  DateTime? purgeAt;

  Map<String, dynamic> me(String email) => {
    'id': id,
    'email': email,
    'birthYear': birthYear,
    'status': status,
    'scheduledPurgeAt': purgeAt?.toIso8601String(),
  };
}
