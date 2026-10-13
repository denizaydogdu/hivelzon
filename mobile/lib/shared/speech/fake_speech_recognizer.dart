import 'dart:async';

import 'speech_recognizer_port.dart';

/// Sahte tanıyıcı (H-055): testler ve yalnızca debug derlemede
/// `--dart-define=HV_FAKE_SPEECH=<senaryo>` ile ekran görüntüsü. Mikrofon
/// açmaz, ses işlemez.
///
/// Senaryo virgülle ayrılmış adımlardır; her dinleme sıradakini kullanır,
/// liste bitince başa döner:
/// - `full`: beklenen ifadeyi aynen "duyar";
/// - `close`: beklenen ifadenin son uzun kelimesini atlar;
/// - `no`: alakasız bir şey duyar; `silence`: hiçbir şey duymaz;
/// - başka her metin: o metni duyar.
///
/// Özel ilk adımlar: `unsupported` (cihaz desteklemiyor), `denied` (izin
/// reddedilmiş), `ask` (izin henüz sorulmamış; sorulunca verilir).
class FakeSpeechRecognizer implements SpeechRecognizerPort {
  FakeSpeechRecognizer({
    this.supported = true,
    SpeechPermission permission = SpeechPermission.granted,
    this.grantOnRequest = true,
    List<String> script = const ['full'],
  }) : _permission = permission,
       _script = script.isEmpty ? const ['full'] : script;

  /// `HV_FAKE_SPEECH` değerinden.
  factory FakeSpeechRecognizer.fromScenario(String scenario) {
    final parts = [
      for (final p in scenario.split(','))
        if (p.trim().isNotEmpty) p.trim(),
    ];
    var supported = true;
    var permission = SpeechPermission.granted;
    final script = <String>[];
    for (final p in parts) {
      switch (p) {
        case 'unsupported':
          supported = false;
        case 'denied':
          permission = SpeechPermission.denied;
        case 'ask':
          permission = SpeechPermission.notAsked;
        default:
          script.add(p);
      }
    }
    return FakeSpeechRecognizer(
      supported: supported,
      permission: permission,
      script: script,
    );
  }

  final bool supported;
  final bool grantOnRequest;
  final List<String> _script;
  SpeechPermission _permission;
  int _step = 0;

  /// Testler: kaç kez dinlendi, izin kaç kez soruldu.
  int listens = 0;
  int permissionRequests = 0;

  /// Bir sonraki dinlemenin sonucunu doğrudan verir (senaryodan önce gelir).
  final List<List<String>> queued = [];

  @override
  Future<SpeechSupport> support() async =>
      supported ? SpeechSupport.onDevice : SpeechSupport.unsupported;

  @override
  Future<SpeechPermission> permission() async => _permission;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    if (_permission == SpeechPermission.notAsked) {
      _permission = grantOnRequest
          ? SpeechPermission.granted
          : SpeechPermission.denied;
    }
    return _permission == SpeechPermission.granted;
  }

  @override
  Future<SpeechHeard> listenOnce({
    Duration maxDuration = const Duration(seconds: 8),
    void Function()? onSoundStart,
    String? debugExpected,
  }) async {
    listens++;
    if (!supported || _permission != SpeechPermission.granted) {
      return SpeechHeard.silence;
    }
    if (queued.isNotEmpty) {
      onSoundStart?.call();
      return SpeechHeard(queued.removeAt(0));
    }
    final step = _script[_step % _script.length];
    _step++;
    final heard = switch (step) {
      'full' => debugExpected ?? '',
      'close' => _dropOne(debugExpected ?? ''),
      'no' => 'banana tree',
      'silence' => '',
      _ => step,
    };
    if (heard.isNotEmpty) onSoundStart?.call();
    return heard.isEmpty ? SpeechHeard.silence : SpeechHeard([heard]);
  }

  static String _dropOne(String s) {
    final words = s.replaceAll('…', ' ').split(RegExp(r'\s+'))
      ..removeWhere((w) => w.isEmpty);
    for (var i = words.length - 1; i >= 0; i--) {
      if (words[i].replaceAll(RegExp(r'[^A-Za-z]'), '').length >= 3) {
        words.removeAt(i);
        break;
      }
    }
    return words.join(' ');
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> cancel() async {}
}
