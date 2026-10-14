// Hi-A koçu (H-048): günün tek önerisi ve görünür gerekçesi. Saf Dart; kural
// tabanlı, öncelik sıralı, yapay zekâ yok (ürün ilkesi: "ilk sürümde öneriler
// kural tabanlı ve gerekçeli"; HI-ASISTAN-VE-KOC.md §2 F3).
//
// Öncelik:
//   a) yarım kalan bölüm → kaldığı yerden devam
//   b) tekrar zamanı gelen ifade ≥ [kReviewThreshold] → Kelime tekrarı
//   c) son 7 günde aynı hata türü ≥ [kRepeatedErrors] → Hi'nin notu / defter
//   g) yarıda kalan kitap → kaldığı cümleden devam (H-067)
//   d) sıradaki açık bölüm → başla
//   e) açılmış ama sahne avı yapılmamış konu seti → Sahne avı
//   b') birkaç ifadenin tekrar zamanı geldiyse (eşiğin altında) → Kelime tekrarı
//   h) seviyede okunmamış kitap → dinlemeye başla (H-067)
//   f) hiçbiri → "Bugünlük bu kadar yeter"
//
// Dil: suçlama, geri sayım, aciliyet yok (K-32). Süreler günlük hedefe göre
// söylenir; hedefi aşan öneride "istediğin yerde bırakabilirsin" denir.

import '../../../l10n/tr_strings.dart';
import '../../../shared/meaning/error_taxonomy.dart';
import 'hi_content.dart';

const int kReviewThreshold = 5;
const int kRepeatedErrors = 2;
const Duration kCoachWindow = Duration(days: 7);

enum HiSuggestionKind {
  continueEpisode,
  review,
  errorNote,
  notebook,
  startEpisode,
  sceneHunt,
  continueBook,
  startBook,
  rest,
}

/// Önerinin eylemi: bir sayfa ([route]) ya da Hi'nin notu ([noteId]).
class HiSuggestion {
  const HiSuggestion({
    required this.kind,
    required this.title,
    required this.reasonTr,
    this.actionLabel,
    this.actionRoute,
    this.noteId,
    this.errorType,
    this.minutes,
  });

  final HiSuggestionKind kind;
  final String title;

  /// "Neden?" satırı: her önerinin görünür gerekçesi.
  final String reasonTr;
  final String? actionLabel;
  final String? actionRoute;
  final String? noteId;

  /// (c) kuralının hata türü: not açılınca okundu olarak kaydedilir.
  final ErrorType? errorType;
  final int? minutes;

  bool get hasAction => actionRoute != null || noteId != null;
}

class CoachEpisode {
  const CoachEpisode({
    required this.contentId,
    required this.number,
    required this.title,
    this.estimatedMinutes,
  });

  final String contentId;
  final int number;
  final String title;
  final int? estimatedMinutes;
}

class CoachTopicSet {
  const CoachTopicSet({
    required this.id,
    required this.titleTr,
    this.unlockEpisode,
  });

  final String id;
  final String titleTr;
  final int? unlockEpisode;
}

/// Kitaplık kitabı (H-067).
class CoachBook {
  const CoachBook({
    required this.bookId,
    required this.title,
    required this.level,
    this.percent = 0,
    this.estimatedMinutes,
  });

  final String bookId;
  final String title;
  final String level;

  /// Okunan kısım (yarım kitapta).
  final int percent;
  final int? estimatedMinutes;
}

/// Öğrenme olayındaki hata (yalnızca `errorType` dolu olanlar).
class ErrorObservation {
  const ErrorObservation({
    required this.type,
    required this.at,
    this.contentId,
    this.sourceId,
  });

  final ErrorType type;

  /// UTC.
  final DateTime at;
  final String? contentId;
  final String? sourceId;
}

class CoachInput {
  const CoachInput({
    required this.now,
    required this.dailyGoalMinutes,
    this.inProgress,
    this.next,
    this.completedCount = 0,
    this.reviewDue = 0,
    this.errors = const [],
    this.notesReadAt = const {},
    this.unhuntedSets = const [],
    this.content = HiContent.empty,
    this.bookInProgress,
    this.bookToStart,
  });

  /// UTC.
  final DateTime now;
  final int dailyGoalMinutes;

  /// Yarım kalan bölüm (kaydı olan) ve sıradaki açık bölüm.
  final CoachEpisode? inProgress;
  final CoachEpisode? next;
  final int completedCount;

  /// Bugünkü kelime tekrarı oturumunun kart sayısı.
  final int reviewDue;
  final List<ErrorObservation> errors;

  /// Hata türü kodu → (c) önerisinin en son açıldığı an (UTC).
  final Map<String, DateTime> notesReadAt;
  final List<CoachTopicSet> unhuntedSets;
  final HiContent content;

  /// Yarıda kalan kitap (son okunan) ve seviyede okunmamış bir kitap.
  final CoachBook? bookInProgress;
  final CoachBook? bookToStart;
}

