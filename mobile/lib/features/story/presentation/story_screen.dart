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

/// Hikâye sekmesi: şimdilik sunucudaki bölümlerin basit listesi.
/// Gerçek Sezon 1 haritası H-035'te gelir.
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
    final ids = switch (kAutoplayMode) {
      'resume1' || 'resume2' => ['A1-001'],
      _ => [for (final p in packages) p.id],
    };
    for (final id in ids) {
      if (kAutoplayMode == 'true') await repo.clearCheckpoint(id);
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
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: packages.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, i) {
        final p = packages[i];
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
            ),
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
      },
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
