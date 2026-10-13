/*
 * FSRS-6 zamanlayıcı — Java portu (H-037, K-04).
 *
 * Kaynak: py-fsrs 6.3.2 `fsrs/scheduler.py` (https://github.com/open-spaced-repetition/py-fsrs),
 * MIT Lisansı, Copyright (c) 2022 Open Spaced Repetition. Algoritma satır satır taşındı; optimizer ve
 * torch yolları alınmadı. Mobil Dart portu (mobile/lib/shared/fsrs/fsrs.dart) ile aynı kurallar:
 * - gün farkı tam gün (Python timedelta.days, aşağı yuvarlama);
 * - aralık yuvarlaması Python round() gibi yarımda çifte (banker's rounding);
 * - fuzz yok (istemci ve sunucu aynı sonucu üretsin).
 * Eşdeğerlik: src/test/resources/fsrs/fsrs_vectors.json (py-fsrs çıktısı, 159 inceleme).
 *
 * MIT License text: Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
 * following conditions: The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
 */
package tr.velzon.hivelzon.fsrs;

import java.time.Duration;
import java.time.Instant;
import java.util.List;

/** Durumsuz, iş parçacığı güvenli FSRS-6 zamanlayıcı. */
public final class FsrsScheduler {

    /** py-fsrs 6.3.2 varsayılan ağırlıkları (FSRS-6, 21 parametre). */
    public static final double[] DEFAULT_PARAMETERS = {
            0.212, 1.2931, 2.3065, 8.2956, 6.4133, 0.8334, 3.0194, 0.001, 1.8722, 0.1666, 0.796,
            1.4835, 0.0614, 0.2629, 1.6483, 0.6014, 1.8729, 0.5425, 0.0912, 0.0658, 0.1542};

    private static final double STABILITY_MIN = 0.001;
    private static final double INITIAL_STABILITY_MAX = 100.0;
    private static final double[] LOWER = {
            STABILITY_MIN, STABILITY_MIN, STABILITY_MIN, STABILITY_MIN, 1.0, 0.001, 0.001, 0.001, 0.0, 0.0,
            0.001, 0.001, 0.001, 0.001, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.1};
    private static final double[] UPPER = {
            INITIAL_STABILITY_MAX, INITIAL_STABILITY_MAX, INITIAL_STABILITY_MAX, INITIAL_STABILITY_MAX, 10.0, 4.0,
            4.0, 0.75, 4.5, 0.8, 3.5, 5.0, 0.25, 0.9, 4.0, 1.0, 6.0, 2.0, 2.0, 0.8, 0.8};
    private static final double MIN_DIFFICULTY = 1.0;
    private static final double MAX_DIFFICULTY = 10.0;
    private static final long MICROS_PER_DAY = 86_400_000_000L;

    private final double[] p;
    private final double desiredRetention;
    private final List<Duration> learningSteps;
    private final List<Duration> relearningSteps;
    private final int maximumInterval;
    private final double decay;
    private final double factor;

    public FsrsScheduler(double[] parameters, double desiredRetention, List<Duration> learningSteps,
            List<Duration> relearningSteps, int maximumInterval) {
        if (parameters.length != LOWER.length) {
            throw new IllegalArgumentException("Expected " + LOWER.length + " parameters, got " + parameters.length);
        }
        for (int i = 0; i < parameters.length; i++) {
            if (!(LOWER[i] <= parameters[i] && parameters[i] <= UPPER[i])) {
                throw new IllegalArgumentException("parameters[" + i + "] = " + parameters[i] + " is out of bounds");
            }
        }
        this.p = parameters.clone();
        this.desiredRetention = desiredRetention;
        this.learningSteps = List.copyOf(learningSteps);
        this.relearningSteps = List.copyOf(relearningSteps);
        this.maximumInterval = maximumInterval;
        this.decay = -p[20];
        this.factor = Math.pow(0.9, 1 / decay) - 1;
    }

    /**
     * hiVelzon ayarı (mobil {@code ReviewPolicy.scheduler()} ile aynı): hedef hatırlama 0,90 (K-04), tek
     * öğrenme ve yeniden öğrenme adımı 10 dk, en uzun aralık 36500 gün, fuzz yok.
     */
    public static FsrsScheduler hivelzon() {
        return new FsrsScheduler(DEFAULT_PARAMETERS, 0.90, List.of(Duration.ofMinutes(10)),
                List.of(Duration.ofMinutes(10)), 36500);
    }

