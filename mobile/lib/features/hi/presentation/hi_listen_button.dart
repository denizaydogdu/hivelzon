// Hi'nin Türkçe sesi için "Dinle" düğmesi (H-083): not, konu kartı, yan görev.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../player/application/clip_audio_player.dart';
import '../../player/presentation/player_screen.dart'
    show videoControllerFactoryProvider;
import '../../player/presentation/widgets/player_ui.dart';
import '../../topic_sets/application/topic_set_providers.dart';

/// Sezon paketindeki bir Hi sesini çalar. Kendiliğinden çalmaz; yalnız
/// dokununca. Çalarken dokunmak durdurur. Kart ya da sayfa kapanınca
/// (widget atılınca) ses durur ve çalar bırakılır. Aynı anda tek Hi sesi:
/// yenisi başlayınca öncekini durdurur.
class HiListenButton extends ConsumerStatefulWidget {
  const HiListenButton({super.key, required this.path});

  /// Sezon paketine göre yol (ör. `hi/note-be-dropped.m4a`).
  final String path;

  @override
  ConsumerState<HiListenButton> createState() => _HiListenButtonState();
}

class _HiListenButtonState extends ConsumerState<HiListenButton> {
  /// Şu an çalan düğme (aynı anda tek Hi sesi).
  static _HiListenButtonState? _active;

  ClipAudioPlayer? _player;

  bool get _playing => _player?.playingUri != null;

  void _onPlayer() {
    if (mounted) setState(() {});
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player?.stop();
      return;
    }
    final other = _active;
    if (other != null && !identical(other, this)) {
      unawaited(other._player?.stop());
    }
    _active = this;
    final player = _player ??= ClipAudioPlayer(
      factory: ref.read(videoControllerFactoryProvider),
    )..addListener(_onPlayer);
    final uri = ref
        .read(contentSourceProvider)
        .seasonMediaUri(kTopicSetSeason, widget.path);
    await player.play(uri);
  }

  @override
  void didUpdateWidget(HiListenButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) unawaited(_player?.stop());
  }

  @override
  void dispose() {
    if (identical(_active, this)) _active = null;
    _player
      ?..removeListener(_onPlayer)
      ..dispose();
    _player = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playing = _playing;
    return ListenButton(
      key: const ValueKey('hi-listen'),
      onPressed: () => unawaited(_toggle()),
      semanticLabel: playing ? HiTexts.listenStop : HiTexts.listen,
      playing: playing,
    );
  }
}
