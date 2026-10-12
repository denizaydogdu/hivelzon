import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';

import '../../support/fixtures.dart';

const episodeIds = ['A1-001', 'A1-002', 'A1-003', 'A1-004'];

/// Doğru yolu oynar; karar başına önce bir yanlış seçenek denenebilir.
/// Dönüş: girilen düğümlerin sırası.
List<String> playThrough(EpisodeEngine e, {bool tryWrongFirst = false}) {
  final triedWrong = <String>{};
  var guard = 0;
  while (!e.isFinished) {
    if (++guard > 500) fail('Sonsuz döngü: ${e.history}');
    final node = e.current!;
    switch (node) {
      case SegmentNode() || CardNode() || ReactionNode():
        e.advance();
      case DecisionNode(:final options):
        final wrong = options.where((o) => !o.correct).firstOrNull;
        if (tryWrongFirst && wrong != null && triedWrong.add(node.id)) {
          e.choose(wrong.id);
        } else {
          e.choose(options.firstWhere((o) => o.correct).id);
        }
      case TaskNode(:final items):
        for (final item in items) {
          e.recordTaskAttempt(item.id, correct: true);
        }
        e.completeTask();
    }
  }
  return e.history;
}

Episode synthetic() => Episode.fromJson({
  'schemaVersion': 1,
  'episode': {
    'id': 'A1-099',
    'slug': 'test',
    'level': 'A1',
    'season': 1,
    'number': 99,
    'title': 'Test',
    'contentVersion': 2,
    'status': 'DRAFT',
    'aiGenerated': true,
    'mission': {'tr': 'Test görevi'},
    'targetPhrases': ['Yes, I can.'],
    'links': {
      'previously': null,
      'payoff': '',
      'openQuestion': 'Q9',
      'answers': [],
      'cluesUnlocked': ['C9'],
      'callbackPhrases': [],
    },
  },
  'flags': [
    {
      'id': 'tone',
      'values': ['formal', 'friendly'],
    },
  ],
  'externalFlags': [
    {
      'episode': 'A1-098',
      'id': 'mood',
      'values': ['happy', 'sad'],
      'default': 'happy',
    },
  ],
  'gate': {
    'rule': 'all',
    'comprehension': ['t1'],
    'targetPhrase': ['d1'],
    'activeTask': ['t1'],
  },
  'start': 's1',
  'nodes': [
    {
      'id': 's1',
      'type': 'segment',
      'checkpoint': true,
      'video': 'segments/s1.mp4',
      'duration': 2,
      'subtitles': null,
      'next': 'c1',
    },
    {
      'id': 'c1',
      'type': 'card',
      'kind': 'message',
      'lines': [
        {'text': 'Base', 'lang': 'en'},
      ],
      'variants': [
        {
          'when': {'episode': 'A1-098', 'flag': 'mood', 'value': 'sad'},
          'lines': [
            {'text': 'Sad', 'lang': 'en'},
          ],
        },
      ],
      'next': 'd1',
    },
    {
      'id': 'd1',
      'type': 'decision',
      'checkpoint': true,
      'prompt': {'tr': 'Ne dersin?'},
      'options': [
        {
          'id': 'a',
          'text': 'Good',
          'correct': true,
          'setFlag': {'flag': 'tone', 'value': 'formal'},
          'next': 'ok',
        },
        {'id': 'b', 'text': 'Bad', 'correct': false, 'next': 'r1'},
        {'id': 'c', 'text': 'Worse', 'correct': false, 'next': 'r2'},
      ],
      'hints': [
        {'level': 2, 'kind': 'pattern', 'tr': 'İki'},
        {'level': 1, 'kind': 'keyword', 'tr': 'Bir'},
        {'level': 3, 'kind': 'explanation', 'tr': 'Üç'},
      ],
    },
    {
      'id': 'r1',
      'type': 'reaction',
      'video': 'segments/r1.mp4',
      'duration': 1,
      'next': 'd1',
    },
    {
      'id': 'r2',
      'type': 'reaction',
      'bubble': {'speaker': 'HI', 'lang': 'tr', 'text': 'Tekrar dene!'},
      'next': 'd1',
    },
    {
      'id': 'ok',
      'type': 'segment',
      'video': 'segments/ok.mp4',
      'duration': 1,
      'next': 'c2',
    },
    {
      'id': 'c2',
      'type': 'card',
      'kind': 'note',
      'lines': [
        {'text': 'Base2', 'lang': 'en'},
      ],
      'variants': [
        {
          'when': {'flag': 'tone', 'value': 'formal'},
          'lines': [
            {'text': 'Formal', 'lang': 'en'},
          ],
        },
      ],
      'next': 't1',
    },
    {
      'id': 't1',
      'type': 'task',
      'kind': 'choice',
      'role': 'comprehension',
      'checkpoint': true,
      'prompt': {'tr': 'Seç'},
      'items': [
        {
          'id': 'i1',
          'options': [
            {'id': 'a', 'text': 'A', 'correct': true},
            {'id': 'b', 'text': 'B', 'correct': false},
          ],
        },
      ],
      'next': 'c3',
    },
    {
      'id': 'c3',
      'type': 'card',
      'kind': 'clue',
      'lines': [
        {'text': 'C9', 'lang': 'tr'},
      ],
      'clueIds': ['C9'],
      'next': 'c4',
    },
    {
      'id': 'c4',
      'type': 'card',
      'kind': 'openQuestion',
      'lines': [
        {'text': 'Soru', 'lang': 'tr'},
      ],
      'questionId': 'Q9',
      'next': null,
    },
  ],
});