    public double desiredRetention() { return desiredRetention; }
    public List<Duration> learningSteps() { return learningSteps; }
    public List<Duration> relearningSteps() { return relearningSteps; }

    /** Verilen anda hatırlama olasılığı (yeni kartta 0). */
    public double retrievability(FsrsCard card, Instant now) {
        if (card.lastReview() == null || card.stability() == null) {
            return 0;
        }
        long elapsed = Math.max(0, days(Duration.between(card.lastReview(), now)));
        return Math.pow(1 + factor * elapsed / card.stability(), decay);
    }

    /** Kartı {@code rating} ile {@code at} anında inceler; yeni durumu döner. */
    public FsrsCard review(FsrsCard card, FsrsRating rating, Instant at) {
        Long daysSince = card.lastReview() == null ? null : days(Duration.between(card.lastReview(), at));
        FsrsState state = card.state();
        Integer step = card.step();
        Double s = card.stability();
        Double d = card.difficulty();
        Duration next;

        switch (state) {
            case LEARNING -> {
                if (step == null) {
                    step = 0;
                }
                if (s == null || d == null) {
                    s = initialStability(rating);
                    d = initialDifficulty(rating, true);
                } else if (daysSince != null && daysSince < 1) {
                    s = shortTermStability(s, rating);
                    d = nextDifficulty(d, rating);
                } else {
                    double r = retrievability(card, at);
                    s = nextStability(d, s, r, rating);
                    d = nextDifficulty(d, rating);
                }
                if (learningSteps.isEmpty() || (step >= learningSteps.size() && rating != FsrsRating.AGAIN)) {
                    state = FsrsState.REVIEW;
                    step = null;
                    next = Duration.ofDays(nextInterval(s));
                } else {
                    switch (rating) {
                        case AGAIN -> {
                            step = 0;
                            next = learningSteps.get(0);
                        }
                        case HARD -> next = hardStep(learningSteps, step);
                        case GOOD -> {
                            if (step + 1 == learningSteps.size()) {
                                state = FsrsState.REVIEW;
                                step = null;
                                next = Duration.ofDays(nextInterval(s));
                            } else {
                                step = step + 1;
                                next = learningSteps.get(step);
                            }
                        }
                        default -> {
                            state = FsrsState.REVIEW;
                            step = null;
                            next = Duration.ofDays(nextInterval(s));
                        }
                    }
                }
            }
            case REVIEW -> {
                if (daysSince != null && daysSince < 1) {
                    s = shortTermStability(s, rating);
                } else {
                    s = nextStability(d, s, retrievability(card, at), rating);
                }
                d = nextDifficulty(d, rating);
                if (rating == FsrsRating.AGAIN && !relearningSteps.isEmpty()) {
                    state = FsrsState.RELEARNING;
                    step = 0;
                    next = relearningSteps.get(0);
                } else {
                    next = Duration.ofDays(nextInterval(s));
                }
            }
            default -> { // RELEARNING
                if (step == null) {
                    step = 0;
                }
                if (daysSince != null && daysSince < 1) {
                    s = shortTermStability(s, rating);
                    d = nextDifficulty(d, rating);
                } else {
                    s = nextStability(d, s, retrievability(card, at), rating);
                    d = nextDifficulty(d, rating);
                }
                if (relearningSteps.isEmpty()
                        || (step >= relearningSteps.size() && rating != FsrsRating.AGAIN)) {
                    state = FsrsState.REVIEW;
                    step = null;
                    next = Duration.ofDays(nextInterval(s));
                } else {
                    switch (rating) {
                        case AGAIN -> {
                            step = 0;
                            next = relearningSteps.get(0);
                        }
                        case HARD -> next = hardStep(relearningSteps, step);
                        case GOOD -> {
                            if (step + 1 == relearningSteps.size()) {
                                state = FsrsState.REVIEW;
                                step = null;
                                next = Duration.ofDays(nextInterval(s));
                            } else {
                                step = step + 1;
                                next = relearningSteps.get(step);
                            }
                        }
                        default -> {
                            state = FsrsState.REVIEW;
                            step = null;
                            next = Duration.ofDays(nextInterval(s));
                        }
                    }
                }
            }
        }
        return new FsrsCard(state, step, s, d, at.plus(next), at);
    }

