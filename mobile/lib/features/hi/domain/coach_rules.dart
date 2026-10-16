// Hi-A koçu (H-048) ve günlük plan (H-088): günün tek önerisi ve görünür
// gerekçesi. Saf Dart; kural tabanlı, öncelik sıralı, yapay zekâ yok (ürün
// ilkesi: "ilk sürümde öneriler kural tabanlı ve gerekçeli";
// HI-ASISTAN-VE-KOC.md §2 F3).
//
// Bu dosya girdileri, öneri tipini ve tekil kuralları (tekrar, hata notu)
// tutar. Sıralama tek yerdedir: `daily_plan.dart` ([planToday]). Ana Sayfa'nın
// birincil kartı ve Hi'nin önerisi aynı fonksiyondan gelir.
//
// Dil: suçlama, geri sayım, aciliyet yok (K-32). Süreler günlük hedefe göre
// söylenir; hedefi aşan öneride "istediğin yerde bırakabilirsin" denir.

import '../../../l10n/tr_strings.dart';
import '../../../shared/meaning/error_taxonomy.dart';
import 'daily_plan.dart';
import 'hi_content.dart';

export 'daily_plan.dart';

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
  grammarSuggest,

  /// Konuş görevi (H-090): yönlendirmeli sahne ya da kısa mesaj.
  talk,
  rest,
}

/// Günlük planın adımları (H-088): kısa tekrar → sahne ya da okuma → küçük
/// görev. Kullanıcı yine tek eylem görür; adımlar yalnızca sakin bir
/// ilerleme olarak gösterilir.
enum PlanStage { warmUp, main, task }

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
    this.stage = PlanStage.main,
    this.contentId,
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

  /// Planın hangi adımı.
  final PlanStage stage;

  /// Bölüm önerisinde bölümün kimliği (Ana Sayfa'nın görselli kartı için).
  final String? contentId;

  bool get hasAction => actionRoute != null || noteId != null;

  /// "Başka bir öneri" ile bugünlük geçilen önerinin anahtarı: tür + hedef
  /// (sayfa ya da not). Aynı anahtar o gün yeniden önerilmez.
  String get key => '${kind.name}:${noteId ?? actionRoute ?? ''}';

  /// "Bugünlük bu kadar yeter" geçilmez.
  bool get dismissible => kind != HiSuggestionKind.rest;
}

class CoachEpisode {
  const CoachEpisode({
    required this.contentId,
    required this.number,
    required this.title,
    this.estimatedMinutes,
    this.lastPlayedAt,
  });

  final String contentId;
  final int number;
  final String title;
  final int? estimatedMinutes;

  /// Yarım bölümde son kaydedilen sahnenin anı (UTC; bilinmiyorsa null).
  final DateTime? lastPlayedAt;
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

/// Konuş görevi (H-090): açılmış (bölümü bitmiş), henüz yapılmamış.
class CoachTalk {
  const CoachTalk({
    required this.id,
    required this.titleTr,
    required this.scene,
    this.unlockEpisode,
    this.characterTr,
    this.minutes = 3,
  });

  final String id;
  final String titleTr;

  /// Sahne mi (karakterle konuşma), kısa mesaj mı.
  final bool scene;

  /// Görevi açan bölüm (gerekçede: "Bölüm 2'de …").
  final int? unlockEpisode;

  /// Sahnedeki karakter ("Maya"); mesajda alıcı.
  final String? characterTr;
  final int minutes;
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

/// Dilbilgisi dersi (H-078): oynanan bölümde ya da okunan kitapta geçen,
/// bitirilmemiş konu.
class CoachGrammar {
  const CoachGrammar({
    required this.lessonId,
    required this.titleTr,
    required this.sourceTr,
    this.minutes,
  });

  final String lessonId;
  final String titleTr;

  /// Gerekçedeki kaynak: '"The New Neighbour" bölümünde'.
  final String sourceTr;
  final int? minutes;
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
    this.grammar,
    this.level,
    this.lastActiveAt,
    this.dismissed = const {},
    this.reviewedToday = false,
    this.mainDoneToday = false,
    this.taskDoneToday = false,
    this.talkTasks = const [],
    this.talkDoneToday = false,
    this.startedAt,
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

  /// Hikâyede geçen, bitirilmemiş dilbilgisi konusu (H-078).
  final CoachGrammar? grammar;

  /// Seviye testinin önerdiği başlangıç seviyesi (`A1`…`C2`; yoksa null, A1
  /// gibi). B1 ve üstünde birincil öneri seviyesindeki kitaptır (H-088).
  final String? level;

  /// Son öğrenme etkinliği (bölüm, kitap, tekrar; UTC). Uzun aradan sonra
  /// plan kısa bir tekrarla başlar.
  final DateTime? lastActiveAt;

  /// Bugün "Başka bir öneri" ile geçilen önerilerin anahtarları
  /// ([HiSuggestion.key]).
  final Set<String> dismissed;

  /// Bugün kelime tekrarı yapıldı mı (en az bir cevap).
  final bool reviewedToday;

  /// Bugün bir bölüm bitti ya da kitap okundu mu.
  final bool mainDoneToday;

  /// Bugün küçük bir görev yapıldı mı (sahne avı, dilbilgisi dersi, Konuş).
  final bool taskDoneToday;

  /// Açılmış ve yapılmamış Konuş görevleri, sırayla (H-090).
  final List<CoachTalk> talkTasks;

  /// Bugün bir Konuş görevi bitti mi (ilk haftada günde en çok bir görev).
  final bool talkDoneToday;

  /// Kullanıcının başladığı an (açılış bitişi; UTC). İlk 7 gün buna göre
  /// sayılır (H-090); bilinmiyorsa ilk hafta akışı yok.
  final DateTime? startedAt;
}

/// Bugünkü tek öneri: [planToday]'ın birincil eylemi (Ana Sayfa ile aynı;
/// H-088).
HiSuggestion suggestToday(CoachInput i) => planToday(i).primary;

/// Kelime tekrarı önerisi. [afterBreak]: uzun aradan sonra (gerekçe sıcak bir
/// karşılamayla başlar). [stage]: borç varsa kısa tekrar, yoksa küçük görev.
HiSuggestion reviewSuggestion(
  int n,
  int goal, {
  bool afterBreak = false,
  PlanStage stage = PlanStage.warmUp,
}) {
  final minutes = HomeTexts.reviewMinutes(n);
  return HiSuggestion(
    kind: HiSuggestionKind.review,
    title: HiTexts.reviewTitle,
    reasonTr: afterBreak
        ? HiTexts.reviewAfterBreakReason(n, minutes, goal)
        : HiTexts.reviewReason(n, minutes, goal),
    actionLabel: HiTexts.reviewAction,
    actionRoute: '/tekrar',
    minutes: minutes,
    stage: stage,
  );
}

/// Son 7 günde tekrarlayan hata türü → Hi'nin notu ya da defter (kısa tekrar
/// adımı). Hatırlama ve "diğer" de sayılır; hepsi aynı pencerede
/// değerlendirilir. Yoksa null.
HiSuggestion? repeatedErrorSuggestion(CoachInput i) {
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
      stage: PlanStage.warmUp,
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
    stage: PlanStage.warmUp,
  );
}
