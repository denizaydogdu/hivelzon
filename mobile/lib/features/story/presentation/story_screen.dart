import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/widgets/page_header.dart';
import '../../player/application/autoplay_driver.dart';
import '../../player/data/progress_repository.dart';
import '../application/story_providers.dart';
import '../data/season_intro_repository.dart';
import '../domain/season_map.dart';
import 'widgets/episode_sheet.dart';
import 'widgets/season_map_view.dart';

/// Hikâye sekmesi: Sezon 1 haritası (H-035).
///
/// Üstte sayfa başlığı ve tek cümle açıklama (H-053), sezon başlığı, ilerleme
/// ("n / 12") ve "Jeneriği izle"; ortada resimli
/// harita ve 12 bölüm noktası; altta odaktaki bölümün kartı. Tam jenerik sezon
/// ilk kez açılınca bir kez kendiliğinden oynar (H-050).
class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  bool _autoplayStarted = false;

  void _openSheet(MapEpisode e) => EpisodeSheet.show(
    context,
    e,
    onPlay: (id, mode) => openEpisode(context, ref, id, mode: mode),
  );

  @override
  Widget build(BuildContext context) {
    final map = ref.watch(seasonMapProvider);
    if (autoplayEnabled && map.hasValue && !_autoplayStarted) {
      _autoplayStarted = true;
      unawaited(_runAutoplay(map.requireValue));
    }
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: switch (map) {
          AsyncData(:final value) when value.episodes.isEmpty => const _Message(
            icon: Icons.auto_stories_outlined,
            title: StoryTexts.noEpisodesTitle,
            body: StoryTexts.noEpisodesBody,
          ),
          AsyncData(:final value) => _MapBody(
            map: value,
            onNodeTap: _openSheet,
          ),
          AsyncError() => _Message(
            icon: Icons.cloud_off_rounded,
            title: CommonTexts.serverDownTitle,
            body: kDebugMode
                ? '${StoryTexts.mapError} ${CommonTexts.serverDownBody}\n\n'
                      '${CommonTexts.devServerHint}'
                : '${StoryTexts.mapError} ${CommonTexts.serverDownBody}',
            action: FilledButton.icon(
              key: const ValueKey('story-retry'),
              onPressed: () => retrySeasonMap(ref),
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(CommonTexts.retry),
            ),
          ),
          _ => const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: AppSpacing.sm),
                Text(StoryTexts.mapLoading),
              ],
            ),
          ),
        },
      ),
    );
  }

  void _logMap(String tag, SeasonMap m) {
    debugPrint(
      '[H035] $tag ${m.completedCount}/${m.total} '
      '${[for (final e in m.episodes) '${e.number}:${e.state.name}'].join(' ')}',
    );
    for (final e in m.episodes.where((e) => e.access.blockedBy != null)) {
      debugPrint(
        '[H035]   ${e.number} kilit: ${e.access.missing.map((g) => g.code).toList()}',
      );
    }
  }

  /// Doğrulama modu: bölümleri sırayla oynatır, özet yazar.
  Future<void> _runAutoplay(SeasonMap initial) async {
    final repo = ref.read(progressRepositoryProvider);
    debugPrint('[H031][SHOT] list');
    _logMap('harita (açılış)', initial);
    await Future<void>.delayed(const Duration(seconds: 4));
    if (kAutoplayMode == 'h035view') {
      // Yalnızca harita: yeniden açılışta kalıcılığı göstermek için.
      debugPrint('[H035][SHOT] map-view');
      return;
    }
    if (kAutoplayMode == 'h035') {
      // Kilitli bölümün paneli (B2), sonra B1 baştan sona; dönüşte harita.
      if (!mounted) return;
      final b2 = initial.episodes.firstWhere((e) => e.number == 2);
      unawaited(_openSheetForShot(b2));
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      debugPrint('[H035][SHOT] sheet-locked');
      await Future<void>.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      await Future<void>.delayed(const Duration(milliseconds: 800));
    }
    if (kAutoplayMode == 'h050') {
      // Sezonun ilk açılışı: tam jenerik bir kez kendiliğinden oynar.
      final intro = ref.read(seasonIntroRepositoryProvider);
      await intro.forget(1);
      debugPrint('[H031][SHOT] season-header');
      await Future<void>.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      // Jenerik ~10 sn; 9. saniyede sezon adı ekrandadır.
      Timer(
        const Duration(seconds: 9),
        () => debugPrint('[H031][SHOT] season-intro'),
      );
      await _MapHeaderState.autoIntro(context, intro, 1, log: true);
      await Future<void>.delayed(const Duration(milliseconds: 1500));
    }
    final ids = switch (kAutoplayMode) {
      'resume1' || 'resume2' || 'h035' => ['A1-001'],
      'h050' => ['A1-001', 'A1-002'],
      _ => [
        for (final e in initial.episodes)
          if (e.playable || e.access.blockedBy != null) e.contentId,
      ],
    };
    for (final id in ids) {
      if (kAutoplayMode == 'true' || kAutoplayMode == 'h050') {
        await repo.clearCheckpoint(id);
      }
      debugPrint('[H031] AUTOPLAY başla $id');
      if (!mounted) return;
      await context.push(AppRoutes.play(id));
      if (!mounted) return;
      await refreshWhenVisible(context, ref);
      await Future<void>.delayed(const Duration(milliseconds: 800));
    }
    debugPrint('[H031] AUTOPLAY BİTTİ');
    for (final r in autoplayResults) {
      debugPrint('[H031] SONUÇ $r');
    }
    if (!mounted) return;
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      final after = ref.read(seasonMapProvider).value;
      if (after != null) _logMap('harita (dönüş)', after);
      await Future<void>.delayed(const Duration(seconds: 2));
      debugPrint('[H035][SHOT] map-after');
    } on Object catch (e) {
      debugPrint('[H035] harita okunamadı: $e');
    }
  }

  Future<void> _openSheetForShot(MapEpisode e) =>
      EpisodeSheet.show(context, e, onPlay: (_, _) {});
}

