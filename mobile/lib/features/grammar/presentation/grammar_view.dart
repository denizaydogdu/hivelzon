import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/skeleton.dart';
import '../application/grammar_providers.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_progress.dart';
import 'grammar_lesson_screen.dart';
import '../../hi/presentation/hi_bubble.dart';

/// Dilbilgisi (H-078; Hikâye sekmesinde "Dilbilgisi"): raflar
/// ("Hikâyende geçenler" · "Senin seviyen" · öteki seviyeler ·
/// "Tamamladıkların"), sakin boş / yükleniyor / hata durumları. Kilit yok:
/// her ders her zaman açık.
class GrammarView extends ConsumerWidget {
  const GrammarView({super.key});

  static const errorImage = AssetImage(
    'assets/illustrations/baglanti-yok.webp',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(grammarListProvider);
    // Hi balonunun payı yalnızca listenin sonunda (H-064).
    final bottom =
        MediaQuery.paddingOf(context).bottom + HiBubbleInset.of(context);
    return ListView(
      key: const ValueKey('grammar-view'),
      padding: EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s8,
        AppSpace.page,
        AppSpace.s32 + bottom,
      ),
      children: [
        // Yenilenirken eski veri kalır (iskelete dönüp zıplamaz).
        switch (data) {
          AsyncValue(:final value?) when value.lessons.isEmpty => const Padding(
            padding: EdgeInsets.only(top: AppSpace.s24),
            child: EmptyState(
              key: ValueKey('grammar-empty'),
              icon: Icons.school_outlined,
              title: GrammarTexts.emptyTitle,
              message: GrammarTexts.emptyBody,
            ),
          ),
          AsyncValue(:final value?) => _Shelves(data: value),
          AsyncError() => Padding(
            padding: const EdgeInsets.only(top: AppSpace.s24),
            child: EmptyState(
              key: const ValueKey('grammar-error'),
              illustration: const Image(image: errorImage, fit: BoxFit.contain),
              title: CommonTexts.serverDownTitle,
              message: kDebugMode
                  ? '${GrammarTexts.loadError} ${CommonTexts.serverDownBody}'
                        '\n\n${CommonTexts.devServerHint}'
                  : '${GrammarTexts.loadError} ${CommonTexts.serverDownBody}',
              action: FilledButton.icon(
                key: const ValueKey('grammar-retry'),
                onPressed: () {
                  ref.invalidate(grammarIndexProvider);
                  refreshGrammar(ref);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(CommonTexts.retry),
              ),
            ),
          ),
          _ => const ListSkeleton(
            key: ValueKey('skeleton-grammar'),
            label: GrammarTexts.loading,
            rows: 3,
            padding: EdgeInsets.only(top: AppSpace.s16),
          ),
        },
      ],
    );
  }
}

class _Shelves extends ConsumerWidget {
  const _Shelves({required this.data});

  final GrammarListData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = data.shelves;
    final p = data.progress;
    final levels = grammarLevelSummaries(data.lessons, p);
    void open(GrammarLessonSummary l) =>
        playGrammarLessons(context, ref, [l.id]);
    return StaggeredList(
      spacing: AppSpace.s24,
      children: [
        if (s.fromStory.isNotEmpty)
          _Shelf(
            id: 'story',
            title: GrammarTexts.shelfFromStory,
            lessons: s.fromStory,
            progress: p,
            onOpen: open,
          ),
        if (s.userLevelLessons.isNotEmpty)
          _Shelf(
            id: 'mine',
            title: GrammarTexts.shelfMine(s.userLevel),
            summary: levels[s.userLevel],
            lessons: s.userLevelLessons,
            progress: p,
            onOpen: open,
          ),
        for (final (level, lessons) in s.otherLevels)
          _Shelf(
            id: 'level-$level',
            title: GrammarTexts.shelfLevel(level),
            summary: levels[level],
            lessons: lessons,
            progress: p,
            onOpen: open,
          ),
        if (s.completed.isNotEmpty)
          _Shelf(
            id: 'completed',
            title: GrammarTexts.shelfCompleted,
            lessons: s.completed,
            progress: p,
            onOpen: open,
          ),
      ],
    );
  }
}

class _Shelf extends StatelessWidget {
  const _Shelf({
    required this.id,
    required this.title,
    required this.lessons,
    required this.progress,
    required this.onOpen,
    this.summary,
  });

  final String id;
  final String title;

  /// Seviye raflarında: "A1 · 3/16 tamamlandı".
  final GrammarLevelSummary? summary;
  final List<GrammarLessonSummary> lessons;
  final Map<String, GrammarProgress> progress;
  final ValueChanged<GrammarLessonSummary> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('grammar-shelf-$id'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(title),
        if (summary case final sum?) ...[
          const SizedBox(height: AppSpace.s4),
          _LevelSummaryLine(key: ValueKey('grammar-level-$id'), summary: sum),
        ],
        const SizedBox(height: AppSpace.s8),
        for (final (i, l) in lessons.indexed) ...[
          if (i > 0) const SizedBox(height: AppSpace.s8),
          LessonTile(
            lesson: l,
            progress: grammarLessonProgress(l, progress[l.id]),
            onTap: () => onOpen(l),
          ),
        ],
      ],
    );
  }
}

