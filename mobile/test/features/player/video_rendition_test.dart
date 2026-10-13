import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/video_rendition.dart';
import 'package:hivelzon/shared/content/content_source.dart';

import '../../support/fixtures.dart';

Map<String, dynamic> _b1() =>
    jsonDecode(fixtureText('A1-001.scenes.json')) as Map<String, dynamic>;

/// H-054 öncesi paket: `renditions` alanları yok.
Map<String, dynamic> _legacy() {
  final j = _b1();
  for (final n in (j['nodes'] as List).cast<Map<String, dynamic>>()) {
    n.remove('renditions');
    n.remove('seasonRenditions');
  }
  return j;
}

void main() {
  test('varsayılan sürüm 720p (yayında her zaman)', () {
    expect(kPreferredRendition, kRendition720);
  });

  test('pickRendition: tercih edilen sürüm, yoksa video alanı', () {
    const r = {'720p': 'segments/a.720p.mp4', '1080p': 'segments/a.mp4'};
    expect(pickRendition('segments/a.mp4', r), 'segments/a.720p.mp4');
    expect(pickRendition('segments/a.mp4', r, '1080p'), 'segments/a.mp4');
    expect(pickRendition('segments/a.mp4', null), 'segments/a.mp4');
    expect(pickRendition('segments/a.mp4', {'1080p': 'x'}), 'segments/a.mp4');
    expect(pickRendition('segments/a.mp4', {'720p': ''}), 'segments/a.mp4');
  });

  test('B1: bütün video düğümleri 720p oynar; başlık arka planı da', () {
    final ep = Episode.fromJson(_b1());
    final videos = [
      for (final n in ep.nodes.values)
        if (n is VideoBearing && (n as VideoBearing).video != null)
          (n as VideoBearing).video!,
    ];
    expect(videos, isNotEmpty);
    for (final v in videos) {
      expect(v, endsWith('.720p.mp4'), reason: v);
    }
    expect(ep.titleNode!.video, 'season:jenerik-baslik.720p.mp4');
    expect(ep.titleNode!.posterPath, 'season:jenerik-baslik.webp');
    expect((ep.node('s02') as SegmentNode).video, 'segments/s02.720p.mp4');
  });

  test('1080p seçilebilir (debug bayrağı yolu)', () {
    final ep = Episode.fromJson(_b1(), rendition: kRendition1080);
    expect((ep.node('s02') as SegmentNode).video, 'segments/s02.mp4');
    expect(ep.titleNode!.video, 'season:jenerik-baslik.mp4');
  });

  test('eski paket (renditions yok): video alanı oynar', () {
    final ep = Episode.fromJson(_legacy());
    expect((ep.node('s02') as SegmentNode).video, 'segments/s02.mp4');
    expect(ep.titleNode!.video, 'season:jenerik-baslik.mp4');
  });

  test('sezon jeneriği: 720p, eski season.json için video alanı', () {
    final info = SeasonInfo.fromJson({
      'season': 1,
      'intro': {
        'video': 'jenerik-tam.mp4',
        'renditions': {
          '720p': 'jenerik-tam.720p.mp4',
          '1080p': 'jenerik-tam.mp4',
        },
      },
      'titleBackground': {
        'video': 'jenerik-baslik.mp4',
        'poster': 'jenerik-baslik.webp',
      },
      'map': {'image': 'map.webp', 'width': 1520, 'height': 2688},
    });
    expect(info.introVideo, 'jenerik-tam.720p.mp4');
    expect(info.titleBackground, 'jenerik-baslik.mp4');
    expect(info.titlePoster, 'jenerik-baslik.webp');
    expect(info.mapImage, 'map.webp');
  });

  test('defterdeki eski jpg kart görseli WebP adına çevrilir', () {
    expect(currentStillPath('stills/T2-pov.jpg'), 'stills/T2-pov.webp');
    expect(currentStillPath('stills/T2-pov.webp'), 'stills/T2-pov.webp');
    expect(currentStillPath('other/x.jpg'), 'other/x.jpg');
  });
}
