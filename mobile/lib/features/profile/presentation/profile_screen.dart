import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/domain/review_policy.dart';

/// Profil: Defter girişi ve günlük hedef (H-036; ayarların geri kalanı sonra).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final overview = ref.watch(reviewOverviewProvider).value;
    final goal = ref.watch(dailyGoalProvider).value;
    final subtitle = overview == null
        ? 'İfadeler ve ipucu panosu'
        : overview.totalItems == 0
        ? 'Henüz ifade yok · ipucu panosu'
        : '${overview.totalItems} ifade'
              '${overview.sessionCount > 0 ? ' · ${overview.sessionCount} tekrar bekliyor' : ''}';
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.sm),
          children: [
            Semantics(
              header: true,
              child: Text(
                'Profil',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                key: const ValueKey('profile-notebook'),
                minTileHeight: 64,
                leading: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.seaBlue,
                ),
                title: const Text(
                  'Defter',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(subtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  await context.push(AppRoutes.notebook);
                  if (context.mounted) refreshNotebook(ref);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Günlük hedef',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SegmentedButton<int>(
              key: const ValueKey('daily-goal'),
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(minimumSize: const Size(48, 48)),
              segments: [
                for (final m in ReviewPolicy.newCardsPerDayByGoal.keys)
                  ButtonSegment(value: m, label: Text('$m dk')),
              ],
              selected: {goal ?? ReviewPolicy.defaultDailyGoalMinutes},
              onSelectionChanged: (s) async {
                await ref
                    .read(notebookStoreProvider)
                    .setDailyGoalMinutes(s.first);
                ref.invalidate(dailyGoalProvider);
                refreshNotebook(ref);
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tekrarda günde en fazla '
              '${ReviewPolicy.newCardsPerDay(goal ?? ReviewPolicy.defaultDailyGoalMinutes)} '
              'yeni kart açılır.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
