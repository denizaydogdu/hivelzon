import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/discover/domain/clip.dart';
import '../../features/grammar/domain/grammar_lesson.dart';
import '../../features/hi/domain/hi_content.dart';
import '../../features/library/domain/book.dart';
import '../../features/player/domain/episode.dart';
import '../../features/player/domain/subtitles.dart';
import '../../features/topic_sets/domain/topic_set.dart';
import 'content_source.dart';

/// `--dart-define=CONTENT_BASE_URL=...` (varsayılan: yerel geliştirme sunucusu).
const String kContentBaseUrl = String.fromEnvironment(
  'CONTENT_BASE_URL',
  defaultValue: 'http://127.0.0.1:8787',
);

/// HTTP üzerinden paket okuyan kaynak: `<base>/packages/<contentId>/<yol>`.
class HttpContentSource implements ContentSource {
  HttpContentSource({
    http.Client? client,
    String baseUrl = kContentBaseUrl,
    this.timeout = const Duration(seconds: 8),
  }) : _client = client ?? http.Client(),
       _base = Uri.parse(baseUrl.endsWith('/') ? baseUrl : '$baseUrl/');

  final http.Client _client;
  final Uri _base;
  final Duration timeout;
  final Map<String, Future<SubtitleTrack>> _subsCache = {};

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
