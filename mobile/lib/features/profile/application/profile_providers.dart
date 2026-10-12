import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/storage/storage_providers.dart';
import '../data/user_profile_store.dart';

final userProfileStoreProvider = Provider<UserProfileStore>(
  (ref) => UserProfileStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// Seslenme adı (yoksa `null`). Okunamazsa uygulama durmaz: "Merhaba!".
final displayNameProvider = FutureProvider.autoDispose<String?>((ref) async {
  try {
    return await ref.watch(userProfileStoreProvider).displayName();
  } on Object catch (e) {
    debugPrint('[H053] ad okunamadı: $e');
    return null;
  }
}, retry: (_, _) => null);
