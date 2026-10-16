import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/features/hi/domain/coach_rules.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';

import '../../support/fake_content_source.dart';

/// H-088: tek günlük plan. Ana Sayfa'nın birincil kartı ve Hi'nin önerisi
/// aynı saf karardan ([planToday]) gelir.
void main() {
  final now = DateTime.utc(2026, 10, 16, 9);

  const b1 = CoachEpisode(
    contentId: 'A1-001',
    number: 1,
    title: 'A Strange Message',
    estimatedMinutes: 6,
  );
  CoachEpisode half({Duration ago = const Duration(hours: 1)}) => CoachEpisode(
    contentId: 'A1-002',
    number: 2,
    title: 'The New Neighbour',
    estimatedMinutes: 7,
    lastPlayedAt: now.subtract(ago),
  );
  const b2Book = CoachBook(
    bookId: 'B2-K01',
    title: 'The Night Ferry',
    level: 'B2',
    estimatedMinutes: 15,
  );
  const a1Book = CoachBook(
    bookId: 'A1-K02',
    title: 'Lost in the Market',
    level: 'A1',
    estimatedMinutes: 7,
  );
  const grammar = CoachGrammar(
    lessonId: 'b2-passive',
    titleTr: 'Edilgen yapı',
    sourceTr: '"The Night Ferry" kitabında',
    minutes: 4,
  );

  CoachInput input({
    String? level,
    CoachEpisode? inProgress,
    CoachEpisode? next,
    int reviewDue = 0,
    List<ErrorObservation> errors = const [],
    CoachBook? reading,
    CoachBook? start,
    CoachGrammar? grammarTopic,
    List<CoachTopicSet> sets = const [],
    DateTime? lastActiveAt,
    Set<String> dismissed = const {},
    bool reviewedToday = false,
    bool mainDoneToday = false,
    bool taskDoneToday = false,
    DateTime? at,
  }) => CoachInput(
    now: at ?? now,
    dailyGoalMinutes: 10,
    level: level,
    inProgress: inProgress,
    next: next,
    reviewDue: reviewDue,
    errors: errors,
    content: loadHiFixture(),
    bookInProgress: reading,
    bookToStart: start,
    grammar: grammarTopic,
    unhuntedSets: sets,
    lastActiveAt: lastActiveAt,
    dismissed: dismissed,
    reviewedToday: reviewedToday,
    mainDoneToday: mainDoneToday,
    taskDoneToday: taskDoneToday,
  );

  group('Ana Sayfa ve Hi aynı eylemi gösterir', () {
    final inputs = <String, CoachInput>{
      'yeni kullanıcı': input(next: b1),
      'tekrar borcu': input(next: b1, reviewDue: 8),
      'B2': input(level: 'B2', next: b1, start: b2Book),
      'bugün yarım bölüm': input(inProgress: half(), reviewDue: 9),
      'hepsi geçildi': input(
        next: b1,
        dismissed: {'startEpisode:${AppRoutes.play('A1-001')}'},
      ),
    };
    for (final MapEntry(key: name, value: i) in inputs.entries) {
      test(name, () {
        final plan = planToday(i);
        final hi = suggestToday(i);
        expect(hi.key, plan.primary.key);
        expect(hi.reasonTr, plan.primary.reasonTr);
        // Aynı girdi → aynı karar (saf fonksiyon).
        expect(planToday(i).primary.key, plan.primary.key);
        expect(plan.primary.reasonTr, isNotEmpty);
      });
    }
  });

  group('seviyeye göre birincil öneri', () {
    test(
      'B2 yerleştirme: birincil öneri A1 bölümü değil, seviyesinde kitap',
      () {
        final plan = planToday(
          input(level: 'B2', next: b1, start: b2Book, grammarTopic: grammar),
        );
        expect(plan.advanced, isTrue);
        expect(plan.primary.kind, isNot(HiSuggestionKind.startEpisode));
        expect(plan.primary.kind, HiSuggestionKind.startBook);
        expect(plan.primary.title, 'Seviyene uygun kitap: The Night Ferry');
        expect(plan.primary.reasonTr, contains('B2'));
        expect(plan.primary.actionRoute, AppRoutes.book('B2-K01'));
        // Kitap + kısa görev; hikâye isteğe bağlı olarak sonra.
        final kinds = [for (final s in plan.queue) s.kind];
        expect(
          kinds.indexOf(HiSuggestionKind.grammarSuggest),
          lessThan(kinds.indexOf(HiSuggestionKind.startEpisode)),
        );
        expect(plan.steps.map((s) => s.stage), [
          PlanStage.main,
          PlanStage.task,
        ]);
        expect(plan.steps.first.reading, isTrue);
      },
    );

    test('B2 yerleştirme, yarım A1 bölümü (eski): yine kitap önce', () {
      final plan = planToday(
        input(
          level: 'B2',
          inProgress: half(ago: const Duration(days: 2)),
          start: b2Book,
        ),
      );
      expect(plan.primary.kind, HiSuggestionKind.startBook);
    });

    test('B1+ ama kitap yok: hikâye yedek olarak önerilir', () {
      expect(
        planToday(input(level: 'C1', next: b1)).primary.kind,
        HiSuggestionKind.startEpisode,
      );
    });

    test('A1–A2 (ya da seviye yok): hikâye birincil, kitap sonra', () {
      for (final level in [null, 'A1', 'A2']) {
        final plan = planToday(input(level: level, next: b1, start: a1Book));
        expect(plan.advanced, isFalse);
        expect(plan.primary.kind, HiSuggestionKind.startEpisode);
        expect(plan.primary.contentId, 'A1-001');
      }
    });
  });

  group('yarım bölümün yaşı', () {
    test('bugün oynanan yarım bölüm tekrardan önce (oturumun ortası)', () {
      final plan = planToday(input(inProgress: half(), reviewDue: 12));
      expect(plan.primary.kind, HiSuggestionKind.continueEpisode);
      expect(plan.queue.first.kind, HiSuggestionKind.review);
    });

    test('dünden kalan yarım bölüm tekrar borcunu bastırmaz', () {
      final plan = planToday(
        input(inProgress: half(ago: const Duration(days: 1)), reviewDue: 6),
      );
      expect(plan.primary.kind, HiSuggestionKind.review);
      expect(plan.queue.first.kind, HiSuggestionKind.continueEpisode);
    });

    test('uzun süredir yarım bölüm: tekrar borcu her gün yeniden önde '
        '(sonsuza dek bastırılmaz)', () {
      // 30 gün boyunca her sabah: yarım bölüm hiç ilerlemedi, tekrar borcu var.
      for (var d = 0; d < 30; d++) {
        final day = now.add(Duration(days: d));
        final plan = planToday(
          input(
            at: day,
            inProgress: half(ago: Duration(days: 10 + d)),
            reviewDue: 7,
          ),
        );
        expect(plan.primary.kind, HiSuggestionKind.review, reason: 'gün $d');
      }
    });

    test('uzun süredir yarım bölüm: hata notu ve yarım kitap önce; gerekçe '
        'sakin', () {
      final stale = half(ago: const Duration(days: 12));
      final withNote = planToday(
        input(
          inProgress: stale,
          errors: [
            ErrorObservation(
              type: ErrorType.preposition,
              at: now.subtract(const Duration(hours: 2)),
            ),
            ErrorObservation(
              type: ErrorType.preposition,
              at: now.subtract(const Duration(hours: 1)),
            ),
          ],
        ),
      );
      expect(withNote.primary.kind, HiSuggestionKind.errorNote);
      final reading = a1Book.copyWithPercent(30);
      final plan = planToday(input(inProgress: stale, reading: reading));
      expect(plan.primary.kind, HiSuggestionKind.continueBook);
      final ep = plan.queue.first;
      expect(ep.kind, HiSuggestionKind.continueEpisode);
      expect(ep.reasonTr, contains('bir süre önce'));
      expect(ep.reasonTr.toLowerCase(), isNot(contains('hâlâ')));
    });

    test('yeni yarım bölüm (1 gün) kitaptan önce kalır', () {
      final plan = planToday(
        input(
          inProgress: half(ago: const Duration(days: 1)),
          reading: a1Book.copyWithPercent(30),
        ),
      );
      expect(plan.primary.kind, HiSuggestionKind.continueEpisode);
    });
  });

  group('"Başka bir öneri" (geçilen öneri)', () {
    test('geçilen öneri bugün yeniden önerilmez; sıradaki gelir', () {
      final i = input(next: b1, reviewDue: 6, sets: const []);
      final first = planToday(i).primary;
      expect(first.kind, HiSuggestionKind.review);
      final after = planToday(
        input(next: b1, reviewDue: 6, dismissed: {first.key}),
      );
      expect(after.primary.kind, HiSuggestionKind.startEpisode);
      expect(after.queue.any((s) => s.key == first.key), isFalse);
      // Hi de aynı şeyi söyler.
      expect(
        suggestToday(input(next: b1, reviewDue: 6, dismissed: {first.key})).key,
        after.primary.key,
      );
    });

    test('hepsi geçildiyse sakin dinlenme; gerekçe bunu söyler', () {
      final plan = planToday(
        input(
          next: b1,
          dismissed: {'startEpisode:${AppRoutes.play('A1-001')}'},
        ),
      );
      expect(plan.primary.kind, HiSuggestionKind.rest);
      expect(plan.primary.dismissible, isFalse);
      expect(plan.primary.reasonTr, contains('başka önerim yok'));
    });

    test('anahtar tür + hedef: başka bölüm etkilenmez', () {
      final plan = planToday(
        input(
          next: b1,
          dismissed: {'startEpisode:${AppRoutes.play('A1-009')}'},
        ),
      );
      expect(plan.primary.kind, HiSuggestionKind.startEpisode);
    });
  });

  group('plan sırası ve adımlar', () {
    test('kısa tekrar → sahne → küçük görev; tek eylem', () {
      final plan = planToday(
        input(
          next: b1,
          reviewDue: 6,
          sets: const [CoachTopicSet(id: 'harbour', titleTr: 'Liman')],
        ),
      );
      expect(plan.primary.kind, HiSuggestionKind.review);
      expect(
        [for (final s in plan.steps) (s.stage, s.state)],
        [
          (PlanStage.warmUp, PlanStepState.current),
          (PlanStage.main, PlanStepState.upcoming),
          (PlanStage.task, PlanStepState.upcoming),
        ],
      );
    });

    test('tekrar yapıldıktan sonra: kısa tekrar bitti, sahne şimdi', () {
      final plan = planToday(
        input(
          next: b1,
          reviewedToday: true,
          sets: const [CoachTopicSet(id: 'harbour', titleTr: 'Liman')],
        ),
      );
      expect(plan.primary.kind, HiSuggestionKind.startEpisode);
      expect(
        [for (final s in plan.steps) (s.stage, s.state)],
        [
          (PlanStage.warmUp, PlanStepState.done),
          (PlanStage.main, PlanStepState.current),
          (PlanStage.task, PlanStepState.upcoming),
        ],
      );
    });

    test('bugün bölüm bitti: küçük görev sıradaki bölümün önüne geçer', () {
      final plan = planToday(
        input(
          next: b1,
          mainDoneToday: true,
          sets: const [CoachTopicSet(id: 'harbour', titleTr: 'Liman')],
        ),
      );
      expect(plan.primary.kind, HiSuggestionKind.sceneHunt);
      expect(plan.queue.first.kind, HiSuggestionKind.startEpisode);
      expect(
        plan.steps.firstWhere((s) => s.stage == PlanStage.main).state,
        PlanStepState.done,
      );
    });

    test('uzun aradan sonra: az tekrar bile önce, sıcak karşılamayla', () {
      final plan = planToday(
        input(
          next: b1,
          reviewDue: 2,
          lastActiveAt: now.subtract(const Duration(days: 9)),
        ),
      );
      expect(plan.primary.kind, HiSuggestionKind.review);
      expect(plan.primary.reasonTr, startsWith('Tekrar hoş geldin!'));
      // Kısa aradan sonra eşik altı tekrar küçük görevdir.
      final soon = planToday(
        input(
          next: b1,
          reviewDue: 2,
          lastActiveAt: now.subtract(const Duration(days: 1)),
        ),
      );
      expect(soon.primary.kind, HiSuggestionKind.startEpisode);
    });

    test('dil: suçlama, geri sayım, aciliyet yok (K-32)', () {
      const banned = [
        'yanlış',
        'başarısız',
        'kaçırdın',
        'serini',
        'son şans',
        'hemen',
        'acele',
        'geride',
        'ihmal',
      ];
      final plans = [
        planToday(input(level: 'B2', start: b2Book)),
        planToday(
          input(
            reviewDue: 1,
            lastActiveAt: now.subtract(const Duration(days: 30)),
          ),
        ),
        planToday(input(inProgress: half(ago: const Duration(days: 40)))),
        planToday(input(next: b1, dismissed: {'startEpisode:/play/A1-001'})),
      ];
      for (final p in plans) {
        final text = '${p.primary.title} ${p.primary.reasonTr}'.toLowerCase();
        for (final w in banned) {
          expect(text, isNot(contains(w)), reason: text);
        }
      }
    });
  });
}

extension on CoachBook {
  CoachBook copyWithPercent(int percent) => CoachBook(
    bookId: bookId,
    title: title,
    level: level,
    percent: percent,
    estimatedMinutes: estimatedMinutes,
  );
}
