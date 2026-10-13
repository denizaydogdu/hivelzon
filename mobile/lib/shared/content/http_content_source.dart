import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

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
