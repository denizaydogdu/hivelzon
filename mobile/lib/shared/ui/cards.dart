import 'package:flutter/material.dart';

import '../../app/design/tokens.dart';
import '../../app/design/typography.dart';
import '../text/turkish.dart';
import 'motion.dart';

/// Dokunulabilir kart (H-057): beyaz, 12 px köşe, yumuşak gölge; basınca
/// hafifçe küçülür ([PressScale]) ve dalga (ripple) verir.
class TappableCard extends StatelessWidget {
  const TappableCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpace.s16),
    this.color,
    this.elevated = false,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Varsayılan: beyaz.
  final Color? color;

  /// Öne çıkan kart (gölge seviyesi 2).
  final bool elevated;

  /// Ekran okuyucu etiketi (verilmezse içerik okunur).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final card = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.mdAll,
        boxShadow: elevated ? AppShadows.level2 : AppShadows.level1,
      ),
      child: Material(
        color: color ?? AppPalette.white,
        borderRadius: AppRadius.mdAll,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      child: PressScale(enabled: onTap != null, child: card),
    );
  }
}

/// [InfoCard] tonları.
enum InfoTone { neutral, info, success, warning, danger }

/// Bilgi kartı (H-057): ikon + başlık + açıklama + isteğe bağlı eylem.
/// Ekranlardaki 8 özel kopyanın yerine geçer (ekran fazlarında).
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    this.body,
    this.icon,
    this.tone = InfoTone.neutral,
    this.action,
  });

  final String title;
  final String? body;
  final IconData? icon;
  final InfoTone tone;
  final Widget? action;

  static (Color background, Color foreground, IconData icon) _tone(
    InfoTone t,
  ) => switch (t) {
    InfoTone.neutral => (
      AppPalette.white,
      AppPalette.seaBlue,
      Icons.info_outline_rounded,
    ),
    InfoTone.info => (
      AppPalette.infoSurface,
      AppPalette.info,
      Icons.lightbulb_outline_rounded,
    ),
    InfoTone.success => (
      AppPalette.successSurface,
      AppPalette.success,
      Icons.check_circle_outline_rounded,
    ),
    InfoTone.warning => (
      AppPalette.warningSurface,
      AppPalette.warning,
      Icons.schedule_rounded,
    ),
    InfoTone.danger => (
      AppPalette.dangerSurface,
      AppPalette.danger,
      Icons.error_outline_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (bg, fg, defaultIcon) = _tone(tone);
    return Semantics(
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpace.s16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.mdAll,
          boxShadow: tone == InfoTone.neutral ? AppShadows.level1 : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(icon ?? defaultIcon, color: fg, size: AppIconSize.md),
            ),
            const SizedBox(width: AppSpace.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppPalette.ink,
                    ),
                  ),
                  if (body != null && body!.isNotEmpty) ...[
                    const SizedBox(height: AppSpace.s4),
                    Text(
                      body!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppPalette.ink700,
                      ),
                    ),
                  ],
                  if (action != null) ...[
                    const SizedBox(height: AppSpace.s12),
                    action!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [CapsLabel] tonları.
enum CapsTone { orange, blue }

/// Büyük harfli küçük etiket ("SEZON 1 · BÖLÜM 2", "AÇIK SORU"). Türkçe
/// büyük harf kuralıyla (`upperTr`: i → İ). Ekran okuyucu metni normal
/// yazımla okur.
class CapsLabel extends StatelessWidget {
  const CapsLabel(this.text, {super.key, this.tone = CapsTone.orange});

  final String text;
  final CapsTone tone;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      CapsTone.orange => AppPalette.orange700,
      CapsTone.blue => AppPalette.seaBlue,
    };
    return Semantics(
      label: text,
      excludeSemantics: true,
      child: Text(
        upperTr(text),
        style: AppTypography.caps.copyWith(color: color),
      ),
    );
  }
}

/// Simgeli kısa satır (H-089, Profil "Neler yapabiliyorsun"): solda renkli
/// simge, sağda metin. Simge ekran okuyucuda okunmaz; metin tek parça.
class IconLine extends StatelessWidget {
  const IconLine({
    super.key,
    required this.icon,
    required this.text,
    this.color = AppPalette.seaBlue,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.s16,
        vertical: AppSpace.s12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(icon, color: color, size: AppIconSize.md),
          ),
          const SizedBox(width: AppSpace.s16),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(color: AppPalette.ink),
            ),
          ),
        ],
      ),
    );
  }
}
