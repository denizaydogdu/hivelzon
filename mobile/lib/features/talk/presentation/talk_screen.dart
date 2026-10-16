import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../hi/presentation/hi_bubble.dart';
import '../application/talk_providers.dart';
import '../domain/talk_task.dart';
import 'talk_widgets.dart';

/// Konuş sekmesi (H-090): yönlendirmeli sahneler ve kısa mesajlar. Yapay
/// zekâ sohbeti MVP'de yok (H-007); sahnelerin cümleleri önceden yazılmıştır
/// ve bu sayfanın başında açıkça söylenir. Görev, ilgili bölüm bitince açılır.
class TalkScreen extends ConsumerWidget {
  const TalkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final views = ref.watch(talkViewsProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          key: const ValueKey('talk-screen'),
          padding: EdgeInsets.fromLTRB(
            AppSpace.page,
            AppSpace.s8,
            AppSpace.page,
            AppSpace.s24 + HiBubbleInset.of(context),
          ),
          children: [
            const PageHeader(
              title: TalkTexts.title,
              subtitle: TalkTexts.subtitle,
            ),
            const SizedBox(height: AppSpace.s16),
            const InfoCard(
              key: ValueKey('talk-intro'),
              tone: InfoTone.info,
              icon: Icons.forum_outlined,
              title: TalkTexts.introTitle,
              body: TalkTexts.introBody,
            ),
            const SizedBox(height: AppSpace.s24),
            ...switch (views) {
              AsyncData(:final value) when value.isEmpty => [
                const EmptyState(
                  key: ValueKey('talk-empty'),
                  icon: Icons.forum_outlined,
                  title: TalkTexts.emptyTitle,
                  message: TalkTexts.emptyBody,
                ),
              ],
              AsyncData(:final value) => _sections(context, value),
              AsyncError() => [
                EmptyState(
                  key: const ValueKey('talk-error'),
                  icon: Icons.error_outline_rounded,
                  title: TalkTexts.errorTitle,
                  message: TalkTexts.errorBody,
                  action: OutlinedButton(
                    onPressed: () => ref.invalidate(talkCatalogProvider),
                    child: const Text(CommonTexts.retry),
                  ),
                ),
              ],
              _ => [
                const ListSkeleton(
                  key: ValueKey('talk-skeleton'),
                  label: TalkTexts.loading,
                  rows: 3,
                  padding: EdgeInsets.zero,
                ),
              ],
            },
          ],
        ),
      ),
    );
  }

  List<Widget> _sections(BuildContext context, List<TalkTaskView> views) {
    final scenes = views.where((v) => v.task.isScene).toList();
    final messages = views.where((v) => !v.task.isScene).toList();
    Widget list(List<TalkTaskView> items) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpace.s12),
          FadeSlideIn(
            index: i,
            child: _TaskCard(view: items[i]),
          ),
        ],
      ],
    );
    return [
      if (scenes.isNotEmpty) ...[
        const SectionHeading(TalkTexts.scenesHeading),
        const SizedBox(height: AppSpace.s12),
        list(scenes),
        const SizedBox(height: AppSpace.s24),
      ],
      if (messages.isNotEmpty) ...[
        const SectionHeading(TalkTexts.messagesHeading),
        const SizedBox(height: AppSpace.s12),
        list(messages),
      ],
    ];
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({required this.view});

  final TalkTaskView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = view.task;
    final theme = Theme.of(context);
    final meta = t.isScene
        ? TalkTexts.sceneMeta(t.characterName, t.turns.length, t.minutes)
        : TalkTexts.messageMeta(t.to, t.minutes);
    final status = !view.unlocked
        ? TalkTexts.locked(t.unlockEpisode)
        : view.done
        ? TalkTexts.doneLabel
        : null;
    return TappableCard(
      key: ValueKey('talk-task-${t.id}'),
      padding: const EdgeInsets.all(AppSpace.s12),
      onTap: view.unlocked
          ? () async {
              await context.push(AppRoutes.talkTask(t.id));
              if (context.mounted) refreshTalk(ref);
            }
          : null,
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Opacity(
              opacity: view.unlocked ? 1 : 0.45,
              child: TalkImage(task: t, aspectRatio: 1),
            ),
          ),
          const SizedBox(width: AppSpace.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.titleTr, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpace.s4),
                Text(
                  meta,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink500,
                  ),
                ),
                if (status != null) ...[
                  const SizedBox(height: AppSpace.s4),
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          view.done
                              ? Icons.check_circle_rounded
                              : Icons.lock_outline_rounded,
                          size: AppIconSize.sm,
                          color: view.done
                              ? AppPalette.success
                              : AppPalette.ink500,
                        ),
                      ),
                      const SizedBox(width: AppSpace.s4),
                      Expanded(
                        child: Text(
                          status,
                          key: ValueKey('talk-status-${t.id}'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: view.done
                                ? AppPalette.success
                                : AppPalette.ink500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (view.unlocked)
            const ExcludeSemantics(
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppPalette.seaBlue,
              ),
            ),
        ],
      ),
    );
  }
}
