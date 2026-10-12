import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../shared/content/content_providers.dart';
import '../../story/application/story_providers.dart';
import '../../story/domain/season_map.dart';

/// Ana Sayfa: tek öğrenme eylemi — "Hikâyeye devam" kartı (H-035, §11.2).
///
/// Yarım kalan bölüm varsa "Devam et" (kaldığı yerden), yoksa sıradaki bölüm
/// için "Başla". Oynanacak bölüm kalmadıysa sıradaki bölümün "yakında" olduğu
/// sakin bir dille söylenir (tarih ve geri sayım yok).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final map = ref.watch(seasonMapProvider);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.sm),
          children: [
            Text(
              'Merhaba',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            switch (map) {
              AsyncData(:final value) => _ContinueCard(map: value),
              AsyncError() => _InfoCard(
                icon: Icons.cloud_off_rounded,
                title: 'Sunucu çalışmıyor',
                body: 'Hikâye yüklenemedi.',
                action: OutlinedButton.icon(
                  key: const ValueKey('home-retry'),
                  onPressed: () => retrySeasonMap(ref),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 48),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Tekrar dene'),
                ),
              ),
              _ => const _InfoCard(
                icon: Icons.hourglass_empty_rounded,
                title: 'Hikâye yükleniyor…',
                body: '',
                loading: true,
              ),
            },
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
            ? 'Sezonu bitirdin'
            : 'Bölüm ${soon.number} hazırlanıyor',
        body: soon?.teaser ?? 'Bölümleri haritadan yeniden oynayabilirsin.',
        action: OutlinedButton(
          onPressed: () => context.go(AppRoutes.story),
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          child: const Text('Haritaya git'),
        ),
      );
    }
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
            aspectRatio: 16 / 9,
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
                    'SEZON ${map.season} · BÖLÜM ${focus.number}',
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
                Text(
                  'HİKÂYEYE DEVAM',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
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
                  label: Text(resume ? 'Devam et' : 'Başla'),
                ),
              ],
            ),
          ),
        ],
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
    this.loading = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;
  final bool loading;

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
                if (loading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                else
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
