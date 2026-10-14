import 'dart:async';

import 'package:hivelzon/features/library/application/background_book_audio.dart';
import 'package:hivelzon/features/library/application/book_media_session.dart';

import 'fake_book_audio.dart';

/// Sahte `just_audio` motoru (H-068): konum = başlangıç + geçen süre × hız
/// ([ReaderTestClock]). [durations]: ses süresi (adresin sonuna göre).
class FakeAudioEngine implements BookAudioEngine {
  FakeAudioEngine(this.clock, {this.durations = const {}});

  final ReaderTestClock clock;
  final Map<String, double> durations;
  bool failLoad = false;

  final List<Uri> loaded = [];
  final List<double> seeks = [];
  final List<double> speeds = [];
  int plays = 0;
  int pauses = 0;
  bool disposed = false;

  Uri? _uri;
  bool _playing = false;
  double _base = 0;
  double _startedAt = 0;
  double _speed = 1;

  bool get playing => _playing;

  double? get _duration {
    final u = _uri?.toString();
    if (u == null) return null;
    for (final e in durations.entries) {
      if (u.endsWith(e.key)) return e.value;
    }
    return null;
  }

  @override
  double get position {
    final p = _playing ? _base + (clock() - _startedAt) * _speed : _base;
    final d = _duration;
    return d != null && p > d ? d : p;
  }

  @override
  bool get completed {
    final d = _duration;
    return d != null && position >= d;
  }

  @override
  Future<double?> load(Uri uri) async {
    if (failLoad) throw StateError('açılamadı');
    _uri = uri;
    loaded.add(uri);
    _playing = false;
    _base = 0;
    return _duration;
  }

  @override
  Future<void> play() async {
    _base = position;
    _startedAt = clock();
    _playing = true;
    plays++;
  }

  @override
  Future<void> pause() async {
    _base = position;
    _playing = false;
    pauses++;
  }

  @override
  Future<void> seek(double seconds) async {
    seeks.add(seconds);
    _base = seconds;
    _startedAt = clock();
  }

  @override
  Future<void> setSpeed(double speed) async {
    _base = position;
    _startedAt = clock();
    _speed = speed;
    speeds.add(speed);
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    _playing = false;
  }
}

/// Kilit ekranına giden son durum.
class FakeSessionState {
  const FakeSessionState(
    this.owner, {
    required this.playing,
    required this.position,
    required this.speed,
    required this.hasNextChapter,
  });

  final Object owner;
  final bool playing;
  final double position;
  final double speed;
  final bool hasNextChapter;
}

/// Sahte oturum ev sahibi (`audio_service` + `audio_session` yerine):
/// gönderilen künye ve durumları kaydeder; [press] kilit ekranı düğmesine
/// basar.
class FakeSessionHost implements BookSessionHost {
  final _commands = StreamController<BookRemoteCommand>.broadcast(sync: true);

  Object? _owner;
  int prepares = 0;
  final List<(BookMediaInfo, double?)> items = [];
  final List<FakeSessionState> states = [];
  final List<Object> releases = [];

  /// Oturum açık mı (künye var, kapatılmadı).
  bool get active => _owner != null;

  @override
  Object? get owner => _owner;

  @override
  Stream<BookRemoteCommand> get commands => _commands.stream;

  /// Kilit ekranından / bildirimden komut.
  void press(BookRemoteCommand c) => _commands.add(c);

  @override
  Future<void> prepare() async => prepares++;

  @override
  Future<void> setItem(
    Object owner,
    BookMediaInfo info,
    double? duration,
  ) async {
    _owner = owner;
    items.add((info, duration));
  }

  @override
  Future<void> setState(
    Object owner, {
    required bool playing,
    required double position,
    required double speed,
    required bool hasNextChapter,
  }) async {
    if (!identical(owner, _owner)) return;
    states.add(
      FakeSessionState(
        owner,
        playing: playing,
        position: position,
        speed: speed,
        hasNextChapter: hasNextChapter,
      ),
    );
  }

  @override
  Future<void> release(Object owner) async {
    if (!identical(owner, _owner)) return;
    _owner = null;
    releases.add(owner);
  }

  Future<void> close() => _commands.close();
}
