import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../player/presentation/widgets/hi_avatar.dart';
import '../application/hi_providers.dart';
import 'hi_panel.dart';

/// Hi balonu yalnızca beş sekmenin kök sayfasında görünür (H-048). Defter,
/// oynatıcı, kelime tekrarı, sahne avı, jenerik ve modallar onun üstündedir
/// ya da sekme dışıdır.
bool hiBubbleVisibleFor(String path) => const {
  AppRoutes.home,
  AppRoutes.discover,
  AppRoutes.story,
  AppRoutes.talk,
  AppRoutes.profile,
}.contains(path);

/// Sağ altta, menünün üstünde yuvarlak, ışıklı Hi. Bugün yeni öneri varsa
/// küçük bir nokta (sayı yok, baskı yok).
class HiBubble extends ConsumerWidget {
  const HiBubble({super.key});

  static const double size = 64;

  /// Sayfaların alttan bırakması gereken boşluk: balon (64) + alt pay (16) +
  /// aralık (8). Bkz. `ShellScaffold`.
  static const double clearance = size + AppSpacing.sm + AppSpacing.xs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badge = ref.watch(hiBadgeProvider).value ?? false;
    return Semantics(
      button: true,
      label: badge ? HiTexts.bubbleLabelNew : HiTexts.bubbleLabel,
      excludeSemantics: true,
      child: Material(
        key: const ValueKey('hi-bubble'),
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => showHiPanel(context, ref),
          child: SizedBox.square(
            dimension: size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.seaBlue,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
                const Center(child: HiAvatar(size: 58, pulseCycles: 2)),
                if (badge)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      key: const ValueKey('hi-bubble-badge'),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.eveningOrange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
