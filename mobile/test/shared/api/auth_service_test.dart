import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/shared/api/api_client.dart';
import 'package:hivelzon/shared/api/auth_service.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fake_api_server.dart';
import '../../support/sync_harness.dart';

void main() {
  late FakeApiServer server;
  late TestClock clock;
  late Device d;

  setUp(() {
    clock = TestClock();
    server = FakeApiServer(clock: clock.call);
    d = Device(server, clock);
  });
  tearDown(() => d.close());

  Future<String?> me() => d.auth.authorized(
    (b) async =>
        (await d.api.send('GET', '/api/v1/me', bearer: b)).map['id'] as String?,
  );

  test('yeni e-posta: önce kayıt bilgisi istenir, kod harcanmaz', () async {
    await d.auth.startEmail('deniz@example.com');
    final code = server.lastCode!;
    final r = await d.auth.verify('deniz@example.com', code);
    expect(r.status, VerifyStatus.signupRequired);
    expect(d.tokens.tokens, isNull);
    expect(await d.store.signedIn(), isFalse);
    final ok = await d.auth.verify(
      'deniz@example.com',
      code,
      signup: const SignupDetails(
        birthYear: 2001,
        termsVersion: 'taslak-1',
        privacyNoticeVersion: 'taslak-1',
      ),
    );
    expect(ok.status, VerifyStatus.signedIn);
    expect(ok.newUser, isTrue);
    final s = await d.store.state();
    expect(s.accountUserId, isNotNull);
    expect(s.emailMasked, 'd•••@example.com');
    expect(d.tokens.tokens, isNotNull);
  });

  test('13 yaş altı: AGE_NOT_ALLOWED, oturum açılmaz', () async {
    await d.auth.startEmail('kid@example.com');
    final e = await d.auth
        .verify(
          'kid@example.com',
          server.lastCode!,
          signup: const SignupDetails(
            birthYear: 2016,
            termsVersion: 'taslak-1',
            privacyNoticeVersion: 'taslak-1',
          ),
        )
        .then<ApiException?>(
          (_) => null,
          onError: (Object e) => e as ApiException,
        );
    expect(e!.code, 'AGE_NOT_ALLOWED');
    expect(await d.store.signedIn(), isFalse);
    expect(ageAllowed(2013, DateTime.utc(2026)), isTrue);
    expect(ageAllowed(2014, DateTime.utc(2026)), isFalse);
  });

  test('süresi dolan erişim belirteci önce yenilenir (rotasyon)', () async {
    await d.signIn('deniz@example.com');
    final first = d.tokens.tokens!;
    clock.advance(const Duration(minutes: 20));
    expect(await me(), isNotNull);
    expect(server.refreshCalls, 1);
    final second = d.tokens.tokens!;
    expect(second.refreshToken, isNot(first.refreshToken));
    expect(second.accessToken, isNot(first.accessToken));
  });

  test(
    '401: bir kez yenilenip yeniden denenir; eşzamanlı istekler tek yenileme',
    () async {
      await d.signIn('deniz@example.com');
      server.expireAccessTokens();
      expect(await me(), isNotNull);
      expect(server.refreshCalls, 1);
      clock.advance(const Duration(minutes: 20));
      final results = await Future.wait([me(), me(), me()]);
      expect(results, everyElement(isNotNull));
      expect(server.refreshCalls, 2);
    },
  );

  test(
    'TOKEN_REUSED: oturum cihazda kapanır, veri kalır, neden duyurulur',
    () async {
      await NotebookStore(
        d.db,
        clock: clock.call,
      ).addItems([phrase('Keep me.')]);
      await d.signIn('deniz@example.com');
      final stolen = d.tokens.tokens!;
      clock.advance(const Duration(minutes: 20));
      await me(); // rotasyon: eski yenileme belirteci kullanıldı
      // Eski belirteç hoşgörü süresinden (30 sn, H-056) sonra yeniden
      // kullanılırsa (ör. kopyalanmış) aile iptal edilir.
      clock.advance(const Duration(seconds: 31));
      await d.tokens.write(stolen);
      final reasons = <String>[];
      final sub = d.auth.forcedSignOuts.listen(reasons.add);
      final e = await me().then<ApiException?>(
        (_) => null,
        onError: (Object e) => e as ApiException,
      );
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(e!.code, 'TOKEN_REUSED');
      expect(reasons, ['TOKEN_REUSED']);
      expect(await d.store.signedIn(), isFalse);
      expect((await d.store.state()).signedOutReason, 'TOKEN_REUSED');
      expect(d.tokens.tokens, isNull);
      expect(await NotebookStore(d.db).entries(), hasLength(1));
    },
  );

  test('H-056: yenileme cevabı yolda kaybolursa yeniden denenir; aynı yeni '
      'anahtar gelir, oturum düşmez', () async {
    await d.signIn('deniz@example.com');
    final first = d.tokens.tokens!;
    clock.advance(const Duration(minutes: 20));
    server.dropNextRefreshResponse = true;
    expect(await me(), isNotNull);
    expect(server.refreshCalls, 2);
    expect(await d.store.signedIn(), isTrue);
    final second = d.tokens.tokens!;
    expect(second.refreshToken, isNot(first.refreshToken));
    // Yeni anahtar çalışır (aile iptal edilmedi).
    clock.advance(const Duration(minutes: 20));
    expect(await me(), isNotNull);
    expect(d.tokens.tokens!.refreshToken, isNot(second.refreshToken));
  });

  test('H-056: 30 sn içinde aynı eski anahtar → aynı yeni anahtar; '
      'sonra çalıntı koruması', () async {
    await d.signIn('deniz@example.com');
    final old = d.tokens.tokens!;
    clock.advance(const Duration(minutes: 20));
    expect(await me(), isNotNull);
    final successor = d.tokens.tokens!.refreshToken;
    // Aynı eski anahtar 10 sn sonra (ör. ikinci istek): aynı yeni anahtar.
    clock.advance(const Duration(seconds: 10));
    await d.tokens.write(old);
    expect(await me(), isNotNull);
    expect(d.tokens.tokens!.refreshToken, successor);
    expect(await d.store.signedIn(), isTrue);
    // 30 sn geçtikten sonra: TOKEN_REUSED, oturum kapanır.
    clock.advance(const Duration(seconds: 25));
    await d.tokens.write(old);
    final e = await me().then<ApiException?>(
      (_) => null,
      onError: (Object e) => e as ApiException,
    );
    expect(e!.code, 'TOKEN_REUSED');
    expect(await d.store.signedIn(), isFalse);
  });

  test('hesap silme ve kodla girişte geri alma', () async {
    await d.signIn('deniz@example.com');
    final purge = await d.auth.deleteAccount();
    expect(purge, clock.now.add(const Duration(days: 30)));
    expect(await d.store.signedIn(), isFalse);
    final r = await d.signIn('deniz@example.com');
    expect(r.status, VerifyStatus.pendingDeletion);
    expect(
      (await d.store.state()).accountStatus,
      AccountStatus.pendingDeletion,
    );
    // Silinmek üzereyken eşitleme denenmez.
    expect((await d.engine.sync()).ok, isFalse);
    await d.auth.restore();
    expect((await d.store.state()).accountStatus, AccountStatus.active);
    expect((await d.engine.sync()).ok, isTrue);
  });

  group('silme bekliyor işareti (H-042; çıkıştan sonra da görünür)', () {
    test('silince yazılır (e-posta yok), geri alınca silinir', () async {
      await d.signIn('deniz@example.com');
      final userId = (await d.store.state()).accountUserId;
      final purge = await d.auth.deleteAccount();
      final m = await d.store.pendingDeletion();
      expect(m, isNotNull);
      expect(m!.purgeAt, purge);
      expect(m.userId, userId);
      // Cihazda e-posta tutulmaz (maskeli bile).
      final meta = await d.db.select(d.db.appMeta).get();
      expect(
        meta.where((r) => r.value.contains('example.com')),
        isEmpty,
        reason: meta.map((r) => '${r.key}=${r.value}').join(', '),
      );
      final r = await d.signIn('deniz@example.com');
      expect(r.status, VerifyStatus.pendingDeletion);
      expect(await d.store.pendingDeletion(), isNotNull);
      await d.auth.restore();
      expect(await d.store.pendingDeletion(), isNull);
    });

    test('geri almadan çıkınca işaret kalır', () async {
      await d.signIn('deniz@example.com');
      await d.auth.deleteAccount();
      await d.signIn('deniz@example.com');
      await d.auth.signOut();
      expect(await d.store.pendingDeletion(), isNotNull);
    });

    test('kalıcı silme tarihi geçince işaret kendiliğinden silinir', () async {
      await d.signIn('deniz@example.com');
      await d.auth.deleteAccount();
      clock.advance(const Duration(days: 30, seconds: 1));
      expect(await d.store.pendingDeletion(), isNull);
      final meta = await d.db.select(d.db.appMeta).get();
      expect(
        meta.map((r) => r.key),
        isNot(contains(SyncStore.pendingDeletionKey)),
      );
    });

    test('aynı hesap başka cihazda geri alındıysa girişte silinir; başka '
        'hesapla girişte kalır', () async {
      await d.signIn('deniz@example.com');
      await d.auth.deleteAccount();
      await d.signIn('ayse@example.com');
      expect(await d.store.pendingDeletion(), isNotNull);
      await d.auth.signOut();
      // Deniz'in hesabı başka cihazda geri alındı.
      final other = Device(server, clock);
      addTearDown(other.close);
      await other.signIn('deniz@example.com');
      await other.auth.restore();
      await d.signIn('deniz@example.com');
      expect(await d.store.pendingDeletion(), isNull);
    });
  });
}
