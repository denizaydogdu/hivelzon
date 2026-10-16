import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/domain/evidence_ladder.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';

/// Kanıt basamağı geçişleri (H-089; `docs/KELIME-TEKRARI.md` §3).
void main() {
  final seen = DateTime.utc(2026, 10, 10, 9);

  Set<EvidenceStage> reach(
    TaskType type, {
    bool correct = true,
    FsrsRating? rating,
    FsrsState? before = FsrsState.review,
    Duration after = const Duration(days: 3),
  }) => EvidenceRules.fromResult(
    taskType: type,
    correct: correct,
    rating: rating,
    stateBefore: before,
    at: seen.add(after),
    seenAt: seen,
  );

  group('geçişler', () {
    test('pratik başarısı → yardımla yaptı; başarısızlık → hiçbir şey', () {
      for (final t in [
        TaskType.pictureChoice,
        TaskType.listenChoice,
        TaskType.arrange,
        TaskType.speak,
        TaskType.sceneHunt,
      ]) {
        expect(reach(t), {EvidenceStage.helped}, reason: t.code);
        expect(reach(t, correct: false), isEmpty, reason: t.code);
      }
    });

    test('denetlenen üretim (yaz, sesi duymadan söyle) → kendi kullandı', () {
      expect(
        reach(
          TaskType.type,
          rating: FsrsRating.good,
          before: FsrsState.learning,
          after: const Duration(minutes: 5),
        ),
        {EvidenceStage.ownUse},
      );
      expect(
        reach(
          TaskType.speakRecall,
          rating: FsrsRating.hard,
          before: FsrsState.learning,
          after: const Duration(minutes: 5),
        ),
        {EvidenceStage.ownUse},
        reason: 'yalnız bir kelime duyulmadı (Hard) da kullanımdır',
      );
      expect(
        reach(TaskType.speakRecall, correct: false, rating: FsrsRating.again),
        isEmpty,
        reason: 'anlamı değiştiren ek → Again → kanıt yok',
      );
      expect(
        reach(
          TaskType.selfCheck,
          rating: FsrsRating.good,
          before: FsrsState.learning,
          after: const Duration(minutes: 5),
        ),
        isEmpty,
        reason: 'kendini yoklama denetlenmez',
      );
    });

    test('sonra hatırladı: uzun vade kartı, ilk görülmeden ≥ 2 gün sonra', () {
      expect(reach(TaskType.selfCheck, rating: FsrsRating.good), {
        EvidenceStage.recalledLater,
      });
      expect(reach(TaskType.type, rating: FsrsRating.good), {
        EvidenceStage.ownUse,
        EvidenceStage.recalledLater,
      });
      expect(
        reach(
          TaskType.selfCheck,
          rating: FsrsRating.good,
          after: const Duration(days: 1, hours: 23),
        ),
        isEmpty,
        reason: '2 günden önce',
      );
      expect(
        reach(
          TaskType.selfCheck,
          rating: FsrsRating.good,
          before: FsrsState.relearning,
        ),
        isEmpty,
        reason: 'pratikle ısınmış (yeniden öğrenme) sayılmaz',
      );
      expect(
        reach(TaskType.selfCheck, rating: FsrsRating.good, before: null),
        isEmpty,
        reason: 'yeni kart',
      );
      expect(reach(TaskType.selfCheck, rating: FsrsRating.again), isEmpty);
    });

    test('en yüksek basamak; basamaklar sırayla gelmek zorunda değil', () {
      final e = ExpressionEvidence(
        seenAt: seen,
        reached: {
          EvidenceStage.recalledLater: seen.add(const Duration(days: 3)),
        },
      );
      expect(e.highest, EvidenceStage.recalledLater);
      expect(e.has(EvidenceStage.seen), isTrue);
      expect(e.has(EvidenceStage.ownUse), isFalse);
      expect(ExpressionEvidence(seenAt: seen).highest, EvidenceStage.seen);
      expect(EvidenceStage.parse('own_use'), EvidenceStage.ownUse);
      expect(EvidenceStage.parse('x'), isNull);
    });
  });

  group('özet', () {
    NotebookItem item(String en, int day) => NotebookItem(
      kind: NotebookKind.phrase,
      textEn: en,
      source: NotebookSource.autoTargetPhrase,
      createdAt: DateTime.utc(2026, 10, day),
    );
    ReviewCardState card(int id, FsrsState state, {int reps = 2}) =>
        ReviewCardState(
          id: id,
          itemId: id,
          reps: reps,
          fsrs: FsrsCard(
            state: state,
            step: state == FsrsState.review ? null : 0,
            stability: 3,
            difficulty: 5,
            due: DateTime.utc(2026, 10, 14),
            lastReview: DateTime.utc(2026, 10, 13, id),
          ),
        );

    test('en yüksek basamağa göre gruplar, en yeni önce; yeniden çalışılacak '
        'kartlar', () {
      final a = item('Where is…?', 1);
      final b = item('Excuse me.', 2);
      final c = item('What time is it?', 3);
      final d = item('I am new here.', 4);
      final e = item('Thank you.', 5);
      final s = summarizeEvidence(
        [
          NotebookEntry(a, card(1, FsrsState.review)),
          NotebookEntry(b, card(2, FsrsState.review)),
          NotebookEntry(c, card(3, FsrsState.relearning)),
          NotebookEntry(d, card(4, FsrsState.learning, reps: 0)),
          NotebookEntry(e, card(5, FsrsState.review)),
        ],
        {
          a.key: {
            EvidenceStage.helped: DateTime.utc(2026, 10, 1),
            EvidenceStage.recalledLater: DateTime.utc(2026, 10, 5),
          },
          e.key: {EvidenceStage.recalledLater: DateTime.utc(2026, 10, 9)},
          b.key: {EvidenceStage.ownUse: DateTime.utc(2026, 10, 3)},
          c.key: {EvidenceStage.helped: DateTime.utc(2026, 10, 4)},
        },
      );
      expect(s.recalledLater.map((i) => i.textEn), [
        'Thank you.',
        'Where is…?',
      ]);
      expect(s.ownUse.map((i) => i.textEn), ['Excuse me.']);
      expect(s.helped.map((i) => i.textEn), ['What time is it?']);
      expect(s.revisit.map((i) => i.textEn), ['What time is it?']);
      expect(s.total, 5);
      expect(s.hasEvidence, isTrue);
      expect(summarizeEvidence(const [], const {}).hasEvidence, isFalse);
    });
  });

  group('hikâye içi "Söyle" (H-093)', () {
    NotebookItem it(
      String en, {
      NotebookKind kind = NotebookKind.phrase,
      String? example,
      String contentId = 'A1-001',
    }) => NotebookItem(
      kind: kind,
      textEn: en,
      exampleEn: example,
      contentId: contentId,
      source: NotebookSource.autoTargetPhrase,
    );

    final items = [
      it('Excuse me.'),
      it('station', kind: NotebookKind.word, example: 'Where is the station?'),
      it(
        'hear',
        kind: NotebookKind.word,
        example: 'I can hear you.',
        contentId: 'A1-002',
      ),
    ];

    test('defterdeki ifade ya da kartın örnek cümlesi (aynı içerik)', () {
      expect(spokenPracticeKeys(expression: 'excuse me', items: items), {
        'phrase|excuse me',
      });
      expect(
        spokenPracticeKeys(
          expression: 'Where is the station?',
          items: items,
          contentId: 'A1-001',
        ),
        {'word|station'},
      );
      // Örnek cümle başka bölümün kartına aitse sayılmaz.
      expect(
        spokenPracticeKeys(
          expression: 'I can hear you.',
          items: items,
          contentId: 'A1-001',
        ),
        isEmpty,
      );
    });

    test(
      'defterde olmayan metin: hiçbir şey; hedef ifade: kartın anahtarı',
      () {
        expect(
          spokenPracticeKeys(expression: 'Nice to meet you.', items: items),
          isEmpty,
        );
        expect(
          spokenPracticeKeys(
            expression: 'Nice to meet you.',
            items: items,
            targetPhrase: true,
          ),
          {'phrase|nice to meet you'},
        );
        // Tek kelimelik hedef ifade kelime kartıdır (deste kuralıyla aynı).
        expect(targetPhraseKey('Hi!'), 'word|hi');
        expect(targetPhraseKey('Where is…?'), 'phrase|where is…');
        expect(spokenPracticeKeys(expression: '  ', items: items), isEmpty);
      },
    );
  });
}
