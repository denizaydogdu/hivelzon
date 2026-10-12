import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/meaning/meaning_controller.dart';
import 'package:hivelzon/shared/meaning/meaning_sheet.dart';
import 'package:hivelzon/shared/meaning/meaning_text.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';

class _FakeAudio implements MeaningAudio {
  final List<String> calls = [];

  @override
  bool get canPlayWords => true;

  @override
  bool get canPlaySentence => true;

  @override
  Future<void> playWord(MeaningWord word, {required double speed}) async =>
      calls.add('word:${word.w}@$speed');

  @override
  Future<void> playSentence({required double speed}) async =>
      calls.add('sentence@$speed');

  @override
  Future<void> stop() async {}
}

const _text = MeaningText(
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
    MeaningWord('Alex', start: 1.9, end: 2.2),
  ],
  chunks: [
    PhraseChunk(en: 'Excuse me', tr: 'Affedersiniz', startWord: 0, endWord: 1),
    PhraseChunk(en: 'where is…?', tr: '… nerede?', startWord: 2, endWord: 6),
    PhraseChunk(
      en: 'old station',
      tr: 'eski istasyon',
      startWord: 5,
      endWord: 6,
    ),
  ],
);

void main() {
  late _FakeAudio audio;
  late InMemoryLearningEventLog events;
  late InMemoryNotebookRepository notebook;
  late MeaningController controller;

  setUp(() {
    audio = _FakeAudio();
    events = InMemoryLearningEventLog();
    notebook = InMemoryNotebookRepository();
    controller = MeaningController(
      text: _text,
      audio: audio,
      events: events,
      notebook: notebook,
      now: () => DateTime.utc(2026, 10, 11, 12),
    );
  });

  Future<void> pumpSheet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: MeaningSheet(controller: controller)),
      ),
    );
  }

  testWidgets('kelime kutucukları en az 48 px; kalıplar gruplanır', (
    tester,
  ) async {
    await pumpSheet(tester);
    for (var i = 0; i < _text.words.length; i++) {
      final size = tester.getSize(find.byKey(ValueKey('meaning-word-$i')));
      expect(size.height, greaterThanOrEqualTo(48));
    }
    // Çakışan kalıplardan soldaki uzun olan görünür grup olur.
    expect(find.byKey(const ValueKey('meaning-chunk-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('meaning-chunk-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('meaning-chunk-5')), findsNothing);
    expect(find.text('Alex'), findsNWidgets(2)); // konuşmacı + kelime
  });

  testWidgets('kelimeye dokun: anlam, kalıp anlamı, ses ve olay', (
    tester,
  ) async {
    await pumpSheet(tester);
    expect(
      find.text('Bir kelimeye dokun: anlamını gör ve sesini dinle.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('meaning-word-5')));
    await tester.pumpAndSettle();
    expect(find.text('eski'), findsOneWidget);
    // En uzun kalıp gösterilir.
    expect(find.text('where is…? = … nerede?'), findsOneWidget);
    expect(audio.calls, ['word:old@1.0']);
    expect(events.events.single.target, 'old');
    expect(events.events.single.at, DateTime.utc(2026, 10, 11, 12));

    // Özel ad: anlamı yok, nazik açıklama.
    await tester.tap(find.byKey(const ValueKey('meaning-word-7')));
    await tester.pumpAndSettle();
    expect(find.text('Özel ad: Türkçesi aynı kalır.'), findsOneWidget);
  });

  testWidgets('Türkçesini göster ikinci adımdır', (tester) async {
    await pumpSheet(tester);
    expect(find.text('Affedersiniz, eski istasyon nerede?'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('meaning-reveal')));
    await tester.pumpAndSettle();
    expect(find.text('Affedersiniz, eski istasyon nerede?'), findsOneWidget);
    expect(find.byKey(const ValueKey('meaning-reveal')), findsNothing);
    expect(events.events.single.target, LearningEvent.sentence);
  });

  testWidgets(
    '0,75x ile tekrar dinle; deftere kalıp eklenir, ikincisi tekrar etmez',
    (tester) async {
      await pumpSheet(tester);
      await tester.tap(find.byKey(const ValueKey('meaning-slow')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('meaning-replay')));
      await tester.pump();
      expect(audio.calls.last, 'sentence@0.75');

      await tester.tap(find.byKey(const ValueKey('meaning-word-0')));
      await tester.pumpAndSettle();
      expect(audio.calls.last, 'word:Excuse@0.75');
      await tester.ensureVisible(find.byKey(const ValueKey('meaning-save')));
      await tester.tap(find.byKey(const ValueKey('meaning-save')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('"Excuse me" deftere eklendi.'), findsOneWidget);
      expect(notebook.items.single.kind, SavedKind.phrase);
      expect(notebook.items.single.tr, 'Affedersiniz');
      expect(notebook.items.single.context, _text.en);

      final again = await controller.save();
      expect(again.added, isFalse);
      expect(again.message, '"Excuse me" zaten defterinde.');
      expect(notebook.items, hasLength(1));
    },
  );

  test('seçim yoksa cümle kaydedilir', () async {
    final r = await controller.save();
    expect(r.item.kind, SavedKind.sentence);
    expect(r.item.tr, _text.tr);
  });

  test('MeaningWord.bare ve boşluk', () {
    expect(const MeaningWord('"Fri…"').bare, 'Fri');
    expect(const MeaningWord("o'clock.").bare, "o'clock");
    expect(const MeaningWord('___.').isBlank, isTrue);
    expect(const MeaningWord('Hi,').isBlank, isFalse);
  });
}
