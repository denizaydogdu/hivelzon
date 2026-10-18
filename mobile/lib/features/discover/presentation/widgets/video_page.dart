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
import '../../domain/feed_video.dart';

/// Keşfet'te tek video (H-040 klip; H-094 günlük set): tam ekran video, üstte
/// kategori/bölüm rozeti ve başlık, sağda Kaydet · Anlam · Tam hikâye, altta
/// dilbilgisi etiketi, altyazı (dokununca anlam paneli) ve videonun ifadesi.
///
/// Aynı sayfa hem hikâye klibini hem bağımsız reeli çizer ([FeedVideo]): kaynak
/// türü yalnızca rozette, anahtar öneklerinde ve "Tam hikâye" düğmesinde
/// görünür. Bağımsız reellde gerçek bölüm bağı yoksa düğme çizilmez (plan
/// §6.3); bölüm kilidi ve spoiler koruması kliplerde kalır (§4).
///
/// Video bitince kendiliğinden sonrakine geçmez (K-32): "Tekrar izle" ve
/// "Sonraki için yukarı kaydır." görünür.
class VideoPage extends StatelessWidget {
  const VideoPage({
    super.key,
    required this.video,
    required this.ordinal,
    required this.total,
    required this.cache,
    required this.active,
    required this.muted,
    required this.saved,
    required this.topInset,
    required this.onTogglePlay,
    required this.onReplay,
    required this.onToggleMute,
    required this.onSave,
    required this.onMeaning,
    required this.onFullStory,
    required this.onGrammar,
    required this.onRetry,
  });

  final FeedVideo video;
  final int ordinal;
  final int total;
  final ClipControllerCache cache;

  /// Ekrandaki video mu (altyazı saati yalnızca onda çalışır).
  final bool active;
  final bool muted;

  /// Videonun ifadesi defterde mi?
  final bool saved;

  /// Üst güvenli alan: başlık şeridi (çipler) varsa 0 gelir.
  final double topInset;
  final VoidCallback onTogglePlay;
  final VoidCallback onReplay;
  final VoidCallback onToggleMute;
  final VoidCallback onSave;

  /// Altyazı satırı (yoksa hedefin satırı) ve dokunulan kelime.
  final void Function(SubtitleCue cue, int? word) onMeaning;

