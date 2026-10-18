import '../../features/discover/domain/clip.dart';
import '../../features/discover/domain/reel.dart';
import '../../features/grammar/domain/grammar_lesson.dart';
import '../../features/hi/domain/hi_content.dart';
import '../../features/library/domain/book.dart';
import '../../features/player/domain/episode.dart';
import '../../features/player/domain/subtitles.dart';
import '../../features/player/domain/video_rendition.dart';
import '../../features/talk/domain/talk_task.dart';
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
    this.grammarTopics = const [],
  });

  factory PackageSummary.fromJson(Map<String, dynamic> j) => PackageSummary(
    id: j['id'] as String,
    title: (j['title'] as String?) ?? j['id'] as String,
    level: j['level'] as String?,
    season: (j['season'] as num?)?.toInt(),
    number: (j['number'] as num?)?.toInt(),
    estimatedMinutes: (j['estimatedMinutes'] as num?)?.toDouble(),
    grammarTopics: grammarTopicsOf(j['grammarTopics']),
  );

  final String id;
  final String title;
  final String? level;
  final int? season;
  final int? number;
  final double? estimatedMinutes;

  /// Bölümde geçen dilbilgisi konuları (G-ID; H-077 `grammarTopics`).
  final List<String> grammarTopics;
}

/// `grammarTopics` alanı (bölüm, kitap): G-ID listesi; yoksa boş.
List<String> grammarTopicsOf(Object? v) => [
  if (v is List)
    for (final x in v)
      if (x is String && x.isNotEmpty) x,
];

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
    this.clipsPath,
    this.talkPath,
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
      clipsPath: j['clips'] is Map
          ? (j['clips'] as Map)['path'] as String?
          : null,
      talkPath: j['talk'] is Map ? (j['talk'] as Map)['path'] as String? : null,
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

  /// Keşfet klipleri (H-040): `clips.json` yolu; sezonda klip yoksa null.
  final String? clipsPath;

  /// Konuş görevleri (H-090): `talk.json` yolu; yoksa null.
  final String? talkPath;

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

  /// Keşfet klipleri (H-040): sezon paketindeki `clips.json` ([path]).
  Future<ClipCatalog> loadClips(int season, String path);

  /// Bağımsız konu reelleri (H-094): `/reels/index.json` kataloğu.
  Future<ReelCatalog> listReels();

  /// Reel paketi: `/reels/<reelId>/reel.json`. Bilinmeyen `schemaVersion`
  /// sessizce boş göstermez; açık hata verir (plan §6.4).
  Future<Reel> loadReel(String reelId);

  /// Reel paketindeki bir dosyanın adresi (`/reels/<reel>/<yol>`).
  Uri reelMediaUri(String reelId, String path);

  /// Konuş görevleri (H-090): sezon paketindeki `talk.json` ([path]).
  Future<TalkCatalog> loadTalk(int season, String path);

  /// Kitaplık (H-067): `/books/index.json`.
  Future<List<BookSummary>> listBooks();

  /// Kitap paketi: `book.json` + `pages.json`.
  Future<Book> loadBook(String bookId);

  /// Kitap paketindeki bir dosyanın adresi (`/books/<kitap>/<yol>`).
  Uri bookMediaUri(String bookId, String path);

  /// Dilbilgisi dersleri (H-078): `/grammar/index.json`.
  Future<List<GrammarLessonSummary>> loadGrammarIndex();

  /// Ders paketi: `lesson.json` + `cards.json`.
  Future<GrammarLesson> loadLesson(String lessonId);

  /// Ders paketindeki bir dosyanın adresi (`/grammar/<ders>/<yol>`).
  Uri grammarMediaUri(String lessonId, String path);
}

/// Defter kartında ders paketindeki dosya yolu (H-078):
/// `_grammar/<ders>/<yol>`.
String grammarMediaPath(String lessonId, String path) =>
    '_grammar/$lessonId/$path';

(String, String)? parseGrammarMediaPath(String path) {
  final m = RegExp(r'^_grammar/([^/]+)/(.+)$').firstMatch(path);
  return m == null ? null : (m.group(1)!, m.group(2)!);
}

/// Defter kartında kitap paketindeki dosya yolu (H-067): `_books/<kitap>/<yol>`.
String bookMediaPath(String bookId, String path) => '_books/$bookId/$path';

(String, String)? parseBookMediaPath(String path) {
  final m = RegExp(r'^_books/([^/]+)/(.+)$').firstMatch(path);
  return m == null ? null : (m.group(1)!, m.group(2)!);
}

/// Defter kartında reel paketindeki dosya yolu (H-094): `_reels/<reel>/<yol>`.
String reelMediaPath(String reelId, String path) => '_reels/$reelId/$path';

(String, String)? parseReelMediaPath(String path) {
  final m = RegExp(r'^_reels/([^/]+)/(.+)$').firstMatch(path);
  return m == null ? null : (m.group(1)!, m.group(2)!);
}

/// Defter kartındaki görsel ya da ses yolu: bölüm paketinde (`stills/x.webp`)
/// ya da sezon paketinde (`_season/S1/sets/…`, konu setleri, H-051) ya da
/// kitap paketinde (`_books/A1-K01/audio/c1.m4a`, H-067) ya da ders
/// paketinde (`_grammar/G-A1-03-…/audio/c07-ex1.m4a`, H-078) ya da reel
/// paketinde (`_reels/A1-R-CIN-01/stills/s02.webp`, H-094).
Uri resolveMediaUri(ContentSource source, String contentId, String path) {
  final reel = parseReelMediaPath(path);
  if (reel != null) return source.reelMediaUri(reel.$1, reel.$2);
  final book = parseBookMediaPath(path);
  if (book != null) return source.bookMediaUri(book.$1, book.$2);
  final grammar = parseGrammarMediaPath(path);
  if (grammar != null) return source.grammarMediaUri(grammar.$1, grammar.$2);
  final season = parseSeasonMediaPath(path);
  return season == null
      ? source.mediaUri(contentId, path)
      : source.seasonMediaUri(season.$1, season.$2);
}
