import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/episode.dart';
import 'player_session.dart';
import 'transition_metrics.dart';

/// Yalnızca doğrulama için: `--dart-define=AUTOPLAY_TEST=<mod>`.
///
/// - `true`: Hikâye sekmesi bütün bölümleri sırayla oynatır.
/// - `resume1`: B1'i `s05` kontrol noktasına dek oynatır ve bekler (süreç dışarıdan öldürülür).
/// - `resume2`: B1'i açar, "Kaldığın yerden devam"ı seçer ve sona dek oynatır.
/// - `meaning`: `true` gibi; B1 s02'de anlam panelini açar, kelime ve
///   "Türkçesini göster" adımlarını, ardından EN+TR altyazıyı gösterir (H-046).
/// - `h035`: Hikâye haritası (H-035): kilitli B2 paneli, B1 baştan sona, dönüşte harita.
/// - `h035view`: yalnızca haritayı açar ve durumunu yazar (kalıcılık denetimi).
/// - `h050`: sezon jeneriği (ilk açılış), B1 başlık ekranı ve 🎯 paneli, B2
///   başlık → "Önceki bölümde" + "Atla" (H-050). Yalnızca B1 ve B2 oynar.
const String kAutoplayMode = String.fromEnvironment('AUTOPLAY_TEST');

bool get autoplayEnabled =>
    kAutoplayMode.isNotEmpty && kAutoplayMode != 'false';

/// Bütün bölümlerin geçiş ölçümleri (Hikâye sekmesi özet yazar).
final List<EpisodeRunSummary> autoplayResults = [];

class EpisodeRunSummary {
  EpisodeRunSummary({
    required this.contentId,
    required this.completed,
    required this.transitions,
    required this.errors,
    required this.maxDriftMs,
    required this.gateOpen,
  });

  final String contentId;
  final bool completed;
  final List<TransitionRecord> transitions;
  final List<String> errors;
  final double maxDriftMs;
  final bool gateOpen;

  GapStats stats(TransitionKind k) =>
      GapStats.of(transitions.where((t) => t.kind == k).map((t) => t.gapMs));

  @override
  String toString() =>
      '$contentId completed=$completed gate=$gateOpen '
      'auto[${stats(TransitionKind.auto)}] '
      'choice[${stats(TransitionKind.choice)}] '
      'ui[${stats(TransitionKind.ui)}] '
      'start[${stats(TransitionKind.start)}] '
      'notPreloaded=${transitions.where((t) => !t.preloaded && t.kind == TransitionKind.auto).length} '
      'subtitleClockDriftMax=${maxDriftMs.toStringAsFixed(0)}ms '
      'errors=${errors.length}${errors.isEmpty ? '' : ' $errors'}';
}

void _log(String m) => debugPrint('[H031] $m');

/// Oturumu kullanıcı gibi sürer: bir kez ipucu ister, her kararda önce bir
/// yanlış seçeneği dener (tepki dalını sınar), görevleri doğru çözer.
///
/// Ekran görüntüsü anlarında `[H031][SHOT] <ad>` yazar ve birkaç saniye bekler.
class AutoplayDriver {
  AutoplayDriver(this.session, {required this.onExit}) {
    session.addListener(_onChange);
    _onChange();
  }

  final PlayerSession session;
  final VoidCallback onExit;

  final Set<String> _triedWrong = {};
  final Set<String> _shots = {};
  bool _hintDone = false;
  bool _subtitleShotArmed = true;
  String _lastKey = '';
  Timer? _timer;
  Timer? _poll;
  bool _disposed = false;
  bool _exited = false;

