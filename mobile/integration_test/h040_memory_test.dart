// H-040 Keşfet bellek ölçümü (gerçek video, simülatör ya da cihaz).
//
// Akış uygulamadan bağımsız açılır: bellekte veritabanı (cihazdaki veriye
// dokunmaz), gerçek içerik sunucusu ve gerçek video oynatıcı. Her sayfada
// birkaç saniye oynatılır; süreç belleği (RSS) ve canlı denetleyici sayısı
// örneklenir, sonra sonraki sayfaya kaydırılır. Satırlar `[H040]` ile başlar.
//
//   python3 tools/dev-content-server/serve.py --port 8797   # ayrı terminal
//   cd mobile && flutter test integration_test/h040_memory_test.dart \
//     -d <simülatör> --dart-define=CONTENT_BASE_URL=http://127.0.0.1:8797
//
// Ölçümü `--dart-define=H040_DWELL_MS=3000` (sayfa başına bekleme) ve
// `H040_ROUNDS=2` (akışı baştan kaç kez) değiştirir.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';
import 'package:hivelzon/features/discover/presentation/discover_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:integration_test/integration_test.dart';

const _dwellMs = int.fromEnvironment('H040_DWELL_MS', defaultValue: 3000);
const _rounds = int.fromEnvironment('H040_ROUNDS', defaultValue: 2);

double _mb(int bytes) => bytes / (1024 * 1024);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('H-040 Keşfet bellek ölçümü', (t) async {
    Future<void> wait(int ms) async {
      final end = DateTime.now().add(Duration(milliseconds: ms));
      while (DateTime.now().isBefore(end)) {
        await t.pump(const Duration(milliseconds: 100));
      }
    }

    Future<void> waitFor(Finder f, {int seconds = 30}) async {
      final end = DateTime.now().add(Duration(seconds: seconds));
      while (DateTime.now().isBefore(end)) {
        await t.pump(const Duration(milliseconds: 200));
        if (f.evaluate().isNotEmpty) return;
      }
      throw TestFailure('Bulunamadı: $f');
    }

    final db = AppDatabase.memory();
    final progress = InMemoryProgressRepository();
    for (var n = 1; n < 4; n++) {
      await progress.markCompleted(
        'A1-00$n',
        gate: {
          for (final g in GateItem.values) g: {'x'},
        },
      );
    }
    final router = GoRouter(
      initialLocation: '/kesfet',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SizedBox()),
        GoRoute(path: '/kesfet', builder: (_, _) => const DiscoverScreen()),
      ],
    );
    final baseline = ProcessInfo.currentRss;
    debugPrint('[H040] başlangıç RSS ${_mb(baseline).toStringAsFixed(1)} MB');
    await t.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          progressRepositoryProvider.overrideWithValue(progress),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await waitFor(find.byType(DiscoverFeed));
    await waitFor(find.byKey(const ValueKey('clip-page-S1-K01')));
    final state = t.state<DiscoverFeedState>(find.byType(DiscoverFeed));
    final feed = state.feed;
    debugPrint(
      '[H040] akış: ${feed.length} sayfa '
      '(${feed.whereType<ClipEntry>().length} klip)',
    );
    var peakRss = ProcessInfo.currentRss;
    var peakLive = 0;
    final perPage = <String>[];
    for (var round = 0; round < _rounds; round++) {
      if (round > 0) {
        state.jumpTo(0);
        await wait(500);
      }
      for (var i = 0; i < feed.length; i++) {
        await wait(_dwellMs);
        final rss = ProcessInfo.currentRss;
        final live = state.cache.liveCount;
        if (rss > peakRss) peakRss = rss;
        if (live > peakLive) peakLive = live;
        final e = feed[state.index];
        final label = switch (e) {
          ClipEntry(:final clip) => clip.id,
          QuizEntry() => 'quiz',
          BreakEntry() => 'mola',
          EndEntry() => 'bitiş',
        };
        perPage.add('$label ${_mb(rss).toStringAsFixed(0)}');
        debugPrint(
          '[H040] tur ${round + 1} sayfa ${state.index} $label: '
          'RSS ${_mb(rss).toStringAsFixed(1)} MB, canlı denetleyici $live',
        );
        expect(live, lessThanOrEqualTo(3));
        if (e is EndEntry) break;
        await t.fling(
          find.byKey(const ValueKey('discover-pages')),
          const Offset(0, -500),
          2000,
        );
        await wait(700);
      }
    }
    final end = ProcessInfo.currentRss;
    debugPrint(
      '[H040] SONUÇ: başlangıç ${_mb(baseline).toStringAsFixed(1)} MB, '
      'en yüksek ${_mb(peakRss).toStringAsFixed(1)} MB '
      '(+${_mb(peakRss - baseline).toStringAsFixed(1)}), bitiş '
      '${_mb(end).toStringAsFixed(1)} MB, en yüksek süreç RSS '
      '${_mb(ProcessInfo.maxRss).toStringAsFixed(1)} MB; aynı anda en çok '
      '$peakLive denetleyici (sınır 3), kurulan ${state.cache.created}',
    );
    expect(peakLive, lessThanOrEqualTo(3));
    await t.pumpWidget(const SizedBox());
    await wait(1500);
    debugPrint(
      '[H040] akış kapandıktan sonra RSS '
      '${_mb(ProcessInfo.currentRss).toStringAsFixed(1)} MB',
    );
    router.dispose();
    await db.close();
  });
}
