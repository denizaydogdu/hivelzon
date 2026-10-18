import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../../shared/storage/storage_providers.dart';
import '../../account/application/account_providers.dart';
import '../../onboarding/application/onboarding_providers.dart';
import '../../story/application/story_providers.dart';
import '../data/discover_store.dart';
import '../domain/clip.dart';
import '../domain/daily_set.dart';
import '../domain/feed.dart';
import '../domain/reel.dart';
import '../domain/reel_selection.dart';

/// Keşfet'in sezonu (MVP: Sezon 1).
const kDiscoverSeason = 1;

/// Bağımsız reellerde seviye bilgisi okunamazsa kullanılan varsayılan (pilot
/// A1/A2; plan §14.7).
const kDefaultReelLevel = 'A1';

/// Günlük seçkinin uzunluğu: "Bugün senin için 3 kısa video" (plan §3).
const kDailyReelCount = 3;

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

// ---------------------------------------------------------------------------
// Günlük üç video (H-094): bağımsız konu reelleri.
//
// Kaynak türleri karışmaz (plan §4): bu bölümdeki her şey `/reels/` paketinden
// gelir; hikâye klipleri yukarıdaki `discoverClipsProvider` akışında kalır.
// Günlük seçkinin cihazda saklanması ve ilgiye göre ağırlıklandırma P2'de;
// bu adımda seçki seviyeye göre **kararlı** biçimde türetilir.
// ---------------------------------------------------------------------------

/// Keşfet'in üst şeridindeki kaynak çipleri.
enum DiscoverChip {
  today,
  cinema,
  sport,
  book,
  storyClips;

  /// Kategori kodu (`CIN` | `SPO` | `BOK`); Bugün ve Hikâye kliplerinde null.
  String? get categoryCode => switch (this) {
    DiscoverChip.cinema => 'CIN',
    DiscoverChip.sport => 'SPO',
    DiscoverChip.book => 'BOK',
    _ => null,
  };
}

/// Seçili çip (kullanıcı seçimi). Sekme yeniden açıldığında "Bugün"e döner.
/// Başlangıç çipi ayrı bir sağlayıcıdan gelir (testler ve gelecekteki derin
/// bağlantılar için).
final discoverInitialChipProvider = Provider<DiscoverChip>(
  (ref) => DiscoverChip.today,
);

class DiscoverChipNotifier extends Notifier<DiscoverChip> {
  @override
  DiscoverChip build() => ref.watch(discoverInitialChipProvider);

  void select(DiscoverChip chip) => state = chip;
}

final discoverChipProvider =
    NotifierProvider<DiscoverChipNotifier, DiscoverChip>(
      DiscoverChipNotifier.new,
    );

/// Bağımsız reellerin kataloğu (`/reels/index.json`, çalışma anında taranır).
final reelCatalogProvider = FutureProvider.autoDispose<ReelCatalog>(
  (ref) => ref.watch(contentSourceProvider).listReels(),
  retry: (_, _) => null,
);

/// Katalogda video bulunan seviyeler (sıralı). Pilot A1/A2.
final reelLevelsProvider = FutureProvider<List<String>>((ref) async {
  final catalog = await ref.watch(reelCatalogProvider.future);
  final levels = {
    for (final r in catalog.reels)
      if (!r.isWithdrawn && r.level.isNotEmpty) r.level,
  }.toList()..sort();
  return levels.isEmpty ? const [kDefaultReelLevel] : levels;
}, retry: (_, _) => null);

/// Yerleştirmenin **gerçekten** önerdiği seviye. Yalnız katalogda o seviyede
/// içerik varsa doludur; aksi hâlde `null` olur ve kullanıcıya "önerilen
/// seviyem" denmez (K-06: öneri bilgidir, vaat değil; B1+ kullanıcıya A1
/// "seviyene uygun" diye sunulmaz — plan §14/7 ve kabul §12/2).
final reelPlacementLevelProvider = FutureProvider<String?>((ref) async {
  final levels = await ref.watch(reelLevelsProvider.future);
  try {
    final suggested = await ref.watch(onboardingStoreProvider).suggestedLevel();
    if (suggested != null &&
        suggested.isNotEmpty &&
        levels.contains(suggested)) {
      return suggested;
    }
  } on Object catch (e) {
    debugPrint('[H094] önerilen seviye okunamadı: $e');
  }
  return null;
}, retry: (_, _) => null);

/// Kullanıcının elle seçtiği seviye (`null` = önerilen). Cihazda saklanır;
/// yalnız Keşfet zorluğunu değiştirir.
class ReelLevelNotifier extends Notifier<String?> {
  bool _disposed = false;

  @override
  String? build() {
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return null;
  }

  Future<void> _load() async {
    try {
      final stored = await ref.read(discoverStoreProvider).reelLevel();
      if (stored == null || stored.isEmpty || _disposed) return;
      state = stored;
    } on Object catch (e) {
      debugPrint('[H094] seviye seçimi okunamadı: $e');
    }
  }

  /// Seçimi yazar; `null` önerilen seviyeye dönüştür.
  Future<void> choose(String? level) async {
    if (!_disposed) state = level;
    try {
      await ref.read(discoverStoreProvider).setReelLevel(level);
    } on Object catch (e) {
      debugPrint('[H094] seviye seçimi yazılamadı: $e');
    }
  }
}

final reelLevelChoiceProvider = NotifierProvider<ReelLevelNotifier, String?>(
  ReelLevelNotifier.new,
);

