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
import '../../hi/application/hi_providers.dart';
import '../../hi/domain/coach_rules.dart';
import '../../hi/presentation/suggestion_actions.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/presentation/notebook_screen.dart';
import '../../profile/application/profile_providers.dart';
import '../../story/application/story_providers.dart';
import '../../story/domain/season_map.dart';
import '../application/home_providers.dart';
import '../../hi/presentation/hi_bubble.dart';

/// Ana Sayfa (H-035, H-036, H-053; tasarım H-060, taslak S07; plan H-088).
///
/// - Üstte selam ve **günlük hedef halkası** (bugün yaklaşık kaç dakika;
///   [todayActivityProvider]).
/// - **Bugünün planı** (birincil, tek öğrenme eylemi): Hi'nin önerisiyle
///   **aynı karar** ([dailyPlanProvider], [planToday]). Üstte sakin adım
///   göstergesi (kısa tekrar → sahne/okuma → küçük görev), altında tek kart:
///   bölüm önerisinde görselli bölüm kartı ("Devam et" / "Başla"), öteki
///   önerilerde başlık + "Neden?" + fiil düğmesi. "Başka bir öneri" öneriyi
///   bugünlük geçer.
/// - **Hikâyen** (birincil öneri bölüm değilse, ikincil): sıradaki bölüm ya da
///   "hazırlanıyor"; B1+ yerleştirmede "İsteğe bağlı".
/// - **Çalışma araçların**: Kelime tekrarı ve Defter, tek dokunuşla (Ana Sayfa
///   sekmesinde açılır; sekme düzeni K-30 değişmez).
/// - Ara sıra hesap kartı (H-038).
///
/// Bölümler sırayla belirir; "Hareketi azalt" açıksa durağandır.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final map = ref.watch(seasonMapProvider);
    final plan = ref.watch(dailyPlanProvider);
    final name = ref.watch(displayNameProvider).value;
    final today = ref.watch(todayActivityProvider).value;
    final p = plan.value;
    final primary = p?.primary;
    final episodeFirst =
        primary == null ||
        primary.kind == HiSuggestionKind.continueEpisode ||
        primary.kind == HiSuggestionKind.startEpisode;
    // Bağlantı yokken "Bugünlük bu kadar" demek yanıltır: hikâyenin hata
    // kartı birincil yerde kalır.
    final storyDown =
        map is AsyncError &&
        (primary == null || primary.kind == HiSuggestionKind.rest);
    Widget storyCard({required bool primarySlot}) => switch (map) {
      AsyncData(:final value) =>
        primarySlot
            ? _ContinueCard(map: value, suggestion: primary)
            : _StoryAside(map: value, optional: p?.advanced ?? false),
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
      _ => const ContinueCardSkeleton(label: HomeTexts.storyLoading),
    };
    final Widget primaryCard;
    if (episodeFirst || storyDown) {
      // Plan henüz hesaplanmadıysa ya da okunamadıysa hikâye kartı birincil
      // kalır (Ana Sayfa hiçbir zaman boş ya da sonsuz iskelette kalmaz).
      primaryCard = storyCard(primarySlot: true);
    } else {
      primaryCard = _PlanCard(suggestion: primary);
    }
    final steps = p?.steps ?? const <PlanStep>[];
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // Hi balonu içeriğin üstünde yüzer; pay yalnızca listenin sonunda
          // (HiBubbleInset, H-064): son kart balonun üstüne kadar kayar.
          padding: EdgeInsets.fromLTRB(
            AppSpace.page,
            AppSpace.s16,
            AppSpace.page,
            AppSpace.s32 + HiBubbleInset.of(context),
          ),
          children: [
            StaggeredList(
              spacing: AppSpace.s24,
              children: [
                _Greeting(name: name, today: today ?? TodayActivity.empty),
                Column(
                  key: const ValueKey('home-plan'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SectionHeading(HomeTexts.planSection),
                    if (steps.length >= 2) ...[
                      const SizedBox(height: AppSpace.s8),
                      _PlanSteps(steps: steps),
                    ],
                    const SizedBox(height: AppSpace.s8),
                    primaryCard,
                  ],
                ),
                // Birincil öneri bölüm değilse hikâye ikincil olarak durur.
                if (!episodeFirst && !storyDown)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SectionHeading(HomeTexts.storySection),
                      const SizedBox(height: AppSpace.s8),
                      storyCard(primarySlot: false),
                    ],
                  ),
                // İkincil: çalışma araçları, daha sade (tek öğrenme eylemi
                // ilkesi; dolu düğme yok).
                const _Tools(),
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

/// Görselli bölüm kartı: planın birincil önerisi bir bölümse ([suggestion]:
/// "Neden?" gerekçesi ve "Başka bir öneri" ile), plan yokken haritanın
/// odağıyla.
class _ContinueCard extends ConsumerWidget {
  const _ContinueCard({required this.map, this.suggestion});

  final SeasonMap map;
  final HiSuggestion? suggestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = suggestion;
    final target = s?.contentId;
    final focus = target == null
        ? map.focus
        : map.episodes.where((e) => e.contentId == target).firstOrNull ??
              map.focus;
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
    final resume = s == null || s.contentId != focus.contentId
        ? focus.progress.hasCheckpoint
        : s.kind == HiSuggestionKind.continueEpisode;
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
                if (s != null && s.contentId == focus.contentId) ...[
                  const SizedBox(height: AppSpace.s12),
                  _Why(reason: s.reasonTr),
                ],
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
                if (s != null && s.contentId == focus.contentId) ...[
                  const SizedBox(height: AppSpace.s4),
                  _AnotherButton(suggestion: s),
                ],
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

/// "Neden?" + görünür gerekçe (her önerinin; ürün ilkesi).
class _Why extends StatelessWidget {
  const _Why({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HiTexts.why,
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppPalette.seaBlue,
          ),
        ),
        const SizedBox(height: AppSpace.s4),
        Text(
          reason,
          key: const ValueKey('home-plan-reason'),
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink700),
        ),
      ],
    );
  }
}

