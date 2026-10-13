import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Hi: yuvarlak, yumuşak ışıklı konuşma balonu ve iki göz (H-005).
///
/// Görsel üretimi yok; tamamen çizimle. Hareket azaltma açıksa nabız durur.
class HiAvatar extends StatefulWidget {
  const HiAvatar({
    super.key,
    this.size = 96,
    this.glow = true,
    this.pulseCycles,
  });

  final double size;
  final bool glow;

  /// Nabız sayısı (H-048 balonu: birkaç nabızdan sonra durur, dikkat
  /// dağıtmaz); `null` ise sürekli.
  final int? pulseCycles;

  @override
  State<HiAvatar> createState() => _HiAvatarState();
}

class _HiAvatarState extends State<HiAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce || !widget.glow) {
      _pulse.stop();
    } else if (!_pulse.isAnimating &&
        !(widget.pulseCycles != null && _started)) {
      _started = true;
      final n = widget.pulseCycles;
      if (n == null) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse.repeat(reverse: true, count: n * 2);
      }
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Hi, yapay zekâ yardımcın',
      image: true,
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) => CustomPaint(
            painter: _HiPainter(
              glow: widget.glow ? 0.55 + 0.45 * _pulse.value : 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _HiPainter extends CustomPainter {
  _HiPainter({required this.glow});

  final double glow;

  static const _core = Color(0xFFFFF4C9);
  static const _rim = Color(0xFF7FD8E8);
  static const _eye = Color(0xFF1F4E79);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = Offset(size.width / 2, size.height * 0.46);
    final r = s * 0.36;

    if (glow > 0) {
      canvas.drawCircle(
        c,
        r * 1.18,
        Paint()
          ..color = _rim.withValues(alpha: 0.45 * glow)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.08),
      );
    }

    // Balon gövdesi + kuyruk.
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
        ..shader = RadialGradient(
          center: const Alignment(-0.25, -0.35),
          radius: 0.95,
          colors: const [Colors.white, _core, _rim],
          stops: const [0, 0.55, 1],
        ).createShader(Rect.fromCircle(center: c, radius: r * 1.1)),
    );
    canvas.drawPath(
      shape,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.018
        ..color = _rim.withValues(alpha: 0.9),
    );

    // Gözler.
    for (final dx in [-0.32, 0.32]) {
      final e = Offset(c.dx + r * dx, c.dy - r * 0.05);
      canvas.drawOval(
        Rect.fromCenter(center: e, width: r * 0.26, height: r * 0.36),
        Paint()..color = _eye,
      );
      canvas.drawCircle(
        e.translate(-r * 0.04, -r * 0.07),
        r * 0.055,
        Paint()..color = Colors.white,
      );
    }

    // Küçük gülümseme.
    canvas.drawArc(
      Rect.fromCenter(
        center: c.translate(0, r * 0.28),
        width: r * 0.42,
        height: r * 0.24,
      ),
      0.15 * math.pi,
      0.7 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = s * 0.025
        ..color = _eye,
    );
  }

  @override
  bool shouldRepaint(_HiPainter old) => old.glow != glow;
}
