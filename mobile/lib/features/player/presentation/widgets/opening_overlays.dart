import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../app/theme.dart';
import '../../domain/episode.dart';

/// Bölüm başlık ekranı (H-050): sezonun kısa animasyonu üstünde
/// "SEZON 1 · BÖLÜM N" ve bölüm adı. Dokunma gerekmez; video bitince oturum
/// sıradaki düğüme geçer.
///
/// Yazı açılışta 0,45 sn'de belirir, videonun son 0,4 sn'sinde kaybolur
/// (konum videodan okunur; video geç başlarsa yazı erken kaybolmaz).
class EpisodeTitleOverlay extends StatefulWidget {
  const EpisodeTitleOverlay({
    super.key,
    required this.node,
    required this.positionSeconds,
  });

  final TitleNode node;

  /// Oynayan başlık videosunun konumu (saniye).
  final double Function() positionSeconds;

  static const fadeIn = 0.45;
  static const fadeOut = 0.4;

  @override
  State<EpisodeTitleOverlay> createState() => _EpisodeTitleOverlayState();
}

class _EpisodeTitleOverlayState extends State<EpisodeTitleOverlay>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((d) => setState(() => _elapsed = d))..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  double get _opacity {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return 1;
    final t = _elapsed.inMicroseconds / 1e6;
    final fadeIn = (t / EpisodeTitleOverlay.fadeIn).clamp(0.0, 1.0);
    final remaining = widget.node.duration - widget.positionSeconds();
    final fadeOut = (remaining / EpisodeTitleOverlay.fadeOut).clamp(0.0, 1.0);
    return Curves.easeOut.transform(fadeIn < fadeOut ? fadeIn : fadeOut);
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final opacity = _opacity;
    final t = Theme.of(context).textTheme;
    const shadow = [
      Shadow(color: Color(0x99000000), blurRadius: 12, offset: Offset(0, 2)),
    ];
    return IgnorePointer(
      child: Align(
        // Gökyüzü: jenerik görselinin üst üçte biri boştur.
        alignment: const Alignment(0, -0.42),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, 8 * (1 - opacity)),
              child: Semantics(
                key: const ValueKey('title-screen'),
                header: true,
                liveRegion: true,
                label:
                    'Sezon ${node.season}, Bölüm ${node.episode}: '
                    '${node.title}',
                excludeSemantics: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      node.caption,
                      textAlign: TextAlign.center,
                      style: t.titleMedium?.copyWith(
                        color: AppColors.lighthouseYellow,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.4,
                        shadows: shadow,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      node.title,
                      textAlign: TextAlign.center,
                      style: t.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        shadows: shadow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Önceki bölümde" özeti sırasında alt çubuk: etiket + "Atla" (H-050).
class RecapBar extends StatelessWidget {
  const RecapBar({super.key, required this.onSkip});

  final VoidCallback? onSkip;

  /// Altyazının bu çubuğun üstünde kalması için gereken yükseklik.
  static const height = 48.0 + AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_rounded, size: 18, color: Colors.white),
                SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    'Önceki bölümde',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        if (onSkip != null)
          Semantics(
            button: true,
            label: 'Önceki bölüm özetini atla',
            excludeSemantics: true,
            child: FilledButton.icon(
              key: const ValueKey('recap-skip'),
              onPressed: onSkip,
              style: FilledButton.styleFrom(
                minimumSize: const Size(96, 48),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                backgroundColor: Colors.white,
                foregroundColor: AppColors.seaBlue,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.skip_next_rounded),
              label: const Text('Atla'),
            ),
          ),
      ],
    );
  }
}
