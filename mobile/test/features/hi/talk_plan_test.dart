import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/hi/domain/coach_rules.dart';
import 'package:hivelzon/l10n/tr_strings.dart';

/// H-090: ilk 7 günlük A1 akışı. Bölümden sonra küçük görev olarak Konuş
/// görevi (yönlendirmeli sahne ya da kısa mesaj); tek birincil eylem ve
/// görünür gerekçe korunur (H-088).
void main() {
  final now = DateTime.utc(2026, 10, 16, 9);
  const neighbour = CoachTalk(
    id: 'maya-neighbour',
    titleTr: 'Yeni komşunla tanış',
    scene: true,
    unlockEpisode: 2,
    characterTr: 'Maya',
    minutes: 3,
  );
  const lateMsg = CoachTalk(
    id: 'late-maya',
    titleTr: "Maya'ya geç kaldığını yaz",
    scene: false,
    unlockEpisode: 5,
    characterTr: 'Maya',
    minutes: 2,
  );
  const next = CoachEpisode(
    contentId: 'A1-003',
    number: 3,
    title: 'Find the Station',
    estimatedMinutes: 6,
  );
  const set = CoachTopicSet(id: 'harbour', titleTr: 'Liman', unlockEpisode: 3);

  CoachInput input({
    Duration since = const Duration(days: 1),
    String? level,
    List<CoachTalk> talk = const [neighbour],
    bool mainDoneToday = false,
    bool talkDoneToday = false,
    List<CoachTopicSet> sets = const [],
    Set<String> dismissed = const {},
    CoachEpisode? nextEpisode = next,
    DateTime? startedAt,
  }) => CoachInput(
    now: now,
    dailyGoalMinutes: 10,
    level: level,
    next: nextEpisode,
    completedCount: 2,
    talkTasks: talk,
    talkDoneToday: talkDoneToday,
    taskDoneToday: talkDoneToday,
    mainDoneToday: mainDoneToday,
    unhuntedSets: sets,
    dismissed: dismissed,
    startedAt: startedAt ?? now.subtract(since),
  );

  group('ilk hafta günü', () {
    test('açılış günü 1. gün; yerel takvimle sayılır; 7 günden sonra yok', () {
      expect(firstWeekDay(input(since: Duration.zero)), 1);
      expect(firstWeekDay(input(since: const Duration(days: 2))), 3);
      expect(firstWeekDay(input(since: const Duration(days: 6))), 7);
      expect(firstWeekDay(input(since: const Duration(days: 7))), isNull);
    });

    test('yalnızca A1 (ya da seviye yok); başlangıç bilinmiyorsa yok', () {
      expect(firstWeekDay(input(level: 'A1')), 2);
      expect(firstWeekDay(input(level: 'A2')), isNull);
      expect(firstWeekDay(input(level: 'B2')), isNull);
      expect(
        firstWeekDay(
          CoachInput(now: now, dailyGoalMinutes: 10, talkTasks: [neighbour]),
        ),
        isNull,
      );
    });
  });

  group('ilk 7 gün: sahne → küçük görev', () {
    test('bölüm bugün bittiyse birincil eylem Konuş sahnesi; gerekçe günü '
        've bölümü söyler', () {
      final plan = planToday(input(mainDoneToday: true, sets: [set]));
      final p = plan.primary;
      expect(p.kind, HiSuggestionKind.talk);
      expect(p.stage, PlanStage.task);
      expect(p.actionRoute, '/konusma/maya-neighbour');
      expect(p.actionLabel, TalkPlanTexts.sceneAction);
      expect(p.title, 'Konuş: Yeni komşunla tanış');
      expect(p.reasonTr, startsWith('İlk haftanın 2. günü. Bölüm 2'));
      expect(p.reasonTr, contains('Maya ile'));
      expect(p.reasonTr, contains('puan yok'));
      // Sahne avı sırada kalır (tek birincil eylem).
      expect(plan.queue.first.kind, HiSuggestionKind.sceneHunt);
    });

    test('bölüm henüz oynanmadıysa önce sahne (bölüm), sonra Konuş', () {
      final plan = planToday(input(sets: [set]));
      expect(plan.primary.kind, HiSuggestionKind.startEpisode);
      final kinds = plan.queue.map((s) => s.kind).toList();
      expect(
        kinds.indexOf(HiSuggestionKind.talk),
        lessThan(kinds.indexOf(HiSuggestionKind.sceneHunt)),
      );
      expect(
        plan.steps.map((s) => s.stage),
        containsAllInOrder([PlanStage.main, PlanStage.task]),
      );
    });

    test('mesaj görevi: fiil ve gerekçe mesaj için', () {
      final p = planToday(input(talk: [lateMsg], mainDoneToday: true)).primary;
      expect(p.actionLabel, TalkPlanTexts.messageAction);
      expect(p.reasonTr, contains('kısa bir mesaj yaz'));
      expect(p.minutes, 2);
    });

    test(
      'günde en çok bir Konuş görevi: bugün yapıldıysa yenisi önerilmez',
      () {
        final plan = planToday(
          input(talk: [lateMsg], mainDoneToday: true, talkDoneToday: true),
        );
        expect(
          [plan.primary, ...plan.queue].map((s) => s.kind),
          isNot(contains(HiSuggestionKind.talk)),
        );
      },
    );

    test('açılmış görev yoksa plan H-088 ile aynı', () {
      final a = planToday(
        input(talk: const [], mainDoneToday: true, sets: [set]),
      );
      expect(a.primary.kind, HiSuggestionKind.sceneHunt);
    });

    test('"Başka bir öneri" ile geçilen Konuş görevi bugün yeniden gelmez', () {
      const key = 'talk:/konusma/maya-neighbour';
      final plan = planToday(input(mainDoneToday: true, dismissed: {key}));
      expect(plan.primary.key, isNot(key));
      expect(plan.queue.map((s) => s.key), isNot(contains(key)));
    });
  });

  group('ilk haftadan sonra ve seviye', () {
    test('8. gün: Konuş görevi sahne avından sonra, gerekçede gün yok', () {
      final plan = planToday(
        input(since: const Duration(days: 8), mainDoneToday: true, sets: [set]),
      );
      expect(plan.primary.kind, HiSuggestionKind.sceneHunt);
      final talk = plan.queue.firstWhere(
        (s) => s.kind == HiSuggestionKind.talk,
      );
      expect(talk.reasonTr, startsWith('Bölüm 2'));
    });

    test('A2 yerleştirme: ilk hafta akışı yok ama görev önerilebilir', () {
      final plan = planToday(
        input(level: 'A2', mainDoneToday: true, sets: [set]),
      );
      expect(plan.primary.kind, HiSuggestionKind.sceneHunt);
      expect(plan.queue.map((s) => s.kind), contains(HiSuggestionKind.talk));
    });

    test('B1+: A1 Konuş sahneleri önerilmez', () {
      final plan = planToday(input(level: 'B1', mainDoneToday: true));
      expect(
        [plan.primary, ...plan.queue].map((s) => s.kind),
        isNot(contains(HiSuggestionKind.talk)),
      );
    });
  });

  test('dil: suçlama, geri sayım, aciliyet yok (K-32)', () {
    for (final t in [neighbour, lateMsg]) {
      for (final day in [null, 1, 7]) {
        final r = TalkPlanTexts.reason(
          day: day,
          scene: t.scene,
          episode: t.unlockEpisode,
          character: t.characterTr,
          minutes: 12,
          goal: 10,
        );
        for (final bad in [
          'yanlış',
          'kaçırdın',
          'acele',
          'son şans',
          'hemen',
        ]) {
          expect(r.toLowerCase(), isNot(contains(bad)), reason: r);
        }
      }
    }
  });
}
