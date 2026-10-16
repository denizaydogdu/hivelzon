import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/speech/speak_widgets.dart';
import '../../../shared/speech/speech_match.dart';
import '../../../shared/speech/speech_providers.dart';
import '../../../shared/speech/speech_store.dart';
import '../../../shared/ui/ui.dart';
import '../../hi/application/hi_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../speak/speak_env.dart';
import '../application/talk_providers.dart';
import '../domain/talk_match.dart';
import '../domain/talk_task.dart';
import 'talk_widgets.dart';

/// Turun cevap yolu: söyleyerek (yardımsız), seçerek, dizerek ya da geçerek.
enum _Mode { none, choose, build }

/// Bitmiş bir turun sonucu.
class _TurnResult {
  const _TurnResult({this.answer, this.own = false, this.spoken = false});

  /// Kabul edilen cevap (kabul listesindeki yazımıyla); geçildiyse null.
  final String? answer;

  /// Yardımsız üretim (seçenek görmeden söyledi).
  final bool own;
  final bool spoken;

  bool get skipped => answer == null;
}

/// Yönlendirmeli sahne (H-090): 3–5 tur. Her turda karakterin satırı
/// (İngilizce; Türkçesi istenince), Türkçe görev ve cevap: söyle (cihazda
/// tanıma, H-055; izin ilk kullanımda), seçeneklerden seç, kelimelerle kur
/// ya da geç. Puan yok; söylemede en çok 2 deneme, sonra örnek cevap (K-32).
/// Mikrofon olmadan da baştan sona dokunarak oynanır.
///
/// Söylenen yazı yalnızca bellekte, karşılaştırma için kullanılır; ekranda
/// kullanıcının balonunda kabul listesindeki cevap görünür.
class TalkSceneView extends ConsumerStatefulWidget {
  const TalkSceneView({super.key, required this.task});

  final TalkTask task;

  @override
  ConsumerState<TalkSceneView> createState() => _TalkSceneViewState();
}

class _TalkSceneViewState extends ConsumerState<TalkSceneView> {
  late final TalkLineSpeaker _player = TalkLineSpeaker(ref);
  final _scroll = ScrollController();

  /// -1: giriş; 0…n-1: tur; n: bitti.
  int _index = -1;
  final List<_TurnResult> _results = [];
  final List<String> _ownUsed = [];

  // Geçerli turun durumu.
  _Mode _mode = _Mode.none;
  bool _sawHelp = false;
  int _attempts = 0;
  bool _listening = false;
  String? _feedback;
  String? _reaction;
  final Set<int> _wrongOptions = {};
  final List<int> _built = [];
  bool _buildRetry = false;
  _TurnResult? _result;

  TalkTask get _task => widget.task;
  bool get _done => _index >= _task.turns.length;
  TalkTurn get _turn => _task.turns[_index];

