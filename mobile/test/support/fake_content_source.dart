import 'dart:convert';

import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/subtitles.dart';
import 'package:hivelzon/shared/content/content_source.dart';

import 'fixtures.dart';

/// Fixture JSON'larından okuyan kaynak; medya adresleri sahte.
class FakeContentSource implements ContentSource {
  FakeContentSource({
    this.fail = false,
    this.seasonFails = false,
    this.packageIds = const ['A1-001', 'A1-002'],
    this.withCatalogue = true,
    this.mapImage,
    this.realSubtitles = false,
  });

  /// `true`: altyazı `test/fixtures/subs/<id>/<dosya>`'dan okunur (yoksa hata);
  /// `false`: her segment için B1 s02 altyazısı (oynatıcı testleri).
  bool realSubtitles;

  bool fail;

  /// Sunucuda paketi olan bölümler (fixture'lar: A1-001…A1-004).
  List<String> packageIds;

  /// Sezon paketinde 12 bölümlük harita kataloğu olsun mu (H-035).
  bool withCatalogue;
  String? mapImage;

  /// Sezon paketi yoksa Hikâye sekmesi sezon başlığını gizler.
  bool seasonFails;
  int listCalls = 0;

  @override
  Future<List<PackageSummary>> listPackages() async {
    listCalls++;
    if (fail) throw ContentUnavailableException('kapalı');
    return [
      for (final id in packageIds)
        PackageSummary(
          id: id,
          title: loadFixture(id).info.title,
          level: 'A1',
          season: 1,
          number: int.parse(id.substring(3)),
          estimatedMinutes: 6,
        ),
    ];
  }

  @override
  Future<Episode> loadEpisode(String contentId) async {
    if (fail) throw ContentUnavailableException('kapalı');
    return loadFixture(contentId);
  }

  @override
  Future<SubtitleTrack> loadSubtitles(String contentId, String path) async {
    if (realSubtitles) {
      final name = path.split('/').last;
      return SubtitleTrack.fromJson(
        jsonDecode(fixtureText('subs/$contentId/$name')),
      );
    }
    return SubtitleTrack.fromJson(
      jsonDecode(fixtureText('A1-001.s02.en.json')),
    );
  }

  @override
  Uri mediaUri(String contentId, String path) =>
      Uri.parse('http://test.invalid/$contentId/$path');

  @override
  Future<SeasonInfo> loadSeason(int season) async {
    if (fail || seasonFails) throw ContentUnavailableException('kapalı');
    return SeasonInfo(
      season: season,
      title: 'The Missing Signal',
      introVideo: 'jenerik-tam.mp4',
      introDuration: 10.3,
      titleBackground: 'jenerik-baslik.mp4',
      titlePoster: 'jenerik-baslik.jpg',
      mapImage: mapImage,
      mapWidth: mapImage == null ? null : 1520,
      mapHeight: mapImage == null ? null : 2688,
      episodes: withCatalogue ? catalogue(packageIds) : const [],
    );
  }

  @override
  Uri seasonMediaUri(int season, String path) =>
      Uri.parse('http://test.invalid/_season/S$season/$path');
}

/// Sezon 1 kataloğu: 12 bölüm (başlıklar kanondan), paketi olanlar `available`.
List<SeasonEpisode> catalogue(List<String> built) => [
  for (final (i, t) in const [
    'A Strange Message',
    'The New Neighbour',
    'Find the Station',
    'The Note',
    'Too Late?',
    'The Recording',
    'Who Knows What?',
    'The First Reveal',
    'The Café on the Hill',
    'Spare Parts',
    'Storm Warning',
    'The Lighthouse',
  ].indexed)
    SeasonEpisode(
      number: i + 1,
      contentId: 'A1-${(i + 1).toString().padLeft(3, '0')}',
      title: t,
      teaserTr: 'İpucu ${i + 1}.',
      teaserStatus: 'DRAFT',
      available: built.contains('A1-${(i + 1).toString().padLeft(3, '0')}'),
      mapX: 0.3 + 0.03 * i,
      mapY: 0.9 - 0.07 * i,
    ),
];
