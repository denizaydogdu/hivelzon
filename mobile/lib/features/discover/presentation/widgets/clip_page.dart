import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import '../../../player/domain/subtitles.dart';
import '../../application/clip_controllers.dart';
import '../../domain/clip.dart';

/// Keşfet'te tek klip (H-040; taslak S10): tam ekran video, üstte bölüm
/// etiketi ve başlık, sağda Kaydet · Anlam · Tam hikâye, altta dilbilgisi
/// etiketi, altyazı (dokununca anlam paneli) ve klibin ifadesi.
///
/// Video bitince kendiliğinden sonrakine geçmez (K-32): "Tekrar izle" ve
/// "Sonraki klip için yukarı kaydır." görünür.
class ClipPage extends StatelessWidget {
  const ClipPage({
    super.key,
    required this.clip,
    required this.ordinal,
    required this.total,
    required this.cache,
    required this.active,
    required this.muted,
    required this.saved,
    required this.posterUri,
    required this.onTogglePlay,
    required this.onReplay,
    required this.onToggleMute,
    required this.onSave,
    required this.onMeaning,
    required this.onFullStory,
    required this.onGrammar,
    required this.onRetry,
  });

  final FeedClip clip;
  final int ordinal;
  final int total;
  final ClipControllerCache cache;

  /// Ekrandaki klip mi (altyazı saati yalnızca onda çalışır).
  final bool active;
  final bool muted;

  /// Klibin ifadesi defterde mi?
  final bool saved;
  final Uri? posterUri;
  final VoidCallback onTogglePlay;
  final VoidCallback onReplay;
  final VoidCallback onToggleMute;
  final VoidCallback onSave;

  /// Altyazı satırı (yoksa hedefin satırı) ve dokunulan kelime.
  final void Function(SubtitleCue cue, int? word) onMeaning;
  final VoidCallback onFullStory;
  final VoidCallback? onGrammar;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Semantics(
        key: ValueKey('clip-page-${clip.id}'),
        container: true,
        label: DiscoverTexts.clipSemantics(ordinal, total, clip.titleTr),
        child: ColoredBox(
          color: AppScrim.playerBackground,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _Poster(uri: posterUri),
              ListenableBuilder(
                listenable: cache,
                builder: (context, _) {
                  final c = cache.ready(clip.video);
                  if (c == null) return const SizedBox.shrink();
                  return _Video(controller: c);
                },
              ),
              const _Scrims(),
              // Videoya dokununca durur / sürer.
              Positioned.fill(
                child: Semantics(
                  button: true,
                  label: DiscoverTexts.playPause,
                  excludeSemantics: true,
                  child: GestureDetector(
                    key: const ValueKey('clip-play-toggle'),
                    behavior: HitTestBehavior.opaque,
                    onTap: onTogglePlay,
                  ),
                ),
              ),
              ListenableBuilder(
                listenable: cache,
                builder: (context, _) => _CenterState(
                  controller: cache.ready(clip.video),
                  failed: cache.failed(clip.video),
                  active: active,
                  onReplay: onReplay,
                  onRetry: onRetry,
                  onTogglePlay: onTogglePlay,
                ),
              ),
              Positioned(
                left: AppSpace.s16,
                right: AppSpace.s16,
                top: pad.top + AppSpace.s12,
                child: _TopBar(clip: clip, muted: muted, onMute: onToggleMute),
              ),
              Positioned(
                left: AppSpace.s16,
                right: AppSpace.s16,
                bottom: pad.bottom + AppSpace.s16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: _ActionRail(
                        saved: saved,
                        clip: clip,
                        onSave: onSave,
                        onMeaning: () {
                          final cue = clip.targetCue;
                          if (cue != null) onMeaning(cue, null);
                        },
                        onFullStory: onFullStory,
                      ),
                    ),
                    const SizedBox(height: AppSpace.s12),
                    if (clip.grammarTitle != null && onGrammar != null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _GrammarChip(
                          // Dersin kısa adı: "can / can't: yetenek…" → "can / can't".
                          title: clip.grammarTitle!.split(':').first.trim(),
                          onTap: onGrammar!,
                        ),
                      ),
                      const SizedBox(height: AppSpace.s8),
                    ],
                    ListenableBuilder(
                      listenable: cache,
                      builder: (context, _) => _CueLine(
                        clip: clip,
                        controller: cache.ready(clip.video),
                        active: active,
                        onTap: onMeaning,
                      ),
                    ),
                    const SizedBox(height: AppSpace.s8),
                    _TargetCard(target: clip.target),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.uri});

  final Uri? uri;

  @override
  Widget build(BuildContext context) {
    final u = uri;
    if (u == null) return const SizedBox.shrink();
    return Image.network(
      u.toString(),
      fit: BoxFit.cover,
      excludeFromSemantics: true,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  }
}

