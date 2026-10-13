import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/perf/perf_log.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/presentation/notebook_screen.dart';
import '../../profile/application/profile_providers.dart';
import '../../story/application/story_providers.dart';
import '../../story/domain/season_map.dart';

/// Ana Sayfa (H-035, H-036, H-053): selam + iki başlıklı bölüm.
///
/// - **Hikâyen** (birincil, tek öğrenme eylemi): yarım kalan bölüm varsa
///   "Devam et" (kaldığı yerden), yoksa sıradaki bölüm için "Başla".
///   Oynanacak bölüm kalmadıysa sıradakinin "hazırlandığı" sakin bir dille
///   söylenir (tarih ve geri sayım yok).
/// - **Kelime tekrarı** (ikincil): tekrar zamanı gelen ifade sayısı ve tahmini
///   süre; yoksa sakin bir durum cümlesi.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final map = ref.watch(seasonMapProvider);
    final name = ref.watch(displayNameProvider).value;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // Alt boşluk: sağ alttaki Hi balonu son öğeyi örtmesin (H-048).
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm + 80,
          ),
          children: [
            PageHeader(
              title: HomeTexts.greeting(name),
              subtitle: HomeTexts.subtitle,
            ),
            const SizedBox(height: AppSpacing.md),
            const SectionHeading(HomeTexts.storySection),
            const SizedBox(height: AppSpacing.xs),
            switch (map) {
              AsyncData(:final value) => _ContinueCard(map: value),
              AsyncError() => _InfoCard(
                icon: Icons.cloud_off_rounded,
                title: CommonTexts.serverDownTitle,
                body: HomeTexts.storyError,
                action: OutlinedButton.icon(
                  key: const ValueKey('home-retry'),
                  onPressed: () => retrySeasonMap(ref),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 48),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(CommonTexts.retry),
                ),
              ),
              // H-054: spinner yerine kartın iskeleti (yerleşim zıplamaz).
              _ => const ContinueCardSkeleton(label: HomeTexts.storyLoading),
            },
            const SizedBox(height: AppSpacing.md),
            const SectionHeading(HomeTexts.reviewSection),
            const SizedBox(height: AppSpacing.xs),
            // İkincil eylem: hikâye kartından sonra, daha sade (tek öğrenme
            // eylemi ilkesi).
            const _ReviewEntry(),
          ],
        ),
      ),
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
      return _InfoCard(
        key: const ValueKey('home-continue'),
        icon: Icons.auto_stories_outlined,
        title: soon == null
            ? HomeTexts.seasonDone
            : HomeTexts.comingSoon(soon.number),
        body: soon?.teaser ?? HomeTexts.seasonDoneBody,
        action: OutlinedButton(
          onPressed: () => context.go(AppRoutes.story),
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          child: const Text(HomeTexts.goToMap),
        ),
      );
    }
    PerfLog.markAfterFrame('Ana Sayfa hazır');
    final resume = focus.progress.hasCheckpoint;
    final info = map.info;
    final poster = info?.titlePoster;
    final source = ref.watch(contentSourceProvider);
    return Card(
      key: const ValueKey('home-continue'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.seaBlue),
                if (poster != null)
                  Image.network(
                    source.seasonMediaUri(map.season, poster).toString(),
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.2),
                    cacheWidth: 1080,
                    excludeFromSemantics: true,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                // Alt kenarda koyulaşan geçiş: gökyüzü üstündeki etiket okunur kalsın.
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.45, 1],
                        colors: [Colors.transparent, Color(0xB3000000)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Text(
                    HomeTexts.episodeLabel(map.season, focus.number),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.lighthouseYellow,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      shadows: const [
                        Shadow(color: Colors.black87, blurRadius: 6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                Semantics(
                  header: true,
                  child: Text(
                    focus.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (focus.teaser != null) ...[
                  const SizedBox(height: 4),
                  Text(focus.teaser!, style: theme.textTheme.bodyLarge),
                ],
                const SizedBox(height: AppSpacing.xs),
                Text(
                  HomeTexts.seasonProgress(map.completedCount, map.total),
                  key: const ValueKey('home-season-progress'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  key: const ValueKey('home-continue-play'),
                  onPressed: () => openEpisode(
                    context,
                    ref,
                    focus.contentId,
                    mode: resume ? 'resume' : null,
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 48),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
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

/// "Kelime tekrarı" kartı (H-036, H-053): sayı cümle içinde, tahmini süreyle.
/// Tekrar zamanı gelen ifade yoksa sakin bir durum cümlesi; düğme yok.
class _ReviewEntry extends ConsumerWidget {
  const _ReviewEntry();

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
    return Card(
      key: const ValueKey('home-review'),
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        side: BorderSide(color: AppColors.seaBlue.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.style_rounded, color: AppColors.seaBlue),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    text,
                    key: const ValueKey('home-review-text'),
                    style: n > 0
                        ? theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          )
                        : theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            if (n > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                key: const ValueKey('home-review-start'),
                onPressed: () => openReview(context, ref),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(HomeTexts.reviewStart),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (body.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(body),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.sm),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
