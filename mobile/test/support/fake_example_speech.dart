import 'package:hivelzon/shared/speech/example_speech.dart';

/// Sahte cihaz sesi (H-064): okunanları yazar; kelime ve bitiş elle
/// tetiklenir ([word], [finish]).
class FakeExampleSpeech implements ExampleSpeech {
  FakeExampleSpeech({this.hasVoice = true});

  bool hasVoice;

  /// Okunan metinler ve göreli hızları.
  final List<(String, double)> spoken = [];
  int stops = 0;

  void Function(int, int)? _onWord;
  void Function()? _onDone;

  bool get speaking => _onDone != null;

  @override
  Future<bool> available() async => hasVoice;

  @override
  Future<void> speak(
    String text, {
    double speed = 1,
    void Function(int start, int end)? onWord,
    void Function()? onDone,
  }) async {
    await stop();
    spoken.add((text, speed));
    _onWord = onWord;
    _onDone = onDone;
  }

  /// Motor [start]–[end] aralığındaki kelimeyi okuyor.
  void word(int start, int end) => _onWord?.call(start, end);

  /// Okuma kendiliğinden bitti.
  void finish() {
    final d = _onDone;
    _onDone = null;
    _onWord = null;
    d?.call();
  }

  @override
  Future<void> stop() async {
    if (_onDone != null) stops++;
    finish();
  }
}