/// Kurallar sırayla denenir; ilk tutan öneri döner (her zaman bir öneri var).
HiSuggestion suggestToday(CoachInput i) {
  final goal = i.dailyGoalMinutes;

  // a) Yarım kalan bölüm.
  final ip = i.inProgress;
  if (ip != null) {
    return HiSuggestion(
      kind: HiSuggestionKind.continueEpisode,
      title: HiTexts.continueTitle(ip.title),
      reasonTr: HiTexts.continueReason(ip.number, ip.estimatedMinutes, goal),
      actionLabel: HiTexts.continueAction,
      actionRoute: '/play/${ip.contentId}?mode=resume',
      minutes: ip.estimatedMinutes,
    );
  }

  // b) Tekrar zamanı gelen ifadeler (eşik ve üstü).
  if (i.reviewDue >= kReviewThreshold) return _review(i.reviewDue, goal);

  // c) Son 7 günde tekrarlayan hata türü.
  final c = _repeatedError(i);
  if (c != null) return c;

  // g) Yarıda kalan kitap (bölüm ve tekrardan sonra; H-067).
  final ib = i.bookInProgress;
  if (ib != null) {
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
  }

  // d) Sıradaki bölüm.
  final nx = i.next;
  if (nx != null) {
    return HiSuggestion(
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
    );
  }

  // e) Sahne avı yapılmamış açık konu seti.
  final set = i.unhuntedSets.firstOrNull;
  if (set != null) {
    return HiSuggestion(
      kind: HiSuggestionKind.sceneHunt,
      title: HiTexts.huntTitle(set.titleTr),
      reasonTr: HiTexts.huntReason(set.titleTr, set.unlockEpisode),
      actionLabel: HiTexts.huntAction,
      actionRoute: '/konu-seti/${set.id}/sahne-avi',
      minutes: 3,
    );
  }

  // b') Eşiğin altında da olsa tekrar zamanı gelen ifade.
  if (i.reviewDue > 0) return _review(i.reviewDue, goal);

  // h) Okunmamış kitap (H-067).
  final sb = i.bookToStart;
  if (sb != null) {
    return HiSuggestion(
      kind: HiSuggestionKind.startBook,
      title: HiTexts.startBookTitle(sb.title),
      reasonTr: HiTexts.startBookReason(sb.level, sb.estimatedMinutes, goal),
      actionLabel: HiTexts.startBookAction,
      actionRoute: '/kitap/${sb.bookId}?mod=dinle',
      minutes: sb.estimatedMinutes,
    );
  }

  // f) Bugünlük bu kadar.
  return const HiSuggestion(
    kind: HiSuggestionKind.rest,
    title: HiTexts.restTitle,
    reasonTr: HiTexts.restReason,
  );
}

HiSuggestion _review(int n, int goal) {
  final minutes = HomeTexts.reviewMinutes(n);
  return HiSuggestion(
    kind: HiSuggestionKind.review,
    title: HiTexts.reviewTitle,
    reasonTr: HiTexts.reviewReason(n, minutes, goal),
    actionLabel: HiTexts.reviewAction,
    actionRoute: '/tekrar',
    minutes: minutes,
  );
}

/// Hatırlama ve "diğer" de sayılır; hepsi aynı pencerede değerlendirilir.
HiSuggestion? _repeatedError(CoachInput i) {
  final since = i.now.subtract(kCoachWindow);
  final byType = <ErrorType, List<ErrorObservation>>{};
  for (final e in i.errors) {
    if (e.at.isBefore(since) || e.type == ErrorType.other) continue;
    byType.putIfAbsent(e.type, () => []).add(e);
  }
  ErrorType? best;
  List<ErrorObservation>? bestList;
  for (final entry in byType.entries) {
    final list = entry.value..sort((a, b) => a.at.compareTo(b.at));
    if (list.length < kRepeatedErrors) continue;
    // Not, bu türün son hatasından sonra açıldıysa tekrar önerilmez.
    final read = i.notesReadAt[entry.key.code];
    if (read != null && !read.isBefore(list.last.at)) continue;
    if (bestList == null ||
        list.length > bestList.length ||
        (list.length == bestList.length &&
            list.last.at.isAfter(bestList.last.at))) {
      best = entry.key;
      bestList = list;
    }
  }
  if (best == null || bestList == null) return null;
  final n = bestList.length;
  // Not: önce olayın kendi notu (karar seçeneği eşlemesi), sonra türün ilk notu.
  ErrorNote? note;
  for (final e in bestList.reversed) {
    final cid = e.contentId;
    final sid = e.sourceId;
    if (cid == null || sid == null) continue;
    note = i.content.note(i.content.decisionError(cid, sid)?.entry);
    if (note != null) break;
  }
  note ??= i.content.noteForType(best);
  if (note != null) {
    return HiSuggestion(
      kind: HiSuggestionKind.errorNote,
      title: HiTexts.noteTitle(note.labelTr),
      reasonTr: HiTexts.noteReason(best.labelTr, n),
      actionLabel: HiTexts.noteAction,
      noteId: note.id,
      errorType: best,
      minutes: 1,
    );
  }
  return HiSuggestion(
    kind: HiSuggestionKind.notebook,
    title: HiTexts.notebookTitle,
    reasonTr: HiTexts.notebookReason(best.labelTr, n),
    actionLabel: HiTexts.notebookAction,
    actionRoute: '/profil/defter',
    errorType: best,
    minutes: 2,
  );
}
