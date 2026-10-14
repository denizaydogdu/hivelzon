import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../library/presentation/library_view.dart';
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

  /// Bağlantı kurulamadığında (H-058 illüstrasyonu).
  static const errorImage = AssetImage(
    'assets/illustrations/baglanti-yok.webp',
  );

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  bool _autoplayStarted = false;

  /// "Macera" (harita) ya da "Kitaplık" (H-067).
  StorySection _section = StorySection.adventure;

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
    final header = _StoryHeader(
      section: _section,
      onChanged: (s) => setState(() => _section = s),
    );
    if (_section == StorySection.library) {
      return Scaffold(
        body: SafeArea(bottom: false, child: LibraryView(header: header)),
      );
    }
    final top = Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s8,
        AppSpace.page,
        0,
      ),
      child: header,
    );
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, c) {
            // Kısa ekranda (ya da büyük yazıda) başlık ve bölüm seçici
            // haritayla birlikte kayar; harita yine ekran boyu yer alır.
            if (c.maxHeight >= _scrollBelow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  top,
                  Expanded(child: _adventure(map)),
                ],
              );
            }
            return SingleChildScrollView(
              key: const ValueKey('story-scroll'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  top,
                  SizedBox(height: c.maxHeight, child: _adventure(map)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Bu yükseklikten kısa ekranda Hikâye sayfası kayar.
  static const double _scrollBelow = 600;

  Widget _adventure(AsyncValue<SeasonMap> map) {
    return switch (map) {
      AsyncData(:final value) when value.episodes.isEmpty => const _Message(
        icon: Icons.auto_stories_outlined,
        title: StoryTexts.noEpisodesTitle,
        body: StoryTexts.noEpisodesBody,
      ),
      AsyncData(:final value) => _MapBody(map: value, onNodeTap: _openSheet),
      AsyncError() => _Message(
        illustration: StoryScreen.errorImage,
        title: CommonTexts.serverDownTitle,
        body: kDebugMode
            ? '${StoryTexts.mapError} ${CommonTexts.serverDownBody}\n\n'
                  '${CommonTexts.devServerHint}'
            : '${StoryTexts.mapError} ${CommonTexts.serverDownBody}',
        action: FilledButton.icon(
          key: const ValueKey('story-retry'),
          onPressed: () => retrySeasonMap(ref),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text(CommonTexts.retry),
        ),
      ),
      // H-054: spinner yerine haritanın iskeleti.
      _ => const MapSkeleton(label: StoryTexts.mapLoading),
    };
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
      'resume1' || 'resume2' || 'h035' || 'h055' => ['A1-001'],
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
    // Alt güvenli alan Hi balonunun payını da içerir (ShellScaffold, H-055):
    // odak kartı balonun altında kalmaz.
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s12,
        AppSpace.page,
        AppSpace.s8 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeSlideIn(child: _MapHeader(map: map)),
          const SizedBox(height: AppSpace.s12),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: AppRadius.lgAll,
                boxShadow: AppShadows.level1,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.lgAll,
                child: SeasonMapView(map: map, onNodeTap: onNodeTap),
              ),
            ),
          ),
          if (focus != null) ...[
            const SizedBox(height: AppSpace.s12),
            FadeSlideIn(
              index: 1,
              child: _FocusCard(episode: focus, onTap: () => onNodeTap(focus)),
            ),
          ],
        ],
      ),
    );
  }
}

enum StorySection { adventure, library }

/// Sayfa başlığı ve "Macera · Kitaplık" seçici (H-067; sekme sayısı
/// değişmez, K-30).
class _StoryHeader extends StatelessWidget {
  const _StoryHeader({required this.section, required this.onChanged});

  final StorySection section;
  final ValueChanged<StorySection> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget label(String text) =>
        Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: StoryTexts.title,
          subtitle: section == StorySection.adventure
              ? StoryTexts.intro
              : LibraryTexts.intro,
        ),
        const SizedBox(height: AppSpace.s12),
        Semantics(
          container: true,
          label: LibraryTexts.segmentsLabel,
          child: SegmentedButton<StorySection>(
            key: const ValueKey('story-sections'),
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: StorySection.adventure,
                icon: const Icon(Icons.map_outlined),
                label: label(LibraryTexts.segmentAdventure),
              ),
              ButtonSegment(
                value: StorySection.library,
                icon: const Icon(Icons.auto_stories_outlined),
                label: label(LibraryTexts.segmentLibrary),
              ),
            ],
            selected: {section},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ),
      ],
    );
  }
}

/// Sezon başlık kartı (H-060, taslak S08): deniz mavisi kart, fener
/// küçük resmi, "Sezon 1 · The Missing Signal", sarı ilerleme çubuğu ve
/// "Jeneriği izle".
class _MapHeader extends ConsumerStatefulWidget {
  const _MapHeader({required this.map});

  final SeasonMap map;

  @override
  ConsumerState<_MapHeader> createState() => _MapHeaderState();
}

class _MapHeaderState extends ConsumerState<_MapHeader> {
  bool _checked = false;

  static const double _thumb = 56;

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

