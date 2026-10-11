import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../../shared/content/content_source.dart';
import '../data/progress_repository.dart';
import '../domain/episode.dart';
import '../domain/episode_engine.dart';
import '../domain/subtitles.dart';
import 'clip_audio_player.dart';
import 'segment_player_pool.dart';
import 'transition_metrics.dart';

enum PlayerPhase { loading, resumePrompt, playing, finished, error }

enum SubtitleMode { en, off }

/// Bir bölüm oynatma oturumu: motor + video havuzu + ses + kayıt.
///
/// Ekran bu nesneyi dinler; iş kuralı motorda (saf Dart), medya burada.
class PlayerSession extends ChangeNotifier {
  PlayerSession({
    required this.contentId,
    required ContentSource source,
    required ProgressRepository progress,
    VideoControllerFactory? videoFactory,
    this.logTransitions = kDebugMode,
  }) : _source = source,
       _progress = progress,
       _videoFactory = videoFactory,
       audio = ClipAudioPlayer(factory: videoFactory);

  final String contentId;
  final ContentSource _source;
  final ProgressRepository _progress;
  final VideoControllerFactory? _videoFactory;
  final bool logTransitions;

  /// Hi balonu, seçenek ve görev sesleri.
  final ClipAudioPlayer audio;

  late final SegmentPlayerPool _pool = SegmentPlayerPool(
    uriFor: (path) => _source.mediaUri(contentId, path),
    factory: _videoFactory,
  );

  PlayerPhase _phase = PlayerPhase.loading;
  String? _error;
  Episode? _episode;
  EpisodeEngine? _engine;
  EngineSnapshot? _savedSnapshot;
  Map<String, Map<String, String>> _externalFlags = const {};

  // Video katmanı.
  VideoPlayerController? _active;
  String? _activePath;
  VideoPlayerController? _under;
  String? _underPath;
  bool _activeReady = false;
  bool _videoLoading = false;
  String? _videoError;
  SubtitleTrack? _subtitles;
  bool _completionHandled = false;
  bool _userPaused = false;

  // Arayüz durumu.
  SubtitleMode _subtitleMode = SubtitleMode.en;
  double _speed = 1.0;
  bool _hintPanelOpen = false;
  bool _reactionBubbleVisible = false;
  Timer? _autoCardTimer;
  int _token = 0;
  String? _lastSavedCheckpoint;
  bool _disposed = false;

  // Konum tahmini (altyazı eşlemesi için; video_player konumu 100 ms'de bir günceller).
  Duration _anchorPos = Duration.zero;
  final Stopwatch _anchorClock = Stopwatch();
  double _maxDriftMs = 0;

  final List<TransitionRecord> transitions = [];
  final List<String> errors = [];

  // ------------------------------------------------------------ okuma

  PlayerPhase get phase => _phase;
  String? get error => _error;
  Episode? get episode => _episode;
  EpisodeEngine? get engine => _engine;
  EpisodeNode? get node => _engine?.current;
  EngineSnapshot? get savedSnapshot => _savedSnapshot;

  VideoPlayerController? get activeController => _active;
  VideoPlayerController? get underController => _under;
  bool get activeReady => _activeReady;
  bool get videoLoading => _videoLoading;
  String? get videoError => _videoError;
  SubtitleTrack? get subtitles => _subtitles;
  SubtitleMode get subtitleMode => _subtitleMode;
  double get speed => _speed;
  bool get hintPanelOpen => _hintPanelOpen;
  bool get reactionBubbleVisible => _reactionBubbleVisible;
  bool get userPaused => _userPaused;
  int get liveVideoControllers => _pool.liveCount;

  /// Altyazı saatinin bildirilen konumdan en büyük sapması (ms).
  double get maxClockDriftMs => _maxDriftMs;

  /// Şu an bir video düğümü mü oynuyor (karar/kart değil)?
  bool get isVideoNode {
    final n = node;
    return n is VideoBearing && (n as VideoBearing).video != null;
  }

  Uri media(String path) => _source.mediaUri(contentId, path);