class _MapBody extends StatelessWidget {
  const _MapBody({required this.map, required this.onNodeTap});

  final SeasonMap map;
  final ValueChanged<MapEpisode> onNodeTap;

  @override
  Widget build(BuildContext context) {
    final focus = map.focus ?? map.firstComingSoon;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(title: StoryTexts.title, subtitle: StoryTexts.intro),
          const SizedBox(height: AppSpacing.sm),
          _MapHeader(map: map),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              child: SeasonMapView(map: map, onNodeTap: onNodeTap),
            ),
          ),
          if (focus != null) ...[
            const SizedBox(height: AppSpacing.xs),
            _FocusCard(episode: focus, onTap: () => onNodeTap(focus)),
          ],
        ],
      ),
    );
  }
}

/// Sezon başlığı: "Sezon 1 · The Missing Signal", ilerleme ve "Jeneriği izle".
class _MapHeader extends ConsumerStatefulWidget {
  const _MapHeader({required this.map});

  final SeasonMap map;

  @override
  ConsumerState<_MapHeader> createState() => _MapHeaderState();
}

class _MapHeaderState extends ConsumerState<_MapHeader> {
  bool _checked = false;

  /// İzlenmediyse jeneriği açar ve izlendi olarak işaretler.
  static Future<void> autoIntro(
    BuildContext context,
    SeasonIntroRepository repo,
    int season, {
    bool log = false,
  }) async {
    if (await repo.seen(season)) return;
    await repo.markSeen(season);
    if (!context.mounted) return;
    if (log) debugPrint('[H031] sezon jeneriği (ilk açılış) $season');
    await context.push(AppRoutes.seasonIntro(season));
  }

  void _maybeAutoIntro() {
    // Doğrulama modu jeneriği kendisi sürer.
    final info = widget.map.info;
    if (_checked || info?.introVideo == null || autoplayEnabled) return;
    _checked = true;
    final repo = ref.read(seasonIntroRepositoryProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(autoIntro(context, repo, info!.season));
    });
  }

  @override
  Widget build(BuildContext context) {
    _maybeAutoIntro();
    final theme = Theme.of(context);
    final map = widget.map;
    final info = map.info;
    final done = map.completedCount;
    final poster = info?.titlePoster;
    return Container(
      key: ValueKey('season-header-${map.season}'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.xs,
        0,
      ),
      decoration: BoxDecoration(
        color: AppColors.seaBlue,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          if (poster != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ref
                    .watch(contentSourceProvider)
                    .seasonMediaUri(map.season, poster)
                    .toString(),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                cacheWidth: 144,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) =>
                    const SizedBox(width: 48, height: 48),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sezon ${map.season}',
                          style: const TextStyle(
                            color: AppColors.lighthouseYellow,
                          ),
                        ),
                        const TextSpan(text: ' · '),
                        TextSpan(text: map.title),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: map.total == 0 ? 0 : done / map.total,
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          color: AppColors.lighthouseYellow,
                          semanticsLabel: StoryTexts.progressLabel,
                          semanticsValue: StoryTexts.progressSemantics(
                            done,
                            map.total,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      StoryTexts.progress(done, map.total),
                      key: const ValueKey('season-progress'),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (info?.introVideo != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: TextButton.icon(
                            key: ValueKey('season-intro-play-${map.season}'),
                            onPressed: () =>
                                context.push(AppRoutes.seasonIntro(map.season)),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(48, 48),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                              ),
                            ),
                            icon: const Icon(Icons.play_circle_outline_rounded),
                            label: const Text(StoryTexts.watchIntro),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Altta odaktaki bölüm: yarım kalan, sıradaki ya da yakında olan.
class _FocusCard extends StatelessWidget {
  const _FocusCard({required this.episode, required this.onTap});

  final MapEpisode episode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = episode;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        key: const ValueKey('story-focus-card'),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StoryTexts.focusLabel(e.number, e.state.labelTr),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (e.teaser != null)
                        Text(
                          e.teaser!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
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
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(body, textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.md),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
