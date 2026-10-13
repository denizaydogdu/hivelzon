import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/speech/speak_widgets.dart';
import '../../../../shared/speech/speech_match.dart';
import '../../../../shared/speech/speech_recognizer_port.dart';
import '../../../../shared/speech/speech_store.dart';
import '../../domain/episode.dart';
import 'hi_avatar.dart';
import 'player_ui.dart';

/// Karar anı kartı (T3): "Ne dersin?" + büyük seçenek düğmeleri.
///
/// Süre yok, geri sayım yok (K-32). İpucu yalnızca kullanıcı isterse (§8.3).
class DecisionSheet extends StatelessWidget {
  const DecisionSheet({
    super.key,
    required this.node,
    required this.onChoose,
    required this.onListen,
    required this.onHint,
    this.speak,
    this.contentId,
  });

  final DecisionNode node;
  final ValueChanged<DecisionOption> onChoose;
  final ValueChanged<String> onListen;
  final VoidCallback? onHint;

  /// "Söyleyerek seç" (H-055): cihazda tanıma varsa ve bütün seçenekler
  /// İngilizceyse. Dokunarak seçmek her zaman aynı kalır.
  final SpeakEnv? speak;
  final String? contentId;

  bool get _canSpeak =>
      speak != null &&
      node.options.length >= 2 &&
      node.options.every((o) => o.lang == Lang.en);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PlayerPanel(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.lighthouseYellow.withValues(alpha: 0.7),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(
                  Icons.flare_rounded,
                  color: AppColors.lighthouseYellow,
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.lighthouseYellow.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Semantics(
            header: true,
            child: Text(
              'Ne dersin?',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.seaBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            node.prompt.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final o in node.options) ...[
            _OptionButton(
              option: o,
              onTap: () => onChoose(o),
              onListen: o.audio == null ? null : () => onListen(o.audio!),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          if (_canSpeak)
            SpeakToChoose(
              key: ValueKey('speak-choose-${node.id}'),
              node: node,
              env: speak!,
              contentId: contentId,
              onChoose: onChoose,
            ),
          if (onHint != null)
            Align(
              child: TextButton.icon(
                onPressed: onHint,
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  foregroundColor: AppColors.seaBlue,
                ),
                icon: const HiAvatar(size: 32, glow: false),
                label: const Text(
                  'Hi\'den ipucu al',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Karar anında "Söyleyerek seç" (H-055). Söylenen, seçeneklerden birine
/// açıkça yakınsa o seçilir (dokunmakla aynı akış: yanlışsa tepki gelir).
/// Belirsizse ya da eşleşme yoksa hiçbir şey seçilmez; iki denemeden sonra
/// düğme kalkar, dokunarak seçilir.
class SpeakToChoose extends StatefulWidget {
  const SpeakToChoose({
    super.key,
    required this.node,
    required this.env,
    required this.onChoose,
    this.contentId,
    this.maxUnclear = 2,
  });

  final DecisionNode node;
  final SpeakEnv env;
  final ValueChanged<DecisionOption> onChoose;
  final String? contentId;
  final int maxUnclear;

  @override
  State<SpeakToChoose> createState() => _SpeakToChooseState();
}

class _SpeakToChooseState extends State<SpeakToChoose> {
  bool _listening = false;
  int _unclear = 0;

  Future<void> _go() async {
    if (_listening) {
      unawaited(widget.env.recognizer.stop());
      return;
    }
    if (!await widget.env.ensureReady(context)) return;
    if (!mounted) return;
    setState(() => _listening = true);
    final options = widget.node.options;
    final correct = options.where((o) => o.correct).firstOrNull;
    final SpeechHeard heard;
    try {
      heard = await widget.env.recognizer.listenOnce(
        debugExpected: correct?.text,
      );
    } finally {
      if (mounted) setState(() => _listening = false);
    }
    if (!mounted) return;
    final pick = SpeechMatcher.bestOption(heard.alternatives, [
      for (final o in options) o.text,
    ]);
    final at = DateTime.now().toUtc();
    if (pick.index == null) {
      widget.env.record(
        SpeechAttempt(
          place: SpeechPlace.decision,
          contentId: widget.contentId,
          itemRef: widget.node.id,
          level: SpeechMatchLevel.no,
          at: at,
        ),
      );
      setState(() => _unclear++);
      return;
    }
    final option = options[pick.index!];
    final m = SpeechMatcher.compareAny(option.text, heard.alternatives);
    widget.env.record(
      SpeechAttempt(
        place: SpeechPlace.decision,
        contentId: widget.contentId,
        itemRef: '${widget.node.id}#${option.id}',
        level: m.level,
        missingCount: m.missingWords.length,
        at: at,
      ),
    );
    setState(() => _unclear = 0);
    widget.onChoose(option);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_unclear >= widget.maxUnclear) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Text(
          SpeakTexts.decisionTapOnly,
          key: const ValueKey('speak-choose-tap-only'),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.ink),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            key: const ValueKey('speak-choose-mic'),
            onPressed: _go,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: AppColors.seaBlue,
              side: BorderSide(color: AppColors.seaBlue.withValues(alpha: 0.4)),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            icon: Icon(
              _listening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
            ),
            label: Text(_listening ? SpeakTexts.stop : SpeakTexts.decisionSay),
          ),
          if (_listening || _unclear > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _listening
                      ? SpeakTexts.listening
                      : SpeakTexts.decisionUnclear,
                  key: const ValueKey('speak-choose-message'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.option,
    required this.onTap,
    this.onListen,
  });

  final DecisionOption option;
  final VoidCallback onTap;
  final VoidCallback? onListen;

  @override
  Widget build(BuildContext context) {
    final icons = _arrowIcons(option.icon);
    return Material(
      color: const Color(0xFFEAF1F8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        side: BorderSide(color: AppColors.seaBlue.withValues(alpha: 0.25)),
      ),
      child: InkWell(
        key: ValueKey('option-${option.id}'),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: Row(
              children: [
                for (final i in icons)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(i, color: AppColors.seaBlue),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      option.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.seaBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                if (onListen != null)
                  ListenButton(
                    onPressed: onListen!,
                    semanticLabel: 'Dinle: ${option.text}',
                    filled: false,
                  )
                else
                  const SizedBox(width: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `arrows:up,left` → yön simgeleri.
List<IconData> _arrowIcons(String? icon) {
  if (icon == null || !icon.startsWith('arrows:')) return const [];
  return [
    for (final d in icon.substring(7).split(','))
      switch (d.trim()) {
        'up' => Icons.arrow_upward_rounded,
        'down' => Icons.arrow_downward_rounded,
        'left' => Icons.turn_left_rounded,
        'right' => Icons.turn_right_rounded,
        _ => Icons.navigation_rounded,
      },
  ];
}
