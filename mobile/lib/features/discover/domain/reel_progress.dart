// Bağımsız reel ilerlemesi (H-094 P2, plan §5): cihazda `discover.reel.<id>`.
//
// Saklanan bilinçli olarak azdır ve **öğrenme kanıtı değildir**: kaç saniye
// oynatıldığı, bitirilip bitirilmediği, en son hangi gün gösterildiği ve
// videonun sonundaki tek sorunun ürün sonucu. Bu kayıt Defter'e, FSRS'e ya da
// `own_use`/`recalled_later` kanıtına **yazılmaz** (plan §5; kanıt kuralları
// H-089'da).
//
// İçerik `contentVersion` artınca eski saniye/sonuç **yeni sürüme taşınmaz**;
// o reel yeniden "izlenmemiş" sayılır.

/// Videonun sonundaki tek sorunun ürün sonucu (kanıt değil).
enum PracticeResult {
  correct,
  wrong,
  skipped;

  static PracticeResult? parse(String? s) {
    for (final r in values) {
      if (r.name == s) return r;
    }
    return null;
  }
}

class ReelProgress {
  const ReelProgress({
    required this.contentVersion,
    this.watchedSeconds = 0,
    this.completed = false,
    this.lastShownDay = '',
    this.practiceResult,
  });

  /// İlerlemenin ait olduğu içerik sürümü.
  final int contentVersion;

  /// Aktif oynatma saniyesi (toplam).
  final int watchedSeconds;

  /// Video bitirildi mi (aktif oynatma + sona yaklaşma birlikte).
  final bool completed;

  /// En son gösterildiği yerel gün (`YYYY-AA-GG`); hiç gösterilmediyse boş.
  final String lastShownDay;

  final PracticeResult? practiceResult;

  /// İlerleme bu içerik sürümüne mi ait (sürüm arttıysa taşınmaz).
  bool isFor(int version) => contentVersion == version;

  /// Bu sürümde tamamlanmış mı (seçim önceliği bunu kullanır).
  bool isCompletedFor(int version) => isFor(version) && completed;

  ReelProgress copyWith({
    int? contentVersion,
    int? watchedSeconds,
    bool? completed,
    String? lastShownDay,
    PracticeResult? practiceResult,
  }) => ReelProgress(
    contentVersion: contentVersion ?? this.contentVersion,
    watchedSeconds: watchedSeconds ?? this.watchedSeconds,
    completed: completed ?? this.completed,
    lastShownDay: lastShownDay ?? this.lastShownDay,
    practiceResult: practiceResult ?? this.practiceResult,
  );

  Map<String, dynamic> toJson() => {
    'contentVersion': contentVersion,
    'watchedSeconds': watchedSeconds,
    'completed': completed,
    'lastShownDay': lastShownDay,
    if (practiceResult != null) 'practiceResult': practiceResult!.name,
  };

  static ReelProgress? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final j = raw.cast<String, dynamic>();
    final version = (j['contentVersion'] as num?)?.toInt();
    if (version == null) return null;
    return ReelProgress(
      contentVersion: version,
      watchedSeconds: (j['watchedSeconds'] as num?)?.toInt() ?? 0,
      completed: j['completed'] == true,
      lastShownDay: (j['lastShownDay'] as String?) ?? '',
      practiceResult: PracticeResult.parse(j['practiceResult'] as String?),
    );
  }

  @override
  String toString() =>
      'ReelProgress(v$contentVersion, ${watchedSeconds}s, '
      'completed: $completed, shown: $lastShownDay, '
      'practice: ${practiceResult?.name})';
}

/// Bir reelin ilerlemesini yeni bir gözlemle **birleştirir** (plan §5).
///
/// - İçerik sürümü değiştiyse eski saniye/sonuç taşınmaz (sıfırdan başlar).
/// - Saniye en büyüğüdür; `completed` yalnızca doğruya döner; gösterim günü
///   en yenisi; soru sonucu son gözlemdir.
ReelProgress mergeReelProgress(
  ReelProgress? current, {
  required int contentVersion,
  int addSeconds = 0,
  bool? completed,
  String? shownDay,
  PracticeResult? practiceResult,
}) {
  final base = (current != null && current.isFor(contentVersion))
      ? current
      : ReelProgress(contentVersion: contentVersion);
  final day = shownDay == null || shownDay.isEmpty
      ? base.lastShownDay
      : shownDay.compareTo(base.lastShownDay) > 0
      ? shownDay
      : base.lastShownDay;
  return ReelProgress(
    contentVersion: contentVersion,
    watchedSeconds: base.watchedSeconds + (addSeconds > 0 ? addSeconds : 0),
    completed: base.completed || completed == true,
    lastShownDay: day,
    practiceResult: practiceResult ?? base.practiceResult,
  );
}
