import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/activity/study_clock.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/meaning/meaning_controller.dart';
import '../../../shared/meaning/meaning_sheet.dart';
import '../../../shared/meaning/meaning_text.dart';
import '../../../shared/meaning/notebook_repository.dart';
import '../../../shared/speech/speech_providers.dart';
import '../../speak/speak_env.dart';
import '../../grammar/application/grammar_providers.dart';
import '../../grammar/presentation/grammar_lesson_screen.dart';
import '../../hi/application/hi_providers.dart';
import '../../hi/presentation/hi_cards.dart';
import '../../notebook/application/deck_sync.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../topic_sets/application/topic_set_providers.dart';
import '../application/autoplay_driver.dart';
import '../application/player_session.dart';
import '../application/segment_player_pool.dart';
import '../../../shared/progress/story_progress.dart';
import '../data/progress_repository.dart';
import '../domain/episode.dart';
import '../domain/episode_engine.dart';
import '../data/subtitle_preference_store.dart';
import 'widgets/card_view.dart';
import 'widgets/decision_sheet.dart';
import 'widgets/end_view.dart';
import 'widgets/hi_avatar.dart' show HiExpression;
import 'widgets/mission_sheet.dart';
import 'widgets/opening_overlays.dart';
import 'widgets/player_top_bar.dart';
import 'widgets/player_ui.dart';
import 'widgets/subtitle_overlay.dart';
import 'widgets/task_view.dart';

/// Defter ve ipucu panosu kayıtları (H-036). Testlerde `null` verilebilir.
final playerHooksProvider = Provider<PlayerHooks?>(
  (ref) => NotebookPlayerHooks(ref.watch(deckSyncProvider)),
);

/// Testlerde sahte video denetleyicisi vermek için.
final videoControllerFactoryProvider = Provider<VideoControllerFactory?>(
  (ref) => null,
);

