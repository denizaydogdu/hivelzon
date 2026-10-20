import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/storage/storage_providers.dart';
import '../data/onboarding_store.dart';
import '../domain/placement.dart';

final onboardingStoreProvider = Provider<OnboardingStore>(
  (ref) => OnboardingStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// Açılış kapısının durumu (yönlendirme bunu dinler).
/// - [checking]: kayıt okunuyor (kısa; açılış ekranı boş zemin gösterir);
/// - [needed]: ilk açılış, açılış gösterilir;
/// - [done]: açılış bitmiş ya da bu cihazda önceden kullanım var.
enum OnboardingGate { checking, needed, done }

class OnboardingGateNotifier extends Notifier<OnboardingGate> {
  @override
  OnboardingGate build() {
    unawaited(_check());
    return OnboardingGate.checking;
  }

  /// Okuma bu kadar sürerse açılış atlanır (boş ekranda beklenmez).
  static const timeout = Duration(seconds: 10);

  Future<void> _check() async {
    try {
      final needed = await ref
          .read(onboardingStoreProvider)
          .needsOnboarding()
          .timeout(timeout);
      // Kapsayıcı (ör. test/ekran kapanışı) okuma sürerken kapanabilir.
      if (!ref.mounted) return;
      state = needed ? OnboardingGate.needed : OnboardingGate.done;
    } on Object catch (e) {
      if (!ref.mounted) return;
      // Kayıt okunamazsa uygulama durmaz: açılış gösterilmez.
      debugPrint('[H039] açılış durumu okunamadı: $e');
      state = OnboardingGate.done;
    }
  }

  /// Açılış bitti (bir kez yazılır). Yazılamasa da uygulamaya geçilir.
  Future<void> complete() async {
    try {
      await ref.read(onboardingStoreProvider).markCompleted();
    } on Object catch (e) {
      debugPrint('[H039] açılış işareti yazılamadı: $e');
    }
    if (!ref.mounted) return;
    state = OnboardingGate.done;
  }

  /// Açılışı yeniden göster (testler ve debug derleme).
  Future<void> restart() async {
    await ref.read(onboardingStoreProvider).reset();
    if (!ref.mounted) return;
    state = OnboardingGate.needed;
  }
}

final onboardingGateProvider =
    NotifierProvider<OnboardingGateNotifier, OnboardingGate>(
      OnboardingGateNotifier.new,
    );

/// Yerleştirme testi soru havuzu (TASLAK, H-028 onayı bekliyor). Uygulama
/// içinde gelir; ağ yok. Testlerde geçersiz kılınabilir.
final placementBankProvider = FutureProvider<PlacementBank>((ref) async {
  final raw = await rootBundle.loadString(placementBankAsset);
  return PlacementBank.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}, retry: (_, _) => null);

const placementBankAsset = 'assets/placement/placement_bank.json';
