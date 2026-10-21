import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../application/discover_providers.dart';
import '../../domain/reel.dart';

/// "İlgi alanların" (H-094, plan §4.3, §5): günlük seçkiye giren konular.
///
/// - Sinema / Spor / Kitap açılıp kapanır; tercih yalnız cihazda saklanır.
/// - En az bir konu açık kalır: son açık konu kapatılmak istenirse anahtar
///   değişmez, altta sakin bir not çıkar.
/// - Kapalı konu "Bugün"e girmez; üstteki çipinden yine gezilebilir.
/// - Değişince bugünün seçkisi yeniden hazırlanır (seviye değişimiyle aynı
///   yol); izleme sayacı ve öğrenme kayıtları silinmez.
///
/// Keşfet zorluğu panelinin içinde durur (üst şerit değişmez).
class DiscoverInterestsSection extends ConsumerStatefulWidget {
  const DiscoverInterestsSection({super.key});

  @override
  ConsumerState<DiscoverInterestsSection> createState() =>
      _DiscoverInterestsSectionState();
}

class _DiscoverInterestsSectionState
    extends ConsumerState<DiscoverInterestsSection> {
  /// Son dokunuşun sonucu (`keepOne` / `failed` ise not gösterilir).
  InterestToggle? _note;

  Future<void> _toggle(String code) async {
    final result = await ref.read(reelCategoriesProvider.notifier).toggle(code);
    if (!mounted) return;
    setState(() => _note = result == InterestToggle.changed ? null : result);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final categories = ref.watch(reelCategoriesProvider);
    final Widget body = switch (categories) {
      AsyncData(value: final on) => _rows(on),
      AsyncError() => Column(
        key: const ValueKey('interests-error'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DiscoverTexts.interestsError,
            style: t.bodyMedium?.copyWith(color: AppPalette.ink700),
          ),
          const SizedBox(height: AppSpace.s8),
          OutlinedButton(
            key: const ValueKey('interests-retry'),
            style: AppButtonStyles.secondary(),
            onPressed: () => ref.invalidate(reelCategoriesProvider),
            child: const Text(CommonTexts.retry),
          ),
        ],
      ),
      _ => Skeleton(
        key: const ValueKey('interests-loading'),
        label: DiscoverTexts.interestsLoading,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < kReelCategoryOrder.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpace.s8),
              const SkeletonBox(height: AppTouch.primary),
            ],
          ],
        ),
      ),
    };
    return Column(
      key: const ValueKey('interests-section'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CapsLabel(DiscoverTexts.interestsTitle),
        const SizedBox(height: AppSpace.s8),
        Text(
          DiscoverTexts.interestsBody,
          style: t.bodyMedium?.copyWith(color: AppPalette.ink700),
        ),
        const SizedBox(height: AppSpace.s16),
        body,
      ],
    );
  }

  Widget _rows(List<String> on) {
    final note = switch (_note) {
      InterestToggle.keepOne => (
        'interests-keep-one',
        DiscoverTexts.interestsKeepOne,
      ),
      InterestToggle.failed => (
        'interests-save-failed',
        DiscoverTexts.interestsSaveFailed,
      ),
      _ => null,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SettingsGroup(
          footer: DiscoverTexts.interestsFooter,
          children: [
            for (final code in kReelCategoryOrder)
              SettingsRow.toggle(
                key: ValueKey('interest-$code'),
                title: kReelCategoryTr[code] ?? code,
                icon: _icon(code),
                subtitle: on.contains(code) ? null : DiscoverTexts.interestOff,
                value: on.contains(code),
                onChanged: (_) => unawaited(_toggle(code)),
              ),
          ],
        ),
        if (note != null) ...[
          const SizedBox(height: AppSpace.s12),
          Semantics(
            liveRegion: true,
            child: Row(
              key: ValueKey(note.$1),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ExcludeSemantics(
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: AppIconSize.sm,
                    color: AppPalette.seaBlue,
                  ),
                ),
                const SizedBox(width: AppSpace.s8),
                Expanded(
                  child: Text(
                    note.$2,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppPalette.ink),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

IconData _icon(String code) => switch (code) {
  'CIN' => Icons.movie_outlined,
  'SPO' => Icons.sports_soccer_outlined,
  'BOK' => Icons.menu_book_outlined,
  _ => Icons.label_outline_rounded,
};
