import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../hi/application/hi_providers.dart';
import '../../notebook/application/card_audio_player.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/presentation/notebook_screen.dart' show createCardAudio;
import '../application/topic_set_providers.dart';
import '../domain/topic_set.dart';
import 'topic_set_widgets.dart';

/// Küçük nesneler için dokunma payı (px): parmak ucu ~48 px.
const double kHuntTapTolerance = 14;

/// Alt çubuğun sabit yüksekliği: sonuç gelince resim zıplamaz.
const double kHuntBottomBarHeight = 72;

/// Sahne avı (H-051): "Find the radio!" → resimde dokun. Süre ve puan yok;
/// iki kaçırmadan sonra bölge nazikçe parlar; "Bilmiyorum" yeri gösterir.
/// Ekran okuyucu açıkken resim yerine seçenek listesi sunulur.
class SceneHuntScreen extends ConsumerWidget {
  const SceneHuntScreen({super.key, required this.setId, this.random});

  final String setId;

  /// Testlerde sabit sıra.
  final math.Random? random;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.watch(topicSetProvider(setId));
    return Scaffold(
      backgroundColor: AppColors.sand,
      body: SafeArea(
        child: switch (set) {
          AsyncData(:final value) => _Hunt(set: value, random: random),
          AsyncError() => _Failure(
            onRetry: () => ref.invalidate(topicSetProvider(setId)),
          ),
          _ => const Skeleton(
            label: TopicSetTexts.setLoading,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Column(
                children: [
                  SkeletonBox(height: 48),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBox(height: 72, radius: AppTheme.radius),
                  SizedBox(height: AppSpacing.sm),
                  Expanded(child: SkeletonBox(radius: AppTheme.radius)),
                ],
              ),
            ),
          ),
        },
      ),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CloseButton(),
        const SizedBox(height: AppSpacing.sm),
        Text(
          TopicSetTexts.setError,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: onRetry,
          child: const Text(CommonTexts.retry),
        ),
      ],
    ),
  );
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
    key: const ValueKey('hunt-close'),
    tooltip: HuntTexts.exit,
    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    onPressed: () => context.canPop() ? context.pop() : null,
    icon: const Icon(Icons.close_rounded, color: AppColors.ink),
  );
}

class _Hunt extends ConsumerStatefulWidget {
  const _Hunt({required this.set, this.random});

  final TopicSet set;
  final math.Random? random;

  @override
  ConsumerState<_Hunt> createState() => _HuntState();
}

enum _Feedback { none, miss, found, revealed }

