import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';

/// Hi'nin ifadeleri (H-063). Hepsi kodla çizilir; görsel dosya yok.
///
/// Sakin ve sıcak kalır: korkutan, suçlayan, üzgün ya da romantik ifade yok
/// (ürün ilkeleri, K-32).
enum HiExpression {
  /// Varsayılan: açık gözler, küçük gülümseme.
  neutral,

  /// Mutlu: gülen gözler, geniş gülümseme, hafif yanak sıcaklığı.
  happy,

  /// Düşünen: gözler yukarı yana bakar, küçük düşünce noktaları.
  thinking,

  /// El sallayan: selamlama (bir kez sallar, sonra el havada kalır).
  waving,

  /// Uykulu: yarı kapalı gözler, küçük "z" (akşam dinlenme önerisi).
  sleepy,

  /// Şaşkın: iri gözler, kaşlar yukarıda, küçük "o" ağız.
  surprised,

  /// Dinleyen: dikkatli bakış, yanda küçük ses dalgaları ("Söyle").
  listening,
}

/// Bir ifadenin çizim değerleri. Değerler arasında yumuşak geçiş için
/// [lerp] kullanılır (göz, göz kapağı, ağız, ışık ve küçük işaretler).
///
/// Uzunluklar balon yarıçapına (r) göre oranlıdır.
class HiFace {
  const HiFace({
    this.eyeOpen = 1,
    this.eyeScale = 1,
    this.eyeSmile = 0,
    this.gazeX = 0,
    this.gazeY = 0,
    this.mouthCurve = 1,
    this.mouthWidth = 1,
    this.mouthOpen = 0,
    this.mouthShift = 0,
    this.glow = 1,
    this.tilt = 0,
    this.brows = 0,
    this.blush = 0,
    this.hand = 0,
    this.thought = 0,
    this.sleep = 0,
    this.waves = 0,
  });

  /// Göz açıklığı (1 açık, 0 kapalı; üst kapak iner).
  final double eyeOpen;

  /// Göz boyu çarpanı.
  final double eyeScale;

  /// Gülen göz ("∩" yay) oranı.
  final double eyeSmile;

  /// Bakış kayması (r oranı).
  final double gazeX;
  final double gazeY;

  /// Gülümsemenin derinliği ve genişliği (1 = varsayılan).
  final double mouthCurve;
  final double mouthWidth;

  /// Küçük "o" ağız oranı.
  final double mouthOpen;

  /// Ağzın yana kayması (r oranı).
  final double mouthShift;

  /// Işık çarpanı.
  final double glow;

  /// Gövde eğimi (radyan).
  final double tilt;

  /// Küçük işaretlerin görünürlüğü (0–1).
  final double brows;
  final double blush;
  final double hand;
  final double thought;
  final double sleep;
  final double waves;

  static const neutral = HiFace();

  static const happy = HiFace(
    eyeSmile: 1,
    mouthCurve: 1.7,
    mouthWidth: 1.25,
    glow: 1.15,
    blush: 1,
  );

  static const thinking = HiFace(
    gazeX: 0.07,
    gazeY: -0.09,
    mouthCurve: 0.35,
    mouthWidth: 0.7,
    mouthShift: 0.08,
    glow: 0.9,
    tilt: -0.06,
    thought: 1,
  );

  static const waving = HiFace(
    eyeSmile: 1,
    mouthCurve: 1.5,
    mouthWidth: 1.15,
    glow: 1.1,
    blush: 0.5,
    hand: 1,
  );

  static const sleepy = HiFace(
    eyeOpen: 0.12,
    gazeY: 0.04,
    mouthCurve: 0.5,
    mouthWidth: 0.7,
    glow: 0.5,
    tilt: 0.05,
    sleep: 1,
  );

  static const surprised = HiFace(
    eyeScale: 1.18,
    gazeY: -0.02,
    mouthOpen: 1,
    glow: 1.1,
    brows: 1,
  );

  static const listening = HiFace(
    eyeScale: 1.06,
    gazeX: 0.05,
    mouthCurve: 0.6,
    mouthWidth: 0.7,
    tilt: 0.06,
    waves: 1,
  );

  static HiFace of(HiExpression e) => switch (e) {
    HiExpression.neutral => neutral,
    HiExpression.happy => happy,
    HiExpression.thinking => thinking,
    HiExpression.waving => waving,
    HiExpression.sleepy => sleepy,
    HiExpression.surprised => surprised,
    HiExpression.listening => listening,
  };

  static HiFace lerp(HiFace a, HiFace b, double t) {
    double l(double x, double y) => lerpDouble(x, y, t)!;
    return HiFace(
      eyeOpen: l(a.eyeOpen, b.eyeOpen),
      eyeScale: l(a.eyeScale, b.eyeScale),
      eyeSmile: l(a.eyeSmile, b.eyeSmile),
      gazeX: l(a.gazeX, b.gazeX),
      gazeY: l(a.gazeY, b.gazeY),
      mouthCurve: l(a.mouthCurve, b.mouthCurve),
      mouthWidth: l(a.mouthWidth, b.mouthWidth),
      mouthOpen: l(a.mouthOpen, b.mouthOpen),
      mouthShift: l(a.mouthShift, b.mouthShift),
      glow: l(a.glow, b.glow),
      tilt: l(a.tilt, b.tilt),
      brows: l(a.brows, b.brows),
      blush: l(a.blush, b.blush),
      hand: l(a.hand, b.hand),
      thought: l(a.thought, b.thought),
      sleep: l(a.sleep, b.sleep),
      waves: l(a.waves, b.waves),
    );
  }

  List<double> get _values => [
    eyeOpen,
    eyeScale,
    eyeSmile,
    gazeX,
    gazeY,
    mouthCurve,
    mouthWidth,
    mouthOpen,
    mouthShift,
    glow,
    tilt,
    brows,
    blush,
    hand,
    thought,
    sleep,
    waves,
  ];

  @override
  bool operator ==(Object other) {
    if (other is! HiFace) return false;
    final a = _values, b = other._values;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_values);
}

/// [HiFace] değerleri arasında geçiş (örtük animasyon için).
class HiFaceTween extends Tween<HiFace> {
  HiFaceTween({super.begin, super.end});

  @override
  HiFace lerp(double t) => HiFace.lerp(begin!, end!, t);
}
