import 'package:hivelzon/features/library/application/book_audio.dart';

/// Elle ilerletilen saat (sn). Okuyucu ve sahte ses aynı saati okur.
class ReaderTestClock {
  double now = 0;

  void advance(double seconds) => now += seconds;

  double call() => now;
}

/// Sahte kitap sesi: çalarken konum = başlangıç + geçen süre × hız
/// ([ReaderTestClock]). [durations]: bölüm sesinin süresi (adresin sonuna göre).
class FakeBookAudio implements BookAudio {
  FakeBookAudio(this.clock, {this.durations = const {}, this.failOpen = false});

  final ReaderTestClock clock;
  final Map<String, double> durations;
  bool failOpen;

  final List<Uri> opened = [];
  final List<double> seeks = [];
  final List<double> speeds = [];
  int plays = 0;
  bool disposed = false;

  Uri? _uri;
  bool _playing = false;
  double _base = 0;
  double _startedAt = 0;
  double _speed = 1;

  bool get playing => _playing;

  @override
  Uri? get uri => _uri;

  @override
  double? get duration {
    final u = _uri?.toString();
    if (u == null) return null;
    for (final e in durations.entries) {
      if (u.endsWith(e.key)) return e.value;
    }
    return null;
  }

  /// Gerçek konum (sn).
  double get truePosition {
    final p = _playing ? _base + (clock() - _startedAt) * _speed : _base;
    final d = duration;
    return d != null && p > d ? d : p;
  }

  @override
  Future<void> open(Uri uri) async {
    if (failOpen) throw StateError('açılamadı');
    if (_uri == uri) return;
    _uri = uri;
    opened.add(uri);
    _playing = false;
    _base = 0;
  }

  @override
  Future<void> play() async {
    _base = truePosition;
    _startedAt = clock();
    _playing = true;
    plays++;
  }

  @override
  Future<void> pause() async {
    _base = truePosition;
    _playing = false;
  }

  @override
  Future<void> seek(double seconds) async {
    seeks.add(seconds);
    _base = seconds;
    _startedAt = clock();
  }

  @override
  Future<void> setSpeed(double speed) async {
    _base = truePosition;
    _startedAt = clock();
    _speed = speed;
    speeds.add(speed);
  }

  @override
  Future<double> position() async => truePosition;

  @override
  bool get isCompleted {
    final d = duration;
    return d != null && truePosition >= d;
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    _playing = false;
  }
}
