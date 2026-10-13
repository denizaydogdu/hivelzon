import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../notebook/application/card_audio_player.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/presentation/notebook_screen.dart' show createCardAudio;
import '../../notebook/presentation/widgets/card_face.dart';
import '../application/topic_set_providers.dart';
import '../domain/topic_set.dart';
import 'topic_set_widgets.dart';

/// Konu seti (H-051): sahne avı girişi ve nesne ızgarası (görsel + kelime).
class TopicSetScreen extends ConsumerStatefulWidget {
  const TopicSetScreen({super.key, required this.setId});

  final String setId;

  @override
  ConsumerState<TopicSetScreen> createState() => _TopicSetScreenState();
}

class _TopicSetScreenState extends ConsumerState<TopicSetScreen> {
  late final CardAudioPlayer _audio;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _audio = createCardAudio(ref);
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  void _refreshDeck() {
    ref.invalidate(deckKeysProvider);
    refreshNotebook(ref);
  }

  Future<void> _add(TopicSet set, List<TopicSetItem> items) async {
    if (_busy) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final added = await ref
          .read(topicSetActionsProvider)
          .addToDeck(set, items);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            items.length == 1 && added == 1
                ? TopicSetTexts.addedOne(items.single.w)
                : TopicSetTexts.addedAll(added),
          ),
        ),
      );
    } on Object catch (e) {
      debugPrint('[H051] deftere eklenemedi: $e');
      messenger.showSnackBar(
        const SnackBar(content: Text(TopicSetTexts.addError)),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        _refreshDeck();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final set = ref.watch(topicSetProvider(widget.setId));
    final theme = Theme.of(context);
    final title = set.value?.titleTr ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        top: false,
        child: switch (set) {
          AsyncData(:final value) => _content(value),
          AsyncError() => Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(TopicSetTexts.setError, style: theme.textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 48),
                  ),
                  onPressed: () =>
                      ref.invalidate(topicSetProvider(widget.setId)),
                  child: const Text(CommonTexts.retry),
                ),
              ],
            ),
          ),
          _ => const SingleChildScrollView(
            child: GridSkeleton(
              key: ValueKey('skeleton-topic-set'),
              label: TopicSetTexts.setLoading,
            ),
          ),
        },
      ),
    );
  }

  Widget _content(TopicSet set) {
    final theme = Theme.of(context);
    final keys = ref.watch(deckKeysProvider).value ?? const <String>{};
    final inDeck = set.items.where((i) => keys.contains(i.notebookKey));
    final allIn = inDeck.length == set.items.length;
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 600 ? 3 : 2;
    return CustomScrollView(
      key: const ValueKey('topic-set-screen'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.xs,
            AppSpacing.sm,
            0,
          ),
          sliver: SliverList.list(
            children: [
              _HuntCard(set: set),
              const SizedBox(height: AppSpacing.md),
              Semantics(
                header: true,
                child: Text(
                  TopicSetTexts.gridHeading,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                TopicSetTexts.inDeckCount(inDeck.length, set.items.length),
                key: const ValueKey('topic-set-count'),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              OutlinedButton.icon(
                key: const ValueKey('topic-set-add-all'),
                onPressed: allIn || _busy ? null : () => _add(set, set.items),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.seaBlue,
                  side: const BorderSide(color: AppColors.seaBlue, width: 1.5),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: Icon(
                  allIn
                      ? Icons.check_circle_rounded
                      : Icons.library_add_rounded,
                ),
                label: Text(
                  allIn ? TopicSetTexts.allInDeck : TopicSetTexts.addAll,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            0,
            AppSpacing.sm,
            AppSpacing.lg,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.74,
            ),
            itemCount: set.items.length,
            itemBuilder: (context, i) {
              final it = set.items[i];
              return _ItemCard(
                item: it,
                inDeck: keys.contains(it.notebookKey),
                onOpen: () => _openItem(set, it),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _openItem(TopicSet set, TopicSetItem it) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: AppColors.sand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radius),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (context, scroll) => Consumer(
          builder: (context, ref, _) {
            final keys = ref.watch(deckKeysProvider).value ?? const {};
            final inDeck = keys.contains(it.notebookKey);
            return ListView(
              key: const ValueKey('topic-item-detail'),
              controller: scroll,
              padding: const EdgeInsets.all(AppSpacing.sm),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: CommonTexts.close,
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
                CardFace(item: set.toNotebookItem(it), player: _audio),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  key: const ValueKey('topic-item-add'),
                  onPressed: inDeck ? null : () => _add(set, [it]),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  icon: Icon(
                    inDeck ? Icons.check_circle_rounded : Icons.add_rounded,
                  ),
                  label: Text(
                    inDeck ? TopicSetTexts.inDeck : TopicSetTexts.addOne,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    unawaited(_audio.stop());
  }
}

/// Sahne avı girişi: sahne görseli ve tek cümle.
class _HuntCard extends StatelessWidget {
  const _HuntCard({required this.set});

  final TopicSet set;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: const ValueKey('topic-set-hunt-card'),
      margin: EdgeInsets.zero,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 2.5,
            child: SetImage(
              path: set.sceneImage,
              alignment: const Alignment(0, -0.1),
              cacheWidth: 1080,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  TopicSetTexts.huntHeading,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  TopicSetTexts.huntIntro,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  key: const ValueKey('topic-set-hunt'),
                  onPressed: () => context.push(AppRoutes.sceneHunt(set.id)),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  icon: const Icon(Icons.search_rounded),
                  label: const Text(TopicSetTexts.huntStart),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Izgaradaki nesne: görsel + kelime + Türkçesi; defterdeyse işaret.
class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.inDeck,
    required this.onOpen,
  });

  final TopicSetItem item;
  final bool inDeck;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: TopicSetTexts.itemSemantics(item.w, item.tr, inDeck),
      excludeSemantics: true,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('topic-item-${item.id}'),
          onTap: onOpen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SetImage(path: item.image, cacheWidth: 384),
                    if (inDeck)
                      const Positioned(
                        top: AppSpacing.xs,
                        right: AppSpacing.xs,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.seaBlue,
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xs,
                  AppSpacing.xs,
                  AppSpacing.xs,
                  0,
                ),
                child: Text(
                  item.w,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  item.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.ink.withValues(alpha: 0.75),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
