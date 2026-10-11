import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../app/theme.dart';
import '../../../shared/content/content_providers.dart';
import '../application/autoplay_driver.dart';
import '../application/player_session.dart';
import '../application/segment_player_pool.dart';
import '../data/progress_repository.dart';
import '../domain/episode.dart';
import 'widgets/card_view.dart';
import 'widgets/decision_sheet.dart';
import 'widgets/end_view.dart';
import 'widgets/player_top_bar.dart';
import 'widgets/player_ui.dart';
import 'widgets/subtitle_overlay.dart';
import 'widgets/task_view.dart';

/// Testlerde sahte video denetleyicisi vermek için.
final videoControllerFactoryProvider = Provider<VideoControllerFactory?>(
  (ref) => null,
);

/// Etkileşimli bölüm oynatıcısı (H-031). Tam ekran; alt sekme çubuğu yok.
class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key, required this.contentId});

  final String contentId;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with WidgetsBindingObserver {
  late final PlayerSession _session;
  AutoplayDriver? _driver;
  String? _still;
  String? _lastNodeId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _session = PlayerSession(
      contentId: widget.contentId,
      source: ref.read(contentSourceProvider),
      progress: ref.read(progressRepositoryProvider),
      videoFactory: ref.read(videoControllerFactoryProvider),
      logTransitions: true,
    )..addListener(_onSession);
    if (autoplayEnabled) {
      _driver = AutoplayDriver(_session, onExit: _exit);
    }
    unawaited(_session.start());
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

  void _onSession() {
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
    if (mounted) setState(() {});
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

  void _exit() {
    if (!mounted) return;
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
        title: const Text('Bölümden çıkılsın mı?'),
        content: const Text(
          'Kaldığın sahne kaydedilecek. Sonra oradan devam edebilirsin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Kal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Çık'),
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
    return PopScope(
      canPop: s.phase != PlayerPhase.playing,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_confirmClose());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF101418),
        body: switch (s.phase) {
          PlayerPhase.loading => const _Centered(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.lighthouseYellow),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Bölüm yükleniyor…',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          PlayerPhase.error => _Centered(
            child: _ErrorPanel(
              message: s.error ?? 'Bir şeyler ters gitti.',
              onRetry: () => unawaited(s.start()),
              onBack: _exit,
            ),
          ),
          PlayerPhase.resumePrompt => _Centered(
            child: _ResumePanel(session: s),
          ),
          PlayerPhase.finished => EndView(engine: s.engine!, onBack: _exit),
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
    final dim = !isVideo || s.reactionBubbleVisible;
    final media = MediaQuery.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1) Video katmanı: eski son kare altta, yenisi ilk karesi gelince üstte.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isVideo ? () => unawaited(s.togglePause()) : null,
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
        // 3) Karar anında kararma (K-27).
        IgnorePointer(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            color: Colors.black.withValues(
              alpha: !dim
                  ? 0
                  : node is CardNode && node.kind == CardKind.title
                  ? 0.35
                  : 0.55,
            ),
          ),
        ),
        if (s.videoLoading && isVideo)
          const Center(
            child: CircularProgressIndicator(color: AppColors.lighthouseYellow),
          ),
        if (s.userPaused && isVideo)
          const IgnorePointer(
            child: Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Color(0x99000000),
                child: Icon(Icons.pause_rounded, color: Colors.white, size: 40),
              ),
            ),
          ),
        // 4) Altyazı.
        if (isVideo && !s.reactionBubbleVisible)
          Positioned(
            left: AppSpacing.sm,
            right: AppSpacing.sm,
            bottom: media.padding.bottom + AppSpacing.lg + AppSpacing.md,
            child: Center(
              child: SubtitleOverlay(
                session: s,
                targetPhrases: e.episode.info.targetPhrases,
              ),
            ),
          ),
        // 5) Yapay zekâ etiketi (§5.6). Videolarda etiket zaten gömülü.
        if (!isVideo)
          Positioned(
            right: AppSpacing.sm,
            bottom: media.padding.bottom + AppSpacing.xs,
            child: IgnorePointer(
              child: Text(
                e.episode.info.aiLabel,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
        // 6) Düğüm arayüzü.
        if (s.videoError != null)
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
              onSubtitleMode: s.setSubtitleMode,
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
              AppSpacing.sm,
              96,
              AppSpacing.sm,
              AppSpacing.md,
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
                title: 'İpucu ${hint.level} / ${node.hints.length}',
                text: hint.tr,
                onListen: hint.audio == null
                    ? null
                    : () => s.playAudio(hint.audio!),
                actions: [
                  FilledButton.icon(
                    key: const ValueKey('hint-more'),
                    onPressed: e.canRequestHint ? () => s.requestHint() : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.seaBlue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(48, 56),
                    ),
                    icon: const Icon(Icons.lightbulb_outline_rounded),
                    label: Text(
                      e.canRequestHint ? 'Bir ipucu daha' : 'Tüm ipuçları açık',
                    ),
                  ),
                  OutlinedButton.icon(
                    key: const ValueKey('hint-retry'),
                    onPressed: s.closeHint,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.seaBlue,
                      minimumSize: const Size(48, 56),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Tekrar dene'),
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
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _CuePill(cue: node.cue!),
                  ),
                DecisionSheet(
                  node: node,
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
                    minimumSize: const Size(48, 56),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Tekrar dene'),
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
        );
        if (node.kind == CardKind.title) {
          return [
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
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

class _CuePill extends StatelessWidget {
  const _CuePill({required this.cue});

  final DecisionCue cue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: const Color(0xCC1B1B1B),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Text(
        cue.text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
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
          padding: const EdgeInsets.all(AppSpacing.md),
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
            size: 48,
            color: AppColors.seaBlue,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Bağlantını ya da içerik sunucusunu kontrol edip tekrar deneyebilirsin.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryAction(label: 'Tekrar dene', onPressed: onRetry),
          const SizedBox(height: AppSpacing.xs),
          TextButton(
            onPressed: onBack,
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            child: const Text('Geri dön'),
          ),
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.seaBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            scene == null
                ? 'Bu bölümü yarıda bırakmıştın.'
                : 'Bu bölümü yarıda bırakmıştın: $scene',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryAction(
            key: const ValueKey('resume-continue'),
            label: 'Kaldığın yerden devam',
            icon: Icons.play_arrow_rounded,
            onPressed: () => session.resume(fromCheckpoint: true),
          ),
          const SizedBox(height: AppSpacing.xs),
          OutlinedButton(
            key: const ValueKey('resume-restart'),
            onPressed: () => session.resume(fromCheckpoint: false),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Baştan başla'),
          ),
        ],
      ),
    );
  }
}
