import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../app/design/tokens.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../player/application/segment_player_pool.dart';
import '../../player/presentation/player_screen.dart';

/// Sezon jeneriği (tam sürüm, ~10 sn; H-049/H-050). Tam ekran, dokunma
/// gerekmez; bitince kapanır. "Geç" ile her an atlanabilir.
class SeasonIntroScreen extends ConsumerStatefulWidget {
  const SeasonIntroScreen({super.key, required this.season});

  final int season;

  @override
  ConsumerState<SeasonIntroScreen> createState() => _SeasonIntroScreenState();
}

class _SeasonIntroScreenState extends ConsumerState<SeasonIntroScreen> {
  VideoPlayerController? _controller;
  SeasonInfo? _info;
  String? _error;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    final source = ref.read(contentSourceProvider);
    try {
      final info = await source.loadSeason(widget.season);
      final video = info.introVideo;
      if (video == null) throw ContentUnavailableException('jenerik yok');
      final factory =
          ref.read(videoControllerFactoryProvider) ??
          defaultVideoControllerFactory;
      final c = factory(source.seasonMediaUri(widget.season, video));
      if (!mounted) {
        unawaited(c.dispose());
        return;
      }
      setState(() {
        _info = info;
        _controller = c;
      });
      c.addListener(_onTick);
      await c.initialize().timeout(const Duration(seconds: 15));
      if (!mounted) return;
      setState(() {});
      await c.play();
      debugPrint('[H050] jenerik oynuyor (sezon ${widget.season})');
    } on Object catch (e) {
      debugPrint('[H050] jenerik açılamadı: $e');
      if (mounted) setState(() => _error = SeasonIntroTexts.error);
    }
  }

  void _onTick() {
    final c = _controller;
    if (c == null) return;
    final v = c.value;
    if (v.isCompleted &&
        v.duration > Duration.zero &&
        v.position >= v.duration - const Duration(milliseconds: 250)) {
      _close();
    }
  }

  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    debugPrint('[H050] jenerik kapandı');
    unawaited(_controller?.pause());
    // Yalnızca jenerik en üstteyken kapatılır; başka sayfayı asla kapatmaz.
    if (ModalRoute.of(context)?.isCurrent == false) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/hikaye');
    }
  }

  @override
  void dispose() {
    final c = _controller;
    c?.removeListener(_onTick);
    // Bir kare sonra at: ekrandaki VideoPlayer o sırada sökülmüş olur.
    if (c != null) {
      // Bitişte eklenti pause().then(seekTo) çağırır; erken atma hata verir.
      Future<void>.delayed(const Duration(milliseconds: 600), c.dispose);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final ready = c != null && c.value.isInitialized;
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: AppPalette.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (ready)
            ExcludeSemantics(
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: c.value.size.width == 0 ? 1080 : c.value.size.width,
                  height: c.value.size.height == 0 ? 1920 : c.value.size.height,
                  child: VideoPlayer(c),
                ),
              ),
            )
          else if (_error == null)
            const Center(
              child: CircularProgressIndicator(
                color: AppPalette.lighthouseYellow,
              ),
            ),
          // Ekran okuyucu için jeneriğin adı (videoda gömülü yazı var).
          Semantics(
            key: const ValueKey('season-intro'),
            label: SeasonIntroTexts.semantics(widget.season, _info?.title),
            liveRegion: true,
            child: const SizedBox.expand(),
          ),
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.s24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      color: AppPalette.white,
                      size: AppIconSize.xl,
                    ),
                    const SizedBox(height: AppSpace.s16),
                    Text(
                      _error!,
                      key: const ValueKey('season-intro-error'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppPalette.white,
                      ),
                    ),
                    const SizedBox(height: AppSpace.s16),
                    FilledButton(
                      key: const ValueKey('season-intro-back'),
                      onPressed: _close,
                      child: const Text(SeasonIntroTexts.goBack),
                    ),
                  ],
                ),
              ),
            ),
          // Yapay zekâ etiketi (§5.6): uygulama içi jenerikte gömülü değil.
          Positioned(
            left: AppSpace.s16,
            top: media.padding.top + AppSpace.s16,
            child: IgnorePointer(
              child: AiNotice(text: _info?.aiLabel ?? SeasonIntroTexts.aiLabel),
            ),
          ),
          Positioned(
            right: AppSpace.s16,
            top: media.padding.top + AppSpace.s8,
            child: Semantics(
              button: true,
              label: SeasonIntroTexts.skipSemantics,
              excludeSemantics: true,
              child: FilledButton.icon(
                key: const ValueKey('season-intro-skip'),
                onPressed: _close,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(88, AppTouch.min),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.s16),
                  backgroundColor: AppScrim.strong,
                  foregroundColor: AppPalette.white,
                ),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.skip_next_rounded),
                label: const Text(SeasonIntroTexts.skip),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
