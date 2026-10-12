/// Yerel hikâye ilerlemesi modeli (H-035). Saf Dart.
///
/// Zamanlar UTC saklanır; kullanıcıya yerel saatle gösterilir.
library;

/// `user_story_progress.status` değerleri.
enum StoryStatus {
  notStarted('NOT_STARTED'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');

  const StoryStatus(this.code);

  final String code;

  static StoryStatus fromCode(String? code) => StoryStatus.values.firstWhere(
    (s) => s.code == code,
    orElse: () => StoryStatus.notStarted,
  );
}

/// Bölüm kapısının üç ölçütü (K-29).
enum GateItem {
  comprehension('comprehension', 'anlama'),
  targetPhrase('targetPhrase', 'hedef ifade'),
  activeTask('activeTask', 'görev');

  const GateItem(this.code, this.labelTr);

  /// `gate_progress.item_kind` değeri.
  final String code;

  /// Kilit nedeninde gösterilen ad.
  final String labelTr;

  static GateItem? fromCode(String code) {
    for (final g in GateItem.values) {
      if (g.code == code) return g;
    }
    return null;
  }
}

/// Bir bölümün yerel ilerlemesi.
class StoryProgress {
  const StoryProgress({
    required this.contentId,
    this.status = StoryStatus.notStarted,
    this.lastCheckpointNodeId,
    this.startedAt,
    this.completedAt,
    this.gateItems = const {},
  });

  final String contentId;
  final StoryStatus status;

  /// Kaldığı yer (yoksa `null`; bölüm bitince silinir).
  final String? lastCheckpointNodeId;
  final DateTime? startedAt;
  final DateTime? completedAt;

  /// Karşılanmış kapı ölçütleri (bütün oynanışların birleşimi).
  final Set<GateItem> gateItems;

  bool get hasCheckpoint => lastCheckpointNodeId != null;

  bool get gateComplete => gateItems.containsAll(GateItem.values);

  Set<GateItem> get missingGateItems =>
      GateItem.values.toSet().difference(gateItems);

  static StoryProgress empty(String contentId) =>
      StoryProgress(contentId: contentId);
}
