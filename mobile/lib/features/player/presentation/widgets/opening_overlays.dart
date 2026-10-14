import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
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
      Shadow(color: AppScrim.textShadow, blurRadius: 12, offset: Offset(0, 2)),
    ];
    return IgnorePointer(
      child: Align(
        // Gökyüzü: jenerik görselinin üst üçte biri boştur.
        alignment: const Alignment(0, -0.42),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s24),
          child: Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, 8 * (1 - opacity)),
              child: Semantics(
                key: const ValueKey('title-screen'),
                header: true,
                liveRegion: true,
                label: PlayerTexts.titleSemantics(
                  node.season,
                  node.episode,
                  node.title,
                ),
                excludeSemantics: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      node.caption,
                      textAlign: TextAlign.center,
                      style: t.titleMedium?.copyWith(
                        color: AppPalette.lighthouseYellow,
                        letterSpacing: 2.4,
                        shadows: shadow,
                      ),
                    ),
                    const SizedBox(height: AppSpace.s8),
                    Text(
                      node.title,
                      textAlign: TextAlign.center,
                      style: t.displaySmall?.copyWith(
                        color: AppPalette.white,
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
  static const height = AppTouch.min + AppSpace.s16;

  @override
  Widget build(BuildContext context) {
    final label = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: AppPalette.white,
      fontWeight: AppFonts.bold,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.s12,
              vertical: AppSpace.s8,
            ),
            decoration: const BoxDecoration(
              color: AppScrim.dim,
              borderRadius: AppRadius.mdAll,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.history_rounded,
                  size: AppIconSize.sm,
                  color: AppPalette.white,
                ),
                const SizedBox(width: AppSpace.s8),
                Flexible(
                  child: Text(
                    PlayerTexts.recap,
                    overflow: TextOverflow.ellipsis,
                    style: label,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpace.s8),
        if (onSkip != null)
          Semantics(
            button: true,
            label: PlayerTexts.recapSkipSemantics,
            excludeSemantics: true,
            child: FilledButton.icon(
              key: const ValueKey('recap-skip'),
              onPressed: onSkip,
              style: FilledButton.styleFrom(
                minimumSize: const Size(96, AppTouch.min),
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s16),
                backgroundColor: AppPalette.white,
                foregroundColor: AppPalette.seaBlue,
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.skip_next_rounded),
              label: const Text(PlayerTexts.recapSkip),
            ),
          ),
      ],
    );
  }
}