class _Video extends StatelessWidget {
  const _Video({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final size = controller.value.size;
    final w = size.width > 0 ? size.width : 720.0;
    final h = size.height > 0 ? size.height : 1280.0;
    return ExcludeSemantics(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(width: w, height: h, child: VideoPlayer(controller)),
      ),
    );
  }
}

class _Scrims extends StatelessWidget {
  const _Scrims();

  @override
  Widget build(BuildContext context) => const IgnorePointer(
    child: Column(
      children: [
        SizedBox(
          height: 140,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppScrim.chip, Colors.transparent],
              ),
            ),
          ),
        ),
        Spacer(),
        SizedBox(
          height: 320,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppScrim.gradientEnd, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.clip,
    required this.muted,
    required this.onMute,
  });

  final FeedClip clip;
  final bool muted;
  final VoidCallback onMute;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final n = clip.episodeNumber;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (n != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.s12,
                    vertical: AppSpace.s4,
                  ),
                  decoration: const BoxDecoration(
                    color: AppPalette.lighthouseYellow,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.full),
                    ),
                  ),
                  child: Text(
                    DiscoverTexts.episodeChip(n),
                    style: t.labelLarge?.copyWith(color: AppPalette.ink),
                  ),
                ),
              const SizedBox(height: AppSpace.s8),
              Semantics(
                header: true,
                child: Text(
                  clip.titleTr,
                  key: const ValueKey('clip-title'),
                  style: t.titleLarge?.copyWith(
                    color: AppPalette.white,
                    shadows: const [
                      Shadow(color: AppScrim.textShadow, blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpace.s8),
        _RoundButton(
          key: const ValueKey('clip-mute'),
          icon: muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
          label: muted ? DiscoverTexts.unmute : DiscoverTexts.mute,
          onTap: onMute,
          dark: true,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.dark = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: PressScale(
      child: Material(
        color: dark ? AppScrim.chip : AppPalette.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: AppTouch.min,
            height: AppTouch.min,
            child: Icon(
              icon,
              size: AppIconSize.md,
              color: dark ? AppPalette.white : AppPalette.seaBlue,
            ),
          ),
        ),
      ),
    ),
  );
}

class _ActionRail extends StatelessWidget {
  const _ActionRail({
    required this.saved,
    required this.clip,
    required this.onSave,
    required this.onMeaning,
    required this.onFullStory,
  });

  final bool saved;
  final FeedClip clip;
  final VoidCallback onSave;
  final VoidCallback onMeaning;
  final VoidCallback onFullStory;

  @override
  Widget build(BuildContext context) {
    Widget action(
      String key,
      IconData icon,
      String label,
      String semantics,
      VoidCallback onTap,
    ) => Padding(
      padding: const EdgeInsets.only(top: AppSpace.s8),
      child: Semantics(
        button: true,
        label: semantics,
        excludeSemantics: true,
        child: GestureDetector(
          key: ValueKey(key),
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 72),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PressScale(
                  child: Container(
                    width: AppTouch.min,
                    height: AppTouch.min,
                    decoration: const BoxDecoration(
                      color: AppPalette.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppScrim.cardShadow, blurRadius: 8),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: AppIconSize.md,
                      color: AppPalette.seaBlue,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.s4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppPalette.white,
                    shadows: const [
                      Shadow(color: AppScrim.textShadow, blurRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        action(
          'clip-save',
          saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          saved ? DiscoverTexts.saved : DiscoverTexts.save,
          saved
              ? DiscoverTexts.savedSemantics(clip.target.en)
              : DiscoverTexts.saveSemantics(clip.target.en),
          onSave,
        ),
        action(
          'clip-meaning',
          Icons.menu_book_rounded,
          DiscoverTexts.meaning,
          DiscoverTexts.meaningSemantics,
          onMeaning,
        ),
        action(
          'clip-full-story',
          Icons.movie_outlined,
          DiscoverTexts.fullStory,
          DiscoverTexts.fullStorySemantics(clip.episodeNumber),
          onFullStory,
        ),
      ],
    );
  }
}

class _GrammarChip extends StatelessWidget {
  const _GrammarChip({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = DiscoverTexts.grammarChip(title);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: PressScale(
        child: Material(
          color: AppPalette.seaBlue,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
          child: InkWell(
            key: const ValueKey('clip-grammar'),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppRadius.full),
            ),
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppTouch.min),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.rule_rounded,
                      size: AppIconSize.sm,
                      color: AppPalette.white,
                    ),
                    const SizedBox(width: AppSpace.s8),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppPalette.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Altyazı satırı: video konumuna her karede eşlenir (konum 0,5 sn'de bir
/// gelir; arası kronometreyle tahmin edilir). Hedef ifadenin sözcükleri fener
/// sarısı. Satıra dokununca video durur ve anlam paneli açılır.
class _CueLine extends StatefulWidget {
  const _CueLine({
    required this.clip,
    required this.controller,
    required this.active,
    required this.onTap,
  });

  final FeedClip clip;
  final VideoPlayerController? controller;
  final bool active;
  final void Function(SubtitleCue cue, int? word) onTap;

  @override
  State<_CueLine> createState() => _CueLineState();
}

class _CueLineState extends State<_CueLine>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_onTick);
  final Stopwatch _since = Stopwatch();
  Duration _lastPos = Duration.zero;
  SubtitleCue? _cue;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant _CueLine old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    if (widget.active && widget.controller != null) {
      if (!_ticker.isActive) _ticker.start();
    } else if (_ticker.isActive) {
      _ticker.stop();
    }
  }

  void _onTick(Duration _) {
    final c = widget.controller;
    if (c == null) return;
    final v = c.value;
    if (v.position != _lastPos) {
      _lastPos = v.position;
      _since
        ..reset()
        ..start();
    }
    var t = v.position.inMicroseconds / 1e6;
    if (v.isPlaying && _since.isRunning) {
      t += _since.elapsedMicroseconds / 1e6 * v.playbackSpeed;
    }
    final cue = widget.clip.subtitles.cueAt(t);
    if (!identical(cue, _cue)) setState(() => _cue = cue);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cue = _cue;
    // Satır yokken de yer tutulur: alttaki kart zıplamaz.
    if (cue == null) return const SizedBox(height: AppTouch.min);
    final hits = targetWordIndexes(cue, [widget.clip.target.en]);
    final spans = <InlineSpan>[];
    for (var i = 0; i < cue.words.length; i++) {
      if (i > 0) spans.add(const TextSpan(text: ' '));
      spans.add(
        TextSpan(
          text: cue.words[i].w,
          style: hits.contains(i)
              ? const TextStyle(
                  color: AppPalette.lighthouseYellow,
                  fontWeight: AppFonts.bold,
                )
              : null,
        ),
      );
    }
    if (spans.isEmpty) spans.add(TextSpan(text: cue.text));
    return Semantics(
      button: true,
      label: '${cue.text}. ${DiscoverTexts.meaningSemantics}',
      excludeSemantics: true,
      child: GestureDetector(
        key: const ValueKey('clip-subtitle'),
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onTap(cue, null),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTouch.min),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.s16,
            vertical: AppSpace.s8,
          ),
          decoration: const BoxDecoration(
            color: AppScrim.captionBox,
            borderRadius: AppRadius.mdAll,
          ),
          alignment: Alignment.center,
          child: Text.rich(
            TextSpan(
              style: AppTypography.subtitle.copyWith(color: AppPalette.white),
              children: spans,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({required this.target});

  final ClipTarget target;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      key: const ValueKey('clip-target'),
      padding: const EdgeInsets.fromLTRB(
        AppSpace.s16,
        AppSpace.s12,
        AppSpace.s16,
        AppSpace.s12,
      ),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CapsLabel(
            target.isWord
                ? DiscoverTexts.targetWord
                : DiscoverTexts.targetPhrase,
          ),
          const SizedBox(height: AppSpace.s4),
          Text(
            target.en,
            style: t.titleMedium?.copyWith(color: AppPalette.seaBlue),
          ),
          Text(
            target.tr,
            style: t.bodyMedium?.copyWith(color: AppPalette.ink500),
          ),
        ],
      ),
    );
  }
}

/// Ortadaki durum: yükleniyor (ilk kare görünür), duraklatıldı (oynat
/// simgesi), bitti ("Tekrar izle" + kaydırma ipucu) ya da hata.
class _CenterState extends StatelessWidget {
  const _CenterState({
    required this.controller,
    required this.failed,
    required this.active,
    required this.onReplay,
    required this.onRetry,
    required this.onTogglePlay,
  });

  final VideoPlayerController? controller;
  final bool failed;
  final bool active;
  final VoidCallback onReplay;
  final VoidCallback onRetry;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    if (failed) {
      return Center(
        child: Container(
          key: const ValueKey('clip-error'),
          padding: const EdgeInsets.all(AppSpace.s16),
          decoration: const BoxDecoration(
            color: AppScrim.captionBox,
            borderRadius: AppRadius.mdAll,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DiscoverTexts.videoError,
                style: t.bodyLarge?.copyWith(color: AppPalette.white),
              ),
              const SizedBox(height: AppSpace.s12),
              FilledButton(
                key: const ValueKey('clip-retry'),
                style: AppButtonStyles.primary(),
                onPressed: onRetry,
                child: const Text(CommonTexts.retry),
              ),
            ],
          ),
        ),
      );
    }
    final c = controller;
    if (c == null || !active) return const SizedBox.shrink();
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: c,
      builder: (context, v, _) {
        final ended =
            v.isCompleted &&
            !v.isPlaying &&
            v.duration > Duration.zero &&
            v.position >= v.duration - const Duration(milliseconds: 300);
        if (ended) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton.icon(
                    key: const ValueKey('clip-replay'),
                    style: AppButtonStyles.primary(),
                    onPressed: onReplay,
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text(DiscoverTexts.replay),
                  ),
                  const SizedBox(height: AppSpace.s12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: AppPalette.white,
                      ),
                      Flexible(
                        child: Text(
                          DiscoverTexts.swipeHint,
                          key: const ValueKey('clip-swipe-hint'),
                          style: t.bodyMedium?.copyWith(
                            color: AppPalette.white,
                            shadows: const [
                              Shadow(color: AppScrim.textShadow, blurRadius: 6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        if (v.isPlaying || !v.isInitialized) return const SizedBox.shrink();
        return IgnorePointer(
          child: Center(
            child: Container(
              key: const ValueKey('clip-paused'),
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppScrim.chip,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: AppIconSize.xl,
                color: AppPalette.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
