import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../app/theme.dart';
import '../../application/player_session.dart';
import '../../domain/subtitles.dart';

/// Uygulamanın çizdiği altyazı (K-03): video konumuna her karede eşlenir.
///
/// Hedef ifadenin sözcükleri fener sarısıyla vurgulanır. Satıra dokununca o
/// satır yeniden oynar.
class SubtitleOverlay extends StatefulWidget {
  const SubtitleOverlay({
    super.key,
    required this.session,
    required this.targetPhrases,
  });

  final PlayerSession session;
  final List<String> targetPhrases;

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
    const base = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.3,
    );
    final spans = <InlineSpan>[];
    for (var i = 0; i < cue.words.length; i++) {
      if (i > 0) spans.add(const TextSpan(text: ' '));
      spans.add(
        TextSpan(
          text: cue.words[i].w,
          style: hits.contains(i)
              ? const TextStyle(
                  color: AppColors.lighthouseYellow,
                  fontWeight: FontWeight.w700,
                )
              : null,
        ),
      );
    }
    if (spans.isEmpty) spans.add(TextSpan(text: cue.text));

    return Semantics(
      button: true,
      label: '${cue.text}. Satırı tekrar dinlemek için dokun.',
      excludeSemantics: true,
      child: GestureDetector(
        key: const ValueKey('subtitle-line'),
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.session.replayCue(cue),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: const Color(0xCC1B1B1B),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: Text.rich(
            TextSpan(style: base, children: spans),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
