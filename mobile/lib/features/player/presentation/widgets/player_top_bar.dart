import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
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
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.sand.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            tooltip: 'Bölümden çık',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.seaBlue,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(
              Icons.close_rounded,
              semanticLabel: 'Bölümden çık',
            ),
          ),
          Expanded(
            child: Semantics(
              label: 'Sahne ${dotIndex + 1} / $dotCount',
              child: ExcludeSemantics(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < dotCount; i++)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i <= dotIndex
                              ? AppColors.seaBlue
                              : AppColors.seaBlue.withValues(alpha: 0.2),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (onMission != null)
            IconButton(
              key: const ValueKey('mission-button'),
              onPressed: onMission,
              tooltip: 'Görev ve hedef ifadeler',
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              color: AppColors.seaBlue,
              icon: const Icon(
                Icons.track_changes_rounded,
                semanticLabel: 'Görev ve hedef ifadeler',
              ),
            ),
          _Chip(
            label: speed == 1.0 ? '1x' : '0,75x',
            semantics: speed == 1.0
                ? 'Hız normal. Yavaşlatmak için dokun.'
                : 'Hız 0,75. Normale dönmek için dokun.',
            selected: speed != 1.0,
            onTap: () => onSpeed(speed == 1.0 ? 0.75 : 1.0),
          ),
          const SizedBox(width: AppSpacing.xs),
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
        borderRadius: BorderRadius.circular(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 56, minHeight: 48),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.seaBlue : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.seaBlue.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.seaBlue,
                ),
              ),
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
      SubtitleMode.en => 'EN',
      SubtitleMode.enTr => 'EN+TR',
      SubtitleMode.off => 'Kapalı',
    };
    // Ekran okuyucu için kısaltma açılır ("EN" değil "İngilizce").
    final spoken = switch (mode) {
      SubtitleMode.en => 'İngilizce',
      SubtitleMode.enTr => 'İngilizce ve Türkçe',
      SubtitleMode.off => 'kapalı',
    };
    final on = mode != SubtitleMode.off;
    return PopupMenuButton<SubtitleMode>(
      key: const ValueKey('subtitle-menu'),
      tooltip: 'Altyazı: $spoken',
      onSelected: onChanged,
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        CheckedPopupMenuItem(
          key: const ValueKey('subtitle-mode-en'),
          value: SubtitleMode.en,
          checked: mode == SubtitleMode.en,
          child: const Text('EN (İngilizce)'),
        ),
        CheckedPopupMenuItem(
          key: const ValueKey('subtitle-mode-entr'),
          value: SubtitleMode.enTr,
          checked: mode == SubtitleMode.enTr,
          child: const Text('EN + TR (Türkçe satırla)'),
        ),
        CheckedPopupMenuItem(
          key: const ValueKey('subtitle-mode-off'),
          value: SubtitleMode.off,
          checked: mode == SubtitleMode.off,
          child: const Text('Kapalı'),
        ),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 56, minHeight: 48),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: on ? AppColors.seaBlue : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.seaBlue.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.closed_caption_rounded,
                  size: 18,
                  color: on ? Colors.white : AppColors.seaBlue,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: on ? Colors.white : AppColors.seaBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