/// Yürürlükteki seviye: elle seçim → yerleştirme önerisi → eldeki ilk seviye.
final reelLevelProvider = Provider<String>((ref) {
  final choice = ref.watch(reelLevelChoiceProvider);
  if (choice != null && choice.isNotEmpty) return choice;
  final placement = ref.watch(reelPlacementLevelProvider);
  if (placement.hasValue && placement.requireValue != null) {
    return placement.requireValue!;
  }
  final levels = ref.watch(reelLevelsProvider);
  if (levels.hasValue && levels.requireValue.isNotEmpty) {
    return levels.requireValue.first;
  }
  return kDefaultReelLevel;
});

/// Günlük set / kategori havuzu sorgusu (çip + seviye).
typedef ReelQuery = ({DiscoverChip chip, String level});

/// Günün seçkisi (H-094 P2, plan §4–5).
///
/// - Gün içinde **kararlı**: cihazda saklanan `{id, contentVersion}` listesi
///   yeniden seçilmez.
/// - Seviye ya da kategoriler değişirse seçki **açıkça yeni başlar** (günlük
///   izleme sayacı ve öğrenme kayıtları korunur).
/// - Geri çekilen içerik sabit listedeyse yerine aynı seviye-kategoriden yedek
///   konur; uygun aday yoksa seçki daha az videoyla sürer.
final dailySetProvider = FutureProvider.autoDispose<DailySet>((ref) async {
  final store = ref.watch(discoverStoreProvider);
  final clock = ref.watch(discoverClockProvider);
  final catalog = await ref.watch(reelCatalogProvider.future);
  final prefs = await store.prefs();
  final level = ref.watch(reelLevelProvider);
  final categories = prefs.normalizedCategories();
  final progress = await store.allReelProgress();
  final now = clock();
  final stored = await store.dailySet(now);
  if (stored != null && stored.matches(level: level, categories: categories)) {
    final fixed = reconcileDailySet(
      set: stored,
      catalog: catalog.reels,
      progress: progress,
    );
    if (fixed == null) return stored;
    await store.setDailySet(now, fixed);
    return fixed;
  }
  final picks = selectDailyReels(
    catalog: catalog.reels,
    level: level,
    categories: categories,
    progress: progress,
    count: kDailyReelCount,
  );
  final set = DailySet(
    level: level,
    categories: categories,
    items: [
      for (final p in picks)
        DailyItem(
          id: p.reel.id,
          contentVersion: p.reel.contentVersion,
          repeat: p.repeat,
        ),
    ],
  );
  await store.setDailySet(now, set);
  return set;
}, retry: (_, _) => null);

/// Aynı gün kalınan video (günlük set; plan §5). Boşsa seçki baştan açılır.
final dailyResumeProvider = FutureProvider.autoDispose<String?>((ref) async {
  final store = ref.watch(discoverStoreProvider);
  final now = ref.watch(discoverClockProvider)();
  return store.resumeId(now);
}, retry: (_, _) => null);

/// Yüklenmiş reel havuzu: reeller + "Tekrar" etiketli kimlikler.
class ReelPool {
  const ReelPool({required this.reels, this.repeats = const {}});

  final List<Reel> reels;

  /// Kullanıcıya daha önce gösterildiği için "Tekrar" denen videolar.
  final Set<String> repeats;
}

/// Seçili çipin havuzu: günlük sette **saklanan seçki** (en çok üç video),
/// kategori çipinde kategorinin tamamı. Geri çekilen içerik oynatılmaz.
final reelPoolProvider = FutureProvider.autoDispose.family<ReelPool, ReelQuery>(
  (ref, query) async {
    final catalog = await ref.watch(reelCatalogProvider.future);
    final level = query.level;
    final category = query.chip.categoryCode;
    final source = ref.watch(contentSourceProvider);
    if (category == null) {
      final set = await ref.watch(dailySetProvider.future);
      final reels = <Reel>[];
      final repeats = <String>{};
      final seen = <String>{};
      for (final item in set.items) {
        if (!seen.add(item.id)) continue;
        final reel = await source.loadReel(item.id);
        if (reel.isWithdrawn || !reel.isStandalone) continue;
        reels.add(reel);
        if (item.repeat) repeats.add(item.id);
      }
      return ReelPool(reels: reels, repeats: repeats);
    }
    final summaries = [
      for (final r in catalog.reels)
        if (!r.isWithdrawn && r.category == category && r.level == level) r,
    ]..sort((a, b) => a.id.compareTo(b.id));
    final reels = <Reel>[];
    for (final s in summaries) {
      final reel = await source.loadReel(s.id);
      if (reel.isWithdrawn || !reel.isStandalone) continue;
      reels.add(reel);
    }
    return ReelPool(reels: reels);
  },
  retry: (_, _) => null,
);

/// Ekranın gördüğü seçki: çip, seviye ve yüklenmiş reeller.
class ReelSet {
  const ReelSet({
    required this.chip,
    required this.level,
    required this.reels,
    this.repeats = const {},
  });

  final DiscoverChip chip;
  final String level;
  final List<Reel> reels;

  /// "Tekrar" etiketli reeller (plan §4.5).
  final Set<String> repeats;
}

final reelSetProvider = Provider.autoDispose<AsyncValue<ReelSet>>((ref) {
  final chip = ref.watch(discoverChipProvider);
  final level = ref.watch(reelLevelProvider);
  final pool = ref.watch(reelPoolProvider((chip: chip, level: level)));
  if (pool.hasError && !pool.isLoading) {
    return AsyncError(pool.error!, pool.stackTrace ?? StackTrace.empty);
  }
  if (!pool.hasValue) return const AsyncLoading();
  final value = pool.requireValue;
  return AsyncData(
    ReelSet(
      chip: chip,
      level: level,
      reels: value.reels,
      repeats: value.repeats,
    ),
  );
});

/// "Tekrar dene": reel kataloğu ve seçki yeniden okunur.
void retryReels(WidgetRef ref) {
  ref.invalidate(reelCatalogProvider);
}
