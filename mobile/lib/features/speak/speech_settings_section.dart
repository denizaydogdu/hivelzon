import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../l10n/tr_strings.dart';
import '../../shared/speech/speech_providers.dart';
import '../../shared/widgets/page_header.dart';

/// Profil → "Söyle alıştırmaları" (H-055): aç/kapat ve gizlilik satırı.
/// Cihaz desteklemiyorsa ya da izin kapalıysa anahtar yerine nedeni yazar.
class SpeechSettingsSection extends ConsumerWidget {
  const SpeechSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final status = ref.watch(speechStatusProvider).value;
    if (status == null) return const SizedBox.shrink();
    final privacy = Text(
      SpeakTexts.profilePrivacy,
      key: const ValueKey('profile-speech-privacy'),
      style: theme.textTheme.bodyMedium,
    );
    final Widget body = switch (status) {
      SpeechStatus.unsupported => _note(
        context,
        const ValueKey('profile-speech-unsupported'),
        SpeakTexts.profileUnsupported,
      ),
      SpeechStatus.denied => _note(
        context,
        const ValueKey('profile-speech-denied'),
        SpeakTexts.profileDenied,
      ),
      _ => Card(
        margin: EdgeInsets.zero,
        child: SwitchListTile(
          key: const ValueKey('profile-speech-toggle'),
          value: status != SpeechStatus.switchedOff,
          onChanged: (on) async {
            await ref.read(speechStoreProvider).setEnabled(on);
            ref.invalidate(speechStatusProvider);
          },
          secondary: const Icon(
            Icons.mic_none_rounded,
            color: AppColors.seaBlue,
          ),
          title: const Text(
            SpeakTexts.profileToggle,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: const Text(SpeakTexts.profileToggleSub),
        ),
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        const SectionHeading(SpeakTexts.profileSection),
        const SizedBox(height: AppSpacing.xs),
        body,
        const SizedBox(height: AppSpacing.xs),
        privacy,
      ],
    );
  }

  Widget _note(BuildContext context, Key key, String text) => Card(
    key: key,
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.mic_off_outlined, color: AppColors.seaBlue),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    ),
  );
}
