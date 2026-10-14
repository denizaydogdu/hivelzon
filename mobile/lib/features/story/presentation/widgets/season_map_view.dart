import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/design/tokens.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/content/content_providers.dart';
import '../../../../shared/perf/perf_log.dart';
import '../../../../shared/progress/story_progress.dart';
import '../../data/unlock_seen_repository.dart';
import '../../domain/season_map.dart';
import 'map_painters.dart';

/// Harita görseli yokken kullanılan en-boy oranı (yükseklik / genişlik).
const double kFallbackMapAspect = 1.6;

/// Bölüm noktasının görünen çapı; dokunma alanı en az 48 px.
const double kNodeSize = 40;
const double kNodeHitSize = AppTouch.min;

/// Yeni açılan bölümün "ışık yanar, yol çizilir" animasyonu (H-060): sakin,
/// tek seferlik, döngü yok (K-32).
abstract final class UnlockMotion {
  static const Duration total = Duration(milliseconds: 1600);

  /// Yolun çizildiği aralık (0–1).
  static const Interval trail = Interval(0, 0.55, curve: AppMotion.standard);

  /// Düğümün ışığının yandığı aralık.
  static const Interval light = Interval(0.45, 0.85, curve: AppMotion.enter);

  /// İzin söndüğü aralık (harita görselindeki yolla çakışmasın).
  static const Interval fade = Interval(0.8, 1, curve: AppMotion.exit);
}

/// Sezon haritası: arka plan (görsel ya da kodla çizim) + 12 bölüm noktası.
///
/// Harita genişliğe sığar; yüksekliği ekrandan büyükse dikey kaydırılır ve
/// ilk açılışta odaktaki bölüm (yarım kalan ya da sıradaki) görünür.
///
/// Yeni açılan bölüm haritada ilk kez görününce (bu cihazda, `app_meta`
/// işareti) önceki bölümden ona bir ışık izi çizilir ve düğümün ışığı yanar.
/// "Hareketi azalt" açıksa animasyon yoktur; işaret yine yazılır.
class SeasonMapView extends ConsumerStatefulWidget {
  const SeasonMapView({super.key, required this.map, required this.onNodeTap});

  final SeasonMap map;
  final ValueChanged<MapEpisode> onNodeTap;

  @override
  ConsumerState<SeasonMapView> createState() => _SeasonMapViewState();
}

