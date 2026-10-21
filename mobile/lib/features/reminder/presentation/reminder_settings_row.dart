import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../application/reminder_providers.dart';
import '../domain/daily_reminder.dart';

/// Profil → Öğrenme → "Günlük hatırlatma" (H-013, H-042): anahtar
/// (varsayılan kapalı) ve açıkken saat satırı. İzin yalnızca açarken
/// sorulur; verilmezse anahtar kapalı kalır ve sakin bir not çıkar.
///
/// Saat satırı aynı bileşenin içindedir (kendi ayracıyla); böylece
/// [SettingsGroup] kapalıyken boş satır ya da fazla ayraç çizmez.
class ReminderSettingsRow extends ConsumerStatefulWidget {
  const ReminderSettingsRow({super.key});

  @override
  ConsumerState<ReminderSettingsRow> createState() =>
      _ReminderSettingsRowState();
}

class _ReminderSettingsRowState extends ConsumerState<ReminderSettingsRow> {
  bool _busy = false;

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _toggle(bool on) async {
    if (_busy) return;
    setState(() => _busy = true);
    final service = ref.read(dailyReminderServiceProvider);
    try {
      if (on) {
        final r = await service.enable();
        final s = await service.settings();
        _snack(switch (r) {
          ReminderEnableResult.enabled => ReminderTexts.enabled(s.timeLabel),
          ReminderEnableResult.denied => ReminderTexts.denied,
          ReminderEnableResult.failed => ReminderTexts.failed,
        });
      } else {
        await service.disable();
        _snack(ReminderTexts.disabled);
      }
    } finally {
      ref.invalidate(reminderViewProvider);
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final view = ref.watch(reminderViewProvider);
    return switch (view) {
      AsyncData(:final value) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsRow.toggle(
            key: const ValueKey('profile-reminder-toggle'),
            icon: value.blocked
                ? Icons.notifications_off_outlined
                : Icons.notifications_none_rounded,
            title: ReminderTexts.tile,
            subtitle: value.blocked
                ? ReminderTexts.blocked
                : value.settings.enabled
                ? ReminderTexts.hintOn(value.settings.timeLabel)
                : ReminderTexts.hintOff,
            value: value.settings.enabled,
            onChanged: _busy ? null : (on) => unawaited(_toggle(on)),
          ),
          if (value.settings.enabled) ...[
            const Divider(
              height: 1,
              indent: AppSpace.s16 + AppIconSize.md + AppSpace.s16,
            ),
            ReminderTimeRow(settings: value.settings),
          ],
        ],
      ),
      AsyncError() => const SettingsRow(
        key: ValueKey('profile-reminder-error'),
        icon: Icons.notifications_off_outlined,
        title: ReminderTexts.tile,
        subtitle: ReminderTexts.loadError,
      ),
      // Okunurken satır yerini tutar (grup zıplamasın).
      _ => const SettingsRow(
        key: ValueKey('profile-reminder-loading'),
        icon: Icons.notifications_none_rounded,
        title: ReminderTexts.tile,
        subtitle: ReminderTexts.hintOff,
      ),
    };
  }
}

/// Saat satırı: yalnızca hatırlatma açıkken görünür.
class ReminderTimeRow extends ConsumerWidget {
  const ReminderTimeRow({super.key, required this.settings});

  final ReminderSettings settings;

  Future<void> _pick(
    BuildContext context,
    WidgetRef ref,
    ReminderSettings s,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: s.hour, minute: s.minute),
      helpText: ReminderTexts.timePickerHelp,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    await ref
        .read(dailyReminderServiceProvider)
        .setTime(picked.hour, picked.minute);
    ref.invalidate(reminderViewProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            ReminderTexts.timeChanged(
              s.copyWith(hour: picked.hour, minute: picked.minute).timeLabel,
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = settings;
    return SettingsRow(
      key: const ValueKey('profile-reminder-time'),
      icon: Icons.schedule_rounded,
      title: ReminderTexts.timeTile,
      subtitle: ReminderTexts.timeHint,
      value: s.timeLabel,
      onTap: () => unawaited(_pick(context, ref, s)),
    );
  }
}
