import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/widgets/page_header.dart';
import '../application/account_providers.dart';

/// Profil → **Hesap** bölümü (H-038): hesap yoksa sakin bir davet, 13 yaş
/// altıysa nedeni, hesap varsa e-posta ve son eşitleme.
class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = accountViewOf(ref.watch);
    final now = DateTime.now().toUtc();
    final String title;
    final String subtitle;
    var enabled = true;
    if (view.signedIn) {
      title = AccountTexts.tileSignedIn(view.row?.emailMasked ?? '');
      subtitle = view.pendingDeletion
          ? AccountTexts.pendingDeletion(
              AccountTexts.date(view.row?.scheduledPurgeAt ?? now),
            )
          : AccountTexts.syncLine(view.row?.lastSyncAt, now);
    } else if (view.ageBlocked(now)) {
      title = AccountTexts.ageBlockedTitle;
      subtitle = AccountTexts.ageBlocked;
      enabled = false;
    } else {
      title = AccountTexts.tileSignedOut;
      subtitle =
          AccountTexts.signedOutReason(view.row?.signedOutReason) ??
          AccountTexts.localOnly;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeading(AccountTexts.section),
        const SizedBox(height: AppSpacing.xs),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            key: const ValueKey('profile-account'),
            minTileHeight: 64,
            enabled: enabled,
            leading: Icon(
              view.signedIn
                  ? Icons.cloud_done_outlined
                  : Icons.person_add_alt_outlined,
              color: AppColors.seaBlue,
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(subtitle),
            trailing: enabled ? const Icon(Icons.chevron_right_rounded) : null,
            onTap: enabled ? () => context.push(AppRoutes.account) : null,
          ),
        ),
      ],
    );
  }
}

/// Ana Sayfa'daki ara sıra görünen, kapatılabilir kart (H-038). Hiçbir şeyi
/// engellemez; kapatılınca 30 gün görünmez.
class AccountNudgeCard extends ConsumerWidget {
  const AccountNudgeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = accountViewOf(ref.watch);
    if (view.signedIn || view.ageBlocked(DateTime.now())) {
      return const SizedBox.shrink();
    }
    final show = ref.watch(accountNudgeProvider).value ?? false;
    if (!show) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Card(
        key: const ValueKey('home-account-nudge'),
        margin: EdgeInsets.zero,
        elevation: 0,
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.phone_iphone_rounded,
                    color: AppColors.seaBlue,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      AccountTexts.nudgeTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(AccountTexts.nudgeBody, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                children: [
                  OutlinedButton(
                    key: const ValueKey('home-account-nudge-open'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                    onPressed: () => context.push(AppRoutes.account),
                    child: const Text(AccountTexts.nudgeOpen),
                  ),
                  TextButton(
                    key: const ValueKey('home-account-nudge-later'),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                    onPressed: () => unawaited(_dismiss(ref)),
                    child: const Text(AccountTexts.nudgeLater),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dismiss(WidgetRef ref) async {
    await ref.read(accountNudgeStoreProvider).dismiss();
    ref.invalidate(accountNudgeProvider);
  }
}

/// Kesin metinler gelene kadar (H-042) hukuk metinlerinin yer tutucusu.
class LegalTextScreen extends ConsumerWidget {
  const LegalTextScreen({super.key, required this.kind});

  /// `kosullar` | `aydinlatma`
  final String kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(apiConfigProvider);
    final terms = kind != 'aydinlatma';
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          terms ? AccountTexts.termsTitle : AccountTexts.privacyTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.sm),
          children: [
            Text(
              AccountTexts.legalVersion(
                terms ? config.termsVersion : config.privacyNoticeVersion,
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(AccountTexts.legalDraft, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              terms
                  ? AccountTexts.termsDraftBody
                  : AccountTexts.privacyDraftBody,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
