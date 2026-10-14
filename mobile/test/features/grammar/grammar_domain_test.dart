import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/grammar/domain/grammar_lesson.dart';
import 'package:hivelzon/features/grammar/domain/grammar_notebook.dart';
import 'package:hivelzon/features/grammar/domain/grammar_progress.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';

import '../../support/fake_content_source.dart';

/// H-078: ders paketinin okunması (H-077 dışa aktarımı, deneme dersi
/// G-A1-99), alıştırma denetimi, raflar, teklif ve kural kartı.
void main() {
  final lesson = loadTestLesson();
  GrammarCard card(GrammarCardType t) =>
      lesson.cards.firstWhere((c) => c.type == t);

  group('paket', () {
    test('kartlar sırayla; meta veri', () {
      expect(lesson.id, kTestLessonId);
      expect(lesson.level, 'A1');
      expect(lesson.titleTr, 'Üçüncü tekil -s');
      expect(
        [for (final c in lesson.cards) c.type],
        [
          GrammarCardType.hook,
          GrammarCardType.explain,
          GrammarCardType.examples,
          GrammarCardType.contrast,
          GrammarCardType.practice,
          GrammarCardType.seeInStory,
          GrammarCardType.rule,
        ],
      );
      expect(lesson.ruleCard?.id, 'c07');
      expect(lesson.indexOfCard('c04'), 3);
      expect(lesson.indexOfCard('yok'), 0);
    });

    test('anlatım: cümleler, kelime zamanları ve okunan yer', () {
      final n = card(GrammarCardType.hook).narration!;
      expect(n.audio, 'audio/c01-tr.m4a');
      expect(n.sentences, hasLength(2));
      expect(n.sentences.first.tokens.first, 'Bu');
      expect(n.placeAt(0.1), isNull);
      expect(n.placeAt(0.25), (0, 0));
      // Kelimeler arası boşlukta önceki kelime vurgulu kalır.
      expect(n.placeAt(0.34), (0, 0));
      expect(n.placeAt(0.4), (0, 1));
      expect(n.placeAt(2.05), (1, 0));
      expect(n.placeAt(30), (1, 5));
    });

    test('örnekler: hedef yapı işaretli, zamanlar kelimelerle aynı sırada', () {
      final ex = card(GrammarCardType.examples).examples;
      expect(ex, hasLength(3));
      final goes = ex[1];
      expect(goes.en, 'He goes to school.');
      expect(
        [
          for (final t in goes.tokens)
            if (t.target) t.text,
        ],
        ['goes'],
      );
      expect(goes.words, hasLength(goes.tokens.length));
      expect(goes.wordAt(0.0), isNull);
      expect(goes.wordAt(0.3), 1);
      final m = goes.toMeaning(lesson.id);
      expect(m.tr, 'O okula gider.');
      expect(m.words[1].bare, 'goes');
      expect(m.words[1].hasTiming, isTrue);
      expect(m.words.every((w) => w.gloss == null), isTrue);
    });

    test('karşılaştırma: yanlış biçim sessiz, doğrusu sesli', () {
      final c = card(GrammarCardType.contrast);
      expect(c.title, 'Türkçede nasıl?');
      expect(c.wrong.single.en, 'She go to school.');
      expect(c.wrong.single.tr, 'Ek eksik.');
      expect(c.examples.single.hasAudio, isTrue);
    });

    test('şemalar: ek ve kutu–ok', () {
      final d = card(GrammarCardType.explain).diagrams;
      expect(d.first, isA<SuffixDiagram>());
      expect((d.first as SuffixDiagram).words[1].word, 'goes');
      expect(d.last, isA<BoxesDiagram>());
      expect((d.last as BoxesDiagram).boxes.first.caption, 'özne');
      final t = GrammarDiagram.fromJson({
        'kind': 'timeline',
        'points': [
          {'at': 'past', 'text': 'I played'},
          {'at': 'now', 'text': 'I play'},
        ],
      });
      expect((t! as TimelineDiagram).points.first.at, TimelineAt.past);
      expect(GrammarDiagram.fromJson({'kind': 'cloud'}), isNull);
    });

    test('Hikâyede gör: bölüm (düğüm + satır) ve kitap (sayfa + cümle)', () {
      final hook = card(GrammarCardType.hook).links.single;
      expect(hook.kind, StoryLinkKind.book);
      expect((hook.page, hook.sentenceId), ('p03', 'p03-s02'));
      final links = card(GrammarCardType.seeInStory).links;
      expect(links.first.kind, StoryLinkKind.episode);
      expect(links.first.contentId, 'A1-901');
      expect((links.first.node, links.first.cueId), ('s01', 's01-04'));
      expect(links.first.cueText, "Yes. I'm your new neighbour.");
    });

    test('sesi olmayan ders: ses yolları boş, metin tam', () {
      final silent = loadTestLesson(silent: true);
      expect(silent.cards.every((c) => c.narration?.audio == null), isTrue);
      expect(silent.cards[1].narration!.text, isNotEmpty);
      final noEn = loadTestLesson(noEnglishAudio: true);
      expect(noEn.cards.first.narration!.hasAudio, isTrue);
      expect(noEn.cards.first.examples.single.hasAudio, isFalse);
    });

    test('özet: seviye kimlikten, süre en az 1 dk', () {
      expect(GrammarLessonSummary.levelOf('G-B2-03-x'), 'B2');
      final s = GrammarLessonSummary.fromJson({
        'id': 'G-A2-01-was-were',
        'titleTr': 'was / were',
        'estimatedMinutes': 0.2,
        'linksTo': {
          'episodes': ['A1-002'],
        },
      });
      expect(s.level, 'A2');
      expect(s.minutes, 1);
      expect(s.episodes, ['A1-002']);
      expect(s.books, isEmpty);
    });
  });

  group('alıştırma (puansız)', () {
    final q = card(GrammarCardType.practice).practice;

    test('seç: doğru seçenek', () {
      expect(q[0].kind, PracticeKind.choose);
      expect(q[0].check('go'), isFalse);
      expect(q[0].check('goes'), isTrue);
      expect(q[0].solved, 'She goes to school.');
      expect(q[0].feedbackTr, 'Tek kişi var; fiile ek gelir.');
    });

    test('boşluk doldur: büyük harf ve boşluk önemsiz; ipucu çözümde yok', () {
      expect(q[1].check(' Plays '), isTrue);
      expect(q[1].check('play'), isFalse);
      expect(q[1].solved, 'He plays football.');
    });

    test('sırala: parçalar birleştirilir, noktalama önemsiz', () {
      expect(q[2].check('Ece opens the box'), isTrue);
      expect(q[2].check('the box opens Ece'), isFalse);
    });

    test('söyle: her zaman geçer (tanıma ayrı)', () {
      expect(q[3].kind, PracticeKind.say);
      expect(q[3].check(''), isTrue);
      expect(q[3].audio, 'audio/c05-q4.m4a');
    });
  });

  group('raflar ve teklif', () {
    final lessons = testLessonSummaries([
      'G-A1-01-to-be',
      'G-A1-02-there-is',
      kTestLessonId,
      'G-A2-01-was-were',
      'G-B1-01-present-perfect',
    ]);

    test('hikâyede geçen önce; her ders tek rafta; bitenler en sonda', () {
      final s = buildGrammarShelves(
        lessons,
        {
          'G-A1-01-to-be': GrammarProgress(
            lessonId: 'G-A1-01-to-be',
            status: GrammarStatus.completed,
            completedAt: DateTime.utc(2026, 10, 14),
          ),
        },
        suggestedLevel: 'A1',
        storyTopics: [kTestLessonId, 'G-A1-01-to-be', 'yok', kTestLessonId],
      );
      expect([for (final l in s.fromStory) l.id], [kTestLessonId]);
      expect([for (final l in s.userLevelLessons) l.id], ['G-A1-02-there-is']);
      expect([for (final (lv, _) in s.otherLevels) lv], ['A2', 'B1']);
      expect([for (final l in s.completed) l.id], ['G-A1-01-to-be']);
      expect(s.isEmpty, isFalse);
    });

    test('seviye yoksa A1', () {
      expect(buildGrammarShelves(lessons, const {}).userLevel, 'A1');
    });

    test('teklif: yalnız dersi olan konular, sıra korunur, süre toplanır', () {
      final o = GrammarOffer.of([
        'yok',
        'G-A2-01-was-were',
        kTestLessonId,
      ], lessons)!;
      expect(o.ids, ['G-A2-01-was-were', kTestLessonId]);
      expect(o.minutes, 5);
      expect(GrammarOffer.of(const ['yok'], lessons), isNull);
      expect(GrammarOffer.of(const [], lessons), isNull);
    });
  });

  group('Defter', () {
    test('kural kartı: kural, örnek ve Türkçesi; kaynak dersin adı', () {
      final item = ruleNotebookItem(lesson, now: DateTime.utc(2026, 10, 14))!;
      expect(item.kind, NotebookKind.rule);
      expect(item.source, NotebookSource.grammar);
      expect(item.textEn, 'She goes to school.');
      expect(item.textTr, 'O okula gider.');
      expect(item.ruleTr, 'Tek kişiden söz ederken fiile ek gelir.');
      expect(item.sourceTitle, 'Üçüncü tekil -s');
      expect(item.contentId, kTestLessonId);
      expect(item.cueId, 'c07');
      expect(item.audio?.path, '_grammar/$kTestLessonId/audio/c07-ex1.m4a');
      expect(item.key, 'rule|she goes to school');
      expect(item.episodeNumber, isNull);
      // Sesi yoksa kart sessiz.
      expect(ruleNotebookItem(loadTestLesson(silent: true))!.audio, isNull);
    });

    test('anlam panelinden ekleme: kaynak ders, kelimede aralık', () {
      final e = card(GrammarCardType.examples).examples[1];
      final deco = decorateGrammarSave(lesson, e);
      final word = deco(
        SavedPhrase(
          contentId: lesson.id,
          sourceId: e.id,
          kind: SavedKind.word,
          en: 'goes',
          context: e.en,
          savedAt: DateTime.utc(2026, 10, 14),
        ),
        wordIndex: 1,
      );
      expect(word.source, NotebookSource.grammar);
      expect(word.sourceTitle, 'Üçüncü tekil -s');
      expect(word.contextTr, 'O okula gider.');
      expect(word.audio?.isRange, isTrue);
      expect(
        word.contextAudio?.path,
        '_grammar/$kTestLessonId/audio/c03-ex2.m4a',
      );
    });
  });
}
