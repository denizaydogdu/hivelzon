import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/meaning/meaning_controller.dart';
import '../../../shared/meaning/meaning_sheet.dart';
import '../../../shared/meaning/meaning_text.dart';
import '../../../shared/meaning/notebook_repository.dart';
import '../../../shared/speech/speech_providers.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../grammar/application/grammar_providers.dart';
import '../../grammar/presentation/grammar_lesson_screen.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/domain/notebook_item.dart';
import '../../player/domain/subtitles.dart';
import '../../player/presentation/player_screen.dart'
    show AiNotice, videoControllerFactoryProvider;
import '../../speak/speak_env.dart';
import '../../story/application/story_providers.dart';
import '../application/clip_controllers.dart';
import '../application/discover_providers.dart';
import '../application/feed_videos.dart';
import '../data/discover_store.dart';
import '../domain/clip.dart';
import '../domain/feed.dart';
import '../domain/feed_video.dart';
import '../domain/reel.dart';
import '../domain/reel_progress.dart';
import 'widgets/feed_cards.dart';
import 'widgets/interests_section.dart';
import 'widgets/video_page.dart';

/// Keşfet (H-040, K-15; günlük üç video H-094).
///
/// Üstte seviye çipi ve kaynak çipleri:
/// - **Bugün** (varsayılan): seviyeye uygun **günlük üç bağımsız video**;
///   her videonun sonunda atlanabilir tek soru, sonda sakin bitiş.
/// - **Sinema · Spor · Kitap**: o kategori + seviyedeki havuz, sonunda bitiş.
/// - **Hikâye klipleri**: mevcut `clips.json` akışı (quiz/mola kartları ve
///   bölüm kilitleri korunur) — **ayrı kaynak** (plan §4).
///
/// - Sonsuz kaydırma yok; akış biter.
/// - 13–17 (ve 13 altı) için günlük 20 dk; yalnızca dolunca söylenir.
/// - Aynı anda en çok 3 video denetleyicisi.
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chip = ref.watch(discoverChipProvider);
    final Widget body;
    final String title;
    if (chip == DiscoverChip.storyClips) {
      title = DiscoverTexts.storyClipsTitle;
      body = const _StoryClipsBody();
    } else {
      final set = ref.watch(reelSetProvider);
      final loaded = switch (set) {
        AsyncData(value: final s) => s,
        _ => null,
      };
      title = switch ((chip, loaded)) {
        (DiscoverChip.today, final s?) => DiscoverTexts.dailyTitle(
          s.reels.isEmpty ? kDailyReelCount : s.reels.length,
        ),
        (_, _) =>
          chip.categoryCode == null
              ? DiscoverTexts.dailyTitle(kDailyReelCount)
              : DiscoverTexts.poolTitle(_chipLabel(chip)),
      };
      body = switch (set) {
        AsyncError() => _Message(
          key: const ValueKey('reels-error'),
          icon: Icons.cloud_off_rounded,
          title: DiscoverTexts.errorTitle,
          body: DiscoverTexts.errorBody,
          action: FilledButton(
            key: const ValueKey('reels-retry'),
            style: AppButtonStyles.primary(),
            onPressed: () => retryReels(ref),
            child: const Text(CommonTexts.retry),
          ),
        ),
        AsyncData(value: final s) when s.reels.isEmpty => _Message(
          key: const ValueKey('reels-empty'),
          icon: Icons.explore_outlined,
          title: DiscoverTexts.poolEmptyTitle,
          body: DiscoverTexts.poolEmptyBody,
          action: chip == DiscoverChip.today
              ? FilledButton(
                  key: const ValueKey('reels-story-clips'),
                  style: AppButtonStyles.primary(),
                  onPressed: () => ref
                      .read(discoverChipProvider.notifier)
                      .select(DiscoverChip.storyClips),
                  child: const Text(DiscoverTexts.chipStoryClips),
                )
              : FilledButton(
                  key: const ValueKey('reels-today'),
                  style: AppButtonStyles.primary(),
                  onPressed: () => ref
                      .read(discoverChipProvider.notifier)
                      .select(DiscoverChip.today),
                  child: const Text(DiscoverTexts.poolEmptyToday),
                ),
        ),
        AsyncData(value: final s) => _ReelFeed(set: s),
        _ => const _Loading(),
      };
    }
    return Scaffold(
      backgroundColor: AppPalette.sand,
      body: Semantics(
        label: DiscoverTexts.screenSemantics,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Column(
            children: [
              _DiscoverHeader(chip: chip, title: title),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

/// Çipin görünen adı (Sinema · Spor · Kitap).
String _chipLabel(DiscoverChip chip) =>
    kReelCategoryTr[chip.categoryCode] ?? DiscoverTexts.chipToday;

/// Keşfet üst şeridi (H-094, plan §3): başlık, seviye çipi ve kaynak çipleri.
/// Kaydırma yönü dikey kalır; şerit videonun üstünde sabit durur.
class _DiscoverHeader extends ConsumerWidget {
  const _DiscoverHeader({required this.chip, required this.title});

  final DiscoverChip chip;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(reelLevelProvider);
    final pad = MediaQuery.paddingOf(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppPalette.sand,
        border: Border(bottom: BorderSide(color: AppPalette.ink100)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpace.s16,
          pad.top + AppSpace.s8,
          AppSpace.s16,
          AppSpace.s8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık ve seviye çipi aynı satırda: başlık kalan yeri alır, çip
            // en fazla satırın %45'i kadar olur (taşma yok; çok büyük yazıda
            // çip kısalır, başlık her zaman okunur).
            LayoutBuilder(
              builder: (context, box) {
                final compact = box.maxWidth < _kLevelChipFullWidth;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        key: const ValueKey('discover-title'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppPalette.seaBlue),
                      ),
                    ),
                    const SizedBox(width: AppSpace.s8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: box.maxWidth * _kLevelChipMaxShare,
                      ),
                      child: _LevelChip(
                        level: level,
                        compact: compact,
                        onTap: () => unawaited(_openLevelPanel(context, ref)),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpace.s8),
            // Kaynak çipleri yatay kaydırılır (küçük ekranda da taşmaz).
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  for (final c in DiscoverChip.values) ...[
                    if (c != DiscoverChip.values.first)
                      const SizedBox(width: AppSpace.s8),
                    _ChipButton(
                      key: ValueKey('chip-${c.name}'),
                      label: c == DiscoverChip.storyClips
                          ? DiscoverTexts.chipStoryClips
                          : c == DiscoverChip.today
                          ? DiscoverTexts.chipToday
                          : _chipLabel(c),
                      selected: c == chip,
                      onTap: () =>
                          ref.read(discoverChipProvider.notifier).select(c),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bu genişliğin altında seviye çipi kısa biçimde yazılır ("Seviye: A1 ▾");
/// tam metinle birlikte başlığa yer kalmıyor.
const double _kLevelChipFullWidth = 560;

/// Seviye çipi en fazla satırın bu kadarını alır (başlık önce gelir).
const double _kLevelChipMaxShare = 0.45;

/// Tamamlanma eşiği (plan §5): video **aktif oynatılırken** süresinin bu
/// kadarını geçtiyse bitirilmiş sayılır. Aynı iki saniyeyi döndürmek eşiğe
/// ulaşmadığı için tamamlanma sayılmaz.
const double _kReelCompletion = 0.9;

/// Tamamlanmanın ikinci koşulu (H-096): bu açılışta **aktif oynatılan**
/// saniyeler sürenin en az bu kadarı olmalı. Konum %90'a atlarsa (ileri sarma,
/// son parçaya geçiş) kısa bir izleme tamamlanma sayılmaz. %80, saniyelik
/// sayaç ve ilk karenin yüklenme payı için %90'ın altında tutuldu.
const double _kReelActiveShare = 0.8;

/// Seviye çipi: "Senin seviyen: A1 · Değiştir" (dar ekranda "A1 · Değiştir";
/// yalnız Keşfet zorluğu; K-06).
class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.level,
    required this.onTap,
    this.compact = false,
  });

  final String level;
  final VoidCallback onTap;

  /// Dar ekranda kısa etiket.
  final bool compact;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: DiscoverTexts.levelChipLevelSemantics(level),
    excludeSemantics: true,
    child: PressScale(
      child: Material(
        color: AppPalette.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.full)),
          side: BorderSide(color: AppPalette.ink200),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const ValueKey('level-chip'),
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppTouch.min),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      compact
                          ? DiscoverTexts.levelChipShort(level)
                          : DiscoverTexts.levelChip(level),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppPalette.seaBlue,
                      ),
                    ),
                  ),
                  if (compact)
                    Icon(
                      Icons.expand_more_rounded,
                      size: 18,
                      color: AppPalette.seaBlue.withValues(alpha: 0.8),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Kaynak çipi (seçili: fener sarısı).
class _ChipButton extends StatelessWidget {
  const _ChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: label,
    excludeSemantics: true,
    child: PressScale(
      child: Material(
        color: selected ? AppPalette.lighthouseYellow : AppPalette.white,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
          side: BorderSide(
            color: selected ? AppPalette.lighthouseYellow : AppPalette.ink200,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppTouch.min),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s16),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? AppPalette.ink : AppPalette.seaBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Seviye paneli (plan §3): önerilen seviye (gerçekten varsa) + elle seçim +
/// seçimi geri alma. Genel yerleştirme sonucu değişmez.
Future<void> _openLevelPanel(BuildContext context, WidgetRef ref) async {
  final level = ref.read(reelLevelProvider);
  final levels = await ref
      .read(reelLevelsProvider.future)
      .catchError((Object _) => <String>[level]);
  final placement = await ref
      .read(reelPlacementLevelProvider.future)
      .catchError((Object _) => null);
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppPalette.sand,
    // H-043: "Hareketi azalt" açıksa panel anında açılır/kapanır.
    sheetAnimationStyle: AppMotion.sheet(context),
    // İlgi alanları bölümüyle panel uzar: içerik kadar yükselir, kısa
    // ekranda kaydırılır.
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _LevelPanel(
      level: level,
      levels: levels,
      placement: placement,
      onPick: (picked) async {
        await ref.read(reelLevelChoiceProvider.notifier).choose(picked);
      },
      onReset: () async {
        await ref.read(reelLevelChoiceProvider.notifier).choose(null);
      },
    ),
  );
}

class _LevelPanel extends StatelessWidget {
  const _LevelPanel({
    required this.level,
    required this.levels,
    required this.placement,
    required this.onPick,
    required this.onReset,
  });

  final String level;
  final List<String> levels;

  /// Yerleştirmenin önerisi; katalogda yoksa `null` (o zaman "önerilen
  /// seviyem" denmez — K-06).
  final String? placement;
  final Future<void> Function(String level) onPick;
  final Future<void> Function() onReset;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final placement = this.placement;
    // Seçim kaldırılınca dönülecek seviye: öneri varsa o, yoksa eldeki ilk.
    final fallback = placement ?? (levels.isEmpty ? level : levels.first);
    return SafeArea(
      // Uzun metin/çok seviye: panel kısa ekranda kaydırılabilir kalır.
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CapsLabel(DiscoverTexts.levelPanelTitle),
              const SizedBox(height: AppSpace.s8),
              Text(
                DiscoverTexts.levelPanelBody,
                style: t.bodyMedium?.copyWith(color: AppPalette.ink700),
              ),
              if (placement == null) ...[
                const SizedBox(height: AppSpace.s8),
                Text(
                  DiscoverTexts.levelPanelNoMatch,
                  style: t.bodyMedium?.copyWith(color: AppPalette.ink700),
                ),
              ],
              const SizedBox(height: AppSpace.s16),
              for (final l in levels) ...[
                Semantics(
                  button: true,
                  selected: l == level,
                  label: l == placement
                      ? '${DiscoverTexts.recommendedLevel(l)}. '
                            '${l == level ? '' : 'Seç'}'
                      : 'Seviye $l${l == level ? ', seçili' : ''}',
                  excludeSemantics: true,
                  child: OutlinedButton(
                    key: ValueKey('level-option-$l'),
                    style: AppButtonStyles.secondary(),
                    onPressed: () async {
                      await onPick(l);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: Text(
                      l == placement ? DiscoverTexts.recommendedLevel(l) : l,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.s8),
              ],
              if (level != fallback) ...[
                const SizedBox(height: AppSpace.s8),
                FilledButton(
                  key: const ValueKey('level-reset'),
                  style: AppButtonStyles.primary(),
                  onPressed: () async {
                    await onReset();
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: Text(
                    placement != null
                        ? DiscoverTexts.backToRecommended
                        : DiscoverTexts.levelPanelClear,
                  ),
                ),
              ],
              const SizedBox(height: AppSpace.s24),
              const DiscoverInterestsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Hikâye klipleri" çipi: mevcut `clips.json` akışı (H-040). Bölüm kilitleri
/// ve spoiler koruması burada kalır; quiz ve mola kartları korunur.
class _StoryClipsBody extends ConsumerWidget {
  const _StoryClipsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clips = ref.watch(discoverClipsProvider);
    // H-043: sınır okunamazsa güvenli taraf (20 dk); iskelet sonsuz kalmaz.
    final safe = discoverLimitOrSafe(ref.watch(discoverLimitProvider));
    final AsyncValue<DiscoverLimit> limit = safe == null
        ? const AsyncLoading()
        : AsyncData(safe);
    return switch ((clips, limit)) {
      (AsyncError(), _) => _Message(
        key: const ValueKey('discover-error'),
        icon: Icons.cloud_off_rounded,
        title: DiscoverTexts.errorTitle,
        body: DiscoverTexts.errorBody,
        action: FilledButton(
          key: const ValueKey('discover-retry'),
          style: AppButtonStyles.primary(),
          onPressed: () => retryDiscover(ref),
          child: const Text(CommonTexts.retry),
        ),
      ),
      (AsyncData(value: final c), AsyncData())
          when c == null || c.clips.isEmpty =>
        _Message(
          key: const ValueKey('discover-empty'),
          icon: Icons.explore_outlined,
          title: DiscoverTexts.emptyTitle,
          body: DiscoverTexts.emptyBody,
          action: FilledButton(
            key: const ValueKey('discover-go-story'),
            style: AppButtonStyles.primary(),
            onPressed: () => context.go(AppRoutes.story),
            child: const Text(DiscoverTexts.goStory),
          ),
        ),
      (AsyncData(value: final c?), AsyncData(value: final l)) => DiscoverFeed(
        key: const ValueKey('discover-feed-clips'),
        videos: [
          for (final clip in c.clips)
            feedVideoOfClip(clip, ref.watch(contentSourceProvider)),
        ],
        entries: buildFeed(c.clips),
        aiLabel: c.aiLabel,
        moreLocked: c.hasLocked,
        limit: l,
      ),
      _ => const _Loading(),
    };
  }
}

/// Günlük set (Bugün) ya da kategori havuzu: **bağımsız reeller** (H-094).
class _ReelFeed extends ConsumerWidget {
  const _ReelFeed({required this.set});

  final ReelSet set;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // H-043: sınır okunamazsa güvenli taraf (20 dk); iskelet sonsuz kalmaz.
    final limit = discoverLimitOrSafe(ref.watch(discoverLimitProvider));
    if (limit == null) return const _Loading();
    final source = ref.watch(contentSourceProvider);
    final videos = [
      for (final reel in set.reels)
        feedVideoOfReel(reel, source, repeat: set.repeats.contains(reel.id)),
    ];
    final daily = set.chip == DiscoverChip.today;
    final entries = buildDailyFeed(videos);
    // Aynı gün kalınan yer (plan §5): yalnız günlük sette, seçkiyle aynı anda
    // okunur; bulunamazsa baştan.
    final resumeId = daily ? set.resumeId : null;
    final at = resumeId == null
        ? -1
        : entries.indexWhere((e) => e is VideoEntry && e.video.id == resumeId);
    return DiscoverFeed(
      // Çip, seviye ya da ilgi alanları değişince set baştan başlar (açık
      // bir başlangıç; plan §5). Katalog yenilenip seçkideki videolar
      // değişirse (geri çekme, yedek) akış yeniden kurulur ve kalınan yerden
      // açılır (H-096).
      key: ValueKey(
        'discover-reels-${set.chip.name}-${set.level}-'
        '${set.categories.join('.')}-'
        '${[for (final r in set.reels) '${r.id}@${r.contentVersion}'].join('.')}',
      ),
      videos: videos,
      entries: entries,
      initialIndex: at < 0 ? 0 : at,
      aiLabel: kDefaultAiLabel,
      moreLocked: false,
      limit: limit,
      // "Hikâye kliplerine bak" yalnız günlük sette: kategori havuzu zaten
      // havuzun kendisi (bitişte yönlendirme zorlanmaz; plan §3).
      daily: daily,
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => Skeleton(
    key: const ValueKey('discover-loading'),
    label: DiscoverTexts.loading,
    child: Padding(
      // Güvenli alanı üst şerit taşır.
      padding: EdgeInsets.fromLTRB(
        AppSpace.s16,
        AppSpace.s16,
        AppSpace.s16,
        MediaQuery.paddingOf(context).bottom + AppSpace.s16,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bone(width: 88, height: 28),
          SizedBox(height: AppSpace.s8),
          _Bone(width: 200, height: 24),
          Spacer(),
          _Bone(width: double.infinity, height: 48),
          SizedBox(height: AppSpace.s8),
          _Bone(width: double.infinity, height: 72),
        ],
      ),
    ),
  );
}

class _Bone extends StatelessWidget {
  const _Bone({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: const BoxDecoration(
      color: AppScrim.chip,
      borderRadius: AppRadius.mdAll,
    ),
  );
}

class _Message extends StatelessWidget {
  const _Message({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget action;

  @override
  Widget build(BuildContext context) => FeedCardFrame(
    child: EmptyState(icon: icon, title: title, message: body, action: action),
  );
}

/// Akışın kendisi: sayfalar, video denetleyicileri, süre sayacı.
class DiscoverFeed extends ConsumerStatefulWidget {
  const DiscoverFeed({
    super.key,
    required this.videos,
    required this.entries,
    required this.aiLabel,
    required this.moreLocked,
    required this.limit,
    this.daily = false,
    this.initialIndex = 0,
  });

  /// Akıştaki videolar (sırayla): önbellek anahtarı ve adres çözümü buradan
  /// gelir; kaynak türü (klip/reel) videonun kendisiyle taşınır.
  final List<FeedVideo> videos;

  /// Sayfalar: kliplerde `buildFeed`, günlük sette `buildDailyFeed`.
  final List<FeedEntry> entries;

  final String aiLabel;
  final bool moreLocked;
  final DiscoverLimit limit;

  /// Günlük set mi (sakin bitiş ve mini soru kartları).
  final bool daily;

  /// Açılış sayfası: günlük sette aynı gün kalınan yer (plan §5); 0 = baştan.
  final int initialIndex;

  @override
  ConsumerState<DiscoverFeed> createState() => DiscoverFeedState();
}

class DiscoverFeedState extends ConsumerState<DiscoverFeed>
    with WidgetsBindingObserver {
  late final List<FeedEntry> feed = widget.entries;

  /// Önbellek anahtarı → tam adres (klip: sezon paketi, reel: `/reels/`).
  late final Map<String, Uri> _uris = {
    for (final v in widget.videos) v.cacheKey: v.mediaUri,
  };

  /// Hikâye klibi girdisi → video modeli (klip kimliğiyle).
  late final Map<String, FeedVideo> _clips = {
    for (final v in widget.videos)
      if (!v.isReel) v.id: v,
  };

  /// Açılış sayfası (günlük sette kalınan yer); aralık dışıysa baştan.
  late final int _initial =
      widget.initialIndex < 0 || widget.initialIndex >= feed.length
      ? 0
      : widget.initialIndex;
  late final PageController _pages = PageController(initialPage: _initial);

  late final ClipControllerCache cache;
  late int _index = _initial;
  bool _muted = false;
  bool _visible = true;
  bool _foreground = true;
  bool _sheetOpen = false;
  bool _away = false; // bölüm ya da ders açık
  bool _limitReached = false;
  bool _limitLoaded = false;
  int _watched = 0; // bugün kaydedilen saniye
  int _pending = 0; // henüz yazılmamış saniye
  Timer? _tick;
  ValueListenable<bool>? _tickerMode;
  final Set<String> _savedKeys = {};
  int _savedCount = 0;
  int _activation = 0;
  late final DiscoverStore _store;
  late final DateTime Function() _clock;
  late final Duration _tickEvery;

  // Bağımsız reel ilerlemesi (H-094 P2, plan §5): ekrandaki reel için aktif
  // saniye ve tamamlanma. **Öğrenme kanıtı değildir.**
  String? _reelId;
  int _reelVersion = 1;
  int _reelPending = 0;

  /// Bu açılışta aktif oynatılan saniyeler (yazınca sıfırlanmaz; H-096).
  int _reelActive = 0;
  bool _reelDone = false;

  /// Ölçüm ve testler: ekrandaki sayfa.
  int get index => _index;

  /// Girdinin videosu (klip girdisi kimliğinden çözülür); kartlarda null.
  FeedVideo? _videoOf(FeedEntry entry) => switch (entry) {
    ClipEntry(:final clip) => _clips[clip.id],
    VideoEntry(:final video) => video,
    _ => null,
  };

  FeedVideo? get _video => _videoOf(feed[_index]);

  VideoPlayerController? get _current {
    final v = _video;
    return v == null ? null : cache.ready(v.cacheKey);
  }

  /// [from] sonrasındaki ilk video sayfası (önceden yükleme).
  int? _nextVideo(int from) {
    for (var i = from + 1; i < feed.length; i++) {
      if (_videoOf(feed[i]) != null) return i;
    }
    return null;
  }

  /// [before] sırasından önceki video sayısı (bitiş kartı için).
  int _videosBefore(int before) {
    var n = 0;
    for (var i = 0; i < before && i < feed.length; i++) {
      if (_videoOf(feed[i]) != null) n++;
    }
    return n;
  }

  bool get _canPlay =>
      _visible &&
      _foreground &&
      !_sheetOpen &&
      !_away &&
      !_limitReached &&
      !_withdrawn;

  /// Açık video yayından kaldırıldı (H-096): akış yeni seçkiyle kurulana dek
  /// oynatma durur.
  bool _withdrawn = false;

  @override
  void initState() {
    super.initState();
    cache = ClipControllerCache(
      uriFor: (key) => _uris[key]!,
      factory: ref.read(videoControllerFactoryProvider),
    );

    _store = ref.read(discoverStoreProvider);
    _clock = ref.read(discoverClockProvider);
    _tickEvery = ref.read(discoverTickProvider);
    WidgetsBinding.instance.addObserver(this);
    _tick = Timer.periodic(_tickEvery, (_) => _onTick());
    unawaited(_loadSaved());
    unawaited(_start());
  }

  Future<void> _start() async {
    await _loadWatched();
    if (!mounted || _limitReached) return;
    await _activate(_initial);
  }

  Future<void> _loadWatched() async {
    final limit = widget.limit.daily;
    try {
      _watched = await _store.watchedSeconds(_clock());
    } on Object catch (e) {
      debugPrint('[H040] süre okunamadı: $e');
    }
    if (!mounted) return;
    setState(() {
      _limitLoaded = true;
      _limitReached = limit != null && _watched >= limit.inSeconds;
    });
  }

  Future<void> _loadSaved() async {
    try {
      final all = await ref.read(notebookRepositoryProvider).all();
      if (!mounted) return;
      setState(() => _savedKeys.addAll(all.map((e) => e.key)));
    } on Object {
      // Defter okunamazsa düğmeler "Kaydet" görünür; ekleme yine çalışır.
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final n = TickerMode.getNotifier(context);
    if (!identical(n, _tickerMode)) {
      _tickerMode?.removeListener(_onVisibility);
      _tickerMode = n..addListener(_onVisibility);
      _visible = n.value;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final fg = state == AppLifecycleState.resumed;
    if (fg == _foreground) return;
    _foreground = fg;
    unawaited(_onPlayability());
  }

  void _onVisibility() {
    final v = _tickerMode?.value ?? true;
    if (v == _visible) return;
    _visible = v;
    unawaited(_onPlayability());
  }

  /// Sekme ya da uygulama görünürlüğü değişti.
  Future<void> _onPlayability() async {
    if (!_canPlay) {
      await _current?.pause();
      await _flush();
      await _flushReel();
      return;
    }
    // Keşfet'e dönüldü ya da uygulama öne geldi: reel kataloğu kontrollü
    // yenilenir (H-096).
    unawaited(_checkCatalog());
    // Geri gelindi: gün değişmiş olabilir; süre yeniden okunur.
    await _flush();
    await _loadWatched();
    if (!mounted || !_canPlay) return;
    final c = _current;
    if (c != null && !c.value.isCompleted) await c.play();
  }

  /// Reel kataloğunu (aralık dolduysa) yeniden okur. Açık video artık
  /// yayında değilse sakin biçimde durur ve kısa bir not gösterilir; seçki
  /// ve havuz sağlayıcılardan yeniden kurulur (günlük sette yerine aynı
  /// seviye-konudan yedek gelir, plan §5). Okunamazsa açık video kesilmez.
  Future<void> _checkCatalog() async {
    if (!widget.videos.any((v) => v.isReel)) return;
    final fresh = await ref.read(reelCatalogRefresherProvider).refreshIfDue();
    if (fresh == null || !mounted || _withdrawn) return;
    final video = _video;
    if (video == null || !video.isReel) return;
    final summary = fresh.byId(video.id);
    if (summary != null && !summary.isWithdrawn) return;
    setState(() => _withdrawn = true);
    await cache.ready(video.cacheKey)?.pause();
    await _flush();
    await _flushReel();
    _reelId = null;
    if (mounted) _snack(DiscoverTexts.reelWithdrawn);
  }

  void _onTick() {
    final c = _current;
    if (c != null && _canPlay && c.value.isCompleted) _checkReelDone(c);
    if (c == null || !c.value.isPlaying || !_canPlay) return;
    _pending += _tickEvery.inSeconds.clamp(1, 60);
    _onReelTick(c);
    final limit = widget.limit.daily;
    if (limit != null && _watched + _pending >= limit.inSeconds) {
      unawaited(_reachLimit());
    } else if (_pending >= 10 || _reelPending >= 10) {
      unawaited(_flush());
      unawaited(_flushReel());
    }
  }

  /// Açık oynatma sayılır; tamamlanma videoyu **açmakla** değil, aktif oynatma
  /// + sona yaklaşmayla oluşur (aynı iki saniyeyi döndürmek yetmez — plan §5).
  void _onReelTick(VideoPlayerController c) {
    if (_reelId == null) return;
    final step = _tickEvery.inSeconds.clamp(1, 60);
    _reelPending += step;
    _reelActive += step;
    _checkReelDone(c);
  }

  /// Tamamlanma (ürün ölçümü, öğrenme kanıtı değil): konum sürenin %90'ını
  /// geçti **ve** bu açılışta en az %80'i kadar aktif oynatıldı (H-096).
  /// Bitmiş videoda konum süreye eşit sayılır (son saniye sayaçlar arasında
  /// kalabilir).
  void _checkReelDone(VideoPlayerController c) {
    if (_reelId == null || _reelDone) return;
    final duration = c.value.duration;
    if (duration <= Duration.zero) return;
    final position = c.value.isCompleted ? duration : c.value.position;
    final activeEnough =
        _reelActive * 1000 >= duration.inMilliseconds * _kReelActiveShare;
    if (position >= duration * _kReelCompletion && activeEnough) {
      _reelDone = true;
    }
  }

  /// Ekrandaki reel ilerlemesini yazar (gösterim günü + saniye + tamamlanma).
  Future<void> _flushReel({bool markShown = false}) async {
    final id = _reelId;
    if (id == null) return;
    final seconds = _reelPending;
    final done = _reelDone;
    if (seconds <= 0 && !done && !markShown) return;
    _reelPending = 0;
    _reelDone = false;
    try {
      await _store.mergeProgress(
        id,
        contentVersion: _reelVersion,
        addSeconds: seconds,
        completed: done,
        shownDay: localDayKey(_clock()),
      );
    } on Object catch (e) {
      debugPrint('[H094] reel ilerlemesi yazılamadı: $e');
      _reelPending += seconds;
      _reelDone = _reelDone || done;
    }
  }

  /// Sorunun ürün sonucu (kanıt değil): yalnız `discover.reel.<id>`.
  Future<void> _recordPractice(FeedVideo video, PracticeResult result) async {
    if (!video.isReel) return;
    try {
      await _store.mergeProgress(
        video.id,
        contentVersion: video.contentVersion,
        practiceResult: result,
      );
    } on Object catch (e) {
      debugPrint('[H094] soru sonucu yazılamadı: $e');
    }
  }

  Future<void> _flush() async {
    final s = _pending;
    if (s <= 0) return;
    _pending = 0;
    try {
      _watched = await _store.addSeconds(_clock(), s);
    } on Object catch (e) {
      debugPrint('[H040] süre yazılamadı: $e');
      _pending += s;
    }
  }

  Future<void> _reachLimit() async {
    if (_limitReached) return;
    setState(() => _limitReached = true);
    await _current?.pause();
    await _flush();
    await _flushReel();
    cache.retain(const {});
  }

  /// Sayfa değişti: ekrandaki video açılır ve oynar, sıradaki önceden açılır,
  /// ötekiler atılır.
  Future<void> _activate(int index) async {
    final token = ++_activation;
    await _flushReel();
    _index = index;
    final entry = feed[index];
    final here = _videoOf(entry);
    _reelId = here != null && here.isReel ? here.id : null;
    _reelVersion = here?.contentVersion ?? 1;
    _reelPending = 0;
    _reelActive = 0;
    _reelDone = false;
    if (_reelId != null) {
      unawaited(_flushReel(markShown: true));
      // Aynı gün kalınan yer (plan §5): yalnız günlük sette.
      if (widget.daily) {
        unawaited(_store.setResumeId(_clock(), _reelId));
      }
    }
    final next = _nextVideo(index);
    final nextVideo = next == null ? null : _videoOf(feed[next]);
    final keep = <String>{
      if (here != null) here.cacheKey,
      if (nextVideo != null) nextVideo.cacheKey,
    };
    for (final p in [...cache.paths]) {
      if (!keep.contains(p)) await cache.ready(p)?.pause();
    }
    cache.retain(keep);
    if (mounted) setState(() {});
    if (here != null) {
      final c = await cache.acquire(here.cacheKey);
      if (!mounted || token != _activation || c == null) return;
      bool ownsController() =>
          mounted &&
          token == _activation &&
          identical(cache.ready(here.cacheKey), c);
      try {
        await c.setVolume(_muted ? 0 : 1);
        if (!ownsController()) return;
        if (c.value.position > Duration.zero || c.value.isCompleted) {
          await c.seekTo(Duration.zero);
        }
        if (!ownsController()) return;
        if (_canPlay) await c.play();
      } on Object {
        // Çip/sekme değişirken bu akışın denetleyicisi eşzamanlı atılabilir.
        // Güncel denetleyicinin gerçek oynatma hatasını gizleme.
        if (ownsController()) rethrow;
      }
    }
    if (!mounted || token != _activation) return;
    if (nextVideo != null && !_limitReached) cache.preload(nextVideo.cacheKey);
  }

  Future<void> _togglePlay() async {
    final c = _current;
    if (c == null || !_canPlay) return;
    if (c.value.isPlaying) {
      await c.pause();
    } else {
      if (c.value.isCompleted) await c.seekTo(Duration.zero);
      await c.play();
    }
    if (mounted) setState(() {});
  }

  Future<void> _replay() async {
    final c = _current;
    if (c == null || !_canPlay) return;
    await c.seekTo(Duration.zero);
    await c.play();
  }

  Future<void> _toggleMute() async {
    setState(() => _muted = !_muted);
    await _current?.setVolume(_muted ? 0 : 1);
  }

  void _snack(String text) {
    final m = ScaffoldMessenger.maybeOf(context);
    m
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  SavedPhrase _targetItem(FeedVideo v) {
    final cue = v.targetCue;
    final id = v.contentId ?? v.id;
    return SavedPhrase(
      contentId: id,
      sourceId: cue?.id ?? '$id#${v.id}',
      kind: v.target.isWord ? SavedKind.word : SavedKind.phrase,
      en: v.target.en,
      tr: v.target.tr,
      context: cue?.text,
      contextTr: cue?.tr,
      sourceTitle: v.sourceTitle,
      // Reel paketinden gelen görsel ve ses doğrudan taşınır (H-094): kart
      // sonradan bölüm verisinden zenginleştirilmez (`_reels/<id>/…`).
      imagePath: v.imagePath,
      audio: v.audioPath == null ? null : MediaClip(v.audioPath!),
      savedAt: _clock().toUtc(),
    );
  }

  bool _isSaved(FeedVideo v) => _savedKeys.contains(_targetItem(v).key);

  /// "Kaydet": videonun ifadesi Defter'e (kaynak "Keşfet: …").
  Future<void> _save(FeedVideo v) async {
    final item = _targetItem(v);
    try {
      final added = await ref.read(notebookRepositoryProvider).add(item);
      if (!mounted) return;
      setState(() {
        _savedKeys.add(item.key);
        if (added) _savedCount++;
      });
      _snack(SaveOutcome(item, added: added).message);
      if (added) refreshNotebook(ref);
    } on Object catch (e) {
      debugPrint('[H040] deftere eklenemedi: $e');
      if (mounted) _snack(MeaningTexts.saveFailed);
    }
  }

  /// Altyazı satırı ya da "Anlam": video durur, anlam paneli açılır; panel
  /// kapanınca kaldığı yerden sürer.
  Future<void> _openMeaning(FeedVideo v, SubtitleCue cue, int? word) async {
    if (_sheetOpen) return;
    final c = _current;
    final wasPlaying = c?.value.isPlaying ?? false;
    final resumeAt = c?.value.position ?? Duration.zero;
    setState(() => _sheetOpen = true);
    await c?.pause();
    await _flush();
    await _flushReel();
    if (!mounted) return;
    final audio = c == null
        ? const SilentMeaningAudio()
        : _ClipMeaningAudio(c, cue);
    final id = v.contentId ?? v.id;
    final title = v.sourceTitle;
    var saved = false;
    final m = MeaningController(
      text: cue.toMeaning(id),
      audio: audio,
      events: ref.read(learningEventLogProvider),
      notebook: ref.read(notebookRepositoryProvider),
      decorate: (draft, {wordIndex, chunk}) {
        saved = true;
        return draft.copyWith(
          sourceTitle: title,
          imagePath: v.imagePath,
          audio: v.audioPath == null ? null : MediaClip(v.audioPath!),
        );
      },
    );
    if (word != null) m.selectWord(word);
    final topic = await showMeaningSheet(
      context,
      m,
      speak: ref.read(speechVisibleProvider) ? speakEnvOf(context) : null,
      structures: meaningStructures(ref, [?v.grammarId]),
    );
    m.dispose();
    await audio.stop();
    if (!mounted) return;
    if (saved) {
      unawaited(_loadSaved());
      refreshNotebook(ref);
    }
    final still = _current;
    if (still != null && identical(still, c)) {
      await still.setPlaybackSpeed(1);
      await still.setVolume(_muted ? 0 : 1);
      await still.seekTo(resumeAt);
    }
    if (!mounted) return;
    setState(() => _sheetOpen = false);
    if (topic != null) {
      await _openGrammar(topic);
      return;
    }
    if (wasPlaying && _canPlay && identical(_current, c)) await c?.play();
  }

  Future<void> _whileAway(Future<void> Function() open) async {
    setState(() => _away = true);
    await _current?.pause();
    await _flush();
    try {
      await open();
    } finally {
      if (mounted) setState(() => _away = false);
    }
  }

  /// "Tam hikâye": bölüm açılır (kaldığı yer sorulur); dönünce video durur
  /// halde bekler. Yalnızca gerçek bölüm bağı olan videolarda (plan §6.3).
  Future<void> _openEpisode(FeedVideo v) => _whileAway(() async {
    final id = v.episodeId;
    if (id == null || !mounted) return;
    await openEpisode(context, ref, id);
  });

  Future<void> _openGrammar(String id) => _whileAway(() async {
    if (!mounted) return;
    await playGrammarLessons(context, ref, [id]);
  });

  /// Testler ve ekran görüntüleri: doğrudan bir sayfaya geçer.
  @visibleForTesting
  void jumpTo(int page) => _pages.jumpToPage(page);

  void _goNext() {
    final to = _index + 1;
    if (to >= feed.length || !_pages.hasClients) return;
    final d = AppMotion.of(context, AppMotion.base);
    if (d == Duration.zero) {
      _pages.jumpToPage(to);
    } else {
      unawaited(
        _pages.animateToPage(to, duration: d, curve: AppMotion.standard),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tickerMode?.removeListener(_onVisibility);
    _tick?.cancel();
    final s = _pending;
    if (s > 0) {
      // Son saniyeler: ekran kapanırken yazılır (beklenmez).
      unawaited(
        _store.addSeconds(_clock(), s).then((_) {}, onError: (Object _) {}),
      );
    }
    unawaited(_flushReel());
    _pages.dispose();
    cache.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_limitLoaded) return const _Loading();
    if (_limitReached) {
      return LimitCard(onStory: () => context.go(AppRoutes.story));
    }
    return MediaQuery.removePadding(
      // Güvenli alanı üst şerit (başlık + çipler) taşır.
      context: context,
      removeTop: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            key: const ValueKey('discover-pages'),
            controller: _pages,
            scrollDirection: Axis.vertical,
            itemCount: feed.length,
            onPageChanged: (i) => unawaited(_activate(i)),
            itemBuilder: (context, i) => switch (feed[i]) {
              ClipEntry(:final ordinal) => _videoPage(
                _videoOf(feed[i])!,
                ordinal,
                i,
              ),
              VideoEntry(:final ordinal) => _videoPage(
                _videoOf(feed[i])!,
                ordinal,
                i,
              ),
              QuizEntry(:final clip) => QuizCard(
                key: ValueKey('quiz-${clip.id}'),
                clip: clip,
                onNext: _goNext,
              ),
              PracticeEntry(:final video) => PracticeCard(
                key: ValueKey('practice-${video.id}'),
                video: video,
                onNext: _goNext,
                onResult: (r) => unawaited(_recordPractice(video, r)),
              ),
              BreakEntry(:final clipsBefore) => BreakCard(
                clipsWatched: clipsBefore,
                saved: _savedCount,
                onHome: () => context.go(AppRoutes.home),
                onContinue: _goNext,
              ),
              EndEntry() => EndCard(
                moreLocked: widget.moreLocked,
                onStory: () => context.go(AppRoutes.story),
                onHome: () => context.go(AppRoutes.home),
              ),
              DailyEndEntry() => DailyEndCard(
                watched: _videosBefore(i),
                moreLabel: widget.daily ? DiscoverTexts.dailyEndMore : null,
                onMore: () => ref
                    .read(discoverChipProvider.notifier)
                    .select(DiscoverChip.storyClips),
                onNotebook: () => context.go(AppRoutes.notebook),
                onHome: () => context.go(AppRoutes.home),
              ),
            },
          ),
          // Yapay zekâ notu (§5.6): akış açılınca birkaç saniye, sonra
          // kaybolur (uygulama içi videoda gömülü etiket yok). Video üstünde.
          Positioned(
            left: AppSpace.s16,
            top: 112,
            child: IgnorePointer(
              child: Visibility(
                visible: _video != null,
                maintainState: true,
                child: AiNotice(
                  key: const ValueKey('ai-note'),
                  text: widget.aiLabel,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tek video sayfası (klip ya da reel): ortak sayfa + akış eylemleri.
  Widget _videoPage(FeedVideo v, int ordinal, int i) => TickerMode(
    enabled: i == _index,
    child: VideoPage(
      video: v,
      ordinal: ordinal,
      total: widget.videos.length,
      cache: cache,
      active: i == _index,
      muted: _muted,
      saved: _isSaved(v),
      topInset: 0,
      onTogglePlay: () => unawaited(_togglePlay()),
      onReplay: () => unawaited(_replay()),
      onToggleMute: () => unawaited(_toggleMute()),
      onSave: () => unawaited(_save(v)),
      onMeaning: (cue, w) => unawaited(_openMeaning(v, cue, w)),
      onFullStory: () => unawaited(_openEpisode(v)),
      onGrammar: v.grammarId == null
          ? null
          : () => unawaited(_openGrammar(v.grammarId!)),
      onRetry: () {
        cache.retry(v.cacheKey);
        unawaited(_activate(i));
      },
    ),
  );
}

/// Anlam panelinin sesi: klibin kendi kaydından kelime ya da satır çalınır
/// (yeniden ses üretimi yok).
class _ClipMeaningAudio implements MeaningAudio {
  _ClipMeaningAudio(this._c, this._cue);

  final VideoPlayerController _c;
  final SubtitleCue _cue;
  Timer? _stop;

  @override
  bool get canPlayWords => _cue.words.isNotEmpty;

  @override
  bool get canPlaySentence => true;

  Future<void> _range(double start, double end, double speed) async {
    _stop?.cancel();
    final from = (start - 0.05).clamp(0.0, double.infinity);
    await _c.setVolume(1);
    await _c.setPlaybackSpeed(speed);
    await _c.seekTo(Duration(microseconds: (from * 1e6).round()));
    await _c.play();
    final ms = ((end - from + 0.12) / speed * 1000).round();
    _stop = Timer(Duration(milliseconds: ms), () => unawaited(_c.pause()));
  }

  @override
  Future<void> playWord(MeaningWord word, {required double speed}) async {
    if (!word.hasTiming) return;
    await _range(word.start!, word.end!, speed);
  }

  @override
  Future<void> playSentence({required double speed}) =>
      _range(_cue.start, _cue.end, speed);

  @override
  Future<void> stop() async {
    _stop?.cancel();
    _stop = null;
    try {
      await _c.pause();
    } on Object {
      // Denetleyici atılmış olabilir.
    }
  }
}
