import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/design/tokens.dart';
import 'hi_face.dart';

part 'hi_painter_marks.dart';

/// Hi'yi çizer (H-005, H-063): yuvarlak, yumuşak ışıklı konuşma balonu, iki
/// göz ve küçük bir ağız; ifadeye göre göz kapağı, bakış, ağız, ışık ve
/// küçük işaretler (el, düşünce noktaları, "z", ses dalgaları).
///
/// Varsayılan yüz ([HiFace.neutral]) H-005'teki çizimin aynısıdır.
class HiPainter extends CustomPainter {
  HiPainter({
    required this.face,
    required this.glow,
    this.blink = 0,
    this.wave = 0,
  });

  final HiFace face;

  /// Işık (0 = ışık yok).
  final double glow;

  /// Göz kırpma (0 açık, 1 kapalı).
  final double blink;

  /// El sallama salınımı (-1…1).
  final double wave;

  static const _core = AppHiColors.core;
  static const _rim = AppHiColors.rim;
  static const _ink = AppHiColors.face;
  static const _white = AppHiColors.highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = Offset(size.width / 2, size.height * 0.46);
    final r = s * 0.36;
    final f = face;

    final g = glow * f.glow;
    if (g > 0) {
      canvas.drawCircle(
        c,
        r * 1.18,
        Paint()
          ..color = _rim.withValues(alpha: (0.45 * g).clamp(0.0, 1.0))
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.08),
      );
    }

    final tilted = f.tilt != 0;
    if (tilted) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(f.tilt);
      canvas.translate(-c.dx, -c.dy);
    }

    _body(canvas, c, r, s);
    if (f.blush > 0) _blush(canvas, c, r);
    _eyes(canvas, c, r, s);
    if (f.brows > 0) _brows(canvas, c, r, s);
    _mouth(canvas, c, r, s);
    if (f.hand > 0) _hand(canvas, c, r, s);

    if (tilted) canvas.restore();

    if (f.thought > 0) _thought(canvas, c, r, s);
    if (f.sleep > 0) _zzz(canvas, c, r, s);
    if (f.waves > 0) _waves(canvas, c, r, s);
  }

  void _body(Canvas canvas, Offset c, double r, double s) {
    final body = Path()..addOval(Rect.fromCircle(center: c, radius: r));
    final tail = Path()
      ..moveTo(c.dx - r * 0.55, c.dy + r * 0.62)
      ..quadraticBezierTo(
        c.dx - r * 0.85,
        c.dy + r * 1.25,
        c.dx - r * 1.05,
        c.dy + r * 1.22,
      )
      ..quadraticBezierTo(
        c.dx - r * 0.55,
        c.dy + r * 1.05,
        c.dx - r * 0.15,
        c.dy + r * 0.9,
      )
      ..close();
    final shape = Path.combine(PathOperation.union, body, tail);
    canvas.drawPath(
      shape,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.25, -0.35),
          radius: 0.95,
          colors: [_white, _core, _rim],
          stops: [0, 0.55, 1],
        ).createShader(Rect.fromCircle(center: c, radius: r * 1.1)),
    );
    canvas.drawPath(
      shape,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.018
        ..color = _rim.withValues(alpha: 0.9),
    );
  }

  void _eyes(Canvas canvas, Offset c, double r, double s) {
    final f = face;
    final open = (f.eyeOpen * (1 - blink)).clamp(0.0, 1.0);
    final w = r * 0.26 * f.eyeScale;
    final h = r * 0.36 * f.eyeScale;
    final ovalAlpha = 1 - f.eyeSmile;
    for (final dx in [-0.32, 0.32]) {
      final e = Offset(c.dx + r * (dx + f.gazeX), c.dy + r * (-0.05 + f.gazeY));
      final rect = Rect.fromCenter(center: e, width: w, height: h);
      if (ovalAlpha > 0) {
        final clipped = open < 0.999;
        final lidY = rect.top + (1 - open) * rect.height;
        if (clipped) {
          canvas.save();
          canvas.clipRect(
            Rect.fromLTRB(rect.left - 1, lidY, rect.right + 1, rect.bottom + 1),
          );
        }
        canvas.drawOval(
          rect,
          Paint()..color = _ink.withValues(alpha: ovalAlpha),
        );
        final shine = ((open - 0.45) / 0.55).clamp(0.0, 1.0) * ovalAlpha;
        if (shine > 0) {
          canvas.drawCircle(
            e.translate(-r * 0.04, -r * 0.07),
            r * 0.055,
            Paint()..color = _white.withValues(alpha: shine),
          );
        }
        if (clipped) {
          canvas.restore();
          // Göz kapağının kenarı: yumuşak, aşağı kıvrık yay (kapalı göz
          // "‿" gibi; huzurlu, kızgın değil).
          canvas.drawArc(
            Rect.fromCenter(
              center: Offset(e.dx, lidY - h * 0.08),
              width: w * 1.15,
              height: h * 0.32,
            ),
            0.08 * math.pi,
            0.84 * math.pi,
            false,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round
              ..strokeWidth = s * 0.022
              ..color = _ink.withValues(
                alpha: ((1 - open) * 3).clamp(0.0, 1.0) * ovalAlpha,
              ),
          );
        }
      }
      if (f.eyeSmile > 0) {
        // Gülen göz: "∩" yay.
        canvas.drawArc(
          Rect.fromCenter(
            center: e.translate(0, h * 0.12),
            width: w * 1.15,
            height: h * 0.7,
          ),
          math.pi,
          math.pi,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = s * 0.03
            ..color = _ink.withValues(alpha: f.eyeSmile.clamp(0.0, 1.0)),
        );
      }
    }
  }

  void _mouth(Canvas canvas, Offset c, double r, double s) {
    final f = face;
    final center = c.translate(r * f.mouthShift, r * 0.28);
    final arcAlpha = 1 - f.mouthOpen;
    if (arcAlpha > 0) {
      canvas.drawArc(
        Rect.fromCenter(
          center: center,
          width: r * 0.42 * f.mouthWidth,
          height: r * 0.24 * math.max(f.mouthCurve, 0.12),
        ),
        0.15 * math.pi,
        0.7 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = s * 0.025
          ..color = _ink.withValues(alpha: arcAlpha),
      );
    }
    if (f.mouthOpen > 0) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center.translate(0, r * 0.06),
          width: r * 0.17,
          height: r * 0.21,
        ),
        Paint()..color = _ink.withValues(alpha: f.mouthOpen.clamp(0.0, 1.0)),
      );
    }
  }

  @override
  bool shouldRepaint(HiPainter old) =>
      old.face != face ||
      old.glow != glow ||
      old.blink != blink ||
      old.wave != wave;
}
