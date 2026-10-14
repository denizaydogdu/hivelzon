import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import '../../domain/notebook_item.dart';
import 'card_face.dart';

/// Defterin **tek satır biçimi** (H-061): kelime, kalıp, cümle ve ipucu aynı
/// satırla çizilir. Solda etiket (bölüm "B1" ya da tür rozeti), ortada
/// İngilizce (ya da ipucunun Türkçesi) + Türkçesi + isteğe bağlı kaynak satırı,
/// sağda eylemler (🔊, menü, ok).
///
/// Kaynak satırı bugün yalnız konu setinden gelenlerde yazılır; Kitaplık
/// (H-067) aynı satıra "Kitap: başlık, s. N" koyacak (bkz.
/// [notebookSourceLine]).
class NotebookRow extends StatelessWidget {
  const NotebookRow({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.source,
    this.trailing = const [],
    this.onTap,
    this.tapKey,
  });

  final Widget leading;
  final String title;
  final String? subtitle;

  /// Küçük kaynak satırı ("Konu setinden"; ileride "Kitap: …, s. 4").
  final String? source;
  final List<Widget> trailing;
  final VoidCallback? onTap;

  /// Dokunulan yüzeyin anahtarı (testler).
  final Key? tapKey;

  /// Satırın en küçük yüksekliği (iki satır metin + boşluk).
  static const double minHeight = 64;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TappableCard(
      key: tapKey,
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(
        AppSpace.s12,
        AppSpace.s8,
        AppSpace.s4,
        AppSpace.s8,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: minHeight - AppSpace.s16),
        child: Row(
          children: [
            SizedBox(
              width: AppSpace.s48,
              child: Center(child: leading),
            ),
            const SizedBox(width: AppSpace.s12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpace.s4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppPalette.ink,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppPalette.ink500,
                        ),
                      ),
                    if (source != null) ...[
                      const SizedBox(height: AppSpace.s4),
                      Text(
                        source!,
                        key: const ValueKey('notebook-row-source'),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppPalette.orange700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (trailing.isEmpty)
              const SizedBox(width: AppSpace.s8)
            else
              ...trailing,
          ],
        ),
      ),
    );
  }
}

/// Satırın kaynak satırı. Her kaynak türü burada ele alınır (`switch`
/// eksiksiz): yeni bir kaynak (ör. kitap) eklenince derleyici burayı sorar.
String? notebookSourceLine(NotebookItem item) => switch (item.source) {
  NotebookSource.topicSet => NotebookTexts.sourceTopicSet,
  // Bölümden gelenlerin kaynağı soldaki bölüm etiketidir.
  NotebookSource.autoTargetPhrase ||
  NotebookSource.userSaved ||
  NotebookSource.lookup => null,
};

/// Satırın sol etiketi: bölümden geliyorsa "B1", değilse tür rozeti.
Widget notebookLeading(NotebookItem item) {
  final tag = item.episodeTag;
  if (tag != null) return EpisodeTag(tag: tag);
  return KindBadge(
    icon: item.source == NotebookSource.topicSet
        ? Icons.category_outlined
        : Icons.chat_bubble_outline_rounded,
  );
}

/// Yuvarlak tür rozeti (bölüm etiketi olmayan satırlar ve ipuçları).
class KindBadge extends StatelessWidget {
  const KindBadge({
    super.key,
    required this.icon,
    this.background = AppPalette.seaBlue50,
    this.color = AppPalette.seaBlue,
  });

  final IconData icon;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: AppSpace.s32 + AppSpace.s8,
      height: AppSpace.s32 + AppSpace.s8,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: AppIconSize.md - AppSpace.s4),
    ),
  );
}
