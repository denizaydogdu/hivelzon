import 'dart:async';

import 'package:drift/drift.dart' show Value;

import '../storage/app_database.dart';

import '../sync/sync_store.dart';
import 'api_client.dart';
import 'token_store.dart';

/// Hesap durumu kodları (`/me` → `status`).
abstract final class AccountStatus {
  static const active = 'ACTIVE';
  static const pendingDeletion = 'PENDING_DELETION';
}

/// Yeni hesap için bilgiler (H-002: 13+; yalnızca doğum yılı).
class SignupDetails {
  const SignupDetails({
    required this.birthYear,
    required this.termsVersion,
    required this.privacyNoticeVersion,
    this.displayName,
    this.marketing = false,
  });

  final int birthYear;
  final String termsVersion;
  final String privacyNoticeVersion;
  final String? displayName;
  final bool marketing;
}

enum VerifyStatus {
  /// Giriş ya da kayıt tamam; hesap etkin.
  signedIn,

  /// Hesap yok: doğum yılı ve onaylar gerekiyor (kod harcanmadı).
  signupRequired,

  /// Hesap silinmek üzere: geri alma sorulur.
  pendingDeletion,
}

class VerifyResult {
  const VerifyResult(this.status, {this.newUser = false, this.purgeAt});

  final VerifyStatus status;
  final bool newUser;
  final DateTime? purgeAt;
}

/// `d•••@example.com`: açık e-posta cihazda saklanmaz (gösterim için).
String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 0) return '•••';
  return '${email.substring(0, 1)}•••${email.substring(at)}';
}

/// Takvim yılına göre yaş (backend `Ages`: bu yıl − doğum yılı).
bool ageAllowed(int birthYear, DateTime now, {int minimum = 13}) =>
    now.toUtc().year - birthYear >= minimum;

/// Oturum ve kimlikli istekler (H-038): e-posta kodu, belirteç yenileme
/// (rotasyon), çıkış, hesap silme ve geri alma.
///
/// - Erişim belirtecinin süresi dolmak üzereyse önce yenilenir; `401` gelirse
///   bir kez yenilenip yeniden denenir. Yenileme tek seferde bir kez yapılır
///   (eşzamanlı istekler aynı yenilemeyi bekler).
/// - Yenileme isteği **yeniden denenmez**: kullanılmış belirteç yeniden
///   gönderilirse sunucu bütün oturumu kapatır (`TOKEN_REUSED`).
/// - `TOKEN_REUSED` / `REFRESH_TOKEN_INVALID`: oturum bu cihazda kapanır,
///   veri cihazda kalır, neden [forcedSignOuts] ile duyurulur.
class AuthService {
  AuthService({
    required this.api,
    required this.tokens,
    required this.store,
    DateTime Function()? clock,
  }) : _clock = clock ?? (() => DateTime.now().toUtc());

  final ApiClient api;
  final TokenStore tokens;
  final SyncStore store;
  final DateTime Function() _clock;

  final _forced = StreamController<String>.broadcast();
  Future<AuthTokens>? _refreshing;

  /// Oturum cihazda kapatıldı (neden kodu).
  Stream<String> get forcedSignOuts => _forced.stream;

  DateTime now() => _clock().toUtc();

  /// Kod gönderir; kodun geçerlilik süresi (sn).
  Future<int> startEmail(String email) async {
    final r = await api.send(
      'POST',
      '/api/v1/auth/email/start',
      body: {'email': email.trim()},
    );
    return (r.map['codeValidSeconds'] as num?)?.toInt() ?? 600;
  }

  /// Kodu doğrular. Hesap yoksa ve [signup] verilmediyse
  /// [VerifyStatus.signupRequired] döner (kod harcanmaz).
  Future<VerifyResult> verify(
    String email,
    String code, {
    SignupDetails? signup,
  }) async {
    final ApiResponse r;
    try {
      r = await api.send(
        'POST',
        '/api/v1/auth/email/verify',
        body: {
          'email': email.trim(),
          'code': code,
          if (signup != null) ...{
            'birthYear': signup.birthYear,
            'termsVersion': signup.termsVersion,
            'privacyNoticeVersion': signup.privacyNoticeVersion,
            'marketing': signup.marketing,
            if (signup.displayName != null) 'displayName': signup.displayName,
          },
        },
      );
    } on ApiException catch (e) {
      if (e.code == 'SIGNUP_DETAILS_REQUIRED') {
        return const VerifyResult(VerifyStatus.signupRequired);
      }
      rethrow;
    }
    final body = r.map;
    final t = AuthTokens.fromResponse(body, now());
    await tokens.write(t);
    final me = await _me(t.accessToken);
    final status = me['status'] as String? ?? AccountStatus.active;
    final purge = DateTime.tryParse('${me['scheduledPurgeAt']}')?.toUtc();
    await store.signIn(
      userId: me['id'] as String,
      emailMasked: maskEmail(me['email'] as String? ?? email),
      status: status,
      scheduledPurgeAt: purge,
    );
    return VerifyResult(
      status == AccountStatus.pendingDeletion
          ? VerifyStatus.pendingDeletion
          : VerifyStatus.signedIn,
      newUser: body['newUser'] == true,
      purgeAt: purge,
    );
  }