void main() {
  group('gerçek paketler (B1–B4)', () {
    for (final id in episodeIds) {
      test('$id ayrıştırılır ve doğru yol sona ulaşır', () {
        final ep = loadFixture(id);
        expect(ep.info.id, id);
        final e = EpisodeEngine(ep);
        expect(e.current!.id, ep.start);
        playThrough(e);
        expect(e.isFinished, isTrue);
        expect(e.gateStatus.open, isTrue, reason: 'K-29 kapısı açılmalı');
        expect(e.collectedClueIds, ep.info.links.cluesUnlocked);
        expect(e.openedQuestionIds, [ep.info.links.openQuestion]);
        expect(e.progressIndex, e.progressCheckpoints.length);
        // Doğru yolda ilk denemeler hep doğru.
        expect(e.firstAttempts.values, everyElement(isTrue));
      });

      test('$id: her yanlış seçenek tepkiye, tepki aynı karara döner', () {
        final ep = loadFixture(id);
        final decisions = ep.nodes.values.whereType<DecisionNode>();
        for (final d in decisions) {
          for (final wrong in d.options.where((o) => !o.correct)) {
            // Kararın kontrol noktası değilse bile oraya gelene dek oyna.
            final e = EpisodeEngine(ep);
            var guard = 0;
            while (e.current?.id != d.id) {
              if (++guard > 200) fail('${d.id} kararına ulaşılamadı');
              final n = e.current!;
              switch (n) {
                case DecisionNode(:final options):
                  e.choose(options.firstWhere((o) => o.correct).id);
                case TaskNode():
                  e.completeTask();
                default:
                  e.advance();
              }
            }
            final r = e.choose(wrong.id);
            expect(r.correct, isFalse);
            expect(r.firstAttempt, isTrue);
            expect(e.current, isA<ReactionNode>());
            final reaction = e.current! as ReactionNode;
            expect(
              reaction.video != null || reaction.bubble != null,
              isTrue,
              reason: 'tepkinin videosu ya da balonu olmalı',
            );
            e.advance();
            expect(e.current!.id, d.id, reason: 'aynı karara dönmeli');
            expect(e.passedNodes.contains(d.id), isFalse);
            final ok = e.choose(d.options.firstWhere((o) => o.correct).id);
            expect(ok.correct, isTrue);
            expect(ok.firstAttempt, isFalse);
            expect(
              e.firstAttempts[d.id],
              isFalse,
              reason: 'ilk deneme sayılır',
            );
            expect(e.passedNodes, contains(d.id));
          }
        }
      });

      test('$id: yanlışlar önce denenerek de sona ulaşılır', () {
        final e = EpisodeEngine(loadFixture(id));
        final history = playThrough(e, tryWrongFirst: true);
        expect(e.isFinished, isTrue);
        expect(history.where((h) => h.startsWith('r-')), isNotEmpty);
        expect(e.gateStatus.open, isTrue);
      });
    }

    test('B1 ilerleme noktaları sahne başlarıdır (başlık sayılmaz)', () {
      final e = EpisodeEngine(loadFixture('A1-001'));
      expect(e.progressCheckpoints, ['s02', 'h-02', 's05']);
      expect(e.progressIndex, 0);
    });

    group('açılış (H-050)', () {
      for (final id in episodeIds) {
        test('$id başlık ekranıyla açılır; önünde düğüm yok', () {
          final ep = loadFixture(id);
          expect(ep.schemaVersion, 2);
          final title = ep.titleNode!;
          expect(ep.start, title.id);
          expect(title.caption, 'SEZON 1 · BÖLÜM ${ep.info.number}');
          expect(title.title, ep.info.title);
          expect(title.video, 'season:jenerik-baslik.mp4');
          expect(title.posterPath, 'season:jenerik-baslik.jpg');
          expect(title.duration, inInclusiveRange(2.0, 3.0));
          expect(title.checkpoint, isFalse);
          // Başlığa giden hiçbir yol yok.
          for (final n in ep.nodes.values) {
            final next = switch (n) {
              SegmentNode(:final next) => [next],
              CardNode(:final next) => [next],
              ReactionNode(:final next) => [next],
              TaskNode(:final next) => [next],
              DecisionNode(:final options) => [for (final o in options) o.next],
            };
            expect(next, isNot(contains(title.id)), reason: n.id);
          }
          final e = EpisodeEngine(ep);
          expect(e.current, isA<TitleNode>());
          expect(e.history, [title.id]);
        });

        test('$id açılışta başlık ve görev kartı yok; görev 🎯 için meta', () {
          final ep = loadFixture(id);
          expect(
            ep.nodes.values.whereType<CardNode>().where(
              (c) => c.kind == CardKind.title || c.kind == CardKind.mission,
            ),
            isEmpty,
          );
          expect(ep.info.mission.tr, isNotEmpty);
          expect(ep.info.targetPhrases, hasLength(5));
          expect(ep.info.targetPhraseGloss, isNotEmpty);
        });
      }

      test('B1: başlık → doğrudan hikâye (özet yok)', () {
        final e = EpisodeEngine(loadFixture('A1-001'));
        expect(e.canSkip, isFalse);
        expect(e.upcomingVideoNodes(limit: 1).map((n) => n.id), ['s02']);
        e.advance();
        expect(e.current!.id, 's02');
        expect(e.lastCheckpoint, 's02');
      });

      for (final (id, after) in [
        ('A1-002', 's02'),
        ('A1-003', 'c-msg'),
        ('A1-004', 'h-01'),
      ]) {
        test('$id: başlık → atlanabilir özet → $after', () {
          final ep = loadFixture(id);
          final e = EpisodeEngine(ep);
          expect(e.upcomingVideoNodes(limit: 1).single, isA<RecapNode>());
          e.advance();
          final recap = e.current! as RecapNode;
          expect(recap.skippable, isTrue);
          expect(recap.duration, lessThanOrEqualTo(15));
          expect(recap.checkpoint, isFalse);
          expect(e.canSkip, isTrue);
          // "Atla": özetin sonrasına geçilir; ilerleme kaydı değişmez.
          e.advance();
          expect(e.current!.id, after);
          expect(e.canSkip, isFalse);
          expect(e.current!.checkpoint, isTrue, reason: 'Sahne 1 başlar');
        });
      }

      test('B3 Maya mesajı ve B4 Hi kartı başlıktan sonra, sahne içinde', () {
        for (final (id, card, scene) in [
          ('A1-003', 'c-msg', 'Sahne 1: Sokakta'),
          ('A1-004', 'h-01', 'Sahne 1: Tide & Pages'),
        ]) {
          final ep = loadFixture(id);
          final e = EpisodeEngine(ep)
            ..advance()
            ..advance();
          expect(e.current!.id, card);
          expect(e.current!.scene, scene);
          expect(e.progressCheckpoints.first, card);
        }
      });

      test('kaldığı yerden devam: önce başlık, sonra kontrol noktası', () {
        final ep = loadFixture('A1-002');
        final snap = EngineSnapshot(
          checkpointNodeId: 's04',
          flags: const {'greet_tone': 'formal'},
          passedNodes: const {'k1'},
          contentVersion: 1,
        );
        final e = EpisodeEngine(ep, resumeFrom: snap);
        expect(e.current, isA<TitleNode>());
        // Başlık sırasında çıkılırsa kayıt kaybolmaz.
        expect(e.snapshot().checkpointNodeId, 's04');
        expect(e.upcomingVideoNodes(limit: 1).single.id, 's04');
        e.advance(); // özet atlanır
        expect(e.current!.id, 's04');
        expect(e.flags['greet_tone'], 'formal');
      });

      test('schemaVersion 2: başlangıç başlık değilse reddedilir', () {
        final j =
            jsonDecode(fixtureText('A1-001.scenes.json'))
                as Map<String, dynamic>;
        j['start'] = 's02';
        expect(
          () => Episode.fromJson(j),
          throwsA(isA<EpisodeFormatException>()),
        );
      });
    });

    test('B2 karar bayrağı yazılır (greet_tone)', () {
      final ep = loadFixture('A1-002');
      for (final (option, value) in [('a', 'formal'), ('b', 'friendly')]) {
        final e = EpisodeEngine(ep);
        while (e.current is! DecisionNode) {
          e.advance();
        }
        expect(e.current!.id, 'k1');
        final r = e.choose(option);
        expect(r.correct, isTrue, reason: 'iki ton da doğru');
        expect(e.flags['greet_tone'], value);
        playThrough(e);
        expect(e.snapshot().flags['greet_tone'], value);
      }
    });

    test('B3 Maya mesajı B2 tonuna göre değişir; bayrak yoksa lines', () {
      final ep = loadFixture('A1-003');
      final card = ep.node('c-msg') as CardNode;
      String firstLine(Map<String, Map<String, String>> ext) =>
          EpisodeEngine(ep, externalFlags: ext).linesFor(card).first.text;

      expect(
        firstLine({
          'A1-002': {'greet_tone': 'formal'},
        }),
        "Hello Alex, I'm sorry. I can't come today.",
      );
      expect(
        firstLine({
          'A1-002': {'greet_tone': 'friendly'},
        }),
        "Sorry, Alex! I can't come today.",
      );
      expect(firstLine(const {}), card.lines.first.text);
    });

    test('B4 kapısı: görev öncesi kapalı, adım adım açılır', () {
      final e = EpisodeEngine(loadFixture('A1-004'));
      expect(e.gateStatus.open, isFalse);
      while (e.current!.id != 't-gorev') {
        final n = e.current!;
        if (n is DecisionNode) {
          e.choose(n.options.firstWhere((o) => o.correct).id);
        } else {
          e.advance();
        }
      }
      // k2 doğru seçildi → hedef ifade karşılandı.
      expect(e.gateStatus.targetPhrase, isTrue);
      expect(e.gateStatus.comprehension, isFalse);
      e.recordTaskAttempt('i1', correct: false);
      e.recordTaskAttempt('i1', correct: true);
      expect(e.firstAttempts['t-gorev/i1'], isFalse);
      e.completeTask();
      expect(e.gateStatus.comprehension, isTrue);
      expect(e.gateStatus.activeTask, isFalse);
    });

    test('B1 kontrol noktasından devam: s05, bayrak ve kapı korunur', () {
      final ep = loadFixture('A1-001');
      final e = EpisodeEngine(ep);
      while (e.current!.id != 't-kanit') {
        final n = e.current!;
        switch (n) {
          case DecisionNode(:final options):
            e.choose(options.firstWhere((o) => o.correct).id);
          case TaskNode():
            e.completeTask();
          default:
            e.advance();
        }
      }
      expect(e.lastCheckpoint, 's05');
      final snap = EngineSnapshot.fromJson(
        jsonDecode(jsonEncode(e.snapshot().toJson())) as Map<String, dynamic>,
      );
      expect(snap.checkpointNodeId, 's05');
      expect(snap.passedNodes, containsAll(['k1', 'k2', 't-gorev']));

      final resumed = EpisodeEngine(ep, resumeFrom: snap);
      expect(resumed.current!.id, 'title', reason: 'H-050: önce başlık');
      expect(resumed.progressIndex, 2);
      resumed.advance();
      expect(resumed.current!.id, 's05');
      playThrough(resumed);
      expect(resumed.gateStatus.open, isTrue);
    });

    test(
      'silinmiş ya da kontrol noktası olmayan düğümden devam → başlangıç',
      () {
        final ep = loadFixture('A1-001');
        for (final id in ['yok-boyle-dugum', 'k1']) {
          final e = EpisodeEngine(
            ep,
            resumeFrom: EngineSnapshot(
              checkpointNodeId: id,
              flags: const {},
              passedNodes: const {},
              contentVersion: 1,
            ),
          );
          expect(e.current!.id, ep.start);
        }
      },
    );

    test('B1 ön ısıtma: s02 karar öncesi doğru ve tepki videoları', () {
      final e = EpisodeEngine(loadFixture('A1-001'));
      e.advance(); // başlık → s02
      expect(e.current!.id, 's02');
      expect(e.upcomingVideoNodes().map((n) => n.id), ['k1-ok', 'r-k1-b']);
      // k1-ok → s03 doğrudan segment.
      e.advance(); // → k1
      e.choose('a'); // → k1-ok
      expect(e.upcomingVideoNodes(limit: 1).map((n) => n.id), ['s03']);
    });
  });

  group('sentetik grafik', () {
    test('ipucu düzeyleri 1 → 2 → 3, sonra 3te kalır', () {
      final e = EpisodeEngine(synthetic())
        ..advance()
        ..advance();
      expect(e.current!.id, 'd1');
      expect(e.currentHint, isNull);
      expect(e.canRequestHint, isTrue);
      expect(e.requestHint()!.tr, 'Bir');
      expect(e.requestHint()!.tr, 'İki');
      expect(e.requestHint()!.tr, 'Üç');
      expect(e.canRequestHint, isFalse);
      expect(e.requestHint()!.level, 3);
      expect(e.hintLevel('d1'), 3);
      // Tepkiden dönünce düzey korunur.
      e
        ..choose('c')
        ..advance();
      expect(e.currentHint!.tr, 'Üç');
    });

    test('balonlu ve videolu tepkiler aynı karara döner', () {
      final e = EpisodeEngine(synthetic())
        ..advance()
        ..advance();
      e.choose('b');
      expect((e.current! as ReactionNode).video, 'segments/r1.mp4');
      e.advance();
      e.choose('c');
      expect((e.current! as ReactionNode).bubble!.text, 'Tekrar dene!');
      e.advance();
      expect(e.current!.id, 'd1');
      expect(e.firstAttempts['d1'], isFalse);
    });

    test('yerel bayrak varyantı ve dış bayrak varyantı', () {
      final ep = synthetic();
      final sad = EpisodeEngine(
        ep,
        externalFlags: {
          'A1-098': {'mood': 'sad'},
        },
      );
      expect(sad.linesFor(ep.node('c1') as CardNode).single.text, 'Sad');
      // Dış bayrak yazılmamış: "default" uygulanmaz, lines gösterilir.
      final unset = EpisodeEngine(ep);
      expect(unset.linesFor(ep.node('c1') as CardNode).single.text, 'Base');
      expect(unset.flagValue('mood', fromEpisode: 'A1-098'), isNull);

      final e = EpisodeEngine(ep)
        ..advance()
        ..advance();
      expect(e.linesFor(ep.node('c2') as CardNode).single.text, 'Base2');
      e.choose('a');
      expect(e.flags, {'tone': 'formal'});
      expect(e.linesFor(ep.node('c2') as CardNode).single.text, 'Formal');
    });

    test('kapı, bitiş, ipucu ve soru takibi', () {
      final e = EpisodeEngine(synthetic());
      playThrough(e, tryWrongFirst: true);
      expect(e.isFinished, isTrue);
      expect(e.gateStatus.open, isTrue);
      expect(e.collectedClueIds, ['C9']);
      expect(e.openedQuestionIds, ['Q9']);
      expect(e.snapshot().contentVersion, 2);
      expect(e.snapshot().checkpointNodeId, 't1');
      expect(() => e.advance(), throwsStateError);
    });

    test('yanlış düğüm türünde işlem hata verir', () {
      final e = EpisodeEngine(synthetic());
      expect(() => e.choose('a'), throwsStateError);
      expect(() => e.completeTask(), throwsStateError);
      e
        ..advance()
        ..advance();
      expect(() => e.advance(), throwsStateError);
      expect(() => e.choose('zzz'), throwsArgumentError);
    });

    test('ön ısıtma kararda doğru hedefi önce verir', () {
      final e = EpisodeEngine(synthetic())
        ..advance()
        ..advance();
      expect(e.upcomingVideoNodes(limit: 3).map((n) => n.id), ['ok', 'r1']);
    });

    test('desteklenmeyen şema sürümü reddedilir', () {
      expect(
        () => Episode.fromJson({'schemaVersion': 3}),
        throwsA(isA<EpisodeFormatException>()),
      );
    });

    test('schemaVersion 1 (başlıksız) paket hâlâ okunur', () {
      final ep = synthetic();
      expect(ep.schemaVersion, 1);
      expect(ep.titleNode, isNull);
    });
  });
}
