import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/home/application/home_providers.dart';
import 'package:hivelzon/features/home/presentation/home_screen.dart';
import 'package:hivelzon/features/notebook/application/notebook_providers.dart';
import 'package:hivelzon/features/notebook/domain/review_session.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/ui/ui.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/widgets/skeleton.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';

import '../../support/fake_content_source.dart';

const _four = ['A1-001', 'A1-002', 'A1-003', 'A1-004'];
const _fullGate = {
  GateItem.comprehension: {'t-gorev'},
  GateItem.targetPhrase: {'k2'},
  GateItem.activeTask: {'t-kanit'},
};

void main() {
  late InMemoryProgressRepository progress;
  late List<String> pushed;

  setUp(() {
    progress = InMemoryProgressRepository();
    pushed = [];
  });

  Future<void> pump(
    WidgetTester tester,
    FakeContentSource source, {
    List<Override> overrides = const [],
    bool reduceMotion = false,
    bool waitForEntrance = true,
  }) async {
    if (reduceMotion) {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
    }
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
        GoRoute(
          path: '/play/:id',
          builder: (context, state) {
            pushed.add(state.uri.toString());
            return const Scaffold(body: Text('oynatıcı'));
          },
        ),
        GoRoute(
          path: '/hikaye',
          builder: (_, _) => const Scaffold(body: Text('harita')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentSourceProvider.overrideWithValue(source),
          progressRepositoryProvider.overrideWithValue(progress),
          ...overrides,
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // H-060: bölümler sırayla belirir (en çok ~0,5 sn); ekran okuyucu
    // görünmeyen (opaklığı 0) öğeyi okumaz.
    if (waitForEntrance) {
      await tester.pump(const Duration(milliseconds: 500));
    }
  }

  testWidgets('yeni kullanıcı: tek kart, B1 "Başla"', (tester) async {
    await pump(tester, FakeContentSource(packageIds: _four));
    expect(find.byKey(const ValueKey('home-continue')), findsOneWidget);
    expect(find.text('Merhaba!'), findsOneWidget);
    expect(find.text('Hikâyen'), findsOneWidget);
    expect(find.text('Bu sezonda 12 bölüm var.'), findsOneWidget);
    expect(find.text('A Strange Message'), findsOneWidget);
    expect(find.text('İpucu 1.'), findsOneWidget);
    expect(find.text('SEZON 1 · BÖLÜM 1'), findsOneWidget);
    expect(find.text('Başla'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const ValueKey('home-continue-play')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('home-continue-play')));
    await tester.pumpAndSettle();
    expect(pushed, ['/play/A1-001']);
  });

  testWidgets('B1 bitti: kart B2\'yi gösterir', (tester) async {
    await progress.markCompleted('A1-001', gate: _fullGate);
    await pump(tester, FakeContentSource(packageIds: _four));
    expect(find.text('The New Neighbour'), findsOneWidget);
    expect(find.text('SEZON 1 · BÖLÜM 2'), findsOneWidget);
    expect(find.text('Başla'), findsOneWidget);
    expect(find.text("Bu sezonda 12 bölümden 1'i bitti."), findsOneWidget);
  });

  testWidgets('yarım bölüm: "Devam et" kaldığı yerden açar', (tester) async {
    await progress.markCompleted('A1-001', gate: _fullGate);
    await progress.saveCheckpoint(
      'A1-002',
      const EngineSnapshot(
        checkpointNodeId: 's03',
        flags: {},
        passedNodes: {},
        contentVersion: 1,
      ),
    );
    await pump(tester, FakeContentSource(packageIds: _four));
    expect(find.text('Devam et'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const ValueKey('home-continue-play')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('home-continue-play')));
    await tester.pumpAndSettle();
    expect(pushed, ['/play/A1-002?mode=resume']);
  });

  testWidgets('oynanacak bölüm kalmadı: sıradaki hazırlanıyor (tarih yok)', (
    tester,
  ) async {
    for (final id in _four) {
      await progress.markCompleted(id, gate: _fullGate);
    }
    await pump(tester, FakeContentSource(packageIds: _four));
    expect(find.text('Bölüm 5 hazırlanıyor'), findsOneWidget);
    expect(find.text('İpucu 5.'), findsOneWidget);
    await tester.ensureVisible(find.text('Haritaya git'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Haritaya git'));
    await tester.pumpAndSettle();
    expect(find.text('harita'), findsOneWidget);
  });

  testWidgets('sunucu kapalı: hata ve tekrar dene', (tester) async {
    final source = FakeContentSource(fail: true);
    await pump(tester, source);
    expect(find.text('Bağlantı kurulamadı'), findsOneWidget);
    expect(find.text('Hikâye yüklenemedi.'), findsOneWidget);
    source.fail = false;
    await tester.tap(find.byKey(const ValueKey('home-retry')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('A Strange Message'), findsOneWidget);
  });

  testWidgets('yüklenirken: spinner yok, kart iskeleti (H-054)', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final source = _SlowSeasonSource(packageIds: _four);
    await pump(tester, source);
    expect(find.byKey(const ValueKey('skeleton-home')), findsOneWidget);
    expect(find.byType(ContinueCardSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.bySemanticsLabel('Hikâyen yükleniyor…'), findsOneWidget);
    source.gate.complete();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(ContinueCardSkeleton), findsNothing);
    expect(find.text('A Strange Message'), findsOneWidget);
    handle.dispose();
  });

  // ------------------------------------------------------------ H-060

  Override overview(int due, {int total = 15}) =>
      reviewOverviewProvider.overrideWith(
        (ref) async => ReviewOverview(
          dueReviews: due,
          newAvailable: 0,
          totalItems: total,
          newPerDay: 10,
        ),
      );

  Override today(int minutes, int goal) => todayActivityProvider.overrideWith(
    (ref) async => TodayActivity(minutes: minutes, goalMinutes: goal),
  );

  testWidgets('H-060: sezon bitti — sakin kart, haritaya gider; ana eylem '
      'düğmesi yok', (tester) async {
    for (final id in _twelve) {
      await progress.markCompleted(id, gate: _fullGate);
    }
    await pump(tester, _AllBuiltSource());
    expect(find.byKey(const ValueKey('home-continue')), findsOneWidget);
    expect(find.text(HomeTexts.seasonDone), findsOneWidget);
    expect(find.text(HomeTexts.seasonDoneBody), findsOneWidget);
    expect(find.byKey(const ValueKey('home-continue-play')), findsNothing);
    // Ortak bilgi kartı (eski özel kart yerine).
    expect(
      find.ancestor(
        of: find.text(HomeTexts.seasonDone),
        matching: find.byType(InfoCard),
      ),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text(HomeTexts.goToMap));
    await tester.pumpAndSettle();
    await tester.tap(find.text(HomeTexts.goToMap));
    await tester.pumpAndSettle();
    expect(find.text('harita'), findsOneWidget);
  });

  testWidgets('H-060: tek ana eylem — ekranda yalnızca bir dolu (birincil) '
      'düğme; tekrar düğmesi çerçeveli', (tester) async {
    await pump(
      tester,
      FakeContentSource(packageIds: _four),
      overrides: [overview(5)],
    );
    expect(find.bySubtype<FilledButton>(), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('home-continue')),
        matching: find.bySubtype<FilledButton>(),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('home-review')),
        matching: find.bySubtype<OutlinedButton>(),
      ),
      findsOneWidget,
    );
  });

  testWidgets('H-060: kelime tekrarı — zamanı gelen ifade varsa sayı cümle '
      'içinde ve düğme; yoksa sakin cümle, düğme yok', (tester) async {
    await pump(
      tester,
      FakeContentSource(packageIds: _four),
      overrides: [overview(5)],
    );
    expect(
      find.text('5 ifadenin tekrar zamanı geldi · yaklaşık 2 dk'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('home-review-start')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());

    await pump(
      tester,
      FakeContentSource(packageIds: _four),
      overrides: [overview(0)],
    );
    expect(find.text(HomeTexts.reviewNone), findsOneWidget);
    expect(find.byKey(const ValueKey('home-review-start')), findsNothing);
    await tester.pumpWidget(const SizedBox());

    await pump(
      tester,
      FakeContentSource(packageIds: _four),
      overrides: [overview(0, total: 0)],
    );
    expect(find.text(HomeTexts.reviewEmpty), findsOneWidget);
    expect(find.byKey(const ValueKey('home-review-start')), findsNothing);
  });

  testWidgets('H-060: günlük hedef halkası bugünkü süreyi gösterir ve ekran '
      'okuyucuya tam cümleyle okunur', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      FakeContentSource(packageIds: _four),
      overrides: [today(6, 10)],
    );
    await tester.pumpAndSettle();
    expect(find.text('6/10'), findsOneWidget);
    expect(find.text('dk'), findsOneWidget);
    final ring = tester.widget<ProgressRing>(
      find.byKey(const ValueKey('home-goal-ring')),
    );
    expect(ring.value, closeTo(0.6, 1e-9));
    expect(
      find.bySemanticsLabel(
        'Günlük hedef: bugün yaklaşık 6 dakika, hedefin 10 dakika',
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('H-060: giriş animasyonu oynar; "Hareketi azalt" açıkken '
      'her şey ilk karede durağan', (tester) async {
    await pump(
      tester,
      FakeContentSource(packageIds: _four),
      overrides: [today(6, 10), overview(5)],
      waitForEntrance: false,
    );
    // Hareket açık: bölümler sırayla belirir (animasyon sürüyor).
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());

    await pump(
      tester,
      FakeContentSource(packageIds: _four),
      overrides: [today(6, 10), overview(5)],
      reduceMotion: true,
      waitForEntrance: false,
    );
    expect(tester.hasRunningAnimations, isFalse);
    // Sırayla belirme yok: içerik ilk karede tam görünür.
    final handle = tester.ensureSemantics();
    await tester.pump();
    expect(find.bySemanticsLabel('A Strange Message'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'Günlük hedef: bugün yaklaşık 6 dakika, hedefin 10 dakika',
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  group('H-060: bugünkü süre tahmini', () {
    test('hedef aşılınca halka "10/10" + onay gösterir', () {
      expect(HomeTexts.goalRing(6, 10), '6/10');
      expect(HomeTexts.goalReached(6, 10), isFalse);
      expect(HomeTexts.goalRing(10, 10), '10/10');
      expect(HomeTexts.goalRing(12, 10), '10/10');
      expect(HomeTexts.goalReached(12, 10), isTrue);
      expect(HomeTexts.goalSemantics(12, 10), contains('tamamlandı'));
      expect(HomeTexts.goalSemantics(6, 10), isNot(contains('tamamlandı')));
    });

    test('biten bölümler (bilinmeyen süre 6 dk) + tekrarda geçen süre '
        '(cevap başına en çok 2 dk, yukarı yuvarlanır)', () {
      expect(estimateTodayMinutes(episodeMinutes: const []), 0);
      expect(estimateTodayMinutes(episodeMinutes: const [7, null]), 13);
      expect(
        estimateTodayMinutes(
          episodeMinutes: const [],
          reviewTimes: const [Duration(seconds: 20), Duration(seconds: 50)],
        ),
        2,
      );
      expect(
        estimateTodayMinutes(
          episodeMinutes: const [5],
          // Açık unutulan kart 2 dk sayılır.
          reviewTimes: const [Duration(minutes: 30)],
        ),
        7,
      );
    });

    test('halka hedefte dolar, aşınca dolu kalır', () {
      expect(const TodayActivity(minutes: 0, goalMinutes: 10).progress, 0);
      expect(const TodayActivity(minutes: 5, goalMinutes: 10).progress, 0.5);
      expect(const TodayActivity(minutes: 25, goalMinutes: 10).progress, 1);
    });
  });
}

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

/// Sezon paketi [gate] tamamlanana dek gelmez (yükleniyor durumu).
class _SlowSeasonSource extends FakeContentSource {
  _SlowSeasonSource({super.packageIds});

  final Completer<void> gate = Completer<void>();

  @override
  Future<SeasonInfo> loadSeason(int season) async {
    await gate.future;
    return super.loadSeason(season);
  }
}
