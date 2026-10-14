import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/meaning/meaning_controller.dart';
import '../../../shared/meaning/meaning_sheet.dart';
import '../../../shared/meaning/meaning_text.dart';
import '../../../shared/meaning/notebook_repository.dart';
import '../../../shared/speech/speech_providers.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../grammar/application/grammar_providers.dart';
import '../../grammar/presentation/grammar_lesson_screen.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../player/domain/subtitles.dart';
import '../../player/presentation/player_screen.dart'
    show AiNotice, videoControllerFactoryProvider;
import '../../speak/speak_env.dart';
import '../../story/application/story_providers.dart';
import '../application/clip_controllers.dart';
import '../application/discover_providers.dart';
import '../data/discover_store.dart';
import '../domain/clip.dart';
import '../domain/feed.dart';
import 'widgets/clip_page.dart';
import 'widgets/feed_cards.dart';

/// Keşfet (H-040, K-15): açılmış bölümlerden kısa klipler, dikey akış.
///
/// - Akış biter: klipler tükenince hikâye önerilir (sonsuz kaydırma yok).
/// - 4–5 klipte bir quiz kartı, ~10 klipte bir mola kartı.
/// - 13–17 (ve 13 altı) için günlük 20 dk; yalnızca dolunca söylenir.
/// - Ses açık başlar, sağ üstte kapatılır. Video kendiliğinden sonrakine
///   geçmez.
/// - Aynı anda en çok 3 video denetleyicisi (ekrandaki + sıradaki + atılmayı
///   bekleyen); ölçüm: `test/features/discover/discover_memory_test.dart`.
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clips = ref.watch(discoverClipsProvider);
    final limit = ref.watch(discoverLimitProvider);
    final Widget body = switch ((clips, limit)) {
      (AsyncError(), _) => _Message(
        key: const ValueKey('discover-error'),
        icon: Icons.cloud_off_rounded,
        title: DiscoverTexts.errorTitle,
        body: DiscoverTexts.errorBody,
        action: FilledButton(
          key: const ValueKey('discover-retry'),
          style: AppButtonStyles.primary(),
          onPressed: () => retryDiscover(ref),
          child: const Text(CommonTexts.retry),
        ),
      ),
      (AsyncData(value: final c), AsyncData())
          when c == null || c.clips.isEmpty =>
        _Message(
          key: const ValueKey('discover-empty'),
          icon: Icons.explore_outlined,
          title: DiscoverTexts.emptyTitle,
          body: DiscoverTexts.emptyBody,
          action: FilledButton(
            key: const ValueKey('discover-go-story'),
            style: AppButtonStyles.primary(),
            onPressed: () => context.go(AppRoutes.story),
            child: const Text(DiscoverTexts.goStory),
          ),
        ),
      (AsyncData(value: final c?), AsyncData(value: final l)) => DiscoverFeed(
        key: const ValueKey('discover-feed'),
        clips: c.clips,
        aiLabel: c.aiLabel,
        moreLocked: c.hasLocked,
        limit: l,
      ),
      _ => const _Loading(),
    };
    return Scaffold(
      backgroundColor: AppScrim.playerBackground,
      body: Semantics(label: DiscoverTexts.screenSemantics, child: body),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => Skeleton(
    key: const ValueKey('discover-loading'),
    label: DiscoverTexts.loading,
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.s16,
        MediaQuery.paddingOf(context).top + AppSpace.s16,
        AppSpace.s16,
        MediaQuery.paddingOf(context).bottom + AppSpace.s16,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bone(width: 88, height: 28),
          SizedBox(height: AppSpace.s8),
          _Bone(width: 200, height: 24),
          Spacer(),
          _Bone(width: double.infinity, height: 48),
          SizedBox(height: AppSpace.s8),
          _Bone(width: double.infinity, height: 72),
        ],
      ),
    ),
  );
}

