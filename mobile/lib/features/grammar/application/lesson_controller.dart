import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../shared/meaning/meaning_controller.dart';
import '../../../shared/meaning/meaning_text.dart';
import '../../../shared/speech/example_speech.dart';
import '../../library/application/book_audio.dart';
import '../domain/grammar_lesson.dart';

/// Çalan ses parçası: Türkçe anlatım (kartın) ya da İngilizce örnek / "Söyle"
/// cümlesi.
enum LessonClipKind { narration, example }

/// Dersin kart sırası ve ses eşlemesi (H-078).
///
/// Her ses parçası ayrı dosyadır (`audio/c02-tr.m4a`, `audio/c03-ex1.m4a`).
/// Çalarken her [tickInterval]'da (50 ms) konum tahmin edilir: son örnek +
/// geçen süre ([clock], sn). Her [sampleEvery] adımda çalardan taze örnek
/// alınır (kitap okuyucusuyla aynı yöntem, H-067). Okunan Türkçe kelime ve
/// İngilizce örnekte okunan kelime vurgulanır.
///
/// **Sessiz mod** ([silent]): hiçbir ses çalmaz; ders tam okunur. Kartın
/// sesi yoksa (ses henüz üretilmedi) o kart da sessiz okunur.
///
/// **Cihaz sesi** ([speech], H-064): İngilizce örneğin önceden üretilmiş ses
/// dosyası yoksa (ya da açılamazsa) örnek telefonun kendi İngilizce sesiyle
/// okunur; dosya varsa her zaman dosya çalar. Cihazda uygun ses yoksa düğme
/// görünmez. Aynı anda tek ses: örnek başlayınca anlatım durur.
class LessonController extends ChangeNotifier {
  LessonController({
    required this.lesson,
    required BookAudio audio,
    required this.mediaUri,
    ExampleSpeech speech = const NoExampleSpeech(),
    this.onCard,
    double Function()? clock,
    bool silent = false,
    int startCard = 0,
    this.tickInterval = const Duration(milliseconds: 50),
    this.sampleEvery = 4,
  }) : _audio = audio,
       _speech = speech,
       _clock = clock ?? _stopwatchClock(),
       _silent = silent,
       _index = startCard.clamp(0, lesson.cards.length - 1);

  static double Function() _stopwatchClock() {
    final sw = Stopwatch()..start();
    return () => sw.elapsedMicroseconds / 1e6;
  }

  final GrammarLesson lesson;
  final Uri Function(String path) mediaUri;

  /// Kart değişti (ilerleme kaydı).
  final void Function(GrammarCard card, int index)? onCard;
  final Duration tickInterval;
  final int sampleEvery;

  final BookAudio _audio;
  final ExampleSpeech _speech;
  final double Function() _clock;

  bool _silent;
  int _index;
  bool _disposed = false;
  bool _audioFailed = false;
  bool _deviceVoice = false;

  /// Çalan parça cihaz sesiyle mi okunuyor.
  bool _viaDevice = false;

  // Çalan parça.
  LessonClipKind? _clip;
  String? _clipId;
  Narration? _narration;
  List<TimedWord> _clipWords = const [];
  double _endAt = 0;
  bool _playing = false;

  // Vurgu.
  (int, int?)? _narrationPlace;
  int? _exampleWord;

  double _sample = 0;
  double _sampleAt = 0;
  double _speed = 1;
  int _ticks = 0;
  int _gen = 0;
  Timer? _timer;

  // ------------------------------------------------------------ durum

  int get index => _index;
  GrammarCard get card => lesson.cards[_index];
  int get cardCount => lesson.cards.length;
  bool get isFirst => _index == 0;
  bool get isLast => _index == lesson.cards.length - 1;

  bool get silent => _silent;

  /// Ses açılamadı (bir kez not gösterilir, ders sessiz sürer).
  bool get audioFailed => _audioFailed;

  bool get isPlaying => _playing;
  LessonClipKind? get clipKind => _playing ? _clip : null;

  /// Çalan parçanın kimliği (anlatımda kart, örnekte örnek kimliği).
  String? get playingId => _playing ? _clipId : null;

  /// Anlatımda okunan yer: (cümle, kelime). Yalnız anlatım çalarken.
  (int, int?)? get narrationPlace =>
      _playing && _clip == LessonClipKind.narration ? _narrationPlace : null;

  /// Örnekte okunan kelime (çalan örnek [playingId]).
  int? get exampleWord =>
      _playing && _clip == LessonClipKind.example ? _exampleWord : null;

  /// Bu kartın anlatımı sesli dinlenebilir mi.
  bool get canPlayNarration =>
      !_silent && !_audioFailed && (card.narration?.hasAudio ?? false);

