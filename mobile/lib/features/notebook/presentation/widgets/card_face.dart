import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../../../shared/content/content_providers.dart';
import '../../application/card_audio_player.dart';
import '../../domain/notebook_item.dart';

/// Kartın görseli: bölümdeki sahne görseli (yazısız; kelimeyi uygulama yazar).
/// İsteğe bağlı kırpma `x,y,w,h` (0–1) hizalamaya çevrilir.
class NotebookImage extends ConsumerWidget {
  const NotebookImage({
    super.key,
    required this.item,
    this.aspectRatio = 4 / 3,
    this.borderRadius = AppTheme.radius,
  });

  final NotebookItem item;
  final double aspectRatio;
  final double borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = item.imagePath;
    final contentId = item.contentId;
    final placeholder = ColoredBox(
      color: AppColors.seaBlue.withValues(alpha: 0.12),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.seaBlue,
          size: 40,
          semanticLabel: 'Görsel yok',
        ),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: path == null || contentId == null
            ? placeholder
            : Image.network(
                ref
                    .watch(contentSourceProvider)
                    .mediaUri(contentId, path)
                    .toString(),
                key: ValueKey('card-image-${item.key}'),
                fit: BoxFit.cover,
                alignment: _alignment(item.imageCrop),
                cacheWidth: 720,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }

  static Alignment _alignment(String? crop) {
    final p = crop?.split(',').map(double.tryParse).toList();
    if (p == null || p.length != 4 || p.contains(null)) {
      // Dikey sahne görselinde kişiler genelde üst-orta bölgededir.
      return const Alignment(0, -0.25);
    }
    final cx = p[0]! + p[2]! / 2;
    final cy = p[1]! + p[3]! / 2;
    return Alignment(cx * 2 - 1, cy * 2 - 1);
  }
}

/// Ses düğmesi (≥ 48 px dokunma alanı).
class AudioButton extends StatelessWidget {
  const AudioButton({
    super.key,
    required this.player,
    required this.item,
    this.example = false,
    this.size = 28,
  });

  final CardAudioPlayer player;
  final NotebookItem item;
  final bool example;
  final double size;

  @override
  Widget build(BuildContext context) {
    final has = example
        ? (item.exampleAudio ?? item.audio) != null
        : item.hasAudio;
    if (!has) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: player,
      builder: (context, _) {
        final playing =
            player.playingKey == CardAudioPlayer.keyFor(item, example: example);
        return IconButton(
          key: ValueKey('audio-${example ? 'example' : 'phrase'}-${item.key}'),
          tooltip: example ? 'Cümleyi dinle' : 'Dinle',
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          onPressed: () => player.play(item, example: example),
          icon: Icon(
            playing ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
            size: size,
            color: AppColors.seaBlue,
            semanticLabel: example ? 'Cümleyi dinle' : 'İfadeyi dinle',
          ),
        );
      },
    );
  }
}

/// Kartın tamamı: görsel, ifade + 🔊, örnek cümle, Türkçe anlam.
class CardFace extends StatelessWidget {
  const CardFace({
    super.key,
    required this.item,
    required this.player,
    this.showImage = true,
  });

  final NotebookItem item;
  final CardAudioPlayer player;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = theme.textTheme.labelMedium?.copyWith(
      color: AppColors.ink.withValues(alpha: 0.7),
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
    );
    return Column(
      key: ValueKey('card-face-${item.key}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showImage) ...[
          NotebookImage(item: item),
          const SizedBox(height: AppSpacing.sm),
        ],
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  item.textEn,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            AudioButton(player: player, item: item),
          ],
        ),
        if (item.textTr != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text('TÜRKÇE ANLAMI', style: label),
          const SizedBox(height: 4),
          Text(
            item.textTr!,
            style: theme.textTheme.titleMedium?.copyWith(color: AppColors.ink),
          ),
        ],
        if (item.exampleEn != null && item.exampleEn != item.textEn) ...[
          const Divider(height: AppSpacing.md),
          Text('BÖLÜMDEKİ CÜMLE', style: label),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.exampleEn!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    if (item.exampleTr != null)
                      Text(
                        item.exampleTr!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.ink.withValues(alpha: 0.75),
                        ),
                      ),
                  ],
                ),
              ),
              AudioButton(player: player, item: item, example: true, size: 24),
            ],
          ),
        ],
      ],
    );
  }
}

/// Bölüm etiketi (`B1`).
class EpisodeTag extends StatelessWidget {
  const EpisodeTag({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minWidth: 40, minHeight: 32),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    decoration: BoxDecoration(
      color: AppColors.seaBlue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      tag,
      semanticsLabel: 'Bölüm ${tag.substring(1)}',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    ),
  );
}