  bool get _isB1 => session.contentId == 'A1-001';
  bool get _h050 => kAutoplayMode == 'h050';
  bool _missionDone = false;
  bool _titleShotArmed = true;
  bool _recapShotArmed = true;

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _poll?.cancel();
    session.removeListener(_onChange);
  }

  void _after(int ms, VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: ms), () {
      if (!_disposed) action();
    });
  }

  /// Ekran görüntüsü için bekleme (yalnızca ilk kez).
  int _shot(String name, {int holdMs = 3500}) {
    if (!(_isB1 || _h050) || !_shots.add(name)) return 0;
    _log('[SHOT] $name');
    return holdMs;
  }

  void _onChange() {
    if (_disposed) return;
    final s = session;
    final node = s.node;
    final key = [
      s.phase.name,
      node?.id,
      s.hintPanelOpen,
      s.engine?.hintLevel(node?.id ?? ''),
      s.reactionBubbleVisible,
      s.videoError,
    ].join('|');
    if (key == _lastKey) return;
    _lastKey = key;

    switch (s.phase) {
      case PlayerPhase.loading:
        return;
      case PlayerPhase.error:
        _log('HATA ${s.error}');
        _after(1000, _exit);
      case PlayerPhase.resumePrompt:
        final fromCp = kAutoplayMode == 'resume2';
        _log(
          'kayıt bulundu: ${s.savedSnapshot?.checkpointNodeId}; '
          '${fromCp ? 'kaldığı yerden' : 'baştan'}',
        );
        _after(_shot('resume', holdMs: 3000) + 800, () {
          s.resume(fromCheckpoint: fromCp);
          if (fromCp) _log('RESUME2 devam düğümü=${s.node?.id}');
        });
      case PlayerPhase.finished:
        _after(_shot('end') + 1500, _exit);
      case PlayerPhase.playing:
        _drive(node);
    }
  }

  void _drive(EpisodeNode? node) {
    final s = session;
    if (node == null) return;
    if (s.videoError != null) {
      _after(1500, s.retryVideo);
      return;
    }
    if (kAutoplayMode == 'resume1' && node.id == 's05') {
      _log('RESUME1 HAZIR kontrol noktası=${s.engine?.lastCheckpoint}');
      _disposed = true; // dışarıdan öldürülmeyi bekle
      return;
    }
    switch (node) {
      case TitleNode():
        if (_h050 && _isB1) _pauseForShot(node.id, 'title', at: 0.9);
      case RecapNode():
        if (_h050) _recapShot(node);
      case SegmentNode():
        if (kAutoplayMode == 'meaning') {
          _armMeaningShots(node);
        } else {
          _armSubtitleShot(node);
        }
      case ReactionNode(:final bubble):
        if (s.reactionBubbleVisible) {
          _after(1200 + _shot('reaction', holdMs: 2500), s.advance);
        } else if (bubble == null) {
          // videolu tepki: bitince oturum ilerler.
        }
      case DecisionNode(:final options, :final hints):
        if (s.hintPanelOpen) {
          final hold = _shot('hint');
          if (s.engine!.canRequestHint && s.engine!.hintLevel(node.id) < 2) {
            _after(1200 + hold, () => s.requestHint());
          } else {
            _after(1200 + hold, s.closeHint);
          }
          return;
        }
        if (_h050 && _isB1 && !_missionDone) {
          _missionDone = true;
          unawaited(_missionShots(node));
          return;
        }
        if (!_hintDone && hints.isNotEmpty) {
          _hintDone = true;
          _after(1000 + _shot('decision'), () => s.requestHint());
          return;
        }
        final wrong = options.where((o) => !o.correct).firstOrNull;
        if (wrong != null && _triedWrong.add(node.id)) {
          _after(900, () => s.choose(wrong.id));
        } else {
          _after(900, () => s.choose(options.firstWhere((o) => o.correct).id));
        }
      case CardNode(:final autoAdvance):
        if (!autoAdvance) _after(1100, s.advance);
      case TaskNode(:final items):
        _after(1400, () {
          for (final i in items) {
            s.recordTaskAttempt(i.id, correct: true);
          }
          s.completeTask();
        });
    }
  }

  /// Video düğümünün [at]. saniyesinde ekran görüntüsü işareti (durdurmadan).
  void _pauseForShot(String nodeId, String name, {required double at}) {
    if (!_titleShotArmed) return;
    _titleShotArmed = false;
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(milliseconds: 20), (t) {
      if (_disposed || session.node?.id != nodeId) {
        t.cancel();
        return;
      }
      if (session.activeReady && session.positionSeconds >= at) {
        t.cancel();
        _log('[SHOT] $name');
      }
    });
  }

  /// B2 özeti: "Önceki bölümde" + "Atla" görüntüsü (durdurmadan), ardından
  /// "Atla" ile geçilir.
  void _recapShot(RecapNode node) {
    if (!_recapShotArmed || session.contentId != 'A1-002') return;
    _recapShotArmed = false;
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(milliseconds: 20), (t) async {
      if (_disposed || session.node?.id != node.id) {
        t.cancel();
        return;
      }
      if (session.activeReady && session.positionSeconds >= 0.6) {
        t.cancel();
        _log('[SHOT] recap');
        await Future<void>.delayed(const Duration(milliseconds: 1100));
        if (_disposed || session.node?.id != node.id) return;
        _log('özet "Atla" ile geçiliyor');
        await session.skipRecap();
      }
    });
  }

  /// B1 ilk kararda 🎯 paneli ve hedef ifadenin anlam paneli (H-050).
  Future<void> _missionShots(DecisionNode node) async {
    final s = session;
    await s.openMissionPanel();
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _log('[SHOT] mission');
    await Future<void>.delayed(const Duration(milliseconds: 3500));
    if (_disposed) return;
    final info = s.episode!.info;
    final phrase = info.targetPhrases.firstWhere(
      (p) => info.targetPhraseGloss.containsKey(p),
      orElse: () => '',
    );
    final gloss = info.targetPhraseGloss[phrase];
    if (gloss != null) {
      s.openMeaningForText(
        gloss.toMeaning(
          contentId: s.contentId,
          sourceId: '${info.id}#target-0',
          en: phrase,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      _log('[SHOT] mission-phrase');
      await Future<void>.delayed(const Duration(milliseconds: 3500));
      if (_disposed) return;
      await s.closeMeaning();
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    await s.closeMissionPanel();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!_disposed && s.node?.id == node.id) _drive(node);
  }

  /// B1 s02'deki "Can you hear me?" satırında ekran görüntüsü için duraklat.
  void _armSubtitleShot(SegmentNode node) {
    if (!_isB1 || node.id != 's02' || !_subtitleShotArmed) return;
    _subtitleShotArmed = false;
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(milliseconds: 50), (t) async {
      if (_disposed || session.node?.id != 's02') {
        t.cancel();
        return;
      }
      final cue = session.currentCue;
      if (cue != null && cue.text.startsWith('Can you hear')) {
        t.cancel();
        await session.togglePause();
        _log('[SHOT] subtitle');
        Timer(const Duration(milliseconds: 3000), () {
          if (!_disposed) session.togglePause();
        });
      }
    });
  }

  /// B1 s02 "Can you hear me?" satırında anlam panelinin adımları (H-046).
  void _armMeaningShots(SegmentNode node) {
    if (!_isB1 || node.id != 's02' || !_subtitleShotArmed) return;
    _subtitleShotArmed = false;
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(milliseconds: 50), (t) async {
      if (_disposed || session.node?.id != 's02') {
        t.cancel();
        return;
      }
      final cue = session.currentCue;
      if (cue == null || !cue.text.startsWith('Can you hear')) return;
      t.cancel();
      await session.openMeaningForCue(cue);
      _log('[SHOT] meaning-open');
      await Future<void>.delayed(const Duration(milliseconds: 3500));
      final m = session.meaning;
      if (_disposed || m == null) return;
      final i = m.text.words.indexWhere((w) => w.bare == 'hear');
      m.selectWord(i < 0 ? 0 : i);
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      _log('[SHOT] meaning-word');
      await Future<void>.delayed(const Duration(milliseconds: 3500));
      if (_disposed || session.meaning == null) return;
      m.reveal();
      await Future<void>.delayed(const Duration(milliseconds: 800));
      _log('[SHOT] meaning-tr');
      await Future<void>.delayed(const Duration(milliseconds: 3500));
      if (_disposed) return;
      session.setSubtitleMode(SubtitleMode.enTr);
      await session.closeMeaning();
      _log('anlam paneli kapandı; video sürüyor');
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (_disposed || session.node?.id != 's02') return;
      await session.togglePause();
      _log('[SHOT] subtitle-entr');
      await Future<void>.delayed(const Duration(milliseconds: 3500));
      if (!_disposed && session.userPaused) await session.togglePause();
    });
  }

  void _exit() {
    if (_exited) return;
    _exited = true;
    final s = session;
    final summary = EpisodeRunSummary(
      contentId: s.contentId,
      completed: s.phase == PlayerPhase.finished,
      transitions: List.of(s.transitions),
      errors: List.of(s.errors),
      maxDriftMs: s.maxClockDriftMs,
      gateOpen: s.engine?.gateStatus.open ?? false,
    );
    autoplayResults.add(summary);
    _log('BÖLÜM ÖZETİ $summary');
    for (final t in s.transitions) {
      _log('  geçiş ${s.contentId} $t');
    }
    onExit();
  }
}
