import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/shared/api/api_client.dart';
import 'package:hivelzon/shared/api/auth_service.dart';
import 'package:hivelzon/shared/api/token_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/sync/sync_engine.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import 'fake_api_server.dart';

/// Test saati: elle ilerletilir.
class TestClock {
  TestClock([DateTime? start]) : now = start ?? DateTime.utc(2026, 10, 13, 9);

  DateTime now;

  DateTime call() => now;

  void advance(Duration d) => now = now.add(d);
}

/// Bir "cihaz": kendi veritabanı, belirteç deposu ve eşitleme motoru; sunucu
/// ortak ([FakeApiServer]).
class Device {
  Device(this.server, this.clock, {int maxRows = 500})
    : db = AppDatabase.memory(),
      tokens = MemoryTokenStore() {
    store = SyncStore(db, clock: clock.call);
    api = ApiClient(
      client: server.client,
      baseUrl: Uri.parse('http://127.0.0.1:8080'),
      sleep: (_) async {},
    );
    auth = AuthService(
      api: api,
      tokens: tokens,
      store: store,
      clock: clock.call,
    );
    engine = SyncEngine(store: store, auth: auth, maxRows: maxRows);
  }

  final FakeApiServer server;
  final TestClock clock;
  final AppDatabase db;
  final MemoryTokenStore tokens;
  late final SyncStore store;
  late final ApiClient api;
  late final AuthService auth;
  late final SyncEngine engine;

  /// Kodla giriş (hesap yoksa açılır, 2000 doğumlu).
  Future<VerifyResult> signIn(String email) async {
    await auth.startEmail(email);
    final code = server.lastCode!;
    final r = await auth.verify(email, code);
    if (r.status != VerifyStatus.signupRequired) return r;
    return auth.verify(
      email,
      code,
      signup: const SignupDetails(
        birthYear: 2000,
        termsVersion: 'taslak-1',
        privacyNoticeVersion: 'taslak-1',
      ),
    );
  }

  Future<void> close() async {
    await auth.dispose();
    await db.close();
  }
}

NotebookItem phrase(String en, {DateTime? at}) => NotebookItem(
  kind: NotebookKind.phrase,
  textEn: en,
  textTr: 'tr',
  contentId: 'A1-001',
  source: NotebookSource.userSaved,
  createdAt: at ?? DateTime.utc(2026, 10, 13, 8),
);
