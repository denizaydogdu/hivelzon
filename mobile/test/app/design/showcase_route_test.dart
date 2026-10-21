import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

void main() {
  test('vitrin yolu /tasarim yalnız debug derlemede (testler debug)', () {
    // Yönlendirici açılış kapısını dinler; kapı veritabanını okur. Bellekteki
    // veritabanı verilmezse gerçek dosya açılmaya çalışılır (path_provider
    // testte yok) ve hata test bittikten sonra düşer (aralıklı başarısızlık).
    final db = AppDatabase.memory();
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });
    final router = container.read(routerProvider);
    final paths = router.configuration.routes.whereType<GoRoute>().map(
      (r) => r.path,
    );
    expect(paths, contains(AppRoutes.designShowcase));
  });
}