/// Etkileşimli bölüm oynatıcısı (H-031). Tam ekran; alt sekme çubuğu yok.
class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({
    super.key,
    required this.contentId,
    this.startMode = PlayerStartMode.ask,
  });

  final String contentId;

  /// Haritadaki "Devam et" / "Tekrar oyna" (H-035); varsayılan: kayıt varsa sor.
  final PlayerStartMode startMode;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with WidgetsBindingObserver {
  late final PlayerSession _session;
  AutoplayDriver? _driver;
  String? _still;
  String? _lastNodeId;
  MeaningController? _shownMeaning;
  bool _missionShown = false;

  /// Kullanıcı bu oynanışta altyazıyı değiştirdi mi (kayıtlı tercih geç
  /// gelirse üzerine yazmasın diye; K-03, H-039).
  bool _subtitleTouched = false;

  /// Bölüm bu oynanıştan önce bitmiş miydi (H-051: konu seti satırı yeni
  /// açılan set için "açıldı", tekrar oynayışta yalnızca "Konu seti" der).
  bool? _completedBefore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(
      ref
          .read(progressRepositoryProvider)
          .loadAll()
          .then((all) {
            if (mounted) {
              _completedBefore =
                  all[widget.contentId]?.status == StoryStatus.completed;
            }
          })
          .catchError((Object _) {}),
    );
    _session = PlayerSession(
      contentId: widget.contentId,
      source: ref.read(contentSourceProvider),
      progress: ref.read(progressRepositoryProvider),
      videoFactory: ref.read(videoControllerFactoryProvider),
      events: ref.read(learningEventLogProvider),
      notebook: ref.read(notebookRepositoryProvider),
      hooks: ref.read(playerHooksProvider),
      coach: ref.read(playerCoachProvider),
      logTransitions: true,
    )..addListener(_onSession);
    if (autoplayEnabled) {
      _driver = AutoplayDriver(_session, onExit: _exit);
    } else {
      // Kayıtlı altyazı tercihi (açılışta seçilen Türkçe satır, K-03).
      unawaited(
        readSubtitlePreference(ref.read(subtitlePreferenceStoreProvider)).then((
          mode,
        ) {
          if (mounted && mode != null && !_subtitleTouched) {
            _session.setSubtitleMode(mode);
          }
        }),
      );
    }
    unawaited(_session.start(mode: widget.startMode));
  }

  void _setSubtitleMode(SubtitleMode mode) {
    _subtitleTouched = true;
    _session.setSubtitleMode(mode);
    unawaited(
      ref
          .read(subtitlePreferenceStoreProvider)
          .setMode(mode)
          .catchError(
            (Object e) => debugPrint('[H039] altyazı kaydedilemedi: $e'),
          ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _driver?.dispose();
    _session
      ..removeListener(_onSession)
      ..dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      unawaited(_session.onBackground());
    }
  }

  bool _posterCached = false;

  void _onSession() {
    // Oynayan video öğrenme etkinliğidir (H-074: günlük süre).
    if (_session.phase == PlayerPhase.playing &&
        _session.isVideoNode &&
        !_session.userPaused &&
        !_session.missionPanelOpen) {
      ref.read(studyClockProvider).signal();
    }
    // Başlık afişi bölüm yüklenir yüklenmez önbelleğe alınır (H-050).
    final poster = _session.episode?.titleNode?.posterPath;
    if (!_posterCached && poster != null && mounted) {
      _posterCached = true;
      precacheImage(
        NetworkImage(_session.media(poster).toString()),
        context,
        onError: (_, _) {},
      );
    }
    final node = _session.node;
    if (node?.id != _lastNodeId) {
      _lastNodeId = node?.id;
      final bg = switch (node) {
        DecisionNode(:final background) => background,
        CardNode(:final background) => background,
        TaskNode(:final background) => background,
        _ => null,
      };
      if (bg != null) _still = bg;
      _precacheUpcoming();
    }
    // Durağan görsel, yeni videonun ilk karesi gelene dek kalır.
    if (_session.isVideoNode && _session.activeReady) _still = null;
    _syncMeaningSheet();
    _syncMissionSheet();
    if (mounted) setState(() {});
  }

  /// Oturumdaki 🎯 paneli ile ekrandaki alt paneli eşler (H-050).
  void _syncMissionSheet() {
    if (!mounted) return;
    final open = _session.missionPanelOpen;
    if (open && !_missionShown) {
      _missionShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final info = _session.episode?.info;
        if (!mounted || info == null || !_session.missionPanelOpen) {
          _missionShown = false;
          unawaited(_session.closeMissionPanel());
          return;
        }
        showMissionSheet(
          context,
          info: info,
          onPhraseTap: (i, phrase, gloss) => _openText(
            gloss.toMeaning(
              contentId: _session.contentId,
              sourceId: '${info.id}#target-$i',
              en: phrase,
            ),
          ),
        ).whenComplete(() {
          _missionShown = false;
          unawaited(_session.closeMissionPanel());
        });
      });
    } else if (!open && _missionShown && _shownMeaning == null) {
      // Oturum paneli kapattı (doğrulama modu): alt paneli indir.
      final nav = Navigator.of(context);
      if (nav.canPop()) nav.pop();
    }
  }

  /// Oturumdaki anlam paneli ile ekrandaki alt paneli eşler.
  void _syncMeaningSheet() {
    if (!mounted) return;
    final m = _session.meaning;
    if (m != null && !identical(m, _shownMeaning)) {
      _shownMeaning = m;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !identical(_session.meaning, m)) return;
        showMeaningSheet(
          context,
          m,
          speak: ref.read(speechVisibleProvider) ? speakEnvOf(context) : null,
          structures: meaningStructures(
            ref,
            _session.episode?.info.grammarTopics ?? const [],
          ),
        ).then((topic) async {
          if (identical(_shownMeaning, m)) _shownMeaning = null;
          await _session.closeMeaning();
          // "Bu yapı ne?" (H-078): video durur, ders açılır.
          if (topic == null || !mounted) return;
          await _session.onBackground();
          if (!mounted) return;
          await playGrammarLessons(context, ref, [topic]);
        });
      });
    } else if (m == null && _shownMeaning != null) {
      // Oturum paneli kapattı (ör. otomatik doğrulama): alt paneli indir.
      _shownMeaning = null;
      final nav = Navigator.of(context);
      if (nav.canPop()) nav.pop();
    }
  }

  void _openText(MeaningText? text, {String? audio}) {
    if (text == null) return;
    _session.openMeaningForText(text, audioPath: audio);
  }

  void _precacheUpcoming() {
    final e = _session.engine;
    final node = _session.node;
    if (e == null || node == null || !mounted) return;
    final path = e.mainPath;
    final i = path.indexOf(node.id);
    if (i < 0) return;
    for (final id in path.skip(i + 1).take(4)) {
      final bg = switch (e.episode.nodes[id]) {
        DecisionNode(:final background) => background,
        CardNode(:final background) => background,
        TaskNode(:final background) => background,
        _ => null,
      };
      if (bg != null) {
        precacheImage(
          NetworkImage(_session.media(bg).toString()),
          context,
          // Ön yükleme başarısızsa görsel ekranda yeniden denenir.
          onError: (_, _) {},
        );
      }
    }
  }

  /// Bölüm sonu; bölüm bir konu setini açıyorsa satırı ve "Konu setini aç"
  /// düğmesi (H-051). Set bilgisi gelmezse ekran setsiz görünür.
  Widget _endView(EpisodeEngine engine) {
    final set = ref.watch(topicSetUnlockedByProvider(widget.contentId)).value;
    return EndView(
      engine: engine,
      onBack: _exit,
      topicSetTitle: set?.titleTr,
      topicSetIsNew: _completedBefore != true,
      speak: ref.watch(speechVisibleProvider) ? speakEnvOf(context) : null,
      onSpokenTarget: () => unawaited(_session.recordSpokenTargetPhrase()),
      onOpenTopicSet: set == null
          ? null
          : () {
              debugPrint('[H051] bölüm sonundan konu seti: ${set.id}');
              context.pushReplacement(AppRoutes.topicSet(set.id));
            },
    );
  }

  void _exit() {
    if (!mounted) return;
    debugPrint('[H031] oynatıcıdan çıkış ${widget.contentId}');
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/hikaye');
    }
  }

  Future<void> _confirmClose() async {
    if (_session.phase != PlayerPhase.playing) {
      _exit();
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(PlayerTexts.exitTitle),
        content: const Text(PlayerTexts.exitBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(PlayerTexts.exitStay),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(PlayerTexts.exitLeave),
          ),
        ],
      ),
    );
    if (leave == true) {
      await _session.saveCheckpoint();
      _exit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _session;
    // "Söyle" durumu erkenden yüklensin (anlam paneli açılırken hazır olsun).
    ref.watch(speechVisibleProvider);
    // "Bu yapı ne?" için ders listesi (H-078; bölümde konu varsa).
    if (s.episode?.info.grammarTopics.isNotEmpty ?? false) {
      ref.watch(grammarLessonsOrEmptyProvider);
    }
    return PopScope(
      canPop: s.phase != PlayerPhase.playing,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_confirmClose());
      },
      child: Scaffold(
        backgroundColor: AppScrim.playerBackground,
        body: switch (s.phase) {
          PlayerPhase.loading => _Centered(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AppPalette.lighthouseYellow,
                ),
                const SizedBox(height: AppSpace.s16),
                Text(
                  PlayerTexts.loading,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppPalette.white),
                ),
              ],
            ),
          ),
          PlayerPhase.error => _Centered(
            child: _ErrorPanel(
              message: s.error ?? PlayerTexts.genericError,
              onRetry: () => unawaited(s.start()),
              onBack: _exit,
            ),
          ),
          PlayerPhase.resumePrompt => _Centered(
            child: _ResumePanel(session: s),
          ),
          PlayerPhase.finished => _endView(s.engine!),
          PlayerPhase.playing => _playing(context),
        },
      ),
    );
  }

  Widget _playing(BuildContext context) {
    final s = _session;
    final e = s.engine!;
    final node = s.node;
    final isVideo = s.isVideoNode;
    final isTitle = node is TitleNode;
    final dim = !isVideo || s.reactionBubbleVisible;
    final media = MediaQuery.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1) Video katmanı: eski son kare altta, yenisi ilk karesi gelince üstte.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          // Başlık ekranı dokunmayla durmaz (kendiliğinden geçer, H-050).
          onTap: isVideo && !isTitle ? () => unawaited(s.togglePause()) : null,
          child: _VideoLayer(session: s),
        ),
        // 2) Karar/kart arka planı (durağan görsel).
        if (_still != null)
          Positioned.fill(
            child: Image.network(
              s.media(_still!).toString(),
              key: ValueKey(_still),
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        // 2b) Başlık afişi (H-050): video ilk karesi gelene dek görünür, sonra
        // videoya yumuşakça bırakır. Bölüm açılışında boş/siyah kare olmaz.
        if (node is TitleNode && node.posterPath != null)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                key: const ValueKey('title-poster'),
                opacity: s.activeReady ? 0 : 1,
                // H-043: "Hareketi azalt" açıksa anında.
                duration: AppMotion.of(
                  context,
                  const Duration(milliseconds: 200),
                ),
                child: Image.network(
                  s.media(node.posterPath!).toString(),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        // 3) Karar anında kararma (K-27).
        IgnorePointer(
          child: AnimatedContainer(
            key: const ValueKey('player-dim'),
            // H-043: "Hareketi azalt" açıksa kararma anında.
            duration: AppMotion.of(context, AppMotion.base),
            color: !dim
                ? AppScrim.dim.withValues(alpha: 0)
                : node is CardNode && node.kind == CardKind.title
                ? AppScrim.dimLight
                : AppScrim.dim,
          ),
        ),
        if (s.videoLoading && isVideo && !isTitle)
          const Center(
            child: CircularProgressIndicator(
              color: AppPalette.lighthouseYellow,
            ),
          ),
        if (s.userPaused && isVideo && !isTitle)
          const IgnorePointer(
            child: Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: AppScrim.strong,
                child: Icon(
                  Icons.pause_rounded,
                  color: AppPalette.white,
                  size: AppIconSize.xl,
                ),
              ),
            ),
          ),
        // 4) Altyazı.
        if (isVideo && !s.reactionBubbleVisible)
          Positioned(
            left: AppSpace.s16,
            right: AppSpace.s16,
            bottom:
                media.padding.bottom +
                AppSpace.s32 +
                AppSpace.s24 +
                (node is RecapNode ? RecapBar.height : 0),
            child: Center(
              child: SubtitleOverlay(
                session: s,
                targetPhrases: e.episode.info.targetPhrases,
                onTapCue: (cue) => unawaited(s.openMeaningForCue(cue)),
              ),
            ),
          ),
        // 5) Yapay zekâ etiketi (§5.6): bölüm açılınca (başlık ekranında) birkaç saniye görünür, sonra
        // kaybolur (kullanıcı kararı 2026-10-12: "kullanıcı az görsün"). Uygulama içi
        // videolarda gömülü etiket yok; sosyal medya kesitlerinde gömülü kalır (K-14).
        Positioned(
          left: AppSpace.s16,
          top: media.padding.top + 72, // üst çubuğun altında
          child: IgnorePointer(child: AiNotice(text: e.episode.info.aiLabel)),
        ),
        // 6) Düğüm arayüzü. Hi'nin konu kartı (H-048) segment bitince gelir.
        if (s.topicIntro != null)
          Positioned.fill(
            child: ColoredBox(
              color: AppScrim.dim,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpace.s16,
                      96,
                      AppSpace.s16,
                      AppSpace.s24,
                    ),
                    child: HiTopicCard(
                      intro: s.topicIntro!,
                      onContinue: s.dismissTopicIntro,
                      onSkip: s.dismissTopicIntro,
                      // Hi'nin sesi oturumun tek çalarından (H-083); kart
                      // kapanınca sonraki düğüm sesi durdurur.
                      onListen: s.topicIntro!.audio == null
                          ? null
                          : () => s.playAudio(
                              '$kSeasonPathPrefix${s.topicIntro!.audio}',
                            ),
                    ),
                  ),
                ),
              ),
            ),
          )
        else if (s.videoError != null)
          _Centered(
            child: _ErrorPanel(
              message: s.videoError!,
              onRetry: s.retryVideo,
              onBack: () => unawaited(_confirmClose()),
            ),
          )
        else
          ..._nodeUi(context, node),
        // 7) Üst çubuk.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: PlayerTopBar(
              dotCount: e.progressCheckpoints.length,
              dotIndex: e.progressIndex,
              speed: s.speed,
              subtitleMode: s.subtitleMode,
              onClose: () => unawaited(_confirmClose()),
              onSpeed: s.setSpeed,
              onSubtitleMode: _setSubtitleMode,
              onMission: () => unawaited(s.openMissionPanel()),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _nodeUi(BuildContext context, EpisodeNode? node) {
    final s = _session;
    final e = s.engine!;
    Widget bottom(Widget child, {Key? key}) => Positioned(
      key: key,
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.fromLTRB(
              AppSpace.s16,
              96,
              AppSpace.s16,
              AppSpace.s24,
            ),
            child: child,
          ),
        ),
      ),
    );

    switch (node) {
      case DecisionNode():
        if (s.hintPanelOpen && e.currentHint != null) {
          final hint = e.currentHint!;
          return [
            bottom(
              key: const ValueKey('hint-panel'),
              HiPanel(
                expression: HiExpression.thinking,
                title: PlayerTexts.hintTitle(hint.level, node.hints.length),
                text: hint.tr,
                onListen: hint.audio == null
                    ? null
                    : () => s.playAudio(hint.audio!),
                actions: [
                  FilledButton.icon(
                    key: const ValueKey('hint-more'),
                    onPressed: e.canRequestHint ? () => s.requestHint() : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppPalette.seaBlue,
                      foregroundColor: AppPalette.white,
                      minimumSize: const Size(AppTouch.min, AppTouch.primary),
                    ),
                    icon: const Icon(Icons.lightbulb_outline_rounded),
                    label: Text(
                      e.canRequestHint
                          ? PlayerTexts.hintMore
                          : PlayerTexts.hintAllOpen,
                    ),
                  ),
                  OutlinedButton.icon(
                    key: const ValueKey('hint-retry'),
                    onPressed: s.closeHint,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppPalette.white,
                      foregroundColor: AppPalette.seaBlue,
                      minimumSize: const Size(AppTouch.min, AppTouch.primary),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text(PlayerTexts.retry),
                  ),
                ],
              ),
            ),
          ];
        }
        return [
          bottom(
            key: ValueKey('decision-${node.id}'),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (node.cue != null && node.cue!.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpace.s16),
                    child: _CuePill(
                      cue: node.cue!,
                      onTap: node.cue!.gloss == null
                          ? null
                          : () => _openText(
                              node.cue!.gloss!.toMeaning(
                                contentId: s.contentId,
                                sourceId: '${node.id}#cue',
                                en: node.cue!.text,
                                speaker: node.cue!.speaker,
                              ),
                              audio: node.cue!.audio,
                            ),
                    ),
                  ),
                DecisionSheet(
                  node: node,
                  speak: ref.watch(speechVisibleProvider)
                      ? speakEnvOf(context)
                      : null,
                  contentId: s.contentId,
                  onChoose: (o) => s.choose(o.id),
                  onListen: s.playAudio,
                  onHint: node.hints.isEmpty ? null : () => s.requestHint(),
                ),
              ],
            ),
          ),
        ];
      case ReactionNode(:final bubble):
        if (!s.reactionBubbleVisible || bubble == null) return const [];
        return [
          bottom(
            key: ValueKey('reaction-${node.id}'),
            HiPanel(
              text: bubble.text,
              onListen: bubble.audio == null
                  ? null
                  : () => s.playAudio(bubble.audio!),
              actions: [
                FilledButton.icon(
                  key: const ValueKey('reaction-retry'),
                  onPressed: s.advance,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(AppTouch.min, AppTouch.primary),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(PlayerTexts.retry),
                ),
              ],
            ),
          ),
        ];
      case CardNode():
        final card = CardView(
          key: ValueKey('card-${node.id}'),
          card: node,
          lines: e.linesFor(node),
          onContinue: s.advance,
          onListen: node.audio == null ? null : () => s.playAudio(node.audio!),
          isLast: node.next == null,
          // Başlık gibi kendiliğinden geçen kartlar panel açmaz.
          onLineTap: node.autoAdvance
              ? null
              : (i, line) => _openText(
                  line.gloss?.toMeaning(
                    contentId: s.contentId,
                    sourceId: '${node.id}#$i',
                    en: line.text,
                    speaker: line.speaker ?? _cardSpeaker(node),
                  ),
                ),
        );
        if (node.kind == CardKind.title) {
          return [
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.s24),
                  child: card,
                ),
              ),
            ),
          ];
        }
        return [bottom(card)];
      case TaskNode():
        return [
          bottom(
            TaskView(
              key: ValueKey('task-${node.id}'),
              task: node,
              onAttempt: (item, ok) => s.recordTaskAttempt(item, correct: ok),
              onComplete: s.completeTask,
              onListen: s.playAudio,
              onStemTap: (item) => _openText(
                item.stemGloss?.toMeaning(
                  contentId: s.contentId,
                  sourceId: '${node.id}.${item.id}#stem',
                  en: item.stem ?? '',
                ),
                audio: node.audio,
              ),
            ),
          ),
        ];
      case TitleNode():
        return [
          Positioned.fill(
            key: ValueKey('title-${node.id}'),
            child: EpisodeTitleOverlay(
              node: node,
              positionSeconds: () => s.activeReady ? s.positionSeconds : 0,
            ),
          ),
        ];
      case RecapNode():
        return [
          Positioned(
            key: ValueKey('recap-${node.id}'),
            left: AppSpace.s16,
            right: AppSpace.s16,
            bottom: MediaQuery.of(context).padding.bottom + AppSpace.s16,
            child: RecapBar(
              onSkip: e.canSkip ? () => unawaited(s.skipRecap()) : null,
            ),
          ),
        ];
      case SegmentNode():
      case null:
        return const [];
    }
  }
}

