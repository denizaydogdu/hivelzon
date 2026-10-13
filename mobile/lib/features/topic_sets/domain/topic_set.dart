// Konu setleri ve sahne avı (H-051). Saf Dart.
//
// Paket: `/packages/_season/S<n>/sets/<id>.json` (tools/content-pipeline/hvpipeline/sets.py).
// Koordinatlar sahne görseline göre normalleştirilmiştir (0–1, sol üst 0,0).

import 'dart:math' as math;

import '../../../shared/fsrs/fsrs.dart';
import '../../../shared/progress/story_progress.dart';
import '../../notebook/domain/notebook_item.dart';
import '../../story/domain/unlock_rule.dart' show accusativeNumber;

/// Sezon paketindeki bir dosyanın defter yolu: `_season/S1/sets/x/y.webp`.
/// Defter kartı bu önekle sezon paketinden okunur (`resolveMediaUri`).
String seasonMediaPath(int season, String path) => '_season/S$season/$path';

/// `_season/S1/sets/x.webp` → (1, `sets/x.webp`); sezon yolu değilse null.
(int, String)? parseSeasonMediaPath(String path) {
  final m = RegExp(r'^_season/S(\d+)/(.+)$').firstMatch(path);
  return m == null ? null : (int.parse(m.group(1)!), m.group(2)!);
}

/// Dokunma bölgesi: dikdörtgen ya da çokgen (normalleştirilmiş).
sealed class HotspotShape {
  const HotspotShape();

  factory HotspotShape.fromJson(Map<String, dynamic> j) {
    final r = j['rect'];
    if (r is List && r.length == 4) {
      final v = [for (final e in r) (e as num).toDouble()];
      return RectShape(v[0], v[1], v[2], v[3]);
    }
    final p = j['polygon'];
    if (p is List && p.length >= 3) {
      return PolygonShape([
        for (final e in p)
          (((e as List)[0] as num).toDouble(), (e[1] as num).toDouble()),
      ]);
    }
    throw const FormatException('dokunma bölgesi rect ya da polygon olmalı');
  }

  /// Köşeler (dikdörtgende 4 köşe).
  List<(double, double)> get points;

  /// Normalleştirilmiş noktada mı (kenar dahil).
  bool contains(double x, double y);

  /// En küçük çevreleyen kutu: (sol, üst, sağ, alt).
  (double, double, double, double) get bounds {
    final xs = points.map((p) => p.$1);
    final ys = points.map((p) => p.$2);
    return (
      xs.reduce(math.min),
      ys.reduce(math.min),
      xs.reduce(math.max),
      ys.reduce(math.max),
    );
  }

  /// Piksel uzayında noktanın şekle uzaklığı (içerideyse 0). [sx], [sy]:
  /// görüntülenen görselin genişliği ve yüksekliği.
  double distancePx(double px, double py, double sx, double sy) {
    if (contains(px / sx, py / sy)) return 0;
    final pts = [for (final p in points) (p.$1 * sx, p.$2 * sy)];
    var best = double.infinity;
    for (var i = 0; i < pts.length; i++) {
      final a = pts[i];
      final b = pts[(i + 1) % pts.length];
      best = math.min(best, _segmentDistance(px, py, a, b));
    }
    return best;
  }
}

class RectShape extends HotspotShape {
  const RectShape(this.x, this.y, this.w, this.h);

  final double x, y, w, h;

  @override
  List<(double, double)> get points => [
    (x, y),
    (x + w, y),
    (x + w, y + h),
    (x, y + h),
  ];

  @override
  bool contains(double px, double py) =>
      px >= x && px <= x + w && py >= y && py <= y + h;
}

class PolygonShape extends HotspotShape {
  const PolygonShape(this.points);

  @override
  final List<(double, double)> points;