  /// Cihazda örnekleri okuyacak İngilizce ses var.
  bool get hasDeviceVoice => _deviceVoice;

  /// Önceden üretilmiş ses dosyası çalınabilir mi.
  bool _fileOk(String? audio) => !_audioFailed && audio != null;

  /// Örnek dinlenebilir mi: dosyası var ya da cihaz sesi var (düğme görünür).
  bool canPlay(String? audio) => !_silent && (_fileOk(audio) || _deviceVoice);

  /// Örnek bu kez cihaz sesiyle mi okunur (dosya yok ya da açılamadı).
  bool usesDeviceVoice(String? audio) => !_fileOk(audio) && _deviceVoice;

  double get _now => _sample + (_clock() - _sampleAt) * _speed;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  // ------------------------------------------------------------ kartlar

  /// Kartı açar: önceki ses durur, anlatım (varsa ve sessiz değilse) başlar.
  Future<void> goTo(int index, {bool autoplay = true}) async {
    final i = index.clamp(0, lesson.cards.length - 1);
    if (i == _index) return;
    await stop();
    _index = i;
    onCard?.call(card, _index);
    _notify();
    if (autoplay) await playNarration();
  }

  Future<void> next() => goTo(_index + 1);

  Future<void> previous() => goTo(_index - 1);

  /// İlk kart açılınca (ekran hazır): kayıt ve anlatım.
  Future<void> start() async {
    onCard?.call(card, _index);
    unawaited(checkDeviceVoice());
    await playNarration();
  }

  /// Cihaz sesinin varlığına bakar (bir kez; hata → yok).
  Future<void> checkDeviceVoice() async {
    bool ok;
    try {
      ok = await _speech.available();
    } on Object {
      ok = false;
    }
    if (_disposed || ok == _deviceVoice) return;
    _deviceVoice = ok;
    _notify();
  }

  Future<void> setSilent(bool on) async {
    if (on == _silent) return;
    _silent = on;
    if (on) await stop();
    _notify();
  }

  // ------------------------------------------------------------ ses

  /// Kartın Türkçe anlatımı (baştan).
  Future<void> playNarration() async {
    final n = card.narration;
    if (n == null || !canPlayNarration) return;
    _narration = n;
    final words = [for (final s in n.sentences) ...s.words];
    final last = words.lastWhere((w) => w.end != null, orElse: () => _none);
    await _play(
      kind: LessonClipKind.narration,
      id: card.id,
      path: n.audio!,
      from: 0,
      endAt: n.duration ?? (last.end ?? 0) + 0.3,
      words: words,
    );
  }

  /// İngilizce örnek ya da "Söyle" cümlesi: dosyası varsa dosya, yoksa
  /// (ya da açılamazsa) cihaz sesi [text]'i okur.
  Future<void> playExample({
    required String id,
    required String text,
    required String? audio,
    required List<TimedWord> words,
    double? start,
    double? end,
    double? duration,
    double speed = 1,
  }) async {
    if (!canPlay(audio)) return;
    if (_fileOk(audio)) {
      final last = words.lastWhere((w) => w.end != null, orElse: () => _none);
      final ok = await _play(
        kind: LessonClipKind.example,
        id: id,
        path: audio!,
        from: 0,
        endAt: duration ?? (end ?? last.end ?? 0) + 0.3,
        words: words,
        speed: speed,
      );
      if (ok || !_deviceVoice) return;
    }
    await _speakDevice(id: id, text: text, speed: speed);
  }

  /// Örnekte tek kelime ([start]–[end] aralığı; anlam paneli).
  Future<void> playExampleRange(
    GrammarExample e, {
    required double start,
    required double end,
    double speed = 1,
  }) async {
    if (_silent || !_fileOk(e.audio)) return;
    await _play(
      kind: LessonClipKind.example,
      id: e.id,
      path: e.audio!,
      from: start,
      endAt: end,
      words: e.words,
      speed: speed,
    );
  }

  /// Anlam panelinin sesi: örneğin kendi sesi (kelime ve cümle).
  MeaningAudio meaningAudio(GrammarExample e) => _ExampleMeaningAudio(this, e);

  Future<void> toggleNarration() =>
      _playing && _clip == LessonClipKind.narration ? stop() : playNarration();

  static const _none = TimedWord('');

