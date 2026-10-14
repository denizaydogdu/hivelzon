import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/fsrs/fsrs.dart';
import '../../../shared/meaning/error_taxonomy.dart';
import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/speech/speak_controller.dart';
import '../../../shared/speech/speak_widgets.dart';
import '../../../shared/speech/speech_match.dart';
import '../../../shared/speech/speech_providers.dart';
import '../../../shared/speech/speech_store.dart';
import '../../speak/speak_env.dart';
import '../../hi/application/hi_providers.dart';
import '../../hi/presentation/hi_cards.dart';
import '../application/card_audio_player.dart';
import '../application/notebook_providers.dart';
import '../domain/retrieval_task.dart';
import '../domain/review_policy.dart';
import '../domain/review_session.dart';
import 'notebook_screen.dart';
import 'widgets/card_face.dart';

/// Testlerde belirlenimci seçenek sırası için.
final reviewRandomProvider = Provider<math.Random>((ref) => math.Random());

enum _Phase { loading, empty, asking, feedback, done, error }

/// Tekrar oturumu (H-036): hatırlama soruları → FSRS notu.
///
/// Süre ölçülür ama gösterilmez (K-32: geri sayım yok). "Bilmiyorum" her
/// görevde var; utandırmaz, kart oturumun sonunda yeniden gelir.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  late final CardAudioPlayer _audio;
  final Stopwatch _watch = Stopwatch();
  ReviewSession? _session;
  _Phase _phase = _Phase.loading;
  ReviewOutcome? _outcome;
  SessionSummary? _summary;
  int? _chosen;
  bool _revealed = false;
  final List<String> _picked = [];
  final TextEditingController _typed = TextEditingController();

  /// "Dinle ve söyle" (H-055): son denemenin durumu (yalnızca sonuç).
  SpeakController? _speak;
  String? _speakNoteId;
  SpeechMatchLevel? _speakLevel;

  @override
  void initState() {
    super.initState();
    _audio = createCardAudio(ref);
    unawaited(_load());
  }

  @override
  void dispose() {
    _audio.dispose();
    _typed.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final store = ref.read(notebookStoreProvider);
      final overview = await ref.read(reviewOverviewProvider.future);
      final entries = await store.entries();
      final picked = pickSessionCards(
        entries,
        now: store.now(),
        newAllowed: overview.newAvailable,
      );
      // H-055: cihazda tanıma yoksa ya da kapalıysa "Dinle ve söyle" gelmez.
      final canSpeak = (await ref.read(
        speechStatusProvider.future,
      )).showsPractice;
      if (!mounted) return;
      if (picked.isEmpty) {
        setState(() => _phase = _Phase.empty);
        return;
      }
      final session = ReviewSession(
        queue: [for (final e in picked) SessionCard(e.item, e.card)],
        pool: [for (final e in entries) e.item],
        scheduler: ReviewPolicy.scheduler(),
        persist: store.saveOutcome,
        clock: store.now,
        random: ref.read(reviewRandomProvider),
        canSpeak: canSpeak,
      );
      _session = session;
      session.start();
      _beginTask();
    } on Object catch (e) {
      debugPrint('[H036] tekrar başlatılamadı: $e');
      if (mounted) setState(() => _phase = _Phase.error);
    }
  }

  void _beginTask() {
    _chosen = null;
    _revealed = false;
    _picked.clear();
    _typed.clear();
    _outcome = null;
    _speak = null;
    _speakNoteId = null;
    _speakLevel = null;
    _watch
      ..reset()
      ..start();
    setState(() => _phase = _Phase.asking);
    final task = _session?.task;
    if (task?.type == TaskType.listenChoice || task?.type == TaskType.speak) {
      unawaited(_audio.play(task!.item));
    }
  }

  /// "Dinle ve söyle" denemesi bitti (H-055). Tam → hemen; denemeler dolunca
  /// en iyi sonuç; yakın sonuçta kullanıcı "Devam et" ile de geçebilir.
  void _onSpeakAttempt(SpeakController c) {
    _speak = c;
    _speakNoteId = c.errorNoteId ?? _speakNoteId;
    if (c.finished) {
      unawaited(_answerSpeech(c.bestLevel ?? SpeechMatchLevel.no, c.attempts));
    } else if (mounted) {
      setState(() {});
    }
  }

  Future<void> _answerSpeech(SpeechMatchLevel level, int attempts) async {
    final s = _session;
    final sc = s?.current;
    if (s == null || sc == null) return;
    _speakLevel = level;
    final rating = ReviewPolicy.rateSpeech(
      level: level,
      elapsed: _watch.elapsed,
      stage: sc.card.stage,
      attempts: attempts,
      audioLength: sc.item.audio?.length ?? Duration.zero,
    );
    await _answer(correct: level != SpeechMatchLevel.no, rating: rating);
  }

  /// "Geç": not yok, kayıt yok; kart sonraki oturumda yine gelir.
  void _skip() {
    final s = _session;
    if (s == null || _phase != _Phase.asking) return;
    s.skip();
    _continue();
  }

  Future<void> _answer({
    required bool correct,
    bool dontKnow = false,
    FsrsRating? rating,
  }) async {
    final s = _session;
    final task = s?.task;
    if (s == null || task == null || _phase != _Phase.asking) return;
    _watch.stop();
    setState(() => _phase = _Phase.feedback);
    final ReviewOutcome outcome;
    try {
      outcome = await s.answer(
        correct: correct,
        dontKnow: dontKnow,
        elapsed: _watch.elapsed,
        rating: rating,
      );
    } on Object catch (e) {
      debugPrint('[H036] cevap kaydedilemedi: $e');
      if (mounted) setState(() => _phase = _Phase.error);
      return;
    }
    // Söyleme denemesi `speech_attempts`'e yazıldı; tanıma gürültüsü hata
    // sayılmaz. "Bilmiyorum" her görevde hatırlama sinyalidir.
    if (!outcome.correct && (task.type != TaskType.speak || dontKnow)) {
      _recordMiss(task);
    }
    if (!mounted) return;
    setState(() => _outcome = outcome);
    unawaited(_audio.play(outcome.item));
  }

  void _recordMiss(RetrievalTask task) {
    final type = switch (task.type) {
      TaskType.arrange => ErrorType.wordOrder,
      TaskType.type => ErrorType.spelling,
      _ => ErrorType.recall,
    };
    unawaited(
      ref
          .read(learningEventLogProvider)
          .record(
            LearningEvent(
              contentId: task.item.contentId ?? '',
              sourceId: 'review:${task.type.code}',
              target: task.item.textEn,
              at: DateTime.now().toUtc(),
              errorType: type,
            ),
          )
          .catchError((Object e) => debugPrint('[H036] olay yazılamadı: $e')),
    );
  }

  void _continue() {
    final s = _session;
    if (s == null) return;
    unawaited(_audio.stop());
    if (s.next() == null) {
      final now = DateTime.now().toUtc();
      final (_, endTomorrow) = localDayBounds(now, addDays: 1);
      setState(() {
        _summary = s.summary(endOfTomorrowUtc: endTomorrow);
        _phase = _Phase.done;
      });
      return;
    }
    _beginTask();
  }

  @override
  Widget build(BuildContext context) {
    final s = _session;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sand,
        leading: IconButton(
          key: const ValueKey('review-close'),
          tooltip: CommonTexts.close,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text(
          s == null || _phase == _Phase.done
              ? ReviewTexts.title
              : ReviewTexts.progress(math.min(s.position, s.total), s.total),
        ),
      ),
      body: SafeArea(
        child: switch (_phase) {
          _Phase.loading => const Center(child: CircularProgressIndicator()),
          _Phase.empty => _CenteredMessage(
            icon: Icons.check_circle_outline_rounded,
            title: ReviewTexts.emptyTitle,
            body: ReviewTexts.emptyBody,
            onBack: () => context.pop(),
          ),
          _Phase.error => _CenteredMessage(
            icon: Icons.error_outline_rounded,
            title: ReviewTexts.errorTitle,
            body: ReviewTexts.errorBody,
            onBack: () => context.pop(),
          ),
          _Phase.asking => _taskView(context),
          _Phase.feedback => _feedbackView(context),
          _Phase.done => _summaryView(context),
        },
      ),
    );
  }

  // ------------------------------------------------------------ görev

  Widget _taskView(BuildContext context) {
    final task = _session!.task!;
    final theme = Theme.of(context);
    final item = task.item;
    final prompt = switch (task.type) {
      TaskType.pictureChoice => ReviewTexts.pictureChoice,
      TaskType.listenChoice => ReviewTexts.listenChoice,
      TaskType.arrange => ReviewTexts.arrange,
      TaskType.type => ReviewTexts.type,
      TaskType.selfCheck || TaskType.sceneHunt => ReviewTexts.selfCheck,
      TaskType.speak => SpeakTexts.reviewTask,
    };
    final children = <Widget>[
      Text(
        prompt,
        key: ValueKey('task-${task.type.code}'),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
    ];
    if (task.type == TaskType.speak) {
      children.addAll([
        NotebookImage(item: item, aspectRatio: 16 / 10),
        const SizedBox(height: AppSpacing.sm),
        if (item.textTr != null)
          Text(
            item.textTr!,
            key: const ValueKey('task-meaning'),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(SpeakTexts.reviewHint, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
      ]);
    }
    if (task.type == TaskType.listenChoice || task.type == TaskType.speak) {
      children.add(
        Center(
          child: ListenableBuilder(
            listenable: _audio,
            builder: (context, _) => FilledButton.icon(
              key: const ValueKey('task-listen'),
              onPressed: () => _audio.play(item),
              style: FilledButton.styleFrom(minimumSize: const Size(160, 64)),
              icon: Icon(
                _audio.playingKey == CardAudioPlayer.keyFor(item)
                    ? Icons.graphic_eq_rounded
                    : Icons.volume_up_rounded,
                size: 32,
              ),
              label: const Text(ReviewTexts.listen),
            ),
          ),
        ),
      );
    } else if (task.type != TaskType.speak) {
      children.addAll([
        NotebookImage(item: item, aspectRatio: 16 / 10),
        const SizedBox(height: AppSpacing.sm),
        if (item.textTr != null)
          Text(
            item.textTr!,
            key: const ValueKey('task-meaning'),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
      ]);
    }
    children.add(const SizedBox(height: AppSpacing.sm));
    switch (task.type) {
      case TaskType.pictureChoice || TaskType.listenChoice:
        for (final (i, o) in task.options.indexed) {
          children.add(
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: OutlinedButton(
                key: ValueKey('option-$i'),
                onPressed: () {
                  _chosen = i;
                  _answer(correct: task.isCorrectChoice(i));
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                ),
                child: Text(o, style: theme.textTheme.titleMedium),
              ),
            ),
          );
        }
      case TaskType.arrange:
        children.addAll(_arrange(task, theme));
      case TaskType.type:
        children.addAll([
          TextField(
            key: const ValueKey('task-input'),
            controller: _typed,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _checkTyped(task),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: ReviewTexts.typeHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton(
            key: const ValueKey('task-check'),
            onPressed: () => _checkTyped(task),
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            child: const Text(ReviewTexts.check),
          ),
        ]);
      case TaskType.speak:
        final c = _speak;
        children.add(
          SpeakPractice(
            key: ValueKey('speak-${item.key}-${_session!.position}'),
            expected: task.spokenText,
            env: speakEnvOf(context),
            place: SpeechPlace.review,
            contentId: item.contentId,
            onAttempt: _onSpeakAttempt,
            keyPrefix: 'review-speak',
          ),
        );
        // Yakın sonuçta denemeyi bitirip geçmek de olur (→ Hard).
        if (c != null &&
            !c.finished &&
            c.last?.level == SpeechMatchLevel.close) {
          children.add(
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: FilledButton(
                key: const ValueKey('review-speak-accept'),
                onPressed: () => unawaited(
                  _answerSpeech(SpeechMatchLevel.close, c.attempts),
                ),
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                child: const Text(SpeakTexts.reviewAccept),
              ),
            ),
          );
        }
      case TaskType.selfCheck || TaskType.sceneHunt:
        if (!_revealed) {
          children.add(
            FilledButton(
              key: const ValueKey('task-reveal'),
              onPressed: () => setState(() => _revealed = true),
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              child: const Text(ReviewTexts.openCard),
            ),
          );
        } else {
          children.addAll([
            Text(
              item.textEn,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(
              key: const ValueKey('task-knew'),
              onPressed: () => _answer(correct: true),
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              child: const Text(ReviewTexts.knewIt),
            ),
          ]);
        }
    }
    children.addAll([
      const SizedBox(height: AppSpacing.sm),
      // İkincil ama açıkça düğme (utandırmaz): seçeneklerden ayrışan
      // kenarlıklı, dolgusuz biçim.
      Center(
        child: OutlinedButton.icon(
          key: const ValueKey('task-dont-know'),
          onPressed: () => _answer(correct: false, dontKnow: true),
          style: AppButtonStyles.dontKnow(minimumSize: const Size(220, 48)),
          icon: const Icon(AppButtonStyles.dontKnowIcon),
          label: const Text(ReviewTexts.dontKnow),
        ),
      ),
      if (task.type == TaskType.speak)
        Center(
          child: TextButton(
            key: const ValueKey('task-skip'),
            onPressed: _skip,
            style: TextButton.styleFrom(minimumSize: const Size(120, 48)),
            child: const Text(SpeakTexts.skip),
          ),
        ),
    ]);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: children,
    );
  }

  List<Widget> _arrange(RetrievalTask task, ThemeData theme) {
    final remaining = List.of(task.tokens);
    for (final p in _picked) {
      remaining.remove(p);
    }
    Widget chip(String t, VoidCallback onTap, {required Key key}) => ActionChip(
      key: key,
      label: Text(t, style: theme.textTheme.titleMedium),
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.white,
    );
    return [
      Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.seaBlue.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final (i, t) in _picked.indexed)
              chip(
                t,
                () => setState(() => _picked.removeAt(i)),
                key: ValueKey('picked-$i'),
              ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          for (final (i, t) in remaining.indexed)
            chip(
              t,
              () => setState(() => _picked.add(t)),
              key: ValueKey('token-$i-$t'),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.sm),
      FilledButton(
        key: const ValueKey('task-check'),
        onPressed: remaining.isEmpty
            ? () => _answer(correct: task.isCorrectOrder(_picked))
            : null,
        style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
        child: const Text(ReviewTexts.check),
      ),
    ];
  }

  void _checkTyped(RetrievalTask task) {
    if (_typed.text.trim().isEmpty) return;
    _answer(correct: task.isCorrectTyped(_typed.text));
  }

  // ------------------------------------------------------------ geri bildirim

  Widget _feedbackView(BuildContext context) {
    final o = _outcome;
    final theme = Theme.of(context);
    if (o == null) return const Center(child: CircularProgressIndicator());
    final again = o.rating == FsrsRating.again;
    final speak = o.taskType == TaskType.speak;
    final title = o.correct
        ? (speak
              ? (_speakLevel == SpeechMatchLevel.close
                    ? SpeakTexts.closeTitle
                    : SpeakTexts.full)
              : ReviewTexts.correct)
        : speak && !o.dontKnow
        ? SpeakTexts.reveal
        : o.dontKnow
        ? ReviewTexts.dontKnowFeedback
        : ReviewTexts.wrongFeedback;
    final body = again
        ? (o.requeued ? ReviewTexts.requeued : ReviewTexts.soon)
        : null;
    final chosen = _chosen;
    final task = _session?.task;
    return ListView(
      key: const ValueKey('review-feedback'),
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        Row(
          children: [
            Icon(
              o.correct ? Icons.check_circle_rounded : Icons.lightbulb_rounded,
              color: o.correct ? AppColors.seaBlue : AppColors.eveningOrange,
              size: 32,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                title,
                key: const ValueKey('feedback-title'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        if (!o.correct &&
            !o.dontKnow &&
            chosen != null &&
            task != null &&
            chosen < task.options.length) ...[
          const SizedBox(height: 4),
          Text(
            ReviewTexts.chosen(task.options[chosen]),
            style: theme.textTheme.bodyMedium,
          ),
        ],
        if (body != null) ...[
          const SizedBox(height: 4),
          Text(body, key: const ValueKey('feedback-body')),
        ],
        // Hi'nin notu (H-048): ifadeyle ilgili Türkçeye göre açıklama varsa;
        // söylemede tanınan tipik hata (H-055) da not açar.
        if (!o.correct || _speakNoteId != null) ...[
          Builder(
            builder: (context) {
              final hi = ref.watch(hiContentProvider).value;
              final note =
                  hi?.note(_speakNoteId) ?? hi?.noteForPhrase(o.item.textEn);
              if (note == null) return const SizedBox.shrink();
              return Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: const ValueKey('review-why-wrong'),
                  onPressed: () => unawaited(showHiNote(context, note)),
                  style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                  label: const Text(HiTexts.whyWrong),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Card(
          margin: EdgeInsets.zero,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: CardFace(item: o.item, player: _audio),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        FilledButton(
          key: const ValueKey('review-continue'),
          onPressed: _continue,
          style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
          child: const Text(ReviewTexts.continueAction),
        ),
      ],
    );
  }

  // ------------------------------------------------------------ özet

  Widget _summaryView(BuildContext context) {
    final s = _summary!;
    final theme = Theme.of(context);
    final lines = <String>[
      if (s.comeBackTomorrow > 0) ReviewTexts.tomorrow(s.comeBackTomorrow),
      if (s.comeBackLater > 0) ReviewTexts.later(s.comeBackLater),
    ];
    return ListView(
      key: const ValueKey('review-summary'),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const Icon(
          Icons.auto_awesome_rounded,
          size: 56,
          color: AppColors.lighthouseYellow,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          ReviewTexts.doneTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          ReviewTexts.reviewed(s.reviewedCards),
          key: const ValueKey('summary-count'),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        for (final l in lines)
          Text(
            l,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          key: const ValueKey('review-done'),
          onPressed: () => context.pop(),
          style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
          child: const Text(ReviewTexts.done),
        ),
      ],
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.body,
    required this.onBack,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.seaBlue),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(body, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
              child: const Text(CommonTexts.goBack),
            ),
          ],
        ),
      ),
    );
  }
}