  /// Çift-tek kuralı (içbükey çokgende de doğru); kenar sayılır.
  @override
  bool contains(double px, double py) {
    var inside = false;
    for (var i = 0, j = points.length - 1; i < points.length; j = i++) {
      final (xi, yi) = points[i];
      final (xj, yj) = points[j];
      if (_onSegment(px, py, points[i], points[j])) return true;
      if ((yi > py) != (yj > py) &&
          px < (xj - xi) * (py - yi) / (yj - yi) + xi) {
        inside = !inside;
      }
    }
    return inside;
  }
}

double _segmentDistance(
  double px,
  double py,
  (double, double) a,
  (double, double) b,
) {
  final (ax, ay) = a;
  final (bx, by) = b;
  final dx = bx - ax;
  final dy = by - ay;
  final len2 = dx * dx + dy * dy;
  var t = len2 == 0 ? 0.0 : ((px - ax) * dx + (py - ay) * dy) / len2;
  t = t.clamp(0.0, 1.0);
  final cx = ax + t * dx;
  final cy = ay + t * dy;
  return math.sqrt((px - cx) * (px - cx) + (py - cy) * (py - cy));
}

bool _onSegment(double px, double py, (double, double) a, (double, double) b) =>
    _segmentDistance(px, py, a, b) < 1e-9;

/// Bir kayıttan kesilmiş ses: dosya ve kaynak kayıttaki aralığı (sn).
class SetAudio {
  const SetAudio({
    required this.path,
    required this.source,
    required this.start,
    this.end,
  });

  static SetAudio? fromJson(Object? path, Object? src) {
    if (path is! String || src is! Map) return null;
    return SetAudio(
      path: path,
      source: src['source'] as String? ?? '',
      start: (src['start'] as num?)?.toDouble() ?? 0,
      end: (src['end'] as num?)?.toDouble(),
    );
  }

  /// `sets/` altındaki yol (`alex-room/radio.m4a`).
  final String path;
  final String source;
  final double start;
  final double? end;

  double? get length => end == null ? null : end! - start;
}

/// Setin bir öğesi: kelime, anlamı, örnek cümle, görseli, dokunma bölgeleri.
class TopicSetItem {
  const TopicSetItem({
    required this.id,
    required this.w,
    required this.tr,
    required this.findEn,
    required this.findTr,
    required this.exampleEn,
    required this.exampleTr,
    required this.image,
    required this.hotspots,
    this.multiWord = false,
    this.aboveLevel = false,
    this.audio,
    this.exampleAudio,
  });

  factory TopicSetItem.fromJson(Map<String, dynamic> j) {
    final w = j['w'] as String;
    return TopicSetItem(
      id: j['id'] as String,
      w: w,
      tr: j['tr'] as String,
      findEn: (j['findEn'] as String?) ?? 'Find the $w!',
      findTr: j['findTr'] as String,
      exampleEn: j['exampleEn'] as String,
      exampleTr: j['exampleTr'] as String,
      image: j['image'] as String,
      multiWord: j['kind'] == 'phrase' || w.trim().contains(' '),
      aboveLevel: j['aboveLevel'] == true,
      hotspots: [
        for (final h in (j['hotspots'] as List? ?? const []))
          HotspotShape.fromJson((h as Map).cast<String, dynamic>()),
      ],
      audio: SetAudio.fromJson(j['audio'], j['audioSource']),
      exampleAudio: SetAudio.fromJson(
        j['exampleAudio'],
        j['exampleAudioSource'],
      ),
    );
  }

  final String id;

  /// İngilizce kelime ya da kısa ifade (`radio`, `bus stop`).
  final String w;
  final String tr;
  final String findEn;
  final String findTr;
  final String exampleEn;
  final String exampleTr;

  /// Öğe görseli (`alex-room/radio.webp`, `sets/` altında).
  final String image;
  final List<HotspotShape> hotspots;
  final bool multiWord;
  final bool aboveLevel;
  final SetAudio? audio;
  final SetAudio? exampleAudio;

  NotebookKind get kind => multiWord ? NotebookKind.phrase : NotebookKind.word;

