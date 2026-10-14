import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/api/api_client.dart';
import '../../../shared/api/auth_service.dart';
import '../../../shared/sync/sync_engine.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/page_header.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/data/user_profile_store.dart';
import '../application/account_providers.dart';

enum SignInStep { email, code, signup, ageBlocked, restore, syncing, done }

/// Hesap aç / giriş yap (H-038): e-posta → 6 haneli kod → (yeni hesapsa)
/// doğum yılı ve onaylar → ilk eşitleme. Şifre yok.
///
/// - 13 yaş altı (doğum yılına göre) hesap açamaz: sakin açıklama, bilgi
///   gönderilmez ve saklanmaz; uygulamanın tamamı hesapsız çalışır.
/// - Silinmek üzere olan hesapla girişte geri alma sorulur.
/// - E-posta ve kod cihazda saklanmaz.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  static const resendAfter = Duration(seconds: 60);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _birthYear = TextEditingController();
  final _name = TextEditingController();
  SignInStep _step = SignInStep.email;
  String? _error;
  bool _busy = false;
  int _validMinutes = 10;
  int _resendLeft = 0;
  Timer? _ticker;
  bool _terms = false;
  bool _privacy = false;
  bool _marketing = false;
  DateTime? _purgeAt;
  SyncOutcome? _outcome;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    // Profil'deki ad (varsa) önerilir; değiştirilebilir, boş bırakılabilir.
    unawaited(
      ref.read(displayNameProvider.future).then((n) {
        if (mounted && n != null && _name.text.isEmpty) _name.text = n;
      }, onError: (_) {}),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _email.dispose();
    _code.dispose();
    _birthYear.dispose();
    _name.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _ticker?.cancel();
    setState(() => _resendLeft = SignInScreen.resendAfter.inSeconds);
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _resendLeft--);
      if (_resendLeft <= 0) t.cancel();
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on ApiException catch (e) {
      if (mounted) _onError(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onError(ApiException e) {
    setState(() {
      _error = e.message;
      if (e.code.startsWith('OTP_') && _step == SignInStep.signup) {
        _step = SignInStep.code;
      }
    });
  }

  Future<void> _sendCode({bool resend = false}) => _run(() async {
    final email = _email.text.trim();
    if (!_emailPattern.hasMatch(email)) {
      setState(() => _error = AccountTexts.emailInvalid);
      return;
    }
    final seconds = await ref.read(authServiceProvider).startEmail(email);
    if (!mounted) return;
    setState(() {
      _validMinutes = (seconds / 60).ceil();
      _step = SignInStep.code;
      _code.clear();
    });
    _startCountdown();
    if (resend) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AccountTexts.codeResent)));
    }
  });

  Future<void> _verify({SignupDetails? signup}) => _run(() async {
    final code = _code.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      setState(() => _error = AccountTexts.codeInvalidFormat);
      return;
    }
    final VerifyResult result;
    try {
      result = await ref
          .read(authServiceProvider)
          .verify(_email.text.trim(), code, signup: signup);
    } on ApiException catch (e) {
      if (e.code == 'AGE_NOT_ALLOWED' && signup != null) {
        await ref.read(ageGateStoreProvider).block(signup.birthYear);
        ref.invalidate(ageGateProvider);
        if (mounted) setState(() => _step = SignInStep.ageBlocked);
        return;
      }
      rethrow;
    }
    if (!mounted) return;
    switch (result.status) {
      case VerifyStatus.signupRequired:
        setState(() => _step = SignInStep.signup);
      case VerifyStatus.pendingDeletion:
        setState(() {
          _purgeAt = result.purgeAt;
          _step = SignInStep.restore;
        });
      case VerifyStatus.signedIn:
        await _firstSync();
    }
  });

  Future<void> _submitSignup() async {
    final year = int.tryParse(_birthYear.text.trim());
    final now = DateTime.now().toUtc();
    if (year == null || year < 1900 || year > now.year) {
      setState(() => _error = AccountTexts.birthYearInvalid);
      return;
    }
    if (!ageAllowed(year, now)) {
      // Sunucuya hiçbir şey gönderilmez; yalnızca bu cihaz hatırlar.
      await ref.read(ageGateStoreProvider).block(year);
      ref.invalidate(ageGateProvider);
      if (mounted) setState(() => _step = SignInStep.ageBlocked);
      return;
    }
    final name = normalizeDisplayName(_name.text);
    if (name != null &&
        (validateDisplayName(name) != null ||
            !RegExp(r"^[\p{L} .'-]+$", unicode: true).hasMatch(name))) {
      setState(() => _error = AccountTexts.displayNameInvalid);
      return;
    }
    if (!_terms || !_privacy) {
      setState(() => _error = AccountTexts.consentMissing);
      return;
    }
    final config = ref.read(apiConfigProvider);
    await _verify(
      signup: SignupDetails(
        birthYear: year,
        displayName: name,
        termsVersion: config.termsVersion,
        privacyNoticeVersion: config.privacyNoticeVersion,
        marketing: _marketing,
      ),
    );
  }

  Future<void> _restore() => _run(() async {
    await ref.read(authServiceProvider).restore();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AccountTexts.restored)));
    await _firstSync();
  });

  Future<void> _declineRestore() => _run(() async {
    await ref.read(authServiceProvider).signOut();
    if (mounted) context.pop();
  });

  Future<void> _firstSync() async {
    setState(() => _step = SignInStep.syncing);
    final outcome = await ref.read(syncControllerProvider.notifier).syncNow();
    if (!mounted) return;
    setState(() {
      _outcome = outcome;
      _step = SignInStep.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: _step != SignInStep.syncing,
      child: Scaffold(
        appBar: AppBar(title: const Text(AccountTexts.signInTitle)),
        body: SafeArea(
          top: false,
          child: AutofillGroup(
            // Kısa form: tembel liste yerine tek kaydırma (her alan ve
            // ana düğme ağaçta; klavye açıkken de kaydırılarak erişilir).
            child: SingleChildScrollView(
              key: ValueKey('sign-in-step-${_step.name}'),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _body(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Girdi: tema biçimi (H-057), sayaç gizli (ekran okuyucu İngilizce
  /// okuyordu).
  InputDecoration _field(String label, {String? helper}) => InputDecoration(
    labelText: label,
    helperText: helper,
    helperMaxLines: 2,
    counterText: '',
  );

  /// Ana eylem; hata metni **hemen üstünde** (H-059: altta kalınca klavye
  /// açıkken ekran dışına düşüyordu).
  Widget _primary(String key, String label, VoidCallback? onPressed) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (_error != null) ...[
        Semantics(
          liveRegion: true,
          child: InfoCard(
            key: const ValueKey('sign-in-error'),
            tone: InfoTone.danger,
            title: _error!,
          ),
        ),
        const SizedBox(height: AppSpace.s12),
      ],
      FilledButton(
        key: ValueKey(key),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.primary),
        ),
        onPressed: _busy ? null : onPressed,
        child: _busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  semanticsLabel: AccountTexts.checking,
                ),
              )
            : Text(label),
      ),
    ],
  );

  List<Widget> _body(ThemeData theme) {
    switch (_step) {
      case SignInStep.email:
        return [
          const SectionHeading(AccountTexts.emailHeading),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const ValueKey('sign-in-email'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.send,
            maxLength: 254,
            onSubmitted: (_) => unawaited(_sendCode()),
            decoration: _field(
              AccountTexts.emailLabel,
              helper: AccountTexts.emailHelper,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _primary(
            'sign-in-send',
            AccountTexts.sendCode,
            () => unawaited(_sendCode()),
          ),
        ];
      case SignInStep.code:
        return [
          const SectionHeading(AccountTexts.codeHeading),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AccountTexts.codeSent(_email.text.trim(), _validMinutes),
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            key: const ValueKey('sign-in-code'),
            controller: _code,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 6,
            autofocus: true,
            style: theme.textTheme.headlineSmall?.copyWith(letterSpacing: 6),
            onChanged: (v) {
              if (v.length == 6) unawaited(_verify());
            },
            decoration: _field(AccountTexts.codeLabel),
          ),
          const SizedBox(height: AppSpacing.sm),
          _primary(
            'sign-in-verify',
            AccountTexts.verify,
            () => unawaited(_verify()),
          ),
          const SizedBox(height: AppSpacing.xs),
          if (_resendLeft > 0)
            Text(
              AccountTexts.resendIn(_resendLeft),
              key: const ValueKey('sign-in-resend-wait'),
              style: theme.textTheme.bodyMedium,
            )
          else
            TextButton(
              key: const ValueKey('sign-in-resend'),
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: _busy
                  ? null
                  : () => unawaited(_sendCode(resend: true)),
              child: const Text(AccountTexts.resend),
            ),
          TextButton(
            key: const ValueKey('sign-in-change-email'),
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: _busy
                ? null
                : () => setState(() {
                    _ticker?.cancel();
                    _error = null;
                    _step = SignInStep.email;
                  }),
            child: const Text(AccountTexts.changeEmail),
          ),
        ];
      case SignInStep.signup:
        return [
          const SectionHeading(AccountTexts.signupHeading),
          const SizedBox(height: 4),
          Text(AccountTexts.signupIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            key: const ValueKey('sign-in-birth-year'),
            controller: _birthYear,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 4,
            decoration: _field(
              AccountTexts.birthYearLabel,
              helper: AccountTexts.birthYearHelper,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            key: const ValueKey('sign-in-name'),
            controller: _name,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            maxLength: UserProfileStore.maxNameLength,
            decoration: _field(AccountTexts.displayNameLabel),
          ),
          const SizedBox(height: AppSpacing.sm),
          SettingsGroup(
            children: [
              _Consent(
                key: const ValueKey('sign-in-terms'),
                value: _terms,
                label: AccountTexts.termsCheck,
                onChanged: (v) => setState(() => _terms = v),
                onOpen: () => context.push(AppRoutes.legal('kosullar')),
              ),
              _Consent(
                key: const ValueKey('sign-in-privacy'),
                value: _privacy,
                label: AccountTexts.privacyCheck,
                onChanged: (v) => setState(() => _privacy = v),
                onOpen: () => context.push(AppRoutes.legal('aydinlatma')),
              ),
              SwitchListTile(
                key: const ValueKey('sign-in-marketing'),
                value: _marketing,
                onChanged: (v) => setState(() => _marketing = v),
                title: const Text(AccountTexts.marketing),
                subtitle: const Text(AccountTexts.marketingNote),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _primary(
            'sign-in-create',
            AccountTexts.createAccount,
            () => unawaited(_submitSignup()),
          ),
        ];
      case SignInStep.ageBlocked:
        return [
          const SectionHeading(AccountTexts.ageBlockedTitle),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AccountTexts.ageBlocked,
            key: const ValueKey('sign-in-age-blocked'),
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AccountTexts.ageBlockedNothingSaved,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            key: const ValueKey('sign-in-back'),
            onPressed: () => context.go(AppRoutes.home),
            child: const Text(AccountTexts.backToApp),
          ),
        ];
      case SignInStep.restore:
        return [
          const SectionHeading(AccountTexts.restoreHeading),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AccountTexts.restoreBody(
              AccountTexts.date(
                _purgeAt ?? DateTime.now().add(const Duration(days: 30)),
              ),
            ),
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          _primary(
            'sign-in-restore',
            AccountTexts.restore,
            () => unawaited(_restore()),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextButton(
            key: const ValueKey('sign-in-restore-decline'),
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: _busy ? null : () => unawaited(_declineRestore()),
            child: const Text(AccountTexts.restoreDecline),
          ),
        ];
      case SignInStep.syncing:
        return [
          const SizedBox(height: AppSpacing.lg),
          const Center(
            child: CircularProgressIndicator(
              semanticsLabel: AccountTexts.syncing,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AccountTexts.syncing,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ];
      case SignInStep.done:
        final ok = _outcome?.ok ?? false;
        return [
          Icon(
            ok ? Icons.cloud_done_outlined : Icons.cloud_queue_rounded,
            size: AppIconSize.xl,
            color: ok ? AppPalette.success : AppPalette.seaBlue,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            ok ? AccountTexts.synced : AccountTexts.syncLater,
            key: const ValueKey('sign-in-done'),
            textAlign: TextAlign.center,
            style: ok ? theme.textTheme.titleLarge : theme.textTheme.bodyLarge,
          ),
          if (ok) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              AccountTexts.syncedBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            key: const ValueKey('sign-in-finish'),
            onPressed: () => context.pop(),
            child: const Text(AccountTexts.done),
          ),
        ];
    }
  }
}

class _Consent extends StatelessWidget {
  const _Consent({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    required this.onOpen,
  });

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          title: Text(label),
        ),
      ),
      TextButton(onPressed: onOpen, child: const Text(AccountTexts.readText)),
      const SizedBox(width: AppSpace.s4),
    ],
  );
}
