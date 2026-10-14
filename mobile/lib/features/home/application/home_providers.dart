import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/activity/active_time_meter.dart';
import '../../../shared/activity/study_clock.dart';
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

/// Ana Sayfa günlük hedef halkası (H-060, H-074).
///
/// Bugünkü süre **cihazda ölçülür** (H-074, `daily_activity`): oynatıcı,
/// kelime tekrarı, konu seti ve sahne avı, kitap okuyucu ve dilbilgisi dersi
/// ön plandayken geçen etkin süre ([StudyClock]). Yarım bırakılan bölüm de
/// sayılır; arka planda ve uzun süre dokunulmadan geçen süre sayılmaz.
///
/// **Geçiş:** ölçüm başlamadan önceki etkinlik (aynı gün, güncellemeden
/// önce) eski tahminle sayılır: biten bölümün tahmini süresi
/// (`estimatedMinutes`, yoksa 6 dk) + tekrar cevaplarında geçen süre
/// (`review_logs.durationMs`, cevap başına en çok 2 dk). Aynı süre iki kez
/// sayılmaz: tahmin yalnız ölçümün başladığı andan öncekini kapsar.
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

/// Saf hesap: [measured] bugün ölçülen süre (H-074); [episodeMinutes] ve
/// [reviewTimes] ölçüm başlamadan önceki etkinliğin tahmini (geçiş): biten
/// bölümlerin tahmini süresi (null: bilinmiyor) ve tekrar cevaplarında geçen
/// süreler. Ölçülen ve tekrar süresi birlikte dakikaya yukarı yuvarlanır.
int estimateTodayMinutes({
  Iterable<int?> episodeMinutes = const [],
  Iterable<Duration> reviewTimes = const [],
  Duration measured = Duration.zero,
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
  final total = ms + (measured.isNegative ? 0 : measured.inMilliseconds);
  return episodes + (total / Duration.millisecondsPerMinute).ceil();
}

/// Bugünün yerel günü içinde mi ([from], [to] UTC)?
bool _today(DateTime? t, DateTime from, DateTime to) =>
    t != null && !t.toUtc().isBefore(from) && t.toUtc().isBefore(to);

/// [t], ölçüm başlamadan önce mi ([since] yoksa ölçüm hiç başlamadı: her şey
/// tahminle sayılır)?
bool _beforeMeasuring(DateTime? t, DateTime? since) =>
    since == null || (t != null && t.toUtc().isBefore(since));

/// Bugünkü etkinlik (H-060, H-074). Ölçülen süre yazılınca ([StudyClock]),
/// ilerleme, paket listesi ya da tekrar özeti yenilenince (oynatıcıdan ya da
/// tekrardan dönüş, eşitleme) yeniden hesaplanır. Hata Ana Sayfa'yı
/// durdurmaz: halka boş görünür.
final todayActivityProvider = FutureProvider.autoDispose<TodayActivity>((
  ref,
) async {
  final store = ref.watch(hiStoreProvider);
  final activity = ref.watch(dailyActivityStoreProvider);
  final clock = ref.watch(studyClockProvider);
  void onMeasured() => ref.invalidateSelf();
  clock.addListener(onMeasured);
  ref.onDispose(() => clock.removeListener(onMeasured));

  var goal = ReviewPolicy.defaultDailyGoalMinutes;
  try {
    goal = await ref.watch(dailyGoalProvider.future);
  } on Object catch (e) {
    debugPrint('[H060] günlük hedef okunamadı: $e');
  }
  final now = DateTime.now().toUtc();
  final (from, to) = localDayBounds(now);

  var measured = Duration.zero;
  DateTime? since;
  try {
    measured = Duration(seconds: await activity.secondsOn(localDayKey(now)));
    since = await activity.measuredSince();
  } on Object catch (e) {
    debugPrint('[H074] ölçülen süre okunamadı: $e');
  }

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
        if (_today(at, from, to) && _beforeMeasuring(at, since)) time,
    ];
  } on Object catch (e) {
    debugPrint('[H060] tekrar kayıtları okunamadı: $e');
  }

  final minutes = estimateTodayMinutes(
    episodeMinutes: [
      for (final p in progress.values)
        if (p.status == StoryStatus.completed &&
            _today(p.completedAt, from, to) &&
            _beforeMeasuring(p.completedAt, since))
          estimated[p.contentId],
    ],
    reviewTimes: reviewTimes,
    measured: measured,
  );
  return TodayActivity(minutes: minutes, goalMinutes: goal);
}, retry: (_, _) => null);
