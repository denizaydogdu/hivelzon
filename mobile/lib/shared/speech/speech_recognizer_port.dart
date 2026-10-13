// Cihazda konuşma tanıma bağlantı noktası (H-055). Uygulama yalnızca bu
// arayüzü bilir; eklenti (speech_to_text) adaptörün arkasındadır.
//
// Bağlayıcı kurallar (`docs/KONUSMA-ALISTIRMASI.md`):
// - yalnızca cihazda tanıma; bulut tanımaya düşülmez, hiçbir koşulda;
// - ses dosyası yazılmaz; yazı yalnızca bellekte, karşılaştırma için tutulur.

/// Cihazın İngilizce tanıma desteği (izin sormadan bakılır).
enum SpeechSupport {
  /// Cihazda İngilizce tanıma var.
  onDevice,

  /// Yok (eski cihaz, dil paketi yok, simülatör vb.): özellik görünmez.
  unsupported,
}

/// Mikrofon + konuşma tanıma izni.
enum SpeechPermission {
  granted,

  /// Henüz sorulmadı: ilk kullanımda önce Türkçe açıklama, sonra sistem sorusu.
  notAsked,

  /// Reddedildi ya da kısıtlı: özellik görünmez.
  denied,
}

/// Tek dinlemenin sonucu.
class SpeechHeard {
  const SpeechHeard(this.alternatives);

  static const silence = SpeechHeard([]);

  /// Motorun yazı alternatifleri, en olası başta. Yalnızca bellekte tutulur.
  final List<String> alternatives;

  bool get isEmpty => alternatives.every((a) => a.trim().isEmpty);
}

abstract interface class SpeechRecognizerPort {
  /// Cihazda İngilizce tanıma var mı (izin sormaz, ağ kullanmaz).
  Future<SpeechSupport> support();

  /// İzin durumu (sormaz).
  Future<SpeechPermission> permission();

  /// Sistem izin sorularını açar (mikrofon + konuşma tanıma). Sonuç: izin var mı.
  Future<bool> requestPermission();

  /// Bir kez dinler; kullanıcı susunca ya da [maxDuration] dolunca biter.
  /// [onPartial]: ekranda "dinliyorum" durumu için (yazı gösterilmez).
  /// Hata ya da sessizlikte [SpeechHeard.silence] döner (istisna atmaz).
  ///
  /// [debugExpected]: yalnızca sahte tanıyıcı (testler ve `HV_FAKE_SPEECH`
  /// ile ekran görüntüsü) kullanır; gerçek adaptör yok sayar.
  Future<SpeechHeard> listenOnce({
    Duration maxDuration = const Duration(seconds: 8),
    void Function()? onSoundStart,
    String? debugExpected,
  });

  /// Dinlemeyi erken bitirir (sonuç [listenOnce]'tan döner).
  Future<void> stop();

  /// Dinlemeyi iptal eder (sonuç boş döner).
  Future<void> cancel();
}