  @override
  void dispose() {
    _player.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _resetTurn() {
    _mode = _Mode.none;
    _sawHelp = false;
    _attempts = 0;
    _listening = false;
    _feedback = null;
    _reaction = null;
    _wrongOptions.clear();
    _built.clear();
    _buildRetry = false;
    _result = null;
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final reduce = AppMotion.reduced(context);
      final to = _scroll.position.maxScrollExtent;
      if (reduce) {
        _scroll.jumpTo(to);
      } else {
        unawaited(
          _scroll.animateTo(
            to,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          ),
        );
      }
    });
  }

  void _start() {
    setState(() {
      _index = 0;
      _results.clear();
      _ownUsed.clear();
      _resetTurn();
    });
    _scrollToEnd();
  }

  Future<void> _next() async {
    final r = _result;
    if (r != null) _results.add(r);
    await _player.stop();
    final last = _index + 1 >= _task.turns.length;
    setState(() {
      _index++;
      _resetTurn();
    });
    if (last) {
      await ref.read(talkActionsProvider).markDone(_task.id);
      if (mounted) {
        refreshHi(ref);
        refreshTalk(ref);
      }
    }
    _scrollToEnd();
  }

  Future<void> _accept(String answer, {required bool own, bool spoken = false}) async {
    final used = TalkMatcher.usedTargets(_turn.targets, answer);
    setState(() {
      _result = _TurnResult(answer: answer, own: own, spoken: spoken);
      if (own) {
        for (final u in used) {
          if (!_ownUsed.contains(u)) _ownUsed.add(u);
        }
      }
    });
    _scrollToEnd();
    if (used.isNotEmpty) {
      await ref.read(talkActionsProvider).recordUse(used, own: own);
      if (mounted) ref.invalidate(evidenceSummaryProvider);
    }
  }

  void _skip() {
    setState(() => _result = const _TurnResult());
    _scrollToEnd();
  }

  // ------------------------------------------------------------ söyleme

  Future<void> _listen() async {
    final env = speakEnvOf(context);
    if (_listening) {
      unawaited(env.recognizer.stop());
      return;
    }
    if (!await env.ensureReady(context)) return;
    if (!mounted) return;
    setState(() {
      _listening = true;
      _reaction = null;
    });
    final turn = _turn;
    final heard = await env.recognizer.listenOnce(debugExpected: turn.model);
    if (!mounted || _done || !identical(turn, _turn)) return;
    final r = TalkMatcher.judgeSpeech(turn, heard.alternatives);
    _attempts++;
    env.record(
      SpeechAttempt(
        place: SpeechPlace.talk,
        contentId: _task.id,
        itemRef: turn.accept[r.acceptIndex ?? 0],
        level: switch (r.outcome) {
          TalkSpeechOutcome.accepted => SpeechMatchLevel.full,
          TalkSpeechOutcome.close => SpeechMatchLevel.close,
          _ => SpeechMatchLevel.no,
        },
        missingCount: r.match?.missingWords.length ?? 0,
        at: DateTime.now().toUtc(),
      ),
    );
    setState(() => _listening = false);
    if (r.accepted) {
      await _accept(
        turn.accept[r.acceptIndex!],
        own: !_sawHelp,
        spoken: true,
      );
      return;
    }
    setState(() {
      _feedback = switch (r.outcome) {
        TalkSpeechOutcome.silence => SpeakTexts.silence,
        TalkSpeechOutcome.distractor => null,
        TalkSpeechOutcome.close when r.match!.changedWords.isNotEmpty =>
          SpeakTexts.closeExtra(r.match!.changedWords),
        TalkSpeechOutcome.close when r.match!.missingWords.length == 1 =>
          SpeakTexts.close(r.match!.missingWords.single),
        _ => SpeakTexts.tryAgain,
      };
      if (r.outcome == TalkSpeechOutcome.distractor) {
        _reaction = turn.distractors[r.distractorIndex!].reactionTr;
      }
      if (_attempts >= 2) _sawHelp = true;
    });
    _scrollToEnd();
  }

  // ------------------------------------------------------------ seçme ve dizme

  /// Seçenekler: iki kabul cevabı + yakın seçenekler, tura göre sabit sırada.
  List<(String, int?)> _options(TalkTurn t) {
    final list = <(String, int?)>[
      for (final a in t.accept.take(2)) (a, null),
      for (var i = 0; i < t.distractors.length; i++) (t.distractors[i].en, i),
    ];
    final shift = t.id.codeUnits.fold<int>(0, (a, b) => a + b) % list.length;
    return [...list.skip(shift), ...list.take(shift)];
  }

  void _open(_Mode m) {
    setState(() {
      _mode = m;
      _sawHelp = true;
      _built.clear();
      _buildRetry = false;
    });
    _scrollToEnd();
  }

  void _choose(int i, (String, int?) o) {
    final d = o.$2;
    if (d == null) {
      unawaited(_accept(o.$1, own: false));
      return;
    }
    setState(() {
      _wrongOptions.add(i);
      _reaction = _turn.distractors[d].reactionTr;
    });
  }

  void _tapTile(List<String> tiles, int i) {
    setState(() {
      _buildRetry = false;
      _built.add(i);
    });
    if (_built.length < tiles.length) return;
    final answer = [for (final j in _built) tiles[j]].join(' ');
    if (TalkMatcher.isAccepted(_turn, answer)) {
      unawaited(_accept(_turn.model, own: false));
    } else {
      setState(() {
        _buildRetry = true;
        _built.clear();
      });
    }
  }

  // ------------------------------------------------------------ görünüm

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final speaker = _task.characterName ?? '';
    final children = <Widget>[];
    if (_index < 0) {
      children.addAll([
        TalkImage(task: _task),
        const SizedBox(height: AppSpace.s16),
        Text(_task.introTr ?? '', style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpace.s12),
        Text(
          TalkTexts.rehearsalNote,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink500),
        ),
        const SizedBox(height: AppSpace.s24),
        FilledButton(
          key: const ValueKey('talk-start'),
          onPressed: _start,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTouch.primary),
          ),
          child: const Text(TalkTexts.start),
        ),
      ]);
    } else {
      final n = _task.turns.length;
      children.add(
        Semantics(
          liveRegion: true,
          child: Text(
            _done
                ? TalkTexts.endTitle
                : TalkTexts.turnProgress(_index + 1, n),
            key: const ValueKey('talk-progress'),
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppPalette.ink500,
            ),
          ),
        ),
      );
      for (var i = 0; i < _results.length; i++) {
        final t = _task.turns[i];
        final r = _results[i];
        children
          ..add(const SizedBox(height: AppSpace.s12))
          ..add(TalkBubble(speaker: speaker, text: t.line.en));
        children
          ..add(const SizedBox(height: AppSpace.s8))
          ..add(
            TalkBubble(
              key: ValueKey('talk-answer-${t.id}'),
              speaker: TalkTexts.you,
              text: r.answer ?? t.model,
              mine: true,
            ),
          );
      }
      if (!_done) {
        children
          ..add(const SizedBox(height: AppSpace.s12))
          ..add(
            TalkLineView(
              key: ValueKey('talk-line-${_turn.id}'),
              speaker: speaker,
              line: _turn.line,
              player: _player,
              keyPrefix: 'talk-line',
            ),
          )
          ..add(const SizedBox(height: AppSpace.s16))
          ..add(_panel(theme));
      } else {
        children.addAll(_end(theme, speaker));
      }
    }
    return Scaffold(
      backgroundColor: AppPalette.sand,
      appBar: AppBar(title: Text(_task.titleTr)),
      body: SafeArea(
        top: false,
        child: ListView(
          key: const ValueKey('talk-scene'),
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(
            AppSpace.page,
            AppSpace.s8,
            AppSpace.page,
            AppSpace.s32,
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _panel(ThemeData theme) {
    final t = _turn;
    final r = _result;
    final speech = ref.watch(speechVisibleProvider);
    final c = <Widget>[
      const CapsLabel(TalkTexts.yourTurn),
      const SizedBox(height: AppSpace.s4),
      Text(
        t.promptTr,
        key: const ValueKey('talk-prompt'),
        style: theme.textTheme.titleMedium,
      ),
      const SizedBox(height: AppSpace.s12),
    ];
    if (r != null) {
      c.addAll(_resultView(theme, t, r));
    } else {
      final revealed = _attempts >= 2;
      if (speech && !revealed) {
        c.add(
          Semantics(
            liveRegion: _listening,
            child: FilledButton.tonalIcon(
              key: const ValueKey('talk-mic'),
              onPressed: _listen,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.min),
                textStyle: AppTypography.button,
              ),
              icon: Icon(
                _listening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
              ),
              label: Text(
                _listening
                    ? SpeakTexts.stop
                    : _attempts == 0
                    ? SpeakTexts.say
                    : SpeakTexts.sayAgain,
              ),
            ),
          ),
        );
        if (_listening) {
          c.add(
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.s4),
              child: Text(
                SpeakTexts.listening,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        }
      }
      if (_feedback != null && !_listening && !revealed) {
        c.add(_note(theme, _feedback!, key: 'talk-feedback'));
      }
      if (revealed) {
        c
          ..add(
            Text(
              TalkTexts.revealed,
              key: const ValueKey('talk-revealed'),
              style: theme.textTheme.bodyLarge,
            ),
          )
          ..add(
            Text(
              t.model,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: AppFonts.bold,
              ),
            ),
          );
      }
      if (_reaction != null) {
        c
          ..add(const SizedBox(height: AppSpace.s8))
          ..add(
            InfoCard(
              key: const ValueKey('talk-reaction'),
              tone: InfoTone.info,
              icon: Icons.lightbulb_outline_rounded,
              title: SpeakTexts.closeTitle,
              body: _reaction,
            ),
          );
      }
      c.add(const SizedBox(height: AppSpace.s12));
      switch (_mode) {
        case _Mode.none:
          c.add(
            Wrap(
              spacing: AppSpace.s8,
              runSpacing: AppSpace.s8,
              children: [
                OutlinedButton.icon(
                  key: const ValueKey('talk-choose'),
                  onPressed: () => _open(_Mode.choose),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(AppTouch.min, AppTouch.min),
                  ),
                  icon: const Icon(Icons.touch_app_outlined),
                  label: const Text(TalkTexts.chooseMode),
                ),
                OutlinedButton.icon(
                  key: const ValueKey('talk-build'),
                  onPressed: () => _open(_Mode.build),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(AppTouch.min, AppTouch.min),
                  ),
                  icon: const Icon(Icons.view_week_outlined),
                  label: const Text(TalkTexts.buildMode),
                ),
              ],
            ),
          );
        case _Mode.choose:
          c.addAll(_chooseView(theme, t));
        case _Mode.build:
          c.addAll(_buildView(theme, t));
      }
      c.add(
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            key: const ValueKey('talk-skip'),
            onPressed: _skip,
            style: TextButton.styleFrom(
              minimumSize: const Size(AppTouch.min, AppTouch.min),
            ),
            child: const Text(TalkTexts.skip),
          ),
        ),
      );
    }
    return Container(
      key: const ValueKey('talk-panel'),
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: c,
      ),
    );
  }

  Widget _note(ThemeData theme, String text, {required String key}) => Padding(
    padding: const EdgeInsets.only(top: AppSpace.s8),
    child: Semantics(
      liveRegion: true,
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
            child: Text(
              text,
              key: ValueKey(key),
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    ),
  );

  List<Widget> _chooseView(ThemeData theme, TalkTurn t) {
    final opts = _options(t);
    return [
      Text(TalkTexts.chooseHint, style: theme.textTheme.bodyMedium),
      const SizedBox(height: AppSpace.s8),
      for (var i = 0; i < opts.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.s8),
          child: OutlinedButton(
            key: ValueKey('talk-opt-$i'),
            onPressed: _wrongOptions.contains(i)
                ? null
                : () => _choose(i, opts[i]),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.min),
              alignment: Alignment.centerLeft,
              backgroundColor: AppPalette.white,
            ),
            child: Text(opts[i].$1),
          ),
        ),
    ];
  }

  List<Widget> _buildView(ThemeData theme, TalkTurn t) {
    final tiles = TalkMatcher.tiles(
      t.model,
      t.id.codeUnits.fold<int>(0, (a, b) => a + b),
    );
    final built = [for (final j in _built) tiles[j]].join(' ');
    return [
      Text(TalkTexts.buildHint, style: theme.textTheme.bodyMedium),
      const SizedBox(height: AppSpace.s8),
      Container(
        key: const ValueKey('talk-built'),
        constraints: const BoxConstraints(minHeight: AppTouch.min),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.s12,
          vertical: AppSpace.s8,
        ),
        decoration: BoxDecoration(
          color: AppPalette.sand50,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: AppPalette.sand300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(built, style: theme.textTheme.titleMedium),
            ),
            if (_built.isNotEmpty)
              IconButton(
                key: const ValueKey('talk-undo'),
                tooltip: TalkTexts.buildUndo,
                onPressed: () => setState(() => _built.removeLast()),
                icon: const Icon(Icons.backspace_outlined),
              ),
          ],
        ),
      ),
      if (_buildRetry) _note(theme, TalkTexts.buildRetry, key: 'talk-build-retry'),
      const SizedBox(height: AppSpace.s8),
      Wrap(
        spacing: AppSpace.s8,
        runSpacing: AppSpace.s8,
        children: [
          for (var i = 0; i < tiles.length; i++)
            if (!_built.contains(i))
              OutlinedButton(
                key: ValueKey('talk-tile-$i'),
                onPressed: () => _tapTile(tiles, i),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(AppTouch.min, AppTouch.min),
                  backgroundColor: AppPalette.white,
                ),
                child: Text(tiles[i]),
              ),
        ],
      ),
    ];
  }

  List<Widget> _resultView(ThemeData theme, TalkTurn t, _TurnResult r) {
    final other = r.skipped
        ? null
        : t.accept.where((a) => a != r.answer).firstOrNull;
    return [
      if (r.skipped) ...[
        Text(TalkTexts.skipped, style: theme.textTheme.bodyLarge),
        Text(
          t.model,
          key: const ValueKey('talk-model'),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: AppFonts.bold,
          ),
        ),
      ] else ...[
        Row(
          children: [
            const ExcludeSemantics(
              child: Icon(Icons.check_circle_rounded, color: AppPalette.success),
            ),
            const SizedBox(width: AppSpace.s8),
            Expanded(
              child: Text(
                r.spoken ? SpeakTexts.full : TalkTexts.accepted,
                key: const ValueKey('talk-accepted'),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppPalette.success,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.s8),
        TalkBubble(
          key: ValueKey('talk-answer-${t.id}'),
          speaker: TalkTexts.you,
          text: r.answer!,
          mine: true,
        ),
        if (other != null) ...[
          const SizedBox(height: AppSpace.s8),
          Text(
            TalkTexts.alsoSay(other),
            key: const ValueKey('talk-also'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppPalette.ink700,
            ),
          ),
        ],
      ],
      const SizedBox(height: AppSpace.s16),
      FilledButton(
        key: const ValueKey('talk-next'),
        onPressed: _next,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.primary),
        ),
        child: const Text(TalkTexts.next),
      ),
    ];
  }

  List<Widget> _end(ThemeData theme, String speaker) {
    final outro = _task.outro;
    return [
      if (outro != null) ...[
        const SizedBox(height: AppSpace.s12),
        TalkLineView(
          key: const ValueKey('talk-outro'),
          speaker: speaker,
          line: outro,
          player: _player,
          keyPrefix: 'talk-outro',
        ),
      ],
      const SizedBox(height: AppSpace.s24),
      const Center(child: CalmCelebration(icon: Icons.forum_rounded, size: 96)),
      const SizedBox(height: AppSpace.s16),
      Semantics(
        header: true,
        child: Text(
          TalkTexts.endTitle,
          key: const ValueKey('talk-end'),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
      ),
      const SizedBox(height: AppSpace.s8),
      Text(
        _ownUsed.isEmpty ? TalkTexts.endBody : TalkTexts.endOwn(_ownUsed),
        key: const ValueKey('talk-end-body'),
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyLarge,
      ),
      const SizedBox(height: AppSpace.s24),
      FilledButton(
        key: const ValueKey('talk-back'),
        onPressed: () => Navigator.of(context).maybePop(),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.primary),
        ),
        child: const Text(TalkTexts.backToTalk),
      ),
      const SizedBox(height: AppSpace.s8),
      OutlinedButton(
        key: const ValueKey('talk-replay'),
        onPressed: _start,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.min),
        ),
        child: const Text(TalkTexts.replay),
      ),
    ];
  }
}
