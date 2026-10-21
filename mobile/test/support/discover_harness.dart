import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/discover/application/discover_providers.dart';
import 'package:hivelzon/features/discover/domain/clip.dart';
import 'package:hivelzon/features/discover/domain/reel.dart';
import 'package:hivelzon/features/discover/presentation/discover_screen.dart';
import 'package:hivelzon/features/onboarding/data/onboarding_store.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';
import 'package:hivelzon/shared/speech/speech_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import 'fake_content_source.dart';
import 'fake_video_platform.dart';

/// İlk kare görselleri olmadan (testte ağ yok; sayfa sökülünce gelen
/// yükleme hatası rapor edilirdi).
ClipCatalog withoutPosters(ClipCatalog c) => ClipCatalog(
  season: c.season,
  status: c.status,
  aiLabel: c.aiLabel,
  clips: [for (final x in c.clips) copyClip(x, id: x.id, poster: null)],
);

/// Klibin kopyası (yeni kimlik ve video yolu, isteğe bağlı ilk kare).
FeedClip copyClip(FeedClip c, {required String id, String? poster}) => FeedClip(
  id: id,
  episodeId: c.episodeId,
  episodeNumber: c.episodeNumber,
  episodeTitle: c.episodeTitle,
  titleTr: c.titleTr,
  video: 'clips/$id.mp4',
  poster: poster,
  duration: c.duration,
  target: c.target,
  subtitles: c.subtitles,
  grammarId: c.grammarId,
  grammarTitle: c.grammarTitle,
  quiz: c.quiz,
);

/// Keşfet testlerinin yaş grubu (cihazdaki eşiklerle, H-039).
enum TestAge { adult, teen, under13, unknown }

/// Keşfet testlerinin ortamı (H-040): bellekte veritabanı, sahte içerik
/// (gerçek `clips.json` kopyası, 17 klip), sahte video platformu, sabit saat.
/// Bölüm ve ders açılışları yer tutucu sayfalara gider (`play:<bölüm>`,
/// `lesson:<G-ID>`); Ana Sayfa ve Hikâye de yer tutucudur.
class DiscoverHarness {
  DiscoverHarness({
    this.unlocked = 4,
    this.age = TestAge.adult,
    this.now,
    Duration Function(String uri)? durationFor,
    Duration Function(String uri)? positionFor,
    ClipCatalog? catalog,
    bool withClips = true,
    bool clipsFail = false,
    this.chip = DiscoverChip.storyClips,
    List<Reel>? reels,
    ReelCatalog? reelCatalog,
    bool withReels = false,
    bool reelsFail = false,
    this.suggestedLevel,
    this.clockOf,
  }) : db = AppDatabase.memory(),
       source = FakeContentSource(
         packageIds: const ['A1-001', 'A1-002', 'A1-003', 'A1-004'],
       ) {
    source
      ..withClips = withClips
      ..clipsFail = clipsFail
      ..clipCatalog = withoutPosters(catalog ?? loadClipFixture())
      ..withReels = withReels
      ..reelsFail = reelsFail
      // Sentetik reeller verilip katalog verilmezse özetler onlardan üretilir.
      ..reelCatalog = reelCatalog ?? (reels == null ? null : catalogOf(reels))
      // İlk kareler testte boş: ağ isteği hata verirdi (kliplerde olduğu gibi).
      ..reels =
          reels ??
          (withReels
              ? reelsWithoutPosters(reelCatalog ?? loadReelCatalogFixture())
              : const []);
    video = FakeVideoPlatform(
      durationFor: durationFor ?? (_) => const Duration(seconds: 8),
      positionFor: positionFor,
    );
  }

  /// Açık bölüm sayısı (B1 her zaman açık; öncekilerin kapısı tamam sayılır).
  final int unlocked;
  final TestAge age;

  /// Açılıştaki çip: varsayılan "Hikâye klipleri" (H-040 klip testleri);
  /// günlük set testleri `DiscoverChip.today` verir (H-094).
  final DiscoverChip chip;

  /// Sabit saat (yerel); yoksa 2026-10-14 10:00.
  final DateTime? now;

  /// Yerleştirmenin önerdiği seviye (`placement.suggestedLevel`); yoksa
  /// öneri yok (seviye çipi eldeki ilk seviyeye düşer).
  final String? suggestedLevel;

  /// Değişebilir saat (gün dönümü testleri): verilirse [now] yerine kullanılır.
  final DateTime Function()? clockOf;
  final AppDatabase db;
  final FakeContentSource source;
  late final FakeVideoPlatform video;
  final progress = InMemoryProgressRepository();
  late GoRouter router;
  final List<String> opened = [];

  /// Keşfet sekmesi görünür mü (başka sekmeye geçiş ve dönüş; H-096).
  final ValueNotifier<bool> tabVisible = ValueNotifier(true);

