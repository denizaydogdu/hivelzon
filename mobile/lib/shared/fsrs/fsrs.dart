// FSRS-6 zamanlayıcı — saf Dart portu (H-036, K-04).
//
// Kaynak: py-fsrs 6.3.2 `fsrs/scheduler.py`
// (https://github.com/open-spaced-repetition/py-fsrs), MIT Lisansı,
// Copyright (c) 2022 Open Spaced Repetition. Algoritma satır satır taşındı;
// optimizer ve torch yolları alınmadı.
//
// Neden paket değil: pub.dev `fsrs` 2.0.1 (dart-fsrs) referanstan geride —
// `_next_difficulty` içinde Easy başlangıç zorluğunu kırpıyor ve Hard için kısa
// vadeli kararlılık alt sınırını uygulamıyor; varsayılan parametreleri de
// eski. Sunucudaki Java portuyla eşdeğerlik (K-04) için referansın kendisi
// taşındı ve `test/fixtures/fsrs_vectors.json` (py-fsrs çıktısı) ile test edilir.
//
// Python ile birebir sonuç için:
// - gün farkı tam gün (`timedelta.days`, aşağı yuvarlama);
// - aralık yuvarlaması Python `round()` gibi yarımda çifte (banker's rounding).

import 'dart:math' as math;

/// py-fsrs 6.3.2 varsayılan ağırlıkları (FSRS-6, 21 parametre).
const List<double> kFsrsDefaultParameters = [
  0.212,
  1.2931,
  2.3065,
  8.2956,
  6.4133,
  0.8334,
  3.0194,
  0.001,
  1.8722,
  0.1666,
  0.796,
  1.4835,
  0.0614,
  0.2629,
  1.6483,
  0.6014,
  1.8729,
  0.5425,
  0.0912,
  0.0658,
  0.1542,
];

const double _stabilityMin = 0.001;
const double _initialStabilityMax = 100.0;
const List<double> _lowerBounds = [
  _stabilityMin,
  _stabilityMin,
  _stabilityMin,
  _stabilityMin,
  1.0,
  0.001,
  0.001,
  0.001,
  0.0,
  0.0,
  0.001,
  0.001,
  0.001,
  0.001,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.1,
];
const List<double> _upperBounds = [
  _initialStabilityMax,
  _initialStabilityMax,
  _initialStabilityMax,
  _initialStabilityMax,
  10.0,
  4.0,
  4.0,
  0.75,
  4.5,
  0.8,
  3.5,
  5.0,
  0.25,
  0.9,
  4.0,
  1.0,
  6.0,
  2.0,
  2.0,
  0.8,
  0.8,
];
const double _minDifficulty = 1.0;
const double _maxDifficulty = 10.0;

enum FsrsState {
  learning(1),
  review(2),
  relearning(3);

  const FsrsState(this.value);

  final int value;

  static FsrsState fromValue(int v) =>
      values.firstWhere((s) => s.value == v, orElse: () => FsrsState.learning);
}

enum FsrsRating {
  again(1),
  hard(2),
  good(3),
  easy(4);

  const FsrsRating(this.value);

  final int value;

  static FsrsRating fromValue(int v) => values.firstWhere((r) => r.value == v);
}

/// Kartın bellek durumu (değişmez). Yeni kart: `learning`, adım 0, S ve D yok.
class FsrsCard {
  const FsrsCard({
    this.state = FsrsState.learning,
    this.step = 0,
    this.stability,
    this.difficulty,
    required this.due,
    this.lastReview,
  });

  factory FsrsCard.newCard(DateTime now) => FsrsCard(due: now.toUtc());

  final FsrsState state;

  /// Öğrenme / yeniden öğrenme adımı; `review` durumunda null.
  final int? step;
  final double? stability;
  final double? difficulty;

  /// UTC.
  final DateTime due;

  /// UTC.
  final DateTime? lastReview;

  bool get isNew => lastReview == null;
}

/// Zamanlayıcı ayarları.
class FsrsScheduler {
  FsrsScheduler({
    List<double> parameters = kFsrsDefaultParameters,
    this.desiredRetention = 0.9,
    this.learningSteps = const [Duration(minutes: 1), Duration(minutes: 10)],
    this.relearningSteps = const [Duration(minutes: 10)],
    this.maximumInterval = 36500,
    this.enableFuzzing = false,
    math.Random? random,
  }) : parameters = List.unmodifiable(parameters),
       _random = random ?? math.Random() {
    _validate(this.parameters);
    _decay = -this.parameters[20];
    _factor = math.pow(0.9, 1 / _decay) - 1;
  }

