// H-062: oynatıcı katmanlarının tasarımı — giriş animasyonları (karar kartı,
// Hi paneli, kartlar), sakin bölüm sonu, "Hareketi azalt"ta durağanlık ve
// tasarımın oynatma zamanlamasını bozmadığı (H-031: segment geçişi ≤ 150 ms;
// H-054: altyazı ekranda ≤ 0,2 sn içinde).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/features/player/presentation/player_screen.dart';
import 'package:hivelzon/features/player/presentation/widgets/card_view.dart';
import 'package:hivelzon/features/player/presentation/widgets/decision_sheet.dart';
import 'package:hivelzon/features/player/presentation/widgets/end_view.dart';
import 'package:hivelzon/features/player/presentation/widgets/hi_avatar.dart';
import 'package:hivelzon/features/player/presentation/widgets/player_ui.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/ui/ui.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';
import '../../support/fixtures.dart';

DecisionNode _k1() => loadFixture('A1-001').node('k1') as DecisionNode;

/// Bölümü baştan sona yürütür: kararlarda doğru seçenek, görevler tamam.
EpisodeEngine _finished(String id) {
  final e = EpisodeEngine(loadFixture(id));
  while (!e.isFinished) {
    switch (e.current) {
      case DecisionNode(:final options):
        e.choose(options.firstWhere((o) => o.correct).id);
      case TaskNode():
        e.completeTask();
      default:
        e.advance();
    }
  }
  return e;
}

Future<void> _pumpAlone(
  WidgetTester tester,
  Widget child, {
  bool reduceMotion = false,
}) async {
  tester.view.physicalSize = const Size(1179, 2556);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(393, 852),
          disableAnimations: reduceMotion,
        ),
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
}

/// [of] altındaki bütün `Opacity` değerlerinin en küçüğü.
double _minOpacity(WidgetTester tester, Finder of) {
  final ops = tester
      .widgetList<Opacity>(
        find.descendant(of: of, matching: find.byType(Opacity)),
      )
      .map((o) => o.opacity);
  return ops.isEmpty ? 1 : ops.reduce((a, b) => a < b ? a : b);
}

