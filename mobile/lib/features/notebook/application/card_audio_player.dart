import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../player/application/segment_player_pool.dart';
import '../domain/notebook_item.dart';

/// Kart sesi: karakterin kendi sesi, bölüm segmentinden kelime zamanlarıyla
/// kesilerek çalınır (ek üretim yok; kullanıcı kararı 2026-10-12).
///
/// Ayrı ses paketi eklememek için `video_player` kullanılır. Aynı dosya için
/// denetleyici korunur (aynı kartı tekrar dinlemek hızlıdır).
class CardAudioPlayer extends ChangeNotifier {
  CardAudioPlayer({required this.uriFor, VideoControllerFactory? factory})
    : _factory = factory ?? defaultVideoControllerFactory;

  final Uri Function(String contentId, String path) uriFor;
  final VideoControllerFactory _factory;

  VideoPlayerController? _controller;
  Uri? _uri;
  Timer? _stopTimer;
  String? _playingKey;
  bool _disposed = false;

  /// Şu an çalan kartın anahtarı (`<item>|example` ya da `<item>`).
  String? get playingKey => _playingKey;

  static String keyFor(NotebookItem item, {bool example = false}) =>
      '${item.key}${example ? '|example' : ''}';

  /// Kartın ifadesini ([example] ise örnek cümlenin tamamını) çalar.
  /// Ses yoksa ya da açılamazsa sessizce döner (metin ekranda).
  Future<void> play(
    NotebookItem item, {
    bool example = false,
    double speed = 1.0,
  }) async {
    final clip = example ? (item.exampleAudio ?? item.audio) : item.audio;
    final contentId = item.contentId;
    if (clip == null || contentId == null || _disposed) return;
    final uri = uriFor(contentId, clip.path);
    final key = keyFor(item, example: example);
    _stopTimer?.cancel();
    try {
      final c = await _controllerFor(uri);
      if (c == null || _disposed) return;
      await c.pause();
      if (c.value.playbackSpeed != speed) await c.setPlaybackSpeed(speed);
      await c.seekTo(Duration(microseconds: ((clip.start ?? 0) * 1e6).round()));
      _playingKey = key;
      notifyListeners();
      await c.play();
      final length = clip.isRange
          ? clip.length
          : (c.value.duration > Duration.zero
                ? c.value.duration
                : const Duration(seconds: 3));
      _stopTimer = Timer(
        Duration(milliseconds: (length.inMilliseconds / speed).round() + 80),
        () {
          if (kDebugMode) {
            debugPrint(
              '[H036] kart sesi ${clip.path} ${clip.start ?? 0}–${clip.end ?? '-'} '
              'sn → konum ${c.value.position.inMilliseconds} ms',
            );
          }
          if (identical(_controller, c)) unawaited(c.pause());
          if (_playingKey == key) {
            _playingKey = null;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      debugPrint('[H036] kart sesi çalınamadı: $uri ($e)');
      _playingKey = null;
      notifyListeners();
    }
  }

  Future<VideoPlayerController?> _controllerFor(Uri uri) async {
    if (_controller != null && _uri == uri) return _controller;
    await _release();
    final c = _factory(uri);
    _controller = c;
    _uri = uri;
    await c.initialize().timeout(const Duration(seconds: 10));
    if (!identical(_controller, c)) return null;
    return c;
  }

  Future<void> stop() async {
    _stopTimer?.cancel();
    _playingKey = null;
    try {
      await _controller?.pause();
    } catch (_) {}
    if (!_disposed) notifyListeners();
  }

  Future<void> _release() async {
    final c = _controller;
    _controller = null;
    _uri = null;
    if (c != null) {
      try {
        await c.dispose();
      } catch (_) {}
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _stopTimer?.cancel();
    unawaited(_release());
    super.dispose();
  }
}
