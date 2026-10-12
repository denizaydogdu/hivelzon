import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/home/presentation/home_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
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

  Future<void> pump(WidgetTester tester, FakeContentSource source) async {
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
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
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
}
