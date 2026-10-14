import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets/page_header.dart';
import '../player/presentation/widgets/hi_avatar.dart';

// Vitrin (H-057) için Hi ifadeleri (H-063). Geliştirici aracıdır; metinler
// burada durur.

/// İfadenin vitrindeki adı.
String showcaseHiLabel(HiExpression e) => switch (e) {
  HiExpression.neutral => 'Sakin',
  HiExpression.happy => 'Mutlu',
  HiExpression.thinking => 'Düşünen',
  HiExpression.waving => 'El sallayan',
  HiExpression.sleepy => 'Uykulu',
  HiExpression.surprised => 'Şaşkın',
  HiExpression.listening => 'Dinleyen',
};

/// Hi'nin bütün ifadeleri yan yana ve geçişleri denemek için büyük bir Hi.
class ShowcaseHiSection extends StatefulWidget {
  const ShowcaseHiSection({super.key});

  @override
  State<ShowcaseHiSection> createState() => _ShowcaseHiSectionState();
}

class _ShowcaseHiSectionState extends State<ShowcaseHiSection> {
  HiExpression _live = HiExpression.neutral;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeading('Hi ifadeleri'),
        const SizedBox(height: AppSpace.s12),
        Wrap(
          spacing: AppSpace.s12,
          runSpacing: AppSpace.s12,
          children: [
            for (final e in HiExpression.values)
              SizedBox(
                key: ValueKey('showcase-hi-${e.name}'),
                width: 104,
                child: Column(
                  children: [
                    HiAvatar(size: 80, expression: e, pulseCycles: 1),
                    const SizedBox(height: AppSpace.s4),
                    Text(
                      showcaseHiLabel(e),
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpace.s16),
        Text('Geçiş', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpace.s8),
        Center(
          child: HiAvatar(
            key: const ValueKey('showcase-hi-live'),
            size: 120,
            expression: _live,
            pulseCycles: 1,
          ),
        ),
        const SizedBox(height: AppSpace.s8),
        Wrap(
          spacing: AppSpace.s8,
          runSpacing: AppSpace.s4,
          children: [
            for (final e in HiExpression.values)
              ChoiceChip(
                key: ValueKey('showcase-hi-pick-${e.name}'),
                label: Text(showcaseHiLabel(e)),
                selected: _live == e,
                onSelected: (_) => setState(() => _live = e),
              ),
          ],
        ),
      ],
    );
  }
}
