import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage_providers.dart';
import 'device_example_speech.dart';
import 'example_speech.dart';
import 'fake_speech_recognizer.dart';
import 'on_device_speech_recognizer.dart';
import 'speech_recognizer_port.dart';
import 'speech_store.dart';

/// Yalnızca debug: `--dart-define=HV_FAKE_SPEECH=<senaryo>` (bkz.
/// [FakeSpeechRecognizer]); sürüm derlemede yok sayılır.
const String kFakeSpeechScenario = String.fromEnvironment('HV_FAKE_SPEECH');

final speechRecognizerProvider = Provider<SpeechRecognizerPort>((ref) {
  if (kDebugMode && kFakeSpeechScenario.isNotEmpty) {
    debugPrint('[H055] sahte tanıyıcı: $kFakeSpeechScenario');
    return FakeSpeechRecognizer.fromScenario(kFakeSpeechScenario);
  }
  return OnDeviceSpeechRecognizer();
});

/// İngilizce örneklerin cihaz sesi (önceden üretilmiş dosya yokken; H-064).
/// Testlerde sahtesi verilir.
final exampleSpeechProvider = Provider<ExampleSpeech>((ref) {
  final speech = DeviceExampleSpeech();
  ref.onDispose(() => speech.stop());
  return speech;
});

final speechStoreProvider = Provider<SpeechStore>(
  (ref) => SpeechStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// "Söyle"nin durumu. Yalnızca [ready] ve [needsPermission] iken arayüz
/// görünür; diğerlerinde her şey dokunarak çalışır (bulut tanıma yok).
enum SpeechStatus {
  /// Cihazda tanıma var, açık, izin verilmiş.
  ready,

  /// Cihazda tanıma var, açık; izin ilk kullanımda (önce Türkçe açıklama).
  needsPermission,

  /// Kullanıcı Profil'den kapattı.
  switchedOff,

  /// İzin reddedildi ya da kısıtlı.
  denied,

  /// Cihazda İngilizce tanıma yok.
  unsupported;

  bool get showsPractice =>
      this == SpeechStatus.ready || this == SpeechStatus.needsPermission;
}

/// Desteği, Profil ayarını ve izni birleştirir. Hata → [SpeechStatus.unsupported]
/// (özellik görünmez; dokunarak her şey çalışır).
Future<SpeechStatus> resolveSpeechStatus(
  SpeechRecognizerPort port,
  SpeechStore Function() store,
) async {
  try {
    if (await port.support() != SpeechSupport.onDevice) {
      return SpeechStatus.unsupported;
    }
    final s = store();
    if (!await s.enabled()) return SpeechStatus.switchedOff;
    return switch (await port.permission()) {
      SpeechPermission.granted => SpeechStatus.ready,
      SpeechPermission.denied => SpeechStatus.denied,
      SpeechPermission.notAsked =>
        await s.permissionAsked()
            ? SpeechStatus.denied
            : SpeechStatus.needsPermission,
    };
  } on Object catch (e) {
    debugPrint('[H055] Söyle durumu okunamadı: $e');
    return SpeechStatus.unsupported;
  }
}

final speechStatusProvider = FutureProvider<SpeechStatus>((ref) async {
  final s = await resolveSpeechStatus(
    ref.watch(speechRecognizerProvider),
    () => ref.read(speechStoreProvider),
  );
  debugPrint('[H055] Söyle durumu: ${s.name}');
  return s;
}, retry: (_, _) => null);

/// Arayüzün tek sorusu: "Söyle" gösterilsin mi? Yüklenirken hayır.
final speechVisibleProvider = Provider<bool>(
  (ref) => ref.watch(speechStatusProvider).value?.showsPractice ?? false,
);