class _VideoLayer extends StatelessWidget {
  const _VideoLayer({required this.session});

  final PlayerSession session;

  @override
  Widget build(BuildContext context) {
    final under = session.underController;
    final active = session.activeController;
    // Yeni video altta çizilir; eski videonun son karesi, yenisinin ilk karesi
    // gelene dek üstte kalır (siyah kare görünmez). Yeni video gizlenmez
    // (Opacity 0 dokuyu çizdirmez ve iOS'ta oynatmayı başlatmaz), yalnızca örtülür.
    final showUnder =
        under != null && under.value.isInitialized && !session.activeReady;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (active != null && active.value.isInitialized)
          _CoverVideo(controller: active, key: ObjectKey(active)),
        if (showUnder) _CoverVideo(controller: under, key: ObjectKey(under)),
      ],
    );
  }
}

class _CoverVideo extends StatelessWidget {
  const _CoverVideo({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final size = controller.value.size;
    return ExcludeSemantics(
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: size.width == 0 ? 1080 : size.width,
            height: size.height == 0 ? 1920 : size.height,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}

String? _cardSpeaker(CardNode card) => switch (card.kind) {
  CardKind.note => 'NOTE',
  CardKind.message => card.title,
  _ => null,
};

/// Kararı tetikleyen replik. Karşı karakterin repliği dokunulabilir (H-046);
/// seçenek düğmeleri panel açmaz.
class _CuePill extends StatelessWidget {
  const _CuePill({required this.cue, this.onTap});

  final DecisionCue cue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      constraints: const BoxConstraints(minHeight: AppTouch.min),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.s16,
        vertical: AppSpace.s8,
      ),
      decoration: const BoxDecoration(
        color: AppScrim.captionBox,
        borderRadius: AppRadius.mdAll,
      ),
      child: Text(
        cue.text,
        textAlign: TextAlign.center,
        style: AppTypography.lead.copyWith(color: AppPalette.white),
      ),
    );
    if (onTap == null) return pill;
    return Semantics(
      button: true,
      label: PlayerTexts.tapForMeaning(cue.text),
      excludeSemantics: true,
      child: GestureDetector(
        key: const ValueKey('decision-cue'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: pill,
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.s24),
          child: child,
        ),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return PlayerPanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: AppIconSize.xl,
            color: AppPalette.seaBlue,
          ),
          const SizedBox(height: AppSpace.s16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpace.s8),
          const Text(PlayerTexts.errorHint, textAlign: TextAlign.center),
          // Yerel geliştirme: içerik sunucusu notu yalnızca debug derlemede.
          if (kDebugMode) ...[
            const SizedBox(height: AppSpace.s8),
            Text(
              CommonTexts.devServerHint,
              key: const ValueKey('player-dev-hint'),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppPalette.ink500),
            ),
          ],
          const SizedBox(height: AppSpace.s24),
          PrimaryAction(label: PlayerTexts.retry, onPressed: onRetry),
          const SizedBox(height: AppSpace.s8),
          TextButton(onPressed: onBack, child: const Text(CommonTexts.goBack)),
        ],
      ),
    );
  }
}

