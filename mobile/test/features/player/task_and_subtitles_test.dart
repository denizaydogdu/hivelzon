import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/subtitles.dart';
import 'package:hivelzon/features/player/domain/task_check.dart';

import '../../support/fixtures.dart';

TaskItem itemOf(String episode, String node) =>
    (loadFixture(episode).node(node) as TaskNode).items.first;

void main() {
  group('görev denetimi (gerçek öğeler)', () {
    test('choice: B1 t-gorev', () {
      final item = itemOf('A1-001', 't-gorev');
      expect(checkChoice(item, 'a'), isTrue);
      expect(checkChoice(item, 'b'), isFalse);
      expect(checkChoice(item, 'yok'), isFalse);
    });

    test('multiSelect: B2 t-gorev üç doğru, eksik ya da fazla yanlış', () {
      final item = itemOf('A1-002', 't-gorev');
      expect(checkMultiSelect(item, {'a', 'b', 'c'}), isTrue);
      expect(checkMultiSelect(item, {'a', 'b'}), isFalse);
      expect(checkMultiSelect(item, {'a', 'b', 'c', 'd'}), isFalse);
      expect(checkMultiSelect(item, {'a', 'b', 'd'}), isFalse);
    });

    test('order: B1 t-kanit', () {
      final item = itemOf('A1-001', 't-kanit');
      expect(checkOrder(item, item.answer), isTrue);
      expect(checkOrder(item, item.tokens), isFalse);
      expect(checkOrder(item, item.answer.sublist(1)), isFalse);
    });

    test('match: B4 t-gorev', () {
      final item = itemOf('A1-004', 't-gorev');
      final right = {for (final p in item.pairs) p.left: p.right};
      expect(checkMatch(item, right), isTrue);
      final swapped = Map.of(right)
        ..['Fri…'] = '7 pm.'
        ..['…pm'] = 'Friday.';
      expect(checkMatch(item, swapped), isFalse);
      expect(checkMatch(item, {'Fri…': 'Friday.'}), isFalse);
    });

    test('fillBlank: B2 t-kanit "any" boş olmayan her cevabı kabul eder', () {
      final item = itemOf('A1-002', 't-kanit');
      expect(splitBlankStem(item.stem!).length, item.blanks.length + 1);
      expect(checkFillBlank(item, {'name': 'Deniz', 'from': 'İzmir'}), isTrue);
      expect(checkFillBlank(item, {'name': 'Deniz', 'from': '  '}), isFalse);
      expect(checkFillBlank(item, {}), isFalse);
    });

    test('fillBlank: kabul listesi harf ve noktalamayı önemsemez', () {
      const blank = Blank(id: 'x', acceptAny: false, accept: ['at seven']);
      expect(checkBlank(blank, 'At seven.'), isTrue);
      expect(checkBlank(blank, ' at  seven '), isTrue);
      expect(checkBlank(blank, 'in seven'), isFalse);
    });
  });

  group('altyazı', () {
    final track = SubtitleTrack.fromJson(
      jsonDecode(fixtureText('A1-001.s02.en.json')),
    );

    test('ipucu zamana göre bulunur; boşlukta null', () {
      expect(track.cues, hasLength(4));
      expect(track.cueAt(0.2), isNull);
      expect(track.cueAt(0.6)!.text, 'OK. Friday.');
      expect(track.cueAt(5.0), isNull);
      expect(track.cueAt(11.5)!.text, 'Can you hear me?');
      expect(track.cueAt(13.0), isNull);
      expect(track.hasTurkish, isFalse, reason: 'tr henüz null');
    });

    test('hedef ifade sözcükleri vurgulanır', () {
      final cue = track.cueAt(11.5)!;
      final hits = targetWordIndexes(cue, ['Can you hear me?', 'Where is…?']);
      expect(hits, {0, 1, 2, 3});
      expect(
        targetWordIndexes(track.cueAt(0.6)!, ['Can you hear me?']),
        isEmpty,
      );
    });

    test('"…" önek ve "/" seçenekli ifadeler', () {
      SubtitleCue cue(String text) => SubtitleCue(
        id: 'x',
        start: 0,
        end: 1,
        speaker: 'A',
        text: text,
        words: [for (final w in text.split(' ')) SubtitleWord(w, 0, 1)],
      );
      expect(
        targetWordIndexes(cue('Excuse me, where is the harbour?'), [
          'Excuse me, where is…?',
        ]),
        {0, 1, 2, 3},
      );
      expect(
        targetWordIndexes(cue('Go straight. Turn right.'), [
          'Turn left / right.',
        ]),
        {2, 3},
      );
      expect(
        targetWordIndexes(cue("It's near the fish shop."), ["It's near…"]),
        {0, 1},
      );
    });
  });
}
