import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/shared/api/auth_service.dart';
import 'package:hivelzon/shared/api/token_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';

import '../../support/fake_api_server.dart';

void main() {
  late AppDatabase db;
  late FakeApiServer server;

  setUp(() {
    db = AppDatabase.memory();
    server = FakeApiServer();
    SyncController.listenLifecycle = false;
  });
  tearDown(() async {
    SyncController.listenLifecycle = true;
    await db.close();
  });

  test('hesap açıkken ilk kez oluşturulan denetleyici hata vermez '
      '(durum build bitmeden yazılmaz)', () async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        apiHttpClientProvider.overrideWithValue(server.client),
        tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
      ],
    );
    addTearDown(container.dispose);

    await SyncStore(db).signIn(
      userId: 'u-1-0000-0000-0000-000000000000',
      emailMasked: 'a***@example.com',
      status: AccountStatus.active,
    );
    // Hesap durumu önceden yüklü: dinleyici build içinde hemen tetiklenir.
    final sub = container.listen(accountStateProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(accountStateProvider.future);

    expect(() => container.read(syncControllerProvider), returnsNormally);
    // İlk eşitleme turu build bittikten sonra başlar.
    await Future<void>.delayed(Duration.zero);
    expect(container.read(syncControllerProvider).dataVersion, 0);
  });
}
