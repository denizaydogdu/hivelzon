import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../player/application/segment_player_pool.dart';

/// Kitap sesi çalar (H-067). Okuyucu bu arayüzle konuşur; testlerde sahtesi
/// verilir. Bugün `video_player` (AVPlayer / ExoPlayer, `m4a`); arka planda
/// ve kilit ekranında dinleme ayrı iştir (H-068: `just_audio` +
/// `audio_service` bu arayüzün arkasına gelir).
abstract interface class BookAudio {
  /// Bölüm sesini açar (öncekini kapatır). Açılamazsa hata fırlatır.
  Future<void> open(Uri uri);

  /// Açık sesin adresi.
  Uri? get uri;

  Future<void> play();

  Future<void> pause();

  /// Saniye (bölüm sesinin başına göre).
  Future<void> seek(double seconds);

  Future<void> setSpeed(double speed);

  /// Çaların o anki konumu (sn), platformdan taze okunur.
  Future<double> position();

  /// Ses sonuna geldi mi.
  bool get isCompleted;

  /// Süre (sn); bilinmiyorsa null.
  double? get duration;

  Future<void> dispose();
}

/// `video_player` ile kitap sesi. Platformun bildirdiği konum ~500 ms'de bir
/// güncellenir; okuyucu bu yüzden [position] ile sık örnek alır ve aradaki
/// zamanı saatle tamamlar (vurgu kayması ≤ 0,2 sn).
class VideoPlayerBookAudio implements BookAudio {
  VideoPlayerBookAudio({VideoControllerFactory? factory})
    : _factory = factory ?? defaultVideoControllerFactory;

  final VideoControllerFactory _factory;
  VideoPlayerController? _c;
  Uri? _uri;

  @override
  Uri? get uri => _uri;

  @override
  Future<void> open(Uri uri) async {
    if (_c != null && _uri == uri) return;
    await _release();
    final c = _factory(uri);
    _c = c;
    _uri = uri;
    await c.initialize().timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> play() async => _c?.play();

  @override
  Future<void> pause() async => _c?.pause();

  @override
  Future<void> seek(double seconds) async => _c?.seekTo(
    Duration(microseconds: (seconds * 1e6).round().clamp(0, 1 << 40)),
  );

  @override
  Future<void> setSpeed(double speed) async {
    final c = _c;
    if (c != null && c.value.playbackSpeed != speed) {
      await c.setPlaybackSpeed(speed);
    }
  }

  @override
  Future<double> position() async {
    final c = _c;
    if (c == null) return 0;
    final p = await c.position ?? c.value.position;
    return p.inMicroseconds / 1e6;
  }

  @override
  bool get isCompleted => _c?.value.isCompleted ?? false;

  @override
  double? get duration {
    final d = _c?.value.duration;
    return d == null || d == Duration.zero ? null : d.inMicroseconds / 1e6;
  }

  Future<void> _release() async {
    final c = _c;
    _c = null;
    _uri = null;
    if (c != null) {
      try {
        await c.dispose();
      } on Object catch (e) {
        debugPrint('[H067] ses kapatılamadı: $e');
      }
    }
  }

  @override
  Future<void> dispose() => _release();
}
