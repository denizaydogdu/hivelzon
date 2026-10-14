import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/design/tokens.dart';
import '../../app/design/typography.dart';

/// İstatistik kutusu (H-057): büyük sayı + kısa etiket. Ekran okuyucu
/// "12 ifade" gibi tek parça okur.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.color = AppPalette.seaBlue,
  }) : count = null;

  /// Sayı sıfırdan yukarı sayarak belirir (H-059; 400 ms). "Hareketi
  /// azalt" açıksa doğrudan son değer. Ekran okuyucu yalnız son değeri okur.
  const StatTile.count({
    super.key,
    required int this.count,
    required this.label,
    this.icon,
    this.color = AppPalette.seaBlue,
  }) : value = '$count';

  final String value;

  /// Sayan kutuda son değer.
  final int? count;
  final String label;
  final IconData? icon;

  /// Sayının ve ikonun rengi.
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      label: '$value $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.s12,
          vertical: AppSpace.s16,
        ),
        decoration: const BoxDecoration(
          color: AppPalette.white,
          borderRadius: AppRadius.mdAll,
          boxShadow: AppShadows.level1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: AppIconSize.md),
              const SizedBox(height: AppSpace.s4),
            ],
            FittedBox(
              fit: BoxFit.scaleDown,
              child: count == null || AppMotion.reduced(context)
                  ? Text(
                      value,
                      style: AppTypography.statNumber.copyWith(color: color),
                    )
                  : TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: count),
                      duration: AppMotion.slow * 2,
                      curve: AppMotion.enter,
                      builder: (context, n, _) => Text(
                        '$n',
                        style: AppTypography.statNumber.copyWith(color: color),
                      ),
                    ),
            ),
            const SizedBox(height: AppSpace.s4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppPalette.ink500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Yan yana eşit genişlikte [StatTile]'lar.
class StatRow extends StatelessWidget {
  const StatRow({super.key, required this.tiles});

  final List<StatTile> tiles;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      if (i > 0) children.add(const SizedBox(width: AppSpace.s12));
      children.add(Expanded(child: tiles[i]));
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// Dolan halka (H-057): günlük hedef, set ilerlemesi. Değer değişince
/// yumuşakça dolar (400 ms); "Hareketi azalt" açıksa anında.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    required this.semanticLabel,
    this.size = 72,
    this.strokeWidth = 8,
    this.color = AppPalette.lighthouseYellow,
    this.trackColor = AppPalette.sand200,
    this.child,
  });

  /// 0–1 arası.
  final double value;

  /// Ekran okuyucu metni ("Günlük hedef: 6 / 10 dk").
  final String semanticLabel;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  /// Ortadaki içerik (ör. "6/10").
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final target = value.clamp(0.0, 1.0);
    return Semantics(
      label: semanticLabel,
      value: '%${(target * 100).round()}',
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: target),
          duration: AppMotion.of(context, AppMotion.slow),
          curve: AppMotion.enter,
          builder: (context, v, child) => CustomPaint(
            painter: _RingPainter(
              value: v,
              strokeWidth: strokeWidth,
              color: color,
              trackColor: trackColor,
            ),
            child: child,
          ),
          child: child == null ? null : Center(child: child),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  final double value;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, math.pi * 2, false, track);
    if (value <= 0) return;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * value, false, fill);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.strokeWidth != strokeWidth;
}
