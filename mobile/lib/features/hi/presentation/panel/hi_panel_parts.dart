// Hi paneli (H-047) ortak parçaları: tanıtım satırı, bölüm başlığı ve
// yükleniyor kartı. H-063'te `hi_panel.dart`'tan davranış değişmeden ayrıldı.
import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../player/presentation/widgets/hi_avatar.dart';

/// Panelin üstü: Hi (ilk açılışta bir kez el sallar, sonra [expression]),
/// yapay zekâ açıklaması ve kapatma düğmesi.
class HiPanelIntro extends StatelessWidget {
  const HiPanelIntro({super.key, this.expression = HiExpression.neutral});

  final HiExpression expression;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        HiAvatar(
          key: const ValueKey('hi-panel-avatar'),
          size: 64,
          expression: expression,
          greet: true,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HiTexts.intro,
                key: const ValueKey('hi-disclosure'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(HiTexts.introSub, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        IconButton(
          tooltip: CommonTexts.close,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

/// Panel bölüm başlığı (ekran okuyucuda başlık).
class HiPanelHeading extends StatelessWidget {
  const HiPanelHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

/// Veri gelene kadar sakin yer tutucu (sonsuz spinner yok).
class HiPanelLoadingCard extends StatelessWidget {
  const HiPanelLoadingCard({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    label: HiTexts.loading,
    child: Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
    ),
  );
}
