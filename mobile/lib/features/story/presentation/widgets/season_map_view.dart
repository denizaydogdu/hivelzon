import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../shared/content/content_providers.dart';
import '../../../../shared/perf/perf_log.dart';
import '../../../../shared/progress/story_progress.dart';
import '../../domain/season_map.dart';
import 'map_painters.dart';

/// Harita görseli yokken kullanılan en-boy oranı (yükseklik / genişlik).
const double kFallbackMapAspect = 1.6;

/// Bölüm noktasının görünen çapı; dokunma alanı en az 48 px.
const double kNodeSize = 40;
const double kNodeHitSize = 48;

/// Sezon haritası: arka plan (görsel ya da kodla çizim) + 12 bölüm noktası.
///
/// Harita genişliğe sığar; yüksekliği ekrandan büyükse dikey kaydırılır ve
/// ilk açılışta odaktaki bölüm (yarım kalan ya da sıradaki) görünür.
class SeasonMapView extends ConsumerStatefulWidget {
  const SeasonMapView({super.key, required this.map, required this.onNodeTap});

  final SeasonMap map;
  final ValueChanged<MapEpisode> onNodeTap;

  @override
  ConsumerState<SeasonMapView> createState() => _SeasonMapViewState();
}

class _SeasonMapViewState extends ConsumerState<SeasonMapView> {
  ScrollController? _scroll;
  bool _imageFailed = false;

  @override
  void dispose() {
    _scroll?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final map = widget.map;
    final info = map.info;
    final useImage = info?.mapImage != null && !_imageFailed;
    final aspect = useImage
        ? (info!.mapAspect ?? kFallbackMapAspect)
        : kFallbackMapAspect;
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = w * aspect;
        final canvas = SizedBox(
          key: const ValueKey('season-map'),
          width: w,
          height: h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: _background(useImage, w)),
              if (!useImage)
                Positioned.fill(
                  child: CustomPaint(
                    painter: MapPathPainter(
                      points: [for (final e in map.episodes) Offset(e.x, e.y)],
                      completedUpTo: _completedUpTo(map),
                    ),
                  ),
                ),
              for (final e in map.episodes)
                Positioned(
                  left: e.x * w - kNodeHitSize / 2,
                  top: e.y * h - kNodeHitSize / 2,
                  child: MapNode(
                    key: ValueKey('map-node-${e.number}'),
                    episode: e,
                    onTap: () => widget.onNodeTap(e),
                  ),
                ),
            ],
          ),
        );
        if (h <= c.maxHeight || !c.hasBoundedHeight) {
          return Align(alignment: Alignment.topCenter, child: canvas);
        }
        _scroll ??= ScrollController(
          initialScrollOffset: _initialOffset(map, h, c.maxHeight),
        );
        PerfLog.markAfterFrame('Hikâye haritası hazır');
        return PerfScope(
          tag: 'harita',
          child: SingleChildScrollView(
            key: const ValueKey('season-map-scroll'),
            controller: _scroll,
            child: canvas,
          ),
        );
      },
    );
  }

  static int _completedUpTo(SeasonMap map) {
    var last = -1;
    for (final (i, e) in map.episodes.indexed) {
      if (e.progress.status == StoryStatus.completed) last = i;
    }
    return last;
  }

  double _initialOffset(SeasonMap map, double mapH, double viewport) {
    final focus = map.focus ?? map.firstComingSoon;
    final y = (focus?.y ?? 1) * mapH;
    return (y - viewport * 0.6).clamp(0, mapH - viewport).toDouble();
  }

  Widget _background(bool useImage, double width) {
    final map = widget.map;
    final last = map.episodes.isEmpty
        ? const Offset(0.45, 0.05)
        : Offset(map.episodes.last.x, map.episodes.last.y);
    final fallback = CustomPaint(
      key: const ValueKey('season-map-fallback'),
      painter: MapFallbackPainter(lighthouse: last),
    );
    if (!useImage) return fallback;
    final source = ref.watch(contentSourceProvider);
    final uri = source.seasonMediaUri(map.season, map.info!.mapImage!);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return Image.network(
      uri.toString(),
      key: const ValueKey('season-map-image'),
      fit: BoxFit.fill,
      cacheWidth: (width * dpr).round(),
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, sync) =>
          frame == null && !sync ? fallback : child,
      errorBuilder: (context, error, stack) {
        // Görsel açılamazsa harita kodla çizilir (noktalar aynı yerde kalır).
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_imageFailed) setState(() => _imageFailed = true);
        });
        return fallback;
      },
    );
  }
}

