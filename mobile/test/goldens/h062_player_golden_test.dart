// H-062 oynatıcı katmanları golden'ları ve erişilebilirlik denetimi: karar
// kartı ("Ne dersin?"), Hi'nin ipucu paneli, 🎯 görev paneli, anlam paneli ve
// bölüm sonu (sakin kutlama).
//
// Karar, ipucu ve 🎯 paneli gerçek oynatıcı ekranında (B1, sahte video ve
// içerik); video ve durağan görseller testte açılmaz, koyu oynatıcı zemini
// görünür. Anlam paneli ve bölüm sonu tek başına (aynı bileşenler).
// "Hareketi azalt" açık: golden son hâli çizer (giriş animasyonları ayrı
// testte, `test/features/player/h062_design_test.dart`). Bilinçli görsel
// değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/features/player/presentation/player_screen.dart';
import 'package:hivelzon/features/player/presentation/widgets/end_view.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/meaning/meaning_controller.dart';
import 'package:hivelzon/shared/meaning/meaning_sheet.dart';
import 'package:hivelzon/shared/meaning/meaning_text.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../support/app_fonts.dart';
import '../support/fake_content_source.dart';
import '../support/fake_video_platform.dart';
import '../support/fixtures.dart';
import '../support/golden.dart';

Future<void> _step(WidgetTester tester, int ms) async {
  for (var i = 0; i < ms ~/ 100; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final f = find.byKey(ValueKey(key));
  await tester.ensureVisible(f);
  await tester.tap(f);
  await _step(tester, 400);
}

/// Bölümü baştan sona yürütür: kararlarda doğru seçenek, görevler tamam.
EpisodeEngine finishedEngine(String id) {
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

class _FakeAudio implements MeaningAudio {
  @override
  bool get canPlayWords => true;
  @override
  bool get canPlaySentence => true;
  @override
  Future<void> playWord(MeaningWord word, {required double speed}) async {}
  @override
  Future<void> playSentence({required double speed}) async {}
  @override
  Future<void> stop() async {}
}

const _meaningText = MeaningText(
  contentId: 'A1-002',
  sourceId: 'k2-ok-01',
  speaker: 'ALEX',
  en: 'Excuse me, where is the old station?',
  tr: 'Affedersiniz, eski istasyon nerede?',
  words: [
    MeaningWord('Excuse', gloss: 'affetmek', start: 0.1, end: 0.4),
    MeaningWord('me,', gloss: 'beni', start: 0.4, end: 0.6),
    MeaningWord('where', gloss: 'nerede', start: 0.7, end: 0.9),
    MeaningWord('is', gloss: '-dır', start: 0.9, end: 1.0),
    MeaningWord('the', gloss: '(belirli)', start: 1.0, end: 1.1),
    MeaningWord('old', gloss: 'eski', start: 1.1, end: 1.3),
    MeaningWord('station?', gloss: 'istasyon', start: 1.3, end: 1.8),
  ],
  chunks: [
    PhraseChunk(en: 'Excuse me', tr: 'Affedersiniz', startWord: 0, endWord: 1),
    PhraseChunk(en: 'where is…?', tr: '… nerede?', startWord: 2, endWord: 6),
  ],
);

enum _Kind { player, standalone }

class _Case {
  const _Case(this.kind, {this.act, this.build});

  final _Kind kind;

  /// Oynatıcıda: kararın açılmasından sonra yapılacaklar.
  final Future<void> Function(WidgetTester tester)? act;

  /// Tek başına çizilecek bileşen.
  final Widget Function()? build;
}

final _cases = <String, _Case>{
  'karar': const _Case(_Kind.player),
  'ipucu': _Case(
    _Kind.player,
    act: (tester) async {
      await tester.tap(find.text("Hi'den ipucu al"));
      await _step(tester, 400);
      await _tapKey(tester, 'hint-more');
    },
  ),
  'gorev_paneli': _Case(
    _Kind.player,
    act: (tester) => _tapKey(tester, 'mission-button'),
  ),
  'anlam_paneli': _Case(
    _Kind.standalone,
    build: () {
      final c = MeaningController(
        text: _meaningText,
        audio: _FakeAudio(),
        events: InMemoryLearningEventLog(),
        notebook: InMemoryNotebookRepository(),
        now: () => DateTime.utc(2026, 10, 14, 12),
      );
      c.selectWord(6);
      c.reveal();
      return Scaffold(
        backgroundColor: AppPalette.sand,
        body: SafeArea(child: MeaningSheet(controller: c)),
      );
    },
  ),
  'bolum_sonu': _Case(
    _Kind.standalone,
    // Oynatıcıdaki gibi Scaffold içinde (konu seti satırı ve düğmesiyle).
    build: () => Scaffold(
      body: EndView(
        engine: finishedEngine('A1-001'),
        onBack: () {},
        topicSetTitle: "Alex'in odası",
        onOpenTopicSet: () {},
      ),
    ),
  ),
};

void main() {
  setUpAll(loadAppFonts);

  Future<void> pumpCase(
    WidgetTester tester,
    _Case c, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    VideoPlayerPlatform.instance = FakeVideoPlatform(
      durationFor: (uri) => uri.endsWith('.m4a')
          ? const Duration(milliseconds: 500)
          : const Duration(seconds: 1),
    );
    Widget app(Widget home) => RepaintBoundary(
      key: const ValueKey('golden'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: home,
      ),
    );
    if (c.kind == _Kind.standalone) {
      await tester.pumpWidget(app(c.build!()));
      await tester.pump();
      return;
    }
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
        child: app(const PlayerScreen(contentId: 'A1-001')),
      ),
    );
    await _step(tester, 300);
    await _step(tester, 1500); // başlık → s02
    await _step(tester, 1500); // s02 → karar k1
    expect(find.text('Ne dersin?'), findsOneWidget);
    // Yapay zekâ notu (4 sn) kaybolsun: golden kararın kendisini göstersin.
    await _step(tester, 4000);
    if (c.act != null) await c.act!(tester);
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await _step(tester, 6000);
  }

  for (final MapEntry(key: id, value: c) in _cases.entries) {
    testWidgets('golden: $id', (tester) async {
      await pumpCase(tester, c);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h062_$id.png'),
      );
      await unmount(tester);
    }, skip: skipGoldensOffMac);

    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCase(tester, c);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // Piksel ölçümü yazı tipi çizimine bağlı; yalnız golden'ların
      // üretildiği macOS'ta.
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
