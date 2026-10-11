import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

/// Test için sahte video platformu. Her kaynak [durationFor] süresinde biter
/// (bitiş sahte zamanlayıcıyla gelir; `tester.pump(süre)` ilerletir).
class FakeVideoPlatform extends VideoPlayerPlatform {
  FakeVideoPlatform({this.durationFor});

  final Duration Function(String uri)? durationFor;
  final Map<int, StreamController<VideoEvent>> _streams = {};
  final Map<int, String> uris = {};
  final Map<int, Duration> _durations = {};
  final Map<int, Timer> _endTimers = {};
  final Map<int, bool> _playing = {};
  final Set<int> disposed = {};
  int _next = 0;

  int get liveCount => uris.length - disposed.length;

  List<String> get liveUris => [
    for (final e in uris.entries)
      if (!disposed.contains(e.key)) e.value,
  ];

  @override
  Future<void> init() async {}

  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async {
    final id = _next++;
    final uri = options.dataSource.uri ?? '';
    uris[id] = uri;
    _durations[id] = durationFor?.call(uri) ?? const Duration(seconds: 2);
    _streams[id] = StreamController<VideoEvent>.broadcast();
    return id;
  }

  @override
  Stream<VideoEvent> videoEventsFor(int playerId) {
    final c = _streams[playerId]!;
    Timer.run(() {
      c.add(
        VideoEvent(
          eventType: VideoEventType.initialized,
          duration: _durations[playerId],
          size: const Size(1080, 1920),
        ),
      );
    });
    return c.stream;
  }

  @override
  Future<void> play(int playerId) async {
    _playing[playerId] = true;
    _endTimers[playerId]?.cancel();
    _endTimers[playerId] = Timer(_durations[playerId]!, () {
      _playing[playerId] = false;
      if (!disposed.contains(playerId)) {
        _streams[playerId]!.add(
          VideoEvent(eventType: VideoEventType.completed),
        );
      }
    });
  }

  @override
  Future<void> pause(int playerId) async {
    _playing[playerId] = false;
    _endTimers[playerId]?.cancel();
  }

  @override
  Future<Duration> getPosition(int playerId) async =>
      (_playing[playerId] ?? false)
      ? const Duration(milliseconds: 40)
      : Duration.zero;

  @override
  Future<void> seekTo(int playerId, Duration position) async {}

  @override
  Future<void> setLooping(int playerId, bool looping) async {}

  @override
  Future<void> setVolume(int playerId, double volume) async {}

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async {}

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) async {}

  @override
  Future<void> dispose(int playerId) async {
    disposed.add(playerId);
    _endTimers[playerId]?.cancel();
    await _streams[playerId]?.close();
  }

  @override
  Widget buildViewWithOptions(VideoViewOptions options) =>
      const SizedBox.expand();
}
