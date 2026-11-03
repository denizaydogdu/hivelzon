// Hi'nin Türkçe sesi için "Dinle" düğmesi (H-083): not, konu kartı, yan görev;
// Konuş görevlerinde Hi'nin yönlendirmeleri (H-104); kitapta "Sayfanın
// Türkçesi" (H-105, `bookId` ile kitap paketinden).
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
  const HiListenButton({
    super.key,
    required this.path,
    this.label = HiTexts.listen,
    this.filled = true,
    this.bookId,
    this.beforePlay,
    this.stopOn,
    this.shouldStop,
  });

  /// Sezon paketine göre yol (ör. `hi/note-be-dropped.m4a`); `bookId`
  /// verilirse kitap paketine göre (ör. `audio/tr/p01.m4a`).
  final String path;

  /// Kitap sesi (H-105): yol bu kitabın paketinden çözülür.
  final String? bookId;

  /// Çalmadan hemen önce (ör. kitabın İngilizce anlatımını duraklat):
  /// iki ses aynı anda çalmaz.
  final Future<void> Function()? beforePlay;

  /// Bu dinlenen değiştiğinde `shouldStop` doğruysa ses durur (ör. İngilizce
  /// anlatım yeniden başladı).
  final Listenable? stopOn;
  final bool Function()? shouldStop;

  /// Ekran okuyucu etiketi ve ipucu (çalarken "Durdur").
  final String label;

  /// Sarı zeminli (Hi kartları) ya da sade simge (Konuş, H-104).
  final bool filled;

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

  void _onStopSignal() {
    if (_playing && (widget.shouldStop?.call() ?? false)) {
      unawaited(_player?.stop());
    }
  }

  @override
  void initState() {
    super.initState();
    widget.stopOn?.addListener(_onStopSignal);
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
    await widget.beforePlay?.call();
    if (!mounted) return;
    final player = _player ??= ClipAudioPlayer(
      factory: ref.read(videoControllerFactoryProvider),
    )..addListener(_onPlayer);
    final source = ref.read(contentSourceProvider);
    final book = widget.bookId;
    final uri = book != null
        ? source.bookMediaUri(book, widget.path)
        : source.seasonMediaUri(kTopicSetSeason, widget.path);
    await player.play(uri);
  }

  @override
  void didUpdateWidget(HiListenButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path || oldWidget.bookId != widget.bookId) {
      unawaited(_player?.stop());
    }
    if (!identical(oldWidget.stopOn, widget.stopOn)) {
      oldWidget.stopOn?.removeListener(_onStopSignal);
      widget.stopOn?.addListener(_onStopSignal);
    }
  }

  @override
  void dispose() {
    widget.stopOn?.removeListener(_onStopSignal);
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
      semanticLabel: playing ? HiTexts.listenStop : widget.label,
      playing: playing,
      filled: widget.filled,
    );
  }
}
