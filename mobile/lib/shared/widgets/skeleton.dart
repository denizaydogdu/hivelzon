import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// İskelet görünümü (H-054): içerik yüklenirken boş spinner yerine, gelecek
/// içeriğin kaba biçimi. Renkler temadan gelir; hareket hafif bir nabızdır.
/// "Hareketi azalt" açıksa (`MediaQuery.disableAnimations`) durağandır.
///
/// Ekran okuyucu için [label] tek bir duyuru olarak okunur; kutular okunmaz.
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, required this.label, required this.child});

  /// Erişilebilirlik duyurusu (ör. "Harita yükleniyor…").
  final String label;
  final Widget child;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.55,
    upperBound: 1,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (still) {
      _pulse
        ..stop()
        ..value = 1;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      liveRegion: true,
      container: true,
      child: ExcludeSemantics(
        child: FadeTransition(opacity: _pulse, child: widget.child),
      ),
    );
  }
}

/// Tek bir iskelet kutusu (yazı satırı, görsel, düğme yeri).
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = 6,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double height;
  final double radius;
  final BoxShape shape;

  /// Kutunun rengi: zemin üstünde belli belirsiz (açık ve koyu temada).
  static Color colorOf(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorOf(context),
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(radius),
      ),
    );
  }
}

/// Ana Sayfa "Hikâyen" kartının iskeleti: görsel şerit, başlık, iki satır, düğme.
class ContinueCardSkeleton extends StatelessWidget {
  const ContinueCardSkeleton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      key: const ValueKey('skeleton-home'),
      label: label,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 2 / 1,
              child: ColoredBox(
                color: AppColors.seaBlue.withValues(alpha: 0.12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  SkeletonBox(width: 200, height: 22),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonBox(height: 14),
                  SizedBox(height: 6),
                  SkeletonBox(width: 160, height: 14),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBox(height: 48, radius: AppTheme.radius),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hikâye haritasının iskeleti: başlık satırı ve yol üstünde birkaç bölüm yeri.
class MapSkeleton extends StatelessWidget {
  const MapSkeleton({super.key, required this.label});

  final String label;

  // Haritadaki yol hissi: alttan üste zikzak (0–1).
  static const _nodes = [
    Offset(0.42, 0.86),
    Offset(0.66, 0.70),
    Offset(0.34, 0.55),
    Offset(0.60, 0.40),
    Offset(0.38, 0.24),
    Offset(0.58, 0.10),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      key: const ValueKey('skeleton-map'),
      label: label,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(width: 220, height: 24),
            const SizedBox(height: AppSpacing.xs),
            const SkeletonBox(width: 140, height: 14),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) => Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.seaBlue.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(AppTheme.radius),
                        ),
                      ),
                    ),
                    for (final o in _nodes)
                      Positioned(
                        left: o.dx * c.maxWidth - 24,
                        top: o.dy * c.maxHeight - 24,
                        child: const SkeletonBox(
                          width: 48,
                          height: 48,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Liste iskeleti (Defter ifadeleri, İpucu panosu): [rows] satır, her biri
/// solda küçük kare ve iki satır yazı.
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({
    super.key,
    required this.label,
    this.rows = 4,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.sm,
      AppSpacing.xs,
      AppSpacing.sm,
      0,
    ),
  });

  final String label;
  final int rows;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      label: label,
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            for (var i = 0; i < rows; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.xs),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: SkeletonBox.colorOf(context).withValues(alpha: 0.04),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Row(
                    children: [
                      const SkeletonBox(width: 40, height: 40, radius: 8),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FractionallySizedBox(
                              widthFactor: i.isEven ? 0.7 : 0.55,
                              child: const SkeletonBox(height: 16),
                            ),
                            const SizedBox(height: 8),
                            FractionallySizedBox(
                              widthFactor: i.isEven ? 0.45 : 0.6,
                              child: const SkeletonBox(height: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Izgara iskeleti (H-051, konu seti nesneleri): kare görsel ve iki satır yazı.
class GridSkeleton extends StatelessWidget {
  const GridSkeleton({
    super.key,
    required this.label,
    this.count = 6,
    this.columns = 2,
  });

  final String label;
  final int count;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      label: label,
      child: GridView.count(
        crossAxisCount: columns,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.sm),
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.78,
        children: [
          for (var i = 0; i < count; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AspectRatio(
                  aspectRatio: 1,
                  child: SkeletonBox(radius: AppTheme.radius),
                ),
                const SizedBox(height: AppSpacing.xs),
                FractionallySizedBox(
                  widthFactor: i.isEven ? 0.6 : 0.5,
                  child: const SkeletonBox(height: 16),
                ),
                const SizedBox(height: 8),
                const FractionallySizedBox(
                  widthFactor: 0.4,
                  child: SkeletonBox(height: 12),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