  Future<Map<String, dynamic>> _me(String bearer) async => (await api.send(
    'GET',
    '/api/v1/me',
    bearer: bearer,
    retryNetwork: true,
  )).map;

  /// Silinmek üzere olan hesabı geri alır (kodla yeni girişten sonra).
  Future<void> restore() async {
    await authorized((b) => api.send('POST', '/api/v1/me/restore', bearer: b));
    await store.update(
      const SyncStateCompanion(accountStatus: Value(AccountStatus.active)),
    );
  }

  /// Hesap silme isteği (30 gün geri alınabilir). Sunucu bütün oturumları
  /// kapatır; bu cihazda da oturum kapanır, veri cihazda kalır.
  Future<DateTime?> deleteAccount() async {
    final r = await authorized(
      (b) => api.send('DELETE', '/api/v1/me', bearer: b),
    );
    await _localSignOut(null);
    return DateTime.tryParse('${r.map['scheduledPurgeAt']}')?.toUtc();
  }

  /// Çıkış: sunucudaki oturum kapatılmaya çalışılır (bağlantı yoksa da
  /// cihazda kapanır).
  Future<void> signOut() async {
    final t = await tokens.read();
    if (t != null) {
      try {
        await api.send(
          'POST',
          '/api/v1/auth/logout',
          body: {'refreshToken': t.refreshToken},
        );
      } on ApiException {
        // Oturum sunucuda 30 gün sonra kendiliğinden düşer.
      }
    }
    await _localSignOut(null);
  }

  Future<void> _localSignOut(String? reason) async {
    await tokens.clear();
    await store.signOut(reason: reason);
  }

  /// Kimlikli istek: belirteci gerekirse yeniler, `401`'de bir kez yeniden
  /// dener. Oturum yoksa `SIGNED_OUT` hatası.
  Future<T> authorized<T>(Future<T> Function(String bearer) call) async {
    var t = await tokens.read();
    if (t == null) {
      throw ApiException(
        code: 'SIGNED_OUT',
        status: 401,
        message: AccountTextsFallback.signedOut,
      );
    }
    if (!t.accessExpiresAt.isAfter(now().add(const Duration(seconds: 30)))) {
      t = await _refresh(t);
    }
    try {
      return await call(t.accessToken);
    } on ApiException catch (e) {
      if (e.status == 401 && e.code == 'UNAUTHORIZED') {
        final fresh = await _refresh(t);
        return call(fresh.accessToken);
      }
      if (e.code == 'ACCOUNT_PENDING_DELETION') {
        await store.update(
          const SyncStateCompanion(
            accountStatus: Value(AccountStatus.pendingDeletion),
          ),
        );
      }
      rethrow;
    }
  }

  Future<AuthTokens> _refresh(AuthTokens old) {
    return _refreshing ??= () async {
      try {
        // Başka bir istek az önce yenilediyse yenisi kullanılır.
        final current = await tokens.read();
        if (current != null && current.refreshToken != old.refreshToken) {
          return current;
        }
        // Bağlantı koptuysa aynı anahtarla yeniden denenir: sunucu, az önce
        // yenilenmiş anahtar 30 sn içinde tekrar gelirse aynı yeni anahtarı
        // döner (H-056); cevap yolda kaybolsa da oturum düşmez.
        final r = await api.send(
          'POST',
          '/api/v1/auth/refresh',
          body: {'refreshToken': old.refreshToken},
          retryNetwork: true,
        );
        final fresh = AuthTokens.fromResponse(r.map, now());
        await tokens.write(fresh);
        return fresh;
      } on ApiException catch (e) {
        if (e.code == 'TOKEN_REUSED' || e.code == 'REFRESH_TOKEN_INVALID') {
          await _localSignOut(e.code);
          _forced.add(e.code);
        }
        rethrow;
      } finally {
        _refreshing = null;
      }
    }();
  }

  Future<void> dispose() => _forced.close();
}

/// Oturum yokken kimlikli istek denenirse (arayüzde görünmez).
abstract final class AccountTextsFallback {
  static const signedOut = 'Bu işlem için giriş yapman gerekiyor.';
}