  String get notebookKey => itemKey(kind, w);

  /// Görüntülenen görselde ([width] × [height] px) piksel noktası bu öğeye
  /// isabet ediyor mu. [tolerance]: küçük nesneler için kenardan pay (px);
  /// parmak ucu ≥ 48 px dokunma alanı ilkesini karşılar.
  bool hitAt(
    double px,
    double py, {
    required double width,
    required double height,
    double tolerance = 0,
  }) => hotspots.any((s) => s.distancePx(px, py, width, height) <= tolerance);

  /// Öğenin bütün bölgelerini çevreleyen kutu (ipucu ve vurgu için).
  (double, double, double, double) get bounds {
    final b = [for (final s in hotspots) s.bounds];
    return (
      b.map((e) => e.$1).reduce(math.min),
      b.map((e) => e.$2).reduce(math.min),
      b.map((e) => e.$3).reduce(math.max),
      b.map((e) => e.$4).reduce(math.max),
    );
  }
}

/// season.json → `topicSets[]` özeti.
class TopicSetSummary {
  const TopicSetSummary({
    required this.id,
    required this.order,
    required this.titleTr,
    required this.unlockAfter,
    required this.itemCount,
    required this.cover,
    required this.path,
    this.unlockEpisode,
  });

  factory TopicSetSummary.fromJson(Map<String, dynamic> j) => TopicSetSummary(
    id: j['id'] as String,
    order: (j['order'] as num?)?.toInt() ?? 0,
    titleTr: j['titleTr'] as String,
    unlockAfter: j['unlockAfter'] as String,
    unlockEpisode: (j['unlockEpisode'] as num?)?.toInt(),
    itemCount: (j['itemCount'] as num?)?.toInt() ?? 0,
    cover: j['cover'] as String,
    path: j['path'] as String,
  );

  final String id;
  final int order;
  final String titleTr;

  /// Bitince seti açan bölüm (`A1-001`).
  final String unlockAfter;
  final int? unlockEpisode;
  final int itemCount;

  /// Kapak (sahne) görseli, `sets/` altında (`alex-room/scene.webp`).
  final String cover;

  /// Set verisi, sezon paketinde (`sets/alex-room.json`).
  final String path;
}

/// Bir konu setinin tamamı.
class TopicSet {
  const TopicSet({
    required this.id,
    required this.season,
    required this.titleTr,
    required this.unlockAfter,
    required this.sceneImage,
    required this.sceneWidth,
    required this.sceneHeight,
    required this.items,
    this.unlockEpisode,
    this.level = 'A1',
    this.status = 'DRAFT',
  });

  factory TopicSet.fromJson(Map<String, dynamic> j) {
    final scene = (j['scene'] as Map).cast<String, dynamic>();
    return TopicSet(
      id: j['id'] as String,
      season: (j['season'] as num?)?.toInt() ?? 1,
      level: (j['level'] as String?) ?? 'A1',
      status: (j['status'] as String?) ?? 'DRAFT',
      titleTr: j['titleTr'] as String,
      unlockAfter: j['unlockAfter'] as String,
      unlockEpisode: (j['unlockEpisode'] as num?)?.toInt(),
      sceneImage: scene['image'] as String,
      sceneWidth: (scene['width'] as num).toInt(),
      sceneHeight: (scene['height'] as num).toInt(),
      items: [
        for (final i in (j['items'] as List? ?? const []))
          TopicSetItem.fromJson((i as Map).cast<String, dynamic>()),
      ],
    );
  }

  final String id;
  final int season;
  final String level;
  final String status;
  final String titleTr;
  final String unlockAfter;
  final int? unlockEpisode;
  final String sceneImage;
  final int sceneWidth;
  final int sceneHeight;
  final List<TopicSetItem> items;

  double get sceneAspect => sceneWidth / sceneHeight;

  /// Sezon paketindeki yol (`sets/` öneki eklenir).
  String setsPath(String path) => 'sets/$path';

