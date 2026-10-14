import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'example_speech.dart';

/// [ExampleSpeech]'in telefonun ses motoruyla adaptörü (flutter_tts 4.x,
/// MIT). iOS'ta AVSpeechSynthesizer (cihazda); Android'de sistemin
/// TextToSpeech motoru, yalnız cihazda kurulu ve ağ istemeyen İngilizce ses
/// seçilir ([pickEnglishVoice]). Ağa çıkmaz, kayıt yapmaz, dosya yazmaz.
class DeviceExampleSpeech implements ExampleSpeech {
  DeviceExampleSpeech();

  FlutterTts? _tts;
  Future<bool>? _ready;
  int _gen = 0;
  void Function(int, int)? _onWord;
  void Function()? _onDone;
  bool _speaking = false;

  FlutterTts get _engine => _tts ??= FlutterTts();

  @override
  Future<bool> available() => _ready ??= _prepare();

  Future<bool> _prepare() async {
    try {
      final raw = await _engine.getVoices;
      final voices = [
        if (raw is List)
          for (final v in raw) ?DeviceVoice.fromMap(v),
      ];
      final voice = pickEnglishVoice(voices);
      if (voice == null) {
        debugPrint('[H064] cihazda uygun İngilizce ses yok');
        return false;
      }
      await _engine.setVoice(voice.toMap());
      await _engine.setPitch(1);
      await _engine.setVolume(1);
      _engine
        ..setProgressHandler((_, start, end, _) => _onWord?.call(start, end))
        ..setCompletionHandler(_finish)
        ..setErrorHandler((_) => _finish());
      debugPrint('[H064] cihaz sesi: ${voice.name} (${voice.locale})');
      return true;
    } on Object catch (e) {
      debugPrint('[H064] cihaz sesi hazırlanamadı: $e');
      return false;
    }
  }

  void _finish() {
    _speaking = false;
    final done = _onDone;
    _onDone = null;
    _onWord = null;
    done?.call();
  }

  @override
  Future<void> speak(
    String text, {
    double speed = 1,
    void Function(int start, int end)? onWord,
    void Function()? onDone,
  }) async {
    await stop();
    if (!await available()) {
      onDone?.call();
      return;
    }
    final gen = ++_gen;
    try {
      if (!kIsWeb && Platform.isIOS) {
        // "Söyle" dinlemesi oturumu kayda alabilir; örnek hoparlörden çıksın.
        await _engine.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          const [],
          IosTextToSpeechAudioMode.spokenAudio,
        );
      }
      // flutter_tts: 0,5 iki platformda da normal hız (Android'de ×2).
      await _engine.setSpeechRate((0.5 * speed).clamp(0.1, 1.0));
      if (gen != _gen) return;
      _onWord = onWord;
      _onDone = onDone;
      _speaking = true;
      await _engine.speak(text);
    } on Object catch (e) {
      debugPrint('[H064] cihaz sesi okuyamadı: $e');
      if (gen == _gen) _finish();
    }
  }

  @override
  Future<void> stop() async {
    _gen++;
    final active = _speaking;
    _finish();
    if (!active || _tts == null) return;
    try {
      await _engine.stop();
    } on Object catch (e) {
      debugPrint('[H064] cihaz sesi durdurulamadı: $e');
    }
  }
}
