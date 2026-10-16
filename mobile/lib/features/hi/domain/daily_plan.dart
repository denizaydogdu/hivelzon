// Bugünün planı (H-088): Ana Sayfa'nın birincil kartı ile Hi'nin günlük
// önerisi **aynı** saf fonksiyondan gelir ([planToday]). Kural tabanlı,
// gerekçesi görünür; yapay zekâ yok.
//
// Plan sırası: kısa tekrar (borç varsa) → sahne ya da okuma → küçük görev.
// Kullanıcı yine tek eylem görür ([DailyPlan.primary]); adımlar
// ([DailyPlan.steps]) yalnızca sakin bir ilerleme olarak gösterilir.
//
// Sıra (ilk tutan, bugün geçilmemiş öneri birincildir):
//   1. Bugün oynanmış yarım bölüm → kaldığı yerden devam (oturumun ortası;
//      yarıda kesilmez).
//   2. Kısa tekrar adımı:
//      a) tekrar zamanı gelen ifade ≥ [kReviewThreshold] → Kelime tekrarı;
//         uzun aradan ([kLongBreak]) sonra 1 ifade bile yeter (sıcak
//         karşılama gerekçesiyle);
//      b) son 7 günde aynı hata türü ≥ [kRepeatedErrors] → Hi'nin notu / defter.
//   3. Sahne ya da okuma (ana adım), seviyeye göre:
//      - A1–A2 (ya da seviye yok): yarım bölüm → yarım kitap → sıradaki
//        bölüm. [kStaleHalfEpisode]'dan uzun bekleyen yarım bölüm yarım
//        kitabın arkasına geçer.
//      - B1+: yarım kitap → seviyesindeki okunmamış kitap. Hikâye isteğe
//        bağlıdır: yarım ve sıradaki bölüm küçük görevden sonra gelir (kitap
//        yoksa yedek). Yeni bölüm üretilmez (K-25).
//   4. Küçük görev: A1–A2'de sahne avı → Konuş görevi → eşik altı tekrar →
//      kitap dinleme → dilbilgisi; B1+'da dilbilgisi → eşik altı tekrar
//      (sahne avı ve Konuş görevleri A1 mekân ve ifadeleridir; önerilmez).
//      **İlk 7 gün (A1 ya da seviye yok; H-090):** Konuş görevi küçük
//      görevlerin başına geçer ve gerekçe günü söyler ("İlk haftanın 3.
//      günü…"). Görev, ilgili bölüm bitince açılır (kafe sahnesi B9'dan
//      sonra). Konuş görevi günde en çok bir kez önerilir.
//      Bugün ana adım yapıldıysa (bölüm bitti ya da kitap okundu) küçük görev
//      ana adımın önüne geçer: "sahne → küçük görev" sırası korunur.
//   5. Hiçbiri (ya da hepsi bugün geçildi) → "Bugünlük bu kadar yeter".
//
// "Başka bir öneri" ile geçilen öneri ([CoachInput.dismissed]) o gün yeniden
// önerilmez; ertesi gün sıfırlanır. Tekrar borcu bu yüzden en çok bir gün
// ertelenir: yarım bölüm onu sonsuza dek bastıramaz.

import '../../../l10n/tr_strings.dart';
import 'coach_rules.dart';

/// Bu kadar süredir dokunulmayan yarım bölüm "bekleyen" sayılır.
const Duration kStaleHalfEpisode = Duration(days: 7);

/// Bu kadar süre etkinlik yoksa plan kısa bir tekrarla başlar.
const Duration kLongBreak = Duration(days: 7);

/// İlk hafta akışının süresi (H-090).
const int kFirstWeekDays = 7;

/// Birincil önerinin kitap olduğu seviyeler (yerleştirme sonucu).
const Set<String> kAdvancedLevels = {'B1', 'B2', 'C1', 'C2'};

bool isAdvancedLevel(String? level) =>
    kAdvancedLevels.contains(level?.trim().toUpperCase());

/// İlk haftanın kaçıncı günü (1–7); ilk hafta akışı yoksa null (H-090).
/// Yalnızca A1 (ya da seviye testi yapılmamış) kullanıcı için; gün yerel
/// takvimle sayılır.
int? firstWeekDay(CoachInput i) {
  final start = i.startedAt;
  final level = i.level?.trim().toUpperCase();
  if (start == null || (level != null && level != 'A1')) return null;
  final a = start.toLocal();
  final b = i.now.toLocal();
  final days = DateTime.utc(
    b.year,
    b.month,
    b.day,
  ).difference(DateTime.utc(a.year, a.month, a.day)).inDays;
  if (days < 0 || days >= kFirstWeekDays) return null;
  return days + 1;
}

enum PlanStepState { done, current, upcoming }

/// Planın bir adımı: kısa tekrar, sahne/okuma ya da küçük görev.
class PlanStep {
  const PlanStep({
    required this.stage,
    required this.state,
    this.reading = false,
  });

  final PlanStage stage;
  final PlanStepState state;