void main() {
  group('karar kartı', () {
    testWidgets('hareket açıkken alttan belirir, seçenekler sırayla gelir; '
        'ilk karede de dokunulur', (tester) async {
      final chosen = <String>[];
      await _pumpAlone(
        tester,
        DecisionSheet(
          node: _k1(),
          onChoose: (o) => chosen.add(o.id),
          onListen: (_) {},
          onHint: () {},
        ),
      );
      final sheet = find.byType(DecisionSheet);
      expect(
        find.descendant(of: sheet, matching: find.byType(SoftEntrance)),
        findsNWidgets(3), // kart + 2 seçenek
      );
      expect(_minOpacity(tester, sheet), lessThan(1));
      // Giriş oynarken dokunma çalışır (giriş oynatmayı ya da seçimi
      // bekletmez).
      await tester.tap(find.byKey(const ValueKey('option-a')));
      expect(chosen, ['a']);
      // Giriş kısa: en geç 250 ms + seçenek başına 50 ms.
      await tester.pump(AppMotion.base + AppMotion.stagger * 2);
      expect(_minOpacity(tester, sheet), 1);
      expect(find.text(PlayerTexts.decisionHeading), findsOneWidget);
      expect(find.text(PlayerTexts.askHint), findsOneWidget);
    });

    testWidgets('"Hareketi azalt" açıkken durağan', (tester) async {
      await _pumpAlone(
        tester,
        DecisionSheet(
          node: _k1(),
          onChoose: (_) {},
          onListen: (_) {},
          onHint: () {},
        ),
        reduceMotion: true,
      );
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(_minOpacity(tester, find.byType(DecisionSheet)), 1);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('seçenekler en az 56 px, basınca hafifçe küçülür', (
      tester,
    ) async {
      await _pumpAlone(
        tester,
        DecisionSheet(
          node: _k1(),
          onChoose: (_) {},
          onListen: (_) {},
          onHint: null,
        ),
        reduceMotion: true,
      );
      final option = find.byKey(const ValueKey('option-a'));
      expect(tester.getSize(option).height, greaterThanOrEqualTo(56));
      expect(
        find.ancestor(of: option, matching: find.byType(PressScale)),
        findsOneWidget,
      );
    });
  });

  group('Hi paneli', () {
    testWidgets('Hi sakin belirir, panel ve eylemler sırayla gelir', (
      tester,
    ) async {
      await _pumpAlone(
        tester,
        HiPanel(
          title: PlayerTexts.hintTitle(1, 3),
          text: 'Kafede daha kibar: *Can I have …, please?*',
          actions: [FilledButton(onPressed: () {}, child: const Text('Tamam'))],
        ),
      );
      final panel = find.byType(HiPanel);
      expect(
        find.descendant(of: panel, matching: find.byType(CalmPop)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: panel, matching: find.byType(SoftEntrance)),
        findsNWidgets(2),
      );
      expect(_minOpacity(tester, panel), lessThan(1));
      await tester.pump(AppMotion.slow);
      expect(_minOpacity(tester, panel), 1);
      expect(find.text('İpucu 1 / 3'), findsOneWidget);
      // Hi'nin nabzı sürer; ekrandan kaldırınca durur.
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('"Hareketi azalt" açıkken durağan (nabız da yok)', (
      tester,
    ) async {
      await _pumpAlone(
        tester,
        HiPanel(
          text: 'Acele yok.',
          actions: [FilledButton(onPressed: () {}, child: const Text('Tamam'))],
        ),
        reduceMotion: true,
      );
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(_minOpacity(tester, find.byType(HiPanel)), 1);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('kartlar', () {
    testWidgets('ipucu kartı: büyük harfli etiket, giriş; azaltılmışsa '
        'durağan', (tester) async {
      final ep = loadFixture('A1-001');
      final clue = ep.nodes.values.whereType<CardNode>().firstWhere(
        (n) => n.kind == CardKind.clue,
      );
      final engine = EpisodeEngine(ep);
      Widget card() =>
          CardView(card: clue, lines: engine.linesFor(clue), onContinue: () {});
      await _pumpAlone(tester, card());
      expect(find.text('YENİ İPUCU'), findsOneWidget);
      expect(find.byType(CapsLabel), findsOneWidget);
      expect(find.byType(SoftEntrance), findsWidgets);
      await tester.pump(AppMotion.base + AppMotion.stagger);
      expect(_minOpacity(tester, find.byType(CardView)), 1);

      await tester.pumpWidget(const SizedBox());
      await _pumpAlone(tester, card(), reduceMotion: true);
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('bölüm sonu', () {
    testWidgets('sakin kutlama ve bölümler; puan ya da geri sayım yok', (
      tester,
    ) async {
      await _pumpAlone(
        tester,
        SizedBox(
          height: 2000,
          child: EndView(engine: _finished('A1-001'), onBack: () {}),
        ),
      );
      expect(find.byType(CalmCelebration), findsOneWidget);
      // H-063: bayrak yerine mutlu Hi.
      expect(find.byIcon(Icons.flag_rounded), findsNothing);
      expect(
        tester
            .widget<HiAvatar>(find.byKey(const ValueKey('end-hi')))
            .expression,
        HiExpression.happy,
      );
      expect(find.text(PlayerTexts.endTitle), findsOneWidget);
      expect(find.text('TOPLANAN İPUÇLARI'), findsOneWidget);
      expect(find.text('AÇIK SORU'), findsOneWidget);
      expect(find.text('BU BÖLÜMÜN İFADELERİ'), findsOneWidget);
      expect(find.textContaining('puan'), findsNothing);
      await tester.pumpAndSettle();
      expect(_minOpacity(tester, find.byType(EndView)), 1);
    });

    testWidgets('"Hareketi azalt" açıkken durağan', (tester) async {
      await _pumpAlone(
        tester,
        SizedBox(
          height: 2000,
          child: EndView(engine: _finished('A1-001'), onBack: () {}),
        ),
        reduceMotion: true,
      );
      expect(find.byType(CalmCelebration), findsOneWidget);
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('oynatma zamanlaması (H-031, H-054) hareket açıkken bozulmaz', () {
    late FakeVideoPlatform platform;

    Future<void> pumpPlayer(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1179, 2556);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            legacyImportProvider.overrideWithValue(Future<void>.value()),
            contentSourceProvider.overrideWithValue(FakeContentSource()),
            progressRepositoryProvider.overrideWithValue(
              InMemoryProgressRepository(),
            ),
            learningEventLogProvider.overrideWithValue(
              InMemoryLearningEventLog(),
            ),
            notebookRepositoryProvider.overrideWithValue(
              InMemoryNotebookRepository(),
            ),
            playerHooksProvider.overrideWithValue(null),
            playerCoachProvider.overrideWithValue(null),
          ],
          // "Hareketi azalt" kapalı: giriş animasyonları oynar.
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const PlayerScreen(contentId: 'A1-001'),
          ),
        ),
      );
    }

    Future<void> step(WidgetTester tester, int ms, {int every = 100}) async {
      for (var i = 0; i < ms ~/ every; i++) {
        await tester.pump(Duration(milliseconds: every));
      }
    }

    testWidgets('karar kartının ilk karesinde seçim; yanıt videosu hemen '
        'başlar ve sıradaki segmente geçiş ≤ 150 ms', (tester) async {
      platform = FakeVideoPlatform(
        durationFor: (uri) => uri.endsWith('.m4a')
            ? const Duration(milliseconds: 500)
            : const Duration(seconds: 1),
      );
      VideoPlayerPlatform.instance = platform;
      await pumpPlayer(tester);
      await step(tester, 300);
      await step(tester, 1500); // başlık → s02
      // s02 biter bitmez karar kartı gelir; girişi bitmeden seç.
      var waited = 0;
      while (find.byKey(const ValueKey('option-a')).evaluate().isEmpty &&
          waited < 3000) {
        await tester.pump(const Duration(milliseconds: 10));
        waited += 10;
      }
      expect(find.text(PlayerTexts.decisionHeading), findsOneWidget);
      expect(
        _minOpacity(tester, find.byType(DecisionSheet)),
        lessThan(1),
        reason: 'giriş animasyonu sürüyor',
      );
      await tester.tap(find.byKey(const ValueKey('option-a')));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      expect(platform.isPlaying('segments/k1-ok.720p.mp4'), isTrue);

      // k1-ok (1 sn) → s03: oynatma başının yeni segmente geçişi.
      int? endedAt;
      int? startedAt;
      for (var t = 0; t < 2000 && startedAt == null; t += 10) {
        await tester.pump(const Duration(milliseconds: 10));
        final okPlaying = platform.isPlaying('segments/k1-ok.720p.mp4');
        if (endedAt == null && !okPlaying) endedAt = t;
        if (endedAt != null && platform.isPlaying('segments/s03.720p.mp4')) {
          startedAt = t;
        }
      }
      expect(endedAt, isNotNull);
      expect(startedAt, isNotNull);
      debugPrint('[H062] k1-ok → s03 geçişi ${startedAt! - endedAt!} ms');
      expect(startedAt - endedAt, lessThanOrEqualTo(150));

      await tester.pumpWidget(const SizedBox());
      await step(tester, 6000);
    });

    testWidgets('altyazı satırı, oynatma başladıktan sonra ≤ 0,2 sn içinde '
        'ekranda', (tester) async {
      // Segment 5 sn; oynatma başı 0,7. sn: "OK. Friday." (0,59–1,87).
      platform = FakeVideoPlatform(
        durationFor: (uri) => uri.endsWith('.m4a')
            ? const Duration(milliseconds: 500)
            : const Duration(seconds: 5),
        positionFor: (_) => const Duration(milliseconds: 700),
      );
      VideoPlayerPlatform.instance = platform;
      await pumpPlayer(tester);
      await step(tester, 300);
      // Başlık (5 sn) kendiliğinden geçer → s02.
      var t = 0;
      while (!platform.isPlaying('segments/s02.720p.mp4') && t < 8000) {
        await tester.pump(const Duration(milliseconds: 10));
        t += 10;
      }
      expect(platform.isPlaying('segments/s02.720p.mp4'), isTrue);
      var shownAfter = -1;
      for (var ms = 0; ms <= 200; ms += 10) {
        if (find.text('OK. Friday.').evaluate().isNotEmpty) {
          shownAfter = ms;
          break;
        }
        await tester.pump(const Duration(milliseconds: 10));
      }
      debugPrint('[H062] altyazı $shownAfter ms sonra ekranda');
      expect(shownAfter, inInclusiveRange(0, 200));
      await tester.pumpWidget(const SizedBox());
      await step(tester, 6000);
    });
  });
}
