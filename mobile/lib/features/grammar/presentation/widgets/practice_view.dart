import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/speech/speak_widgets.dart';
import '../../../../shared/speech/speech_store.dart';
import '../../../../shared/ui/ui.dart';
import '../../application/lesson_controller.dart';
import '../../domain/grammar_lesson.dart';

enum _Answer { none, correct, wrong }

/// Alıştırma (H-078; K-32: puan, süre, can yok). Sorular sırayla gelir.
/// Yanlışta kısa Türkçe açıklama, sonra aynı soru yeniden ("Tekrar dene").
/// "Geç" her zaman var: alıştırma dersin ilerlemesini hiçbir zaman kilitlemez.
class PracticeView extends StatefulWidget {
  const PracticeView({
    super.key,
    required this.lessonId,
    required this.items,
    required this.controller,
    this.speak,
  });

  final String lessonId;
  final List<PracticeItem> items;
  final LessonController controller;

  /// "Söyle" (H-055); null: cihazda tanıma yok, cümle yalnız dinlenir.
  final SpeakEnv? speak;

  @override
  State<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends State<PracticeView> {
  int _q = 0;
  _Answer _answer = _Answer.none;
  bool _skipped = false;
  String? _picked;
  final _fill = TextEditingController();
  final List<int> _order = [];

  bool get _done => _q >= widget.items.length;
  PracticeItem get _item => widget.items[_q];

  @override
  void dispose() {
    _fill.dispose();
    super.dispose();
  }

  void _check(String input) {
    final ok = _item.check(input);
    setState(() {
      _picked = input;
      _answer = ok ? _Answer.correct : _Answer.wrong;
    });
  }

  void _retry() => setState(() {
    _answer = _Answer.none;
    _picked = null;
    _fill.clear();
    _order.clear();
  });

  void _skip() => setState(() {
    _skipped = true;
    _answer = _Answer.correct;
  });

  void _next() => setState(() {
    _q++;
    _answer = _Answer.none;
    _skipped = false;
    _picked = null;
    _fill.clear();
    _order.clear();
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_done) {
      return SoftEntrance(
        child: InfoCard(
          key: const ValueKey('practice-done'),
          icon: Icons.check_circle_outline_rounded,
          tone: InfoTone.success,
          title: GrammarTexts.practiceDone,
        ),
      );
    }
    final item = _item;
    final body = switch (item.kind) {
      PracticeKind.choose => _choose(item),
      PracticeKind.fill => _fillView(item),
      PracticeKind.order => _orderView(item),
      PracticeKind.say => _sayView(item),
    };
    return Column(
      key: ValueKey('practice-q${_q + 1}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          GrammarTexts.questionOf(_q + 1, widget.items.length),
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppPalette.ink500,
            fontWeight: AppFonts.bold,
          ),
        ),
        const SizedBox(height: AppSpace.s8),
        body,
        const SizedBox(height: AppSpace.s12),
        ..._feedback(item),
      ],
    );
  }

  Widget _stem(String? stem, {String? fill}) {
    final s = stem ?? '';
    final text = fill == null ? s : s.replaceFirst('___', fill);
    return Text(
      text,
      style: AppTypography.lead.copyWith(color: AppPalette.ink),
    );
  }

  Widget _choose(PracticeItem item) {
    final theme = Theme.of(context);
    final answered = _answer == _Answer.correct;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          GrammarTexts.chooseHint,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink500),
        ),
        const SizedBox(height: AppSpace.s4),
        _stem(item.stem, fill: answered ? item.correctOption : null),
        const SizedBox(height: AppSpace.s12),
        Wrap(
          spacing: AppSpace.s8,
          runSpacing: AppSpace.s8,
          children: [
            for (final (i, o) in item.options.indexed)
              _OptionButton(
                key: ValueKey('opt-$i'),
                text: o.text,
                state: _picked == o.text
                    ? _answer
                    : (answered && o.correct ? _Answer.correct : _Answer.none),
                onPressed: _answer == _Answer.none
                    ? () => _check(o.text)
                    : null,
              ),
          ],
        ),
      ],
    );
  }

  Widget _fillView(PracticeItem item) {
    final theme = Theme.of(context);
    final answered = _answer == _Answer.correct;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          GrammarTexts.fillHint,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink500),
        ),
        const SizedBox(height: AppSpace.s4),
        _stem(item.stem),
        const SizedBox(height: AppSpace.s12),
        if (!answered) ...[
          TextField(
            key: const ValueKey('fill-field'),
            controller: _fill,
            enabled: _answer == _Answer.none,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (v) {
              if (v.trim().isNotEmpty) _check(v);
            },
            decoration: const InputDecoration(
              labelText: GrammarTexts.fillField,
            ),
          ),
          if (_answer == _Answer.none) ...[
            const SizedBox(height: AppSpace.s8),
            ListenableBuilder(
              listenable: _fill,
              builder: (context, _) => FilledButton(
                key: const ValueKey('practice-check'),
                onPressed: _fill.text.trim().isEmpty
                    ? null
                    : () => _check(_fill.text),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppTouch.min),
                ),
                child: const Text(GrammarTexts.check),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _orderView(PracticeItem item) {
    final theme = Theme.of(context);
    final answered = _answer == _Answer.correct;
    final picked = [for (final i in _order) item.tokens[i]];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          GrammarTexts.orderHint,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink500),
        ),
        const SizedBox(height: AppSpace.s8),
        // Senin cümlen.
        Semantics(
          label: GrammarTexts.orderAnswer,
          container: true,
          child: Container(
            key: const ValueKey('order-answer'),
            constraints: const BoxConstraints(minHeight: AppTouch.min + 16),
            padding: const EdgeInsets.all(AppSpace.s8),
            decoration: BoxDecoration(
              color: AppPalette.white,
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: AppPalette.seaBlue200),
            ),
            child: Wrap(
              spacing: AppSpace.s8,
              runSpacing: AppSpace.s8,
              children: [
                if (answered && _skipped)
                  _stem(item.answer)
                else
                  for (final (k, i) in _order.indexed)
                    _TokenChip(
                      key: ValueKey('order-picked-$k'),
                      text: item.tokens[i],
                      selected: true,
                      onPressed: _answer == _Answer.none
                          ? () => setState(() => _order.removeAt(k))
                          : null,
                    ),
              ],
            ),
          ),
        ),
        if (!answered) ...[
          const SizedBox(height: AppSpace.s12),
          Wrap(
            spacing: AppSpace.s8,
            runSpacing: AppSpace.s8,
            children: [
              for (final (i, t) in item.tokens.indexed)
                if (!_order.contains(i))
                  _TokenChip(
                    key: ValueKey('order-token-$i'),
                    text: t,
                    selected: false,
                    onPressed: _answer == _Answer.none
                        ? () => setState(() => _order.add(i))
                        : null,
                  ),
            ],
          ),
          if (_answer == _Answer.none) ...[
            const SizedBox(height: AppSpace.s12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const ValueKey('order-reset'),
                    onPressed: _order.isEmpty
                        ? null
                        : () => setState(_order.clear),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(AppTouch.min),
                    ),
                    child: const Text(GrammarTexts.orderReset),
                  ),
                ),
                const SizedBox(width: AppSpace.s8),
                Expanded(
                  child: FilledButton(
                    key: const ValueKey('practice-check'),
                    onPressed: _order.length == item.tokens.length
                        ? () => _check(picked.join(' '))
                        : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(AppTouch.min),
                    ),
                    child: const Text(GrammarTexts.check),
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _sayView(PracticeItem item) {
    final theme = Theme.of(context);
    final c = widget.controller;
    final text = item.text ?? '';
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final playing = c.playingId == item.id;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.speak == null
                  ? GrammarTexts.sayNoSpeech
                  : GrammarTexts.sayHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.ink500,
              ),
            ),
            const SizedBox(height: AppSpace.s4),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        key: const ValueKey('say-text'),
                        style: AppTypography.lead.copyWith(
                          color: AppPalette.ink,
                        ),
                      ),
                      if (item.tr != null)
                        Text(
                          item.tr!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppPalette.ink500,
                          ),
                        ),
                    ],
                  ),
                ),
                if (c.canPlay(item.audio))
                  IconButton(
                    key: ValueKey('play-${item.id}'),
                    tooltip: GrammarTexts.playExample(text),
                    color: AppPalette.seaBlue,
                    onPressed: () => unawaited(
                      playing
                          ? c.stop()
                          : c.playExample(
                              id: item.id,
                              text: text,
                              audio: item.audio,
                              words: item.words,
                            ),
                    ),
                    icon: Icon(
                      playing
                          ? Icons.stop_circle_outlined
                          : Icons.volume_up_rounded,
                    ),
                  ),
              ],
            ),
            if (widget.speak != null) ...[
              const SizedBox(height: AppSpace.s8),
              SpeakPractice(
                key: ValueKey('grammar-speak-${item.id}'),
                expected: text,
                env: widget.speak!,
                place: SpeechPlace.grammar,
                contentId: widget.lessonId,
                keyPrefix: 'grammar-speak',
              ),
            ],
          ],
        );
      },
    );
  }

  List<Widget> _feedback(PracticeItem item) {
    final theme = Theme.of(context);
    final last = _q == widget.items.length - 1;
    final nextButton = FilledButton(
      key: const ValueKey('practice-next'),
      onPressed: _next,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AppTouch.min),
      ),
      child: Text(
        last ? CommonTexts.continueAction : GrammarTexts.nextQuestion,
      ),
    );
    if (item.kind == PracticeKind.say) return [nextButton];
    switch (_answer) {
      case _Answer.none:
        return [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              key: const ValueKey('practice-skip'),
              onPressed: _skip,
              style: TextButton.styleFrom(
                minimumSize: const Size(AppTouch.min, AppTouch.min),
              ),
              child: const Text(GrammarTexts.skip),
            ),
          ),
        ];
      case _Answer.correct:
        final solved = item.solved;
        return [
          Semantics(
            liveRegion: true,
            child: Container(
              key: const ValueKey('practice-correct'),
              padding: const EdgeInsets.all(AppSpace.s12),
              decoration: const BoxDecoration(
                color: AppPalette.successSurface,
                borderRadius: AppRadius.mdAll,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      _skipped
                          ? Icons.lightbulb_outline_rounded
                          : Icons.check_circle_rounded,
                      color: AppPalette.success,
                    ),
                  ),
                  const SizedBox(width: AppSpace.s8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_skipped)
                          Text(
                            GrammarTexts.correct,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppPalette.success,
                            ),
                          ),
                        if (solved != null)
                          Text(
                            _skipped ? GrammarTexts.answerWas(solved) : solved,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppPalette.ink,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s12),
          nextButton,
        ];
      case _Answer.wrong:
        return [
          Semantics(
            liveRegion: true,
            child: Container(
              key: const ValueKey('practice-feedback'),
              padding: const EdgeInsets.all(AppSpace.s12),
              decoration: const BoxDecoration(
                color: AppPalette.yellow100,
                borderRadius: AppRadius.mdAll,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExcludeSemantics(
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppPalette.orange700,
                    ),
                  ),
                  const SizedBox(width: AppSpace.s8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GrammarTexts.tryTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppPalette.ink,
                          ),
                        ),
                        if (item.feedbackTr != null)
                          Text(
                            item.feedbackTr!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppPalette.ink,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const ValueKey('practice-skip'),
                  onPressed: _skip,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppTouch.min),
                  ),
                  child: const Text(GrammarTexts.skip),
                ),
              ),
              const SizedBox(width: AppSpace.s8),
              Expanded(
                child: FilledButton(
                  key: const ValueKey('practice-retry'),
                  onPressed: _retry,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppTouch.min),
                  ),
                  child: const Text(GrammarTexts.tryAgain),
                ),
              ),
            ],
          ),
        ];
    }
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    super.key,
    required this.text,
    required this.state,
    required this.onPressed,
  });

  final String text;
  final _Answer state;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, side) = switch (state) {
      _Answer.correct => (
        AppPalette.successSurface,
        AppPalette.success,
        AppPalette.success,
      ),
      _Answer.wrong => (
        AppPalette.yellow100,
        AppPalette.ink,
        AppPalette.lighthouseYellow,
      ),
      _Answer.none => (
        AppPalette.white,
        AppPalette.seaBlue,
        AppPalette.seaBlue200,
      ),
    };
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(72, AppTouch.min),
        backgroundColor: bg,
        foregroundColor: fg,
        disabledForegroundColor: fg,
        disabledBackgroundColor: bg,
        side: BorderSide(color: side, width: 2),
        textStyle: AppTypography.lead,
      ),
      child: Text(text),
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({
    super.key,
    required this.text,
    required this.selected,
    required this.onPressed,
  });

  final String text;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(AppTouch.min, AppTouch.min),
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s12),
      backgroundColor: selected ? AppPalette.seaBlue50 : AppPalette.white,
      foregroundColor: AppPalette.ink,
      disabledForegroundColor: AppPalette.ink,
      side: const BorderSide(color: AppPalette.seaBlue200),
    ),
    child: Text(text, style: AppTypography.lead),
  );
}
