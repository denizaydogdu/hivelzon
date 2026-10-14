import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'book_audio.dart';
import 'book_media_session.dart';

/// Çalar motoru: `just_audio`'nun okuyucuya gereken ince yüzü. Testlerde
/// sahtesi verilir.
abstract interface class BookAudioEngine {
  /// Sesi yükler; süreyi (sn) döner, bilinmiyorsa null. Açılamazsa fırlatır.
  Future<double?> load(Uri uri);

  /// Çalmayı başlatır ve hemen döner.
  Future<void> play();

  Future<void> pause();

  Future<void> seek(double seconds);

  Future<void> setSpeed(double speed);

  /// Çaların o anki konumu (sn).
  double get position;

  /// Ses sonuna geldi mi.
  bool get completed;

  Future<void> dispose();
}

/// Kilit ekranı / bildirim oturumunun ev sahibi (uygulamada tek;
/// `audio_service` + `audio_session`). Testlerde sahtesi verilir.
///
/// Aynı anda bir **sahip** vardır: künyeyi son gönderen ses. Komutlar
/// yalnız sahibe gider; sahibi olmayanın durumu ve bırakması yok sayılır
/// (eski okuyucu yenisinin oturumunu kapatamaz).
abstract interface class BookSessionHost {
  Object? get owner;

  /// Komutlar (bütün sahiplere; ses kendi sahipliğine göre süzer).
  Stream<BookRemoteCommand> get commands;

  /// Çalmadan önce: ses oturumu (iOS `playback` kategorisi, Android ses
  /// odağı). Başarısız olursa ses yine çalar, yalnız arka plan garantisi
  /// olmaz.
  Future<void> prepare();

  /// Künyeyi gösterir ve oturumu [owner]'a verir.
  Future<void> setItem(Object owner, BookMediaInfo info, double? duration);

  /// Kilit ekranındaki düğme ve konum.
  Future<void> setState(
    Object owner, {
    required bool playing,
    required double position,
    required double speed,
    required bool hasNextChapter,
  });

  /// Oturum kapanır (bildirim kalkar, ses odağı bırakılır); yalnız sahip.
  Future<void> release(Object owner);
}

/// Arka planda ve kilit ekranında çalan kitap sesi (H-068).
///
/// [BookAudio] arayüzünün (okuyucu mantığı ve testleri aynı kalır) arkasında
/// `just_audio` ([BookAudioEngine]) ve `audio_service` ([BookSessionHost])
/// durur. Okuyucu sesin tek sahibidir: kilit ekranı komutları
/// [commands] ile okuyucuya gider, okuyucu da bu sesi çalar/duraklatır.
///
/// **Duraklama gecikmesi:** bölüm geçişinde okuyucu sesi bir an duraklatıp
/// sıradakini açar. Android'de bildirime "duraklatıldı" gitmesi ön plan
/// hizmetini düşürür, arka planda yeniden başlatmak yasaktır (Android 12+).
/// Bu yüzden duraklama bildirime [pauseStateDelay] sonra yansır; arada
/// yeniden çalarsa hiç yansımaz. Kilit ekranından gelen duraklatma hemen
/// yansır.
class BackgroundBookAudio implements BookAudio, BookMediaSession {
  BackgroundBookAudio({
    required BookAudioEngine engine,
    required BookSessionHost host,
    this.pauseStateDelay = const Duration(milliseconds: 800),
  }) : _engine = engine,
       _host = host;

  final BookAudioEngine _engine;
  final BookSessionHost _host;
  final Duration pauseStateDelay;

  Uri? _uri;
  double? _duration;
  bool _playing = false;
  double _speed = 1;
  BookMediaInfo? _info;
  bool _disposed = false;
  bool _pauseNow = false;
  Timer? _pauseTimer;

  @visibleForTesting
  bool get disposed => _disposed;

  // ------------------------------------------------------------ BookAudio

  @override
  Uri? get uri => _uri;

  @override
  double? get duration => _duration;

  @override
  bool get isCompleted => _uri != null && _engine.completed;

  @override
  Future<void> open(Uri uri) async {
    if (_disposed) throw StateError('ses kapatıldı');
    if (_uri == uri) return;
    _uri = null;
    _duration = null;
    _playing = false;
    final d = await _engine.load(uri).timeout(const Duration(seconds: 10));
    _uri = uri;
    _duration = d;
    final info = _info;
    if (info != null) await _sendItem(info);
  }

