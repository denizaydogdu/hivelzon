/// Gerçek öğrenme süresi ölçümü (H-074): saf hesap, saat dışarıdan verilir.
///
/// Kural: ölçüm yalnızca bir öğrenme ekranı açıkken ve uygulama ön plandayken
/// çalışır ([start] / [stop]). Ekrandaki her etkinlik (dokunma, oynayan video,
/// okunan cümle) bir [signal]dir. İki işaret arasındaki süre sayılır, ama en
/// çok [idleCap] kadar: telefon açık bırakılıp unutulduysa süre şişmez.
/// Uygulama arka plana geçince [stop] çağrılır; arka planda geçen süre hiç
/// sayılmaz (ön plana dönünce yeni [start]).
///
/// Süre yerel güne yazılır; gece yarısını aşan aralık iki güne bölünür.
library;

/// İki etkinlik arasında en çok bu kadar süre sayılır (tekrardaki cevap
/// sınırıyla aynı: `kMaxReviewAnswerTime`).
const Duration kStudyIdleCap = Duration(minutes: 2);

/// Yerel gün anahtarı (`2026-10-14`).
String localDayKey(DateTime t) {
  final l = t.toLocal();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${l.year.toString().padLeft(4, '0')}-${two(l.month)}-${two(l.day)}';
}

class ActiveTimeMeter {
  ActiveTimeMeter({this.idleCap = kStudyIdleCap});

  final Duration idleCap;

  /// Son işaret; `null` ise ölçüm durmuş.
  DateTime? _last;

  /// Henüz yazılmamış süre (yerel gün → ms).
  final Map<String, int> _pendingMs = {};

  bool get running => _last != null;

  /// Yazılmayı bekleyen toplam süre (ms).
  int get pendingMs => _pendingMs.values.fold(0, (a, b) => a + b);

  void start(DateTime now) => _last ??= now;

  void signal(DateTime now) {
    final last = _last;
    if (last == null) return;
    _add(last, now);
    _last = now;
  }

  void stop(DateTime now) {
    final last = _last;
    if (last == null) return;
    _add(last, now);
    _last = null;
  }

  void _add(DateTime from, DateTime to) {
    var d = to.difference(from);
    // Saat geri alındıysa (saat dilimi, elle ayar) aralık sayılmaz.
    if (d <= Duration.zero) return;
    if (d > idleCap) d = idleCap;
    // Sayılan aralık: [to − d, to]; yerel gün sınırında bölünür.
    final start = to.toLocal().subtract(d);
    var end = to.toLocal();
    while (end.isAfter(start)) {
      final probe = end.subtract(const Duration(microseconds: 1));
      final dayStart = DateTime(probe.year, probe.month, probe.day);
      final segStart = start.isAfter(dayStart) ? start : dayStart;
      final key = localDayKey(probe);
      _pendingMs[key] =
          (_pendingMs[key] ?? 0) + end.difference(segStart).inMilliseconds;
      end = segStart;
    }
  }

  /// Yazılacak tam saniyeler (gün → sn). Saniyenin altındaki artık bir sonraki
  /// yazmaya kalır; hiçbir süre kaybolmaz ya da iki kez yazılmaz.
  Map<String, int> takeSeconds() {
    final out = <String, int>{};
    for (final day in _pendingMs.keys.toList()) {
      final ms = _pendingMs[day]!;
      final s = ms ~/ Duration.millisecondsPerSecond;
      if (s > 0) out[day] = s;
      final rest = ms - s * Duration.millisecondsPerSecond;
      if (rest > 0) {
        _pendingMs[day] = rest;
      } else {
        _pendingMs.remove(day);
      }
    }
    return out;
  }

  /// Yazma başarısız oldu: süre geri konur (bir sonraki yazmada denenir).
  void restore(Map<String, int> seconds) {
    seconds.forEach((day, s) {
      _pendingMs[day] =
          (_pendingMs[day] ?? 0) + s * Duration.millisecondsPerSecond;
    });
  }
}