  final List<double> parameters;
  final double desiredRetention;
  final List<Duration> learningSteps;
  final List<Duration> relearningSteps;
  final int maximumInterval;

  /// Aralıklara küçük rastgele sapma. hiVelzon kapalı tutar (istemci ve
  /// sunucu aynı sonucu üretsin, K-04).
  final bool enableFuzzing;
  final math.Random _random;

  late final double _decay;
  late final double _factor;

  static void _validate(List<double> p) {
    if (p.length != _lowerBounds.length) {
      throw ArgumentError(
        'Expected ${_lowerBounds.length} parameters, got ${p.length}.',
      );
    }
    for (var i = 0; i < p.length; i++) {
      if (!(_lowerBounds[i] <= p[i] && p[i] <= _upperBounds[i])) {
        throw ArgumentError('parameters[$i] = ${p[i]} is out of bounds');
      }
    }
  }

  /// Verilen anda hatırlama olasılığı (yeni kartta 0).
  double retrievability(FsrsCard card, DateTime now) {
    if (card.lastReview == null || card.stability == null) return 0;
    final elapsed = math.max(
      0,
      _days(now.toUtc().difference(card.lastReview!)),
    );
    return math.pow(1 + _factor * elapsed / card.stability!, _decay).toDouble();
  }

  /// Kartı [rating] ile [at] anında inceler; yeni durumu döndürür.
  FsrsCard review(FsrsCard card, FsrsRating rating, DateTime at) {
    if (!at.isUtc) throw ArgumentError('review time must be UTC');
    final daysSince = card.lastReview == null
        ? null
        : _days(at.difference(card.lastReview!));
    var state = card.state;
    int? step = card.step;
    double? s = card.stability;
    double? d = card.difficulty;
    Duration next;

    switch (state) {
      case FsrsState.learning:
        step ??= 0;
        if (s == null || d == null) {
          s = _initialStability(rating);
          d = _initialDifficulty(rating, clamp: true);
        } else if (daysSince != null && daysSince < 1) {
          s = _shortTermStability(s, rating);
          d = _nextDifficulty(d, rating);
        } else {
          final r = retrievability(card, at);
          s = _nextStability(d, s, r, rating);
          d = _nextDifficulty(d, rating);
        }
        if (learningSteps.isEmpty ||
            (step >= learningSteps.length && rating != FsrsRating.again)) {
          state = FsrsState.review;
          step = null;
          next = Duration(days: _nextInterval(s));
        } else {
          switch (rating) {
            case FsrsRating.again:
              step = 0;
              next = learningSteps[0];
            case FsrsRating.hard:
              if (step == 0 && learningSteps.length == 1) {
                next = learningSteps[0] * 1.5;
              } else if (step == 0 && learningSteps.length >= 2) {
                next = (learningSteps[0] + learningSteps[1]) * 0.5;
              } else {
                next = learningSteps[step];
              }
            case FsrsRating.good:
              if (step + 1 == learningSteps.length) {
                state = FsrsState.review;
                step = null;
                next = Duration(days: _nextInterval(s));
              } else {
                step = step + 1;
                next = learningSteps[step];
              }
            case FsrsRating.easy:
              state = FsrsState.review;
              step = null;
              next = Duration(days: _nextInterval(s));
          }
        }

      case FsrsState.review:
        if (daysSince != null && daysSince < 1) {
          s = _shortTermStability(s!, rating);
        } else {
          s = _nextStability(d!, s!, retrievability(card, at), rating);
        }
        d = _nextDifficulty(d!, rating);
        if (rating == FsrsRating.again && relearningSteps.isNotEmpty) {
          state = FsrsState.relearning;
          step = 0;
          next = relearningSteps[0];
        } else {
          next = Duration(days: _nextInterval(s));
        }

      case FsrsState.relearning:
        step ??= 0;
        if (daysSince != null && daysSince < 1) {
          s = _shortTermStability(s!, rating);
          d = _nextDifficulty(d!, rating);
        } else {
          s = _nextStability(d!, s!, retrievability(card, at), rating);
          d = _nextDifficulty(d, rating);
        }
        if (relearningSteps.isEmpty ||
            (step >= relearningSteps.length && rating != FsrsRating.again)) {
          state = FsrsState.review;
          step = null;
          next = Duration(days: _nextInterval(s));
        } else {
          switch (rating) {
            case FsrsRating.again:
              step = 0;
              next = relearningSteps[0];
            case FsrsRating.hard:
              if (step == 0 && relearningSteps.length == 1) {
                next = relearningSteps[0] * 1.5;
              } else if (step == 0 && relearningSteps.length >= 2) {
                next = (relearningSteps[0] + relearningSteps[1]) * 0.5;
              } else {
                next = relearningSteps[step];
              }
            case FsrsRating.good:
              if (step + 1 == relearningSteps.length) {
                state = FsrsState.review;
                step = null;
                next = Duration(days: _nextInterval(s));
              } else {
                step = step + 1;
                next = relearningSteps[step];
              }
            case FsrsRating.easy:
              state = FsrsState.review;
              step = null;
              next = Duration(days: _nextInterval(s));
          }
        }
    }

    if (enableFuzzing && state == FsrsState.review) next = _fuzz(next);
    return FsrsCard(
      state: state,
      step: step,
      stability: s,
      difficulty: d,
      due: at.add(next),
      lastReview: at,
    );
  }

