import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/discover/domain/clip.dart';
import '../../features/discover/domain/reel.dart';
import '../../features/grammar/domain/grammar_lesson.dart';
import '../../features/hi/domain/hi_content.dart';
import '../../features/library/domain/book.dart';
import '../../features/player/domain/episode.dart';
import '../../features/player/domain/subtitles.dart';
import '../../features/talk/domain/talk_task.dart';
import '../../features/topic_sets/domain/topic_set.dart';
import 'content_source.dart';

/// `--dart-define=CONTENT_BASE_URL=...` (varsayılan: yerel geliştirme sunucusu).
const String kContentBaseUrl = String.fromEnvironment(
  'CONTENT_BASE_URL',
  defaultValue: 'http://127.0.0.1:8787',
);

/// Yayınlanmış reel kataloğu (H-094 P4): yetkili durum backend'dedir.
///
/// `--dart-define=REEL_CATALOG_URL=...` ile değiştirilir; boş dize verilirse
/// eski dosya kataloğu (`/reels/index.json`) okunur (yalnız yerel/deneme).
const String kReelCatalogUrl = String.fromEnvironment(
  'REEL_CATALOG_URL',
  defaultValue: 'http://127.0.0.1:8080/api/v1/catalog/reels',
);

/// HTTP üzerinden paket okuyan kaynak: `<base>/packages/<contentId>/<yol>`.
class HttpContentSource implements ContentSource {
  HttpContentSource({
    http.Client? client,
    String baseUrl = kContentBaseUrl,
    String? reelCatalogUrl = kReelCatalogUrl,
    this.timeout = const Duration(seconds: 8),
  }) : _client = client ?? http.Client(),
       _base = Uri.parse(baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'),
       _reelCatalog = (reelCatalogUrl == null || reelCatalogUrl.isEmpty)
           ? null
           : Uri.parse(reelCatalogUrl);

  final http.Client _client;
  final Uri _base;
  final Duration timeout;
  final Uri? _reelCatalog;
  final Map<String, Future<SubtitleTrack>> _subsCache = {};

  /// Backend'in verdiği paket kökleri (`packageBaseUrl`); `_reels/<id>/`
  /// yerine gerçek yayın adresini kullanır (CDN dahil).
  final Map<String, Uri> _reelPackageBases = {};

  Uri _packagesUri(List<String> segments) =>
      _base.resolveUri(Uri(pathSegments: ['packages', ...segments]));

  @override
  Uri mediaUri(String contentId, String path) =>
      _packagesUri([contentId, ...path.split('/')]);

  Future<Object?> _getJson(Uri uri) async {
    final http.Response res;
    try {
      res = await _client.get(uri).timeout(timeout);
    } on TimeoutException catch (e) {
      throw ContentUnavailableException('Sunucu yanıt vermedi', cause: e);
    } on Exception catch (e) {
      throw ContentUnavailableException('Sunucuya bağlanılamadı', cause: e);
    }
    if (res.statusCode != 200) {
      throw ContentUnavailableException(
        'Sunucu ${res.statusCode} döndü',
        cause: uri,
      );
    }
    try {
      return jsonDecode(utf8.decode(res.bodyBytes));
    } on FormatException catch (e) {
      throw ContentUnavailableException('Bozuk JSON', cause: e);
    }
  }

  @override
  Future<List<PackageSummary>> listPackages() async {
    final json = await _getJson(_packagesUri(['index.json']));
    final list = (json is Map ? json['packages'] : null) as List? ?? const [];
    return [for (final p in list) PackageSummary.fromJson((p as Map).cast())];
  }

  @override
  Future<Episode> loadEpisode(String contentId) async {
    final json = await _getJson(_packagesUri([contentId, 'scenes.json']));
    return Episode.fromJson(json);
  }

  @override
  Uri seasonMediaUri(int season, String path) =>
      _packagesUri(['_season', 'S$season', ...path.split('/')]);

  @override
  Future<SeasonInfo> loadSeason(int season) async {
    final json = await _getJson(seasonMediaUri(season, 'season.json'));
    if (json is! Map) throw ContentUnavailableException('Bozuk season.json');
    return SeasonInfo.fromJson(json.cast<String, dynamic>());
  }

  @override
  Future<TopicSet> loadTopicSet(int season, String path) async {
    final json = await _getJson(seasonMediaUri(season, path));
    if (json is! Map) throw ContentUnavailableException('Bozuk konu seti');
    try {
      return TopicSet.fromJson(json.cast<String, dynamic>());
    } on Object catch (e) {
      throw ContentUnavailableException('Bozuk konu seti', cause: e);
    }
  }

  @override
  Future<HiContent> loadHiContent(int season) async {
    final json = await _getJson(seasonMediaUri(season, 'hi.json'));
    if (json is! Map) throw ContentUnavailableException('Bozuk hi.json');
    try {
      return HiContent.fromJson(json.cast<String, dynamic>());
    } on Object catch (e) {
      throw ContentUnavailableException('Bozuk hi.json', cause: e);
    }
  }

  @override
  Future<ClipCatalog> loadClips(int season, String path) async {
    final json = await _getJson(seasonMediaUri(season, path));
    if (json is! Map) throw ContentUnavailableException('Bozuk clips.json');
    try {
      return ClipCatalog.fromJson(json.cast<String, dynamic>());
    } on Object catch (e) {
      throw ContentUnavailableException('Bozuk clips.json', cause: e);
    }
  }

  @override
  Future<TalkCatalog> loadTalk(int season, String path) async {
    final json = await _getJson(seasonMediaUri(season, path));
    if (json is! Map) throw ContentUnavailableException('Bozuk talk.json');
    try {
      return TalkCatalog.fromJson(json.cast<String, dynamic>());
    } on Object catch (e) {
      throw ContentUnavailableException('Bozuk talk.json', cause: e);
    }
  }

  Uri _booksUri(List<String> segments) =>
      _base.resolveUri(Uri(pathSegments: ['books', ...segments]));

  @override
  Uri bookMediaUri(String bookId, String path) =>
      _booksUri([bookId, ...path.split('/')]);

  @override
  Future<List<BookSummary>> listBooks() async {
    final json = await _getJson(_booksUri(['index.json']));
    final list = (json is Map ? json['books'] : null) as List? ?? const [];
    try {
      return [for (final b in list) BookSummary.fromJson((b as Map).cast())];
    } on Object catch (e) {
      throw ContentUnavailableException('Bozuk kitap listesi', cause: e);
    }
  }

  @override
  Future<Book> loadBook(String bookId) async {
    final results = await Future.wait([
      _getJson(bookMediaUri(bookId, 'book.json')),
      _getJson(bookMediaUri(bookId, 'pages.json')),
    ]);
    final (book, pages) = (results[0], results[1]);
    if (book is! Map || pages is! Map) {
      throw ContentUnavailableException('Bozuk kitap paketi');
    }
    try {
      return Book.fromJson(book.cast(), pages.cast());
    } on Object catch (e) {
      throw ContentUnavailableException('Bozuk kitap paketi', cause: e);
    }
  }

  Uri _grammarUri(List<String> segments) =>
      _base.resolveUri(Uri(pathSegments: ['grammar', ...segments]));

  @override
  Uri grammarMediaUri(String lessonId, String path) =>
      _grammarUri([lessonId, ...path.split('/')]);

  Uri _reelsUri(List<String> segments) =>
      _base.resolveUri(Uri(pathSegments: ['reels', ...segments]));

  @override
  Uri reelMediaUri(String reelId, String path) {
    final packageBase = _reelPackageBases[reelId];
    if (packageBase != null) {
      return packageBase.resolveUri(Uri(pathSegments: path.split('/')));
    }
    return _reelsUri([reelId, ...path.split('/')]);
  }

  /// Katalog: backend varsa **yayımlanmış** reeller; yoksa dosya kataloğu.
  ///
  /// Backend yanıtı sayfalanır (`size=100`); her kaydın `packageBaseUrl`
  /// değeri saklanır. Yetkili kaynak yanıt vermezse sessizce dosya kataloğuna
  /// düşülmez: hata gösterilir (geri çekilen içerik açığa çıkmasın).
  @override
  Future<ReelCatalog> listReels() async {
    final catalog = _reelCatalog;
    if (catalog == null) {
      final json = await _getJson(_reelsUri(['index.json']));
      if (json is! Map) throw ContentUnavailableException('Bozuk reel listesi');
      try {
        return ReelCatalog.fromJson(json.cast<String, dynamic>());
      } on Object catch (e) {
        throw ContentUnavailableException('Bozuk reel listesi', cause: e);
      }
    }

    final reels = <ReelSummary>[];
    for (var page = 0; page < 100; page++) {
      final json = await _getJson(
        catalog.replace(
          queryParameters: {
            ...catalog.queryParameters,
            'page': '$page',
            'size': '100',
          },
        ),
      );
      if (json is! Map) {
        throw ContentUnavailableException('Bozuk reel listesi');
      }
      final items = json['items'];
      if (items is! List) {
        throw ContentUnavailableException('Bozuk reel listesi');
      }
      try {
        for (final item in items) {
          reels.add(_reelSummaryFromBackend((item as Map).cast()));
        }
      } on Object catch (e) {
        throw ContentUnavailableException('Bozuk reel listesi', cause: e);
      }
      final total = (json['totalItems'] as num?)?.toInt() ?? reels.length;
      if (items.isEmpty || reels.length >= total) break;
    }
    return ReelCatalog(reels: reels);
  }

  ReelSummary _reelSummaryFromBackend(Map<String, dynamic> j) {
    final id = j['contentId'] as String;
    final category = (j['category'] as String?) ?? '';
    final packageBase = j['packageBaseUrl'] as String?;
    if (packageBase != null && packageBase.isNotEmpty) {
      _reelPackageBases[id] = Uri.parse(packageBase);
    }
    return ReelSummary(
      id: id,
      contentVersion: (j['contentVersion'] as num?)?.toInt() ?? 1,
      // Reel kataloğu her zaman bağımsız konu reelleridir.
      sourceType: (j['sourceType'] as String?) ?? 'standalone',
      category: category,
      categoryTr: kReelCategoryTr[category] ?? category,
      level: (j['level'] as String?) ?? '',
      titleTr: (j['titleTr'] as String?) ?? (j['title'] as String?) ?? id,
      duration: (j['duration'] as num?)?.toDouble() ?? 0,
      family: j['family'] as String?,
      // Açık uç yalnız yayımlanmış sürümü döndürür.
      status: 'PUBLISHED',
    );
  }

  @override
  Future<Reel> loadReel(String reelId) async {
    Uri uri;
    final packageBase = _reelPackageBases[reelId];
    if (packageBase != null) {
      uri = packageBase.resolve('reel.json');
    } else if (_reelCatalog != null) {
      // Katalog henüz yüklenmediyse bir kez yükle; yayında olmayan kimlik
      // (geri çekilmiş) oynatılmaz.
      await listReels();
      final base = _reelPackageBases[reelId];
      if (base == null) {
        throw ContentUnavailableException('Reel yayında değil', cause: reelId);
      }
      uri = base.resolve('reel.json');
    } else {
      uri = reelMediaUri(reelId, 'reel.json');
    }
    final json = await _getJson(uri);
    if (json is! Map) throw ContentUnavailableException('Bozuk reel paketi');
    try {
      return Reel.fromJson(json.cast<String, dynamic>());
    } on Object catch (e) {
      throw ContentUnavailableException('Bozuk reel paketi', cause: e);
    }
  }

  @override
  Future<List<GrammarLessonSummary>> loadGrammarIndex() async {
    final json = await _getJson(_grammarUri(['index.json']));
    final list = (json is Map ? json['lessons'] : null) as List? ?? const [];
    try {
      return [
        for (final l in list) GrammarLessonSummary.fromJson((l as Map).cast()),
      ];
    } on Object catch (e) {
      throw ContentUnavailableException('Bozuk ders listesi', cause: e);
    }
  }

  @override
  Future<GrammarLesson> loadLesson(String lessonId) async {
    final results = await Future.wait([
      _getJson(grammarMediaUri(lessonId, 'lesson.json')),
      _getJson(grammarMediaUri(lessonId, 'cards.json')),
    ]);
    final (lesson, cards) = (results[0], results[1]);
    if (lesson is! Map || cards is! Map) {
      throw ContentUnavailableException('Bozuk ders paketi');
    }
    try {
      return GrammarLesson.fromJson(lesson.cast(), cards.cast());
    } on Object catch (e) {
      throw ContentUnavailableException('Bozuk ders paketi', cause: e);
    }
  }

  @override
  Future<SubtitleTrack> loadSubtitles(String contentId, String path) {
    final key = '$contentId/$path';
    return _subsCache.putIfAbsent(key, () async {
      try {
        return SubtitleTrack.fromJson(
          await _getJson(mediaUri(contentId, path)),
        );
      } catch (_) {
        unawaited(Future(() => _subsCache.remove(key)));
        rethrow;
      }
    });
  }
}
