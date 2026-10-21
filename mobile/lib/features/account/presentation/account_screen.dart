import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/api/api_client.dart';
import '../../../shared/ui/ui.dart';
import '../../profile/application/profile_providers.dart';
import '../../reminder/application/reminder_providers.dart';
import '../application/account_providers.dart';

/// Profil → Hesap (H-038).
///
/// - Oturum kapalı: hesabın ne işe yaradığı (isteğe bağlı) ve giriş yolları
///   (şimdilik e-posta kodu; Apple/Google H-044'te aynı listeye eklenir).
/// - Oturum açık: e-posta (maskeli), son eşitleme, "Şimdi eşitle", "Çıkış
///   yap", "Hesabımı sil".
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static const headerImage = AssetImage('assets/illustrations/hosgeldin.webp');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = accountViewOf(ref.watch);
    return Scaffold(
      appBar: AppBar(title: const Text(AccountTexts.title)),
      body: SafeArea(
        top: false,
        child: ListView(
          key: const ValueKey('account-screen'),
          padding: const EdgeInsets.only(bottom: AppSpace.s32),
          children: view.signedIn
              ? [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpace.page,
                      AppSpace.s8,
                      AppSpace.page,
                      0,
                    ),
                    child: _SignedIn(view: view),
                  ),
                ]
              : [
                  const ShapedHeader(
                    shape: HeaderShape.diagonal,
                    image: headerImage,
                    height: 190,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpace.page,
                    ),
                    child: _SignedOut(view: view),
                  ),
                ],
        ),
      ),
    );
  }
}

class _SignedOut extends StatelessWidget {
  const _SignedOut({required this.view});

  final AccountView view;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now().toUtc();
    final reason = AccountTexts.signedOutReason(view.row?.signedOutReason);
    final deletion = view.deletion;
    if (deletion == null && view.ageBlocked(now)) {
      return const InfoCard(
        key: ValueKey('account-age-blocked'),
        title: AccountTexts.ageBlockedTitle,
        body: AccountTexts.ageBlocked,
      );
    }
    return StaggeredList(
      children: [
        // H-042: silme isteği bu telefondan yapıldı; oturum kapansa da durum
        // ve kalıcı silme tarihi görünür, geri alma yolu açıktır.
        if (deletion != null)
          InfoCard(
            key: const ValueKey('account-pending-deletion-signed-out'),
            tone: InfoTone.warning,
            icon: Icons.schedule_rounded,
            title: AccountTexts.restoreHeading,
            body: AccountTexts.signedOutPendingBody(
              AccountTexts.date(deletion.purgeAt),
            ),
            action: FilledButton(
              key: const ValueKey('account-restore-signed-out'),
              onPressed: () => context.push(AppRoutes.signIn),
              child: const Text(AccountTexts.restore),
            ),
          ),
        if (reason != null)
          InfoCard(
            key: const ValueKey('account-signed-out-reason'),
            tone: InfoTone.warning,
            icon: Icons.lock_outline_rounded,
            title: reason,
          ),
        Semantics(
          header: true,
          child: Text(AccountTexts.intro, style: theme.textTheme.titleMedium),
        ),
        const _BenefitCard(),
        // Giriş yolları listesi: Apple ve Google (H-044) buraya eklenir.
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              key: const ValueKey('account-email'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              onPressed: () => context.push(AppRoutes.signIn),
              icon: const Icon(Icons.mail_outline_rounded),
              label: const Text(AccountTexts.methodEmail),
            ),
            const SizedBox(height: AppSpace.s8),
            Text(
              AccountTexts.methodEmailNote,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppPalette.ink500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Hesabın üç faydası: yuvarlak, renkli zeminli ikon + kısa başlık +
/// açıklama.
class _BenefitCard extends StatelessWidget {
  const _BenefitCard();

  @override
  Widget build(BuildContext context) {
    return const SettingsGroup(
      children: [
        _Benefit(
          icon: Icons.cloud_upload_outlined,
          background: AppPalette.yellow100,
          foreground: AppPalette.yellow700,
          title: AccountTexts.benefitBackupTitle,
          body: AccountTexts.benefitBackup,
        ),
        _Benefit(
          icon: Icons.devices_outlined,
          background: AppPalette.seaBlue50,
          foreground: AppPalette.seaBlue,
          title: AccountTexts.benefitDevicesTitle,
          body: AccountTexts.benefitDevices,
        ),
        _Benefit(
          icon: Icons.sentiment_satisfied_alt_rounded,
          background: AppPalette.successSurface,
          foreground: AppPalette.success,
          title: AccountTexts.benefitLocalTitle,
          body: AccountTexts.benefitLocal,
        ),
      ],
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpace.s16),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Container(
              width: AppSpace.s48,
              height: AppSpace.s48,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: foreground, size: AppIconSize.md),
            ),
          ),
          const SizedBox(width: AppSpace.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppPalette.seaBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignedIn extends ConsumerStatefulWidget {
  const _SignedIn({required this.view});

  final AccountView view;

  @override
  ConsumerState<_SignedIn> createState() => _SignedInState();
}

class _SignedInState extends ConsumerState<_SignedIn> {
  bool _busy = false;

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _syncNow() async {
    setState(() => _busy = true);
    final outcome = await ref.read(syncControllerProvider.notifier).syncNow();
    if (!mounted) return;
    setState(() => _busy = false);
    _snack(
      outcome.ok
          ? AccountTexts.syncNowDone
          : (outcome.error?.message ?? AccountTexts.syncLater),
    );
  }

  Future<bool?> _confirm(
    String title,
    String body,
    String action, {
    bool danger = false,
  }) => showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          key: const ValueKey('account-confirm-cancel'),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AccountTexts.cancel),
        ),
        FilledButton(
          key: const ValueKey('account-confirm-ok'),
          style: danger ? AppButtonStyles.dangerFilled() : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(action),
        ),
      ],
    ),
  );

