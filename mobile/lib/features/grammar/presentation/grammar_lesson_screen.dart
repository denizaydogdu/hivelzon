import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/meaning/meaning_controller.dart';
import '../../../shared/meaning/meaning_sheet.dart';
import '../../../shared/meaning/notebook_repository.dart';
import '../../../shared/speech/speech_providers.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../hi/application/hi_providers.dart';
import '../../library/application/library_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../speak/speak_env.dart';
import '../../story/application/story_providers.dart';
import '../../story/domain/season_map.dart';
import '../application/grammar_providers.dart';
import '../application/lesson_controller.dart';
import '../data/grammar_progress_store.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_notebook.dart';
import 'widgets/lesson_card_view.dart';

/// Son dersten sonra ne sunulur: "Bölümü başlat" ya da "Kitabı aç".
enum GrammarContinue {
  episode('bolum'),
  book('kitap');

  const GrammarContinue(this.code);

  final String code;

  static GrammarContinue? parse(String? v) =>
      values.where((c) => c.code == v).firstOrNull;
}

/// Dilbilgisi dersi (H-078; tam ekran, `/dilbilgisi/:id`).
///
/// Kart kart ilerler: kanca → anlatım → örnekler → "Türkçede nasıl?" →
/// alıştırma → "Hikâyede gör" → kural. Türkçe anlatım kart açılınca
/// kendiliğinden okunur (sessiz modda okunmaz). [lessonIds] birden çoksa
/// dersler sırayla gelir; son dersten sonra [continueKind] varsa
/// "Bölümü başlat" / "Kitabı aç" sunulur ve sayfa `true` ile kapanır.
class GrammarLessonScreen extends ConsumerStatefulWidget {
  const GrammarLessonScreen({
    super.key,
    required this.lessonIds,
    this.continueKind,
  });

  final List<String> lessonIds;
  final GrammarContinue? continueKind;

