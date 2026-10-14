import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/skeleton.dart';
import '../application/topic_set_providers.dart';
import '../domain/topic_set.dart';

/// Sezon paketindeki konu seti görseli (`sets/<yol>`). Yüklenirken aynı renkte
/// sakin kutu, açılamazsa yer tutucu.
class SetImage extends ConsumerWidget {
  const SetImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.cacheWidth = 512,
  });

  /// `alex-room/radio.webp`
  final String path;
  final BoxFit fit;
  final Alignment alignment;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = ref.watch(contentSourceProvider);
    const box = ColoredBox(color: AppPalette.seaBlue100);
    return Image.network(
      source.seasonMediaUri(kTopicSetSeason, 'sets/$path').toString(),
      key: ValueKey('set-image-$path'),
      fit: fit,
      alignment: alignment,
      cacheWidth: cacheWidth,
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, sync) =>
          frame == null && !sync ? box : child,
      errorBuilder: (_, _, _) => const ColoredBox(
        color: AppPalette.seaBlue100,
        child: Center(
          child: Icon(Icons.image_outlined, color: AppPalette.seaBlue),
        ),
      ),
    );
  }
}

/// Defter → "Konu setleri" sekmesi: setler, kilitli olanlar sakin bir nedenle.
/// Tasarım (H-061): görselli kart satırları, basınca hafif küçülür; ilk
/// açılışta sırayla belirir.
class TopicSetsSection extends ConsumerWidget {
  const TopicSetsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sets = ref.watch(topicSetsProvider);
    return switch (sets) {
      AsyncData(:final value) when value.isEmpty => const EmptyState(
        icon: Icons.photo_library_outlined,
        title: TopicSetTexts.empty,
      ),
      AsyncData(:final value) => StaggeredList(
        key: const ValueKey('topic-sets'),
        spacing: AppSpace.s8,
        children: [for (final v in value) _SetTile(view: v)],
      ),
      AsyncError() => EmptyState(
        icon: Icons.error_outline_rounded,
        title: TopicSetTexts.listError,
        action: OutlinedButton(
          key: const ValueKey('topic-sets-retry'),
          onPressed: () => ref.invalidate(topicSetsProvider),
          child: const Text(CommonTexts.retry),
        ),
      ),
      _ => const ListSkeleton(
        key: ValueKey('skeleton-topic-sets'),
        label: TopicSetTexts.listLoading,
        rows: 3,
        padding: EdgeInsets.only(top: AppSpace.s8),
      ),
    };
  }
}

class _SetTile extends StatelessWidget {
  const _SetTile({required this.view});

  final TopicSetView view;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = view.summary;
    final open = view.unlocked;
    final body = Row(
      children: [
        ClipRRect(
          borderRadius: AppRadius.smAll,
          child: SizedBox(
            width: 72,
            height: 96,
            child: open
                ? SetImage(
                    path: s.cover,
                    alignment: const Alignment(0, -0.2),
                    cacheWidth: 216,
                  )
                : const ColoredBox(
                    color: AppPalette.sand200,
                    child: Center(
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: AppPalette.ink500,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: AppSpace.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.titleTr,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: open ? AppPalette.ink : AppPalette.ink700,
                ),
              ),
              const SizedBox(height: AppSpace.s4),
              Text(
                open
                    ? TopicSetTexts.objectCount(s.itemCount)
                    : view.lockReason ?? TopicSetTexts.locked,
                key: ValueKey('topic-set-status-${s.id}'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppPalette.ink500,
                ),
              ),
            ],
          ),
        ),
        Icon(
          open ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
          color: open ? AppPalette.seaBlue : AppPalette.ink500,
          semanticLabel: open ? TopicSetTexts.openSet : TopicSetTexts.locked,
        ),
      ],
    );
    if (!open) {
      // Kilitli set: dokunulmaz, kum zeminde sakin; nedeni yazılı.
      return Semantics(
        key: ValueKey('topic-set-${s.id}'),
        label: '${s.titleTr}. ${view.lockReason ?? TopicSetTexts.locked}',
        excludeSemantics: true,
        child: TappableCard(
          color: AppPalette.sand50,
          padding: const EdgeInsets.all(AppSpace.s12),
          child: body,
        ),
      );
    }
    return TappableCard(
      key: ValueKey('topic-set-${s.id}'),
      padding: const EdgeInsets.all(AppSpace.s12),
      onTap: () => context.push(AppRoutes.topicSet(s.id)),
      child: body,
    );
  }
}
