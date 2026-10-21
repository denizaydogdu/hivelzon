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
/// H-043: yaş bilgisi okunamazsa [DiscoverLimit.failSafe] (20 dk; güvenli
/// taraf). Sağlayıcı hata durumuna düşmez (ekranda sonsuz iskelet olmaz).
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
  } on Object catch (e) {
    debugPrint('[H043] yaş bilgisi okunamadı, 20 dk sınır: ${e.runtimeType}');
    return DiscoverLimit.failSafe;
  }
}, retry: (_, _) => null);

/// Ekranda kullanılan sınır: sağlayıcı yine de hata verirse güvenli taraf.
DiscoverLimit? discoverLimitOrSafe(AsyncValue<DiscoverLimit> v) =>
    v.hasValue ? v.value : (v.hasError ? DiscoverLimit.failSafe : null);

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

/// Reel kataloğunun kontrollü yenilenmesi arasındaki en kısa süre (H-096).
final reelCatalogRefreshIntervalProvider = Provider<Duration>(
  (ref) => const Duration(minutes: 1),
);

/// Reel kataloğunun **kontrollü** yenilenmesi (H-096).
///
/// Keşfet'e dönüşte ve uygulama öne gelince çağrılır. En kısa aralık
/// [reelCatalogRefreshIntervalProvider]: son okumadan (başarılı ya da değil)
/// bu kadar geçmeden yeniden okunmaz; eşzamanlı çağrılar tek okumayı paylaşır.
/// Katalog değiştiyse okunan sonuç [reelCatalogProvider]'a aktarılır (ikinci
/// istek yok) ve seçki/havuz yeniden kurulur; değişmediyse hiçbir şey
/// yenilenmez (açık akış kesilmez).
class ReelCatalogRefresher {
  ReelCatalogRefresher(this._ref);

  final Ref _ref;
  DateTime? _lastRead;
  String? _signature;
  ReelCatalog? _fresh;
  Future<ReelCatalog?>? _inFlight;

  /// [reelCatalogProvider] okudu.
  void _loaded(ReelCatalog catalog) {
    _lastRead = _ref.read(discoverClockProvider)();
    _signature = _signatureOf(catalog);
  }

  ReelCatalog? _takeFresh() {
    final f = _fresh;
    _fresh = null;
    return f;
  }

  /// Zamanı geldiyse kataloğu okur. Okunan kataloğu döndürür; zamanı
  /// gelmediyse ya da okunamadıysa `null` (hata sessizce yutulmaz: kaynak
  /// yayın kapısını kapatır, yeni paket açılmaz; açık video kesilmez).
  Future<ReelCatalog?> refreshIfDue() {
    final running = _inFlight;
    if (running != null) return running;
    final now = _ref.read(discoverClockProvider)();
    final last = _lastRead;
    final every = _ref.read(reelCatalogRefreshIntervalProvider);
    if (last != null && now.difference(last).abs() < every) {
      return Future.value();
    }
    _lastRead = now;
    final f = _read().whenComplete(() => _inFlight = null);
    _inFlight = f;
    return f;
  }

  Future<ReelCatalog?> _read() async {
    final ReelCatalog fresh;
    try {
      fresh = await _ref.read(contentSourceProvider).listReels();
    } on Object catch (e) {
      debugPrint('[H096] reel kataloğu yenilenemedi: ${e.runtimeType}');
      return null;
    }
    final sig = _signatureOf(fresh);
    if (sig != _signature) {
      _signature = sig;
      _fresh = fresh;
      _ref.invalidate(reelCatalogProvider);
    }
    return fresh;
  }

  static String _signatureOf(ReelCatalog c) => ([
    for (final r in c.reels) '${r.id}@${r.contentVersion}:${r.status}',
  ]..sort()).join('|');
}

final reelCatalogRefresherProvider = Provider<ReelCatalogRefresher>(
  ReelCatalogRefresher.new,
);

/// Bağımsız reellerin kataloğu (backend yayın kataloğu ya da yerel
/// `/reels/index.json`). Kontrollü yenileme: [ReelCatalogRefresher].
final reelCatalogProvider = FutureProvider.autoDispose<ReelCatalog>((
  ref,
) async {
  final source = ref.watch(contentSourceProvider);
  final refresher = ref.read(reelCatalogRefresherProvider);
  final catalog = refresher._takeFresh() ?? await source.listReels();
  refresher._loaded(catalog);
  return catalog;
}, retry: (_, _) => null);

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

/// "İlgi alanların" değişikliğinin sonucu.
enum InterestToggle {
  /// Tercih yazıldı; bugünün seçkisi yeniden hazırlanır.
  changed,

  /// Son açık konu kapatılmak istendi: tercih değişmedi (en az biri açık).
  keepOne,

  /// Cihaza yazılamadı: tercih değişmedi.
  failed,
}

