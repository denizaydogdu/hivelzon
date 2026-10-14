part of 'hi_painter.dart';

// Hi'nin küçük işaretleri (H-063): yanak, kaş, el, düşünce balonları, "z" ve
// ses dalgaları. Ana çizim `hi_painter.dart`'ta.

extension _HiMarks on HiPainter {
  void _blush(Canvas canvas, Offset c, double r) {
    final paint = Paint()
      ..color = AppHiColors.cheek.withValues(alpha: 0.3 * face.blush);
    for (final dx in [-0.56, 0.56]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: c.translate(r * dx, r * 0.2),
          width: r * 0.22,
          height: r * 0.12,
        ),
        paint,
      );
    }
  }

  void _brows(Canvas canvas, Offset c, double r, double s) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = s * 0.02
      ..color = AppHiColors.face.withValues(alpha: face.brows.clamp(0.0, 1.0));
    for (final dx in [-0.32, 0.32]) {
      canvas.drawArc(
        Rect.fromCenter(
          center: c.translate(r * (dx + face.gazeX), -r * 0.36 * face.eyeScale),
          width: r * 0.26,
          height: r * 0.12,
        ),
        1.15 * math.pi,
        0.7 * math.pi,
        false,
        paint,
      );
    }
  }

  void _hand(Canvas canvas, Offset c, double r, double s) {
    final a = face.hand.clamp(0.0, 1.0);
    // Yuvarlak, yumuşak bir el balonun sağ üstünde durur; sallarken bileği
    // etrafında ±14° salınır. Yanında iki küçük hareket çizgisi.
    final base = -math.pi * 0.25;
    final angle = base + wave * math.pi * 0.08;
    final p = c + Offset(math.cos(base), math.sin(base)) * (r * 1.08);
    canvas.save();
    canvas.translate(p.dx, p.dy);
    canvas.rotate(angle + math.pi / 2);
    final hand = Rect.fromCenter(
      center: Offset.zero,
      width: r * 0.32,
      height: r * 0.42,
    );
    canvas.drawOval(
      hand,
      Paint()..color = AppHiColors.core.withValues(alpha: a),
    );
    canvas.drawOval(
      hand,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.018
        ..color = AppHiColors.rim.withValues(alpha: 0.9 * a),
    );
    canvas.restore();
    final lines = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = s * 0.016
      ..color = AppHiColors.face.withValues(alpha: 0.45 * a);
    for (final side in [-1.0, 1.0]) {
      canvas.drawArc(
        Rect.fromCircle(center: p, radius: r * 0.36),
        base + side * math.pi * 0.32 - math.pi * 0.07,
        math.pi * 0.14,
        false,
        lines,
      );
    }
  }

  void _thought(Canvas canvas, Offset c, double r, double s) {
    // Hi'nin renginde üç küçük düşünce balonu: açık ve koyu zeminde görünür.
    final a = face.thought.clamp(0.0, 1.0);
    final fill = Paint()..color = AppHiColors.core.withValues(alpha: a);
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.012
      ..color = AppHiColors.rim.withValues(alpha: a);
    for (final (dx, dy, rad) in [
      (0.98, -0.62, 0.05),
      (1.1, -0.86, 0.07),
      (1.16, -1.12, 0.09),
    ]) {
      final p = c.translate(r * dx, r * dy);
      canvas.drawCircle(p, r * rad, fill);
      canvas.drawCircle(p, r * rad, edge);
    }
  }

  void _zzz(Canvas canvas, Offset c, double r, double s) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = s * 0.02
      ..color = AppHiColors.face.withValues(
        alpha: 0.6 * face.sleep.clamp(0.0, 1.0),
      );
    for (final (dx, dy, z) in [(0.98, -0.92, 0.22), (0.74, -1.14, 0.14)]) {
      final o = c.translate(r * dx, r * dy);
      final h = r * z;
      canvas.drawPath(
        Path()
          ..moveTo(o.dx, o.dy)
          ..lineTo(o.dx + h, o.dy)
          ..lineTo(o.dx, o.dy + h)
          ..lineTo(o.dx + h, o.dy + h),
        paint,
      );
    }
  }

  void _waves(Canvas canvas, Offset c, double r, double s) {
    final a = face.waves.clamp(0.0, 1.0);
    for (final (rad, alpha) in [(0.2, 0.7), (0.34, 0.45)]) {
      canvas.drawArc(
        Rect.fromCircle(
          center: c.translate(r * 1.0, -r * 0.05),
          radius: r * rad,
        ),
        -0.3 * math.pi,
        0.6 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = s * 0.02
          ..color = AppHiColors.face.withValues(alpha: alpha * a),
      );
    }
  }
}
