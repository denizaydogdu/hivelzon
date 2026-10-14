import 'dart:convert';
import 'dart:io';

import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:hivelzon/features/onboarding/domain/placement.dart';

/// Uygulamadaki soru havuzu (TASLAK), dosyadan eşzamanlı okunur.
PlacementBank loadBank() => PlacementBank.fromJson(
  jsonDecode(File(placementBankAsset).readAsStringSync())
      as Map<String, dynamic>,
);
