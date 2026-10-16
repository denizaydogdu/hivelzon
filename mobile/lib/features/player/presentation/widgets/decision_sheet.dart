import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../shared/ui/ui.dart';
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
    // Giriş (H-062): kart alttan yumuşakça gelir, seçenekler sırayla belirir.
    // Dokunma ilk karede de çalışır; "Hareketi azalt" açıksa durağan.
    return PlayerEntrance(
      child: PlayerPanel(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.s24,
          AppSpace.s16,
          AppSpace.s24,
          AppSpace.s16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _LighthouseRule(),
            Semantics(
              header: true,
              child: Text(
                PlayerTexts.decisionHeading,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppPalette.seaBlue,
                ),
              ),
            ),
            const SizedBox(height: AppSpace.s4),
            Text(
              node.prompt.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: AppPalette.ink),
            ),
            const SizedBox(height: AppSpace.s16),
            for (final (i, o) in node.options.indexed) ...[
              PlayerEntrance(
                index: i + 1,
                child: _OptionButton(
                  option: o,
                  onTap: () => onChoose(o),
                  onListen: o.audio == null ? null : () => onListen(o.audio!),
                ),
              ),
              const SizedBox(height: AppSpace.s8),
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
                  icon: const HiAvatar(size: AppIconSize.lg, glow: false),
                  label: const Text(PlayerTexts.askHint),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Kartın üstündeki fener çizgisi: iki ince sarı çizgi ve ortada ışık.
class _LighthouseRule extends StatelessWidget {
  const _LighthouseRule();

  @override
  Widget build(BuildContext context) {
    const line = Expanded(child: Divider(color: AppPalette.yellow200));
    return const ExcludeSemantics(
      child: Row(
        children: [
          line,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpace.s8),
            child: Icon(
              Icons.flare_rounded,
              color: AppPalette.lighthouseYellow,
            ),
          ),
          line,
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
    // H-093: doğru seçeneği söylemek, kararın hedef ifadesi için
    // "yardımla yaptı"dır (seçenekler ekranda: taklit, FSRS'e gitmez).
    final target = widget.node.targetPhrase;
    if (option.correct && target != null && m.imitationSucceeded) {
      widget.env.practiced?.call(
        SpokenPractice(
          place: SpeechPlace.decision,
          expression: target,
          contentId: widget.contentId,
        ),
      );
    }
    setState(() => _unclear = 0);
    widget.onChoose(option);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_unclear >= widget.maxUnclear) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.s8),
        child: Text(
          SpeakTexts.decisionTapOnly,
          key: const ValueKey('speak-choose-tap-only'),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            key: const ValueKey('speak-choose-mic'),
            onPressed: _go,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.min),
            ),
            icon: Icon(
              _listening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
            ),
            label: Text(_listening ? SpeakTexts.stop : SpeakTexts.decisionSay),
          ),
          if (_listening || _unclear > 0)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.s4),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _listening
                      ? SpeakTexts.listening
                      : SpeakTexts.decisionUnclear,
                  key: const ValueKey('speak-choose-message'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink,
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
    return PressScale(
      child: Material(
        color: AppPalette.seaBlue50,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(color: AppPalette.seaBlue200),
        ),
        child: InkWell(
          key: ValueKey('option-${option.id}'),
          borderRadius: AppRadius.mdAll,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppTouch.primary),
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpace.s16),
              child: Row(
                children: [
                  for (final i in icons)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpace.s4),
                      child: Icon(i, color: AppPalette.seaBlue),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpace.s12,
                      ),
                      child: Text(
                        option.text,
                        style: AppTypography.lead.copyWith(
                          color: AppPalette.seaBlue,
                        ),
                      ),
                    ),
                  ),
                  if (onListen != null)
                    ListenButton(
                      onPressed: onListen!,
                      semanticLabel: PlayerTexts.listenTo(option.text),
                      filled: false,
                    )
                  else
                    const SizedBox(width: AppSpace.s16),
                ],
              ),
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