class _HuntState extends ConsumerState<_Hunt>
    with SingleTickerProviderStateMixin {
  late HuntSession _session = HuntSession(widget.set, random: widget.random);
  late final CardAudioPlayer _audio;
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  final TransformationController _zoom = TransformationController();
  Size _viewport = Size.zero;
  _Feedback _feedback = _Feedback.none;
  Offset? _lastMiss;
  Future<int>? _recorded;

  @override
  void initState() {
    super.initState();
    _audio = createCardAudio(ref);
    // Soru önce yalnızca İngilizce (+ kelimenin sesi, varsa).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _playWord();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void dispose() {
    _zoom.dispose();
    _pulse.dispose();
    _audio.dispose();
    super.dispose();
  }

  bool get _reduceMotion =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  void _syncPulse() {
    if (_session.showHint && !_reduceMotion) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse
        ..stop()
        ..value = 1;
    }
  }

  void _onTap(Offset local, Size size) {
    final r = _session.tap(
      local.dx,
      local.dy,
      width: size.width,
      height: size.height,
      tolerance: kHuntTapTolerance,
    );
    _after(r, local);
  }

  void _onChoice(TopicSetItem choice) => _after(_session.choose(choice), null);

  void _after(HuntTap r, Offset? at) {
    if (r == HuntTap.ignored) return;
    setState(() {
      _feedback = r == HuntTap.correct ? _Feedback.found : _Feedback.miss;
      _lastMiss = r == HuntTap.miss ? at : null;
    });
    _syncPulse();
    final dir = Directionality.of(context);
    if (r == HuntTap.correct) {
      _playWord();
      SemanticsService.sendAnnouncement(
        View.of(context),
        '${HuntTexts.found} ${_session.current?.w ?? ''}',
        dir,
      );
    } else {
      SemanticsService.sendAnnouncement(
        View.of(context),
        _session.showHint ? HuntTexts.hint : HuntTexts.miss,
        dir,
      );
    }
  }

  void _reveal() {
    _session.reveal();
    setState(() {
      _feedback = _Feedback.revealed;
      _lastMiss = null;
    });
    _syncPulse();
    _playWord();
  }

  void _playWord() {
    final it = _session.current;
    if (it == null) return;
    final n = widget.set.toNotebookItem(it);
    if (n.hasAudio) unawaited(_audio.play(n));
  }

  void _next() {
    unawaited(_audio.stop());
    _session.next();
    setState(() {
      _feedback = _Feedback.none;
      _lastMiss = null;
    });
    _syncPulse();
    if (!_session.finished) _playWord();
    if (_session.finished) {
      // Hi-A (H-048): bu set için sahne avı önerisi artık gelmez.
      unawaited(
        ref
            .read(hiStoreProvider)
            .markHuntDone(widget.set.id)
            .catchError(
              (Object e) => debugPrint('[H048] sahne avı işareti: $e'),
            ),
      );
      _recorded = ref
          .read(topicSetActionsProvider)
          .recordHunt(_session.results)
          .catchError((Object e) {
            debugPrint('[H051] sahne avı sonucu yazılamadı: $e');
            return 0;
          })
          .whenComplete(() {
            if (mounted) {
              ref.invalidate(deckKeysProvider);
              refreshNotebook(ref);
            }
          });
    }
  }

  void _restart() {
    setState(() {
      _session = HuntSession(widget.set, random: widget.random);
      _feedback = _Feedback.none;
      _lastMiss = null;
      _recorded = null;
    });
    _zoom.value = Matrix4.identity();
    _syncPulse();
    _playWord();
  }

  @override
  Widget build(BuildContext context) {
    if (_session.finished) {
      final keys = ref.watch(deckKeysProvider).value;
      return _Summary(
        session: _session,
        recorded: _recorded,
        allInDeck:
            keys != null &&
            widget.set.items.every((i) => keys.contains(i.notebookKey)),
        onAgain: _restart,
        onAddAll: () async {
          await ref
              .read(topicSetActionsProvider)
              .addToDeck(widget.set, widget.set.items);
          ref.invalidate(deckKeysProvider);
          refreshNotebook(ref);
        },
      );
    }
    final theme = Theme.of(context);
    final it = _session.current!;
    final a11y = MediaQuery.of(context).accessibleNavigation;
    final hasAudio = widget.set.toNotebookItem(it).hasAudio;
    // Türkçe yardım satırı ilk yanlış dokunuştan sonra gelir; ekran okuyucu
    // açıkken ipucuna (2 kaçırma) kadar gizli kalır.
    final showHelper = a11y
        ? _session.showHint
        : _session.misses >= 1 || _session.resolved;
    return Column(
      key: const ValueKey('scene-hunt'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, AppSpacing.xs, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _CloseButton(),
              Expanded(
                child: _Prompt(
                  item: it,
                  showHelper: showHelper,
                  hasAudio: hasAudio,
                  onListen: _playWord,
                ),
              ),
              Semantics(
                label: '${HuntTexts.title} · ${widget.set.titleTr}',
                child: Text(
                  HuntTexts.progress(_session.position, _session.total),
                  key: const ValueKey('hunt-progress'),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _Scene(
            set: widget.set,
            session: _session,
            pulse: _pulse,
            lastMiss: _lastMiss,
            zoom: _zoom,
            onViewport: (size) => _viewport = size,
            onTap: _onTap,
            onChoice: _onChoice,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.xs,
            AppSpacing.sm,
            AppSpacing.xs,
          ),
          // Alt alan sabit yükseklikte: sonuç gelince resim zıplamaz.
          child: a11y
              ? (_session.resolved
                    ? _Resolved(
                        item: it,
                        revealed: _feedback == _Feedback.revealed,
                        last: _session.position == _session.total,
                        hasAudio: hasAudio,
                        onListen: _playWord,
                        onNext: _next,
                      )
                    : _Pending(
                        feedback: _feedback,
                        hint: _session.showHint,
                        choices: _session.choices(random: widget.random),
                        onChoice: _onChoice,
                        onDontKnow: _reveal,
                      ))
              : SizedBox(
                  height: kHuntBottomBarHeight,
                  child: _session.resolved
                      ? _Resolved(
                          item: it,
                          revealed: _feedback == _Feedback.revealed,
                          last: _session.position == _session.total,
                          hasAudio: hasAudio,
                          onListen: _playWord,
                          onNext: _next,
                        )
                      : _Pending(
                          feedback: _feedback,
                          hint: _session.showHint,
                          choices: null,
                          onChoice: _onChoice,
                          onDontKnow: _reveal,
                          zoomControls: _ZoomButtons(
                            zoom: _zoom,
                            viewport: () => _viewport,
                          ),
                        ),
                ),
        ),
      ],
    );
  }
}