  Future<void> _signOut({required bool wipe}) async {
    final ok = wipe
        ? await _confirm(
            AccountTexts.wipeTitle,
            AccountTexts.wipeBody,
            AccountTexts.wipeConfirm,
            danger: true,
          )
        : await _confirm(
            AccountTexts.signOutTitle,
            AccountTexts.signOutBody,
            AccountTexts.signOut,
          );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    // Son değişiklikler gitsin (bağlantı yoksa veri telefonda kalır).
    await ref.read(syncControllerProvider.notifier).syncNow();
    await ref.read(authServiceProvider).signOut();
    if (wipe) {
      await ref.read(syncStoreProvider).wipeLocalLearningData();
      // H-042: günlük hatırlatma da kaldırılır (ayar varsayılana döner).
      await ref.read(dailyReminderServiceProvider).clear();
      ref.invalidate(reminderViewProvider);
      _refreshAll();
    }
    if (!mounted) return;
    setState(() => _busy = false);
    _snack(wipe ? AccountTexts.signedOutWiped : AccountTexts.signedOut);
  }

  void _refreshAll() {
    ref.read(syncControllerProvider.notifier).notifyDataChanged();
    ref.invalidate(displayNameProvider);
  }

  Future<void> _delete() async {
    final ok = await _confirm(
      AccountTexts.deleteTitle,
      AccountTexts.deleteBody,
      AccountTexts.deleteAccount,
      danger: true,
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      final purge = await ref.read(authServiceProvider).deleteAccount();
      _snack(
        AccountTexts.deleted(
          AccountTexts.date(
            purge ?? DateTime.now().add(const Duration(days: 30)),
          ),
        ),
      );
    } on ApiException catch (e) {
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final row = widget.view.row;
    final syncing = ref.watch(syncControllerProvider).syncing;
    final now = DateTime.now().toUtc();
    final waiting = row?.lastErrorCode == ApiException.networkCode;
    final pending = widget.view.pendingDeletion;
    // Eşitleme durumu: renk + ikon (yalnız renge dayanmaz; metin de var).
    final (IconData syncIcon, Color syncColor) = pending
        ? (Icons.schedule_rounded, AppPalette.warning)
        : syncing
        ? (Icons.sync_rounded, AppPalette.seaBlue)
        : waiting
        ? (Icons.cloud_queue_rounded, AppPalette.warning)
        : (Icons.cloud_done_outlined, AppPalette.success);

    final status = Container(
      key: const ValueKey('account-status'),
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: AppSpace.s48,
                  height: AppSpace.s48,
                  decoration: BoxDecoration(
                    color: syncColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(syncIcon, color: syncColor),
                ),
              ),
              const SizedBox(width: AppSpace.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CapsLabel(
                      AccountTexts.signedInHeading,
                      tone: CapsTone.blue,
                    ),
                    const SizedBox(height: AppSpace.s4),
                    Text(
                      row?.emailMasked ?? '',
                      key: const ValueKey('account-email-masked'),
                      style: theme.textTheme.titleMedium,
                    ),
                    if (!pending) ...[
                      const SizedBox(height: 2),
                      Text(
                        syncing
                            ? AccountTexts.syncing
                            : AccountTexts.syncLine(row?.lastSyncAt, now),
                        key: const ValueKey('account-sync-line'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppPalette.ink700,
                        ),
                      ),
                      if (waiting && !syncing)
                        Text(
                          AccountTexts.syncWaiting,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppPalette.ink500,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (!pending) ...[
            const SizedBox(height: AppSpace.s16),
            OutlinedButton.icon(
              key: const ValueKey('account-sync-now'),
              onPressed: _busy || syncing ? null : () => unawaited(_syncNow()),
              icon: const Icon(Icons.sync_rounded),
              label: const Text(AccountTexts.syncNow),
            ),
          ],
        ],
      ),
    );

    return StaggeredList(
      children: [
        status,
        if (pending)
          InfoCard(
            key: const ValueKey('account-pending-deletion'),
            tone: InfoTone.warning,
            title: AccountTexts.pendingDeletion(
              AccountTexts.date(row?.scheduledPurgeAt ?? now),
            ),
            action: FilledButton(
              key: const ValueKey('account-restore'),
              onPressed: _busy ? null : () => context.push(AppRoutes.signIn),
              child: const Text(AccountTexts.restore),
            ),
          ),
        Center(
          child: TextButton.icon(
            key: const ValueKey('account-sign-out'),
            onPressed: _busy ? null : () => unawaited(_signOut(wipe: false)),
            icon: const Icon(Icons.logout_rounded),
            label: const Text(AccountTexts.signOut),
          ),
        ),
        SettingsGroup(
          key: const ValueKey('account-danger-zone'),
          title: AccountTexts.dangerZone,
          children: [
            SettingsRow(
              key: const ValueKey('account-sign-out-wipe'),
              icon: Icons.phonelink_erase_rounded,
              title: AccountTexts.wipeAlso,
              subtitle: AccountTexts.wipeRowHint,
              destructive: true,
              onTap: _busy ? null : () => unawaited(_signOut(wipe: true)),
            ),
            if (!pending)
              SettingsRow(
                key: const ValueKey('account-delete'),
                icon: Icons.delete_outline_rounded,
                title: AccountTexts.deleteAccount,
                subtitle: AccountTexts.deleteRowHint,
                destructive: true,
                onTap: _busy ? null : () => unawaited(_delete()),
              ),
          ],
        ),
      ],
    );
  }
}