  @override
  ConsumerState<GrammarLessonScreen> createState() =>
      _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends ConsumerState<GrammarLessonScreen> {
  int _pos = 0;
  GrammarLesson? _lesson;
  LessonController? _c;
  PageController? _pages;
  Object? _error;
  bool _finished = false;
  bool _silent = false;
  bool _audioNoticeShown = false;
  bool _programmaticPage = false;
  RuleSaveState _rule = RuleSaveState.idle;

  /// Bir sonraki dersin başlığı (bitiş ekranı).
  String? _nextTitle;

  GrammarProgressStore get _store => ref.read(grammarProgressStoreProvider);

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() => _error = null);
    final id = widget.lessonIds[_pos];
    try {
      final source = ref.read(contentSourceProvider);
      final lesson = await source.loadLesson(id);
      final progress = await _store.get(lesson.id);
      final inNotebook = await _ruleInNotebook(lesson);
      if (!mounted) return;
      final start = progress != null && !progress.isCompleted
          ? lesson.indexOfCard(progress.lastCard)
          : 0;
      final c = LessonController(
        lesson: lesson,
        audio: ref.read(grammarAudioFactoryProvider)(),
        speech: ref.read(exampleSpeechProvider),
        mediaUri: (path) => source.grammarMediaUri(lesson.id, path),
        clock: ref.read(grammarClockProvider),
        silent: _silent,
        startCard: start,
        onCard: (card, _) => _saveCard(lesson.id, card.id),
      );
      _c = c;
      _lesson = lesson;
      _pages = PageController(initialPage: c.index);
      _finished = false;
      _rule = inNotebook ? RuleSaveState.exists : RuleSaveState.idle;
      _nextTitle = null;
      c.addListener(_onController);
      setState(() {});
      unawaited(c.start());
      unawaited(_findNextTitle());
    } on Object catch (e) {
      debugPrint('[H078] ders açılamadı: $id ($e)');
      if (mounted) setState(() => _error = e);
    }
  }

  Future<bool> _ruleInNotebook(GrammarLesson lesson) async {
    final item = ruleNotebookItem(lesson);
    if (item == null) return false;
    try {
      return await ref.read(notebookStoreProvider).hasItem(item.key);
    } on Object {
      return false;
    }
  }

  Future<void> _findNextTitle() async {
    if (_pos >= widget.lessonIds.length - 1) return;
    try {
      final lessons = await ref.read(contentSourceProvider).loadGrammarIndex();
      final next = widget.lessonIds[_pos + 1];
      final t = lessons.where((l) => l.id == next).firstOrNull?.titleTr;
      if (mounted) setState(() => _nextTitle = t ?? next);
    } on Object {
      if (mounted) setState(() => _nextTitle = widget.lessonIds[_pos + 1]);
    }
  }

  void _saveCard(String lessonId, String cardId) {
    unawaited(
      _store.markCard(lessonId, cardId).catchError((Object e) {
        debugPrint('[H078] ilerleme yazılamadı: $e');
        return false;
      }),
    );
  }

  void _onController() {
    final c = _c;
    final pages = _pages;
    if (c == null || pages == null || !mounted) return;
    if (pages.hasClients) {
      final shown = pages.page?.round() ?? c.index;
      if (shown != c.index && !_programmaticPage) {
        _programmaticPage = true;
        final done = AppMotion.reduced(context)
            ? Future<void>.sync(() => pages.jumpToPage(c.index))
            : pages.animateToPage(
                c.index,
                duration: AppMotion.base,
                curve: AppMotion.standard,
              );
        unawaited(done.whenComplete(() => _programmaticPage = false));
      }
    }
    if (c.audioFailed && !_audioNoticeShown) {
      _audioNoticeShown = true;
      _snack(GrammarTexts.noAudio);
    }
    setState(() {});
  }

  void _snack(String text) {
    final m = ScaffoldMessenger.maybeOf(context);
    m?.hideCurrentSnackBar();
    m?.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    _c?.removeListener(_onController);
    _c?.dispose();
    _pages?.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------ eylemler

  Future<void> _finish() async {
    final c = _c;
    final lesson = _lesson;
    if (c == null || lesson == null) return;
    await c.stop();
    try {
      await _store.markCompleted(lesson.id, lastCard: c.card.id);
    } on Object catch (e) {
      debugPrint('[H078] bitiş yazılamadı: $e');
    }
    if (!mounted) return;
    setState(() => _finished = true);
  }

  Future<void> _nextLesson() async {
    final old = _c;
    final oldPages = _pages;
    old?.removeListener(_onController);
    setState(() {
      _pos++;
      _c = null;
      _lesson = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      old?.dispose();
      oldPages?.dispose();
    });
    await _load();
  }

  Future<void> _toggleSilent() async {
    final c = _c;
    if (c == null) return;
    _silent = !c.silent;
    await c.setSilent(_silent);
    if (!_silent) unawaited(c.playNarration());
  }

  Future<void> _addRule() async {
    final lesson = _lesson;
    if (lesson == null) return;
    final item = ruleNotebookItem(lesson);
    if (item == null) return;
    setState(() => _rule = RuleSaveState.saving);
    try {
      final added = await ref.read(notebookStoreProvider).addItems([item]);
      if (!mounted) return;
      setState(
        () => _rule = added > 0 ? RuleSaveState.added : RuleSaveState.exists,
      );
      refreshNotebook(ref);
    } on Object catch (e) {
      debugPrint('[H078] kural kartı eklenemedi: $e');
      if (!mounted) return;
      setState(() => _rule = RuleSaveState.idle);
      _snack(GrammarTexts.ruleFailed);
    }
  }

  Future<void> _openMeaning(GrammarExample e, int? word) async {
    final c = _c;
    final lesson = _lesson;
    if (c == null || lesson == null) return;
    await c.stop();
    if (!mounted) return;
    final m = MeaningController(
      text: e.toMeaning(lesson.id),
      audio: c.meaningAudio(e),
      events: ref.read(learningEventLogProvider),
      notebook: ref.read(notebookRepositoryProvider),
      decorate: decorateGrammarSave(lesson, e),
    );
    if (word != null) m.selectWord(word);
    await showMeaningSheet(
      context,
      m,
      speak: ref.read(speechVisibleProvider) ? speakEnvOf(context) : null,
    );
    m.dispose();
    if (!mounted) return;
    await c.stop();
  }

  String _linkSource(GrammarStoryLink l) {
    if (l.kind == StoryLinkKind.episode) {
      final map = ref.read(seasonMapProvider).value;
      final title = map?.episodes
          .where((e) => e.contentId == l.contentId)
          .firstOrNull
          ?.title;
      return GrammarTexts.episodeSource(title ?? l.contentId);
    }
    final books = ref.read(bookListProvider).value;
    final title = books?.where((b) => b.id == l.contentId).firstOrNull?.title;
    final page = int.tryParse(
      RegExp(r'^p(\d+)').firstMatch(l.page ?? '')?.group(1) ?? '',
    );
    return GrammarTexts.bookSource(title ?? l.contentId, page);
  }

  /// "Hikâyede gör": bölüm haritada açıksa bölüm başından (düğümden açma
  /// oynatıcıda yok); kitap ilgili sayfada ve cümlede, sessiz.
  Future<void> _openLink(GrammarStoryLink l) async {
    await _c?.stop();
    if (!mounted) return;
    if (l.kind == StoryLinkKind.book) {
      final page = l.page;
      await context.push(
        page == null
            ? AppRoutes.book(l.contentId)
            : AppRoutes.bookAt(l.contentId, page: page, sentence: l.sentenceId),
      );
      if (mounted) refreshLibrary(ref);
      return;
    }
    final SeasonMap? map = ref.read(seasonMapProvider).value;
    final ep = map?.episodes.where((e) => e.contentId == l.contentId);
    if (ep == null || ep.isEmpty || !ep.first.playable) {
      _snack(GrammarTexts.linkLocked);
      return;
    }
    await openEpisode(context, ref, l.contentId);
  }

  // ------------------------------------------------------------ çizim

  @override
  Widget build(BuildContext context) {
    final c = _c;
    final lesson = _lesson;
    if (_error != null) return _ErrorView(onRetry: _load);
    if (c == null || lesson == null) {
      return const Scaffold(
        body: SafeArea(
          child: ListSkeleton(
            key: ValueKey('skeleton-lesson'),
            label: GrammarTexts.lessonLoading,
            rows: 4,
          ),
        ),
      );
    }
    final speak = ref.watch(speechVisibleProvider) ? speakEnvOf(context) : null;
    // "Hikâyede gör" bağlarının başlıkları ve bölümün açık olup olmadığı.
    if (lesson.cards.any((card) => card.links.isNotEmpty)) {
      ref.watch(seasonMapProvider);
      ref.watch(bookListProvider);
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(
              lesson: lesson,
              controller: c,
              finished: _finished,
              onClose: () => Navigator.of(context).maybePop(),
              onToggleSilent: () => unawaited(_toggleSilent()),
            ),
            Expanded(
              child: _finished
                  ? _DoneView(
                      lesson: lesson,
                      nextTitle: _pos < widget.lessonIds.length - 1
                          ? (_nextTitle ?? widget.lessonIds[_pos + 1])
                          : null,
                      continueKind: widget.continueKind,
                      onNextLesson: () => unawaited(_nextLesson()),
                      onContinue: () => Navigator.of(context).pop(true),
                      onClose: () => Navigator.of(context).maybePop(false),
                    )
                  : PageView.builder(
                      key: const ValueKey('lesson-pages'),
                      controller: _pages,
                      itemCount: lesson.cards.length,
                      onPageChanged: (i) {
                        if (_programmaticPage) return;
                        unawaited(c.goTo(i));
                      },
                      itemBuilder: (context, i) => SingleChildScrollView(
                        key: ValueKey('lesson-scroll-$i'),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpace.page,
                          AppSpace.s8,
                          AppSpace.page,
                          AppSpace.s24,
                        ),
                        child: LessonCardView(
                          lesson: lesson,
                          card: lesson.cards[i],
                          controller: c,
                          onExampleTap: (e, w) => unawaited(_openMeaning(e, w)),
                          onOpenLink: (l) => unawaited(_openLink(l)),
                          linkSource: _linkSource,
                          ruleState: _rule,
                          onAddRule: () => unawaited(_addRule()),
                          speak: speak,
                        ),
                      ),
                    ),
            ),
            if (!_finished)
              _BottomBar(
                controller: c,
                onPrevious: c.isFirst ? null : () => unawaited(c.previous()),
                onNext: c.isLast
                    ? () => unawaited(_finish())
                    : () => unawaited(c.next()),
              ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.lesson,
    required this.controller,
    required this.finished,
    required this.onClose,
    required this.onToggleSilent,
  });

  final GrammarLesson lesson;
  final LessonController controller;
  final bool finished;
  final VoidCallback onClose;
  final VoidCallback onToggleSilent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = controller;
    final n = c.index + 1;
    final total = c.cardCount;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.s4,
        0,
        AppSpace.s4,
        AppSpace.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                key: const ValueKey('lesson-close'),
                onPressed: onClose,
                tooltip: GrammarTexts.close,
                icon: const Icon(Icons.close_rounded),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        lesson.titleTr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    if (!finished)
                      Text(
                        GrammarTexts.cardOf(n, total),
                        key: const ValueKey('lesson-progress'),
                        semanticsLabel: GrammarTexts.cardOfSemantics(n, total),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppPalette.ink500,
                        ),
                      ),
                  ],
                ),
              ),
              if (!finished)
                IconButton(
                  key: const ValueKey('lesson-sound'),
                  onPressed: onToggleSilent,
                  tooltip: c.silent
                      ? GrammarTexts.soundOff
                      : GrammarTexts.soundOn,
                  icon: Icon(
                    c.silent
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                  ),
                ),
            ],
          ),
          if (!finished)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: n / total),
                  duration: AppMotion.of(context, AppMotion.base),
                  builder: (context, v, _) => LinearProgressIndicator(
                    value: v,
                    minHeight: AppSpace.s4 + 2,
                    backgroundColor: AppPalette.sand300,
                    color: AppPalette.lighthouseYellow,
                    semanticsLabel: GrammarTexts.cardOfSemantics(n, total),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.controller,
    required this.onPrevious,
    required this.onNext,
  });

  final LessonController controller;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final last = controller.isLast;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s8,
        AppSpace.page,
        AppSpace.s8,
      ),
      decoration: const BoxDecoration(
        color: AppPalette.sand50,
        border: Border(top: BorderSide(color: AppPalette.sand300)),
      ),
      child: Row(
        children: [
          IconButton.outlined(
            key: const ValueKey('lesson-prev'),
            onPressed: onPrevious,
            tooltip: GrammarTexts.previous,
            style: IconButton.styleFrom(
              minimumSize: const Size(AppTouch.primary, AppTouch.primary),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: AppSpace.s12),
          Expanded(
            child: FilledButton.icon(
              key: ValueKey(last ? 'lesson-finish' : 'lesson-next'),
              onPressed: onNext,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              icon: Icon(
                last ? Icons.check_rounded : Icons.arrow_forward_rounded,
              ),
              label: Text(last ? GrammarTexts.finish : GrammarTexts.next),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dersin sonu: sakin kutlama (K-32: puan, lig, geri sayım yok).
class _DoneView extends StatelessWidget {
  const _DoneView({
    required this.lesson,
    required this.nextTitle,
    required this.continueKind,
    required this.onNextLesson,
    required this.onContinue,
    required this.onClose,
  });

  final GrammarLesson lesson;
  final String? nextTitle;
  final GrammarContinue? continueKind;
  final VoidCallback onNextLesson;
  final VoidCallback onContinue;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = nextTitle != null
        ? FilledButton.icon(
            key: const ValueKey('lesson-next-topic'),
            onPressed: onNextLesson,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.primary),
            ),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(GrammarTexts.nextLesson(nextTitle!)),
          )
        : continueKind != null
        ? FilledButton.icon(
            key: const ValueKey('lesson-continue'),
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.primary),
            ),
            icon: Icon(
              continueKind == GrammarContinue.episode
                  ? Icons.play_arrow_rounded
                  : Icons.menu_book_rounded,
            ),
            label: Text(
              continueKind == GrammarContinue.episode
                  ? GrammarTexts.startEpisode
                  : GrammarTexts.openBookNow,
            ),
          )
        : null;
    return SingleChildScrollView(
      key: const ValueKey('lesson-done'),
      padding: const EdgeInsets.all(AppSpace.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpace.s24),
          const Center(child: CalmCelebration(icon: Icons.school_rounded)),
          const SizedBox(height: AppSpace.s24),
          Semantics(
            header: true,
            child: Text(
              GrammarTexts.doneTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: AppSpace.s8),
          Text(
            GrammarTexts.doneBody(lesson.titleTr),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppPalette.ink700,
            ),
          ),
          const SizedBox(height: AppSpace.s32),
          ?primary,
          if (primary != null) const SizedBox(height: AppSpace.s8),
          OutlinedButton(
            key: const ValueKey('lesson-back'),
            onPressed: onClose,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.min),
            ),
            child: Text(
              continueKind == null
                  ? GrammarTexts.backToList
                  : CommonTexts.close,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        tooltip: GrammarTexts.close,
        icon: const Icon(Icons.close_rounded),
      ),
    ),
    body: Center(
      child: SingleChildScrollView(
        child: EmptyState(
          key: const ValueKey('lesson-error'),
          icon: Icons.cloud_off_rounded,
          title: CommonTexts.serverDownTitle,
          message: '${GrammarTexts.lessonError} ${CommonTexts.serverDownBody}',
          action: FilledButton.icon(
            key: const ValueKey('lesson-retry'),
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text(CommonTexts.retry),
          ),
        ),
      ),
    ),
  );
}

/// Dersleri sırayla açar ([offer]); son dersten sonra kullanıcı "Bölümü
/// başlat" / "Kitabı aç" derse true. Dönünce Dilbilgisi, Hi ve Defter
/// yenilenir.
Future<bool> playGrammarLessons(
  BuildContext context,
  WidgetRef ref,
  List<String> ids, {
  GrammarContinue? then,
}) async {
  if (ids.isEmpty) return false;
  final r = await context.push<bool>(
    AppRoutes.grammarLesson(
      ids.first,
      then: ids.skip(1).toList(),
      cont: then?.code,
    ),
  );
  if (context.mounted) {
    refreshGrammar(ref);
    refreshHi(ref);
    refreshNotebook(ref);
  }
  return r == true;
}