/// Seviye rafının özeti (tamamlanan / toplam ders); ekran okuyucuya tam
/// cümle.
class _LevelSummaryLine extends StatelessWidget {
  const _LevelSummaryLine({super.key, required this.summary});

  final GrammarLevelSummary summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    return Semantics(
      container: true,
      label: GrammarTexts.levelSummarySemantics(s.level, s.completed, s.total),
      child: ExcludeSemantics(
        child: Row(
          children: [
            Icon(
              s.completed > 0
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: AppSpace.s16,
              color: s.completed > 0 ? AppPalette.success : AppPalette.ink500,
            ),
            const SizedBox(width: AppSpace.s4),
            Flexible(
              child: Text(
                GrammarTexts.levelSummary(s.level, s.completed, s.total),
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppPalette.ink500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ders kartı: seviye rozeti, Türkçe başlık, tek cümle hedef, süre,
/// ilerleme (yarımsa ince çubuk ve "%40 ilerledin"; başlanmamışta sakin,
/// yazı yok) ve (bittiyse) onay işareti.
class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    required this.progress,
    required this.onTap,
  });

  final GrammarLessonSummary lesson;
  final GrammarLessonProgress progress;
  final VoidCallback onTap;

  bool get done => progress.isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = lesson;
    final minutes = l.minutes;
    final started = progress.isStarted && !done;
    final percent = progress.percent;
    return TappableCard(
      key: ValueKey('lesson-tile-${l.id}'),
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpace.s12),
      semanticLabel: GrammarTexts.cardSemantics(
        title: l.titleTr,
        level: l.level,
        minutes: minutes,
        done: done,
        started: started,
        percent: percent,
      ),
      child: ExcludeSemantics(
        child: Row(
          children: [
            Container(
              width: AppSpace.s48,
              height: AppSpace.s48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: done ? AppPalette.successSurface : AppPalette.seaBlue50,
                shape: BoxShape.circle,
              ),
              child: done
                  ? const Icon(
                      Icons.check_rounded,
                      key: ValueKey('lesson-done-tick'),
                      color: AppPalette.success,
                    )
                  : Text(
                      l.level,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppPalette.seaBlue,
                        fontWeight: AppFonts.bold,
                      ),
                    ),
            ),
            const SizedBox(width: AppSpace.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.titleTr, style: theme.textTheme.titleMedium),
                  if (l.goalTr != null)
                    Text(
                      l.goalTr!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppPalette.ink500,
                      ),
                    ),
                  const SizedBox(height: AppSpace.s4),
                  Text(
                    [
                      l.level,
                      if (minutes != null) GrammarTexts.minutes(minutes),
                      if (done) GrammarTexts.done,
                    ].join(' · '),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: done ? AppPalette.success : AppPalette.orange700,
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                  if (started) ...[
                    const SizedBox(height: AppSpace.s8),
                    _TileProgress(
                      key: ValueKey('lesson-tile-progress-${l.id}'),
                      percent: percent,
                    ),
                  ],
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

/// Yarım dersin ince ilerleme çubuğu ve yazısı. Yüzde bilinmiyorsa yalnız
/// "Başladın".
class _TileProgress extends StatelessWidget {
  const _TileProgress({super.key, required this.percent});

  final int? percent;

  @override
  Widget build(BuildContext context) {
    final p = percent;
    final label = Text(
      p == null
          ? GrammarTexts.progressStarted
          : GrammarTexts.progressPercent(p),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppPalette.seaBlue,
        fontWeight: AppFonts.bold,
      ),
    );
    if (p == null) return label;
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: p / 100),
              duration: AppMotion.of(context, AppMotion.slow),
              curve: AppMotion.enter,
              builder: (_, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: AppSpace.s4 + 2,
                color: AppPalette.seaBlue,
                backgroundColor: AppPalette.seaBlue50,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpace.s8),
        Flexible(child: label),
      ],
    );
  }
}

/// Bölüm panelinde ve kitap açma panelinde ikincil düğme: "Bu bölümdeki
/// dilbilgisi (~2 dk)" ve altında konuların adları (H-078; H-050 bozulmaz:
/// kullanıcı seçmezse bölüm yine doğrudan başlıkla açılır).
class GrammarOfferButton extends StatelessWidget {
  const GrammarOfferButton({
    super.key,
    required this.offer,
    required this.label,
    required this.onPressed,
  });

  final GrammarOffer offer;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          key: const ValueKey('grammar-offer'),
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTouch.min),
            backgroundColor: AppPalette.white,
          ),
          icon: const Icon(Icons.school_outlined),
          label: Text(label),
        ),
        const SizedBox(height: AppSpace.s4),
        Text(
          GrammarTexts.offerTopics([for (final l in offer.lessons) l.titleTr]),
          key: const ValueKey('grammar-offer-topics'),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink500),
        ),
      ],
    );
  }
}
