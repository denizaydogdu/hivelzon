import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';

/// Açılışı (H-039) bitmiş sayan kapı: uygulamanın tamamını açan testler
/// doğrudan sekmelerle başlar. Açılışın kendisi
/// `test/features/onboarding/` altında sınanır.
class DoneOnboardingGate extends OnboardingGateNotifier {
  @override
  OnboardingGate build() => OnboardingGate.done;
}

final onboardingDoneOverride = onboardingGateProvider.overrideWith(
  DoneOnboardingGate.new,
);
