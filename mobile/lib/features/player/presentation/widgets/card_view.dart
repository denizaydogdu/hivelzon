import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
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
        caption: PlayerTexts.missionLabel,
        icon: Icons.flag_rounded,
        lines: lines,
        onTap: onLineTap,
      ),
      CardKind.clue => _LinesPanel(
        caption: PlayerTexts.newClueLabel,
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
    // Giriş (H-062): kart ve düğmesi sırayla gelir. Hi kartı kendi girişini
    // yapar (HiPanel); kendiliğinden geçen başlık kartı durağan kalır.
    final animate = card.kind != CardKind.hi && card.kind != CardKind.title;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (animate) PlayerEntrance(child: body) else body,
        if (showButton) ...[
          const SizedBox(height: AppSpace.s16),
          if (onListen != null && card.kind != CardKind.hi)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.s8),
              child: ListenButton(
                onPressed: onListen!,
                semanticLabel: PlayerTexts.listen,
              ),
            ),
          PlayerEntrance(index: 1, child: _continue()),
        ],
      ],
    );
  }

  Widget _continue() => PrimaryAction(
    key: const ValueKey('card-continue'),
    label: isLast ? PlayerTexts.finishEpisode : PlayerTexts.continueAction,
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
    label: PlayerTexts.tapForMeaning(l.text),
    excludeSemantics: true,
    child: InkWell(
      key: ValueKey('card-line-$index'),
      borderRadius: AppRadius.mdAll,
      onTap: () => onTap(index, l),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppTouch.min),
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
        decorationColor: AppPalette.seaBlue300,
      );

TextStyle? _styleFor(BuildContext context, CardLine l) {
  final t = Theme.of(context).textTheme;
  return switch (l.style) {
    'heading' => t.headlineSmall?.copyWith(color: AppPalette.seaBlue),
    'highlight' => t.titleMedium?.copyWith(color: AppPalette.seaBlue),
    'caption' => AppTypography.caps.copyWith(color: AppPalette.orange700),
    _ => t.bodyLarge?.copyWith(
      color: AppPalette.ink,
      fontWeight: AppFonts.medium,
      height: 1.35,
    ),
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
              padding: const EdgeInsets.only(bottom: AppSpace.s8),
              child: Text(
                l.text,
                textAlign: TextAlign.center,
                style: l.style == 'heading'
                    ? t.displaySmall?.copyWith(color: AppPalette.white)
                    : t.titleMedium?.copyWith(
                        color: AppPalette.lighthouseYellow,
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
              Icon(icon, color: AppPalette.orange700),
              if (caption != null) ...[
                const SizedBox(width: AppSpace.s8),
                Flexible(child: CapsLabel(caption!)),
              ],
            ],
          ),
          const SizedBox(height: AppSpace.s8),
          for (final (i, l) in lines.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.s8),
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
      padding: const EdgeInsets.all(AppSpace.s24),
      decoration: BoxDecoration(
        color: AppPalette.yellow50,
        borderRadius: AppRadius.lgAll,
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
              padding: const EdgeInsets.only(bottom: AppSpace.s16),
              child: Text(
                card.title!,
                style: t.labelLarge?.copyWith(
                  color: AppPalette.orange700,
                  fontWeight: AppFonts.bold,
                ),
              ),
            ),
          for (final (i, l) in lines.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.s8),
              child: _tappable(
                i,
                l,
                onTap,
                Text(
                  l.text,
                  style: _tapStyle(
                    t.titleLarge?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: AppFonts.medium,
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
                radius: AppIconSize.sm,
                backgroundColor: AppPalette.seaBlue,
                child: Icon(
                  Icons.sms_rounded,
                  size: AppIconSize.sm,
                  color: AppPalette.white,
                ),
              ),
              const SizedBox(width: AppSpace.s8),
              Flexible(
                child: Text(
                  card.title ?? PlayerTexts.messageFallback,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppPalette.seaBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.s16),
          for (final (i, l) in lines.indexed)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpace.s8),
              decoration: const BoxDecoration(
                color: AppPalette.white,
                borderRadius: AppRadius.mdAll,
                boxShadow: AppShadows.level1,
              ),
              child: _tappable(
                i,
                l,
                onTap,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.s16,
                    vertical: AppSpace.s12,
                  ),
                  child: Text(
                    l.text,
                    style: _tapStyle(
                      AppTypography.lead.copyWith(
                        color: AppPalette.ink,
                        fontWeight: AppFonts.regular,
                      ),
                      l,
                      onTap,
                    ),
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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppPalette.orange700,
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                const SizedBox(height: AppSpace.s4),
                _tappable(
                  i,
                  l,
                  onTap,
                  Text(
                    l.text,
                    style: _tapStyle(
                      AppTypography.spoken.copyWith(color: AppPalette.ink),
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
