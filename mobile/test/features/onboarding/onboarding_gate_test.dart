import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:hivelzon/features/onboarding/data/onboarding_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

// H-039: açılış kapısı okuması sürerken kapsayıcı kapanabilir (test bitişi,
// ekran kapanışı). `_check` döndüğünde `state` yazmaya çalışırsa Riverpod
// "Ref after dispose" hatası verir; guard bunu engeller.
void main() {
  test('okuma sürerken kapsayıcı kapanırsa durum yazılmaz', () async {
    final db = AppDatabase.memory();
    final ready = Completer<void>();
    final container = ProviderContainer(
      overrides: [
        onboardingStoreProvider.overrideWithValue(
          OnboardingStore(db, ready: ready.future),
        ),
      ],
    );
    addTearDown(db.close);

    // Okumayı başlat, kapsayıcıyı okuma bitmeden kapat.
    container.read(onboardingGateProvider);
    container.dispose();
    ready.complete();

    // Bekleyen okuma tamamlanınca hata fırlatılmamalı.
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });
}