  /// Oynayan videonun tahmini konumu (saniye).
  double get positionSeconds {
    final c = _active;
    if (c == null) return 0;
    var pos = _anchorPos.inMicroseconds / 1e6;
    if (c.value.isPlaying && _anchorClock.isRunning) {
      pos += _anchorClock.elapsedMicroseconds / 1e6 * _speed;
    }
    final dur = c.value.duration.inMicroseconds / 1e6;
    return dur > 0 && pos > dur ? dur : pos;
  }

  SubtitleCue? get currentCue {
    if (_subtitleMode == SubtitleMode.off || !isVideoNode) return null;
    return _subtitles?.cueAt(positionSeconds);
  }

  // ------------------------------------------------------------ başlangıç

  Future<void> start() async {
    _setPhase(PlayerPhase.loading);
    try {
      final ep = await _source.loadEpisode(contentId);
      final external = <String, Map<String, String>>{};
      for (final f in ep.externalFlags) {
        external.putIfAbsent(f.episode, () => {});
      }
      for (final id in external.keys.toList()) {
        external[id] = await _progress.loadEpisodeFlags(id);
      }
      _episode = ep;
      _externalFlags = external;
      final snap = await _progress.loadCheckpoint(contentId);
      if (_disposed) return;
      if (snap != null &&
          snap.checkpointNodeId != ep.start &&
          ep.nodes[snap.checkpointNodeId]?.checkpoint == true) {
        _savedSnapshot = snap;
        _setPhase(PlayerPhase.resumePrompt);
      } else {
        _begin(null);
      }
    } on Object catch (e) {
      _error = e is ContentUnavailableException
          ? 'İçerik sunucusuna ulaşılamadı.'
          : 'Bölüm açılamadı.';
      errors.add('load: $e');
      _log('bölüm yüklenemedi: $e');
      _setPhase(PlayerPhase.error);
    }
  }

  /// Kayıt sorusunun cevabı: kaldığı yerden mi, baştan mı?
  void resume({required bool fromCheckpoint}) {
    final snap = fromCheckpoint ? _savedSnapshot : null;
    if (!fromCheckpoint) unawaited(_progress.clearCheckpoint(contentId));
    _begin(snap);
  }

  void _begin(EngineSnapshot? snap) {
    _engine = EpisodeEngine(
      _episode!,
      externalFlags: _externalFlags,
      resumeFrom: snap,
    );
    _lastSavedCheckpoint = snap?.checkpointNodeId;
    _setPhase(PlayerPhase.playing);
    _log(
      'başla ${_engine!.current!.id}${snap != null ? ' (kaldığı yerden)' : ''}',
    );
    _onNodeEntered(kind: TransitionKind.start);
  }

  // ------------------------------------------------------------ eylemler

  /// Kart ve tepki balonundan sonra ilerle.
  void advance() {
    final e = _engine;
    if (e == null || e.isFinished) return;
    final n = e.current;
    if (n is DecisionNode || n is TaskNode) return;
    _reactionBubbleVisible = false;
    e.advance();
    _onNodeEntered(kind: TransitionKind.ui);
  }

  DecisionResult? choose(String optionId) {
    final e = _engine;
    if (e == null || e.current is! DecisionNode) return null;
    final result = e.choose(optionId);
    _hintPanelOpen = false;
    _log('karar ${result.option.id} doğru=${result.correct}');
    _onNodeEntered(kind: TransitionKind.choice);
    return result;
  }

  Hint? requestHint() {
    final hint = _engine?.requestHint();
    if (hint == null) return null;
    _hintPanelOpen = true;
    final a = hint.audio;
    if (a != null) unawaited(audio.play(media(a)));
    notifyListeners();
    return hint;
  }

  void closeHint() {
    _hintPanelOpen = false;
    unawaited(audio.stop());
    notifyListeners();
  }

  void recordTaskAttempt(String itemId, {required bool correct}) =>
      _engine?.recordTaskAttempt(itemId, correct: correct);

  void completeTask() {
    final e = _engine;
    if (e == null || e.current is! TaskNode) return;
    e.completeTask();
    _onNodeEntered(kind: TransitionKind.ui);
  }

  void playAudio(String path) => unawaited(audio.play(media(path)));

  void setSpeed(double value) {
    _speed = value;
    _reanchor();
    unawaited(_active?.setPlaybackSpeed(value));
    notifyListeners();
  }

  void setSubtitleMode(SubtitleMode mode) {
    _subtitleMode = mode;
    notifyListeners();
  }

