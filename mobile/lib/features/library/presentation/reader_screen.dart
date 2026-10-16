import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/activity/study_clock.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/meaning/meaning_controller.dart';
import '../../../shared/meaning/meaning_sheet.dart';
import '../../../shared/meaning/notebook_repository.dart';
import '../../../shared/speech/speech_providers.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../grammar/application/grammar_providers.dart';
import '../../grammar/presentation/grammar_lesson_screen.dart';
import '../../speak/speak_env.dart';
import '../application/library_providers.dart';
import '../application/reader_controller.dart';
import '../data/book_progress_store.dart';
import '../domain/book.dart';
import '../domain/book_notebook.dart';
import '../domain/book_progress.dart';
import 'widgets/book_page_view.dart';
import 'widgets/comprehension_view.dart';
import 'widgets/end_of_book_view.dart';
import 'widgets/page_turkish_sheet.dart';

/// Kitap okuyucu (H-067; tam ekran, `/kitap/:bookId`).
///
/// Kitap ve kalınan yer yüklenince [ReaderController] kurulur; sesli açıldıysa
/// kalınan cümleden okumaya başlar. Yarıda kalan kitap kaldığı cümleden açılır;
/// biten kitap baştan açılır (durumu "bitti" kalır).
class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({
    super.key,
    required this.bookId,
    this.listen = true,
    this.startPage,
    this.startSentence,
  });

  final String bookId;

  /// Bu sayfada (`p03`) ve cümlede (`p03-s02`) açılır (H-078: dilbilgisi
  /// dersinde "Hikâyede gör"); verilmezse kalınan yerden.
  final String? startPage;
  final String? startSentence;

  /// Sesli açılsın mı (kitabın sesi yoksa sessiz açılır).
  final bool listen;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen>
    with WidgetsBindingObserver {
  ReaderController? _c;
  Book? _book;
  BookColors? _colors;
  Object? _error;
  int _textSize = 1;
  PageController? _pages;
  bool _programmaticPage = false;
  bool _showEnd = false;

  /// Kitap sonu anlama (H-091) bitti ya da atlandı: kitap sonu görünür.
  bool _comprehensionDone = false;
  bool _audioNoticeShown = false;

  /// Satır altı Türkçe (okuma ayarı, H-086).
  bool _interlinear = false;

  /// Sessiz modda Türkçe panelinden seçilen cümle (sayfa çevrilince söner).
  ReaderPlace? _focus;

  /// Seçilen cümleyi görünür kılma isteği (her artışta bir kez).
  ReaderPlace? _reveal;
  int _revealRequest = 0;

  /// Okunan yeri izleme (sesli mod): kullanıcı kaydırınca durur, kaydırma
  /// bittikten [followResumeAfter] sonra ya da Dinle / sayfa düğmesi /
  /// cümleye dokunma / "Okunan yere dön" ile sürer.
  bool _followPaused = false;
  int _followRequest = 0;
  Timer? _followTimer;

  static const followResumeAfter = Duration(seconds: 4);

  /// Kitap sonunda önerilecek, aynı seviyede açılmamış kitap (yoksa null).
  String? _nextBookId;

  BookProgressStore get _store => ref.read(bookProgressStoreProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load());
  }

  /// H-068: ses arka planda (ekran kilitliyken) sürer; öne dönünce vurgu
  /// ve sayfa çaların konumuyla yeniden eşlenir.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_c?.resync());
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final book = await ref
          .read(contentSourceProvider)
          .loadBook(widget.bookId);
      final store = _store;
      final progress = await store.get(book.id);
      final size = await store.textSize();
      final word = await store.wordHighlight();
      final interlinear = await store.interlinear();
      if (!mounted) return;
      ReaderPlace? start;
      final p = progress;
      if (p != null && !p.isCompleted && p.pageNumber != null) {
        final pi = book.pages.indexWhere((x) => x.number == p.pageNumber);
        if (pi >= 0) start = ReaderPlace(pi, p.sentenceIndex ?? 0);
      }
      final linkPage = widget.startPage == null
          ? -1
          : book.pages.indexWhere((x) => x.id == widget.startPage);
      if (linkPage >= 0) {
        final si = book.pages[linkPage].sentences.indexWhere(
          (x) => x.id == widget.startSentence,
        );
        start = ReaderPlace(linkPage, si < 0 ? 0 : si);
      }
      final source = ref.read(contentSourceProvider);
      final c = ReaderController(
        book: book,
        audio: ref.read(bookAudioFactoryProvider)(),
        mediaUri: (path) => source.bookMediaUri(book.id, path),
        clock: ref.read(readerClockProvider),
        mode: widget.listen ? ReaderMode.listen : ReaderMode.silent,
        start: start,
        wordHighlight: word,
        onPlace: _savePlace,
        onFinished: _finished,
      );
      _c = c;
      _book = book;
      _textSize = size;
      _interlinear = interlinear;
      _colors = BookColors.fromPalette(
        background: book.palette.background,
        text: book.palette.text,
        accent: book.palette.accent,
        surface: book.palette.surface,
        highlight: book.palette.highlight,
      );
      _pages = PageController(initialPage: c.pageIndex);
      c.addListener(_onController);
      setState(() {});
      // İlk açılış "okunuyor" olarak kaydedilir (raf ve Hi önerisi için).
      if (p == null || p.status == BookStatus.notStarted) {
        _savePlace(
          book.chapterOf(book.pages[c.pageIndex]),
          c.place,
          book.sentenceAt(c.pageIndex, c.place.sentenceIndex).start,
        );
      }
      if (c.chapterAudioMissing) {
        c.clearChapterAudioNotice();
        _snack(ReaderTexts.chapterNoAudio);
      }
      if (c.mode == ReaderMode.listen) unawaited(c.play());
    } on Object catch (e) {
      debugPrint('[H067] kitap açılamadı: ${widget.bookId} ($e)');
      if (mounted) setState(() => _error = e);
    }
  }

  void _savePlace(BookChapter chapter, ReaderPlace place, double? sec) {
    final book = _book ?? _c?.book;
    if (book == null) return;
    unawaited(
      _store
          .savePosition(
            book.id,
            chapterId: chapter.id,
            pageNumber: book.pages[place.pageIndex].number,
            sentenceIndex: place.sentenceIndex,
            positionSec: sec,
          )
          .catchError((Object e) {
            debugPrint('[H067] ilerleme yazılamadı: $e');
            return false;
          }),
    );
  }

  void _finished() {
    final book = _book;
    if (book == null) return;
    unawaited(
      _store.markCompleted(book.id).catchError((Object e) {
        debugPrint('[H067] bitiş yazılamadı: $e');
      }),
    );
    if (mounted) {
      ref.invalidate(bookSavedItemsProvider(book.id));
      setState(() => _showEnd = true);
      unawaited(_findNextBook(book));
    }
  }

  /// Anlama bitti (H-091): yalnız sayılar ve öz değerlendirme yazılır.
  void _comprehensionFinished(ComprehensionOutcome o) {
    final book = _book;
    if (book == null) return;
    unawaited(
      ref
          .read(bookComprehensionStoreProvider)
          .save(
            bookId: book.id,
            contentVersion: book.contentVersion,
            answered: o.answered,
            firstTryCorrect: o.firstTryCorrect,
            retellDone: o.retellDone,
            selfCheck: o.selfCheck,
          )
          .catchError((Object e) {
            debugPrint('[H091] anlama sonucu yazılamadı: $e');
          }),
    );
    if (mounted) setState(() => _comprehensionDone = true);
  }

  void _onController() {
    final c = _c;
    final pages = _pages;
    if (c == null || pages == null || !mounted) return;
    // Sesli okuma öğrenme etkinliğidir (H-074: günlük süre).
    if (c.isPlaying) ref.read(studyClockProvider).signal();
    if (pages.hasClients) {
      final shown = pages.page?.round() ?? c.pageIndex;
      if (shown != c.pageIndex && !_programmaticPage) {
        _programmaticPage = true;
        final done = AppMotion.reduced(context)
            ? Future<void>.sync(() => pages.jumpToPage(c.pageIndex))
            : pages.animateToPage(
                c.pageIndex,
                duration: AppMotion.slow,
                curve: AppMotion.standard,
              );
        unawaited(done.whenComplete(() => _programmaticPage = false));
      }
    }
    if (c.sleepFired) {
      c.clearSleepNotice();
      _snack(ReaderTexts.sleepFired);
    }
    if (c.audioFailed && !_audioNoticeShown) {
      _audioNoticeShown = true;
      _snack(ReaderTexts.noAudio);
    }
    if (c.chapterAudioMissing) {
      c.clearChapterAudioNotice();
      _snack(ReaderTexts.chapterNoAudio);
    }
    final f = _focus;
    if (f != null &&
        (c.pageIndex != f.pageIndex || c.mode == ReaderMode.listen)) {
      _focus = null;
    }
    setState(() {});
  }

  // ------------------------------------------------------------ izleme

  void _onUserScroll() {
    _followTimer?.cancel();
    if (!_followPaused) setState(() => _followPaused = true);
  }

  void _onUserScrollEnd() {
    _followTimer?.cancel();
    _followTimer = Timer(followResumeAfter, _resumeFollow);
  }

  /// İzleme sürer; okunan cümle görünür kılınır.
  void _resumeFollow() {
    _followTimer?.cancel();
    _followTimer = null;
    if (!mounted) return;
    setState(() {
      _followPaused = false;
      _followRequest++;
    });
  }

  void _snack(String text) {
    final m = ScaffoldMessenger.maybeOf(context);
    m?.hideCurrentSnackBar();
    m?.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _followTimer?.cancel();
    _c?.removeListener(_onController);
    _c?.dispose();
    _pages?.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------ eylemler

  Future<void> _openMeaning(ReaderPlace place, int? wordIndex) async {
    final c = _c;
    final book = _book;
    if (c == null || book == null) return;
    if (_followPaused) _resumeFollow();
    final wasPlaying = await c.pauseForSheet();
    if (!mounted) return;
    final s = book.sentenceAt(place.pageIndex, place.sentenceIndex);
    final m = MeaningController(
      text: s.toMeaning(book.id),
      audio: c.meaningAudio(place),
      events: ref.read(learningEventLogProvider),
      notebook: ref.read(notebookRepositoryProvider),
      speed: c.speed < 1 ? 0.75 : 1.0,
      decorate: (draft, {wordIndex, chunk}) => decorateBookSave(
        book,
        place.pageIndex,
        place.sentenceIndex,
        draft,
        wordIndex: wordIndex,
        chunk: chunk,
      ),
    );
    if (wordIndex != null) m.selectWord(wordIndex);
    final topic = await showMeaningSheet(
      context,
      m,
      speak: ref.read(speechVisibleProvider) ? speakEnvOf(context) : null,
      structures: meaningStructures(ref, book.grammarTopics),
    );
    m.dispose();
    if (!mounted) return;
    if (topic != null) {
      // "Bu yapı ne?" (H-078): ders açılır; dönünce okuma duraklı kalır.
      await c.resumeAfterSheet(false);
      if (!mounted) return;
      await playGrammarLessons(context, ref, [topic]);
      return;
    }
    await c.resumeAfterSheet(wasPlaying);
  }

  /// "Sayfanın Türkçesi" (H-086): ekrandaki sayfanın Türkçesi alttan
  /// panelde. Ses panel açıkken durur, kapanınca kaldığı yerden sürer.
  /// Paneldeki cümleye dokununca panel kapanır, İngilizcesi vurgulanır ve
  /// görünür kılınır (sesli modda okuma o cümleden sürer).
  Future<void> _openPageTurkish() async {
    final c = _c;
    final book = _book;
    if (c == null || book == null) return;
    final pageIndex = c.pageIndex;
    if (book.turkishOf(pageIndex).isEmpty) return;
    if (_followPaused) _resumeFollow();
    final wasPlaying = await c.pauseForSheet();
    if (!mounted) return;
    final picked = await showPageTurkishSheet(
      context,
      book: book,
      pageIndex: pageIndex,
      current: c.highlighted ?? _focus,
    );
    if (!mounted) return;
    if (picked == null || c.pageIndex != pageIndex) {
      await c.resumeAfterSheet(wasPlaying);
      return;
    }
    final place = ReaderPlace(pageIndex, picked);
    await c.resumeAfterSheetAt(place, wasPlaying);
    if (!mounted) return;
    setState(() {
      _focus = c.mode == ReaderMode.listen ? null : place;
      _reveal = place;
      _revealRequest++;
    });
  }

  /// Uzun basma: sesli modda kelimeyi tek dokunuşla Defter'e ekler (ses
  /// durmaz); sessiz modda yalnız o cümleyi seslendirir.
  Future<void> _longPress(ReaderPlace place, int? wordIndex) async {
    final c = _c;
    final book = _book;
    if (c == null || book == null) return;
    if (c.mode == ReaderMode.silent || wordIndex == null) {
      await c.playSentenceOnly(place);
      return;
    }
    final item = bookWordSave(
      book,
      place.pageIndex,
      place.sentenceIndex,
      wordIndex,
      now: DateTime.now(),
    );
    try {
      final added = await ref.read(notebookRepositoryProvider).add(item);
      if (!mounted) return;
      _snack(
        added ? ReaderTexts.quickAdded : ReaderTexts.alreadySaved(item.en),
      );
      if (added) ref.invalidate(bookSavedItemsProvider(book.id));
    } on Object catch (e) {
      debugPrint('[H067] deftere eklenemedi: $e');
      if (mounted) _snack(ReaderTexts.saveFailed);
    }
  }

  Future<void> _chapters() async {
    final c = _c;
    final book = _book;
    if (c == null || book == null) return;
    final picked = await showAppSheet<int>(
      context: context,
      title: ReaderTexts.chapters,
      builder: (context) => ListView(
        key: const ValueKey('reader-chapters'),
        shrinkWrap: true,
        children: [
          for (final (i, ch) in book.chapters.indexed)
            ListTile(
              key: ValueKey('chapter-${ch.id}'),
              selected: book.chapterIndexOf(c.chapter.id) == i,
              title: Text(ReaderTexts.chapterRow(i + 1, ch.title)),
              subtitle: ch.titleTr == null ? null : Text(ch.titleTr!),
              trailing: ch.pageIds.isEmpty
                  ? null
                  : Text(
                      ReaderTexts.chapterPage(
                        book.pages[book.pageIndexOf(ch.pageIds.first)].number,
                      ),
                    ),
              onTap: () => Navigator.of(context).pop(i),
            ),
        ],
      ),
    );
    if (picked != null) await c.goToChapter(picked);
  }

  Future<void> _settings() async {
    final c = _c;
    if (c == null) return;
    await showAppSheet<void>(
      context: context,
      title: ReaderTexts.settings,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) => SingleChildScrollView(
          key: const ValueKey('reader-settings'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ReaderTexts.textSize,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpace.s8),
              SegmentedButton<int>(
                key: const ValueKey('reader-text-size'),
                showSelectedIcon: false,
                segments: [
                  for (final (i, l) in ReaderTexts.textSizes.indexed)
                    ButtonSegment(
                      value: i,
                      label: Text(
                        l,
                        key: ValueKey('text-size-$i'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                selected: {_textSize},
                onSelectionChanged: (s) {
                  setState(() => _textSize = s.first);
                  setSheet(() {});
                  unawaited(_store.setTextSize(s.first));
                },
              ),
              const SizedBox(height: AppSpace.s16),
              SwitchListTile(
                key: const ValueKey('reader-interlinear'),
                contentPadding: EdgeInsets.zero,
                title: const Text(ReaderTexts.interlinear),
                subtitle: const Text(ReaderTexts.interlinearHint),
                value: _interlinear,
                onChanged: (v) {
                  setState(() => _interlinear = v);
                  setSheet(() {});
                  unawaited(_store.setInterlinear(v));
                },
              ),
              SwitchListTile(
                key: const ValueKey('reader-word-highlight'),
                contentPadding: EdgeInsets.zero,
                title: const Text(ReaderTexts.wordHighlight),
                subtitle: const Text(ReaderTexts.wordHighlightHint),
                value: c.wordHighlight,
                onChanged: (v) {
                  c.setWordHighlight(v);
                  setSheet(() {});
                  unawaited(_store.setWordHighlight(v));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sleep() async {
    final c = _c;
    if (c == null) return;
    String label(SleepOption o) => switch (o) {
      SleepOption.off => ReaderTexts.sleepOff,
      SleepOption.endOfChapter => ReaderTexts.sleepChapter,
      _ => ReaderTexts.sleepMinutes(o.minutes!),
    };
    final picked = await showAppSheet<SleepOption>(
      context: context,
      title: ReaderTexts.sleep,
      builder: (context) => ListView(
        key: const ValueKey('reader-sleep'),
        shrinkWrap: true,
        children: [
          for (final o in SleepOption.values)
            ListTile(
              key: ValueKey('sleep-${o.name}'),
              title: Text(label(o)),
              trailing: c.sleep == o
                  ? const Icon(Icons.check_rounded, color: AppPalette.seaBlue)
                  : null,
              selected: c.sleep == o,
              onTap: () => Navigator.of(context).pop(o),
            ),
        ],
      ),
    );
    if (picked == null) return;
    c.setSleep(picked);
    if (picked != SleepOption.off) _snack(ReaderTexts.sleepOn(label(picked)));
  }

  Future<void> _findNextBook(Book book) async {
    try {
      final books = await ref.read(contentSourceProvider).listBooks();
      final progress = await _store.all();
      final next = pickUnreadBook(
        books.where((b) => b.id != book.id).toList(),
        progress,
        book.level,
        ref.read(libraryRandomProvider),
        preferAudio: true,
      );
      if (mounted) setState(() => _nextBookId = next?.id);
    } on Object catch (e) {
      debugPrint('[H067] sıradaki kitap bulunamadı: $e');
    }
  }

  void _openNextBook() {
    final id = _nextBookId;
    if (id == null) return;
    context.pushReplacement(AppRoutes.book(id, listen: true));
  }

  // ------------------------------------------------------------ çizim

  @override
  Widget build(BuildContext context) {
    // "Bu yapı ne?" için ders listesi hazır olsun (H-078).
    if (_book?.grammarTopics.isNotEmpty ?? false) {
      ref.watch(grammarLessonsOrEmptyProvider);
    }
    final c = _c;
    final book = _book;
    final colors = _colors;
    if (_error != null) return _ErrorView(onRetry: _load);
    if (c == null || book == null || colors == null) {
      return const Scaffold(
        body: SafeArea(
          child: ListSkeleton(
            key: ValueKey('skeleton-reader'),
            label: ReaderTexts.loading,
            rows: 5,
          ),
        ),
      );
    }
    final page = book.pages[c.pageIndex];
    final hasTurkish = book.turkishOf(c.pageIndex).isNotEmpty;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(
              book: book,
              colors: colors,
              chapterIndex: book.chapterIndexOf(page.chapterId),
              onClose: () => Navigator.of(context).maybePop(),
              onChapters: _showEnd ? null : _chapters,
              onSettings: _showEnd ? null : _settings,
              onPageTurkish: _showEnd || !hasTurkish ? null : _openPageTurkish,
            ),
            Expanded(
              child:
                  _showEnd && !_comprehensionDone && book.comprehension != null
                  ? ComprehensionView(
                      book: book,
                      comprehension: book.comprehension!,
                      colors: colors,
                      onSkip: () => setState(() => _comprehensionDone = true),
                      onFinish: _comprehensionFinished,
                    )
                  : _showEnd
                  ? EndOfBookView(
                      book: book,
                      colors: colors,
                      onBack: () => Navigator.of(context).maybePop(),
                      onReadAgain: () async {
                        await c.restart();
                        if (!mounted) return;
                        final old = _pages;
                        setState(() {
                          _pages = PageController();
                          _showEnd = false;
                          _comprehensionDone = false;
                        });
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => old?.dispose(),
                        );
                      },
                      onNextBook: _nextBookId == null ? null : _openNextBook,
                    )
                  : PageView.builder(
                      key: const ValueKey('reader-pages'),
                      controller: _pages,
                      itemCount: book.pages.length,
                      onPageChanged: (i) {
                        if (_focus != null && _focus!.pageIndex != i) {
                          setState(() => _focus = null);
                        }
                        if (_programmaticPage) return;
                        unawaited(c.goToPage(i));
                      },
                      itemBuilder: (context, i) => BookPageView(
                        book: book,
                        pageIndex: i,
                        colors: colors,
                        textSize: _textSize,
                        highlighted: c.highlighted?.pageIndex == i
                            ? c.highlighted
                            : c.highlighted == null && _focus?.pageIndex == i
                            ? _focus
                            : null,
                        highlightedWord: c.highlightedWord,
                        onWordTap: _openMeaning,
                        onWordLongPress: _longPress,
                        follow: c.mode == ReaderMode.listen && !_followPaused,
                        followWord: c.spokenWord,
                        followRequest: _followRequest,
                        onUserScroll: _onUserScroll,
                        onUserScrollEnd: _onUserScrollEnd,
                        interlinear: _interlinear,
                        reveal: _reveal,
                        revealRequest: _revealRequest,
                        onPageTurkish: book.turkishOf(i).isNotEmpty
                            ? _openPageTurkish
                            : null,
                      ),
                    ),
            ),
            if (!_showEnd && _followPaused && c.mode == ReaderMode.listen)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.s8),
                child: Center(
                  child: ActionChip(
                    key: const ValueKey('reader-follow-back'),
                    avatar: const Icon(Icons.my_location_rounded, size: 18),
                    label: const Text(ReaderTexts.followBack),
                    onPressed: _resumeFollow,
                  ),
                ),
              ),
            if (!_showEnd)
              _Controls(
                controller: c,
                colors: colors,
                onSleep: _sleep,
                onTogglePlay: () {
                  if (_followPaused) _resumeFollow();
                  unawaited(c.togglePlay());
                },
                onPrev: c.pageIndex > 0 ? () => _turn(c.pageIndex - 1) : null,
                onNext: c.pageIndex < book.pages.length - 1
                    ? () => _turn(c.pageIndex + 1)
                    : null,
                onFinish: c.pageIndex == book.pages.length - 1
                    ? c.finish
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  /// Düğmeyle sayfa çevirme (kaydırmayla aynı hareket).
  void _turn(int i) {
    if (_followPaused) _resumeFollow();
    final pages = _pages;
    if (pages == null || !pages.hasClients) return;
    if (AppMotion.reduced(context)) {
      pages.jumpToPage(i);
    } else {
      unawaited(
        pages.animateToPage(
          i,
          duration: AppMotion.slow,
          curve: AppMotion.standard,
        ),
      );
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.book,
    required this.colors,
    required this.chapterIndex,
    required this.onClose,
    required this.onChapters,
    required this.onSettings,
    required this.onPageTurkish,
  });

  final Book book;
  final BookColors colors;
  final int chapterIndex;
  final VoidCallback onClose;
  final VoidCallback? onChapters;
  final VoidCallback? onSettings;

  /// Null ise (sayfanın Türkçesi yok) düğme gizli.
  final VoidCallback? onPageTurkish;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chapter = book.chapters[chapterIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      child: Row(
        children: [
          IconButton(
            key: const ValueKey('reader-close'),
            onPressed: onClose,
            tooltip: ReaderTexts.close,
            color: colors.text,
            icon: const Icon(Icons.close_rounded),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.text,
                  ),
                ),
                Text(
                  '${ReaderTexts.chapterLabel(chapterIndex + 1)} · ${chapter.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.text,
                  ),
                ),
              ],
            ),
          ),
          if (onPageTurkish != null)
            IconButton(
              key: const ValueKey('reader-page-turkish'),
              onPressed: onPageTurkish,
              tooltip: ReaderTexts.pageTurkish,
              color: colors.text,
              icon: const Icon(Icons.translate_rounded),
            ),
          IconButton(
            key: const ValueKey('reader-chapters-button'),
            onPressed: onChapters,
            tooltip: ReaderTexts.chapters,
            color: colors.text,
            icon: const Icon(Icons.toc_rounded),
          ),
          IconButton(
            key: const ValueKey('reader-settings-button'),
            onPressed: onSettings,
            tooltip: ReaderTexts.settings,
            color: colors.text,
            icon: const Icon(Icons.text_fields_rounded),
          ),
        ],
      ),
    );
  }
}

/// Alt denetimler: biçim (Sesli · Sessiz), sayfa ve ses ya da sayfa düğmeleri.
class _Controls extends StatelessWidget {
  const _Controls({
    required this.controller,
    required this.colors,
    required this.onSleep,
    required this.onTogglePlay,
    required this.onPrev,
    required this.onNext,
    required this.onFinish,
  });

  final ReaderController controller;
  final BookColors colors;
  final VoidCallback onSleep;
  final VoidCallback onTogglePlay;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = controller;
    final book = c.book;
    final page = book.pages[c.pageIndex];
    final listen = c.mode == ReaderMode.listen;
    final pageLabel = Semantics(
      label: ReaderTexts.pageSemantics(page.number, book.pageCount),
      excludeSemantics: true,
      child: Text(
        ReaderTexts.pageOf(page.number, book.pageCount),
        key: const ValueKey('reader-page-label'),
        style: theme.textTheme.labelLarge?.copyWith(color: AppPalette.ink700),
      ),
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.s12,
        AppSpace.s8,
        AppSpace.s12,
        AppSpace.s8,
      ),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.sheetTop,
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpace.s8,
            runSpacing: AppSpace.s4,
            children: [
              Semantics(
                container: true,
                label: ReaderTexts.modeLabel,
                child: SegmentedButton<ReaderMode>(
                  key: const ValueKey('reader-mode'),
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: ReaderMode.listen,
                      enabled: c.canListen,
                      icon: const Icon(Icons.headphones_rounded),
                      label: const Text(ReaderTexts.listen),
                    ),
                    const ButtonSegment(
                      value: ReaderMode.silent,
                      icon: Icon(Icons.menu_book_rounded),
                      label: Text(ReaderTexts.silent),
                    ),
                  ],
                  selected: {c.mode},
                  onSelectionChanged: (s) => unawaited(c.setMode(s.first)),
                ),
              ),
              pageLabel,
            ],
          ),
          const SizedBox(height: AppSpace.s8),
          if (listen)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  key: const ValueKey('reader-back10'),
                  onPressed: () => unawaited(c.back10()),
                  tooltip: ReaderTexts.back10,
                  icon: const Icon(Icons.replay_10_rounded),
                  color: AppPalette.seaBlue,
                ),
                Semantics(
                  button: true,
                  label: ReaderTexts.speedSemantics(c.speed),
                  excludeSemantics: true,
                  child: TextButton(
                    key: const ValueKey('reader-speed'),
                    onPressed: () => unawaited(c.cycleSpeed()),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(AppTouch.min, AppTouch.min),
                    ),
                    child: Text(ReaderTexts.speed(c.speed)),
                  ),
                ),
                SizedBox.square(
                  dimension: AppTouch.primary + AppSpace.s8,
                  child: IconButton.filled(
                    key: const ValueKey('reader-play'),
                    onPressed: onTogglePlay,
                    tooltip: c.isPlaying ? ReaderTexts.pause : ReaderTexts.play,
                    style: IconButton.styleFrom(
                      backgroundColor: AppPalette.lighthouseYellow,
                      foregroundColor: AppPalette.ink,
                    ),
                    icon: Icon(
                      c.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: AppIconSize.lg,
                    ),
                  ),
                ),
                IconButton(
                  key: const ValueKey('reader-sleep-button'),
                  onPressed: onSleep,
                  tooltip: ReaderTexts.sleep,
                  isSelected: c.sleep != SleepOption.off,
                  icon: const Icon(Icons.bedtime_outlined),
                  selectedIcon: const Icon(Icons.bedtime_rounded),
                  color: AppPalette.seaBlue,
                ),
              ],
            )
          else
            Row(
              children: [
                IconButton(
                  key: const ValueKey('reader-prev'),
                  onPressed: onPrev,
                  tooltip: ReaderTexts.prevPage,
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: AppPalette.seaBlue,
                ),
                const Spacer(),
                if (onFinish != null)
                  Flexible(
                    child: FilledButton.icon(
                      key: const ValueKey('reader-finish'),
                      onPressed: onFinish,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(AppTouch.min, AppTouch.min),
                      ),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text(
                        ReaderTexts.finishBook,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                else
                  IconButton(
                    key: const ValueKey('reader-next'),
                    onPressed: onNext,
                    tooltip: ReaderTexts.nextPage,
                    icon: const Icon(Icons.chevron_right_rounded),
                    color: AppPalette.seaBlue,
                  ),
              ],
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
        tooltip: ReaderTexts.close,
        icon: const Icon(Icons.close_rounded),
      ),
    ),
    body: Center(
      child: SingleChildScrollView(
        child: EmptyState(
          key: const ValueKey('reader-error'),
          icon: Icons.cloud_off_rounded,
          title: CommonTexts.serverDownTitle,
          message: '${ReaderTexts.loadError} ${CommonTexts.serverDownBody}',
          action: FilledButton.icon(
            key: const ValueKey('reader-retry'),
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text(CommonTexts.retry),
          ),
        ),
      ),
    ),
  );
}
