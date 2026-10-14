import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/fsrs/fsrs.dart';
import '../../../shared/meaning/error_taxonomy.dart';
import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/speech/speak_controller.dart';
import '../../../shared/speech/speak_widgets.dart';
import '../../../shared/speech/speech_match.dart';
import '../../../shared/speech/speech_providers.dart';
import '../../../shared/speech/speech_store.dart';
import '../../../shared/ui/ui.dart';
import '../../speak/speak_env.dart';
import '../../hi/application/hi_providers.dart';
import '../../hi/presentation/hi_cards.dart';
import '../../player/presentation/widgets/hi_avatar.dart';
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
///
/// Tasarım (H-061, taslak S05): üstte ince sarı ilerleme çubuğu; görev kartı
/// (görsel + soru) her görevde yumuşakça belirir; seçenekler beyaz hap
/// düğmeler; geri bildirim sakin bir panelle gelir (doğruda hafif titreşim);
/// özet `StatRow` + sakin kutlama. "Hareketi azalt" açıksa hepsi durağan.
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
    // Doğru cevapta tek, hafif dokunsal onay (H-061). Yanlış ve "Bilmiyorum"
    // titreşimsiz: uyarı gibi hissettirmesin (K-32).
    if (outcome.correct) unawaited(HapticFeedback.lightImpact());
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
    final inSession =
        s != null && (_phase == _Phase.asking || _phase == _Phase.feedback);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('review-close'),
          tooltip: CommonTexts.close,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text(
          s == null || _phase == _Phase.done
              ? ReviewTexts.title
              : ReviewTexts.progress(math.min(s.position, s.total), s.total),
        ),
        bottom: inSession
            ? PreferredSize(
                preferredSize: const Size.fromHeight(AppSpace.s12),
                child: _SessionBar(
                  value: s.total == 0
                      ? 0
                      : (math.min(s.position, s.total) -
                                (_phase == _Phase.asking ? 1 : 0)) /
                            s.total,
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: switch (_phase) {
          _Phase.loading => const Center(child: CircularProgressIndicator()),
          _Phase.empty => _CenteredMessage(
            key: const ValueKey('review-empty'),
            illustration: const Image(
              image: NotebookIllustrations.nothingDue,
              fit: BoxFit.contain,
            ),
            title: ReviewTexts.emptyTitle,
            body: ReviewTexts.emptyBody,
            onBack: () => context.pop(),
          ),
          _Phase.error => _CenteredMessage(
            key: const ValueKey('review-error'),
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

  /// Seçenek düğmesi: beyaz hap, ortalanmış yazı (taslak S05).
  static final ButtonStyle _optionStyle = OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(AppTouch.primary),
    backgroundColor: AppPalette.white,
    foregroundColor: AppPalette.seaBlue,
    side: const BorderSide(color: AppPalette.ink200),
    shape: AppButtonStyles.pill,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpace.s16,
      vertical: AppSpace.s12,
    ),
  );

  Widget _taskView(BuildContext context) {
    final session = _session!;
    final task = session.task!;
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
    final listen =
        task.type == TaskType.listenChoice || task.type == TaskType.speak;
    final showImage = task.type != TaskType.listenChoice;

    // Görev kartı: görsel (dinle-seç dışında) + görev cümlesi + anlam.
    final card = TappableCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showImage)
            NotebookImage(item: item, aspectRatio: 16 / 10, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(AppSpace.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  prompt,
                  key: ValueKey('task-${task.type.code}'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink500,
                  ),
                ),
                if (task.type != TaskType.listenChoice &&
                    item.textTr != null) ...[
                  const SizedBox(height: AppSpace.s4),
                  Text(
                    item.textTr!,
                    key: const ValueKey('task-meaning'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppPalette.seaBlue,
                    ),
                  ),
                ],
                if (task.type == TaskType.speak) ...[
                  const SizedBox(height: AppSpace.s8),
                  Text(
                    SpeakTexts.reviewHint,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppPalette.ink500,
                    ),
                  ),
                ],
                if (listen) ...[
                  const SizedBox(height: AppSpace.s16),
                  Center(
                    child: ListenableBuilder(
                      listenable: _audio,
                      builder: (context, _) => FilledButton.icon(
                        key: const ValueKey('task-listen'),
                        onPressed: () => _audio.play(item),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(160, AppSpace.s64),
                        ),
                        icon: Icon(
                          _audio.playingKey == CardAudioPlayer.keyFor(item)
                              ? Icons.graphic_eq_rounded
                              : Icons.volume_up_rounded,
                          size: AppIconSize.lg,
                        ),
                        label: const Text(ReviewTexts.listen),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    final children = <Widget>[
      // Her görevde yeni anahtar: kart yumuşakça belirir (azaltılmışsa yok).
      KeyedSubtree(
        key: ValueKey('task-card-${session.position}'),
        child: FadeSlideIn(child: card),
      ),
      const SizedBox(height: AppSpace.s16),
    ];
    switch (task.type) {
      case TaskType.pictureChoice || TaskType.listenChoice:
        for (final (i, o) in task.options.indexed) {
          children.add(
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.s8),
              child: PressScale(
                child: OutlinedButton(
                  key: ValueKey('option-$i'),
                  onPressed: () {
                    _chosen = i;
                    _answer(correct: task.isCorrectChoice(i));
                  },
                  style: _optionStyle,
                  child: Text(
                    o,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppPalette.seaBlue,
                    ),
                  ),
                ),
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
            decoration: const InputDecoration(hintText: ReviewTexts.typeHint),
          ),
          const SizedBox(height: AppSpace.s16),
          FilledButton(
            key: const ValueKey('task-check'),
            onPressed: () => _checkTyped(task),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.primary),
            ),
            child: const Text(ReviewTexts.check),
          ),
        ]);
      case TaskType.speak:
        final c = _speak;
        children.add(
          SpeakPractice(
            key: ValueKey('speak-${item.key}-${session.position}'),
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
              padding: const EdgeInsets.only(top: AppSpace.s8),
              child: FilledButton(
                key: const ValueKey('review-speak-accept'),
                onPressed: () => unawaited(
                  _answerSpeech(SpeechMatchLevel.close, c.attempts),
                ),
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
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              child: const Text(ReviewTexts.openCard),
            ),
          );
        } else {
          children.addAll([
            FadeSlideIn(
              child: Text(
                item.textEn,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppPalette.ink,
                ),
              ),
            ),
            const SizedBox(height: AppSpace.s16),
            FilledButton(
              key: const ValueKey('task-knew'),
              onPressed: () => _answer(correct: true),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              child: const Text(ReviewTexts.knewIt),
            ),
          ]);
        }
    }
    children.addAll([
      const SizedBox(height: AppSpace.s8),
      // İkincil ama açıkça düğme (utandırmaz): ortak "Bilmiyorum" biçimi.
      DontKnowButton(
        key: const ValueKey('task-dont-know'),
        label: ReviewTexts.dontKnow,
        expand: true,
        onPressed: () => _answer(correct: false, dontKnow: true),
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
    return _ScrollColumn(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s8,
        AppSpace.page,
        AppSpace.s24,
      ),
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
    );
    return [
      Container(
        constraints: const BoxConstraints(minHeight: AppSpace.s64),
        padding: const EdgeInsets.all(AppSpace.s8),
        decoration: BoxDecoration(
          color: AppPalette.sand50,
          border: Border.all(color: AppPalette.seaBlue300),
          borderRadius: AppRadius.mdAll,
        ),
        child: Wrap(
          spacing: AppSpace.s8,
          runSpacing: AppSpace.s8,
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
      const SizedBox(height: AppSpace.s16),
      Wrap(
        spacing: AppSpace.s8,
        runSpacing: AppSpace.s8,
        children: [
          for (final (i, t) in remaining.indexed)
            chip(
              t,
              () => setState(() => _picked.add(t)),
              key: ValueKey('token-$i-$t'),
            ),
        ],
      ),
      const SizedBox(height: AppSpace.s16),
      FilledButton(
        key: const ValueKey('task-check'),
        onPressed: remaining.isEmpty
            ? () => _answer(correct: task.isCorrectOrder(_picked))
            : null,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.primary),
        ),
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
    return _ScrollColumn(
      key: const ValueKey('review-feedback'),
      padding: const EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s8,
        AppSpace.page,
        AppSpace.s24,
      ),
      children: [
        // Sakin geri bildirim paneli: doğruda yeşil onay, değilse deniz mavisi
        // zeminde ampul (kırmızı ve çarpı yok).
        FadeSlideIn(
          child: Container(
            key: ValueKey(
              o.correct ? 'feedback-panel-correct' : 'feedback-panel-calm',
            ),
            padding: const EdgeInsets.all(AppSpace.s16),
            decoration: BoxDecoration(
              color: o.correct
                  ? AppPalette.successSurface
                  : AppPalette.seaBlue50,
              borderRadius: AppRadius.mdAll,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: CalmPop(
                    child: Icon(
                      o.correct
                          ? Icons.check_circle_rounded
                          : Icons.lightbulb_rounded,
                      color: o.correct
                          ? AppPalette.success
                          : AppPalette.orange700,
                      size: AppIconSize.lg,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpace.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          title,
                          key: const ValueKey('feedback-title'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: o.correct
                                ? AppPalette.success
                                : AppPalette.ink,
                          ),
                        ),
                      ),
                      if (!o.correct &&
                          !o.dontKnow &&
                          chosen != null &&
                          task != null &&
                          chosen < task.options.length) ...[
                        const SizedBox(height: AppSpace.s4),
                        Text(
                          ReviewTexts.chosen(task.options[chosen]),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppPalette.ink700,
                          ),
                        ),
                      ],
                      if (body != null) ...[
                        const SizedBox(height: AppSpace.s4),
                        Text(
                          body,
                          key: const ValueKey('feedback-body'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppPalette.ink700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                  label: const Text(HiTexts.whyWrong),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: AppSpace.s16),
        FadeSlideIn(
          index: 1,
          child: TappableCard(
            child: CardFace(item: o.item, player: _audio),
          ),
        ),
        const SizedBox(height: AppSpace.s16),
        FilledButton(
          key: const ValueKey('review-continue'),
          onPressed: _continue,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTouch.primary),
          ),
          child: const Text(ReviewTexts.continueAction),
        ),
      ],
    );
  }

  // ------------------------------------------------------------ özet

  Widget _summaryView(BuildContext context) {
    final s = _summary!;
    final theme = Theme.of(context);
    // Sıfır olan sayı gösterilmez (ör. "0 ilk seferde bildin" yok).
    final tiles = <StatTile>[
      if (s.firstTryCorrect > 0)
        StatTile.count(
          key: const ValueKey('summary-first-try'),
          count: s.firstTryCorrect,
          label: ReviewTexts.statFirstTry,
          icon: Icons.check_circle_outline_rounded,
          color: AppPalette.success,
        ),
      if (s.comeBackTomorrow > 0)
        StatTile.count(
          key: const ValueKey('summary-tomorrow'),
          count: s.comeBackTomorrow,
          label: ReviewTexts.statTomorrow,
          icon: Icons.wb_sunny_outlined,
          color: AppPalette.orange700,
        ),
      if (s.comeBackLater > 0)
        StatTile.count(
          key: const ValueKey('summary-later'),
          count: s.comeBackLater,
          label: ReviewTexts.statLater,
          icon: Icons.event_outlined,
        ),
    ];
    return _ScrollColumn(
      key: const ValueKey('review-summary'),
      padding: const EdgeInsets.all(AppSpace.s24),
      children: [
        // H-063: tekrar bitti, Hi mutlu.
        const Center(
          child: CalmCelebration(
            child: HiAvatar(
              key: ValueKey('review-summary-hi'),
              size: 90,
              expression: HiExpression.happy,
              pulseCycles: 1,
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s24),
        Semantics(
          header: true,
          child: Text(
            ReviewTexts.doneTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppPalette.seaBlue,
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s8),
        Text(
          ReviewTexts.reviewed(s.reviewedCards),
          key: const ValueKey('summary-count'),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(color: AppPalette.ink700),
        ),
        if (tiles.isNotEmpty) ...[
          const SizedBox(height: AppSpace.s24),
          FadeSlideIn(
            index: 1,
            child: StatRow(
              key: const ValueKey('review-summary-stats'),
              tiles: tiles,
            ),
          ),
        ],
        const SizedBox(height: AppSpace.s32),
        FilledButton(
          key: const ValueKey('review-done'),
          onPressed: () => context.pop(),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTouch.primary),
          ),
          child: const Text(ReviewTexts.done),
        ),
      ],
    );
  }
}

/// Oturumun ince sarı ilerleme çubuğu (taslak S05). Başlıktaki "3 / 8"
/// ekran okuyucuya yeter; çubuk görsel tekrardır.
class _SessionBar extends StatelessWidget {
  const _SessionBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.page,
        0,
        AppSpace.page,
        AppSpace.s8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0.0, 1.0)),
          duration: AppMotion.of(context, AppMotion.slow),
          curve: AppMotion.enter,
          builder: (context, v, _) => LinearProgressIndicator(
            key: const ValueKey('review-progress-bar'),
            value: v,
            minHeight: AppSpace.s4,
            color: AppPalette.lighthouseYellow,
            backgroundColor: AppPalette.sand200,
          ),
        ),
      ),
    ),
  );
}

/// Kaydırılabilir sütun: görev, geri bildirim ve özet. Bütün öğeler hemen
/// kurulur (tembel `ListView` alttaki düğmeyi kurmayabiliyordu).
class _ScrollColumn extends StatelessWidget {
  const _ScrollColumn({
    super.key,
    required this.padding,
    required this.children,
  });

  final EdgeInsetsGeometry padding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    super.key,
    required this.title,
    required this.body,
    required this.onBack,
    this.icon,
    this.illustration,
  });

  final IconData? icon;
  final Widget? illustration;
  final String title;
  final String body;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      child: EmptyState(
        icon: icon,
        illustration: illustration,
        title: title,
        message: body,
        action: OutlinedButton(
          onPressed: onBack,
          child: const Text(CommonTexts.goBack),
        ),
      ),
    ),
  );
}
