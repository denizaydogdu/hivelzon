import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
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
    final box = ColoredBox(color: AppColors.seaBlue.withValues(alpha: 0.12));
    return Image.network(
      source.seasonMediaUri(kTopicSetSeason, 'sets/$path').toString(),
      key: ValueKey('set-image-$path'),
      fit: fit,
      alignment: alignment,
      cacheWidth: cacheWidth,
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, sync) =>
          frame == null && !sync ? box : child,
      errorBuilder: (_, _, _) => ColoredBox(
        color: AppColors.seaBlue.withValues(alpha: 0.12),
        child: const Center(
          child: Icon(Icons.image_outlined, color: AppColors.seaBlue),
        ),
      ),
    );
  }
}

/// Defter → "Konu setleri" sekmesi: setler, kilitli olanlar sakin bir nedenle.
class TopicSetsSection extends ConsumerWidget {
  const TopicSetsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sets = ref.watch(topicSetsProvider);
    return switch (sets) {
      AsyncData(:final value) when value.isEmpty => const _Note(
        icon: Icons.photo_library_outlined,
        text: TopicSetTexts.empty,
      ),
      AsyncData(:final value) => Column(
        key: const ValueKey('topic-sets'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final v in value) ...[
            _SetTile(view: v),
            const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ),
      AsyncError() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Note(
            icon: Icons.error_outline_rounded,
            text: TopicSetTexts.listError,
          ),
          OutlinedButton(
            key: const ValueKey('topic-sets-retry'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => ref.invalidate(topicSetsProvider),
            child: const Text(CommonTexts.retry),
          ),
        ],
      ),
      _ => const ListSkeleton(
        key: ValueKey('skeleton-topic-sets'),
        label: TopicSetTexts.listLoading,
        rows: 3,
        padding: EdgeInsets.only(top: AppSpacing.xs),
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
    final body = Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            child: SizedBox(
              width: 72,
              height: 96,
              child: open
                  ? SetImage(
                      path: s.cover,
                      alignment: const Alignment(0, -0.2),
                      cacheWidth: 216,
                    )
                  : ColoredBox(
                      color: AppColors.seaBlue.withValues(alpha: 0.12),
                      child: const Center(
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.seaBlue,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.titleTr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  open
                      ? TopicSetTexts.objectCount(s.itemCount)
                      : view.lockReason ?? TopicSetTexts.locked,
                  key: ValueKey('topic-set-status-${s.id}'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.ink.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            open ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
            color: AppColors.seaBlue,
            semanticLabel: open ? TopicSetTexts.openSet : TopicSetTexts.locked,
          ),
        ],
      ),
    );
    return Material(
      color: Colors.white.withValues(alpha: open ? 0.9 : 0.55),
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: open
          ? InkWell(
              key: ValueKey('topic-set-${s.id}'),
              borderRadius: BorderRadius.circular(AppTheme.radius),
              onTap: () => context.push(AppRoutes.topicSet(s.id)),
              child: body,
            )
          : Semantics(
              key: ValueKey('topic-set-${s.id}'),
              label: '${s.titleTr}. ${view.lockReason ?? TopicSetTexts.locked}',
              excludeSemantics: true,
              child: body,
            ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.seaBlue),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    ),
  );
}