  /// Tek satır metnin genişliği (yazı büyütme dahil).
  static double _textWidth(BuildContext context, String text, TextStyle? st) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: st),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final w = tp.width;
    tp.dispose();
    return w;
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
    final thumbFallback = Container(
      width: _thumb,
      height: _thumb,
      color: AppPalette.seaBlue700,
      alignment: Alignment.center,
      child: const Icon(
        Icons.flare_rounded,
        color: AppPalette.lighthouseYellow,
        size: AppIconSize.lg,
      ),
    );
    return Container(
      key: ValueKey('season-header-${map.season}'),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppPalette.seaBlue,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.level2,
      ),
      child: Stack(
        children: [
          // Fener ışığı gibi sakin süs (sağ üst).
          Positioned(
            right: -AppSpace.s48,
            top: -AppSpace.s64,
            child: ExcludeSemantics(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPalette.lighthouseYellow.withValues(alpha: 0.16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.s12,
              AppSpace.s12,
              AppSpace.s12,
              AppSpace.s4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.mdAll,
                      child: poster == null
                          ? thumbFallback
                          : Image.network(
                              ref
                                  .watch(contentSourceProvider)
                                  .seasonMediaUri(map.season, poster)
                                  .toString(),
                              width: _thumb,
                              height: _thumb,
                              fit: BoxFit.cover,
                              cacheWidth: 168,
                              excludeFromSemantics: true,
                              errorBuilder: (_, _, _) => thumbFallback,
                            ),
                    ),
                    const SizedBox(width: AppSpace.s12),
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sezon ${map.season}',
                                style: const TextStyle(
                                  color: AppPalette.lighthouseYellow,
                                ),
                              ),
                              const TextSpan(text: ' · '),
                              TextSpan(text: map.title),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppPalette.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                LayoutBuilder(
                  builder: (context, c) {
                    final progressRow = Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            child: LinearProgressIndicator(
                              value: map.total == 0 ? 0 : done / map.total,
                              minHeight: AppSpace.s8,
                              backgroundColor: AppPalette.white.withValues(
                                alpha: 0.2,
                              ),
                              color: AppPalette.lighthouseYellow,
                              semanticsLabel: StoryTexts.progressLabel,
                              semanticsValue: StoryTexts.progressSemantics(
                                done,
                                map.total,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpace.s8),
                        Text(
                          StoryTexts.progress(done, map.total),
                          key: const ValueKey('season-progress'),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppPalette.white,
                            fontWeight: AppFonts.bold,
                          ),
                        ),
                      ],
                    );
                    if (info?.introVideo == null) {
                      return SizedBox(height: AppTouch.min, child: progressRow);
                    }
                    final intro = OutlinedButton.icon(
                      key: ValueKey('season-intro-play-${map.season}'),
                      onPressed: () =>
                          context.push(AppRoutes.seasonIntro(map.season)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppPalette.white,
                        side: BorderSide(
                          color: AppPalette.white.withValues(alpha: 0.7),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpace.s12,
                        ),
                      ),
                      icon: const Icon(Icons.play_circle_outline_rounded),
                      label: const Text(StoryTexts.watchIntro),
                    );
                    // Sığmazsa (dar ekran, büyük yazı) düğme alt satıra
                    // iner; dokunma alanı küçülmez.
                    final countStyle = theme.textTheme.titleSmall?.copyWith(
                      fontWeight: AppFonts.bold,
                    );
                    final need =
                        _textWidth(
                          context,
                          StoryTexts.progress(done, map.total),
                          countStyle,
                        ) +
                        _textWidth(
                          context,
                          StoryTexts.watchIntro,
                          AppTypography.button,
                        ) +
                        // Düğme: ikon + boşluklar; çubuk için en az 64 px.
                        AppIconSize.md +
                        AppSpace.s24 +
                        AppSpace.s8 +
                        AppSpace.s8 +
                        AppSpace.s12 +
                        AppSpace.s64;
                    if (c.maxWidth >= need) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpace.s8,
                          bottom: AppSpace.s8,
                        ),
                        child: Row(
                          children: [
                            Expanded(child: progressRow),
                            const SizedBox(width: AppSpace.s12),
                            intro,
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpace.s12,
                        bottom: AppSpace.s8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          progressRow,
                          const SizedBox(height: AppSpace.s8),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: intro,
                          ),
                        ],
                      ),
                    );
                  },
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
    final colors = mapNodeColors(e.state);
    return TappableCard(
      key: const ValueKey('story-focus-card'),
      elevated: true,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpace.s12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpace.s48),
        child: Row(
          children: [
            ExcludeSemantics(
              child: Container(
                width: AppSpace.s48,
                height: AppSpace.s48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.fill,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppPalette.seaBlue100, width: 3),
                ),
                child: Text(
                  '${e.number}',
                  style: theme.textTheme.titleLarge?.copyWith(color: colors.fg),
                ),
              ),
            ),
            const SizedBox(width: AppSpace.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StoryTexts.focusLabel(e.number, e.state.labelTr),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppPalette.orange700,
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpace.s4),
                  Text(e.title, style: theme.textTheme.titleMedium),
                  if (e.teaser != null)
                    Text(
                      e.teaser!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppPalette.ink500,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppPalette.seaBlue),
          ],
        ),
      ),
    );
  }
}

/// Boş ve hata durumu (H-060: ortak [EmptyState]).
class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    required this.body,
    this.icon,
    this.illustration,
    this.action,
  });

  final IconData? icon;
  final ImageProvider? illustration;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: EmptyState(
          icon: icon,
          illustration: illustration == null
              ? null
              : Image(image: illustration!, fit: BoxFit.contain),
          title: title,
          message: body,
          action: action,
        ),
      ),
    );
  }
}
