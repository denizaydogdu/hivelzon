import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../app/design/tokens.dart';

/// Harita görseli yokken çizilen sade arka plan (H-035): gün batımı göğü,
/// solda deniz, sağda tepe, altta liman rıhtımı, tepede fener.
///
/// Konumlar bölüm noktalarıyla uyumludur (liman altta, fener üstte).
class MapFallbackPainter extends CustomPainter {
  const MapFallbackPainter({required this.lighthouse});

  /// Fenerin normalize konumu (son bölüm noktası).
  final Offset lighthouse;

  static const _sea = AppMapColors.sea;
  static const _seaDeep = AppMapColors.seaDeep;
  static const _land = AppMapColors.land;
  static const _hill = AppMapColors.hill;
  static const _hillDark = AppMapColors.hillDark;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rect = Offset.zero & size;

    // Deniz (zemin) ve gün batımı göğü.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(Offset.zero, Offset(0, h), [
          _sea,
          _seaDeep,
        ]),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h * 0.09),
      Paint()
        ..shader = ui.Gradient.linear(Offset.zero, Offset(0, h * 0.09), [
          AppPalette.eveningOrange.withValues(alpha: 0.85),
          AppPalette.lighthouseYellow.withValues(alpha: 0.25),
        ]),
    );

    // Kara: sağ tarafı ve aşağıyı kaplar (kıyı çizgisi kıvrımlı).
    final land = Path()
      ..moveTo(w * 0.12, h)
      ..cubicTo(w * 0.02, h * 0.86, w * 0.10, h * 0.70, w * 0.26, h * 0.62)
      ..cubicTo(w * 0.36, h * 0.52, w * 0.30, h * 0.36, w * 0.36, h * 0.24)
      ..cubicTo(w * 0.40, h * 0.14, w * 0.36, h * 0.08, w * 0.42, h * 0.07)
      ..lineTo(w, h * 0.06)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(land, Paint()..color = _land);

    // Tepe: üst sağda yeşil yamaç.
    final hill = Path()
      ..moveTo(w * 0.38, h * 0.36)
      ..cubicTo(w * 0.40, h * 0.20, w * 0.44, h * 0.10, w * 0.50, h * 0.07)
      ..lineTo(w, h * 0.05)
      ..lineTo(w, h * 0.48)
      ..cubicTo(w * 0.80, h * 0.44, w * 0.60, h * 0.42, w * 0.38, h * 0.36)
      ..close();
    canvas.drawPath(hill, Paint()..color = _hill);
    final ridge = Path()
      ..moveTo(w * 0.62, h * 0.06)
      ..cubicTo(w * 0.78, h * 0.12, w * 0.86, h * 0.20, w, h * 0.22)
      ..lineTo(w, h * 0.05)
      ..close();
    canvas.drawPath(ridge, Paint()..color = _hillDark);

    // Liman: rıhtım ve iskele.
    final quay = Paint()..color = AppPalette.sand500;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.79, w * 0.62, h * 0.02),
        const Radius.circular(4),
      ),
      quay,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.80, h * 0.78, w * 0.06, h * 0.20),
        const Radius.circular(4),
      ),
      quay,
    );

    // Küçük evler (turuncu çatılar).
    final house = Paint()..color = AppPalette.sand;
    final roof = Paint()..color = AppPalette.eveningOrange;
    for (final (x, y) in const [
      (0.14, 0.70),
      (0.30, 0.68),
      (0.70, 0.66),
      (0.78, 0.58),
      (0.30, 0.48),
      (0.74, 0.38),
    ]) {
      final r = Rect.fromLTWH(w * x, h * y, w * 0.08, h * 0.03);
      canvas.drawRect(r, house);
      canvas.drawPath(
        Path()
          ..moveTo(r.left - 2, r.top)
          ..lineTo(r.center.dx, r.top - h * 0.015)
          ..lineTo(r.right + 2, r.top)
          ..close(),
        roof,
      );
    }

    // Fener (son noktanın hemen üstünde).
    final lx = lighthouse.dx * w, ly = math.max(lighthouse.dy * h - 28, 12.0);
    final beam = Path()
      ..moveTo(lx, ly)
      ..lineTo(lx - w * 0.30, ly - 18)
      ..lineTo(lx - w * 0.30, ly + 6)
      ..close();
    canvas.drawPath(
      beam,
      Paint()..color = AppPalette.lighthouseYellow.withValues(alpha: 0.35),
    );
    final tower = Path()
      ..moveTo(lx - 5, ly + 22)
      ..lineTo(lx - 3.5, ly)
      ..lineTo(lx + 3.5, ly)
      ..lineTo(lx + 5, ly + 22)
      ..close();
    canvas.drawPath(tower, Paint()..color = AppPalette.white);
    canvas.drawRect(
      Rect.fromLTWH(lx - 4.5, ly + 9, 9, 4),
      Paint()..color = AppMapColors.lighthouseBand,
    );
    canvas.drawCircle(
      Offset(lx, ly - 2),
      3.5,
      Paint()..color = AppPalette.lighthouseYellow,
    );
  }

  @override
  bool shouldRepaint(MapFallbackPainter old) => old.lighthouse != lighthouse;
}

