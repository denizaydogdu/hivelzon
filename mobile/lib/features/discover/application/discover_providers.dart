import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../../shared/storage/storage_providers.dart';
import '../../account/application/account_providers.dart';
import '../../onboarding/application/onboarding_providers.dart';
import '../../story/application/story_providers.dart';
import '../data/discover_store.dart';
import '../domain/clip.dart';
import '../domain/feed.dart';

/// Keşfet'in sezonu (MVP: Sezon 1).
const kDiscoverSeason = 1;

/// Saat (yerel gün ve yaş eşiği için). Testlerde sabitlenir.
final discoverClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// İzleme süresi sayacının adımı. Testlerde kısaltılabilir.
final discoverTickProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 1),
);

final discoverStoreProvider = Provider<DiscoverStore>(
  (ref) => DiscoverStore(ref.watch(appDatabaseProvider)),
);

/// Günlük sınır (K-15): 13–17 ve 13 altı için 20 dk; 18+ için yok.
final discoverLimitProvider = FutureProvider.autoDispose<DiscoverLimit>((
  ref,
) async {
  final now = ref.watch(discoverClockProvider)();
  try {
    final adultFrom = await ref.watch(onboardingStoreProvider).adultFromYear();
    final blocked = await ref.watch(ageGateStoreProvider).blockedUntil();
    return discoverLimitFor(
      now: now,
      ageBlockedUntil: blocked,
      adultFromYear: adultFrom,
    );
  } on Object {
    return DiscoverLimit.none;
  }
}, retry: (_, _) => null);

/// Sezonun klipleri: sezon paketinde `clips` yoksa null (boş durum).
final clipCatalogProvider = FutureProvider.autoDispose<ClipCatalog?>((
  ref,
) async {
  final source = ref.watch(contentSourceProvider);
  final SeasonInfo info = await ref.watch(
    seasonProvider(kDiscoverSeason).future,
  );
  final path = info.clipsPath;
  if (path == null) return null;
  return source.loadClips(kDiscoverSeason, path);
}, retry: (_, _) => null);

/// Akıştaki klipler: yalnızca açılmış (oynanabilir) bölümlerden; gelecek
/// bölümün sahnesi önceden görünmez ve "Tam hikâye" her zaman açılır.
class DiscoverClips {
  const DiscoverClips({
    required this.clips,
    required this.total,
    required this.aiLabel,
  });

  final List<FeedClip> clips;

  /// Sezondaki bütün klipler (kilitli bölümlerinkiler dahil).
  final int total;
  final String aiLabel;

  bool get hasLocked => clips.length < total;
}

final discoverClipsProvider = Provider.autoDispose<AsyncValue<DiscoverClips?>>((
  ref,
) {
  final catalog = ref.watch(clipCatalogProvider);
  if (catalog.hasError && !catalog.isLoading) {
    return AsyncError(catalog.error!, catalog.stackTrace ?? StackTrace.empty);
  }
  if (!catalog.hasValue) return const AsyncLoading();
  final c = catalog.value;
  if (c == null) return const AsyncData(null);
  final map = ref.watch(seasonMapProvider);
  if (map.hasError && !map.isLoading) {
    return AsyncError(map.error!, map.stackTrace ?? StackTrace.empty);
  }
  final m = map.value;
  if (m == null) return const AsyncLoading();
  final open = {...m.unlockedIds};
  return AsyncData(
    DiscoverClips(
      clips: [
        for (final clip in c.clips)
          if (open.contains(clip.episodeId)) clip,
      ],
      total: c.clips.length,
      aiLabel: c.aiLabel,
    ),
  );
});

/// "Tekrar dene": klipler, sezon ve harita yeniden okunur.
void retryDiscover(WidgetRef ref) {
  ref.invalidate(clipCatalogProvider);
  retrySeasonMap(ref);
}