class _Bone extends StatelessWidget {
  const _Bone({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: const BoxDecoration(
      color: AppScrim.chip,
      borderRadius: AppRadius.mdAll,
    ),
  );
}

class _Message extends StatelessWidget {
  const _Message({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget action;

  @override
  Widget build(BuildContext context) => FeedCardFrame(
    child: EmptyState(icon: icon, title: title, message: body, action: action),
  );
}

/// Akışın kendisi: sayfalar, video denetleyicileri, süre sayacı.
class DiscoverFeed extends ConsumerStatefulWidget {
  const DiscoverFeed({
    super.key,
    required this.clips,
    required this.aiLabel,
    required this.moreLocked,
    required this.limit,
  });

  final List<FeedClip> clips;
  final String aiLabel;
  final bool moreLocked;
  final DiscoverLimit limit;

  @override
  ConsumerState<DiscoverFeed> createState() => DiscoverFeedState();
}

class DiscoverFeedState extends ConsumerState<DiscoverFeed>
    with WidgetsBindingObserver {
  late final List<FeedEntry> feed = buildFeed(widget.clips);
  final PageController _pages = PageController();
  late final ClipControllerCache cache;
  int _index = 0;
  bool _muted = false;
  bool _visible = true;
  bool _foreground = true;
  bool _sheetOpen = false;
  bool _away = false; // bölüm ya da ders açık
  bool _limitReached = false;
  bool _limitLoaded = false;
  int _watched = 0; // bugün kaydedilen saniye
  int _pending = 0; // henüz yazılmamış saniye
  Timer? _tick;
  ValueListenable<bool>? _tickerMode;
  final Set<String> _savedKeys = {};
  int _savedCount = 0;
  int _activation = 0;
  late final DiscoverStore _store;
  late final DateTime Function() _clock;
  late final Duration _tickEvery;

  /// Ölçüm ve testler: ekrandaki sayfa.
  int get index => _index;

  FeedClip? get _clip => switch (feed[_index]) {
    ClipEntry(:final clip) => clip,
    _ => null,
  };

  VideoPlayerController? get _current {
    final c = _clip;
    return c == null ? null : cache.ready(c.video);
  }

  bool get _canPlay =>
      _visible && _foreground && !_sheetOpen && !_away && !_limitReached;

  @override
  void initState() {
    super.initState();
    final source = ref.read(contentSourceProvider);
    cache = ClipControllerCache(
      uriFor: (p) => source.seasonMediaUri(kDiscoverSeason, p),
      factory: ref.read(videoControllerFactoryProvider),
    );
    _store = ref.read(discoverStoreProvider);
    _clock = ref.read(discoverClockProvider);
    _tickEvery = ref.read(discoverTickProvider);
    WidgetsBinding.instance.addObserver(this);
    _tick = Timer.periodic(_tickEvery, (_) => _onTick());
    unawaited(_loadSaved());
    unawaited(_start());
  }

  Future<void> _start() async {
    await _loadWatched();
    if (!mounted || _limitReached) return;
    await _activate(0);
  }

  Future<void> _loadWatched() async {
    final limit = widget.limit.daily;
    try {
      _watched = await _store.watchedSeconds(_clock());
    } on Object catch (e) {
      debugPrint('[H040] süre okunamadı: $e');
    }
    if (!mounted) return;
    setState(() {
      _limitLoaded = true;
      _limitReached = limit != null && _watched >= limit.inSeconds;
    });
  }

  Future<void> _loadSaved() async {
    try {
      final all = await ref.read(notebookRepositoryProvider).all();
      if (!mounted) return;
      setState(() => _savedKeys.addAll(all.map((e) => e.key)));
    } on Object {
      // Defter okunamazsa düğmeler "Kaydet" görünür; ekleme yine çalışır.
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final n = TickerMode.getNotifier(context);
    if (!identical(n, _tickerMode)) {
      _tickerMode?.removeListener(_onVisibility);
      _tickerMode = n..addListener(_onVisibility);
      _visible = n.value;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final fg = state == AppLifecycleState.resumed;
    if (fg == _foreground) return;
    _foreground = fg;
    unawaited(_onPlayability());
  }

  void _onVisibility() {
    final v = _tickerMode?.value ?? true;
    if (v == _visible) return;
    _visible = v;
    unawaited(_onPlayability());
  }

  /// Sekme ya da uygulama görünürlüğü değişti.
  Future<void> _onPlayability() async {
    if (!_canPlay) {
      await _current?.pause();
      await _flush();
      return;
    }
    // Geri gelindi: gün değişmiş olabilir; süre yeniden okunur.
    await _flush();
    await _loadWatched();
    if (!mounted || !_canPlay) return;
    final c = _current;
    if (c != null && !c.value.isCompleted) await c.play();
  }

  void _onTick() {
    final c = _current;
    if (c == null || !c.value.isPlaying || !_canPlay) return;
    _pending += _tickEvery.inSeconds.clamp(1, 60);
    final limit = widget.limit.daily;
    if (limit != null && _watched + _pending >= limit.inSeconds) {
      unawaited(_reachLimit());
    } else if (_pending >= 10) {
      unawaited(_flush());
    }
  }

  Future<void> _flush() async {
    final s = _pending;
    if (s <= 0) return;
    _pending = 0;
    try {
      _watched = await _store.addSeconds(_clock(), s);
    } on Object catch (e) {
      debugPrint('[H040] süre yazılamadı: $e');
      _pending += s;
    }
  }

  Future<void> _reachLimit() async {
    if (_limitReached) return;
    setState(() => _limitReached = true);
    await _current?.pause();
    await _flush();
    cache.retain(const {});
  }

  /// Sayfa değişti: ekrandaki klip açılır ve oynar, sıradaki önceden açılır,
  /// ötekiler atılır.
  Future<void> _activate(int index) async {
    final token = ++_activation;
    _index = index;
    final entry = feed[index];
    final next = nextClipIndex(feed, index);
    final nextPath = next == null ? null : (feed[next] as ClipEntry).clip.video;
    final keep = <String>{if (entry is ClipEntry) entry.clip.video, ?nextPath};
    for (final p in [...cache.paths]) {
      if (!keep.contains(p)) await cache.ready(p)?.pause();
    }
    cache.retain(keep);
    if (mounted) setState(() {});
    if (entry is ClipEntry) {
      final c = await cache.acquire(entry.clip.video);
      if (!mounted || token != _activation || c == null) return;
      await c.setVolume(_muted ? 0 : 1);
      if (c.value.position > Duration.zero || c.value.isCompleted) {
        await c.seekTo(Duration.zero);
      }
      if (_canPlay && token == _activation) await c.play();
    }
    if (!mounted || token != _activation) return;
    if (nextPath != null && !_limitReached) cache.preload(nextPath);
  }

  Future<void> _togglePlay() async {
    final c = _current;
    if (c == null || !_canPlay) return;
    if (c.value.isPlaying) {
      await c.pause();
    } else {
      if (c.value.isCompleted) await c.seekTo(Duration.zero);
      await c.play();
    }
    if (mounted) setState(() {});
  }

  Future<void> _replay() async {
    final c = _current;
    if (c == null || !_canPlay) return;
    await c.seekTo(Duration.zero);
    await c.play();
  }

  Future<void> _toggleMute() async {
    setState(() => _muted = !_muted);
    await _current?.setVolume(_muted ? 0 : 1);
  }

  void _snack(String text) {
    final m = ScaffoldMessenger.maybeOf(context);
    m
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  String _sourceTitle(FeedClip clip) =>
      DiscoverTexts.notebookSource(clip.episodeTitle ?? clip.titleTr);

  SavedPhrase _targetItem(FeedClip clip) {
    final cue = clip.targetCue;
    return SavedPhrase(
      contentId: clip.episodeId,
      sourceId: cue?.id ?? '${clip.episodeId}#${clip.id}',
      kind: clip.target.isWord ? SavedKind.word : SavedKind.phrase,
      en: clip.target.en,
      tr: clip.target.tr,
      context: cue?.text,
      contextTr: cue?.tr,
      sourceTitle: _sourceTitle(clip),
      savedAt: _clock().toUtc(),
    );
  }

  bool _isSaved(FeedClip clip) => _savedKeys.contains(_targetItem(clip).key);

  /// "Kaydet": klibin ifadesi Defter'e (kaynak "Keşfet: bölüm adı").
  Future<void> _save(FeedClip clip) async {
    final item = _targetItem(clip);
    try {
      final added = await ref.read(notebookRepositoryProvider).add(item);
      if (!mounted) return;
      setState(() {
        _savedKeys.add(item.key);
        if (added) _savedCount++;
      });
      _snack(SaveOutcome(item, added: added).message);
      if (added) refreshNotebook(ref);
    } on Object catch (e) {
      debugPrint('[H040] deftere eklenemedi: $e');
      if (mounted) _snack(MeaningTexts.saveFailed);
    }
  }

  /// Altyazı satırı ya da "Anlam": video durur, anlam paneli açılır; panel
  /// kapanınca kaldığı yerden sürer.
  Future<void> _openMeaning(FeedClip clip, SubtitleCue cue, int? word) async {
    if (_sheetOpen) return;
    final c = _current;
    final wasPlaying = c?.value.isPlaying ?? false;
    final resumeAt = c?.value.position ?? Duration.zero;
    setState(() => _sheetOpen = true);
    await c?.pause();
    await _flush();
    if (!mounted) return;
    final audio = c == null
        ? const SilentMeaningAudio()
        : _ClipMeaningAudio(c, cue);
    final title = _sourceTitle(clip);
    var saved = false;
    final m = MeaningController(
      text: cue.toMeaning(clip.episodeId),
      audio: audio,
      events: ref.read(learningEventLogProvider),
      notebook: ref.read(notebookRepositoryProvider),
      decorate: (draft, {wordIndex, chunk}) {
        saved = true;
        return draft.copyWith(sourceTitle: title);
      },
    );
    if (word != null) m.selectWord(word);
    final topic = await showMeaningSheet(
      context,
      m,
      speak: ref.read(speechVisibleProvider) ? speakEnvOf(context) : null,
      structures: meaningStructures(ref, [?clip.grammarId]),
    );
    m.dispose();
    await audio.stop();
    if (!mounted) return;
    if (saved) {
      unawaited(_loadSaved());
      refreshNotebook(ref);
    }
    final still = _current;
    if (still != null && identical(still, c)) {
      await still.setPlaybackSpeed(1);
      await still.setVolume(_muted ? 0 : 1);
      await still.seekTo(resumeAt);
    }
    if (!mounted) return;
    setState(() => _sheetOpen = false);
    if (topic != null) {
      await _openGrammar(topic);
      return;
    }
    if (wasPlaying && _canPlay && identical(_current, c)) await c?.play();
  }

  Future<void> _whileAway(Future<void> Function() open) async {
    setState(() => _away = true);
    await _current?.pause();
    await _flush();
    try {
      await open();
    } finally {
      if (mounted) setState(() => _away = false);
    }
  }

  /// "Tam hikâye": bölüm açılır (kaldığı yer sorulur); dönünce klip durur
  /// halde bekler.
  Future<void> _openEpisode(FeedClip clip) => _whileAway(() async {
    if (!mounted) return;
    await openEpisode(context, ref, clip.episodeId);
  });

  Future<void> _openGrammar(String id) => _whileAway(() async {
    if (!mounted) return;
    await playGrammarLessons(context, ref, [id]);
  });

  /// Testler ve ekran görüntüleri: doğrudan bir sayfaya geçer.
  @visibleForTesting
  void jumpTo(int page) => _pages.jumpToPage(page);

  void _goNext() {
    final to = _index + 1;
    if (to >= feed.length || !_pages.hasClients) return;
    final d = AppMotion.of(context, AppMotion.base);
    if (d == Duration.zero) {
      _pages.jumpToPage(to);
    } else {
      unawaited(
        _pages.animateToPage(to, duration: d, curve: AppMotion.standard),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tickerMode?.removeListener(_onVisibility);
    _tick?.cancel();
    final s = _pending;
    if (s > 0) {
      // Son saniyeler: ekran kapanırken yazılır (beklenmez).
      unawaited(
        _store.addSeconds(_clock(), s).then((_) {}, onError: (Object _) {}),
      );
    }
    _pages.dispose();
    cache.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_limitLoaded) return const _Loading();
    if (_limitReached) {
      return LimitCard(onStory: () => context.go(AppRoutes.story));
    }
    final clipTotal = widget.clips.length;
    final source = ref.read(contentSourceProvider);
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          key: const ValueKey('discover-pages'),
          controller: _pages,
          scrollDirection: Axis.vertical,
          itemCount: feed.length,
          onPageChanged: (i) => unawaited(_activate(i)),
          itemBuilder: (context, i) => switch (feed[i]) {
            ClipEntry(:final clip, :final ordinal) => TickerMode(
              enabled: i == _index,
              child: ClipPage(
                clip: clip,
                ordinal: ordinal,
                total: clipTotal,
                cache: cache,
                active: i == _index,
                muted: _muted,
                saved: _isSaved(clip),
                posterUri: clip.poster == null
                    ? null
                    : source.seasonMediaUri(kDiscoverSeason, clip.poster!),
                onTogglePlay: () => unawaited(_togglePlay()),
                onReplay: () => unawaited(_replay()),
                onToggleMute: () => unawaited(_toggleMute()),
                onSave: () => unawaited(_save(clip)),
                onMeaning: (cue, w) => unawaited(_openMeaning(clip, cue, w)),
                onFullStory: () => unawaited(_openEpisode(clip)),
                onGrammar: clip.grammarId == null
                    ? null
                    : () => unawaited(_openGrammar(clip.grammarId!)),
                onRetry: () {
                  cache.retry(clip.video);
                  unawaited(_activate(i));
                },
              ),
            ),
            QuizEntry(:final clip) => QuizCard(
              key: ValueKey('quiz-${clip.id}'),
              clip: clip,
              onNext: _goNext,
            ),
            BreakEntry(:final clipsBefore) => BreakCard(
              clipsWatched: clipsBefore,
              saved: _savedCount,
              onHome: () => context.go(AppRoutes.home),
              onContinue: _goNext,
            ),
            EndEntry() => EndCard(
              moreLocked: widget.moreLocked,
              onStory: () => context.go(AppRoutes.story),
              onHome: () => context.go(AppRoutes.home),
            ),
          },
        ),
        // Yapay zekâ notu (§5.6): akış açılınca birkaç saniye, sonra kaybolur
        // (uygulama içi videoda gömülü etiket yok). Yalnızca klip üstünde.
        Positioned(
          left: AppSpace.s16,
          top: MediaQuery.paddingOf(context).top + 112,
          child: IgnorePointer(
            child: Visibility(
              visible: feed[_index] is ClipEntry,
              maintainState: true,
              child: AiNotice(
                key: const ValueKey('ai-note'),
                text: widget.aiLabel,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Anlam panelinin sesi: klibin kendi kaydından kelime ya da satır çalınır
/// (yeniden ses üretimi yok).
class _ClipMeaningAudio implements MeaningAudio {
  _ClipMeaningAudio(this._c, this._cue);

  final VideoPlayerController _c;
  final SubtitleCue _cue;
  Timer? _stop;

  @override
  bool get canPlayWords => _cue.words.isNotEmpty;

  @override
  bool get canPlaySentence => true;

  Future<void> _range(double start, double end, double speed) async {
    _stop?.cancel();
    final from = (start - 0.05).clamp(0.0, double.infinity);
    await _c.setVolume(1);
    await _c.setPlaybackSpeed(speed);
    await _c.seekTo(Duration(microseconds: (from * 1e6).round()));
    await _c.play();
    final ms = ((end - from + 0.12) / speed * 1000).round();
    _stop = Timer(Duration(milliseconds: ms), () => unawaited(_c.pause()));
  }

  @override
  Future<void> playWord(MeaningWord word, {required double speed}) async {
    if (!word.hasTiming) return;
    await _range(word.start!, word.end!, speed);
  }

  @override
  Future<void> playSentence({required double speed}) =>
      _range(_cue.start, _cue.end, speed);

  @override
  Future<void> stop() async {
    _stop?.cancel();
    _stop = null;
    try {
      await _c.pause();
    } on Object {
      // Denetleyici atılmış olabilir.
    }
  }
}
