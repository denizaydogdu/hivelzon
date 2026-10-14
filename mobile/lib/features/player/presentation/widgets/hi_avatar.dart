import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/design/tokens.dart';
import '../../../../l10n/tr_strings.dart';
import 'hi_face.dart';
import 'hi_painter.dart';

export 'hi_face.dart' show HiExpression;

/// Hi: yuvarlak, yumuşak ışıklı konuşma balonu ve iki göz (H-005).
///
/// Görsel üretimi yok; tamamen çizimle. İfadeler (H-063) [expression] ile
/// seçilir; ifade değişince gözler, göz kapakları, ağız ve ışık yumuşakça
/// geçer. "Hareketi azalt" açıksa ışık nabzı, nefes ve el sallama durur;
/// ifade değişimi anlık olur.
class HiAvatar extends StatefulWidget {
  const HiAvatar({
    super.key,
    this.size = 96,
    this.glow = true,
    this.pulseCycles,
    this.expression = HiExpression.neutral,
    this.breathe = false,
    this.greet = false,
  });

  final double size;
  final bool glow;

  /// Işık nabzı (ve [breathe] açıksa nefes) döngü sayısı; bir döngü
  /// [idlePeriod]. Birkaç döngüden sonra durur, dikkat dağıtmaz (H-048).
  /// `null` ise sürekli.
  final int? pulseCycles;

  /// Hi'nin ifadesi.
  final HiExpression expression;

  /// Sakin "nefes alma" (H-063): çok hafif büyüyüp küçülme ve arada bir göz
  /// kırpma. Hi balonunda kullanılır.
  final bool breathe;

  /// İlk görünüşte bir kez el sallar, sonra [expression]'a geçer.
  final bool greet;

  /// Bir nefes (ve ışık nabzı) döngüsü: yavaş, sakin.
  static const Duration idlePeriod = Duration(milliseconds: 4800);

  /// El sallama süresi (üç yumuşak salınım).
  static const Duration waveDuration = Duration(milliseconds: 1400);

  /// Nefeste en büyük ölçek artışı (%2,5).
  static const double breathAmplitude = 0.025;

  @override
  State<HiAvatar> createState() => _HiAvatarState();
}

class _HiAvatarState extends State<HiAvatar> with TickerProviderStateMixin {
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: HiAvatar.idlePeriod,
  );
  late final AnimationController _wave =
      AnimationController(vsync: this, duration: HiAvatar.waveDuration)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed && _greeting && mounted) {
            setState(() => _greeting = false);
          }
        });

  bool _started = false;
  bool _ready = false;
  bool _greeting = false;
  bool _reduced = false;

  bool get _idleWanted => widget.glow || widget.breathe;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = AppMotion.reduced(context);
    if (!_ready) {
      _ready = true;
      if (!_reduced &&
          (widget.greet || widget.expression == HiExpression.waving)) {
        _greeting = widget.greet;
        _wave.forward(from: 0);
      }
    }
    if (_reduced) {
      _wave.stop();
      _greeting = false;
    }
    _syncIdle();
  }

  @override
  void didUpdateWidget(HiAvatar old) {
    super.didUpdateWidget(old);
    if (widget.expression == HiExpression.waving &&
        old.expression != HiExpression.waving &&
        !_reduced) {
      _wave.forward(from: 0);
    }
    if (widget.glow != old.glow || widget.breathe != old.breathe) {
      _syncIdle();
    }
  }

  void _syncIdle() {
    if (_reduced || !_idleWanted) {
      _idle.stop();
    } else if (!_idle.isAnimating &&
        !(widget.pulseCycles != null && _started)) {
      _started = true;
      final n = widget.pulseCycles;
      if (n == null) {
        _idle.repeat();
      } else {
        _idle.repeat(count: n);
      }
    }
  }

  @override
  void dispose() {
    _idle.dispose();
    _wave.dispose();
    super.dispose();
  }

  HiExpression get _target =>
      _greeting ? HiExpression.waving : widget.expression;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: PlayerTexts.hiSemantics,
      image: true,
      child: SizedBox.square(
        dimension: widget.size,
        child: TweenAnimationBuilder<HiFace>(
          tween: HiFaceTween(end: HiFace.of(_target)),
          duration: _reduced ? Duration.zero : AppMotion.slow,
          curve: AppMotion.standard,
          builder: (context, face, _) => AnimatedBuilder(
            animation: Listenable.merge([_idle, _wave]),
            builder: (context, _) => _paint(face),
          ),
        ),
      ),
    );
  }

  Widget _paint(HiFace face) {
    final idle = _idle.isAnimating;
    final t = _idle.value;
    // Işık nabzı: 0 → 1 → 0 doğrusal (H-005'teki nabzın aynısı); nefes aynı
    // dalganın yumuşatılmışı (kosinüs).
    final pulse = idle ? (t < 0.5 ? 2 * t : 2 - 2 * t) : 0.0;
    final breath = idle ? 0.5 - 0.5 * math.cos(2 * math.pi * t) : 0.0;
    final glow = widget.glow ? 0.55 + 0.45 * pulse : 0.0;
    var blink = 0.0;
    if (idle && widget.breathe && t > 0.62 && t < 0.7) {
      blink = math.sin(math.pi * (t - 0.62) / 0.08);
    }
    final w = _wave.value;
    final wave = _wave.isAnimating
        ? math.sin(w * 3 * 2 * math.pi) * (1 - w)
        : 0.0;
    Widget child = CustomPaint(
      painter: HiPainter(face: face, glow: glow, blink: blink, wave: wave),
    );
    if (widget.breathe) {
      // Durağanken ölçek 1: çizim nefessiz hâliyle aynıdır.
      child = Transform.scale(
        scale: 1 + HiAvatar.breathAmplitude * breath,
        child: child,
      );
    }
    return child;
  }
}
