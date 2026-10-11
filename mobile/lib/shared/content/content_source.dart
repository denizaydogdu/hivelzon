import '../../features/player/domain/episode.dart';
import '../../features/player/domain/subtitles.dart';

/// Sunucudaki bir bölüm paketinin özeti (`/packages/index.json`).
class PackageSummary {
  const PackageSummary({
    required this.id,
    required this.title,
    this.level,
    this.season,
    this.number,
    this.estimatedMinutes,
  });

  factory PackageSummary.fromJson(Map<String, dynamic> j) => PackageSummary(
    id: j['id'] as String,
    title: (j['title'] as String?) ?? j['id'] as String,
    level: j['level'] as String?,
    season: (j['season'] as num?)?.toInt(),
    number: (j['number'] as num?)?.toInt(),
    estimatedMinutes: (j['estimatedMinutes'] as num?)?.toDouble(),
  );

  final String id;
  final String title;
  final String? level;
  final int? season;
  final int? number;
  final double? estimatedMinutes;
}

/// İçeriğe erişilemedi (sunucu kapalı, ağ yok, dosya bozuk).
class ContentUnavailableException implements Exception {
  ContentUnavailableException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'ContentUnavailableException: $message ($cause)';
}

/// Bölüm paketlerinin kaynağı. Bugün yerel geliştirme sunucusu
/// (`tools/dev-content-server`), ileride `VideoHostingPort` / CDN (K-13).
abstract interface class ContentSource {
  Future<List<PackageSummary>> listPackages();

  Future<Episode> loadEpisode(String contentId);

  Future<SubtitleTrack> loadSubtitles(String contentId, String path);

  /// Paket içindeki bir dosyanın (video, ses, görsel) oynatılabilir adresi.
  Uri mediaUri(String contentId, String path);
}
