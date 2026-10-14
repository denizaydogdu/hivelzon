import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/perf/perf_log.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../account/presentation/account_widgets.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/presentation/notebook_screen.dart';
import '../../profile/application/profile_providers.dart';
import '../../story/application/story_providers.dart';
import '../../story/domain/season_map.dart';
import '../application/home_providers.dart';

/// Ana Sayfa (H-035, H-036, H-053; tasarım H-060, taslak S07).
///
/// - Üstte selam ve **günlük hedef halkası** (bugün yaklaşık kaç dakika;
///   [todayActivityProvider]).
/// - **Hikâyen** (birincil, tek öğrenme eylemi): görselli bölüm kartı; yarım
///   kalan bölüm varsa "Devam et" (kaldığı yerden), yoksa sıradaki bölüm için
///   "Başla". Oynanacak bölüm kalmadıysa sıradakinin "hazırlandığı" sakin bir
///   dille söylenir (tarih ve geri sayım yok).
/// - **Kelime tekrarı** (ikincil, çerçeve düğmesi): tekrar zamanı gelen ifade
///   sayısı ve tahmini süre; yoksa sakin bir durum cümlesi.
/// - Ara sıra hesap kartı (H-038).
///
/// Bölümler sırayla belirir; "Hareketi azalt" açıksa durağandır.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final map = ref.watch(seasonMapProvider);
    final name = ref.watch(displayNameProvider).value;
    final today = ref.watch(todayActivityProvider).value;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // Hi balonunun payı alt güvenli alanda (ShellScaffold, H-055).
          padding: const EdgeInsets.fromLTRB(
            AppSpace.page,
            AppSpace.s16,
            AppSpace.page,
            AppSpace.s32,
          ),
          children: [
            StaggeredList(
              spacing: AppSpace.s24,
              children: [
                _Greeting(name: name, today: today ?? TodayActivity.empty),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SectionHeading(HomeTexts.storySection),
                    const SizedBox(height: AppSpace.s8),
                    switch (map) {
                      AsyncData(:final value) => _ContinueCard(map: value),
                      AsyncError() => InfoCard(
                        icon: Icons.cloud_off_rounded,
                        title: CommonTexts.serverDownTitle,
                        body: HomeTexts.storyError,
                        action: OutlinedButton.icon(
                          key: const ValueKey('home-retry'),
                          onPressed: () => retrySeasonMap(ref),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text(CommonTexts.retry),
                        ),
                      ),
                      // H-054: spinner yerine kartın iskeleti.
                      _ => const ContinueCardSkeleton(
                        label: HomeTexts.storyLoading,
                      ),
                    },
                  ],
                ),
                // İkincil eylem: hikâye kartından sonra, daha sade (tek
                // öğrenme eylemi ilkesi).
                const _ReviewCard(),
                // H-038: hesap yoksa ara sıra, kapatılabilir; hiçbir şeyi
                // engellemez.
                const AccountNudgeCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Selam + tek cümle + günlük hedef halkası ("6/10 dk").
class _Greeting extends StatelessWidget {
  const _Greeting({required this.name, required this.today});

  final String? name;
  final TodayActivity today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  HomeTexts.greeting(name),
                  key: const ValueKey('page-title'),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppPalette.seaBlue,
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.s4),
              Text(
                HomeTexts.subtitle,
                key: const ValueKey('page-subtitle'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppPalette.ink500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpace.s12),
        ProgressRing(
          key: const ValueKey('home-goal-ring'),
          value: today.progress,
          size: 76,
          semanticLabel: HomeTexts.goalSemantics(
            today.minutes,
            today.goalMinutes,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.s12),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        HomeTexts.goalRing(today.minutes, today.goalMinutes),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppPalette.ink,
                        ),
                      ),
                      if (HomeTexts.goalReached(
                        today.minutes,
                        today.goalMinutes,
                      ))
                        const Icon(
                          Icons.check_rounded,
                          key: ValueKey('home-goal-done'),
                          size: AppIconSize.sm,
                          color: AppPalette.seaBlue,
                        ),
                    ],
                  ),
                  Text(
                    HomeTexts.goalUnit,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppPalette.ink500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContinueCard extends ConsumerWidget {
  const _ContinueCard({required this.map});

  final SeasonMap map;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final focus = map.focus;
    if (focus == null) {
      final soon = map.firstComingSoon;
      return InfoCard(
        key: const ValueKey('home-continue'),
        icon: Icons.auto_stories_outlined,
        title: soon == null
            ? HomeTexts.seasonDone
            : HomeTexts.comingSoon(soon.number),
        body: soon?.teaser ?? HomeTexts.seasonDoneBody,
        action: OutlinedButton.icon(
          onPressed: () => context.go(AppRoutes.story),
          icon: const Icon(Icons.map_outlined),
          label: const Text(HomeTexts.goToMap),
        ),
      );
    }
    PerfLog.markAfterFrame('Ana Sayfa hazır');
    final resume = focus.progress.hasCheckpoint;
    final poster = map.info?.titlePoster;
    final source = ref.watch(contentSourceProvider);
    final done = map.completedCount;
    return Container(
      key: const ValueKey('home-continue'),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 2 / 1,
            child: ClipPath(
              clipper: const ShapedEdgeClipper(HeaderShape.wave),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const _HeroBackdrop(),
                  if (poster != null)
                    Image.network(
                      source.seasonMediaUri(map.season, poster).toString(),
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.2),
                      cacheWidth: 1080,
                      excludeFromSemantics: true,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.s16,
              AppSpace.s4,
              AppSpace.s16,
              AppSpace.s16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CapsLabel(
                    HomeTexts.episodeLabel(map.season, focus.number),
                  ),
                ),
                const SizedBox(height: AppSpace.s4),
                Semantics(
                  header: true,
                  child: Text(
                    focus.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppPalette.ink,
                    ),
                  ),
                ),
                if (focus.teaser != null) ...[
                  const SizedBox(height: AppSpace.s4),
                  Text(
                    focus.teaser!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppPalette.ink700,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpace.s16),
                Text(
                  HomeTexts.seasonProgress(done, map.total),
                  key: const ValueKey('home-season-progress'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink500,
                  ),
                ),
                const SizedBox(height: AppSpace.s8),
                ExcludeSemantics(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: map.total == 0 ? 0 : done / map.total),
                      duration: AppMotion.of(context, AppMotion.slow),
                      curve: AppMotion.enter,
                      builder: (_, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: AppSpace.s8,
                        color: AppPalette.lighthouseYellow,
                        backgroundColor: AppPalette.sand200,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.s16),
                FilledButton.icon(
                  key: const ValueKey('home-continue-play'),
                  onPressed: () => openEpisode(
                    context,
                    ref,
                    focus.contentId,
                    mode: resume ? 'resume' : null,
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppTouch.primary),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(resume ? HomeTexts.resume : HomeTexts.play),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bölüm görseli yokken ya da yüklenirken: akşam göğü ve fener ışığı.
class _HeroBackdrop extends StatelessWidget {
  const _HeroBackdrop();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppPalette.seaBlue900, AppPalette.seaBlue],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -AppSpace.s32,
              top: -AppSpace.s32,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPalette.lighthouseYellow.withValues(alpha: 0.22),
                ),
              ),
            ),
            const Positioned(
              right: AppSpace.s32,
              top: AppSpace.s24,
              child: Icon(
                Icons.flare_rounded,
                color: AppPalette.lighthouseYellow,
                size: AppIconSize.xl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Kelime tekrarı" kartı (H-036, H-053; tasarım H-060): sayı cümle içinde,
/// tahmini süreyle. Tekrar zamanı gelen ifade yoksa sakin bir durum cümlesi;
/// düğme yok.
class _ReviewCard extends ConsumerWidget {
  const _ReviewCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(reviewOverviewProvider);
    final theme = Theme.of(context);
    final o = overview.value;
    final n = o?.sessionCount ?? 0;
    final String text;
    if (o == null) {
      text = HomeTexts.reviewLoading;
    } else if (n > 0) {
      text = HomeTexts.reviewDue(n, HomeTexts.reviewMinutes(n));
    } else if (o.totalItems == 0) {
      text = HomeTexts.reviewEmpty;
    } else {
      text = HomeTexts.reviewNone;
    }
    return Container(
      key: const ValueKey('home-review'),
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.level1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Container(
              width: AppSpace.s48,
              height: AppSpace.s48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: n > 0 ? AppPalette.yellow100 : AppPalette.seaBlue50,
              ),
              child: Icon(
                Icons.style_rounded,
                color: n > 0 ? AppPalette.orange700 : AppPalette.seaBlue,
              ),
            ),
          ),
          const SizedBox(width: AppSpace.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    HomeTexts.reviewSection,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppPalette.ink,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.s4),
                Text(
                  text,
                  key: const ValueKey('home-review-text'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink700,
                  ),
                ),
                if (n > 0) ...[
                  const SizedBox(height: AppSpace.s12),
                  OutlinedButton.icon(
                    key: const ValueKey('home-review-start'),
                    onPressed: () => openReview(context, ref),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text(HomeTexts.reviewStart),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
