import 'package:flutter/material.dart';

import '../../app/design/tokens.dart';
import '../../app/design/typography.dart';

/// Ayar grubu (H-057): isteğe bağlı başlık + beyaz kart içinde ayraçlı
/// satırlar. Profil ve Hesap ekranlarındaki düz `ListTile` kartlarının
/// yerine (H-059).
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    this.title,
    this.footer,
    required this.children,
  });

  final String? title;

  /// Grubun altında küçük açıklama.
  final String? footer;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(
          const Divider(
            height: 1,
            indent: AppSpace.s16 + AppIconSize.md + AppSpace.s16,
          ),
        );
      }
      rows.add(children[i]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpace.s4,
              bottom: AppSpace.s8,
            ),
            child: Semantics(
              header: true,
              child: Text(title!, style: theme.textTheme.titleMedium),
            ),
          ),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppPalette.white,
            borderRadius: AppRadius.mdAll,
            boxShadow: AppShadows.level1,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.mdAll,
            child: Material(
              type: MaterialType.transparency,
              child: Column(mainAxisSize: MainAxisSize.min, children: rows),
            ),
          ),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.s4,
              AppSpace.s8,
              AppSpace.s4,
              0,
            ),
            child: Text(
              footer!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppPalette.ink500,
              ),
            ),
          ),
      ],
    );
  }
}

/// Ayar satırı: ikon + başlık + alt satır ipucu + sağda değer / ok /
/// anahtar. En az 56 px yükseklik.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    this.value,
    this.onTap,
    this.trailing,
    this.destructive = false,
    this.toggleValue,
  });

  /// Açılıp kapanan ayar (sağda anahtar). Satırın tamamı dokunulabilir.
  factory SettingsRow.toggle({
    Key? key,
    required String title,
    IconData? icon,
    String? subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) => SettingsRow(
    key: key,
    title: title,
    icon: icon,
    subtitle: subtitle,
    onTap: onChanged == null ? null : () => onChanged(!value),
    trailing: ExcludeSemantics(
      child: Switch(value: value, onChanged: onChanged),
    ),
    toggleValue: value,
  );

  final String title;
  final IconData? icon;
  final String? subtitle;

  /// Sağda kısa değer ("10 dk", "Açık").
  final String? value;
  final VoidCallback? onTap;

  /// Özel sağ öğe; verilmezse dokunulabilir satırda ok gösterilir.
  final Widget? trailing;

  /// Kırmızı (tehlikeli eylem satırı).
  final bool destructive;

  /// Anahtar satırında durum (ekran okuyucu için).
  final bool? toggleValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = destructive ? AppPalette.danger : AppPalette.ink;
    final iconColor = destructive ? AppPalette.danger : AppPalette.seaBlue;
    final trailingWidget =
        trailing ??
        (onTap != null
            ? const Icon(Icons.chevron_right_rounded, color: AppPalette.ink300)
            : null);
    // Her satır ayrı düğüm (komşu satırlarla tek metne birleşmesin).
    return Semantics(
      container: true,
      button: onTap != null && toggleValue == null,
      toggled: toggleValue,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppTouch.primary),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.s16,
              vertical: AppSpace.s12,
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  ExcludeSemantics(
                    child: Icon(icon, color: iconColor, size: AppIconSize.md),
                  ),
                  const SizedBox(width: AppSpace.s16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: fg,
                          fontWeight: AppFonts.medium,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppPalette.ink500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (value != null) ...[
                  const SizedBox(width: AppSpace.s8),
                  Text(
                    value!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppPalette.ink500,
                    ),
                  ),
                ],
                if (trailingWidget != null) ...[
                  const SizedBox(width: AppSpace.s8),
                  trailingWidget,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