  /// Python `timedelta.days`: aşağı yuvarlanmış gün.
  static int _days(Duration d) =>
      (d.inMicroseconds / Duration.microsecondsPerDay).floor();

  double _clampD(double d) => d.clamp(_minDifficulty, _maxDifficulty);

  double _clampS(double s) => math.max(s, _stabilityMin);

  double _initialStability(FsrsRating r) => _clampS(parameters[r.value - 1]);

  double _initialDifficulty(FsrsRating r, {required bool clamp}) {
    final d = parameters[4] - math.exp(parameters[5] * (r.value - 1)) + 1;
    return clamp ? _clampD(d) : d;
  }

  int _nextInterval(double stability) {
    final raw =
        (stability / _factor) * (math.pow(desiredRetention, 1 / _decay) - 1);
    var i = roundHalfEven(raw);
    i = math.max(i, 1);
    return math.min(i, maximumInterval);
  }

  double _shortTermStability(double s, FsrsRating r) {
    var inc =
        math.exp(parameters[17] * (r.value - 3 + parameters[18])) *
        math.pow(s, -parameters[19]);
    if (r != FsrsRating.again) inc = math.max(inc, 1.0);
    return _clampS(s * inc);
  }

  double _nextDifficulty(double d, FsrsRating r) {
    final arg1 = _initialDifficulty(FsrsRating.easy, clamp: false);
    final delta = -(parameters[6] * (r.value - 3));
    final arg2 = d + (10.0 - d) * delta / 9.0;
    return _clampD(parameters[7] * arg1 + (1 - parameters[7]) * arg2);
  }

  double _nextStability(double d, double s, double r, FsrsRating rating) {
    final next = rating == FsrsRating.again
        ? _nextForgetStability(d, s, r)
        : _nextRecallStability(d, s, r, rating);
    return _clampS(next);
  }

  double _nextForgetStability(double d, double s, double r) {
    final longTerm =
        parameters[11] *
        math.pow(d, -parameters[12]) *
        (math.pow(s + 1, parameters[13]) - 1) *
        math.exp((1 - r) * parameters[14]);
    final shortTerm = s / math.exp(parameters[17] * parameters[18]);
    return math.min(longTerm, shortTerm);
  }

  double _nextRecallStability(double d, double s, double r, FsrsRating rating) {
    final hardPenalty = rating == FsrsRating.hard ? parameters[15] : 1.0;
    final easyBonus = rating == FsrsRating.easy ? parameters[16] : 1.0;
    return s *
        (1 +
            math.exp(parameters[8]) *
                (11 - d) *
                math.pow(s, -parameters[9]) *
                (math.exp((1 - r) * parameters[10]) - 1) *
                hardPenalty *
                easyBonus);
  }

  Duration _fuzz(Duration interval) {
    final days = interval.inDays;
    if (days < 2.5) return interval;
    var delta = 1.0;
    for (final (start, end, factor) in const [
      (2.5, 7.0, 0.15),
      (7.0, 20.0, 0.1),
      (20.0, double.infinity, 0.05),
    ]) {
      delta += factor * math.max(math.min(days.toDouble(), end) - start, 0.0);
    }
    var minIvl = roundHalfEven(days - delta);
    var maxIvl = roundHalfEven(days + delta);
    minIvl = math.max(2, minIvl);
    maxIvl = math.min(maxIvl, maximumInterval);
    minIvl = math.min(minIvl, maxIvl);
    final fuzzed = _random.nextDouble() * (maxIvl - minIvl + 1) + minIvl;
    return Duration(days: math.min(roundHalfEven(fuzzed), maximumInterval));
  }
}

/// Python `round()` (yarımda çift sayıya).
int roundHalfEven(double x) {
  final f = x.floorToDouble();
  final diff = x - f;
  if (diff > 0.5) return f.toInt() + 1;
  if (diff < 0.5) return f.toInt();
  return f.toInt().isEven ? f.toInt() : f.toInt() + 1;
}
