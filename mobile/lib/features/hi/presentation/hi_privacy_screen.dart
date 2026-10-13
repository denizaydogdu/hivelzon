import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/meaning/error_taxonomy.dart';
import '../../profile/application/profile_providers.dart';
import '../application/hi_providers.dart';
import '../domain/weekly_summary.dart';

/// Profil → "Hi benim hakkımda ne biliyor?" (H-048, HI-ASISTAN-VE-KOC §5).
///
/// Cihazda saklananları sade dille listeler; "Hi'nin kayıtlarını sil" yalnızca
/// öğrenme olaylarını ve yan görev durumlarını siler (onaylı). İlerleme,
/// defter ve ad silinmez.
class HiPrivacyScreen extends ConsumerWidget {
  const HiPrivacyScreen({super.key});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(HiTexts.privacyConfirmTitle),
        content: const Text(HiTexts.privacyConfirmBody),
        actions: [
          TextButton(
            key: const ValueKey('hi-privacy-cancel'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(HiTexts.privacyConfirmCancel),
          ),
          FilledButton(
            key: const ValueKey('hi-privacy-confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(HiTexts.privacyConfirmDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(hiStoreProvider).deleteLearningData();
    refreshHi(ref);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(HiTexts.privacyDeleted)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final k = ref.watch(hiKnowledgeProvider);
    final name = ref.watch(displayNameProvider).value;
    final week = ref.watch(weeklySummaryProvider).value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text(
          HiTexts.privacyTitle,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: switch (k) {
          AsyncData(:final value) => ListView(
            key: const ValueKey('hi-privacy'),
            padding: const EdgeInsets.all(AppSpacing.sm),
            children: [
              Text(HiTexts.privacyIntro, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.sm),
              _Row(
                icon: Icons.badge_outlined,
                title: HiTexts.privacyName,
                value: name ?? HiTexts.privacyNoName,
              ),
              _Row(
                icon: Icons.auto_stories_outlined,
                title: HiTexts.privacyProgress,
                value: HiTexts.privacyProgressValue(
                  value.completedEpisodes,
                  value.inProgressEpisodes,
                ),
              ),
              _Row(
                icon: Icons.menu_book_outlined,
                title: HiTexts.privacyNotebook,
                value: HiTexts.privacyNotebookValue(
                  value.notebookItems,
                  value.reviewAnswers,
                ),
              ),
              _Row(
                key: const ValueKey('hi-privacy-events'),
                icon: Icons.insights_outlined,
                title: HiTexts.privacyEvents,
                value: HiTexts.privacyEventsValue(value.lookups, value.errors),
              ),
              _Row(
                key: const ValueKey('hi-privacy-errors'),
                icon: Icons.translate_rounded,
                title: HiTexts.privacyErrors,
                value: _errorLines(value.errorCounts),
              ),
              _Row(
                icon: Icons.calendar_today_outlined,
                title: HiTexts.privacyWeek,
                value: _weekText(week),
              ),
              _Row(
                icon: Icons.flag_outlined,
                title: HiTexts.privacyBridge,
                value: HiTexts.privacyBridgeValue(
                  value.bridgeDone,
                  value.bridgeDismissed,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                HiTexts.privacyDeleteNote,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              OutlinedButton.icon(
                key: const ValueKey('hi-privacy-delete'),
                onPressed: () => unawaited(_delete(context, ref)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text(HiTexts.privacyDelete),
              ),
            ],
          ),
          AsyncError() => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text(HiTexts.privacyError, textAlign: TextAlign.center),
            ),
          ),
          _ => const Center(
            child: CircularProgressIndicator(semanticsLabel: HiTexts.loading),
          ),
        },
      ),
    );
  }
}

String _errorLines(Map<ErrorType, int> counts) {
  if (counts.isEmpty) return HiTexts.privacyErrorsNone;
  final sorted = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return [for (final e in sorted) '${e.key.labelTr}: ${e.value}'].join('\n');
}

String _weekText(WeeklySummary? w) {
  if (w == null) return HiTexts.loading;
  final lines = [
    if (w.phrasesAdded > 0) HiTexts.weekPhrases(w.phrasesAdded),
    if (w.phrasesReviewed > 0) HiTexts.weekReviews(w.phrasesReviewed),
    if (w.episodesCompleted > 0) HiTexts.weekEpisodes(w.episodesCompleted),
    if (w.focus != null) HiTexts.weekFocus(w.focus!.labelTr),
  ];
  return lines.isEmpty ? HiTexts.weekEmpty : lines.join('\n');
}

class _Row extends StatelessWidget {
  const _Row({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.seaBlue),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(value, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Profil'deki giriş satırı.
class HiPrivacyTile extends StatelessWidget {
  const HiPrivacyTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: ListTile(
      key: const ValueKey('profile-hi-privacy'),
      minTileHeight: 64,
      leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.seaBlue),
      title: const Text(
        HiTexts.privacyTile,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: const Text(HiTexts.privacyTileSub),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    ),
  );
}
