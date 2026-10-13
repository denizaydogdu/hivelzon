import '../../features/hi/domain/hi_content.dart';
import '../../features/player/domain/episode.dart';
import '../../features/player/domain/subtitles.dart';
import '../../features/player/domain/video_rendition.dart';
import '../../features/topic_sets/domain/topic_set.dart';

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

/// Sezon haritasındaki bir bölüm yeri (`season.json` → `episodes[]`, H-035).
class SeasonEpisode {
  const SeasonEpisode({
    required this.number,
    required this.contentId,
    required this.title,
    this.teaserTr,
    this.teaserStatus,
    this.available = false,
    this.mapX,
    this.mapY,
  });

  factory SeasonEpisode.fromJson(Map<String, dynamic> j) {
    final pos = j['mapPos'];
    double? at(int i) =>
        pos is List && pos.length == 2 ? (pos[i] as num?)?.toDouble() : null;
    return SeasonEpisode(
      number: (j['number'] as num).toInt(),
      contentId: j['contentId'] as String,
      title: (j['title'] as String?) ?? j['contentId'] as String,
      teaserTr: j['teaserTr'] as String?,
      teaserStatus: j['teaserStatus'] as String?,
      available: j['available'] == true,
      mapX: at(0),
      mapY: at(1),
    );
  }

  final int number;
  final String contentId;
  final String title;

  /// Spoiler'sız tek cümle (taslak: `teaserStatus == DRAFT`).
  final String? teaserTr;
  final String? teaserStatus;

  /// Paket üretilmiş mi (dışa aktarma anındaki durum).
  final bool available;

  /// Harita üzerindeki konum (0–1, sol üst `0,0`).
  final double? mapX;
  final double? mapY;
}

/// Sezon paketi (`/packages/_season/S<n>/season.json`, H-050).
class SeasonInfo {
  const SeasonInfo({
    required this.season,
    required this.title,
    this.introVideo,
    this.introDuration,
    this.titleBackground,
    this.titlePoster,
    this.aiLabel = 'Yapay zekâ ile üretilmiştir',
    this.episodes = const [],
    this.mapImage,
    this.mapWidth,
    this.mapHeight,
    this.topicSets = const [],
  });

  /// [rendition]: jenerik videolarının oynatılacak sürümü (H-054).
  factory SeasonInfo.fromJson(
    Map<String, dynamic> j, {
    String rendition = kPreferredRendition,
  }) {
    String? video(Object? e) => e is Map && e['video'] is String
        ? pickRendition(e['video'] as String, e['renditions'], rendition)
        : null;
    final map = j['map'] is Map
        ? (j['map'] as Map).cast<String, dynamic>()
        : null;
    return SeasonInfo(
      season: (j['season'] as num).toInt(),
      title: (j['title'] as String?) ?? 'Sezon ${j['season']}',
      introVideo: video(j['intro']),
      introDuration: j['intro'] is Map
          ? ((j['intro'] as Map)['duration'] as num?)?.toDouble()
          : null,
      titleBackground: video(j['titleBackground']),
      titlePoster: j['titleBackground'] is Map
          ? (j['titleBackground'] as Map)['poster'] as String?
          : null,
      aiLabel: (j['aiLabel'] as String?) ?? 'Yapay zekâ ile üretilmiştir',
      episodes: [
        for (final e in (j['episodes'] as List? ?? const []))
          SeasonEpisode.fromJson((e as Map).cast<String, dynamic>()),
      ]..sort((a, b) => a.number.compareTo(b.number)),
      mapImage: map?['image'] as String?,
      mapWidth: (map?['width'] as num?)?.toInt(),
      mapHeight: (map?['height'] as num?)?.toInt(),
      topicSets: [
        for (final t in (j['topicSets'] as List? ?? const []))
          TopicSetSummary.fromJson((t as Map).cast<String, dynamic>()),
      ]..sort((a, b) => a.order.compareTo(b.order)),
    );
  }

  final int season;
  final String title;

  /// Tam jenerik (~10 sn): sezonun ilk açılışında bir kez oynar.
  final String? introVideo;
  final double? introDuration;

  /// Bölüm başlık ekranının yazısız arka planı.
  final String? titleBackground;

  /// Başlık arka planının ilk karesi (webp; H-054 öncesi jpg); Ana Sayfa
  /// kartında da kullanılır.
  final String? titlePoster;
  final String aiLabel;

  /// Sezonun bütün bölüm yerleri (harita kataloğu; yoksa boş).
  final List<SeasonEpisode> episodes;

  /// Harita görseli (`map.webp`; H-054 öncesi jpg) ve piksel boyutu; yoksa
  /// harita kodla çizilir.
  final String? mapImage;
  final int? mapWidth;
  final int? mapHeight;

  /// Konu setleri (H-051; yoksa boş): `sets/<id>.json` özetleri.
  final List<TopicSetSummary> topicSets;

  /// Harita yüksekliği / genişliği.
  double? get mapAspect =>
      (mapWidth != null && mapHeight != null && mapWidth! > 0)
      ? mapHeight! / mapWidth!
      : null;
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

  /// Sezon paketi bilgisi (jenerik ve başlık arka planı, H-050).
  Future<SeasonInfo> loadSeason(int season);

  /// Sezon paketindeki bir dosyanın adresi (`/packages/_season/S<n>/<yol>`).
  Uri seasonMediaUri(int season, String path);

  /// Konu seti verisi (H-051): sezon paketindeki `sets/<id>.json`.
  Future<TopicSet> loadTopicSet(int season, String path);

  /// Hi-A verisi (H-048): sezon paketindeki `hi.json` (hata kataloğu, konu
  /// tanıtımları, köprü görevleri, "Bu ne demek?" dizini).
  Future<HiContent> loadHiContent(int season);
}

/// Defter kartındaki görsel ya da ses yolu: bölüm paketinde (`stills/x.webp`)
/// ya da sezon paketinde (`_season/S1/sets/…`, konu setleri, H-051).
Uri resolveMediaUri(ContentSource source, String contentId, String path) {
  final season = parseSeasonMediaPath(path);
  return season == null
      ? source.mediaUri(contentId, path)
      : source.seasonMediaUri(season.$1, season.$2);
}