  @override
  Future<void> play() async {
    if (_disposed || _uri == null) return;
    _pauseTimer?.cancel();
    _pauseTimer = null;
    _pauseNow = false;
    _playing = true;
    try {
      await _host.prepare();
    } on Object catch (e) {
      debugPrint('[H068] ses oturumu hazırlanamadı: $e');
    }
    if (_disposed || !_playing) return;
    await _engine.play();
    await _sendState();
  }

  @override
  Future<void> pause() async {
    if (_disposed) return;
    _playing = false;
    await _engine.pause();
    _pauseTimer?.cancel();
    if (_pauseNow || pauseStateDelay == Duration.zero) {
      _pauseNow = false;
      _pauseTimer = null;
      await _sendState();
    } else {
      _pauseTimer = Timer(pauseStateDelay, () {
        _pauseTimer = null;
        if (!_playing) unawaited(_sendState());
      });
    }
  }

  @override
  Future<void> seek(double seconds) async {
    if (_disposed) return;
    await _engine.seek(seconds < 0 ? 0 : seconds);
    if (_playing) await _sendState();
  }

  @override
  Future<void> setSpeed(double speed) async {
    if (_disposed || speed == _speed) return;
    _speed = speed;
    await _engine.setSpeed(speed);
    if (_playing) await _sendState();
  }

  @override
  Future<double> position() async => _uri == null ? 0 : _engine.position;

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _playing = false;
    _pauseTimer?.cancel();
    _pauseTimer = null;
    try {
      await _engine.dispose();
    } on Object catch (e) {
      debugPrint('[H068] çalar kapatılamadı: $e');
    }
    try {
      await _host.release(this);
    } on Object catch (e) {
      debugPrint('[H068] oturum kapatılamadı: $e');
    }
  }

  // ------------------------------------------------------------ oturum

  @override
  Stream<BookRemoteCommand> get commands => _host.commands
      .where((_) => !_disposed && identical(_host.owner, this))
      .map((c) {
        // Kilit ekranından duraklatma bildirime hemen yansır.
        if (c == BookRemoteCommand.pause || c == BookRemoteCommand.stop) {
          _pauseNow = true;
        }
        return c;
      });

  @override
  Future<void> setMediaInfo(BookMediaInfo info) async {
    if (_disposed || info == _info) return;
    _info = info;
    if (_uri != null) await _sendItem(info);
  }

  Future<void> _sendItem(BookMediaInfo info) async {
    try {
      await _host.setItem(this, info, _duration);
      await _sendState();
    } on Object catch (e) {
      debugPrint('[H068] künye gönderilemedi: $e');
    }
  }

  Future<void> _sendState() async {
    if (_disposed || !identical(_host.owner, this)) return;
    try {
      await _host.setState(
        this,
        playing: _playing,
        position: _engine.position,
        speed: _speed,
        hasNextChapter: _info?.hasNextChapter ?? false,
      );
    } on Object catch (e) {
      debugPrint('[H068] oturum durumu gönderilemedi: $e');
    }
  }
}

/// `just_audio` çaları. Kesintileri (arama, kulaklık) çalar değil oturum
/// ev sahibi yakalar ve okuyucuya komut olarak iletir; çalar kendi başına
/// duraklayıp sürmez (okuyucunun saati kaymasın).
class JustAudioEngine implements BookAudioEngine {
  JustAudioEngine() : _p = AudioPlayer(handleInterruptions: false);

  final AudioPlayer _p;

  @override
  Future<double?> load(Uri uri) async {
    final d = await _p.setAudioSource(AudioSource.uri(uri));
    return d == null || d == Duration.zero ? null : d.inMicroseconds / 1e6;
  }

  @override
  Future<void> play() async {
    // `play()` çalma bitince ya da duraklayınca tamamlanır; beklenmez.
    unawaited(
      _p.play().catchError((Object e) {
        debugPrint('[H068] çalınamadı: $e');
      }),
    );
  }

  @override
  Future<void> pause() => _p.pause();

  @override
  Future<void> seek(double seconds) =>
      _p.seek(Duration(microseconds: (seconds * 1e6).round()));

  @override
  Future<void> setSpeed(double speed) => _p.setSpeed(speed);

  @override
  double get position => _p.position.inMicroseconds / 1e6;

  @override
  bool get completed => _p.processingState == ProcessingState.completed;

  @override
  Future<void> dispose() async {
    try {
      await _p.stop();
    } finally {
      await _p.dispose();
    }
  }
}
