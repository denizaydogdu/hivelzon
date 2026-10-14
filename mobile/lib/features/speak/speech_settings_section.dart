import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/tr_strings.dart';
import '../../shared/speech/speech_providers.dart';
import '../../shared/ui/ui.dart';

/// Profil → "Söyle alıştırmaları" satırı (H-055; tasarım H-059): anahtarlı
/// ayar satırı, altında gizlilik ipucu. Cihaz desteklemiyorsa ya da izin
/// kapalıysa anahtar yerine nedeni yazar.
class SpeechSettingsRow extends ConsumerWidget {
  const SpeechSettingsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(speechStatusProvider).value;
    return switch (status) {
      // Durum okunurken satır yerini tutar (grup zıplamasın).
      null => const SettingsRow(
        key: ValueKey('profile-speech-loading'),
        icon: Icons.mic_none_rounded,
        title: SpeakTexts.profileToggle,
        subtitle: SpeakTexts.profilePrivacy,
      ),
      SpeechStatus.unsupported => const SettingsRow(
        key: ValueKey('profile-speech-unsupported'),
        icon: Icons.mic_off_outlined,
        title: SpeakTexts.profileToggle,
        subtitle: SpeakTexts.profileUnsupported,
        value: SpeakTexts.profileUnavailable,
      ),
      SpeechStatus.denied => const SettingsRow(
        key: ValueKey('profile-speech-denied'),
        icon: Icons.mic_off_outlined,
        title: SpeakTexts.profileToggle,
        subtitle: SpeakTexts.profileDenied,
        value: SpeakTexts.profileUnavailable,
      ),
      _ => SettingsRow.toggle(
        key: const ValueKey('profile-speech-toggle'),
        icon: Icons.mic_none_rounded,
        title: SpeakTexts.profileToggle,
        subtitle: SpeakTexts.profilePrivacy,
        value: status != SpeechStatus.switchedOff,
        onChanged: (on) async {
          await ref.read(speechStoreProvider).setEnabled(on);
          ref.invalidate(speechStatusProvider);
        },
      ),
    };
  }
}
