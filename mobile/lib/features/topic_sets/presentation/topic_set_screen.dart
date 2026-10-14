import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../notebook/application/card_audio_player.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/presentation/notebook_screen.dart' show createCardAudio;
import '../../notebook/presentation/widgets/card_face.dart';
import '../application/topic_set_providers.dart';
import '../domain/topic_set.dart';
import 'topic_set_widgets.dart';

/// Konu seti (H-051): sahne avı girişi ve nesne ızgarası (görsel + kelime).
/// Tasarım (H-061, taslak S06): dalga kesimli sahne görselli "Sahne avı"
/// kartı; ızgara kartları basınca hafifçe küçülür ve ilk açılışta sırayla
/// belirir.
class TopicSetScreen extends ConsumerStatefulWidget {
  const TopicSetScreen({super.key, required this.setId});

  final String setId;

  @override
  ConsumerState<TopicSetScreen> createState() => _TopicSetScreenState();
}

class _TopicSetScreenState extends ConsumerState<TopicSetScreen> {
  late final CardAudioPlayer _audio;
  bool _busy = false;

  /// Belirme animasyonu oynamış ızgara öğeleri (kaydırınca yeniden oynamaz).
  final Set<Object> _seen = {};

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
    final title = set.value?.titleTr ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        top: false,
        child: switch (set) {
          AsyncData(:final value) => _content(value),
          AsyncError() => SingleChildScrollView(
            child: EmptyState(
              icon: Icons.error_outline_rounded,
              title: TopicSetTexts.setError,
              action: OutlinedButton(
                onPressed: () => ref.invalidate(topicSetProvider(widget.setId)),
                child: const Text(CommonTexts.retry),
              ),
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
            AppSpace.page,
            AppSpace.s8,
            AppSpace.page,
            0,
          ),
          sliver: SliverList.list(
            children: [
              FadeSlideIn(child: _HuntCard(set: set)),
              const SizedBox(height: AppSpace.s24),
              Semantics(
                header: true,
                child: Text(
                  TopicSetTexts.gridHeading,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: AppSpace.s4),
              Text(
                TopicSetTexts.inDeckCount(inDeck.length, set.items.length),
                key: const ValueKey('topic-set-count'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppPalette.ink500,
                ),
              ),
              const SizedBox(height: AppSpace.s12),
              // Tema ikincil düğmesi (deniz mavisi kenar).
              OutlinedButton.icon(
                key: const ValueKey('topic-set-add-all'),
                onPressed: allIn || _busy ? null : () => _add(set, set.items),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppTouch.min),
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
              const SizedBox(height: AppSpace.s16),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.page,
            0,
            AppSpace.page,
            AppSpace.s32,
          ),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) => SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: AppSpace.s12,
                crossAxisSpacing: AppSpace.s12,
                mainAxisExtent: _itemExtent(
                  context,
                  constraints.crossAxisExtent,
                  columns,
                ),
              ),
              itemCount: set.items.length,
              itemBuilder: (context, i) {
                final it = set.items[i];
                return StaggerOnce(
                  id: it.id,
                  index: i,
                  seen: _seen,
                  child: _ItemCard(
                    item: it,
                    inDeck: keys.contains(it.notebookKey),
                    onOpen: () => _openItem(set, it),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Izgara kartının yüksekliği: kare görsel + kelime ve Türkçesi (iki
  /// satır, yazı büyütmesiyle birlikte). Büyük yazıda kart uzar, kesilmez.
  double _itemExtent(BuildContext context, double width, int columns) {
    final item = (width - (columns - 1) * AppSpace.s12) / columns;
    final scaler = MediaQuery.textScalerOf(context);
    // titleMedium 24 px + bodyMedium 20 px satır yüksekliği + boşluklar.
    return item +
        AppSpace.s8 +
        scaler.scale(24) +
        scaler.scale(20) +
        AppSpace.s12;
  }

  Future<void> _openItem(TopicSet set, TopicSetItem it) async {
    await showAppSheet<void>(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final keys = ref.watch(deckKeysProvider).value ?? const {};
          final inDeck = keys.contains(it.notebookKey);
          return SingleChildScrollView(
            key: const ValueKey('topic-item-detail'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardFace(item: set.toNotebookItem(it), player: _audio),
                const SizedBox(height: AppSpace.s24),
                FilledButton.icon(
                  key: const ValueKey('topic-item-add'),
                  onPressed: inDeck ? null : () => _add(set, [it]),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppTouch.primary),
                  ),
                  icon: Icon(
                    inDeck ? Icons.check_circle_rounded : Icons.add_rounded,
                  ),
                  label: Text(
                    inDeck ? TopicSetTexts.inDeck : TopicSetTexts.addOne,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    unawaited(_audio.stop());
  }
}

/// Sahne avı girişi (taslak S06): dalga kesimli sahne görseli, başlık, tek
/// cümle ve tam genişlik ana eylem.
class _HuntCard extends StatelessWidget {
  const _HuntCard({required this.set});

  final TopicSet set;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TappableCard(
      key: const ValueKey('topic-set-hunt-card'),
      elevated: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipPath(
            clipper: const ShapedEdgeClipper(HeaderShape.wave),
            child: AspectRatio(
              aspectRatio: 2.4,
              child: SetImage(
                path: set.sceneImage,
                alignment: const Alignment(0, -0.1),
                cacheWidth: 1080,
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
                Row(
                  children: [
                    const ExcludeSemantics(
                      child: Icon(
                        Icons.travel_explore_rounded,
                        color: AppPalette.orange700,
                      ),
                    ),
                    const SizedBox(width: AppSpace.s8),
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(
                          TopicSetTexts.huntHeading,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppPalette.seaBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.s4),
                Text(
                  TopicSetTexts.huntIntro,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink700,
                  ),
                ),
                const SizedBox(height: AppSpace.s16),
                FilledButton.icon(
                  key: const ValueKey('topic-set-hunt'),
                  onPressed: () => context.push(AppRoutes.sceneHunt(set.id)),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppTouch.primary),
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

/// Izgaradaki nesne: görsel + kelime + Türkçesi; defterdeyse yeşil işaret.
/// Basınca hafifçe küçülür ([TappableCard]).
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
    return TappableCard(
      key: ValueKey('topic-item-${item.id}'),
      onTap: onOpen,
      padding: EdgeInsets.zero,
      semanticLabel: TopicSetTexts.itemSemantics(item.w, item.tr, inDeck),
      child: ExcludeSemantics(
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
                      top: AppSpace.s8,
                      right: AppSpace.s8,
                      child: DecoratedBox(
                        key: ValueKey('topic-item-in-deck'),
                        decoration: BoxDecoration(
                          color: AppPalette.white,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.level1,
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: AppPalette.success,
                          size: AppIconSize.md,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.s12,
                AppSpace.s8,
                AppSpace.s12,
                0,
              ),
              child: Text(
                item.w,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppPalette.seaBlue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s12),
              child: Text(
                item.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppPalette.ink500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