class _ResumePanel extends StatelessWidget {
  const _ResumePanel({required this.session});

  final PlayerSession session;

  @override
  Widget build(BuildContext context) {
    final ep = session.episode!;
    final cp = session.savedSnapshot!.checkpointNodeId;
    final scene = ep.nodes[cp]?.scene;
    return PlayerPanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ep.info.title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: AppPalette.seaBlue),
          ),
          const SizedBox(height: AppSpace.s8),
          Text(PlayerTexts.resumeBody(scene), textAlign: TextAlign.center),
          const SizedBox(height: AppSpace.s24),
          PrimaryAction(
            key: const ValueKey('resume-continue'),
            label: PlayerTexts.resumeContinue,
            icon: Icons.play_arrow_rounded,
            onPressed: () => session.resume(fromCheckpoint: true),
          ),
          const SizedBox(height: AppSpace.s8),
          OutlinedButton(
            key: const ValueKey('resume-restart'),
            onPressed: () => session.resume(fromCheckpoint: false),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.min),
            ),
            child: const Text(PlayerTexts.restart),
          ),
        ],
      ),
    );
  }
}

/// Bölüm başında kısa süre görünen yapay zekâ bilgisi.
class AiNotice extends StatefulWidget {
  const AiNotice({
    super.key,
    required this.text,
    this.visibleFor = const Duration(seconds: 4),
  });

  final String text;
  final Duration visibleFor;

  @override
  State<AiNotice> createState() => _AiNoticeState();
}

class _AiNoticeState extends State<AiNotice> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.visibleFor, () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      // "Hareketi azalt" açıksa solmadan kaybolur (H-040).
      duration: AppMotion.of(context, const Duration(milliseconds: 600)),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.s12,
          vertical: AppSpace.s4,
        ),
        decoration: const BoxDecoration(
          color: AppScrim.chip,
          borderRadius: AppRadius.mdAll,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: AppIconSize.sm,
              color: AppScrim.captionText,
            ),
            const SizedBox(width: AppSpace.s4),
            Text(
              widget.text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppPalette.white),
            ),
          ],
        ),
      ),
    );
  }
}