class _SeasonMapViewState extends ConsumerState<SeasonMapView>
    with SingleTickerProviderStateMixin {
  ScrollController? _scroll;
  bool _imageFailed = false;

  /// Animasyonu oynayan bölümün numarası (yoksa null).
  int? _unlocking;
  AnimationController? _unlock;

  /// Son "görüldü" denetiminin yapıldığı açık bölüm listesi (aynı harita
  /// için ikinci kez sorulmaz).
  String? _claimedFor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeClaimUnlock();
  }

  @override
  void didUpdateWidget(SeasonMapView old) {
    super.didUpdateWidget(old);
    if (old.map != widget.map) _maybeClaimUnlock();
  }

  @override
  void dispose() {
    _scroll?.dispose();
    _unlock?.dispose();
    super.dispose();
  }

  /// Harita görünürken (sekme ya da üstteki sayfa onu örtmüyorken) açık
  /// bölümleri "görüldü" işaretler; yeni açılan bölüm ilk kez görülüyorsa
  /// animasyonu başlatır.
  void _maybeClaimUnlock() {
    // Görünmeyen sekmede ya da örtülü sayfada animasyon sessizce biterdi.
    if (!TickerMode.of(context)) return;
    final map = widget.map;
    final ids = map.unlockedIds;
    if (ids.isEmpty) return;
    final key = ids.join(',');
    if (_claimedFor == key) return;
    _claimedFor = key;
    final candidate = map.newestUnlocked;
    final reduced = AppMotion.reduced(context);
    final repo = ref.read(unlockSeenRepositoryProvider);
    unawaited(() async {
      Set<String> fresh;
      try {
        fresh = await repo.claimUnseen(ids);
      } on Object catch (e) {
        // İşaret okunamazsa animasyon yok (tekrar tekrar oynamasın).
        debugPrint('[H060] açılış işareti okunamadı: $e');
        return;
      }
      if (!mounted || candidate == null) return;
      if (!fresh.contains(candidate.contentId)) return;
      _announce(candidate.number);
      if (reduced) return;
      _startUnlock(candidate.number);
    }());
  }

  void _announce(int number) {
    final view = View.maybeOf(context);
    if (view == null) return;
    unawaited(
      SemanticsService.sendAnnouncement(
        view,
        StoryTexts.unlockedAnnouncement(number),
        Directionality.of(context),
      ),
    );
  }

  void _startUnlock(int number) {
    final c = _unlock ??= AnimationController(
      vsync: this,
      duration: UnlockMotion.total,
    )..addStatusListener(_onUnlockStatus);
    setState(() => _unlocking = number);
    unawaited(c.forward(from: 0));
  }

  void _onUnlockStatus(AnimationStatus s) {
    if (s == AnimationStatus.completed && mounted) {
      setState(() => _unlocking = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final map = widget.map;
    final info = map.info;
    final useImage = info?.mapImage != null && !_imageFailed;
    final aspect = useImage
        ? (info!.mapAspect ?? kFallbackMapAspect)
        : kFallbackMapAspect;
    final points = [for (final e in map.episodes) Offset(e.x, e.y)];
    final unlockIndex = _unlocking == null
        ? -1
        : map.episodes.indexWhere((e) => e.number == _unlocking);
    final unlock = _unlock;
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
                      points: points,
                      completedUpTo: _completedUpTo(map),
                    ),
                  ),
                ),
              if (unlock != null && unlockIndex > 0)
                Positioned.fill(
                  key: const ValueKey('map-unlock-trail'),
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: unlock,
                      builder: (_, _) => CustomPaint(
                        painter: UnlockTrailPainter(
                          points: points,
                          toIndex: unlockIndex,
                          progress: UnlockMotion.trail.transform(unlock.value),
                          opacity:
                              1 - UnlockMotion.fade.transform(unlock.value),
                        ),
                      ),
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
                    lightUp: e.number == _unlocking ? unlock : null,
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

/// Düğüm renkleri (H-060: yalnız belirteçlerden).
({Color fill, Color fg, Color border}) mapNodeColors(MapNodeState s) =>
    switch (s) {
      MapNodeState.completed => (
        fill: AppPalette.seaBlue,
        fg: AppPalette.white,
        border: AppPalette.white,
      ),
      MapNodeState.inProgress => (
        fill: AppPalette.seaBlue,
        fg: AppPalette.white,
        border: AppPalette.lighthouseYellow,
      ),
      MapNodeState.next => (
        fill: AppPalette.lighthouseYellow,
        fg: AppPalette.ink,
        border: AppPalette.white,
      ),
      MapNodeState.playable => (
        fill: AppPalette.white,
        fg: AppPalette.seaBlue,
        border: AppPalette.seaBlue,
      ),
      MapNodeState.locked => (
        fill: AppMapColors.nodeLocked,
        fg: AppPalette.white,
        border: AppPalette.white.withValues(alpha: 0.7),
      ),
      MapNodeState.comingSoon => (
        fill: AppMapColors.nodeLocked.withValues(alpha: 0.55),
        fg: AppPalette.white.withValues(alpha: 0.7),
        border: AppPalette.white.withValues(alpha: 0.38),
      ),
    };

/// Bir bölüm noktası. Durumlar: tamamlandı (onay), devam ediyor (halka),
/// sıradaki (parıltı; hareket azaltılmadıysa ≤ 1 Hz nabız), kilitli (kilit),
/// yakında (soluk).
///
/// [lightUp] verilirse (yeni açılan bölümün ilk gösterimi, H-060) düğüm
/// kilitli görünümden kendi rengine geçer, ışığı yanar ve bir kez yumuşak bir
/// hale yayılır.
class MapNode extends StatefulWidget {
  const MapNode({
    super.key,
    required this.episode,
    required this.onTap,
    this.lightUp,
  });

  final MapEpisode episode;
  final VoidCallback onTap;

  /// Açılış animasyonunun tamamı (0–1); düğüm [UnlockMotion.light]
  /// aralığında yanar. Yoksa düğüm doğrudan son hâliyle çizilir.
  final Animation<double>? lightUp;

  @override
  State<MapNode> createState() => _MapNodeState();
}

class _MapNodeState extends State<MapNode> with SingleTickerProviderStateMixin {
  /// Tam nabız döngüsü 2,4 sn (≈ 0,4 Hz).
  static const pulseHalfPeriod = Duration(milliseconds: 1200);

  AnimationController? _pulse;

  bool get _glows =>
      widget.episode.state == MapNodeState.next ||
      widget.episode.state == MapNodeState.playable ||
      widget.episode.state == MapNodeState.inProgress;

  bool get _wantsPulse =>
      widget.episode.state == MapNodeState.next && !AppMotion.reduced(context);

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

  /// [light]: 0 (kilitli görünüm) → 1 (kendi rengi); [glow]: nabız.
  Widget _circle(BuildContext context, {double light = 1, double glow = 0}) {
    final e = widget.episode;
    final theme = Theme.of(context);
    final own = mapNodeColors(e.state);
    final dim = mapNodeColors(MapNodeState.locked);
    final fill = Color.lerp(dim.fill, own.fill, light)!;
    final fg = Color.lerp(dim.fg, own.fg, light)!;
    final border = Color.lerp(dim.border, own.border, light)!;
    final ring = e.state == MapNodeState.inProgress ? 4.0 : 2.0;
    final lit = e.state == MapNodeState.next;
    return Container(
      width: kNodeSize,
      height: kNodeSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: ring),
        boxShadow: [
          if (lit || light < 1)
            BoxShadow(
              color: AppPalette.lighthouseYellow.withValues(
                alpha: (0.45 + 0.35 * glow) * light,
              ),
              blurRadius: 10 + 10 * glow,
              spreadRadius: 2 + 4 * glow,
            )
          else
            const BoxShadow(
              color: AppScrim.badgeShadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Text(
        '${e.number}',
        style: theme.textTheme.titleMedium?.copyWith(color: fg),
      ),
    );
  }

  /// Işık yanarken bir kez dışa yayılan hale.
  Widget _halo(double t) {
    final opacity = (1 - t) * 0.6;
    return IgnorePointer(
      child: Transform.scale(
        scale: 1 + 0.9 * t,
        child: Container(
          width: kNodeSize,
          height: kNodeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppPalette.lighthouseYellow.withValues(alpha: opacity),
              width: 3,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.episode;
    final badge = switch (e.state) {
      MapNodeState.completed => const _Badge(
        icon: Icons.check_rounded,
        color: AppMapColors.badgeDone,
      ),
      MapNodeState.locked => const _Badge(
        icon: Icons.lock_rounded,
        color: AppMapColors.badgeLocked,
      ),
      MapNodeState.inProgress => const _Badge(
        icon: Icons.play_arrow_rounded,
        color: AppMapColors.badgeInProgress,
      ),
      _ => null,
    };
    final pulse = _pulse;
    final lightUp = widget.lightUp;
    final Widget body;
    if (lightUp != null && _glows) {
      body = AnimatedBuilder(
        key: const ValueKey('map-node-light-up'),
        animation: lightUp,
        builder: (context, _) {
          final t = UnlockMotion.light.transform(lightUp.value);
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (t > 0 && t < 1) _halo(t),
              _circle(context, light: t, glow: pulse?.value ?? 0.6),
            ],
          );
        },
      );
    } else if (pulse != null) {
      body = AnimatedBuilder(
        animation: pulse,
        builder: (context, _) => _circle(context, glow: pulse.value),
      );
    } else {
      body = _circle(context, glow: e.state == MapNodeState.next ? 0.6 : 0);
    }
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
                body,
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
      border: Border.all(color: AppPalette.white, width: 2),
    ),
    child: Icon(icon, size: 12, color: AppPalette.white),
  );
}
