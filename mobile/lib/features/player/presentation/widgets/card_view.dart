import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../domain/episode.dart';
import 'player_ui.dart';

/// Yerel arayüz kartları: başlık, görev, Hi, replik, not, mesaj, ipucu, açık soru.
class CardView extends StatelessWidget {
  const CardView({
    super.key,
    required this.card,
    required this.lines,
    required this.onContinue,
    this.onListen,
    this.isLast = false,
    this.onLineTap,
  });

  final CardNode card;

  /// Bayrağa göre seçilmiş satırlar (motor `linesFor`).
  final List<CardLine> lines;
  final VoidCallback onContinue;
  final VoidCallback? onListen;
  final bool isLast;

  /// İngilizce satıra dokunuldu (anlamı varsa; H-046). Null ise satırlar
  /// dokunulmaz.
  final LineTap? onLineTap;

  @override
  Widget build(BuildContext context) {
    final body = switch (card.kind) {
      CardKind.title => _TitleCard(lines: lines),
      CardKind.hi => HiPanel(
        text: lines.map((l) => l.text).join('\n'),
        onListen: onListen,
        actions: [_continue()],
      ),
      CardKind.message => _MessageCard(
        card: card,
        lines: lines,
        onTap: onLineTap,
      ),
      CardKind.note => _NoteCard(card: card, lines: lines, onTap: onLineTap),
      CardKind.line => _LineCard(lines: lines, onTap: onLineTap),
      CardKind.mission => _LinesPanel(
        caption: 'GÖREV',
        icon: Icons.flag_rounded,
        lines: lines,
        onTap: onLineTap,
      ),
      CardKind.clue => _LinesPanel(
        caption: 'YENİ İPUCU',
        icon: Icons.push_pin_rounded,
        lines: lines,
        onTap: onLineTap,
      ),
      CardKind.openQuestion => _LinesPanel(
        caption: null,
        icon: Icons.help_outline_rounded,
        lines: lines,
        onTap: onLineTap,
      ),
    };
    final showButton = !card.autoAdvance && card.kind != CardKind.hi;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        body,
        if (showButton) ...[
          const SizedBox(height: AppSpacing.sm),
          if (onListen != null && card.kind != CardKind.hi)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: ListenButton(onPressed: onListen!, semanticLabel: 'Dinle'),
            ),
          _continue(),
        ],
      ],
    );
  }

  Widget _continue() => PrimaryAction(
    key: const ValueKey('card-continue'),
    label: isLast ? 'Bölümü bitir' : PlayerTexts.continueAction,
    icon: Icons.arrow_forward_rounded,
    onPressed: onContinue,
  );
}

typedef LineTap = void Function(int index, CardLine line);

/// Anlamı olan İngilizce satır dokunulabilir: ince noktalı alt çizgi ipucu verir.
Widget _tappable(int index, CardLine l, LineTap? onTap, Widget child) {
  if (onTap == null || l.lang != Lang.en || l.gloss == null) return child;
  return Semantics(
    button: true,
    label: '${l.text}. Anlamını görmek için dokun.',
    excludeSemantics: true,
    child: InkWell(
      key: ValueKey('card-line-$index'),
      borderRadius: BorderRadius.circular(AppTheme.radius),
      onTap: () => onTap(index, l),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    ),
  );
}

TextStyle? _tapStyle(TextStyle? base, CardLine l, LineTap? onTap) =>
    onTap == null || l.lang != Lang.en || l.gloss == null
    ? base
    : base?.copyWith(
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dotted,
        decorationColor: AppColors.seaBlue.withValues(alpha: 0.5),
      );

TextStyle? _styleFor(BuildContext context, CardLine l) {
  final t = Theme.of(context).textTheme;
  return switch (l.style) {
    'heading' => t.headlineSmall?.copyWith(
      color: AppColors.seaBlue,
      fontWeight: FontWeight.w700,
    ),
    'highlight' => t.titleMedium?.copyWith(
      color: AppColors.seaBlue,
      fontWeight: FontWeight.w700,
    ),
    'caption' => t.labelLarge?.copyWith(
      color: AppColors.eveningOrange,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    ),
    _ => t.titleMedium?.copyWith(color: AppColors.ink, height: 1.35),
  };
}

class _TitleCard extends StatelessWidget {
  const _TitleCard({required this.lines});

  final List<CardLine> lines;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Semantics(
      header: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                l.text,
                textAlign: TextAlign.center,
                style: l.style == 'heading'
                    ? t.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      )
                    : t.titleMedium?.copyWith(
                        color: AppColors.lighthouseYellow,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LinesPanel extends StatelessWidget {
  const _LinesPanel({
    required this.caption,
    required this.icon,
    required this.lines,
    this.onTap,
  });

  final String? caption;
  final IconData icon;
  final List<CardLine> lines;
  final LineTap? onTap;

  @override
  Widget build(BuildContext context) {
    return PlayerPanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.eveningOrange),
              if (caption != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  caption!,
                  style: const TextStyle(
                    color: AppColors.eveningOrange,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final (i, l) in lines.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _tappable(
                i,
                l,
                onTap,
                Text(l.text, style: _tapStyle(_styleFor(context, l), l, onTap)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Dünya içi not: kâğıt görünümü.
class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.card, required this.lines, this.onTap});

  final CardNode card;
  final List<CardLine> lines;
  final LineTap? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppPalette.yellow50,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppPalette.sand300),
        boxShadow: const [
          BoxShadow(
            color: AppScrim.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (card.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                card.title!,
                style: t.labelLarge?.copyWith(
                  color: AppColors.eveningOrange,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          for (final (i, l) in lines.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _tappable(
                i,
                l,
                onTap,
                Text(
                  l.text,
                  style: _tapStyle(
                    t.titleLarge?.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                    l,
                    onTap,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Telefon mesajı: gönderen başlığı + balonlar.
class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.card, required this.lines, this.onTap});

  final CardNode card;
  final List<CardLine> lines;
  final LineTap? onTap;

  @override
  Widget build(BuildContext context) {
    return PlayerPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.seaBlue,
                child: Icon(Icons.sms_rounded, size: 18, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                card.title ?? 'Mesaj',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.seaBlue,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final (i, l) in lines.indexed)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: _tappable(
                i,
                l,
                onTap,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 12,
                  ),
                  child: Text(
                    l.text,
                    style: _tapStyle(const TextStyle(fontSize: 18), l, onTap),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Alex'in iç sesi ya da bir karakterin repliği.
class _LineCard extends StatelessWidget {
  const _LineCard({required this.lines, this.onTap});

  final List<CardLine> lines;
  final LineTap? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, l) in lines.indexed)
          PlayerPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (l.speaker != null)
                  Text(
                    _speakerName(l.speaker!),
                    style: const TextStyle(
                      color: AppColors.eveningOrange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 4),
                _tappable(
                  i,
                  l,
                  onTap,
                  Text(
                    l.text,
                    style: _tapStyle(
                      const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                      ),
                      l,
                      onTap,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

String _speakerName(String s) => switch (s) {
  'ALEX' => 'Alex',
  'HI' => 'Hi',
  'MAYA' => 'Maya',
  _ => s[0] + s.substring(1).toLowerCase(),
};