  /// Defter kartı: görsel kırpılmış öğe görseli, ses karakterin kendi sesi.
  ///
  /// Kelime ve örnek cümle aynı kayıttan geliyorsa tek dosya (örnek cümlenin
  /// sesi) kullanılır, kelime onun içindeki aralıktır; defter tablosu tek ses
  /// yolu tutar. Örnek cümlenin sesi yoksa kelime dosyası tam çalınır ve
  /// "Cümleyi dinle" düğmesi görünmez.
  NotebookItem toNotebookItem(TopicSetItem it, {DateTime? createdAt}) {
    MediaClip? audio;
    MediaClip? example;
    final a = it.audio;
    final e = it.exampleAudio;
    if (a != null && e != null && a.source == e.source) {
      final path = seasonMediaPath(season, setsPath(e.path));
      audio = MediaClip(path, start: a.start - e.start, end: _end(a, e.start));
      example = MediaClip(path, start: 0, end: _end(e, e.start));
    } else if (a != null) {
      audio = MediaClip(
        seasonMediaPath(season, setsPath(a.path)),
        start: 0,
        end: a.length ?? 1,
      );
    } else if (e != null) {
      example = MediaClip(
        seasonMediaPath(season, setsPath(e.path)),
        start: 0,
        end: e.length ?? 3,
      );
      audio = null;
    }
    return NotebookItem(
      kind: it.kind,
      textEn: it.w,
      textTr: it.tr,
      exampleEn: it.exampleEn,
      exampleTr: it.exampleTr,
      contentId: unlockAfter,
      cueId: 'set:$id/${it.id}',
      imagePath: seasonMediaPath(season, setsPath(it.image)),
      imageCrop: '0,0,1,1',
      audio: audio,
      exampleAudio: audio == null ? null : example,
      source: NotebookSource.topicSet,
      createdAt: createdAt,
    );
  }

  static double _end(SetAudio a, double origin) =>
      (a.end ?? (a.start + 1)) - origin;
}

/// Kilit durumu ile set (Defter → Konu setleri listesi).
class TopicSetView {
  const TopicSetView(this.summary, {required this.unlocked, this.lockReason});

  final TopicSetSummary summary;
  final bool unlocked;

  /// Sakin kilit nedeni: "Bölüm 1'i bitirince açılır."
  final String? lockReason;
}

/// Set, kendi bölümü (`unlockAfter`) bitince açılır (zaman kilidi yok, K-32).
List<TopicSetView> resolveTopicSets(
  List<TopicSetSummary> sets,
  Map<String, StoryProgress> progress,
) {
  final sorted = [...sets]..sort((a, b) => a.order.compareTo(b.order));
  return [
    for (final s in sorted)
      isTopicSetUnlocked(s.unlockAfter, progress)
          ? TopicSetView(s, unlocked: true)
          : TopicSetView(
              s,
              unlocked: false,
              lockReason: topicSetLockReason(s.unlockEpisode),
            ),
  ];
}

bool isTopicSetUnlocked(
  String unlockAfter,
  Map<String, StoryProgress> progress,
) => progress[unlockAfter]?.status == StoryStatus.completed;

String topicSetLockReason(int? episode) => episode == null
    ? 'İlgili bölümü bitirince açılır.'
    : 'Bölüm ${accusativeNumber(episode)} bitirince açılır.';

// ------------------------------------------------------------------ sahne avı

/// Bir öğenin sahne avı sonucu.
class HuntResult {
  const HuntResult({
    required this.item,
    required this.misses,
    required this.revealed,
    this.elapsed = Duration.zero,
  });

  final TopicSetItem item;

  /// Öğe gösterildikten bulunana dek geçen süre (gösterilmez, yalnızca kayıt).
  final Duration elapsed;

  /// Doğru yere dokunmadan önceki dokunuş sayısı.
  final int misses;

  /// "Bilmiyorum" ile gösterildi.
  final bool revealed;

