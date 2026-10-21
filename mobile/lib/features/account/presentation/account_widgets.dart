import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../application/account_providers.dart';

/// Profil → **Hesap** satırı (H-038; tasarım H-059): hesap yoksa sakin bir
/// davet, 13 yaş altıysa nedeni (satır kapalı), hesap varsa maskeli e-posta
/// ve son eşitleme.
class AccountRow extends ConsumerWidget {
  const AccountRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = accountViewOf(ref.watch);
    final now = DateTime.now().toUtc();
    final String subtitle;
    final String value;
    var enabled = true;
    if (view.signedIn) {
      value = view.row?.emailMasked ?? '';
      subtitle = view.pendingDeletion
          ? AccountTexts.pendingDeletion(
              AccountTexts.date(view.row?.scheduledPurgeAt ?? now),
            )
          : AccountTexts.syncLine(view.row?.lastSyncAt, now);
    } else if (view.deletion != null) {
      // H-042: oturum kapalı ama silme isteği bekliyor.
      value = AccountTexts.rowValueSignedOut;
      subtitle = AccountTexts.pendingDeletion(
        AccountTexts.date(view.deletion!.purgeAt),
      );
    } else if (view.ageBlocked(now)) {
      value = AccountTexts.rowValueBlocked;
      subtitle = AccountTexts.ageBlocked;
      enabled = false;
    } else {
      value = AccountTexts.rowValueSignedOut;
      subtitle =
          AccountTexts.signedOutReason(view.row?.signedOutReason) ??
          AccountTexts.localOnly;
    }
    return SettingsRow(
      key: const ValueKey('profile-account'),
      icon: view.signedIn
          ? Icons.cloud_done_outlined
          : Icons.person_outline_rounded,
      title: AccountTexts.section,
      subtitle: subtitle,
      value: value,
      onTap: enabled ? () => context.push(AppRoutes.account) : null,
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
    // Tasarım H-060: ortak bilgi kartı, sakin bilgi tonu.
    return InfoCard(
      key: const ValueKey('home-account-nudge'),
      icon: Icons.phone_iphone_rounded,
      tone: InfoTone.info,
      title: AccountTexts.nudgeTitle,
      body: AccountTexts.nudgeBody,
      action: Wrap(
        spacing: AppSpace.s8,
        runSpacing: AppSpace.s4,
        children: [
          OutlinedButton(
            key: const ValueKey('home-account-nudge-open'),
            onPressed: () => context.push(AppRoutes.account),
            child: const Text(AccountTexts.nudgeOpen),
          ),
          TextButton(
            key: const ValueKey('home-account-nudge-later'),
            onPressed: () => unawaited(_dismiss(ref)),
            child: const Text(AccountTexts.nudgeLater),
          ),
        ],
      ),
    );
  }

  Future<void> _dismiss(WidgetRef ref) async {
    await ref.read(accountNudgeStoreProvider).dismiss();
    ref.invalidate(accountNudgeProvider);
  }
}

/// Ana Sayfa'da "metin güncellendi" kartı (H-095). Yeniden onay istenmez;
/// kart hiçbir şeyi engellemez, her yeni sürümde bir kez görünür. "Tamam"
/// ya da metni açmak sürümü görüldü sayar (yalnızca cihazda).
class LegalUpdateCard extends ConsumerWidget {
  const LegalUpdateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final update = ref.watch(legalUpdateProvider).value ?? LegalUpdate.none;
    if (!update.any) return const SizedBox.shrink();
    Future<void> open(String kind) async {
      await markLegalTextsSeen(ref);
      if (context.mounted) unawaited(context.push(AppRoutes.legal(kind)));
    }

    return InfoCard(
      key: const ValueKey('home-legal-update'),
      icon: Icons.article_outlined,
      tone: InfoTone.info,
      title: AccountTexts.legalUpdateTitle(
        terms: update.terms,
        privacy: update.privacy,
      ),
      body: AccountTexts.legalUpdateBody,
      action: Wrap(
        spacing: AppSpace.s8,
        runSpacing: AppSpace.s4,
        children: [
          if (update.terms)
            OutlinedButton(
              key: const ValueKey('home-legal-update-terms'),
              onPressed: () => unawaited(open('kosullar')),
              child: const Text(AccountTexts.legalUpdateOpenTerms),
            ),
          if (update.privacy)
            OutlinedButton(
              key: const ValueKey('home-legal-update-privacy'),
              onPressed: () => unawaited(open('aydinlatma')),
              child: const Text(AccountTexts.legalUpdateOpenPrivacy),
            ),
          TextButton(
            key: const ValueKey('home-legal-update-dismiss'),
            onPressed: () => unawaited(markLegalTextsSeen(ref)),
            child: const Text(AccountTexts.legalUpdateDismiss),
          ),
        ],
      ),
    );
  }
}

/// Hukuk metinleri (H-095 taslağı; hukukçu gözden geçirecek; tasarım H-059):
/// sürüm etiketi, taslak notu, başlıklı bölümler; okunur satır genişliği (en
/// fazla 600 px).
class LegalTextScreen extends ConsumerWidget {
  const LegalTextScreen({super.key, required this.kind});

  /// `kosullar` | `aydinlatma`
  final String kind;

  static const double maxWidth = 600;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(apiConfigProvider);
    final terms = kind != 'aydinlatma';
    final theme = Theme.of(context);
    final sections = terms
        ? AccountTexts.termsSections
        : AccountTexts.privacySections;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          terms ? AccountTexts.termsTitle : AccountTexts.privacyTitle,
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          key: const ValueKey('legal-text'),
          padding: const EdgeInsets.fromLTRB(
            AppSpace.page,
            AppSpace.s8,
            AppSpace.page,
            AppSpace.s32,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CapsLabel(
                      AccountTexts.legalVersion(
                        terms
                            ? config.termsVersion
                            : config.privacyNoticeVersion,
                      ),
                      tone: CapsTone.blue,
                    ),
                    const SizedBox(height: AppSpace.s16),
                    const InfoCard(
                      tone: InfoTone.warning,
                      icon: Icons.edit_note_rounded,
                      title: AccountTexts.legalDraftTitle,
                      body: AccountTexts.legalDraft,
                    ),
                    for (final (heading, body) in sections) ...[
                      const SizedBox(height: AppSpace.s24),
                      Semantics(
                        header: true,
                        child: Text(heading, style: theme.textTheme.titleLarge),
                      ),
                      const SizedBox(height: AppSpace.s8),
                      Text(
                        body,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: AppPalette.ink700,
                        ),
                      ),
                    ],
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
