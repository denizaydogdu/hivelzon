import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/api/api_client.dart';
import '../../../shared/widgets/page_header.dart';
import '../../profile/application/profile_providers.dart';
import '../application/account_providers.dart';

/// Profil → Hesap (H-038).
///
/// - Oturum kapalı: hesabın ne işe yaradığı (isteğe bağlı) ve giriş yolları
///   (şimdilik e-posta kodu; Apple/Google H-044'te aynı listeye eklenir).
/// - Oturum açık: e-posta (maskeli), son eşitleme, "Şimdi eşitle", "Çıkış
///   yap", "Hesabımı sil".
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = accountViewOf(ref.watch);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text(
          AccountTexts.title,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          key: const ValueKey('account-screen'),
          padding: const EdgeInsets.all(AppSpacing.sm),
          children: view.signedIn
              ? [_SignedIn(view: view)]
              : [_SignedOut(view: view)],
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
    if (view.ageBlocked(now)) {
      return _Info(
        key: const ValueKey('account-age-blocked'),
        icon: Icons.info_outline_rounded,
        text: AccountTexts.ageBlocked,
      );
    }
    Widget bullet(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.seaBlue),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (reason != null) ...[
          _Info(
            key: const ValueKey('account-signed-out-reason'),
            icon: Icons.lock_outline_rounded,
            text: reason,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(
          AccountTexts.intro,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        bullet(Icons.cloud_upload_outlined, AccountTexts.benefitBackup),
        bullet(Icons.devices_outlined, AccountTexts.benefitDevices),
        bullet(Icons.phone_iphone_rounded, AccountTexts.benefitLocal),
        const SizedBox(height: AppSpacing.md),
        const SectionHeading(AccountTexts.methodsHeading),
        const SizedBox(height: AppSpacing.xs),
        // Giriş yolları listesi: Apple ve Google (H-044) buraya eklenir.
        FilledButton.icon(
          key: const ValueKey('account-email'),
          onPressed: () => context.push(AppRoutes.signIn),
          icon: const Icon(Icons.mail_outline_rounded),
          label: const Text(AccountTexts.methodEmail),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(AccountTexts.methodEmailNote, style: theme.textTheme.bodyMedium),
      ],
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

  Future<bool?> _confirm(String title, String body, String action) =>
      showDialog<bool>(
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
    final children = <Widget>[
      const SectionHeading(AccountTexts.signedInHeading),
      const SizedBox(height: AppSpacing.xs),
      Text(
        row?.emailMasked ?? '',
        key: const ValueKey('account-email-masked'),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
    ];
    if (widget.view.pendingDeletion) {
      children.addAll([
        _Info(
          icon: Icons.info_outline_rounded,
          text: AccountTexts.pendingDeletion(
            AccountTexts.date(row?.scheduledPurgeAt ?? now),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        FilledButton(
          key: const ValueKey('account-restore'),
          onPressed: _busy ? null : () => context.push(AppRoutes.signIn),
          child: const Text(AccountTexts.restore),
        ),
      ]);
    } else {
      children.addAll([
        Text(
          syncing
              ? AccountTexts.syncing
              : AccountTexts.syncLine(row?.lastSyncAt, now),
          key: const ValueKey('account-sync-line'),
          style: theme.textTheme.bodyLarge,
        ),
        if (waiting && !syncing)
          Text(AccountTexts.syncWaiting, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          key: const ValueKey('account-sync-now'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: _busy || syncing ? null : () => unawaited(_syncNow()),
          icon: const Icon(Icons.sync_rounded),
          label: const Text(AccountTexts.syncNow),
        ),
      ]);
    }
    children.addAll([
      const SizedBox(height: AppSpacing.md),
      OutlinedButton.icon(
        key: const ValueKey('account-sign-out'),
        style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
        onPressed: _busy ? null : () => unawaited(_signOut(wipe: false)),
        icon: const Icon(Icons.logout_rounded),
        label: const Text(AccountTexts.signOut),
      ),
      const SizedBox(height: AppSpacing.xs),
      TextButton(
        key: const ValueKey('account-sign-out-wipe'),
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
        onPressed: _busy ? null : () => unawaited(_signOut(wipe: true)),
        child: const Text(AccountTexts.wipeAlso),
      ),
      if (!widget.view.pendingDeletion) ...[
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          key: const ValueKey('account-delete'),
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: _busy ? null : () => unawaited(_delete()),
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text(AccountTexts.deleteAccount),
        ),
      ],
    ]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    elevation: 0,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.seaBlue),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    ),
  );
}
