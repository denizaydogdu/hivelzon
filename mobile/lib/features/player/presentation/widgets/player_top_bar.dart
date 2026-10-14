import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../application/player_session.dart';

/// Üst çubuk (T3): kapat · ilerleme noktaları · 🎯 görev · hız · altyazı.
class PlayerTopBar extends StatelessWidget {
  const PlayerTopBar({
    super.key,
    required this.dotCount,
    required this.dotIndex,
    required this.speed,
    required this.subtitleMode,
    required this.onClose,
    required this.onSpeed,
    required this.onSubtitleMode,
    this.onMission,
  });

  final int dotCount;
  final int dotIndex;
  final double speed;
  final SubtitleMode subtitleMode;
  final VoidCallback onClose;
  final ValueChanged<double> onSpeed;
  final ValueChanged<SubtitleMode> onSubtitleMode;

  /// 🎯 paneli: görev cümlesi ve hedef ifadeler (H-050). Null ise gizli.
  final VoidCallback? onMission;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpace.s8,
        AppSpace.s8,
        AppSpace.s8,
        0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s8),
      decoration: BoxDecoration(
        color: AppPalette.sand.withValues(alpha: 0.94),
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.level1,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            tooltip: PlayerTexts.exitEpisode,
            style: IconButton.styleFrom(
              backgroundColor: AppPalette.seaBlue,
              foregroundColor: AppPalette.white,
            ),
            icon: const Icon(
              Icons.close_rounded,
              semanticLabel: PlayerTexts.exitEpisode,
            ),
          ),
          Expanded(
            child: Semantics(
              label: PlayerTexts.sceneProgress(dotIndex + 1, dotCount),
              child: ExcludeSemantics(
                // Dar ekranda (320 px, büyük yazı) noktalar sığmazsa küçülür.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < dotCount; i++)
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpace.s4,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i <= dotIndex
                                ? AppPalette.seaBlue
                                : AppPalette.seaBlue200,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (onMission != null)
            IconButton(
              key: const ValueKey('mission-button'),
              onPressed: onMission,
              tooltip: PlayerTexts.missionButton,
              color: AppPalette.seaBlue,
              icon: const Icon(
                Icons.track_changes_rounded,
                semanticLabel: PlayerTexts.missionButton,
              ),
            ),
          _Chip(
            label: PlayerTexts.speed(speed),
            semantics: PlayerTexts.speedSemantics(speed),
            selected: speed != 1.0,
            onTap: () => onSpeed(speed == 1.0 ? 0.75 : 1.0),
          ),
          const SizedBox(width: AppSpace.s8),
          _SubtitleMenu(mode: subtitleMode, onChanged: onSubtitleMode),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.semantics,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final String semantics;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semantics,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppTouch.primary,
            minHeight: AppTouch.min,
          ),
          child: Center(
            child: _Pill(
              selected: selected,
              child: _PillText(label, selected: selected),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubtitleMenu extends StatelessWidget {
  const _SubtitleMenu({required this.mode, required this.onChanged});

  final SubtitleMode mode;
  final ValueChanged<SubtitleMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final label = switch (mode) {
      SubtitleMode.en => PlayerTexts.subtitleEn,
      SubtitleMode.enTr => PlayerTexts.subtitleEnTr,
      SubtitleMode.off => PlayerTexts.subtitleOff,
    };
    // Ekran okuyucu için kısaltma açılır ("EN" değil "İngilizce").
    final spoken = switch (mode) {
      SubtitleMode.en => PlayerTexts.subtitleEnSpoken,
      SubtitleMode.enTr => PlayerTexts.subtitleEnTrSpoken,
      SubtitleMode.off => PlayerTexts.subtitleOffSpoken,
    };
    final on = mode != SubtitleMode.off;
    return PopupMenuButton<SubtitleMode>(
      key: const ValueKey('subtitle-menu'),
      tooltip: PlayerTexts.subtitleTooltip(spoken),
      onSelected: onChanged,
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        CheckedPopupMenuItem(
          key: const ValueKey('subtitle-mode-en'),
          value: SubtitleMode.en,
          checked: mode == SubtitleMode.en,
          child: const Text(PlayerTexts.subtitleMenuEn),
        ),
        CheckedPopupMenuItem(
          key: const ValueKey('subtitle-mode-entr'),
          value: SubtitleMode.enTr,
          checked: mode == SubtitleMode.enTr,
          child: const Text(PlayerTexts.subtitleMenuEnTr),
        ),
        CheckedPopupMenuItem(
          key: const ValueKey('subtitle-mode-off'),
          value: SubtitleMode.off,
          checked: mode == SubtitleMode.off,
          child: const Text(PlayerTexts.subtitleMenuOff),
        ),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppTouch.primary,
          minHeight: AppTouch.min,
        ),
        child: Center(
          child: _Pill(
            selected: on,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.closed_caption_rounded,
                  size: AppIconSize.sm,
                  color: on ? AppPalette.white : AppPalette.seaBlue,
                ),
                const SizedBox(width: AppSpace.s4),
                _PillText(label, selected: on),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Üst çubuktaki hap (hız, altyazı): seçiliyken deniz mavisi dolgu.
class _Pill extends StatelessWidget {
  const _Pill({required this.selected, required this.child});

  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: AppMotion.of(context, AppMotion.fast),
    curve: AppMotion.standard,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpace.s12,
      vertical: AppSpace.s4,
    ),
    decoration: BoxDecoration(
      color: selected ? AppPalette.seaBlue : AppPalette.white,
      borderRadius: BorderRadius.circular(AppRadius.full),
      border: Border.all(color: AppPalette.seaBlue200),
    ),
    child: child,
  );
}

class _PillText extends StatelessWidget {
  const _PillText(this.label, {required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: AppFonts.bold,
      color: selected ? AppPalette.white : AppPalette.seaBlue,
    ),
  );
}
