import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../application/player_session.dart';
import '../../domain/subtitles.dart';

/// Uygulamanın çizdiği altyazı (K-03): video konumuna her karede eşlenir.
///
/// Hedef ifadenin sözcükleri fener sarısıyla vurgulanır. EN+TR modunda
/// Türkçe satır altta, küçük yazılır. Satıra dokununca video durur ve anlam
/// paneli açılır (H-046); tekrar dinleme paneldedir.
class SubtitleOverlay extends StatefulWidget {
  const SubtitleOverlay({
    super.key,
    required this.session,
    required this.targetPhrases,
    required this.onTapCue,
  });

  final PlayerSession session;
  final List<String> targetPhrases;
  final ValueChanged<SubtitleCue> onTapCue;

  @override
  State<SubtitleOverlay> createState() => _SubtitleOverlayState();
}

class _SubtitleOverlayState extends State<SubtitleOverlay>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  SubtitleCue? _cue;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      final cue = widget.session.currentCue;
      if (!identical(cue, _cue)) setState(() => _cue = cue);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cue = _cue;
    if (cue == null) return const SizedBox.shrink();
    final hits = targetWordIndexes(cue, widget.targetPhrases);
    final base = AppTypography.subtitle.copyWith(color: AppPalette.white);
    final spans = <InlineSpan>[];
    for (var i = 0; i < cue.words.length; i++) {
      if (i > 0) spans.add(const TextSpan(text: ' '));
      spans.add(
        TextSpan(
          text: cue.words[i].w,
          style: hits.contains(i)
              ? const TextStyle(
                  color: AppPalette.lighthouseYellow,
                  fontWeight: AppFonts.bold,
                )
              : null,
        ),
      );
    }
    if (spans.isEmpty) spans.add(TextSpan(text: cue.text));
    final showTr =
        widget.session.subtitleMode == SubtitleMode.enTr && cue.hasTurkish;

    return Semantics(
      button: true,
      label: PlayerTexts.subtitleSemantics(cue.text, showTr ? cue.tr : null),
      excludeSemantics: true,
      child: GestureDetector(
        key: const ValueKey('subtitle-line'),
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onTapCue(cue),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTouch.min),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.s16,
            vertical: AppSpace.s8,
          ),
          decoration: const BoxDecoration(
            color: AppScrim.captionBox,
            borderRadius: AppRadius.mdAll,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(style: base, children: spans),
                textAlign: TextAlign.center,
              ),
              if (showTr) ...[
                const SizedBox(height: AppSpace.s4),
                Text(
                  cue.tr!,
                  key: const ValueKey('subtitle-tr'),
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitleTr.copyWith(
                    color: AppScrim.captionText,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