  /// Anlam/telaffuz olayları (kanıt testleri: buraya yazılmaması gerekir).
  final InMemoryLearningEventLog learningLog = InMemoryLearningEventLog();

  DateTime get clock => clockOf?.call() ?? now ?? DateTime(2026, 10, 14, 10);

  Future<void> dispose() => db.close();

  Future<void> _seed() async {
    for (var n = 1; n < unlocked; n++) {
      await progress.markCompleted(
        'A1-00$n',
        gate: {
          for (final g in GateItem.values) g: {'x'},
        },
      );
    }
    final year = clock.year;
    Future<void> meta(String k, String v) => db
        .into(db.appMeta)
        .insertOnConflictUpdate(AppMetaCompanion.insert(key: k, value: v));
    switch (age) {
      case TestAge.teen:
        await meta('profile.adultFromYear', '${year + 3}');
      case TestAge.under13:
        await meta('profile.adultFromYear', '${year + 8}');
        await meta('account.ageBlockedUntil', '${year + 3}');
      case TestAge.adult || TestAge.unknown:
        break;
    }
    if (suggestedLevel != null) {
      await meta(OnboardingStore.suggestedLevelKey, suggestedLevel!);
    }
  }

  /// İzlenmiş süreyi yazar (bugün, saniye).
  Future<void> watched(WidgetTester tester, int seconds) => tester.runAsync(
    () => db
        .into(db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(
            key: 'discover.watch.${_day(clock)}',
            value: '$seconds',
          ),
        ),
  );

  static String _day(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<int> storedSeconds(WidgetTester tester) async {
    final row = await tester.runAsync(
      () =>
          (db.select(db.appMeta)
                ..where((t) => t.key.equals('discover.watch.${_day(clock)}')))
              .getSingleOrNull(),
    );
    return int.tryParse(row?.value ?? '') ?? 0;
  }

  Future<void> pump(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double textScale = 1,
    bool reduceMotion = false,
    Duration tick = const Duration(seconds: 1),
    List<Override> overrides = const [],
  }) async {
    tester.view.physicalSize = size * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    if (reduceMotion) {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
    }
    VideoPlayerPlatform.instance = video;
    await tester.runAsync(_seed);
    Widget placeholder(String text) =>
        Scaffold(body: Center(child: Text(text)));
    router = GoRouter(
      initialLocation: '/kesfet',
      routes: [
        GoRoute(path: '/', builder: (_, _) => placeholder('home')),
        GoRoute(path: '/kesfet', builder: (_, _) => const DiscoverScreen()),
        GoRoute(path: '/hikaye', builder: (_, _) => placeholder('story')),
        GoRoute(
          path: '/play/:contentId',
          builder: (_, s) {
            opened.add('play:${s.pathParameters['contentId']}');
            return placeholder('play:${s.pathParameters['contentId']}');
          },
        ),
        GoRoute(
          path: '/dilbilgisi/:id',
          builder: (_, s) {
            opened.add('lesson:${s.pathParameters['id']}');
            return placeholder('lesson:${s.pathParameters['id']}');
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(source),
          progressRepositoryProvider.overrideWithValue(progress),
          learningEventLogProvider.overrideWithValue(learningLog),
          speechVisibleProvider.overrideWithValue(false),
          discoverClockProvider.overrideWithValue(() => clock),
          discoverTickProvider.overrideWithValue(tick),
          discoverInitialChipProvider.overrideWithValue(chip),
          ...overrides,
        ],
        child: RepaintBoundary(
          key: const ValueKey('golden'),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            routerConfig: router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              // Sekme görünürlüğü (StatefulShellRoute gibi TickerMode).
              child: ValueListenableBuilder<bool>(
                valueListenable: tabVisible,
                builder: (_, visible, _) =>
                    TickerMode(enabled: visible, child: child!),
              ),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  /// Veritabanı, sahte gelecekler ve video olayları çözülsün.
  Future<void> settle(WidgetTester tester, {int rounds = 30}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  DiscoverFeedState feedState(WidgetTester tester) =>
      tester.state<DiscoverFeedState>(find.byType(DiscoverFeed));

  /// Akışta bir sonraki sayfaya kaydırır (yukarı sürükleme).
  Future<void> swipeUp(WidgetTester tester) async {
    await tester.fling(
      find.byKey(const ValueKey('discover-pages')),
      const Offset(0, -500),
      2000,
    );
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await settle(tester, rounds: 12);
  }

  /// Ağacı söker; denetleyicilerin atılması biter. (`VideoPlayerController`
  /// atılırken kök bölgedeki tamamlanmış bir geleceği bekler: gerçek
  /// mikro görevler de çalışmalı.)
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    }
  }
}