/// "Find the radio!" (+ ses) ve ilk yanlıştan sonra Türkçe yardım satırı.
/// Yardım satırının yeri baştan ayrılır: gelince resim kaymaz.
class _Prompt extends StatelessWidget {
  const _Prompt({
    required this.item,
    required this.showHelper,
    required this.hasAudio,
    required this.onListen,
  });

  final TopicSetItem item;
  final bool showHelper;
  final bool hasAudio;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      key: const ValueKey('hunt-prompt'),
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                liveRegion: true,
                child: Text(
                  item.findEn,
                  key: const ValueKey('hunt-find-en'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.seaBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
                child: showHelper
                    ? Text(
                        item.findTr,
                        key: const ValueKey('hunt-find-tr'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.ink.withValues(alpha: 0.75),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
        if (hasAudio)
          IconButton(
            key: const ValueKey('hunt-prompt-listen'),
            tooltip: HuntTexts.listen,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: onListen,
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.seaBlue),
          ),
      ],
    );
  }
}

/// Sahne görseli: oran korunarak sığdırılır; dokunuşlar görselin piksel
/// uzayında değerlendirilir. Ekran okuyucu için her nesne bölgesi Türkçe
/// adıyla düğmedir.
class _Scene extends StatelessWidget {
  const _Scene({
    required this.set,
    required this.session,
    required this.pulse,
    required this.lastMiss,
    required this.zoom,
    required this.onViewport,
    required this.onTap,
    required this.onChoice,
  });

  final TopicSet set;
  final HuntSession session;
  final Animation<double> pulse;
  final Offset? lastMiss;

  /// Yakınlaştırma (iki parmak) ve kaydırma. Dokunma denetimi görselin kendi
  /// (dönüştürülmemiş) koordinatlarında yapılır; büyütme isabeti bozmaz.
  final TransformationController zoom;