/// "Başka bir öneri": öneriyi bugünlük geçer; sıradaki öneri gelir (Hi'de
/// de aynı). Sakin metin düğmesi; ana eylemle yarışmaz.
class _AnotherButton extends ConsumerWidget {
  const _AnotherButton({required this.suggestion});

  final HiSuggestion suggestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!suggestion.dismissible) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        key: const ValueKey('home-plan-another'),
        onPressed: () => dismissSuggestion(ref, suggestion),
        style: TextButton.styleFrom(
          minimumSize: const Size(AppTouch.min, AppTouch.min),
        ),
        child: const Text(HiTexts.another),
      ),
    );
  }
}

/// Sakin adım göstergesi: "Kısa tekrar ✓ · Sahne · Küçük görev". Sayı,
/// geri sayım ya da yüzde yok; yapılmayan adım vurgulanmaz.
class _PlanSteps extends StatelessWidget {
  const _PlanSteps({required this.steps});

  final List<PlanStep> steps;

  static String _label(PlanStep s) => switch (s.stage) {
    PlanStage.warmUp => HomeTexts.stepWarmUp,
    PlanStage.main => s.reading ? HomeTexts.stepReading : HomeTexts.stepScene,
    PlanStage.task => HomeTexts.stepTask,
  };

  static String _state(PlanStepState s) => switch (s) {
    PlanStepState.done => HomeTexts.stepDone,
    PlanStepState.current => HomeTexts.stepCurrent,
    PlanStepState.upcoming => HomeTexts.stepUpcoming,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      label: HomeTexts.stepsSemantics([
        for (final s in steps) HomeTexts.stepState(_label(s), _state(s.state)),
      ]),
      child: ExcludeSemantics(
        child: Wrap(
          key: const ValueKey('home-plan-steps'),
          spacing: AppSpace.s8,
          runSpacing: AppSpace.s8,
          children: [
            for (final s in steps)
              Container(
                key: ValueKey('home-step-${s.stage.name}-${s.state.name}'),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.s12,
                  vertical: AppSpace.s4,
                ),
                decoration: BoxDecoration(
                  color: switch (s.state) {
                    PlanStepState.current => AppPalette.yellow100,
                    PlanStepState.done => AppPalette.successSurface,
                    PlanStepState.upcoming => AppPalette.white,
                  },
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: s.state == PlanStepState.current
                        ? AppPalette.lighthouseYellow
                        : AppPalette.ink100,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      switch (s.state) {
                        PlanStepState.done => Icons.check_rounded,
                        PlanStepState.current => Icons.arrow_forward_rounded,
                        PlanStepState.upcoming => Icons.circle_outlined,
                      },
                      size: AppIconSize.sm,
                      color: switch (s.state) {
                        PlanStepState.done => AppPalette.success,
                        PlanStepState.current => AppPalette.orange700,
                        PlanStepState.upcoming => AppPalette.ink500,
                      },
                    ),
                    const SizedBox(width: AppSpace.s4),
                    Text(
                      _label(s),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: s.state == PlanStepState.upcoming
                            ? AppPalette.ink500
                            : AppPalette.ink,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Birincil öneri bölüm değilse (tekrar, not, kitap, sahne avı, dilbilgisi,
/// dinlenme): ikon + adım etiketi + başlık + "Neden?" + tek dolu düğme.
class _PlanCard extends ConsumerWidget {
  const _PlanCard({required this.suggestion});

  final HiSuggestion suggestion;

  static IconData _icon(HiSuggestionKind k) => switch (k) {
    HiSuggestionKind.review => Icons.style_rounded,
    HiSuggestionKind.errorNote => Icons.lightbulb_outline_rounded,
    HiSuggestionKind.notebook => Icons.menu_book_rounded,
    HiSuggestionKind.continueBook ||
    HiSuggestionKind.startBook => Icons.auto_stories_rounded,
    HiSuggestionKind.sceneHunt => Icons.travel_explore_rounded,
    HiSuggestionKind.grammarSuggest => Icons.school_outlined,
    HiSuggestionKind.continueEpisode ||
    HiSuggestionKind.startEpisode => Icons.play_circle_outline_rounded,
    HiSuggestionKind.rest => Icons.nights_stay_outlined,
  };

  static String _stage(HiSuggestion s) => switch (s.stage) {
    PlanStage.warmUp => HomeTexts.stepWarmUp,
    PlanStage.main =>
      s.kind == HiSuggestionKind.continueBook ||
              s.kind == HiSuggestionKind.startBook
          ? HomeTexts.stepReading
          : HomeTexts.stepScene,
    PlanStage.task => HomeTexts.stepTask,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = suggestion;
    final rest = s.kind == HiSuggestionKind.rest;
    PerfLog.markAfterFrame('Ana Sayfa hazır');
    return Container(
      key: ValueKey('home-plan-${s.kind.name}'),
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: AppSpace.s48,
                  height: AppSpace.s48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: rest ? AppPalette.seaBlue50 : AppPalette.yellow100,
                  ),
                  child: Icon(
                    _icon(s.kind),
                    color: rest ? AppPalette.seaBlue : AppPalette.orange700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!rest) ...[
                      CapsLabel(_stage(s)),
                      const SizedBox(height: AppSpace.s4),
                    ],
                    Semantics(
                      header: true,
                      child: Text(
                        s.title,
                        key: const ValueKey('home-plan-title'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppPalette.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.s12),
          if (rest)
            Text(
              s.reasonTr,
              key: const ValueKey('home-plan-reason'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.ink700,
              ),
            )
          else
            _Why(reason: s.reasonTr),
          if (s.hasAction && s.actionLabel != null) ...[
            const SizedBox(height: AppSpace.s16),
            FilledButton.icon(
              key: const ValueKey('home-plan-action'),
              onPressed: () => openSuggestionFromHome(context, ref, s),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(s.actionLabel!),
            ),
            const SizedBox(height: AppSpace.s4),
            _AnotherButton(suggestion: s),
          ],
        ],
      ),
    );
  }
}

/// İkincil hikâye kartı (birincil öneri bölüm değilken): sıradaki bölüm ve
/// çerçeveli düğme; B1+ yerleştirmede "İsteğe bağlı". Oynanacak bölüm yoksa
/// sakin "hazırlanıyor" / "sezonu bitirdin" kartı.
class _StoryAside extends ConsumerWidget {
  const _StoryAside({required this.map, required this.optional});

  final SeasonMap map;
  final bool optional;

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
    final resume = focus.progress.hasCheckpoint;
    return Container(
      key: const ValueKey('home-continue'),
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: CapsLabel(
              optional
                  ? HomeTexts.storyOptional
                  : HomeTexts.episodeLabel(map.season, focus.number),
              tone: optional ? CapsTone.blue : CapsTone.orange,
            ),
          ),
          const SizedBox(height: AppSpace.s4),
          Semantics(
            header: true,
            child: Text(
              focus.title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppPalette.ink,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s4),
          Text(
            optional
                ? HomeTexts.storyOptionalBody
                : HomeTexts.seasonProgress(map.completedCount, map.total),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppPalette.ink500,
            ),
          ),
          const SizedBox(height: AppSpace.s12),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              key: const ValueKey('home-continue-play'),
              onPressed: () => openEpisode(
                context,
                ref,
                focus.contentId,
                mode: resume ? 'resume' : null,
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(resume ? HomeTexts.resume : HomeTexts.play),
            ),
          ),
        ],
      ),
    );
  }
}

/// Çalışma araçları (H-088): Kelime tekrarı ve Defter Ana Sayfa'dan tek
/// dokunuşla (Profil'e gömülü kalmaz). Kelime tekrarı satırı tekrar zamanı
/// gelen ifade sayısını cümle içinde söyler (H-053).
class _Tools extends ConsumerWidget {
  const _Tools();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final o = ref.watch(reviewOverviewProvider).value;
    final n = o?.sessionCount ?? 0;
    final String reviewText;
    if (o == null) {
      reviewText = HomeTexts.reviewLoading;
    } else if (n > 0) {
      reviewText = HomeTexts.reviewDue(n, HomeTexts.reviewMinutes(n));
    } else if (o.totalItems == 0) {
      reviewText = HomeTexts.reviewEmpty;
    } else {
      reviewText = HomeTexts.reviewNone;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeading(HomeTexts.toolsSection),
        const SizedBox(height: AppSpace.s8),
        _ToolRow(
          key: const ValueKey('home-review'),
          tapKey: const ValueKey('home-review-start'),
          icon: Icons.style_rounded,
          highlight: n > 0,
          title: HomeTexts.reviewSection,
          body: reviewText,
          bodyKey: const ValueKey('home-review-text'),
          onTap: () => openReview(context, ref),
        ),
        const SizedBox(height: AppSpace.s8),
        _ToolRow(
          key: const ValueKey('home-notebook'),
          tapKey: const ValueKey('home-notebook-open'),
          icon: Icons.menu_book_rounded,
          title: HomeTexts.notebookTool,
          body: HomeTexts.notebookToolBody,
          onTap: () async {
            await context.push(AppRoutes.homeNotebook);
            if (context.mounted) refreshNotebook(ref);
          },
        ),
      ],
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow({
    super.key,
    required this.tapKey,
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    this.bodyKey,
    this.highlight = false,
  });

  final Key tapKey;
  final IconData icon;
  final String title;
  final String body;
  final Key? bodyKey;
  final bool highlight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TappableCard(
      key: tapKey,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpace.s12),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Container(
              width: AppSpace.s48,
              height: AppSpace.s48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: highlight ? AppPalette.yellow100 : AppPalette.seaBlue50,
              ),
              child: Icon(
                icon,
                color: highlight ? AppPalette.orange700 : AppPalette.seaBlue,
              ),
            ),
          ),
          const SizedBox(width: AppSpace.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppPalette.ink,
                  ),
                ),
                const SizedBox(height: AppSpace.s4),
                Text(
                  body,
                  key: bodyKey,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink700,
                  ),
                ),
              ],
            ),
          ),
          const ExcludeSemantics(
            child: Icon(Icons.chevron_right_rounded, color: AppPalette.ink500),
          ),
        ],
      ),
    );
  }
}