  /// Altyazı satırına dokununca o satırı yeniden oynat.
  Future<void> replayCue(SubtitleCue cue) async {
    final c = _active;
    if (c == null || !isVideoNode) return;
    await _cancelPrestart();
    await c.seekTo(Duration(microseconds: (cue.start * 1e6).round()));
    _anchorPos = Duration(microseconds: (cue.start * 1e6).round());
    _anchorClock
      ..reset()
      ..start();
    _userPaused = false;
    if (!c.value.isPlaying) await c.play();
    notifyListeners();
  }

  Future<void> togglePause() async {
    final c = _active;
    if (c == null || !isVideoNode) return;
    if (c.value.isPlaying) {
      _userPaused = true;
      await c.pause();
      await _cancelPrestart();
      // Duraklayınca tahmin saati gerçek konuma bağlanır (altyazı kaymaz).
      final p = await c.position;
      if (p != null) _reanchor(position: p);
    } else {
      _userPaused = false;
      await c.play();
    }
    notifyListeners();
  }

  /// Uygulama arka plana geçti: duraklat ve kaydet.
  Future<void> onBackground() async {
    if (_active?.value.isPlaying ?? false) {
      _userPaused = true;
      await _active!.pause();
      await _cancelPrestart();
    }
    await saveCheckpoint();
    notifyListeners();
  }

  /// Çıkış: kontrol noktası kaydedilir (bölüm bittiyse kayıt yoktur).
  Future<void> saveCheckpoint() async {
    final e = _engine;
    if (e == null || e.isFinished) return;
    await _progress.saveCheckpoint(contentId, e.snapshot());
  }

  /// Video açılamadıysa aynı düğümü yeniden dene.
  void retryVideo() {
    final n = node;
    if (n is VideoBearing) {
      final path = (n as VideoBearing).video;
      if (path != null) _pool.evict(path);
    }
    _videoError = null;
    _onNodeEntered(kind: TransitionKind.ui);
  }

  // ------------------------------------------------------------ düğüm akışı

  void _onNodeEntered({required TransitionKind kind}) {
    final e = _engine!;
    final token = ++_token;
    _autoCardTimer?.cancel();
    _hintPanelOpen = false;
    _reactionBubbleVisible = false;
    _videoError = null;
    unawaited(audio.stop());

    if (e.isFinished) {
      unawaited(_finish());
      return;
    }
    final n = e.current!;
    _maybeSaveCheckpoint(n);

    switch (n) {
      case final VideoBearing v when v.video != null:
        _activeReady = false;
        unawaited(_playVideo(v, kind: kind, token: token));
      case ReactionNode(:final bubble):
        _reactionBubbleVisible = true;
        if (bubble?.audio != null) playAudio(bubble!.audio!);
      case CardNode(:final autoAdvance, :final duration, :final audio):
        if (audio != null) playAudio(audio);
        if (autoAdvance) {
          final ms = ((duration ?? 2.5) * 1000).round();
          _autoCardTimer = Timer(Duration(milliseconds: ms), () {
            if (token == _token) advance();
          });
        }
      case TaskNode(:final audio):
        if (audio != null) playAudio(audio);
      case DecisionNode():
      case SegmentNode():
        break;
    }
    _preloadUpcoming();
    notifyListeners();
  }

  void _maybeSaveCheckpoint(EpisodeNode n) {
    final cp = _engine!.lastCheckpoint;
    if (n.checkpoint && cp != null && cp != _lastSavedCheckpoint) {
      _lastSavedCheckpoint = cp;
      unawaited(_progress.saveCheckpoint(contentId, _engine!.snapshot()));
      _log('kontrol noktası kaydedildi: $cp');
    }
  }

  void _preloadUpcoming() {
    final e = _engine;
    if (e == null || e.isFinished) return;
    final upcoming = e.upcomingVideoNodes(limit: 2);
    final paths = [for (final v in upcoming) v.video!];
    _pool.preload(paths, protect: _protected);
    for (final v in upcoming) {
      final s = v.subtitles;
      if (s != null) _source.loadSubtitles(contentId, s).ignore();
    }
  }

  /// Ekrandaki, altındaki ve açılmakta olan video atılmaz.
  Set<String> get _protected => {
    ?_activePath,
    ?_underPath,
    ?_pendingPath,
    ?_prestartedPath,
  };