  /// Ana adım kitap mı (etiket "Okuma"), bölüm mü ("Sahne")?
  final bool reading;
}

class DailyPlan {
  const DailyPlan({
    required this.primary,
    required this.steps,
    required this.queue,
    this.advanced = false,
  });

  /// Kullanıcının gördüğü tek eylem (Ana Sayfa kartı = Hi önerisi).
  final HiSuggestion primary;

  /// Bugünün adımları (yalnızca gereken ya da bugün yapılanlar), sırayla.
  final List<PlanStep> steps;

  /// Birincilden sonra sıradaki öneriler (geçilmemiş), sırayla; sonda her
  /// zaman "Bugünlük bu kadar yeter".
  final List<HiSuggestion> queue;

  /// Seviye testi B1+ (hikâye isteğe bağlı, kitap birincil).
  final bool advanced;
}

DailyPlan planToday(CoachInput i) {
  final goal = i.dailyGoalMinutes;
  final advanced = isAdvancedLevel(i.level);
  final last = i.lastActiveAt;
  final longBreak = last != null && i.now.difference(last) >= kLongBreak;
  bool open(HiSuggestion? s) => s != null && !i.dismissed.contains(s.key);

  // ---- adaylar
  final ip = i.inProgress;
  final played = ip?.lastPlayedAt;
  final freshEpisode =
      ip != null && played != null && _sameLocalDay(played, i.now);
  final staleEpisode =
      ip != null &&
      played != null &&
      i.now.difference(played) >= kStaleHalfEpisode;
  final continueEpisode = ip == null
      ? null
      : HiSuggestion(
          kind: HiSuggestionKind.continueEpisode,
          title: HiTexts.continueTitle(ip.title),
          reasonTr: staleEpisode
              ? HiTexts.continueStaleReason(
                  ip.number,
                  ip.estimatedMinutes,
                  goal,
                )
              : HiTexts.continueReason(ip.number, ip.estimatedMinutes, goal),
          actionLabel: HiTexts.continueAction,
          actionRoute: '/play/${ip.contentId}?mode=resume',
          minutes: ip.estimatedMinutes,
          contentId: ip.contentId,
        );

  final ib = i.bookInProgress;
  final continueBook = () {
    if (ib == null) return null;
    final est = ib.estimatedMinutes == null
        ? null
        : (ib.estimatedMinutes! * (100 - ib.percent) / 100).ceil();
    return HiSuggestion(
      kind: HiSuggestionKind.continueBook,
      title: HiTexts.continueBookTitle(ib.title),
      reasonTr: HiTexts.continueBookReason(ib.title, ib.percent, est, goal),
      actionLabel: HiTexts.continueBookAction,
      actionRoute: '/kitap/${ib.bookId}',
      minutes: est,
    );
  }();

  final nx = i.next;
  final startEpisode = nx == null
      ? null
      : HiSuggestion(
          kind: HiSuggestionKind.startEpisode,
          title: HiTexts.startTitle(nx.title),
          reasonTr: HiTexts.startReason(
            nx.number,
            i.completedCount,
            nx.estimatedMinutes,
            goal,
          ),
          actionLabel: HiTexts.startAction,
          actionRoute: '/play/${nx.contentId}',
          minutes: nx.estimatedMinutes,
          contentId: nx.contentId,
        );

  final sb = i.bookToStart;
  final startBook = sb == null
      ? null
      : advanced
      // B1+: seviyesindeki kitap birincil; okuyucu açılır (dinle ya da oku).
      ? HiSuggestion(
          kind: HiSuggestionKind.startBook,
          title: HiTexts.levelBookTitle(sb.title),
          reasonTr: HiTexts.levelBookReason(
            sb.level,
            sb.estimatedMinutes,
            goal,
          ),
          actionLabel: HiTexts.levelBookAction,
          actionRoute: '/kitap/${sb.bookId}',
          minutes: sb.estimatedMinutes,
        )
      // A1–A2: hikâyeden sonra kulak için sesli kitap.
      : HiSuggestion(
          kind: HiSuggestionKind.startBook,
          title: HiTexts.startBookTitle(sb.title),
          reasonTr: HiTexts.startBookReason(
            sb.level,
            sb.estimatedMinutes,
            goal,
          ),
          actionLabel: HiTexts.startBookAction,
          actionRoute: '/kitap/${sb.bookId}?mod=dinle',
          minutes: sb.estimatedMinutes,
        );

  final set = i.unhuntedSets.firstOrNull;
  final hunt = set == null
      ? null
      : HiSuggestion(
          kind: HiSuggestionKind.sceneHunt,
          title: HiTexts.huntTitle(set.titleTr),
          reasonTr: HiTexts.huntReason(set.titleTr, set.unlockEpisode),
          actionLabel: HiTexts.huntAction,
          actionRoute: '/konu-seti/${set.id}/sahne-avi',
          minutes: 3,
          stage: PlanStage.task,
        );

  final g = i.grammar;
  final grammar = g == null
      ? null
      : HiSuggestion(
          kind: HiSuggestionKind.grammarSuggest,
          title: HiTexts.grammarTitle(g.titleTr),
          reasonTr: HiTexts.grammarReason(g.sourceTr, g.minutes, goal),
          actionLabel: HiTexts.grammarAction,
          actionRoute: '/dilbilgisi/${g.lessonId}',
          minutes: g.minutes,
          stage: PlanStage.task,
        );

  // Konuş görevi (H-090): günde en çok bir tane; B1+ kullanıcıya önerilmez.
  final day = advanced ? null : firstWeekDay(i);
  final tk = (advanced || i.talkDoneToday) ? null : i.talkTasks.firstOrNull;
  final talk = tk == null
      ? null
      : HiSuggestion(
          kind: HiSuggestionKind.talk,
          title: TalkPlanTexts.title(tk.titleTr),
          reasonTr: TalkPlanTexts.reason(
            day: day,
            scene: tk.scene,
            episode: tk.unlockEpisode,
            character: tk.characterTr,
            minutes: tk.minutes,
            goal: goal,
          ),
          actionLabel: tk.scene
              ? TalkPlanTexts.sceneAction
              : TalkPlanTexts.messageAction,
          actionRoute: '/konusma/${tk.id}',
          minutes: tk.minutes,
          stage: PlanStage.task,
        );

  final dueWarm =
      i.reviewDue >= kReviewThreshold || (longBreak && i.reviewDue > 0);
  final warm = <HiSuggestion?>[
    if (dueWarm) reviewSuggestion(i.reviewDue, goal, afterBreak: longBreak),
    repeatedErrorSuggestion(i),
  ];
  final smallReview = !dueWarm && i.reviewDue > 0
      ? reviewSuggestion(i.reviewDue, goal, stage: PlanStage.task)
      : null;

  // B1+: hikâye isteğe bağlıdır; kitap ve kısa görevden sonra gelir.
  final main = advanced
      ? [continueBook, startBook]
      : staleEpisode
      ? [continueBook, continueEpisode, startEpisode]
      : [continueEpisode, continueBook, startEpisode];
  // Sahne avı A1 mekân kelimeleridir: B1+ kullanıcıya önerilmez (kullanıcı
  // kararı 2026-10-16); isteyen Defter'den açar.
  final tasks = advanced
      ? [grammar, smallReview]
      : day != null
      // İlk hafta (H-090): bölümden sonra kendi kullanma görevi önce.
      ? [talk, hunt, smallReview, startBook, grammar]
      : [hunt, talk, smallReview, startBook, grammar];

  // ---- sıra
  final ordered = <HiSuggestion>[];
  final keys = <String>{};
  void add(HiSuggestion? s) {
    if (!open(s) || !keys.add(s!.key)) return;
    ordered.add(s);
  }

  if (freshEpisode) add(continueEpisode);
  warm.forEach(add);
  if (i.mainDoneToday) {
    tasks.forEach(add);
    main.forEach(add);
  } else {
    main.forEach(add);
    tasks.forEach(add);
  }
  if (advanced) {
    add(continueEpisode);
    add(startEpisode);
  }
  final anyDismissed = [
    continueEpisode,
    continueBook,
    startEpisode,
    startBook,
    hunt,
    grammar,
    smallReview,
    talk,
    ...warm,
  ].any((s) => s != null && i.dismissed.contains(s.key));
  ordered.add(
    HiSuggestion(
      kind: HiSuggestionKind.rest,
      title: HiTexts.restTitle,
      reasonTr: anyDismissed ? HiTexts.restDismissedReason : HiTexts.restReason,
    ),
  );
  final primary = ordered.first;

  // ---- adımlar
  bool has(PlanStage s) => ordered.any((x) => x.stage == s && x.dismissible);
  final steps = <PlanStep>[];
  void step(PlanStage s, bool done, {bool reading = false}) {
    final current = primary.dismissible && primary.stage == s;
    if (!current && !done && !has(s)) return;
    steps.add(
      PlanStep(
        stage: s,
        reading: reading,
        state: current
            ? PlanStepState.current
            : done
            ? PlanStepState.done
            : PlanStepState.upcoming,
      ),
    );
  }

  final firstMain = ordered
      .where((x) => x.stage == PlanStage.main && x.dismissible)
      .firstOrNull;
  step(PlanStage.warmUp, i.reviewedToday && !has(PlanStage.warmUp));
  step(
    PlanStage.main,
    i.mainDoneToday,
    reading:
        firstMain?.kind == HiSuggestionKind.continueBook ||
        firstMain?.kind == HiSuggestionKind.startBook ||
        (firstMain == null && advanced),
  );
  step(PlanStage.task, i.taskDoneToday);

  return DailyPlan(
    primary: primary,
    steps: steps,
    queue: ordered.skip(1).toList(),
    advanced: advanced,
  );
}

bool _sameLocalDay(DateTime a, DateTime b) {
  final x = a.toLocal();
  final y = b.toLocal();
  return x.year == y.year && x.month == y.month && x.day == y.day;
}
