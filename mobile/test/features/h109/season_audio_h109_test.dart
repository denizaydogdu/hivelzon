import 'dart:async';
import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/discover/application/feed_videos.dart';
import 'package:hivelzon/features/discover/domain/clip.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';
import 'package:hivelzon/features/discover/presentation/widgets/feed_cards.dart';
import 'package:hivelzon/features/notebook/application/card_audio_player.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/presentation/widgets/card_face.dart';
import 'package:hivelzon/features/player/domain/subtitles.dart';
import 'package:hivelzon/features/player/presentation/player_screen.dart'
    show videoControllerFactoryProvider;
import 'package:hivelzon/features/talk/domain/talk_task.dart';
import 'package:hivelzon/features/talk/presentation/talk_widgets.dart';
import 'package:hivelzon/features/topic_sets/domain/topic_set.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/speech/speech_providers.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_example_speech.dart';
import '../../support/fixtures.dart';
import '../../support/talk_harness.dart' show FakeAudioController;

/// H-109 Faz 3b: Konuş çevirileri, konu seti örnek Türkçesi ve Keşfet klip
/// alıştırması. Düğme yalnız ses varken ve yalnız Türkçe metin görünürken;
/// yalnız dokununca çalar; eski paket (alan yok) hiçbir şeyi değiştirmez.
void main() {
  group('paket alanları', () {
    test('Konuş satırı `trAudio`; boş alan yok sayılır', () {
      final l = TalkLine.fromJson(const {
        'en': 'Here you are.',
        'tr': 'Buyurun.',
        'trAudio': 'talk/ceviri-cafe-rosa-t2-line.m4a',
      });
      expect(l.trAudio, 'talk/ceviri-cafe-rosa-t2-line.m4a');
      expect(
        TalkLine.fromJson(const {'en': 'a', 'tr': 'b', 'trAudio': ''}).trAudio,
        isNull,
      );
      expect(TalkLine.fromJson(const {'en': 'a', 'tr': 'b'}).trAudio, isNull);
    });

    test('konu seti öğesi `exampleTrAudio`', () {
      final set = _setWithTrAudio();
      final radio = set.items.firstWhere((i) => i.id == 'radio');
      expect(radio.exampleTrAudio, 'alex-room/tr-radio.m4a');
      expect(
        loadTopicSetFixture('alex-room').items.map((i) => i.exampleTrAudio),
        everyElement(isNull),
      );
    });

    test('klip `quiz.audioTr` sezon yoluyla bağlanır', () {
      final catalog = ClipCatalog.fromJson(
        (jsonDecode(fixtureText('clips.json')) as Map).cast<String, dynamic>(),
      );
      expect(
        catalog.clips.map((c) => c.quiz?.promptAudio),
        everyElement(isNull),
      );
      final json = (jsonDecode(fixtureText('clips.json')) as Map)
          .cast<String, dynamic>();
      final clip = ((json['clips'] as List).first as Map)
          .cast<String, dynamic>();
      (clip['quiz'] as Map)['audioTr'] = {
        'prompt': {'audio': 'clips/S1-K01.tr-prompt.m4a', 'textSha256': 'x'},
      };
      final c = FeedClip.fromJson(clip);
      expect(c.quiz!.promptAudio, 'clips/S1-K01.tr-prompt.m4a');
      expect(c.quiz!.explainAudio, isNull);
      final v = feedVideoOfClip(c, FakeContentSource());
      expect(v.practice!.promptAudio, '_season/S1/clips/S1-K01.tr-prompt.m4a');
    });
  });

  group('Keşfet klip alıştırması', () {
    testWidgets('soru düğmesi dokununca sezon paketinden çalar; açıklama '
        'düğmesi yalnız cevaptan sonra', (tester) async {
      final players = <FakeAudioController>[];
      final quiz = const ClipQuiz(
        promptTr: '“Nice to meet you.” ne demek?',
        explainTr: 'Biriyle ilk kez tanışınca denir.',
        promptAudio: 'clips/S1-K04.tr-prompt.m4a',
        explainAudio: 'clips/S1-K04.tr-explain.m4a',
        options: [
          ClipQuizOption(text: 'Tanıştığımıza memnun oldum.', correct: true),
          ClipQuizOption(text: 'Seni görmek güzel.'),
        ],
      );
      final clip = FeedClip(
        id: 'S1-K04',
        episodeId: 'A1-002',
        titleTr: 'Tanıştığımıza memnun oldum',
        video: 'clips/S1-K04.mp4',
        duration: 8,
        target: const ClipTarget(kind: 'phrase', en: 'Nice', tr: 'x'),
        subtitles: SubtitleTrack.fromJson(const {
          'schemaVersion': 1,
          'segment': 'S1-K04',
          'duration': 8,
          'cues': [],
        }),
        quiz: quiz,
      );
      final source = FakeContentSource();
      await tester.pumpWidget(
        _scope(
          source,
          players,
          PracticeCard(video: feedVideoOfClip(clip, source), onNext: () {}),
        ),
      );
      await tester.pump();
      final prompt = find.byKey(const ValueKey('practice-prompt-listen'));
      final explain = find.byKey(const ValueKey('practice-explain-listen'));
      expect(prompt, findsOneWidget);
      expect(explain, findsNothing);
      expect(players, isEmpty);
      await tester.tap(prompt);
      await tester.pump();
      await tester.pump();
      expect(
        players.single.uri.toString(),
        'http://test.invalid/_season/S1/clips/S1-K04.tr-prompt.m4a',
      );
      await tester.tap(find.byKey(const ValueKey('practice-opt-0')));
      await tester.pump();
      expect(explain, findsOneWidget);
    });
  });

  group('Keşfet akışı: klip soru kartı (QuizCard)', () {
    testWidgets('akıştaki soru kartında ses düğmesi sezon paketinden çalar; '
        'açıklama düğmesi yalnız cevaptan sonra; sesi olmayan kartta yok', (
      tester,
    ) async {
      Map<String, dynamic> catalog() =>
          (jsonDecode(fixtureText('clips.json')) as Map)
              .cast<String, dynamic>();
      // Akışın gerçekten gösterdiği ilk soru kartının klibine ses eklenir.
      final first = buildFeed(
        ClipCatalog.fromJson(catalog()).clips,
      ).whereType<QuizEntry>().first.clip.id;
      final json = catalog();
      for (final c in json['clips'] as List) {
        final q = (c as Map)['quiz'];
        if (q is Map && c['id'] == first) {
          q['audioTr'] = {
            'prompt': {'audio': 'clips/$first.tr-prompt.m4a'},
            'explain': {'audio': 'clips/$first.tr-explain.m4a'},
          };
        }
      }
      final clips = ClipCatalog.fromJson(json).clips;
      final quizzes = buildFeed(clips).whereType<QuizEntry>().toList();
      final withAudio = quizzes.first;
      expect(withAudio.clip.id, first);
      final players = <FakeAudioController>[];
      final source = FakeContentSource();
      await tester.pumpWidget(
        _scope(source, players, QuizCard(clip: withAudio.clip, onNext: () {})),
      );
      await tester.pump();
      final prompt = find.byKey(const ValueKey('quiz-prompt-listen'));
      final explain = find.byKey(const ValueKey('quiz-explain-listen'));
      expect(prompt, findsOneWidget);
      expect(explain, findsNothing);
      expect(players, isEmpty);
      await tester.tap(prompt);
      await tester.pump();
      await tester.pump();
      expect(
        players.single.uri.toString(),
        'http://test.invalid/_season/S1/clips/$first.tr-prompt.m4a',
      );
      final correct = withAudio.clip.quiz!.correctIndex;
      await tester.tap(find.byKey(ValueKey('quiz-opt-$correct')));
      await tester.pump();
      expect(explain, findsOneWidget);
      final other = clips.firstWhere((c) => c.quiz != null && c.id != first);
      await tester.pumpWidget(
        _scope(source, players, QuizCard(clip: other, onNext: () {})),
      );
      await tester.pump();
      expect(find.byKey(const ValueKey('hi-listen')), findsNothing);
    });
  });

  group('Konuş: karakter satırının Türkçesi', () {
    Future<(List<FakeAudioController>, TalkLineSpeaker)> pump(
      WidgetTester tester,
      TalkLine line,
    ) async {
      final players = <FakeAudioController>[];
      late TalkLineSpeaker speaker;
      await tester.pumpWidget(
        _scope(
          FakeContentSource(),
          players,
          Consumer(
            builder: (context, ref, _) {
              speaker = TalkLineSpeaker(ref);
              return TalkLineView(speaker: 'ROSA', line: line, player: speaker);
            },
          ),
        ),
      );
      await tester.pump();
      return (players, speaker);
    }

    final listen = find.byKey(const ValueKey('talk-line-tr-listen'));
    final toggle = find.byKey(const ValueKey('talk-line-tr'));

    testWidgets('ses yoksa Türkçe açılınca da düğme yok', (tester) async {
      await pump(tester, const TalkLine(en: 'Here you are.', tr: 'Buyurun.'));
      await tester.tap(toggle);
      await tester.pump();
      expect(find.text('Buyurun.'), findsOneWidget);
      expect(listen, findsNothing);
    });

    testWidgets('düğme yalnız Türkçe açıkken; dokununca çalar, İngilizce '
        'satır başlayınca ve Türkçe kapanınca durur', (tester) async {
      final (players, speaker) = await pump(
        tester,
        const TalkLine(
          en: 'Here you are.',
          tr: 'Buyurun.',
          trAudio: 'talk/ceviri-cafe-rosa-t2-line.m4a',
        ),
      );
      expect(listen, findsNothing); // Türkçe kapalı: düğme yok
      await tester.tap(toggle);
      await tester.pump();
      expect(listen, findsOneWidget);
      expect(players, isEmpty); // kendiliğinden çalmaz
      await tester.tap(listen);
      await tester.pump();
      await tester.pump();
      expect(
        players.single.uri.toString(),
        'http://test.invalid/_season/S1/talk/ceviri-cafe-rosa-t2-line.m4a',
      );
      expect(players.single.played, isTrue);
      bool playing() => find
          .descendant(of: listen, matching: find.byIcon(Icons.stop_rounded))
          .evaluate()
          .isNotEmpty;
      expect(playing(), isTrue);
      // İngilizce satır başlarken Türkçe ses durur (iki ses aynı anda çalmaz).
      unawaited(
        speaker.play(const TalkLine(en: 'Here you are.', tr: 'Buyurun.')),
      );
      await tester.pump();
      await tester.pump();
      expect(playing(), isFalse);
      await tester.tap(listen);
      await tester.pump();
      await tester.pump();
      expect(playing(), isTrue);
      // Türkçe kapanınca düğme gider, çalar bırakılır.
      await tester.tap(toggle);
      await tester.pump();
      expect(listen, findsNothing);
      expect(players.last.disposed, isTrue);
    });
  });

  group('konu seti kartı: örnek cümlenin Türkçesi', () {
    Future<List<FakeAudioController>> pump(
      WidgetTester tester,
      FakeContentSource source,
      NotebookItem item,
    ) async {
      final players = <FakeAudioController>[];
      await tester.pumpWidget(
        _scope(
          source,
          players,
          SingleChildScrollView(
            child: CardFace(
              item: item,
              showImage: false,
              player: CardAudioPlayer(
                uriFor: (c, p) => resolveMediaUri(source, c, p),
                factory: (uri) {
                  final c = FakeAudioController(uri);
                  players.add(c);
                  return c;
                },
              ),
            ),
          ),
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump();
      }
      return players;
    }

    NotebookItem itemOf(TopicSet set, String id) =>
        set.toNotebookItem(set.items.firstWhere((i) => i.id == id));

    testWidgets('ses varsa ve metin aynıysa düğme; dokununca sezon '
        'paketinden çalar', (tester) async {
      final source = _SetSource();
      final players = await pump(
        tester,
        source,
        itemOf(_setWithTrAudio(), 'radio'),
      );
      final listen = find.byKey(
        const ValueKey('card-example-tr-listen-word|radio'),
      );
      expect(find.text('E! Telsizdeki mesaj!'), findsOneWidget);
      expect(listen, findsOneWidget);
      expect(players, isEmpty);
      await tester.tap(listen);
      await tester.pump();
      await tester.pump();
      expect(
        players.single.uri.toString(),
        'http://test.invalid/_season/S1/sets/alex-room/tr-radio.m4a',
      );
    });

    testWidgets('sesi olmayan öğe, eski (farklı) metin ve bölüm kartı: '
        'düğme yok', (tester) async {
      final source = _SetSource();
      final set = _setWithTrAudio();
      await pump(tester, source, itemOf(set, 'clock'));
      expect(find.byKey(const ValueKey('hi-listen')), findsNothing);
      final old = itemOf(set, 'radio');
      await pump(
        tester,
        source,
        NotebookItem(
          kind: old.kind,
          textEn: old.textEn,
          textTr: old.textTr,
          exampleEn: old.exampleEn,
          exampleTr: 'E! Telsizde bir mesaj!', // kayıttaki eski çeviri
          contentId: old.contentId,
          cueId: old.cueId,
          source: NotebookSource.topicSet,
        ),
      );
      expect(find.byKey(const ValueKey('hi-listen')), findsNothing);
      await pump(
        tester,
        source,
        NotebookItem(
          kind: NotebookKind.phrase,
          textEn: 'Can you hear me?',
          exampleEn: 'Hello? Can you hear me?',
          exampleTr: 'E! Telsizdeki mesaj!',
          contentId: 'A1-001',
          cueId: 's02-01',
          source: NotebookSource.userSaved,
        ),
      );
      expect(find.byKey(const ValueKey('hi-listen')), findsNothing);
    });
  });
}

/// Gerçek set kopyası; `radio` öğesinde örnek Türkçesinin sesi var.
TopicSet _setWithTrAudio() {
  final j = (jsonDecode(fixtureText('sets/alex-room.json')) as Map)
      .cast<String, dynamic>();
  for (final i in j['items'] as List) {
    if ((i as Map)['id'] == 'radio') {
      i['exampleTrAudio'] = 'alex-room/tr-radio.m4a';
    }
  }
  return TopicSet.fromJson(j);
}

class _SetSource extends FakeContentSource {
  @override
  Future<TopicSet> loadTopicSet(int season, String path) async =>
      path.endsWith('alex-room.json')
      ? _setWithTrAudio()
      : super.loadTopicSet(season, path);
}

Widget _scope(
  FakeContentSource source,
  List<FakeAudioController> players,
  Widget child,
) => ProviderScope(
  overrides: [
    contentSourceProvider.overrideWithValue(source),
    exampleSpeechProvider.overrideWithValue(FakeExampleSpeech()),
    videoControllerFactoryProvider.overrideWithValue((uri) {
      final c = FakeAudioController(uri);
      players.add(c);
      return c;
    }),
  ],
  child: MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  ),
);
