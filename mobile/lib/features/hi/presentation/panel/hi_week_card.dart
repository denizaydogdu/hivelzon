// Hi paneli: haftalık özet kartı (H-063 bölme).

import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../notebook/domain/evidence_ladder.dart';
import '../../domain/weekly_summary.dart';
import 'hi_panel_parts.dart';

/// Haftanın kanıt cümlesi (H-093): en güçlü basamak; yoksa null.
String? weekEvidenceLine(WeeklySummary s) => switch (s.topEvidence) {
  (EvidenceStage.recalledLater, final n) => HiTexts.weekRecalled(n),
  (EvidenceStage.ownUse, final n) => HiTexts.weekOwnUse(n),
  (EvidenceStage.helped, final n) => HiTexts.weekHelped(n),
  _ => null,
};

/// Haftalık özet: bu hafta yapılanlar (sayı baskısı yok). H-093: önce
/// öğrenme kanıtından tek cümle, sonra sayılar.
class HiWeekCard extends StatelessWidget {
  const HiWeekCard({super.key, required this.summary});

  final WeeklySummary? summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = summary;
    if (s == null) return const HiPanelLoadingCard();
    final evidence = weekEvidenceLine(s);
    final lines = <String>[
      ?evidence,
      if (s.phrasesAdded > 0) HiTexts.weekPhrases(s.phrasesAdded),
      if (s.phrasesReviewed > 0) HiTexts.weekReviews(s.phrasesReviewed),
      if (s.episodesCompleted > 0) HiTexts.weekEpisodes(s.episodesCompleted),
      if (s.focus != null) HiTexts.weekFocus(s.focus!.labelTr),
    ];
    return Card(
      key: const ValueKey('hi-week'),
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              HiTexts.weekSub,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.ink.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            if (lines.isEmpty)
              Text(HiTexts.weekEmpty, style: theme.textTheme.bodyLarge)
            else
              for (final l in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 20,
                          color: AppColors.seaBlue,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(l, style: theme.textTheme.bodyLarge),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
