import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/widgets/page_header.dart';
import '../../account/presentation/account_widgets.dart';
import '../../hi/application/hi_providers.dart';
import '../../hi/presentation/hi_privacy_screen.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/domain/review_policy.dart';
import '../../speak/speech_settings_section.dart';
import '../application/profile_providers.dart';
import '../data/user_profile_store.dart';

/// Profil (H-036, H-053): seslenme adı, Defter girişi ve günlük hedef.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final overview = ref.watch(reviewOverviewProvider).value;
    final goal = ref.watch(dailyGoalProvider).value;
    final subtitle = overview == null
        ? ProfileTexts.notebookLoading
        : overview.totalItems == 0
        ? ProfileTexts.notebookEmpty
        : ProfileTexts.notebookCount(
            overview.totalItems,
            overview.sessionCount,
          );
    final minutes = goal ?? ReviewPolicy.defaultDailyGoalMinutes;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // Hi balonunun payı alt güvenli alanda (ShellScaffold, H-055).
          padding: const EdgeInsets.all(AppSpacing.sm),
          children: [
            const PageHeader(
              title: ProfileTexts.title,
              subtitle: ProfileTexts.subtitle,
            ),
            const SizedBox(height: AppSpacing.md),
            const SectionHeading(ProfileTexts.nameSection),
            const SizedBox(height: AppSpacing.xs),
            const DisplayNameField(),
            const SizedBox(height: AppSpacing.md),
            const SectionHeading(ProfileTexts.notebookSection),
            const SizedBox(height: AppSpacing.xs),
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
                  ProfileTexts.notebookTile,
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
            const SizedBox(height: AppSpacing.xs),
            HiPrivacyTile(
              onTap: () async {
                await context.push(AppRoutes.hiPrivacy);
                if (context.mounted) refreshHi(ref);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const SectionHeading(ProfileTexts.goalSection),
            const SizedBox(height: 4),
            Text(ProfileTexts.goalIntro, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.xs),
            SegmentedButton<int>(
              key: const ValueKey('daily-goal'),
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(minimumSize: const Size(48, 48)),
              segments: [
                for (final m in ReviewPolicy.newCardsPerDayByGoal.keys)
                  ButtonSegment(
                    value: m,
                    label: Text(ProfileTexts.goalOption(m)),
                  ),
              ],
              selected: {minutes},
              onSelectionChanged: (s) async {
                await ref
                    .read(notebookStoreProvider)
                    .setDailyGoalMinutes(s.first);
                ref.invalidate(dailyGoalProvider);
                refreshNotebook(ref);
                refreshHi(ref);
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              ProfileTexts.goalNote(ReviewPolicy.newCardsPerDay(minutes)),
              style: theme.textTheme.bodyMedium,
            ),
            // H-055: aç/kapat ve gizlilik (destek yoksa nedeni).
            const SpeechSettingsSection(),
            // H-038: isteğe bağlı hesap ve eşitleme.
            const SizedBox(height: AppSpacing.md),
            const AccountSection(),
          ],
        ),
      ),
    );
  }
}

/// "Sana nasıl seslenelim?" alanı: isteğe bağlı, en fazla 20 karakter,
/// yalnızca bu cihazda (H-053).
class DisplayNameField extends ConsumerStatefulWidget {
  const DisplayNameField({super.key});

  @override
  ConsumerState<DisplayNameField> createState() => _DisplayNameFieldState();
}

class _DisplayNameFieldState extends ConsumerState<DisplayNameField> {
  final _controller = TextEditingController();
  bool _loaded = false;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _messageFor(DisplayNameError? e) => switch (e) {
    null => null,
    DisplayNameError.tooLong => ProfileTexts.nameTooLong,
    DisplayNameError.invalidCharacters => ProfileTexts.nameInvalid,
  };

  Future<void> _save() async {
    final error = _messageFor(validateDisplayName(_controller.text));
    setState(() => _error = error);
    if (error != null || _saving) return;
    setState(() => _saving = true);
    final name = normalizeDisplayName(_controller.text);
    try {
      await ref.read(userProfileStoreProvider).setDisplayName(name);
      ref.invalidate(displayNameProvider);
      if (!mounted) return;
      _controller.text = name ?? '';
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            name == null ? ProfileTexts.nameCleared : ProfileTexts.nameSaved,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(displayNameProvider);
    if (!_loaded && current.hasValue) {
      _loaded = true;
      _controller.text = current.value ?? '';
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            key: const ValueKey('profile-name'),
            controller: _controller,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            enableSuggestions: false,
            maxLength: UserProfileStore.maxNameLength,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            decoration: InputDecoration(
              labelText: ProfileTexts.nameLabel,
              helperText: ProfileTexts.nameHelper,
              helperMaxLines: 2,
              // Sayaç gizli: ekran okuyucu onu İngilizce okuyordu
              // ("characters remaining"). Sınırı `maxLength` korur.
              counterText: '',
              errorText: _error,
              errorMaxLines: 2,
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: FilledButton(
            key: const ValueKey('profile-name-save'),
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            ),
            child: const Text(CommonTexts.save),
          ),
        ),
      ],
    );
  }
}
