import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/api/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

ApiClient _client(
  MockClientHandler handler, {
  List<Duration>? slept,
  Duration timeout = const Duration(seconds: 15),
}) => ApiClient(
  client: MockClient(handler),
  baseUrl: Uri.parse('http://127.0.0.1:8080'),
  timeout: timeout,
  sleep: (d) async => slept?.add(d),
);

http.Response _problem(
  int status,
  String code, {
  Map<String, String>? headers,
}) => http.Response.bytes(
  utf8.encode(
    jsonEncode({
      'code': code,
      'detail': 'Sunucu: $code',
      'table': 'clues',
      'index': 2,
    }),
  ),
  status,
  headers: {'content-type': 'application/problem+json', ...?headers},
);

void main() {
  test('ProblemDetail → kodlu hata, Türkçe metin, Retry-After, yer', () async {
    final api = _client(
      (r) async =>
          _problem(429, 'RATE_LIMITED', headers: {'retry-after': '42'}),
    );
    final e = await api
        .send('POST', '/api/v1/auth/email/start', body: {'email': 'a@b.co'})
        .then<ApiException?>(
          (_) => null,
          onError: (Object e) => e as ApiException,
        );
    expect(e!.code, 'RATE_LIMITED');
    expect(e.status, 429);
    expect(e.message, AccountTexts.errorFor('RATE_LIMITED'));
    expect(e.retryAfter, const Duration(seconds: 42));
    expect(e.properties, {'table': 'clues', 'index': 2});
  });

  test(
    'bilinmeyen kod: sunucunun Türkçe metni; gövdesiz: genel metin',
    () async {
      var e = await _client((r) async => _problem(409, 'SOMETHING_NEW'))
          .send('GET', '/x')
          .then<ApiException?>(
            (_) => null,
            onError: (Object e) => e as ApiException,
          );
      expect(e!.message, 'Sunucu: SOMETHING_NEW');
      e = await _client((r) async => http.Response('', 500))
          .send('GET', '/x')
          .then<ApiException?>(
            (_) => null,
            onError: (Object e) => e as ApiException,
          );
      expect(e!.code, 'HTTP_500');
      expect(e.message, AccountTexts.errorFor('HTTP_500'));
    },
  );

  test('Türkçe metinler: kod hataları suçlamasız', () {
    for (final code in [
      'OTP_INVALID',
      'OTP_EXPIRED',
      'OTP_TOO_MANY_ATTEMPTS',
      'AGE_NOT_ALLOWED',
      'TOKEN_REUSED',
      'NETWORK',
    ]) {
      final m = AccountTexts.errorFor(code).toLowerCase();
      expect(m, isNot(contains('yanlış')), reason: code);
      expect(m, isNot(contains('hata')), reason: code);
      expect(m, isNot(contains('sunucu')), reason: code);
    }
    expect(
      AccountTexts.errorFor('AGE_NOT_ALLOWED'),
      'Hesap açmak için en az 13 yaşında olmalısın; uygulamanın tamamını '
      'hesapsız kullanabilirsin.',
    );
  });

  test(
    'ağ hatası: yalnızca işaretli istekte geri çekilerek yeniden denenir',
    () async {
      var calls = 0;
      final slept = <Duration>[];
      final api = _client((r) async {
        calls++;
        if (calls < 3) throw http.ClientException('down');
        return http.Response('{"ok":true}', 200);
      }, slept: slept);
      final r = await api.send('GET', '/api/v1/sync/pull', retryNetwork: true);
      expect(r.map['ok'], isTrue);
      expect(calls, 3);
      expect(slept, [
        const Duration(milliseconds: 500),
        const Duration(seconds: 1),
      ]);

      // İşaretsiz (ör. kod doğrulama, belirteç yenileme): tek deneme.
      calls = 0;
      final once = _client((r) async {
        calls++;
        throw http.ClientException('down');
      });
      final e = await once
          .send('POST', '/api/v1/auth/refresh')
          .then<ApiException?>(
            (_) => null,
            onError: (Object e) => e as ApiException,
          );
      expect(e!.isNetwork, isTrue);
      expect(e.message, AccountTexts.errorFor('NETWORK'));
      expect(calls, 1);
    },
  );

  test('sunucu hatası yeniden denenmez; zaman aşımı ağ hatasıdır', () async {
    var calls = 0;
    final api = _client((r) async {
      calls++;
      return _problem(400, 'SYNC_ROW_INVALID');
    });
    await expectLater(
      api.send('POST', '/api/v1/sync/push', retryNetwork: true),
      throwsA(isA<ApiException>()),
    );
    expect(calls, 1);

    final slow = _client(
      (r) => Future.delayed(
        const Duration(milliseconds: 200),
        () => http.Response('{}', 200),
      ),
      timeout: const Duration(milliseconds: 20),
    );
    final e = await slow
        .send('GET', '/x')
        .then<ApiException?>(
          (_) => null,
          onError: (Object e) => e as ApiException,
        );
    expect(e!.code, ApiException.networkCode);
  });

  test('istek: JSON gövde, Bearer, sorgu; taban yolu korunur', () async {
    late http.Request seen;
    final api = ApiClient(
      client: MockClient((r) async {
        seen = r;
        return http.Response('{}', 200);
      }),
      baseUrl: Uri.parse('http://127.0.0.1:8080/'),
    );
    await api.send(
      'POST',
      '/api/v1/sync/push',
      body: {'changes': {}},
      bearer: 'tok',
      query: {'since': '3'},
    );
    expect(
      seen.url.toString(),
      'http://127.0.0.1:8080/api/v1/sync/push?since=3',
    );
    expect(seen.headers['Authorization'], 'Bearer tok');
    expect(seen.headers['Content-Type'], startsWith('application/json'));
    expect(jsonDecode(seen.body), {'changes': {}});
  });
}
