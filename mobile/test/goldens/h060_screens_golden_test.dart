// H-060 ekran golden'ları ve erişilebilirlik denetimi: Ana Sayfa (devam eden
// kullanıcı / yeni kullanıcı / sezon bitti), Hikâye haritası, bölüm paneli
// (kilitli / yarım bölüm).
//
// Veriler sabit (sağlayıcılar geçersiz kılınır), yazı tipleri gömülü
// (`loadAppFonts`). Ağ görselleri testte açılmaz: kart görseli yerine akşam
// göğü zemini, harita yerine kodla çizilen harita görünür. Bilinçli görsel
// değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/home/application/home_providers.dart';
import 'package:hivelzon/features/home/presentation/home_screen.dart';
import 'package:hivelzon/features/notebook/application/notebook_providers.dart';
import 'package:hivelzon/features/notebook/domain/review_session.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/features/profile/application/profile_providers.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/features/story/data/unlock_seen_repository.dart';
import 'package:hivelzon/features/story/presentation/story_screen.dart';
import 'package:hivelzon/shared/api/token_store.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../support/app_fonts.dart';
import '../support/fake_api_server.dart';
import '../support/fake_content_source.dart';
import '../support/golden.dart';

const _four = ['A1-001', 'A1-002', 'A1-003', 'A1-004'];
const _fullGate = {
  GateItem.comprehension: {'t-gorev'},
  GateItem.targetPhrase: {'k2'},
  GateItem.activeTask: {'t-kanit'},
};
final _twelve = <String>[
  for (var i = 1; i <= 12; i++) 'A1-${i.toString().padLeft(3, '0')}',
];

/// 12 bölümün hepsi sunucuda (sezon bitti durumu için).
class _AllBuiltSource extends FakeContentSource {
  _AllBuiltSource() : super(packageIds: _twelve);

  @override
  Future<List<PackageSummary>> listPackages() async => [
    for (final (i, id) in _twelve.indexed)
      PackageSummary(
        id: id,
        title: 'Bölüm ${i + 1}',
        level: 'A1',
        season: 1,
        number: i + 1,
        estimatedMinutes: 6,
      ),
  ];
}

/// Bir ekran durumu: ekran, kaynak, ilerleme ve sabit veriler.
class _Case {
  const _Case({
    required this.screen,
    required this.progress,
    this.source,
    this.name,
    this.due = 5,
    this.total = 15,
    this.minutes = 6,
    this.nudge = false,
    this.openNode,
  });

  final Widget screen;
  final Future<void> Function(InMemoryProgressRepository) progress;
  final FakeContentSource Function()? source;
  final String? name;
  final int due;
  final int total;
  final int minutes;
  final bool nudge;

  /// Haritada dokunulacak düğüm (bölüm paneli).
  final int? openNode;
}

Future<void> _b1Done(InMemoryProgressRepository p) =>
    p.markCompleted('A1-001', gate: _fullGate);

Future<void> _b2Half(InMemoryProgressRepository p) async {
  await _b1Done(p);
  await p.saveCheckpoint(
    'A1-002',
    const EngineSnapshot(
      checkpointNodeId: 's03',
      flags: {},
      passedNodes: {},
      contentVersion: 1,
    ),
  );
}

Future<void> _none(InMemoryProgressRepository p) async {}

Future<void> _allDone(InMemoryProgressRepository p) async {
  for (final id in _twelve) {
    await p.markCompleted(id, gate: _fullGate);
  }
}

final _cases = <String, _Case>{
  'ana_sayfa': const _Case(
    screen: HomeScreen(),
    progress: _b2Half,
    name: 'Deniz',
    nudge: true,
  ),
  'ana_sayfa_yeni': const _Case(
    screen: HomeScreen(),
    progress: _none,
    due: 0,
    total: 0,
    minutes: 0,
  ),
  'ana_sayfa_sezon_bitti': _Case(
    screen: const HomeScreen(),
    progress: _allDone,
    source: _AllBuiltSource.new,
    name: 'Deniz',
    due: 0,
    minutes: 12,
  ),
  'harita': const _Case(screen: StoryScreen(), progress: _b1Done),
  'bolum_paneli_kilitli': const _Case(
    screen: StoryScreen(),
    progress: _b1Done,
    openNode: 3,
  ),
  'bolum_paneli_yarim': const _Case(
    screen: StoryScreen(),
    progress: _b2Half,
    openNode: 2,
  ),
};

void main() {
  setUpAll(loadAppFonts);
  setUp(() => SyncController.listenLifecycle = false);
  tearDown(() => SyncController.listenLifecycle = true);

  Future<void> pumpCase(
    WidgetTester tester,
    _Case c, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    // Harita düğümünün nabzı sonsuz döner; golden'da durağan çizilir.
    // Ana Sayfa'nın giriş animasyonu ise bitene dek beklenir.
    if (c.screen is StoryScreen) {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
    }
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final server = FakeApiServer();
    final progress = InMemoryProgressRepository();
    await c.progress(progress);
    final intro = InMemorySeasonIntroRepository()..seenSeasons.add(1);
    final overrides = <Override>[
      appDatabaseProvider.overrideWithValue(db),
      legacyImportProvider.overrideWithValue(Future<void>.value()),
      contentSourceProvider.overrideWithValue(
        c.source?.call() ?? FakeContentSource(packageIds: _four),
      ),
      progressRepositoryProvider.overrideWithValue(progress),
      seasonIntroRepositoryProvider.overrideWithValue(intro),
      unlockSeenRepositoryProvider.overrideWithValue(
        InMemoryUnlockSeenRepository(),
      ),
      apiHttpClientProvider.overrideWithValue(server.client),
      tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
      displayNameProvider.overrideWith((ref) async => c.name),
      dailyGoalProvider.overrideWith((ref) async => 10),
      reviewOverviewProvider.overrideWith(
        (ref) async => ReviewOverview(
          dueReviews: c.due,
          newAvailable: 0,
          totalItems: c.total,
          newPerDay: 10,
        ),
      ),
      todayActivityProvider.overrideWith(
        (ref) async => TodayActivity(minutes: c.minutes, goalMinutes: 10),
      ),
      accountNudgeProvider.overrideWith((ref) async => c.nudge),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: RepaintBoundary(
          key: const ValueKey('golden'),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
            home: c.screen,
          ),
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
    if (c.openNode != null) {
      final node = find.byKey(ValueKey('map-node-${c.openNode}'));
      await tester.ensureVisible(node);
      await tester.pumpAndSettle();
      await tester.tap(node);
      await tester.pumpAndSettle();
    }
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  for (final MapEntry(key: id, value: c) in _cases.entries) {
    testWidgets('golden: $id', (tester) async {
      await pumpCase(tester, c);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h060_$id.png'),
      );
      await unmount(tester);
    }, skip: skipGoldensOffMac);

    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCase(tester, c);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // Piksel ölçümü yazı tipi çizimine bağlı (Linux'ta kenar yumuşatma
      // farklı); yalnız golden'ların üretildiği macOS'ta.
      if (!skipGoldensOffMac) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
      await unmount(tester);
    });

    testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
      tester,
    ) async {
      await pumpCase(tester, c, size: const Size(320, 568), textScale: 1.3);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }
}