  /// Görünen alanın boyutu (büyütme düğmesi ortaya göre büyütür).
  final ValueChanged<Size> onViewport;
  final void Function(Offset local, Size size) onTap;
  final void Function(TopicSetItem) onChoice;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final aspect = set.sceneAspect;
        var w = c.maxWidth;
        var h = w / aspect;
        if (h > c.maxHeight) {
          h = c.maxHeight;
          w = h * aspect;
        }
        final size = Size(w, h);
        final it = session.current!;
        final highlight = session.resolved || session.showHint;
        final viewer = InteractiveViewer(
          key: const ValueKey('hunt-zoom'),
          transformationController: zoom,
          minScale: 1,
          maxScale: 4,
          child: SizedBox(
            width: c.maxWidth,
            height: c.maxHeight,
            child: Center(
              child: SizedBox.fromSize(
                size: size,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Semantics(
                        label: HuntTexts.sceneLabel(set.titleTr),
                        image: true,
                        child: SetImage(
                          path: set.sceneImage,
                          fit: BoxFit.fill,
                          cacheWidth: 1080,
                        ),
                      ),
                      GestureDetector(
                        key: const ValueKey('hunt-scene'),
                        behavior: HitTestBehavior.opaque,
                        onTapUp: (d) => onTap(d.localPosition, size),
                        excludeFromSemantics: true,
                      ),
                      if (highlight || lastMiss != null)
                        IgnorePointer(
                          child: AnimatedBuilder(
                            animation: pulse,
                            builder: (context, _) => CustomPaint(
                              key: ValueKey(
                                session.resolved
                                    ? 'hunt-highlight'
                                    : session.showHint
                                    ? 'hunt-hint'
                                    : 'hunt-miss',
                              ),
                              painter: _HotspotPainter(
                                shapes: highlight ? it.hotspots : const [],
                                strong: session.resolved,
                                pulse: pulse.value,
                                miss: lastMiss,
                              ),
                            ),
                          ),
                        ),
                      // Ekran okuyucu: nesne bölgeleri (görünmez düğmeler).
                      for (final o in set.items)
                        for (final s in o.hotspots.take(1))
                          _SemanticRegion(
                            shape: s,
                            size: size,
                            label: o.tr,
                            onTap: session.resolved ? null : () => onChoice(o),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        onViewport(c.biggest);
        return viewer;
      },
    );
  }
}

/// İki parmakla büyütmenin yanında tek dokunuşla büyütme (erişilebilirlik).
/// Alt çubukta durur; resmin üstünü kapatmaz.
class _ZoomButtons extends StatelessWidget {
  const _ZoomButtons({required this.zoom, required this.viewport});

  final TransformationController zoom;
  final Size Function() viewport;

  void _zoomIn() {
    final current = zoom.value.getMaxScaleOnAxis();
    final next = (current * 2).clamp(1.0, 4.0);
    final f = next / current;
    final v = viewport();
    final c = Offset(v.width / 2, v.height / 2);
    // Görünen alanın ortasına göre büyüt.
    zoom.value = Matrix4.identity()
      ..translateByDouble(c.dx * (1 - f), c.dy * (1 - f), 0, 1)
      ..multiply(Matrix4.diagonal3Values(f, f, 1))
      ..multiply(zoom.value.clone());
  }

  @override
  Widget build(BuildContext context) {
    Widget button(String key, String tip, IconData icon, VoidCallback onTap) =>
        Material(
          color: Colors.white.withValues(alpha: 0.85),
          shape: const CircleBorder(),
          child: IconButton(
            key: ValueKey(key),
            tooltip: tip,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: onTap,
            icon: Icon(icon, color: AppColors.seaBlue),
          ),
        );
    return ValueListenableBuilder<Matrix4>(
      valueListenable: zoom,
      builder: (context, m, _) {
        final zoomed = m.getMaxScaleOnAxis() > 1.01;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (m.getMaxScaleOnAxis() < 3.99)
              button(
                'hunt-zoom-in',
                HuntTexts.zoomIn,
                Icons.zoom_in_rounded,
                _zoomIn,
              ),
            if (zoomed) ...[
              const SizedBox(width: 4),
              button(
                'hunt-zoom-reset',
                HuntTexts.zoomReset,
                Icons.zoom_out_map_rounded,
                () => zoom.value = Matrix4.identity(),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SemanticRegion extends StatelessWidget {
  const _SemanticRegion({
    required this.shape,
    required this.size,
    required this.label,
    required this.onTap,
  });

  final HotspotShape shape;
  final Size size;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (l, t, r, b) = shape.bounds;
    return Positioned(
      left: l * size.width,
      top: t * size.height,
      width: (r - l) * size.width,
      height: (b - t) * size.height,
      child: Semantics(
        button: true,
        label: label,
        onTap: onTap,
        child: const IgnorePointer(child: SizedBox.expand()),
      ),
    );
  }
}

class _HotspotPainter extends CustomPainter {
  _HotspotPainter({
    required this.shapes,
    required this.strong,
    required this.pulse,
    this.miss,
  });

  final List<HotspotShape> shapes;
  final bool strong;
  final double pulse;
  final Offset? miss;

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in shapes) {
      final path = Path()
        ..addPolygon([
          for (final (x, y) in s.points)
            Offset(x * size.width, y * size.height),
        ], true);
      final a = strong ? 1.0 : 0.35 + 0.65 * pulse;
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.lighthouseYellow.withValues(
            alpha: (strong ? 0.30 : 0.18) * a,
          ),
      );
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strong ? 4 : 3
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.lighthouseYellow.withValues(alpha: a),
      );
    }
    final m = miss;
    if (m != null) {
      // Dokunulan yer: nötr, küçük bir halka (kırmızı ve çarpı yok).
      canvas.drawCircle(
        m,
        14,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = Colors.white.withValues(alpha: 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(_HotspotPainter old) =>
      old.pulse != pulse ||
      old.strong != strong ||
      old.miss != miss ||
      old.shapes != shapes;
}

/// Henüz bulunmadı: nazik geri bildirim, ipucu, "Bilmiyorum".
class _Pending extends StatelessWidget {
  const _Pending({
    required this.feedback,
    required this.hint,
    required this.choices,
    required this.onChoice,
    required this.onDontKnow,
    this.zoomControls,
  });

  final Widget? zoomControls;
  final _Feedback feedback;
  final bool hint;
  final List<TopicSetItem>? choices;
  final void Function(TopicSetItem) onChoice;
  final VoidCallback onDontKnow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = hint
        ? HuntTexts.hint
        : feedback == _Feedback.miss
        ? HuntTexts.miss
        : null;
    final feedbackText = message == null
        ? const SizedBox.shrink()
        : Text(
            message,
            key: const ValueKey('hunt-feedback'),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          );
    // İnceleme ekranındaki "Bilmiyorum" ile aynı biçim (H-057: ortak stil).
    final dontKnow = OutlinedButton.icon(
      key: const ValueKey('hunt-dont-know'),
      onPressed: onDontKnow,
      style: AppButtonStyles.dontKnow(),
      icon: const Icon(AppButtonStyles.dontKnowIcon),
      label: const Text(HuntTexts.dontKnow),
    );
    if (choices == null) {
      return Row(
        children: [
          Expanded(child: feedbackText),
          ?zoomControls,
          const SizedBox(width: AppSpacing.xs),
          dontKnow,
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(HuntTexts.choicesHeading, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 4),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final c in choices!)
              OutlinedButton(
                key: ValueKey('hunt-choice-${c.id}'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  backgroundColor: Colors.white,
                ),
                onPressed: () => onChoice(c),
                child: Text(c.tr),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        feedbackText,
        const SizedBox(height: AppSpacing.xs),
        Center(child: dontKnow),
      ],
    );
  }
}

/// Bulundu ya da gösterildi: kelime, Türkçesi, ses, "Devam et" (tek satır).
class _Resolved extends StatelessWidget {
  const _Resolved({
    required this.item,
    required this.revealed,
    required this.last,
    required this.hasAudio,
    required this.onListen,
    required this.onNext,
  });

  final TopicSetItem item;
  final bool revealed;
  final bool last;
  final bool hasAudio;
  final VoidCallback onListen;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      key: const ValueKey('hunt-resolved'),
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                revealed ? HuntTexts.revealed : HuntTexts.found,
                key: const ValueKey('hunt-result-text'),
                maxLines: 2,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.seaBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: item.w,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: '  ${item.tr}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.ink.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
        if (hasAudio)
          IconButton(
            key: const ValueKey('hunt-listen'),
            tooltip: HuntTexts.listen,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: onListen,
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.seaBlue),
          ),
        const SizedBox(width: 4),
        FilledButton(
          key: const ValueKey('hunt-next'),
          onPressed: onNext,
          style: FilledButton.styleFrom(
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          ),
          child: Text(last ? HuntTexts.finish : HuntTexts.next),
        ),
      ],
    );
  }
}

/// Sonuç: sakin özet, puan yok.
class _Summary extends StatefulWidget {
  const _Summary({
    required this.session,
    required this.allInDeck,
    required this.recorded,
    required this.onAgain,
    required this.onAddAll,
  });

  final HuntSession session;

  /// Setin bütün nesneleri defterde mi (değilse ekleme önerilir).
  final bool allInDeck;
  final Future<int>? recorded;
  final VoidCallback onAgain;
  final Future<void> Function() onAddAll;

  @override
  State<_Summary> createState() => _SummaryState();
}

class _SummaryState extends State<_Summary> {
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = widget.session;
    final alone = s.foundAlone;
    final helped = s.helped;
    return ListView(
      key: const ValueKey('hunt-summary'),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Align(alignment: Alignment.centerLeft, child: _CloseButton()),
        const Icon(
          Icons.travel_explore_rounded,
          size: 64,
          color: AppColors.seaBlue,
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          header: true,
          child: Text(
            HuntTexts.doneTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.seaBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          HuntTexts.foundAlone(alone, s.total),
          key: const ValueKey('hunt-summary-found'),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        if (helped > 0 && alone > 0) ...[
          const SizedBox(height: 4),
          Text(
            HuntTexts.helped(helped),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        FutureBuilder<int>(
          future: widget.recorded,
          builder: (context, snap) {
            final n = snap.data;
            if (n == null) return const SizedBox(height: 24);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (n > 0)
                  Text(
                    HuntTexts.deckUpdated(n),
                    key: const ValueKey('hunt-summary-deck'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                if (!widget.allInDeck || _added) ...[
                  if (n > 0) const SizedBox(height: AppSpacing.xs),
                  Text(
                    HuntTexts.notInDeck,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  OutlinedButton.icon(
                    key: const ValueKey('hunt-add-all'),
                    onPressed: _added
                        ? null
                        : () async {
                            await widget.onAddAll();
                            if (mounted) setState(() => _added = true);
                          },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      foregroundColor: AppColors.seaBlue,
                      side: const BorderSide(
                        color: AppColors.seaBlue,
                        width: 1.5,
                      ),
                    ),
                    icon: Icon(
                      _added
                          ? Icons.check_circle_rounded
                          : Icons.library_add_rounded,
                    ),
                    label: Text(
                      _added ? TopicSetTexts.allInDeck : TopicSetTexts.addAll,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          key: const ValueKey('hunt-again'),
          onPressed: widget.onAgain,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          child: const Text(HuntTexts.playAgain),
        ),
        const SizedBox(height: AppSpacing.xs),
        OutlinedButton(
          key: const ValueKey('hunt-back'),
          onPressed: () => context.canPop() ? context.pop() : null,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text(HuntTexts.backToSet),
        ),
      ],
    );
  }
}