/// Günlük seçkiye giren konular (plan §4.3, §5): `discover.prefs.categories`,
/// yalnız cihazda. Katalog sırasıyla (Sinema · Spor · Kitap) döner.
///
/// `dailySetProvider` bunu izler: değişince saklanan seçkinin
/// `prefsSnapshot`'ı uyuşmaz ve seviye değişimindeki **aynı yolla** yeni
/// seçim başlar (izleme sayacı ve öğrenme kayıtları silinmez).
class ReelCategoriesNotifier extends AsyncNotifier<List<String>> {
  /// Yazmalar sırayla uygulanır (hızlı art arda dokunuşta kayıp olmaz).
  Future<void> _queue = Future<void>.value();

  @override
  Future<List<String>> build() async =>
      (await ref.watch(discoverStoreProvider).prefs()).normalizedCategories();

  /// [code] konusunu açar ya da kapatır. Son açık konu kapatılmaz.
  Future<InterestToggle> toggle(String code) {
    final done = Completer<InterestToggle>();
    _queue = _queue.then((_) async {
      done.complete(await _apply(code));
    });
    return done.future;
  }

  Future<InterestToggle> _apply(String code) async {
    final current = state.value ?? await future;
    final on = current.contains(code);
    if (on && current.length <= 1) return InterestToggle.keepOne;
    final next = [
      for (final c in kReelCategoryOrder)
        if (c == code ? !on : current.contains(c)) c,
    ];
    try {
      await ref.read(discoverStoreProvider).setReelCategories(next);
    } on Object catch (e) {
      debugPrint('[H094] ilgi alanları yazılamadı: $e');
      return InterestToggle.failed;
    }
    if (ref.mounted) state = AsyncData(next);
    return InterestToggle.changed;
  }
}

final reelCategoriesProvider =
    AsyncNotifierProvider<ReelCategoriesNotifier, List<String>>(
      ReelCategoriesNotifier.new,
      retry: (_, _) => null,
    );

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
  final level = ref.watch(reelLevelProvider);
  final categories = await ref.watch(reelCategoriesProvider.future);
  final progress = await store.allReelProgress();
  final now = clock();
  final stored = await store.dailySet(now);
  if (stored != null && stored.matches(level: level, categories: categories)) {
    final fixed = reconcileDailySetDetailed(
      set: stored,
      catalog: catalog.reels,
      progress: progress,
    );
    if (fixed == null) return stored;
    await store.setDailySet(now, fixed.set);
    // Kalınan video geri çekildiyse yedeğinden sürülür (H-096): akış aynı
    // sıradan açılır.
    try {
      final resume = await store.resumeId(now);
      final to = resume == null ? null : fixed.replaced[resume];
      if (to != null) await store.setResumeId(now, to);
    } on Object catch (e) {
      debugPrint('[H096] kalınan video güncellenemedi: ${e.runtimeType}');
    }
    return fixed.set;
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
/// H-043: okunamazsa da baştan (null); sağlayıcı hata durumuna düşmez.
///
/// Seçki uzlaştırıldıktan **sonra** okunur (H-096: geri çekilen videonun
/// yerine yedeği yazılmış olur).
final dailyResumeProvider = FutureProvider.autoDispose<String?>((ref) async {
  final store = ref.watch(discoverStoreProvider);
  final now = ref.watch(discoverClockProvider)();
  try {
    await ref.watch(dailySetProvider.future);
    return await store.resumeId(now);
  } on Object catch (e) {
    debugPrint('[H043] kalınan video okunamadı, baştan: ${e.runtimeType}');
    return null;
  }
}, retry: (_, _) => null);

/// Yüklenmiş reel havuzu: reeller + "Tekrar" etiketli kimlikler.
class ReelPool {
  const ReelPool({
    required this.reels,
    this.repeats = const {},
    this.categories = const [],
    this.resumeId,
  });

  final List<Reel> reels;

  /// Günlük sette aynı gün kalınan video (seçkiyle aynı anda okunur; kategori
  /// havuzunda `null`).
  final String? resumeId;

  /// Günlük sette seçkinin yapıldığı konular (`prefsSnapshot`); kategori
  /// havuzunda boş. Akışın anahtarına girer: konular değişince seçki baştan
  /// başlar (plan §5).
  final List<String> categories;

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
      final resumeId = await ref.watch(dailyResumeProvider.future);
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
      return ReelPool(
        reels: reels,
        repeats: repeats,
        categories: set.categories,
        resumeId: resumeId,
      );
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
    this.categories = const [],
    this.resumeId,
  });

  final DiscoverChip chip;
  final String level;
  final List<Reel> reels;

  /// Günlük sette seçkinin konuları (bkz. [ReelPool.categories]).
  final List<String> categories;

  /// "Tekrar" etiketli reeller (plan §4.5).
  final Set<String> repeats;

  /// Günlük sette kalınan video (bkz. [ReelPool.resumeId]).
  final String? resumeId;
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
      categories: value.categories,
      resumeId: value.resumeId,
    ),
  );
});

/// "Tekrar dene": reel kataloğu ve seçki yeniden okunur.
void retryReels(WidgetRef ref) {
  ref.invalidate(reelCatalogProvider);
  ref.invalidate(reelCategoriesProvider);
}
