import 'dart:convert';

import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/subtitles.dart';
import 'package:hivelzon/shared/content/content_source.dart';

import 'fixtures.dart';

/// Fixture JSON'larından okuyan kaynak; medya adresleri sahte.
class FakeContentSource implements ContentSource {
  FakeContentSource({this.fail = false, this.seasonFails = false});

  bool fail;

  /// Sezon paketi yoksa Hikâye sekmesi sezon başlığını gizler.
  bool seasonFails;
  int listCalls = 0;

  @override
  Future<List<PackageSummary>> listPackages() async {
    listCalls++;
    if (fail) throw ContentUnavailableException('kapalı');
    return [
      for (final id in ['A1-001', 'A1-002'])
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
  Future<SubtitleTrack> loadSubtitles(String contentId, String path) async =>
      SubtitleTrack.fromJson(jsonDecode(fixtureText('A1-001.s02.en.json')));

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
    );
  }

  @override
  Uri seasonMediaUri(int season, String path) =>
      Uri.parse('http://test.invalid/_season/S$season/$path');
}
