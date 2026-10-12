import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../player/application/autoplay_driver.dart';
import '../../player/data/progress_repository.dart';
import '../data/season_intro_repository.dart';

/// Hikâye sekmesi: şimdilik sunucudaki bölümlerin basit listesi.
/// Gerçek Sezon 1 haritası H-035'te gelir.
///
/// Listenin başında sezon başlığı ve "Jeneriği izle" vardır. Tam jenerik,
/// sezon ilk kez açılınca bir kez kendiliğinden oynar (H-050).
class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  bool _autoplayStarted = false;

  @override
  Widget build(BuildContext context) {
    final packages = ref.watch(packageListProvider);
    if (autoplayEnabled && packages.hasValue && !_autoplayStarted) {
      _autoplayStarted = true;
      unawaited(_runAutoplay(packages.requireValue));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Hikâye')),
      body: switch (packages) {
        AsyncData(:final value) when value.isEmpty => const _Message(
          icon: Icons.auto_stories_outlined,
          title: 'Henüz bölüm yok',
          body: 'Yeni bölümler hazır olunca burada görünecek.',
        ),
        AsyncData(:final value) => _EpisodeList(packages: value),
        AsyncError() => _Message(
          icon: Icons.cloud_off_rounded,
          title: 'Sunucu çalışmıyor',
          body:
              'Bölümler yüklenemedi. Yerel içerik sunucusunu başlatıp '
              'tekrar dene:\npython3 tools/dev-content-server/serve.py',
          action: FilledButton.icon(
            key: const ValueKey('story-retry'),
            onPressed: () => ref.invalidate(packageListProvider),
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tekrar dene'),
          ),
        ),
        _ => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: AppSpacing.sm),
              Text('Bölümler yükleniyor…'),
            ],
          ),
        ),
      },
    );
  }

  /// Doğrulama modu: bütün bölümleri sırayla oynatır, özet yazar.
  Future<void> _runAutoplay(List<PackageSummary> packages) async {
    final repo = ref.read(progressRepositoryProvider);
    debugPrint('[H031][SHOT] list');
    await Future<void>.delayed(const Duration(seconds: 4));
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
      await _SeasonHeaderState.autoIntro(context, intro, 1, log: true);
      await Future<void>.delayed(const Duration(milliseconds: 1500));
    }
    final ids = switch (kAutoplayMode) {
      'resume1' || 'resume2' => ['A1-001'],
      'h050' => ['A1-001', 'A1-002'],
      _ => [for (final p in packages) p.id],
    };
    for (final id in ids) {
      if (kAutoplayMode == 'true' || kAutoplayMode == 'h050') {
        await repo.clearCheckpoint(id);
      }
      debugPrint('[H031] AUTOPLAY başla $id');
      if (!mounted) return;
      await context.push(AppRoutes.play(id));
      await Future<void>.delayed(const Duration(milliseconds: 800));
    }
    debugPrint('[H031] AUTOPLAY BİTTİ');
    for (final r in autoplayResults) {
      debugPrint('[H031] SONUÇ $r');
    }
  }
}

class _EpisodeList extends StatelessWidget {
  const _EpisodeList({required this.packages});

  final List<PackageSummary> packages;

  @override
  Widget build(BuildContext context) {
    final seasons = [
      ...{for (final p in packages) ?p.season},
    ]..sort();
    final items = <Widget>[
      for (final season in seasons) ...[
        _SeasonHeader(season: season, autoIntro: season == seasons.first),
        for (final (i, p) in packages.indexed)
          if (p.season == season) _EpisodeTile(package: p, index: i),
      ],
      for (final (i, p) in packages.indexed)
        if (p.season == null) _EpisodeTile(package: p, index: i),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, i) => items[i],
    );
  }
}

/// Sezon başlığı: sezon adı ve "Jeneriği izle" (H-050). Sezon paketi
/// yüklenemezse görünmez (bölüm listesi yine çalışır).
class _SeasonHeader extends ConsumerStatefulWidget {
  const _SeasonHeader({required this.season, required this.autoIntro});

  final int season;

  /// Sezon ilk kez açıldıysa tam jenerik kendiliğinden oynar.
  final bool autoIntro;

  @override
  ConsumerState<_SeasonHeader> createState() => _SeasonHeaderState();
}

class _SeasonHeaderState extends ConsumerState<_SeasonHeader> {
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
    if (_checked || !widget.autoIntro || autoplayEnabled) return;
    _checked = true;
    final repo = ref.read(seasonIntroRepositoryProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(autoIntro(context, repo, widget.season));
    });
  }

  @override
  Widget build(BuildContext context) {
    final season = ref.watch(seasonProvider(widget.season));
    final info = season.value;
    if (info == null) return const SizedBox.shrink();
    _maybeAutoIntro();
    final theme = Theme.of(context);
    return Container(
      key: ValueKey('season-header-${widget.season}'),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.seaBlue,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SEZON ${info.season}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.lighthouseYellow,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Semantics(
            header: true,
            child: Text(
              info.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (info.introVideo != null) ...[
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              key: ValueKey('season-intro-play-${info.season}'),
              onPressed: () => context.push(AppRoutes.seasonIntro(info.season)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(48, 48),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Jeneriği izle'),
            ),
          ],
        ],
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({required this.package, required this.index});

  final PackageSummary package;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = package;
    final i = index;
    final subtitle = [
      if (p.season != null && p.number != null)
        'Sezon ${p.season} · Bölüm ${p.number}',
      if (p.level != null) p.level!,
      if (p.estimatedMinutes != null) '~${p.estimatedMinutes!.round()} dk',
    ].join(' · ');
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        key: ValueKey('episode-${p.id}'),
        minVerticalPadding: AppSpacing.sm,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        leading: CircleAvatar(
          backgroundColor: AppColors.seaBlue,
          foregroundColor: Colors.white,
          child: Text('${p.number ?? i + 1}'),
        ),
        title: Text(
          p.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.play_circle_fill_rounded,
          color: AppColors.lighthouseYellow,
          size: 40,
          semanticLabel: 'Oynat',
        ),
        onTap: () => context.push(AppRoutes.play(p.id)),
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
