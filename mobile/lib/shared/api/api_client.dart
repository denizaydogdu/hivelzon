import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../l10n/tr_strings.dart';

/// hiVelzon API ayarları (H-038). İçerik sunucusundan (`CONTENT_BASE_URL`)
/// ayrıdır: katalog ve medya oradan, hesap ve eşitleme buradan.
class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    this.termsVersion = defaultLegalVersion,
    this.privacyNoticeVersion = defaultLegalVersion,
  });

  /// `--dart-define=API_BASE_URL=http://127.0.0.1:8080` (backend varsayılan
  /// portu `HIVELZON_PORT` = 8080).
  factory ApiConfig.fromEnvironment() => ApiConfig(
    baseUrl: Uri.parse(
      const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://127.0.0.1:8080',
      ),
    ),
    termsVersion: const String.fromEnvironment(
      'TERMS_VERSION',
      defaultValue: defaultLegalVersion,
    ),
    privacyNoticeVersion: const String.fromEnvironment(
      'PRIVACY_NOTICE_VERSION',
      defaultValue: defaultLegalVersion,
    ),
  );

  /// Hukuk metinlerinin taslak sürümü (backend `HIVELZON_TERMS_VERSION`
  /// varsayılanı; gerçek metinler H-042).
  static const defaultLegalVersion = 'taslak-1';

  final Uri baseUrl;
  final String termsVersion;
  final String privacyNoticeVersion;
}

/// API hatası. [code] makine kodu (`OTP_INVALID`, `NETWORK` …), [message]
/// kullanıcıya gösterilebilir Türkçe metin.
class ApiException implements Exception {
  ApiException({
    required this.code,
    required this.status,
    required this.message,
    this.retryAfter,
    this.properties = const {},
  });

  factory ApiException.network() => ApiException(
    code: networkCode,
    status: 0,
    message: AccountTexts.errorFor(networkCode),
  );

  static const networkCode = 'NETWORK';

  final String code;

  /// HTTP durumu; ağ hatasında 0.
  final int status;
  final String message;
  final Duration? retryAfter;

  /// Problem gövdesindeki ek alanlar (`table`, `index`, `field`).
  final Map<String, Object?> properties;

  bool get isNetwork => code == networkCode;

  @override
  String toString() => 'ApiException($status $code)';
}

class ApiResponse {
  const ApiResponse(this.status, this.json, this.headers);

  final int status;
  final Object? json;
  final Map<String, String> headers;

  Map<String, dynamic> get map => (json as Map).cast<String, dynamic>();
}

/// İnce JSON istemcisi: zaman aşımı, ağ hatalarında geri çekilmeli yeniden
/// deneme (yalnızca [retryNetwork] işaretli, tekrarı güvenli isteklerde),
/// ProblemDetail → [ApiException].
///
/// Loglara gövde, belirteç ya da e-posta yazılmaz.
class ApiClient {
  ApiClient({
    required http.Client client,
    required Uri baseUrl,
    this.timeout = const Duration(seconds: 15),
    this.retryDelays = const [
      Duration(milliseconds: 500),
      Duration(seconds: 1),
      Duration(seconds: 2),
    ],
    Future<void> Function(Duration)? sleep,
  }) : _client = client,
       _base = baseUrl,
       _sleep = sleep ?? Future<void>.delayed;

  final http.Client _client;
  final Uri _base;
  final Duration timeout;
  final List<Duration> retryDelays;
  final Future<void> Function(Duration) _sleep;

  Uri uri(String path, [Map<String, String>? query]) {
    final basePath = _base.path.endsWith('/')
        ? _base.path.substring(0, _base.path.length - 1)
        : _base.path;
    return _base.replace(
      path: '$basePath$path',
      queryParameters: query == null || query.isEmpty ? null : query,
    );
  }

  Future<ApiResponse> send(
    String method,
    String path, {
    Object? body,
    Map<String, String>? query,
    String? bearer,
    bool retryNetwork = false,
  }) async {
    var attempt = 0;
    while (true) {
      try {
        return await _once(method, path, body, query, bearer);
      } on ApiException catch (e) {
        if (!e.isNetwork || !retryNetwork || attempt >= retryDelays.length) {
          rethrow;
        }
        await _sleep(retryDelays[attempt++]);
      }
    }
  }

  Future<ApiResponse> _once(
    String method,
    String path,
    Object? body,
    Map<String, String>? query,
    String? bearer,
  ) async {
    final request = http.Request(method, uri(path, query))
      ..headers['Accept'] = 'application/json, application/problem+json';
    if (bearer != null) request.headers['Authorization'] = 'Bearer $bearer';
    if (body != null) {
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      request.bodyBytes = utf8.encode(jsonEncode(body));
    }
    http.Response response;
    try {
      response = await http.Response.fromStream(
        await _client.send(request).timeout(timeout),
      ).timeout(timeout);
    } on TimeoutException {
      throw ApiException.network();
    } on SocketException {
      throw ApiException.network();
    } on HandshakeException {
      throw ApiException.network();
    } on http.ClientException {
      throw ApiException.network();
    }
    Object? json;
    if (response.bodyBytes.isNotEmpty) {
      try {
        json = jsonDecode(utf8.decode(response.bodyBytes));
      } on FormatException {
        json = null;
      }
    }
    if (response.statusCode >= 400) {
      throw _problem(response, json);
    }
    return ApiResponse(response.statusCode, json, response.headers);
  }

  static ApiException _problem(http.Response r, Object? json) {
    final map = json is Map ? json.cast<String, Object?>() : const {};
    final code = map['code'] is String
        ? map['code']! as String
        : 'HTTP_${r.statusCode}';
    final retry = int.tryParse(r.headers['retry-after'] ?? '');
    return ApiException(
      code: code,
      status: r.statusCode,
      message: AccountTexts.errorFor(code, fallback: map['detail'] as String?),
      retryAfter: retry == null ? null : Duration(seconds: retry),
      properties: {
        for (final k in const ['table', 'index', 'field'])
          if (map.containsKey(k)) k: map[k],
      },
    );
  }
}