  String? _pendingPath;

  /// Sıradaki segment, bu segment bitmeden [prestartLead] önce altta başlatılır
  /// (AVPlayer/ExoPlayer başlangıç gecikmesi ~150 ms gizlenir). Eski son kare
  /// üstte kalır; yeni video ilk karesiyle ortaya çıkar.
  static const prestartLead = Duration(milliseconds: 220);
  String? _prestartedPath;
  bool _prestarting = false;

  Future<void> _playVideo(
    VideoBearing v, {
    required TransitionKind kind,
    required int token,
  }) async {
    final t0 = Stopwatch()..start();
    final path = v.video!;
    final from = _activeNodeId;
    final preloaded = _pool.isReady(path);
    _pendingPath = path;
    _completionHandled = false;
    _userPaused = false;
    if (!preloaded) {
      _videoLoading = true;
      notifyListeners();
    }

    final VideoPlayerController c;
    try {
      c = await _pool.acquire(path, protect: _protected);
    } on Object catch (err) {
      if (token != _token) return;
      _videoLoading = false;
      _videoError = 'Video yüklenemedi.';
      errors.add('video $path: $err');
      _log('video açılamadı: $path ($err)');
      notifyListeners();
      return;
    }
    if (token != _token || _disposed) return;
    _pendingPath = null;

    // Eski video (son karesiyle) yenisinin ilk karesine dek altta kalır.
    final old = _active;
    if (old != null && !identical(old, c)) {
      old.removeListener(_onActiveTick);
      _under = old;
      _underPath = _activePath;
    }
    _active = c;
    _activePath = path;
    _activeNodeId = v.id;
    _activeReady = false;
    _videoLoading = false;
    _subtitles = null;
    c.addListener(_onActiveTick);
    final subsPath = v.subtitles;
    if (subsPath != null) {
      _source
          .loadSubtitles(contentId, subsPath)
          .then((t) {
            if (token == _token) {
              _subtitles = t;
              notifyListeners();
            }
          })
          .catchError((Object err) {
            errors.add('subs $subsPath: $err');
          });
    }

    final prestarted = _prestartedPath == path && c.value.isPlaying;
    _prestartedPath = null;
    if (!prestarted) {
      if (c.value.playbackSpeed != _speed) await c.setPlaybackSpeed(_speed);
      if (c.value.position > Duration.zero) await c.seekTo(Duration.zero);
      await c.play();
    }
    final playCallMs = t0.elapsedMicroseconds / 1000;
    _reanchor(position: prestarted ? await c.position : Duration.zero);

    // İlk kare: oynatma başı ilerleyince (platform konumu > 0) kabul edilir.
    var moved = false;
    Duration? firstPos;
    while (t0.elapsedMilliseconds < 8000 && token == _token && !_disposed) {
      final pos = await c.position;
      if (pos != null && pos > Duration.zero) {
        moved = true;
        firstPos = pos;
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 4));
    }
    if (token != _token || _disposed) return;
    final gap = t0.elapsedMicroseconds / 1000;
    // Altyazı saati, oynatmanın gerçekten başladığı konuma bağlanır.
    if (firstPos != null) _reanchor(position: firstPos);
    _activeReady = true;
    _under = null;
    _underPath = null;
    final rec = TransitionRecord(
      from: from,
      to: v.id,
      kind: kind,
      gapMs: gap,
      preloaded: preloaded,
      prestarted: prestarted,
    );
    transitions.add(rec);
    if (!moved) errors.add('first-frame timeout ${v.id}');
    _log(
      'geçiş $rec (play() ${playCallMs.toStringAsFixed(1)}ms, '
      'buffering=${c.value.isBuffering}, canlı denetleyici=${_pool.liveCount})',
    );
    notifyListeners();
    _preloadUpcoming();
  }

  String? _activeNodeId;

  void _onActiveTick() {
    final c = _active;
    if (c == null || _disposed) return;
    final value = c.value;
    if (value.hasError && _videoError == null) {
      _videoError = 'Video oynatılamadı.';
      errors.add('play ${_activeNodeId ?? ''}: ${value.errorDescription}');
      notifyListeners();
      return;
    }
    // Konum güncellendi: tahmin saatini yeniden bağla, sapmayı ölç.
    if (value.position != _anchorPos) {
      if (value.isPlaying && _anchorClock.isRunning) {
        final est = positionSeconds;
        final drift = (est - value.position.inMicroseconds / 1e6).abs() * 1000;
        if (drift < 1000 && drift > _maxDriftMs) _maxDriftMs = drift;
      }
      _reanchor(position: value.position);
    }
    _maybePrestart(value);
    // Yeniden oynatılan denetleyicide eski `isCompleted` bayrağı bir süre
    // kalabilir; yalnızca oynatma başı sona yakınsa bitiş sayılır.
    final nearEnd =
        value.duration > Duration.zero &&
        value.position >= value.duration - const Duration(milliseconds: 250);
    if (value.isCompleted && nearEnd && !_completionHandled && isVideoNode) {
      final n = node;
      if (n == null ||
          n is! VideoBearing ||
          (n as VideoBearing).id != _activeNodeId) {
        return;
      }
      _completionHandled = true;
      _onVideoCompleted(n);
    }
  }

  void _maybePrestart(VideoPlayerValue value) {
    if (_prestartedPath != null || _prestarting || !value.isPlaying) return;
    final n = node;
    if (n is! SegmentNode || n.id != _activeNodeId) return;
    final next = n.next == null ? null : _engine!.episode.nodes[n.next];
    if (next is! VideoBearing) return;
    final path = (next as VideoBearing).video;
    if (path == null || !_pool.isReady(path) || path == _activePath) return;
    final remainingUs =
        (value.duration.inMicroseconds - positionSeconds * 1e6) / _speed;
    if (remainingUs > prestartLead.inMicroseconds) return;
    _prestarting = true;
    final token = _token;
    unawaited(() async {
      try {
        final c = await _pool.acquire(path, protect: _protected);
        if (token != _token || _disposed) return;
        if (c.value.playbackSpeed != _speed) await c.setPlaybackSpeed(_speed);
        if (c.value.position > Duration.zero) await c.seekTo(Duration.zero);
        _prestartedPath = path;
        await c.play();
      } catch (_) {
        // Ön başlatma olmazsa normal geçiş yapılır.
      } finally {
        _prestarting = false;
      }
    }());
  }

  /// Ön başlatılmış sıradaki video varsa durdurur (kullanıcı duraklattı).
  Future<void> _cancelPrestart() async {
    final p = _prestartedPath;
    _prestartedPath = null;
    if (p == null) return;
    try {
      final c = await _pool.acquire(p, protect: _protected);
      await c.pause();
      await c.seekTo(Duration.zero);
    } catch (_) {}
  }

  void _onVideoCompleted(EpisodeNode n) {
    final e = _engine!;
    if (n is SegmentNode) {
      e.advance();
      _onNodeEntered(kind: TransitionKind.auto);
    } else if (n is ReactionNode) {
      if (n.bubble != null) {
        _reactionBubbleVisible = true;
        final a = n.bubble!.audio;
        if (a != null) playAudio(a);
        notifyListeners();
      } else {
        e.advance();
        _onNodeEntered(kind: TransitionKind.ui);
      }
    }
  }

  void _reanchor({Duration? position}) {
    if (position != null) _anchorPos = position;
    _anchorClock
      ..reset()
      ..start();
  }

  Future<void> _finish() async {
    final e = _engine!;
    _active?.removeListener(_onActiveTick);
    await audio.stop();
    await _progress.saveEpisodeFlags(e.episode.info.id, e.flags);
    await _progress.clearCheckpoint(contentId);
    _setPhase(PlayerPhase.finished);
    _log('bölüm bitti; kapı=${e.gateStatus.open}');
  }

  void _setPhase(PlayerPhase p) {
    _phase = p;
    if (!_disposed) notifyListeners();
  }

  void _log(String msg) {
    if (logTransitions) debugPrint('[H031] $contentId $msg');
  }

  GapStats statsFor(TransitionKind kind) =>
      GapStats.of(transitions.where((t) => t.kind == kind).map((t) => t.gapMs));

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _token++;
    _autoCardTimer?.cancel();
    _active?.removeListener(_onActiveTick);
    audio.dispose();
    unawaited(_pool.dispose());
    super.dispose();
  }
}