  /// Kendisi buldu (en çok 1 kaçırmayla).
  bool get foundAlone => !revealed && misses < HuntSession.hintAfterMisses;

  /// FSRS notu: kendisi bulduysa Good; "Bilmiyorum" ya da 2+ kaçırma Again.
  FsrsRating get rating => foundAlone ? FsrsRating.good : FsrsRating.again;
}

enum HuntTap { correct, miss, ignored }

/// Sahne avı oturumu: sırayla her öğe; süre ve puan yok (K-32).
class HuntSession {
  HuntSession(
    this.set, {
    List<TopicSetItem>? order,
    math.Random? random,
    DateTime Function()? clock,
  }) : _order = order ?? ([...set.items]..shuffle(random ?? math.Random())),
       _clock = clock ?? DateTime.now {
    _shownAt = _clock();
  }

  /// Bu kadar kaçırmadan sonra bölge nazikçe parlar (ipucu).
  static const hintAfterMisses = 2;

  final TopicSet set;
  final List<TopicSetItem> _order;
  final DateTime Function() _clock;
  late DateTime _shownAt;
  final List<HuntResult> _results = [];
  int _index = 0;
  int _misses = 0;
  bool _resolved = false;
  bool _revealed = false;

  List<TopicSetItem> get order => List.unmodifiable(_order);
  int get total => _order.length;

  /// 1 tabanlı sıra.
  int get position => math.min(_index + 1, total);
  bool get finished => _index >= _order.length;
  TopicSetItem? get current => finished ? null : _order[_index];
  int get misses => _misses;

  /// Bu öğe bulundu ya da gösterildi; "Devam et" bekleniyor.
  bool get resolved => _resolved;
  bool get revealed => _revealed;
  bool get showHint => !_resolved && _misses >= hintAfterMisses;
  List<HuntResult> get results => List.unmodifiable(_results);

  /// Dokunuşu değerlendirir (görüntülenen görselin piksel uzayında).
  HuntTap tap(
    double px,
    double py, {
    required double width,
    required double height,
    double tolerance = 0,
  }) {
    final it = current;
    if (it == null || _resolved) return HuntTap.ignored;
    if (it.hitAt(px, py, width: width, height: height, tolerance: tolerance)) {
      _resolve(revealed: false);
      return HuntTap.correct;
    }
    _misses++;
    return HuntTap.miss;
  }

  /// Ekran okuyucu seçeneği: [choice] doğru öğe mi.
  HuntTap choose(TopicSetItem choice) {
    final it = current;
    if (it == null || _resolved) return HuntTap.ignored;
    if (choice.id == it.id) {
      _resolve(revealed: false);
      return HuntTap.correct;
    }
    _misses++;
    return HuntTap.miss;
  }

  /// "Bilmiyorum": yeri gösterilir.
  void reveal() {
    if (current == null || _resolved) return;
    _resolve(revealed: true);
  }

  void _resolve({required bool revealed}) {
    _resolved = true;
    _revealed = revealed;
    _results.add(
      HuntResult(
        item: current!,
        misses: _misses,
        revealed: revealed,
        elapsed: _clock().difference(_shownAt),
      ),
    );
  }

  /// Sıradaki öğe.
  void next() {
    if (!_resolved) return;
    _index++;
    _misses = 0;
    _resolved = false;
    _revealed = false;
    _shownAt = _clock();
  }

  /// Ekran okuyucu için seçenekler: doğru öğe + en çok 3 başka öğe (sıra karışık).
  List<TopicSetItem> choices({math.Random? random}) {
    final it = current;
    if (it == null) return const [];
    final others = [
      for (final o in set.items)
        if (o.id != it.id) o,
    ]..shuffle(random ?? math.Random(it.id.hashCode));
    return [it, ...others.take(3)]..shuffle(random ?? math.Random(_index));
  }

  int get foundAlone => _results.where((r) => r.foundAlone).length;
  int get helped => _results.length - foundAlone;
}
