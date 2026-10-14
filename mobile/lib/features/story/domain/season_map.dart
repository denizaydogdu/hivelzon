// Sezon haritası modeli (H-035). Saf Dart: katalog + paket listesi + yerel
// ilerleme → 12 düğümün durumu.

import '../../../shared/content/content_source.dart';
import '../../../shared/progress/story_progress.dart';
import 'unlock_rule.dart';

enum MapNodeState {
  completed('tamamlandı'),
  inProgress('devam ediyor'),
  next('sıradaki'),
  playable('oynanabilir'),
  locked('kilitli'),
  comingSoon('yakında');

  const MapNodeState(this.labelTr);

  final String labelTr;
}

/// Katalogda konum yoksa kullanılan yol (S1 harita görseliyle aynı noktalar).
const List<(double, double)> kDefaultMapPositions = [
  (0.42, 0.772),
  (0.24, 0.762),
  (0.47, 0.539),
  (0.60, 0.455),
  (0.51, 0.400),
  (0.44, 0.338),
  (0.555, 0.298),
  (0.67, 0.255),
  (0.61, 0.215),
  (0.565, 0.124),
  (0.466, 0.102),
  (0.445, 0.040),
];

class MapEpisode {
  const MapEpisode({
    required this.number,
    required this.contentId,
    required this.title,
    required this.teaser,
    required this.x,
    required this.y,
    required this.progress,
    required this.access,
    required this.state,
  });

  final int number;
  final String contentId;
  final String title;
  final String? teaser;
  final double x;
  final double y;
  final StoryProgress progress;
  final EpisodeAccess access;
  final MapNodeState state;

  bool get playable => access.isPlayable;

  /// "Bölüm 3, Find the Station, tamamlandı"
  String get semanticsLabel => 'Bölüm $number, $title, ${state.labelTr}';
}

class SeasonMap {
  const SeasonMap({
    required this.season,
    required this.title,
    required this.episodes,
    this.info,
  });

  final int season;
  final String title;
  final SeasonInfo? info;
  final List<MapEpisode> episodes;

  int get total => episodes.length;

  int get completedCount =>
      episodes.where((e) => e.progress.status == StoryStatus.completed).length;

  /// Tek öğrenme eylemi: yarım kalan bölüm, yoksa sıradaki bölüm.
  MapEpisode? get focus {
    for (final e in episodes) {
      if (e.state == MapNodeState.inProgress) return e;
    }
    for (final e in episodes) {
      if (e.state == MapNodeState.next) return e;
    }
    return null;
  }

  /// Açılmış (oynanabilir) bölümlerin kimlikleri (H-060, "görüldü" işareti).
  List<String> get unlockedIds => [
    for (final e in episodes)
      if (e.playable) e.contentId,
  ];

  /// Önceki bölüm bitince açılan en yeni bölüm (bitmemiş; Bölüm 1 hariç,
  /// o baştan açıktır). Haritada ilk kez görününce ışığı yanar (H-060).
  MapEpisode? get newestUnlocked {
    MapEpisode? out;
    for (final (i, e) in episodes.indexed) {
      if (i == 0 || !e.playable) continue;
      if (e.state == MapNodeState.completed) continue;
      out = e;
    }
    return out;
  }

  /// Oynanacak bölüm kalmadıysa: ilk "yakında" bölüm.
  MapEpisode? get firstComingSoon {
    for (final e in episodes) {
      if (e.state == MapNodeState.comingSoon) return e;
    }
    return null;
  }
}

SeasonMap buildSeasonMap({
  required int season,
  SeasonInfo? info,
  required List<PackageSummary> packages,
  required Map<String, StoryProgress> progress,
}) {
  final built = {
    for (final p in packages)
      if (p.season == null || p.season == season) p.id,
  };
  final slots = <SeasonEpisode>[
    if (info != null && info.episodes.isNotEmpty)
      ...info.episodes
    else
      // Katalog yoksa: yalnızca sunucudaki paketler (konumlar varsayılan yoldan).
      for (final (i, p) in ([
        ...packages.where((p) => p.season == null || p.season == season),
      ]..sort((a, b) => (a.number ?? 0).compareTo(b.number ?? 0))).indexed)
        SeasonEpisode(
          number: p.number ?? i + 1,
          contentId: p.id,
          title: p.title,
          available: true,
        ),
  ];
  final byNumber = {for (final s in slots) s.number: s};
  final result = <MapEpisode>[];
  var nextAssigned = false;
  for (final (i, s) in slots.indexed) {
    final own = progress[s.contentId] ?? StoryProgress.empty(s.contentId);
    final prevSlot = byNumber[s.number - 1];
    final prev = prevSlot == null ? null : progress[prevSlot.contentId];
    final available = s.available && built.contains(s.contentId);
    final access = episodeAccess(
      number: s.number,
      available: available,
      own: own,
      previous: prev,
    );
    final MapNodeState state;
    if (access.kind == EpisodeAvailability.comingSoon) {
      state = MapNodeState.comingSoon;
    } else if (access.kind == EpisodeAvailability.locked) {
      state = MapNodeState.locked;
    } else if (own.status == StoryStatus.completed) {
      state = MapNodeState.completed;
    } else if (own.status == StoryStatus.inProgress) {
      state = MapNodeState.inProgress;
    } else if (!nextAssigned) {
      state = MapNodeState.next;
      nextAssigned = true;
    } else {
      state = MapNodeState.playable;
    }
    final fallback = kDefaultMapPositions[i % kDefaultMapPositions.length];
    result.add(
      MapEpisode(
        number: s.number,
        contentId: s.contentId,
        title: s.title,
        teaser: s.teaserTr,
        x: s.mapX ?? fallback.$1,
        y: s.mapY ?? fallback.$2,
        progress: own,
        access: access,
        state: state,
      ),
    );
  }
  return SeasonMap(
    season: season,
    title: info?.title ?? 'Sezon $season',
    info: info,
    episodes: result,
  );
}
