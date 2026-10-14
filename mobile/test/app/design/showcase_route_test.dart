import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/router.dart';

void main() {
  test('vitrin yolu /tasarim yalnız debug derlemede (testler debug)', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider);
    final paths = router.configuration.routes.whereType<GoRoute>().map(
      (r) => r.path,
    );
    expect(paths, contains(AppRoutes.designShowcase));
  });
}
