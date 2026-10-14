import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../../shared/progress/story_progress.dart';
import '../../hi/application/hi_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/domain/review_policy.dart';
import '../../story/application/story_providers.dart';

/// Bölümün tahmini süresi yoksa (K-27: bölüm 5–8 dk).
const int kDefaultEpisodeMinutes = 6;

/// Bir tekrar cevabında sayılan en uzun süre (kart açık bırakılıp
/// unutulduysa süre şişmesin).
const Duration kMaxReviewAnswerTime = Duration(minutes: 2);

/// Ana Sayfa günlük hedef halkası (H-060).
///
/// **Yeni kayıt tutulmaz.** Bugünkü süre, cihazda zaten olan kayıtlardan
/// **tahmin edilir**: bugün biten bölümlerin tahmini süresi
/// (`estimatedMinutes`, yoksa 6 dk) + bugünkü tekrar cevaplarında geçen süre
/// (`review_logs.durationMs`, cevap başına en çok 2 dk). Yarım bırakılan
/// bölümde geçen süre sayılmaz.
class TodayActivity {
  const TodayActivity({required this.minutes, required this.goalMinutes});

  static const empty = TodayActivity(
    minutes: 0,
    goalMinutes: ReviewPolicy.defaultDailyGoalMinutes,
  );

  /// Bugün yaklaşık kaç dakika (yukarı yuvarlanır).
  final int minutes;

  /// Günlük hedef (5 / 10 / 15 dk, H-013).
  final int goalMinutes;

  /// Halkanın doluluğu (0–1; hedef aşılınca dolu kalır).
  double get progress =>
      goalMinutes <= 0 ? 0 : (minutes / goalMinutes).clamp(0.0, 1.0);
}

/// Saf hesap: [episodeMinutes] bugün biten bölümlerin tahmini süresi (null:
/// bilinmiyor), [reviewTimes] bugünkü tekrar cevaplarında geçen süreler.
/// Tekrar süresi dakikaya yukarı yuvarlanır.
int estimateTodayMinutes({
  required Iterable<int?> episodeMinutes,
  Iterable<Duration> reviewTimes = const [],
}) {
  final episodes = episodeMinutes.fold<int>(
    0,
    (sum, m) => sum + (m ?? kDefaultEpisodeMinutes),
  );
  final ms = reviewTimes.fold<int>(
    0,
    (sum, d) =>
        sum +
        (d.isNegative
            ? 0
            : (d > kMaxReviewAnswerTime ? kMaxReviewAnswerTime : d)
                  .inMilliseconds),
  );
  return episodes + (ms / Duration.millisecondsPerMinute).ceil();
}

/// Bugünün yerel günü içinde mi ([from], [to] UTC)?
bool _today(DateTime? t, DateTime from, DateTime to) =>
    t != null && !t.toUtc().isBefore(from) && t.toUtc().isBefore(to);

/// Bugünkü etkinlik (H-060). İlerleme, paket listesi ve tekrar özeti
/// yenilenince (oynatıcıdan ya da tekrardan dönüş, eşitleme) yeniden
/// hesaplanır. Hata Ana Sayfa'yı durdurmaz: halka boş görünür.
final todayActivityProvider = FutureProvider.autoDispose<TodayActivity>((
  ref,
) async {
  final store = ref.watch(hiStoreProvider);

  var goal = ReviewPolicy.defaultDailyGoalMinutes;
  try {
    goal = await ref.watch(dailyGoalProvider.future);
  } on Object catch (e) {
    debugPrint('[H060] günlük hedef okunamadı: $e');
  }
  final now = DateTime.now().toUtc();
  final (from, to) = localDayBounds(now);

  var progress = const <String, StoryProgress>{};
  try {
    progress = await ref.watch(storyProgressProvider.future);
  } on Object catch (e) {
    debugPrint('[H060] ilerleme okunamadı: $e');
  }
  var packages = const <PackageSummary>[];
  try {
    packages = await ref.watch(packageListProvider.future);
  } on Object {
    // Sunucuya ulaşılamıyorsa bölüm süresi varsayılandır.
  }
  final estimated = {
    for (final p in packages)
      if (p.estimatedMinutes != null) p.id: p.estimatedMinutes!.round(),
  };

  var reviewTimes = const <Duration>[];
  try {
    // Tekrar özeti önce eşitlenir (biten bölümün ifadeleri deftere geçer).
    await ref.watch(reviewOverviewProvider.future);
    reviewTimes = [
      for (final (at, time) in await store.reviewTimeSince(from))
        if (_today(at, from, to)) time,
    ];
  } on Object catch (e) {
    debugPrint('[H060] tekrar kayıtları okunamadı: $e');
  }

  final minutes = estimateTodayMinutes(
    episodeMinutes: [
      for (final p in progress.values)
        if (p.status == StoryStatus.completed &&
            _today(p.completedAt, from, to))
          estimated[p.contentId],
    ],
    reviewTimes: reviewTimes,
  );
  return TodayActivity(minutes: minutes, goalMinutes: goal);
}, retry: (_, _) => null);