  /// Cihaz sesiyle okur; okunan kelime vurgulanır (motor bildirirse).
  Future<void> _speakDevice({
    required String id,
    required String text,
    required double speed,
  }) async {
    if (_silent || !_deviceVoice || text.trim().isEmpty) return;
    await stop();
    final gen = ++_gen;
    _clip = LessonClipKind.example;
    _clipId = id;
    _clipWords = const [];
    _narrationPlace = null;
    _exampleWord = null;
    _viaDevice = true;
    _playing = true;
    _notify();
    try {
      await _speech.speak(
        text,
        speed: exampleSpeechSpeed(lesson.level) * speed,
        onWord: (start, _) {
          if (gen != _gen || !_playing) return;
          final w = wordIndexAt(text, start);
          if (w == _exampleWord) return;
          _exampleWord = w;
          _notify();
        },
        onDone: () {
          if (gen == _gen) unawaited(stop());
        },
      );
    } on Object catch (e) {
      debugPrint('[H064] cihaz sesi okuyamadı: $e');
      if (gen == _gen) await stop();
    }
  }

  /// Dosya açıldıysa true.
  Future<bool> _play({
    required LessonClipKind kind,
    required String id,
    required String path,
    required double from,
    required double endAt,
    required List<TimedWord> words,
    double speed = 1,
  }) async {
    await stop();
    final gen = ++_gen;
    try {
      await _audio.open(mediaUri(path));
      if (gen != _gen || _disposed) return true;
      if (speed != _speed) await _audio.setSpeed(speed);
      _speed = speed;
      await _audio.seek(from);
    } on Object catch (e) {
      debugPrint('[H078] ders sesi açılamadı: $path ($e)');
      _audioFailed = true;
      _playing = false;
      _notify();
      return false;
    }
    if (gen != _gen || _disposed) return true;
    _clip = kind;
    _clipId = id;
    _clipWords = words;
    _endAt = endAt;
    _sample = from;
    _sampleAt = _clock();
    _narrationPlace = null;
    _exampleWord = null;
    _playing = true;
    _timer ??= Timer.periodic(tickInterval, (_) => tick());
    _viaDevice = false;
    _notify();
    await _audio.play();
    return true;
  }

  /// Ses durur, vurgu kalkar.
  Future<void> stop() async {
    _gen++;
    _timer?.cancel();
    _timer = null;
    final was = _playing;
    final device = _viaDevice;
    _playing = false;
    _viaDevice = false;
    _narrationPlace = null;
    _exampleWord = null;
    if (was) {
      _notify();
      try {
        if (device) {
          await _speech.stop();
        } else {
          await _audio.pause();
        }
      } on Object catch (e) {
        debugPrint('[H078] ses durdurulamadı: $e');
      }
    }
  }

  @visibleForTesting
  void tick() {
    if (!_playing || _disposed || _viaDevice) return;
    _ticks++;
    if (_ticks % sampleEvery == 0) unawaited(_takeSample());
    final t = _now;
    if (_audio.isCompleted || t >= _endAt) {
      unawaited(stop());
      return;
    }
    var changed = false;
    if (_clip == LessonClipKind.narration) {
      final p = _narration?.placeAt(t);
      if (p != _narrationPlace) {
        _narrationPlace = p;
        changed = true;
      }
    } else {
      int? w;
      for (var i = 0; i < _clipWords.length; i++) {
        final s = _clipWords[i].start;
        if (s == null || t < s) break;
        w = i;
      }
      if (w != _exampleWord) {
        _exampleWord = w;
        changed = true;
      }
    }
    if (changed) _notify();
  }

  Future<void> _takeSample() async {
    final gen = _gen;
    try {
      final p = await _audio.position();
      if (!_playing || _disposed || gen != _gen) return;
      _sample = p;
      _sampleAt = _clock();
    } on Object catch (e) {
      debugPrint('[H078] konum okunamadı: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    if (_playing && _viaDevice) unawaited(_speech.stop());
    unawaited(_audio.dispose());
    super.dispose();
  }
}

class _ExampleMeaningAudio implements MeaningAudio {
  _ExampleMeaningAudio(this._c, this._e);

  final LessonController _c;
  final GrammarExample _e;

  // Kelime kelime dinleme yalnız dosyanın zaman damgalarıyla (cihaz sesinde
  // panelde yalnız cümle okunur; kelime zamanı yok).
  @override
  bool get canPlayWords =>
      _c.canPlay(_e.audio) &&
      !_c.usesDeviceVoice(_e.audio) &&
      _e.words.any((w) => w.hasTiming);

  @override
  bool get canPlaySentence => _c.canPlay(_e.audio);

  @override
  Future<void> playWord(MeaningWord word, {required double speed}) async {
    if (!word.hasTiming) return;
    await _c.playExampleRange(
      _e,
      start: word.start!,
      end: word.end!,
      speed: speed,
    );
  }

  @override
  Future<void> playSentence({required double speed}) => _c.playExample(
    id: _e.id,
    text: _e.en,
    audio: _e.audio,
    words: _e.words,
    start: _e.start,
    end: _e.end,
    duration: _e.duration,
    speed: speed,
  );

  @override
  Future<void> stop() => _c.stop();
}
