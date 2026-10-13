import 'package:flutter/foundation.dart';

import 'speech_match.dart';
import 'speech_recognizer_port.dart';

/// Tek ifade için "Söyle" denemeleri (H-055): en çok [maxAttempts] deneme,
/// sonra metin gösterilir ve devam edilir. Puan yok.
///
/// Tanıma yazısı yalnızca [listen] içinde, karşılaştırma için kullanılır;
/// alanlarda tutulmaz (yalnızca sonuç: düzey, duyulmayan kelimeler, not).
class SpeakController extends ChangeNotifier {
  SpeakController({
    required this.expected,
    required this.recognizer,
    this.maxAttempts = 2,
  });

  final String expected;
  final SpeechRecognizerPort recognizer;
  final int maxAttempts;

  int _attempts = 0;
  bool _listening = false;
  bool _silent = false;
  SpeechMatch? _last;
  SpeechMatch? _best;
  String? _errorNoteId;
  bool _disposed = false;

  int get attempts => _attempts;
  bool get listening => _listening;

  /// Son denemede hiç ses duyulmadı.
  bool get silent => _silent;
  SpeechMatch? get last => _last;

  /// Denemelerin en iyisi (tam > yakın > değil).
  SpeechMatch? get best => _best;
  SpeechMatchLevel? get bestLevel => _best?.level;

  /// Hata kataloğu kimliği (son denemede tanındıysa).
  String? get errorNoteId => _errorNoteId;

  bool get succeeded => _best?.isFull ?? false;

  /// Bitti: tam söylendi ya da denemeler doldu.
  bool get finished => succeeded || _attempts >= maxAttempts;

  /// Denemeler doldu ve tam söylenemedi: metin gösterilir.
  bool get revealed => !succeeded && _attempts >= maxAttempts;

  /// Bir kez dinler ve karşılaştırır; sonuç [last]'ta. Bitmişse ya da zaten
  /// dinliyorsa null.
  Future<SpeechMatch?> listen() async {
    if (_listening || finished || _disposed) return null;
    _listening = true;
    _notify();
    final SpeechHeard heard;
    try {
      heard = await recognizer.listenOnce(debugExpected: expected);
    } finally {
      _listening = false;
    }
    if (_disposed) return null;
    _attempts++;
    _silent = heard.isEmpty;
    final m = _silent
        ? SpeechMatch(
            level: SpeechMatchLevel.no,
            missingWords: [
              for (final w in SpeechMatcher.tokenize(expected))
                if (w != '…') w,
            ],
          )
        : SpeechMatcher.compareAny(expected, heard.alternatives);
    _errorNoteId = (m.isFull || _silent)
        ? null
        : SpeechMatcher.detectErrorNote(expected, heard.alternatives);
    _last = m;
    final b = _best;
    if (b == null || m.level.index < b.level.index) _best = m;
    _notify();
    return m;
  }

  Future<void> stop() => recognizer.stop();

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    if (_listening) recognizer.cancel();
    super.dispose();
  }
}
