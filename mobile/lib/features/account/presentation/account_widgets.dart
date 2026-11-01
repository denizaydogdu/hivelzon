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
/// ve son eşitleme. H-102: hesap kartı ([AccountNudgeCard]) üstündeyken
/// davet cümlesini yinelemez, kısa "Hesap aç ya da giriş yap" der.
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
      final nudgeShown = ref.watch(accountNudgeProvider).value ?? false;
      subtitle =
          AccountTexts.signedOutReason(view.row?.signedOutReason) ??
          (nudgeShown ? AccountTexts.tileSignedOut : AccountTexts.localOnly);
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

/// Profil'de, Hesap grubunun üstünde ara sıra görünen, kapatılabilir kart
/// (H-038; H-102 ile Ana Sayfa'dan taşındı). Hiçbir şeyi engellemez;
/// kapatılınca 30 gün görünmez. Görünürken altına [bottomGap] boşluk bırakır
/// (gizliyken yer kaplamaz).
class AccountNudgeCard extends ConsumerWidget {
  const AccountNudgeCard({super.key, this.bottomGap = 0});

  final double bottomGap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = accountViewOf(ref.watch);
    if (view.signedIn || view.ageBlocked(DateTime.now())) {
      return const SizedBox.shrink();
    }
    final show = ref.watch(accountNudgeProvider).value ?? false;
    if (!show) return const SizedBox.shrink();
    // Tasarım H-060: ortak bilgi kartı, sakin bilgi tonu; H-102: kompakt
    // eylemler (birincil tonal, ikincil yalnız yazı).
    return Padding(
      padding: EdgeInsets.only(bottom: bottomGap),
      child: InfoCard(
        key: const ValueKey('profile-account-nudge'),
        icon: Icons.phone_iphone_rounded,
        tone: InfoTone.info,
        title: AccountTexts.nudgeTitle,
        body: AccountTexts.nudgeBody,
        action: CompactActions(
          children: [
            CompactButton.tonal(
              key: const ValueKey('profile-account-nudge-open'),
              label: AccountTexts.nudgeOpen,
              onPressed: () => unawaited(context.push(AppRoutes.account)),
            ),
            CompactButton.quiet(
              key: const ValueKey('profile-account-nudge-later'),
              label: AccountTexts.nudgeLater,
              onPressed: () => unawaited(_dismiss(ref)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dismiss(WidgetRef ref) async {
    await ref.read(accountNudgeStoreProvider).dismiss();
    ref.invalidate(accountNudgeProvider);
  }
}

/// "Metin güncellendi" kartı (H-095; H-102 ile Ana Sayfa'dan Profil'e,
/// Hakkında grubunun üstüne taşındı). Yeniden onay istenmez; kart hiçbir
/// şeyi engellemez, her yeni sürümde bir kez görünür. "Tamam" ya da metni
/// açmak sürümü görüldü sayar (yalnızca cihazda). Görünürken altına
/// [bottomGap] boşluk bırakır.
class LegalUpdateCard extends ConsumerWidget {
  const LegalUpdateCard({super.key, this.bottomGap = 0});

  final double bottomGap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final update = ref.watch(legalUpdateProvider).value ?? LegalUpdate.none;
    if (!update.any) return const SizedBox.shrink();
    Future<void> open(String kind) async {
      await markLegalTextsSeen(ref);
      if (context.mounted) unawaited(context.push(AppRoutes.legal(kind)));
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottomGap),
      child: InfoCard(
        key: const ValueKey('profile-legal-update'),
        icon: Icons.article_outlined,
        tone: InfoTone.info,
        title: AccountTexts.legalUpdateTitle(
          terms: update.terms,
          privacy: update.privacy,
        ),
        body: AccountTexts.legalUpdateBody,
        action: CompactActions(
          children: [
            if (update.terms)
              CompactButton.tonal(
                key: const ValueKey('profile-legal-update-terms'),
                label: AccountTexts.legalUpdateOpenTermsShort,
                semanticLabel: AccountTexts.legalUpdateOpenTerms,
                onPressed: () => unawaited(open('kosullar')),
              ),
            if (update.privacy)
              CompactButton.tonal(
                key: const ValueKey('profile-legal-update-privacy'),
                label: AccountTexts.legalUpdateOpenPrivacyShort,
                semanticLabel: AccountTexts.legalUpdateOpenPrivacy,
                onPressed: () => unawaited(open('aydinlatma')),
              ),
            CompactButton.quiet(
              key: const ValueKey('profile-legal-update-dismiss'),
              label: AccountTexts.legalUpdateDismiss,
              onPressed: () => unawaited(markLegalTextsSeen(ref)),
            ),
          ],
        ),
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
