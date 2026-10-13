import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'speech_recognizer_port.dart';

/// `speech_to_text` (BSD-3) üzerinde yalnızca cihazda tanıma (H-055).
///
/// Bulut tanımaya düşmemek için destek eklentiden önce **uygulamanın kendi
/// kanalıyla** sorulur (`tr.velzon.hivelzon/speech`):
/// - iOS: `SFSpeechRecognizer(en-US | en-GB).supportsOnDeviceRecognition`;
///   dinlemede eklenti `requiresOnDeviceRecognition = true` kurar.
/// - Android: API 31+ ve `SpeechRecognizer.isOnDeviceRecognitionAvailable`.
///   Eklenti bu durumda `createOnDeviceSpeechRecognizer` kullanır; desteklenmeyen
///   cihazda (eklenti normal tanıyıcıya düşerdi) özellik hiç açılmaz.
///
/// Ses dosyası yazılmaz; yazı yalnızca dönüş değeri olarak bellekte kalır ve
/// loglara yazılmaz.
class OnDeviceSpeechRecognizer implements SpeechRecognizerPort {
  OnDeviceSpeechRecognizer({SpeechToText? plugin, MethodChannel? channel})
    : _plugin = plugin ?? SpeechToText(),
      _channel = channel ?? const MethodChannel(channelName);

  static const channelName = 'tr.velzon.hivelzon/speech';

  final SpeechToText _plugin;
  final MethodChannel _channel;
  String? _locale;
  bool _initialized = false;
  Completer<SpeechHeard>? _pending;
  List<String> _last = const [];

  @override
  Future<SpeechSupport> support() async {
    try {
      final r = await _channel.invokeMapMethod<String, Object?>(
        'onDeviceSupport',
      );
      final ok = r?['supported'] == true && r?['locale'] is String;
      _locale = ok ? r!['locale'] as String : null;
      return ok ? SpeechSupport.onDevice : SpeechSupport.unsupported;
    } on Object catch (e) {
      debugPrint('[H055] cihazda tanıma desteği okunamadı: $e');
      return SpeechSupport.unsupported;
    }
  }

  @override
  Future<SpeechPermission> permission() async {
    try {
      final s = await _channel.invokeMethod<String>('permissionStatus');
      return switch (s) {
        'granted' => SpeechPermission.granted,
        'denied' => SpeechPermission.denied,
        _ => SpeechPermission.notAsked,
      };
    } on Object catch (e) {
      debugPrint('[H055] izin durumu okunamadı: $e');
      return SpeechPermission.denied;
    }
  }

  @override
  Future<bool> requestPermission() => _init();

  Future<bool> _init() async {
    if (_initialized) return true;
    try {
      _initialized = await _plugin.initialize(
        onError: _onError,
        onStatus: _onStatus,
      );
    } on Object catch (e) {
      debugPrint('[H055] tanıma başlatılamadı: $e');
      _initialized = false;
    }
    return _initialized;
  }

  @override
  Future<SpeechHeard> listenOnce({
    Duration maxDuration = const Duration(seconds: 8),
    void Function()? onSoundStart,
    String? debugExpected,
  }) async {
    if (_pending != null) await cancel();
    if (_locale == null && await support() != SpeechSupport.onDevice) {
      return SpeechHeard.silence;
    }
    if (!await _init()) return SpeechHeard.silence;
    final done = Completer<SpeechHeard>();
    _pending = done;
    _last = const [];
    var soundSeen = false;
    try {
      await _plugin.listen(
        onResult: (SpeechRecognitionResult r) {
          _last = [
            for (final a in r.alternates)
              if (a.recognizedWords.trim().isNotEmpty) a.recognizedWords,
          ];
          if (!soundSeen && _last.isNotEmpty) {
            soundSeen = true;
            onSoundStart?.call();
          }
          if (r.finalResult) _complete(SpeechHeard(_last));
        },
        listenOptions: SpeechListenOptions(
          onDevice: true,
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.confirmation,
          listenFor: maxDuration,
          pauseFor: const Duration(seconds: 2),
          localeId: _locale,
        ),
      );
    } on Object catch (e) {
      debugPrint('[H055] dinleme başlatılamadı: $e');
      _complete(SpeechHeard.silence);
    }
    return done.future.timeout(
      maxDuration + const Duration(seconds: 3),
      onTimeout: () {
        unawaited(_plugin.stop());
        return SpeechHeard(_last);
      },
    );
  }

  void _complete(SpeechHeard heard) {
    final p = _pending;
    _pending = null;
    if (p != null && !p.isCompleted) p.complete(heard);
  }

  void _onStatus(String status) {
    // `done`: oturum bitti; son kısmi sonuç kullanılır.
    if (status == SpeechToText.doneStatus) _complete(SpeechHeard(_last));
  }

  void _onError(SpeechRecognitionError e) {
    // Yazı içermez; yalnızca hata kodu.
    debugPrint('[H055] tanıma hatası: ${e.errorMsg} kalıcı=${e.permanent}');
    if (e.permanent) _complete(SpeechHeard(_last));
  }

  @override
  Future<void> stop() async {
    try {
      await _plugin.stop();
    } on Object catch (_) {}
  }

  @override
  Future<void> cancel() async {
    try {
      await _plugin.cancel();
    } on Object catch (_) {}
    _last = const [];
    _complete(SpeechHeard.silence);
  }
}
