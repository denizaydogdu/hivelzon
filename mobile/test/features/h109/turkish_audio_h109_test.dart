import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/discover/domain/clip.dart';
import 'package:hivelzon/features/discover/domain/feed_video.dart';
import 'package:hivelzon/features/discover/domain/reel.dart';
import 'package:hivelzon/features/discover/presentation/widgets/feed_cards.dart';
import 'package:hivelzon/features/player/domain/subtitles.dart';
import 'package:hivelzon/features/player/presentation/player_screen.dart'
    show videoControllerFactoryProvider;
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/features/grammar/domain/grammar_lesson.dart';

import '../../support/fake_content_source.dart';
import '../../support/grammar_harness.dart';
import '../../support/library_harness.dart';
import '../../support/talk_harness.dart' show FakeAudioController;

/// H-109: yeni Türkçe ses yerleri. Düğme yalnız ses varken görünür, yalnız
/// dokununca çalar; paket alanı yoksa (eski paket) hiçbir şey değişmez.
void main() {
  group('paket alanları', () {
    test('kitap: soru Türkçesi ve tanıtım sesi `trAudio`dan okunur', () {
      final plain = loadTestBook();
      expect(plain.blurbTrAudio, isNull);
      expect(
        plain.comprehension!.questions.map((q) => q.promptTrAudio),
        everyElement(isNull),
      );
      final b = loadTestBook(turkishAudio: const {'q2', 'blurb'});
      expect(b.blurbTrAudio, 'audio/tr/blurb.m4a');
      expect(b.comprehension!.questions.map((q) => q.promptTrAudio), [
        null,
        'audio/tr/q2.m4a',
      ]);
    });

    test('dilbilgisi: açıklama sesi alıştırma maddesinde', () {
      final item = PracticeItem.fromJson({
        'id': 'c07-q1',
        'kind': 'choose',
        'stem': 'I ___ Ece.',
        'options': [
          {'text': 'am', 'correct': true},
          {'text': 'is', 'correct': false},
        ],
        'feedbackTr': 'Ben için am gelir.',
        'feedbackAudio': 'audio/c07-q1-fb.m4a',
        'feedbackDuration': 2.4,
      })!;
      expect(item.feedbackAudio, 'audio/c07-q1-fb.m4a');
      expect(item.feedbackDuration, 2.4);
      final old = PracticeItem.fromJson({
        'id': 'c07-q1',
        'kind': 'fill',
        'stem': 'I ___ Ece.',
        'answers': ['am'],
        'feedbackTr': 'Ben için am gelir.',
      })!;
      expect(old.feedbackAudio, isNull);
    });

    test(
      'reel: alıştırma sesi `practice.audioTr`dan; bozuk alan yok sayılır',
      () {
        Map<String, dynamic> doc(Object? audioTr) => {
          'schemaVersion': 1,
          'id': 'A1-R-CIN-01',
          'category': 'CIN',
          'level': 'A1',
          'titleTr': 'Gişede iki bilet',
          'duration': 12.6,
          'video': 'A1-R-CIN-01.mp4',
          'target': {
            'kind': 'phrase',
            'en': 'Two tickets, please.',
            'tr': 'İki bilet, lütfen.',
          },
          'practice': {
            'promptTr': 'Kaç bilet isteniyor?',
            'explainTr': 'Mia iki bilet istiyor.',
            'options': [
              {'text': 'İki', 'lang': 'tr', 'correct': true},
              {'text': 'Bir', 'lang': 'tr', 'correct': false},
            ],
            'audioTr': ?audioTr,
          },
          'cues': const [],
        };
        final r = Reel.fromJson(
          doc({
            'prompt': {
              'audio': 'audio/tr/practice-prompt.m4a',
              'duration': 3.1,
              'textSha256': 'x',
            },
            'explain': {'audio': 'audio/tr/practice-explain.m4a'},
          }),
        );
        expect(r.practice!.promptAudio, 'audio/tr/practice-prompt.m4a');
        expect(r.practice!.explainAudio, 'audio/tr/practice-explain.m4a');
        final none = Reel.fromJson(doc(null));
        expect(none.practice!.promptAudio, isNull);
        final bad = Reel.fromJson(
          doc({
            'prompt': 'x',
            'explain': {'audio': 3},
          }),
        );
        expect(bad.practice!.promptAudio, isNull);
        expect(bad.practice!.explainAudio, isNull);
      },
    );
  });

  group('kitap sonu soru Türkçesi', () {
    Future<void> toEnd(WidgetTester tester, LibraryHarness h) async {
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byKey(const ValueKey('reader-next')));
        await h.settle(tester);
      }
      await tester.tap(find.byKey(const ValueKey('reader-finish')));
      await h.settle(tester);
    }

    final q1 = find.byKey(const ValueKey('comp-q1-tr-listen'));
    final q2 = find.byKey(const ValueKey('comp-q2-tr-listen'));

    testWidgets('ses yoksa düğme yok', (tester) async {
      final h = LibraryHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99?mod=oku');
      await toEnd(tester, h);
      expect(find.text('Kutu ne renk?'), findsOneWidget);
      expect(q1, findsNothing);
      expect(q2, findsNothing);
    });

    testWidgets('yalnız sesi olan soruda düğme; kendiliğinden çalmaz, '
        'dokununca çalar, ikinci dokunuş durdurur', (tester) async {
      final h = LibraryHarness(turkishAudio: const {'q1'});
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99?mod=oku');
      await toEnd(tester, h);
      expect(q1, findsOneWidget);
      expect(q2, findsNothing);
      expect(h.players, isEmpty);
      await tester.ensureVisible(q1);
      await h.settle(tester);
      await tester.tap(q1);
      await h.settle(tester);
      expect(h.players, hasLength(1));
      expect(
        h.players.single.uri.toString(),
        'http://test.invalid/books/A1-K99/audio/tr/q1.m4a',
      );
      expect(h.players.single.played, isTrue);
      expect(
        find.descendant(of: q1, matching: find.byIcon(Icons.stop_rounded)),
        findsOneWidget,
      );
      await tester.tap(q1);
      await h.settle(tester);
      expect(
        find.descendant(of: q1, matching: find.byIcon(Icons.stop_rounded)),
        findsNothing,
      );
    });
  });

  group('dilbilgisi yanlış cevap açıklaması', () {
    const route = '/dilbilgisi/$kTestLessonId';
    Finder key(String k) => find.byKey(ValueKey(k));
    final listen = key('feedback-listen-c05-q1');

    Future<void> wrongAnswer(WidgetTester tester, GrammarHarness h) async {
      await h.next(tester, 4);
      await tester.tap(key('opt-0'));
      await h.settle(tester, rounds: 3);
      expect(key('practice-feedback'), findsOneWidget);
    }

    testWidgets('ses yoksa düğme yok', (tester) async {
      final h = GrammarHarness();
      addTearDown(h.dispose);
      await h.pump(tester, route);
      await wrongAnswer(tester, h);
      expect(find.text('Tek kişi var; fiile ek gelir.'), findsOneWidget);
      expect(listen, findsNothing);
    });

    testWidgets(
      'ses varsa düğme; kendiliğinden çalmaz, dokununca ders paketinden '
      'çalar (ders sesi duraklı), ikinci dokunuş durdurur; sessiz modda '
      'gizli',
      (tester) async {
        final h = GrammarHarness(feedbackAudio: true);
        addTearDown(h.dispose);
        await h.pump(tester, route);
        await wrongAnswer(tester, h);
        expect(listen, findsOneWidget);
        expect(h.players, isEmpty);
        await tester.ensureVisible(listen);
        await h.settle(tester, rounds: 3);
        await tester.tap(listen);
        await h.settle(tester, rounds: 5);
        expect(h.players, hasLength(1));
        expect(
          h.players.single.uri.toString(),
          'http://test.invalid/grammar/$kTestLessonId/audio/c05-q1-fb.m4a',
        );
        expect(h.players.single.played, isTrue);
        expect(h.audio.playing, isFalse);
        bool playing() => find
            .descendant(of: listen, matching: find.byIcon(Icons.stop_rounded))
            .evaluate()
            .isNotEmpty;
        expect(playing(), isTrue);
        await tester.tap(listen);
        await h.settle(tester, rounds: 5);
        expect(playing(), isFalse);
        // Sessiz mod: düğme gizlenir.
        await tester.tap(key('lesson-sound'));
        await h.settle(tester);
        expect(
          find.descendant(of: listen, matching: key('hi-listen')),
          findsNothing,
        );
        expect(find.text('Tek kişi var; fiile ek gelir.'), findsOneWidget);
      },
    );
  });

  group('Keşfet reel alıştırması', () {
    FeedVideo video({
      String prefix = 'reel',
      String? promptAudio,
      String? explainAudio,
    }) => FeedVideo(
      keyPrefix: prefix,
      id: 'A1-R-CIN-01',
      titleTr: 'Gişede iki bilet',
      cacheKey: 'reels/A1-R-CIN-01/A1-R-CIN-01.mp4',
      mediaUri: Uri.parse('http://test.invalid/reels/A1-R-CIN-01/v.mp4'),
      subtitles: SubtitleTrack.fromJson(const {
        'schemaVersion': 1,
        'segment': 'A1-R-CIN-01',
        'duration': 12.6,
        'cues': [],
      }),
      target: const ClipTarget(
        kind: 'phrase',
        en: 'Two tickets, please.',
        tr: 'İki bilet, lütfen.',
      ),
      practice: ClipQuiz(
        promptTr: 'Kaç bilet isteniyor?',
        explainTr: 'Mia iki bilet istiyor.',
        promptAudio: promptAudio,
        explainAudio: explainAudio,
        options: const [
          ClipQuizOption(text: 'İki', correct: true),
          ClipQuizOption(text: 'Bir'),
        ],
      ),
    );

    Future<List<FakeAudioController>> pump(
      WidgetTester tester,
      FeedVideo v,
    ) async {
      final players = <FakeAudioController>[];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            contentSourceProvider.overrideWithValue(
              FakeContentSource(packageIds: const ['A1-001']),
            ),
            videoControllerFactoryProvider.overrideWithValue((uri) {
              final c = FakeAudioController(uri);
              players.add(c);
              return c;
            }),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: PracticeCard(video: v, onNext: () {}),
            ),
          ),
        ),
      );
      await tester.pump();
      return players;
    }

    final prompt = find.byKey(const ValueKey('practice-prompt-listen'));
    final explain = find.byKey(const ValueKey('practice-explain-listen'));

    testWidgets(
      'ses yoksa ya da klibin yolu sezon paketinde değilse düğme yok',
      (tester) async {
        await pump(tester, video());
        expect(find.text('Kaç bilet isteniyor?'), findsOneWidget);
        expect(prompt, findsNothing);
        await pump(
          tester,
          video(prefix: 'clip', promptAudio: 'audio/tr/practice-prompt.m4a'),
        );
        expect(prompt, findsNothing);
      },
    );

    testWidgets('soru düğmesi dokununca reel paketinden çalar; açıklama '
        'düğmesi yalnız cevaptan sonra', (tester) async {
      final players = await pump(
        tester,
        video(
          promptAudio: 'audio/tr/practice-prompt.m4a',
          explainAudio: 'audio/tr/practice-explain.m4a',
        ),
      );
      expect(prompt, findsOneWidget);
      expect(explain, findsNothing);
      expect(players, isEmpty);
      await tester.tap(prompt);
      await tester.pump();
      await tester.pump();
      expect(players, hasLength(1));
      expect(
        players.single.uri.toString(),
        'http://test.invalid/reels/A1-R-CIN-01/audio/tr/practice-prompt.m4a',
      );
      expect(players.single.played, isTrue);
      await tester.tap(find.byKey(const ValueKey('practice-opt-0')));
      await tester.pump();
      expect(find.text('Mia iki bilet istiyor.'), findsOneWidget);
      expect(explain, findsOneWidget);
      await tester.ensureVisible(explain);
      await tester.tap(explain);
      await tester.pump();
      await tester.pump();
      expect(
        players.last.uri.toString(),
        'http://test.invalid/reels/A1-R-CIN-01/audio/tr/practice-explain.m4a',
      );
    });
  });
}