/// Bir bölüm noktası. Durumlar: tamamlandı (onay), devam ediyor (halka),
/// sıradaki (parıltı; hareket azaltılmadıysa ≤ 1 Hz nabız), kilitli (kilit),
/// yakında (soluk).
class MapNode extends StatefulWidget {
  const MapNode({super.key, required this.episode, required this.onTap});

  final MapEpisode episode;
  final VoidCallback onTap;

  @override
  State<MapNode> createState() => _MapNodeState();
}

class _MapNodeState extends State<MapNode> with SingleTickerProviderStateMixin {
  /// Tam nabız döngüsü 2,4 sn (≈ 0,4 Hz).
  static const pulseHalfPeriod = Duration(milliseconds: 1200);

  AnimationController? _pulse;

  bool get _wantsPulse =>
      widget.episode.state == MapNodeState.next &&
      !MediaQuery.disableAnimationsOf(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(MapNode old) {
    super.didUpdateWidget(old);
    _syncPulse();
  }

  void _syncPulse() {
    if (_wantsPulse) {
      _pulse ??= AnimationController(vsync: this, duration: pulseHalfPeriod)
        ..repeat(reverse: true);
    } else {
      _pulse?.dispose();
      _pulse = null;
    }
  }

  @override
  void dispose() {
    _pulse?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.episode;
    final theme = Theme.of(context);
    final (fill, fg, border) = switch (e.state) {
      MapNodeState.completed => (AppColors.seaBlue, Colors.white, Colors.white),
      MapNodeState.inProgress => (
        AppColors.seaBlue,
        Colors.white,
        AppColors.lighthouseYellow,
      ),
      MapNodeState.next => (
        AppColors.lighthouseYellow,
        AppColors.ink,
        Colors.white,
      ),
      MapNodeState.playable => (
        Colors.white,
        AppColors.seaBlue,
        AppColors.seaBlue,
      ),
      MapNodeState.locked => (
        const Color(0xFF5B6470),
        Colors.white,
        Colors.white70,
      ),
      MapNodeState.comingSoon => (
        const Color(0xFF5B6470).withValues(alpha: 0.55),
        Colors.white70,
        Colors.white38,
      ),
    };
    final ring = e.state == MapNodeState.inProgress ? 4.0 : 2.0;
    Widget circle(double glow) => Container(
      width: kNodeSize,
      height: kNodeSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: ring),
        boxShadow: [
          if (e.state == MapNodeState.next)
            BoxShadow(
              color: AppColors.lighthouseYellow.withValues(
                alpha: 0.45 + 0.35 * glow,
              ),
              blurRadius: 10 + 10 * glow,
              spreadRadius: 2 + 4 * glow,
            )
          else
            const BoxShadow(
              color: Color(0x55000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Text(
        '${e.number}',
        style: theme.textTheme.titleMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    final badge = switch (e.state) {
      MapNodeState.completed => const _Badge(
        icon: Icons.check_rounded,
        color: Color(0xFF2E9E5B),
      ),
      MapNodeState.locked => const _Badge(
        icon: Icons.lock_rounded,
        color: Color(0xFF3A414A),
      ),
      MapNodeState.inProgress => const _Badge(
        icon: Icons.play_arrow_rounded,
        color: AppColors.eveningOrange,
      ),
      _ => null,
    };
    final pulse = _pulse;
    return Semantics(
      button: true,
      label: e.semanticsLabel,
      excludeSemantics: true,
      child: SizedBox(
        width: kNodeHitSize,
        height: kNodeHitSize,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onTap,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (pulse != null)
                  AnimatedBuilder(
                    animation: pulse,
                    builder: (_, _) => circle(pulse.value),
                  )
                else
                  circle(e.state == MapNodeState.next ? 0.6 : 0),
                if (badge != null)
                  Positioned(right: 0, bottom: 0, child: badge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: Icon(icon, size: 12, color: Colors.white),
  );
}
