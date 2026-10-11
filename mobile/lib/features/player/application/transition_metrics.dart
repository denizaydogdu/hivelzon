/// Segment geçiş ölçümleri (H-031 kabul: geçiş ≤ 150 ms, siyah kare yok).
library;

enum TransitionKind {
  /// Segment bitti → sıradaki video kendiliğinden başladı (asıl ölçüt).
  auto,

  /// Karar dokunuşu → seçilen yanıt/tepki videosunun ilk karesi.
  choice,

  /// Kart, görev ya da tepki balonundan sonra video.
  ui,

  /// Bölüm ya da kaldığı yerden başlangıç.
  start,
}

class TransitionRecord {
  const TransitionRecord({
    required this.from,
    required this.to,
    required this.kind,
    required this.gapMs,
    required this.preloaded,
    this.prestarted = false,
  });

  final String? from;
  final String to;
  final TransitionKind kind;

  /// Önceki segmentin bitişi (ya da dokunuş) → yeni segmentte oynatma başının
  /// ilerlediğinin ilk görüldüğü an.
  final double gapMs;

  /// Denetleyici geçiş anında hazır mıydı (ön ısıtma tuttu mu)?
  final bool preloaded;

  /// Sıradaki video, önceki bitmeden altta başlatılmış mıydı?
  final bool prestarted;

  @override
  String toString() =>
      '${from ?? '-'}→$to ${kind.name} ${gapMs.toStringAsFixed(1)}ms'
      '${preloaded ? '' : ' (ön ısıtmasız)'}'
      '${prestarted ? ' (önden başlatıldı)' : ''}';
}

class GapStats {
  const GapStats(this.count, this.medianMs, this.maxMs);

  factory GapStats.of(Iterable<double> gaps) {
    final s = gaps.toList()..sort();
    if (s.isEmpty) return const GapStats(0, 0, 0);
    final mid = s.length ~/ 2;
    final median = s.length.isOdd ? s[mid] : (s[mid - 1] + s[mid]) / 2;
    return GapStats(s.length, median, s.last);
  }

  final int count;
  final double medianMs;
  final double maxMs;

  @override
  String toString() => count == 0
      ? 'n=0'
      : 'n=$count median=${medianMs.toStringAsFixed(1)}ms '
            'max=${maxMs.toStringAsFixed(1)}ms';
}
