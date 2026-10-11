import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import 'segment_player_pool.dart';

/// Kısa sesler (Hi balonu, seçenek, görev dinleme) için tek kanallı çalar.
///
/// Ayrı bir ses paketi eklememek için `video_player` kullanılır (AVPlayer /
/// ExoPlayer `m4a` çalar). Aynı anda tek ses çalar; yenisi eskisini durdurur.
class ClipAudioPlayer extends ChangeNotifier {
  ClipAudioPlayer({VideoControllerFactory? factory})
    : _factory = factory ?? defaultVideoControllerFactory;

  final VideoControllerFactory _factory;
  VideoPlayerController? _controller;
  Uri? _uri;
  bool _disposed = false;

  /// Şu an çalan sesin adresi (çalmıyorsa null).
  Uri? get playingUri => (_controller?.value.isPlaying ?? false) ? _uri : null;

  Future<void> play(Uri uri) async {
    await stop();
    if (_disposed) return;
    final c = _factory(uri);
    _controller = c;
    _uri = uri;
    c.addListener(notifyListeners);
    try {
      await c.initialize().timeout(const Duration(seconds: 10));
      if (!identical(_controller, c) || _disposed) return;
      await c.play();
    } catch (e) {
      // Ses çalınamazsa metin zaten ekranda; oynatıcı durmaz.
      debugPrint('[H031] ses çalınamadı: $uri ($e)');
      if (identical(_controller, c)) await stop();
    }
  }

  Future<void> stop() async {
    final c = _controller;
    _controller = null;
    _uri = null;
    if (c != null) {
      c.removeListener(notifyListeners);
      try {
        await c.dispose();
      } catch (_) {}
    }
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(stop());
    super.dispose();
  }
}