  /// "Tam hikâye": yalnızca [FeedVideo.episodeId] varsa çizilir.
  final VoidCallback onFullStory;
  final VoidCallback? onGrammar;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final prefix = video.keyPrefix;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Semantics(
        key: ValueKey('$prefix-page-${video.id}'),
        container: true,
        label: video.isReel
            ? DiscoverTexts.reelSemantics(ordinal, total, video.titleTr)
            : DiscoverTexts.clipSemantics(ordinal, total, video.titleTr),
        child: ColoredBox(
          color: AppScrim.playerBackground,
          child: LayoutBuilder(
            builder: (context, box) {
              // Kısa ekran (küçük telefon ya da büyük yazı): alt bölüm kısalır.
              // Altyazı satırı her zaman kalır (uygulama içi altyazı); ifade
              // kartı yer yoksa çizilmez, ifade "Anlam" panelinden okunur.
              final room = box.maxHeight;
              // Kısa ekranda alt bölümün aralıkları daralır.
              final tight = room < _kTargetCardRoom;
              return Stack(
                fit: StackFit.expand,
                children: [
                  _Poster(uri: video.posterUri),
                  ListenableBuilder(
                    listenable: cache,
                    builder: (context, _) {
                      final c = cache.ready(video.cacheKey);
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
                        key: ValueKey('$prefix-play-toggle'),
                        behavior: HitTestBehavior.opaque,
                        onTap: onTogglePlay,
                      ),
                    ),
                  ),
                  ListenableBuilder(
                    listenable: cache,
                    builder: (context, _) => _CenterState(
                      controller: cache.ready(video.cacheKey),
                      failed: cache.failed(video.cacheKey),
                      active: active,
                      prefix: prefix,
                      // Sıradaki sayfa kısa soruysa ipucu onu söyler (K-32).
                      hint: video.isReel && video.practice != null
                          ? DiscoverTexts.practiceSwipeHint
                          : video.isReel
                          ? DiscoverTexts.reelSwipeHint
                          : DiscoverTexts.swipeHint,
                      onReplay: onReplay,
                      onRetry: onRetry,
                      onTogglePlay: onTogglePlay,
                    ),
                  ),
                  Positioned(
                    left: AppSpace.s16,
                    right: AppSpace.s16,
                    top: topInset + AppSpace.s12,
                    child: _TopBar(
                      video: video,
                      muted: muted,
                      onMute: onToggleMute,
                    ),
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
                            video: video,
                            tight: tight,
                            onSave: onSave,
                            onMeaning: () {
                              final cue = video.targetCue;
                              if (cue != null) onMeaning(cue, null);
                            },
                            onFullStory: video.episodeId == null
                                ? null
                                : onFullStory,
                          ),
                        ),
                        SizedBox(height: tight ? AppSpace.s8 : AppSpace.s12),
                        if (video.grammarTitle != null &&
                            onGrammar != null) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _GrammarChip(
                              prefix: prefix,
                              // Dersin kısa adı: "can / can't: yetenek…" → "can / can't".
                              title: video.grammarTitle!
                                  .split(':')
                                  .first
                                  .trim(),
                              onTap: onGrammar!,
                            ),
                          ),
                          SizedBox(height: tight ? AppSpace.s4 : AppSpace.s8),
                        ],
                        ListenableBuilder(
                          listenable: cache,
                          builder: (context, _) => _CueLine(
                            video: video,
                            controller: cache.ready(video.cacheKey),
                            active: active,
                            tight: tight,
                            onTap: onMeaning,
                          ),
                        ),
                        if (room >= _kTargetCardRoom) ...[
                          const SizedBox(height: AppSpace.s8),
                          _TargetCard(
                            prefix: prefix,
                            target: video.target,
                            isReel: video.isReel,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// İfade kartı (ifadenin İngilizcesi + çevirisi) yalnızca bu yükseklikten
/// itibaren çizilir; kısa ekranda yer kalmıyor (yerleşim taşmasın diye).
const double _kTargetCardRoom = 600;

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

/// Üst/alt karartma şeritleri. Yükseklikler kısa ekranda küçülür (sabit
/// 140 + 320 piksel küçük ekranda taşar).
class _Scrims extends StatelessWidget {
  const _Scrims();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: LayoutBuilder(
      builder: (context, box) {
        final h = box.maxHeight;
        final top = h * 0.28 < 140 ? h * 0.28 : 140.0;
        final bottom = h * 0.68 < 320 ? h * 0.68 : 320.0;
        return Column(
          children: [
            SizedBox(
              height: top,
              width: double.infinity,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppScrim.chip, Colors.transparent],
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: bottom,
              width: double.infinity,
              child: const DecoratedBox(
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
        );
      },
    ),
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.video,
    required this.muted,
    required this.onMute,
  });

  final FeedVideo video;
  final bool muted;
  final VoidCallback onMute;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final badge = video.badge;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (badge != null || video.isRepeat)
                Wrap(
                  spacing: AppSpace.s8,
                  runSpacing: AppSpace.s8,
                  children: [
                    if (badge != null)
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
                          badge,
                          style: t.labelLarge?.copyWith(color: AppPalette.ink),
                        ),
                      ),
                    // Kontrollü tekrar (H-094 §4.5): video daha önce gösterildi.
                    if (video.isRepeat)
                      Semantics(
                        label: DiscoverTexts.reelRepeatSemantics,
                        excludeSemantics: true,
                        child: Container(
                          key: ValueKey('${video.keyPrefix}-repeat'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpace.s12,
                            vertical: AppSpace.s4,
                          ),
                          decoration: BoxDecoration(
                            color: AppPalette.white.withValues(alpha: 0.16),
                            border: Border.all(
                              color: AppPalette.white.withValues(alpha: 0.56),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(AppRadius.full),
                            ),
                          ),
                          child: Text(
                            DiscoverTexts.reelRepeatBadge,
                            style: t.labelLarge?.copyWith(
                              color: AppPalette.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: AppSpace.s8),
              Semantics(
                header: true,
                child: Text(
                  video.titleTr,
                  key: ValueKey('${video.keyPrefix}-title'),
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
          key: ValueKey('${video.keyPrefix}-mute'),
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
    required this.video,
    required this.onSave,
    required this.onMeaning,
    required this.onFullStory,
    this.tight = false,
  });

  final bool saved;
  final FeedVideo video;

  /// Kısa ekranda aralıklar daralır.
  final bool tight;
  final VoidCallback onSave;
  final VoidCallback onMeaning;

  /// `null` ise "Tam hikâye" çizilmez (gerçek bölüm bağı yok; plan §6.3).
  final VoidCallback? onFullStory;

  @override
  Widget build(BuildContext context) {
    Widget action(
      String key,
      IconData icon,
      String label,
      String semantics,
      VoidCallback onTap,
    ) => Padding(
      padding: EdgeInsets.only(top: tight ? AppSpace.s4 : AppSpace.s8),
      child: Semantics(
        button: true,
        label: semantics,
        excludeSemantics: true,
        child: GestureDetector(
          key: ValueKey('${video.keyPrefix}-$key'),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          'save',
          saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          saved ? DiscoverTexts.saved : DiscoverTexts.save,
          saved
              ? DiscoverTexts.savedSemantics(video.target.en)
              : DiscoverTexts.saveSemantics(video.target.en),
          onSave,
        ),
        action(
          'meaning',
          Icons.menu_book_rounded,
          DiscoverTexts.meaning,
          DiscoverTexts.meaningSemantics,
          onMeaning,
        ),
        if (onFullStory != null)
          action(
            'full-story',
            Icons.movie_outlined,
            DiscoverTexts.fullStory,
            DiscoverTexts.fullStorySemantics(video.episodeNumber),
            onFullStory!,
          ),
      ],
    );
  }
}

class _GrammarChip extends StatelessWidget {
  const _GrammarChip({
    required this.prefix,
    required this.title,
    required this.onTap,
  });

  final String prefix;
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
            key: ValueKey('$prefix-grammar'),
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
    required this.video,
    required this.controller,
    required this.active,
    required this.onTap,
    this.tight = false,
  });

  final FeedVideo video;
  final VideoPlayerController? controller;
  final bool active;

  /// Kısa ekranda dikey iç boşluk daralır (en az dokunma yüksekliği korunur).
  final bool tight;
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
    final cue = widget.video.subtitles.cueAt(t);
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
    final hits = targetWordIndexes(cue, [widget.video.target.en]);
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
        key: ValueKey('${widget.video.keyPrefix}-subtitle'),
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onTap(cue, null),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTouch.min),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpace.s16,
            vertical: widget.tight ? AppSpace.s4 : AppSpace.s8,
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
  const _TargetCard({
    required this.prefix,
    required this.target,
    required this.isReel,
  });

  final String prefix;
  final ClipTarget target;

  /// Bağımsız reelde "klip" denmez.
  final bool isReel;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      key: ValueKey('$prefix-target'),
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
                ? (isReel
                      ? DiscoverTexts.reelTargetWord
                      : DiscoverTexts.targetWord)
                : (isReel
                      ? DiscoverTexts.reelTargetPhrase
                      : DiscoverTexts.targetPhrase),
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
    required this.prefix,
    required this.hint,
    required this.onReplay,
    required this.onRetry,
    required this.onTogglePlay,
  });

  final VideoPlayerController? controller;
  final bool failed;
  final bool active;

  /// Anahtar öneki (`clip` | `reel`).
  final String prefix;

  /// Bitti durumundaki ipucu: sıradaki sayfa klip, video ya da kısa soru.
  final String hint;
  final VoidCallback onReplay;
  final VoidCallback onRetry;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    if (failed) {
      return Center(
        child: Container(
          key: ValueKey('$prefix-error'),
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
                key: ValueKey('$prefix-retry'),
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
                    key: ValueKey('$prefix-replay'),
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
                          hint,
                          key: ValueKey('$prefix-swipe-hint'),
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
              key: ValueKey('$prefix-paused'),
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