/// Bölüm noktalarını birleştiren yol: biten kısım düz, kalan kısım kesikli.
class MapPathPainter extends CustomPainter {
  const MapPathPainter({required this.points, required this.completedUpTo});

  /// Normalize noktalar (bölüm sırasıyla).
  final List<Offset> points;

  /// Düz çizilecek son nokta indeksi (yoksa -1).
  final int completedUpTo;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final pts = [
      for (final p in points) Offset(p.dx * size.width, p.dy * size.height),
    ];
    final base = Paint()
      ..color = AppPalette.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final done = Paint()
      ..color = AppPalette.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < pts.length - 1; i++) {
      final seg = segment(pts, i);
      if (i < completedUpTo) {
        canvas.drawPath(seg, done);
      } else {
        _dashed(canvas, seg, base);
      }
    }
  }

  /// Catmull-Rom → kübik Bezier (i → i+1).
  static Path segment(List<Offset> p, int i) {
    final p0 = p[math.max(i - 1, 0)];
    final p1 = p[i];
    final p2 = p[i + 1];
    final p3 = p[math.min(i + 2, p.length - 1)];
    final c1 = p1 + (p2 - p0) / 6;
    final c2 = p2 - (p3 - p1) / 6;
    return Path()
      ..moveTo(p1.dx, p1.dy)
      ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
  }

  static void _dashed(Canvas canvas, Path path, Paint paint) {
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, math.min(d + 8, m.length)), paint);
        d += 14;
      }
    }
  }

  @override
  bool shouldRepaint(MapPathPainter old) =>
      old.completedUpTo != completedUpTo || old.points != points;
}

/// Yeni açılan bölüme giden yolun "çizilmesi" (H-060): önceki bölümden yeni
/// bölüme fener sarısı, yumuşak ışıklı bir iz. [progress] 0–1: iz uzar;
/// [opacity] sonunda iz söner (harita görselindeki yolla çakışmasın diye
/// kalıcı değildir).
class UnlockTrailPainter extends CustomPainter {
  const UnlockTrailPainter({
    required this.points,
    required this.toIndex,
    required this.progress,
    required this.opacity,
  });

  /// Normalize noktalar (bölüm sırasıyla).
  final List<Offset> points;

  /// Yeni açılan bölümün indeksi (iz `toIndex - 1` → `toIndex`).
  final int toIndex;
  final double progress;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (toIndex < 1 || toIndex >= points.length) return;
    if (progress <= 0 || opacity <= 0) return;
    final pts = [
      for (final p in points) Offset(p.dx * size.width, p.dy * size.height),
    ];
    final seg = MapPathPainter.segment(pts, toIndex - 1);
    final glow = Paint()
      ..color = AppPalette.lighthouseYellow.withValues(alpha: 0.45 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final line = Paint()
      ..color = AppPalette.lighthouseYellow.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    for (final m in seg.computeMetrics()) {
      final drawn = m.extractPath(0, m.length * progress.clamp(0.0, 1.0));
      canvas
        ..drawPath(drawn, glow)
        ..drawPath(drawn, line);
      final head = m.getTangentForOffset(m.length * progress.clamp(0.0, 1.0));
      if (head != null && progress < 1) {
        canvas.drawCircle(
          head.position,
          5,
          Paint()..color = AppPalette.yellow100.withValues(alpha: opacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(UnlockTrailPainter old) =>
      old.progress != progress ||
      old.opacity != opacity ||
      old.toIndex != toIndex ||
      old.points != points;
}