    private static Duration hardStep(List<Duration> steps, int step) {
        if (step == 0 && steps.size() == 1) {
            return scale(steps.get(0), 1.5);
        }
        if (step == 0 && steps.size() >= 2) {
            return scale(steps.get(0).plus(steps.get(1)), 0.5);
        }
        return steps.get(step);
    }

    /** timedelta * float: mikrosaniyeye yarımda çifte yuvarlanır. */
    private static Duration scale(Duration d, double f) {
        long micros = roundHalfEven(micros(d) * f);
        return Duration.ofNanos(micros * 1000);
    }

    private static long micros(Duration d) {
        return Math.addExact(Math.multiplyExact(d.getSeconds(), 1_000_000L), d.getNano() / 1000);
    }

    /** Python {@code timedelta.days}: aşağı yuvarlanmış gün. */
    static long days(Duration d) {
        return Math.floorDiv(micros(d), MICROS_PER_DAY);
    }

    private static double clampD(double d) {
        return Math.min(Math.max(d, MIN_DIFFICULTY), MAX_DIFFICULTY);
    }

    private static double clampS(double s) {
        return Math.max(s, STABILITY_MIN);
    }

    private double initialStability(FsrsRating r) {
        return clampS(p[r.value() - 1]);
    }

    private double initialDifficulty(FsrsRating r, boolean clamp) {
        double d = p[4] - Math.exp(p[5] * (r.value() - 1)) + 1;
        return clamp ? clampD(d) : d;
    }

    private long nextInterval(double stability) {
        double raw = (stability / factor) * (Math.pow(desiredRetention, 1 / decay) - 1);
        long i = roundHalfEven(raw);
        i = Math.max(i, 1);
        return Math.min(i, maximumInterval);
    }

    private double shortTermStability(double s, FsrsRating r) {
        double inc = Math.exp(p[17] * (r.value() - 3 + p[18])) * Math.pow(s, -p[19]);
        if (r != FsrsRating.AGAIN) {
            inc = Math.max(inc, 1.0);
        }
        return clampS(s * inc);
    }

    private double nextDifficulty(double d, FsrsRating r) {
        double arg1 = initialDifficulty(FsrsRating.EASY, false);
        double delta = -(p[6] * (r.value() - 3));
        double arg2 = d + (10.0 - d) * delta / 9.0;
        return clampD(p[7] * arg1 + (1 - p[7]) * arg2);
    }

    private double nextStability(double d, double s, double r, FsrsRating rating) {
        double next = rating == FsrsRating.AGAIN ? nextForgetStability(d, s, r) : nextRecallStability(d, s, r, rating);
        return clampS(next);
    }

    private double nextForgetStability(double d, double s, double r) {
        double longTerm = p[11] * Math.pow(d, -p[12]) * (Math.pow(s + 1, p[13]) - 1) * Math.exp((1 - r) * p[14]);
        double shortTerm = s / Math.exp(p[17] * p[18]);
        return Math.min(longTerm, shortTerm);
    }

    private double nextRecallStability(double d, double s, double r, FsrsRating rating) {
        double hardPenalty = rating == FsrsRating.HARD ? p[15] : 1.0;
        double easyBonus = rating == FsrsRating.EASY ? p[16] : 1.0;
        return s * (1 + Math.exp(p[8]) * (11 - d) * Math.pow(s, -p[9]) * (Math.exp((1 - r) * p[10]) - 1)
                * hardPenalty * easyBonus);
    }

    /** Python {@code round()} (yarımda çift sayıya). */
    public static long roundHalfEven(double x) {
        double f = Math.floor(x);
        double diff = x - f;
        long fl = (long) f;
        if (diff > 0.5) {
            return fl + 1;
        }
        if (diff < 0.5) {
            return fl;
        }
        return (fl % 2 == 0) ? fl : fl + 1;
    }
}
