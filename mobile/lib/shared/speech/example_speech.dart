// İngilizce örneklerin cihazda seslendirilmesi (H-064 ek; `docs/DILBILGISI.md`
// §7). Uygulama yalnızca bu arayüzü bilir; eklenti (flutter_tts) adaptörün
// arkasındadır ([DeviceExampleSpeech]).
//
// Bağlayıcı kurallar:
// - yalnızca telefonun kendi ses motoru (iOS AVSpeechSynthesizer; Android
//   TextToSpeech, yalnız cihazda kurulu ve ağ istemeyen ses); ağ sesi
//   seçilmez, bulut hizmeti yok;
// - kayıt yok, dosya yazılmaz; yalnız ekrandaki İngilizce örnek okunur;
// - önceden üretilmiş ses dosyası (ElevenLabs) varsa o çalar; bu yalnız
//   dosya yokken (ya da açılamazken) devreye girer.

/// Cihazdaki İngilizce sesle örnek okuma.
abstract interface class ExampleSpeech {
  /// Cihazda uygun İngilizce ses var mı (ağ kullanmaz, sormaz). Hata → false.
  Future<bool> available();

  /// [text]'i okumaya başlar; önceki okuma durur. [speed] göreli hızdır
  /// (1 = normal, 0,85 = biraz yavaş). [onWord]: okunan kelimenin metindeki
  /// karakter aralığı (motor bildirirse). [onDone]: okuma bitti, durduruldu
  /// ya da hata verdi (bir kez).
  Future<void> speak(
    String text, {
    double speed = 1,
    void Function(int start, int end)? onWord,
    void Function()? onDone,
  });

  /// Okumayı durdurur (okuma yoksa bir şey yapmaz).
  Future<void> stop();
}

/// Hiçbir şey okumayan ses (cihaz desteklemiyorsa ve varsayılan testlerde):
/// düğme görünmez.
class NoExampleSpeech implements ExampleSpeech {
  const NoExampleSpeech();

  @override
  Future<bool> available() async => false;

  @override
  Future<void> speak(
    String text, {
    double speed = 1,
    void Function(int start, int end)? onWord,
    void Function()? onDone,
  }) async => onDone?.call();

  @override
  Future<void> stop() async {}
}

/// Ses motorunun bildirdiği ses (eklentinin `getVoices` haritası).
class DeviceVoice {
  const DeviceVoice({
    required this.name,
    required this.locale,
    this.identifier,
    this.quality,
    this.networkRequired = false,
    this.notInstalled = false,
  });

  /// flutter_tts haritasından: iOS `name`, `locale`, `identifier`,
  /// `quality`; Android `name`, `locale`, `quality`, `network_required`
  /// ("1"/"0"), `features` (sekmeyle ayrılmış; `notInstalled` olabilir).
  static DeviceVoice? fromMap(Object? raw) {
    if (raw is! Map) return null;
    final name = raw['name'];
    final locale = raw['locale'];
    if (name is! String || locale is! String) return null;
    final features = raw['features'];
    return DeviceVoice(
      name: name,
      locale: locale,
      identifier: raw['identifier'] as String?,
      quality: raw['quality']?.toString(),
      networkRequired: '${raw['network_required']}' == '1',
      notInstalled:
          features is String && features.split('\t').contains('notInstalled'),
    );
  }

  final String name;
  final String locale;
  final String? identifier;
  final String? quality;
  final bool networkRequired;
  final bool notInstalled;

  /// `en-GB`, `en_GB` → `en-gb`.
  String get normalizedLocale => locale.replaceAll('_', '-').toLowerCase();

  Map<String, String> toMap() => {
    'name': name,
    'locale': locale,
    'identifier': ?identifier,
  };
}

/// Örnekler için ses seçimi: önce en-GB, yoksa en-US. Ağ isteyen ya da
/// cihazda kurulu olmayan ses (Android) ve Apple'ın eğlence/eski sesleri
/// (`speech.synthesis.voice.*`, `eloquence`) seçilmez. Aynı dilde daha
/// kaliteli ses önce gelir. Uygun ses yoksa null (düğme görünmez).
DeviceVoice? pickEnglishVoice(Iterable<DeviceVoice> voices) {
  const locales = ['en-gb', 'en-us'];
  int qualityRank(String? q) => switch (q?.toLowerCase()) {
    'premium' => 0,
    'enhanced' => 1,
    'very high' || 'very_high' => 1,
    'high' => 2,
    _ => 3,
  };
  bool usable(DeviceVoice v) {
    if (v.networkRequired || v.notInstalled) return false;
    final id = (v.identifier ?? '').toLowerCase();
    if (id.contains('speech.synthesis.voice') || id.contains('eloquence')) {
      return false;
    }
    return locales.contains(v.normalizedLocale);
  }

  final candidates = voices.where(usable).toList()
    ..sort((a, b) {
      final l = locales
          .indexOf(a.normalizedLocale)
          .compareTo(locales.indexOf(b.normalizedLocale));
      if (l != 0) return l;
      final q = qualityRank(a.quality).compareTo(qualityRank(b.quality));
      if (q != 0) return q;
      return a.name.compareTo(b.name);
    });
  return candidates.firstOrNull;
}

/// Seviyeye göre okuma hızı: A1–A2 biraz yavaş (0,85), üstü normal.
double exampleSpeechSpeed(String level) =>
    level == 'A1' || level == 'A2' ? 0.85 : 1;

/// [text]'teki boşlukla ayrılmış kelimelerden [offset]'i içereni (sıra).
/// Ekrandaki kelime sırasıyla aynıdır (`GrammarExample.tokens`).
int? wordIndexAt(String text, int offset) {
  var i = 0;
  for (final m in RegExp(r'\S+').allMatches(text)) {
    if (offset < m.end) return i;
    i++;
  }
  return i == 0 ? null : i - 1;
}
