import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Oturum belirteçleri (H-038). Erişim belirteci kısa ömürlüdür (15 dk),
/// yenileme belirteci her kullanımda değişir (rotasyon).
class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.accessExpiresAt,
    required this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> j) => AuthTokens(
    accessToken: j['a'] as String,
    accessExpiresAt: DateTime.parse(j['e'] as String).toUtc(),
    refreshToken: j['r'] as String,
  );

  /// `/auth/email/verify` ve `/auth/refresh` cevabından.
  factory AuthTokens.fromResponse(Map<String, dynamic> j, DateTime now) =>
      AuthTokens(
        accessToken: j['accessToken'] as String,
        accessExpiresAt: now.toUtc().add(
          Duration(seconds: (j['expiresIn'] as num).toInt()),
        ),
        refreshToken: j['refreshToken'] as String,
      );

  final String accessToken;
  final DateTime accessExpiresAt;
  final String refreshToken;

  Map<String, dynamic> toJson() => {
    'a': accessToken,
    'e': accessExpiresAt.toUtc().toIso8601String(),
    'r': refreshToken,
  };

  @override
  String toString() => 'AuthTokens(***)';
}

/// Belirteç deposu. Üretimde iOS Anahtar Zinciri / Android Keystore
/// ([SecureTokenStore]); testlerde [MemoryTokenStore].
abstract interface class TokenStore {
  Future<AuthTokens?> read();

  /// İki belirteç tek kayıtta yazılır (yarım rotasyon kalmaz).
  Future<void> write(AuthTokens tokens);

  Future<void> clear();
}

class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              // Yedeğe ve başka cihaza taşınmaz; ilk kilit açılışından sonra
              // arka planda da okunabilir.
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  static const _key = 'hivelzon.auth.v1';
  final FlutterSecureStorage _storage;

  @override
  Future<AuthTokens?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    try {
      return AuthTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(AuthTokens tokens) =>
      _storage.write(key: _key, value: jsonEncode(tokens.toJson()));

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

class MemoryTokenStore implements TokenStore {
  AuthTokens? tokens;

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> write(AuthTokens t) async => tokens = t;

  @override
  Future<void> clear() async => tokens = null;
}
